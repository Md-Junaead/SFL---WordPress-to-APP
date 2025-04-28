// // File: lib/viewmodels/webview_viewmodel.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// /// ViewModel for managing WebView state (loading, errors, progress, back-button).
// class WebViewViewModel extends ChangeNotifier {
//   late InAppWebViewController _webViewController;

//   bool isLoading = true; // Shows spinner while loading
//   bool hasError = false; // True if load error occurred
//   String errorMessage = ''; // Error description
//   double progress = 0.0; // Page load progress (0.0–1.0)

//   /// Called when the WebView controller is created
//   void setWebViewController(InAppWebViewController controller) {
//     _webViewController = controller;
//     debugPrint('WebViewController initialized');
//   }

//   /// Page load started
//   void onPageStarted() {
//     isLoading = true;
//     hasError = false;
//     notifyListeners();
//     debugPrint('Page started loading');
//   }

//   /// Page load finished
//   void onPageFinished() {
//     isLoading = false;
//     notifyListeners();
//     debugPrint('Page finished loading');
//   }

//   /// Received a web resource error
//   void onWebResourceError(WebResourceError error) {
//     isLoading = false;
//     hasError = true;
//     errorMessage = error.description;
//     notifyListeners();
//     debugPrint('Web resource error: $errorMessage');
//   }

//   /// Progress update callback (0–100)
//   void onProgressChanged(int value) {
//     progress = value / 100.0;
//     notifyListeners();
//   }

//   /// Reload the WebView (used by Retry button)
//   Future<void> reloadWebView() async {
//     await _webViewController.reload();
//     onPageStarted();
//   }

//   /// Handle Android back button
//   Future<bool> handleBackButton() async {
//     if (await _webViewController.canGoBack()) {
//       await _webViewController.goBack();
//       debugPrint('Navigated back in WebView history');
//       return false; // Prevent exiting app
//     }
//     return true; // Exit app
//   }
// }

// File: lib/viewmodels/webview_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../database/database_helper.dart'; // ← NEW

class WebViewViewModel extends ChangeNotifier {
  late InAppWebViewController _webViewController;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  double progress = 0.0;

  void setWebViewController(InAppWebViewController controller) {
    _webViewController = controller;
    debugPrint('WebViewController initialized');
  }

  void onPageStarted() {
    isLoading = true;
    hasError = false;
    notifyListeners();
  }

  /// 🔄 Updated: Save URL into SQLite whenever a page finishes loading
  void onPageFinished() async {
    isLoading = false;
    notifyListeners();

    // Get current URL
    final webUri = await _webViewController.getUrl();
    final urlString = webUri?.toString();
    if (urlString != null) {
      // Insert into history table
      await DatabaseHelper.insertUrl(urlString);
      debugPrint('Inserted into DB history: $urlString');
    }

    debugPrint('Page finished loading');
  }

  void onWebResourceError(WebResourceError error) {
    isLoading = false;
    hasError = true;
    errorMessage = error.description;
    notifyListeners();
  }

  void onProgressChanged(int value) {
    progress = value / 100.0;
    notifyListeners();
  }

  Future<void> reloadWebView() async {
    await _webViewController.reload();
    onPageStarted();
  }

  Future<bool> handleBackButton() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return false;
    }
    return true;
  }
}
