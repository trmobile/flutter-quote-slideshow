// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/quote.dart';
import '../../model/services/api_service.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final ApiService apiService;
  List<Quote> favQuote = [];
  QuoteBloc(this.apiService) : super(QuoteInitial()) {
    on<QuoteEvent>((event, emit) async {
      if (event is FetchQuotes) {
        emit(QuoteLoading());
        try {
          final quotes = await apiService.fetchFastestQuote();
          emit(QuoteLoaded(quotes));
        } catch (e) {
          emit(QuoteError(e.toString()));
        }
      } else if (event is FetchFavQuotes) {
        emit(QuoteLoading());
        try {
          final quotes = favQuote;
          emit(FavQuoteLoaded(quotes));
        } catch (e) {
          emit(QuoteError(e.toString()));
        }
      }
    });
  }
}
