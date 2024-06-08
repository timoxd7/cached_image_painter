import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImagePainterWidget extends StatefulWidget {
  const ImagePainterWidget(
      {super.key,
      required this.imageBytes,
      this.precachedImage,
      this.onImageLoaded});

  final Uint8List imageBytes;
  final ui.Image? precachedImage;
  final void Function(ui.Image)? onImageLoaded;

  @override
  State<ImagePainterWidget> createState() => _ImagePainterWidgetState();

  static Future<ui.Image> loadImage(Uint8List imgBytes,
      {final Function(ui.Image)? onDone}) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      if (onDone != null) {
        onDone(img);
      }

      completer.complete(img);
    });

    return completer.future;
  }
}

class _ImagePainterWidgetState extends State<ImagePainterWidget> {
  ui.Image? _image;

  @override
  void initState() {
    if (widget.precachedImage != null) {
      _image = widget.precachedImage;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return CustomPaint(
        painter: _ImagePainter(_image!),
        size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
      );
    }

    // Load image
    ImagePainterWidget.loadImage(widget.imageBytes, onDone: (ui.Image img) {
      if (mounted) {
        setState(() {
          _image = img;
          if (widget.onImageLoaded != null) {
            widget.onImageLoaded!(img);
          }
        });
      }
    });

    return const Placeholder();
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;

  _ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    double imageRatio = image.width / image.height;
    double canvasRatio = size.width / size.height;

    Rect src;
    if (imageRatio > canvasRatio) {
      // Image is wider than canvas, so cut off the left and right sides
      double excessWidth = image.height * canvasRatio;
      double offsetX = (image.width - excessWidth) / 2;
      src = Rect.fromLTWH(offsetX, 0, excessWidth, image.height.toDouble());
    } else {
      // Image is taller than canvas, so cut off the top and bottom
      double excessHeight = image.width / canvasRatio;
      double offsetY = (image.height - excessHeight) / 2;
      src = Rect.fromLTWH(0, offsetY, image.width.toDouble(), excessHeight);
    }

    Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
