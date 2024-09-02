import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong_game/ball.dart';
import 'package:pong_game/brick.dart';
import 'package:pong_game/coverscreen.dart';
import 'package:pong_game/scrollscreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomepageState extends State<Homepage> {
  //player variables (buttom brick)
  double PlayerX = -0.2;
  double brickWidth = 0.4;
  int playerScore = 0;

  // enemy variables (top bricks)
  double enemyX = -0.2;
  int enemyScore = 0;

  // ball variables
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // game setting
  bool gameHasStarted = false;

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      // update direction
      updateDirection();

      // move ball
      moveBall();

      // move enemy
      moveEnemy();

      // check if the player is dead
      if (isPlayerDead()) {
        enemyScore++;
        timer.cancel();
        _showDialog(false);
      }

      if (isEnemyDead()) {
        playerScore++;
        timer.cancel();
        _showDialog(true);
      }
    });
  }

  bool isEnemyDead() {
    if (ballY <= -1) {
      return true;
    }
    return false;
  }

  void moveEnemy() {
    setState(() {
      enemyX = ballX;
    });
  }

  void _showDialog(bool enemyDied) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                enemyDied ? "PINK WIN" : "PURPLE WIN",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color:
                        enemyDied ? Colors.pink[100] : Colors.deepPurple[100],
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                          color: enemyDied
                              ? Colors.pink[800]
                              : Colors.deepPurple[800]),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      PlayerX = -0.2;
      enemyX = -0.2;
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void updateDirection() {
    setState(() {
      //update vertical direction

      if (ballY >= 0.9 && PlayerX + brickWidth >= ballX && PlayerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      // update horizontal direction
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void moveBall() {
    setState(() {
      // vertical movement
      if (ballYDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballYDirection == direction.UP) {
        ballY -= 0.01;
      }

      // Horizontal movement
      if (ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(PlayerX + brickWidth >= 1)) {
        PlayerX += 0.1;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(PlayerX - 0.1 <= -1)) {
        PlayerX -= 0.1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed((LogicalKeyboardKey.arrowLeft))) {
            moveLeft();
          } else if (event.isKeyPressed((LogicalKeyboardKey.arrowRight))) {
            moveRight();
          }
        },
        child: GestureDetector(
          onTap: startGame,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            body: Center(
              child: Stack(
                children: [
                  // tap to play
                  CoverScreen(
                    gameHasStarted: gameHasStarted,
                  ),

                  // Scroll Screen
                  ScrollScreen(
                    gameHasStarted: gameHasStarted,
                    enemyScore: enemyScore,
                    playerScore: playerScore,
                  ),

                  // top Brick
                  MyBrick(
                    x: enemyX,
                    y: -0.9,
                    brickwidth: brickWidth,
                    thisIsEnemy: true,
                  ),
                  //bottom Brick
                  MyBrick(
                    x: PlayerX,
                    y: 0.9,
                    brickwidth: brickWidth,
                    thisIsEnemy: false,
                  ),
                  // Ball
                  MyBall(
                    x: ballX,
                    y: ballY,
                    gameHasStarted: gameHasStarted,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
