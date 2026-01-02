double calculateBMI(double weight, double heightCm) {
  final h = heightCm / 100;
  return weight / (h * h);
}

String bmiCategory(double bmi) {
  if (bmi < 18.5) return 'Niedowaga';
  if (bmi < 25) return 'Norma';
  if (bmi < 30) return 'Nadwaga';
  return 'Otyłość';
}

double calculateBMR({
  required double weight,
  required double height,
  required double age,
  required String gender,
}) {
  if (gender == 'M') {
    return 10 * weight + 6.25 * height - 5 * age + 5;
  } else {
    return 10 * weight + 6.25 * height - 5 * age - 161;
  }
}

double calculateTDEE({
  required double bmr,
  required String goal,
}) {
  const activity = 1.55;
  double base = bmr * activity;

  switch (goal) {
    case 'Redukcja':
      return base - 500;
    case 'Masa':
      return base + 400;
    default:
      return base;
  }
}
