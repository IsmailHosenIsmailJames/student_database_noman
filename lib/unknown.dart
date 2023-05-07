import 'package:flutter/material.dart';

class Unknown extends StatelessWidget {
  const Unknown({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "404",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
