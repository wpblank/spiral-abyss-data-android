import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String MIHOYO = 'https://bbs.mihoyo.com/ys/home/26';
  static const String HOYOLAB = 'https://www.hoyolab.com/home';

  String url = MIHOYO;

  final controller = Completer<WebViewController>();

  void selectServer(String server) {
    controller.future.then((web) {
      url = server;
      web.runJavascript("window.location.href = '$url'");
    });
  }

  void upload() {
    controller.future.then((web) {
      String server;
      if (url == MIHOYO) {
        server = "";
      } else if (url == HOYOLAB) {
        server = "global/";
      } else {
        return;
      }
      web.runJavascript("javascript:(function () { "
          "const s = document.createElement('script'); "
          "s.src = 'https://abyss.izumi.pub/spiralAbyss/${server}js/local'; "
          "document.body.append(s) })();");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("米游社数据上传"),
      ),
      body: WebView(
        initialUrl: MIHOYO,
        onWebViewCreated: (webViewController) {
          controller.complete(webViewController);
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(), // 底部导航栏打一个圆形的洞
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => selectServer(MIHOYO),
              child: const Text('国服', style: TextStyle(color: Colors.black87)),
            ),
            const SizedBox(),
            TextButton(
              onPressed: () => selectServer(HOYOLAB),
              child: const Text('国际服', style: TextStyle(color: Colors.black87)),
            ),
          ], //均分底部导航栏横向空间
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: upload,
        child: Image.asset(
          "images/upload.png",
          width: 32,
          height: 32,
        ),
      ),
    );
  }
}
