// ignore_for_file: use_key_in_widget_constructors

import 'package:evdeai/constants/appcolors.dart';
import 'package:evdeai/db_helper/db_helper.dart';
import 'package:evdeai/presentation/auth/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        title: const Text(
          'HOME PAGE',
          style: TextStyle(color: AppColors.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => markAttendance(context),
          child: const Text('Mark Your Attendance'),
        ),
      ),
    );
  }

  void markAttendance(BuildContext context) async {
    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';
    final time = '${now.hour}:${now.minute}:${now.second}';

    await Db_Helper.insertAttendance(date, time);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Attendance marked for $date at $time')),
    );
  }

  void logout(BuildContext context) {
    // Navigate back to the login page to log out
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
