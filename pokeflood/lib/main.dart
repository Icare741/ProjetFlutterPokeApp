import 'package:flutter/material.dart';
import 'package:pokeflood/pokemonHome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pokemonHome.dart';

void main()async {
  await dotenv.load(fileName: "lib/.env");  //path to your .env file);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        
        '/pokemon': (context) => const PokemonListWidget(key: Key('pokemon-list')),
        
        
      },
      title: 'Flutter Demo',
      initialRoute: '/pokemon',
      
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
    );
  }
}

