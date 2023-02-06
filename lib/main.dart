import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:parkezy/login.dart';
import 'package:parkezy/lots.dart';
import 'package:parkezy/parking.dart';
import 'package:parkezy/spots.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parkezy',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/login':(context) => const Login(),
        '/lots': (context) => const Lots(),
        '/parking': (context) => const Parking(),
        '/spots': (context) => const Spots(),
      },
      theme: ThemeData(
        cardTheme: CardTheme(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final parkings = [
  "Parking One, GHFF+RP2, NH 91, Greater Noida, Uttar Pradesh 203207",
  "Parking 2, Shiv Nadar University, Grande Noida, Dadri, Uttar Pradesh"
  // "https://www.google.co.in/maps/place/Parking+One/@28.5252819,77.573448,17.76z/data=!4m12!1m6!3m5!1s0x390ceb4eaaaaaaab:0x321412756718874c!2sShiv+Nadar+University!8m2!3d28.5267298!4d77.575363!3m4!1s0x390c94d9f0d15827:0xdcf98ff998034426!8m2!3d28.5245085!4d77.5742751",
  // "https://www.google.co.in/maps/place/Parking+2/@28.5257937,77.5737519,17.76z/data=!4m12!1m6!3m5!1s0x390ceb4eaaaaaaab:0x321412756718874c!2sShiv+Nadar+University!8m2!3d28.5267298!4d77.575363!3m4!1s0x390c95b1b47102cb:0x678ce2039d824146!8m2!3d28.52728!4d77.577825"
];

final locations = [
  ["Library", parkings[0]],
  ["A Block", parkings[1]],
  ["B Block", parkings[1]],
  ["C Block", parkings[0]],
  ["D Block", parkings[0]],
  ["G Block", parkings[0]],
  ["ISC", parkings[0]],
  ["Towers", parkings[1]],
  ["Cluster 1", parkings[0]],
  ["Cluster 2", parkings[0]],
  ["Cluster 3", parkings[0]],
  ["Cluster 4", parkings[0]],
  ["Cluster 5", parkings[0]],
];

class _MyHomePageState extends State<MyHomePage> { 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xffEBEFF2),
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "SHIV NADAR IOE",
                        style: TextStyle(
                          color: Colors.blue[300],
                        ),
                      ),
                      const Text(
                        "X",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "PARKEZY",
                        style: TextStyle(
                          color: Colors.purple[400],
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: locations.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () async {
                          MapsLauncher.launchQuery(locations[index][1]);
                        },
                        child: Card(
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Center(
                              child: Text(
                                locations[index][0],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "Admin login",
                    style: TextStyle(
                      color: Colors.purple[400],
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
