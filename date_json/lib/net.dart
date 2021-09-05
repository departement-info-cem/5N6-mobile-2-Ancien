import 'package:date_json/dto.dart';
import 'package:dio/dio.dart';

var base_url = "https://exercices-web.herokuapp.com/";

Future<TrucAvecUneDate> envoiLeDonc(TrucAvecUneDate truc ) async   {
  Dio dio = Dio();
  Response response = await dio.post(
    base_url + "exos/date",
    data: truc    // TODO ca va automatiquement appeler toJson
  );
  if (response.statusCode == 200 || response.statusCode == 201){
    return TrucAvecUneDate.fromJson(response.data) as TrucAvecUneDate;
  } else {
    throw Exception("bimTypedPost");
  }
}