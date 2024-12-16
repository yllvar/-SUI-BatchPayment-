address 0x0 {
    module BatchPayments {

        use sui::error;
        use sui::tx_context::{Self, TxContext};
        use sui::coin::{Self, Coin};
        use std::vector;

        /// Represents an individual payment
        struct Payment has copy, drop, store {
            recipient: address,
            amount: u64,
        }

        /// Represents a batch of payments
        struct Batch has store {
            payments: vector<Payment>,
        }

        // Error codes
        const EINVALID_AMOUNT: u64 = 1;
        const EINCOMPLETE_TRANSFER: u64 = 2;
        const EINSUFFICIENT_FUNDS: u64 = 3;

        /// Initialize an empty batch
        public fun create_batch(): Batch {
            Batch {
                payments: vector::empty<Payment>()
            }
        }

        /// Add a payment to the batch
        public fun add_payment(
            batch: &mut Batch,
            recipient: address,
            amount: u64,
        ) {
            assert!(amount > 0, error::invalid_argument(EINVALID_AMOUNT));
            let payment = Payment {
                recipient,
                amount,
            };
            vector::push_back(&mut batch.payments, payment);
        }

        /// Execute the batch of payments atomically
        public fun execute_batch<T>(
            batch: Batch,
            coin: Coin<T>,
            ctx: &mut TxContext,
        ) {
            let mut total_amount = 0;

            // Calculate the total payment amount
            let len = vector::length(&batch.payments);
            let mut i = 0;
            while (i < len) {
                let payment = vector::borrow(&batch.payments, i);
                assert!(payment.amount > 0, error::invalid_argument(EINVALID_AMOUNT));
                total_amount = total_amount + payment.amount;
                i = i + 1;
            }

            // Ensure the coin has sufficient funds
            let coin_balance = coin::value(&coin);
            assert!(coin_balance >= total_amount, error::invalid_argument(EINSUFFICIENT_FUNDS));

            // Perform the payments
            let mut j = 0;
            while (j < len) {
                let payment = vector::borrow(&batch.payments, j);
                let recipient_coin = coin::split(&coin, payment.amount, ctx);
                coin::transfer(payment.recipient, recipient_coin, ctx);
                j = j + 1;
            }

            // Ensure the remaining coin balance matches the expected amount
            assert!(coin::value(&coin) == (coin_balance - total_amount), error::abort_code(EINCOMPLETE_TRANSFER));
        }

        /// Helper to calculate the total batch payment amount
        public fun total_batch_amount(batch: &Batch): u64 {
            let mut total = 0;
            let len = vector::length(&batch.payments);
            let mut i = 0;
            while (i < len) {
                let payment = vector::borrow(&batch.payments, i);
                total = total + payment.amount;
                i = i + 1;
            };
            total
        }
    }
}
