import 'dart:async';
import 'dart:math';
import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class CalculatorEngine {
  Expression expression;

  final evaluator = const ExpressionEvaluator();

  var context = {'cos': cos, 'sin': sin};

  final List<String> operatorsWithProblems = ['×', '÷'];

  String evaluateExpression(String expresion) {
    expresion = parseExpresion(expresion);
    Expression expression = Expression.parse(expresion);

    num result = evaluator.eval(expression, context);
    print('Here is result: look $result');
    return result.toString();
  }

  String parseExpresion(String expresion) {
    for (String operatorBad in operatorsWithProblems) {
      if (expresion.contains(operatorBad) && operatorBad == '×') {
        expresion = expresion.replaceAll(RegExp('×'), '*');
      } else if (expresion.contains(operatorBad) && operatorBad == '÷') {
        expresion = expresion.replaceAll(RegExp('÷'), '/');
      }
    }
    return expresion;
  }
}

enum ExpressionMethods { Add, Clear, Delete }
List<String> operations = ["÷", "×", "-", "+", "(", ")", "%", "."];

class CalculationBLoC {
  List<String> math_expression;

  final StreamController<Map<String, List<String>>> stateStreamController =
      StreamController<Map<String, List<String>>>();
  StreamSink<Map<String, List<String>>> get stateSink =>
      stateStreamController.sink;
  Stream<Map<String, List<String>>> get stateStream =>
      stateStreamController.stream;

  final StreamController<Map<ExpressionMethods, String>> eventStreamController =
      StreamController<Map<ExpressionMethods, String>>();
  StreamSink<Map<ExpressionMethods, String>> get eventSink =>
      eventStreamController.sink;
  Stream<Map<ExpressionMethods, String>> get eventStream =>
      eventStreamController.stream;

  CalculationBLoC() {
    final CalculatorEngine calculatorEngine = CalculatorEngine();
    math_expression = [];
    String result = "0";
    eventStream.listen(
      (event) {
        if (event.containsKey(ExpressionMethods.Add)) {
          if (math_expression.length == 1 && math_expression[0] == "0") {
            math_expression = [event[ExpressionMethods.Add]];
          } else {
            math_expression.add(event[ExpressionMethods.Add]);
          }
        } else if (event.containsKey(ExpressionMethods.Delete)) {
          math_expression.length == 1
              ? math_expression = ["0"]
              : math_expression.removeLast();
        } else if (event.containsKey(ExpressionMethods.Clear)) {
          math_expression = ["0"];
        }

        StringBuffer expressionString = StringBuffer();
        expressionString.writeAll(math_expression);

        int rightParatense = 0;
        int leftParatense = 0;
        for (var char in math_expression) {
          if (char == "(") rightParatense++;
          if (char == ")") leftParatense++;
        }

        if (operations.contains(math_expression.last) ||
            rightParatense != leftParatense) {
          print("Operator Button was pressed");
        } else {
          result =
              calculatorEngine.evaluateExpression(expressionString.toString());
        }

        stateSink.add(
          {result: math_expression},
        );
      },
    );
  }
}
