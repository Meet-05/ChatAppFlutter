import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './messagebubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User currentUser = _auth.currentUser;
    return StreamBuilder(
        //listen to the stream and perform sorting based on descending order of the timeStamp to fetch latest messages
        stream: _fireStore
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (cxt, messagesnapshot) {
          if (messagesnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = messagesnapshot.data.docs;

          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (_, index) {
                return MessageBubble(
                  message: chatDocs[index]['text'],
                  isMe: currentUser.uid == chatDocs[index]['userId']
                      ? true
                      : false,
                  Key: ValueKey(chatDocs[index].documentID),
                  userName: chatDocs[index]['username'],
                );
              });
        });
  }
}
