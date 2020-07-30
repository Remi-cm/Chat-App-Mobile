import 'package:customerchat/helpers/constants.dart';
import 'package:customerchat/services/database.dart';
import 'package:customerchat/services/localStorage.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {

  final Map chatRoom;

  const Conversation({Key key, this.chatRoom}) : super(key: key);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController _textFieldController = new TextEditingController();

  String replierName = "Yoo";

  Stream chatMessageStream;

  Widget chatMsgList(){
    return StreamBuilder(
      stream: chatMessageStream, 
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageBox(
              message: snapshot.data.documents[index].data["message"],
              messageIsLocal: snapshot.data.documents[index].data["sentBy"] == Constants.localName,
            );
          }
        ) : Center(child: CircularProgressIndicator());
      },
    );
  }

  getReplierName(){
    print("ooooooooooooooooooooooooooooooook");
    databaseMethods.getChatRoomById(widget.chatRoom["chatRoomId"]).then((val){
      print(val.documents[0].data["users"].toString());
      setState(() {
        replierName = val.documents[0].data["users"].toString();
      });
    });
  }

  sendMessage(){
    if (_textFieldController.text.isNotEmpty) {
      print("msg: ${_textFieldController.text}\nauthor: ${Constants.localName}\nchatid: ${widget.chatRoom["chatRoomId"]}\n");
      String message = _textFieldController.text;

        Map<String, dynamic> msgMap = {
        "message": message,
        "sentBy": Constants.localName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "date": DateTime.now()
      }; 

      databaseMethods.addMessage(widget.chatRoom["chatRoomId"], msgMap);

      _textFieldController.text = "";
    }
    else{
      print("weeeeee");
    }
    
  }

  @override
  void initState() {
    databaseMethods.getMessages(widget.chatRoom["chatRoomId"]).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    getReplierName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey,),
          ),
          onTap: (){Navigator.pop(context);},
          borderRadius: BorderRadius.circular(50),),
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: Text("${widget.chatRoom["replierName"].substring(0,1).toUpperCase()}", style: TextStyle(color: Colors.white)), 
                  backgroundColor: Colors.black54,
                ), SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.chatRoom["replierName"]}", style: TextStyle(color: Colors.black54),),
                    SizedBox(height: 1),
                    Text("Online", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w400),),
                  ],
                ),
              ],
            ),
            IconButton(icon: Icon(Icons.settings, color: Colors.black54), onPressed: (){})
          ],
        )
        ),
      body: Stack(children: <Widget>[
        chatMsgList(),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(5),
            color: Color(0xfff2f2f2),
            //decoration: BoxDecoration(border: ),
            child: Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textFieldController,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.camera_alt, color: Colors.black45,),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "Message...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(bottom: 12, left: 15),
                    ),
                  ),
                ),
              ),
              InkWell(child: Container(
                margin: EdgeInsets.all(7),
                padding: EdgeInsets.all(13),
                child: Icon(Icons.send, size: 20, color: Colors.white,),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    /*const Color(0xff007ef4),
                    const Color(0xff2a75bc)*/
                    const Color(0xff47945f),
                    const Color(0xff5cb878)
                  ]),
                ),
                ),
                onTap: sendMessage,
                borderRadius: BorderRadius.circular(50),
              ),
            ],)
          ),
        )
      ],),
    );
  }
}

class MessageBox extends StatelessWidget {

  final String message;
  final bool messageIsLocal;

  const MessageBox({Key key, this.message, this.messageIsLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left : messageIsLocal ? 0: 24, right: messageIsLocal ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 2),
      width: MediaQuery.of(context).size.width,
      alignment: messageIsLocal ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 200),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: messageIsLocal ? [
            const Color(0xfffafffa),
            const Color(0xfffafffb)
            
          ]
          : [
            const Color(0xff47945f),
            const Color(0xff5cb878)
          ]),
          borderRadius: messageIsLocal ? BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            //bottomRight: Radius.circular(10)
          ) :
          BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            //bottomLeft: Radius.circular(10),
          )
        ),
        child: Text(message, style: TextStyle(color: !messageIsLocal ? Colors.white : Colors.black54, fontSize: 17, fontWeight: FontWeight.w600),),
      ),
    );
  }
}