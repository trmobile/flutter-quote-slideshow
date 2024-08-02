import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quotes_slide_show/model/quote.dart';
import 'package:quotes_slide_show/view/quote_screen.dart';
import 'package:quotes_slide_show/view_model/bloc/quote_bloc.dart';

class MockQuoteBloc extends MockBloc<QuoteEvent, QuoteState>
    implements QuoteBloc {}

class QuoteEventFake extends Fake implements QuoteEvent {}

class QuoteStateFake extends Fake implements QuoteState {}

void main() {
  group('QuoteScreen Widget Tests', () {
    setUpAll(() {
      registerFallbackValue(QuoteEventFake());
      registerFallbackValue(QuoteStateFake());
    });

    testWidgets('Quotes loading', (widgetTester) async {
      final quoteBloc = MockQuoteBloc();
      when(() => quoteBloc.state).thenReturn(QuoteLoading());

      await widgetTester.pumpWidget(MaterialApp(
        home: BlocProvider<QuoteBloc>.value(
          value: quoteBloc,
          child: const QuoteScreen(),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays quotes and allows sharing',
        (WidgetTester tester) async {
      // Provide the QuoteBloc with the sample quotes
      final quotes = [
        Quote(
            content: 'The purpose of our lives is to be happy.',
            author: 'Dalai Lama'),
        Quote(
            content:
                'Life is what happens when you’re busy making other plans.',
            author: 'John Lennon'),
      ];

      final quoteBloc = MockQuoteBloc();
      when(() => quoteBloc.state).thenReturn(QuoteLoaded(quotes[0]));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteBloc>(
            create: (context) => quoteBloc..add(FetchQuotes()),
            child: const QuoteScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the quote is displayed
      expect(find.text('The purpose of our lives is to be happy.'),
          findsOneWidget);
      expect(find.text('Dalai Lama'), findsOneWidget);

      // Verify that the share button is displayed
      expect(find.byIcon(Icons.share), findsNWidgets(1));

      // Tap the share button and verify the share functionality
      await tester.tap(find.byIcon(Icons.share).first);
      await tester.pumpAndSettle();
    });

    testWidgets('displays error message when QuoteError state is emitted',
        (WidgetTester tester) async {
      // Provide the QuoteBloc with an error state
      final quoteBloc = MockQuoteBloc();
      when(() => quoteBloc.state)
          .thenReturn(const QuoteError('Failed to load quotes'));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<QuoteBloc>(
            create: (context) => quoteBloc..add(FetchQuotes()),
            child: const QuoteScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the error message is displayed
      expect(find.text('Failed to load quotes'), findsOneWidget);
    });
  });
}
