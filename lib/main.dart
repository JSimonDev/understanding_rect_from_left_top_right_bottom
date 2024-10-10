import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const RectDemoApp());
}

/// Main application widget that sets up the MaterialApp.
class RectDemoApp extends StatelessWidget {
  const RectDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Rect.fromLTRB Demo',
      home: RectDemoPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Main page that displays the rectangle demonstration.
class RectDemoPage extends StatefulWidget {
  const RectDemoPage({super.key});

  @override
  State<RectDemoPage> createState() => _RectDemoPageState();
}

/// State of the main page handling the sliders and rectangle logic.
class _RectDemoPageState extends State<RectDemoPage> {
  double _left = 50;
  double _top = 50;
  double _right = 250;
  double _bottom = 250;

  @override
  Widget build(BuildContext context) {
    // Create a rectangle from the current slider values.
    Rect rect = Rect.fromLTRB(_left, _top, _right, _bottom);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rect.fromLTRB Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Drawing area that displays the rectangle.
            Expanded(
              child: Center(
                child: CustomPaint(
                  size: const Size(300, 300),
                  painter: RectPainter(rect),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Slider to adjust the Left value.
            SliderControl(
              label: 'Left',
              min: 0,
              max: 300,
              value: _left,
              onChanged: (value) {
                setState(() {
                  _left = value;
                  // Ensure Left is not greater than Right.
                  _left = math.min(_left, _right);
                });
              },
            ),

            /// Slider to adjust the Top value.
            SliderControl(
              label: 'Top',
              min: 0,
              max: 300,
              value: _top,
              onChanged: (value) {
                setState(() {
                  _top = value;
                  // Ensure Top is not greater than Bottom.
                  _top = math.min(_top, _bottom);
                });
              },
            ),

            /// Slider to adjust the Right value.
            SliderControl(
              label: 'Right',
              min: 0,
              max: 300,
              value: _right,
              onChanged: (value) {
                setState(() {
                  _right = value;
                  // Ensure Right is not less than Left.
                  _right = math.max(_right, _left);
                });
              },
            ),

            /// Slider to adjust the Bottom value.
            SliderControl(
              label: 'Bottom',
              min: 0,
              max: 300,
              value: _bottom,
              onChanged: (value) {
                setState(() {
                  _bottom = value;
                  // Ensure Bottom is not less than Top.
                  _bottom = math.max(_bottom, _top);
                });
              },
            ),

            /// Display the current rectangle values.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Rect: left=${_left.toStringAsFixed(1)}, top=${_top.toStringAsFixed(1)}, right=${_right.toStringAsFixed(1)}, bottom=${_bottom.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom widget for slider controls.
class SliderControl extends StatelessWidget {
  final String label;
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;

  const SliderControl({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label showing the name and current value of the slider.
        Text(
          '$label: ${value.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 16),
        ),

        /// Slider to adjust the value.
        Slider(
          min: min,
          max: max,
          value: value.clamp(min, max),
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}

/// Custom painter to draw the rectangle and background.
class RectPainter extends CustomPainter {
  final Rect rect;

  RectPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint the white background.
    final Paint backgroundPaint = Paint()..color = Colors.white;

    // Paint the rectangle with semi-transparent color.
    final Paint rectPaint = Paint()
      ..color = Colors.deepPurple.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Paint the border of the rectangle.
    final Paint borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw the background of the drawing area.
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Draw the specified rectangle.
    canvas.drawRect(rect, rectPaint);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant RectPainter oldDelegate) {
    // Indicates whether to repaint based on changes in the rectangle.
    return oldDelegate.rect != rect;
  }
}
