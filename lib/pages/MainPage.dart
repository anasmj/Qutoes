import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/db/db_helper.dart';
import 'package:untitled/models/quote.dart';
import 'package:untitled/widgets/quote_template.dart';
import 'package:untitled/widgets/slidable_widget.dart';
import 'dart:async';

import 'package:untitled/widgets/toast_widget.dart';
StreamController <Quote> streamController = StreamController();

class MainPage extends StatefulWidget {
  //const MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color appColor = const Color(0xff272350);
  TextEditingController quoteController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  bool isLoading = false;
  late List<Quote> quotes;
  late int noOfItem = 0;

  Future refresh () async{
    setState(()=> isLoading = true);
    quotes = await DbHelper.instance.readAll();
    setState(()=> isLoading = false);
  }

  @override
  void initState(){
    super.initState();
    refresh();
    countItem();
    streamController.stream.listen((quote){
        openBottomSheet(quote: quote);
    });
  }
  void openBottomSheet({required Quote quote}){
    setState(() {
      bottomSheet(context, quote: quote);
    });
  }
  @override
  void dispose(){
    super.dispose();
    DbHelper.instance.close();
  }
  void countItem () async => noOfItem = await DbHelper.instance.getCount();
  @override
  Widget build(BuildContext context) {
    countItem();
    refresh ();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColor, //Color(0xff272350),
      body: CustomScrollView(
        slivers:  <Widget> [
          SliverToBoxAdapter(
            child: FutureBuilder<List<Quote>>(
              future: DbHelper.instance.readAll(),
              builder: (BuildContext context, AsyncSnapshot<List<Quote>> snapshot){
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading..',style: TextStyle(color: Colors.white),),);
                }
                return snapshot.data!.isEmpty? const Center(
                          child: Text(
                            'Empty database',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: noOfItem,
                      itemBuilder: (BuildContext context, int index){
                        return SlidableWidget(
                          child: QuoteTemplate(quotes[index]),
                          quote: quotes[index],
                        );
                      },
                    );
              }
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        tooltip: 'Add new',
        backgroundColor: const Color(0x967C89DC),
        onPressed: () {
          setState(() {
            bottomSheet(context);
          });
        },
      ),
    );
  }

  void bottomSheet(BuildContext context, {Quote? quote}) {
    if (quote!=null){
      quoteController.text  = quote.description;
      authorController.text = quote.author;
    }
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            //height: 1000,
            decoration: BoxDecoration(
              //color: Color(0xff6A7980),
              color: appColor, // Colors.grey,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 80.0, right: 12.0, bottom: 12.0),
                  child: TextFormField(
                    controller: quoteController ,
                    autofocus: true,
                    cursorHeight: 30.0,
                    maxLength: 500,
                    maxLines: 5,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Quote',
                      labelStyle: const TextStyle(color: Colors.white) ,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //fillColor: Color(0xff58656C),
                      //filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: authorController,
                    maxLength: 50,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      //fillColor: Color(0xff58656C),
                      filled: true,
                      labelStyle: const TextStyle(color: Colors.white) ,
                      labelText: '- Author',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                //Save button
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 20, 120, 0),
                  child: RaisedButton(
                    onPressed: () {
                      if(quote!=null){
                        DbHelper.instance.delete(quote.id!);
                        DbHelper.instance.update(quote.copy(
                          id: quote.id,
                          description: quoteController.text,
                          author: authorController.text,

                        ));
                      }

                      DbHelper.instance.insert(Quote(
                          description: quoteController.text,
                          author: authorController.text,
                          isFavorite: false,
                      ));
                      refresh();
                      quoteController.clear();
                      authorController.clear();
                      Navigator.pop(context);
                      showToast('Saved');

                    },
                    color: const Color(0xC897C5F2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text("SAVE"),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    quoteController.clear();
                    authorController.clear();
                  },
                  color: const Color(0xC897C5F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        });
  }
}
