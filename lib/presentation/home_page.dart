// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:evdeai/constants/appcolors.dart';
import 'package:evdeai/db_helper/db_helper.dart';
import 'package:evdeai/presentation/auth/login.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isAttendanceMarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.appbarColor,
        title: const Text(
          'HOME PAGE',
          style: TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold,),
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
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.buttoncolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 55),
            elevation: 5,
          ),
          onPressed: isAttendanceMarked ? markExit : markAttendance,
          child: Text(
            isAttendanceMarked ? 'Mark Exit' : 'Mark Attendance',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void markAttendance() async {
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
    setState(() {
      isAttendanceMarked = true;
    });
  }

  void markExit() async {
    final now = DateTime.now();
    final exitTime = DateTime(now.year, now.month, now.day, 18, 0);
    final difference = now.difference(exitTime).inMinutes.abs();

    if (difference <= 0) {
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
      setState(() {
        isAttendanceMarked = false;
      });
    }
  }

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
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
