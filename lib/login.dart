// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_database/authontication.dart';
import 'package:student_database/signup.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final key = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: key,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.asset(
                        "img/tpi.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "Please enter a valid email.";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "type your email...",
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: pass,
                    obscureText: true,
                    enableSuggestions: false,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Password is too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "type your password...",
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        try {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: pass.text);

                          Navigator.pop(context);
                          Navigator.pop(context);

                          Fluttertoast.showToast(
                            msg: "LogIn Successfull",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[700],
                            textColor: Colors.white,
                          );
                        } on FirebaseAuthException catch (e) {
                          Fluttertoast.showToast(
                            msg: e.message!,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[700],
                            textColor: Colors.white,
                          );
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Authentication(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Login'),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.login)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Haven\'t account ?'),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUp(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
