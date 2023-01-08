import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkezy/login.dart';
import 'package:parkezy/lots.dart';
import 'package:parkezy/parking.dart';
import 'package:parkezy/spots.dart';

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
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        
                      },
                      child: const Card(
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Center(
                            child: Text(
                              "Acad blocks",
                              // snapshot.data!.docs[index].id,
                              style: TextStyle(
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
    );
  }
}
