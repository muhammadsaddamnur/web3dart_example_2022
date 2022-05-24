part of 'wallet_to_wallet_bloc.dart';

@immutable
abstract class WalletToWalletState {
  final String myAddressPrivateKey =
      'f90beef7616594565e1a8573faed3e467e0659dfe957766f9f1f822906bba7bf';
  final String myAddress = '0x4935ae210f0f4e17365104459E8350f6E15741e2';

  final String friendWalletAddress =
      '0x29B63c0b7C47624eB2Bd622dd0E6c47491477161';
}

class WalletToWalletInitial extends WalletToWalletState {}

class WalletToWalletLoaded extends WalletToWalletState {
  final BigInt myWalletBalance;
  final BigInt? friendWalletBalance;
  final BigInt? gasFee;
  final String? signHex;
  final String? txHash;

  WalletToWalletLoaded(
    this.myWalletBalance,
    this.friendWalletBalance,
    this.gasFee,
    this.signHex,
    this.txHash,
  );
}
