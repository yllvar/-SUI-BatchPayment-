# -SUI-BatchPayment-
Another walkaround to perfrom bundling tx on SUI network using Move. Group multiple payment transfers into a single transaction to reduce gas fees.
Set up your environment and project structure to implement a **Move-based batch transaction solution** for SUI. This includes creating a production-ready script to batch buy tokens and handle private keys for signing transactions.

---

### **Step 1: Install Required Tools**

1. **Install Rust**  
   SUI requires Rust for Move development. Install Rust using the following command:  
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
   After installation, add Rust to your shell:  
   ```bash
   source $HOME/.cargo/env
   ```

2. **Install SUI CLI**  
   Clone the SUI repository and build the CLI:
   ```bash
   git clone https://github.com/MystenLabs/sui.git
   cd sui
   cargo build --release
   ```
   Add the binary to your PATH:
   ```bash
   export PATH="$PWD/target/release:$PATH"
   ```

3. **Install Python**  
   For scripting and automation, ensure you have Python 3.9 or later. Use `brew` to install:
   ```bash
   brew install python
   ```

4. **Install Required Python Packages**  
   Use `pip` to install necessary libraries:
   ```bash
   pip install requests cryptography
   ```

---
