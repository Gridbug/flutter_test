import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:proathlete_athleteslist_mockup/athlete.dart';
import 'package:rxdart/rxdart.dart';

class InheritedAthleteListBloc extends InheritedWidget {
  final AthleteListBloc bloc;

  InheritedAthleteListBloc(this.bloc, Widget child) : super (child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedAthleteListBloc of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedAthleteListBloc);
}

class AthleteListBloc {
  static List<Athlete> _athletes = <Athlete>[
    Athlete("Атлет 1", 174),
    Athlete("Атлет 2", 165),
    Athlete("Атлет 3", 165),
    Athlete("Атлет 4", 165),
    Athlete("Атлет 5", 165),
    Athlete("Атлет 6", 165),
    Athlete("Атлет 7", 165),
    Athlete("Атлет 8", 165),
    Athlete("Атлет 9", 165),
    Athlete("Атлет 10", 165),
    Athlete("Атлет 11", 165),
    Athlete("Try Tryumen", 0),
  ];

  final _athletesSubject = BehaviorSubject<List<Athlete>>();

  Stream<List<Athlete>> get athletes => _athletesSubject.stream;


  final Sink<Athlete> createAthlete;

  factory AthleteListBloc() {
    // ignore: close_sinks
    final createAthleteController = StreamController<Athlete>(sync: true);

    // ignore: cancel_subscriptions
    StreamSubscription<dynamic> createAthleteSubscription =
        createAthleteController.stream.listen(_addAthleteListener);

    return AthleteListBloc._(createAthleteController, createAthleteSubscription);
  }

  AthleteListBloc._(this.createAthlete, this._createAthleteStreamSubscription) {
    _athletesSubject.add(_athletes);
  }

  static void _addAthleteListener(Athlete a) {
    _athletes.add(a);
  }

  void close() {
    createAthlete.close();
    _createAthleteStreamSubscription.cancel();
  }

  final StreamSubscription<dynamic> _createAthleteStreamSubscription;
}
