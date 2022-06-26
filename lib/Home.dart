import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperaPreco() async{
    String url = "https://www.blockchain.com/pt/ticker";
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: _recuperaPreco(),
        builder:  (context, snapshot){
          var resultado;
          switch(snapshot.connectionState){
            case ConnectionState.done:
              // sucesso e erro
              resultado = "carregado";
              if(snapshot.hasError){
                resultado = "Erro ao carregar os dados";
              }else{
                double valor = snapshot.data!["BRL"]["buy"];
                resultado = "Valor do bitcoin: ${valor.toString()}";
              }
              break;
              //sem conexão
            case ConnectionState.none:
              resultado = "Sem conexão";
              break;
              //carregando
            case ConnectionState.waiting:
              resultado = "Carregando...";
             break;
          }
        //Configuração do widget
          return Center(
            child: Text(resultado),
          );
        },
    );
  }
}
