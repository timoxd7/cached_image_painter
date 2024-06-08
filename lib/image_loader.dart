import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageLoader {
  static Future<ui.Image> load(Uint8List imgBytes,
      {final Function(ui.Image)? onDone}) {
    // Create completer for later completion
    final Completer<ui.Image> completer = Completer();

    // Decode image from bytes, will run async and call callback later
    ui.decodeImageFromList(imgBytes, (ui.Image img) {
      // Report done if wished
      if (onDone != null) {
        onDone(img);
      }

      // Complete to return image future
      completer.complete(img);
    });

    return completer.future;
  }
}
