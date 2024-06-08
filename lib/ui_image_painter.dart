import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class UIImagePainter extends CustomPainter {
  final ui.Image image;

  UIImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double imageRatio = image.width / image.height;
    final double canvasRatio = size.width / size.height;

    Rect src;
    if (imageRatio > canvasRatio) {
      // Image is wider than canvas, so cut off the left and right sides
      final double excessWidth = image.height * canvasRatio;
      final double offsetX = (image.width - excessWidth) / 2;
      src = Rect.fromLTWH(offsetX, 0, excessWidth, image.height.toDouble());
    } else {
      // Image is taller than canvas, so cut off the top and bottom
      final double excessHeight = image.width / canvasRatio;
      final double offsetY = (image.height - excessHeight) / 2;
      src = Rect.fromLTWH(0, offsetY, image.width.toDouble(), excessHeight);
    }

    final Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
