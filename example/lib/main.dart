import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lottie/flutter_lottie.dart';

import 'page_dragger.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LottieController? controller;
  LottieController? controller2;
  late StreamController<double> newProgressStream;

  _MyAppState() {
    newProgressStream = new StreamController<double>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageDragger(
        stream: this.newProgressStream,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Lottie'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: 150,
                    height: 150,
                    child: LottieView.fromURL(
                      url:
                          "https://raw.githubusercontent.com/airbnb/lottie-ios/master/Example/Tests/EverythingBagel.json",
                      autoPlay: true,
                      loop: true,
                      reverse: true,
                      onViewCreated: onViewCreated,
                    )),
                TextButton(
                  child: Text("Play"),
                  onPressed: () {
                    controller?.play();
                  },
                ),
                TextButton(
                  child: Text("Stop"),
                  onPressed: () {
                    controller?.stop();
                  },
                ),
                TextButton(
                  child: Text("Pause"),
                  onPressed: () {
                    controller?.pause();
                  },
                ),
                TextButton(
                  child: Text("Resume"),
                  onPressed: () {
                    controller?.resume();
                  },
                ),
                Text("From File"),
                Container(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: LottieView.fromAsset(
                      filePath: "animations/newAnimation.json",
                      autoPlay: true,
                      loop: true,
                      reverse: true,
                      onViewCreated: onViewCreatedFile,
                    ),
                  ),
                ),
                TextButton(
                  child: Text("Change Color"),
                  onPressed: () {
                    // Set Color of KeyPath
                    this.controller2?.setValue(
                          value: LOTColorValue.fromColor(color: Color.fromRGBO(0, 0, 255, 1)),
                          keyPath: "body Konturen.Gruppe 1.Fläche 1",
                        );
                    // Set Opacity of KeyPath
                    this.controller2?.setValue(
                          value: LOTOpacityValue(opacity: 0.1),
                          keyPath: "body Konturen.Gruppe 1.Fläche 1",
                        );
                  },
                ),
                Text("Drag anywhere to change animation progress"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onViewCreated(LottieController controller) {
    this.controller = controller;

    // Listen for when the playback completes
    controller.onPlayFinished.listen((bool animationFinished) {
      print("Playback complete. Was Animation Finished? $animationFinished");
    });
  }

  void onViewCreatedFile(LottieController controller) {
    this.controller2 = controller;
    newProgressStream.stream.listen((double progress) {
      this.controller2?.setAnimationProgress(progress);
    });
  }

  void dispose() {
    super.dispose();
    newProgressStream.close();
  }
}
