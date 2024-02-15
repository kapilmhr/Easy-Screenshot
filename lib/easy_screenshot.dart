library easy_screenshot;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class EasyScreenshotController {
  late GlobalKey _screenKey;

  EasyScreenshotController() {
    _screenKey = GlobalKey();
  }

  Future<File> capture() async {
    final tempDirectory = await getTemporaryDirectory();

    Uint8List _image = await _captureAsImage();
    File file = await File('$tempDirectory/easyscreenshot.png').create();
    file.writeAsBytesSync(_image);
    return file;
  }

  Future<Uint8List> _captureAsImage() async {
    RenderRepaintBoundary boundary =
        _screenKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    try {
      var _image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? _byteData =
          await _image.toByteData(format: ImageByteFormat.png);
      Uint8List _uint8List = _byteData!.buffer.asUint8List();
      return _uint8List;
    } on Exception {
      rethrow;
    }
  }
}

class EasyScreenshot extends StatefulWidget {
  final Widget child;
  final EasyScreenshotController controller;

  const EasyScreenshot(
      {super.key, required this.controller, required this.child});

  @override
  State<EasyScreenshot> createState() => _EasyScreenshotState();
}

class _EasyScreenshotState extends State<EasyScreenshot> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.controller._screenKey,
      child: widget.child,
    );
  }
}
