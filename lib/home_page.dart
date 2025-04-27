
/// List all books of the bible
import 'package:bible/bible.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'book_page.dart';

class HomePage extends StatefulWidget {

  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(); //'xx');
}

class _HomePageState extends State<HomePage> {

  List<Map<String, String>> booknames=[];


  @override
  void initState() {
    super.initState();

    getbooks();

  }

  getbooks() async
  {
    await Bible.initialize();

    setState(() {
      booknames=Bible.booknames;

    });

  }


  setbook(newbook)
  {
    Navigator.push(
      context,

      MaterialPageRoute(
          builder: (context) =>
              BookPage(book:newbook)), //JPage(groups: groups)),
    );

  }



  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery
        .of(context)
        .orientation;
    return Scaffold(
        body: Container(
          //height:  MediaQuery.of(context).size.height-200,
            decoration: BoxDecoration(
              color:Colors.white
            ),
             padding: EdgeInsets.only(top: 40),
            // constraints: BoxConstraints.expand(),
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [

                           booknames.length > 0
                              ? Align(
                               alignment:Alignment.center,
                               child:Wrap(children: [
                                for (var bookname in booknames)
                                  Padding(
                                     padding:EdgeInsets.only(right:0),
                          child:ElevatedButton(
                                      onPressed: (){
                                        setbook(bookname['value']);
                                      },
                                      style: TextButton.styleFrom(
                                          minimumSize: Size.zero, // Set this
                                          padding: EdgeInsets.all(0),//zero, // and this
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap
                                      ),
                                      child: Stack(
                                          children: [

                                            Image.asset(Bible.getimage(bookname['value']),width:100),
                                            Text(bookname['name'].toString(),style:TextStyle(fontSize:bookname['name'].toString().length>10?10:15, color:Colors.white,backgroundColor: Colors.black.withOpacity(0.5),))
                                          ]
                                      )
                                  ))

                          ]))
                              : SizedBox.shrink()
                        ],
                      )
                  )
              );
            }
            )
        )
    );


  }

  }