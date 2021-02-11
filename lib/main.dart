import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

  const request = "https://economia.awesomeapi.com.br/json/all";

void main() async{

  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Color.fromRGBO(240, 240, 242, 100),
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(240, 240, 242, 100))),
        hintStyle: TextStyle(color: Color.fromRGBO(240, 240, 242, 100)),
      )),
    ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);


  }
  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro*this.euro/dolar).toStringAsFixed(2); 
  }

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(170, 177, 191, 100),
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder:(context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",
                  style: TextStyle(color:
                  Color.fromRGBO(240, 240, 242, 100), fontSize: 25),
                )
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao Carregar Dados.",
                    style: TextStyle(color:
                    Color.fromRGBO(240, 240, 242, 100), fontSize: 25),
                  )
                );
              }
            else{
              dolar = double.parse(snapshot.data["USD"]["bid"]);
              euro = double.parse(snapshot.data["EUR"]["bid"]);
              return SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      "images/LOGOMARCA.png",
                      fit: BoxFit.fitWidth,
                      //height: 240.0,
                    ),
                    buildTextField("Real", "R\$", realController, _realChanged),
                    Divider(),
                    buildTextField("Dolar", "US\$", dolarController,_dolarChanged),
                    Divider(),
                    buildTextField("Euro", "€\$", euroController, _euroChanged)
                  ],
                ),
              );
            }
          }
        },
        ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return  TextField (
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(),
      prefixText: prefix,  
    ),
    style: TextStyle(
      color: Colors.white,
      fontSize: 25,
    ) ,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}