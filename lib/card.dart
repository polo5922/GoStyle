import 'package:flutter/material.dart';

class Produits {
  final String title;
  final String desc;

  Produits({required this.title, required this.desc});

  factory Produits.fromJson(Map<String, dynamic> json) {
    return Produits(desc: json['desc'], title: json['title']);
  }
}

Widget personDetailCard(id) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  desc,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
