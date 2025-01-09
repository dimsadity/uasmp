class Data {
  final int? id;
  final String title;
  final String description;
  final int userId;

  Data({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
  });

  // Convert Data object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': userId,
    };
  }

  // Create Data object from Map
  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      userId: map['user_id'],
    );
  }
}
