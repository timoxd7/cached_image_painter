import 'dart:ui' as ui;

import 'package:cached_image_painter/ui_image_painter.dart';
import 'package:flutter/material.dart';

/// A widget that paints a precached image. The image is painted immediately
/// after the widget is built (without popping in).
/// Use ImageLoader.load() to precache an image or generate it yourself.
class PrecachedImagePainter extends StatelessWidget {
  /// Create a [PrecachedImagePainter] that uses a precached image.
  /// Image will be displayed immediately after the widget is built (without
  /// popping in).
  const PrecachedImagePainter({
    super.key,
    required this.precachedImage,
  });

  final ui.Image precachedImage;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: UIImagePainter(precachedImage),
      size: Size(
          precachedImage.width.toDouble(), precachedImage.height.toDouble()),
    );
  }
}
