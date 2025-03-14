#![no_main]
sp1_zkvm::entrypoint!(main);

pub fn main() {
    // Read the username as input (private)
    let username = sp1_zkvm::io::read::<String>();
    
    // Simple validation: ensure username isn't empty
    assert!(!username.is_empty(), "Username cannot be empty");

    // Commit the username as a public value (proving it was processed)
    sp1_zkvm::io::commit(&username);
}
