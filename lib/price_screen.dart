import 'package:bc_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:dio/dio.dart';

final dio = Dio();

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  late String selectCurrency = "USD";
  late String rate = "?";



  void updateUI(dynamic rateData) {
    setState(() {
      int rateInt = rateData['rate'].toInt();
      rate = rateInt.toString();
    });
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem> dropdownCurrency = [];
    for (String item in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      dropdownCurrency.add(newItem);
    }

    return DropdownButton(
      value: selectCurrency,
      items: dropdownCurrency,
      onChanged: (value) {
        setState(() {
          selectCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        selectCurrency = currenciesList[index];
      },
      children: currenciesList.map((item) => Text(item)).toList(),
    );
  }

  // List<Text> getPickerItem() {
  //   List<Text> pickerCurrency = [];
  //   for (String item in currenciesList) {
  //     var newItem = Text(item);
  //     pickerCurrency.add(newItem);
  //   }
  //   return pickerCurrency;
  // }
  Map<String,String> coinValue ={};
  bool isWaiting = true;

  Future<void> getData()async{
    print(1);
    CoinData coinData = CoinData();
    try {
      var data = await coinData.getCoin(selectCurrency);
      isWaiting = false;
      setState(() {
        coinValue = data;
      });
    }catch(e){
      print(e);
    }

  }
  Column makeCard() {
    List<CryptoCard> card = [];
    for (String crypto in cryptoList) {
      card.add(
          CryptoCard(rate: isWaiting ? '?': coinValue[crypto] ?? 'Error', selectCurrency: selectCurrency, crypto: crypto));
    }
    return Column(
      children: card,
    );
  }


  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.rate,
    required this.selectCurrency,
    required this.crypto,
  });
  final String crypto;
  final String rate;
  final String selectCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate $selectCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
