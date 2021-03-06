// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrcode_app/db/db.dart';
import 'package:qrcode_app/models/scanner_model.dart';
import 'package:qrcode_app/views/result_page.dart';
import '../widgets/flushbar.dart';
import '../widgets/home_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper.instance;

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
                    "Usu??rio!",
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
                      child: button(
                        "Ler QR Code",
                        Icons.qr_code_scanner_outlined, 
                        (){
                          _scanQR(context);
                        }
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: button(
                        "Ler C??digo de Barras",
                        Icons.payment_sharp,
                        (){
                          _scanBarcode(context);
                        }
                      )
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: button(
                        "Resultados",
                        Icons.view_list_sharp,
                        (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultPage()));
                        }
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

  Future _scanQR(context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#E5E5E5', 
        'Cancelar', 
        true, 
        ScanMode.QR
      );

      if (barcodeScanRes != "-1") {
        Scanner scanner = Scanner(type: "QR", result: barcodeScanRes.toString());
        db.create(scanner);
        await buildFlushBar(
          context,
          barcodeScanRes.toString(), 
          Icons.qr_code_outlined,
          5
        );
      } else {
        await buildFlushBar(
          context,
          "Consulta Cancelada", 
          Icons.error_outline,
          3
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print(barcodeScanRes);
    }catch(e){
      print(e);
    }
  }

  Future _scanBarcode(context) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#E5E5E5', 
        'Cancelar', 
        true,
        ScanMode.BARCODE
      );

      if (barcodeScanRes != "-1") {
        Scanner scanner = Scanner(type: "BC", result: barcodeScanRes.toString());
        db.create(scanner);

        await buildFlushBar(
          context,
          barcodeScanRes.toString(), 
          Icons.payment_sharp,
          5
        );
      } else {
        await buildFlushBar(
          context, 
          "Consulta Cancelada", 
          Icons.error_outline,
          3
        );
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      print(barcodeScanRes);
    }catch(e){
      print(e);
    }

  }

}
