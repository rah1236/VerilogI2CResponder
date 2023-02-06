
module i2cSlave (SCL, SDA, out, errorFlag);
    input reg SCL;
    inout reg SDA;
    output reg [7:0] out;
    output reg errorFlag;
    
    reg address = 8'h33;
    reg [7:0] shiftRegOut;         //Hold shift register value
    reg readWrite;                 //Keep track of read write bit 
    
    reg counterEnable;             //Enable for signal counter
    reg clrCounter;                //Clear for signal counter
    reg counterCount;

    reg [1:0] state;                //State machine

    //state machine :
    // 0 - Idle
    // 1 - Reading and checking Address
    // 2 - Reading Data
    // 3 - Reset

    always @(negedge SDA) begin  //initiate
        if(state == 2'h0 && SCL) begin
            state = 2'h1;
            counterEnable = 1;
        end
    end

    always @(posedge SCL)begin
        case (state)
            // 2'd0:begin
            //     clrCounter = 1;
            //     counterEnable = 0;
            // end
            2'h1:begin
                if (shiftRegOut == address >> 1 && counterCount == 4'd8) begin
                    state = 2'd2;
                    clrCounter = 1;
                end
                else begin
                    errorFlag = 1;
                end
            end
            2'd2:begin
                SDA = 0;  //address ACK BIT
                clrCounter = 0;
                if(counterCount == 4'h8) begin
                    state = 2'd3;
                    out = shiftRegOut;
                end
            end
            2'd3:begin
                SDA = 0; //Data ACK BIT
                clrCounter = 1;
                state = 2'h0;
            end
          //  default:
        endcase
    end

    shiftReg8b addressRegister(
        .shift_in (SDA), 
        .clock    (SCL),
        .byte_out (shiftRegOut)
    );

    counter signalCounter(
        .clk      (SCL),
        .up       (counterEnable),
        .clr      (clrCounter),
        .count    (counterCount)
    );

endmodule

