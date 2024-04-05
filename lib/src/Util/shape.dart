import 'package:flutter/material.dart';

import '../Enum/shape_type.dart';

class Shape {
  double left;
  double top;
  double width;
  double height;
  ShapeType type;
  bool isDraggable;
  Color color;
  Shape({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.type,
    required this.color,
    required this.isDraggable,
  });
}
