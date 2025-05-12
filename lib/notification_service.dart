import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications(Function(String? payload) onNotificationTap) async {
  print('🛠 通知初期化開始');

  final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final ios = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
  );

  final settings = InitializationSettings(android: android, iOS: ios);

  await notificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      final payload = details.payload;
      print('🔔 通知がタップされた: $payload');
      onNotificationTap(payload);
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground, // ✅ 追加（iOSバックグラウンド対策）
  );

  tz.initializeTimeZones();

  print('✅ 通知初期化完了');
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
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  print('📡 [BG] 通知タップ（バックグラウンド）: ${details.payload}');
}