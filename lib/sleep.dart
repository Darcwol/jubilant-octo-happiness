import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Sleep implements Comparable<dynamic> {
  DateTime date;
  String type;
  double time;


  Sleep(String type, double time) {
    this.date = DateTime.now();
    this.type = type;
    this.time = time;
  }

  Sleep.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        type = json['type'],
        time = json['time'];

  Map<String, dynamic> toJson() =>
      {
        'date': date.toIso8601String(),
        'type': type,
        'time': time,
      };

  Row display() {
    return Row(
      children: <Widget>[
        Container(
          color: Colors.grey[200],
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  DateFormat.jm().format(date).split(' ')[0],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Text(
                  DateFormat.jm().format(date).split(' ')[1],
                  style: TextStyle(

                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Text(
                  type,
                  style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                  ),
                ),
              ),
              Text(
                time >= 1 ? time.toString().replaceAll('.', ' hour ') +
                    ' minute' : (time * 100).round().toString() + ' minute',
                style: TextStyle(
                    fontSize: 15.0,
                ),

              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  String toString() {
    return date.toString() + ' ' + type + ' ' + time.toString();
  }

  @override
  int compareTo(dynamic other) {
    return other.date.compareTo(date);
  }


}