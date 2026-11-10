import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';

class ContactCard extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const ContactCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 14),
          transform: Matrix4.identity()..translate(0.0, _hovered ? -6.0 : 0.0),
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.cardGradientDark
                : AppColors.cardGradientLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: widget.color.withOpacity(_hovered ? 0.6 : 0.2)),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovered ? 0.4 : 0.1),
                blurRadius: _hovered ? 24 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              FaIcon(
                widget.icon,
                color: widget.color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
