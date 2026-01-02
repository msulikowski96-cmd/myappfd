# Project Blueprint

## Overview

This document outlines the plan for creating a comprehensive unit testing suite for the Flutter application. The goal is to ensure the reliability and correctness of the app's business logic and utility functions.

## Current State

The project currently has a BMI calculator screen with AI analysis features. However, there are no unit tests to validate the correctness of the calculations and other logic.

## Plan for Unit Tests

I will implement the following unit tests:

1.  **`calculators_test.dart`**: This will contain unit tests for the utility functions in `lib/utils/calculators.dart`. The tests will cover:
    *   `calculateBMI()`: Verify that the BMI calculation is correct for a range of inputs.
    *   `calculateBMR()`: Test the BMR calculation for different genders, weights, heights, and ages.
    *   `calculateTDEE()`: Ensure the TDEE calculation is accurate based on different activity levels (goals).
    *   `bmiCategory()`: Validate that the BMI category is correctly determined based on the BMI value.

2.  **`ai_service_test.dart`**: This will contain unit tests for the `AIService` in `lib/services/ai_service.dart`. The tests will mock the AI service and verify that the service correctly handles:
    *   Successful API responses.
    *   Error handling when the API call fails.
    *   Correct parsing of the JSON response into a `HealthAIResult` object.

3.  **`health_ai_result_test.dart`**: This will contain unit tests for the `HealthAIResult` model in `lib/models/health_ai_result.dart`. The tests will ensure:
    *   The `fromJson()` factory constructor correctly parses the JSON data.
    *   The model's properties are correctly initialized.

## Implementation Steps

1.  Create the `test` directory in the project's root.
2.  Add the `test` dependency to the `pubspec.yaml` file.
3.  Create the `test/calculators_test.dart` file and add the corresponding unit tests.
4.  Create the `test/ai_service_test.dart` file and add the corresponding unit tests.
5.  Create the `test/health_ai_result_test.dart` file and add the corresponding unit tests.
6.  Run the tests using the `flutter test` command to ensure all tests pass.

By following this plan, we will establish a solid testing foundation for the application, making it more robust and easier to maintain.
