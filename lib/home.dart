import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_promo/person.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Person> persons = [
    Person(title: '20%P', desc: 'desc 1'),
    Person(title: '20%P', desc: 'desc 2'),
    Person(title: '20%P', desc: 'desc 3'),
    Person(title: '20%P', desc: 'desc 1'),
    Person(title: '20%P', desc: 'desc 2'),
    Person(title: '20%P', desc: 'desc 3'),
    Person(title: '20%P', desc: 'desc 1')
  ];
  // ignore: unused_field
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode scan'),
          actions: [
            FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              onPressed: () => scanQR(),
              icon: Icon(Icons.camera_alt),
              label: Text('Scan QR'),
            ),
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(widget.email),
                  Column(
                      children: persons.map((p) {
                    return personDetailCard(p);
                  }).toList()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget personDetailCard(Person) {
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
                    Person.title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    Person.desc,
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
}
