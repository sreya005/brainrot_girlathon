import 'package:flutter/material.dart';
import 'childdashboard.dart';
import 'login.dart';
import 'dart:async';
import 'routine.dart';
import 'childaihistory.dart';
import 'suggestion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parent Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Segoe UI',
      ),
      initialRoute: '/', // Start with login page
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => ParentDashboard(),
        '/child': (context) => EmotionBridgeHome(), // Add child dashboard route
      },
    );
  }
}

class ParentDashboard extends StatefulWidget {
  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final TextEditingController _messageController = TextEditingController();
  bool _isCallActive = false;
  Timer? _callTimer;
  int _callDuration = 0;
  String _currentEmotion = '😊';
  String _currentEmotionText = 'Happy & Excited';
  String _lastUpdated = '12 minutes ago';

  @override
  void initState() {
    super.initState();
    _startEmotionUpdates();
  }

  void _startEmotionUpdates() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (mounted) {
        _simulateEmotionUpdate();
      }
    });
  }

  void _simulateEmotionUpdate() {
    final emotions = ['😊', '😄', '😌', '🤔', '😴'];
    final emotionTexts = [
      'Happy & Excited',
      'Joyful',
      'Calm & Peaceful',
      'Thoughtful',
      'Sleepy'
    ];

    if (DateTime.now().millisecond % 10 == 0) {
      final randomIndex = DateTime.now().millisecond % emotions.length;
      setState(() {
        _currentEmotion = emotions[randomIndex];
        _currentEmotionText = emotionTexts[randomIndex];
        _lastUpdated = 'Updated just now';
      });
    }
  }

  void _initiateCall() {
    setState(() {
      _isCallActive = !_isCallActive;

      if (_isCallActive) {
        _callDuration = 0;
        _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _callDuration++;
          });
        });
      } else {
        _callTimer?.cancel();
        _callDuration = 0;
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Message Sent'),
          content: Text('Message sent to Alex: "${_messageController.text}"'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      _messageController.clear();
    }
  }

  void _addTemplate(String template) {
    _messageController.text = template;
  }

  String _formatCallDuration() {
    int minutes = _callDuration ~/ 60;
    int seconds = _callDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Parent Dashboard'),
        backgroundColor: Color(0xFFD0D0D0),
        foregroundColor: Color(0xFF2C2C2C),
        actions: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Color(0xFF8A8A8A),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text('3',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Positioned(
                right: 3,
                top: 5,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xFF8A8A8A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('JP',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Good Evening, Jane!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C2C2C),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          '7:24 PM • Wednesday, July 16',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5C5C5C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Main Dashboard Grid
            LayoutBuilder(
              builder: (context, constraints) {
                bool isTablet = constraints.maxWidth > 600;

                if (isTablet) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildEmotionCard()),
                          SizedBox(width: 20),
                          Expanded(child: _buildRoutineCard()),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildChatCard()),
                          SizedBox(width: 20),
                          Expanded(child: _buildSuggestionsCard()),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildEmotionCard(),
                      SizedBox(height: 20),
                      _buildRoutineCard(),
                      SizedBox(height: 20),
                      _buildChatCard(),
                      SizedBox(height: 20),
                      _buildSuggestionsCard(),
                    ],
                  );
                }
              },
            ),

            SizedBox(height: 25),

            // Message Section
            _buildMessageCard(),

            SizedBox(height: 25),

            // Insights Section
            _buildInsightsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionCard() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF8A8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('😊', style: TextStyle(fontSize: 12))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Alex\'s Current Mood',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(_currentEmotion, style: TextStyle(fontSize: 60)),
          SizedBox(height: 10),
          Text(
            _currentEmotionText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C2C),
            ),
          ),
          SizedBox(height: 5),
          Text(
            _lastUpdated,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5C5C5C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineCard() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF8A8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('📋', style: TextStyle(fontSize: 12))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Set Daily Routine',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('View Current'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('⚙️', style: TextStyle(fontSize: 40)),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Schedule',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Set up your work hours, availability, and daily routine to optimize family time.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoutinePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C6C6C),
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 45),
            ),
            child: Text('Set Up Routine'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF8A8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('💬', style: TextStyle(fontSize: 12))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Alex & AI Chat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChildChatScreen()),
                  );
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: ListView(
              children: [
                _buildChatMessage('Alex',
                    'Can you help me with my math homework?', '6:45 PM', true),
                _buildChatMessage(
                    'AI Helper',
                    'Of course! Let\'s start with the first problem. What\'s 12 + 8?',
                    '6:46 PM',
                    false),
                _buildChatMessage('Alex',
                    '20! That was easy. What about 15 × 4?', '6:47 PM', true),
                _buildChatMessage(
                    'AI Helper',
                    'Great job! For 15 × 4, you can think of it as 15 × 4 = 60.',
                    '6:48 PM',
                    false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(
      String sender, String content, String time, bool isChild) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isChild ? Color(0xFFE3F2FD) : Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isChild ? Color(0xFF2196F3) : Color(0xFF9C27B0),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF5C5C5C),
            ),
          ),
          SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF2C2C2C),
            ),
          ),
          SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF8A8A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsCard() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF8A8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('🤖', style: TextStyle(fontSize: 12))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'AI Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParentChatScreen()),
                  );
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSuggestionItem(
            'Alex seems to enjoy math today. Consider adding 10 minutes of fun math games to tomorrow\'s routine.',
            'Based on activity patterns',
            'Priority: High',
          ),
          SizedBox(height: 12),
          _buildSuggestionItem(
            'It\'s been 2 days since creative time. Schedule some drawing or crafts for tomorrow afternoon.',
            'Based on routine analysis',
            'Priority: Medium',
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String text, String meta1, String meta2) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: Color(0xFF8A8A8A), width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF2C2C2C),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meta1,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5C5C5C),
                ),
              ),
              Text(
                meta2,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5C5C5C),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF8A8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('📨', style: TextStyle(fontSize: 12))),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Connect with Alex',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _initiateCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isCallActive ? Color(0xFFF44336) : Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📞'),
                        SizedBox(width: 8),
                        Text(_isCallActive ? 'End Call' : 'Call Alex'),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text('Schedule'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          if (_isCallActive)
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFE8F5E8),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Color(0xFF4CAF50)),
              ),
              child: Row(
                children: [
                  Text('📞'),
                  SizedBox(width: 8),
                  Text(
                    'Connected to Alex • ${_formatCallDuration()}',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ],
              ),
            ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type your message to Alex...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C6C6C),
                  foregroundColor: Colors.white,
                  minimumSize: Size(80, 50),
                ),
                child: Text('Send'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildTemplateButton('Great job today!'),
              _buildTemplateButton('Don\'t forget to brush your teeth!'),
              _buildTemplateButton('I love you!'),
              _buildTemplateButton('How was your day?'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateButton(String template) {
    return ElevatedButton(
      onPressed: () => _addTemplate(template),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF8F8F8),
        foregroundColor: Color(0xFF2C2C2C),
        side: BorderSide(color: Color(0xFFC0C0C0)),
      ),
      child: Text(template, style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildInsightsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(0xFF8A8A8A),
                  shape: BoxShape.circle,
                ),
                child:
                    Center(child: Text('📊', style: TextStyle(fontSize: 12))),
              ),
              SizedBox(width: 10),
              Text(
                'Weekly Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                childAspectRatio: 2.5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildInsightItem('📈', 'Learning Progress',
                      'Alex completed 85% of educational activities this week, showing improvement in math and reading.'),
                  _buildInsightItem('🎯', 'Goal Achievement',
                      'Successfully maintained bedtime routine 6 out of 7 days. Consider adjusting weekend schedule.'),
                  _buildInsightItem('🌟', 'Mood Patterns',
                      'Happiest between 3-5 PM and after dinner. Energy levels peak during afternoon activities.'),
                  _buildInsightItem('🤝', 'Parent-Child Connection',
                      'Shared 12 meaningful conversations this week. Consider more one-on-one time on weekends.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String icon, String title, String description) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: TextStyle(fontSize: 32)),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF2C2C2C),
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5C5C5C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _callTimer?.cancel();
    super.dispose();
  }
}
