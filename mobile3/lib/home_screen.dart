

import 'package:flutter/material.dart';
import 'package:mobile3/db_helper.dart';

class HomeScreen extends StatefulWidget{

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  void _refreshData() async{
    final data = await SQlHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    }); 
  }

  @override
  void initState(){
    super.initState();
    _refreshData();
  }
  

  // Future<void> _addData() async{
  //   await SQlHelper.createData(_nameController.text, _styleController.text, _seasonController.text);
  //   _refreshData();
  // }
  Future<void> _addData() async {
  try {
    print("Adding Data...");
    await SQlHelper.createData(_nameController.text, _styleController.text, _seasonController.text);
    print("Data Added!");
    _refreshData();
  } catch (e) {
    print("Error adding data: $e");
  }
}


  Future<void> _updateData(int id) async{
    await SQlHelper.updateData(id, _nameController.text, _styleController.text, _seasonController.text);
    _refreshData();
  }

  Future<void> _deleteData(int id) async{
    await SQlHelper.updateData(id, _nameController.text, _styleController.text, _seasonController.text);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data DELETED"),
    ));
    _refreshData();
  }
  final TextEditingController _nameController= TextEditingController();
  final TextEditingController _styleController= TextEditingController();
  final TextEditingController _seasonController= TextEditingController();

 void showBottomSheet(int? id) async{
  if(id!=null){
    final existingData = _allData.firstWhere((element) => element['id']==id);
    _nameController.text = existingData['name'];
    _styleController.text = existingData['style'];
    _seasonController.text = existingData['season'];
  }
  showModalBottomSheet(
    elevation: 5,
    isScrollControlled: true,
    context: context, 
    builder: (_) => Container(
      padding: EdgeInsets.only(
        top:30,
        left: 15,
        right: 15, 
        bottom: MediaQuery.of(context).viewInsets.bottom + 50,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Name"
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _styleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Style"
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _seasonController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Season"
            ),
          ),
          SizedBox(height: 10),
          Center(
            child:ElevatedButton(
              onPressed: () async{
                if(id==null){
                  await _addData();
                }
                if (id !=null){
                  await _updateData(id);
                }

                _nameController.text = "";
                _styleController.text = "";
                _seasonController.text = "";

                Navigator.of(context).pop();
                print("Data Added");
              },
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(id==null ? "Add Data" : "Update",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
 }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFECEAF4),
      appBar: AppBar(
        title: Text("CRUD operations"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):ListView.builder(
        itemCount: _allData.length,
        itemBuilder: (context, index)=> Card(
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Padding(padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(_allData[index]['name'],
            style: TextStyle(fontSize: 20,
            ),
            ),
            ),
            //subtitle: Text(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: Icon(Icons.add),
        ),
    );
  }
}