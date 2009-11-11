Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f177.google.com ([209.85.216.177]:32772 "EHLO
	mail-px0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZKKFUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 00:20:49 -0500
Received: by pxi7 with SMTP id 7so542081pxi.17
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 21:20:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ddfe20800911102113h66f34980rf3e2486eb05bb961@mail.gmail.com>
References: <ddfe20800911100913l2ebe777dya3ef47fc944e6897@mail.gmail.com>
	 <1257901423.4040.53.camel@palomino.walls.org>
	 <ddfe20800911102113h66f34980rf3e2486eb05bb961@mail.gmail.com>
Date: Wed, 11 Nov 2009 00:15:17 -0500
Message-ID: <ddfe20800911102115n4b71264dma843f77d4ee40e29@mail.gmail.com>
Subject: Fwd: Hauppauge HVR-1600 cx18 loading problem
From: John Nuszkowski <john.nuszkowski@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---------- Forwarded message ----------
From: John Nuszkowski <john.nuszkowski@gmail.com>
Date: Wed, Nov 11, 2009 at 12:13 AM
Subject: Re: Hauppauge HVR-1600 cx18 loading problem
To: Andy Walls <awalls@radix.net>


See my comments below.

On Tue, Nov 10, 2009 at 8:03 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2009-11-10 at 12:13 -0500, John Nuszkowski wrote:
>> My new Hauppauge HVR-1600 does not load the firmware.  The driver was
>> built using the source from over the weekend.  I am using mythbuntu.
>>
>> Below is a "modprobe cx18 debug=511" command
>>
>> Any help would greatly be appreciated.
>>
>> [43594.063182] cx18:  Start initialization, version 1.2.0
>> [43594.063306] cx18-0: Initializing card 0
>> [43594.063312] cx18-0: Autodetected Hauppauge card
>> [43594.063447] cx18-0:  info: base addr: 0xdc000000
>> [43594.063450] cx18-0:  info: Enabling pci device
>> [43594.063478] cx18 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 10
>> (level, low) -> IRQ 10
>> [43594.063493] cx18-0:  info: cx23418 (rev 0) at 00:0c.0, irq: 10,
>> latency: 64, memory: 0xdc000000
>> [43594.063498] cx18-0:  info: attempting ioremap at 0xdc000000 len 0x04000000
>> [43594.065656] cx18-0: cx23418 revision 01010000 (B)
>> [43594.246946] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
>> 00003001/00000000
>> [43594.246970] cx18-0:  info: activating i2c...
>> [43594.246973] cx18-0:  i2c: i2c init
>> [43594.362969] tveeprom 5-0050: Hauppauge model 74041, rev C6B2, serial# 6380357
>> [43594.362976] tveeprom 5-0050: MAC address is 00-0D-FE-61-5B-45
>> [43594.362981] tveeprom 5-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
>> [43594.362987] tveeprom 5-0050: TV standards NTSC(M) (eeprom 0x08)
>> [43594.362991] tveeprom 5-0050: audio processor is CX23418 (idx 38)
>> [43594.362995] tveeprom 5-0050: decoder processor is CX23418 (idx 31)
>> [43594.363000] tveeprom 5-0050: has no radio, has IR receiver, has IR
>> transmitter
>> [43594.363004] cx18-0: Autodetected Hauppauge HVR-1600
>> [43594.363008] cx18-0:  info: NTSC tuner detected
>> [43594.363011] cx18-0: Simultaneous Digital and Analog TV capture supported
>> [43594.542552] IRQ 10/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
>> [43594.551681] tuner 6-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
>> [43594.554867] cs5345 5-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
>> [43594.557430] tuner-simple 6-0061: creating new instance
>> [43594.557436] tuner-simple 6-0061: type set to 50 (TCL 2002N)
>> [43594.558186] cx18-0:  info: Allocate encoder MPEG stream: 64 x 32768
>> buffers (2048kB total)
>> [43594.558268] cx18-0:  info: Allocate TS stream: 32 x 32768 buffers
>> (1024kB total)
>> [43594.558310] cx18-0:  info: Allocate encoder YUV stream: 16 x 131072
>> buffers (2048kB total)
>> [43594.558351] cx18-0:  info: Allocate encoder VBI stream: 20 x 51984
>> buffers (1015kB total)
>> [43594.558389] cx18-0:  info: Allocate encoder PCM audio stream: 256 x
>> 4096 buffers (1024kB total)
>> [43594.558570] cx18-0:  info: Allocate encoder IDX stream: 32 x 32768
>> buffers (1024kB total)
>> [43594.558732] cx18-0: Registered device video1 for encoder MPEG (64 x 32 kB)
>> [43594.558738] DVB: registering new adapter (cx18)
>> [43594.594104] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
>> [43594.607124] cx18-0: Mismatch at offset 0
>
> OK.  That's bad.  From messages previous to this, we can obviously
> access CX23418 registers.  This "Mismatch at offset 0" message indicates
> that writes or reads to the memory chip on the HVR-1600 via the PCI bus
> and the CX23418 are failing.
>
> Possible causes are:
>
> 1. Repeated PCI bus errors when trying to write or write to the CX23418
> memory.
>
> 2. A new memory chip is is use on the HVR-1600 and the DRR memory
> configuration parameters in the HVR-1600 entry in cx18-cards.c are
> wrong.
>
> 3. Writes to CX23418 registers to configure the DDR memory parameters
> failed.
>
> 4. Some other device driver or device DMA engine is errantly writing
> into CX23418 memory space.
>
>
> Some things you can you do:
>
> 1. Pull *all* your PCI cards out of your machine, blow the dust out of
> the PCI slots, reseat all the cards and try again.  This should somewhat
> mitigate PCI signal problems due to dust and oxidation.

Nothing changed.  I also moved the card to another PCI slot.



> 2. In the file
>
>        cx18-driver.h
>
> change the value of
>
>        #define CX18_MAX_MMIO_WR_RETRIES 10
>
> up from 10 to 20 (or whatever) to increase the number of retries when
> writing to the CX23418 over the PCI bus.  Recompile and install the cx18
> driver and test again.


Same result.





> 3. If you still have /dev/video* device nodes after modprobe, even
> though the firmware load failed; compile the v4l-dbg in the v4l-dvb tree
> and run these commands as root:
>
> # v4l2-dbg -d /dev/video1 -S
> host0: cx23418    revision 0x01010000
> host1: cx23418_843 revision 0x00008430
> i2c 0x4c: cs5345     revision 0x00000000
>


# ./v4l2-dbg -D
Failed to open /dev/video0: No such device or address

# ls -al /dev/video*
crw-rw----+ 1 root video 81, 0 2009-11-10 21:52 /dev/video0
crw-rw----+ 1 root video 81, 3 2009-11-10 21:52 /dev/video24
crw-rw----+ 1 root video 81, 1 2009-11-10 21:52 /dev/video32

So basically v4l2-dbg doesn't work with this error.  I wish I could do
those commands below.


> # v4l2-dbg -d /dev/video1 -c host0 --list-registers=min=0x2c80000,max=0x2c80057
> ioctl: VIDIOC_DBG_G_REGISTER
>
>                00       04       08       0C       10       14       18       1C
> 02c80000: 00000001 00000003 0000030c 44220e82 00000008 00000000 00000000 00000010
> 02c80020: 00000000 00000003 00000000 00df1154 000bdef6 00000007 00000000 00000000
> 02c80040: 00000000 00000000 00000000 00000000 00000005 00000000
>
> These are the registers that hold the DRR ram configuration.  These are
> the values for my HVR-1600.
>
> Also
>
> # v4l2-dbg -d /dev/video0 -c host0 --list-registers=min=0x0000000,max=0x000005f
> ioctl: VIDIOC_DBG_G_REGISTER
>
>                00       04       08       0C       10       14       18       1C
> 00000000: e59ff018 e59ff018 e59ff018 e59ff018 e59ff018 e1a00000 e59ff014 e59ff014
> 00000020: 000173a4 00000040 00000044 00000048 0000004c 00011984 00000050 00020680
> 00000040: eafffffe eafffffe eafffffe eafffffe eafffffe e92d4070 e1a04000 e1a00001
>
> These are the first few words of the DDR ram memory on the HVR-1600
> connected to the CX23418 with the CPU firmware image loaded.
>
> You can test trying to wrtie to the CX23418's memory with a command
> sequence like this:
>
> # v4l2-dbg -d /dev/video0 -c host0 -g 0x14
> ioctl: VIDIOC_DBG_G_REGISTER
> Register 0x00000014 = e1a00000h (3785359360d  11100001 10100000 00000000 00000000b)
> # v4l2-dbg -d /dev/video0 -c host0 -s 0x14 0xe1a00001
> Register 0x00000014 set to 0xe1a00001
> # v4l2-dbg -d /dev/video0 -c host0 -g 0x14
> ioctl: VIDIOC_DBG_G_REGISTER
> Register 0x00000014 = e1a00001h (3785359361d  11100001 10100000 00000000 00000001b)
>
> Mucking with the memory word at 0x14 should be safe even when the
> CX23418 is in operation.
>
>
> 4. Please provide the output of
>
> # lspci -nnvv
> # cat /proc/iomem
> # grep Vmalloc /proc/mem

# lspci -nnvv

00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] AMD-760
[IGD4-1P] System Controller [1022:700e] (rev 13)
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
       Latency: 32
       Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
       Region 1: Memory at e3001000 (32-bit, prefetchable) [size=4K]
       Region 2: I/O ports at d000 [disabled] [size=4]
       Capabilities: <access denied>
       Kernel driver in use: agpgart-amdk7
       Kernel modules: amd76x_edac, amd-k7-agp

