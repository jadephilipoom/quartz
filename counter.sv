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

typedef struct packed { bit[2:0] q; } state__3B_1S;
typedef struct packed { bit[0:0] en; bit[0:0] resetn; } req__1B_1B_2S;

function automatic state__3B_1S counter_inner_specialization_1 (
  input Pair#(state__3B_1S, req__1B_1B_2S)::t p);
  begin state__3B_1S st_0; st_0 = Pair#(state__3B_1S, req__1B_1B_2S)::fst(p);
  begin req__1B_1B_2S d_1; d_1 = Pair#(state__3B_1S, req__1B_1B_2S)::snd(p);
  begin bit[0:0] rst_bar_2; rst_bar_2 = (~d_1.resetn);
  begin bit[0:0] g_3; g_3 = (d_1.en & (~rst_bar_2));
  begin bit[2:0] n_4; n_4 = (st_0.q + 3'd1);
  if (rst_bar_2) begin
    counter_inner_specialization_1 = st_0;
  end else begin
    begin state__3B_1S st_5;
    st_5 = st_0;
    st_5.q = n_4;
    counter_inner_specialization_1 = st_5; end
  end end end end end end
endfunction

function automatic state__3B_1S counter_inner (
  input Pair#(state__3B_1S, req__1B_1B_2S)::t x);
  counter_inner = counter_inner_specialization_1(x);
endfunction

/* This part is hand coded */
module top(input clk, input resetn, output [2:0] q);
    state__3B_1S state;
    req__1B_1B_2S req;

    assign req = {1'd1, resetn};

    always @(posedge clk)
      state <= counter_inner(Pair#(state__3B_1S, req__1B_1B_2S)::mk (state, req));

    assign q = state.q;
endmodule
