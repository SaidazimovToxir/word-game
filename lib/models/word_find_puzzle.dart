class WordFindPuzzle {
  final String answer;
  String? currentValue;
  int currentIndex;
  bool hintShow = false;

  WordFindPuzzle({
    required this.answer,
    this.currentValue,
    required this.currentIndex,
  });

  void clearValue() {
    currentValue = null;
  }
}
