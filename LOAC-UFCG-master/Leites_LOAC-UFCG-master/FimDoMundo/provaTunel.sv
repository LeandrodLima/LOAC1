logic entrada_tunel;
logic saida_tunel;
logic estado1;
logic estado2;
logic [1:0] clockinho;
logic [1:0] count_cars;

parameter CHEIO = 3;

logic CLOCK;
logic reset;
logic [30:0] OUTPUT;

always_comb reset <= SWI[1];
always_comb entrada_tunel <= SWI[0];
always_comb saida_tunel <= SWI[7];

//atrasador de clock
always_ff @(posedge CLOCK_50) begin
    OUTPUT <= OUTPUT + 1;
end

always_ff @(posedge CLOCK) begin
    if(reset) begin
        estado1 <= 0;
        estado2 <= 0;
        count_cars <= 0;
        clockinho <= 0;
        LED[3] <= 0;
    end
    else begin
        if(entrada_tunel && count_cars < CHEIO) begin
            estado1 <= 1;
        end
        if(count_cars == CHEIO) begin
            clockinho <= clockinho + 1;
            if(clockinho == CHEIO) LED[3] <= 1;
        end
        else if (count_cars != CHEIO) begin
            LED[3] <= 0;
            clockinho <= 0
        end
        if ( entrada_tunel == 0 ) begin
            if(estado1) begin
                estado1 <= 0;
                count_cars <= count_cars + 1;
            end
        end
        if( saida_tunel )begin
            estado2 <= 1;
        end
        else if (saida_tunel == 0) begin
            if(estado2) begin
                estado2 <= 0;
                count_cars <= count_cars - 1;
            end
        end
    end
end

always_comb LED[4] <= OUTPUT[24];
always_comb LED[0] <= entrada_tunel;
always_comb LED[7] <= saida_tunel;

always_comb begin
    case(count_cars)
        1: SEG <= 8'b00000110;
        1: SEG <= 8'b01011011;
        1: SEG <= 8'b01001111;
        default SEG <= 8'b00111000;
end
