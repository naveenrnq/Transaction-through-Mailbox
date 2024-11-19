class transaction;

  rand bit [3:0] din1;
  rand bit [3:0] din2;

  bit [4:0] dout;

endclass

class generator;

  transaction t;
  mailbox mbx;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task main();

    for(int i = 0; i < 10; i++) begin // We want to send 10 random transactions
      t = new();
      assert(t.randomize) else $display("Randomization Failed");
      $display("[GEN]: DATA SENT: din1 : %0d and din2: %0d",t.din1,t.din2);
      mbx.put(t);  // transfer data from generator to driver
      #10;
    end

  endtask

endclass

class driver;

  transaction dc;
  mailbox mbx;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task main();
    forever begin  // That means we will be ready to receive the data always
      mbx.get(dc);  // All data object will be received at dc object
      $display("[DRV]: DATA RCVD: din1: %0d and din2: %0d", dc.din1,dc.din2);
      #10; // Each new txn after 10ns
    end
  endtask

endclass

module tb;
  generator g;
  driver d;
  mailbox mbx;
  
  initial begin
    mbx = new();
    g = new(mbx);
    d = new(mbx);
    
    fork 
      g.main();
      d.main();
    join
      
  end
  
  
  
  
endmodule
