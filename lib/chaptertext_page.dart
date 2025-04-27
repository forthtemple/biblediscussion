/// List the chapter raw text as bbe or king james
import 'package:bible/bible.dart';

import 'package:bible/source/speech_source.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'config/notifier.dart';

class ChapterTextPage extends StatefulWidget {
  final book; //loggedInUser;
  // const JoinExistingGroupPage({super.key});
  final chapter; //loggedInUser;
  final bbe;

  ChapterTextPage(
      {Key? key, required this.book, required this.chapter, this.bbe})
      : super(key: key);

  @override
  _ChapterTextPageState createState() => _ChapterTextPageState(); //'xx');
}

class _ChapterTextPageState extends State<ChapterTextPage> {

  List chaptertext = [];
  String speechtext="";

  Map currentbook = {};  // The current book chosen


  List<Map<String, String>> chapters = [];

  @override
  void initState() {
    super.initState();
    // player = AudioPlayer(); // Create a player

    // getpurchased();
    //player = AudioPlayer();
    SpeechSource.flutterTts.stop();
    setbook(widget.book);
  }

  // Display chapter of the book chosen
  setbook(newbook) {
    setState(() {

      currentbook = Bible.books[widget.book];

      chapters = Bible.getchapters(widget.book); //chaptersii;
      for (final chapterii in currentbook['chapters']) {
        // print("ooo"+chapterii.toString()+" "+chapter);
        if (chapterii['chapter'] == widget.chapter) {
          //   print("ooo"+chap)
        //  desc = chapterii['desc']!;
          for (final verse in chapterii['verses']) {

            if (widget.bbe != null && widget.bbe) {
              chaptertext.add([verse['verse'], verse['bbe']]);
              speechtext+=verse['bbe']+" ";
            }  else {
              chaptertext.add([verse['verse'], verse['text']]);
              speechtext+=verse['text']+" ";
            }

          }
        }
      }
    });

  }

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
        onWillPop: () async {
      // Do something here
      //  print("After clicking the Android Back Button");
      SpeechSource.flutterTts.stop();
      return true;
    },child:Scaffold(
        appBar: AppBar(
          title: Row(
        children:[Text(Bible.books[widget.book]['book'] +
              " Chpt " +
              widget.chapter+(widget.bbe!=null&&widget.bbe?"-Basic":"")),
          ValueListenableBuilder(
              valueListenable: Notifier.speechNotifier,
              builder: (context, speechNotifier, _) {
                final speaking = speechNotifier[0];
                final paused = speechNotifier[1];
                return Row(children: [
                  speechtext != "" && (!speaking || paused)
                      ? IconButton(
                      icon: Icon(Icons.play_arrow),
                      //tooltip: 'Increase volume by 10',
                      onPressed: () async {
                        await SpeechSource.speak(speechtext);
                        // speaking=SpeechSource.speaking;
                      })
                      : speechtext != "" && speaking && !paused
                      ? IconButton(
                      icon: Icon(Icons.pause),
                      //tooltip: 'Increase volume by 10',
                      onPressed: () async {
                        await SpeechSource.flutterTts.pause();
                        // speaking=SpeechSource.speaking;
                      })
                      : SizedBox.shrink(),
                  speechtext != "" && (speaking || paused)
                      ? IconButton(
                      icon: Icon(Icons.stop),
                      //tooltip: 'Increase volume by 10',
                      onPressed: () async {
                        await SpeechSource.flutterTts.stop();
                        // speaking=SpeechSource.speaking;
                      })
                      : SizedBox.shrink()
                ]);
              })
        ]), //'Purchase'),
        ),
        body: Container(
            //height:  MediaQuery.of(context).size.height-200,
            decoration: BoxDecoration(
              color:Colors.white

                ),
            padding: EdgeInsets.only(top: 10, left: 2, right: 10),
            // constraints: BoxConstraints.expand(),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(Bible.getimage(widget.book,  chapter:widget.chapter,random:true),
                                width: 200),
                            SizedBox(height: 20),

                            // Text(desc + "\n------"),

                            for (final verse in chaptertext)
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(bottom: 7),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Padding(padding:EdgeInsets.only(top:4),
                                      child:Text(verse[0],
                                                style: TextStyle(fontSize: 12))),
                                      Flexible(child:Text(verse[1],
                                          style: TextStyle(fontSize: 18)))]
                                      ))),
                          ])
                      // : SizedBox.shrink()

                      ));
            }))));
    //),
    //);
  }
}
