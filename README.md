# Bloc Demo

Project ini merupakan project demo untuk menunjukan penggunaan
Bloc pattern pada Flutter.

## Apa itu BloC
Bloc adalah pattern yang sangat populer yang digunakan untuk
melakukan manajemen state dan komponen dalam proyek Flutter.
Bloc memisahkan perhatian antara state dan komponen menjadi bagian yang terpisah, sehingga codebase akan lebih mudah untuk diorganisir dan dirawat.

BloC menggunakan konsep event, state, dan component. Contoh dari event
yaitu ketika sebuah tombol diklik. Event tidak hanya bisa terjadi
dari hasil interaksi user interface, event juga bisa terjadi
dari serangkaian proses. Misalkan event dijalankan setelah sebuah
komponen berhasil dirender di layar.

Dalam implementasinya, kita akan membuat sebuah `Bloc` class yang berfungsi memetekan `event` dengan `state`. Dengan kata lain, ketika ada
event yang ditriger, maka akan ada state yang diupdate.

Pada sisi komponen (widget), kita akan menggunakan `BlocBuilder` untuk mengawasi perubahan
state yang terjadi. Begitu terdapat perubaha pada state yang diawasi, widget langsung
melakukan "refresh".

Dalam demo ini kita membuat sebuah aplikasi Flutter yang
mengkonsumsi JSON dari REST API dan menampilkan responsenya
ke dalam `ListView`.

Folder `undiksha01api` berisikan aplikasi web yang dibuat dengan
Laravel untuk kebutuhan REST API. Folder `undiksha01` dan `undiksha02` berisikan project Flutter yang
mendemonstrasikan penggunaan BloC. Perbedaan antara `undiksha01` dan
`undiksha02` terletak pada organisasi kode. Pada `undiksha02`, kode
telah dipisahkan sesuai dengan concernnya masing-masing dan diorganisasikan menjadi folder dan file terpisah.

Penerapan BloC pada demo ini menggunakan library `flutter_bloc` untuk
meminimalisir boilerplate kode sehingga dapat fokus pada penerapan
`BloC` saja.

Rekaman video sesi demo dapat ditonton pada URL berikut 
[URL Berikut](https://us06web.zoom.us/rec/share/NdCYMU9VNKk8i3XOKyWmd8kTfx4lLS6lowyDe9ZbTD-rdL5BXXT_ylKO_gKBv3YJ.nc_pzjvh-wnwLINQ)

Passcode: `#Q*MWVP2`

## Membuat Model Buku untuk proses serialisasi JSON

Pertama, buat buatlah sebuah model dengan nama `Buku` yang nanti akan
digunakan pada proses serialisasi JSON response dari REST API

```dart
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
```

## Menyiapkan class untuk event
Selanjutnya kita akan menyiapkan beberapa class event.

```dart
// base class untuk event
abstract class BukuEvent {}

// event untuk mengambil data
class FetchBuku extends BukuEvent {}

// event untuk post data
class PostBuku extends BukuEvent {}

// event untuk update data
class UpdateBuku extends BukuEvent {}

// event untuk delete data
class DeleteBuku extends BukuEvent {}
```

## Menyiapkan class untuk state
Kita juga akan membuat beberapa class untuk menyimpan state.

```dart
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

```

Selanjutnya kita akan membuat membuat class Bloc serta logic
dalam melakukan serialisasi JSON. Dalam pembuatan class Bloc
ini, kita akan menggunakan `BukuEvent` dan `BukuState` sebagai 
parameter.

```dart

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

```

## Menggunakan BlocBuilder pada widget

`BlocBuilder` adalah widget yang digunakan untuk mendengarkan
perubahan state yang terjadi. `BlocBuilder` memerlukan parameter
`bloc` dan `state`. Kita akan menggunakan `BlocBuku` dan `BukuState`.

```dart
  // kode widget lainnya

@override
Widget build(BuildContext context) {
return Scaffold(
    appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Testing Bloc"),
    ),
    body: BlocProvider(
        create: (context) =>
            BlocBuku(httpClient: httpClient)..add(FetchBuku()),
        child: BlocBuilder<BlocBuku, BukuState>(builder: (context, state) {
            if (state is InitBuku) {
            return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorBuku) {
            return const Center(
                child: Text('Terjadi error saat mengambil buku'));
            } else if (state is LoadedBuku) {
            return ListView.builder(
                itemCount: state.buku.length,
                itemBuilder: (context, index) {
                    return ListTile(
                    title: Text(state.buku[index].judul),
                    subtitle: Text(state.buku[index].pengarang),
                    );
                });
            }
            return Container();
        })));
}
```