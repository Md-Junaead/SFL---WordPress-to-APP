// import 'package:SaverFavor/viewmodel/webview_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';

// class WebViewScreen extends StatefulWidget {
//   final InAppWebViewController? preloadedController;

//   const WebViewScreen({Key? key, this.preloadedController}) : super(key: key);

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final WebViewViewModel viewModel = WebViewViewModel();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ChangeNotifierProvider<WebViewViewModel>(
//           create: (_) => viewModel,
//           child: Consumer<WebViewViewModel>(
//             builder: (context, vm, _) => WillPopScope(
//               onWillPop: vm.handleBackButton,
//               child: Stack(
//                 children: [
//                   InAppWebView(
//                     key: const Key('main_webview'),
//                     initialUrlRequest:
//                         URLRequest(url: WebUri('https://saverfavor.com/')),
//                     initialOptions: InAppWebViewGroupOptions(
//                       crossPlatform: InAppWebViewOptions(
//                         javaScriptEnabled: true,
//                         cacheEnabled: true,
//                         clearCache: false,
//                       ),
//                     ),
//                     onWebViewCreated: (controller) {
//                       // Use the preloaded controller if available
//                       if (widget.preloadedController != null) {
//                         viewModel
//                             .setWebViewController(widget.preloadedController!);
//                         debugPrint('✔️ Using preloaded controller');
//                       } else {
//                         viewModel.setWebViewController(controller);
//                         debugPrint('✔️ Using fresh controller');
//                       }
//                     },
//                     onLoadStart: (controller, _) => vm.onPageStarted(),
//                     onLoadStop: (controller, _) => vm.onPageFinished(),
//                     onReceivedError: (controller, req, error) =>
//                         vm.onWebResourceError(error),
//                     onProgressChanged: (controller, progress) =>
//                         vm.onProgressChanged(progress),
//                   ),

//                   // Linear progress bar at top
//                   if (vm.progress < 1.0)
//                     LinearProgressIndicator(value: vm.progress, minHeight: 3),

//                   // Full-screen loading spinner
//                   if (vm.isLoading)
//                     const Center(child: CircularProgressIndicator()),

//                   // Custom error UI
//                   if (vm.hasError)
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.wifi_off,
//                               size: 100, color: Colors.grey),
//                           const SizedBox(height: 20),
//                           const Text('Oops! Something went wrong.',
//                               style: TextStyle(fontSize: 18)),
//                           Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 24.0),
//                             child: Text(vm.errorMessage,
//                                 textAlign: TextAlign.center),
//                           ),
//                           const SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: vm.reloadWebView,
//                             child: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// File: lib/screens/webview_screen.dart

import 'package:SaverFavor/viewmodel/webview_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

/// Main WebView screen: full-screen under SafeArea,
/// uses aggressive caching so no ERR_FAILED on offline.
class WebViewScreen extends StatefulWidget {
  final InAppWebViewController? preloadedController;

  const WebViewScreen({Key? key, this.preloadedController}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebViewViewModel viewModel = WebViewViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove AppBar for full screen
      body: SafeArea(
        child: ChangeNotifierProvider<WebViewViewModel>(
          create: (_) => viewModel,
          child: Consumer<WebViewViewModel>(
            builder: (context, vm, _) => WillPopScope(
              onWillPop: vm.handleBackButton,
              child: Stack(
                children: [
                  InAppWebView(
                    key: const Key('main_webview'),
                    // 🍪 Initial URL request
                    initialUrlRequest:
                        URLRequest(url: WebUri('https://saverfavor.com/')),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        cacheEnabled: true, // ✅ enable HTML5 cache
                        clearCache: false, // ✅ keep cache between sessions
                      ),
                      android: AndroidInAppWebViewOptions(
                        /**
                         * 🍂 Android cache mode:
                         * - LOAD_CACHE_ELSE_NETWORK: use cache, only go network if not cached
                         * - This makes the WebView load whatever is stored locally first,
                         *   so offline = cached content displayed, no ERR_FAILED.
                         */
                        cacheMode: AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK,
                      ),
                      ios: IOSInAppWebViewOptions(
                        allowsLinkPreview: false,
                        // iOS uses NSURLRequestReturnCacheDataElseLoad
                        // by default if cacheEnabled = true
                      ),
                    ),

                    onWebViewCreated: (controller) {
                      // Use preloaded controller if available
                      if (widget.preloadedController != null) {
                        viewModel
                            .setWebViewController(widget.preloadedController!);
                        debugPrint('✔️ Using preloaded controller');
                      } else {
                        viewModel.setWebViewController(controller);
                        debugPrint('✔️ Using fresh controller');
                      }
                    },

                    onLoadStart: (controller, _) => vm.onPageStarted(),
                    onLoadStop: (controller, _) => vm.onPageFinished(),

                    // 🍂 Do NOT set hasError or show error UI
                    // onReceivedError: suppressed in ViewModel

                    onProgressChanged: (controller, progress) =>
                        vm.onProgressChanged(progress),
                  ),

                  // Top progress bar
                  if (vm.progress < 1.0)
                    LinearProgressIndicator(value: vm.progress, minHeight: 3),

                  // Full-screen loader
                  if (vm.isLoading)
                    const Center(child: CircularProgressIndicator()),

                  // NO ERRORS SHOWN: we removed vm.hasError block
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
