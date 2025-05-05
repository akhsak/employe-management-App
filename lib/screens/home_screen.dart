import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:king_labs_task/controller/auth_provider.dart';
import 'package:king_labs_task/controller/employee_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/employee_card.dart';
import 'employee_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
    });
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToEmployeeDetail(int employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeDetailScreen(employeeId: employeeId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF009DDC), Color(0xFF005F73)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Employes',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.square_arrow_right,
                            color: Colors.white),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, ${authProvider.user?.email ?? "User"}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // List of Employees
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => employeeProvider.fetchEmployees(),
                child: employeeProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : employeeProvider.employees.isEmpty
                        ? const Center(
                            child: Text(
                              'No employees found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: employeeProvider.employees.length,
                            itemBuilder: (context, index) {
                              final employee =
                                  employeeProvider.employees[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: EmployeeCard(
                                  employee: employee,
                                  onPressed: () =>
                                      _navigateToEmployeeDetail(employee.id),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF005F73),
        onPressed: () => employeeProvider.fetchEmployees(),
        child: const Icon(CupertinoIcons.refresh, color: Colors.white),
      ),
    );
  }
}
