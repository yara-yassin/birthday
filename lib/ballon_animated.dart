// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ionicons/ionicons.dart';

class BalloonsAnimation extends StatefulWidget {
  const BalloonsAnimation({super.key});

  @override
  _BalloonsAnimationState createState() => _BalloonsAnimationState();
}

class _BalloonsAnimationState extends State<BalloonsAnimation> {
  late Timer _timer;
  final Random _random = Random();
  late List<double> _balloonYPositions; // Y positions for each balloon
  late List<double> _balloonXPositions; // X positions for each balloon
  final List<double> _balloonXDirections =
      List.generate(20, (_) => 1.0); // Direction for X movement

  // List to track if each balloon's animation has started
  final List<bool> _balloonStarted = List.generate(20, (_) => false);

  @override
  void initState() {
    super.initState();

    // Initialize Y positions (all start at the bottom)
    _balloonYPositions = List.generate(20, (_) => 1.0);

    // Initialize random X positions (random horizontal placement)
    _balloonXPositions = List.generate(20, (_) => _random.nextDouble());

    // Start the animation with a slight delay for each balloon
    for (int i = 0; i < 20; i++) {
      _startBalloonAnimation(i);
    }
  }

  // Function to start each balloon's movement with a staggered delay
  void _startBalloonAnimation(int index) {
    // Generate a random delay for each balloon (between 0 to 3 seconds)
    final delay = _random.nextInt(3000); // Random delay from 0 to 3 seconds

    // Start each balloon's animation after a random delay
    Future.delayed(Duration(milliseconds: delay), () {
      setState(() {
        _balloonStarted[index] = true; // Mark this balloon as started
      });

      // Start the upward movement
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (_balloonStarted[index]) {
            _balloonYPositions[index] -= 0.02; // Upward movement
            _balloonXPositions[index] +=
                _balloonXDirections[index] * 0.002; // Sideways drift

            // Reset the balloon Y position immediately without animation
            if (_balloonYPositions[index] < -0.1) {
              _balloonYPositions[index] = 1.0; // Instantly reset to the bottom
              _balloonXPositions[index] =
                  _random.nextDouble(); // Randomize X position again
            }

            // Reverse X direction when the balloon reaches the screen edges
            if (_balloonXPositions[index] > 1.0 ||
                _balloonXPositions[index] < 0.0) {
              _balloonXDirections[index] =
                  -_balloonXDirections[index]; // Change direction
            }
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
    return Stack(
      children: List.generate(20, (index) => _buildBalloon(index)),
    );
  }

  Widget _buildBalloon(int index) {
    // Only render balloons after their animation has started
    if (!_balloonStarted[index])
      return const SizedBox.shrink(); // Empty widget until the balloon starts

    return Positioned(
      // No animation here, only update positions instantly if needed
      top: MediaQuery.of(context).size.height *
          _balloonYPositions[index], // Y position
      left: MediaQuery.of(context).size.width *
          _balloonXPositions[index], // X position
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Smooth upward movement
        child: Icon(
          Ionicons.balloon, // Balloon icon from Ionicons package
          size: 50,
          color: Colors.pink.shade300.withOpacity(0.4),
        ),
      ),
    );
  }
}
