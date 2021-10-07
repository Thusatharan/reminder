import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/screens/SuccessScreen.dart';
import '../main.dart';
import '../models/ReminderModel.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var rng = new Random();
  DateTime selectedDate;
  TimeOfDay selectedTime;
  // DateTime _todayDate = DateTime.now();
  // TimeOfDay _currentTime = TimeOfDay.now();
  String title;
  String id = DateTime.now().toString();
  String errorText = "";

  TextEditingController _titleController = TextEditingController();
  final List<Reminder> reminder = [
    Reminder(
      id: 'r1',
      title: 'Check Inbox',
      date: DateTime.now(),
      time: TimeOfDay.now(),
    )
  ];

  void _datePicker(context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        selectedDate = pickedDate;
        print(selectedDate);
      });
    });
  }

  void _timePicker(context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }

      setState(() {
        selectedTime = pickedTime;
        print(selectedTime);
      });
    });
  }

  void _onPressButton(
      String newId, String newTitle, DateTime newDate, TimeOfDay newTime) {
    final newReminder = Reminder(
      id: newId,
      title: newTitle,
      date: newDate,
      time: newTime,
    );
    setState(() {
      reminder.add(newReminder);
    });

    print(reminder[1].title);
  }

  void validateOnPressed() {
    if (_titleController.text == null ||
        selectedDate == null ||
        selectedTime == null) {
      setState(() {
        errorText = "Please fill all fields";
      });
    } else {
      sheduleNotification();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/orange_bg.jpg')),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: EdgeInsets.only(left: 10, right: 10, top: 70),
                child: Text(
                  "Tell me anything, \n I will remind you",
                  style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: EdgeInsets.only(left: 20, right: 20, top: 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: false,
                      controller: _titleController,
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontFamily: 'Glory'),
                      cursorHeight: 30,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "What should I remind?",
                          hintStyle: TextStyle(color: Colors.black12)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => _datePicker(context),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            (selectedDate == null)
                                ? 'Select Date'
                                : DateFormat()
                                    .add_yMMMEd()
                                    .format(selectedDate),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.orange[800],
                                fontFamily: 'Glory'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _timePicker(context),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            (selectedTime == null)
                                ? 'Select Time'
                                : selectedTime.format(context),
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.orange[800],
                                fontFamily: 'Glory'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    onPressed: () => cancelNotification(),
                    child: Text('CANCEL ALL',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Glory',
                            fontWeight: FontWeight.bold)),
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    onPressed: () {
                      validateOnPressed();
                    },
                    child: Text('ADD REMINDER',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Glory',
                            fontWeight: FontWeight.bold)),
                    color: Colors.orange[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.only(top: 20),
                  height: 40,
                  child: Text(
                    errorText,
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void sheduleNotification() async {
    print('Notification function called');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'reminder_app_1',
            'reminder_app_notification channel',
            'reminder_app_notification channel description',
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound('reminder_sound'),
            playSound: true,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();

    var timePrint = tz.TZDateTime(
        tz.getLocation('Asia/Kolkata'),
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
        selectedDate.second);

    print(timePrint);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      rng.nextInt(1000),
      _titleController.text,
      _titleController.text,
      timePrint,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SuccessScreen(
                selectedDateNav: selectedDate,
                selectedTimeHour: selectedTime.hour,
                selectedTimeMinute: selectedTime.minute,
              )),
    );
  }

  void cancelNotification() {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Cancelled all reminders")));
  }
}
