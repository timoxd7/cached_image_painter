# Instantly draw Images!

This is a simple Widget to cache Images before using any build method and instantly draw in new image widgets. Removes popping in of images.

## Why use this?

If using the Image widget from flutter, the image might pop in after some time, even if it was loaded directly from memory using `Uint8List`.

This simple Widget works around this by using a canvas and draws the image directly on there. It also provides you with some helper to easily load the image before any build method was called.

## How to use

### 1. First cache, then display

Somewhere in your code, load the Image using

    // Buildup futures of images
    final Future<ui.Image> imageFuture =
        rootBundle.load("assets/your_image.png").then((value) {
      return value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
    }).then((raw) {
      // -> Got the raw bytes, now convert the bytes to ui.Image
      return ImageLoader.load(raw);
    });

    ui.Image image = await imageFuture;

`await` the future somewhere and then use the following to display the image

    PrecachedImagePainter(
        precachedImage: imageFuture,
    )

### 2. Display and cache at the same time

> NOTE: this will still pop your image in on the first build, however later not

Use the following in your widget tree. As long as the parent widget is alive, the image will be cached (e.g. for slideshows or so).

    ui.Image? precachedImage;

    // ...

    ImagePainter(
        imageBytes: YOUR_IMAGE_BYTES,
        placeholder: SOME_PLACEHOLDER_WIDGET,
        precachedImage: precachedImage,
        onImageLoaded: (processedImage) {
            if (mounted) {
                setState(() {
                    precachedImage = processedImage
                });
            }
        },
    )

The `YOUR_IMAGE_BYTES` can be a picture loaded from the assets, file or network.
The `SOME_PLACEHOLDER_WIDGET` is displayed while loading the image.

After loading once after first build, the image will be stored in `precachedImage` variable.

## TODO Global image cache

Planned for the future is a global cache which loads all needed images after starting the app, in the background, _async_. Then, this image is simply given to a widget which can immediately show the image, without popping in.
