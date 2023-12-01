import 'package:bmi_cal/abc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BmiHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('BMI History'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => BmiPage()));
            },
          )),
      body: BmiHistoryList(),
    );
  }
}

class BmiHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    Color bmicolor = Colors.black;
    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

    CollectionReference bmiCollection =
        FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
      stream: bmiCollection.where('id', isEqualTo: user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<Widget> bmiEntries = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          String date = data['date_time'];
          String name = data['name'];
          double height = data['height'];
          double weight = data['weight'];
          double bmi = data['BMI'];

          if (weight > 0 && height > 0) {
            bmi = weight / ((height / 100) * (height / 100));
            // You can use the bmi value as needed
            // print('BMI: $bmi');
            if (bmi < 18.5) {
              bmicolor = Colors.lightBlue;
            } else if (bmi >= 18.5 && bmi < 25) {
              bmicolor = Colors.green;
            } else if (bmi >= 25 && bmi < 30) {
              bmicolor = Colors.orange;
            } else {
              bmicolor = Colors.red;
            }
          }

          bmiEntries.add(
            ListTile(
              title: Text('Date: $date'),
              subtitle:
                  Text('Name: $name\nHeight: $height cm, Weight: $weight kg'),
              trailing: Text(
                'BMI: ${bmi.toStringAsFixed(2)}',
                style: TextStyle(color: bmicolor),
              ),
            ),
          );
        }

        return ListView(
          children: bmiEntries,
        );
      },
    );
  }
}
