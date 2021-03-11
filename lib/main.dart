import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_promo/home.dart';
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
        appBar: AppBar(title: const Text("Gostyle - login")),
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
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 150.0, bottom: 60.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Entrer votre email',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ne pas rentrer de valeur vide';
                }
                if (value.contains('@') == false) {
                  return 'Metre un email valide';
                }
                return null;
              },
              controller: myController,
            ),
          ),
          Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(email: myController.text)));
                      }
                    },
                    child: Text('Valider'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomePage(email: myController.text)));
                    }
                  },
                  child: Text('S\'inscrire'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
