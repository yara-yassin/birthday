// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'ballon_animated.dart';
import 'content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  late DateTime birthday;
  late Timer _timer;
  Duration timeLeft = Duration.zero; // Initialize timeLeft with a default value
  bool isButtonEnabled = false;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
      birthday = DateTime.parse(prefs.getString('userBirthday')!);

      // Get the current date and time
      DateTime now = DateTime.now();

      // Check if the selected birthday is today
      if (birthday.month == now.month && birthday.day == now.day) {
        timeLeft = Duration.zero; // Set timeLeft to 0 if birthday is today
        isButtonEnabled = true; // Enable the button immediately
        return; // Exit early as we don't need further calculations
      }

      // Set the birthday time to 00:00:00 for the next occurrence
      DateTime nextBirthday = DateTime(now.year, birthday.month, birthday.day);

      // If the birthday has already passed this year, set it to next year
      if (nextBirthday.isBefore(now)) {
        nextBirthday = DateTime(now.year + 1, birthday.month, birthday.day);
      }

      // Calculate the time left for the countdown
      timeLeft = nextBirthday.difference(now);

      // Start the countdown timer
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          // Update the current time and calculate time left again
          now = DateTime.now();
          timeLeft = nextBirthday.difference(now);

          // When the countdown reaches zero, stop the timer and enable the button
          if (timeLeft.isNegative || timeLeft.inSeconds <= 0) {
            timeLeft = Duration.zero; // Set timeLeft to 0
            isButtonEnabled = true; // Enable the button
            _timer.cancel(); // Stop the timer
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BalloonsAnimation(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Countdown to $userName\'s Birthday',
                    style: GoogleFonts.dynaPuff(
                      fontSize: 30,
                      color: Colors.pink.shade300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // Display the remaining time until birthday (including hours, minutes, and seconds)
                  Text(
                    '${timeLeft.inDays} days '
                    '${timeLeft.inHours.remainder(24)} hours '
                    '${timeLeft.inMinutes.remainder(60)} minutes '
                    '${timeLeft.inSeconds.remainder(60)} seconds',
                    style: GoogleFonts.dynaPuff(
                      fontSize: 20,
                      color: Colors.pink.shade300.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isButtonEnabled
                        ? () {
                            // Trigger confetti
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ConfettiScreen()),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Celebrate!',
                      style: GoogleFonts.dynaPuff(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
