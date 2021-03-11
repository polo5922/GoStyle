import 'package:flutter/material.dart';
import 'package:scan_promo/home.dart';
import 'package:http/http.dart' as http;

Future<String> fetchData(id, type, email) async {
  var queryParameters = {
    'id': id.toString(),
    'type': type,
    'email': email,
  };
  String url = 'tartapain.bzh';
  var uri = Uri.https(url, '/api/scan/set.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load the post');
  }
}

class Remove extends StatefulWidget {
  final int id;
  final String email;

  const Remove({Key key, this.email, this.id}) : super(key: key);

  @override
  _Remove createState() => _Remove();
}

class _Remove extends State<Remove> {
  Future<String> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(widget.id, 'remove', widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Supression du scan'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(email: widget.email)));
              }),
        ),
        body: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Loading..."));
                    }
                    if (snapshot.hasData) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 200.0, bottom: 200.0),
                        child: Center(
                          child: Container(
                            width: 280,
                            height: 50,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: new BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                snapshot.data,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      );
                    } else {
                      return CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black));
                    }
                  }),
              FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                email: widget.email,
                              )))
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Retour'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
