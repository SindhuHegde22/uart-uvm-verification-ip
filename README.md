# UART Universal Verification IP Framework (UVM)

A modular and scalable UART verification environment developed using the **Universal Verification Methodology (UVM)** to validate UART serial communication functionality. The verification environment implements a complete object-oriented UVM architecture including constrained-random stimulus generation, UART protocol framing, passive monitoring, scoreboard-based data checking, transaction-level communication (TLM), and functional coverage collection.

---

## 📁 Repository Structure

The architecture of this project follows industry-standard ASIC/FPGA verification directory organization patterns:

* `interface/` - Defines the physical UART pin-level signaling interface (`uart_if.sv`).
* `sim/` - Automated Tcl simulation execution scripts (`run.do`) for Siemens QuestaSim / ModelSim.
* `tb/` - Complete UVM verification environment including transactions, sequences, drivers, monitors, agents, scoreboards, environments, and tests.


---

## 🚀 Architectural Implementations

### 1. Transaction-Level UART Verification Architecture

The complete verification environment is constructed using reusable UVM Verification Components (UVCs):

* Transaction-level packet abstraction using `uart_transaction`.
* Sequencer-driver handshake communication.
* Passive monitor-based protocol observation.
* TLM analysis port communication between components.
* Centralized scoreboard validation architecture.
* Modular agent encapsulation for scalability and reuse.

---

### 2. Robust UART Protocol Framing & Serialization

The UART driver (`uart_driver1.sv`) converts randomized transaction packets into cycle-accurate UART protocol signaling:

* UART line idle-state initialization (`1'b1`).
* Explicit **Start Bit** generation (`1'b0`) for frame synchronization.
* Serialized 8-bit payload transmission (`LSB → MSB`).
* Clock-synchronized protocol timing alignment.
* Explicit **Stop Bit** assertion to restore bus idle condition.

---

### 3. Falling-Edge Aligned Passive Monitoring

The passive monitor (`uart_monitor.sv`) reconstructs UART frames independently from the driver to eliminate race conditions and unstable sample windows:

* Continuous polling for valid start-bit detection.
* Protocol re-synchronization after frame detection.
* Stable payload sampling aligned to the **falling edge** (`negedge vif.clk`) of the protocol clock.
* Accurate payload reconstruction into transaction objects.
* Automatic transaction forwarding into the scoreboard through analysis ports.

---

### 4. Constrained Random Transaction Generation

The sequence layer generates randomized UART payload traffic using SystemVerilog constrained randomization:

* Random 8-bit payload generation.
* Pattern-controlled stimulus categories.
* Directed-random verification methodology.
* Enumerated packet classifications:
  * `ZERO_PAYLOAD`
  * `NO_PAYLOAD`
  * `ALTERNATING`
  * `RANDOM`

Implemented protocol constraints:
* `8'h00`
* `8'hFF`
* `8'h55`
* Fully randomized payload distributions.

---

### 5. Dual-Port Scoreboard Verification System

The scoreboard (`uart_scoreboard.sv`) implements a transaction-level expected-vs-actual verification pipeline:

* Dedicated expected-data analysis implementation port.
* Dedicated actual-data monitor implementation port.
* FIFO queue synchronization mechanism.
* Automated payload comparison engine.
* PASS / FAIL protocol reporting system.

Verification checks include:
* Payload integrity validation.
* Queue synchronization tracking.
* End-to-end UART frame consistency verification.

---

### 6. Functional Coverage Driven Verification

The verification environment integrates SystemVerilog functional coverage (`covergroup`) for protocol stimulus tracking and coverage closure measurement.

Coverage categories include:

* Deep Zero payload patterns (`8'h00`)
* Deep One payload patterns (`8'hFF`)
* Alternating toggle payload patterns (`8'h55`)
* Distributed randomized payload ranges (`8'h01 → 8'hFE`)

Coverage metrics are sampled dynamically during scoreboard validation.

---

## 📊 Verification Results

### ✅ UVM Simulation Summary

| Verification Metric | Result |
|---|---|
| Total Transactions Generated | 10 |
| Transactions Monitored | 10 |
| Scoreboard Matches | 10 / 10 |
| UVM Errors | 0 |
| UVM Fatal Errors | 0 |
| Protocol Mismatches | 0 |

---

### 📈 Functional Coverage Metrics

| Coverage Type | Achieved Value |
|---|---|
| Functional Coverage | 57.14% |
| Protocol Assertions | PASS |
| Scoreboard Integrity | PASS |
| Transaction Reconstruction | PASS |

---

### 📋 Sample UVM Transcript

```text
UVM_INFO [SEQ] Generated Data = 18
UVM_INFO [DRV] Driving Data = 18
UVM_INFO [MON] Captured Data Frame = 18
UVM_INFO [SB_PASS] MATCH! Data = 18

UVM_INFO [SEQ] Generated Data = 9A
UVM_INFO [DRV] Driving Data = 9A
UVM_INFO [MON] Captured Data Frame = 9A
UVM_INFO [SB_PASS] MATCH! Data = 9A

UVM_INFO [SEQ] Generated Data = 58
UVM_INFO [DRV] Driving Data = 58
UVM_INFO [MON] Captured Data Frame = 58
UVM_INFO [SB_PASS] MATCH! Data = 58
```

---

## 📊 Simulation Waveform

![UART Protocol Simulation Waveform](images/UART_Waveform.png)

---

## 🛠️ Tools & Technologies

* SystemVerilog
* Universal Verification Methodology (UVM 1.1d)
* Siemens QuestaSim
* ModelSim
* Transaction-Level Modeling (TLM)
* Functional Coverage
* Constrained Random Verification
* Object-Oriented Verification Methodology

---

## 📈 How To Run the Simulation

The verification environment can be executed directly inside Siemens QuestaSim / ModelSim using the following compilation flow.

### Step 1 — Create Work Library

```tcl
vlib work
vmap work work
```

### Step 2 — Compile Source Files

```tcl
vlog uart_pkg.sv
vlog top.sv
```

### Step 3 — Launch Simulation

```tcl
vsim work.top -voptargs=+acc
```

### Step 4 — Add Waveforms

```tcl
add wave -r /*
```

### Step 5 — Run Verification

```tcl
run -all
```

---

## ⚡ Automated Simulation Execution

The project also supports fully automated QuestaSim execution using Tcl macro scripting.

Execute using:

```tcl
do sim/run.do
```

---

## 🔮 Future Enhancements

Planned scalability improvements include:

* UART parity-bit support
* Configurable baud-rate generation
* Error injection verification
* SystemVerilog Assertions (SVA)
* Multiple randomized sequence libraries
* Extended functional coverage closure
* Full UART RX/TX bidirectional verification
* Parameterized UART frame sizes
* Regression automation scripting

---

## 🎯 Key Verification Concepts Demonstrated

This project demonstrates practical implementation knowledge of:

* Universal Verification Methodology (UVM)
* Transaction-Level Modeling (TLM)
* Constrained Random Verification (CRV)
* Scoreboard-Based Data Checking
* Functional Coverage Collection
* UART Serial Communication Protocols
* Object-Oriented SystemVerilog
* Passive Protocol Monitoring
* Verification Environment Integration
* ASIC/FPGA Verification Flow Methodology

---

## 👩‍💻 Author

### Sindhu Hegde

Electronics and Communication Engineering  
Interested in VLSI Verification, Embedded Systems, Semiconductor Design, and Hardware Validation
