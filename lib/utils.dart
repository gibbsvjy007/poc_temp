import 'package:flutter/material.dart';

import 'enums.dart';

class Utils {
  static showImagePickerSelectOptions(BuildContext context, Function onTap) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            //backgroundColor: Colors.white,
            title: Text(
              "Choose the picture from",
              style: TextStyle(fontSize: 16.0),
            ),
            children: <Widget>[
              ListTile(
                dense: true,
                leading: Icon(Icons.photo_album),
                title: Text(
                  "Gallery",
                  style: TextStyle(fontSize: 14.0),
                ),
                onTap: () {
                  onTap(PhotoSourceType.GALLERY);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                dense: true,
                leading: Icon(Icons.camera_alt),
                title: Text(
                  "Camera",
                  style: TextStyle(fontSize: 14.0),
                ),
                onTap: () {
                  onTap(PhotoSourceType.CAMERA);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}