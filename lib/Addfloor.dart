import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Addfloor extends StatefulWidget {
  Addfloor({this.email});
  final String email;
  @override
  _AddfloorState createState() => _AddfloorState();
}


class _AddfloorState extends State<Addfloor> {

  void _adddata() {
  Firestore.instance.runTransaction((Transaction transcation) async {
      
    CollectionReference reference = Firestore.instance.collection("Floor");
    await reference.add({
      "email" : widget.email,
      "Floorname" :floorname,
      "NumofRooms" : numofrooms,

    });

  });
  
  Navigator.pop(context);
  }

  String floorname='';
  String numofrooms='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Floors",
          style: new TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              letterSpacing: 2.0,
              fontFamily: "Pacifico"),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 130.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Add Floor",
                    style: new TextStyle(fontSize: 24.0, color: Colors.white),
                  ),
                ),
                Icon(
                  Icons.list,
                  color: Colors.white,
                  size: 30.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged:(String str) {
                setState(() {
                  floorname=str ;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(
                    Icons.home,
                    size: 30.0,
                  ),
                  hintText: "Floor Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str) {
                setState(() {
                  numofrooms=str;
                });
              },
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  icon: Icon(
                    Icons.menu,
                    size: 30.0,
                  ),
                  hintText: "Number of Rooms",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                IconButton(
                  icon: Icon(Icons.check,size: 50.0,),
                  onPressed: () {
                    _adddata();
                  },
                ),

                IconButton(
                  icon: Icon(Icons.close,size: 50.0,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
