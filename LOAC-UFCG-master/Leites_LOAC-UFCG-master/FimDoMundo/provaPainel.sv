/* 
    Prova mal estruturada, nao tenho certeza da nota. Acredito que vale so 2
    {POR CONTA E RISCO}
 */
logic painel, liga_sol, liga_rede, clock, rst;

logic [2:0] incidencia_solar;
logic [30:0] OUTPUT;

always_comb rst <= SWI[0];
always_comb sol <= SWI[1];

always_ff @(posedge clock) begin
    if(rst) begin
        liga_sol <= 0;
        liga_rede <= 0;
        sem_sol <= 0;
        sem_rede <= 0;
        sol <= 0;
    end
/*     else begin
        if(sol) begin
            liga_sol <= 1;
            //  incidencia_solar = incidencia_solar + 1; original
            incidencia_solar <= incidencia_solar + 1;
        end
        else if(sol == 0) begin
            liga_sol <= 0;
            liga_rede <= 0;
        end
    end */
end

always_comb LED[0] <= painel;
always_comb LED[1] <= liga_sol;
always_comb LED[2] <= liga_rede;

always_comb LED[7] <= clock;