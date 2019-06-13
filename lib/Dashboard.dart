import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'main.dart';
import 'package:rent_keeper/Addfloor.dart';
import 'transitionanimation.dart';

class Dashboard extends StatefulWidget {
  Dashboard({this.user, this.googleSignIn});

  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  void _signout() {
    AlertDialog alertDialog = new AlertDialog(
      elevation: 8.0,
      backgroundColor: Colors.white,
      content: Container(
        height: 250.0,
        child: Column(children: <Widget>[
          ClipOval(
            child: new Image.network(widget.user.photoUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Signout??",
              style: new TextStyle(fontSize: 16.0),
            ),
          ),
          new Divider(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {
                  widget.googleSignIn.signOut();
                  Navigator.push(context, SlideRightRoute(widget: new MyHomepage()));
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    Text("Yes")
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    Text("No")
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              SlideRightRoute(widget: new Addfloor(email: widget.user.email)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(height: 45,
        child:  new BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 3,
        elevation: 10.0,
        color: Colors.purple,
        child: ButtonBar(

          children: <Widget>[
          ],
        ),
      ),
      ),

      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("Floor")
                  .where("email", isEqualTo: widget.user.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                return new FloorList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
            height: 190.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("images/nkgrnd.jpg"),
                    fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0)
                ],
                color: Colors.purple),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 45.0, left: 5.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: new NetworkImage(widget.user.photoUrl),
                                fit: BoxFit.cover)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "WELCOME",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              new Text(
                                widget.user.displayName,
                                style: new TextStyle(
                                    fontSize: 24.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new IconButton(
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          _signout();
                        },
                      )
                    ],
                  ),
                ),
                new Text(
                  "FLOORS LIST",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      letterSpacing: 2,
                      fontFamily: "Pacifico"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FloorList extends StatelessWidget {
  FloorList({this.document});

  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 0.0, mainAxisSpacing: 2.0),
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String floorname = document[i].data['Floorname'].toString();
        String numofrooms = document[i].data['NumofRooms'].toString();
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 5.0,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[

                      Padding(padding: const EdgeInsets.all(4.0),

              ),


                      Text(
                        floorname,
                        style: TextStyle(fontSize: 27.0, letterSpacing: 1.0,), textAlign: TextAlign.center,
                      ),

                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.all(5.0),

                      ),
                      Text("Num.of Rooms:", style: TextStyle(fontSize: 20.0), textAlign: TextAlign.center,),
                      Text(
                        numofrooms,
                        style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                      ),
                    ],
                  )


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
