import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: const Center(
        child: Text(
          "Setting",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
