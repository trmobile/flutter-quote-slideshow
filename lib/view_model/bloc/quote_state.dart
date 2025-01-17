part of 'quote_bloc.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

final class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final Quote quote;

  const QuoteLoaded(this.quote);

  @override
  List<Object> get props => [quote];
}

class FavQuoteLoaded extends QuoteState {
  final List<Quote> favQuotes;

  const FavQuoteLoaded(this.favQuotes);

  @override
  List<Object> get props => [favQuotes];
}

class QuoteError extends QuoteState {
  final String message;

  const QuoteError(this.message);

  @override
  List<Object> get props => [message];
}
