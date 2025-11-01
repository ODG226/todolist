class Rappels {
  final int? id;
  final String title;
  final DateTime dateTime;
  final String? imagePath; 
  Rappels(this.id, {required this.title, required this.dateTime, this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Rappels.fromMap(Map<String, dynamic> map) {
    return Rappels(
      map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      imagePath: map['imagePath'],
    );
  }
}