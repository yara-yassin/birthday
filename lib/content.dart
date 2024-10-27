// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfettiScreen extends StatefulWidget {
  const ConfettiScreen({super.key});

  @override
  _ConfettiScreenState createState() => _ConfettiScreenState();
}

class _ConfettiScreenState extends State<ConfettiScreen> {
  late ConfettiController _confettiController;
  String? userName;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(minutes: 5));
    _confettiController.play(); // Start confetti on screen load
    _userNameLoad();
  }

  @override
  void dispose() {
    _confettiController.dispose();

    super.dispose();
  }

  Future <void> _userNameLoad()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Happy Birthday to\n$userName',
                    style: GoogleFonts.dynaPuff(
                        fontSize: 45,
                        color: Colors.pink.shade300,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Return to BirthdayScreen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 10,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      "Back",
                      style: GoogleFonts.dynaPuff(
                        fontSize: 20,
                        color: Colors.pink.shade300,
                      ),
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
