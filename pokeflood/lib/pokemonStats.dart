
import 'package:flutter/material.dart';

import 'pokemon.dart';


class PokemonStats extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonStats({required this.pokemon, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Stats'),
      ),
      body: Center(
        child: Text(pokemon.name),
        
        
        
      ),
    );
  }
}