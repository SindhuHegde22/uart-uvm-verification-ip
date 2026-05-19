# ==============================================================================
#  QuestaSim / ModelSim Single-Click UVM Compilation & Execution Script
# ==============================================================================

# Clear previous transcripts
.main clear

# Refresh work library
if [file exists work] {
    vdel -all
}
vlib work
vmap work work

# Compile source files with include directory flag targeting the tb/ folder
vlog +incdir+tb tb/uart_pkg.sv tb/top.sv

# Optimize and load simulation with full visibility and active functional coverage tracking
vsim -voptargs="+acc" -coverage work.top

# Log all interface signals recursively
log -r /*

# Run the simulation through its phases
run -all

# Dump out structural covergroup data directly to command console
coverage report -detail -cvg

# Disengage simulator gracefully
quit -sim
