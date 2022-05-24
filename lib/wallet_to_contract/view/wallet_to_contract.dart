import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';

import '../bloc/contract_bloc.dart';

class WalletToContract extends StatefulWidget {
  const WalletToContract({Key? key}) : super(key: key);

  @override
  State<WalletToContract> createState() => _WalletToContractState();
}

class _WalletToContractState extends State<WalletToContract> {
  @override
  void initState() {
    context.read<ContractBloc>().add(Init());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        return Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Column(
                    children: [
                      const Text('My Address Wallet'),
                      Text(
                        state.myAddress,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('My Wallet Balance'),
                      if (state is ContractLoaded)
                        Text(
                          state.myWalletBalance.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Column(
                    children: [
                      const Text('Contract Address'),
                      Text(
                        state.contractAddress,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Contract Balance'),
                      if (state is ContractLoaded)
                        Text(
                          state.contractBalance.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Center(
                  child: Column(
                    children: [
                      const Text('Gas Fee'),
                      if (state is ContractLoaded)
                        Text(
                          state.gasFee.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ContractBloc>().add(SendWalletToContract());
                  },
                  child: Text(
                    'Send ${EtherAmount.inWei(BigInt.parse('10000000000'))} to contract',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<ContractBloc>()
                        .add(SendSigningWalletToContract());
                  },
                  child: Text(
                    'Sign -> Send Raw ${EtherAmount.inWei(BigInt.parse('10000000000'))} to contract',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  right: 8,
                  left: 8,
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Text('Signing Hash'),
                      if (state is ContractLoaded)
                        Text(
                          (state.signHex ?? '-').toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  right: 8,
                  left: 8,
                ),
                child: Center(
                  child: Column(
                    children: [
                      const Text('TxHash'),
                      if (state is ContractLoaded)
                        Text(
                          state.txHash.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      else
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
