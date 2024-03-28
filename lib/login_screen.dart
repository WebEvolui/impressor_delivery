import 'package:flutter/material.dart';
import 'package:impressor_delivery/widgets/gradient_button.dart';
import 'package:impressor_delivery/widgets/login_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              const LoginField(hintText: 'Email'),
              const SizedBox(height: 15),
              const LoginField(hintText: 'Senha', obscureText: true),
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
  }
}
