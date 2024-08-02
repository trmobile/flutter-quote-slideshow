import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_slide_show/model/services/api_service.dart';
import 'package:quotes_slide_show/view/quote_screen.dart';
import 'package:quotes_slide_show/view_model/bloc/quote_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => QuoteBloc(ApiService()),
        child: const QuoteScreen(),
      ),
    );
  }
}
