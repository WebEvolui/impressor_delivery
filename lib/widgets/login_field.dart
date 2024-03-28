import 'package:flutter/material.dart';
import '../pallete.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  TextEditingController controller;
  LoginField({super.key, required this.hintText, required this.controller, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
        ),
        obscureText: obscureText,
      ),
    );
  }
}