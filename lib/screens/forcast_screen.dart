import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/weather_services.dart';

class ForecastScreen extends StatefulWidget {
  final String city;
  const ForecastScreen({required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  List<dynamic>? _forecast;

  @override
  void initState() {
    super.initState();
    _fetchForecast();
  }

  Future<void> _fetchForecast() async {
    try {
      final forecastData = await _weatherService.fetch7DayForecast(widget.city);
      setState(() {
        _forecast = forecastData['forecast']['forecastday'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _forecast == null
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFF1A2344),
                    Color.fromARGB(255, 125, 32, 142),
                    Colors.purple,
                    Color.fromARGB(255, 151, 44, 170),
                  ])),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFF1A2344),
                    Color.fromARGB(255, 125, 32, 142),
                    Colors.purple,
                    Color.fromARGB(255, 151, 44, 170),
                  ])),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "7 Days Forecast",
                            style: GoogleFonts.lato(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _forecast!.length,
                      itemBuilder: (context, index) {
                        final day = _forecast![index];
                        String iconUrl =
                            'http:${day['day']['condition']['icon']}';
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                height: 112,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: AlignmentDirectional.topStart,
                                      end: AlignmentDirectional.bottomEnd,
                                      colors: [
                                        Color(0xFF1A2344).withOpacity(0.5),
                                        Color(0xFF1A2344).withOpacity(0.2),
                                      ]),
                                ),
                                child: ListTile(
                                  leading: Image.network(iconUrl),
                                  title: Text(
                                    '${day['date']} ${day['day']['avgtemp_c'].round()}°C',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                      day['day']['condition']['text'],
                                      style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: Colors.white70
                                      ),
                                  ),
                                  trailing: Text(
                                    'Max: ${day['day']['maxtemp_c']}°C\n'
                                        'Min: ${day['day']['mintemp_c']}°C',
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    ));
  }
}
