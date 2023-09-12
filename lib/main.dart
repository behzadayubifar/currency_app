import 'package:currency_app/Model/Currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String lorem1 =
        "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز ";

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Farsi
        // Locale('en'), // English
      ],
      theme: ThemeData(
        fontFamily: 'estedad',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'estedad',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          bodySmall: TextStyle(
            fontFamily: 'estedad',
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'estedad',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'estedad',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(lorem1: lorem1),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.lorem1,
  });

  final String lorem1;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency = [];

  Future getResponse(BuildContext cntx) async {
    String url =
        "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
    var value = await http.get(Uri.parse(url)).then((value) {
      if (currency.isEmpty) {
        if (value.statusCode == 200) {
          _showSnackBar(cntx, "به‌روزرسانی اطلاعات با موفقیت انجام شد");
          List jsonList = convert.jsonDecode(value.body);

          if (jsonList.isNotEmpty) {
            setState(() {
              for (int i = 0; i < jsonList.length; i++) {
                currency.add(
                  Currency(
                    id: jsonList[i]["id"],
                    title: jsonList[i]["title"],
                    price: jsonList[i]["price"],
                    changes: jsonList[i]["changes"],
                    status: jsonList[i]["status"],
                  ),
                );
              }
            });
          }
        }
      }
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme myTextTheme = Theme.of(context).textTheme;
    getResponse(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(221, 1, 0, 39),
        actions: [
          const SizedBox(width: 8),
          Image.asset(
            "assets/images/icons8-money-bag-bitcoin-94.png",
            width: 45,
            height: 45,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "قیمت به‌روز سکه و ارز",
              style: Theme.of(context).textTheme.displayLarge!.apply(
                    color: Colors.white,
                  ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/images/icons8-menu-94.png",
                width: 40,
                height: 40,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/icons8-question-94.png",
                      width: 50),
                  const SizedBox(width: 8),
                  Text("نرخ ارز آزاد چیست؟", style: myTextTheme.displayLarge),
                ],
              ),
              const SizedBox(height: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.lorem1, style: myTextTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 130, 130, 130),
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "نام ارز",
                        style: myTextTheme.bodyLarge!.apply(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "قیمت",
                        style: myTextTheme.bodyLarge!.apply(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "تغییر",
                        style: myTextTheme.bodyLarge!.apply(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 350,
                child: FutureBuilder(
                  future: getResponse(context),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.hasData
                        ? ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: currency.length,
                            itemBuilder: (BuildContext context, int position) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: MyItem(
                                  currency: currency,
                                  position: position,
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              if (index != 0 && ((index % 9) == 0)) {
                                return const Adds();
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 232, 232, 232),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 202, 193, 255)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                            ),
                          ),
                          onPressed: () => _showSnackBar(
                              context, "به‌روزرسانی با موفقیت انجام شد"),
                          icon: const Icon(
                            Icons.refresh_outlined,
                            // CupertinoIcons.refresh_bold,
                            color: Colors.black,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              "به‌روزرسانی",
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text("آخرین به‌روز رسانی ${_getTime()}")
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getTime() {
    return "20:45";
  }
}

void _showSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    backgroundColor: Colors.green,
  ));
}

class MyItem extends StatelessWidget {
  final List<Currency> currency;
  final int position;
  const MyItem({
    super.key,
    required this.currency,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            currency[position].title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            currency[position].price!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            currency[position].changes!,
            style: Theme.of(context).textTheme.bodyMedium!.apply(
                color: currency[position].status == "n"
                    ? Colors.red
                    : Colors.green),
          ),
        ],
      ),
    );
  }
}

class Adds extends StatelessWidget {
  const Adds({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 1.0, color: Colors.grey)
        ],
        color: Colors.red,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "تبلیغات",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}
