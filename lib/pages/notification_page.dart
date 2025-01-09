import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {'title': 'Update Available', 'description': 'A new version of the app is available.', 'time': '5 mins ago'},
    {'title': 'System Maintenance', 'description': 'Scheduled maintenance at 2 AM.', 'time': '2 hours ago'},
    {'title': 'Welcome!', 'description': 'Thank you for joining our app.', 'time': '1 day ago'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Icon(Icons.notifications, color: Colors.deepPurple),
                ),
                title: Text(
                  notification['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification['description']),
                    SizedBox(height: 4),
                    Text(
                      notification['time'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
