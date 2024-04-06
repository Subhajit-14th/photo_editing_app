import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

AppImageProvider appImageProvider = AppImageProvider();

class AppImageProvider extends ChangeNotifier {
  Uint8List? currentImage;

  savedImage(File image) {
    currentImage = image.readAsBytesSync();
    debugPrint("Provider image is: ${currentImage!}");
    notifyListeners();
  }

  changeImage(Uint8List image) {
    currentImage = image;
    debugPrint("Provider image is: ${currentImage!}");
    notifyListeners();
  }

  void reset() {
    currentImage = null;
    notifyListeners();
  }
}
