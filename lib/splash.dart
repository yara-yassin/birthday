// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'birthday_screen.dart';
import 'introduction_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the correct screen after checking user data
    Timer(const Duration(seconds: 3), _checkFirstTimeUser);
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUserData =
        prefs.containsKey('userName') && prefs.containsKey('userBirthday');

    if (hasUserData) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BirthdayScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroductionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Circular border
                child: Image.asset(
                  "assets/birthdaylogo.jpg",
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to Birthday App! 🎂',
                style: GoogleFonts.dynaPuff(
                  fontSize: 30,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
