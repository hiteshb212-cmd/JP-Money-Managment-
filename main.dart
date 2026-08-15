import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JPMoneyApp());
}

class JPMoneyApp extends StatelessWidget {
  const JPMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp
        import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('JP MONEY MANAGEMENT '))),
    );
  }
}

      title: 'JP Money Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3C72),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        fontFamily: 'Roboto',
      ),
      home: const AuthLockScreen(),
    );
  }
}

// ==================== 1. BIOMETRIC SECURITY SCREEN ====================
class AuthLockScreen extends StatefulWidget {
  const AuthLockScreen({super.key});

  @override
  State<AuthLockScreen> createState() => _AuthLockScreenState();
}

class _AuthLockScreenState extends State<AuthLockScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _statusMessage = 'App is Locked';

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _statusMessage = 'Scanning Fingerprint / Face...';
      });

      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        _goToHome();
        return;
      }

      authenticated = await _auth.authenticate(
        localizedReason: 'Unlock JP Money Management to access your vault',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Authentication Failed: Tap icon to retry';
      });
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }

    if (authenticated) {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3C72),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'JP Money Hub',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _isAuthenticating ? null : _authenticateUser,
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text('Unlock with Biometrics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3C72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _goToHome,
                  child: const Text(
                    'Skip / Demo Mode',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 2. MAIN DASHBOARD SCREEN ====================
class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final bool isExpense;
  final String category;
  final DateTime date;
  final IconData icon;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.category,
    required this.date,
    required this.icon,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TransactionItem> _transactions = [
    TransactionItem(
      id: '1',
      title: 'Salary & Business Income',
      amount: 52000,
      isExpense: false,
      category: 'Income',
      date: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.account_balance_wallet_rounded,
    ),
    TransactionItem(
      id: '2',
      title: 'Ghar Kharch & Ration',
      amount: 4500,
      isExpense: true,
      category: 'Ghar Kharch',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      icon: Icons.home_rounded,
    ),
    TransactionItem(
      id: '3',
      title: 'Khedut Mandi / Agro Sale',
      amount: 18450,
      isExpense: false,
      category: 'Kheti & Dairy',
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.agriculture_rounded,
    ),
    TransactionItem(
      id: '4',
      title: 'Trading & Equity Investment',
      amount: 12000,
      isExpense: true,
      category: 'Investment',
      date: DateTime.now().subtract(const Duration(days: 3)),
      icon: Icons.candlestick_chart_rounded,
    ),
  ];

  double get _totalIncome => _transactions
      .where((item) => !item.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _totalExpense => _transactions
      .where((item) => item.isExpense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get _netBalance => _totalIncome - _totalExpense;

  void _addNewTransaction(
      String title, double amount, bool isExpense, String category) {
    IconData icon = Icons.shopping_bag_rounded;
    if (category == 'Ghar Kharch') icon = Icons.home_rounded;
    if (category == 'Kheti & Dairy') icon = Icons.agriculture_rounded;
    if (category == 'Investment') icon = Icons.candlestick_chart_rounded;
    if (category == 'Bills & Utilities') icon = Icons.receipt_long_rounded;
    if (category == 'Income') icon = Icons.account_balance_wallet_rounded;

    final newItem = TransactionItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      isExpense: isExpense,
      category: category,
      date: DateTime.now(),
      icon: icon,
    );

    setState(() {
      _transactions.insert(0, newItem);
    });
  }

  void _openAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _AddTransactionModal(onAdd: _addNewTransaction),
    );
  }

  void _openCalculatorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => const _SmartCalculatorModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3C72).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_wallet_rounded,
                  color: Color(0xFF1E3C72)),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JP Money Management',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  'Safe & Secured Vault',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Smart Calculator',
            onPressed: () => _openCalculatorDialog(context),
            icon: const Icon(Icons.calculate_rounded,
                color: Color(0xFF1E3C72), size: 28),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3C72).withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.verified_user_rounded,
                          color: Colors.white70, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${_netBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Income',
                          amount: _totalIncome,
                          icon: Icons.arrow_downward_rounded,
                          color: const Color(0xFF00E676),
                        ),
                      ),
                      Container(height: 36, width: 1, color: Colors.white24),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Expense',
                          amount: _totalExpense,
                          icon: Icons.arrow_upward_rounded,
                          color: const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Category Summary Tiles
            const Text(
              'Key Portfolios',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryCard(
                    'Ghar Kharch',
                    'Family & Home',
                    '₹45,280',
                    Icons.home_rounded,
                    const Color(0xFFE8F5E9),
                    const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCategoryCard(
                    'Kheti & Dairy',
                    'Khedut Mandi Log',
                    '₹1,84,500',
                    Icons.agriculture_rounded,
                    const Color(0xFFFFF3E0),
                    const Color(0xFFE65100),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All',
                      style: TextStyle(color: Color(0xFF1E3C72))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Transactions List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _transactions[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (item.isExpense ? Colors.red : Colors.green)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: item.isExpense ? Colors.red : Colors.green,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.category} • ${_formatDate(item.date)}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${item.isExpense ? '-' : '+'}₹${item.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: item.isExpense
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTransactionSheet(context),
        backgroundColor: const Color(0xFF1E3C72),
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Entry',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String sub, String val, IconData icon,
      Color bg, Color accent) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87),
          ),
          Text(
            sub,
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
          const SizedBox(height: 6),
          Text(
            val,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: accent),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ==================== 3. SMART CALCULATION SHEET ====================
class _SmartCalculatorModal extends StatefulWidget {
  const _SmartCalculatorModal();

  @override
  State<_SmartCalculatorModal> createState() => _SmartCalculatorModalState();
}

class _SmartCalculatorModalState extends State<_SmartCalculatorModal> {
  String _input = '0';
  double _firstOperand = 0;
  String _operator = '';
  bool _shouldResetInput = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '0';
        _firstOperand = 0;
        _operator = '';
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        _firstOperand = double.tryParse(_input) ?? 0;
        _operator = value;
        _shouldResetInput = true;
      } else if (value == '=') {
        double secondOperand = double.tryParse(_input) ?? 0;
        double result = 0;
        if (_operator == '+') result = _firstOperand + secondOperand;
        if (_operator == '-') result = _firstOperand - secondOperand;
        if (_operator == '×') result = _firstOperand * secondOperand;
        if (_operator == '÷') {
          result = secondOperand != 0 ? _firstOperand / secondOperand : 0;
        }
        _input = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
        _operator = '';
      } else {
        if (_input == '0' || _shouldResetInput) {
          _input = value;
          _shouldResetInput = false;
        } else {
          _input += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quick Money Calculator',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _input,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3C72)),
            ),
          ),
          const SizedBox(height: 16),
          for (var row in buttons)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row.map((btn) {
                  final isOp = ['+', '-', '×', '÷', '='].contains(btn);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isOp ? const Color(0xFF1E3C72) : Colors.white,
                          foregroundColor: isOp ? Colors.white : Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _onButtonPressed(btn),
                        child: Text(btn,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== 4. ADD TRANSACTION MODAL ====================
class _AddTransactionModal extends StatefulWidget {
  final Function(String title, double amount, bool isExpense, String category)
      onAdd;

  const _AddTransactionModal({required this.onAdd});

  @override
  State<_AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<_AddTransactionModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isExpense = true;
  String _selectedCategory = 'Ghar Kharch';

  final List<String> _expenseCategories = [
    'Ghar Kharch',
    'Bills & Utilities',
    'Investment',
    'Shopping',
    'Travel',
    'Other'
  ];
  final List<String> _incomeCategories = [
    'Income',
    'Kheti & Dairy',
    'Trading Profit',
    'Bonus & Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Transaction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Expense')),
                  selected: _isExpense,
                  selectedColor: Colors.red.withOpacity(0.2),
                  onSelected: (val) {
                    setState(() {
                      _isExpense = true;
                      _selectedCategory = _expenseCategories.first;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Income')),
                  selected: !_isExpense,
                  selectedColor: Colors.green.withOpacity(0.2),
                  onSelected: (val) {
                    setState(() {
                      _isExpense = false;
                      _selectedCategory = _incomeCategories.first;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Description / Title',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.edit_note_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount (₹)',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.currency_rupee_rounded),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.category_rounded),
            ),
            items: (_isExpense ? _expenseCategories : _incomeCategories)
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3C72),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final title = _titleController.text.trim();
                final amount = double.tryParse(_amountController.text.trim());
                if (title.isEmpty || amount == null || amount <= 0) return;

                widget.onAdd(title, amount, _isExpense, _selectedCategory);
                Navigator.pop(context);
              },
              child: const Text(
                'Save Transaction',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

