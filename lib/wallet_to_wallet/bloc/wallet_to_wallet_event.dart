part of 'wallet_to_wallet_bloc.dart';

@immutable
abstract class WalletToWalletEvent {}

class Init extends WalletToWalletEvent {}

class GetWalletBalance extends WalletToWalletEvent {}

class GetFriendWalletBalance extends WalletToWalletEvent {}

class SendWalletToWallet extends WalletToWalletEvent {}

class SendSigningWalletToWallet extends WalletToWalletEvent {}
