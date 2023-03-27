class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> abilities;
  


  int? hp;
  int? attack;
  int? defense;
  int? speed;
  int? specialattack;
  int? specialdefense;
  double? weight;
  double? height;
  String? description;


  Pokemon(
    {required this.name, 
    required this.imageUrl, 
    required this.types,
    required this.abilities,
    this.hp,
    this.attack,
    this.defense,
    this.speed,
    this.specialattack,
    this.specialdefense,
    this.weight,
    this.height,
    this.description,});
}