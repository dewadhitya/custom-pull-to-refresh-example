import 'dart:async';

import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Refresh',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Custom Refresh Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _offsetToArmed = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomRefreshIndicator(
        onRefresh: () => Future.delayed(Duration(seconds: 5), () {
          Fluttertoast.showToast(msg: "Refresh Completed");
        }),
        offsetToArmed: _offsetToArmed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    "Title $index",
                  ),
                  subtitle: Text(
                    "Subtitle $index",
                  ),
                ),
              );
            },
          ),
        ),
        builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
        ) {
          return AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!controller.isIdle)
                    Container(
                      color: Colors.grey[200],
                      height: _offsetToArmed * controller.value,
                      width: double.infinity,
                      child: SpinKitSquareCircle(
                        color: Colors.teal,
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, _offsetToArmed * controller.value),
                    child: AnimatedOpacity(
                      opacity: controller.isIdle ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 450),
                      child: child,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}