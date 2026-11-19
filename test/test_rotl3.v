From Stdlib Require Import BinInt Bits Vector String.
Require Import quartz.lang.Syntax. Import type.
Import (notations) type expr eexpr.

Definition test_rotl3_inner {var} := @fn.Fn var (Bits 32) (Bits 32) (fun v =>
    quartz_eexpr:(
      let sl := #v << 32 'd 3 in
      let sr := #v >> 32 'd 29 in
      return ( #sl | #sr )
    )).

Definition test_rotl3 {var fn} := fns.package_global_fns'' var fn (@test_rotl3_inner).

Module Counter.

  Record req := { 
    en : Bool;
    resetn : Bool;
  }. 
  Definition Req := type.reify'' req.

  Record state := { 
    q : Array Bool 3;
  }. 
  Definition State := type.reify'' state.

  Definition counter_inner {var} : fn.fn var (Pair State Req) State := fn.Fn (fun (p: var (Pair State Req)) => quartz_eexpr:(
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

  Definition counter {var fn} := fns.package_global_fns'' var fn (@counter_inner).

  Require Import quartz.lang.sv.
  Compute (sv.pp counter).
End Counter.
