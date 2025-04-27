/// Display the selected chapter of the book
import 'package:bible/bible.dart';

import 'package:bible/source/speech_source.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


import 'chaptertext_page.dart';

import 'config/notifier.dart';

class ChapterPage extends StatefulWidget {
  final book;//loggedInUser;
  // const JoinExistingGroupPage({super.key});
   final chapter;//loggedInUser;

   ChapterPage({
    Key? key,
     required this.book,
    required this.chapter,
  }) : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState(); //'xx');
}

class _ChapterPageState extends State<ChapterPage> {

  String desc="";

  Map currentbook={};  // The current book that are looking at

  List<Map<String, String>> chapters=[];


  @override
  void initState() {
    super.initState();

    SpeechSource.flutterTts.stop();

    setbook(widget.book);

  }

  // Set the chapter of the book currently selected
  setbook(newbook)
  {
    setState(() {
      currentbook=Bible.books[widget.book];
      chapters=Bible.getchapters(widget.book);
      for (final chapterii in  currentbook['chapters']) {
        if (chapterii['chapter'] == widget.chapter) {
          desc = chapterii['desc']!;
        }
      }
    });
  }


  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return WillPopScope(
        onWillPop: () async {

      SpeechSource.flutterTts.stop();
      return true;
    },child:Scaffold(

          appBar: AppBar(
            title: Row(
        children:[Text(Bible.books[widget.book]['book']+" Chapter "+widget.chapter),
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
        ]),//'Purchase'),
          ),


        body: Container(
          //height:  MediaQuery.of(context).size.height-200,
            decoration: BoxDecoration(
              color:Colors.white

            ),
             padding: EdgeInsets.only(top: 0,left:0,right:0),
            // constraints: BoxConstraints.expand(),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
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
                          children: [
                      Container(

                      width:orientation==Orientation.landscape? MediaQuery.of(context).size.width / 2:double.infinity,
                      child:

                      Column(
                        children: [
                          Container(
                    //  color:Colors.black,
                          child:
                              Column(
                                children:[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children:[
                                Column(

                                  children:[

                                    ElevatedButton(
                                  //padding:EdgeInsets.all(0),
                                    onPressed: (){
                                      Navigator.push(
                                        context,

                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChapterTextPage(book:widget.book,chapter:widget.chapter)), //JPage(groups: groups)),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                        minimumSize: Size.zero, // Set this
                                        padding: EdgeInsets.all(0),//zero, // and this
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                    ),
                                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap

                                    child: Stack(
                                        children: [

                                          Image.asset('images/kingjames.png', width:130,fit: BoxFit.fill),
                                          // Icon(Icons.menu_book, size:15),
                                          Padding(padding:EdgeInsets.only(top:0),
                                              child:Text("King James", style:TextStyle(fontSize: 18,color:Colors.white, backgroundColor: Colors.black.withOpacity(0.5))))
                                        ]
                                    )
                                ),

                                    ElevatedButton(
                                      //padding:EdgeInsets.all(0),
                                        onPressed: (){
                                          Navigator.push(
                                            context,

                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChapterTextPage(book:widget.book,chapter:widget.chapter, bbe:true)), //JPage(groups: groups)),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                            minimumSize: Size.zero, // Set this
                                            padding: EdgeInsets.all(0),//zero, // and this
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                        ),

                                        child: Stack(
                                            children: [
                                              //'images/'+bookname['value'].toString()+'.png'
                                              Image.asset('images/england.png', width:130,fit: BoxFit.fill),
                                              // Icon(Icons.menu_book, size:15),
                                              Padding(padding:EdgeInsets.only(top:0),
                                                  child:Text("Basic English", style:TextStyle(fontSize: 18, color:Colors.white,backgroundColor: Colors.black.withOpacity(0.5))))
                                            ]
                                        )
                                    ),
                                  ]),


                                Expanded(
                                    child:Image.asset(Bible.getimage(widget.book, chapter:widget.chapter, random: true),width: double.infinity,
                                    fit: BoxFit.fill,)),//,height:100)),
                              ]
                          ),

                          ]
                              )
              )
             ] )),

                  Container(
                      width: orientation==Orientation.landscape?MediaQuery.of(context).size.width / 2:double.infinity,
                            child:

                            Padding(
                                padding:EdgeInsets.only(left:5, right:5),
                               child:
                               MarkdownBody(
                                 styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                                     textTheme: TextTheme(
                                         bodyMedium: TextStyle(
                                             fontSize:18.0)))),
                                 //controller: controller,
                                 //  selectable: true,
                                 data: desc,
                                 // )
                               )// Text(desc , style:TextStyle(fontSize: 18))
                            ))
                          ]),
                          )

              );
            }
            )
        )
    ));

  }

  }