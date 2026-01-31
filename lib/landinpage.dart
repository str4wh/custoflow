// ignore_for_file: unused_element

import 'package:flutter/material.dart';

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

// LandingPage widget
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  // Get responsive padding
  double _getHorizontalPadding(BuildContext context) {
    if (_isMobile(context)) return 16;
    if (_isTablet(context)) return 32;
    return 40;
  }

  double _getVerticalPadding(BuildContext context) {
    if (_isMobile(context)) return 16;
    if (_isTablet(context)) return 24;
    return 40;
  }

  // Navigation methods using named routes
  void navigateToAuth(bool isSignUp) {
    Navigator.pushNamed(context, '/auth', arguments: {'isSignUp': isSignUp});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _isMobile(context) ? _buildMobileDrawer() : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header/Navbar
                _buildHeader(),

                // Hero Section
                _buildHeroSection(),

                // Features Section
                _buildFeaturesSection(),

                // How It Works Section
                _buildHowItWorksSection(),

                // CTA Section
                _buildCTASection(),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mobile Drawer
  Widget _buildMobileDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'CustoFlow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.login, color: Colors.white),
                title: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  navigateToAuth(false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.rocket_launch, color: Colors.white),
                title: const Text(
                  'Start Free Trial',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  navigateToAuth(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(context),
        vertical: _getVerticalPadding(context) / 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: _isMobile(context) ? 24 : 32,
              ),
              SizedBox(width: _isMobile(context) ? 8 : 12),
              Text(
                'CustoFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile(context) ? 20 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Navigation
          if (_isMobile(context))
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            )
          else
            Row(
              children: [
                TextButton(
                  onPressed: () => navigateToAuth(false),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _isTablet(context) ? 14 : 16,
                    ),
                  ),
                ),
                SizedBox(width: _isTablet(context) ? 12 : 16),
                ElevatedButton(
                  onPressed: () => navigateToAuth(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF667eea),
                    padding: EdgeInsets.symmetric(
                      horizontal: _isTablet(context) ? 24 : 32,
                      vertical: _isTablet(context) ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Start Free Trial',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _isTablet(context) ? 13 : 15,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getHorizontalPadding(context),
          vertical: _isMobile(context) ? 40 : (_isTablet(context) ? 60 : 100),
        ),
        child: Column(
          children: [
            Text(
              'Automate Customer Feedback',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile(context)
                    ? 32
                    : (_isTablet(context) ? 42 : 56),
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 16 : 24),
            Text(
              'Collect, categorize, and respond to customer feedback automatically.\nPowered by N8N automation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: _isMobile(context)
                    ? 16
                    : (_isTablet(context) ? 18 : 20),
                height: 1.6,
              ),
            ),
            SizedBox(height: _isMobile(context) ? 32 : 48),
            ElevatedButton(
              onPressed: () => navigateToAuth(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667eea),
                padding: EdgeInsets.symmetric(
                  horizontal: _isMobile(context) ? 32 : 48,
                  vertical: _isMobile(context) ? 18 : 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                minimumSize: const Size(48, 48), // Minimum touch target
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started Free',
                    style: TextStyle(
                      fontSize: _isMobile(context) ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No credit card required • Setup in 5 minutes',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: _isMobile(context) ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': Icons.email_outlined,
        'title': 'Automated Emails',
        'description': 'Send thank you emails instantly to every customer',
      },
      {
        'icon': Icons.analytics_outlined,
        'title': 'Smart Categorization',
        'description': 'AI-powered sentiment analysis (Positive/Negative)',
      },
      {
        'icon': Icons.notifications_active_outlined,
        'title': 'Auto Escalation',
        'description': 'Route negative feedback to support team immediately',
      },
      {
        'icon': Icons.bar_chart_outlined,
        'title': 'Weekly Reports',
        'description': 'Automated insights delivered to managers',
      },
      {
        'icon': Icons.account_tree_outlined,
        'title': 'Multi-Department',
        'description': 'Organize feedback by departments',
      },
      {
        'icon': Icons.integration_instructions_outlined,
        'title': 'Easy Integration',
        'description': 'Add to your website in minutes with API',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(context),
        vertical: _isMobile(context) ? 40 : (_isTablet(context) ? 60 : 80),
      ),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Everything You Need',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _isMobile(context)
                  ? 28
                  : (_isTablet(context) ? 36 : 42),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF667eea),
            ),
          ),
          SizedBox(height: _isMobile(context) ? 8 : 16),
          Text(
            'Powerful automation tools to streamline your customer feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _isMobile(context)
                  ? 14
                  : (_isTablet(context) ? 16 : 18),
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(
            height: _isMobile(context) ? 32 : (_isTablet(context) ? 48 : 60),
          ),

          // Responsive grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              double childAspectRatio;

              if (_isMobile(context)) {
                crossAxisCount = 1;
                childAspectRatio = 1.3;
              } else if (_isTablet(context)) {
                crossAxisCount = 2;
                childAspectRatio = 1.2;
              } else {
                crossAxisCount = 3;
                childAspectRatio = 1.0;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: _isMobile(context) ? 16 : 32,
                  mainAxisSpacing: _isMobile(context) ? 16 : 32,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final feature = features[index];
                  return Container(
                    padding: EdgeInsets.all(_isMobile(context) ? 20 : 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            feature['icon'] as IconData,
                            size: _isMobile(context) ? 32 : 40,
                            color: const Color(0xFF667eea),
                          ),
                        ),
                        SizedBox(height: _isMobile(context) ? 12 : 20),
                        Text(
                          feature['title'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _isMobile(context) ? 18 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: _isMobile(context) ? 8 : 12),
                        Text(
                          feature['description'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: _isMobile(context) ? 13 : 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    final steps = [
      {
        'number': '1',
        'title': 'Sign Up',
        'description': 'Create your account and get your API key instantly',
      },
      {
        'number': '2',
        'title': 'Create Departments',
        'description': 'Set up departments like Support, Sales, Technical',
      },
      {
        'number': '3',
        'title': 'Integrate',
        'description': 'Add feedback form to your website with our API',
      },
      {
        'number': '4',
        'title': 'Automate',
        'description': 'N8N handles emails, categorization, and escalation',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(context),
        vertical: _isMobile(context) ? 40 : (_isTablet(context) ? 60 : 80),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea).withOpacity(0.05),
            const Color(0xFF764ba2).withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'How It Works',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _isMobile(context)
                  ? 28
                  : (_isTablet(context) ? 36 : 42),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: _isMobile(context) ? 32 : 60),

          // Responsive layout for steps
          if (_isMobile(context) || _isTablet(context))
            _buildVerticalSteps(steps)
          else
            _buildHorizontalSteps(steps),
        ],
      ),
    );
  }

  Widget _buildVerticalSteps(List<Map<String, String>> steps) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;

        return Column(
          children: [
            _buildStepItem(step),
            if (index < steps.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Icon(
                  Icons.arrow_downward,
                  color: const Color(0xFF667eea),
                  size: _isMobile(context) ? 24 : 32,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHorizontalSteps(List<Map<String, String>> steps) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStepItem(step),
            if (index < steps.length - 1)
              const Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF667eea),
                  size: 32,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStepItem(Map<String, String> step) {
    return Column(
      children: [
        Container(
          width: _isMobile(context) ? 60 : 80,
          height: _isMobile(context) ? 60 : 80,
          decoration: const BoxDecoration(
            color: Color(0xFF667eea),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step['number']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isMobile(context) ? 24 : 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: _isMobile(context) ? 280 : 200,
          child: Column(
            children: [
              Text(
                step['title']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _isMobile(context) ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                step['description']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _isMobile(context) ? 13 : 14,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(context),
        vertical: _isMobile(context) ? 60 : (_isTablet(context) ? 80 : 100),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Automate Your Feedback?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: _isMobile(context)
                  ? 28
                  : (_isTablet(context) ? 36 : 42),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _isMobile(context) ? 16 : 24),
          Text(
            'Join companies using CustoFlow to streamline customer feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: _isMobile(context)
                  ? 14
                  : (_isTablet(context) ? 16 : 18),
            ),
          ),
          SizedBox(height: _isMobile(context) ? 32 : 48),
          ElevatedButton(
            onPressed: () => navigateToAuth(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF667eea),
              padding: EdgeInsets.symmetric(
                horizontal: _isMobile(context) ? 32 : 48,
                vertical: _isMobile(context) ? 18 : 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
              minimumSize: const Size(48, 48), // Minimum touch target
            ),
            child: Text(
              'Start Your Free Trial',
              style: TextStyle(
                fontSize: _isMobile(context) ? 16 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(_isMobile(context) ? 24 : 40),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: _isMobile(context) ? 20 : 24,
              ),
              const SizedBox(width: 8),
              Text(
                'CustoFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _isMobile(context) ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2026 CustoFlow. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: _isMobile(context) ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
