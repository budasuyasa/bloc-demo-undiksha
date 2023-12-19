import 'package:undiksha02/entity/buku.dart';

abstract class BukuState {}

// state ketika loading
class InitBuku extends BukuState {}

// state ketika ada error saat mengambil data
class ErrorBuku extends BukuState {}

// state ketika data berhasil didapatkan
class LoadedBuku extends BukuState {
  List<Buku> buku;
  LoadedBuku({required this.buku});
}
