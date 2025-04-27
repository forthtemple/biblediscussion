
import 'package:flutter_tts/flutter_tts.dart';


import '../config/notifier.dart';


class SpeechSource  {

  static FlutterTts flutterTts=FlutterTts();

  static initialize() async
  {
    await flutterTts.awaitSpeakCompletion(true);

    flutterTts.setStartHandler(() {
      ///This is called when the audio starts

        Notifier.speechNotifier.value=[true,false];

    });
    SpeechSource.flutterTts.setPauseHandler(() {
      Notifier.speechNotifier.value=[false,true];

    });


    flutterTts.setContinueHandler(() {
      Notifier.speechNotifier.value=[true,false];


    });

    flutterTts.setCancelHandler(() {
      Notifier.speechNotifier.value=[false,false];


    });

    flutterTts.setCompletionHandler(() {
      ///This is called when the audio ends
          Notifier.speechNotifier.value=[false,false];

    });


  }

  static speak(String str) async
  {
    await flutterTts.speak(str.replaceAll("**","").replaceAll("###",""));

  }
/*
  static stop() async
  {
    await flutterTts.stop();

  }*/
}
