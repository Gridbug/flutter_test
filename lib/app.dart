import 'package:flutter/material.dart';
import 'package:proathlete_athleteslist_mockup/athlete_list_bloc.dart';
import 'package:proathlete_athleteslist_mockup/athletes_list_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проатлет 2.0',
      theme: ThemeData(
          primarySwatch: Colors.grey, scaffoldBackgroundColor: Colors.white),
      home: AthleteListBlocProvider(AthleteListBloc(DumbAthleteReactiveRepository()), AthletesListScreen()),
      color: Colors.white,
    );
  }
}
