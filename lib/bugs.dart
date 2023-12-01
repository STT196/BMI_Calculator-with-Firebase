import 'package:flutter/material.dart';
import 'login.dart';

void bug(String error, BuildContext context) {
  // print("$error");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Error !',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                error,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void succs(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success !'),
        content: Text('Account has been created.'),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        ],
      );
    },
  );
}
