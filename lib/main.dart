import 'dart:async';

import 'package:flutter/material.dart';
import 'package:integrations_flutter/platform_view.dart';
import 'package:integrations_flutter/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _service = PlatformService();
  StreamSubscription? _subscription;
  int _counter = 0;

  void _getValue() async {
    _counter = await _service.callMethodChannel();
    setState(() {
      _counter++;
    });
  }

  void _sendText() async {
    _service.sendText('text');
  }

  // void _getSteam() async {
  //   _service.callEventChannel().listen((event) {
  //     setState(() {
  //       _counter = event;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 200),
                child: PlatformWidget(),
              ),
            ),
            StreamBuilder<int>(
              stream: _service.callEventChannel(),
              builder: (context, snapshot) => Text(
                '${snapshot.hasData ? snapshot.data : "No data"}',
                style: style,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getValue,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _sendText,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
