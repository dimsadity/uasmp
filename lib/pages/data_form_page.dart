import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../database_helper_crud.dart';

class DataFormPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  DataFormPage({this.data});

  @override
  _DataFormPageState createState() => _DataFormPageState();
}

class _DataFormPageState extends State<DataFormPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String location = 'Location not set';
  double? latitude;
  double? longitude;

  final CrudDatabaseHelper dbHelper = CrudDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      titleController.text = widget.data!['title'];
      descriptionController.text = widget.data!['description'];
      latitude = widget.data!['latitude'];
      longitude = widget.data!['longitude'];
      location = 'Lat: $latitude, Long: $longitude';
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Periksa apakah layanan lokasi diaktifkan
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          location = 'Location services are disabled. Please enable them in browser settings.';
        });
        return;
      }

      // Periksa izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            location = 'Location permissions are denied. Please allow location access.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          location = 'Location permissions are permanently denied. Update browser or system settings.';
        });
        return;
      }

      // Dapatkan lokasi saat ini
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
        location = 'Lat: ${currentPosition.latitude}, Long: ${currentPosition.longitude}';
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        location = 'Failed to get location. Error: $e';
      });
    }
  }

  void _saveData() async {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location is required.')),
      );
      return;
    }

    try {
      if (widget.data == null) {
        // Tambahkan data baru
        await dbHelper.addData(
          title,
          description,
          latitude!,
          longitude!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data added successfully')),
        );
      } else {
        // Update data
        await dbHelper.updateData(
          widget.data!['id'],
          title,
          description,
          latitude!,
          longitude!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data updated successfully')),
        );
      }
      Navigator.pop(context); // Kembali ke halaman Data List
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data == null ? 'Add Data' : 'Edit Data'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.location_on, color: Colors.deepPurple),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.data == null ? 'Save' : 'Update',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
