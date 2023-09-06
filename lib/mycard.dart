import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Map<String, dynamic> current_obj;
  const MyCard({Key? key, required this.current_obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightBlue[100],
        ),
        height: 100,
        width: double.maxFinite,
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.grey),
              child: Image.network(
                'https://static.remove.bg/sample-gallery/graphics/bird-thumbnail.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Text(
                  current_obj["name"],
                  style: TextStyle(fontSize: 22),
                ),
                Text(current_obj["age"].toString()),
                Text(current_obj["gender"]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
