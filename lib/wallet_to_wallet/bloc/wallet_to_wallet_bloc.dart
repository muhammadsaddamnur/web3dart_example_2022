import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:convert/convert.dart';

part 'wallet_to_wallet_event.dart';
part 'wallet_to_wallet_state.dart';

class WalletToWalletBloc
    extends Bloc<WalletToWalletEvent, WalletToWalletState> {
  WalletToWalletBloc() : super(WalletToWalletInitial()) {
    const String rpcUrl = 'http://10.0.2.2:7545';
    const String wsUrl = 'ws://10.0.2.2:7545';

    late Web3Client client;

    /// temp variables
    BigInt myWalletBalance = BigInt.from(0);
    BigInt friendWalletBalance = BigInt.from(0);
    BigInt gasFee = BigInt.from(0);
    String signingHex = '';
    String txHash = '';

    /// init event
    on<Init>((event, emit) async {
      client = Web3Client(
        rpcUrl,
        Client(),
        socketConnector: () {
          return IOWebSocketChannel.connect(wsUrl).cast<String>();
        },
      );

      /// check gas fee
      gasFee = (await client.getGasPrice()).getInWei;

      add(GetWalletBalance());
      add(GetFriendWalletBalance());
    });

    /// get wallet balance
    on<GetWalletBalance>((event, emit) async {
      var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);
      Future<EtherAmount> balance = client.getBalance(credentials.address);
      myWalletBalance = (await balance).getInWei;

      emit(
        WalletToWalletLoaded(
          myWalletBalance,
          friendWalletBalance,
          gasFee,
          signingHex,
          txHash,
        ),
      );
    });

    /// get friend balance
    on<GetFriendWalletBalance>((event, emit) async {
      var credentials = EthereumAddress.fromHex(state.friendWalletAddress);
      Future<EtherAmount> balance = client.getBalance(credentials);
      friendWalletBalance = (await balance).getInWei;

      emit(
        WalletToWalletLoaded(
          myWalletBalance,
          friendWalletBalance,
          gasFee,
          signingHex,
          txHash,
        ),
      );
    });

    /// send wallet to contract
    on<SendWalletToWallet>((event, emit) async {
      var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);

      var result = client.sendTransaction(
        credentials,
        Transaction(
          from: credentials.address,
          to: EthereumAddress.fromHex(state.friendWalletAddress),
          value: EtherAmount.inWei(BigInt.parse('10000000000')),
        ),
      );

      txHash = await result;
      print(await result);

      add(Init());
    });

    /// send sign wallet to contract
    on<SendSigningWalletToWallet>((event, emit) async {
      var credentials = EthPrivateKey.fromHex(state.myAddressPrivateKey);

      var signHex = client.signTransaction(
        credentials,
        Transaction(
          from: credentials.address,
          to: EthereumAddress.fromHex(state.friendWalletAddress),
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
