import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/messages.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                    value: 'signout',
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          Text('Signout'),
                        ],
                      ),
                    ))
              ],
              onChanged: (seelctedItem) {
                if (seelctedItem == 'signout') {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                }
              })
        ],
      ),
      //a listner attached to our cloudfirestore at path /chats/ox2cUPjlX8tSk9JJfvjP/messages/
      body: Column(
        children: [Expanded(child: Messages()), NewMessage()],
      ),
    );
  }
}
