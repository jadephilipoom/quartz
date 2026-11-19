// Generated from Rocq by Quartz (experimental prototype version)
typedef enum bit { tt } unit; // no zero-size types in SystemVerilog :/

class Pair #(parameter type A, parameter type B);
  typedef struct packed { A fst; B snd; } t;
  static function A fst (t p); return p.fst; endfunction
  static function B snd (t p); return p.snd; endfunction
  static function t mk (A a, B b); return t'{a, b}; endfunction
endclass

class Either #(parameter type A, parameter type B);
  typedef union tagged packed { A left; B right; } t;
  static function t left(A a); return tagged left a; endfunction
  static function t right(B b); return tagged right b; endfunction
endclass

typedef struct packed { bit[3-1:0][0:0] q; } state__1B_3A_1S;
typedef struct packed { bit[0:0] en; bit[0:0] resetn; } req__1B_1B_2S;

function automatic state__1B_3A_1S counter_inner_specialization_1 (
  input Pair#(state__1B_3A_1S, req__1B_1B_2S)::t p);
  begin state__1B_3A_1S st_0; st_0 = Pair#(state__1B_3A_1S, req__1B_1B_2S)::fst(p);
  begin req__1B_1B_2S d_1; d_1 = Pair#(state__1B_3A_1S, req__1B_1B_2S)::snd(p);
  begin bit[0:0] rst_bar_2; rst_bar_2 = (~d_1.resetn);
  begin bit[0:0] g_3; g_3 = (d_1.en & (~rst_bar_2));
  begin bit[0:0] n0_4; n0_4 = (st_0.q[Pair#(bit[1:0], unit)::mk(2'd0, tt).fst] ^ g_3);
  begin bit[0:0] n1_5; n1_5 = (st_0.q[Pair#(bit[1:0], unit)::mk(2'd1, tt).fst] ^ (st_0.q[Pair#(bit[1:0], unit)::mk(2'd0, tt).fst] & g_3));
  begin bit[0:0] n2_6; n2_6 = (st_0.q[Pair#(bit[1:0], unit)::mk(2'd2, tt).fst] ^ ((st_0.q[Pair#(bit[1:0], unit)::mk(2'd1, tt).fst] & st_0.q[Pair#(bit[1:0], unit)::mk(2'd0, tt).fst]) & g_3));
  begin bit[3-1:0][0:0] q_upd_7;
  q_upd_7 = st_0.q;
  q_upd_7[Pair#(bit[1:0], unit)::mk(2'd0, tt).fst] = (rst_bar_2 ? 1'd0 : n0_4);
  begin bit[3-1:0][0:0] q_upd_8;
  q_upd_8 = q_upd_7;
  q_upd_8[Pair#(bit[1:0], unit)::mk(2'd1, tt).fst] = (rst_bar_2 ? 1'd0 : n1_5);
  begin bit[3-1:0][0:0] q_upd_9;
  q_upd_9 = q_upd_8;
  q_upd_9[Pair#(bit[1:0], unit)::mk(2'd2, tt).fst] = (rst_bar_2 ? 1'd0 : n2_6);
  begin state__1B_3A_1S st_10;
  st_10 = st_0;
  st_10.q = q_upd_9;
  counter_inner_specialization_1 = st_10; end end end end end end end end end end end
endfunction

function automatic state__1B_3A_1S counter_inner (
  input Pair#(state__1B_3A_1S, req__1B_1B_2S)::t x);
  counter_inner = counter_inner_specialization_1(x);
endfunction

/* This part is hand coded */
module top(input clk, input resetn, output [2:0] count);
    state__1B_3A_1S state;
    req__1B_1B_2S req;

    assign req = {1'd1, resetn};

    always @(posedge clk)
      state <= counter_inner(Pair#(state__1B_3A_1S, req__1B_1B_2S)::mk (state, req));

    assign count = state.q;
endmodule
