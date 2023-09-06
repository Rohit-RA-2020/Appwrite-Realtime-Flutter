import 'package:appwrite_realtime/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';

Databases database = Databases(client);
final realtime = Realtime(client);
RealtimeSubscription? subscription = realtime.subscribe(['documents']);

final counterStream = StreamProvider<int>((ref) {
  return subscription!.stream.map((event) => event.payload['counter']);
});
