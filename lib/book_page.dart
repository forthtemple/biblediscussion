/// List information about a book of a bible and its chapters
import 'package:bible/bible.dart';

import 'package:bible/source/speech_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'chapter_page.dart';

import 'config/notifier.dart';

class BookPage extends StatefulWidget {

  final book; //loggedInUser;

  BookPage({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState(); //'xx');
}

class _BookPageState extends State<BookPage> {

  String desc = "";

  Map currentbook = {};

  List<Map<String, String>> chapters = [];


  @override
  void initState() {
    super.initState();

    setbook(widget.book);
    SpeechSource.flutterTts.stop();


  }

  setbook(newbook) {
    setState(() {

      currentbook = Bible.books[widget.book];

      chapters = Bible.getchapters(widget.book); //chaptersii;
      desc = currentbook['desc']!;
    });
  }

  setchapter(newchapter) {
    Navigator.push(
      context,

      MaterialPageRoute(
          builder: (context) => ChapterPage(
              book: widget.book,
              chapter: newchapter)), //JPage(groups: groups)),
    );
  }

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
        onWillPop: () async {
          // Do something here
          //  print("After clicking the Android Back Button");
          SpeechSource.flutterTts.stop();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Row(children: [
                Text(Bible.books[widget.book]['book']),
                ValueListenableBuilder(
                    valueListenable: Notifier.speechNotifier,
                    builder: (context, speechNotifier, _) {
                      final speaking = speechNotifier[0];
                      final paused = speechNotifier[1];
                      return Row(children: [
                        desc != "" && (!speaking || paused)
                            ? IconButton(
                                icon: Icon(Icons.play_arrow),
                                //tooltip: 'Increase volume by 10',
                                onPressed: () async {
                                  await SpeechSource.speak(desc);
                                  // speaking=SpeechSource.speaking;
                                })
                            : desc != "" && speaking && !paused
                                ? IconButton(
                                    icon: Icon(Icons.pause),
                                    //tooltip: 'Increase volume by 10',
                                    onPressed: () async {
                                      await SpeechSource.flutterTts.pause();
                                      // speaking=SpeechSource.speaking;
                                    })
                                : SizedBox.shrink(),
                        desc != "" && (speaking || paused)
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
              ]), //, style:TextStyle(color:Colors.black)),//'Purchase'),
              //  backgroundColor: Colors.white,
            ),
            body: Container(
                //height:  MediaQuery.of(context).size.height-200,
                decoration: BoxDecoration(
                  color: Colors.white
                    /* image: DecorationImage(
            image: AssetImage("icon/background.jpg"),
            fit: BoxFit.cover,
          ),*/
                    ),
                padding: EdgeInsets.only(top: 0, left: 0),
                // constraints: BoxConstraints.expand(),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight:  constraints.maxHeight,
                         //   maxHeight:600
                          ),
                          child: Flex(
                              //    mainAxisSize : MainAxisSize.min,
                              direction: orientation == Orientation.landscape
                                  ? Axis.horizontal
                                  : Axis.vertical,
                              crossAxisAlignment:
                                  orientation == Orientation.landscape
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,
                              //  crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                          Container(

                              width:orientation==Orientation.landscape? MediaQuery.of(context).size.width / 2:double.infinity,
                                 child:
                                 Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Container(
                                          //  color:Colors.black,

                                          child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Wrap(
                                                  // alignment: WrapAlignment.start,
                                                  //  runAlignment:WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.up,
                                                  //  direction: Axis.horizontal,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  children: [
                                                    for (var chapter
                                                        in chapters.reversed)
                                                      (int.parse(chapter['value']
                                                                          .toString()) -
                                                                      1) <
                                                                  chapters.length /
                                                                      2 ||
                                                              chapters.length <
                                                                  10
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 0,
                                                                      bottom:
                                                                          0),
                                                              child: ElevatedButton(
                                                                  //padding:EdgeInsets.all(0),
                                                                  onPressed: () {
                                                                    setchapter(
                                                                        chapter[
                                                                            'value']);
                                                                  },
                                                                  style: TextButton.styleFrom(
                                                                      minimumSize: Size.zero,
                                                                      // Set this
                                                                      padding: EdgeInsets.all(0),
                                                                      //zero, // and this
                                                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                                                  //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap

                                                                  child: Stack(children: [
                                                                    //'images/'+bookname['value'].toString()+'.png'
                                                                    Image.asset(
                                                                        Bible.getangelimage(
                                                                            chapter) ,
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        fit: BoxFit
                                                                            .fill),
                                                                    // Icon(Icons.menu_book, size:15),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child: Text(
                                                                            " " +
                                                                                chapter['value'].toString(),
                                                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color:Colors.white,backgroundColor: Colors.black.withOpacity(0.5))))
                                                                  ])))
                                                          : SizedBox.shrink()
                                                  ])))),
                      Image.asset(Bible.getimage(widget.book),width: double.infinity,
                        fit: BoxFit.fill,),//fit:BoxFit.fitWidth),
                                  //,width:200),
                                  Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Container(
                                          //  color:Colors.black,

                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Wrap(children: [
                                                for (var chapter in chapters)
                                                  (int.parse(chapter['value']
                                                                      .toString()) -
                                                                  1) >=
                                                              chapters.length /
                                                                  2 &&
                                                          chapters.length >= 10
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 0,
                                                                  bottom: 0),
                                                          child: ElevatedButton(
                                                              //padding:EdgeInsets.all(0),
                                                              onPressed: () {
                                                                setchapter(
                                                                    chapter[
                                                                        'value']);
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      minimumSize:
                                                                          Size
                                                                              .zero,
                                                                      // Set this
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              0),
                                                                      //zero, // and this
                                                                      tapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap),
                                                              //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap

                                                              child: Stack(
                                                                  children: [

                                                                    Image.asset(
                                                                        Bible.getangelimage(
                                                                            chapter) ,
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        fit: BoxFit
                                                                            .fill),
                                                                    // Icon(Icons.menu_book, size:15),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top:
                                                                                10),
                                                                        child: Text(
                                                                            " " +
                                                                                chapter['value'].toString(),
                                                                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color:Colors.white,backgroundColor: Colors.black.withOpacity(0.5))))
                                                                  ])))
                                                      : SizedBox.shrink()
                                              ])))),
                                ])),
                    //  SizedBox(width:orientation==Orientation.landscape?10:0),
                      Container(

                          width: orientation==Orientation.landscape?MediaQuery.of(context).size.width / 2:double.infinity,
                          child:Padding(
                                        padding: EdgeInsets.only(
                                            left: orientation==Orientation.landscape?15:5, right: 5, top: 5),
                                        child:
                                       // SizedBox(height:100,
                                           MarkdownBody(
                                               styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                                                 textTheme: TextTheme(
                                                     bodyMedium: TextStyle(
                                                         fontSize:18.0)))),

                                          data: desc,
                                       // )
                                        ),
                                      /*  Text(desc,
                                            style: TextStyle(fontSize: 18))*/

                          )),

                              ])


                          ));
                }))));
    //),
    //);
  }
}
