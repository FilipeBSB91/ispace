// Sistema que gerencia o estado do jogo
class GameState {
  int _score = 0; // Pontuação atual
  int _lives = 10; // Vidas restantes
  bool _gameOver = false; // Estado do jogo

  int get score => _score;
  int get lives => _lives;
  bool get gameOver => _gameOver;

  void addScore(int points) {
    _score += points; // Adiciona pontos à pontuação
  }

  void loseLife() {
    _lives--; // Remove uma vida
  }

  void setGameOver() {
    _gameOver = true; // Marca jogo como terminado
  }

  void reset() {
    _score = 0; // Zera pontuação
    _lives = 10; // Reseta vidas
    _gameOver = false; // Reinicia estado do jogo
  }
}