part of 'quote_bloc.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuotes extends QuoteEvent {}

class FetchFavQuotes extends QuoteEvent {}
