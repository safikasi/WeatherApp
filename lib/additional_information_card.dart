import 'package:flutter/material.dart';

class additional_information extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const additional_information({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Icon(
              icon, // icon here
              size: 32,
            ),
            const SizedBox(height: 8), // use to add some space

            Text(
              label, // label here
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(170, 255, 255, 255),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8), // use to add some space

            Text(
              value, // here we value
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
