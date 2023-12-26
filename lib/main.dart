// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sqllite_project/sql.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final sqllite _db = sqllite();

  List<Map> works = [];
  TextEditingController title_con = TextEditingController();
  TextEditingController description_con = TextEditingController();
  Future readData() async {
    var response = await _db.Selecttable('SELECT * FROM `works`');
    works = response;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    readData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text(
          'Works',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: const Color.fromARGB(0, 33, 149, 243),
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  height: 270,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        maxLength: 30,
                        controller: title_con,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter The Task Title',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        maxLength: 40,
                        controller: description_con,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          hintText: 'Enter The Task Description',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: TextButton(
                          style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            await _db.Inserttable(
                                'INSERT INTO works (`title`,`description`,`ischecked`) VALUES ("${title_con.text}","${description_con.text}","false")');

                            title_con.clear();
                            description_con.clear();
                            setState(() {
                              readData();
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Add Task',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
            decelerationRate: ScrollDecelerationRate.normal),
        itemCount: works.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Are You Sure To Delete This Task',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              '${works[index]['title']}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Back',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      await _db.DeleteRawtable(
                                          'DELETE FROM works WHERE id ="${works[index]['id']}"');
                                      setState(() {
                                        readData();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: ListTile(
              title: Text(
                "${works[index]['title']}",
                style: TextStyle(
                    decoration: works[index]['ischecked'] == 'true'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              subtitle: Text(
                "${works[index]['description']}",
                style: TextStyle(
                    decoration: works[index]['ischecked'] == 'true'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              trailing: Checkbox(
                value: works[index]['ischecked'] == 'false' ? false : true,
                onChanged: (v) async {
                  await _db.UpdateRawTable(
                      'UPDATE works SET ischecked ="$v" WHERE id="${works[index]['id']}"');
                  setState(() {
                    readData();
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
