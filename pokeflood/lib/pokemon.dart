import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon(this.name, this.imageUrl);
}

class PokemonListWidget extends StatefulWidget {
  const PokemonListWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonListWidgetState createState() => _PokemonListWidgetState();
}

class _PokemonListWidgetState extends State<PokemonListWidget> {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _searchResults = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();
    
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchPokemonList() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    final json = jsonDecode(response.body);
    final results = json['results'];

    List<Pokemon> pokemonList = [];
    for (var i = 0; i < results.length; i++) {
      final pokemon = results[i];
      final name = pokemon['name'];
      final url = pokemon['url'];
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final imageUrl = json['sprites']['front_default'];

      pokemonList.add(Pokemon(name, imageUrl));
    }

    setState(() {
      _pokemonList = pokemonList;
      _searchResults = pokemonList;
    });
  }

  void _onSearchTextChanged(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults = _pokemonList;
      });
    } else {
      List<Pokemon> searchResults = [];
      for (var i = 0; i < _pokemonList.length; i++) {
        if (_pokemonList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
          searchResults.add(_pokemonList[i]);
        }
      }
      setState(() {
        _searchResults = searchResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste de Pokémons'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Recherche',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: _searchResults.map((pokemon) {
          return GestureDetector(
            onTap:  () {
              print(pokemon.name);
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemon.imageUrl),
                  const SizedBox(height: 8),
                  Text(pokemon.name),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
