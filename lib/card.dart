import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Data> fetchData(id, type) async {
  var queryParameters = {
    'type': type,
    'id': id.toString(),
  };
  String url = 'tartapain.bzh';
  var uri = Uri.https(url, '/api/scan/get.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Data.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class Data {
  final String title;
  final String desc;

  Data({
    this.title,
    this.desc,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    print(json['desc'] + " " + json['title'] + "\n");
    return Data(
      desc: json['desc'],
      title: json['title'],
    );
  }
}

class CardDisplay extends StatefulWidget {
  final int id;

  const CardDisplay({Key key, this.id}) : super(key: key);

  @override
  _CardDisplay createState() => _CardDisplay();
}

class _CardDisplay extends State<CardDisplay> {
  Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(widget.id, 'get_info_id');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              FutureBuilder(
                  future: futureData,
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Loading..."));
                    }
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            snapshot.data.title,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          Text(
                            snapshot.data.desc,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      );
                    } else {
                      return CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
