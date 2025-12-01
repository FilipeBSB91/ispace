import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'components/player.dart';
import 'components/alien.dart';
import 'components/bullet.dart';
import 'components/alien_bullet.dart';
import 'systems/collision_system.dart';
import 'systems/game_state.dart';

// Classe principal do jogo que estende FlameGame
class SpaceGame extends FlameGame {
  late Player player; // Instância do jogador
  final List<Bullet> bullets = []; // Lista de balas do jogador
  final List<Alien> aliens = []; // Lista de aliens
  final List<AlienBullet> alienBullets = []; // Lista de balas dos aliens
  final GameState gameState = GameState(); // Gerenciador de estado do jogo
  
  // CONFIGURAÇÕES DE TAMANHO DA TELA E MARGENS
  final double gameWidth = 800; // Largura fixa da tela do jogo
  final double gameHeight = 600; // Altura fixa da tela do jogo
  
  final double leftMargin = 20; // Margem esquerda
  final double rightMargin = 20; // Margem direita 
  final double topMargin = 50; // Margem superior
  final double bottomMargin = 100; // Margem inferior 
  
  double alienDirection = 1; // Direção do movimento dos aliens (1 = direita, -1 = esquerda)
  final double alienSpeed = 100; // Velocidade dos aliens
  double alienShootTimer = 0; // Temporizador para tiros dos aliens
  final double alienShootInterval = 0.5; // Intervalo entre tiros dos aliens
  double playerShootCooldown = 0; // Cooldown para tiros do jogador
  final double playerShootDelay = 0.5; // Delay entre tiros do jogador
  
  // Callbacks para atualizar a UI
  final VoidCallback? onScoreUpdate;
  final VoidCallback? onLivesUpdate;
  final VoidCallback? onGameOver;

  SpaceGame({this.onScoreUpdate, this.onLivesUpdate, this.onGameOver});

  // Getters para acessar estado do jogo
  int get score => gameState.score;
  int get lives => gameState.lives;
  bool get gameOver => gameState.gameOver;

