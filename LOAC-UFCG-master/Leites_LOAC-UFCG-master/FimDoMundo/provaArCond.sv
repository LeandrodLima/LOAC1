logic clock;
logic [27:0] contaClock;
logic [1:0] count_cars;

//atrasador de clock
always_ff @(posedge CLOCK_50) begin
    OUTPUT <= OUTPUT + 1;
end

always_ff @(posedge CLOCK_50) begin
    contaClock <= contaClock + 1;
    if (contaClock == 100000000) begin
        clock <= ~clock;
        contaClock <= 0;
    end
end

always_comb begin
    LED[0] <= clock;
end

logic diminuir;
logic aumentar;
logic [7:0] temperatura_desejada;
logic [7:0] temperatura_real;
logic [7:0] contador;

always_comb begin
    diminuir <= SWI[9];
    aumentar <= SWI[1];
end

always_ff @(posedge clock) begin
    if ( ~KEY[3] ) begin
        temperatura_desejada <= 20;
        temperatura_real <= 20;
    end 
    else begin
        if (temperatura_desejada <= 0) begin
            temperatura_desejada <= 20;
            temperatura_real <= 20;
        end

        if ( ~(aumentar && diminuir) ) begin
            if ( temperatura_desejada > temperatura_real ) begin
                if (contador == 3) begin
                    temperatura_real <= temperatura_real + 1;
                    contador <= 0;
                end
                else contador <= contador + 1;
            end 
            else begin
                if ( contador == 3 ) begin
                    temperatura_real <= temperatura_real + 1;
                    contador <= 0;
                end 
                else contador <= contador + 1;
            end
        end
    end
end








always_comb begin
    unique case(temperatura_real)
        8'h14: HEX0 <= 7'b1000000;
        8'h15: HEX0 <= 7'b1111001;
        8'h16: HEX0 <= 7'b0100100;
        8'h17: HEX0 <= 7'b0110000;
        8'h18: HEX0 <= 7'b0011001;
        8'h19: HEX0 <= 7'b0010010;
        8'h1A: HEX0 <= 7'b1000010;
        8'h1B: HEX0 <= 7'b1111000;
        8'h1C: HEX0 <= 7'b0000000;
        8'h1D: HEX0 <= 7'b0011000;
    endcase
end

always_comb begin
    unique case(temperatura_desejada)
        8'h14: HEX0 <= 7'b1000000;
        8'h15: HEX0 <= 7'b1111001;
        8'h16: HEX0 <= 7'b0100100;
        8'h17: HEX0 <= 7'b0110000;
        8'h18: HEX0 <= 7'b0011001;
        8'h19: HEX0 <= 7'b0010010;
        8'h1A: HEX0 <= 7'b1000010;
        8'h1B: HEX0 <= 7'b1111000;
        8'h1C: HEX0 <= 7'b0000000;
        8'h1D: HEX0 <= 7'b0011000;
    endcase
end
