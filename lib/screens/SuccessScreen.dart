import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SuccessScreen extends StatelessWidget {
  final DateTime selectedDateNav;
  final int selectedTimeHour;
  final int selectedTimeMinute;
  SuccessScreen(
      {@required this.selectedDateNav,
      @required this.selectedTimeHour,
      @required this.selectedTimeMinute});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(right: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: RichText(
                    text: TextSpan(
                      text: 'I will remind you at \n',
                      style: TextStyle(fontSize: 20),
                      children: [
                        TextSpan(
                            text: DateFormat.yMMMd().format(selectedDateNav) +
                                '\n',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                height: 2,
                                color: Colors.orange,
                                fontFamily: 'Glory')),
                        TextSpan(
                            text: selectedTimeHour.toString() +
                                ":" +
                                selectedTimeMinute.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                                fontFamily: 'Glory')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Image(
                    image: AssetImage('assets/images/boy.png'),
                    height: 350,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('assets/images/success.png'),
                  height: 150,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Reminder Added',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
