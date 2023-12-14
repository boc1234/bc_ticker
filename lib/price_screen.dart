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

  Future getCurrentRate()async{
    var response = await dio.get("https://rest.coinapi.io/v1/exchangerate/BTC/USD",queryParameters: {'apikey':'4F67CCAA-44B4-4BED-A3E3-2662E44D9FD7'});
    var rateData = response.data;
    updateUI(rateData);

  }
  void updateUI(dynamic rateData){
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
        });
      },
    );
  }

  CupertinoPicker iOSPicker(){
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {},
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


  @override
  void initState() {
    super.initState();
    getCurrentRate();

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
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '1 BTC = $rate USD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
