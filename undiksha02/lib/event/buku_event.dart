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