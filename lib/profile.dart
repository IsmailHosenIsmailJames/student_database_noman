// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget imageProfile = const CircularProgressIndicator();
  Widget profileData = const CircularProgressIndicator();
  bool oneTimeCall = true;
  void getProfileLink() async {
    try {
      final ref = FirebaseFirestore.instance
          .collection("profile")
          .doc(FirebaseAuth.instance.currentUser!.email);
      final json = await ref.get();
      if (!json.exists) {
        imageProfile = const Icon(Icons.broken_image);
        showModalBottomSheet(
          context: context,
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                if (!kIsWeb) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowCompression: true,
                    type: FileType.custom,
                    allowMultiple: false,
                    allowedExtensions: ['jpg', 'png'],
                  );
                  if (result != null) {
                    final tem = result.files.first;
                    String? extension = tem.extension;
                    File imageFile = File(tem.path!);

                    String uploadePath =
                        "${"user"}/${FirebaseAuth.instance.currentUser!.email}.$extension";
                    final ref =
                        FirebaseStorage.instance.ref().child(uploadePath);
                    UploadTask uploadTask;
                    uploadTask = ref.putFile(imageFile);
                    final snapshot = await uploadTask.whenComplete(() {});
                    String url = await snapshot.ref.getDownloadURL();
                    final temRef = FirebaseFirestore.instance
                        .collection("profile")
                        .doc(FirebaseAuth.instance.currentUser!.email);
                    try {
                      await temRef.set({'url': url.toString()});
                    } catch (e) {
                      await temRef.update({'url': url.toString()});
                    }
                  }
                }
                if (kIsWeb) {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom,
                          allowMultiple: false,
                          allowCompression: true,
                          allowedExtensions: ['jpg', 'png']);

                  if (result != null) {
                    final tem = result.files.first;
                    Uint8List? selectedImage = tem.bytes;
                    String? extension = tem.extension;

                    String uploadePath =
                        "profile/${FirebaseAuth.instance.currentUser!.email}.$extension";
                    final ref =
                        FirebaseStorage.instance.ref().child(uploadePath);
                    UploadTask uploadTask;
                    final metadata =
                        SettableMetadata(contentType: 'image/jpeg');
                    uploadTask = ref.putData(selectedImage!, metadata);
                    final snapshot = await uploadTask.whenComplete(() {});
                    String url = await snapshot.ref.getDownloadURL();
                    final temRef = FirebaseFirestore.instance
                        .collection("profile")
                        .doc(FirebaseAuth.instance.currentUser!.email);
                    try {
                      await temRef.set({'url': url.toString()});
                    } catch (e) {
                      await temRef.update({'url': url.toString()});
                    }
                  }
                }
                Navigator.pop(context);
                Navigator.pop(context);
                getProfileLink();
              },
              child: const Text("Uploade Profile Photo"),
            ),
          ),
        );
        return;
      }
      String profile = json['url'];
      setState(() {
        imageProfile = SizedBox(
          height: 350,
          width: 350,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Image.network(
              profile,
              fit: BoxFit.cover,
            ),
          ),
        );
      });
      final jsonData = await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      String name = jsonData["name"];
      String roll = jsonData["roll"];
      String reg = jsonData["reg"];
      setState(() {
        profileData = Column(
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
    } catch (e) {
      imageProfile = const Icon(Icons.broken_image);
    }
    setState(() {
      oneTimeCall == false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (oneTimeCall) getProfileLink();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageProfile,
            const SizedBox(
              height: 20,
            ),
            profileData,
          ],
        ),
      ),
    );
  }
}
