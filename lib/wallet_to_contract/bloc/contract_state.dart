part of 'contract_bloc.dart';

@immutable
abstract class ContractState {
  final String myAddressPrivateKey =
      'f90beef7616594565e1a8573faed3e467e0659dfe957766f9f1f822906bba7bf';
  final String myAddress = '0x4935ae210f0f4e17365104459E8350f6E15741e2';

  final String contractAddress = '0xeF2a7Fb6373f17908903e96C4CefFE1a16e76DeC';
}

class ContractInitial extends ContractState {}

class ContractLoaded extends ContractState {
  final BigInt myWalletBalance;
  final BigInt? contractBalance;
  final BigInt? gasFee;
  final String? signHex;
  final String? txHash;

  ContractLoaded(
    this.myWalletBalance,
    this.contractBalance,
    this.gasFee,
    this.signHex,
    this.txHash,
  );
}
