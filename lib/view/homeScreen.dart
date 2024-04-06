import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editing_app/controller/commonFun/commonColors.dart';
import 'package:photo_editing_app/controller/provider/imageProvider.dart';
import 'package:photo_editing_app/view/EditorHome/editorHomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _pickImage;

  late AppImageProvider imageProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.darkColor,
      body: Consumer<AppImageProvider>(
        builder: (context, provider, child) {
          if (provider.currentImage != null) {
            return const EditorHomeScreen();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.5, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: Image.asset(
                      'assets/profile.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: const Text(
                    'Select your photo from gallery',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist-Bold',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: InkWell(
                    onTap: () async {
                      File imageRes = await _pickingImage();
                      debugPrint("Image path is: ${imageRes.toString()}");
                      if (mounted) {
                        context.read<AppImageProvider>().savedImage(imageRes);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // For picking image an image from gallery
  Future _pickingImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pickImage = File(pickedFile.path);
      // debugPrint("Picked Image Path: $_pickImage");
    } else {
      _pickingImage();
    }
    return _pickImage;
  }
}
