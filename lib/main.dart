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
    }
    else if(newVar == 'C'){
      return continuousVar = '';
    }
    return continuousVar += newVar;
  }
  num actualcalculate(){
    for(int i = 0; i < continuousVar.length; i++){
      
    }

    return result;
  }
  @override
  void dispose(){
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
                style: TextStyle(
                  fontSize: 52,
                  color: Colors.red,
                ),
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
                          textcontroller = TextEditingController(text: calculate("current") );
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
                    style: ElevatedButton.styleFrom(fixedSize: Size(200, 100)),
                    child: Text('='),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(fixedSize: Size(200, 100)),
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
