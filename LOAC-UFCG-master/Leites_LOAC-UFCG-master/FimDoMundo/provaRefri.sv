//maquina de refris
// esta maquina de refris nao sabe dar troco, portanto insira a quantia correta

logic clock, r, sai_refri;
logic m0, m25, m50, m100; //moedas
logic [30:0] contador;
logic [2:0] est_atual;
logic [4:0] n;

parameter S0 = 0, S25 =1, S50 = 2, S75 = 3, S100 = 4; // ESTADOS QUE INDICAM O TOTAL DE DINHEIRO ARRECADADO

// ATRASADOR DE CLOCK
always_ff @(posedge CLOCK_50) begin
    contador <= contador + 1;
end 

always_comb begin
    clock <= contador[24];
    r <= SWI[0];
    m0 <= SWI[4];
    m25 <= SWI[5];
    m50 <= SWI[6];
    m100 <= SWI[7];
end

always_ff @(posedge clock) begin
    if(r) begin
        est_atual <= S0;
    end
    else begin
        case(est_atual)
            s0: begin
                sai_refri <= 0; n <= S0;
                if (m25) est_atual <= S25;
                else if(m50) est_atual <= S50;
                else if(m100) est_atual <= S100;
            end
            S25: begin
                n <= S25; sai_refri <= 0;
                if(m25) est_atual <= S50;
                else if(m50) est_atual <= S75;
                else if (m0 | m100) est_atual <= S0;
            end
            S50: begin
                n <= S50;
                if(m25) est_atual <= S75;
                else if(m50) est_atual <= 100;
                else if(m0 | m100) est_atual <= S0;
            end
            S75: begin
                n <= S75;
                if(m25) est_atual <= S100;
                else if(m0 | m50 | m100) est_atual <= S0;
            end
            default begin
                n <= S100;
                sai_refri <= 1; est_atual <= S0;
            end
        endcase
    end
end

always_comb begin
    LED[7] <= clock;
    LED[4] <= sai_refri;
    case(n)
        0: SEG <= 8'b00111111;
        1: SEG <= 8'b00000110;
        2: SEG <= 8'b01011011;
        3: SEG <= 8'b01001111;
        4: SEG <= 8'b01100110;
        5: SEG <= 8'b01101101;
        6: SEG <= 8'b01111101;
        7: SEG <= 8'b00000111;
        8: SEG <= 8'b01111111;
        9: SEG <= 8'b01101111;
        default SEG <= 8'b10000110;
    endcase
end