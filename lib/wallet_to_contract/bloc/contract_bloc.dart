import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart_example/signing/custom_sign.dart';
import 'package:web_socket_channel/io.dart';
import 'package:convert/convert.dart';
part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  ContractBloc() : super(ContractInitial()) {
    const String rpcUrl = 'http://10.0.2.2:7545';
    const String wsUrl = 'ws://10.0.2.2:7545';

    late Web3Client client;

    /// contract variables
    late DeployedContract contract;
    late ContractFunction balanceFunction;
    late ContractFunction contributeFunction;

    /// temp variables
    BigInt myWalletBalance = BigInt.from(0);
    BigInt contractBalance = BigInt.from(0);
    BigInt gasFee = BigInt.from(0);
    String signingHex = '';
    String txHash = '';

    /// abi contract variable
    dynamic abi;

    /// init event
    on<Init>((event, emit) async {
      /// create Web3Client object
      client = Web3Client(
        rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(wsUrl).cast<String>();
        },
      );

      /// define contract
      String abiRaw =
          await rootBundle.loadString('contract/build/contracts/Demo.json');
      abi = await json.decode(abiRaw)['abi'];
      contract = DeployedContract(
        ContractAbi.fromJson(json.encode(abi), 'Demo'),
        EthereumAddress.fromHex(state.contractAddress),
      );
      balanceFunction = contract.function('balance');
      contributeFunction = contract.function('contribute');

      /// check gas fee
      gasFee = (await client.getGasPrice()).getInWei;

      add(GetWalletBalance());
      add(GetContractBalance());
    });

    /// get wallet balance
    on<GetWalletBalance>((event, emit) async {
      var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);
      Future<EtherAmount> balance = client.getBalance(credentials.address);
      myWalletBalance = (await balance).getInWei;

      emit(
        ContractLoaded(
          myWalletBalance,
          contractBalance,
          gasFee,
          signingHex,
          txHash,
        ),
      );
    });

    /// get contract balance
    on<GetContractBalance>((event, emit) async {
      final balance = await client.call(
        contract: contract,
        function: balanceFunction,
        params: [],
      );
      contractBalance = EtherAmount.inWei(balance.first as BigInt).getInWei;
      emit(
        ContractLoaded(
          myWalletBalance,
          contractBalance,
          gasFee,
          signingHex,
          txHash,
        ),
      );
    });

    /// send wallet to contract
    on<SendWalletToContract>((event, emit) async {
      /// versi lama
      // var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);
      // var result = client.sendTransaction(
      //   credentials,
      //   Transaction.callContract(
      //     contract: contract,
      //     function: contributeFunction,
      //     parameters: [],
      //     value: EtherAmount.inWei(BigInt.parse('10000000000')),
      //   ),
      // );

      /// versi baru (custom credential)
      CustomCredential credentials = CustomCredential(
        privateKey: EthPrivateKey.fromHex(state.myAddressPrivateKey),
        client: client,
      );
      var result = client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: contributeFunction,
          parameters: [],
          value: EtherAmount.inWei(BigInt.parse('10000000000')),
        ),
      );
      txHash = await result;
      print(await result);

      add(Init());
    });

    /// send sign wallet to contract
    on<SendSigningWalletToContract>((event, emit) async {
      var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);

      var signHex = client.signTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: contributeFunction,
          parameters: [],
          value: EtherAmount.inWei(BigInt.parse('10000000000')),
        ),
      );

      signingHex = hex.encode(await signHex);
      print(await signHex);

      var result = client.sendRawTransaction(await signHex);
      txHash = await result;
      print(await result);

      add(Init());
    });
  }
}
