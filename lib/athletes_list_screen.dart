import 'package:flutter/material.dart';

import 'package:proathlete_athleteslist_mockup/add_athlete_dialog.dart';
import 'package:proathlete_athleteslist_mockup/athlete.dart';
import 'package:proathlete_athleteslist_mockup/athlete_list_bloc.dart';
import 'package:proathlete_athleteslist_mockup/proathlete_colors.dart';
import 'package:proathlete_athleteslist_mockup/trainer_profile_screen.dart';

class AthletesListScreen extends StatefulWidget {
  @override
  _AthletesListScreenState createState() => _AthletesListScreenState();
}

class _AthletesListScreenState extends State<AthletesListScreen> {
  double _searchBarHeight = 0;
  bool _searchBarVisible = false;
  final _searchController = TextEditingController();
  var _appBarSearchButtonColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ProathleteColors.graySeparationLine,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Menu button pressed!');
          },
        ),
        title: Text('Атлеты'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_missed_outgoing),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TrainerProfileScreen();
                },
              ));
            },
          ),
          IconButton(
            icon: ImageIcon(AssetImage('assets/add_athlete.png')),
            onPressed: () {
              Future<Athlete> newAthlete = showDialog(
                  context: context, builder: (context) => AddAthleteDialog());

              newAthlete.then((athlete) {
                if (athlete != null) {
                  AthleteListBlocProvider.of(context)
                      .bloc
                      .addAthlete
                      .add(athlete);
                }
              });
            },
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: IconButton(
              icon: ImageIcon(AssetImage('assets/search.png')),
              color: _appBarSearchButtonColor,
              onPressed: () {
//              showSearch(
//                  context: context,
//                  delegate: AthleteSearch(
//                      AthleteListBlocProvider.of(context).bloc.athletes));

                _searchController.clear();
                FocusScope.of(context).requestFocus(
                    FocusNode()); //MUST BE CHANGED TO "FocusScope.of(context).unfocus()" in Flutter 1.5.9

                if (_searchBarVisible) {
                  setState(() {
                    _searchBarVisible = false;
                    _searchBarHeight = 0;
                    _appBarSearchButtonColor = Colors.black;
                  });

                  AthleteListBlocProvider.of(context).bloc.updateFilter.add("");
                } else {
                  setState(() {
                    _searchBarVisible = true;
                    _searchBarHeight = 30;
                    _appBarSearchButtonColor = ProathleteColors.orange;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: ProathleteColors.graySeparationLine,
            height: _searchBarHeight,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
//                      prefixIcon: Icon(Icons.search),
                      prefixIcon: ImageIcon(AssetImage("assets/search.png")),
                      suffixIcon: Container(
                        child: FlatButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: ImageIcon(
                            AssetImage("assets/x.png"),
                          ),
//                        icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();

                              AthleteListBlocProvider.of(context)
                                  .bloc
                                  .updateFilter
                                  .add(_searchController.text);
                            });
                          },
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                    controller: _searchController,
                    onChanged: (text) {
                      AthleteListBlocProvider.of(context)
                          .bloc
                          .updateFilter
                          .add(text);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Athlete>>(
              stream: AthleteListBlocProvider.of(context).bloc.filteredAthletes,
              initialData: [],
              builder: (context, snapshot) => _buildAthletesList(snapshot.data),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAthletesList(List<Athlete> athletes) {
    List<Card> athleteCards = athletes
        .map((athlete) => Card(
              child: Padding(
                padding: EdgeInsets.all(28),
                child: Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: athlete.photo != null
                              ? FileImage(athlete.photo)
                              : AssetImage('assets/user_photo_placeholder.png'),
                        ),
                      ),
                      child: SizedBox.fromSize(size: Size.square(80)),
                    ),
                    SizedBox.fromSize(size: Size.square(21)),
                    Text(
                      athlete.name,
                      style: TextStyle(fontSize: 17),
                    ),
                    Spacer(),
                    Text(
                      athlete.numOfTrainings.toString(),
                      style: TextStyle(
                          color: ProathleteColors.c1c2c8, fontSize: 17),
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(width: 1, color: ProathleteColors.f4f4f4),
              ),
              elevation: 0,
            ))
        .toList();

    athleteCards.add(Card(
      child: Center(
        child: Text('В списке атлетов: ${athleteCards.length}',
            style: TextStyle(color: ProathleteColors.c1c2c8, fontSize: 15)),
      ),
      elevation: 0,
    ));

    return ListView(
      children: athleteCards,
      padding: const EdgeInsets.all(20),
    );
  }
}

//class AthleteSearch extends SearchDelegate<Athlete> {
//  final Stream<List<Athlete>> _athletesStream;
//
//  AthleteSearch(this._athletesStream);
//
//  @override
//  List<Widget> buildActions(BuildContext context) {
//    return [
//      IconButton(
//        icon: Icon(Icons.clear),
//        onPressed: () {
//          query = '';
//        },
//      )
//    ];
//  }
//
//  @override
//  Widget buildLeading(BuildContext context) {
//    return IconButton(
//      icon: Icon(Icons.arrow_back),
//      onPressed: () {
//        close(context, Athlete("Nobody", 0, null));
//      },
//    );
//  }
//
//  @override
//  Widget buildResults(BuildContext context) {
//    return StreamBuilder<List<Athlete>>(
//        stream: _athletesStream,
//        initialData: [],
//        builder: (context, snapshot) => ListView(
//              children: snapshot.data
//                  .where((athlete) =>
//                      athlete.name.toLowerCase().contains(query.toLowerCase()))
//                  .map<ListTile>((athlete) => ListTile(
//                        leading: Container(
//                          decoration: BoxDecoration(
//                            shape: BoxShape.circle,
//                            image: DecorationImage(
//                              image: AssetImage(
//                                  'assets/user_photo_placeholder.png'),
//                            ),
//                          ),
//                          child: SizedBox.fromSize(size: Size.square(32)),
//                        ),
//                        title: Text(athlete.name),
//                        onTap: () {
//                          close(context, athlete);
//                        },
//                      ))
//                  .toList(),
//            ));
//  }
//
//  @override
//  Widget buildSuggestions(BuildContext context) {
//    return StreamBuilder<List<Athlete>>(
//        stream: _athletesStream,
//        initialData: [],
//        builder: (context, snapshot) => ListView(
//              children: snapshot.data
//                  .where((athlete) =>
//                      athlete.name.toLowerCase().contains(query.toLowerCase()))
//                  .map<ListTile>((athlete) => ListTile(
//                        title: Text(
//                          athlete.name,
//                          style: TextStyle(color: Colors.blue),
//                        ),
//                        dense: true,
//                        onTap: () {
//                          close(context, athlete);
//                        },
//                      ))
//                  .toList(),
//            ));
//  }
//}
