import 'package:flutter/material.dart';
import 'package:flutter_crud_using_sqflite/adduser.dart';

import 'sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    _refreshJournals();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter CRUD using sqflite'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _journals.isEmpty
              ? const Center(
                  child: Text(
                  "No Data Found",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ))
              : ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 2,
                        color: Colors.white,
                        margin: const EdgeInsets.all(15),
                        child: Container(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: ((context) =>
                                                      Adduser(
                                                          id: _journals[index]
                                                              ['id'])))),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _deleteItem(
                                              _journals[index]['id']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Text(
                                        _journals[index]['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Text(
                                        _journals[index]['mobile'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 49, 48, 48)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            _journals[index]['address'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 49, 48, 48)),
                                          ),
                                          Text(
                                            _journals[index]['landmark'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 49, 48, 48)),
                                          ),
                                          Text(
                                            " - " + _journals[index]['pincode'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 49, 48, 48)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                        // ListTile(

                        //     title: Text(_journals[index]['name']),
                        //     subtitle: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(_journals[index]['mobile']),
                        //         Text(_journals[index]['address']),
                        //       ],
                        //     ),
                        //     trailing: SizedBox(
                        //       width: 100,
                        //       child: Row(
                        //         children: [
                        //           IconButton(
                        //             icon: const Icon(Icons.edit),
                        //             onPressed: () => Navigator.of(context).push(
                        //                 MaterialPageRoute(
                        //                     builder: ((context) => Adduser(
                        //                         id: _journals[index]['id'])))),
                        //           ),
                        //           IconButton(
                        //             icon: const Icon(Icons.delete),
                        //             onPressed: () =>
                        //                 _deleteItem(_journals[index]['id']),
                        //           ),
                        //         ],
                        //       ),
                        //     )),
                        );
                  }),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.add),
          // onPressed: () => _showForm(null),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => Adduser(
                    id: null,
                  ))))),
    );
  }
}
