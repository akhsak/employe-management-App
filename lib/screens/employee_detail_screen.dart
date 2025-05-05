import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:king_labs_task/controller/employee_provider.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../widgets/custom_text_field.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({Key? key, required this.employeeId})
      : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false)
          .getEmployeeById(widget.employeeId);
    });
  }

  @override
  @override
  void dispose() {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    employeeProvider.firstNameController.dispose();
    employeeProvider.lastNameController.dispose();
    employeeProvider.phoneController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context, listen: false);
    final employee = employeeProvider.selectedEmployee;
    if (employee != null && !_isEditing) {
      employeeProvider.firstNameController.text = employee.firstName;
      employeeProvider.lastNameController.text = employee.lastName;
      employeeProvider.phoneController.text = employee.phone;
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
          firstName: employeeProvider.firstNameController.text.trim(),
          lastName: employeeProvider.lastNameController.text.trim(),
          email: employee.email,
          phone: employeeProvider.phoneController.text.trim(),
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
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          _toggleEditing();
        } else {
          if (!mounted) return;
          Fluttertoast.showToast(
            msg: employeeProvider.errorMessage ?? 'Failed to update employee',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      }
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF005F73),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDetails(Employee employee) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
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
        ),
      ),
    );
  }

  Widget _buildEditForm(Employee employee) {
    final employeProvider = context.read<EmployeeProvider>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(employee.image),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: employeProvider.firstNameController,
            labelText: 'First Name',
            validator: (value) =>
                value!.isEmpty ? 'Please enter first name' : null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: employeProvider.lastNameController,
            labelText: 'Last Name',
            validator: (value) =>
                value!.isEmpty ? 'Please enter last name' : null,
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: employeProvider.phoneController,
            labelText: 'Phone',
            keyboardType: TextInputType.phone,
            validator: (value) =>
                value!.isEmpty ? 'Please enter phone number' : null,
          ),
          const SizedBox(height: 16),
          _buildDetailItem('Email', employee.email),
          _buildDetailItem('Gender', employee.gender),
          _buildDetailItem('Address', employee.address.fullAddress),
          _buildDetailItem('Company', employee.company.name),
          _buildDetailItem('Position', employee.company.title),
          _buildDetailItem('Department', employee.company.department),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005F73),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final employee = employeeProvider.selectedEmployee;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF005F73),
        title: Text(
          employee?.fullName ?? 'Employee Details',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (employee != null)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: Colors.white,
              ),
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: employeeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : employee == null
              ? const Center(child: Text('Employee not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _isEditing
                      ? _buildEditForm(employee)
                      : _buildEmployeeDetails(employee),
                ),
    );
  }
}
