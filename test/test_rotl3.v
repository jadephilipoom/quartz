From Stdlib Require Import BinInt.
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
    q : Bits 3;
  }. 
  Definition State := type.reify'' state.

  Definition counter_inner {var} : fn.fn var (Pair State Req) State := fn.Fn (fun (p: var (Pair State Req)) => quartz_eexpr:(
      let st := #p .1 in let d := #p .2 in
      let rst_bar := ~ #d..resetn in
      let g := (#d..en) & (~ #rst_bar) in
      let n := (#st..q) + 3'd 1 in
      if #rst_bar then
        return #st
      else
        let st <- #st..q = #n in
        return #st)).

  Definition counter {var fn} := fns.package_global_fns'' var fn (@counter_inner).

  Require Import Stdlib.Strings.String.
  Require Import quartz.lang.sv.
  Compute (sv.pp counter).
End Counter.
