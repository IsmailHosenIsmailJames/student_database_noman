// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authontication.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final key = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  final conpass = TextEditingController();
  final name = TextEditingController();
  final roll = TextEditingController();
  final reg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: key,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: name,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Name is too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "type your name...",
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: roll,
                    validator: (value) {
                      try {
                        int.parse(value!);
                        return null;
                      } catch (e) {
                        return "Roll is not Correct";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "type your roll...",
                      labelText: "Roll",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: reg,
                    validator: (value) {
                      try {
                        int.parse(value!);
                        return null;
                      } catch (e) {
                        return "registation number is not Correct";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "type your registation...",
                      labelText: "Registation",
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
                      if (value!.length < 6) {
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
                  TextFormField(
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: conpass,
                    obscureText: true,
                    enableSuggestions: false,
                    validator: (value) {
                      if (pass.text != value) {
                        return "Did't massed";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Type your password again",
                      labelText: "Confirm password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 05,
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
                              .createUserWithEmailAndPassword(
                                  email: email.text.trim(),
                                  password: pass.text.trim());
                          final ref = FirebaseFirestore.instance
                              .collection("user")
                              .doc(email.text);
                          await ref.set({
                            "name": name.text,
                            "roll": roll.text,
                            "reg": reg.text,
                          });
                          Fluttertoast.showToast(
                            msg: "Sign Up successfull",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[700],
                            textColor: Colors.white,
                          );
                          Navigator.pop(context);
                        } on FirebaseException catch (e) {
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
                        Text('Sign Up'),
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
                      const Text('Already haven account ?'),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogIn(),
                            ),
                          );
                        },
                        child: const Text('Log In'),
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
