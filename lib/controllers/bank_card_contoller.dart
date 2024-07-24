import 'package:get/get.dart';
import 'package:get_x/models/bank_card.dart';

class BankCardController extends GetxController {
  final cards = <BankCard>[].obs;

  void addCard(BankCard card) {
    cards.add(card);
  }

  void removeCard(int index) {
    cards.removeAt(index);
  }

  void editCard(BankCard newCard, int index) {
    cards[index] = newCard;
  }
}
