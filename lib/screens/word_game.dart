import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x/models/word_game_model.dart';
import 'package:get_x/utils/constants.dart';
import '../controllers/word_game_controller.dart';
import '../widgets/ball_widget.dart';

class WordGame extends StatelessWidget {
  const WordGame({super.key});

  @override
  Widget build(BuildContext context) {
    final WordGameController controller = Get.put(WordGameController());

    return Scaffold(
      body: Obx(() {
        final WordGameModel listOfQuestion =
            listQuestions[controller.indexQues.value];

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/bg.png",
                fit: BoxFit.cover,
              ),
            ),
            const BallWidget(),

            //? Question section
            Container(
              margin: const EdgeInsets.only(bottom: 300),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Text(
                listOfQuestion.question,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //? From input the word section
            Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      children: List.generate(
                        listOfQuestion.answer.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 40,
                          child: TextField(
                            onTap: null,
                            readOnly: true,
                            controller: controller.controllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            //? Buttons section
            Align(
              child: Container(
                margin: const EdgeInsets.only(top: 600),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 8,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: controller.buttons.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.containderBorder,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(
                                    constraints.biggest.width,
                                    constraints.biggest.height,
                                  ),
                                ),
                                child: Text(
                                  controller.buttons[index].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  controller
                                      .addCharacter(controller.buttons[index]);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
