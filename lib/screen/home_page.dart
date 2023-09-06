import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';

class MySecondPage extends ConsumerStatefulWidget {
  const MySecondPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MySecondPageState();
}

class _MySecondPageState extends ConsumerState<MySecondPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(counterStream).when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Second Page'),
          ),
          body: Center(
            child: Text(
              data.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
      error: ((error, stackTrace) {
        return const Center(
          child: Text("Error"),
        );
      }),
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
