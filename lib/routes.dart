import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/enhanced_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/settings_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const EnhancedLoginScreen(),
  '/dashboard': (_) => const HomeScreen(),
  '/home': (_) => const HomeScreen(),
  '/appointments': (_) => const AppointmentsScreen(),
  '/settings': (_) => const SettingsScreen(),
};
