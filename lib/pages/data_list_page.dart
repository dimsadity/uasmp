import 'package:flutter/material.dart';
import '../database_helper_crud.dart';
import 'data_form_page.dart';

class DataListPage extends StatefulWidget {
  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  List<Map<String, dynamic>> dataList = [];

  final CrudDatabaseHelper dbHelper = CrudDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _fetchDataList();
  }

  void _fetchDataList() async {
    final data = await dbHelper.getDataList();
    setState(() {
      dataList = data;
    });
  }

  void _deleteData(int id) async {
    await dbHelper.deleteData(id);
    _fetchDataList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data deleted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data List'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: dataList.isEmpty
          ? Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final item = dataList[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      item['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['description']),
                        Text(
                          'Lat: ${item['latitude']}, Long: ${item['longitude']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DataFormPage(data: item),
                              ),
                            ).then((_) => _fetchDataList());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteData(item['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataFormPage(data: null)),
          ).then((_) => _fetchDataList());
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
