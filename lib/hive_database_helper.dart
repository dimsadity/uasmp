import 'package:hive/hive.dart';

class HiveDatabaseHelper {
  static final String boxName = 'dataBox';

  static Future<void> addData(String title, String description) async {
    final box = await Hive.openBox(boxName);
    await box.add({'title': title, 'description': description});
    print('Data added: {title: $title, description: $description}');
  }

  static Future<List<Map<String, dynamic>>> getDataList() async {
    final box = await Hive.openBox(boxName);
    return box.keys.map((key) {
      final value = box.get(key);
      return {'id': key, 'title': value['title'], 'description': value['description']};
    }).toList();
  }

  static Future<void> updateData(int id, String title, String description) async {
    final box = await Hive.openBox(boxName);
    await box.put(id, {'title': title, 'description': description});
    print('Data updated: {id: $id, title: $title, description: $description}');
  }

  static Future<void> deleteData(int id) async {
    final box = await Hive.openBox(boxName);
    await box.delete(id);
    print('Data deleted: $id');
  }
}
