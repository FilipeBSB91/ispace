import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Invaders',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            width: 800, // Largura do jogo
            height: 600, // Altura do jogo
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: GameScreen(),
          ),
        ),
      ),
    );
  }
}