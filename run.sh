#!/bin/bash

echo "compiling..."
circom circut.circom --r1cs --wasm

echo "copying input..."
cp input.json ./circut_js

echo "moving circut.r1cs..."
mv circut.r1cs ./circut_js

echo "cd to circut_js..."
cd circut_js

echo "computing witness"
node generate_witness.js circut.wasm input.json witness.wtns

echo "starting ceremony..."
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup circut.r1cs pot12_final.ptau circut_0000.zkey
snarkjs zkey contribute circut_0000.zkey circut_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey circut_0001.zkey verification_key.json

echo "generating proof..."
snarkjs groth16 prove circut_0001.zkey witness.wtns proof.json public.json

echo "verifying proof..."
snarkjs groth16 verify verification_key.json public.json proof.json

echo "generating sol..."
snarkjs zkey export solidityverifier circut_0001.zkey verifier.sol

echo "generating call..."
snarkjs generatecall