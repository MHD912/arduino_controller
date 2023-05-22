import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arduino Controller',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // Set the app bar color to blue
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner:
          false, // Add this line to remove the debug banner

      routes: {
        '/wifi': (context) => const WifiPage(), // Route for the Wi-Fi interface
        '/bluetooth': (context) =>
            const BluetoothPage(), // Route for the Bluetooth interface
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Wi-Fi'),
              onTap: () {
                // Navigate to the Wi-Fi interface
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/wifi');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth),
              title: const Text('Bluetooth'),
              onTap: () {
                // Navigate to the Bluetooth interface
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/bluetooth');
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/aiu_logo.png', // Replace with the actual image path
            width: 200,
            height: 200,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 50)),
          const Text(
            'Welcome to the Arduino Controller!\nPress the menu button to choose the desired communication method.\n',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 50)),
          const Text(
            '----=( Done by )=----\nIslam Al-Abd\n&\nMohammad Hussein Hamed',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  @override
  WifiPageState createState() => WifiPageState();
}

class WifiPageState extends State<WifiPage> {
  bool ledState = false;
  double temperature = 0.0;

  Future<void> toggleLed() async {
    final response = await http.get('http://arduino_ip_address/LED' as Uri);
    if (response.statusCode == 200) {
      setState(() {
        ledState = !ledState;
      });
    }
  }

  Future<void> fetchTemperature() async {
    final response =
        await http.get('http://arduino_ip_address/temperature' as Uri);
    if (response.statusCode == 200) {
      setState(() {
        temperature = double.parse(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arduino Over Wi-Fi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 22),
            Text(
              'Temperature: $temperature °C',
              style: const TextStyle(fontSize: 23),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: toggleLed,
              child: Text(ledState ? 'LED ON' : 'LED OFF'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTemperature();
  }
}

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Interface'),
      ),
      body: const Center(
        child: Text(
          'This is the Bluetooth Interface',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
