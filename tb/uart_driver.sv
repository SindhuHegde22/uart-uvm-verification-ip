class uart_driver extends uvm_driver #(uart_transaction);
  `uvm_component_utils(uart_driver)

  uvm_analysis_port #(uart_transaction) drv_ap;
  virtual uart_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv_ap = new("drv_ap", this);
    if(!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRV_NO_VIF", "Virtual interface not found in driver!")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    uart_transaction tx;
    vif.tx <= 1'b1; 

    forever begin
      seq_item_port.get_next_item(tx);
      `uvm_info("DRV", $sformatf("Driving Data = %0h", tx.data), UVM_MEDIUM)
      drv_ap.write(tx);

      vif.tx <= 1'b0; // Start bit
      @(posedge vif.clk);

      for (int i = 0; i < 8; i++) begin
        vif.tx <= tx.data[i]; 
        @(posedge vif.clk);
      end

      vif.tx <= 1'b1; // Stop bit
      @(posedge vif.clk);

      seq_item_port.item_done();
    end
  endtask
endclass
