import 'package:flutter/material.dart';
import 'package:scan_promo/home.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

Future<String> fetchData(email, type, password) async {
  var queryParameters = {
    'email': email,
    'type': type,
    'password': password,
  };
  String url = 'tartapain.bzh';
  var uri = Uri.https(url, '/api/scan/get.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load the post');
  }
}

class Register extends StatefulWidget {
  final String email;
  final String password;

  const Register({Key key, this.email, this.password}) : super(key: key);

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  Future<String> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData(widget.email, 'register', widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
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
                    if (snapshot.data == 'good:register')
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 200.0, bottom: 200.0),
                            child: Center(
                              child: Container(
                                width: 280,
                                height: 50,
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Vous êtes inscrit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                            icon: Icon(Icons.check),
                            label: Text('Suivant'),
                          ),
                        ],
                      );
                    if (snapshot.data == 'bad:register')
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 200.0, bottom: 200.0),
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
                                    "Inscription invalide",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Email()))
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Page d\'inscription'),
                          ),
                        ],
                      );
                    if (snapshot.data == 'bad:register:email_used')
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 200.0, bottom: 200.0),
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
                                    "Email déjà utilisé",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Email()))
                            },
                            icon: Icon(Icons.arrow_back),
                            label: Text('Page de connexion'),
                          ),
                        ],
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
