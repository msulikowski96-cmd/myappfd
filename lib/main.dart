import 'package:flutter/material.dart';
import 'screens/bmi_screen.dart';

void main() {
  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI AI Analyzer',
      theme: ThemeData.dark(useMaterial3: true),
      home: const BMIScreen(),
    );
  }
}
