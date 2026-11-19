From Stdlib Require Import BinInt Bits String.
Require Import quartz.lang.sv.
Require Import quartz.lang.Syntax. Import type.
Import (notations) type expr eexpr.

Record req := { 
  en : Bool;
  resetn : Bool;
}. 
Definition Req := type.reify'' req.

Record state := { 
  q : Array Bool 3;
}. 
Definition State := type.reify'' state.

Definition test_counter_inner {var} : fn.fn var (Pair State Req) State := fn.Fn (fun (p: var (Pair State Req)) => quartz_eexpr:(
    let st := #p .1 in let d := #p .2 in
    let rst_bar := ~ #d..resetn in
    let g := (#d..en) & (~ #rst_bar) in
    let n0 : Bool := (#st..q)[2 'd 0] ^ #g in
    let n1 : Bool := (#st..q)[2 'd 1] ^ ((#st..q)[2 'd 0] & #g) in
    let n2 : Bool := (#st..q)[2 'd 2] ^ ((#st..q)[2 'd 1] & (#st..q)[2 'd 0] & #g) in
    let q_upd <- (#st..q)[2 'd 0] = if #rst_bar then 1 'd 0 else #n0 in
    let q_upd <- #q_upd[2 'd 1] = if #rst_bar then 1 'd 0 else #n1 in
    let q_upd <- #q_upd[2 'd 2] = if #rst_bar then 1 'd 0 else #n2 in
    let st <- #st..q = #q_upd in
    return #st)).

Definition test_counter {var fn} := fns.package_global_fns'' var fn (@test_counter_inner).
