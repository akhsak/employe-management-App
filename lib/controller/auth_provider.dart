import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _checkAuthentication();
  }

  // Check if user is already authenticated
  _checkAuthentication() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storageService.getAuthToken();
      final email = await _storageService.getUserEmail();

      if (token != null && email != null) {
        _user = User(email: email, token: token);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _apiService.login(email, password);
      _user = user;

      // Save user data
      await _storageService.saveAuthToken(user.token);
      await _storageService.saveUserEmail(user.email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _storageService.clearUserData();
    _user = null;

    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
