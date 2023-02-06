module counter(
    input clk,
    input wire up,
    input reg clr,
    output reg [3:0] count,
    output reg rco
);



always @(posedge clk) begin
    if (up) begin
        count <= count + 1;
    end
    if (clr) begin
        count <= 0;
    end
    if (count == ~0) begin//if all ones
        rco <= 1;
    end
    else begin
        rco <= 0;
    end
end

endmodule

