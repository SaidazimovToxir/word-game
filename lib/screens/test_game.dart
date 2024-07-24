import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_x/screens/bank_card_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp(
    //   title: 'Bank Card App',
    //   home: BankCardPage(),
    // );
    return MaterialApp(
      home: WordFind(),
    );
  }
}

class WordFind extends StatefulWidget {
  WordFind({Key? key}) : super(key: key);

  @override
  _WordFindState createState() => _WordFindState();
}

class _WordFindState extends State<WordFind> {
  final GlobalKey<_WordFindWidgetState> globalKey = GlobalKey();
  late List<WordFindQues> listQuestions;

  @override
  void initState() {
    super.initState();
    listQuestions = [
      WordFindQues(
        question: "What is the name of this game?",
        answer: "mario",
        pathImage:
            "https://images.pexels.com/photos/163077/mario-yoschi-figures-funny-163077.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      ),
      WordFindQues(
        question: "What is this animal?",
        answer: "cat",
        pathImage:
            "https://images.pexels.com/photos/617278/pexels-photo-617278.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
      ),
      WordFindQues(
        question: "What is this animal's name?",
        answer: "wolf",
        pathImage:
            "https://as1.ftcdn.net/v2/jpg/02/48/64/04/1000_F_248640483_5KAZi0GqcWrBu6GOhFEAxk1quNEuOzHJ.jpg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.green,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      color: Colors.blue,
                      child: WordFindWidget(
                        size: constraints.biggest,
                        listQuestions:
                            listQuestions.map((ques) => ques.clone()).toList(),
                        key: globalKey,
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    globalKey.currentState?.generatePuzzle(
                      loop: listQuestions.map((ques) => ques.clone()).toList(),
                    );
                  },
                  child: const Text("Reload"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordFindWidget extends StatefulWidget {
  final Size size;
  final List<WordFindQues> listQuestions;

  WordFindWidget({required this.size, required this.listQuestions, Key? key})
      : super(key: key);

  @override
  _WordFindWidgetState createState() => _WordFindWidgetState();
}

class _WordFindWidgetState extends State<WordFindWidget> {
  late Size size;
  late List<WordFindQues> listQuestions;
  int indexQues = 0;
  int hintCount = 0;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    listQuestions = widget.listQuestions;
    generatePuzzle();
  }

  @override
  Widget build(BuildContext context) {
    WordFindQues currentQues = listQuestions[indexQues];

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: generateHint,
                  child: Icon(
                    Icons.healing_outlined,
                    size: 45,
                    color: Colors.yellow[200],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => generatePuzzle(left: true),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color: Colors.yellow[200],
                      ),
                    ),
                    InkWell(
                      onTap: () => generatePuzzle(next: true),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 45,
                        color: Colors.yellow[200],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: size.width / 2 * 1.5,
                ),
                child: Image.network(
                  currentQues.pathImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          //! Savol ko'rsatish
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              "${currentQues.question ?? ''}",
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //! Kiritilgan harflar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            alignment: Alignment.center,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: currentQues.puzzles.map((puzzle) {
                    Color color;

                    if (currentQues.isDone)
                      color = Colors.green[300]!;
                    else if (puzzle.hintShow)
                      color = Colors.yellow[100]!;
                    else if (currentQues.isFull)
                      color = Colors.red;
                    else
                      color = const Color(0xff7EE7FD);

                    return InkWell(
                      onTap: () {
                        if (puzzle.hintShow || currentQues.isDone) return;

                        currentQues.isFull = false;
                        puzzle.clearValue();
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: constraints.biggest.width / 7 - 6,
                        height: constraints.biggest.width / 7 - 6,
                        margin: const EdgeInsets.all(3),
                        child: Text(
                          "${puzzle.currentValue ?? ''}".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          //! Taxminiy raqamlar
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 8,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 16,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool statusBtn = currentQues.puzzles
                        .indexWhere((puzzle) => puzzle.currentIndex == index) >=
                    0;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    Color color =
                        statusBtn ? Colors.white70 : const Color(0xff7EE7FD);

                    return Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(constraints.biggest.width,
                              constraints.biggest.height),
                        ),
                        child: Text(
                          "${currentQues.arrayBtns[index]}".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (!statusBtn) setBtnClick(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void generatePuzzle({
    List<WordFindQues>? loop,
    bool next = false,
    bool left = false,
  }) {
    if (loop != null) {
      indexQues = 0;
      listQuestions = List<WordFindQues>.from(loop);
    } else {
      if (next && indexQues < listQuestions.length - 1)
        indexQues++;
      else if (left && indexQues > 0)
        indexQues--;
      else if (indexQues >= listQuestions.length - 1) return;

      if (listQuestions[indexQues].isDone) return;
    }

    WordFindQues currentQues = listQuestions[indexQues];

    setState(() {
      currentQues.arrayBtns = generateArrayBtns(currentQues.answer);
      currentQues.puzzles =
          generatePuzzles(currentQues.answer, currentQues.arrayBtns.length);
      currentQues.isDone = false;
    });
  }

  void generateHint() {
    setState(() {
      if (hintCount < 3) {
        WordFindQues currentQues = listQuestions[indexQues];
        int hintIndex = currentQues.puzzles
            .indexWhere((puzzle) => puzzle.currentValue == null);
        if (hintIndex != -1) {
          currentQues.puzzles[hintIndex].currentValue =
              currentQues.answer[hintIndex];
          hintCount++;
        }
      }
    });
  }

  void setBtnClick(int index) {
    WordFindQues currentQues = listQuestions[indexQues];
    if (currentQues.isFull) return;

    int puzzleIndex = currentQues.puzzles
        .indexWhere((puzzle) => puzzle.currentIndex == index);
    if (puzzleIndex >= 0) {
      if (currentQues.puzzles[puzzleIndex].currentValue != null) {
        return;
      }
    }

    setState(() {
      for (int i = 0; i < currentQues.puzzles.length; i++) {
        if (currentQues.puzzles[i].currentValue == null) {
          currentQues.puzzles[i].currentValue = currentQues.arrayBtns[index];
          currentQues.puzzles[i].currentIndex = index;
          if (checkAnswer()) {
            currentQues.isDone = true;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Congratulations!"),
                  content: const Text("You've completed the puzzle."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        generatePuzzle(next: true);
                      },
                      child: const Text("Next"),
                    ),
                  ],
                );
              },
            );
          }
          break;
        }
      }
    });
  }

  bool checkAnswer() {
    WordFindQues currentQues = listQuestions[indexQues];
    return currentQues.puzzles.every((puzzle) =>
        puzzle.currentValue == currentQues.answer[puzzle.currentIndex]);
  }
}

class WordFindQues {
  final String question;
  final String answer;
  final String pathImage;
  late List<String> arrayBtns;
  late List<WordFindPuzzle> puzzles;
  bool isDone = false;
  bool isFull = false;

  WordFindQues({
    required this.question,
    required this.answer,
    required this.pathImage,
  });

  WordFindQues clone() {
    return WordFindQues(
      question: this.question,
      answer: this.answer,
      pathImage: this.pathImage,
    );
  }
}

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

List<String> generateArrayBtns(String answer) {
  List<String> buttons = answer.split('')..shuffle();
  while (buttons.length < 16) {
    buttons.add(String.fromCharCode(
        65 + (buttons.length % 26))); // Adding random letters A-Z
  }
  buttons.shuffle(); // Shuffle to mix the letters
  return buttons;
}

List<WordFindPuzzle> generatePuzzles(String answer, int size) {
  List<WordFindPuzzle> puzzles = [];
  for (int i = 0; i < size; i++) {
    puzzles.add(
      WordFindPuzzle(
        answer: answer,
        currentValue: null,
        currentIndex: i,
      ),
    );
  }
  return puzzles;
}
