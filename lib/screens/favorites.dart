import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Favorites',
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
