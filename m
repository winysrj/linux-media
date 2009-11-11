Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63527 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZKKPoE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 10:44:04 -0500
Subject: Re: Fwd: Hauppauge HVR-1600 cx18 loading problem
From: Andy Walls <awalls@radix.net>
To: John Nuszkowski <john.nuszkowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <ddfe20800911102115n4b71264dma843f77d4ee40e29@mail.gmail.com>
References: <ddfe20800911100913l2ebe777dya3ef47fc944e6897@mail.gmail.com>
	 <1257901423.4040.53.camel@palomino.walls.org>
	 <ddfe20800911102113h66f34980rf3e2486eb05bb961@mail.gmail.com>
	 <ddfe20800911102115n4b71264dma843f77d4ee40e29@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 10:47:13 -0500
Message-Id: <1257954433.4391.53.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-11-11 at 00:15 -0500, John Nuszkowski wrote:

> 
> See my comments below.
> 
> On Tue, Nov 10, 2009 at 8:03 PM, Andy Walls <awalls@radix.net> wrote:
> > On Tue, 2009-11-10 at 12:13 -0500, John Nuszkowski wrote:
> >> My new Hauppauge HVR-1600 does not load the firmware.  The driver was
> >> built using the source from over the weekend.  I am using mythbuntu.
> >>
> >> Below is a "modprobe cx18 debug=511" command
> >>
> >> Any help would greatly be appreciated.

> >> [43594.594104] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
> >> [43594.607124] cx18-0: Mismatch at offset 0
> >
> > OK.  That's bad.  From messages previous to this, we can obviously
> > access CX23418 registers.  This "Mismatch at offset 0" message indicates
> > that writes or reads to the memory chip on the HVR-1600 via the PCI bus
> > and the CX23418 are failing.
> >
> > Possible causes are:
> >
> > 1. Repeated PCI bus errors when trying to write or write to the CX23418
> > memory.
> >
> > 2. A new memory chip is is use on the HVR-1600 and the DRR memory
> > configuration parameters in the HVR-1600 entry in cx18-cards.c are
> > wrong.
> >
> > 3. Writes to CX23418 registers to configure the DDR memory parameters
> > failed.
> >
> > 4. Some other device driver or device DMA engine is errantly writing
> > into CX23418 memory space.
> >
> >
> > Some things you can you do:
> >
> > 1. Pull *all* your PCI cards out of your machine, blow the dust out of
> > the PCI slots, reseat all the cards and try again.  This should somewhat
> > mitigate PCI signal problems due to dust and oxidation.
> 
> Nothing changed.  I also moved the card to another PCI slot.

OK.  So much for the easy fix....


> > 2. In the file
> >
> >        cx18-driver.h
> >
> > change the value of
> >
> >        #define CX18_MAX_MMIO_WR_RETRIES 10
> >
> > up from 10 to 20 (or whatever) to increase the number of retries when
> > writing to the CX23418 over the PCI bus.  Recompile and install the cx18
> > driver and test again.
>
> Same result.

OK.  This is a somewhat reasonable indicator that it is not a PCI bus
error.


> 
> 
> > 3. If you still have /dev/video* device nodes after modprobe, even
> > though the firmware load failed; compile the v4l-dbg in the v4l-dvb tree
> > and run these commands as root:
> >
> > # v4l2-dbg -d /dev/video1 -S
> > host0: cx23418    revision 0x01010000
> > host1: cx23418_843 revision 0x00008430
> > i2c 0x4c: cs5345     revision 0x00000000
> >
> 
> 
> # ./v4l2-dbg -D
> Failed to open /dev/video0: No such device or address
> 
> # ls -al /dev/video*
> crw-rw----+ 1 root video 81, 0 2009-11-10 21:52 /dev/video0
> crw-rw----+ 1 root video 81, 3 2009-11-10 21:52 /dev/video24
> crw-rw----+ 1 root video 81, 1 2009-11-10 21:52 /dev/video32
> 
> So basically v4l2-dbg doesn't work with this error.  I wish I could do
> those commands below.

Hmm. OK now I see, since cx18-fileops.c:cx18-serialized_open() will
never get called when there is a firmware load problem, the device nodes
will not be usable.  Sorry for not noticing that earlier.


