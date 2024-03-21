// //AAAAnpE9UGw:APA91bFyyIXV-TqFIvy-Xe3nUbB3nCHQ5S1z9c6AUiNFVMtBEGYxhII6o0ElLV_u_Y8T-ldQEPKsRFNxzB_XHZSpepkKIA25lj1fkW_Rq62ZmyQEgZEp8QSP3sn4GoF3qyb77fmNhotc
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseMessagingService {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   Future<String> getDeviceToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   void configureFirebaseMessaging() {
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         // Handle foreground messages
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         // Handle when app is terminated and user taps on notification
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         // Handle when app is in background and user taps on notification
//       },
//     );
//   }

//   Future<void> sendNotificationToDevice(String deviceToken, String title, String body) async {
//     await _firebaseMessaging
//         .send(
//           RemoteMessage(
//             data: {
//               'title': title,
//               'body': body,
//             },
//             to: deviceToken,
//           ),
//         )
//         .then((value) => print("Notification sent successfully"))
//         .catchError((error) => print("Error sending notification: $error"));
//   }
// }

// void main() {
//   FirebaseMessagingService messagingService = FirebaseMessagingService();
//   messagingService.configureFirebaseMessaging();

//   // Get device token
//   messagingService.getDeviceToken().then((token) {
//     print("Device Token: $token");
//     // Now you can use this token to send notifications to this device
//     // e.g., messagingService.sendNotificationToDevice(token, "Hello", "This is a test notification");
//   });
// }
