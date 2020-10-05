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
  bool isRefresh = false;

  Future<void> _refreshFunction() {
    setState(() {
      isRefresh = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isRefresh = false;
      });
      Fluttertoast.showToast(msg: "Refresh Completed");
    });

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CustomRefreshIndicator(
        onRefresh: _refreshFunction,
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
                  !controller.isIdle 
                  ? Container(
                    color: Colors.grey[200],
                    height: _offsetToArmed * controller.value,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.isArmed ? Icons.arrow_circle_up : Icons.arrow_circle_down,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          controller.isArmed ? "Release to refresh" : "Pull down to refresh",
                        ),
                      ],
                    ),
                  ) 
                  : this.isRefresh
                  ? Container(
                    color: Colors.grey[200],
                    height: _offsetToArmed,
                    width: double.infinity,
                    child: SpinKitCircle(
                      color: Colors.teal,
                    ),
                  ) : Container(),
                  Transform.translate(
                    offset: Offset(0, this.isRefresh ? _offsetToArmed : _offsetToArmed * controller.value),
                    child: child,
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