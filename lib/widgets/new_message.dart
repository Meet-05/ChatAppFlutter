import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String newMessage = '';
  var newMessageController = TextEditingController();
  User loggedInUser;
  var userDoc;

//storing a message with a timeStamp to maintain the order of message while recieving it
  void _sendMessage() async {
    loggedInUser = _auth.currentUser;
    FocusScope.of(context).unfocus();
    //return the user document haviing the id as current logged in userId
    userDoc = await _firestore.collection('users').doc(loggedInUser.uid).get();
    if (newMessageController.text.isEmpty) {
      return;
    }
    _firestore.collection('chat').add({
      'text': newMessageController.text,
      'createdAt': Timestamp.now(),
      'userId': loggedInUser.uid,
      'username': userDoc['username'],
      'imageUrl': userDoc['imageUrl'],
    });

    newMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      // margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: newMessageController,
            decoration: InputDecoration(labelText: 'Send a Message'),
            onChanged: (value) {
              newMessage = value;
            },
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              _sendMessage();
            },
          )),
          IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: newMessage.trim().isEmpty ? null : _sendMessage),
        ],
      ),
    );
  }
}
