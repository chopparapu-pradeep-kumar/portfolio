import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String index;
  final String title;
  final bool centered;
  const SectionTitle({
    super.key,
    required this.index,
    required this.title,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          '$index / ${title.toUpperCase()}',
          style: GoogleFonts.inter(
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (r) => AppColors.accentGradient.createShader(r),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        )
            .animate()
            .scaleX(
              begin: 0,
              end: 1,
              duration: 700.ms,
              curve: Curves.easeOutCubic,
              alignment: centered ? Alignment.center : Alignment.centerLeft,
            ),
      ],
    );
  }
}