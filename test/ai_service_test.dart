import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:bmi/services/ai_service.dart';
import 'dart:convert';

class MockClient extends Mock implements http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('AIService', () {
    test('analyzeHealth returns a valid JSON on success', () async {
      final client = MockClient();
      final expectedResponse = {
        'ai_score': 85,
        'summary': 'Your health is in good condition.',
        'recommendations': [
          'Maintain a balanced diet.',
          'Engage in regular physical activity.'
        ]
      };

      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(jsonEncode({'choices': [{'message': {'content': jsonEncode(expectedResponse)}}]}), 200));

      final result = await AIService.analyzeHealth(
        age: 30,
        gender: 'M',
        weight: 80,
        height: 180,
        bmi: 24.7,
        bmiCategory: 'Norma',
        bmr: 1845,
        tdee: 2214,
        goal: 'Utrzymanie',
        client: client,
      );

      expect(result, expectedResponse);
    });

    test('analyzeHealth throws an exception on failure', () async {
      final client = MockClient();

      when(client.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => AIService.analyzeHealth(
          age: 30,
          gender: 'M',
          weight: 80,
          height: 180,
          bmi: 24.7,
          bmiCategory: 'Norma',
          bmr: 1845,
          tdee: 2214,
          goal: 'Utrzymanie',
          client: client,
        ),
        throwsException,
      );
    });
  });
}
