import 'package:flutter/material.dart';

class ParentChatScreen extends StatefulWidget {
  @override
  _ParentChatScreenState createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> messages = [
    ChatMessage(
      isFromAI: true,
      content:
          "Your child had dinner alone today.\nHere's how you can gently connect:\n1. plan breakfast together\n2. plan a weekend cooking session\n3. surprise him in the morning with gifts",
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
    ),
    ChatMessage(
      isFromAI: false,
      content: "Im travelling tomorrow too.I wont be home this weekend...",
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    ChatMessage(
      isFromAI: true,
      content:
          "That's okay. Here's how you can still bond:\n1. make toast together on the phone.\n2. schedule a \"dinner message\" every night that auto-plays.\n3. Send a \"countdown\" to together time.",
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          isFromAI: false,
          content: _messageController.text,
          timestamp: DateTime.now(),
        ));
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "AI Parenting Assistant",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Message...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF6B73FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final bool isFromAI;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.isFromAI,
    required this.content,
    required this.timestamp,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isFromAI) ...[
            _buildAvatar(true),
            SizedBox(width: 8),
            Expanded(child: _buildMessageBubble(context)),
          ] else ...[
            Expanded(child: _buildMessageBubble(context)),
            SizedBox(width: 8),
            _buildAvatar(false),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isAI) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isAI ? Color(0xFF6B73FF) : Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          isAI ? "A" : "P",
          style: TextStyle(
            color: isAI ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Column(
        crossAxisAlignment: message.isFromAI
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isFromAI ? Colors.white : Color(0xFFE3F2FD),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft:
                    message.isFromAI ? Radius.circular(4) : Radius.circular(16),
                bottomRight:
                    message.isFromAI ? Radius.circular(16) : Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return "${time.day}/${time.month}";
    }
  }
}
