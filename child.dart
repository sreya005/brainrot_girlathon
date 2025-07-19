import 'package:flutter/material.dart';

class EmotionBridgeHome extends StatefulWidget {
  const EmotionBridgeHome({super.key});

  @override
  State<EmotionBridgeHome> createState() => _EmotionBridgeHomeState();
}

class _EmotionBridgeHomeState extends State<EmotionBridgeHome> {
  final List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _parentMessages = [];
  final Map<String, bool> _tasks = {
    'Wake up early': false,
    'Study 1hr': false,
  };

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _parentMsgController = TextEditingController();
  final TextEditingController _taskEditController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _editingTaskKey;

  void _sendMessage(String text, {bool isUser = true}) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': isUser});
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    if (isUser) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _sendMessage("Got it! ✅", isUser: false);
      });
    }
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final day = days[now.weekday % 7];
    final month = months[now.month - 1];
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$day, $month ${now.day} · $hour:$minute $ampm';
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.account_circle, size: 30),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isUser ? Colors.deepPurple[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (isUser)
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.account_circle, size: 30),
            ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message['text'], message['isUser']);
              },
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: Colors.grey[100],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'Message..',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (text) {
                        _sendMessage(text);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: Colors.deepPurple),
                    onPressed: () {
                      _sendMessage(_controller.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(top: 20, right: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 4,
            offset: const Offset(2, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16),
            child: Text(
              getCurrentDateTime(),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const Divider(),
          // 👇 Parent Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.account_circle,
                            size: 30, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text("Online", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView.builder(
                        itemCount: _parentMessages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Align(
                              alignment: _parentMessages[index]['isParent']
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _parentMessages[index]['isParent']
                                      ? Colors.deepPurple[100]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(_parentMessages[index]['text']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _parentMsgController,
                            decoration:
                                const InputDecoration(hintText: 'Message'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              _parentMessages.add({
                                'text': _parentMsgController.text,
                                'isParent': false,
                              });
                              _parentMsgController.clear();
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 👇 Daily Task Box with scrollable tasks
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Tasks',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      children: _tasks.entries.map((entry) {
                        final isEditing = _editingTaskKey == entry.key;
                        return Row(
                          children: [
                            Checkbox(
                              value: entry.value,
                              onChanged: (newValue) {
                                setState(() {
                                  _tasks[entry.key] = newValue!;
                                });
                              },
                            ),
                            isEditing
                                ? Expanded(
                                    child: TextField(
                                      controller: _taskEditController
                                        ..text = entry.key,
                                      autofocus: true,
                                      onSubmitted: (newName) {
                                        if (newName.trim().isEmpty ||
                                            _tasks.containsKey(newName)) {
                                          setState(
                                              () => _editingTaskKey = null);
                                          return;
                                        }
                                        final status = _tasks.remove(entry.key);
                                        _tasks[newName] = status!;
                                        _editingTaskKey = null;
                                        _taskEditController.clear();
                                        setState(() {});
                                      },
                                    ),
                                  )
                                : Expanded(child: Text(entry.key)),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                setState(() => _editingTaskKey = entry.key);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 18, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _tasks.remove(entry.key);
                                });
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _tasks['New Task'] = false);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Task'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: const Text("Emotion Bridge"),
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.deepPurple,
            centerTitle: true,
          ),
          Expanded(
            child: Row(
              children: [
                _buildChatArea(),
                _buildSidebar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
