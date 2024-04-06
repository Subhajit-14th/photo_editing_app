import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:photo_editing_app/controller/commonFun/CommonFun.dart';
import 'package:photo_editing_app/model/crop&cutImageAspectRatioModel.dart';
import 'package:photo_editing_app/view/CropImage/src/crop_image.dart';
import 'package:photo_editing_app/view/CropImage/src/src/crop_controller.dart';
import 'package:photo_editing_app/view/CropImage/src/src/crop_image.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../controller/commonFun/commonColors.dart';
import '../../controller/provider/imageProvider.dart';
import 'dart:ui' as ui;

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({super.key});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  List<CropAndCutAspectRatioModel> aspectRatioNumbers = [];

  final cropImageController = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  void initState() {
    super.initState();
    loadAspectRatioNumbers();
  }

  loadAspectRatioNumbers() {
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: '2:1'));
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: '1:2'));
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: '4:3'));
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: '16:9'));
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: 'Free'));
    aspectRatioNumbers.add(CropAndCutAspectRatioModel(ratio: 'Square'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.darkColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_rounded,
            ),
          ),
          title: const Text(
            'Crop',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                ui.Image bitmap = await cropImageController.croppedBitmap();
                Image image = await cropImageController.croppedImage();
                ByteData? data =
                    await bitmap.toByteData(format: ImageByteFormat.png);
                Uint8List bytes = data!.buffer.asUint8List();
                if (mounted) {
                  context.read<AppImageProvider>().changeImage(bytes);
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.done_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<AppImageProvider>(
              builder: (context, provider, child) {
                debugPrint('Image isss: ${provider.currentImage}');
                if (provider.currentImage != null) {
                  return Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      // width: getScreenWidth(context) / 1.2,
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          ),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(10),
                        child: CropImage(
                          controller: cropImageController,
                          image: Image.memory(
                            provider.currentImage!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: getScreenHeight(context) * 0.2,
          padding: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: AppColor.greyColor.withOpacity(.16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                child: ListView.builder(
                  itemCount: aspectRatioNumbers.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (aspectRatioNumbers[index].ratio == '2:1') {
                          cropImageController.aspectRatio = 2.0;
                        } else if (aspectRatioNumbers[index].ratio == '1:2') {
                          cropImageController.aspectRatio = 1 / 2;
                        } else if (aspectRatioNumbers[index].ratio == '4:3') {
                          cropImageController.aspectRatio = 4.0 / 3.0;
                        } else if (aspectRatioNumbers[index].ratio == '16:9') {
                          cropImageController.aspectRatio = 16.0 / 9.0;
                        } else if (aspectRatioNumbers[index].ratio == 'Free') {
                          cropImageController.aspectRatio = null;
                        } else {
                          cropImageController.aspectRatio = 1;
                        }
                        cropImageController.crop =
                            const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: Text(
                            aspectRatioNumbers[index].ratio,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: _rotateLeft,
                    icon: const Icon(
                      Icons.rotate_90_degrees_ccw_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.cut_rounded,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _rotateRight,
                    icon: const Icon(
                      Icons.rotate_90_degrees_cw_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _rotateLeft() async => cropImageController.rotateLeft();

  Future<void> _rotateRight() async => cropImageController.rotateRight();
}
