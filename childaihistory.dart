import 'package:flutter/material.dart';

class ChildChatScreen extends StatefulWidget {
  @override
  _ChildChatScreenState createState() => _ChildChatScreenState();
}

class _ChildChatScreenState extends State<ChildChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChildChatMessage> _messages = [
    ChildChatMessage(
      isUser: false,
      message: "Hi there\nHow are you feeling today ?",
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      emotion: 'greeting',
    ),
    ChildChatMessage(
      isUser: true,
      message: "I feel sad today",
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      emotion: 'sad',
    ),
    ChildChatMessage(
      isUser: false,
      message: "It's okay to feel sad.\nI'm here with you",
      timestamp: DateTime.now(),
      emotion: 'supportive',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.purple[400],
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'My Emotion Friend',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mood Status Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[100]!, Colors.purple[50]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_emotions, color: Colors.purple[600], size: 20),
                SizedBox(width: 8),
                Text(
                  'Today\'s Mood Tracker',
                  style: TextStyle(
                    color: Colors.purple[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                _buildMoodIndicator('😊', false),
                SizedBox(width: 4),
                _buildMoodIndicator('😢', true), // Current mood
                SizedBox(width: 4),
                _buildMoodIndicator('😡', false),
                SizedBox(width: 4),
                _buildMoodIndicator('😰', false),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: ChildChatBubble(
                    isUser: message.isUser,
                    message: message.message,
                    timestamp: message.timestamp,
                    emotion: message.emotion,
                  ),
                );
              },
            ),
          ),

          // Parent Message Notification (when parent responds)
          if (_shouldShowParentMessage())
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.pink[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.pink[400], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Mommy/Daddy sent you a hug! 🤗',
                    style: TextStyle(
                      color: Colors.pink[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () => _showParentMessage(),
                    child: Text('View'),
                  ),
                ],
              ),
            ),

          // Input Area
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Emotion Quick Buttons
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildEmotionButton('😊', 'Happy', Colors.yellow),
                      SizedBox(width: 8),
                      _buildEmotionButton('😢', 'Sad', Colors.blue),
                      SizedBox(width: 8),
                      _buildEmotionButton('😡', 'Angry', Colors.red),
                      SizedBox(width: 8),
                      _buildEmotionButton('😰', 'Worried', Colors.orange),
                      SizedBox(width: 8),
                      _buildEmotionButton('😴', 'Tired', Colors.purple),
                      SizedBox(width: 8),
                      _buildEmotionButton('🤗', 'Need Hug', Colors.pink),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Message Input
                Row(
                  children: [
                    // Voice Input Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple[100],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.mic,
                            color: Colors.purple[600], size: 20),
                        onPressed: () => _startVoiceInput(),
                      ),
                    ),
                    SizedBox(width: 8),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Tell me how you feel...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),

                    // Send Button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple[400],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white, size: 18),
                        onPressed: () => _sendMessage(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIndicator(String emoji, bool isActive) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple[200] : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildEmotionButton(String emoji, String label, Color color) {
    return InkWell(
      onTap: () => _sendEmotionMessage(emoji, label),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(ChildChatMessage(
          isUser: true,
          message: _messageController.text,
          timestamp: DateTime.now(),
          emotion: _detectEmotion(_messageController.text),
        ));
      });

      String userMessage = _messageController.text;
      _messageController.clear();

      // Simulate AI response
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add(ChildChatMessage(
            isUser: false,
            message: _generateAIResponse(userMessage),
            timestamp: DateTime.now(),
            emotion: 'supportive',
          ));
        });
      });
    }
  }

  void _sendEmotionMessage(String emoji, String emotion) {
    setState(() {
      _messages.add(ChildChatMessage(
        isUser: true,
        message: "I feel $emotion $emoji",
        timestamp: DateTime.now(),
        emotion: emotion.toLowerCase(),
      ));
    });

    // Simulate AI response
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChildChatMessage(
          isUser: false,
          message: _generateEmotionResponse(emotion),
          timestamp: DateTime.now(),
          emotion: 'supportive',
        ));
      });
    });
  }

  String _generateAIResponse(String userMessage) {
    if (userMessage.toLowerCase().contains('sad')) {
      return "I understand you're feeling sad. Would you like to talk about what's making you feel this way? I'm here to listen. 💙";
    } else if (userMessage.toLowerCase().contains('happy')) {
      return "That's wonderful! I'm so glad you're feeling happy today. What made you smile? 😊";
    } else if (userMessage.toLowerCase().contains('angry')) {
      return "It's okay to feel angry sometimes. Let's take a deep breath together. Can you tell me what happened? 🫂";
    } else {
      return "Thank you for sharing your feelings with me. You're very brave for talking about how you feel. 🌟";
    }
  }

  String _generateEmotionResponse(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return "Yay! I'm so happy that you're happy! Let's celebrate together! 🎉";
      case 'sad':
        return "It's okay to feel sad sometimes. I'm here with you. Would you like a virtual hug? 🤗";
      case 'angry':
        return "When we feel angry, it helps to count to 10. Let's try it together: 1... 2... 3... 🌈";
      case 'worried':
        return "I understand you're worried. Remember, you're safe and loved. Let's think of happy things together. 🌟";
      case 'tired':
        return "Rest is important! Maybe it's time for a cozy break? I'll be here when you're ready. 😴";
      case 'need hug':
        return "Sending you the biggest, warmest hug! 🤗💕 You are loved and special!";
      default:
        return "Thank you for sharing your feelings with me. You're so brave! 🌟";
    }
  }

  String _detectEmotion(String message) {
    String lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('sad') || lowerMessage.contains('cry'))
      return 'sad';
    if (lowerMessage.contains('happy') || lowerMessage.contains('good'))
      return 'happy';
    if (lowerMessage.contains('angry') || lowerMessage.contains('mad'))
      return 'angry';
    if (lowerMessage.contains('worried') || lowerMessage.contains('scared'))
      return 'worried';
    return 'neutral';
  }

  void _startVoiceInput() {
    // Simulate voice input
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎤 Listening... Speak now!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.purple[400],
      ),
    );
  }

  bool _shouldShowParentMessage() {
    // Simulate parent response availability
    return _messages.length >= 2;
  }

  void _showParentMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.pink[400]),
            SizedBox(width: 8),
            Text('Message from Mommy/Daddy'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'I love you so much! Even when I\'m not home, I\'m always thinking about you. 💕'),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.play_arrow),
              label: Text('Play Voice Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How to use'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Tap the emotion buttons to share how you feel'),
            Text('• Use the microphone to speak your feelings'),
            Text('• Type messages to tell me about your day'),
            Text('• I\'ll always listen and help you feel better'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Got it!'),
          ),
        ],
      ),
    );
  }
}

class ChildChatMessage {
  final bool isUser;
  final String message;
  final DateTime timestamp;
  final String emotion;

  ChildChatMessage({
    required this.isUser,
    required this.message,
    required this.timestamp,
    required this.emotion,
  });
}

class ChildChatBubble extends StatelessWidget {
  final bool isUser;
  final String message;
  final DateTime timestamp;
  final String emotion;

  const ChildChatBubble({
    Key? key,
    required this.isUser,
    required this.message,
    required this.timestamp,
    required this.emotion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[300]!, Colors.purple[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? Colors.purple[100] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isUser ? Colors.purple[200]! : Colors.grey[300]!,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                  if (emotion != 'neutral' && emotion != 'supportive') ...[
                    SizedBox(width: 4),
                    Text(
                      _getEmotionEmoji(emotion),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (isUser) ...[
          SizedBox(width: 8),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.blue[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.child_care,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😡';
      case 'worried':
        return '😰';
      case 'tired':
        return '😴';
      default:
        return '💭';
    }
  }
}
