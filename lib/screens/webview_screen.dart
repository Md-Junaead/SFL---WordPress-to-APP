// File: lib/screens/webview_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sfl/viewmodel/webview_viewmodel.dart';

/// Main WebView screen: loads your site, shows progress bar, handles errors.
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final WebViewViewModel viewModel = WebViewViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<WebViewViewModel>(
        create: (_) => viewModel,
        child: Consumer<WebViewViewModel>(
          builder: (context, vm, _) => WillPopScope(
            onWillPop: vm.handleBackButton,
            child: Stack(
              children: [
                InAppWebView(
                  // 🔄 Use WebUri instead of Uri
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
                  onWebViewCreated: vm.setWebViewController,
                  onLoadStart: (controller, _) => vm.onPageStarted(),
                  onLoadStop: (controller, _) => vm.onPageFinished(),

                  // 🔄 Replace old onLoadError + manual WebResourceError
                  //     with the new onReceivedError callback:
                  onReceivedError: (controller, request, error) {
                    vm.onWebResourceError(error);
                  },

                  // 🔄 Progress updates 0–100
                  onProgressChanged: (controller, progress) =>
                      vm.onProgressChanged(progress),
                ),

                // ✅ Corrected LinearProgressIndicator usage:
                if (vm.progress < 1.0)
                  LinearProgressIndicator(
                    value: vm.progress, // <-- set progress here
                    minHeight: 3,
                  ),

                // Full-screen loading spinner
                if (vm.isLoading)
                  const Center(child: CircularProgressIndicator()),

                // Custom error screen
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
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
    );
  }
}
