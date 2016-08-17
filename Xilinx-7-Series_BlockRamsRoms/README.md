Background : when familiarizing with VectorBlox RISC-V implementation 'orca' I had to add RAM and ROM to the processor core. This sent me on a little journey with the usual obstacles. Questions that popped up and had to be answered:

* How do I get a grip on BRAMs in Vivado?
* Instatiate a template?
* Do it directly in VHDL?
 
After successfully playing around with
Language Templates -> VHDL -> Device Primitive Instantiation -> Artix-7 -> RAM/ROM -> BlockRam
I found a much more elegant way with 'signal arrays' and the 'ram_type' attribute.

But the results were confusing. Some combinations of address- and data-widths synthesized into block rams, others into distributed ram. So I added the two widths as generics to my module 'blockram7s' and worked out the table that is shown inside of the source file blockram7s.vhd. This table is far from being complete but it shows an abstract of what Vivado does.

In the next step I wrote a simple test bench (not included in this rep) to make some reads and writes to the RAM. I also introduced module 'use_blockram7s.vhd' to distiguish between using a ram or a rom, simply by tying the we (write enable) and/or the din (data in) of the instantiated blockram7s to '0'.
