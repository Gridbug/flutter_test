import 'package:flutter/material.dart';
import 'package:proathlete_athleteslist_mockup/proathlete_colors.dart';

class TrainerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мой профиль'),
        backgroundColor: ProathleteColors.graySeparationLine,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
//                            color: Colors.red,
                ),
          ),
          Expanded(
            flex: 6,
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ProathleteColors.graySeparationLine)),
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
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
                  ),
//                          controller: _phoneController,
                ),
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Фамилия',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
                  ),
//                          controller: _phoneController,
                ),
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ProathleteColors.f4f4f4)),
                      suffix: Text(
                        "Не подтверждён",
                        style: TextStyle(color: ProathleteColors.orange, fontSize: 10),
                      )),
//                          controller: _phoneController,
                ),
                SizedBox(
                  height: 4,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Телефон',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: ProathleteColors.f4f4f4)),
                  ),
//                          controller: _phoneController,
                ),
                SizedBox(
                  height: 80,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    "Сменить пароль",
                    style: TextStyle(color: ProathleteColors.orange),
                  ),
                  padding: EdgeInsets.all(0),
                ),
//                        Expanded(
//                          child: Center(
//                            child: FlatButton(
//                              onPressed: () {},
//                              child: Text(
//                                "Сменить пароль",
//                                style: TextStyle(
//                                    color: ProathleteColors.orange),
//                              ),
//                              padding: EdgeInsets.all(0),
//                            ),
//                          ),
//                        ),
//                              Expanded(
//                                child: SizedBox(),
//                              ),
//                              FlatButton(
//                                onPressed: () {},
//                                child: Text(
//                                  "Удалить",
//                                  style: TextStyle(color: Colors.red),
//                                ),
//                                padding: EdgeInsets.all(0),
//                              ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
//                            color: Colors.red,
                ),
          ),
        ],
      ),
    );
  }
}
