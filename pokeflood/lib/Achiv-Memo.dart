import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonListWidget extends StatefulWidget {
  @override
  _PokemonListWidgetState createState() => _PokemonListWidgetState();
}

class _PokemonListWidgetState extends State<PokemonListWidget> {
  List<dynamic>? pokemonList = [];
  List<dynamic>? filteredPokemonList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPokemonList();
  }

  Future<void> getPokemonList() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse('https://mon-api-pokemon.vercel.app/api/v1/pokemon'));

    if (response.statusCode == 200) {
      setState(() {
        pokemonList = json.decode(response.body);
        print(pokemonList);
        filteredPokemonList = pokemonList;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

  void filterPokemonList(String searchText) {
    setState(() {
      filteredPokemonList = pokemonList!
          .where((pokemon) => pokemon['name']['fr'].toString().toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (text) {
                filterPokemonList(text);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: filteredPokemonList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final pokemon = filteredPokemonList![index];
                      return Card(
                        child: ListTile(
                          leading: pokemon['sprites']['regular'] != null
                              ? Image.network(pokemon['sprites']['regular'])
                              : SizedBox(),
                          title: pokemon['name']['en'] != null
                              ? Text(pokemon['name']['en'])
                              : SizedBox(),
                          subtitle: pokemon['type'] != null ? Text(pokemon['type'].join(', ')) : SizedBox(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
