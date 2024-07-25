import '../screens/test_game.dart';

class WordGameModel {
  final String question;
  final String answer;
  late List<String> arrayBtns;
  late List<WordFindPuzzle> puzzles;
  bool isDone = false;
  bool isFull = false;

  WordGameModel({
    required this.question,
    required this.answer,
  });
}

List<WordGameModel> listQuestions = [
  WordGameModel(
    question: "Qaysi sayyora Quyosh tizimidagi eng katta sayyoradir?",
    answer: "yup",
  ),
  WordGameModel(
    question:
        "Qaysi sayyora 'kuzatilgan' deb ataladi, chunki u doim Quyosh atrofida to‘g‘ri qamchilanadi?",
    answer: "merkuriy",
  ),
  WordGameModel(
    question:
        "Qaysi sayyora dengizlar bilan to‘ldirilgan va o‘zining ko‘k rangiga ega?",
    answer: "yer",
  ),
  WordGameModel(
    question:
        "Qaysi sayyora Quyosh tizimida 'yangi o‘zgaruvchi' deb nomlanadi?",
    answer: "uran",
  ),
  WordGameModel(
    question:
        "Sayyoralar orasida eng kuchli tortishish kuchiga ega bo‘lgan sayyora qaysi?",
    answer: "yupiter",
  ),
  WordGameModel(
    question: "Saturnning ulkan halqalari qaysi sayyora atrofida joylashgan?",
    answer: "saturn",
  ),
  WordGameModel(
    question: "Qaysi sayyora Quyosh tizimida eng uzoq masofada joylashgan?",
    answer: "pluton",
  ),
  WordGameModel(
    question: "Qaysi sayyora bir necha oy to‘plamlariga ega?",
    answer: "yupiter",
  ),
  WordGameModel(
    question: "Qaysi sayyora o‘zining mayda halqalari bilan mashhur?",
    answer: "urans",
  ),
];
