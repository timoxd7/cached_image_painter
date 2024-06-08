import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_image_painter/image_loader.dart';
import 'package:cached_image_painter/precached_image_painter.dart';
import 'package:flutter/material.dart';

class ImagePainter extends StatefulWidget {
  /// Create an [ImagePainter] that loads an image from a byte array.
  /// The [onImageLoaded] callback is called when the image is loaded.
  /// The [placeholder] widget is displayed while the image is loading.
  /// Optionally a [precachedImage] can be provided to display the image
  /// directly without altering the calling widget between caching.
  const ImagePainter({
    super.key,
    required this.imageBytes,
    required this.placeholder,
    this.precachedImage,
    this.onImageLoaded,
  });

  final Uint8List imageBytes;
  final Widget placeholder;
  final ui.Image? precachedImage;
  final void Function(ui.Image)? onImageLoaded;

  @override
  State<ImagePainter> createState() => _ImagePainterState();
}

class _ImagePainterState extends State<ImagePainter> {
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
    // If image is loaded (or was precached), directly display it
    if (_image != null) {
      return PrecachedImagePainter(precachedImage: _image!);
    }

    // Otherwise, generate image from bytes. Operation can only be async, as
    // the dart api can only be executed in async mode.
    ImageLoader.load(widget.imageBytes!, onDone: (ui.Image img) {
      if (mounted) {
        setState(() {
          _image = img;
          if (widget.onImageLoaded != null) {
            widget.onImageLoaded!(img);
          }
        });
      }
    });

    return widget.placeholder!;
  }
}
