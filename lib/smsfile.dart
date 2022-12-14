import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class smsapp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<smsapp> {
  late TextEditingController _controllerPeople, _controllerMessage;
  String? _message, body;
  String _canSendSMSMessage = 'Check is not run.';
  List<String> people = [];
  bool sendDirect = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: _controllerMessage.text,
        recipients: recipients,
        sendDirect: sendDirect,
      );
      setState(() => _message = "குறுஞ்செய்தி வெற்றிகரமாக அனுப்பப்பட்டது");
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  Future<bool> _canSendSMS() async {
    bool _result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
    return _result;
  }

  Widget _phoneTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => people.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    name,
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('குறுஞ்செய்தி அனுப்புதல்'),
          backgroundColor: Color.fromARGB(255, 246, 100, 2),
        ),
        body: ListView(
          children: <Widget>[
            if (people.isEmpty)
              const SizedBox(height: 0)
            else
              SizedBox(
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(people.length, (int index) {
                      return _phoneTile(people[index]);
                    }),
                  ),
                ),
              ),
            ListTile(
              
              leading: const Icon(Icons.people),
              title: TextField(
                controller: _controllerPeople,
                decoration: const InputDecoration(
                    hoverColor: Color.fromARGB(255, 255, 102, 0),
                    labelText: 'தொலைபேசி எண்ணைச் சேர்க்கவும்'),
                keyboardType: TextInputType.number,
                onChanged: (String value) => setState(() {}),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _controllerPeople.text.isEmpty
                    ? null
                    : () => setState(() {
                          people.add(_controllerPeople.text.toString());
                          _controllerPeople.clear();
                        }),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.message),
              title: TextField(
                decoration:
                    const InputDecoration(labelText: 'செய்தியைச் சேர்க்கவும்'),
                controller: _controllerMessage,
                onChanged: (String value) => setState(() {}),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 255, 102, 0),
                ),
                onPressed: () {
                  _send();
                },
                child: Text(
                  'அனுப்பு',
                  //style: Theme.of(context).textTheme.displayMedium,
                ),
                
              ),
            ),
            Visibility(
              visible: _message != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _message ?? 'தகவல் இல்லை',
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    if (people.isEmpty) {
      setState(() => _message = 'குறைந்தபட்சம் ஒரு கைபேசி எண்ணைச் சேர்க்கவும்');
    } else {
      _sendSMS(people);
    }
  }
}
