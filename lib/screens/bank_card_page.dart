import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_x/controllers/bank_card_contoller.dart';
import 'package:get_x/models/bank_card.dart';

class BankCardPage extends StatelessWidget {
  final BankCardController controller = Get.put(BankCardController());

  BankCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Cards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.separated(
                  itemCount: controller.cards.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final card = controller.cards[index];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.card_giftcard),
                              Text(
                                card.cvv,
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.removeCard(index);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  _showEditCardDialog(context, index);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatCardNumber(card.cardNumber),
                                style: const TextStyle(fontSize: 22),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    card.cardHolderName,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    card.expiryDate,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () => _showAddCardBottomSheet(context),
              child: const Text('Add Card'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCardDialog(BuildContext context, int index) {
    final card = controller.cards[index];
    final TextEditingController cardNumberController =
        TextEditingController(text: card.cardNumber);
    final TextEditingController cardHolderNameController =
        TextEditingController(text: card.cardHolderName);
    final TextEditingController expiryDateController =
        TextEditingController(text: card.expiryDate);
    final TextEditingController cvvController =
        TextEditingController(text: card.cvv);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Card'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter()
                  ],
                ),
                TextField(
                  controller: cardHolderNameController,
                  decoration:
                      const InputDecoration(labelText: 'Card Holder Name'),
                ),
                TextField(
                  controller: expiryDateController,
                  decoration:
                      const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                ),
                TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedCard = BankCard(
                  cardNumber: cardNumberController.text,
                  cardHolderName: cardHolderNameController.text,
                  expiryDate: expiryDateController.text,
                  cvv: cvvController.text,
                );
                controller.editCard(updatedCard, index);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _formatCardNumber(String cardNumber) {
    final cleanedNumber = cardNumber.replaceAll(RegExp(r'\D'), '');

    final buffer = StringBuffer();
    for (int i = 0; i < cleanedNumber.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(cleanedNumber[i]);
    }

    return buffer.toString();
  }

  void _showAddCardBottomSheet(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController cardHolderNameController =
        TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter()
                ],
              ),
              TextField(
                controller: cardHolderNameController,
                decoration:
                    const InputDecoration(labelText: 'Card Holder Name'),
              ),
              TextField(
                controller: expiryDateController,
                decoration:
                    const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
              ),
              TextField(
                controller: cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final card = BankCard(
                    cardNumber: cardNumberController.text,
                    cardHolderName: cardHolderNameController.text,
                    expiryDate: expiryDateController.text,
                    cvv: cvvController.text,
                  );
                  controller.addCard(card);
                  cardNumberController.clear();
                  cardHolderNameController.clear();
                  expiryDateController.clear();
                  cvvController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add Card'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
