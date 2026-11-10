import 'package:flutter/material.dart';

class AppColors {
  static const primary      = Color(0xFF6366F1);
  static const primaryDark  = Color(0xFF4F46E5);
  static const accentCyan   = Color(0xFF06B6D4);
  static const accentViolet = Color(0xFF8B5CF6);
  static const success      = Color(0xFF10B981);

  static const bgLight       = Color(0xFFF7F8FC);
  static const surfaceLight  = Colors.white;
  static const textPrimaryL  = Color(0xFF0F172A);
  static const textSecondaryL= Color(0xFF64748B);
  static const borderLight   = Color(0xFFE2E8F0);

  static const bgDark        = Color(0xFF0A0E1A);
  static const surfaceDark   = Color(0xFF111827);
  static const cardDark      = Color(0xFF161B2C);
  static const borderDark    = Color(0xFF1F2937);
  static const textPrimaryD  = Color(0xFFF8FAFC);
  static const textSecondaryD= Color(0xFF94A3B8);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0E1A), Color(0xFF1E1B4B), Color(0xFF4C1D95)],
    stops: [0.0, 0.55, 1.0],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFF06B6D4)],
  );

  static const cardGradientLight = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Colors.white, Color(0xFFF1F5F9)],
  );

  static const cardGradientDark = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF161B2C), Color(0xFF111827)],
  );
}