> > 4. Please provide the output of
> >
> > # lspci -nnvv
> > # cat /proc/iomem
> > # grep Vmalloc /proc/mem
> 
> # lspci -nnvv
> 
> 00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] AMD-760
> [IGD4-1P] System Controller [1022:700e] (rev 13)
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>        Latency: 32
>        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
>        Region 1: Memory at e3001000 (32-bit, prefetchable) [size=4K]
>        Region 2: I/O ports at d000 [disabled] [size=4]
>        Capabilities: <access denied>
>        Kernel driver in use: agpgart-amdk7
>        Kernel modules: amd76x_edac, amd-k7-agp

I will note that the 64 MB PCI address region at 0xd8000000 is directly
below the CX23418 64 MB PCI address region at 0xdc00000.

That region is, I'm guessing, somehow involved with some sort of
graphics memory aperature.


> 00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] AMD-760
> [IGD4-1P] AGP Bridge [1022:700f]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32
>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
>        Memory behind bridge: e0000000-e1ffffff
>        Prefetchable memory behind bridge: d0000000-d7ffffff
>        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Kernel modules: shpchp
> 
> 00:07.0 ISA bridge [0601]: VIA Technologies, Inc. VT82C686 [Apollo
> Super South] [1106:0686] (rev 40)
>        Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super
> South] [1106:0686]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping+ SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0
>        Capabilities: <access denied>
>        Kernel driver in use: parport_pc
>        Kernel modules: parport_pc
> 
> 00:07.1 IDE interface [0101]: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
> (rev 06) (prog-if 8a [Master SecP PriP])
>        Subsystem: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32
>        Region 0: [virtual] Memory at 000001f0 (32-bit,
> non-prefetchable) [size=8]
>        Region 1: [virtual] Memory at 000003f0 (type 3,
> non-prefetchable) [size=1]
>        Region 2: [virtual] Memory at 00000170 (32-bit,
> non-prefetchable) [size=8]
>        Region 3: [virtual] Memory at 00000370 (type 3,
> non-prefetchable) [size=1]
>        Region 4: I/O ports at d400 [size=16]
>        Capabilities: <access denied>
>        Kernel driver in use: pata_via
> 
> 00:07.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
> USB 1.1 Controller [1106:3038] (rev 1a)
>        Subsystem: First International Computer, Inc. Device [0925:1234]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32, Cache Line Size: 32 bytes
>        Interrupt: pin D routed to IRQ 11
>        Region 4: I/O ports at d800 [size=32]
>        Capabilities: <access denied>
>        Kernel driver in use: uhci_hcd
> 
> 00:07.3 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
> USB 1.1 Controller [1106:3038] (rev 1a)
>        Subsystem: First International Computer, Inc. Device [0925:1234]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32, Cache Line Size: 32 bytes
>        Interrupt: pin D routed to IRQ 11
>        Region 4: I/O ports at dc00 [size=32]
>        Capabilities: <access denied>
>        Kernel driver in use: uhci_hcd
> 
> 00:07.4 SMBus [0c05]: VIA Technologies, Inc. VT82C686 [Apollo Super
> ACPI] [1106:3057] (rev 40)
>        Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
> [1106:3057]
>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Interrupt: pin ? routed to IRQ 9
>        Capabilities: <access denied>
>        Kernel modules: via686a, i2c-viapro
> 
> 00:09.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog
> Video/Broadcast Audio Decoder [14f1:5b7a]
>        Subsystem: Hauppauge computer works Inc. Device [0070:7444]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 5
>        Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=64M]
>        Capabilities: <access denied>
>        Kernel driver in use: cx18
>        Kernel modules: cx18

I will note that there are no Master or Target Aborts logged for the
CX23418.  I find that to be amazing, but certainly nothing to worry
about for you - having no PCI transfers errors is a good thing.


