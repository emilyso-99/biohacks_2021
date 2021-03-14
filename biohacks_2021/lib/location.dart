import 'package:biohacks_2021/go_to_hospital.dart';
import 'package:biohacks_2021/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
//import 'package:flutter_map/flutter_map.dart';

class Locator extends StatelessWidget {
  Map values;
  Locator(Map<String, bool> values) {
    this.values = values;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColorBrightness: Brightness.dark),
      home: LocatorPage(this.values, title: 'Locator'),
    );
  }
}

class LocatorPage extends StatefulWidget {
  Map values;
  LocatorPage(Map value, {Key key, this.title}) : super(key: key) {
    // super(key: key);
    this.values = value;
  }

  final String title;

  @override
  _LocatorStatePage createState() => _LocatorStatePage(this.values);
}

class _LocatorStatePage extends State<LocatorPage> {
  Map _pickedLocation;
  var _pickedLocationText;
  Map values;
  String cases = "3598343";
  String death = "55629";
  _LocatorStatePage(Map values) {
    this.values = values;
  }
  Future getLocationWithNominatim() async {
    Map result = await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return NominatimLocationPicker(
            searchHint: 'Search',
            awaitingForLocation: "Finding Location",
          );
        });
    if (result != null) {
      setState(() => _pickedLocation = result);
    } else {
      return;
    }
  }

  RaisedButton nominatimButton(Color color, String name) {
    return RaisedButton(
      color: color,
      onPressed: () async {
        await getLocationWithNominatim();
      },
      textColor: Colors.white,
      child: Center(
        child: Text(name),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  RaisedButton mapBoxButton(Color color, String name) {
    return RaisedButton(
      color: color,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => getLocationWithMapBox()),
        );
      },
      textColor: Colors.white,
      child: Center(
        child: Text(name),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget getLocationWithMapBox() {
    return MapBoxLocationPicker(
      popOnSelect: true,
      apiKey: "YOUR API KEY",
      limit: 10,
      language: 'pt',
      country: 'br',
      searchHint: 'Pesquisar',
      awaitingForLocation: "Procurando por sua localização",
      onSelected: (place) {
        setState(() {
          _pickedLocationText = place.geometry
              .coordinates; // Example of how to call the coordinates after using the Mapbox Location Picker
          print(_pickedLocationText);
        });
      },
      context: context,
    );
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text('How to use'),
    );
  }

  List<Widget> MakeList() {
    List<Widget> texts = [];
    for (var i in this.values.keys) {
      texts.add(Text("$i:${this.values[i].toString()}",
          textAlign: TextAlign.left, style: TextStyle(fontSize: 14)));
    }
    return texts;
  }

  int MakeWeights() {
    int weights = 0;
    for (var i in this.values.keys) {
      if (i == 'Have travelled to another country within the last 14 days' ||
          i ==
              'Have been in contact with someone who has travelled to another country within the last 14 days' ||
          i == 'Over the age of 60' ||
          i ==
              'Have a condition such as: cancer, chronic kidney disease, heart conditions, type II diabetes, pregnancy, down syndrome, immunocompromised') {
        if (this.values[i] == true) {
          weights += 5;
        }
      }
      if (i == "Fever" || i == "Dry cough" || i == "Fatigue") {
        if (this.values[i] == true) {
          weights += 2;
        }
      } else {
        if (this.values[i] == true) {
          weights += 1;
        }
      }
    }
    return weights;
  }

  Widget body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: _pickedLocation != null
              ? Center(
                  child: Column(
                  children: [
                    Text(
                      "You specified your location to be the following:\n",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${this._pickedLocation["desc"]}\n",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "The current case count in your state is $cases and there have been $death total deaths. Please be mindful of this.\n",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (MakeWeights() > 16) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Hospital()),
                            );
                          }
                        },
                        child: Text("Next"))
                  ],
                ))
              : SingleChildScrollView(
                  child: Column(children: [
                  for (var i in this.values.keys)
                    new Text(
                      "$i:${this.values[i].toString()}",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  nominatimButton(Colors.blue, 'Select my Location'),
                ])),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, appBar: appBar(), body: body(context));
  }
}
