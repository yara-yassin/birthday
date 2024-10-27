import 'package:flutter/material.dart';
import 'splash.dart'; // Import SplashScreen

void main() {
  runApp(const BirthdayCountdownApp());
}

class BirthdayCountdownApp extends StatelessWidget {
  const BirthdayCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Birthday Countdown',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}