> 00:0b.0 Ethernet controller [0200]: ADMtek NC100 Network Everywhere
> Fast Ethernet 10/100 [1317:0985] (rev 11)
>        Subsystem: ADMtek Device [1317:0574]
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32 (63750ns min, 63750ns max), Cache Line Size: 32 bytes
>        Interrupt: pin A routed to IRQ 11
>        Region 0: I/O ports at e000 [size=256]
>        Region 1: Memory at e3000000 (32-bit, non-prefetchable) [size=1K]
>        [virtual] Expansion ROM at 30000000 [disabled] [size=128K]
>        Capabilities: <access denied>
>        Kernel driver in use: tulip
>        Kernel modules: tulip
> 
> 01:05.0 VGA compatible controller [0300]: nVidia Corporation NV18
> [GeForce4 MX 4000] [10de:0185] (rev a4)
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 248 (1250ns min, 250ns max)
>        Interrupt: pin A routed to IRQ 10
>        Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
>        Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
>        [virtual] Expansion ROM at e1000000 [disabled] [size=128K]
>        Capabilities: <access denied>
>        Kernel driver in use: nvidia
>        Kernel modules: nvidia, nvidiafb
> 
> 
> # cat /proc/iomem
> 
> 00000000-00001fff : System RAM
> 00002000-00005fff : reserved
> 00006000-0009fbff : System RAM
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000cf7ff : Video ROM
> 000d0000-000d3fff : pnp 00:00
> 000f0000-000fffff : reserved
>  000f0000-000fffff : System ROM
> 00100000-2ffeffff : System RAM
>  00100000-00575553 : Kernel code
>  00575554-0078d307 : Kernel data
>  0081a000-008a809f : Kernel bss
> 2fff0000-2fff2fff : ACPI Non-volatile Storage
> 2fff3000-2fffffff : ACPI Tables
> 30000000-3001ffff : 0000:00:0b.0
> d0000000-d7ffffff : PCI Bus 0000:01
>  d0000000-d7ffffff : 0000:01:05.0
> d8000000-dbffffff : 0000:00:00.0
> dc000000-dfffffff : 0000:00:09.0
>  dc000000-dfffffff : cx18 encoder
> e0000000-e1ffffff : PCI Bus 0000:01
>  e0000000-e0ffffff : 0000:01:05.0
>    e0000000-e0ffffff : nvidia
>  e1000000-e101ffff : 0000:01:05.0
> e3000000-e30003ff : 0000:00:0b.0
>  e3000000-e30003ff : tulip
> e3001000-e3001fff : 0000:00:00.0
> fee00000-fee00fff : pnp 00:00
> ffff0000-ffffffff : reserved
>  ffff0000-ffffffff : pnp 00:00
> 
> 
> grep Vmalloc /proc/meminfo
> 
> VmallocTotal:     262144 kB
> VmallocUsed:      90820 kB
> VmallocChunk:   135156 kB


OK.  Plenty of Vmalloc space is left - good.
> 
> 
> >> [43594.607137] cx18-0: Retry loading firmware
> >> [43594.608161] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
> >> [43594.649832] cx18-0: Mismatch at offset 0
> >> [43594.649848] cx18-0: Failed to initialize on minor 3
> >> [43594.682215] cx18-0: Failed to initialize on minor 3
> >
> > I cannot see in the code how you can legitimately get this message on a
> > simple open() call unless you are out of memory or something about the
> > struct cx18 instance structure is corrupt/wrong.  You should have at
> > least seen messages from these debug statements:
> >
> >        CX18_DEBUG_FILE("open %s\n", s->name);
> >        CX18_DEBUG_WARN("nomem on v4l2 open\n");
> >
> > Maybe I'm missing something or perhaps something went
> > to /var/log/messages but not to dmesg (or vice-versa)?
> 
> I do not see either of those dbug messages
> 
> # dmesg
[snip]

OK.  Thanks for the additional logs.


Assuming you knwo that the HVR-1600 works (i.e. you've tested it under
windows or in another machine)

At this point I only have two hypothesis:


1. The memory chip on the HVR-1600 has changed.  Can you please provide
what type of memory chip is on the board?  The two I know of are:

ESMT M13S128324A-5B (Normal production HVR-1600s)
or
Samsung K4D263238G-VC33 memory (supposedly only used on preproduction
boards)

If you have a different chip, that will explain why things aren't
working.

If you happen to have one with Samsung memory, you may want to force the
card type with:

 # modprobe cx18 cardtype=2

The cards with ESMT memory are cardtype=1.


2. Some other driver or device is continually, errantly writing in
CX23418 memory.  If this unlikely hypothesis is true, then I would first
look to the driver for the device with the PCI memory region just below
the CX23418's:

       Kernel driver in use: agpgart-amdk7
       Kernel modules: amd76x_edac, amd-k7-agp

Since it's a graphics aperature related driver, that would also lead to
looking at user space compoentns like the X server.

I'm fairly certain the amd76x_edac (Error Detection and Correction)
module wouldn't be to blame though.

I think hypothesis #2 is a stretch and unlikely to be true.  I suspect
the cause is HVR-1600 DDR memory configuration in hypothesis #1.

Regards,
Andy

