import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Calendar Demo', home: MyHomePage());
  }
}

/// The hove page which hosts the calendar
class MyHomePage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DropdownMenuItem<int>> _items = [];
  int _selectItem = 0;
  int _countFlower = 10;

  List<bool> isSelected = List.generate(3, (index) => false);
  final random = Random();
  double get randomValue => (random.nextDouble() * 2) - 1;

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value!;
  }

  void setItems() {
    _items
      ..add(const DropdownMenuItem(
          child: Text('3', style: TextStyle(fontSize: 20.0)), value: 3))
      ..add(const DropdownMenuItem(
          child: Text('4', style: TextStyle(fontSize: 20.0)), value: 4))
      ..add(const DropdownMenuItem(
          child: Text('5', style: TextStyle(fontSize: 20.0)), value: 5))
      ..add(const DropdownMenuItem(
          child: Text('6', style: TextStyle(fontSize: 20.0)), value: 6))
      ..add(const DropdownMenuItem(
          child: Text('7', style: TextStyle(fontSize: 20.0)), value: 7))
      ..add(const DropdownMenuItem(
          child: Text('8', style: TextStyle(fontSize: 20.0)), value: 8));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: Row(
            children: const [
              Text('左'),
              Icon(Icons.battery_full),
              Text('右'),
              Icon(Icons.battery_full),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 300,
              child: SfCalendar(
                view: CalendarView.month,
                monthCellBuilder:
                    (BuildContext buildContext, MonthCellDetails details) {
                  final Color backgroundColor =
                      _getMonthCellBackgroundColor(details.date);
                  final Color defaultColor =
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black54
                          : Colors.white;
                  return Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        border: Border.all(color: defaultColor, width: 0.5)),
                    child: Center(
                      child: Text(
                        details.date.day.toString(),
                        style: TextStyle(
                            color: _getCellTextColor(backgroundColor)),
                      ),
                    ),
                  );
                },
                showDatePickerButton: true,
                monthViewSettings: const MonthViewSettings(
                  showTrailingAndLeadingDates: false,
                ),
              ),
            ),
            DropdownButton(
              items: _items,
              value: _selectItem,
              onChanged: (value) => {
                setState(() {
                  _selectItem = value as int;
                }),
              },
            ),
            SizedBox(
              height: 250,
              child: Stack(fit: StackFit.expand, children: <Widget>[
                Image.asset('assets/image/sougen.jpg', fit: BoxFit.fill),
                for (var i = 0; i < _countFlower; i++)
                  Align(
                    alignment: Alignment(randomValue, (randomValue + 1) / 2),
                    child: Image.asset('assets/image/flower.png', scale: 12),
                  ),
              ]),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              highlightColor: Colors.lightBlue,
              color: Colors.blueGrey[200],
              borderRadius: BorderRadius.circular(20),
              borderColor: Colors.blueGrey[200],
              borderWidth: 3,
              selectedBorderColor: Colors.lightBlue,
              disabledColor: Colors.grey[800],
              isSelected: isSelected,
              children: const <Widget>[
                Icon(Icons.chevron_left),
                Icon(Icons.swap_horizontal_circle_outlined),
                Icon(Icons.chevron_right),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                  if (index == 0 && _countFlower > 1) {
                    _countFlower--;
                  } else if (index == 1) {
                    _countFlower = 10;
                  } else if (index == 2) {
                    _countFlower++;
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  final Color _color1 = Colors.red;
  final Color _color2 = Colors.greenAccent;

  Color _getCellTextColor(Color backgroundColor) {
    if (backgroundColor == _color1) {
      return Colors.white;
    }
    return Colors.black;
  }

  Color _getMonthCellBackgroundColor(DateTime date) {
    if (date.month.isEven) {
      if (date.day % _selectItem == 0) {
        return _color1;
      } else {
        return _color2;
      }
    } else {
      if (date.day % _selectItem == 0) {
        return _color1;
      } else {
        return _color2;
      }
    }
  }

  // ignore: unused_element
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false),
    );
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
