// File: lib/screens/splash_decider.dart

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'webview_screen.dart';

/// Shows SplashScreen for 3 seconds, then navigates to WebViewScreen.
class SplashDecider extends StatefulWidget {
  const SplashDecider({Key? key}) : super(key: key);

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds before showing WebView
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WebViewScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
