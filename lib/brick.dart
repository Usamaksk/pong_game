import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  const MyBrick({super.key, this.x, this.y,this.brickwidth,this.thisIsEnemy});

  final x;
  final y;
  final brickwidth;// out of 2
  final thisIsEnemy;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * x + brickwidth) / (2 - brickwidth), y),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: thisIsEnemy ? Colors.deepPurple[300] : Colors.pink[300],
          height: 20,
          width: MediaQuery.of(context).size.width  * brickwidth /2,
        ),
      ),
    );
  }
}
