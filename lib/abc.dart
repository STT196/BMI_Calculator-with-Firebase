import 'package:bmi_cal/firebase_functions.dart';
import 'package:bmi_cal/history.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Gender { male, female }

class BmiPage extends StatefulWidget {
  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();

  String userName = '';
  String address = '';
  Gender gender = Gender.male;
  DateTime? dateOfBirth;
  double weight = 0.0;
  double height = 0.0;
  String comment = "";
  double bmi = 0.0;
  String result = '';
  Color bmicolor = Colors.black;
  int start = 0;
  int end = 0;

  String? user = FirebaseAuth.instance.currentUser!.email;
  // String displayname = user.email ?? "null";

  String? submitForm() {
    int? age = calculateAge();
    calculateBMI();

    setState(() {
      if (_formKey.currentState!.validate()) {
        result =
            'Result:\n Name: ${userName}\nAddress: ${address}\n Gender: ${gender == Gender.male ? 'Male' : 'Female'}\nDate of Birth: ${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}\nAge: $age\nWeight: ${weight} kg\nHeight: ${height} cm\nBMI: ${bmi.toStringAsFixed(2)}\nComment: $comment';
        savedata(
            userName,
            address,
            gender == Gender.male ? 'male' : 'female',
            "${dateOfBirth!.year}-${dateOfBirth!.month}-${dateOfBirth!.day}",
            age,
            weight,
            height,
            bmi,
            comment);
      }
    });

    start = result.indexOf('Comment:');
    end = start + 'Comment:'.length;
  }

  String? resetForm() {
    setState(() {
      _weight.clear();
      _height.clear();
      _name.clear();
      _address.clear();
      height = 0;
      weight = 0;
      result = '';
    });
  }

  int? calculateAge() {
    if (dateOfBirth != null) {
      final currentDate = DateTime.now();
      int age = currentDate.year - dateOfBirth!.year;
      if (currentDate.month < dateOfBirth!.month ||
          (currentDate.month == dateOfBirth!.month &&
              currentDate.day < dateOfBirth!.day)) {
        age--;
      }
      return age;
    }
  }

  int? calculateBMI() {
    if (weight > 0 && height > 0) {
      bmi = weight / ((height / 100) * (height / 100));
      // You can use the bmi value as needed
      // print('BMI: $bmi');
      if (bmi < 18.5) {
        comment = 'Underweight';
        bmicolor = Colors.lightBlue;
      } else if (bmi >= 18.5 && bmi < 25) {
        comment = 'Normal weight';
        bmicolor = Colors.green;
      } else if (bmi >= 25 && bmi < 30) {
        comment = 'Overweight';
        bmicolor = Colors.orange;
      } else {
        comment = 'Obese';
        bmicolor = Colors.red;
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                logout(context);
              },
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Gender:'),
                    SizedBox(width: 20),
                    Radio(
                      value: Gender.male,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value as Gender;
                        });
                      },
                    ),
                    Icon(Icons.male),
                    Text('Male'),
                    SizedBox(width: 20),
                    Radio(
                      value: Gender.female,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value as Gender;
                        });
                      },
                    ),
                    Icon(Icons.female),
                    Text('Female'),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text("Date of Birth"),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        setState(() {
                          if (selectedDate == null) {
                            final selectedDate = DateTime.now();
                          } else {
                            dateOfBirth = selectedDate;
                          }
                        });
                      },
                      label: Text('Select Date '),
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _weight,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (in kgs)',
                    prefixIcon: Icon(Icons.scale_outlined),
                  ),
                  onChanged: (value) {
                    setState(() {
                      weight = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _height,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Height (in cms)',
                      prefixIcon: Icon(Icons.straighten)),
                  onChanged: (value) {
                    setState(() {
                      height = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your Height';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: submitForm,
                      icon: Icon(Icons.calculate),
                      label: Text(
                        'Calculate',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    ElevatedButton.icon(
                      onPressed: resetForm,
                      icon: Icon(Icons.restart_alt),
                      label: Text(
                        'Reset',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                if (result.isNotEmpty)
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: result.substring(0, 7),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: result.substring(7, end),
                            style: TextStyle(fontSize: 17),
                          ),
                          TextSpan(
                            text: result.substring(end),
                            style: TextStyle(
                              color: bmicolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Text(result)
                  )
              ],
            )),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BmiHistoryPage()));
        },
        child: Icon(Icons.history),
      ),
    );
  }
}
