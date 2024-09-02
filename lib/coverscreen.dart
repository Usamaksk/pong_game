import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key,required this.gameHasStarted});
 final bool gameHasStarted;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.2),
      child:Text(
       gameHasStarted ? '' :'T A P T O P L A Y',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
