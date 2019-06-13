import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'transitionanimation.dart';

import 'Dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: new MyHomepage());
  }

}


class MyHomepage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}




class _MyHomePageState extends State<MyHomepage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signin() async {
    FirebaseUser user;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    user = await firebaseAuth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentuser = await firebaseAuth.currentUser();
    assert(user.uid == currentuser.uid);

    Navigator.push(context, SlideRightRoute(widget: new Dashboard(user: user,googleSignIn: googleSignIn)
    )
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('RentKeeper')),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bkgrnd.jpg"), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: new Image.asset(
                "images/welcome.png",
                width: 150,
              ),
            ),



                new InkWell(
                  onTap: (){
                    _signin();
                  },
                    child:
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Image.asset("images/signbtn.jpg", width: 350, height: 50,),
                    )
                ),


          ],
        ),
      ),
    );
  }
}
