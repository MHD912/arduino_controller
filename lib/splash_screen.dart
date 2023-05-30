import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color as per your preference
      body: Center(
        child: Image.asset(
          'assets/images/splash_image.png', // Replace with the path to your custom image
          width: 200, // Customize the width as needed
          height: 200, // Customize the height as needed
        ),
      ),
    );
  }
}
