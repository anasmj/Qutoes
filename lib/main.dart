import 'package:flutter/material.dart';
import 'package:untitled/pages/MainPage.dart';

void main() => runApp(QuoteApp());

class QuoteApp extends StatefulWidget{
  @override
  State<QuoteApp> createState() => _QuoteAppState();
}
class _QuoteAppState extends State<QuoteApp> {
  Color appColor = const Color(0xff272350);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Your quotes',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}


