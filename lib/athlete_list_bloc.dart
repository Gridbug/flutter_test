import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:proathlete_athleteslist_mockup/athlete.dart';
import 'package:rxdart/rxdart.dart';

class AthleteListBlocProvider extends InheritedWidget {
  final AthleteListBloc bloc;

  AthleteListBlocProvider(this.bloc, Widget child) : super (child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AthleteListBlocProvider of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AthleteListBlocProvider);
}

class AthleteListBloc {
  final Sink<Athlete> addAthlete;

  final Stream<List<Athlete>> athletes;

  final List<StreamSubscription<dynamic>> _subscriptions;

  factory AthleteListBloc(DumbAthleteReactiveRepository repository) {
    // ignore: close_sinks
    final addAthleteController = StreamController<Athlete>(sync: true);

    final subscriptions = <StreamSubscription<dynamic>>[
      addAthleteController.stream.listen(repository.addAthlete),
    ];

    return AthleteListBloc._(addAthleteController.sink, repository.athletes, subscriptions);
  }

  AthleteListBloc._(this.addAthlete, this.athletes, this._subscriptions);

  void close() {
    addAthlete.close();
    _subscriptions.forEach((subscription) => subscription.cancel());
  }
}

class DumbAthleteReactiveRepository {
  static List<Athlete> _initialAthletes = <Athlete>[
    Athlete("Атлет 1", 174),
    Athlete("Атлет 2", 165),
    Athlete("Атлет 3", 165),
    Athlete("Атлет 4", 165),
    Athlete("Атлет 5", 165),
    Athlete("Атлет 6", 165),
    Athlete("Атлет 7", 165),
    Athlete("Атлет 8", 165),
    Athlete("Атлет 9", 165),
  ];

  final BehaviorSubject<List<Athlete>> _subject;

  DumbAthleteReactiveRepository()
    : _subject =  BehaviorSubject.seeded(_initialAthletes);

  void addAthlete(Athlete a) {
    _subject.add(<Athlete>[]
        ..addAll(_subject.value ?? [])
        ..add(a));
  }

  Stream<List<Athlete>> get athletes => _subject.stream;
}
