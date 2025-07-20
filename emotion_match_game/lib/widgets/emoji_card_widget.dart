import 'package:flutter/material.dart';
import '../models/emoji_card.dart';

class EmojiCardWidget extends StatelessWidget {
  final EmojiCard card;
  final VoidCallback onTap;

  const EmojiCardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.transparent
              : card.isFlipped
                  ? Colors.white
                  : Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: card.isMatched
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  )
                ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Image.asset(card.imagePath, width: 60, height: 60)
              : const Icon(Icons.question_mark, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}
