import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

dynamic textcontroller = TextEditingController(text: '');
String continuousVar = '';
Future<List<dynamic>> readHistory() async {
  
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<dynamic> calc = prefs.getKeys().map((key) => prefs.get(key)).toList();

  return calc;
}

int calculationCounter = 0;

class _CalculatorScreenState extends State<CalculatorScreen> {
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
  Future<void> addToHistory(String calculation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(calculationCounter.toString(), calculation);
  }

  String calculate(String newVar, bool answer) {
    if (newVar == 'current') {
      return continuousVar;
    } else if (newVar == 'C') {
      return continuousVar = '';
    } else if (answer == true) {
      addToHistory(("$continuousVar = $newVar"));
       setState(() {
        calculationCounter++;
        
      });
     
      return continuousVar = "= $newVar";
    } else if (newVar == "Delete") {
      return continuousVar = continuousVar.substring(
        0,
        continuousVar.length - 1,
      );
    }
    return continuousVar += newVar;
  }

  num actualcalculate() {
    List<num> numberList = [];
    List<num> queue = [];
    String str = continuousVar;
    if(str.startsWith("= -")){
      str = "0${str.substring(2,str.length)}";
    }
    if (str.startsWith('-')) {
      str = "0$str";
    } else if (str.startsWith("= ")) {
      str = str.substring(2, str.length);
    }
    
    List<String> rawnums = str.split(RegExp(r'[+\-/*]'));
    List<String> operators = [];
    num result = 0;

    for (int i = 0; i < rawnums.length; i++) {
      try {
        numberList.add(double.parse(rawnums[i]));
      } on FormatException {
        setState(() {
          textcontroller = TextEditingController(text: "Format Error");
        });
      }
    }
    for (int i = 0; i < str.length; i++) {
      if (str[i] == '+' || str[i] == '-' || str[i] == '/' || str[i] == '*') {
        operators.add(str[i]);
      }
    }
  
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '+') {
        queue.add(numberList[i]);
      } else if (operators[i] == '-') {
        queue.add(numberList[i]);
        numberList[i + 1] = numberList[i + 1] * -1;
      } else if (operators[i] == '*') {
        numberList[i + 1] = numberList[i] * numberList[i + 1];
      } else if (operators[i] == '/') {
        if (numberList[i + 1] == 0) {
          setState(() {
            textcontroller = TextEditingController(text: "Error");
          });
          throw ArgumentError('Cannot divide by 0');
        } else {
          numberList[i + 1] = numberList[i] / numberList[i + 1];
        }
      }
      if (i + 1 >= operators.length) {
        queue.add(numberList[i + 1]);
      }
    }

    for (int i = 0; i < queue.length; i++) {
      result += queue[i];
    }
    if(result.toString().length > 10){
      result = double.parse(result.toString().substring(0,12));
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => CalcHistory()));
            },
            tooltip: 'Open History',
            icon: Icon(Icons.history),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),

              child: SizedBox(
                height: 80,
                width: 500,

                child: Text(
                  textcontroller.text,
                  style: TextStyle(fontSize: 52, color: Colors.black87),
                ),
              ),
            ),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(80, 30, 80, 0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            calculate(actions[index], false);
                            textcontroller = TextEditingController(
                              text: calculate("current", false),
                            );
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.red,
                          ),
                        ),
                        child: Text(
                          actions[index],
                          style: TextStyle(fontSize: 45, color: Colors.black87),
                        ),
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
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          textcontroller = TextEditingController(
                            text: calculate(actualcalculate().toString(), true),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 100),
                        backgroundColor: Colors.red,
                      ),
                      label: Text('Result'),
                      icon: Icon(Icons.equalizer_sharp),
                    ),
                    SizedBox(
                      height: 40,
                      width: 50,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          try {
                            textcontroller = TextEditingController(
                              text: calculate("Delete", false),
                            );
                          } on RangeError {
                            textcontroller = TextEditingController(
                              text: calculate(" ", false),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(200, 100),
                        backgroundColor: Colors.red,
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

class CalcHistory extends StatefulWidget {
  const CalcHistory({super.key});

  @override
  CalcHistoryState createState() => CalcHistoryState();
}

class CalcHistoryState extends State<CalcHistory> {
  Future<void> clearHistory() async {
    setState(() {
      calculationCounter = 0;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History'),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearHistory();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
      ),
      backgroundColor: Colors.black87,
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Loading History'));
          }
          if (snapshot.hasError) {
            return (Center(
              child: Text("Error in loading history: ${snapshot.error}"),
            ));
          }

          return ListView.builder(
            itemCount: calculationCounter,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                snapshot.data![index].toString(),
                style: TextStyle(color: Colors.white, fontSize: 24),
              );
            },
          );
        },
        future: readHistory(),
      ),
    );
  }
}
