import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import '../utils/calculators.dart';
import '../services/ai_service.dart';
import '../models/health_ai_result.dart';

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
  HealthAIResult? aiResult;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  double get bmi => calculateBMI(weight, height);
  double get bmr =>
      calculateBMR(weight: weight, height: height, age: age, gender: gender);
  double get tdee => calculateTDEE(bmr: bmr, goal: goal);
  String get category => bmiCategory(bmi);

  Future<void> _analyzeAI() async {
  setState(() => loading = true);

  try {
    final json = await AIService.analyzeHealth(
      age: age.toInt(),
      gender: gender,
      weight: weight,
      height: height,
      bmi: bmi,
      bmiCategory: category,
      bmr: bmr,
      tdee: tdee,
      goal: goal,
    );

    setState(() {
      aiResult = HealthAIResult.fromJson(json);
    });
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Błąd AI: $e')),
    );
  } finally {
    setState(() => loading = false);
  }
}


  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    history.add({
      'date': DateTime.now().toIso8601String(),
      'bmi': bmi,
    });
    await prefs.setString('history', jsonEncode(history));
    setState(() {});
  }

  Future<void> _loadHistory() async {
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
          children: [
            _slider('Waga', weight, 40, 150, (v) => setState(() => weight = v)),
            _slider(
                'Wzrost', height, 140, 210, (v) => setState(() => height = v)),
            _slider('Wiek', age, 14, 80, (v) => setState(() => age = v)),
            Row(
              children: [
                _dropdown('Płeć', gender, ['M', 'K'],
                    (v) => setState(() => gender = v)),
                const SizedBox(width: 12),
                _dropdown('Cel', goal, ['Redukcja', 'Utrzymanie', 'Masa'],
                    (v) => setState(() => goal = v)),
              ],
            ),
            const SizedBox(height: 12),
            Text('BMI: ${bmi.toStringAsFixed(2)} ($category)'),
            Text('BMR: ${bmr.toStringAsFixed(0)} kcal'),
            Text('TDEE: ${tdee.toStringAsFixed(0)} kcal'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(LineChartData(
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
                  )
                ],
              )),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _analyzeAI,
              child: Text(loading ? 'Analiza...' : 'Analizuj AI'),
            ),
            if (aiResult != null) ...[
              const SizedBox(height: 12),
              Text('AI-Score: ${aiResult!.aiScore}/100'),
              Text(aiResult!.summary),
            ],
            ElevatedButton(
              onPressed: _save,
              child: const Text('Zapisz wynik'),
            )
          ],
        ),
      ),
    );
  }

  Widget _slider(
          String l, double v, double min, double max, Function(double) f) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$l: ${v.toStringAsFixed(0)}'),
          Slider(value: v, min: min, max: max, onChanged: f),
        ],
      );

  Widget _dropdown(
          String l, String v, List<String> items, Function(String) f) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l),
            DropdownButton<String>(
              value: v,
              isExpanded: true,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (x) => f(x!),
            )
          ],
        ),
      );
}
