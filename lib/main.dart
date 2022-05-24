import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart_example/wallet_to_wallet/bloc/wallet_to_wallet_bloc.dart';
import 'package:web3dart_example/wallet_to_wallet/view/wallet_to_wallet_view.dart';

import 'wallet_to_contract/bloc/contract_bloc.dart';
import 'wallet_to_contract/view/wallet_to_contract.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ContractBloc()),
        BlocProvider(create: (context) => WalletToWalletBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletToContract(),
                  ),
                );
              },
              child: const Text('My Wallet to Contract'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletToWalletView(),
                  ),
                );
              },
              child: const Text('My Wallet to Friend wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
