import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  void Function(File selectedFile) imagePickerFunction;
  UserImagePicker({this.imagePickerFunction});
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
      widget.imagePickerFunction(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 60,
          backgroundImage: _image != null ? FileImage(_image) : null,
        ),
        FlatButton.icon(
            onPressed: () {
              getImage();
            },
            icon: Icon(Icons.image),
            label: Text('Add image'))
      ],
    );
  }
}
