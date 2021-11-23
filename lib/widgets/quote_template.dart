import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/db/db_helper.dart';
import 'package:untitled/models/quote.dart';
import 'package:untitled/widgets/toast_widget.dart';

class QuoteTemplate extends StatefulWidget {
  Quote quote;
  QuoteTemplate (this.quote);
  @override
  State<StatefulWidget> createState(){
    return QuoteTemplateState();
  }
}

class QuoteTemplateState extends State<QuoteTemplate> {
  bool starred = false;

  @override
  Widget build(BuildContext context) {
    //Widget star = quote.status ? getStar() : getStarBorder();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            // middle column
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                //color: Colors.orange,
                child: SelectableText(
                  widget.quote.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 0.0),
                    child: Text(
                      widget.quote.author,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 10.0, 0.0, 10.0),
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
                widget.quote.isFavorite = _isStarred;
                DbHelper.instance.update(widget.quote.copy(id:widget.quote.id));
              },

            ),

            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white70,),
              onPressed: () async {
                await FlutterClipboard.copy(widget.quote.description);
                showToast('Copied');
              },
              //splashColor: Colors.yellow,

            ),
          ],
        ),
      ],
    );
  }
}