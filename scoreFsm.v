module itgrn ( reset, W,  SCORE, startSwitch, enable, current_state, timeUp, systemClock);
input timeUp, systemClock;
input reset;
input W;
wire enableIn;
input startSwitch;
wire  [3:0] score, current;
output [3:0] SCORE, current_state;
scoreCounter b0(.clock(systemClock),.reset(reset), .score(score), .W(W), .timeUp(timeUp), .enable(enableIn));
gameState b1 (.Clock(systemClock), .Reset(reset), .startSwitch(startSwitch), .score(score), .enable(enableIn), .current_state(current));
assign SCORE = score;
assign current_state = current;
output enable;
assign enable = enableIn;
endmodule

module gameState(Clock, Reset, startSwitch, score, enable, current_state);
    input Clock;
    input Reset;
    input startSwitch;
    input [3:0] score;
	output reg	enable;
  

    localparam IDLE = 4'd0,
    GAME_START = 4'd1,
	GAME_OVER = 4'd2;

    
    output reg [3:0] current_state;
reg [3:0]	next_state;

    always @(*)
    begin
    case (current_state)
        IDLE: next_state = startSwitch ? GAME_START : IDLE;
        GAME_START: next_state = (score == 0 )? GAME_OVER : GAME_START;
        GAME_OVER: next_state = startSwitch ? GAME_OVER: IDLE;
      //  default: next_state = IDLE;
    endcase
    end

    always@(*)
    begin: enable_signals
    case(current_state)
        IDLE: begin
            //writeEn = 1'b1;
            enable = 1'b0;
        end
        GAME_START: begin
            enable = 1'b1;
        end
        GAME_OVER: begin
            enable = 1'b0;
        end
    endcase
	end 


    always @(posedge Clock)
    begin: state_flipflop
        if (Reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
         
endmodule



module scoreCounter(clock, reset, score, W, timeUp, enable);
    input clock, reset, W, timeUp, enable;
    output reg [3:0] score;

    // reg key_prev1 = 1'b0;
	 // reg key_prev2 = 1'b0;
    
    always @(negedge timeUp or posedge reset) begin
        if (reset) 
            score <= 4'b0001;  // Reset score on reset signal
			else if (!enable && !reset)
			score <= score;
        else  begin
           if (W == 1)
			score <= score + 1;
			else if (W == 0 && score != 0 )
			score <= score -1;
			else 
			score <= score;
        end
    end
	
endmodule

