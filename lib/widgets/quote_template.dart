import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:untitled/models/quote.dart';

class QuoteTemplate extends StatefulWidget {
  final Quote quote;
  const QuoteTemplate (this.quote);
  State<StatefulWidget> createState(){
    return QuoteTemplateState();
  }
}

class QuoteTemplateState extends State<QuoteTemplate> {
  bool starred = false;

  Widget build(BuildContext context) {
    //Widget star = quote.status ? getStar() : getStarBorder();

    return Container(
      //outer container
      //color: Colors.redAccent,
      child: Container(
        // inner container
        //color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Column(
                // middle column
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                    //color: Colors.orange,
                    child: SelectableText(
                      widget.quote.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                        child: Text(
                          widget.quote.author,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40.0, 10.0, 0.0, 10.0),
                    child: Container(
                      height: 5.0,
                      width: 150.0,
                      color: Colors.amberAccent,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                //star,
                StarButton(
                  iconSize: 40.0,
                  isStarred: false,
                  valueChanged: (_isStarred) {
                    print('Is Starred : $_isStarred');
                  },

                ),

                IconButton(
                  icon: Icon(Icons.copy, color: Colors.white70,),
                  onPressed: () {
                    print("copy");
                    //TODO a snackbar saying 'coppied'
                  },
                  //splashColor: Colors.yellow,

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getStar() {
    return Icon(
      Icons.star,
      color: Colors.white70,

    );
  }

  getStarBorder() {
    return Icon(
      Icons.star_border,
      color: Colors.white70,
    );
  }
}