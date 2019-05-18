import 'package:flutter/material.dart';
import 'package:proathlete_athleteslist_mockup/athlete.dart';
import 'package:proathlete_athleteslist_mockup/athlete_list_bloc.dart';
import 'package:proathlete_athleteslist_mockup/proathlete_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
                    AthleteListBlocProvider.of(context)
                        .bloc
                        .addAthlete
                        .add(athlete);
                  }
                });
              }),
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
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
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

class AthleteSearch extends SearchDelegate<Athlete> {
  final Stream<List<Athlete>> _athletesStream;

  AthleteSearch(this._athletesStream);

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
        close(context, Athlete("Nobody", 0, null));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Athlete>>(
        stream: _athletesStream,
        initialData: [],
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
        initialData: [],
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
}

class AddAthleteDialog extends StatefulWidget {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _contraindicationsController = TextEditingController();

  @override
  _AddAthleteDialogState createState() => _AddAthleteDialogState();
}

class _AddAthleteDialogState extends State<AddAthleteDialog> {
  File _athletePhotoFile;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
      titlePadding: EdgeInsets.fromLTRB(0, 4, 0, 4),
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
        margin: EdgeInsets.all(0),

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
            Text('Новый атлет',
                style: TextStyle(color: Colors.white, fontSize: 14)),
            FlatButton(
              child: Text('Готово', style: TextStyle(color: Colors.white)),
              onPressed: () {
                String _name = widget._nameController.text;
                String _surname = widget._surnameController.text;
                String _birthDate = widget._birthDateController.text;
                String _gender = widget._genderController.text;
                String _email = widget._emailController.text;
                String _phone = widget._phoneController.text;
                String _height = widget._heightController.text;
                String _weight = widget._weightController.text;
                String _contraindications = widget._contraindicationsController.text;

                Navigator.of(context)
                    .pop(Athlete(_name, 42, _athletePhotoFile));
              },
            ),
          ],
        ),
      ),
      children: <Widget>[
        Row(
          children: <Widget>[
            AthletePhoto((File athletePhotoFile) {
              _athletePhotoFile = athletePhotoFile;
            }),
            Expanded(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: widget._nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: widget._surnameController,
                    decoration: InputDecoration(
                      labelText: 'Фамилия',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4),
                      ),
                    ),
                  )
                ],
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'День рождения',
              suffixIcon: Image(
                image: AssetImage('assets/datepicker.png'),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._birthDateController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Пол',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._genderController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._emailController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Телефон',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
          ),
          controller: widget._phoneController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Рост',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._heightController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Вес',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._weightController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Противопоказания',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: widget._contraindicationsController,
        ),
      ],
    );
  }
}

class AthletePhoto extends StatefulWidget {
  Function callback;

  AthletePhoto(this.callback);

  @override
  _AthletePhotoState createState() => _AthletePhotoState(callback);
}

class _AthletePhotoState extends State<AthletePhoto> {
  final Function callback;

  _AthletePhotoState(this.callback);

  File _athletePhoto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        File imageFile =
            await ImagePicker.pickImage(source: ImageSource.gallery);

        setState(() {
          _athletePhoto = imageFile;
          callback(imageFile);
        });
      },
      child: _athletePhoto != null
          ? Container(
              padding: EdgeInsets.all(20),
              child: Image.file(_athletePhoto),
              width: 80,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(80)),
            )
          : Padding(
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
    );
  }
}
