import 'package:flutter/material.dart';
import 'package:impressor_delivery/widgets/gradient_button.dart';
import 'package:impressor_delivery/widgets/login_field.dart';

import 'helpers/dio.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const Text(
                'Impressor Delivery',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              LoginField(hintText: 'Email', controller: controllerEmail),
              const SizedBox(height: 15),
              LoginField(
                  hintText: 'Senha',
                  controller: controllerPassword,
                  obscureText: true),
              const SizedBox(height: 20),
              GradientButton(onPressed: login),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    final email = controllerEmail.text;
    final password = controllerPassword.text;

    final dio = createDio('');
    dynamic response = await dio.post('/login', data: {
      'email': email,
      'password': password,
      'device_name': 'app-desktop',
    });

    if (response.statusCode != 200) {
      return;
    }

    final token = response.data['access_token'];

    final dioStore = createDio(token);
    response = await dioStore.get('/store');

    if (response.statusCode != 200) {
      return;
    }

    final storeId = response.data['id'].toString();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomeScreen(token, storeId)));
  }
}
