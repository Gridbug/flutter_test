import 'package:flutter/material.dart';
import 'package:proathlete_athleteslist_mockup/athlete.dart';
import 'package:proathlete_athleteslist_mockup/athlete_list_bloc.dart';
import 'package:proathlete_athleteslist_mockup/proathlete_colors.dart';

class AthletesListScreen extends StatelessWidget {
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
            }),
        title: Text('Атлеты'),
        actions: <Widget>[
          IconButton(
              icon: ImageIcon(AssetImage('assets/add_athlete.png')),
              onPressed: () {
                Future<Athlete> newAthlete = showDialog(
                    context: context, builder: (context) => AddAthleteDialog());
                
                newAthlete.then((athlete) {
                  if (athlete != null) {
                    InheritedAthleteListBloc.of(context).bloc.createAthlete.add(athlete);
                  }
                } );
              }),
          IconButton(
            icon: ImageIcon(AssetImage('assets/search.png')),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: AthleteSearch(
                      InheritedAthleteListBloc.of(context).bloc.athletes));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: InheritedAthleteListBloc.of(context).bloc.athletes,
        builder: (context, snapshot) => _buildAthletesList(snapshot.data),
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
                          image:
                              AssetImage('assets/user_photo_placeholder.png'),
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
                  side: BorderSide(width: 1, color: ProathleteColors.f4f4f4)),
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

class AthleteSearch extends SearchDelegate<Athlete> {
  final Stream<List<Athlete>> _athletesStream;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Athlete("Nobody", 0));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Athlete>>(
        stream: _athletesStream,
        builder: (context, snapshot) => ListView(
              children: snapshot.data
                  .where((athlete) =>
                      athlete.name.toLowerCase().contains(query.toLowerCase()))
                  .map<ListTile>((athlete) => ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/user_photo_placeholder.png'),
                            ),
                          ),
                          child: SizedBox.fromSize(size: Size.square(32)),
                        ),
                        title: Text(athlete.name),
                        onTap: () {
                          close(context, athlete);
                        },
                      ))
                  .toList(),
            ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Athlete>>(
        stream: _athletesStream,
        builder: (context, snapshot) => ListView(
              children: snapshot.data
                  .where((athlete) =>
                      athlete.name.toLowerCase().contains(query.toLowerCase()))
                  .map<ListTile>((athlete) => ListTile(
                        title: Text(
                          athlete.name,
                          style: TextStyle(color: Colors.blue),
                        ),
                        dense: true,
                        onTap: () {
                          close(context, athlete);
                        },
                      ))
                  .toList(),
            ));
  }

  AthleteSearch(this._athletesStream);
}

class AddAthleteDialog extends SimpleDialog {
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _contraindicationsController = TextEditingController();

  String _name = '';
  String _surname = '';
  String _birthDate = '';
  String _gender = '';
  String _email = '';
  String _phone = '';
  String _height = '';
  String _weight = '';
  String _contraindications = '';

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
      titlePadding: EdgeInsets.fromLTRB(0, 4, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
//        side: BorderSide(
//          width: 10,
//          color: Colors.red
//        )
      ),
      title: Container(
        color: ProathleteColors.violet,
        padding: EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            Text('Новый атлет', style: TextStyle(color: Colors.white)),
            FlatButton(
              child: Text('Готово', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(Athlete(_name, 42));
              },
            )
          ],
        ),
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      'Загрузить',
                      style: TextStyle(color: ProathleteColors.orange),
                    ),
                  ),
                  Center(
                    child: Text(
                      'фото',
                      style: TextStyle(color: ProathleteColors.orange),
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Имя',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ProathleteColors.f4f4f4))),
                    onChanged: (name) => _name = name,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Фамилия',
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ProathleteColors.f4f4f4))),
                    onChanged: (surname) => _surname = surname,
                  )
                ],
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'День рождения',
              suffixIcon: Image(
                image: AssetImage('assets/datepicker.png'),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _birthDateController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'Пол',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _genderController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _emailController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            labelText: 'Телефон',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
          ),
          controller: _phoneController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'Рост',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _heightController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'Вес',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _weightController,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              labelText: 'Противопоказания',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _contraindicationsController,
        ),
      ],
    );
  }
}
