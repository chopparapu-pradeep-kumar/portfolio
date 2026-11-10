import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pradeep_portfolio/widgets/glass_card.dart';
import '../theme/app_colors.dart';

class AchievementCard extends StatefulWidget {
  final Map<String, dynamic> achievement;
  const AchievementCard({super.key, required this.achievement});

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        transform: Matrix4.identity()..translate(_hovered ? 6.0 : 0.0, 0.0),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          accent: AppColors.accentViolet,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.4), blurRadius: 12),
                  ],
                ),
                child: Icon(widget.achievement['icon'] as IconData,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.achievement['title'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(widget.achievement['description'] as String,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryD
                                : AppColors.textSecondaryL)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}