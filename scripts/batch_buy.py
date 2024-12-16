import json
import requests
from utils import sign_transaction, build_transaction

# Load configuration
with open('config.json', 'r') as config_file:
    config = json.load(config_file)

SUI_RPC_URL = config['rpc_url']
PRIVATE_KEYS = config['private_keys']
TOKEN_ADDRESS = config['token_address']
RECIPIENTS = config['recipients']  # List of recipient addresses and amounts


def batch_buy_tokens():
    transactions = []
    for recipient in RECIPIENTS:
        address = recipient['address']
        amount = recipient['amount']

        # Build the transaction
        tx = build_transaction(
            sender=PRIVATE_KEYS[0]['address'],  # Use the first wallet for this example
            recipient=address,
            amount=amount,
            token_address=TOKEN_ADDRESS
        )
        transactions.append(tx)

    # Sign and send each transaction
    for i, tx in enumerate(transactions):
        signed_tx = sign_transaction(tx, PRIVATE_KEYS[i % len(PRIVATE_KEYS)]['key'])
        response = requests.post(SUI_RPC_URL, json={'tx_bytes': signed_tx})
        if response.status_code == 200:
            print(f"Transaction {i + 1} sent: {response.json()}")
        else:
            print(f"Transaction {i + 1} failed: {response.text}")


if __name__ == "__main__":
    batch_buy_tokens()
