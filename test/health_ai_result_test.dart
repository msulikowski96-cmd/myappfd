import 'package:flutter_test/flutter_test.dart';
import 'package:bmi/models/health_ai_result.dart';

void main() {
  group('HealthAIResult', () {
    test('fromJson creates a valid object', () {
      final json = {
        'ai_score': 85,
        'risk_level': 'low',
        'summary': 'Your health is in good condition.',
        'interpretation': {
          'bmi': 'Your BMI is within the normal range.',
          'metabolism': 'Your metabolism is at a healthy rate.',
          'goal_fit': 'Your goal is realistic.'
        },
        'recommendations': {
          'nutrition': [
            'Maintain a balanced diet.',
            'Stay hydrated.'
          ],
          'activity': [
            'Engage in regular physical activity.',
            'Incorporate strength training.'
          ],
          'lifestyle': [
            'Get enough sleep.',
            'Manage stress.'
          ]
        },
        'warnings': [],
        'next_steps': []
      };

      final result = HealthAIResult.fromJson(json);

      expect(result.aiScore, 85);
      expect(result.riskLevel, 'low');
      expect(result.summary, 'Your health is in good condition.');
      expect(result.interpretation['bmi'], 'Your BMI is within the normal range.');
      expect(result.recommendations['nutrition'], [
        'Maintain a balanced diet.',
        'Stay hydrated.'
      ]);
    });
  });
}
