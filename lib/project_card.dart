import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.project['color'] as Color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.cardGradientDark : AppColors.cardGradientLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? color.withOpacity(0.5) : color.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_hovered ? 0.25 : 0.08),
              blurRadius: _hovered ? 30 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12)],
                  ),
                  child: Icon(widget.project['icon'] as IconData,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.project['title'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(widget.project['subtitle'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_outward,
                    color: _hovered ? color : Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: (widget.project['technologies'] as List<String>)
                  .map((tech) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.25)),
                        ),
                        child: Text(tech,
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: color,
                                fontWeight: FontWeight.w600)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ...(widget.project['features'] as List<String>).map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(f,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: isDark ? Colors.grey[300] : Colors.grey[700])),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}