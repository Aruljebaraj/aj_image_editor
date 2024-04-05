import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Map<String, dynamic>>> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (var pointList in points) {
      if (pointList.isNotEmpty) {
        Paint paint = Paint();
        for (int i = 0; i < pointList.length - 1; i++) {
          final currentPoint = pointList[i];
          final nextPoint = pointList[i + 1];
          if (currentPoint['position'] != null &&
              nextPoint['position'] != null) {
            if (currentPoint['text'] != null) {
              // Draw text
              TextSpan span = TextSpan(
                text: currentPoint['text'],
                style: TextStyle(
                  color: currentPoint['color'],
                  fontSize: 16.0,
                ),
              );
              TextPainter tp = TextPainter(
                text: span,
                textDirection: TextDirection.ltr,
              );
              tp.layout();
              tp.paint(
                canvas,
                currentPoint['position'],
              );
            } else {
              paint.color = currentPoint['color'];
              paint.strokeCap = StrokeCap.square;
              if (currentPoint['size'] != null) {
                paint.strokeWidth = currentPoint['size'];
              }
              canvas.drawLine(
                currentPoint['position'],
                nextPoint['position'],
                paint,
              );
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
