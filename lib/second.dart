import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Second extends StatefulWidget {
  var messageone;
  Second({required this.messageone});
  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  var translator;
  var translation='';
  @override
  void initState() {
    translator = GoogleTranslator();
    temp();
    super.initState();
  }

  Future temp() async{
    var translation = await translator.translate(widget.messageone, to: 'ta');
    setState(() {
      this.translation =  translation.toString();;
      print(this.translation);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General"),
      ),
      body: Container(
        child: (this.translation!='')?Container(child: Text(this.translation),):CircularProgressIndicator(),
      ),
    );
  }
}