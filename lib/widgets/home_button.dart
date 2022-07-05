import 'package:flutter/material.dart';

Widget button(text, icon, onPressedFunction){
  return ElevatedButton(
    onPressed: onPressedFunction,
    style: ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 20, 33, 61),
      shadowColor: const Color.fromARGB(255, 20, 33, 61),
      elevation: 15.0
    ),
    child: Row(
      children: [
        Icon(icon),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    ),
  );
}