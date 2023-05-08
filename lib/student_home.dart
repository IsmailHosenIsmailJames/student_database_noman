import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_database/authontication.dart';
import 'package:student_database/profile.dart';
import 'package:student_database/settings.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  Widget initialWidget = const CircularProgressIndicator();
  Widget profilePhoto =
      const SizedBox(height: 40, width: 40, child: CircularProgressIndicator());
  bool oneTimeCall = true;
  void getData() async {
    try {
      final jsonData = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      String name = jsonData["name"];
      String roll = jsonData["roll"];
      String reg = jsonData["reg"];
      setState(() {
        initialWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Text(
              "Roll : $roll",
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              "Registation : $reg",
              style: const TextStyle(fontSize: 25),
            ),
          ],
        );
        oneTimeCall = false;
      });
      final ref = FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.email);
      final json = await ref.get();
      setState(() {
        if (json.exists) {
          profilePhoto = Image.network(
            json['url'],
            fit: BoxFit.cover,
          );
        } else {
          profilePhoto = const Icon(
            Icons.person,
            size: 70,
          );
        }
      });
    } catch (e) {
      setState(() {
        profilePhoto = const Icon(Icons.broken_image);
        initialWidget = const Text("No Data");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (oneTimeCall) getData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.person),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Profile'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Setting(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.settings),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Setting'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Authentication(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 5,
                      ),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: profilePhoto,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            initialWidget,
          ],
        ),
      ),
    );
  }
}
