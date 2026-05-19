module top;
  import uvm_pkg::*;
  import uart_pkg::*;
  `include "uvm_macros.svh"

  logic clk;
  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  uart_if inf(clk);

  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", inf);
    run_test("uart_test");
  end
endmodule
