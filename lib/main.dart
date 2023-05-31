import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NodeMCU Controller",
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // Set the app bar color to blue
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late String temp;
  late IOWebSocketChannel channel;
  late bool connected;
  late bool ledOn;

  @override
  void initState() {
    connected = false;
    ledOn = false;
    temp = "N/A";
    Future.delayed(Duration.zero, () async {
      channelConnect();
    });

    super.initState();
  }

  channelConnect() {
    try {
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81");
      channel.stream.listen((message) {
        if (kDebugMode) {
          print(message);
        }
        setState(() {
          if (message == "connected") {
            connected = true;
          } else if (message.substring(0, 8) == "{'temp':") {
            message = message.replaceAll(RegExp("'"), '"');
            Map<String, dynamic> jsonData = json.decode(message);
            setState(() {
              temp = jsonData["temp"];
            });
          }
        });
      }, onDone: () {
        if (kDebugMode) {
          print("Web socket is closed");
        }
        setState(() {
          connected = false;
          temp = "N/A";
        });
      }, onError: (error) {
        if (kDebugMode) {
          print(error.toString());
        }
      });
    } catch (_) {
      if (kDebugMode) {
        print("error on connecting to websocket.");
      }
    }
  }

  Future<void> sendCmd(String cmd) async {
    if (connected == true) {
      channel.sink.add(cmd);
    } else {
      channelConnect();
      if (kDebugMode) {
        print("Websocket is not connected.");
      }
    }
  }

  Future<void> toggleLED(bool value) async {
    setState(() {
      ledOn = value;
    });
    String cmd = ledOn ? "ledOn" : "ledOff";
    sendCmd(cmd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NodeMCU Controller"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: Container(
              child: connected
                  ? const Text("WebSocket: CONNECTED")
                  : const Text("DISCONNECTED"),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/images/aiu_logo.png',
              width: 200, // Adjust the width as per your requirements
              height: 200, // Adjust the height as per your requirements
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'LED Status',
                    style: TextStyle(fontSize: 24),
                  ),
                  CupertinoSwitch(
                    value: ledOn,
                    onChanged: toggleLED,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Temperature',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    '$temp °C',
                    style: const TextStyle(fontSize: 32),
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
