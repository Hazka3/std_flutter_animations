import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
        child: CustomPaint(
          painter: AppleWatchPainter(),
          size: const Size(400, 400),
        ),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final redCircleRadius = (size.width) / 2 * 0.9;
    final greenCircleRadius = (size.width) / 2 * 0.76;
    final blueCircleRadius = (size.width) / 2 * 0.62;

    const circleStrokeWidth = 25.0;
    const startingAngle = -pi / 2;

    // draw red circle
    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleStrokeWidth;

    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );

    // draw green circle
    final greenCirclePaint = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleStrokeWidth;

    canvas.drawCircle(
      center,
      greenCircleRadius,
      greenCirclePaint,
    );

    // draw blue circle
    final blueCirclePaint = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleStrokeWidth;

    canvas.drawCircle(
      center,
      blueCircleRadius,
      blueCirclePaint,
    );

    // draw red arc
    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = circleStrokeWidth;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      pi / 4, // のちにRandom値となるように変更する
      false,
      redArcPaint,
    );

    // draw green arc
    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );

    final greenArcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = circleStrokeWidth;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      3 * pi / 4, // のちにRandom値となるように変更する
      false,
      greenArcPaint,
    );

    // draw blue arc
    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );

    final blueArcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = circleStrokeWidth;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      2 * pi / 3, // のちにRandom値となるように変更する
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
