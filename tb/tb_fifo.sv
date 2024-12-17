module tb_fifo();
parameter DATA_WIDTH = 8 ;
parameter FIFO_DEPTH = 4 ;

  logic                   clk;
  logic                   rst;
  logic                   write_en;
  logic                   read_en;
  logic [DATA_WIDTH-1:0]  write_data;

  logic [DATA_WIDTH-1:0]  read_data_a;
  logic                   full_a;
  logic                   empty_a;

  logic [DATA_WIDTH-1:0]  read_data_b;
  logic                   full_b;
  logic                   empty_b;

  logic [DATA_WIDTH-1:0]  read_data_c;
  logic                   full_c;
  logic                   empty_c;

  count_fifo #(
  .DATA_WIDTH    (DATA_WIDTH),
  .FIFO_DEPTH    (FIFO_DEPTH)
) u_counter_fifo (
  .clk           (clk),
  .rst           (rst),
  .write_en      (write_en),
  .read_en       (read_en),
  .write_data    (write_data),
  .read_data     (read_data_a),
  .full          (full_a),
  .empty         (empty_a)
);

  le_fifo #(
  .DATA_WIDTH    (DATA_WIDTH),
  .FIFO_DEPTH    (FIFO_DEPTH)
  ) u_last_empty_fifo (
  .clk           (clk),
  .rst           (rst),
  .write_en      (write_en),
  .read_en       (read_en),
  .write_data    (write_data),
  .read_data     (read_data_b),
  .full          (full_b),
  .empty         (empty_b)
);

 wbit_fifo #(
  .DATA_WIDTH    (DATA_WIDTH),
  .FIFO_DEPTH    (FIFO_DEPTH)
  ) u_wrapper_bit_fifo (
  .clk           (clk),
  .rst           (rst),
  .write_en      (write_en),
  .read_en       (read_en),
  .write_data    (write_data),
  .read_data     (read_data_c),
  .full          (full_c),
  .empty         (empty_c)
);

  always #5 clk = ~clk;

  initial begin
  clk = 0;
  rst = 1;
  write_en = 0;
  read_en = 0;
  write_data = 0;
  @(posedge clk);
  rst = 0;
  @(posedge clk);

  repeat(4) begin
    write_en <= 1;
    read_en <= 0;
    write_data <= $urandom;
    @(posedge clk);
  end

  repeat(4) begin
    write_en <= 0;
    read_en <= 1;
    @(posedge clk);
  end

  read_en <= 0;

  end
endmodule