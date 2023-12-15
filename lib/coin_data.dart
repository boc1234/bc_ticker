
import 'package:dio/dio.dart';

final dio = Dio();
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];
const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getCoin(String selectCurrency) async {
    Map<String,String> cryptoPrice = {};
    for (String item in cryptoList) {
      var response = await dio.get(
          "https://rest.coinapi.io/v1/exchangerate/$item/$selectCurrency",
          queryParameters: {'apikey': '4F67CCAA-44B4-4BED-A3E3-2662E44D9FD7'});
      if(response.statusCode == 200){
        double rate = response.data['rate'];
        cryptoPrice[item] = rate.toStringAsFixed(0);
        print(response.data);
      }else{
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }


    return cryptoPrice;
  }
}
