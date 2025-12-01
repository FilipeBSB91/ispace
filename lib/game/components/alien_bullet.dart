import 'package:flame/components.dart';
import 'dart:ui';

// Classe da bala do alien
class AlienBullet extends RectangleComponent {
  AlienBullet({required Vector2 position}) {
    size = Vector2(6, 12); // Tamanho da bala
    this.position = position; // Posição inicial
    paint = Paint()..color = Color(0xFF00FF00); // Cor verde
  }
}