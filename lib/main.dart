import 'package:calculator_vd/models.dart';
import 'package:calculator_vd/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CalculatorApp());
}

const List<List<String>> buttonsChar = [
  ["C", "()", "％", "÷"],
  ["7", "8", "9", "×"],
  ["4", "5", "6", "-"],
  ["1", "2", "3", "+"],
  ["±", "0", ".", "="]
];

class CalculatorApp extends StatelessWidget {
  CalculatorApp({Key key}) : super(key: key);

  final List<String> buttonsC = ["÷", "×", "-", "+", "="];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Color(0xff5B5455),
            fontSize: 15,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Color(0xff020203),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                TextFiela(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Image.asset("assets/Icons/pi.png"),
                      SizedBox(
                        width: 30,
                      ),
                      Image.asset("assets/Icons/clock.png"),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.backspace,
                          color: Color(0xffFF3E70),
                        ),
                        onPressed: () {
                          calculationBLoC.eventSink
                              .add({ExpressionMethods.Delete: ""});
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 50,
                  color: Color(0xff27292E),
                  thickness: 3,
                ),
                Expanded(
                  child: CalculatorKeybord(buttonsChar),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
