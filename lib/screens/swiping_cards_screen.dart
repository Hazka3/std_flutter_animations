import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;

  late final iconColorBound = size.width - 200;

  int _index = 1;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
    lowerBound: (size.width + 100) * -1,
    upperBound: size.width + 100,
    value: 0.0,
  );

  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  late final Tween<double> _buttonScale = Tween(
    begin: 1.0,
    end: 1.2,
  );

  late final ColorTween _cancleButtonColor =
      ColorTween(begin: Colors.white, end: Colors.red);

  late final ColorTween _checkButtonColor =
      ColorTween(begin: Colors.white, end: Colors.green);

  void _whenComplete() {
    _position.value = 0; // カードの位置を元に戻す
    setState(() {
      _index =
          _index == 5 ? 1 : _index + 1; // スワイプアニメ終了時に、Card の index をインクリメント
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200; // カードを消すスワイプ位置
    final dropZone = size.width + 100; // カードが消える位置
    final factor =
        _position.value.isNegative ? -1 : 1; // 左右どちらにスワイプしたかで、アニメーション方向を決定する

    // スワイプ距離が bound を超えた時に、非表示アニメーション
    if (_position.value.abs() >= bound) {
      _position.animateTo(dropZone * factor).whenComplete(_whenComplete);

      // スワイプ距離が十分ではなかった場合は、カードの位置を元に戻す
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  void _testBackButton() {
    if (_position.isAnimating) {
      return;
    }
    _position.reverse().whenComplete(_whenComplete);
  }

  void _testForwardButton() {
    if (_position.isAnimating) {
      return;
    }
    _position.forward().whenComplete(_whenComplete);
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiping Cards'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle = _rotation
                  .transform((_position.value / (size.width + 100) + 1) / 2) *
              pi /
              180;

          final scale = _scale.transform(
            _position.value.abs() / (size.width + 100),
          );

          final buttonScale = _buttonScale.transform(
            _position.value.abs() / (size.width + 100),
          );

          final cancleButtonColor = _cancleButtonColor.transform(
            _position.value * -1 / (size.width + 100),
          );

          final checkButtonColor = _checkButtonColor.transform(
            _position.value / (size.width + 100),
          );

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // 後ろのカード
              Positioned(
                top: 50,
                child: Transform.scale(
                  scale: scale,
                  child: Card(
                    index:
                        _index == 5 ? 1 : _index + 1, // 後ろにあるカードは、index + 1 をもつ
                  ),
                ),
              ),

              // 表のカード
              Positioned(
                top: 50,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: _index, // 表にあるカードは、現在の index を持つ
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 70,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _testBackButton,
                      child: Transform.scale(
                        scale: _position.value.isNegative ? buttonScale : 1.0,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: cancleButtonColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close_outlined,
                            color: _position.value > -iconColorBound
                                ? Colors.red
                                : Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    GestureDetector(
                      onTap: _testForwardButton,
                      child: Transform.scale(
                        scale: _position.value.isNegative ? 1.0 : buttonScale,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: checkButtonColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 5),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.done_rounded,
                            color: _position.value < iconColorBound
                                ? Colors.green
                                : Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.6,
        child: Image.asset(
          "assets/covers/$index.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
