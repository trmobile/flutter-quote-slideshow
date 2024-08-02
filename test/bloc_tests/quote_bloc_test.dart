import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:quotes_slide_show/view_model/bloc/quote_bloc.dart';
import 'package:quotes_slide_show/model/quote.dart';
import 'package:quotes_slide_show/model/services/api_service.dart';

import 'quote_bloc_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuoteBloc', () {
    QuoteBloc quoteBloc = QuoteBloc(MockApiService());
    MockApiService mockApiService = MockApiService();

    setUp(() {
      mockApiService = MockApiService();
      quoteBloc = QuoteBloc(mockApiService);
    });

    test('initial state is QuoteInitial', () {
      expect(quoteBloc.state, QuoteInitial());
    });

    blocTest<QuoteBloc, QuoteState>(
      'emits [QuoteLoading, QuoteLoaded] when FetchQuotes event is added',
      build: () {
        when(mockApiService.fetchFastestQuote()).thenAnswer(
            (_) async => Quote(content: 'Test Quote', author: 'Test Author'));
        return quoteBloc;
      },
      act: (bloc) => bloc.add(FetchQuotes()),
      expect: () => [
        QuoteLoading(),
        QuoteLoaded(Quote(content: 'Test Quote', author: 'Test Author'))
      ],
    );

    blocTest<QuoteBloc, QuoteState>(
      'emits [QuoteLoading, QuoteError] when FetchQuotes event throws an error',
      build: () {
        when(mockApiService.fetchFastestQuote())
            .thenThrow(Exception('Test Error'));
        return quoteBloc;
      },
      act: (bloc) => bloc.add(FetchQuotes()),
      expect: () => [QuoteLoading(), const QuoteError('Exception: Test Error')],
    );
  });
}
