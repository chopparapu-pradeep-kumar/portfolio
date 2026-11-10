import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.15),
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Animate(
        autoPlay: _visible,
        effects: [
          FadeEffect(duration: 700.ms, delay: widget.delay),
          MoveEffect(
            begin: widget.offset,
            end: Offset.zero,
            duration: 700.ms,
            delay: widget.delay,
            curve: Curves.easeOutCubic,
          ),
        ],
        child: widget.child,
      ),
    );
  }
}