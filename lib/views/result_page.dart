import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:qrcode_app/db/db.dart';
import 'package:qrcode_app/models/scanner_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Resultados"),
          backgroundColor:const Color.fromARGB(255, 20, 33, 61),
        ),
        backgroundColor: const Color.fromARGB(255, 229, 229, 229),
        body: FutureBuilder<List<Scanner>>(
          future: DatabaseHelper.instance.read(),
          builder: (BuildContext context, AsyncSnapshot<List<Scanner>> snapshot){
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Carregando...")
                  ],
                ),
              );
            } 
            if (snapshot.data!.isEmpty) {
              return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Sem consultas na lista")
                ],
              ),
            );
            } else {
              return ListView(
              children: snapshot.data!.map((scanner){
                var icon = scanner.type == 'QR' ? Icons.qr_code_outlined : Icons.payment;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      icon
                    ),
                    title: Linkify(
                      onOpen: _onOpen,
                      text: scanner.result,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        DatabaseHelper.instance.delete(scanner);
                        setState(() {
                          
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            );
            }
          }
        ),
      )
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunchUrlString(link.url)) {
      await launchUrlString(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}