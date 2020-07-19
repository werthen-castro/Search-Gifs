import 'dart:convert';

import 'package:busca_gifs_api/page_gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'key.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const  String labelText = 'Digite aqui sua pesquisa';
  static const String loadMore = 'Carregar mais';
  static const String api = 'https://api.giphy.com/v1/gifs';
  static const imageNetwork = 'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif';

  String _search;
  int offset = 0;
  int qtd = 9;

  Future<Map> getGifs() async{
    http.Response response;
    if(_search == null || _search.isEmpty){
      response = await http.get("$api/trending?api_key=$key&limit=20&rating=G");
    }else{
      response = await http.get("$api/search?api_key$key&q=$_search&limit=$qtd&offset=$offset&rating=G&lang=pt");
    }

    return json.decode(response.body);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(imageNetwork),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 18,),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle:  TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text){
                    setState(() {
                      _search = text;
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getGifs(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                        break;
                      default:
                        if(snapshot.hasError) return Container();
                        else return _createGifTable(context, snapshot);
                    }
                  },
                )
              )
            ],
          ),
      ),
    );
  }

  int _getCount(List data){
    if(_search == null || _search.isEmpty){
      return data.length;
    }else{
      return data.length + 1;
    }
  }

  Widget _createGifTable(context, snapshot){
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemCount: _getCount( snapshot.data["data"]),
      itemBuilder: (context,index){
        if (_search == null || index < snapshot.data['data'].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:  (context) => Gif(snapshot.data["data"][index]) ));
            },

            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70,),
                  Text(loadMore, style: TextStyle(color: Colors.white),)
                ],
              ),
              onTap: (){
                setState(() {
                  offset += 9;
                  //qtd += 9;
                });

              },
            ),
          );
      }
    );
  }
}
