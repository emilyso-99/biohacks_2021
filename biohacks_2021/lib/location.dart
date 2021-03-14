import 'package:biohacks_2021/main.dart';
import 'package:flutter/material.dart';
import 'package:nominatim_location_picker/nominatim_location_picker.dart';
//import 'package:flutter_map/flutter_map.dart';

class Locator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue, primaryColorBrightness: Brightness.dark),
      home: MyHomePage(title: 'Example of usage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map _pickedLocation;
  var _pickedLocationText;

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
                      "You specified your location to be the following:",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      this._pickedLocation["desc"],
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new MyApp()),
                          );
                        },
                        child: Text("Next"))
                  ],
                ))
              : nominatimButton(Colors.blue, 'Select my Location'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, appBar: appBar(), body: body(context));
  }
}
