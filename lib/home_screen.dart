import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'services/realtime_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  final String storeId;

  const HomeScreen(this.token, this.storeId, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final realTimeService;

  @override
  void initState() {
    super.initState();
    realTimeService =
        RealTimeService(widget.token, 'private-stores.${widget.storeId}');
  }

  @override
  void dispose() {
    realTimeService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Impressor Delivery (Código)'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              realTimeService.disconnect();
              realTimeService.connect();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
              onPressed: () {
                realTimeService.disconnect();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Só aguardar os pedidos...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'A conexão em real-time está ativa.',
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
