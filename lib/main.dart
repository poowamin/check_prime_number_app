import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String _result = '';
  late FocusNode _focusNode;
  final numRegex = RegExp('^[0-9]');

  // ฟังก์ชัน คำนวณ จำนวนเฉพาะ
  bool isPrime(n) {
    if (n <= 1) {
      return false;
    }
    for (var i = 2; i <= n / i; ++i) {
      if (n % i == 0) {
        return false;
      }
    }

    return true;
  }

  // ฟังก์ชัน แสดง ผลลัพธ์
  String primeMessage(int number) {
    Stopwatch stopwatch = Stopwatch()..start();
    bool result = isPrime(number);
    stopwatch.stop();
    return 'Number: $number is ${result ? "prime number " : "not prime number"}\nTime taken: ${stopwatch.elapsed.inMicroseconds} ms';
  }

  // ฟังก์ชัน เคลีย ค่าจาก controller
  void clearValue() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Check Prime numbers',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: TextFormField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter numbers',
                      border: OutlineInputBorder(),
                      // errorText: _errorText.isNotEmpty ? _errorText : null,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a number';
                      } else if (!numRegex.hasMatch(value)) {
                        return 'Only 0-9';
                      }
                      return null;
                    },
                  ),
                ),
                Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    int? newValue = int.tryParse(_controller.text);

                    if (_formkey.currentState!.validate()) {
                      setState(
                        () {
                          if (newValue != null) {
                            _result = primeMessage(newValue);
                            clearValue();
                          }
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
