part of 'contract_bloc.dart';

@immutable
abstract class ContractEvent {}

class Init extends ContractEvent {}

class GetWalletBalance extends ContractEvent {}

class GetContractBalance extends ContractEvent {}

class SendWalletToContract extends ContractEvent {}

class SendSigningWalletToContract extends ContractEvent {}
