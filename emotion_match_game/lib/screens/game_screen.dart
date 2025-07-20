import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

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

class GameScreen extends StatefulWidget {
  final int cardCount;

  const GameScreen({super.key, required this.cardCount});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<EmojiCard> cards = [];
  int? firstIndex;
  int? secondIndex;
  bool isBusy = false;

  late ConfettiController _confettiController;
  late AudioPlayer _audioPlayer;

  final List<String> allEmojis = [
    'assets/images/happy.png',
    'assets/images/sad.png',
    'assets/images/angry.png',
    'assets/images/surprised.png',
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _playBgm();
    setupGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBgm() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/bgm-game.mp3'));
  }

  void setupGame() {
    final random = Random();
    List<String> selectedImages = [];

    while (selectedImages.length < widget.cardCount ~/ 2) {
      String emoji = allEmojis[random.nextInt(allEmojis.length)];
      if (!selectedImages.contains(emoji)) {
        selectedImages.add(emoji);
      }
    }

    List<EmojiCard> tempCards = [];
    for (String img in selectedImages) {
      tempCards.add(EmojiCard(imagePath: img));
      tempCards.add(EmojiCard(imagePath: img));
    }

    tempCards.shuffle();

    setState(() {
      cards = tempCards;
      firstIndex = null;
      secondIndex = null;
      isBusy = false;
    });
  }

  void onCardTap(int index) {
    if (isBusy || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() {
      cards[index].isFlipped = true;

      if (firstIndex == null) {
        firstIndex = index;
      } else if (secondIndex == null && index != firstIndex) {
        secondIndex = index;
        isBusy = true;
        checkMatch();
      }
    });
  }

  void checkMatch() {
    if (cards[firstIndex!].imagePath == cards[secondIndex!].imagePath) {
      setState(() {
        cards[firstIndex!].isMatched = true;
        cards[secondIndex!].isMatched = true;
        firstIndex = null;
        secondIndex = null;
        isBusy = false;
      });

      if (cards.every((card) => card.isMatched)) {
        _confettiController.play();

        Future.delayed(const Duration(milliseconds: 600), () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text("🎉 Game Completed!"),
              content: const Text("Do you want to play again?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setupGame();
                    });
                  },
                  child: const Text("Restart"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("Exit"),
                ),
              ],
            ),
          );
        });
      }
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          cards[firstIndex!].isFlipped = false;
          cards[secondIndex!].isFlipped = false;
          firstIndex = null;
          secondIndex = null;
          isBusy = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const cardSpacing = 12;
    const minCardSize = 100;
    int possibleCount = (screenWidth / (minCardSize + cardSpacing)).floor();

    int crossAxisCount = possibleCount;
    while (widget.cardCount % crossAxisCount != 0 && crossAxisCount > 1) {
      crossAxisCount--;
    }

    if (crossAxisCount < 2) crossAxisCount = 2;

    return Scaffold(
      appBar: AppBar(title: const Text("🎮 Emotion Match")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: cards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: card.isFlipped || card.isMatched
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(card.imagePath),
                            )
                          : const Icon(Icons.help_outline_rounded,
                              size: 40, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
