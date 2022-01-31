import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double diam = 40.0;
    return Container(
      width: diam,
      height: diam,
      decoration: BoxDecoration(
        // color: Colors.black,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 4,
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black,
            spreadRadius: -4,
            blurRadius: 5,
          )
        ],
        gradient: RadialGradient(
          colors: [Colors.grey, Colors.black.withOpacity(0.2)],
          center: const Alignment(0, -0.75),
        ),
      ),
    );
  }
}
