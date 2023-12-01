import 'package:bmi_cal/login.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void logout(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Log Out'),
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()));
            },
          ),
        ],
      );
    },
  );
}

void savedata(
    name, address, gender, dob, age, weight, height, bmi, comment) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference userdata = FirebaseFirestore.instance.collection('users');

  // DateTime? datetime = DateTime.now();
  // String finaldate = " ${datetime.year}-${datetime.month}-${datetime.day}";

  Map<String, dynamic> users = {
    "id": user?.uid,
    "date_time": Timestamp.now(),
    "name": name,
    'address': address,
    'gender': gender,
    'dob': dob,
    'age': age,
    "weight": weight,
    "height": height,
    "BMI": bmi,
    "comment": comment,
  };
  await userdata.add(users);
}
