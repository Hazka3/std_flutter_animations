import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late Animation<double> _redArcProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);

  late Animation<double> _greenArcProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);

  late Animation<double> _blueArcProgress = Tween(
    begin: 0.005,
    end: Random().nextDouble() * 2.0,
  ).animate(_curve);

  void _animateValues() {
    setState(() {
      // red Arc
      _redArcProgress = Tween(
        begin: _redArcProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);

      //green Arc
      _greenArcProgress = Tween(
        begin: _greenArcProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);

      //blue Arc
      _blueArcProgress = Tween(
        begin: _blueArcProgress.value,
        end: Random().nextDouble() * 2.0,
      ).animate(_curve);
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
        child: AnimatedBuilder(
          animation: _curve,
          builder: (context, child) => CustomPaint(
            painter: AppleWatchPainter(
              redProgress: _redArcProgress.value,
              greenProgress: _greenArcProgress.value,
              blueProgress: _blueArcProgress.value,
            ),
            size: const Size(400, 400),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double redProgress;
  final double greenProgress;
  final double blueProgress;

  AppleWatchPainter({
    required this.redProgress,
    required this.greenProgress,
    required this.blueProgress,
  });

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
      redProgress * pi, // のちにRandom値となるように変更する
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
      greenProgress * pi, // のちにRandom値となるように変更する
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
      blueProgress * pi, // のちにRandom値となるように変更する
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return (oldDelegate.redProgress != redProgress) ||
        (oldDelegate.greenProgress != greenProgress) ||
        (oldDelegate.blueProgress != blueProgress);
  }
}
