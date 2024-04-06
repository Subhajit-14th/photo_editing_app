// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:photo_editing_app/view/Widgets/colorFilter_Brightness.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  File? _editedImage;
  final picker = ImagePicker();
  Uint8List? imageData;
  double _brightnessValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Editing App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _image = null;
              setState(() {});
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: _image == null
          ? Theme(
              data: ThemeData(
                splashColor: Colors.white,
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {
                  _pickImage();
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: _image == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.add_a_photo_rounded,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: Text('Select a photo from gellary'),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Column(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(
                      ColorFilterGenerator.brightnessAdjustMatrix(
                    value: _brightnessValue,
                  )),
                  child: Image.file(_image!),
                ),
                _image != null
                    ? Expanded(
                        child: AnimatedContainer(
                          // height: _image != null ? MediaQuery.of(context).size.height * 0.4 : 0,
                          color: Colors.amber,
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            children: [
                              Slider(
                                value: _brightnessValue,
                                min: -1.0,
                                max: 1.0,
                                onChanged: (value) {
                                  _adjustBrightness(value);
                                },
                              ),
                              Text("$_brightnessValue"),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
      floatingActionButton: _image != null
          ? FloatingActionButton(
              onPressed: saveImage,
              child: const Icon(
                Icons.save_alt_rounded,
              ),
            )
          : const SizedBox(),
    );
  }

  /// For picking an image from gellary
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _editedImage = File(pickedFile.path);
      }
    });
  }

  /// for chnaging the brightness
  void _applyBrightness(value) async {
    if (_editedImage == null) return;

    imageData = await fileToUint8List(_image!);

    img.Image image = img.decodeImage(_editedImage!.readAsBytesSync())!;

    // Adjust brightness
    image = img.adjustColor(image, brightness: value);

    setState(() {});
  }

  // For adjust brightness of the photo
  void _adjustBrightness(double value) {
    setState(() {
      _brightnessValue = value;
    });
  }

  Future<ByteData?> fileToByteData(File filePath) async {
    try {
      // File file = File(filePath);
      if (await filePath.exists()) {
        List<int> bytes = await filePath.readAsBytes();
        return ByteData.view(Uint8List.fromList(bytes).buffer);
      } else {
        print('File does not exist');
        return null;
      }
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }

  // For save the copy
  Future<void> saveImage() async {
    if (_editedImage != null) {
      imageData = await fileToUint8List(_editedImage!);

      // Decode image

      img.Image? image = img.decodeImage(imageData!);

      // Adjust brightness
      image = img.adjustColor(image!, brightness: _brightnessValue);

      // Convert to Uint8List
      Uint8List bytes = Uint8List.fromList(img.encodePng(image));

      setState(() {});
      // Save image to gallery
      var res = await ImageGallerySaver.saveImage(bytes);

      if (res['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo saved in gallery'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo is not saved'),
          ),
        );
      }

      debugPrint('Res print: ${res['isSuccess']}');
    }
  }

  Future<Uint8List> fileToUint8List(File file) async {
    // Read the file as bytes
    List<int> bytes = await file.readAsBytes();

    // Convert the bytes to Uint8List
    Uint8List uint8List = Uint8List.fromList(bytes);
    setState(() {});
    return uint8List;
  }
}
