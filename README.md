# **FIFO Design Variations**

This repository contains three different FIFO (First-In-First-Out) buffer implementations using SystemVerilog. Each implementation explores a unique control mechanism for determining **Full** and **Empty** states.

---

## **1. Counter-Based FIFO (count_fifo)**  
- **Design**: Uses a counter to track the number of elements in the FIFO.  
- **Full Condition**: When the counter equals the FIFO depth.  
- **Empty Condition**: When the counter is zero.  
- **Pros**: Simple and easy to understand.  
- **Cons**: Requires extra hardware (counter logic).

```systemverilog
full  = (fifo_count == FIFO_DEPTH);
empty = (fifo_count == 0);
```

---

## **2. Last Empty FIFO (le_fifo)**  
- **Design**: Determines the **Full** and **Empty** conditions using pointer comparison without a counter.  
- **Behavior**:  
  - **Full** and **Empty** signals **assert** one cycle earlier than expected.  
    - Therefor **Full** remains **high** for one extra cycle.  
    - Therefor **The last FIFO slot remains unused** due to the early assertion logic.  
- **Full Condition**: Write pointer + 1 equals the read pointer.  
- **Empty Condition**: Write pointer equals the read pointer.  
- **Pros**: No counter logic required; lightweight design.  
- **Cons**:  
  - Full and empty states have **assert** two cycle.  
  - The **last slot** of the FIFO remains empty.

```systemverilog
full  = ((write_ptr + 1'b1) == read_ptr);
empty = (write_ptr == read_ptr);
```

---

## **3. Wrapper Bit FIFO (wbit_fifo)**  
- **Design**: Utilizes the MSB (wrapper bit) of the write and read pointers to differentiate between wrap-around and normal conditions.  
- **Full Condition**: Write pointer and read pointer align, but the wrapper bit is toggled.  
- **Empty Condition**: Write pointer equals the read pointer (including wrapper bit).  
- **Pros**: Efficient hardware usage; avoids counters.  
- **Cons**: Slightly more complex logic to implement.

```systemverilog
wrap_around = write_ptr[MSB] ^ read_ptr[MSB];
full  = wrap_around & (write_ptr[ADDR_WIDTH-1:0] == read_ptr[ADDR_WIDTH-1:0]);
empty = (write_ptr == read_ptr);
```

---

## **Summary of Differences**

| **Design**       | **Control Mechanism**   | **Behavior**                                      | **Full Condition**                | **Empty Condition**               |
|-------------------|-------------------------|--------------------------------------------------|-----------------------------------|-----------------------------------|
| **count_fifo**    | Counter                 | Accurate Full/Empty states.                      | `fifo_count == FIFO_DEPTH`        | `fifo_count == 0`                 |
| **le_fifo**       | Pointer comparison      | Early Full/Empty assertion; last slot unused. | `write_ptr + 1 == read_ptr`       | `write_ptr == read_ptr`           |
| **wbit_fifo**     | Wrapper bit + pointers  | Correct wrap-around handling with pointer logic. | `wrap_around && pointers align`   | `write_ptr == read_ptr`           |

---

## **How to Run**
1. Synthesize and simulate the desired FIFO module.  
2. Compare performance, resource utilization, and signal behavior for each design.  
3. Observe and verify Full/Empty timing for each implementation.

---

Here's a clearer and more polished version of your note:

---

**Note**: When implementing this design on the Basys-3 board, you need to **slow down the clock**. The default clock runs at a very high frequency, so a single push of a button may be detected thousands of times by the FIFO. To avoid this, use a clock divider or debounce logic.