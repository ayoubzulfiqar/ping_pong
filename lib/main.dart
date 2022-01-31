import 'package:flutter/material.dart';
import 'package:pong_game/pong.dart';

void main() {
  runApp(const PongGame());
}

class PongGame extends StatelessWidget {
  const PongGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pong(),
    );
  }
}
