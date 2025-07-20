import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'game_screen.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playBGM();
  }

  void playBGM() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // loop the music
    await _audioPlayer.play(AssetSource('sounds/bgm-intro.mp3'));
  }

  void navigateToGame(BuildContext context, int cardCount) {
    _audioPlayer.stop(); // stop bgm when going to game
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(cardCount: cardCount),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // release the player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text(
          "🎯 Choose Difficulty",
          style: GoogleFonts.comicNeue(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background animation
          Align(
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/lottie/animation.json',
              height: 200,
              repeat: true,
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                difficultyButton(context, "Easy", 4, Colors.green, "🟢"),
                const SizedBox(height: 20),
                difficultyButton(context, "Medium", 6, Colors.orange, "🟠"),
                const SizedBox(height: 20),
                difficultyButton(context, "Hard", 8, Colors.red, "🔴"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget difficultyButton(BuildContext context, String label, int cards,
      Color color, String emoji) {
    return ElevatedButton.icon(
      onPressed: () => navigateToGame(context, cards),
      icon: Text(emoji, style: const TextStyle(fontSize: 24)),
      label: Text(
        "$label (${cards} Cards)",
        style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 6,
      ),
    );
  }
}
