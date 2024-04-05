import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  Color selectedColor;

  TrianglePainter({required this.selectedColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = selectedColor;
    paint.strokeWidth = 2.0;
    paint.style = PaintingStyle.stroke;
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
