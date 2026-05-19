class uart_transaction extends uvm_sequence_item;
  `uvm_object_utils(uart_transaction)

  rand bit [7:0] data;
  
  typedef enum {ZERO_PAYLOAD, NO_PAYLOAD, ALTERNATING, RANDOM} data_pattern_e;
  rand data_pattern_e pattern;

  constraint c_patterns {
    if (pattern == ZERO_PAYLOAD) data == 8'h00;
    if (pattern == NO_PAYLOAD)   data == 8'hFF;
    if (pattern == ALTERNATING)  data == 8'h55; 
  }

  function new(string name = "uart_transaction");
    super.new(name);
  endfunction
endclass
