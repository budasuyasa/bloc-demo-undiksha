import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:undiksha02/event/buku_event.dart';
import 'package:undiksha02/state/buku_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:undiksha02/entity/buku.dart';

class BlocBuku extends Bloc<BukuEvent, BukuState> {
  final http.Client httpClient;

  BlocBuku({required this.httpClient}) : super(InitBuku());

  // jika terjadi sebuah event, maka lakukan perubahan state
  @override
  Stream<BukuState> mapEventToState(BukuEvent event) async* {
    if (event is FetchBuku) {
      // mengambil data JOSN dari REST API
      // yield InitBuku();
      try {
        final response =
            await http.get(Uri.parse('http://localhost:8000/api/buku'));
        if (response.statusCode == 200) {
          // melakukan proses decoding string JSON ke List of Buku
          print(response.body);
          final data = jsonDecode(response.body) as List;
          final daftarBuku =
              data.map((stringMentah) => Buku.fromJson(stringMentah)).toList();
          // emit data buku yang sudah diambil dari REST API
          yield (LoadedBuku(buku: daftarBuku));
        }
      } catch (error) {
        print("Terjadi error $error");
        yield ErrorBuku();
      }
    } else if (event is PostBuku) {
      // post buku ke rest api
    } else if (event is UpdateBuku) {
      // post buku ke rest api
    } else if (event is DeleteBuku) {
      // post buku ke rest api
    }
  }
}