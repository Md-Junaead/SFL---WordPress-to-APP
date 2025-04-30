// import 'package:SaverFavor/viewmodel/webview_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:provider/provider.dart';

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({Key? key}) : super(key: key);

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final WebViewViewModel viewModel = WebViewViewModel();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Wrap everything in SafeArea to respect the status bar height
//       body: SafeArea(
//         child: ChangeNotifierProvider<WebViewViewModel>(
//           create: (_) => viewModel,
//           child: Consumer<WebViewViewModel>(
//             builder: (context, vm, _) => WillPopScope(
//               onWillPop: vm.handleBackButton,
//               child: Stack(
//                 children: [
//                   InAppWebView(
//                     // Ensure your URL uses WebUri
//                     initialUrlRequest: URLRequest(
//                       url: WebUri('https://saverfavor.com/'),
//                     ),
//                     initialOptions: InAppWebViewGroupOptions(
//                       crossPlatform: InAppWebViewOptions(
//                         javaScriptEnabled: true,
//                         cacheEnabled: true,
//                         clearCache: false,
//                       ),
//                     ),
//                     onWebViewCreated: vm.setWebViewController,
//                     onLoadStart: (controller, _) => vm.onPageStarted(),
//                     onLoadStop: (controller, _) => vm.onPageFinished(),
//                     onReceivedError: (controller, request, error) {
//                       vm.onWebResourceError(error);
//                     },
//                     onProgressChanged: (controller, progress) =>
//                         vm.onProgressChanged(progress),
//                   ),

//                   // Top loading bar
//                   if (vm.progress < 1.0)
//                     LinearProgressIndicator(
//                       value: vm.progress,
//                       minHeight: 3,
//                     ),

//                   // Full-screen loader
//                   if (vm.isLoading)
//                     const Center(child: CircularProgressIndicator()),

//                   // Error UI
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

class WebViewScreen extends StatefulWidget {
  final InAppWebViewController?
      preloadedController; // ← Accept optional controller

  const WebViewScreen({Key? key, this.preloadedController}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebViewViewModel viewModel = WebViewViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    initialUrlRequest: URLRequest(
                      url: WebUri('https://saverfavor.com/'),
                    ),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        cacheEnabled: true,
                        clearCache: false,
                      ),
                    ),
                    onWebViewCreated: (controller) {
                      // Use preloaded controller if available
                      if (widget.preloadedController != null) {
                        viewModel.setWebViewController(
                            widget.preloadedController!); // ← Use preloaded
                      } else {
                        viewModel
                            .setWebViewController(controller); // ← Fallback
                      }
                    },
                    onLoadStart: (controller, _) => vm.onPageStarted(),
                    onLoadStop: (controller, _) => vm.onPageFinished(),
                    onReceivedError: (controller, request, error) =>
                        vm.onWebResourceError(error),
                    onProgressChanged: (controller, progress) =>
                        vm.onProgressChanged(progress),
                  ),
                  if (vm.progress < 1.0)
                    LinearProgressIndicator(value: vm.progress, minHeight: 3),
                  if (vm.isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (vm.hasError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 100, color: Colors.grey),
                          const SizedBox(height: 20),
                          const Text('Oops! Something went wrong.',
                              style: TextStyle(fontSize: 18)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(vm.errorMessage,
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: vm.reloadWebView,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
