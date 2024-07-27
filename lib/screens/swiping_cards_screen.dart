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

  int _index = 1;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
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

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
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

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: scale,
                  child: Card(
                    index: _index == 5 ? 1 : _index + 1,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: Card(
                        index: _index,
                      ),
                    ),
                  ),
                ),
              )
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
