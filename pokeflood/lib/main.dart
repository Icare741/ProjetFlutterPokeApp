import 'package:flutter/material.dart';
import 'package:pokeflood/pokemonHome.dart';
import 'pokemonHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        
        '/pokemon': (context) => PokemonListWidget(key: Key('pokemon-list')),
      },
      title: 'Flutter Demo',
      initialRoute: '/pokemon',
      
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
    );
  }
}

