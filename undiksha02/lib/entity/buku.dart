class Buku {
  final String judul;
  final String isbn;
  final String pengarang;
  final String tahunTerbit;

  Buku(
      {required this.judul,
      required this.isbn,
      required this.pengarang,
      required this.tahunTerbit});

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      isbn: json['isbn'],
      judul: json['judul'],
      pengarang: json['pengarang'],
      tahunTerbit: json['tahun_terbit'],
    );
  }
}