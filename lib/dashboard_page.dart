import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:html' as html;
import 'main.dart';

// Responsive breakpoints
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
}

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic>? companyData;
  final bool isFirstTimeSetup;

  const DashboardPage({
    Key? key,
    this.companyData,
    this.isFirstTimeSetup = false,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? _companyData;
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _allFeedbackMessages = [];
  List<Map<String, dynamic>> _positiveFeedbackDocs = [];
  List<Map<String, dynamic>> _negativeFeedbackDocs = [];
  bool _isLoading = true;
  int _totalFeedback = 0;
  int _positiveFeedback = 0;
  int _negativeFeedback = 0;
  String _selectedDepartmentFilter = 'All';
  String _trendPeriod = 'weekly';
  StreamSubscription<QuerySnapshot>? _positiveStreamSub;
  StreamSubscription<QuerySnapshot>? _negativeStreamSub;

  static const List<String> _departmentFilters = [
    'All',
    'Sales',
    'Support',
    'Technical',
    'Billing',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    _initializeDashboard();
  }

  @override
  void dispose() {
    _positiveStreamSub?.cancel();
    _negativeStreamSub?.cancel();
    super.dispose();
  }

  Future<void> _initializeDashboard() async {
    await _loadCompanyData();
    await _loadDepartments();
    _setupRealtimeStreams();

    // Show onboarding dialog for first-time users
    if (widget.isFirstTimeSetup && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showOnboardingDialog();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadCompanyData() async {
    try {
      if (widget.companyData != null) {
        _companyData = widget.companyData;
      } else {
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          final doc = await _firestore
              .collection('companies')
              .doc(userId)
              .get();
          if (doc.exists) {
            _companyData = doc.data();
          }
        }
      }
    } catch (e) {
      print('Error loading company data: $e');
    }
  }

  Future<void> _loadDepartments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _firestore
            .collection('companies')
            .doc(userId)
            .collection('departments')
            .get();

        setState(() {
          _departments = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      }
    } catch (e) {
      print('Error loading departments: $e');
    }
  }

  void _setupRealtimeStreams() {
    final companyId =
        _companyData?['id'] ??
        _companyData?['companyId'] ??
        _auth.currentUser?.uid;

    if (companyId == null || companyId.isEmpty) return;

    _positiveStreamSub = _firestore
        .collection('feedback')
        .snapshots()
        .listen((snapshot) {
          if (!mounted) return;
          setState(() {
            _positiveFeedbackDocs = _parseFeedbackDocs(
              snapshot.docs,
              companyId,
              'positive',
              'feedback',
            );
            _updateAnalytics();
          });
        });

    _negativeStreamSub = _firestore
        .collection('feedback negative')
        .snapshots()
        .listen((snapshot) {
          if (!mounted) return;
          setState(() {
            _negativeFeedbackDocs = _parseFeedbackDocs(
              snapshot.docs,
              companyId,
              'negative',
              'feedback negative',
            );
            _updateAnalytics();
          });
        });
  }

  List<Map<String, dynamic>> _parseFeedbackDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    String companyId,
    String defaultSentiment,
    String collectionName,
  ) {
    return docs
        .where((doc) {
          if (doc.data()['companyId']?.toString() == companyId) return true;
          for (final key in doc.data().keys) {
            if (key.contains(companyId)) return true;
          }
          return false;
        })
        .map((doc) {
          final allKeysString = doc.data().keys.join(' ');

          String extractValue(String fieldName) {
            final directValue = doc.data()[fieldName]?.toString();
            if (directValue != null && directValue.isNotEmpty) {
              return directValue;
            }
            final pattern = RegExp('"$fieldName"\\s*:\\s*"([^"]+)"');
            final match = pattern.firstMatch(allKeysString);
            return match?.group(1) ?? '';
          }

          return {
            'id': doc.id,
            '_collection': collectionName,
            'message': extractValue('message'),
            'email': extractValue('email'),
            'adminEmail': extractValue('adminEmail'),
            'companyId': companyId,
            'sentiment': extractValue('sentiment').isEmpty
                ? defaultSentiment
                : extractValue('sentiment'),
            'department': extractValue('department').isEmpty
                ? 'General'
                : extractValue('department'),
            'status': extractValue('status').isEmpty
                ? 'pending'
                : extractValue('status'),
            'source': extractValue('source'),
            'timestamp': extractValue('timestamp'),
            'createdAt': extractValue('createdAt'),
          };
        })
        .toList();
  }

  void _updateAnalytics() {
    final allMessages = [..._positiveFeedbackDocs, ..._negativeFeedbackDocs];
    allMessages.sort(
      (a, b) => _getFeedbackDate(b).compareTo(_getFeedbackDate(a)),
    );
    _positiveFeedback = _positiveFeedbackDocs.length;
    _negativeFeedback = _negativeFeedbackDocs.length;
    _totalFeedback = _positiveFeedback + _negativeFeedback;
    _allFeedbackMessages = allMessages;
  }

  Future<void> _updateFeedbackStatus(
    String docId,
    String collection,
    String newStatus,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        'status': newStatus,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to "$newStatus"'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> get _filteredFeedbackMessages {
    if (_selectedDepartmentFilter == 'All') {
      return _allFeedbackMessages;
    }

    return _allFeedbackMessages.where((item) {
      final department = item['department']?.toString() ?? '';
      return department.toLowerCase() ==
          _selectedDepartmentFilter.toLowerCase();
    }).toList();
  }

  DateTime _getFeedbackDate(Map<String, dynamic> feedback) {
    final createdAt = _tryParseDate(feedback['createdAt']);
    if (createdAt != null) {
      return createdAt;
    }

    final timestamp = _tryParseDate(feedback['timestamp']);
    if (timestamp != null) {
      return timestamp;
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  DateTime? _tryParseDate(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed;
      }

      final numericValue = int.tryParse(value);
      if (numericValue != null) {
        return DateTime.fromMillisecondsSinceEpoch(numericValue);
      }
    }

    return null;
  }

  String _formatFeedbackDate(Map<String, dynamic> feedback) {
    final date = _getFeedbackDate(feedback);
    if (date.millisecondsSinceEpoch == 0) {
      return 'Unknown date';
    }

    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();
    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  Color _getDepartmentColor(String department) {
    switch (department.toLowerCase()) {
      case 'sales':
        return Colors.blue;
      case 'support':
        return Colors.green;
      case 'technical':
        return Colors.orange;
      case 'billing':
        return Colors.purple;
      case 'general':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
      case 'closed':
        return Colors.green;
      case 'pending':
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // ── CHARTS SECTION ──────────────────────────────────────────────────────────

  Widget _buildChartsSection(bool isMobile, double padding) {
    // Sentiment values
    final double positiveVal = _positiveFeedback.toDouble();
    final double negativeVal = _negativeFeedback.toDouble();
    final bool hasFeedback = _totalFeedback > 0;

    // Department counts
    final deptOrder = ['Sales', 'Support', 'Technical', 'Billing', 'General'];
    final deptColors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.grey,
    ];
    final Map<String, int> deptCounts = {for (var d in deptOrder) d: 0};
    for (final msg in _allFeedbackMessages) {
      final dept = msg['department']?.toString() ?? 'General';
      if (deptCounts.containsKey(dept)) {
        deptCounts[dept] = deptCounts[dept]! + 1;
      } else {
        deptCounts['General'] = (deptCounts['General'] ?? 0) + 1;
      }
    }

    // Trend data — recomputed whenever _trendPeriod changes
    final trendData = _computeTrendData(_trendPeriod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Charts',
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: padding / 2),

        // Pie + Bar side by side (column on mobile)
        isMobile
            ? Column(
                children: [
                  _buildSentimentPieCard(positiveVal, negativeVal, hasFeedback, padding),
                  SizedBox(height: padding),
                  _buildDepartmentBarCard(deptOrder, deptCounts, deptColors, padding),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSentimentPieCard(
                      positiveVal, negativeVal, hasFeedback, padding,
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    flex: 2,
                    child: _buildDepartmentBarCard(
                      deptOrder, deptCounts, deptColors, padding,
                    ),
                  ),
                ],
              ),

        SizedBox(height: padding),

        // Trend line chart with period dropdown
        _buildTrendLineCard(
          trendData['positive'] as List<FlSpot>,
          trendData['negative'] as List<FlSpot>,
          trendData['labels'] as List<String>,
          trendData['title'] as String,
          padding,
        ),
      ],
    );
  }

  /// Returns spots, labels, and title for the chosen trend period.
  Map<String, dynamic> _computeTrendData(String period) {
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<FlSpot> pos = [];
    final List<FlSpot> neg = [];
    final List<String> labels = [];
    String title = '';

    if (period == 'monthly') {
      // Last 4 weeks, one point per week
      title = '4-Week Feedback Trend';
      for (int i = 0; i < 4; i++) {
        final weekEnd = today.subtract(Duration(days: (3 - i) * 7));
        final weekStart = weekEnd.subtract(const Duration(days: 6));
        final weekEndInclusive = weekEnd.add(const Duration(days: 1));
        labels.add('Wk ${i + 1}\n${monthNames[weekStart.month]} ${weekStart.day}');
        int p = 0, n = 0;
        for (final msg in _allFeedbackMessages) {
          final d = _getFeedbackDate(msg);
          if (!d.isBefore(weekStart) && d.isBefore(weekEndInclusive)) {
            if (msg['sentiment']?.toString().toLowerCase() == 'positive') {
              p++;
            } else {
              n++;
            }
          }
        }
        pos.add(FlSpot(i.toDouble(), p.toDouble()));
        neg.add(FlSpot(i.toDouble(), n.toDouble()));
      }
    } else if (period == 'yearly') {
      // Last 12 months, one point per month
      title = '12-Month Feedback Trend';
      for (int i = 0; i < 12; i++) {
        // Calculate month going back from current
        int m = now.month - 11 + i;
        int y = now.year;
        while (m <= 0) {
          m += 12;
          y -= 1;
        }
        final monthStart = DateTime(y, m, 1);
        final monthEnd = (m == 12)
            ? DateTime(y + 1, 1, 1)
            : DateTime(y, m + 1, 1);
        labels.add('${monthNames[m]}\n$y');
        int p = 0, n = 0;
        for (final msg in _allFeedbackMessages) {
          final d = _getFeedbackDate(msg);
          if (!d.isBefore(monthStart) && d.isBefore(monthEnd)) {
            if (msg['sentiment']?.toString().toLowerCase() == 'positive') {
              p++;
            } else {
              n++;
            }
          }
        }
        pos.add(FlSpot(i.toDouble(), p.toDouble()));
        neg.add(FlSpot(i.toDouble(), n.toDouble()));
      }
    } else {
      // Weekly — last 7 days, one point per day
      title = '7-Day Feedback Trend';
      for (int i = 0; i < 7; i++) {
        final day = today.subtract(Duration(days: 6 - i));
        final dayEnd = day.add(const Duration(days: 1));
        labels.add('${day.day}\n${monthNames[day.month]}');
        int p = 0, n = 0;
        for (final msg in _allFeedbackMessages) {
          final d = _getFeedbackDate(msg);
          if (!d.isBefore(day) && d.isBefore(dayEnd)) {
            if (msg['sentiment']?.toString().toLowerCase() == 'positive') {
              p++;
            } else {
              n++;
            }
          }
        }
        pos.add(FlSpot(i.toDouble(), p.toDouble()));
        neg.add(FlSpot(i.toDouble(), n.toDouble()));
      }
    }

    return {'positive': pos, 'negative': neg, 'labels': labels, 'title': title};
  }

  Widget _buildSentimentPieCard(
    double positiveVal,
    double negativeVal,
    bool hasFeedback,
    double padding,
  ) {
    final total = positiveVal + negativeVal;
    final posPct = total > 0 ? (positiveVal / total * 100).toStringAsFixed(0) : '0';
    final negPct = total > 0 ? (negativeVal / total * 100).toStringAsFixed(0) : '0';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sentiment Split',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: hasFeedback
                  ? PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: positiveVal,
                            color: Colors.green,
                            title: '$posPct%',
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          PieChartSectionData(
                            value: negativeVal,
                            color: Colors.red,
                            title: '$negPct%',
                            radius: 75,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        centerSpaceRadius: 35,
                        sectionsSpace: 3,
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No data yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chartLegendDot(Colors.green, 'Positive (${positiveVal.toInt()})'),
                const SizedBox(width: 16),
                _chartLegendDot(Colors.red, 'Negative (${negativeVal.toInt()})'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentBarCard(
    List<String> deptOrder,
    Map<String, int> deptCounts,
    List<Color> deptColors,
    double padding,
  ) {
    final maxY = deptCounts.values.isEmpty
        ? 5.0
        : (deptCounts.values.reduce((a, b) => a > b ? a : b) + 1).toDouble();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feedback by Department',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: maxY,
                  barGroups: List.generate(deptOrder.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: deptCounts[deptOrder[i]]!.toDouble(),
                          color: deptColors[i],
                          width: 22,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= deptOrder.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              deptOrder[idx].substring(0, 3),
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) return const SizedBox();
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 11),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendLineCard(
    List<FlSpot> positiveSpots,
    List<FlSpot> negativeSpots,
    List<String> labels,
    String title,
    double padding,
  ) {
    final allY = [...positiveSpots, ...negativeSpots].map((s) => s.y);
    final maxY = allY.isEmpty ? 5.0 : (allY.reduce((a, b) => a > b ? a : b) + 1);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: title + period dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF667eea)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _trendPeriod,
                      isDense: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Color(0xFF667eea),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF667eea),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      onChanged: (val) {
                        if (val != null) setState(() => _trendPeriod = val);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'weekly',
                          child: Text('Weekly (7 days)'),
                        ),
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text('Monthly (4 weeks)'),
                        ),
                        DropdownMenuItem(
                          value: 'yearly',
                          child: Text('Yearly (12 months)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: positiveSpots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withOpacity(0.08),
                      ),
                    ),
                    LineChartBarData(
                      spots: negativeSpots,
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.08),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          // Only render labels at exact integer x positions
                          final idx = value.toInt();
                          if (value != idx.toDouble()) return const SizedBox();
                          if (idx < 0 || idx >= labels.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[idx],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10, height: 1.3),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0) return const SizedBox();
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 11),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chartLegendDot(Colors.green, 'Positive'),
                const SizedBox(width: 16),
                _chartLegendDot(Colors.red, 'Negative'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // ── FEEDBACK FEED ────────────────────────────────────────────────────────────

  Widget _buildFeedbackMessageFeed(bool isMobile, double padding) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feedback Message Feed',
          style: TextStyle(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: padding / 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _departmentFilters.map((department) {
              final isSelected = _selectedDepartmentFilter == department;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(department),
                  selected: isSelected,
                  selectedColor: const Color(0xFF667eea),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (_) {
                    setState(() {
                      _selectedDepartmentFilter = department;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: padding / 2),
        if (_allFeedbackMessages.isEmpty)
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding * 1.5),
              child: Column(
                children: [
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No feedback messages yet',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'New feedback will appear here once collected.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_filteredFeedbackMessages.isEmpty)
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(padding * 1.5),
              child: Column(
                children: [
                  Icon(
                    Icons.filter_list_off,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No messages for $_selectedDepartmentFilter',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredFeedbackMessages.length,
            itemBuilder: (context, index) {
              final feedback = _filteredFeedbackMessages[index];
              final message =
                  feedback['message']?.toString().trim().isNotEmpty == true
                  ? feedback['message'].toString()
                  : 'No message provided';
              final email =
                  feedback['email']?.toString().trim().isNotEmpty == true
                  ? feedback['email'].toString()
                  : 'Unknown sender';
              final department =
                  feedback['department']?.toString().trim().isNotEmpty == true
                  ? feedback['department'].toString()
                  : 'General';
              final sentiment =
                  feedback['sentiment']?.toString().trim().isNotEmpty == true
                  ? feedback['sentiment'].toString().toLowerCase()
                  : 'unknown';
              final status =
                  feedback['status']?.toString().trim().isNotEmpty == true
                  ? feedback['status'].toString()
                  : 'Unknown';

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 14 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              email,
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 13,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getDepartmentColor(
                                department,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              department,
                              style: TextStyle(
                                color: _getDepartmentColor(department),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getSentimentColor(
                                sentiment,
                              ).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              sentiment,
                              style: TextStyle(
                                color: _getSentimentColor(sentiment),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            initialValue: status,
                            tooltip: 'Update status',
                            onSelected: (newStatus) {
                              final docId =
                                  feedback['id']?.toString() ?? '';
                              final collection =
                                  feedback['_collection']?.toString() ??
                                  'feedback';
                              if (docId.isNotEmpty) {
                                _updateFeedbackStatus(
                                  docId,
                                  collection,
                                  newStatus,
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'pending',
                                child: Text('Pending'),
                              ),
                              PopupMenuItem(
                                value: 'reviewed',
                                child: Text('Reviewed'),
                              ),
                              PopupMenuItem(
                                value: 'resolved',
                                child: Text('Resolved'),
                              ),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  status,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: _getStatusColor(status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 14,
                                    color: _getStatusColor(status),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatFeedbackDate(feedback),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showOnboardingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667eea).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.celebration,
                color: Color(0xFF667eea),
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Welcome to CustoFlow!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your account has been successfully created! 🎉',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Next Steps:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildOnboardingStep(
                '1',
                'Check Your Email',
                'We\'ve sent your API key and setup instructions',
              ),
              const SizedBox(height: 12),
              _buildOnboardingStep(
                '2',
                'Create Departments',
                'Set up departments like Support, Sales, Technical',
              ),
              const SizedBox(height: 12),
              _buildOnboardingStep(
                '3',
                'Get Webhook URLs',
                'Copy department webhook URLs for integration',
              ),
              const SizedBox(height: 12),
              _buildOnboardingStep(
                '4',
                'Integrate with Your Website',
                'Add feedback forms using our API',
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.key, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Your API Key',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _companyData?['apiKey'] ?? 'Loading...',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: _companyData?['apiKey'] ?? '',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('API Key copied to clipboard!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Got it!'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showCreateDepartmentDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create First Department'),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF667eea),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreateDepartmentDialog() {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Create Department'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Department Name',
                  hintText: 'e.g., Support, Sales, Technical',
                  prefixIcon: const Icon(Icons.business_center),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter department name';
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await _createDepartment(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createDepartment(String name) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await _firestore
            .collection('companies')
            .doc(userId)
            .collection('departments')
            .add({
              'name': name,
              'createdAt': Timestamp.now(),
              'webhookUrl':
                  'http://localhost:5678/webhook-test/ddda45c7-ce0c-4340-9c36-7fe2f64ecd63',
            });

        // Reload departments
        await _loadDepartments();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Department "$name" created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating department: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, Routes.landing);
  }

  Future<void> _generateReport(String period) async {
    final int days;
    final String reportLabel;
    switch (period) {
      case 'monthly':
        days = 30;
        reportLabel = 'Monthly';
        break;
      case 'yearly':
        days = 365;
        reportLabel = 'Yearly';
        break;
      default:
        days = 7;
        reportLabel = 'Weekly';
    }

    final cutoff = DateTime.now().subtract(Duration(days: days));
    final weeklyMessages = _allFeedbackMessages.where((msg) {
      final date = _getFeedbackDate(msg);
      return date.isAfter(cutoff);
    }).toList();

    // Check if there's any feedback in this period
    if (weeklyMessages.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Feedback'),
          content: Text('No feedback received in the last $days days yet.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate statistics
    final totalThisWeek = weeklyMessages.length;
    final positiveThisWeek = weeklyMessages
        .where(
          (msg) => msg['sentiment']?.toString().toLowerCase() == 'positive',
        )
        .length;
    final negativeThisWeek = weeklyMessages
        .where(
          (msg) => msg['sentiment']?.toString().toLowerCase() == 'negative',
        )
        .length;
    final sentimentPercentage = totalThisWeek > 0
        ? (positiveThisWeek / totalThisWeek * 100).toStringAsFixed(1)
        : '0.0';

    // Department breakdown
    final departmentBreakdown = <String, int>{};
    for (var msg in weeklyMessages) {
      final dept = msg['department']?.toString() ?? 'General';
      departmentBreakdown[dept] = (departmentBreakdown[dept] ?? 0) + 1;
    }

    // Date range formatting
    final endDate = DateTime.now();
    final startDate = cutoff;
    final dateRange = '${_formatDate(startDate)} - ${_formatDate(endDate)}';

    // Generate HTML report
    final reportHtml =
        '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CustoFlow $reportLabel Report</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; padding: 20px; }
    .container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 12px 12px 0 0; }
    .header h1 { font-size: 32px; margin-bottom: 8px; }
    .header p { font-size: 18px; opacity: 0.9; }
    .content { padding: 40px; }
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 40px; }
    .stat-card { background: #f8f9fa; padding: 24px; border-radius: 8px; border-left: 4px solid #667eea; }
    .stat-card h3 { font-size: 14px; color: #666; text-transform: uppercase; margin-bottom: 8px; }
    .stat-card .value { font-size: 36px; font-weight: bold; color: #333; }
    .stat-card.positive { border-left-color: #4CAF50; }
    .stat-card.positive .value { color: #4CAF50; }
    .stat-card.negative { border-left-color: #f44336; }
    .stat-card.negative .value { color: #f44336; }
    .section { margin-bottom: 40px; }
    .section h2 { font-size: 24px; margin-bottom: 16px; color: #333; }
    .sentiment-bar { height: 40px; border-radius: 8px; overflow: hidden; display: flex; margin-bottom: 8px; }
    .sentiment-bar .positive { background: #4CAF50; }
    .sentiment-bar .negative { background: #f44336; }
    .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
    .table th { background: #667eea; color: white; padding: 12px; text-align: left; }
    .table td { padding: 12px; border-bottom: 1px solid #eee; }
    .table tr:hover { background: #f8f9fa; }
    .feedback-list { display: flex; flex-direction: column; gap: 16px; }
    .feedback-item { background: #f8f9fa; padding: 20px; border-radius: 8px; border-left: 4px solid #667eea; }
    .feedback-item.positive { border-left-color: #4CAF50; }
    .feedback-item.negative { border-left-color: #f44336; }
    .feedback-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; flex-wrap: wrap; gap: 8px; }
    .feedback-meta { display: flex; gap: 8px; flex-wrap: wrap; }
    .chip { display: inline-block; padding: 4px 12px; border-radius: 16px; font-size: 12px; font-weight: 600; }
    .chip.positive { background: #e8f5e9; color: #4CAF50; }
    .chip.negative { background: #ffebee; color: #f44336; }
    .chip.department { background: #e3f2fd; color: #2196F3; }
    .feedback-message { font-size: 16px; color: #333; line-height: 1.6; margin-bottom: 8px; }
    .feedback-email { font-size: 14px; color: #666; }
    .footer { background: #f8f9fa; padding: 20px 40px; border-radius: 0 0 12px 12px; text-align: center; color: #666; font-size: 14px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>${_companyData?['name'] ?? 'Company'} - $reportLabel Feedback Report</h1>
      <p>Week of $dateRange</p>
    </div>
    
    <div class="content">
      <div class="stats-grid">
        <div class="stat-card">
          <h3>Total Feedback</h3>
          <div class="value">$totalThisWeek</div>
        </div>
        <div class="stat-card positive">
          <h3>Positive</h3>
          <div class="value">$positiveThisWeek</div>
        </div>
        <div class="stat-card negative">
          <h3>Negative</h3>
          <div class="value">$negativeThisWeek</div>
        </div>
      </div>

      <div class="section">
        <h2>Sentiment Distribution</h2>
        <div class="sentiment-bar">
          <div class="positive" style="width: $sentimentPercentage%;"></div>
          <div class="negative" style="width: ${100 - double.parse(sentimentPercentage)}%;"></div>
        </div>
        <p style="color: #666; font-size: 14px;">$sentimentPercentage% Positive, ${(100 - double.parse(sentimentPercentage)).toStringAsFixed(1)}% Negative</p>
      </div>

      <div class="section">
        <h2>Department Breakdown</h2>
        <table class="table">
          <thead>
            <tr>
              <th>Department</th>
              <th>Feedback Count</th>
            </tr>
          </thead>
          <tbody>
            ${departmentBreakdown.entries.map((e) => '<tr><td>${e.key}</td><td>${e.value}</td></tr>').join('\n            ')}
          </tbody>
        </table>
      </div>

      <div class="section">
        <h2>All Feedback This Week</h2>
        <div class="feedback-list">
          ${weeklyMessages.map((msg) {
          final sentiment = msg['sentiment']?.toString().toLowerCase() ?? 'neutral';
          final message = msg['message']?.toString() ?? 'No message';
          final email = msg['email']?.toString() ?? 'No email';
          final department = msg['department']?.toString() ?? 'General';
          final date = _getFeedbackDate(msg);
          final formattedDate = _formatDateTime(date);

          return '''
          <div class="feedback-item $sentiment">
            <div class="feedback-header">
              <div class="feedback-meta">
                <span class="chip department">$department</span>
                <span class="chip $sentiment">${sentiment.toUpperCase()}</span>
              </div>
              <span style="color: #999; font-size: 13px;">$formattedDate</span>
            </div>
            <div class="feedback-message">"$message"</div>
            <div class="feedback-email">From: $email</div>
          </div>
''';
        }).join('\n          ')}
        </div>
      </div>
    </div>
    
    <div class="footer">
      <p>Generated by CustoFlow on ${_formatDateTime(DateTime.now())}</p>
    </div>
  </div>
</body>
</html>
''';

    // Download the HTML file
    try {
      final blob = html.Blob([reportHtml], 'text/html');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute(
          'download',
          'custoflow_${reportLabel.toLowerCase()}_report_${DateTime.now().millisecondsSinceEpoch}.html',
        )
        ..click();
      html.Url.revokeObjectUrl(url);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$reportLabel report downloaded successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading report: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
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
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateTime(DateTime date) {
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
      'Dec',
    ];
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  void _showIntegrationGuide() {
    final htmlCode = _generateIntegrationHtml();
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header - Fixed at top
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.integration_instructions,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Integration Guide',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add CustoFlow feedback form to your website',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instructions Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb,
                                    color: Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'How to Integrate',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildIntegrationStep(
                                '1',
                                'Copy the HTML code below',
                              ),
                              const SizedBox(height: 8),
                              _buildIntegrationStep(
                                '2',
                                'Paste it into your website where you want the feedback form',
                              ),
                              const SizedBox(height: 8),
                              _buildIntegrationStep(
                                '3',
                                'That\'s it! Your form is ready to collect feedback',
                              ),
                              const SizedBox(height: 16),
                              // OR Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.blue.shade300,
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.blue.shade300,
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Step 4 - VS Code Copilot Alternative
                              _buildCopilotStep(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Code Section - Inline Display
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF667eea,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.code,
                                          color: Color(0xFF667eea),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Integration Code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: htmlCode),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Code copied to clipboard!',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.copy, size: 16),
                                    label: const Text('Copy'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF667eea),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                constraints: const BoxConstraints(
                                  maxHeight: 400,
                                ),
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    htmlCode,
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Footer Info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.amber.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'This code includes your API key and all your departments. Feedback will be automatically saved to your CustoFlow dashboard.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isMobile ? 16 : 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIntegrationStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF667eea),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _buildCopilotStep() {
    final apiKey = _companyData?['apiKey'] ?? 'YOUR_API_KEY';
    final companyId = _auth.currentUser?.uid ?? 'YOUR_COMPANY_ID';
    final adminEmail = _companyData?['adminEmail'] ?? 'YOUR_ADMIN_EMAIL';

    final copilotPrompt =
        'When the (your button name) is clicked, prompt the user for their feedback message and email address. Then send data as a POST request to http://localhost:5678/webhook-test/fd5bcb27-a283-45e1-ae9b-fba435fe24ba with a JSON body containing: message (the user\'s feedback), email (the customer\'s email address), adminEmail (set to "$adminEmail"), timestamp (current ISO timestamp), companyId: "$companyId", and apiKey: "$apiKey". Validate that the email format is correct before sending. Show a success message after sending.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.purple.shade400,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Colors.purple.shade400,
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Use VS Code Copilot to generate the code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 36),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Paste this to VS Code Copilot:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: copilotPrompt));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copilot prompt copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 14),
                    label: const Text('Copy'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.purple.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SelectableText(
                  copilotPrompt,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Colors.grey.shade800,
                    fontFamily: 'Courier',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Copilot will generate the code automatically with your credentials',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Generate the HTML code for integration
  String _generateIntegrationHtml() {
    final apiKey = _companyData?['apiKey'] ?? 'YOUR_API_KEY';
    final companyId = _auth.currentUser?.uid ?? 'YOUR_COMPANY_ID';

    return '''

<script>
async function sendFeedback() {
  const message = prompt('Share your feedback or report an issue:') || '';
  
  // Validate that message is not empty
  if (!message.trim()) {
    alert('Please enter your feedback before submitting.');
    return;
  }
  
  try {
    const response = await fetch('http://localhost:5678/webhook-test/fd5bcb27-a283-45e1-ae9b-fba435fe24ba', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        message: message,
        timestamp: new Date().toISOString(),
        companyId: '$companyId',
        apiKey: '$apiKey'
      })
    });
    
    if (response.ok) {
      alert('Thank you for your feedback!');
    } else {
      alert('Failed to send feedback. Please try again.');
    }
  } catch (error) {
    console.error('Error sending feedback:', error);
    alert('An error occurred. Please try again later.');
  }
}
</script>''';
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

  double _getPadding(BuildContext context) {
    if (_isMobile(context)) return 16;
    if (_isTablet(context)) return 24;
    return 32;
  }

  int _getCrossAxisCount(BuildContext context) {
    if (_isMobile(context)) return 1;
    if (_isTablet(context)) return 2;
    return 3;
  }

  /// Build method
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    final padding = _getPadding(context);
    final isMobile = _isMobile(context);
    final crossAxisCount = _getCrossAxisCount(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _companyData?['name'] ?? 'Dashboard',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.assessment, color: Colors.white),
            tooltip: 'Download Report',
            onSelected: _generateReport,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'weekly',
                child: Text('Weekly Report (7 days)'),
              ),
              PopupMenuItem(
                value: 'monthly',
                child: Text('Monthly Report (30 days)'),
              ),
              PopupMenuItem(
                value: 'yearly',
                child: Text('Yearly Report (365 days)'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.integration_instructions),
            onPressed: _showIntegrationGuide,
            tooltip: 'Integration Guide',
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showOnboardingDialog,
            tooltip: 'Help',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF667eea).withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF667eea).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: Color(0xFF667eea),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _companyData?['name'] ?? 'Your Company',
                                  style: TextStyle(
                                    fontSize: isMobile ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _companyData?['adminEmail'] ?? '',
                                  style: TextStyle(
                                    fontSize: isMobile ? 13 : 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.key, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          const Text(
                            'API Key: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              _companyData?['apiKey'] ?? 'Loading...',
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _companyData?['apiKey'] ?? '',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('API Key copied!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: padding),

              // Analytics Section
              Text(
                'Analytics Overview',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: padding / 2),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 1.5 : 1.8,
                children: [
                  _buildAnalyticsCard(
                    'Total Feedback',
                    _totalFeedback.toString(),
                    Icons.feedback,
                    Colors.blue,
                    isMobile,
                  ),
                  _buildAnalyticsCard(
                    'Positive',
                    _positiveFeedback.toString(),
                    Icons.thumb_up,
                    Colors.green,
                    isMobile,
                  ),
                  _buildAnalyticsCard(
                    'Negative',
                    _negativeFeedback.toString(),
                    Icons.thumb_down,
                    Colors.red,
                    isMobile,
                  ),
                ],
              ),
              SizedBox(height: padding),

              _buildChartsSection(isMobile, padding),
              SizedBox(height: padding),

              _buildFeedbackMessageFeed(isMobile, padding),
              SizedBox(height: padding),

              // Departments Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Departments',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreateDepartmentDialog,
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(isMobile ? 'Add' : 'Add Department'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding / 2),

              if (_departments.isEmpty)
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(padding * 2),
                    child: Column(
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Departments Yet',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first department to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: isMobile ? 13 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _departments.length,
                  itemBuilder: (context, index) {
                    final dept = _departments[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667eea).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.business_center,
                            color: Color(0xFF667eea),
                          ),
                        ),
                        title: Text(
                          dept['name'] ?? 'Department',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          dept['webhookUrl'] ?? '',
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: dept['webhookUrl'] ?? ''),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Webhook URL copied!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: _showCreateDepartmentDialog,
              backgroundColor: const Color(0xFF667eea),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: isMobile ? 28 : 32),
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
