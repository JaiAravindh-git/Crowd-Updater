import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      home: Page1(),
    ));

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}
class _Page1State extends State<Page1> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<DeviceIdentifier> deviceNames = [];
  void report(List numbs) {
    setState(() {
      int cnt = numbs.length;
      if (cnt > 5) {
        Alert(context: context, title: 'Report', desc: "Report to medico")
            .show();
      } else {
        Alert(context: context, title: 'Safe', desc: "Be Careful").show();
      }
    });
  }
  //Map dn = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Corona count updater'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    color: Colors.cyan,
                    child: Text("scan"),
                    onPressed: () {
                      flutterBlue.startScan(timeout: Duration(seconds: 4));
                      flutterBlue.scanResults.listen((results) {
                        for (ScanResult r in results) {
                          //print('${r.device.id} found!');
                          deviceNames.add(r.device.id);
                          deviceNames = deviceNames.toSet().toList();
                          //dn["device id"] = r.device.id;
                          //dn["connection type"] = r.device.type;
                        }
                      });
                      //Stop Scanning
                      flutterBlue.stopScan();
                    }),
                SizedBox(height: 10.0),
                FlatButton(
                  color: Colors.cyan,
                  onPressed: () {
                    print(deviceNames.toSet().toList());
                    print(deviceNames.length);
                    //print(dn);
                  },
                  child: Text('console print'),
                ),
                FlatButton(
                  onPressed: () {
                   // report(deviceNames);
                  Firestore.instance
                        .collection("blueids")
                        .document("0")
                        .setData({'BlueId': '$deviceNames'});
                  },
                  child: Text('report'),
                  color: Colors.cyan,
                ),

                //Container(child: printing(),),
              ]),
        ));
  }
}
