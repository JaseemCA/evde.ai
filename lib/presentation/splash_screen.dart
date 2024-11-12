import 'dart:async';

import 'package:evdeai/constants/appcolors.dart';
import 'package:evdeai/presentation/auth/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;
  @override
  void initState() {
    super.initState();
    _startAnimation();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  void _startAnimation() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 3),
          child: const Text(
            'ATTENDANCE REGISTER ',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.appbarColor),
          ),
        ),
      ),
    );
  }
}
