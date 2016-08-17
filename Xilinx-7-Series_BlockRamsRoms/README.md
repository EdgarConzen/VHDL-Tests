Background : when familiarizing with VectorBlox's RISC-V implementation 'orca' I had to add RAM and ROM to the processor core. This sent me on a little journey with the inescapable obstacles. Questions that popped up and had to be answered:

* How do I get a grip on BRAMs in Vivado?
* Instatiate a template?
* Do it directly in VHDL?
 
After successfully playing around with
'Language Templates -> VHDL -> Device Primitive Instantiation -> Artix-7 -> RAM/ROM -> BlockRam'
I found a much more elegant way with 'signal arrays' and the 'ram_type' attribute.

But the results were confusing. Some combinations of address- and data-widths actually synthesized into block rams, but others into distributed ram. So I added the two widths as generics 'NUM_ADDR_BITS' and 'NUM_DATA_BITS' to my module 'blockram7s' and worked out the table that is shown inside of the source file blockram7s.vhd. This table is far from being complete but it shows an abstract of what Vivado does, when it is ordered to synthesize a blockram.

In the next step I wrote a simple test bench (not included in this rep) to make some reads and writes to the RAM. I also introduced an intermediary module 'use_blockram7s.vhd' to switch easily between synthesizing a ram or a rom (rom by tying the we (write enable) and/or the din (data in) of the instantiated 'blockram7s' to '0').

To my confusion the rom was sometimes optimised away. I firmly expected that the attribute 'rom_type' would persuade Vivado to leave the synthesized ram as it is. But in fact Vivado not only looks IF there is any initialisation data in the rom. It actually takes this data into account and tries to replace the rom with some simple kind of combinatorial logic. Weird!

Another inconsistency of Vivado (at least in my opinion) made me stumble again. I handed 'NUM_ADDR_BITS' and 'NUM_DATA_BITS' down from my test bench through 'use_blockram7s' to 'blockram7s'. At some point trying to start the simulation ended with an error:

ERROR: [VRFC 10-380] binding entity use_blockram7s does not have generic num_addr_bits

I searched the web desperately but I only found an indirect explanation for this behaviour. Again, Vivado conflicted with my firm expectation: the error appeared when I went from Behavioral Simulation to Post-Synthesis resp. Post-Implementation Simulation.

When a Behavioral Simulation is started, Vivado compiles not only the testbench but also the device under test.

When one of the four other simulations is started, Vivado won't start the synthesis or implementation process. Instead it now expects a completely synthesized or implemented d.u.t. In total contrast to Behavioral Simulation! This means, that the generics for the d.u.t. at synthesis or implementation time cannot stem from the testbench. Bummer!

To keep the generics unambiguous I moved them to a package named 'blockram7s_package.vhd'

Changing the values of 'NUM_ADDR_BITS' and 'NUM_DATA_BITS' in 'blockram7s_package.vhd' and synthesizing the design is a quick and convenient way to see what type of memory Vivado can create.

