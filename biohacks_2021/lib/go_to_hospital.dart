import 'package:flutter/material.dart';
import 'main.dart';

class Hospital extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Please Seek Medical Attention'),
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/images/go_to_hospital.jpeg',
                  fit: BoxFit.fill),
              Text(
                "\nBased on the symptoms you have selected, it appears that you may have come in contact with COVID-19 and could be at risk for infection. Please seek medical attention.\n",
                style: TextStyle(fontSize: 24),
              ),
              ButtonTheme(
                  minWidth: 100,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => new MyApp()),
                      );
                    },
                    child: Text(
                      "Go Back to Home",
                      style: TextStyle(fontSize: 20),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
