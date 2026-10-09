import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Calculator App', home: CalculatorScreen());
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  dynamic textcontroller = TextEditingController(text: 'asdf');
  String continuousVar = '';
  List<String> actions = [
    '1',
    '2',
    '3',
    '+',
    '4',
    '5',
    '6',
    '-',
    '7',
    '8',
    '9',
    '*',
    '0',
    '.',
    'C',
    '/',
  ];

  String calculate(String newVar) {
    if (newVar == 'current') {
      return continuousVar;
    } else if (newVar == 'C') {
      return continuousVar = '';
    }
    return continuousVar += newVar;
  }

  num actualcalculate() {
    List<num> numberList = [];
    List<num> queue = [];
    String str = continuousVar;
    if (str.startsWith('-')) {
      str = "0$str";
    }
    List<String> rawnums = str.split(RegExp(r'[+\-/*]'));
    List<String> operators = [];
    num result = 0;

    for (int i = 0; i < rawnums.length; i++) {
      numberList.add(double.parse(rawnums[i]));
    }
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '+' || str[i] == '-' || str[i] == '/' || str[i] == '*') {
        operators.add(str[i]);
      }
    }

    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '+'){
        queue.add(numberList[i]);
      }
      else if (operators[i] == '-') {
        queue.add(numberList[i]);
        numberList[i + 1] = numberList[i + 1] * -1;
      } else if (operators[i] == '*') {
        numberList[i + 1] = numberList[i] * numberList[i + 1];
      } else if (operators[i] == '/') {
        numberList[i + 1] = numberList[i] / numberList[i + 1];
      }
      if (i + 1 >= operators.length) {
        queue.add(numberList[i + 1]);
      }
    }

    for (int i = 0; i < queue.length; i++) {
      result += queue[i];
    }

    return result;
  }

  @override
  void dispose() {
    textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),

              child: SizedBox(
                height: 80,
                width: 500,

                child: Text(
                  textcontroller.text,
                  style: TextStyle(fontSize: 52, color: Colors.red),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(80, 170, 80, 0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ElevatedButton(
                      onPressed: () {
                        print(textcontroller.text);
                        setState(() {
                          calculate(actions[index]);
                          textcontroller = TextEditingController(
                            text: calculate("current"),
                          );
                        });
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Text(
                        actions[index],
                        style: TextStyle(fontSize: 45, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 100),
                      ),
                      child: Text('='),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 100),
                      ),
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
