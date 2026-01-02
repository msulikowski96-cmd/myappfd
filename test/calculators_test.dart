import 'package:flutter_test/flutter_test.dart';
import 'package:bmi/utils/calculators.dart';

void main() {
  group('Calculator Tests', () {
    test('BMI Calculation', () {
      expect(calculateBMI(80, 180), 24.691358024691358);
      expect(calculateBMI(60, 170), 20.761245674740486);
    });

    test('BMR Calculation', () {
      expect(
          calculateBMR(
              weight: 80,
              height: 180,
              age: 30,
              gender: 'M'),
          1780.0);
      expect(
          calculateBMR(
              weight: 60,
              height: 170,
              age: 25,
              gender: 'K'),
          1376.5);
    });

    test('TDEE Calculation', () {
      expect(calculateTDEE(bmr: 1780, goal: 'Utrzymanie'), 2759.0);
      expect(calculateTDEE(bmr: 1339, goal: 'Redukcja'), closeTo(1575.45, 0.01));
      expect(calculateTDEE(bmr: 1339, goal: 'Masa'), 2475.45);
    });

    test('BMI Category', () {
      expect(bmiCategory(18.4), 'Niedowaga');
      expect(bmiCategory(18.5), 'Norma');
      expect(bmiCategory(24.9), 'Norma');
      expect(bmiCategory(25), 'Nadwaga');
      expect(bmiCategory(29.9), 'Nadwaga');
      expect(bmiCategory(30), 'Otyłość');
    });
  });
}
