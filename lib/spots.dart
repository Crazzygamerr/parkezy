import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Spots extends StatefulWidget {
  const Spots({Key? key}) : super(key: key);

  @override
  State<Spots> createState() => _SpotsState();
}

class _SpotsState extends State<Spots> {
  
  var db = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? stream;
  bool isHistory = false;
  String parking = "";
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      parking = args["parking"] ?? "";
      isHistory = args["history"] ?? false;
      setState(() {
        stream = db.collection('lots')
          .doc(parking)
          .collection(isHistory ? 'history' : 'spots')
          .snapshots();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Text(
              "$parking: ${isHistory ? "History" : "Spots"}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No data",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return Card(
                        child: ListTile(
                          title: Text(doc['reg']),
                          subtitle: Text(doc['model']),
                          trailing: isHistory 
                            ? Text(doc['time']) 
                            : IconButton(
                              onPressed: () {
                                db.collection('lots')
                                  .doc(parking)
                                  .collection('spots')
                                  .doc(doc.id)
                                  .delete();
                                  
                                db.collection('lots')
                                  .doc(parking)
                                  .collection('history')
                                  .add({
                                    'reg': doc['reg'],
                                    'model': doc['model'],
                                    'time': DateTime.now().toString(),
                                });
                              },
                              icon: const Icon(Icons.exit_to_app),
                            ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}