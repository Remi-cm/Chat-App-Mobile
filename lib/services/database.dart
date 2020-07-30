
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByUsername(String username) async {
    return await Firestore.instance.collection("Users")
    .where("username", isEqualTo: username)
    .getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance.collection("Users")
    .where("email", isEqualTo: email)
    .getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("Users")
    .add(userMap).catchError((e){
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("Chatroom")
      .document(chatRoomId).setData(chatRoomMap).catchError((e){
        print(e.toString());
      });
  }

  getChatRoomById(String chatRoomId) async {
    return await Firestore.instance.collection("Chatroom")
    .where("chatroomId", isEqualTo: chatRoomId)
    .getDocuments();
  }

  addMessage(String chatRoomId, Map msgMap){
    Firestore.instance.collection("Chatroom")
    .document(chatRoomId).collection("chats")
    .add(msgMap)
    .catchError((e){print(e.toString());});

  }

  getMessages(String chatRoomId) async {
    return await Firestore.instance.collection("Chatroom")
    .document(chatRoomId).collection("chats")
    .orderBy("date")
    .snapshots();

  }

  getChatRooms(String username) async {
    return Firestore.instance.collection("Chatroom")
    .where("users", arrayContains: username)
    .snapshots();
  }

}