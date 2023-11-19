import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
}

class MyApp extends StatelessWidget {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // Mostrar un mensaje de error cuando se produce un error de carga.
            if (error.errorCode == -2) {
              // -2 indica que no hay conexión a Internet.
              showNoInternetDialog(context);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://blackholereview.great-site.net'));

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            // Widget para mostrar un mensaje cuando no hay conexión a Internet
            ConnectivityWidget(),
          ],
        ),
      ),
    );
  }

  void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No hay conexión a Internet'),
          content: Text('Por favor, verifica tu conexión a Internet y vuelve a intentarlo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ConnectivityWidget extends StatefulWidget {
  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !hasInternet,
      child: Center(
        child: Text(
          'No hay conexión a Internet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
