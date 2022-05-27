# Circom Demo

## Create Circut

`vi circit.circom`

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

## Create Example Input

`vi input.json`

```json
{ "a": 3, "b": 11 }
```

## Compile, Compute Witness, Prove, Generate .sol and Call

`./run.sh`