import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_slide_show/model/Utility/helper_functions.dart';

import '../quote.dart';

class ApiService {
  final List<String> apiUrls = [
    'https://api.quotable.io/random',
    'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en'
  ];

  final List<Quote> localQuotes = [
    Quote(
        content:
            'The only limit to our realization of tomorrow is our doubts of today.',
        author: 'Franklin D. Roosevelt'),
    Quote(
        content: 'The purpose of our lives is to be happy.',
        author: 'Dalai Lama'),
    Quote(
        content: 'Life is what happens when you’re busy making other plans.',
        author: 'John Lennon'),
    Quote(
        content:
            'The greatest glory in living lies not in never falling, but in rising every time we fall.',
        author: 'Nelson Mandela'),
    Quote(
        content: 'The way to get started is to quit talking and begin doing.',
        author: 'Walt Disney'),
  ];

  // fetches a quote from the given url
  Future<Quote> fetchQuoteFromApi(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl),
        headers: HelperFunctions.getApiHeaders());

    if (response.statusCode == 200) {
      String resString = (response.body).replaceAll(r"\'", "'");
      Map<String, dynamic> body = json.decode(resString);
      return Quote.fromJson(body, apiUrl);
    } else {
      throw Exception('Failed to load quote from $apiUrl');
    }
  }

  // fetches the fastest quote from available sources
  Future<Quote> fetchFastestQuote() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // when offline return a random local quote
      var random = Random();
      return localQuotes[random.nextInt(5)];
    } else {
      List<Future<Quote>> futures =
          apiUrls.map((url) => fetchQuoteFromApi(url)).toList();
      return Future.any(futures);
    }
  }
}
