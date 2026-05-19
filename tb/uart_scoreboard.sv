`uvm_analysis_imp_decl(_drv)
`uvm_analysis_imp_decl(_mon)

class uart_scoreboard extends uvm_component;
  `uvm_component_utils(uart_scoreboard)

  uvm_analysis_imp_drv #(uart_transaction, uart_scoreboard) drv_imp;
  uvm_analysis_imp_mon #(uart_transaction, uart_scoreboard) mon_imp;

  uart_transaction exp_queue[$];

  covergroup uart_coverage;
    option.per_instance = 1;
    coverpoint_data: coverpoint exp_queue[0].data {
      bins zeros = {8'h00};
      bins ones  = {8'hFF};
      bins alternate = {8'h55};
      bins data_range[4] = {[8'h01:8'hFE]}; 
    }
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    drv_imp = new("drv_imp", this);
    mon_imp = new("mon_imp", this);
    uart_coverage = new();
  endfunction

  function void write_drv(uart_transaction t);
    exp_queue.push_back(t);
  endfunction

  function void write_mon(uart_transaction t);
    uart_transaction exp_tx;

    if (exp_queue.size() == 0) begin
      `uvm_error("SB_ERROR", "Received monitor data, but expected queue is empty!")
      return;
    end

    uart_coverage.sample();
    exp_tx = exp_queue.pop_front();

    if (t.data == exp_tx.data) begin
      `uvm_info("SB_PASS", $sformatf("MATCH! Data = %0h", t.data), UVM_MEDIUM)
    end else begin
      `uvm_error("SB_FAIL", $sformatf("MISMATCH! Exp: %0h | Act: %0h", exp_tx.data, t.data))
    end
  endfunction
endclass
