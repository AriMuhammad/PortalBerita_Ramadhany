import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:portalberita_rama/detailberita.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'detailberita.dart';
import 'beritaitem.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      'https://newsapi.org/v2/everything?q=motogp&apiKey=c7376717adf94b908a537c4b87ef181b';

  List data;
  var extractdata;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      extractdata = jsonDecode(response.body);
      data = extractdata["articles"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MotoGP News 2019'),
      ),
      body: ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return ListTile(
            onTap: () {
              var nextPage = MaterialPageRoute(
                  builder: (context) => DetailBerita(
                        title: data[i]["title"].toString(),
                        description: data[i]["description"].toString(),
                        image: data[i]["urlToImage"].toString(),
                        content: data[i]["content"].toString(),
                        publishedAt: data[i]["publishedAt"].toString(),
                        author: data[i]["author"].toString(),
                      ));
              Navigator.push(context, nextPage);
            },
            title: Text(data[i]["title"].toString()),
            subtitle: Text(data[i]["publishedAt"]),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(data[i]["urlToImage"] == null
                  ? 'https://uae.microless.com/cdn/no_image.jpg'
                  : data[i]["urlToImage"].toString()),
            ),
          );
        },
      ),
    );
  }
}
