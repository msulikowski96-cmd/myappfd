import 'dart:convert';
import 'package:http/http.dart' as http;

/// ===============================
/// AI SERVICE – OPENROUTER
/// ===============================
/// Wariant A:
/// - prompt generowany w Dart
/// - odpowiedź WYŁĄCZNIE JSON
/// - gotowe pod Flutter mobile + web
class AIService {
  static const String _apiKey = String.fromEnvironment('OPENROUTER_API_KEY');

  static const String _endpoint =
      'https://openrouter.ai/api/v1/chat/completions';

  static const String _model = 'qwen/qwen-2.5-vl-7b-instruct:free';

  /// ===============================
  /// PUBLIC API
  /// ===============================
  static Future<Map<String, dynamic>> analyzeHealth({
    required int age,
    required String gender,
    required double weight,
    required double height,
    required double bmi,
    required String bmiCategory,
    required double bmr,
    required double tdee,
    required String goal,
  }) async {
    final prompt = _buildPrompt(
      age: age,
      gender: gender,
      weight: weight,
      height: height,
      bmi: bmi,
      bmiCategory: bmiCategory,
      bmr: bmr,
      tdee: tdee,
      goal: goal,
    );

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://bmi-ai.app',
        'X-Title': 'BMI AI Analyzer',
      },
      body: jsonEncode({
        "model": _model,
        "temperature": 0.4,
        "messages": [
          {
            "role": "system",
            "content":
                "Zwracaj WYŁĄCZNIE poprawny JSON. Bez markdown. Bez komentarzy."
          },
          {"role": "user", "content": prompt}
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI error ${response.statusCode}: ${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final content = decoded['choices'][0]['message']['content'];

    try {
      return jsonDecode(content);
    } catch (_) {
      throw Exception('AI returned invalid JSON:\n$content');
    }
  }

  /// ===============================
  /// PROMPT TEMPLATE
  /// ===============================
  static String _buildPrompt({
    required int age,
    required String gender,
    required double weight,
    required double height,
    required double bmi,
    required String bmiCategory,
    required double bmr,
    required double tdee,
    required String goal,
  }) {
    return '''
Jesteś certyfikowanym dietetykiem klinicznym i trenerem zdrowia.
Analizujesz dane zdrowotne w sposób odpowiedzialny i konkretny.

ZASADY:
- Odpowiadaj WYŁĄCZNIE poprawnym JSON
- Brak markdown, brak tekstu poza JSON
- Skala AI-score 1–100 (100 = optymalne zdrowie metaboliczne)

DANE UŻYTKOWNIKA:
- Wiek: $age
- Płeć: $gender
- Waga (kg): ${weight.toStringAsFixed(1)}
- Wzrost (cm): ${height.toStringAsFixed(1)}
- BMI: ${bmi.toStringAsFixed(2)}
- Kategoria BMI: $bmiCategory
- BMR: ${bmr.toStringAsFixed(0)}
- TDEE: ${tdee.toStringAsFixed(0)}
- Cel: $goal

ZWRÓĆ JSON O STRUKTURZE:

{
  "ai_score": number,
  "risk_level": "low | moderate | high",
  "summary": "krótka ocena stanu zdrowia",
  "interpretation": {
    "bmi": "interpretacja BMI",
    "metabolism": "ocena metabolizmu",
    "goal_fit": "realność celu"
  },
  "recommendations": {
    "nutrition": ["3 konkretne zalecenia"],
    "activity": ["3 zalecenia ruchowe"],
    "lifestyle": ["3 zalecenia stylu życia"]
  },
  "warnings": ["potencjalne ryzyka zdrowotne"],
  "next_steps": ["kroki na 7–30 dni"]
}
''';
  }
}
