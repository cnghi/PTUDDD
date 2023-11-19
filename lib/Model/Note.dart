class Note {
  String id;
  String title;
  String content;
  DateTime dateadded;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateadded,
  });

  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "title": title,
      "content": content,
      "dateadded": dateadded
    });
  }
}
