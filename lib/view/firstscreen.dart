import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_editing_app/controller/provider/imageProvider.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<AppImageProvider>(
            builder: (context, provider, child) {
              if (provider.currentImage != null) {
                return Image.memory(provider.currentImage!);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
