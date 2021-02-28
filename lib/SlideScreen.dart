import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vaccineapp/LoginPage.dart';

class SlideScreen extends StatefulWidget {
  @override
  _SlideScreenState createState() => _SlideScreenState();
}

final int numPages = 3;
final PageController controller = PageController(initialPage: 0);
int _currentpage = 0;
List<Widget> _buildPageIndicator() {
  List<Widget> list = [];
  for (int i = 0; i < numPages; i++) {
    list.add(i == _currentpage ? _indicator(true) : _indicator(false));
  }
  return list;
}

Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    height: 8.0,
    width: isActive ? 14.0 : 16.0,
    decoration: BoxDecoration(
      color: isActive ? Color(0xff00B0FF) : Colors.grey,
      shape: BoxShape.circle,
    ),
  );
}

class _SlideScreenState extends State<SlideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: controller,
                  onPageChanged: (page) {
                    setState(() {
                      _currentpage = page;
                    });
                  },
                  children: [Walk1(), Walk2(), Walk3(), LoginPage()],
                ),
              ),
            ),
          ],
        ));
  }
}

class Walk1 extends StatefulWidget {
  @override
  _Walk1State createState() => _Walk1State();
}

class _Walk1State extends State<Walk1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img1.png',
          ),
          Text(
            'You can easily sign up with your google account and proceed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              height: ScreenUtil().setHeight(40.0),
              minWidth: ScreenUtil().setWidth(285.0),
              color: Color(0xff00B0FF),
              onPressed: () {
                controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                "Proceed",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(15.0)),
              ))
        ],
      ),
    );
  }
}

class Walk2 extends StatefulWidget {
  @override
  _Walk2State createState() => _Walk2State();
}

class _Walk2State extends State<Walk2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img2.png',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'You can easily navigate nearest vaccination center.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: ScreenUtil().setSp(18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              height: ScreenUtil().setHeight(40.0),
              minWidth: ScreenUtil().setWidth(285.0),
              color: Color(0xff00B0FF),
              onPressed: () {
                controller.nextPage(
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Text(
                "Proceed",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(15.0)),
              ))
        ],
      ),
    );
  }
}

class Walk3 extends StatefulWidget {
  @override
  _Walk3State createState() => _Walk3State();
}

class _Walk3State extends State<Walk3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img3.png',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Simply book your appointment according to your need.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: ScreenUtil().setSp(18)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              height: ScreenUtil().setHeight(40.0),
              minWidth: ScreenUtil().setWidth(285.0),
              color: Color(0xff00B0FF),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(15.0)),
              ))
        ],
      ),
    );
  }
}

