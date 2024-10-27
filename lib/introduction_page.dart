// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'birthday_screen.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userBirthday', _selectedDate.toString());

    // Navigate to the birthday screen after saving data
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const BirthdayScreen()),
    );
  }

  Future<void> _pickBirthday() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome! Please Enter Your Name and Birthday',
                style: GoogleFonts.dynaPuff(
                    fontSize: 30, color: Colors.pink.shade300),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _selectedDate == null
                    ? ''
                    : 'Selected Birthday: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                style: GoogleFonts.dynaPuff(
                    fontSize: 20, color: Colors.pink.shade300),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickBirthday,
                child: Text(
                  _selectedDate == null
                      ? 'Select Birthday'
                      : 'Selected Birthday: ${_selectedDate!.toLocal()}'
                          .split(' ')[0],
                  style: GoogleFonts.dynaPuff(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    _nameController.text.isNotEmpty && _selectedDate != null
                        ? _saveUserData
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Save and Continue',
                  style:
                      GoogleFonts.dynaPuff(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
