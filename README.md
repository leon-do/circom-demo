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

`circom multiplier2.circom --r1cs --wasm`

`vi multiplier2_js/input.json`

33 = 3 * 11

```json
{ "a": 3, "b": 11 }
```

### Computing the Witness

`cd multiplier2_js`

`node generate_witness.js multiplier2.wasm input.json witness.wtns`

### Start Ceremony: Powers of Tau .ptau

`snarkjs powersoftau new bn128 12 pot12_0000.ptau -v`

`snarkjs powersoftau prepare phase2 pot12_0000.ptau pot12_final.ptau -v`

`snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey`