// import 'dart:nativewrappers/_internal/vm/lib/ffi_dynamic_library_patch.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //https://pub.dev/packages/flutter_dotenv
import 'hourly_weather_card.dart';
import 'additional_information_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for json convertion
// for date formatting
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  dynamic data =
      0; // in dynamic we set int type data then we change to string or other in future :) => mara opna orignal comment aa

  // async function to get future data
  Future<Map<String, dynamic>> getWeatherData() async {
    final String city = 'Quetta,PK';

    String apiKey = dotenv.env['API_KEY'] ?? ''; // <-- API key from .env
    final String url =
        'http://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey';

    // print("📡 API Call: $url");

    final response = await http.get(Uri.parse(url));
    // print('response.statusCode :: ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        // decode JSON response
        data = jsonDecode(response.body);
        return data;
      } catch (e) {
        print("❌ JSON Decode Error: $e");
        throw Exception("JSON decoding failed");
      }
    } else {
      print("❌ HTTP Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to fetch weather data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            // IconButton more good click effect
            onPressed: () {
              print('refresh button pressed');
            },
            icon: const Icon(Icons.refresh),
          ),
          // InkWell(
          //   // we use guesture also on the place of inkwell it just give us the click effect color
          //   onTap: () {
          //     print("refresh clicked");
          //   },
          //   child: const Icon(Icons.refresh),
          // ),
        ],
      ),
      body: FutureBuilder(
        future: getWeatherData(),
        builder: (context, snapshot) {
          // print(context);
          // print(snapshot);
          // print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          //               (data['list'][0]['main']['temp']) -   273.15;
          final data = snapshot.data!; // ! why !
          final currentTemperature = (data['list'][0]['main']['temp']) - 273.15;
          final currentWeatherCondition = data['list'][0]['weather'][0]['main'];
          String iconCode = data['list'][0]['weather'][0]['icon'];
          final iconUrl =
              'https://openweathermap.org/img/wn/$iconCode@2x.png'; // here i put icon code in url

          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: BackdropFilter(
                        //backgrop use to add blur and clipRReact use to elevate it
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 5),

                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemperature.toStringAsFixed(2)}° C ',
                                // ${temp.toStringAsFixed(2)}° C
                                // toStringAsFixed(2) use to print jsut 2 value of floating point
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Image.network(iconUrl),
                              const SizedBox(height: 3),

                              Text(
                                currentWeatherCondition, // string here
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // use to add some space
                const Text(
                  // we also use align widget use to algin it like left  , right  , we also use contanier
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16), // use to add some space
                // SingleChildScrollView(
                //   scrollDirection:
                //       Axis.horizontal, // by default SingleChildScrollView widget scroll vertically
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 10; i++) ...[
                // weather_card(
                //   time: data['list'][i]['dt_txt'].split(" ")[1],
                //   temprature: ((data['list'][i]['main']['temp']) -
                //           273.15)
                //       .toStringAsFixed(2),
                //   url:
                //       'https://openweathermap.org/img/wn/${data['list'][i]['weather'][0]['icon']}@2x.png',
                // ),
                //       ],
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final time = DateTime.parse(
                        data['list'][index]['dt_txt'],
                      );
                      return weather_card(
                        time: DateFormat.j().format(time),
                        temprature: ((data['list'][index]['main']['temp']) -
                                273.15)
                            .toStringAsFixed(2),
                        url:
                            'https://openweathermap.org/img/wn/${data['list'][index]['weather'][0]['icon']}@2x.png',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // use to add some space
                const Text(
                  // we also use align widget use to algin it like left  , right  , we also use contanier
                  "Additional Information",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(height: 16), // use to add some space

                    additional_information(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: "$humidity",
                    ),
                    additional_information(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: "$windSpeed",
                    ),

                    additional_information(
                      icon: Icons.speed,
                      label: "Pressure",
                      value: "$pressure",
                    ),

                    // const SizedBox(height: 16), // use to add some space
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
