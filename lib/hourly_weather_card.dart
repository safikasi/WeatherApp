import 'package:flutter/material.dart';

class weather_card extends StatelessWidget {
  final String time;
  final String temprature;
  final String url;
  const weather_card({
    super.key,
    required this.time,
    required this.temprature,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ), // use to add boarder radius
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5), // use to add some space
              Image.network(url),
              const SizedBox(height: 5), // use to add some space
              Text(
                "$temprature° C",
                // style: TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
