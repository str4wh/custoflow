import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

class AuthPage extends StatefulWidget {
  final bool isSignUp;

  const AuthPage({Key? key, required this.isSignUp}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Sign Up
  final TextEditingController _signUpCompanyController =
      TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
      TextEditingController();

  // Controllers for Login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Controllers for Forgot Password
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController();

  // Password visibility states
  bool _signUpPasswordVisible = false;
  bool _signUpConfirmPasswordVisible = false;
  bool _loginPasswordVisible = false;

  // Loading states
  bool _isLoading = false;
  String _loadingMessage = '';

  // Form keys
  final _signUpFormKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  final _forgotPasswordFormKey = GlobalKey<FormState>();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.isSignUp) {
      _tabController.index = 0;
    } else {
      _tabController.index = 1;
    }
  }

  // Test webhook connectivity
  Future<void> _testWebhook() async {
    print('\n========== TESTING WEBHOOK CONNECTION ==========');
    print('🧪 Testing if N8N webhook is reachable...');
    try {
      final response = await http
          .post(
            Uri.parse(
              'http://localhost:5678/webhook-test/ddda45c7-ce0c-4340-9c36-7fe2f64ecd63',
            ),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'test': 'connection',
              'timestamp': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 5));
      print('🟢 Test successful! Status: ${response.statusCode}');
      print('🟢 Response: ${response.body}');
    } catch (e) {
      print('🔴 Test failed! Error: $e');
      print('🔴 Error Type: ${e.runtimeType}');
      print('⚠️  Make sure N8N is running on http://localhost:5678');
    }
    print('========== WEBHOOK TEST COMPLETE ==========\n');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _signUpCompanyController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _forgotPasswordEmailController.dispose();
    super.dispose();
  }

  // Responsive helper methods
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.mobile &&
        width < ResponsiveBreakpoints.tablet;
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;
  }

  double _getCardMaxWidth(BuildContext context) {
    if (_isMobile(context)) return double.infinity;
    if (_isTablet(context)) return 500;
    return 550;
  }

  double _getCardPadding(BuildContext context) {
    if (_isMobile(context)) return 24;
    if (_isTablet(context)) return 32;
    return 40;
  }

  double _getTitleFontSize(BuildContext context) {
    if (_isMobile(context)) return 24;
    if (_isTablet(context)) return 28;
    return 32;
  }

  double _getSubtitleFontSize(BuildContext context) {
    if (_isMobile(context)) return 14;
    if (_isTablet(context)) return 15;
    return 16;
  }

  double _getButtonHeight(BuildContext context) {
    if (_isMobile(context)) return 48;
    if (_isTablet(context)) return 52;
    return 56;
  }

  double _getLogoSize(BuildContext context) {
    if (_isMobile(context)) return 48;
    if (_isTablet(context)) return 56;
    return 64;
  }

  // Generate unique API key
  String _generateApiKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return 'cfk_${timestamp}_$random';
  }

  // Send POST request to N8N webhook
  Future<bool> _sendToN8NWebhook(Map<String, dynamic> data) async {
    const webhookUrl =
        'http://localhost:5678/webhook-test/ddda45c7-ce0c-4340-9c36-7fe2f64ecd63';

    print('\n========== WEBHOOK DEBUG START ==========');
    print('🔵 Attempting webhook call');
    print('🔵 URL: $webhookUrl');
    print('🔵 Method: POST');
    print(
      '🔵 Headers: {"Content-Type": "application/json", "Accept": "application/json"}',
    );
    print('🔵 Payload: ${jsonEncode(data)}');
    print('🔵 Payload Size: ${jsonEncode(data).length} bytes');
    print('🔵 Timeout: 10 seconds');

    try {
      final response = await http
          .post(
            Uri.parse(webhookUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      print('🟢 Response Status: ${response.statusCode}');
      print('🟢 Response Headers: ${response.headers}');
      print('🟢 Response Body: ${response.body}');
      print('🟢 Response Body Length: ${response.body.length} bytes');
      print('========== WEBHOOK DEBUG END ==========\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Webhook call successful!');
        return true;
      } else {
        print(
          '⚠️  Webhook returned non-success status: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      print('🔴 Webhook Error: $e');
      print('🔴 Error Type: ${e.runtimeType}');
      if (e.toString().contains('XMLHttpRequest')) {
        print('⚠️  CORS Issue Detected: Browser blocked the request');
        print(
          '⚠️  Solution: Check N8N CORS settings or run Flutter app from localhost',
        );
      } else if (e.toString().contains('TimeoutException')) {
        print('⚠️  Timeout: N8N did not respond within 10 seconds');
      } else if (e.toString().contains('SocketException')) {
        print('⚠️  Network Error: Cannot reach N8N server');
        print('⚠️  Check if N8N is running on http://localhost:5678');
      }
      print('========== WEBHOOK DEBUG END ==========\n');
      return false;
    }
  }

  // Sign Up Handler
  Future<void> handleSignUp() async {
    if (!_signUpFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Creating your account...';
    });

    try {
      final companyName = _signUpCompanyController.text.trim();
      final email = _signUpEmailController.text.trim();
      final password = _signUpPasswordController.text;

      // Create Firebase Auth user
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;
      final apiKey = _generateApiKey();
      final webhookUrl =
          'http://localhost:5678/webhook-test/ddda45c7-ce0c-4340-9c36-7fe2f64ecd63';
      final now = DateTime.now();

      // Create Firestore company document
      setState(() {
        _loadingMessage = 'Setting up your company profile...';
      });

      await _firestore.collection('companies').doc(userId).set({
        'id': userId,
        'name': companyName,
        'adminEmail': email,
        'apiKey': apiKey,
        'webhookUrl': webhookUrl,
        'createdAt': Timestamp.fromDate(now),
        'departmentIds': [],
      });

      // Send POST request to N8N webhook
      setState(() {
        _loadingMessage = 'Setting up your account...';
      });

      final webhookData = {
        'companyId': userId,
        'companyName': companyName,
        'adminEmail': email,
        'apiKey': apiKey,
        'webhookUrl': webhookUrl,
        'timestamp': now.toIso8601String(),
        'eventType': 'company_created',
      };

      // Call webhook without blocking navigation
      print('\n📤 ABOUT TO CALL WEBHOOK - handleSignUp()');
      print('📤 Webhook data prepared: ${webhookData.keys.toList()}');

      _sendToN8NWebhook(webhookData)
          .then((success) {
            print('📥 WEBHOOK CALL COMPLETED - handleSignUp()');
            print('📥 Success: $success');
            if (!success && mounted) {
              _showSnackBar(
                'Welcome email may be delayed. You can find your API key in the dashboard.',
                isWarning: true,
              );
            }
          })
          .catchError((error) {
            print('🔴 Webhook call error in .catchError: $error');
            print('🔴 Error stack trace: ${StackTrace.current}');
          });

      print('✅ Webhook call initiated (running in background)');

      // Navigate to Dashboard with first-time setup flag
      if (mounted) {
        final companyData = {
          'id': userId,
          'name': companyName,
          'adminEmail': email,
          'apiKey': apiKey,
          'webhookUrl': webhookUrl,
        };

        Navigator.pushReplacementNamed(
          context,
          Routes.dashboard,
          arguments: {'companyData': companyData, 'isFirstTimeSetup': true},
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'This email is already registered. Please login instead.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use at least 8 characters.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingMessage = '';
        });
      }
    }
  }

  // Login Handler
  Future<void> handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Signing you in...';
    });

    try {
      final email = _loginEmailController.text.trim();
      final password = _loginPasswordController.text;

      // Sign in with Firebase Auth
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;

      // Fetch company data from Firestore
      setState(() {
        _loadingMessage = 'Loading your company data...';
      });

      final companyDoc = await _firestore
          .collection('companies')
          .doc(userId)
          .get();

      if (!companyDoc.exists) {
        throw Exception('Company data not found');
      }

      final companyData = companyDoc.data()!;

      // Navigate to Dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          Routes.dashboard,
          arguments: {'companyData': companyData, 'isFirstTimeSetup': false},
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage =
              'Incorrect password. Try again or reset your password.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingMessage = '';
        });
      }
    }
  }

  // Forgot Password Handler
  Future<void> handleForgotPassword() async {
    if (!_forgotPasswordFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Sending password reset email...';
    });

    try {
      final email = _forgotPasswordEmailController.text.trim();

      await _auth.sendPasswordResetEmail(email: email);

      if (mounted) {
        Navigator.pop(context);
        _showSnackBar(
          'Password reset email sent! Check your inbox.',
          isSuccess: true,
        );
        _forgotPasswordEmailController.clear();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Check your connection.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingMessage = '';
        });
      }
    }
  }

  // Show SnackBar
  void _showSnackBar(
    String message, {
    bool isSuccess = false,
    bool isWarning = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess
            ? Colors.green
            : isWarning
            ? Colors.orange
            : Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show Forgot Password Dialog
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: _forgotPasswordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _forgotPasswordEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'your@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : handleForgotPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  // Password Strength Calculator
  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = password.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    int strength = 0;
    if (hasUppercase) strength++;
    if (hasLowercase) strength++;
    if (hasDigits) strength++;
    if (hasSpecialCharacters) strength++;
    if (password.length >= 8) strength++;

    if (strength <= 2) return 'Weak';
    if (strength <= 3) return 'Medium';
    return 'Strong';
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardMaxWidth = _getCardMaxWidth(context);
    final cardPadding = _getCardPadding(context);
    final titleFontSize = _getTitleFontSize(context);
    final subtitleFontSize = _getSubtitleFontSize(context);
    final buttonHeight = _getButtonHeight(context);
    final logoSize = _getLogoSize(context);
    final isMobile = _isMobile(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardMaxWidth),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(cardPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo and Title
                            Icon(
                              Icons.auto_awesome,
                              size: logoSize,
                              color: const Color(0xFF667eea),
                            ),
                            SizedBox(height: isMobile ? 16 : 24),
                            Text(
                              'CustoFlow',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF667eea),
                              ),
                            ),
                            SizedBox(height: isMobile ? 8 : 12),
                            Text(
                              'Automated Customer Feedback',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: isMobile ? 24 : 32),

                            // Tab Bar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  color: const Color(0xFF667eea),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey.shade700,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 14 : 15,
                                ),
                                tabs: const [
                                  Tab(text: 'Sign Up'),
                                  Tab(text: 'Login'),
                                ],
                              ),
                            ),
                            SizedBox(height: isMobile ? 24 : 32),

                            // Tab Views
                            SizedBox(
                              height: _tabController.index == 0
                                  ? (isMobile ? 420 : 480)
                                  : (isMobile ? 260 : 300),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildSignUpForm(isMobile, buttonHeight),
                                  _buildLoginForm(isMobile, buttonHeight),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          _loadingMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Sign Up Form
  Widget _buildSignUpForm(bool isMobile, double buttonHeight) {
    return Form(
      key: _signUpFormKey,
      child: ListView(
        children: [
          // Company Name Field
          TextFormField(
            controller: _signUpCompanyController,
            decoration: InputDecoration(
              labelText: 'Company Name',
              hintText: 'Your Company',
              prefixIcon: const Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter company name';
              }
              if (value.trim().length < 2) {
                return 'Company name must be at least 2 characters';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Email Field
          TextFormField(
            controller: _signUpEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'your@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Password Field
          TextFormField(
            controller: _signUpPasswordController,
            obscureText: !_signUpPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'At least 8 characters',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _signUpPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _signUpPasswordVisible = !_signUpPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {}); // Update password strength
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!RegExp(
                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$',
              ).hasMatch(value)) {
                return 'Use uppercase, lowercase, and numbers';
              }
              return null;
            },
          ),

          // Password Strength Indicator
          if (_signUpPasswordController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  'Strength: ',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  _getPasswordStrength(_signUpPasswordController.text),
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.bold,
                    color: _getPasswordStrengthColor(
                      _getPasswordStrength(_signUpPasswordController.text),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: isMobile ? 12 : 16),

          // Confirm Password Field
          TextFormField(
            controller: _signUpConfirmPasswordController,
            obscureText: !_signUpConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _signUpConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _signUpConfirmPasswordVisible =
                        !_signUpConfirmPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _signUpPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 20 : 24),

          // Sign Up Button
          SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _isLoading ? null : handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm(bool isMobile, double buttonHeight) {
    return Form(
      key: _loginFormKey,
      child: ListView(
        children: [
          // Email Field
          TextFormField(
            controller: _loginEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'your@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Password Field
          TextFormField(
            controller: _loginPasswordController,
            obscureText: !_loginPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Your password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _loginPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _loginPasswordVisible = !_loginPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: const Color(0xFF667eea),
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          // Login Button
          SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: _isLoading ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
