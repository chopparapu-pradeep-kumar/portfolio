import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pradeep_portfolio/achievement_card.dart';
import 'package:pradeep_portfolio/contact_card.dart';
import 'package:pradeep_portfolio/project_card.dart';
import 'package:pradeep_portfolio/skill_chip.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme/app_colors.dart';
import 'widgets/glass_card.dart';
import 'widgets/reveal.dart';
import 'widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Global animated background
          Positioned.fill(child: _animatedBg(isDark)),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(context, isDark),
              SliverList(
                delegate: SliverChildListDelegate([
                  _hero(context),
                  _sectionWrapper(_aboutKey, _aboutSection(context), isDark),
                  _sectionWrapper(_skillsKey, _skillsSection(context), isDark,
                      alt: true),
                  _sectionWrapper(
                      _experienceKey, _experienceSection(context), isDark),
                  _sectionWrapper(
                      _projectsKey, _projectsSection(context), isDark,
                      alt: true),
                  _sectionWrapper(null, _achievementsSection(context), isDark),
                  _sectionWrapper(_contactKey, _contactSection(context), isDark,
                      alt: true),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============== BACKGROUND ==============
  Widget _animatedBg(bool isDark) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -150,
            left: -100,
            child: _bgBlob(AppColors.accentViolet, 400, isDark),
          ),
          Positioned(
            top: 500,
            right: -120,
            child: _bgBlob(AppColors.accentCyan, 320, isDark),
          ),
          Positioned(
            bottom: 200,
            left: -80,
            child: _bgBlob(AppColors.primary, 360, isDark),
          ),
        ],
      ),
    );
  }

  Widget _bgBlob(Color c, double size, bool isDark) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.withOpacity(isDark ? 0.08 : 0.05),
        boxShadow: [
          BoxShadow(
              color: c.withOpacity(isDark ? 0.15 : 0.08),
              blurRadius: 200,
              spreadRadius: 60),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
        begin: -30, end: 30, duration: 8.seconds, curve: Curves.easeInOut);
  }

  // ============== APP BAR ==============
  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 70,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withOpacity(0.55),
              border: Border(
                bottom: BorderSide(color: AppColors.primary.withOpacity(0.15)),
              ),
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              gradient: AppColors.accentGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text('P',
                style: GoogleFonts.inter(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .shimmer(duration: 2.seconds),
          const SizedBox(width: 12),
          Text('Pradeep Kumar',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 17)),
        ],
      ),
      actions: [
        _navBtn('About', _aboutKey),
        _navBtn('Skills', _skillsKey),
        _navBtn('Experience', _experienceKey),
        _navBtn('Projects', _projectsKey),
        _navBtn('Contact', _contactKey),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _navBtn(String label, GlobalKey key) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton(
          onPressed: () => _scrollToKey(key),
          child: Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary)),
        ),
      );

  // ============== SECTION WRAPPER ==============
  Widget _sectionWrapper(GlobalKey? key, Widget child, bool isDark,
      {bool alt = false}) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      decoration: alt
          ? BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.015),
              border: Border.symmetric(
                horizontal:
                    BorderSide(color: AppColors.primary.withOpacity(0.08)),
              ),
            )
          : null,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: child,
        ),
      ),
    );
  }

  // ============== HERO ==============
  Widget _hero(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          Positioned(
              top: -80, left: -80, child: _glow(AppColors.accentViolet, 320)),
          Positioned(
              bottom: -100,
              right: -80,
              child: _glow(AppColors.accentCyan, 300)),
          Positioned(
              top: 180, right: 120, child: _glow(AppColors.primary, 200)),
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.success.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.success))
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(begin: 0.8, end: 1.4, duration: 900.ms),
                        const SizedBox(width: 8),
                        Text('Available for opportunities',
                            style: GoogleFonts.inter(
                                color: Colors.white, fontSize: 13)),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.3, end: 0),

                  const SizedBox(height: 28),

                  // Avatar
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: const CircularProgressIndicator(
                          value: 0.75,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white24),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .rotate(duration: 6.seconds),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.accentCyan,
                              AppColors.accentViolet
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.jpeg', // 👈 .jpeg here
                            width: 124,
                            height: 124,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 124,
                              height: 124,
                              color: Colors.white,
                              child: const Icon(Icons.person,
                                  size: 70, color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .scale(duration: 900.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 26),

                  // Typewriter
                  DefaultTextStyle(
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText('Flutter Engineer',
                            speed: const Duration(milliseconds: 80)),
                        TypewriterAnimatedText('Mobile Architect',
                            speed: const Duration(milliseconds: 80)),
                        TypewriterAnimatedText('Clean Code Advocate',
                            speed: const Duration(milliseconds: 80)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 12),

                  // Gradient Name
                  ShaderMask(
                    shaderCallback: (r) =>
                        AppColors.accentGradient.createShader(r),
                    child: Text(
                      'Pradeep Kumar',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 1.05,
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 10),

                  Text(
                    '2.5 yrs shipping production Flutter apps',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.white54,
                        letterSpacing: 0.5),
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 36),

                  // Metrics
                  Wrap(
                    spacing: 36,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _metric('2.5', 'Years'),
                      _metric('40%', 'Perf Gain'),
                      _metric('75%', 'Code Reuse'),
                    ],
                  ).animate().fadeIn(delay: 1000.ms),

                  const SizedBox(height: 40),

                  // CTAs
                  // Wrap(
                  //   spacing: 14,
                  //   runSpacing: 12,
                  //   alignment: WrapAlignment.center,
                  //   children: [
                  //     _primaryCTA('View Projects', Icons.arrow_forward,
                  //         () => _scrollToKey(_projectsKey)),
                  //     _ghostCTA('Download Resume', Icons.download, () {}),
                  //   ],
                  // ).animate().fadeIn(delay: 1200.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color c, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: c.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
                color: c.withOpacity(0.4), blurRadius: 120, spreadRadius: 40)
          ],
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
          begin: -18, end: 18, duration: 5.seconds, curve: Curves.easeInOut);

  Widget _metric(String v, String l) => Column(
        children: [
          ShaderMask(
            shaderCallback: (r) => AppColors.accentGradient.createShader(r),
            child: Text(v,
                style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
          ),
          Text(l.toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 11, color: Colors.white54, letterSpacing: 2)),
        ],
      );

  Widget _primaryCTA(String label, IconData icon, VoidCallback onTap) =>
      ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ).animate().shimmer(
          delay: 1.seconds, duration: 2.seconds, color: Colors.white24);

  Widget _ghostCTA(String label, IconData icon, VoidCallback onTap) =>
      OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );

  // ============== ABOUT ==============
  Widget _aboutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(index: '01', title: 'About Me'),
        const SizedBox(height: 24),
        Reveal(
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Results-driven Flutter Engineer with 2.5 years of experience building cross-platform mobile applications for e-commerce and project management domains. Specialized in Clean Architecture, BLoC state management, and performance optimization.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.9,
                    color: isDark
                        ? AppColors.textPrimaryD
                        : AppColors.textPrimaryL,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _infoChip('🎯 2.5 Years Experience'),
                    _infoChip('📱 Cross-Platform'),
                    _infoChip('🏗️ Clean Architecture'),
                    _infoChip('⚡ Performance Optimized'),
                    _infoChip('🎨 Pixel-Perfect UI'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600)),
      );

  // ============== SKILLS ==============
  Widget _skillsSection(BuildContext context) {
    final skills = {
      'Mobile Development': [
        {'n': 'Flutter', 'l': 0.95},
        {'n': 'Dart', 'l': 0.95},
        {'n': 'Android Studio', 'l': 0.85},
      ],
      'State Management': [
        {'n': 'Provider', 'l': 0.9},
        {'n': 'BLoC', 'l': 0.9},
      ],
      'Architecture': [
        {'n': 'Clean Architecture', 'l': 0.85},
        {'n': 'MVVM', 'l': 0.85},
      ],
      'Backend & APIs': [
        {'n': 'RESTful APIs', 'l': 0.9},
        {'n': 'JSON', 'l': 0.95},
        {'n': 'Dio', 'l': 0.9},
        {'n': 'HTTP', 'l': 0.9},
      ],
      'Version Control': [
        {'n': 'GitHub', 'l': 0.9},
        {'n': 'SourceTree', 'l': 0.8},
      ],
      'Tools': [
        {'n': 'Postman', 'l': 0.9},
        {'n': 'Firebase', 'l': 0.8},
        {'n': 'Figma', 'l': 0.85},
        {'n': 'VS Code', 'l': 0.95},
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(index: '02', title: 'Technical Skills'),
        const SizedBox(height: 24),
        ...skills.entries.toList().asMap().entries.map((outer) {
          final i = outer.key;
          final entry = outer.value;
          return Reveal(
            delay: Duration(milliseconds: i * 80),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key,
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value
                        .map<Widget>((s) => SkillChip(
                            skill: s['n'] as String, level: s['l'] as double))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ============== EXPERIENCE ==============
  Widget _experienceSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final experiences = [
      {
        'title': 'Flutter Developer',
        'company': 'Dakshah e-Informatics Services',
        'period': 'June 2024 – Present',
        'achievements': [
          'Developed grocery delivery app with BLoC architecture',
          'Integrated Google Maps API and payment gateway',
          'Reduced load time by 40% through optimized state management',
          'Built role-based UI system for Admin/Manager/Employee',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(index: '03', title: 'Experience'),
        const SizedBox(height: 24),
        ...experiences.map((exp) => Reveal(
              child: GlassCard(
                accent: AppColors.accentCyan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.work_outline,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exp['title'] as String,
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              Text(exp['company'] as String,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.accentCyan)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.success.withOpacity(0.4)),
                      ),
                      child: Text(exp['period'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.success,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 18),
                    ...(exp['achievements'] as List<String>).map((a) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: AppColors.primary, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(a,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: isDark
                                            ? AppColors.textPrimaryD
                                            : AppColors.textPrimaryL)),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // ============== PROJECTS ==============
  Widget _projectsSection(BuildContext context) {
    final projects = [
      {
        'title': 'Village Kart',
        'subtitle': 'Grocery Delivery Application',
        'icon': Icons.shopping_cart,
        'technologies': [
          'Flutter',
          'BLoC',
          'REST APIs',
          'Firebase',
          'Google Maps'
        ],
        'features': [
          'User Authentication',
          'Product Catalog',
          'Shopping Cart',
          'Order Management',
          'Real-time Tracking',
        ],
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Digitom',
        'subtitle': 'Role-Based Project Management System',
        'icon': Icons.dashboard_customize,
        'technologies': ['Flutter', 'Provider', 'REST APIs', 'SQLite'],
        'features': [
          'Multi-role Access (Admin/Manager/Employee)',
          'Task Assignment',
          'Progress Tracking',
          'Responsive Design',
          'Cross-Platform (Mobile & Web)',
        ],
        'color': AppColors.accentViolet,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(index: '04', title: 'Key Projects'),
        const SizedBox(height: 24),
        ...projects.asMap().entries.map((e) => Reveal(
              delay: Duration(milliseconds: e.key * 120),
              child: ProjectCard(project: e.value),
            )),
      ],
    );
  }

  // ============== ACHIEVEMENTS ==============
  Widget _achievementsSection(BuildContext context) {
    final achievements = [
      {
        'icon': Icons.code,
        'title': 'Complex State Management',
        'description':
            'Implemented state management solutions handling 30–50 screens efficiently',
      },
      {
        'icon': Icons.devices,
        'title': 'Code Reusability',
        'description':
            'Achieved 75% code reusability across mobile and web platforms for Digitom',
      },
      {
        'icon': Icons.speed,
        'title': 'Performance Optimization',
        'description':
            'Reduced app loading time by 40% through optimized state management',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(index: '05', title: 'Achievements'),
        const SizedBox(height: 24),
        ...achievements.asMap().entries.map((e) => Reveal(
              delay: Duration(milliseconds: e.key * 100),
              child: AchievementCard(achievement: e.value),
            )),
      ],
    );
  }

  // ============== CONTACT ==============
  Widget _contactSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SectionTitle(index: '06', title: 'Get In Touch', centered: true),
        const SizedBox(height: 8),
        Text(
          "Let's build something amazing together",
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isDark ? AppColors.textSecondaryD : AppColors.textSecondaryL,
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 30),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            ContactCard(
                icon: FontAwesomeIcons.whatsapp,
                label: 'WhatsApp',
                color: const Color(0xFF25D366),
                onTap: _launchWhatsApp),
            ContactCard(
                icon: Icons.email,
                label: 'Email',
                color: const Color(0xFFEA4335),
                onTap: _launchEmail),
            ContactCard(
                icon: FontAwesomeIcons.github,
                label: 'GitHub',
                color: Colors.grey.shade400,
                onTap: _launchGitHub),
            ContactCard(
                icon: FontAwesomeIcons.linkedin,
                label: 'LinkedIn',
                color: const Color(0xFF0A66C2),
                onTap: _launchLinkedIn),
          ],
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 32),
        Reveal(
          child: GlassCard(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 40,
              runSpacing: 16,
              children: [
                _contactItem(Icons.phone, '+91 9032616661'),
                _contactItem(Icons.email, 'pradeeppandu.844@gmail.com'),
                _contactItem(Icons.location_on, 'Mandavalli, Andhra Pradesh'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          '© 2025 Pradeep Kumar · Built with Flutter',
          style: GoogleFonts.inter(
              fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _contactItem(IconData i, String t) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(t, style: GoogleFonts.inter(fontSize: 14)),
        ],
      );

  // ============== LAUNCHERS ==============
  void _launchWhatsApp() async {
    final url = 'https://wa.me/919032616661';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  void _launchEmail() async {
    final url = 'mailto:pradeeppandu.844@gmail.com';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  void _launchGitHub() async {
    final url = 'https://github.com/pradeepkumar';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  void _launchLinkedIn() async {
    final url = 'https://linkedin.com/in/pradeepkumar';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;
    const s = 64.0;
    for (double x = 0; x < size.width; x += s) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += s) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
