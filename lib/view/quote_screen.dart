import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_slide_show/model/quote.dart';
import 'package:quotes_slide_show/view/fav_quote_screen.dart';
import 'package:quotes_slide_show/view_model/bloc/quote_bloc.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  static const platform = MethodChannel('com.example.quotes_slide_show/share');
  List<Quote> quotes = [];
  List<Quote> favQuotes = [];
  final PageController _pageController = PageController();
  int _rating = 0;

  @override
  void initState() {
    BlocProvider.of<QuoteBloc>(context).add(FetchQuotes());
    super.initState();
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes Slideshow'),
      ),
      body: BlocBuilder<QuoteBloc, QuoteState>(
        builder: (context, state) {
          if (state is QuoteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is QuoteLoaded) {
            quotes.add(state.quote);
            return SingleChildScrollView(
              child: Column(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _setRating(0);
                      context.read<QuoteBloc>().add(FetchQuotes());
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.quote.content,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  state.quote.author,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return IconButton(
                                      icon: Icon(
                                        index < _rating
                                            ? Icons.star
                                            : Icons.star_border,
                                      ),
                                      color: Colors.amber,
                                      onPressed: () => _setRating(index + 1),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => _shareQuote(
                                      state.quote.content, state.quote.author),
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share'),
                                ),
                                const SizedBox(height: 20),
                                IconButton(
                                    onPressed: () =>
                                        (BlocProvider.of<QuoteBloc>(context)
                                            .favQuote
                                            .add(state.quote)),
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.amber,
                                      size: 50.0,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (
                      ctx,
                    ) =>
                                const FavQuoteScreen())),
                    icon: const Icon(Icons.navigation_outlined),
                    label: const Text('Navigate'),
                  ),
                ],
              ),
            );
          } else if (state is QuoteError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 24),
              ),
            );
          }
          return const Placeholder();
        },
      ),
    );
  }

  _favQuote(Quote quote) {
    favQuotes.add(quote);
  }

  Future<void> _shareQuote(String content, String author) async {
    try {
      final quote = '"$content" - $author';
      await platform.invokeMethod('share', {'quote': quote});
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Issue sharing quote: '${e.message}'.");
      }
    }
  }
}
