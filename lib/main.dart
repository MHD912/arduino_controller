import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NodeMCU Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final String nodeMCUIpAddress = '192.168.1.105'; // Replace with your NodeMCU's IP address
  final int nodeMCUPort = 80; // Replace with the port number used in your NodeMCU code
  bool isLEDTurnedOn = false;
  String currentTemperature = "0.0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NodeMCU Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LED Status:',
              style: TextStyle(fontSize: 24),
            ),
            Switch(
              value: isLEDTurnedOn,
              onChanged: (value) {
                setState(() {
                  isLEDTurnedOn = value;
                });
                sendLEDCommand(value);
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'Temperature:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$currentTemperature °C',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchTemperature,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> sendLEDCommand(bool isTurnedOn) async {
    try {
      String command = isTurnedOn ? 'ON' : 'OFF';
      final url = Uri.parse('http://$nodeMCUIpAddress:$nodeMCUPort/$command');
      await http.get(url);
    } catch (e) {
      if (kDebugMode) {
        print('Error sending LED command: $e');
      }
    }
  }

  Future<void> fetchTemperature() async {
    try {
      final url = Uri.parse('http://$nodeMCUIpAddress:$nodeMCUPort');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          currentTemperature = response.body;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching temperature: $e');
      }
    }
  }
}
