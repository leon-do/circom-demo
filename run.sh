#!/bin/bash

echo "compiling..."
circom circuit.circom --r1cs --wasm

echo "copying input..."
cp input.json ./circuit_js

echo "moving circuit.r1cs..."
mv circuit.r1cs ./circuit_js

echo "cd to circuit_js..."
cd circuit_js

echo "computing witness"
node generate_witness.js circuit.wasm input.json witness.wtns

echo "starting ceremony..."
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey circuit_0001.zkey verification_key.json

echo "generating proof..."
snarkjs groth16 prove circuit_0001.zkey witness.wtns proof.json public.json

echo "verifying proof..."
snarkjs groth16 verify verification_key.json public.json proof.json

echo "generating sol..."
snarkjs zkey export solidityverifier circuit_0001.zkey verifier.sol

echo "generating call..."
snarkjs generatecall