import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/authForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/chat_screen.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthSceen extends StatefulWidget {
  @override
  _AuthSceenState createState() => _AuthSceenState();
}

class _AuthSceenState extends State<AuthSceen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool isLoading = false;
  UserCredential user;
  dynamic url;

  void _submitAuthForm(String username, String email, String password,
      bool isLogin, BuildContext ctx, File image) async {
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

//before storing user data we store the image so that we can use also store the image path  in  user data
        //create a refernce to path in the  bucket.
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(user.user.uid + '.jpg');
//the put file method returns uploadTask.The whencompleted takes a callback in which we can fethc the imageurl
        UploadTask uploadTask = ref.putFile(image);
        uploadTask.whenComplete(() async {
          url = await ref.getDownloadURL();
          //to store some extra data during signup like usrname,etc
          //store the data in cloudFireStore immediatley after signup.
          //.collection()->creates a collection if not exists
          //.doc()->create a document with  an id
          //.set()->a Map to set the fields inside user documents
          _fireStore
              .collection('users')
              .doc(user.user.uid)
              .set({'username': username, 'email': email, 'imageUrl': url});
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
