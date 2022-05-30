import 'dart:typed_data';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/src/crypto/secp256k1.dart' as secp256k1;

class CustomCredential extends CustomTransactionSender {
  final Web3Client client;
  final EthPrivateKey privateKey;
  final int? chainId;
  final bool fetchChainIdFromNetworkId;

  CustomCredential({
    required this.privateKey,
    required this.client,
    this.chainId = 1,
    this.fetchChainIdFromNetworkId = false,
  });

  @override
  Future<EthereumAddress> extractAddress() async {
    return privateKey.extractAddress();
  }

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    var signed = await client.signTransaction(
      this,
      transaction,
      chainId: chainId,
      fetchChainIdFromNetworkId: fetchChainIdFromNetworkId,
    );

    if (transaction.isEIP1559) {
      signed = prependTransactionType(0x02, signed);
    }
    print(signed);
    return client.sendRawTransaction(signed);
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) async {
    print('ini signToSignature bosss');

    /// ubah jadi MPC
    final signature = secp256k1.sign(keccak256(payload), privateKey.privateKey);

    // https://github.com/ethereumjs/ethereumjs-util/blob/8ffe697fafb33cefc7b7ec01c11e3a7da787fe0e/src/signature.ts#L26
    // be aware that signature.v already is recovery + 27
    int chainIdV;
    if (isEIP1559) {
      chainIdV = signature.v - 27;
    } else {
      chainIdV = chainId != null
          ? (signature.v - 27 + (chainId * 2 + 35))
          : signature.v;
    }
    return MsgSignature(signature.r, signature.s, chainIdV);
  }
}
