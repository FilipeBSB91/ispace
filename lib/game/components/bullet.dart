import 'package:flame/components.dart';
import 'dart:ui';

// Classe da bala do jogador
class Bullet extends RectangleComponent {
  Bullet({required Vector2 position}) {
    size = Vector2(6, 12); // Tamanho da bala
    this.position = position; // Posição inicial
    paint = Paint()..color = Color(0xFF2196F3); // Cor azul
  }

  @override
  void render(Canvas canvas) {

    super.render(canvas); // Desenha a bala principal
  }
}