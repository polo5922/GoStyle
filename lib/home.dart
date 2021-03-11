import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scan_promo/card.dart';
import 'package:scan_promo/qr_result.dart';
import 'package:scan_promo/main.dart';

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
  final int lenght;

  Ids({
    this.ids,
    this.lenght,
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

  const HomePage({Key key, this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Ids> futureIds;
  // ignore: unused_field
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    futureIds = fetchIds(widget.email, 'get_scan_user');
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QrResult(
                    email: widget.email,
                    qrValue: _scanBarcode,
                  )));
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
          leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Email()));
              }),
          actions: [
            FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () => scanQR(),
              icon: Icon(Icons.camera_alt),
              label: Text('QR'),
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
              if (snapshot.data.lenght == 0) {
                return Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Pas de QR Code scanné",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var i = 0; i < snapshot.data.lenght; i++)
                        CardDisplay(
                          id: snapshot.data.ids[i],
                          email: widget.email,
                        ),
                    ],
                  ),
                );
              }
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
