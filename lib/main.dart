import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screen/home_page.dart';

Client client = Client();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  client
      .setEndpoint('http://192.168.1.7/v1')
      .setProject('64f0c11196cc253e2cca')
      .setSelfSigned(status: true);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Databases database = Databases(client);
  final realtime = Realtime(client);
  RealtimeSubscription? subscription;

  Stream sub() {
    subscription = realtime.subscribe(['documents']);
    return subscription!.stream;
    //subscription!.stream.listen((event) => log(event.payload.toString()));
  }

  int? counter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    subscription!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My AppBar'),
      ),
      body: StreamBuilder(
        stream: sub(),
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.data.payload['counter'].toString(),
                style: const TextStyle(fontSize: 30),
              ),
            );
          } else {
            return const Center(
              child: Text("No data"),
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // update counter value from Appwrite Database to one more than current value
              database
                  .getDocument(
                databaseId: '64f18323b5b3ce4c030a',
                collectionId: '64f1832c29f85ac07eb3',
                documentId: '64f1c8a2947d720b2e3f',
              )
                  .then(
                (value) {
                  database.updateDocument(
                    databaseId: '64f18323b5b3ce4c030a',
                    collectionId: '64f1832c29f85ac07eb3',
                    documentId: '64f1c8a2947d720b2e3f',
                    data: {
                      'counter': value.data['counter'] + 1,
                    },
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              database.updateDocument(
                databaseId: '64f18323b5b3ce4c030a',
                collectionId: '64f1832c29f85ac07eb3',
                documentId: '64f1c8a2947d720b2e3f',
                data: {
                  'counter': 0,
                },
              );
            },
            child: const Icon(Icons.restore),
          ),
        ],
      ),
    );
  }
}
