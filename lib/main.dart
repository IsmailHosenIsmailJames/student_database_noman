import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'unknown.dart';
import 'authontication.dart';
import 'firebase_options.dart';
import 'login.dart';
import 'signup.dart';
import 'student_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPI Student Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Authentication(),
      onGenerateRoute: (settings) {
        final List<String> paths = settings.name!.split('/');
        if (paths[0] != '') {
          return null;
        } else if (paths[1] == 'home') {
          return MaterialPageRoute(
            builder: (BuildContext context) => const StudentHome(),
          );
        } else if (paths[1] == 'login') {
          return MaterialPageRoute(
            builder: (BuildContext context) => const LogIn(),
          );
        } else if (paths[1] == 'signup') {
          return MaterialPageRoute(
            builder: (BuildContext context) => const SignUp(),
          );
        } else {
          return MaterialPageRoute(
            builder: (BuildContext context) => const Unknown(),
          );
        }
      },
    );
  }
}
