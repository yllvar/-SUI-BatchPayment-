import base64
import hashlib
from cryptography.hazmat.primitives.asymmetric import ed25519
import json

def build_transaction(sender, recipient, amount, token_address):
    """
    Build the transaction payload.
    """
    return {
        "sender": sender,
        "recipient": recipient,
        "amount": amount,
        "token_address": token_address,
        "gas_budget": 1000
    }


def sign_transaction(tx, private_key):
    """
    Sign the transaction using the private key.
    """
    # Serialize the transaction to bytes
    tx_bytes = json.dumps(tx, separators=(',', ':')).encode('utf-8')

    # Create an Ed25519 private key object
    private_key_obj = ed25519.Ed25519PrivateKey.from_private_bytes(base64.b64decode(private_key))

    # Sign the transaction
    signature = private_key_obj.sign(tx_bytes)
    return {
        "tx_bytes": base64.b64encode(tx_bytes).decode('utf-8'),
        "signature": base64.b64encode(signature).decode('utf-8')
    }
