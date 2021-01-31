import 'package:calculator_vd/models.dart';
import 'package:calculator_vd/staticfunctions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final calculationBLoC = CalculationBLoC();

class TextFiela extends StatelessWidget {
  TextFiela({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          StreamBuilder(
            stream: calculationBLoC.stateStream, //to inplement Stream BLoC
            builder: (context, snapshot) {
              var keys;
              Map<String, List<String>> data;
              if (snapshot.data == null) {
                data = {
                  "0": ["00", "00"]
                };
                keys = data.keys;
              } else {
                data = snapshot.data;
                keys = data.keys;
              }
              String key = keys.first;

              //getting key of snpapshot

              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: data[key].map((i) {
                        print("$data");
                        Color colorText;

                        if (operations.contains(i)) {
                          colorText = Color(0xffFB3D6E);
                        } else {
                          colorText = Color(0xffCACACA);
                        }
                        return Text(
                          i,
                          style: GoogleFonts.titilliumWeb(
                              color: colorText, fontSize: 25),
                        );
                      }).toList()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "$key",
                        style: GoogleFonts.titilliumWeb(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button(this.character, this.size, {Key key}) : super(key: key) {
    this.size = this.size * 1;
  }

  final String character;
  Color textColor = Colors.white;
  Color backColor = Color(0xff27292E);
  double size;
  static const List<String> purpleText = [
    ".",
    "C",
    "()",
    "％",
    "÷",
    "×",
    "-",
    "+",
    "±"
  ];
  static const List<String> backgroundButtons = ["÷", "×", "-", "+"];

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  Color backColor;
  Color textColor;

  bool parentheses = false;

  Color backGroundColor(String character) {
    if (Button.backgroundButtons.contains(character)) {
      return Color(0xff27292E);
    } else if (character == "=") {
      return Color(0xffFF3E70);
    } else {
      return Colors.transparent;
    }
  }

  Color coloredText(String character) {
    if (Button.purpleText.contains(character)) {
      return Color(0xffFF3E70);
    } else if (character == "=") {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.backColor = backGroundColor(this.widget.character);
    this.textColor = coloredText(this.widget.character);
    if (this.parentheses) {
      this.backColor = Color(0xffFF3E70);
      this.textColor = Colors.black;
    } else {
      this.backColor = backGroundColor(this.widget.character);
      this.textColor = coloredText(this.widget.character);
    }
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: this.backColor,
          borderRadius: BorderRadius.circular(
            this.widget.size / 2,
          ),
        ),
        height: this.widget.size,
        width: this.widget.size,
        child: Center(
          child: Text(
            this.widget.character,
            style: GoogleFonts.titilliumWeb(
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: this.textColor,
            ),
          ),
        ),
      ),
      onTap: () {
        if (this.widget.character == "C") {
          calculationBLoC.eventSink.add({ExpressionMethods.Clear: ""});
        } else if (this.widget.character == "()") {
          if (!this.parentheses) {
            setState(() {
              this.parentheses = true;
              calculationBLoC.eventSink.add({ExpressionMethods.Add: "("});
              this.backColor = Colors.grey;
              this.textColor = Colors.white;
            });
          } else if (this.parentheses) {
            setState(() {
              this.parentheses = false;
              calculationBLoC.eventSink.add({ExpressionMethods.Add: ")"});
            });
          }
        } else {
          calculationBLoC.eventSink
              .add({ExpressionMethods.Add: this.widget.character});
        }
      },
    );
  }
}

class CalculatorKeybord extends StatelessWidget {
  final List<List<String>> charachters;

  CalculatorKeybord(this.charachters, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: this.charachters.map(
        (e) {
          return Builder(
            builder: (BuildContext context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: e.map(
                  (i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Button(i, height(context));
                      },
                    );
                  },
                ).toList(),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
