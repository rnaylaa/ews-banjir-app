import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback? onMulaiPantauPressed;

  const SplashScreen({
    super.key,
    this.onMulaiPantauPressed,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF090D16);
    const primaryCyan = Color(0xFF38C5F4);
    const cardBgColor = Color(0xFF111927);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Radar Circles
          Positioned.fill(
            child: CustomPaint(
              painter: RadarBackgroundPainter(),
            ),
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(),

                  // Center Logo & App Title Section
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon Box Container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(28),
                        child: const WaterDropLogo(),
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'EWS Bok Malang',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Peringatan Dini Banjir Real-Time',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Bottom Action Section
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "Mulai Pantau" Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: onMulaiPantauPressed ?? () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryCyan,
                            foregroundColor: const Color(0xFF090D16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Mulai Pantau',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Location Info
                      Text(
                        'Kali Piring · Pilangbango',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kota Madiun',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw the radar/wave background rings
class RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Radius list from inner to outer
    final radii = [80.0, 140.0, 200.0, 260.0, 320.0, 380.0, 440.0];

    for (int i = 0; i < radii.length; i++) {
      final opacity = (0.12 - (i * 0.013)).clamp(0.02, 0.15);
      paint.color = const Color(0xFF38C5F4).withOpacity(opacity);
      canvas.drawCircle(center, radii[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter to draw the Water Drop Icon with internal wave lines
class WaterDropLogo extends StatelessWidget {
  const WaterDropLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WaterDropPainter(),
      size: Size.infinite,
    );
  }
}

class _WaterDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Gradient fill for water drop
    final dropGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF38C5F4),
        Color(0xFF0091EA),
      ],
    );

    final dropPaint = Paint()
      ..shader = dropGradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // Draw Water Drop Path
    final dropPath = Path();
    dropPath.moveTo(w * 0.5, 0);

    // Right curve down
    dropPath.cubicTo(
      w * 0.95, h * 0.45,
      w * 0.95, h * 0.95,
      w * 0.5, h,
    );

    // Left curve up
    dropPath.cubicTo(
      w * 0.05, h * 0.95,
      w * 0.05, h * 0.45,
      w * 0.5, 0,
    );

    dropPath.close();

    canvas.drawPath(dropPath, dropPaint);

    // Draw 2 Wave Lines Inside Drop
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round;

    // First (Upper) Wave
    final wavePath1 = Path();
    wavePath1.moveTo(w * 0.30, h * 0.53);
    wavePath1.quadraticBezierTo(
      w * 0.40, h * 0.45,
      w * 0.50, h * 0.53,
    );
    wavePath1.quadraticBezierTo(
      w * 0.60, h * 0.61,
      w * 0.70, h * 0.53,
    );
    canvas.drawPath(wavePath1, wavePaint);

    // Second (Lower) Wave
    final wavePath2 = Path();
    wavePath2.moveTo(w * 0.30, h * 0.68);
    wavePath2.quadraticBezierTo(
      w * 0.40, h * 0.60,
      w * 0.50, h * 0.68,
    );
    wavePath2.quadraticBezierTo(
      w * 0.60, h * 0.76,
      w * 0.70, h * 0.68,
    );
    canvas.drawPath(wavePath2, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
