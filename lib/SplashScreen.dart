import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vaccineapp/SlideScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 8),
        () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SlideScreen()))
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                height: ScreenUtil().setHeight(200),
                width: ScreenUtil().setWidth(200),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset(
                    'assets/logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                )),
            SizedBox(
              height: ScreenUtil().setHeight(55.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(55.0),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Please Wait...',
                style: TextStyle(fontSize: ScreenUtil().setSp(25.0)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
