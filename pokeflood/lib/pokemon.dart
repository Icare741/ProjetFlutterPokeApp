class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;


  int? hp;
  int? attack;
  int? defense;
  int? speed;

  Pokemon(
    {required this.name, 
    required this.imageUrl, 
    required this.types,
   
    this.hp,
    this.attack,
    this.defense,
    this.speed});
}