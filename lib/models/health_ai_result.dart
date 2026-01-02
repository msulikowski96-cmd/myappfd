class HealthAIResult {
  final int aiScore;
  final String riskLevel;
  final String summary;
  final Map<String, dynamic> interpretation;
  final Map<String, List<String>> recommendations;
  final List<String> warnings;
  final List<String> nextSteps;

  HealthAIResult({
    required this.aiScore,
    required this.riskLevel,
    required this.summary,
    required this.interpretation,
    required this.recommendations,
    required this.warnings,
    required this.nextSteps,
  });

  factory HealthAIResult.fromJson(Map<String, dynamic> json) {
    return HealthAIResult(
      aiScore: json['ai_score'],
      riskLevel: json['risk_level'],
      summary: json['summary'],
      interpretation: Map<String, dynamic>.from(json['interpretation']),
      recommendations: {
        "nutrition": List<String>.from(json['recommendations']['nutrition']),
        "activity": List<String>.from(json['recommendations']['activity']),
        "lifestyle": List<String>.from(json['recommendations']['lifestyle']),
      },
      warnings: List<String>.from(json['warnings']),
      nextSteps: List<String>.from(json['next_steps']),
    );
  }
}
