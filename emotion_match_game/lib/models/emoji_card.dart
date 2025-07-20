class EmojiCard {
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  EmojiCard({
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
