// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../widgets/custom_text_field.dart';
// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();
//     // Pre-fill with the test credentials
//     _emailController.text = 'eve.holt@reqres.in';
//     _passwordController.text = 'cityslicka';
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
//       final success = await authProvider.login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
      
//       if (success) {
//         // Navigate to home screen
//         if (!mounted) return;
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       } else {
//         // Show error message
//         if (!mounted) return;
//         Fluttertoast.showToast(
//           msg: authProvider.errorMessage ?? 'Login failed',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),
//                 const Icon(
//                   Icons.account_circle,
//                   size: 100,
//                   color: Colors.blue,
//                 ),
//                 const SizedBox(height: 40),
//                 CustomTextField(
//                   controller: _emailController,
//                   labelText: 'Email',
//                   keyboardType: TextInputType.emailAddress,
//                   prefixIcon: Icons.email,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   obscureText: _obscurePassword,
//                   prefixIcon: Icons.lock,
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   onPressed: authProvider.isLoading ? null : _login,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     textStyle: const TextStyle(fontSize: 16),
//                   ),
//                   child: authProvider.isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text('LOGIN'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }