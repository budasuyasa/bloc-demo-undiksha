import 'package:flutter/material.dart';
import 'package:undiksha02/bloc/buku_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:undiksha02/state/buku_state.dart';
import 'package:undiksha02/event/buku_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final httpClient = http.Client();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(httpClient: httpClient),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final http.Client httpClient;

  const MyHomePage({Key? key, required this.httpClient}) : super(key: key);

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
}
