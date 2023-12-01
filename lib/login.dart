import 'package:bmi_cal/abc.dart';
import 'package:bmi_cal/bugs.dart';
import 'package:bmi_cal/password_reset.dart';
import 'package:bmi_cal/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Login());
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // static Feature<User?> loginUserEmail
  Future<void> _loginButtonPrssed() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BmiPage()));
        // User has successfully logged in
      } catch (e) {
        // Handle login errors
        bug("$e", context);
        // print("Error: $e");
      }
    } else {
      bug("Username or Password is empthy", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                "Login to App",
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
                    hintText: "User Email",
                    prefixIcon: Icon(
                      Icons.mail,
                    )),
              ),
              const SizedBox(
                height: 26,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "User Password",
                    prefixIcon: Icon(
                      Icons.lock,
                    )),
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()));
                },
                child: const Text(
                  "Don't remember password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: const Color(0xFF0069FE),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: _loginButtonPrssed,
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 20),
              Text("Don't have an account?"),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Color.fromARGB(255, 73, 96, 128),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                  },
                  child: const Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
