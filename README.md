# Circom Demo

## Tutorial

### Create circut

`vi multiplier2.circom`

```
pragma circom 2.0.0;

/*This circuit template checks that c is the multiplication of a and b.*/  

template Multiplier2 () {  

   // Declaration of signals.  
   signal input a;  
   signal input b;  
   signal output c;  

   // Constraints.  
   c <== a * b;  
}

component main = Multiplier2();
```

### Compile

`cd multiplier2_js`

`circom multiplier2.circom --r1cs --wasm`

`vi multiplier2_js/input.json`

33 = 3 * 11

```json
{ "a": 3, "b": 11 }
```

### Computing the Witness

`node generate_witness.js multiplier2.wasm input.json witness.wtns`

### Start Ceremony: Powers of Tau .ptau

`snarkjs powersoftau new bn128 12 pot12_0000.ptau -v`

`snarkjs powersoftau prepare phase2 pot12_0000.ptau pot12_final.ptau -v`

`snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey`

`snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v`

`snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json`

### Generate Proof

`snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json`

### Verify Proof

`snarkjs groth16 verify verification_key.json public.json proof.json`

### Verify Smart Contract

`snarkjs zkey export solidityverifier multiplier2_0001.zkey verifier.sol`

### Generate Smart Contract Call

`snarkjs zkey export solidityverifier multiplier2_0001.zkey verifier.sol`