00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] AMD-760
[IGD4-1P] AGP Bridge [1022:700f]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
       Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32
       Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
       Memory behind bridge: e0000000-e1ffffff
       Prefetchable memory behind bridge: d0000000-d7ffffff
       Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
       BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
               PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
       Kernel modules: shpchp

00:07.0 ISA bridge [0601]: VIA Technologies, Inc. VT82C686 [Apollo
Super South] [1106:0686] (rev 40)
       Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super
South] [1106:0686]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 0
       Capabilities: <access denied>
       Kernel driver in use: parport_pc
       Kernel modules: parport_pc

00:07.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
(rev 06) (prog-if 8a [Master SecP PriP])
       Subsystem: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32
       Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [size=8]
       Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [size=1]
       Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [size=8]
       Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [size=1]
       Region 4: I/O ports at d400 [size=16]
       Capabilities: <access denied>
       Kernel driver in use: pata_via

00:07.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 1a)
       Subsystem: First International Computer, Inc. Device [0925:1234]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin D routed to IRQ 11
       Region 4: I/O ports at d800 [size=32]
       Capabilities: <access denied>
       Kernel driver in use: uhci_hcd

00:07.3 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 1a)
       Subsystem: First International Computer, Inc. Device [0925:1234]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32, Cache Line Size: 32 bytes
       Interrupt: pin D routed to IRQ 11
       Region 4: I/O ports at dc00 [size=32]
       Capabilities: <access denied>
       Kernel driver in use: uhci_hcd

00:07.4 SMBus [0c05]: VIA Technologies, Inc. VT82C686 [Apollo Super
ACPI] [1106:3057] (rev 40)
       Subsystem: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI]
[1106:3057]
       Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Interrupt: pin ? routed to IRQ 9
       Capabilities: <access denied>
       Kernel modules: via686a, i2c-viapro

00:09.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23418 Single-Chip MPEG-2 Encoder with Integrated Analog
Video/Broadcast Audio Decoder [14f1:5b7a]
       Subsystem: Hauppauge computer works Inc. Device [0070:7444]
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 64 (500ns min, 50000ns max), Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 5
       Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=64M]
       Capabilities: <access denied>
       Kernel driver in use: cx18
       Kernel modules: cx18

00:0b.0 Ethernet controller [0200]: ADMtek NC100 Network Everywhere
Fast Ethernet 10/100 [1317:0985] (rev 11)
       Subsystem: ADMtek Device [1317:0574]
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 32 (63750ns min, 63750ns max), Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 11
       Region 0: I/O ports at e000 [size=256]
       Region 1: Memory at e3000000 (32-bit, non-prefetchable) [size=1K]
       [virtual] Expansion ROM at 30000000 [disabled] [size=128K]
       Capabilities: <access denied>
       Kernel driver in use: tulip
       Kernel modules: tulip

01:05.0 VGA compatible controller [0300]: nVidia Corporation NV18
[GeForce4 MX 4000] [10de:0185] (rev a4)
       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 248 (1250ns min, 250ns max)
       Interrupt: pin A routed to IRQ 10
       Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
       Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
       [virtual] Expansion ROM at e1000000 [disabled] [size=128K]
       Capabilities: <access denied>
       Kernel driver in use: nvidia
       Kernel modules: nvidia, nvidiafb


# cat /proc/iomem

00000000-00001fff : System RAM
00002000-00005fff : reserved
00006000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf7ff : Video ROM
000d0000-000d3fff : pnp 00:00
000f0000-000fffff : reserved
 000f0000-000fffff : System ROM
00100000-2ffeffff : System RAM
 00100000-00575553 : Kernel code
 00575554-0078d307 : Kernel data
 0081a000-008a809f : Kernel bss
2fff0000-2fff2fff : ACPI Non-volatile Storage
2fff3000-2fffffff : ACPI Tables
30000000-3001ffff : 0000:00:0b.0
d0000000-d7ffffff : PCI Bus 0000:01
 d0000000-d7ffffff : 0000:01:05.0
d8000000-dbffffff : 0000:00:00.0
dc000000-dfffffff : 0000:00:09.0
 dc000000-dfffffff : cx18 encoder
e0000000-e1ffffff : PCI Bus 0000:01
 e0000000-e0ffffff : 0000:01:05.0
   e0000000-e0ffffff : nvidia
 e1000000-e101ffff : 0000:01:05.0
e3000000-e30003ff : 0000:00:0b.0
 e3000000-e30003ff : tulip
e3001000-e3001fff : 0000:00:00.0
fee00000-fee00fff : pnp 00:00
ffff0000-ffffffff : reserved
 ffff0000-ffffffff : pnp 00:00


grep Vmalloc /proc/meminfo

VmallocTotal:     262144 kB
VmallocUsed:      90820 kB
VmallocChunk:   135156 kB



>> [43594.607137] cx18-0: Retry loading firmware
>> [43594.608161] cx18 0000:00:0c.0: firmware: requesting v4l-cx23418-cpu.fw
>> [43594.649832] cx18-0: Mismatch at offset 0
>> [43594.649848] cx18-0: Failed to initialize on minor 3
>> [43594.682215] cx18-0: Failed to initialize on minor 3
>
> I cannot see in the code how you can legitimately get this message on a
> simple open() call unless you are out of memory or something about the
> struct cx18 instance structure is corrupt/wrong.  You should have at
> least seen messages from these debug statements:
>
>        CX18_DEBUG_FILE("open %s\n", s->name);
>        CX18_DEBUG_WARN("nomem on v4l2 open\n");
>
> Maybe I'm missing something or perhaps something went
> to /var/log/messages but not to dmesg (or vice-versa)?

I do not see either of those dbug messages

# dmesg

[10457.072193] cx18:  Start initialization, version 1.2.0
[10457.072311] cx18-0: Initializing card 0
[10457.072316] cx18-0: Autodetected Hauppauge card
[10457.074070] cx18-0:  info: base addr: 0xdc000000
[10457.074077] cx18-0:  info: Enabling pci device
[10457.074105] cx18 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 5
(level, low) -> IRQ 5
[10457.074123] cx18-0:  info: cx23418 (rev 0) at 00:09.0, irq: 5,
latency: 64, memory: 0xdc000000
[10457.074128] cx18-0:  info: attempting ioremap at 0xdc000000 len 0x04000000
[10457.076284] cx18-0: cx23418 revision 01010000 (B)
[10457.458781] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
00003001/00000000
[10457.458803] cx18-0:  info: activating i2c...
[10457.458806] cx18-0:  i2c: i2c init
[10457.574928] tveeprom 4-0050: Hauppauge model 74041, rev C6B2, serial# 6380357
[10457.574935] tveeprom 4-0050: MAC address is 00-0D-FE-61-5B-45
[10457.574939] tveeprom 4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
[10457.574944] tveeprom 4-0050: TV standards NTSC(M) (eeprom 0x08)
[10457.574949] tveeprom 4-0050: audio processor is CX23418 (idx 38)
[10457.574953] tveeprom 4-0050: decoder processor is CX23418 (idx 31)
[10457.574957] tveeprom 4-0050: has no radio, has IR receiver, has IR
transmitter
[10457.574962] cx18-0: Autodetected Hauppauge HVR-1600
[10457.574965] cx18-0:  info: NTSC tuner detected
[10457.574968] cx18-0: Simultaneous Digital and Analog TV capture supported
[10457.954650] IRQ 5/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
[10457.965343] tuner 5-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[10457.970584] cs5345 4-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[10457.975079] tuner-simple 5-0061: creating new instance
[10457.975087] tuner-simple 5-0061: type set to 50 (TCL 2002N)
[10457.975838] cx18-0:  info: Allocate encoder MPEG stream: 64 x 32768
buffers (2048kB total)
[10457.975928] cx18-0:  info: Allocate TS stream: 32 x 32768 buffers
(1024kB total)
[10457.975975] cx18-0:  info: Allocate encoder YUV stream: 16 x 131072
buffers (2048kB total)
[10457.986180] cx18-0:  info: Allocate encoder VBI stream: 20 x 51984
buffers (1015kB total)
[10457.986222] cx18-0:  info: Allocate encoder PCM audio stream: 256 x
4096 buffers (1024kB total)
[10457.986495] cx18-0:  info: Allocate encoder IDX stream: 32 x 32768
buffers (1024kB total)
[10457.986819] cx18-0: Registered device video0 for encoder MPEG (64 x 32 kB)
[10457.986826] DVB: registering new adapter (cx18)
[10458.008290] cx18 0000:00:09.0: firmware: requesting v4l-cx23418-cpu.fw
[10458.069215] MXL5005S: Attached at address 0x63
[10458.069230] DVB: registering adapter 0 frontend 0 (Samsung S5H1409
QAM/8VSB Frontend)...
[10458.069415] cx18-0: DVB Frontend registered
[10458.069420] cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
[10458.069467] cx18-0: Registered device video32 for encoder YUV (16 x 128 kB)
[10458.069505] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
[10458.069541] cx18-0: Registered device video24 for encoder PCM audio
(256 x 4 kB)
[10458.069546] cx18-0: Initialized card: Hauppauge HVR-1600
[10458.069585] cx18:  End initialization
[10458.103716] cx18-0: Mismatch at offset 0
[10458.103740] cx18-0: Retry loading firmware
[10458.104077] cx18 0000:00:09.0: firmware: requesting v4l-cx23418-cpu.fw
[10458.122560] cx18-0: Mismatch at offset 0
[10458.122575] cx18-0: Failed to initialize on minor 0
[10458.124373] cx18-0: Failed to initialize on minor 1
[10458.125557] cx18-0: Failed to initialize on minor 2
[10458.132842] cx18-0: Failed to initialize on minor 3
[10458.286672] cx18-0: Failed to initialize on minor 2
[10458.289944] cx18-0: Failed to initialize on minor 3
[10458.294484] cx18-0: Failed to initialize on minor 0
[10458.298326] cx18-0: Failed to initialize on minor 1





# tail -n 100 /var/log/messages

