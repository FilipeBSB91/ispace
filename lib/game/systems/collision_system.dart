import 'package:flame/components.dart';

// Sistema dedicado para verificar colisões
class CollisionSystem {
  // Verifica colisão entre dois componentes (método AABB - Axis Aligned Bounding Box)
  static bool checkCollision(PositionComponent a, PositionComponent b) {
    return a.position.x < b.position.x + b.size.x &&
           a.position.x + a.size.x > b.position.x &&
           a.position.y < b.position.y + b.size.y &&
           a.position.y + a.size.y > b.position.y;
  }

  // Verifica colisão entre uma bala e uma lista de aliens
  static bool checkBulletCollision(PositionComponent bullet, List aliens) {
    for (final alien in List.from(aliens)) {
      if (checkCollision(bullet, alien)) {
        alien.removeFromParent(); // Remove alien do jogo
        aliens.remove(alien); // Remove da lista
        return true; // Retorna true indicando colisão
      }
    }
    return false; // Nenhuma colisão
  }
}