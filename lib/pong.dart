import 'package:flutter/material.dart';
import 'dart:math';
import 'ball.dart';
import 'bat.dart';

enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  late double width;
  late double height;

  // double batWidth;
  // double batHeight;
  double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;
  double posX = 0;
  double posY = 0;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      setState(() {
        checkBorders();
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });

      checkBorders();
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Ping Pong',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 70,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                posX = 0;
                posY = 0;
                score = 0;
              });

              controller.repeat();
            },
            icon: const Icon(Icons.repeat_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        // batWidth = (width / 5);
        // batHeight = height / 20;

        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 24,
              child: Text(
                'Score: ' + score.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              child: const Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) {
                  moveBat(update, context);
                },
                child: const Bat(100, 20),
              ),
            ),
          ],
        );
      }),
    );
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }

    if (posY >= height - diameter - 20 && vDir == Direction.down) {
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + 100 + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randX = randomNumber();
    }
  }

  void moveBat(DragUpdateDetails update, BuildContext context) {
    setState(() {
      batPosition += update.delta.dx;
    });
  }

  double randomNumber() {
    var ran = Random();
    int myNum = ran.nextInt(100);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Game Over: ' + score.toString(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            content: const Text('Would you like to play again?',
                style: TextStyle(
                  fontSize: 17,
                )),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // dispose();
                  controller.stop();
                },
              ),
            ],
          );
        });
  }
}
