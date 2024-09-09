
module Random (timeUp, reset, mole, enable);
input timeUp, reset, enable;
output [1:0]mole;
reg generated; 
reg [4:0]LFSR;
// only generate a random number after time up 
always @(negedge timeUp, posedge reset)
begin 
if (reset)
LFSR <= 5'b10001;
else if (!enable)
LFSR <= 0;
else 
LFSR <= {LFSR[3:0], LFSR[4]^LFSR[3]};
end 

assign mole = LFSR [1:0];
endmodule 

