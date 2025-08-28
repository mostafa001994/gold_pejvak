import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(GoldCalculatorApp());
}

class GoldCalculatorApp extends StatelessWidget {
  const GoldCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ماشین‌حساب طلا',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'irsans', primarySwatch: Colors.amber),
      home: GoldCalculatorScreen(),
    );
  }
}

class GoldCalculatorScreen extends StatefulWidget {
  const GoldCalculatorScreen({super.key});

  @override
  State<GoldCalculatorScreen> createState() => _GoldCalculatorScreenState();
}

class _GoldCalculatorScreenState extends State<GoldCalculatorScreen> {
  final priceController = TextEditingController();
  final wageController = TextEditingController();
  final profitController = TextEditingController();
  final taxController = TextEditingController();
  final weightController = TextEditingController();

  double result = 0;

  void calculatePrice() {
    // جدید (درست)
    double price = parseFormattedInput(priceController.text);
    double wage = double.tryParse(wageController.text) ?? 0;
    double profit = double.tryParse(profitController.text) ?? 0;
    double tax = double.tryParse(taxController.text) ?? 0;
    double weight = parseFormattedInput(weightController.text);
    double base = price * weight;
    double wageAmount = base * wage / 100;
    double profitAmount = (base + wageAmount) * profit / 100;
    double taxAmount = (base + wageAmount + profitAmount) * tax / 100;

    setState(() {
      result = base + wageAmount + profitAmount + taxAmount;
    });
  }

  void resetFields() {
    priceController.clear();
    wageController.clear();
    profitController.clear();
    taxController.clear();
    weightController.clear();
    setState(() {
      result = 0;
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    final needsFormatter = label == 'قیمت هر گرم طلا' || label.contains('وزن');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: needsFormatter ? [PersianCurrencyFormatter()] : [],
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white30, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: flutter.TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFF2d0408),
        body: Column(
          children: [
            SizedBox(height: 40),
            ShinyLogo(), // لوگو همیشه بالا نمایش داده می‌شه
            SizedBox(height: 0), // 👈 فاصله‌ی کمتر تا فرم
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      buildTextField('قیمت هر گرم طلا', priceController),
                      buildTextField('درصد اجرت', wageController),
                      buildTextField('درصد سود', profitController),
                      buildTextField('درصد مالیات', taxController),
                      buildTextField('وزن (گرم)', weightController),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xff77070b),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: Icon(Icons.calculate, size: 24.0),
                        label: Text('محاسبه', style: TextStyle(fontSize: 18)),
                        onPressed: calculatePrice,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 36, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'قیمت نهایی:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: resetFields,
                                  icon: Icon(Icons.clear, color: Colors.white),
                                  label: Text(
                                    'پاک کردن',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0x8e5c1016),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${NumberFormat("#,##0.##", "fa").format(result)} تومان',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () async {
                              const url = 'https://www.instagram.com/goldpejvak_fantezi';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0x90F58529),
                                    Color(0x90DD2A7B),
                                    Color(0x908134AF),
                                    Color(0x90515BD4),
                                  ],

                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.link, color: Colors.white), // یا آیکون اینستاگرام
                                  SizedBox(width: 8),
                                  Text(
                                    'رفتن به پیج اینستاگرام',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ],

                              ),
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShinyLogo extends StatefulWidget {
  const ShinyLogo({super.key});

  @override
  State<ShinyLogo> createState() => _ShinyLogoState();
}

class _ShinyLogoState extends State<ShinyLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [
                Colors.transparent,
                const Color.fromARGB(
                  179,
                  255,
                  191,
                  0,
                ), // معادل Colors.amberAccent با شفافیت 0.7
                Colors.transparent,
              ],
              stops: [0.2, 0.5, 0.8],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Image.asset('assets/logo.webp', height: 100),
        );
      },
    );
  }
}

class PersianCurrencyFormatter extends TextInputFormatter {
  final NumberFormat formatter = NumberFormat("#,##0.##", "en");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final raw = newValue.text
        .replaceAll(',', '')
        .replaceAll('٫', '.')
        .replaceAll(RegExp(r'[^\d.]'), '');

    // اگر کاربر حذف کامل انجام داده یا ورودی خالیه
    if (raw.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // جلوگیری از چند نقطه اعشار
    if ('.'.allMatches(raw).length > 1) return oldValue;

    final number = double.tryParse(raw);
    if (number == null) return newValue;

    final formatted = formatter.format(number);

    // کرسر نسبت به انتهای متن تنظیم بشه
    final diff = formatted.length - raw.length;
    var newOffset = newValue.selection.baseOffset + diff;
    newOffset = newOffset.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

double parseFormattedInput(String text) {
  return double.tryParse(
    text
        .replaceAll(',', '')
        .replaceAll('٫', '.')
        .replaceAll(RegExp(r'[^\d.]'), ''),
  ) ??
      0;
}
