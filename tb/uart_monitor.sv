class uart_monitor extends uvm_component;
  `uvm_component_utils(uart_monitor)

  uvm_analysis_port #(uart_transaction) mon_ap;
  virtual uart_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON_NO_VIF", "Virtual interface not found in monitor!")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    uart_transaction tx;

    for (int num_tx = 0; num_tx < 10; num_tx++) begin
      do begin
        @(posedge vif.clk);
      end while (vif.tx === 1'b1);

      tx = uart_transaction::type_id::create("tx");

      for (int i = 0; i < 8; i++) begin
        @(negedge vif.clk); 
        tx.data[i] = vif.tx;
      end

      @(posedge vif.clk);
      `uvm_info("MON", $sformatf("Captured Data Frame = %0h", tx.data), UVM_MEDIUM)
      mon_ap.write(tx);
    end
  endtask
endclass
