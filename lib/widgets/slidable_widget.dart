import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/db/db_helper.dart';
import 'package:untitled/models/quote.dart';

import 'package:untitled/pages/MainPage.dart';
import 'package:untitled/widgets/toast_widget.dart';

class SlidableWidget extends StatelessWidget{
  final Widget child;
  final Quote quote;
  SlidableWidget ({required this.child, required this.quote});

  @override
  Widget build(BuildContext context){
      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        child: child,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Share',
            color: Colors.green,
            icon: Icons.delete,
            onTap: (){
            },
          ),
          IconSlideAction(
            caption: 'Edit',
            color: Colors.blue[300],
            icon: Icons.edit,
            onTap: (){
              streamController.add(quote);
            },
          ),

          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: ()async{
              await DbHelper.instance.delete(quote.id!);
              showToast('Deleted');
            },
          ),
        ],
      );
  }
}