import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/views/homepage_view.dart';
import 'package:meetingreminder/app/routes/app_pages.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(
    GetMaterialApp(
      // home: const MyHomePage(title: 'Meeting Schedul initialBinding: InitialBinding(),er'),
      home: const HomePageView(),
      initialRoute: AppPages.INITIAL, // Ensure it points to '/homepage'
      getPages: AppPages.routes, 
    ),
  );
}
