# Roast Me - Hyperbolic x Succinct App
In **Roast Me**, you get roasted by `Hyperbolic's API` and generate a proof of it by `Succinct's SP1 zkVM`!

## Overview
This app combines:
- **Hyperbolic API**: Generates humorous, crypto-themed roasts.
- **Succinct SP1**: Creates zero-knowledge proofs to verify a username was roasted without revealing the roast itself.
- **Flask**: Powers the web frontend.
- **Node.js**: Manages the backend for proof generation.

---

## System Requirements
The app is for development deployment, so you have to run it on Local systems. (I'll add steps for production deployment to be able to run on cloud servers)
* Local Linux PC
* Setting up Ubuntu via WSL on Windows using this [Guide](https://github.com/0xmoei/Install-Linux-on-Windows)

---

## 1) Prerequisites
**Important:**
* After running each of these commands, follow the on-screen prompts to complete the installation.
* For example: In my enviorment, after installing one of them, it asks me to enter `source /root/.bashrc` to verify the installation.

**1. Python**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip python3-venv -y
```

**2. Node.js and npm**
```bash
sudo apt-get update

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

node -v
npm -v
```

**3. Rust and Cargo**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
* It asks you to enter a command to add `cargo` to your `shell`. In my environment, it was:
```bash
. "$HOME/.cargo/env"
```

---

## 2) Clone Repository
```bash
git clone https://github.com/0xmoei/RoastMe-SP1.git
cd RoastMe-SP1
```

---

## 3) Hyperbolic API Key
The `app.py` file includes a placeholder API key for Hyperbolic. To use your own:
1. Sign up at [Hyperbolic](https://app.hyperbolic.xyz/) and get your **API key** in **Setting**.
2. Replace the `HYPERBOLIC_API_KEY` value in `app.py` directly using:
```bash
nano app.py
```

---

## 4) Setting Up the Environment
### Install the SP1 Toolchain
The app uses Succinct's SP1 zkVM for zero-knowledge proofs. Install it with:
```bash
curl -L https://sp1up.succinct.xyz | bash
```
* After entering the command, follow the new prompts to enter the neccessery command!
```bash
source /root/.bashrc
```
```bash
sp1up
```
```bash
rustup toolchain list
```
* You have to see `succinct` as a toolchain in the list!

---

## 5) Configure the Rust Toolchain
Navigate to the `roast_proof` directory and set the appropriate Rust toolchain:
```bash
cd ~/RoastMe-SP1/roast_proof
rustup override set succinct
```

---

## 6) Installing Dependencies
### Node.js Dependencies
Install the backend dependencies:
```bash 
cd ~/RoastMe-SP1/backend
npm install
```

### 7) Rust Dependencies
Build the Rust proof generation script:
```bash
cd ~/RoastMe-SP1/roast_proof/script
cargo build --release
```

---

## 8) Running the Application
```
cd ~/RoastMe-SP1
```

1. Create and activate a virtual environment:
```bash
python3 -m venv venv
source venv/bin/activate
```

2. Install Dependencies:
```bash
pip install -r requirements.txt
```

3. Run the app (while in the virtual environment)
```bash
python app.py
```
* Open your browser and navigate to `http://localhost:5000`

---

## 9) Start Proof Generator (Backend)
Open a new terminal, and launch the Node.js backend:
```bash
cd ~/RoastMe-SP1/backend
node server.js
```
* This should run on `http://localhost:3000`.

---

## 10) Access the App
Open your browser and navigate to `http://localhost:5000`.

---

## 11) Using the App
**1. Get Roasted:**
  - Enter your name in the input box.
  - Click "Roast me" to receive a crypto-themed roast generated by Hyperbolic’s API.

**2. Generate a Proof:**
  - After getting your roast, click "Prove (SP1)" to generate a zero-knowledge proof.
  - The proof confirms your name was processed (roasted) without revealing the roast content.
  - The proof result, including a hash, will appear below the roast.
  - The script generates and verifies the proof, saving it to `roast_proof.bin` in `RoastMe-SP1/roast-proof/script` directory

---

## Errors
1- Cargo
```
SP1 output: 
SP1 errors: /bin/sh: 1: cargo: not found
```
Enter `. "$HOME/.cargo/env"` before `9) Start Proof Generator (Backend)`
