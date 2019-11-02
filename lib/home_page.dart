import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vijay_poc/result_page.dart';
import 'package:vijay_poc/utils.dart';
import 'package:path/path.dart' as path;
import 'add_pic_circle.dart';
import 'enums.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File imageFile;
  StorageUploadTask _task;

  void _uploadImg() async {
    final String extension = path.extension(imageFile.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '$extension';

    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('poc/$fileName');
    final StorageUploadTask task = firebaseStorageRef.putFile(
      imageFile,
      StorageMetadata(
        contentType: 'image/$extension',
      ),
    );
    setState(() {
      _task = task;
    });
  }

  Future<void> _loadAssets(PhotoSourceType type) async {
    switch (type) {
      case PhotoSourceType.GALLERY:
        imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
      case PhotoSourceType.CAMERA:
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      default:
    }

    setState(() {
      _task = null;
      imageFile = imageFile;
    });
  }

  void _selectMedia() {
    Utils.showImagePickerSelectOptions(context, _loadAssets);
  }

  Future<void> setImage() async {
    String url = '';
    final StorageTaskSnapshot downloadUrl = (await _task.onComplete);
    _task = null;
    url = (await downloadUrl.ref.getDownloadURL());
    print(url);
    await Fluttertoast.showToast(
        msg: 'Document uploaded successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        textColor: Colors.white,
        fontSize: 14.0);

    await Future.delayed(Duration(seconds: 1));
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResultPage(url: url,)));
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          if (_task != null) {
            _task.cancel();
            _task = null;
          }
          return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              AddPicCircle(
                size: 180.0,
                image: imageFile,
                imgUrl: '',
                onPressed: _selectMedia,
              ),
              SizedBox(height: 30.0,),
              Text(
                'Tap to Select', style: Theme.of(context).textTheme.title.copyWith(color: Colors.grey)
              ),
              SizedBox(height: 20.0,),
              _task != null ? StreamBuilder<StorageTaskEvent>(
                stream: _task.events,
                builder: (context,
                    AsyncSnapshot<StorageTaskEvent> snapshot) {
                  bool uploadComplete = false;
                  if (_task.isComplete && _task.isSuccessful) {
                    uploadComplete = true;
                    setImage();
                  }
                  print('_________________uploaded__________' + uploadComplete.toString());
                  return Container();
                },
              ) : Container(),
              imageFile != null ? SizedBox(
                width: 200.0,
                height: 55.0,
                child: OutlineButton(
                  onPressed: imageFile != null ? _uploadImg : null,
                  child: _task != null && _task.isInProgress ? CircularProgressIndicator(strokeWidth: 1.0,) : Text('UPLOAD', style: TextStyle(color: Colors.blue),),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  borderSide: BorderSide(color: Colors.blue),
                  shape: StadiumBorder(),
                ),
              ) : Container()
            ],
          ),
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
