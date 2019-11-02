import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String url;

  ResultPage({this.url});

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Result'),),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.face,  size: 100.0,),
            SizedBox(height: 30.0,),
            Text('Hello!', style: TextStyle(fontSize: 20.0, letterSpacing: 1.0),),
            SizedBox(height: 30.0,),
            FlatButton.icon(
              icon: Icon(Icons.system_update, color: Colors.grey,),
              onPressed: _launchURL,
              label: Text('download', style: TextStyle(color: Colors.grey, fontSize: 16.0),),
            )
          ],
        ),
      ),
    );
  }
}