  // Getter que retorna a área jogável dentro das margens
  Rect get playableArea {
    return Rect.fromLTRB(
      leftMargin, // Limite esquerdo
      topMargin, // Limite superior
      gameWidth - rightMargin, // Limite direito
      gameHeight - bottomMargin, // Limite inferior
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Cria o jogador na posição inicial (considerando margens)
    player = Player(
      position: Vector2(
        gameWidth / 2 - 25, // Centralizado horizontalmente
        gameHeight - bottomMargin - 30, // Posicionado acima da margem inferior
      ),
    );
    
    add(player); // Adiciona o jogador ao jogo
    _createAliens(); // Cria a formação de aliens
  }



  // Manipula entrada de teclado
  void handleKey(LogicalKeyboardKey key, Function restartCallback) {
    if (gameState.gameOver) {
      // Se o jogo acabou, só permite reiniciar com 'R'
      if (key == LogicalKeyboardKey.keyR) {
        restartCallback();
      }
      return;
    }
    
    // Obtém os limites da área jogável
    final area = playableArea;
    
    // Controles do jogador durante o jogo
    switch (key) {
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        // Move jogador para esquerda com limite na margem esquerda
        player.position.x -= 10;
        if (player.position.x < area.left) player.position.x = area.left;
        break;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        // Move jogador para direita com limite na margem direita
        player.position.x += 10;
        if (player.position.x > area.right - player.size.x) {
          player.position.x = area.right - player.size.x;
        }
        break;
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.keyZ:
        // Dispara bala se não estiver em cooldown
        if (playerShootCooldown <= 0) {
          _shoot();
          playerShootCooldown = playerShootDelay;
        }
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameState.gameOver) return; // Pausa atualização se jogo acabou
    
    // Atualiza cooldown do tiro do jogador
    if (playerShootCooldown > 0) {
      playerShootCooldown -= dt;
    }
    
    // Atualiza posição das balas do jogador e verifica colisões
    for (final bullet in List.from(bullets)) {
      bullet.position.y -= 300 * dt; // Move bala para cima
      
      // Verifica colisão com aliens
      if (CollisionSystem.checkBulletCollision(bullet, aliens)) {
        _handleAlienHit(bullet);
        break;
      }
      
      // Remove bala se sair da área jogável (passar da margem superior)
      if (bullet.position.y < topMargin - bullet.size.y) {
        bullet.removeFromParent();
        bullets.remove(bullet);
      }
    }
    
    // Atualiza posição das balas dos aliens e verifica colisões
    for (final bullet in List.from(alienBullets)) {
      bullet.position.y += 150 * dt; // Move bala para baixo
      
      // Verifica colisão com jogador
      if (CollisionSystem.checkCollision(bullet, player)) {
        _handlePlayerHit(bullet);
        break;
      }
      
      // Remove bala se sair da área jogável (passar da margem inferior)
      if (bullet.position.y > gameHeight - bottomMargin) {
        bullet.removeFromParent();
        alienBullets.remove(bullet);
      }
    }
    
    _updateAliens(dt); // Atualiza movimento dos aliens
    
    // Controle de tiros dos aliens
    alienShootTimer += dt;
    if (alienShootTimer >= alienShootInterval && aliens.isNotEmpty) {
      _alienShoot();
      alienShootTimer = 0;
    }
    
    _checkGameOver(); // Verifica condições de fim de jogo
  }

  // Cria a formação inicial de aliens
  void _createAliens() {
    const int rows = 3; // Número de linhas de aliens
    const int cols = 8; // Número de colunas de aliens
    const double spacing = 60; // Espaçamento entre aliens
    
    // Calcula posição inicial para centralizar os aliens dentro das margens
    final double availableWidth = gameWidth - leftMargin - rightMargin;
    final double alienGridWidth = (cols - 1) * spacing + 30;
    final double startX = leftMargin + (availableWidth - alienGridWidth) / 2;
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final alien = Alien(
          position: Vector2(
            startX + col * spacing, // Posição X dentro das margens
            topMargin + 30 + row * spacing, // Posição Y dentro das margens
          ),
        );
        add(alien); // Adiciona alien ao jogo
        aliens.add(alien); // Adiciona à lista de aliens
      }
    }
  }

  // Atualiza movimento dos aliens
  void _updateAliens(double dt) {
    // Move todos os aliens na direção atual
    for (final alien in aliens) {
      alien.position.x += alienSpeed * alienDirection * dt;
    }
    
    bool changeDirection = false; // Flag para mudar direção
    double leftMost = gameWidth; // Alien mais à esquerda
    double rightMost = 0; // Alien mais à direita
    
    // Encontra aliens mais à esquerda e direita
    for (final alien in aliens) {
      if (alien.position.x < leftMost) leftMost = alien.position.x;
      if (alien.position.x > rightMost) rightMost = alien.position.x;
    }
    
    // Obtém os limites da área jogável
    final area = playableArea;
    
    // Verifica se precisa mudar direção (atingiu margens laterais)
    if (leftMost <= area.left && alienDirection < 0) {
      changeDirection = true;
    }
    if (rightMost >= area.right - 30 && alienDirection > 0) {
      changeDirection = true;
    }
    
    // Se precisa mudar direção, inverte e desce
    if (changeDirection) {
      alienDirection *= -1;
      for (final alien in aliens) {
        alien.position.y += 20; // Desce uma linha
      }
    }
  }

  // Faz um alien atirar
  void _alienShoot() {
    if (aliens.isEmpty) return;
    
    // Escolhe alien aleatório para atirar
    final randomAlien = aliens[DateTime.now().millisecond % aliens.length];
    final bullet = AlienBullet(
      position: Vector2(
        randomAlien.position.x + randomAlien.size.x / 2 - 1.5, // Centro do alien
        randomAlien.position.y + randomAlien.size.y, // Base do alien
      ),
    );
    
    add(bullet); // Adiciona bala ao jogo
    alienBullets.add(bullet); // Adiciona à lista de balas
  }

  // Trata colisão de bala com alien
  void _handleAlienHit(Bullet bullet) {
    bullet.removeFromParent(); // Remove bala
    bullets.remove(bullet); // Remove da lista
    gameState.addScore(10); // Adiciona pontos
    onScoreUpdate?.call(); // Notifica UI
  }

  // Trata colisão de bala com jogador
  void _handlePlayerHit(AlienBullet bullet) {
    bullet.removeFromParent(); // Remove bala
    alienBullets.remove(bullet); // Remove da lista
    gameState.loseLife(); // Remove vida
    
    if (gameState.lives <= 0) {
      gameState.setGameOver(); // Fim de jogo se vidas acabarem
      onGameOver?.call(); // Notifica UI
    } else {
      onLivesUpdate?.call(); // Atualiza display de vidas
    }
  }

  // Verifica condições de fim de jogo
  void _checkGameOver() {
    // Fim de jogo se vidas acabarem
    if (gameState.lives <= 0) {
      gameState.setGameOver();
      onGameOver?.call();
      return;
    }
    
    // Fim de jogo se aliens chegarem muito perto do jogador 
    for (final alien in aliens) {
      if (alien.position.y >= gameHeight - bottomMargin - 50) {
        gameState.setGameOver();
        onGameOver?.call();
        return;
      }
    }
    
    // Se todos aliens forem destruídos, cria nova leva
    if (aliens.isEmpty) {
      gameState.addScore(100); // Bônus por limpar leva
      onScoreUpdate?.call();
      _createAliens(); // Cria nova formação
    }
  }

  // Jogador atira
  void _shoot() {
    final bullet = Bullet(
      position: Vector2(
        player.position.x + player.size.x / 2 - 2, // Centro da nave
        player.position.y - 10, // Acima da nave
      ),
    );
    
    add(bullet); // Adiciona bala ao jogo
    bullets.add(bullet); // Adiciona à lista
  }
}