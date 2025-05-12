import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications(Function(String?) onNotificationTap) async {
  print('通知初期化中...');
  final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final ios = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  final settings = InitializationSettings(android: android, iOS: ios);

  await notificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (details) {
      print('🔔 通知がタップされた: ${details.payload}');
      onNotificationTap(details.payload);
    },
  );

  tz.initializeTimeZones();
}

// Future<void> scheduleCallNotification() async {
//   final scheduledTime = tz.TZDateTime.local(
//     DateTime.now().year,
//     DateTime.now().month,
//     DateTime.now().day,
//     10, 0,
//   );

//   await notificationsPlugin.zonedSchedule(
//     0,
//     '着信',
//     '通話がかかってきました',
//     scheduledTime,
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'call_channel',
//         'Call',
//         importance: Importance.max,
//         priority: Priority.high,
//         fullScreenIntent: true,
//       ),
//     ),
//     androidAllowWhileIdle: true,
//     payload: '/incoming',
//     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//   );
// }
Future<void> scheduleCallNotification() async {
  final locationTokyo = tz.getLocation('Asia/Tokyo');
  final now = tz.TZDateTime.now(locationTokyo);
  final scheduledTime = now.add(const Duration(seconds: 15));
  final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  print('📅 通知を ${formatter.format(scheduledTime)} にスケジュールします');

  
  await notificationsPlugin.zonedSchedule(
    0,
    '着信',
    '通話がかかってきました',
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'call_channel',
        'Call',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
      ),
      iOS: DarwinNotificationDetails(
      ),
    ),
    androidAllowWhileIdle: true,
    payload: '/incoming',
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}