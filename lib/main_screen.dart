import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'decimal_formatter.dart';

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final TextEditingController cost = TextEditingController();
  final TextEditingController fee = TextEditingController();
  final TextEditingController discount = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController margin = TextEditingController();
  bool _priceEnabled = true;
  bool _marginEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora"),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: cost,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DecimalInputFormatter()
                  ],
                  decoration: InputDecoration(
                      prefix: Text('R\$ '),
                      border: OutlineInputBorder(),
                      labelText: 'Custo'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: fee,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DecimalInputFormatter()
                  ],
                  decoration: InputDecoration(
                    suffix: Text(' %'),
                      border: OutlineInputBorder(),
                      labelText: 'Impostos'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: discount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DecimalInputFormatter()
                  ],
                  decoration: InputDecoration(
                      suffix: Text(' %'),
                      border: OutlineInputBorder(),
                      labelText: 'Desc. Fin'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  onTap: (){
                    setState(() {
                      margin.text = '';
                      _marginEnabled = false;
                    });
                  },
                  controller: price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DecimalInputFormatter()
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefix: Text('R\$ '),
                      labelText: 'Preço'
                  ),
                ),
              ),
              TextFormField(
                controller: margin,
                onTap: (){
                  setState(() {
                    price.text = '';
                    _priceEnabled = false;
                  });
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  DecimalInputFormatter()
                ],
                decoration: InputDecoration(
                    suffix: Text(' %'),
                    border: OutlineInputBorder(),
                    labelText: 'Margem'
                ),
              ),
              Row(
                children: [
                  Expanded(flex: 5, child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: RaisedButton(child: Text("Calcular Margem"),onPressed: () => calcMargin(),),
                  )),
                  Expanded(flex: 5, child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: RaisedButton(child: Text("Calcular Preço"),onPressed: () => calcPrice()),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void calcMargin(){
    double _price = parseDouble(price.text);
    double _cost = parseDouble(cost.text);
    double _fee = parseDouble(fee.text);
    double _discount = parseDouble(discount.text);

    double result = (((_price - _cost)/_price) - (_fee + _discount)) * 100;

    setState(() {
      debugPrint(result.toString());
      margin.text = parseString(result);
    });
  }
  void calcPrice(){
    double _margin = parseDouble(margin.text)/100;
    double _cost = parseDouble(cost.text);
    double _fee = parseDouble(fee.text)/100;
    double _discount = parseDouble(discount.text)/100;

    double result = (_cost / (1-(_fee + _discount + _margin)));

    setState(() {
      price.text = parseString(result);
    });
  }

  double parseDouble (String str){
    return NumberFormat('#,##0.00', 'pt_BR').parse(str);
  }

  String parseString (double db){
    return NumberFormat('#,##0.00', 'pt_BR').format(db);
  }
}

