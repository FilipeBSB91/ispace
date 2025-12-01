import 'package:flame/components.dart';
import 'dart:ui';

// Classe do jogador (nave)
class Player extends RectangleComponent {
  Player({required Vector2 position}) {
    size = Vector2(50, 30); // Tamanho da nave
    this.position = position; // Posição inicial
    paint = Paint()..color = Color(0xFF0000FF); // Cor azul
  }

  @override
  void render(Canvas canvas) {
 
    // Corpo da nave (triângulo)
    final path = Path()
      ..moveTo(size.x / 2, 0) // Ponto superior (bico)
      ..lineTo(10, size.y) // Ponto inferior esquerdo
      ..lineTo(size.x - 10, size.y) // Ponto inferior direito
      ..close(); // Fecha o triângulo
    
    final shipPaint = Paint()..color = Color(0xFF2196F3);
    canvas.drawPath(path, shipPaint);
    
  }
}