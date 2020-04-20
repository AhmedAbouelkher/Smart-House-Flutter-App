import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:smart_house/screens/home.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SequenceAnimation sequenceAnimation;
  Duration _fullDuration;

  @override
  void initState() {
    super.initState();
    _fullDuration = Duration(milliseconds: 400);
    _controller = AnimationController(vsync: this, duration: _fullDuration);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: intervel(0),
            to: _fullDuration,
            tag: "arrowAnimation")
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: intervel(0.35),
            to: _fullDuration,
            tag: 'masterMasterAnimation')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: intervel(0.9),
            to: Duration(milliseconds: 550),
            tag: 'slowerMasterAnimation')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: intervel(0.6),
            to: _fullDuration,
            tag: 'masterAnimation')
        .addAnimatable(
            animatable: Tween<double>(begin: 0, end: 1),
            from: intervel(0.65),
            to: Duration(milliseconds: 1500),
            tag: 'increasing number')
        .animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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

  Duration intervel(double intervel, {int fullDuration = 400}) {
    int _fullDuration = fullDuration;
    return Duration(milliseconds: (_fullDuration * intervel).round());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            left: 23,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                double animationValue =
                    sequenceAnimation['arrowAnimation'].value;
                return Transform.translate(
                  offset: Offset(40 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: BackButton(
                color: Colors.black,
                onPressed: () => _moveToHome(),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 40,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                double animationValue =
                    sequenceAnimation['masterMasterAnimation'].value;
                return Transform.translate(
                  offset: Offset(20 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  text: 'Your ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: 'History',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: 30,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                double animationValue =
                    sequenceAnimation['masterAnimation'].value;
                return Transform.translate(
                  offset: Offset(20 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                width: width - 75,
                child: Row(
                  children: <Widget>[
                    Text(
                      "July",
                      style: TextStyle(
                        color: Colors.black12,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      "August",
                      style: TextStyle(
                        color: Color(0xff0ECE96),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 55),
                    Text(
                      "September",
                      style: TextStyle(
                        color: Colors.black12,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 50,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                double animationValue =
                    sequenceAnimation['masterMasterAnimation'].value;
                double animationValueY =
                    sequenceAnimation['slowerMasterAnimation'].value;
                return Transform.translate(
                  offset: Offset(350 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: Container(
                      height: 50 + 200 * animationValueY,
                      width: width - 50,
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Color(0xff343950),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 50,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                double animationValue =
                    sequenceAnimation['masterAnimation'].value;
                return Transform.translate(
                  offset: Offset(30 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                );
              },
              child: Container(
                height: 250,
                width: width - 50,
                color: Colors.transparent,
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Period",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "from",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '7:30 ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 33,
                            ),
                            children: [
                              TextSpan(
                                text: 'PM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "to",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: '8:00 ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 33,
                            ),
                            children: [
                              TextSpan(
                                text: 'AM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 270,
            child: Container(
              height: 160,
              width: 220,
              child: Padding(
                padding: EdgeInsets.only(right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget child) {
                        double animationValue =
                            sequenceAnimation['masterAnimation'].value;
                        return Transform.translate(
                          offset: Offset(20 * (1 - animationValue), 0),
                          child: Opacity(
                            opacity: animationValue,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        "Humidity\n",
                        style: TextStyle(
                          color: Color(0xff343950),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget child) {
                        double animationValue =
                            sequenceAnimation['masterAnimation'].value;
                        double slowAnimation =
                            sequenceAnimation['increasing number'].value;
                        return Opacity(
                          opacity: animationValue,
                          child: Text(
                            (slowAnimation * 49).toStringAsFixed(0) + "%",
                            style: TextStyle(
                              color: Color(0xff343950),
                              fontSize: 45,
                            ),
                          ),
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (BuildContext context, Widget child) {
                        double animationValue =
                            sequenceAnimation['masterAnimation'].value;
                        return Opacity(
                          opacity: animationValue,
                          child: child,
                        );
                      },
                      child: Text(
                        "Week 2 - 12% humidity",
                        style: TextStyle(
                          color: Colors.black12,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: width / 2 + 100,
            left: 0,
            child: Container(
              height: 200,
              width: width + 50,
              child: Transform(
                transform: Matrix4.translationValues(-55, 10, 0),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    double animationValue =
                        sequenceAnimation['masterAnimation'].value;
                    double slowAimation =
                        sequenceAnimation['slowerMasterAnimation'].value;
                    return Transform.translate(
                      offset: Offset(-40 * (1 - animationValue), 0),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 50.0 + 62,
                            top: 10,
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              height: 130 * slowAimation,
                              width: 1,
                            ),
                          ),
                          Positioned(
                            left: 50.0 + 186,
                            top: 10 + 110.0,
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              height: 70 * slowAimation,
                              width: 1,
                            ),
                          ),
                          Positioned(
                            left: 50.0 + 186 + 79,
                            top: 10 + 80.0,
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              height: 90 * slowAimation,
                              width: 1,
                            ),
                          ),
                          Positioned(
                            left: 50.0 + 186 + 79 + 78,
                            top: 10 + 110.0,
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                              height: 50 * slowAimation,
                              width: 1,
                            ),
                          ),
                          Opacity(
                            opacity: animationValue,
                            child: BezierChart(
                              bezierChartScale: BezierChartScale.CUSTOM,
                              xAxisCustomValues: [0, 20, 60, 85, 110],
                              series: [
                                BezierLine(
                                  lineColor: Color(0xffFFB93F),
                                  lineStrokeWidth: 3,
                                  data: [
                                    DataPoint<int>(value: 70, xAxis: 0),
                                    DataPoint<int>(value: 75, xAxis: 20),
                                    DataPoint<int>(value: 35, xAxis: 60),
                                    DataPoint<int>(value: 50, xAxis: 85),
                                    DataPoint<int>(value: 40, xAxis: 110),
                                  ],
                                ),
                              ],
                              config: BezierChartConfig(
                                  showVerticalIndicator: false,
                                  snap: false,
                                  xLinesColor: Colors.black,
                                  displayLinesXAxis: false,
                                  xAxisTextStyle:
                                      TextStyle(color: Colors.transparent)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
