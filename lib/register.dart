import 'package:bmi_cal/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'bugs.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _registerUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      succs(context);

      // Registration successful, navigate to next page
    } catch (e) {
      // Handle registration error
      // print("Error: $e");
      bug("$e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("BMI Calculator",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                const Text(
                  "Register to App",
                  style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 44.0,
                ),
                TextFormField(
                  controller: _emailController,
                  // validator: (value),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(
                        Icons.mail,
                      )),
                ),
                const SizedBox(
                  height: 26,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(
                        Icons.mail,
                      )),
                  obscureText: true,
                ),
                const SizedBox(height: 88),
                Container(
                  width: double.infinity,
                  child: RawMaterialButton(
                    fillColor: const Color(0xFF0069FE),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: _registerUser,
                    child: const Text("Register",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
