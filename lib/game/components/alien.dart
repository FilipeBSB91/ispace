import 'package:flame/components.dart';
import 'dart:ui';

// Classe do alien
class Alien extends RectangleComponent {
  Alien({required Vector2 position}) {
    size = Vector2(30, 30); // Tamanho do alien
    this.position = position; // Posição inicial
    paint = Paint()..color = Color(0xFF00FF00); // Cor verde
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Desenha retângulo de fundo
    
    // Cabeça do alien (círculo)
    final headPaint = Paint()..color = Color(0xFF00FF00);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 12, headPaint);
    
    // Olhos
    final eyePaint = Paint()..color = Color.fromARGB(255, 0, 0, 0);
    canvas.drawCircle(Offset(size.x / 2 - 6, size.y / 2 - 4), 3, eyePaint);
    canvas.drawCircle(Offset(size.x / 2 + 6, size.y / 2 - 4), 3, eyePaint);
    // Boca
    final mouthPaint = Paint()
      ..color = Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.x / 2 - 5, size.y / 2 + 6),
      Offset(size.x / 2 + 5, size.y / 2 + 6),
      mouthPaint,
    );
  }
}