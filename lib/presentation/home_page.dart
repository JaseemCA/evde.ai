// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:evdeai/constants/appcolors.dart';
import 'package:evdeai/db_helper/db_helper.dart';
import 'package:evdeai/presentation/auth/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        title: const Text(
          'HOME PAGE',
          style: TextStyle(color: AppColors.textColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(
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

    final attendanceTime = DateTime(now.year, now.month, now.day, 9, 0);
    final difference = now.difference(attendanceTime).inMinutes.abs();

    if (difference <= 0) {
      alertMessage(
        context,
        'Good',
        'Attendance marked on time!',
        Colors.green,
      );
    } else if (now.isAfter(attendanceTime)) {
      alertMessage(
        context,
        'Late',
        'You are late for attendance!',
        Colors.red,
      );
    } else {
      alertMessage(
        context,
        'Early',
        'You are early for attendance!',
        Colors.grey,
      );
    }
  }

  void _markExit(BuildContext context) async {
    final now = DateTime.now();
    final exitTime = DateTime(now.year, now.month, now.day, 18, 0);
    final difference = now.difference(exitTime).inMinutes.abs();

    if (difference <= 0) {
      // within 5 minutes of exit time
      alertMessage(
        context,
        'Good',
        'Exit marked on time!',
        Colors.green,
      );
    } else if (now.isAfter(exitTime)) {
      alertMessage(
        context,
        'Late',
        'You are late for exit!',
        Colors.red,
      );
    } else {
      alertMessage(
        context,
        'Early',
        'You are early for exit!',
        Colors.grey,
      );
    }
  }

  // void _markExit(BuildContext context) async {
  //   final now = DateTime.now();
  //   final exitTime = DateTime(now.year, now.month, now.day, 23, 0);
  //   // final date = '${now.year}-${now.month}-${now.day}';
  //   // final time = '${now.hour}:${now.minute}:${now.second}';

  //   // await Db_Helper.updateExitTime(date, time);

  //   if (now.isAtSameMomentAs(exitTime)) {
  //     alertMessage(
  //       context,
  //       'Good',
  //       'Exit marked on time!',
  //       Colors.green,
  //     );
  //   } else if (now.isAfter(exitTime)) {
  //     alertMessage(
  //       context,
  //       'Late',
  //       'You are late for exit!',
  //       Colors.red,
  //     );
  //   } else {
  //     alertMessage(
  //       context,
  //       'Early',
  //       'You are early for exit!',
  //       Colors.grey,
  //     );
  //   }
  // }

  void alertMessage(
      BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: color)),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) {
    // Navigate back to the login page to log out
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
