module ifScore (keyPressed, mole, W, reset, pressedInTime, timeUp);
input keyPressed, mole, reset,pressedInTime, timeUp;
output reg W;
// should only check after a key has been pressed 
always@(posedge timeUp)
if (!pressedInTime)
W = 1'b0;
else 
begin
	if (keyPressed == mole)
	begin 
	W = 1'b1;
	end 
	else 
	W = 1'b0;
end 
endmodule 