import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'abc.dart';
import 'package:intl/intl.dart';

class BmiHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => BmiPage()));
          },
        ),
      ),
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
      stream: bmiCollection
          .where('id', isEqualTo: user.uid)
          .orderBy("date_time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No BMI data available.'));
        }

        List<Widget> bmiEntries = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          var dateTime = data['date_time'];
          var name = data['name'];
          var height = data['height'];
          var weight = data['weight'];
          var bmi = data['BMI'];

          DateTime date = dateTime.toDate();
          var myDate = DateFormat('dd/MM/yyyy').format(date);

          if (weight > 0 && height > 0) {
            bmi = weight / ((height / 100) * (height / 100));

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
          // print(date);
          bmiEntries.add(
            ListTile(
              title: Text('Date: ${myDate}'),
              subtitle:
                  Text('Name: $name\nHeight: $height cm, Weight: $weight kg'),
              trailing: Text(
                'BMI: ${bmi.toStringAsFixed(2)}',
                style: TextStyle(color: bmicolor),
              ),
            ),
          );
        }

        // SizedBox(
        //   height: 10,
        // );
        return ListView(
          children: bmiEntries,
        );
      },
    );
  }
}
