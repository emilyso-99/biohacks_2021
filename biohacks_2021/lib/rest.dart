import 'package:flutter/material.dart';
import 'main.dart';

class Rest extends StatelessWidget {
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
              Image.asset('assets/images/rest.jpg'),
              Text(
                "\n\nBased on the symptoms you have selected, it does not appear that your symptoms are severe and thereofore you may not be at risk for COVID-19. Track your symptoms daily, and if they progress seek medical attention.\n\n",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              ButtonTheme(
                  minWidth: 150,
                  height: 90,
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
