import 'package:feather_icons_svg/feather_icons_svg.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: FeatherIconTheme(
        strokeWidth: 1.5,
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: IconTheme(
          data: IconThemeData(color: Colors.black),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(color: Colors.green, size: 40),
                child: FeatherIcon(FeatherIcons.arrowLeft),
              ),
              FeatherIcon(FeatherIcons.arrowRight, size: 40),
              FeatherIcon(
                FeatherIcons.calendar,
                color: Colors.blue,
              ),
              FeatherIcon(FeatherIcons.arrowLeft),
              FeatherIcon(
                FeatherIcons.arrowRight,
                strokeWidth: 3,
              ),
              FeatherIcon(FeatherIcons.activity),
              FeatherIcon(
                FeatherIcons.bell,
                strokeWidth: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
