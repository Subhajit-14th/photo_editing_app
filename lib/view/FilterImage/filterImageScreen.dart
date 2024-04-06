import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editing_app/controller/commonFun/commonColors.dart';
import 'package:photo_editing_app/controller/provider/imageProvider.dart';
import 'package:photo_editing_app/model/filterApiResModel.dart';
import 'package:photo_editing_app/view/Widgets/filterScreen.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sizer/sizer.dart';

import '../../controller/commonFun/CommonFun.dart';

class FilterImageScreen extends StatefulWidget {
  const FilterImageScreen({super.key});

  @override
  State<FilterImageScreen> createState() => _FilterImageScreenState();
}

class _FilterImageScreenState extends State<FilterImageScreen> {
  late Filter currentFilter;
  late List<Filter> filters;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    filters = Filters().list();
    currentFilter = filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.perfectDarkColor,
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
            'Filter',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                Uint8List? bytes = await screenshotController.capture();
                context.read<AppImageProvider>().changeImage(bytes!);
                if (!mounted) return;
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.done_rounded,
              ),
            ),
          ],
        ),
        body: Consumer<AppImageProvider>(
          builder: (context, provider, child) {
            debugPrint('Image isss: ${provider.currentImage}');
            if (provider.currentImage != null) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: getScreenWidth(context) / 1.2,
                  decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      ),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(10),
                    child: Screenshot(
                      controller: screenshotController,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.matrix(currentFilter.matrix),
                        child: Image.memory(
                          provider.currentImage!,
                          fit: BoxFit.contain,
                        ),
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
        bottomNavigationBar: Container(
          height: getScreenHeight(context) * 0.2,
          padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
          decoration: BoxDecoration(
            color: AppColor.greyColor.withOpacity(.16),
          ),
          child: Consumer<AppImageProvider>(
            builder: (context, provider, child) {
              debugPrint('Image isss: ${provider.currentImage}');
              if (provider.currentImage != null) {
                return ListView.builder(
                    itemCount: filters.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 80,
                                width: 60,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: InkWell(
                                    onTap: () {
                                      currentFilter = filters[index];
                                      setState(() {});
                                    },
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                          filters[index].matrix),
                                      child: Image.memory(
                                        provider.currentImage!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                filters[index].filterName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
