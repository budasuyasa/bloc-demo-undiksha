import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Membuat class Buku untuk menampung data buku
// dan menambahkan factory method untuk mengubah
// json menjadi instance dari Buku

class Buku {
  final String isbn;
  final String judul;
  final String penulis;
  final String tanggalTerbit;

  Buku(
      {required this.isbn,
      required this.judul,
      required this.penulis,
      required this.tanggalTerbit});

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      isbn: json['isbn'],
      judul: json['judul'],
      penulis: json['pengarang'],
      tanggalTerbit: json['tahun_terbit'],
    );
  }
}

// Buku event yang akan digunakan untuk mengambil data dari API
// contoh mendapatkan buku dengan Fetch buku
abstract class BukuEvent {}

class FetchBuku extends BukuEvent {}

// Base abstract class untuk semua state buku
// - Ketika melakukan fetch data dengan method GET
// - Ketika error terjadi
// - Ketika data berhasil di load

abstract class BukuState {}

// InitBuku adalah event ketika
class InitBuku extends BukuState {}

class ErrorBuku extends BukuState {}

// menambahkan list buku ketika BukuLoaded terjadi
class BukuLoaded extends BukuState {
  final List<Buku> buku;

  BukuLoaded({required this.buku});
}

class BukuBloc extends Bloc<BukuEvent, BukuState> {
  final http.Client httpClient;

  BukuBloc({required this.httpClient}) : super(InitBuku());

  @override
  Stream<BukuState> mapEventToState(BukuEvent event) async* {
    if (event is FetchBuku) {
      // emit InitBuku sebelum
      // data belum berhasil didapatkan
      yield InitBuku();

      // perform http request ke endpoint buku
      try {
        final response =
            await httpClient.get(Uri.parse('http://localhost:8000/api/buku'));
        if (response.statusCode == 200) {
          print(response.body);
          final data = jsonDecode(response.body) as List;
          final buku =
              data.map((jsonMentah) => Buku.fromJson(jsonMentah)).toList();
          // ketika stream telah berhasil didapatkan, lakukan emit event
          // BukuLoaded beserta dengan data buku dalam List
          yield BukuLoaded(buku: buku);
        }
      } catch (error) {
        print(error.toString());
        yield ErrorBuku();
      }
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    return MaterialApp(
      title: 'Belajar BLoC Pattern pada Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Contoh BLoC', httpClient: httpClient),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final http.Client httpClient;

  const MyHomePage({Key? key, required this.title, required this.httpClient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocProvider(
        // ketika bloc dibuat, langsung lakukan triger event FetchBuku
        create: (context) => BukuBloc(httpClient: httpClient)..add(FetchBuku()),
        child: BlocBuilder<BukuBloc, BukuState>(
          // builder akan melisten/mendengarkan state yang berubah buku block
          // aplikasi dan menjalankan operasi sesuai dengan state
          builder: (context, state) {
            if (state is InitBuku) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorBuku) {
              return const Center(child: Text('Gagal mengambil data buku'));
            } else if (state is BukuLoaded) {
              return ListView.builder(
                itemCount: state.buku.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // state bisa diakse karena saat ini
                    // state adalah instance dari BukuLoaded
                    title: Text(state.buku[index].judul),
                    subtitle: Text(state.buku[index].penulis),
                  );
                },
              );
            }
            // since builder tidak boleh null, kembalikan widget apapun
            return Container();
          },
        ),
      ),
    );
  }
}
