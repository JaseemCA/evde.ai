import 'dart:developer';
import 'package:evdeai/db_helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:evdeai/presentation/auth/login.dart';
import 'package:evdeai/constants/appcolors.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        title: const Text(
          'REGISTER',
          style: TextStyle(color: AppColors.textColor),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your phone number';
                  if (value.length != 10) return 'Please enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a password' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                   autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => saveToDatabase(context),
                
                child: const Text('Register'),
              

              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveToDatabase(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      String name = nameController.text;
      String password = passwordController.text;
      String phone = phoneController.text;

      // Save data using DBHelper
      Map<String, dynamic> user = {
        'name': name,
        'phone': phone,
        'password': password,
      };
      await Db_Helper.insertUser(user);
      log("Data saved successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful")),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }
}
