import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
    this.color,
    this.fontWeight,
  }) : super(key: key);
  final String buttonText;
  final Function() onPressed;
  final double? height;
  final double? width;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 120,
        width: width ?? 100,
        decoration: BoxDecoration(
          color: color ?? Colors.black,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(40),
          // ),
          // shadows: [
          //   BoxShadow(
          //     color: Colors.white.withOpacity(.4),
          //     blurRadius: 10,
          //     spreadRadius: 1,
          //   ),
          // ],
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Urbanist-Bold',
                fontWeight: fontWeight ?? FontWeight.w700,
                letterSpacing: 0.20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
Container(
width: 380,
height: 58,
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
decoration: ShapeDecoration(
color: Color(0xFF001692),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),
child: Row(
mainAxisSize: MainAxisSize.min,
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Expanded(
child: SizedBox(
child: Text(
'Button',
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontFamily: 'Urbanist',
fontWeight: FontWeight.w700,
height: 0.09,
letterSpacing: 0.20,
),
),
),
),
],
),
)*/
