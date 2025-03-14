use sp1_sdk::{include_elf, utils, ProverClient, SP1Stdin};
use std::env;

pub const ROAST_ELF: &[u8] = include_elf!("roast-proof-program");

fn main() {
    // Setup logging
    utils::setup_logger();

    // Get command-line arguments
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <username>", args[0]);
        std::process::exit(1);
    }
    let username = &args[1];

    println!("Generating proof for username: {}", username);

    // Setup input
    let mut stdin = SP1Stdin::new();
    stdin.write(&username.to_string());

    // Create ProverClient
    let client = ProverClient::from_env();
    let (pk, vk) = client.setup(ROAST_ELF);

    // Generate proof
    println!("Generating proof...");
    let proof = client
        .prove(&pk, &stdin)
        .run()
        .expect("Failed to generate proof");
    println!("Proof generated successfully!");

    // Verify proof
    println!("Verifying proof...");
    client.verify(&proof, &vk).expect("Verification failed");
    println!("Proof verified successfully!");

    // Save proof (optional)
    let proof_path = "roast_proof.bin";
    proof.save(proof_path).expect("Failed to save proof");
    println!("Proof saved to: {}", proof_path);
}
