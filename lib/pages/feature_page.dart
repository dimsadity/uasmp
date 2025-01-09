import 'package:flutter/material.dart';
import 'geolocation_page.dart'; // Pastikan impor halaman GeolocationPage

class FeaturePage extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.notifications,
      'title': 'Push Notifications',
      'description': 'Receive updates in real-time.',
      'onTap': null // Tidak ada aksi untuk item ini
    },
    {
      'icon': Icons.location_on,
      'title': 'Geolocation',
      'description': 'Track your location seamlessly.',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeolocationPage()),
        );
      }
    },
    {
      'icon': Icons.analytics,
      'title': 'Analytics',
      'description': 'Monitor your activity easily.',
      'onTap': null // Tidak ada aksi untuk item ini
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Features'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Icon(feature['icon'], color: Colors.deepPurple),
                ),
                title: Text(
                  feature['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(feature['description']),
                onTap: feature['onTap'] != null
                    ? () => feature['onTap'](context) // Navigasi ke halaman
                    : null, // Tidak ada aksi jika `onTap` null
              ),
            );
          },
        ),
      ),
    );
  }
}
