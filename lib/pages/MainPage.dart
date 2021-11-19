import 'package:flutter/material.dart';
import 'package:untitled/db/db_helper.dart';
import 'package:untitled/models/quote.dart';
import 'package:untitled/widgets/quote_template.dart';
import 'package:untitled/widgets/slidable_widget.dart';


class MainPage extends StatefulWidget {
  //const MainPage({Key key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color appColor = const Color(0xff272350);
  TextEditingController quoteController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  // static const List<Quote> quotes = [
  //   Quote(
  //       description:
  //           "The greatest glory in living lies not in never falling, but in rising every time we fall.",
  //       author: "- Nelson Mandela"),
  //   Quote(
  //       description:
  //           "The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.",
  //       author: "- Helen Keller"),
  //   Quote(
  //       description:
  //           "When you reach the end of your rope, tie a knot in it and hang on.",
  //       author: "- Franklin D. Roosevelt"),
  //   Quote(
  //       description:
  //           "If you look at what you have in life, you'll always have more. If you look at what you don't have in life, you'll never have enough.",
  //       author: " -Oprah Winfrey"),
  //   Quote(
  //       description:
  //           "If you set your goals ridiculously high and it's a failure, you will fail above everyone else's success.",
  //       author: "-James Cameron"),
  //   Quote(
  //       description:
  //           "Do not go where the path may lead, go instead where there is no path and leave a trail.",
  //       author: " -Ralph Waldo Emerson"),
  //   Quote(
  //       description:
  //           "The real test is not whether you avoid this failure, because you won't. It's whether you let it harden or shame you into inaction, or whether you learn from it; whether you choose to persevere.",
  //       author: " -Barack Obama"),
  //   Quote(
  //       description:
  //           "Success is not final; failure is not fatal: It is the courage to continue that counts",
  //       author: " -Winston S. Churchil"),
  //   Quote(
  //       description:
  //           "Success usually comes to those who are too busy to be looking for it.",
  //       author: "- Henry David Thoreau"),
  // ];
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
  }

  @override
  void dispose(){
    super.dispose();
    DbHelper.instance.close();
  }
  void countItem () async => noOfItem = await DbHelper.instance.getCount();
  Widget build(BuildContext context) {
    countItem();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColor, //Color(0xff272350),
      // body: Center(
      //   child: FutureBuilder<List<Quote>>(
      //     future: DbHelper.instance.readAllQuotes(),
      //     builder: (BuildContext context, AsyncSnapshot<List<Quote>> snapshot){
      //       if(!snapshot.hasData){
      //         return const Center(child: Text('Loading..'));
      //       }
      //       return snapshot.data!.isEmpty?
      //       const Center(child:Text('No item found')): ListView(
      //         children: snapshot.data!.map((e)=>Center(
      //           child: Card(
      //             child: ListTile(
      //               title: Text(e.description),
      //             ),
      //           ),
      //         )).toList(),
      //       );
      //     },
      //   ),
      // ),

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

      // body: CustomScrollView(
      //   slivers: <Widget>[
      //     SliverToBoxAdapter(
      //       child: ListView.builder(
      //         primary: false,
      //         shrinkWrap: true,
      //         itemCount: quotes.length,
      //         itemBuilder: (BuildContext context, int position) {
      //           return SlidableWidget(
      //             child: QuoteTemplate(quotes[position]),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),

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
              // primary: false,
              // shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 80.0, right: 12.0, bottom: 12.0),
                  child: TextFormField(
                    controller: quoteController ,
                    autofocus: true,
                    cursorHeight: 30.0,
                    maxLength: 500,
                    //cursorColor: Colors.red,
                    maxLines: 5,
                    style: const TextStyle(
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
                      DbHelper.instance.insert(Quote(
                          description: quoteController.text,
                          author: authorController.text));
                      refresh();
                      quoteController.clear();
                      authorController.clear();
                      Navigator.pop(context);
                    },
                    color: const Color(0xC897C5F2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text("SAVE"),
                  ),
                ),
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
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