Nov 11 00:09:09 mythpvr-desktop kernel: [10457.072193] cx18:  Start
initialization, version 1.2.0
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.072311] cx18-0:
Initializing card 0
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.072316] cx18-0:
Autodetected Hauppauge card
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.074070] cx18-0:  info:
base addr: 0xdc000000
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.074077] cx18-0:  info:
Enabling pci device
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.074105] cx18
0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.074123] cx18-0:  info:
cx23418 (rev 0) at 00:09.0, irq: 5, latency: 64, memory: 0xdc000000
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.074128] cx18-0:  info:
attempting ioremap at 0xdc000000 len 0x04000000
Nov 11 00:09:09 mythpvr-desktop kernel: [10457.076284] cx18-0: cx23418
revision 01010000 (B)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.458781] cx18-0:  info:
GPIO initial dir: 0000cffe/0000ffff out: 00003001/00000000
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.458803] cx18-0:  info:
activating i2c...
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.458806] cx18-0:  i2c: i2c init
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574928] tveeprom
4-0050: Hauppauge model 74041, rev C6B2, serial# 6380357
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574935] tveeprom
4-0050: MAC address is 00-0D-FE-61-5B-45
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574939] tveeprom
4-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574944] tveeprom
4-0050: TV standards NTSC(M) (eeprom 0x08)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574949] tveeprom
4-0050: audio processor is CX23418 (idx 38)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574953] tveeprom
4-0050: decoder processor is CX23418 (idx 31)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574957] tveeprom
4-0050: has no radio, has IR receiver, has IR transmitter
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574962] cx18-0:
Autodetected Hauppauge HVR-1600
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574965] cx18-0:  info:
NTSC tuner detected
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.574968] cx18-0:
Simultaneous Digital and Analog TV capture supported
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.954650] IRQ 5/cx18-0:
IRQF_DISABLED is not guaranteed on shared IRQs
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.965343] tuner 5-0061:
chip found @ 0xc2 (cx18 i2c driver #0-1)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.970584] cs5345 4-004c:
chip found @ 0x98 (cx18 i2c driver #0-0)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.975079] tuner-simple
5-0061: creating new instance
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.975087] tuner-simple
5-0061: type set to 50 (TCL 2002N)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.975838] cx18-0:  info:
Allocate encoder MPEG stream: 64 x 32768 buffers (2048kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.975928] cx18-0:  info:
Allocate TS stream: 32 x 32768 buffers (1024kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.975975] cx18-0:  info:
Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.986180] cx18-0:  info:
Allocate encoder VBI stream: 20 x 51984 buffers (1015kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.986222] cx18-0:  info:
Allocate encoder PCM audio stream: 256 x 4096 buffers (1024kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.986495] cx18-0:  info:
Allocate encoder IDX stream: 32 x 32768 buffers (1024kB total)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.986819] cx18-0:
Registered device video0 for encoder MPEG (64 x 32 kB)
Nov 11 00:09:10 mythpvr-desktop kernel: [10457.986826] DVB:
registering new adapter (cx18)
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.008290] cx18
0000:00:09.0: firmware: requesting v4l-cx23418-cpu.fw
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069215] MXL5005S:
Attached at address 0x63
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069230] DVB:
registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069415] cx18-0: DVB
Frontend registered
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069420] cx18-0:
Registered DVB adapter0 for TS (32 x 32 kB)
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069467] cx18-0:
Registered device video32 for encoder YUV (16 x 128 kB)
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069505] cx18-0:
Registered device vbi0 for encoder VBI (20 x 51984 bytes)
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069541] cx18-0:
Registered device video24 for encoder PCM audio (256 x 4 kB)
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069546] cx18-0:
Initialized card: Hauppauge HVR-1600
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.069585] cx18:  End initialization
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.103740] cx18-0: Retry
loading firmware
Nov 11 00:09:10 mythpvr-desktop kernel: [10458.104077] cx18
0000:00:09.0: firmware: requesting v4l-cx23418-cpu.fw
