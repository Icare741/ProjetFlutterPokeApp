import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokeflood/pokemonStats.dart';
import 'dart:convert';
import 'pokemon.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokeflood/pokemonStats.dart';

class PokemonListWidget extends StatefulWidget {
  const PokemonListWidget({required Key key}) : super(key: key);

  @override
  _PokemonListWidgetState createState() => _PokemonListWidgetState();
}

class _PokemonListWidgetState extends State<PokemonListWidget> {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _searchResults = [];
  final _searchController = TextEditingController();
  bool _isLoading = true;
  var nexturl = "";
  late ScrollController _scrollController;
  List<Pokemon> pokemonList = [];

  @override
  void initState() {
    super.initState();
    _fetchPokemonList(
        Uri.parse('${dotenv.env['API_BASE_URL']}pokemon?limit=8'));
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollEnd);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
Future<Pokemon> _fetchPokemon(pokemon) async {
      final name = pokemon['name'];
      final idPokemon = pokemon['url'].split('/')[6];
      final imageUrl = '${dotenv.env['POKEMON_SPRITE_BASE_URL']}${idPokemon}.png';
      final typesUrl = await http.get(Uri.parse(pokemon['url']));
      final typesJson = jsonDecode(typesUrl.body);
      final types = List<String>.from(
          typesJson['types'].map((type) => type['type']['name']));
      final baseStats = typesJson['stats'];
      int hp = baseStats[0]['base_stat'];
      int attack = baseStats[1]['base_stat'];
      int defense = baseStats[2]['base_stat'];
      int speed = baseStats[5]['base_stat'];
      int specialattack = baseStats[3]['base_stat'];
      int specialdefense = baseStats[4]['base_stat'];
      int weight = typesJson['weight'];
      int height = typesJson['height'];
      List<String> abilities = List<String>.from(
          typesJson['abilities'].map((ability) => ability['ability']['name']));
      final speciesUrl = await http.get(Uri.parse(typesJson['species']['url']));
      final speciesJson = jsonDecode(speciesUrl.body);
      final flavorText = speciesJson['flavor_text_entries'].firstWhere(
          (entry) => entry['language']['name'] == 'en')['flavor_text'];
          return Pokemon(
        name: name,
        imageUrl: imageUrl,
        types: types,
        hp: hp,
        attack: attack,
        defense: defense,
        speed: speed,
        specialattack: specialattack,
        specialdefense: specialdefense,
        weight: weight.toDouble(),
        height: height.toDouble(),
        abilities: abilities,
        description: flavorText,
      );

}

  Future<void> _fetchPokemonList(Uri url) async {
    final response = await http.get(url);
    final json = jsonDecode(response.body);
    final results = json['results'];
    nexturl = json['next'];    
    for (var i = 0; i < results.length; i++) {
      final pokemon = results[i];
      pokemonList.add(await _fetchPokemon(pokemon));
    }

    setState(() {
      _pokemonList = pokemonList;
      _searchResults = pokemonList;
      _isLoading = false;
    });
  }

  Future<void> _onSearchTextChanged(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults = _pokemonList;
      });
    } else {
      List<Pokemon> searchResults = [];
      for (var i = 0; i < _pokemonList.length; i++) {
        if (_pokemonList[i]
            .name
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          searchResults.add(_pokemonList[i]);
        }
      }
      setState(() {
        _searchResults = searchResults;
      });
    }
    //   List<Pokemon> searchResults = [];
    //   final response = await http.get(Uri.parse('${dotenv.env['API_BASE_URL']}pokemon?name=${searchText}'));
    // final json = jsonDecode(response.body);
    // final results = json['results'];
    //  for (var i = 0; i < results.length; i++) {
    //   final pokemon = results[i];
    //   searchResults.add(await _fetchPokemon(pokemon));
     //}
   
  
    
  }

  void _onScrollEnd() {
    if (_scrollController.offset >=
      _scrollController.position.maxScrollExtent &&
      !_scrollController.position.outOfRange) {
      _fetchPokemonList(Uri.parse(nexturl));
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
                hintText: 'Recherche de Pokémon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
            controller: _scrollController,
              crossAxisCount: 2,
              children: _searchResults.map((pokemon) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PokemonStats(
                                  pokemon: pokemon,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(pokemon.name),
                          Image.network(pokemon.imageUrl),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  pokemon.types[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const Padding(
                                  padding: const EdgeInsets.all(10.0)),
                              if (pokemon.types.length > 1)
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    pokemon.types[1],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
