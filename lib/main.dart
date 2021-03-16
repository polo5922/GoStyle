import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_promo/login.dart';
import 'package:scan_promo/register.dart';
//import 'package:scan_promo/home.dart';

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Email();
  }
}

class Email extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Gostyle")),
        body: Center(
          child: MyEmailInput(),
        ),
      ),
    );
  }
}

class MyEmailInput extends StatefulWidget {
  MyEmailInput({Key key}) : super(key: key);

  @override
  _MyEmailInputState createState() => _MyEmailInputState();
}

class _MyEmailInputState extends State<MyEmailInput> {
  final myControllerEmail = TextEditingController();
  final myControllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 0.0, bottom: 20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez compléter le champ';
                  }
                  if (value.contains('@') == false) {
                    return 'Mettez un email valide';
                  }
                  return null;
                },
                controller: myControllerEmail,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 60.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Veuillez compléter le champ';
                  }
                  return null;
                },
                controller: myControllerPassword,
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(
                                  email: myControllerEmail.text,
                                  password: myControllerPassword.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Connexion'),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register(
                                          email: myControllerEmail.text,
                                          password: myControllerPassword.text,
                                        )));
                          }
                        },
                        child: Text('Inscription'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
