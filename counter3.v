module timeCount (timeUp, systemClock, timer, reset, enable, shrink,ifPressed, pressedInTime);
input systemClock, reset, enable,ifPressed, shrink;
output timeUp, pressedInTime;
output [3:0] timer;
wire pulse;
RateDivider #(50000000) RDV (.ClockIn(systemClock), .Reset(reset),.pulse(pulse));
DisplayCounter #(5) DSP (.Clock(systemClock),.Reset(reset), .pulse(pulse), .enable(enable), .timer(timer),.timeUp (timeUp),.shrink(shrink),.ifPressed (ifPressed), .pressedInTime(pressedInTime));

endmodule



module RateDivider
#(parameter CLOCK_FREQUENCY = 50000000)(
	input ClockIn,
	input Reset,
	output pulse
	);
	
	
	reg [27:0] Q;
	always @(posedge ClockIn)
	begin
	if (Reset)
	Q <= CLOCK_FREQUENCY-1;
	else if (Q == 0)
	Q <= CLOCK_FREQUENCY-1;
	else 
	Q <= Q - 1;
	end 
	
	assign pulse = (Q == 1'b0)? 1:0;
endmodule

module DisplayCounter 
#(TIME = 10)
	(input Clock,
	input Reset,
	input pulse,
	input enable,
	input ifPressed,
	input shrink,
	output [3:0] timer,
	output reg timeUp,
	output reg pressedInTime
	);
	reg [3:0] timeRmb;
	reg [3:0]Q;
	always@(posedge Clock)
	begin
	if (shrink == 1'b1 && timeRmb > 1)
	 timeRmb <= timeRmb-1; 
	if (shrink == 1'b0)
	timeRmb <= timeRmb;
	if (Reset== 1'b1|enable == 1'b0)begin
		Q <= TIME;
		timeUp <= 1'b0;
		timeRmb<= TIME;
	end
	else if (ifPressed == 1'b1 && Q != 4'd0)
		begin 
		Q <= 0;
		pressedInTime <= 1'b1;
		timeUp <= 1'b1;
		end
	else if (pulse)
		begin 
		pressedInTime <= 1'b0;
		if (Q == 0)begin 
			Q <= timeRmb;
			timeUp <= 1'b1;
			end 
		else 
		timeUp <= 1'b0;
		Q <= Q - 1; 
		end 
	else if (Q == 0)
	begin 
	Q <= timeRmb;
	timeUp <= 1'b1;
	end
	else
	begin
	Q <= Q;
	// pressedInTime<= 1'b0;
	end 
	end 
	
// always @(negedge timeUp, posedge Reset)
// begin 
// if (Reset)
// timeRmb <= TIME;
// else if (shrink)
// timeRmb <= timeRmb-2;
// else 
// timeRmb <= timeRmb;
// end 
assign timer = Q;

endmodule 