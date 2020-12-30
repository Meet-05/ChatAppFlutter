import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Key;
  final String message;
  final bool isMe;
  final String userName;

  MessageBubble({this.message, this.isMe, this.Key, this.userName});
  @override
  Widget build(BuildContext context) {
    //wrapping container inside the row so that the width and height of container child are maintained
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isMe ? Theme.of(context).accentColor : Colors.pink[50],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft:
                      isMe ? Radius.circular(20.0) : Radius.circular(0.0),
                  bottomRight:
                      isMe ? Radius.circular(0.0) : Radius.circular(20.0))),
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.center,
            children: [
              Text(userName),
              Text(
                message,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
