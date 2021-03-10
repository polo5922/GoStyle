import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_promo/person.dart';
import 'package:scan_promo/card.dart';

Future<Ids> fetchIds(email, type) async {
  var queryParameters = {
    'type': type,
    'email': email,
  };
  String url = 'tartapain.bzh';
  var uri = Uri.https(url, '/api/scan/get.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    return Ids.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class Ids {
  final List<dynamic> ids;
  final String lenght;

  Ids({
    required this.ids,
    required this.lenght,
  });

  factory Ids.fromJson(Map<String, dynamic> json) {
    return Ids(
      ids: json['ids'],
      lenght: json['lenght'],
    );
  }
}

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Ids> futureIds;
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
    futureIds = fetchIds(widget.email, 'get_scan_user');
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
        body: FutureBuilder(
          initialData: [],
          future: futureIds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading..."));
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(widget.email),
                    Column(
                      children: [
                        for (var i = 0;
                            i < int.parse(snapshot.data.lenght);
                            i++)
                          {
                            //Text(i.toString()),
                            personDetailCard(snapshot.data.ids[i]),
                          }
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black));
            }
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names

}
