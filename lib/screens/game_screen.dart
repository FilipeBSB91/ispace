import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import '../game/game.dart';

// Tela principal do jogo
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SpaceGame game; // Instância do jogo
  final FocusNode focusNode = FocusNode(); // Foco para capturar teclado

  @override
  void initState() {
    super.initState();
    // Inicializa o jogo com callbacks para atualizar UI
    game = SpaceGame(
      onScoreUpdate: _updateUI,
      onLivesUpdate: _updateUI,
      onGameOver: _updateUI,
    );
    focusNode.requestFocus(); // Solicita foco para capturar teclado
  }

  // Atualiza a interface quando estado do jogo muda
  void _updateUI() {
    setState(() {});
  }

  // Reinicia o jogo
  void _restartGame() {
    setState(() {
      game = SpaceGame( // Cria nova instância do jogo
        onScoreUpdate: _updateUI,
        onLivesUpdate: _updateUI,
        onGameOver: _updateUI,
      );
      focusNode.requestFocus(); // Solicita foco novamente
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto
      body: Stack(
        children: [
          // Widget para capturar entrada de teclado
          // ignore: deprecated_member_use
          RawKeyboardListener(
            focusNode: focusNode,
            autofocus: true,
            // ignore: deprecated_member_use
            onKey: (RawKeyEvent event) {
              // ignore: deprecated_member_use
              if (event is RawKeyDownEvent) {
                // Passa tecla pressionada para o jogo
                game.handleKey(event.logicalKey, _restartGame);
              }
            },
            child: Center( // Centraliza o jogo na tela (NOVO)
              child: SizedBox( // Container com tamanho fixo (NOVO)
                width: 800, // Largura fixa do jogo (deve corresponder ao gameWidth no SpaceGame)
                height: 600, // Altura fixa do jogo (deve corresponder ao gameHeight no SpaceGame)
                child: GameWidget( // Widget do Flame para renderizar o jogo
                  game: game,
                ),
              ),
            ),
          ),
          // Display de pontuação (canto superior esquerdo)
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              'SCORE: ${game.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Display de vidas (canto superior direito)
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              'VIDAS: ${game.lives}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Overlay de Game Over
          if (game.gameOver)
            Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.8), // Fundo semi-transparente
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Texto "GAME OVER"
                    const Text(
                      'GAME OVER',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Display da pontuação final
                    Text(
                      'Score: ${game.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Botão para jogar novamente
                    ElevatedButton(
                      onPressed: _restartGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'JOGAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'SISTEMAS PARA A INTERNET - IFB \n DESENVOVIMENTO PARA DISPOSITOVS MÓVEIS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose(); // Libera foco
    super.dispose();
  }
}