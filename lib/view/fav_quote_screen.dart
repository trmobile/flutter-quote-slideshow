import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_slide_show/view_model/bloc/quote_bloc.dart';

class FavQuoteScreen extends StatefulWidget {
  const FavQuoteScreen({super.key});

  @override
  State<FavQuoteScreen> createState() => _FavQuoteScreenState();
}

class _FavQuoteScreenState extends State<FavQuoteScreen> {
  @override
  void initState() {
    BlocProvider.of<QuoteBloc>(context).add(FetchFavQuotes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuoteBloc, QuoteState>(
      builder: (context, state) {
        if (state is FavQuoteLoaded) {
          return ListView.builder(
              itemCount: state.favQuotes.length,
              itemBuilder: (_, index) {
                final quote = state.favQuotes[index];
                return ListTile(
                  title: Text(quote.content),
                  subtitle: Text(quote.author),
                );
              });
        }
        return const Placeholder();
      },
    );
  }
}
