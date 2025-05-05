import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';
import '../models/user.dart';

class ApiService {
  static const String loginUrl = 'https://reqres.in/api/login';
  static const String employeesUrl = 'https://dummyjson.com/users';

  // Login user with credentials
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': 'reqres-free-v1', //  API key here
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return User(email: email, token: jsonData['token']);
    } else {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error'] ?? 'Failed to login');
    }
  }

  // Fetch all employees
  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(employeesUrl));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final employeesJson = jsonData['users'] as List;
      return employeesJson.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  // Fetch employee by ID
  Future<Employee> getEmployeeById(int id) async {
    final response = await http.get(Uri.parse('$employeesUrl/$id'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Employee.fromJson(jsonData);
    } else {
      throw Exception('Failed to load employee details');
    }
  }

  // Update employee (simulated)
  Future<bool> updateEmployee(Employee employee) async {
    // Simulate a PUT request
    final response = await http.put(
      Uri.parse('$employeesUrl/${employee.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );

    // For testing purposes, we'll consider it successful if status code is between 200-299
    // In a real app, you'd check the specific response
    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
