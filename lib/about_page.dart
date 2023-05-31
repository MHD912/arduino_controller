import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to NodeMCU Controller',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'This app was developed for the final project of MPMC course. ',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              'Team members',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Islam Al-Abd\n&\nMohammad Hussein Hamed',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Text(
              'Instructor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'Dr. Ahmad Mohsen',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
