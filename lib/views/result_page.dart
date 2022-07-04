import 'package:flutter/material.dart';
import 'package:qrcode_app/db/db.dart';
import 'package:qrcode_app/models/scanner_model.dart';

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
                'Resultados',
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
            return snapshot.data!.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Sem consultas na lista")
                ],
              ),
            )
            : ListView(
              children: snapshot.data!.map((scanner){
                return ListTile(
                  title: Text(scanner.result),
                );
              }).toList(),
            );
          }
        ),
      )
    );
  }
}