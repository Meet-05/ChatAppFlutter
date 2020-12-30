import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/authForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/chat_screen.dart';

class AuthSceen extends StatefulWidget {
  @override
  _AuthSceenState createState() => _AuthSceenState();
}

class _AuthSceenState extends State<AuthSceen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool isLoading = false;
  UserCredential user;
  void _submitAuthForm(String username, String email, String password,
      bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        //already has an account
        user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        //islogin=false i.e new user which has n account curently
        user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        //to store some extra data during signup like usrname,etc
        //store the data in cloudFireStore immediatley after signup.
        //.collection()->creates a collection if not exists
        //.doc()->create a document with  an id
        //.set()->a Map to set the fields inside user documents
        _fireStore.collection('users').doc(user.user.uid).set({
          'username': username,
          'email': email,
        });
      }

      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => ChatScreen()));
    } catch (error) {
      var message = 'Invalid credentials';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, isLoading));
  }
}
