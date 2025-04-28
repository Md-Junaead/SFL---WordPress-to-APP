// File: lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash_decider.dart';

void main() {
  // Ensure binding before running app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// flutter build apk --build-name=1.0 --build-number=1

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove debug banner
      debugShowCheckedModeBanner: false,
      title: 'SaverFavor',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // Start at the SplashDecider which shows animation then WebView
      home: const SplashDecider(),
    );
  }
}
