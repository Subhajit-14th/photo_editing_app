import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editing_app/controller/commonFun/CommonFun.dart';
import 'package:photo_editing_app/controller/commonFun/commonColors.dart';
import 'package:photo_editing_app/model/editItemsModels.dart';
import 'package:photo_editing_app/view/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../controller/provider/imageProvider.dart';
import '../CropImage/cropImage.dart';
import '../FilterImage/filterImageScreen.dart';

class EditorHomeScreen extends StatefulWidget {
  const EditorHomeScreen({super.key});

  @override
  State<EditorHomeScreen> createState() => _EditorHomeScreenState();
}

class _EditorHomeScreenState extends State<EditorHomeScreen> {
  List<EditItems> editItems = [];
  Uint8List? editedImage;
  String response = '';

  @override
  void initState() {
    super.initState();
    // addEditItems();
  }

  // addEditItems() {
  //   editItems.add(
  //     EditItems(icon: Icons.crop, title: 'Crop'),
  //   );
  //   editItems.add(
  //     EditItems(icon: Icons.photo_filter_rounded, title: 'Filter'),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.darkColor,
        appBar: AppBar(
          backgroundColor: AppColor.perfectDarkColor,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          leading: IconButton(
            onPressed: () {
              context.read<AppImageProvider>().reset();
            },
            icon: const Icon(
              Icons.home_filled,
            ),
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                if (editedImage != null) {
                  final Map<dynamic, dynamic> result =
                      await ImageGallerySaver.saveImage(editedImage!);
                  debugPrint('My saving response is: $result');
                  if (result['filePath'] != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Your photo is saved in gallery'),
                      behavior: SnackBarBehavior.floating,
                    ));
                  }
                }
                debugPrint(response);
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AppImageProvider>(
              builder: (context, provider, child) {
                if (provider.currentImage != null) {
                  editedImage = provider.currentImage;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.80,
                    width: double.infinity,
                    child: Image.memory(
                      provider.currentImage!,
                      fit: BoxFit.contain,
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
          height: 8.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColor.perfectDarkColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  openScreen(context, const CropImageScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.crop_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: const Text(
                          'Crop',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  openScreen(context, const FilterImageScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.photo_filter_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: const Text(
                          'Filter',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //   ListView.builder(
          //     itemCount: editItems.length,
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     padding: EdgeInsets.only(top: 2.h),
          //     physics: editItems.length > 5
          //         ? const BouncingScrollPhysics()
          //         : const NeverScrollableScrollPhysics(),
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         onTap: () {
          //           if (editItems[index].title == 'Crop') {
          //             openScreen(context, const CropImageScreen());
          //           } else {
          //             openScreen(context, const FilterImageScreen());
          //           }
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 24),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 editItems[index].icon,
          //                 color: Colors.white,
          //                 size: 22,
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.only(top: 1.h),
          //                 child: Text(
          //                   editItems[index].title,
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
        ),
      ),
    );
  }
}
