
const String quoteTable = 'quotes';

class QuoteFields{
  static final List<String>values = [
    id, description, author, isFavorite,
  ];
  static const String id = '_id';
  static const String description = 'description';
  static const String author = 'author';
  static const String isFavorite = 'ifFavorite';
}

class Quote {
  final int? id;
  final String description;
  final String author;
  final bool isFavorite;

  const Quote({
    this.id,
    required this.description,
    this.author ='',
    this.isFavorite = false
  });
  Quote copy({
    int? id,
    String? description,
    String? author,
    bool? isFavorite,
  }) =>
      Quote(
    id: id?? this.id,
    description: description ?? this.description,
    author: author ?? this.author,
    isFavorite: isFavorite?? this.isFavorite,
  );
  static Quote fromMaptoObj (Map<String, Object?> json) => Quote (
    id: json[QuoteFields.id] as int,
    description: json[QuoteFields.description] as String,
    author: json[QuoteFields.author] as String,
    isFavorite: json[QuoteFields.isFavorite] ==1
  );
  Map<String, Object?> fromObjtoMap()=> {
    QuoteFields.id: id,
    QuoteFields.description: description,
    QuoteFields.author: author,
    QuoteFields.isFavorite: isFavorite? 1: 0,
  };

}

