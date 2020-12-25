import 'package:chris_calc/christ_tree_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Chris Calc',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Calculator'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = "0";
  set output(String val) => _display = val;

  /// 输出美化
  String get output {
    if (_display.endsWith('.00'))
      return _display.substring(0, _display.length - 3);
    return _display;
  }

  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  /// 展示圣诞树
  showChrisTree() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ChrisTreePage();
    }));
  }

  buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "/" ||
        buttonText == "X") {
      num1 = double.parse(output);

      operand = buttonText;

      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        print("Already conatains a decimals");
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      num2 = double.parse(output);

      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "X") {
        _output = (num1 * num2).toString();
      }
      if (operand == "/") {
        _output = (num1 / num2).toString();

        /// 展示圣诞树
        print("$num1, $num2, $operand");
        if (num1 == 47000 && num2 == 188 && operand == '/') showChrisTree();
      }

      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else {
      _output = _output + buttonText;
    }

    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
  }

  Widget buildButton(String buttonText, {int flex = 1, String pngName}) =>
      Expanded(
        flex: flex,
        child: OutlineButton(
          color: Colors.black,
          highlightedBorderColor: Colors.black,
          // padding: EdgeInsets.all(24.0),
          child: Image.asset('assets/images/$pngName.png'),
          onPressed: () => buttonPressed(buttonText),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
          color: Colors.black,
          child: Column(children: <Widget>[
            Expanded(child: Container()),
            Container(
                color: Colors.black,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                child: Text(output,
                    style: TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ))),
            Column(children: [
              Row(children: [
                buildButton("CLEAR", pngName: 'ac'),
                buildButton("±", pngName: '+-'),
                buildButton("%", pngName: '%'),
                buildButton("/", pngName: 'div')
              ]),
              Row(children: [
                buildButton("7", pngName: '7'),
                buildButton("8", pngName: '8'),
                buildButton("9", pngName: '9'),
                buildButton("X", pngName: 'x')
              ]),
              Row(children: [
                buildButton("4", pngName: '4'),
                buildButton("5", pngName: '5'),
                buildButton("6", pngName: '6'),
                buildButton("-", pngName: '-')
              ]),
              Row(children: [
                buildButton("1", pngName: '1'),
                buildButton("2", pngName: '2'),
                buildButton("3", pngName: '3'),
                buildButton("+", pngName: '+')
              ]),
              Row(children: [
                buildButton("0", pngName: '0', flex: 2),
                buildButton(".", pngName: '。'),
                buildButton("=", pngName: '='),
              ])
            ])
          ])));
}
