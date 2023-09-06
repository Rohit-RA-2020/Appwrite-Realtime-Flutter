import 'dart:developer';

import 'package:flutter/material.dart';
import '/main.dart';
import 'package:appwrite/appwrite.dart';
import '/mycard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Databases databases = Databases(client);
  String databaseId = "64f18323b5b3ce4c030a";
  String collectionId = "64f1832c29f85ac07eb3";

  late RealtimeSubscription subscription;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
    subscribe();
  }

  loadItems() async {
    try {
      await databases
          .listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      )
          .then((value) {
        var currentDocs = value.documents;
        setState(() {
          items = currentDocs.map((e) => e.data).toList();
        });
      });

      for (var i in items) {
        log(i.toString());
      }
    } on AppwriteException catch (e) {
      log(e.message.toString());
    }
  }

  void subscribe() {
    final realtime = Realtime(client);

    subscription = realtime.subscribe(
        ['databases.$databaseId.collections.$collectionId.documents']);

    // listen to changes
    subscription.stream.listen((data) {
      log("there is some change");
      // data will consist of `events` and a `payload`
      if (data.payload.isNotEmpty) {
        log("there is some change");
        if (data.events
            .contains("databases.*.collections.*.documents.*.create")) {
          var item = data.payload;
          log("Item Added");
          items.add(item);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.delete")) {
          var item = data.payload;
          log("item deleted");
          items.removeWhere((it) => it['\$id'] == item['\$id']);
          setState(() {});
        } else if (data.events
            .contains("databases.*.collections.*.documents.*.update")) {
          var item = data.payload;
          log("item update");
          int idx = items.indexWhere((it) => it['\$id'] == item['\$id']);
          log("$idx is the index");
          items[idx] = item;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    subscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rick and Morty"),
      ),
      body: items.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> current_obj = items[index];
                return MyCard(current_obj: current_obj);
              })
          : const Center(
              child: Text(
                "Oops! No stores to show",
              ),
            ),
    );
  }
}
