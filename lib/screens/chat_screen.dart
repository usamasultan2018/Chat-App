import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utility/const.dart';
User? loggedIn;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  var messageController = TextEditingController();

  void getCurrentUser() {
    var user = _auth.currentUser;
    if (user != null) {
      loggedIn = user;
      print(user.email);
    } else {
      print('Something error');
    }
  }

  var list = [];

  // void getSms() async {
  //   // we goto firestore to collect data from messsages and then we use stream tc  collect
  //   await for (var snapshot in fireStore.collection('messages').snapshots()) {
  //
  //     for (var allSms in snapshot.docs) {
  //       print(allSms.data());
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
               _auth.signOut();
               Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: fireStore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    var message = snapshot.data!.docs;
                    List<MessageBubble> messagesWidgets = [];
                    for (var allMessage in message) {
                      final data = allMessage.data() as Map;
                      final textMessage = data['text'];
                      final sender = data['sender'];
                      final messageTime = data['time'] ; //add this
                      final currentUser = loggedIn!.email;

                      final msgBubble =
                      MessageBubble(
                        text: textMessage,
                        sender: sender,
                        isMe: currentUser == sender,
                        time: messageTime,
                      );

                      messagesWidgets.add(msgBubble);
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          reverse: true,
                          children: messagesWidgets,
                        ),
                      ),
                    );
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {

                      //Implement send functionality.
                      if(messageController.text.isEmpty){
                         return ;
                      }
                      fireStore.collection('messages').add({
                        'text': messageController.text,
                        'sender': loggedIn!.email,
                        'time':DateTime.now().millisecondsSinceEpoch,
                      });
                      messageController.clear();
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final  dynamic time;
  const MessageBubble({Key? key, required this.text, required this.sender,required this.isMe,required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            ' $sender ',// add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thing
            style:  TextStyle(color: isMe?Colors.white70:Colors.white, fontSize: 12),
          ),
          Material(
              borderRadius:isMe? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ):
              const BorderRadius.only(
              topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
               bottomRight: Radius.circular(30),
    ),
              elevation: 5,
              color: isMe ?Colors.blueAccent:Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                child: Text(
                  text,
                  style:  TextStyle(fontSize: 15, color:isMe ?Colors.white:Colors.black),
                ),

              )
          ),
          Text(
            ' ${getHumanReadableDate(time)} ',// add this only if you want to show the time along with the email. If you dont want this then don't add this DateTime thing
            style:  TextStyle(color: isMe?Colors.white70:Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('hh-mm').format(dateTime);
  }
}
