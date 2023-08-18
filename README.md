# Asynchronous-FIFO

This circuit consists of a FIFO of size 8. read clk, write clk, read enable, write enable as inputs and dataOut , full, empty signals as outputs.
In Asynchronous FIFO, reading and writing happens at different frequency.
For transfering pointer data between different frequency read, write domains, synchronisers are used.
