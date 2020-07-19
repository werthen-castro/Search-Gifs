import 'package:busca_gifs_api/Home.dart';
import 'package:flutter/material.dart';

void main() => runApp(


    MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    )
);
