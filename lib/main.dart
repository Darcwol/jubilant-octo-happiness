import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rb_intern_app/sleep.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';



void main() => runApp(SleepTracker());

class SleepTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep tracker',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(title: 'Sleep tracker'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Sleep> sleeps = new List();
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    loadData().then((value) {
      sleeps = value;
    });
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.brightness_3,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
            child: Text(
              'Get to know your baby\'s sleep patterns and keep track on how much sleep they are getting here.',
              style: TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.black54,
                  fontSize: 15.0
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child:
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPage()),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
                child: Text(
                  'Add new sleeping record',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(40.0),
                ),
              ),
            ),
          ),
          Container(
//            margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
            margin: EdgeInsets.fromLTRB(40, 80, 40, 20),
            child: Text(
              DateFormat('EEEE, d MMM yyyy').format(now).toUpperCase(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: new ListView.builder
              (
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sleeps.length,
              itemBuilder: (BuildContext ctxt, int index) =>
                  buildBody(ctxt, index),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<List<Sleep>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sleepStrings = prefs.getStringList('sleeps') ?? new List();
    List<Sleep> sleeps = new List();
    for (var str in sleepStrings) {
      sleeps.add(Sleep.fromJson(jsonDecode(str)));
    }
    sleeps.sort();
    return sleeps ?? new List();
  }

  Widget buildBody(BuildContext ctxt, int index) {
    return sleeps[index].display();
  }
}

class AddPage extends StatefulWidget {
  AddPage({Key key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _currentSelectedValue;
  double _sleepTime = 0;

  Future _showDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.decimal(
          minValue: 0,
          maxValue: 24,
          decimalPlaces: 2,
          initialDoubleValue: _sleepTime,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => _sleepTime = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var _types = ['Night\'s sleep', 'Nap'];
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(
            'Sleeping tracker',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(30.0),
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: Image.asset('assets/mother_with_baby.jpg'),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date and time',
                    labelStyle: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 20
                    ),
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blue[800],
                    ),
                  ),
                  controller: TextEditingController(
                      text: DateFormat('d MMMM yyyy, HH:mm').format(now)),
                  // initialValue: ,
                  enabled: false,
                ),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 20,
                        ),
                        hintText: 'Night, nap, etc',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelText: 'Sleep type',
                        icon: Icon(
                          Icons.brightness_3,
                          color: Colors.blue[800],
                        ),
                        border: UnderlineInputBorder(),
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValue = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _types.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                    onTap: () => _showDialog(),
                    child: AbsorbPointer(
                        child: FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 20,
                                ),
                                hintText: '',
                                labelText: 'Sleep duration',
                                icon: Icon(
                                  Icons.access_time,
                                  color: Colors.blue[800],
                                ),
                                border: UnderlineInputBorder(),
                              ),
                              child: Text(
                                  _sleepTime.toString().replaceAll('.', ' h ') +
                                      ' min'
                              ),
                            );
                          },
                        )
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 20.0),
                  child: FlatButton(
                    onPressed: save,
                    padding: EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 200.0),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    color: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(40.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  save() async {
    if (_currentSelectedValue != '' && _sleepTime > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Sleep sleep = new Sleep(_currentSelectedValue, _sleepTime);
      var s = json.encode(sleep.toJson());
      var sleeps = prefs.getStringList('sleeps') ?? new List();
      sleeps.add(s);
      prefs.setStringList('sleeps', sleeps);
      Navigator.pop(context);
    }
  }
}