import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

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

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double weight = 80;
  double height = 180;
  double age = 30;
  String gender = 'M';
  String goal = 'Utrzymanie';

  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  double get bmi => weight / ((height / 100) * (height / 100));

  double get bmr {
    if (gender == 'M') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  double get tdee {
    const activityFactor = 1.55;
    double base = bmr * activityFactor;

    switch (goal) {
      case 'Redukcja':
        return base - 500;
      case 'Masa':
        return base + 400;
      default:
        return base;
    }
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Niedowaga';
    if (bmi < 25) return 'Norma';
    if (bmi < 30) return 'Nadwaga';
    return 'Otyłość';
  }

  Future<void> saveResult() async {
    final prefs = await SharedPreferences.getInstance();

    history.add({
      'date': DateTime.now().toIso8601String(),
      'bmi': bmi,
      'bmr': bmr,
      'tdee': tdee,
    });

    await prefs.setString('history', jsonEncode(history));
    setState(() {});
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('history');
    if (raw != null) {
      history = List<Map<String, dynamic>>.from(jsonDecode(raw));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI AI Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            slider('Waga (kg)', weight, 40, 150,
                (v) => setState(() => weight = v)),
            slider('Wzrost (cm)', height, 140, 210,
                (v) => setState(() => height = v)),
            slider('Wiek', age, 14, 80, (v) => setState(() => age = v)),
            Row(
              children: [
                dropdown('Płeć', gender, ['M', 'K'],
                    (v) => setState(() => gender = v)),
                const SizedBox(width: 16),
                dropdown('Cel', goal, ['Redukcja', 'Utrzymanie', 'Masa'],
                    (v) => setState(() => goal = v)),
              ],
            ),
            const SizedBox(height: 20),
            Text('BMI: ${bmi.toStringAsFixed(2)} ($bmiCategory)'),
            Text('BMR: ${bmr.toStringAsFixed(0)} kcal'),
            Text('TDEE (cel): ${tdee.toStringAsFixed(0)} kcal'),
            const SizedBox(height: 20),
            bmiChart(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveResult,
              child: const Text('Zapisz wynik'),
            ),
            const SizedBox(height: 20),
            const Text('Historia:', style: TextStyle(fontSize: 18)),
            ...history.reversed.map((e) => Text(
                '${e['date'].substring(0, 10)} → BMI ${e['bmi'].toStringAsFixed(2)}, TDEE ${e['tdee'].toStringAsFixed(0)}')),
          ],
        ),
      ),
    );
  }

  Widget slider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(0)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget dropdown(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ],
      ),
    );
  }

  Widget bmiChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: 15,
          maxY: 40,
          lineBarsData: [
            LineChartBarData(
              spots: history
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value['bmi']))
                  .toList(),
              isCurved: true,
              dotData: const FlDotData(show: true),
            )
          ],
        ),
      ),
    );
  }
}
