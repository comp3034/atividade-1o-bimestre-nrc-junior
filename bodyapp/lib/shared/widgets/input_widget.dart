import 'package:flutter/material.dart';

import '../colors.dart';

class InputWidget extends StatelessWidget {
  TextEditingController? controller;
  String? hintText;
  IconData? prefixIcon;
  IconData? sufixIcon;
  bool obscureText;
  VoidCallback? suffixIconOnPressed;
  String? Function(String?)? validator;
  void Function(String)? onChanged;

  InputWidget({
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.sufixIcon,
    this.obscureText = false,
    this.suffixIconOnPressed,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        fillColor: Colors.grey[300],
        filled: true,
        focusColor: Colors.grey[300],
        hoverColor: Colors.grey[300],
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[800]),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Colors.red),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.teal,
        ),
        suffixIcon: IconButton(
          icon: Icon(sufixIcon),
          color: AppColors.teal,
          onPressed: suffixIconOnPressed,
        ),
      ),
      validator: validator,
    );
  }
}
