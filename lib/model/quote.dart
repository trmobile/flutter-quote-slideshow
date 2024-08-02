class Quote {
  final String content;
  final String author;

  Quote({required this.content, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json, String apiUrl) {
    if (apiUrl.contains('quotable.io')) {
      return Quote(
        content: json['content'],
        author: json['author'],
      );
    } else if (apiUrl.contains('forismatic.com')) {
      return Quote(
        content: json['quoteText'],
        author: json['quoteAuthor'] ?? 'Unknown',
      );
    } else {
      throw Exception('Unknown API URL');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Quote &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          author == other.author;

  @override
  int get hashCode => content.hashCode ^ author.hashCode;
}
