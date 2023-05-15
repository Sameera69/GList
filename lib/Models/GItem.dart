class GItem {
  String id;
  String name;
  String imageUrl;

  GItem({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory GItem.fromMap(Map<String, dynamic> map) {
    return GItem(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }
}
