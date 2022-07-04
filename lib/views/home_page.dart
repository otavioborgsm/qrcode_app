// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:qrcode_app/db/db.dart';
import 'package:qrcode_app/models/scanner_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int id = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            150.0
          ),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top
            ),
            decoration: const BoxDecoration(
              gradient:  LinearGradient(
                colors: [
                  Color.fromARGB(255, 20, 33, 61),
                  Colors.black
                ]
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                )
              ]
            ),
            child: const Padding(
              padding: EdgeInsets.only(
                left: 30.0,
                top: 20.0,
                bottom: 20.0
              ),
              child: Text(
                'MyScanner',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 229, 229, 229)
                ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 229, 229, 229),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Text(
                    "Bem vindo,",
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                  Text(
                    "Usuário!",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      child: _button(
                        "Ler QR Code",
                        Icons.qr_code_scanner_outlined, 
                        () async {
                          _scanQR();
                        }
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: _button(
                        "Ler Código de Barras",
                        Icons.payment_sharp,
                        () async {
                          _scanBarcode();
                        }
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: _button(
                        "Resultados",
                        Icons.view_list_sharp,
                        (){}
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
    
  Widget _button(text, icon, onPressedFunction){
    return ElevatedButton(
      onPressed: onPressedFunction,
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 20, 33, 61),
        shadowColor: const Color.fromARGB(255, 20, 33, 61),
        elevation: 15.0
      ),
      child: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#E5E5E5', 
        'Cancelar', 
        true, 
        ScanMode.QR
      );

      if (barcodeScanRes != "-1") {
        id++;
        Scanner scanner = Scanner(id: id ,type: "QR", result: barcodeScanRes.toString());
        DB.instance.create(scanner);

        await _buildFlushBar(
          barcodeScanRes.toString(), 
          Icons.qr_code_outlined,
          5
        );
        print(DB.instance.read());
      } else {
        await _buildFlushBar(
          "Consulta Cancelada", 
          Icons.error_outline,
          3
        );
      }
      print(barcodeScanRes.toString());
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print(barcodeScanRes);
    }catch(e){
      print(e);
    }
  }

  Future _scanBarcode() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#E5E5E5', 
        'Cancelar', 
        true,
        ScanMode.BARCODE
      );

      if (barcodeScanRes != "-1") {
        id++;
        Scanner scanner = Scanner(id: id ,type: "BC", result: barcodeScanRes.toString());
        DB.instance.create(scanner);

        await _buildFlushBar(
          barcodeScanRes.toString(), 
          Icons.payment_sharp,
          5
        );
      } else {
        await _buildFlushBar( 
          "Consulta Cancelada", 
          Icons.error_outline,
          3
        );
      }
      print(barcodeScanRes.toString());
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print(barcodeScanRes);
    }catch(e){
      print(e);
    }

  }

  Future<Widget> _buildFlushBar(barcodeScanRes, icon, duration) async {
    return await Flushbar(
      icon: Icon(
          icon,
          color: Colors.white,
          size: 30
        ),
      message: barcodeScanRes.toString(),
      messageSize: 20,
      duration: Duration(seconds: duration),
    ).show(context);
  }
}
