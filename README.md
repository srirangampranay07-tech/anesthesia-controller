# Automated Anesthesia Controller (Verilog)

## 📌 Description
This project implements a finite state machine (FSM) based anesthesia controller.

It monitors sensor values and adjusts drug delivery automatically:
- LOW → Increase dosage
- HIGH → Decrease dosage
- NORMAL → Maintain dosage

## ⚙️ Features
- FSM-based control
- Safety ERROR state
- Delay stabilization logic
- Parameterized thresholds

## 📂 Files
- src/ → Verilog design
- tb/ → Testbench
- results/ → Simulation outputs

## ▶️ Simulation
Run using ModelSim / Vivado / Cadence
https://github.com/srirangampranay07-tech/anesthesia-controller/blob/5d547a7f095fca166f51beaf7aae3a10c6848fd3/src/waveformpr.png
## 📊 Output Behavior
| Sensor Value | Action |
|-------------|--------|
| < 4         | Increase |
| 4–10        | Stable |
| > 10        | Decrease |

## 🚀 Author
Pranay (ECE - VLSI)
