import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/word_game_model.dart';

class WordGameController extends GetxController {
  final RxInt indexQues = 0.obs;
  final RxInt hintCount = 0.obs;
  late List<TextEditingController> controllers;
  late List<String> buttons;
  RxBool isFull = false.obs;
  RxBool isDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _initializeButtons();
  }

  void _initializeControllers() {
    final WordGameModel listOfQuestion = listQuestions[indexQues.value];
    controllers = List.generate(
      listOfQuestion.answer.length,
      (_) => TextEditingController(),
    );
  }

  void _initializeButtons() {
    final WordGameModel listOfQuestion = listQuestions[indexQues.value];
    buttons = generateArrayBtns(listOfQuestion.answer);
  }

  List<String> generateArrayBtns(String answer) {
    List<String> buttons = answer.split('')..shuffle();
    while (buttons.length < 16) {
      String randomLetter = String.fromCharCode(65 + Random().nextInt(26));
      buttons.add(randomLetter);
    }
    buttons.shuffle();
    return buttons;
  }

  void addCharacter(String char) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        controllers[i].text = char;
        _checkAnswer();
        break;
      }
    }
  }

  void _checkAnswer() {
    final WordGameModel listOfQuestion = listQuestions[indexQues.value];
    final enteredText = getEnteredText();
    print(enteredText.toLowerCase());
    if (enteredText.length == listOfQuestion.answer.length) {
      if (enteredText.toLowerCase() == listOfQuestion.answer) {
        _showDialog("To'g'ri!", "Kiritilgan so'z to'g'ri.", nextQuestion: true);
      } else {
        _showDialog("Xato!", "Kiritilgan so'z noto'g'ri.", nextQuestion: false);
      }
    }
  }

  String getEnteredText() {
    return controllers.map((controller) => controller.text).join();
  }

  void _showDialog(String title, String message, {required bool nextQuestion}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              if (nextQuestion) {
                _goToNextQuestion();
              } else {
                _clearTextFields();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearTextFields() {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  void _goToNextQuestion() {
    int nextIndex = indexQues.value + 1;
    if (nextIndex < listQuestions.length) {
      updateIndex(nextIndex);
    } else {
      _showDialog("Tugatildi!", "Savollar tugadi.", nextQuestion: false);
    }
  }

  void updateIndex(int newIndex) {
    indexQues.value = newIndex;
    _initializeControllers();
    _initializeButtons();
  }
}
