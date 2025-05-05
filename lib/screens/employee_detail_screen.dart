import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:king_labs_task/controller/employee_provider.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../widgets/custom_text_field.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Fetch employee details when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false)
          .getEmployeeById(widget.employeeId);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    final employee =
        Provider.of<EmployeeProvider>(context, listen: false).selectedEmployee;
    if (employee != null && !_isEditing) {
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _phoneController.text = employee.phone;
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final employeeProvider =
          Provider.of<EmployeeProvider>(context, listen: false);
      final employee = employeeProvider.selectedEmployee;

      if (employee != null) {
        final updatedEmployee = Employee(
          id: employee.id,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: employee.email,
          phone: _phoneController.text.trim(),
          image: employee.image,
          gender: employee.gender,
          address: employee.address,
          company: employee.company,
        );

        final success = await employeeProvider.updateEmployee(updatedEmployee);

        if (success) {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: 'Employee updated successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          _toggleEditing();
        } else {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: employeeProvider.errorMessage ?? 'Failed to update employee',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDetails(Employee employee) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(employee.image),
          ),
        ),
        const SizedBox(height: 20),
        _buildDetailItem('Name', employee.fullName),
        _buildDetailItem('Email', employee.email),
        _buildDetailItem('Phone', employee.phone),
        _buildDetailItem('Gender', employee.gender),
        _buildDetailItem('Address', employee.address.fullAddress),
        _buildDetailItem('Company', employee.company.name),
        _buildDetailItem('Position', employee.company.title),
        _buildDetailItem('Department', employee.company.department),
      ],
    );
  }

  Widget _buildEditForm(Employee employee) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(employee.image),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _firstNameController,
            labelText: 'First Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _phoneController,
            labelText: 'Phone',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildDetailItem('Email', employee.email),
          _buildDetailItem('Gender', employee.gender),
          _buildDetailItem('Address', employee.address.fullAddress),
          _buildDetailItem('Company', employee.company.name),
          _buildDetailItem('Position', employee.company.title),
          _buildDetailItem('Department', employee.company.department),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final employee = employeeProvider.selectedEmployee;

    return Scaffold(
      appBar: AppBar(
        title: Text(employee?.fullName ?? 'Employee Details'),
        actions: [
          if (employee != null)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: employeeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : employee == null
              ? const Center(child: Text('Employee not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _isEditing
                      ? _buildEditForm(employee)
                      : _buildEmployeeDetails(employee),
                ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _saveChanges,
              child: const Icon(Icons.save),
            )
          : null,
    );
  }
}
