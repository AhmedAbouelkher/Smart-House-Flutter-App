import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_house/screens/home.dart';
import 'dart:math' as math;

double degreeToRad(double angle) {
  return -angle * (math.pi / 180);
}

class AirConditioner extends StatefulWidget {
  @override
  _AirConditionerState createState() => _AirConditionerState();
}

class _AirConditionerState extends State<AirConditioner>
    with TickerProviderStateMixin, AfterLayoutMixin<AirConditioner> {
  AnimationController _controller;
  AnimationController _secondaryContoller;
  AnimationController _switchContoller;
  AnimationController _switchTextController;
  Animation<double> _animation;
  Animation<double> _secondaryAnimation;
  Animation<double> _arrowSecondaryAnimation;
  Animation<double> _switchAnimation;
  Animation<double> _switchTextAnimation;
  Animation<double> _showMeterAnimtion;
  bool isDeviceOff = false;
  bool isCoolingOn = false;
  bool isCoolingSwitchSizedChanged = false;
  bool changeTempColor = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _secondaryContoller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _switchContoller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _switchTextController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _showMeterAnimtion = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _controller, curve: Interval(0.5, 1, curve: Curves.ease)))
      ..addListener(() {
        setState(() {});
      });

    _secondaryAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _secondaryContoller, curve: Curves.elasticOut));
    _arrowSecondaryAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _secondaryContoller,
            curve: Interval(0.4, 1, curve: Curves.ease)));
    _switchAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _switchContoller, curve: Curves.ease))
          ..addListener(() {
            setState(() {});
          });
    _switchTextAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _switchTextController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (!_controller.isCompleted) {
      _controller.stop();
    }
    _controller.dispose();
  }

  List<Widget> _generateCiculerIndicator(
      {bool changePercentage = false, bool changeColor = false}) {
    //width: 280 --> angle: 6
    //width: 100 --> angle: ?
    List<Widget> _colection = [];
    double width = 300;
    double angle = -6;
    int count = (angle.abs() * 10).round();
    int alfaValue = (255 / count).round();
    int alfaColorIndex = 0;
    for (var i = 0; i < count; i++) {
      if (changePercentage) {
        if (i <= count * 0.6) {
          alfaColorIndex = i * 2;
        }
      }
      _colection.add(
        Transform.rotate(
          angle: degreeToRad(angle * i),
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(),
                Container(
                  color: Colors.white.withOpacity(0.15),
                  width: 12,
                  height: 6,
                  child: Container(
                    color: changePercentage
                        ? Color(0xff476BFE)
                            .withAlpha(alfaColorIndex * alfaValue)
                        : (changeColor
                            ? Color(0xff476BFE).withAlpha(i * alfaValue)
                            : Color(0xffFEC448).withAlpha(i * alfaValue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _colection;
  }

  void _moveToHome() {
    Navigator.push(
      context,
      PageRouteBuilder(
        maintainState: false,
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, animation, seconderyAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeIn));
          Animation<Offset> slideAnimation = animation.drive(tween);
          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // return AnimationTest();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          //background
          Positioned(
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                double translationY = (1 - _animation.value) * height;
                return Transform.translate(
                  offset: Offset(0, translationY),
                  child: Container(
                    height: height + 100,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xff343950),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular((1 - _animation.value) * 50),
                        topRight: Radius.circular((1 - _animation.value) * 50),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          //main text header
          Positioned(
            top: 120,
            left: 30,
            child: RichText(
              text: TextSpan(
                text: 'Air ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: 'Conditioner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          ),
          //ciculer indicator
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: _showMeterAnimtion.value,
              child: Stack(
                alignment: Alignment.center,
                children: _generateCiculerIndicator(
                    changePercentage: isCoolingOn,
                    changeColor: changeTempColor),
              ),
            ),
          ),
          //temp. indicator text
          Positioned(
            top: height / 2 - 90,
            left: 150,
            child: Text(
              (26 - _switchTextAnimation.value * (26 - 12)).toStringAsFixed(0) +
                  "°",
              style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          //back icon
          Positioned(
            top: 50,
            left: 10,
            child: AnimatedBuilder(
              animation: _arrowSecondaryAnimation,
              builder: (context, child) {
                double translationX =
                    (1 - _arrowSecondaryAnimation.value) * 100;
                return Transform(
                  transform: Matrix4.translationValues(translationX, 0, 0)
                    ..scale(1.15),
                  child: Opacity(
                    opacity: _arrowSecondaryAnimation.value,
                    child: child,
                  ),
                );
              },
              child: BackButton(
                color: Colors.white,
                onPressed: () => _moveToHome(),
              ),
            ),
          ),
          //orange switch
          Positioned(
            bottom: height * 0.30,
            left: (width / 2) - 55,
            child: AnimatedBuilder(
              animation: _secondaryAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: 1 - _switchAnimation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          top: 20 + _secondaryAnimation.value * 80, //20 -> 100
                          child: Container(
                            width: 110,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffFFB93B).withOpacity(0.4),
                                  Colors.transparent
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _switchContoller.isCompleted
                                ? _switchContoller.reverse()
                                : _switchContoller.forward();

                            setState(() {
                              changeTempColor = true;
                            });
                          },
                          child: Transform.translate(
                            offset: Offset(0, _switchAnimation.value * 100),
                            child: Container(
                              width: 110,
                              height: 50 +
                                  _secondaryAnimation.value * 80, //50 -> 130
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                color: Color(0xffFFB93B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Align(
                                alignment: Alignment(0, -0.6),
                                child: FaIcon(
                                  FontAwesomeIcons.sun,
                                  color: Colors.white,
                                  size: 15 + _secondaryAnimation.value * 5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          //Blue switch
          Positioned(
            bottom: height * 0.10,
            left: (width / 2) - 55,
            child: Transform.rotate(
              angle: degreeToRad(180),
              child: AnimatedBuilder(
                animation: _secondaryAnimation,
                builder: (context, child) {
                  double coolingSwitchScale =
                      isCoolingSwitchSizedChanged ? 0.96 : 1;
                  return Opacity(
                    opacity: _switchAnimation.value,
                    child: Opacity(
                      opacity: _animation.value,
                      child: Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Positioned(
                            top:
                                20 + _secondaryAnimation.value * 80, //20 -> 100
                            child: Container(
                              width: 110,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff476BFE).withOpacity(0.4),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTapDown: (_) {
                              _switchTextController.forward();
                              setState(() {
                                isCoolingSwitchSizedChanged = true;
                                isCoolingOn = true;
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                isCoolingSwitchSizedChanged = false;
                              });
                            },
                            onDoubleTap: () {
                              _switchContoller.isCompleted
                                  ? _switchContoller.reverse()
                                  : _switchContoller.forward();
                              _switchTextController.reverse();
                              setState(() {
                                isCoolingOn = false;
                                changeTempColor = false;
                              });
                            },
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.translationValues(
                                  0, _switchAnimation.value * 40, 0)
                                ..scale(coolingSwitchScale, coolingSwitchScale),
                              child: Container(
                                width: 110,
                                height: 50 +
                                    _secondaryAnimation.value * 80, //50 -> 130
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  color: Color(0xff476BFE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment(0, -0.6),
                                  child: FaIcon(
                                    FontAwesomeIcons.snowflake,
                                    color: Colors.white,
                                    size: 15 + _secondaryAnimation.value * 5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          //On/Off Switch
          Positioned(
            bottom: 15,
            left: (width / 2) - 48,
            child: GestureDetector(
              onLongPress: () {
                setState(() => isDeviceOff = !isDeviceOff);
              },
              child: Opacity(
                opacity: _animation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 1),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.powerOff,
                            color:
                                isDeviceOff ? Colors.red : Colors.greenAccent,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hold to turn" + (isDeviceOff ? " On" : " Off"),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        // fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () {
      _controller.forward();
      Future.delayed(Duration(milliseconds: 200), () {
        _secondaryContoller.forward();
      });
    });
  }
}
