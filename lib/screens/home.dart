import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_house/screens/air_conditioner.dart';
import 'package:smart_house/screens/history.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AfterLayoutMixin<HomeScreen> {
  AnimationController _controller;
  AnimationController _defController;
  Animation<double> _animation;
  Animation<double> _slidingAnimation;
  Animation<double> _defAnimation;
  int _counter = 8;
  bool _lightOnScale = false;

  @override
  void initState() {
    super.initState();
    _defController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _defAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _defController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _slidingAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _moveToControl() {
    _controller.forward().then((_) {
      Navigator.push(
          context,
          PageRouteBuilder(
              maintainState: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  AirConditioner(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              }));
    });
  }

  _moveToHistory() {
    _controller.forward().then((_) {
      Navigator.push(
          context,
          PageRouteBuilder(
              maintainState: false,
              pageBuilder: (context, animation, secondaryAnimation) =>
                  History(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            //home background
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                color: Colors.white,
                height: height,
                width: double.infinity,
              ),
            ),
            //Menu Icon
            Positioned(
              left: 5,
              top: 20,
              child: AnimatedBuilder(
                animation: _defAnimation,
                builder: (BuildContext context, Widget child) {
                  double translationX = (_defAnimation.value) * 30;
                  return Transform(
                    transform: Matrix4.translationValues(translationX, 0, 0),
                    child: Opacity(
                      opacity: _defAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            //Welcomming Text
            Positioned(
              left: 40,
              top: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                    text: 'Hi,',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                    ),
                    children: [
                      TextSpan(
                        text: ' Lily!',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )),
                  SizedBox(height: 5),
                  Opacity(
                    opacity: 0.4,
                    child: RichText(
                        text: TextSpan(
                      text: 'What is your',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: ' mood',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' now?',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              ),
            ),
            //main screen widgets
            Positioned(
              top: 190,
              left: -120,
              child: AnimatedBuilder(
                animation: _defAnimation,
                builder: (context, child) {
                  double bulkTranslationX = (1 - _defAnimation.value) * 70;
                  return Transform(
                    transform:
                        Matrix4.translationValues(bulkTranslationX, 0, 0),
                    child: Opacity(
                      opacity: 1,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  height: 600,
                  width: 240 * 1.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 400,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/living_room.jpg',
                                alignment:
                                    Alignment((1 - _defAnimation.value), 0),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 400,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.black.withOpacity(
                                  _counter < 10 ? (0.2 - _counter / 100) : 0.0),
                            ),
                          ),
                          Container(
                            width: 400,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white.withOpacity(
                                  _counter > 10 && _counter < 40
                                      ? _counter / 100
                                      : (_counter < 10 ? 0 : 20 / 100)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Transform.translate(
                            offset: Offset((1 - _defAnimation.value) * 10, 0),
                            child: Container(
                              width: 120,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Color(0xff0ECE96),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(5, 5),
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 2,
                                    blurRadius: 20,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Currently",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      " 7°",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 65,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Transform.scale(
                            scale: _lightOnScale ? 0.97 : 1,
                            child: Transform.translate(
                              offset: Offset((1 - _defAnimation.value) * 20, 0),
                              child: GestureDetector(
                                onVerticalDragStart: (_) {
                                  setState(() {
                                    _lightOnScale = true;
                                  });
                                },
                                onVerticalDragEnd: (_) {
                                  setState(() {
                                    _lightOnScale = false;
                                  });
                                },
                                onVerticalDragUpdate: (dragUpdateDetails) {
                                  if (dragUpdateDetails.delta.dy < 0) {
                                    setState(() {
                                      if (_counter < 100) {
                                        _counter++;
                                      }
                                    });
                                  }
                                  if (dragUpdateDetails.delta.dy > 0) {
                                    setState(() {
                                      if (_counter > 0) {
                                        _counter--;
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: 120,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(5, 5),
                                        color: Colors.black.withOpacity(0.08),
                                        spreadRadius: 2,
                                        blurRadius: 20,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "light On",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          (_counter < 10 ? "0" : "") +
                                              "$_counter",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 60,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            //sliding side panel
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, bigchild) {
                  double maintranslationX = -width * 0.60 * _animation.value;
                  return AnimatedBuilder(
                    animation: _defAnimation,
                    child: Transform(
                      transform:
                          Matrix4.translationValues(maintranslationX, 0, 0),
                      child: bigchild,
                    ),
                    builder: (context, smallchild) {
                      double deftranslationX = 70 * (1 - _defAnimation.value);
                      return Transform(
                        transform:
                            Matrix4.translationValues(deftranslationX, 0, 0),
                        child: smallchild,
                      );
                    },
                  );
                },
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                  height: height,
                  width: 140,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/avater.jpg',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      SizedBox(
                        height: 350,
                        child: Opacity(
                          opacity: 0.7,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                  child: FaIcon(FontAwesomeIcons.utensils)),
                              Expanded(
                                  child: FaIcon(FontAwesomeIcons.couch,
                                      color: Colors.orange)),
                              Expanded(child: FaIcon(FontAwesomeIcons.bed)),
                              Expanded(
                                  child: FaIcon(FontAwesomeIcons.plusCircle)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => _moveToHistory(),
                              child: Transform.translate(
                                offset:
                                    Offset((1 - _defAnimation.value) * 30, 0),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Text(
                                    "Histoy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18,
                                      letterSpacing: 1.01,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                _moveToControl();
                              },
                              child: Transform.translate(
                                offset:
                                    Offset((1 - _defAnimation.value) * 20, 0),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height: 15),
                                      Text(
                                        "Control",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18,
                                          letterSpacing: 1.01,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      CircleAvatar(
                                        backgroundColor: Colors.orange,
                                        radius: 2.5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //sliding Screen
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _slidingAnimation,
                builder: (BuildContext context, Widget child) {
                  double translationX = (1 - _slidingAnimation.value) * width;
                  return Transform(
                    transform: Matrix4.translationValues(translationX, 0, 0),
                    child: child,
                  );
                },
                child: Container(
                  color: Colors.white,
                  height: height,
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future.delayed(Duration(milliseconds: 50), () => _defController.forward());
  }
}
