import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String? selectedRole;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  Future<void> login() async {
    if (selectedRole == null) {
      _showDialog('Please select your profile first!');
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        isLoading = false;
      });

      final roleName = selectedRole == 'parent' ? 'Jane' : 'Alex';
      final dashboardType =
          selectedRole == 'parent' ? 'Parent Dashboard' : 'Child Dashboard';

      _showDialogWithCallback(
        'Welcome to EmotionBridge, $roleName!\n\nRedirecting to $dashboardType...',
        onDialogClose: () {
          // Navigate based on selected role
          if (selectedRole == 'parent') {
            Navigator.pushNamed(context, '/home');
          } else {
            Navigator.pushNamed(context, '/child');
          }
        },
      );
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('EmotionBridge'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogWithCallback(String message, {VoidCallback? onDialogClose}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                if (onDialogClose != null) {
                  onDialogClose(); // Execute navigation
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 20,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE9ECEF), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAppHeader(),
                        const SizedBox(height: 30),
                        _buildRoleSelection(),
                        const SizedBox(height: 30),
                        _buildLoginActions(),
                        const SizedBox(height: 20),
                        _buildFooterInfo(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: const [
        Text(
          'EmotionBridge',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Connecting hearts, building understanding',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6C757D),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      children: [
        const Text(
          'Choose Your Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _buildRoleCard('parent', 'JP', 'Jane', 'Parent'),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildRoleCard('child', 'A', 'Alex', 'Child'),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRoleCard(String role, String avatar, String name, String type) {
    final isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF495057), Color(0xFF6C757D)],
                )
              : null,
          color: isSelected ? null : const Color(0xFFF8F9FA),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF495057) : const Color(0xFFE9ECEF),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF6C757D),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  avatar,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              type,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white70 : const Color(0xFF6C757D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginActions() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ElevatedButton(
              onPressed: (selectedRole != null && !isLoading) ? login : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: (selectedRole != null && !isLoading)
                    ? const Color(0xFF495057)
                    : const Color(0xFFDEE2E6),
                elevation: (selectedRole != null && !isLoading) ? 10 : 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      selectedRole != null
                          ? 'Continue as ${selectedRole == 'parent' ? 'Jane' : 'Alex'}'
                          : 'Select a profile to continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: (selectedRole != null && !isLoading)
                            ? Colors.white
                            : const Color(0xFF6C757D),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooterInfo() {
    return const Text(
      'Building stronger family connections through understanding and meaningful communication.',
      style: TextStyle(
        fontSize: 14,
        color: Color(0xFF6C757D),
        height: 1.6,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }
}
