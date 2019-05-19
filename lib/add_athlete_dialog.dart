import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proathlete_athleteslist_mockup/proathlete_colors.dart';

import 'athlete.dart';

class AddAthleteDialog extends StatefulWidget {
  @override
  _AddAthleteDialogState createState() => _AddAthleteDialogState();
}

class _AddAthleteDialogState extends State<AddAthleteDialog> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _contraindicationsController = TextEditingController();

  File _athletePhotoFile;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 4),
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
//        side: BorderSide(
//          width: 10,
//          color: Colors.red
//        )
      ),
      title: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          color: ProathleteColors.violet,
        ),
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
                String _name = _nameController.text;
                String _surname = _surnameController.text;
                String _birthDate = _birthDateController.text;
                String _gender = _genderController.text;
                String _email = _emailController.text;
                String _phone = _phoneController.text;
                String _height = _heightController.text;
                String _weight = _weightController.text;
                String _contraindications = _contraindicationsController.text;

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
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _surnameController,
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
          controller: _birthDateController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Пол',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _genderController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _emailController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Телефон',
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
          ),
          controller: _phoneController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Рост',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _heightController,
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
              labelText: 'Вес',
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ProathleteColors.f4f4f4))),
          controller: _weightController,
        ),
        SizedBox(height: 10),
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

class AthletePhoto extends StatefulWidget {
  final Function callback;

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