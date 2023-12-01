import 'package:bmi_cal/bugs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    String email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Reset password email sent successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Password Reset',
            ),
            content: Text('A password reset email has been sent to $email.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Home())); // Navigate back to the previous page
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle reset password error
      bug('${e}', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
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
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.mail)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
