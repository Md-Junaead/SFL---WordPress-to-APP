// // File: lib/screens/splash_decider.dart

// import 'package:flutter/material.dart';
// import 'splash_screen.dart';
// import 'webview_screen.dart';

// /// Shows SplashScreen for 3 seconds, then navigates to WebViewScreen.
// class SplashDecider extends StatefulWidget {
//   const SplashDecider({Key? key}) : super(key: key);

//   @override
//   State<SplashDecider> createState() => _SplashDeciderState();
// }

// class _SplashDeciderState extends State<SplashDecider> {
//   @override
//   void initState() {
//     super.initState();
//     // Delay for 3 seconds before showing WebView
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const WebViewScreen()),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SplashScreen();
//   }
// }

// File: lib/screens/splash_decider.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'webview_screen.dart';
import 'splash_screen.dart';

class SplashDecider extends StatefulWidget {
  const SplashDecider({Key? key}) : super(key: key);

  @override
  State<SplashDecider> createState() => _SplashDeciderState();
}

class _SplashDeciderState extends State<SplashDecider> {
  InAppWebViewController? _controller; // ← Store preloaded controller

  @override
  void initState() {
    super.initState();

    // Start preloading the website in background during splash screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('https://saverfavor.com/'),
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            cacheEnabled: true,
            clearCache: false, // ← Don't clear cache
          ),
        ),
        onWebViewCreated: (controller) {
          _controller = controller;
        },
      );
    });

    // Wait for 3 seconds, then go to WebView screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
                preloadedController:
                    _controller), // ← Pass preloaded controller
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
