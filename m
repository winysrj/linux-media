Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41684 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab1HWRbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Aug 2011 13:31:53 -0400
Received: from [10.83.86.16] (unknown [88.162.125.7])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 0F20D940069
	for <linux-media@vger.kernel.org>; Tue, 23 Aug 2011 19:31:44 +0200 (CEST)
Message-ID: <4E53E3FF.5090109@streamvision.fr>
Date: Tue, 23 Aug 2011 19:31:43 +0200
From: =?ISO-8859-1?Q?St=E9phane_Railhet?=
	<stephane.railhet@streamvision.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Satelco DVBS CAM initialisation failing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I encounter a really strange problem with (I guess) linux DVB driver, I 
will try to be as clear as possible.

I have installed a clean debian squeeze and I choosed to use the debian 
backport kernel (2.6.38-bpo.2-686). I use a Satelco Easywatch DVBS (KNC 
One) with the budget_av driver, I have also a CI interface and two CAM 
(one Neotion Viacess and one Aston Viacess).
To control the card I use a soft of my own that seems to be OK with 
several DVB hardware until now (please tell me if you need any 
information about how it works).

On my first sandbox machine everything was fine (MACHINE 1). The card is 
OK and both CAM are working fine. Then I try to put the SAME hard drive 
+ DVB card + DVB CI + CAM in an two other machine (MACHINE 2, MACHINE 3) 
and it does not works with the Neotion Viacess CAM even if the Aston 
Viacess CAM is working fine.

Because I have no idea where the problem come from I will try to give 
you as much information as I can (CPU information, PCI information, 
module logs), please tell me if you need more.

If you have any idea where the problem com from...

---------------------------------------------------------------------------
---------------------------------------------------------------------------

MACHINE 1 (WORK)

---------------------------------------------------------------------------

CPU INFO :

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Pentium(R) Dual  CPU  E2220  @ 2.40GHz
stepping    : 13
cpu MHz        : 2400.358
cache size    : 1024 KB
physical id    : 0
siblings    : 1
core id        : 0
cpu cores    : 1
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc up arch_perfmon pebs bts aperfmperf pni dtes64 monitor 
ds_cpl est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts
bogomips    : 4800.71
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

---------------------------------------------------------------------------

PCI INFO :

00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM 
Controller/Host-Hub Interface (rev 02)
     Subsystem: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub 
Interface
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Region 0: Memory at f8000000 (32-bit, prefetchable) [size=4M]
     Capabilities: [e4] Vendor Specific Information: Len=06 <?>
     Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated 
Graphics Controller (rev 02) (prog-if 00 [VGA controller])
     Subsystem: Intel Corporation 82865G Integrated Graphics Controller
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 7
     Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
     Region 1: Memory at f8500000 (32-bit, non-prefetchable) [size=512K]
     Region 2: I/O ports at da00 [size=8]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [d0] Power Management version 1
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: i915

00:06.0 System peripheral: Intel Corporation 82865G/PE/P Processor to 
I/O Memory Interface (rev 02)
     Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Region 0: Memory at 3f800000 (32-bit, non-prefetchable) [size=4K]

00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #1
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 7
     Region 4: I/O ports at e100 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation Device 24d2
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 10
     Region 4: I/O ports at e300 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation Device 24d2
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 11
     Region 4: I/O ports at d800 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation Device 24d2
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 7
     Region 4: I/O ports at d900 [size=32]
     Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02) (prog-if 20 [EHCI])
     Subsystem: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI 
Controller
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 11
     Region 0: Memory at f8580000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 
00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
     I/O behind bridge: 0000c000-0000cfff
     Memory behind bridge: f8400000-f84fffff
     Prefetchable memory behind bridge: 3f700000-3f7fffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
     Subsystem: Intel Corporation Device 24d2
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx+
     Latency: 0
     Interrupt: pin A routed to IRQ 11
     Region 0: I/O ports at 01f0 [size=8]
     Region 1: I/O ports at 03f4 [size=1]
     Region 2: I/O ports at 0170 [size=8]
     Region 3: I/O ports at 0374 [size=1]
     Region 4: I/O ports at f000 [size=16]
     Region 5: Memory at 3f801000 (32-bit, non-prefetchable) [size=1K]
     Kernel driver in use: ata_piix

00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller 
(rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
     Subsystem: Intel Corporation 82801EB (ICH5) SATA Controller
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 11
     Region 0: I/O ports at db00 [size=8]
     Region 1: I/O ports at dc00 [size=4]
     Region 2: I/O ports at dd00 [size=8]
     Region 3: I/O ports at de00 [size=4]
     Region 4: I/O ports at df00 [size=16]
     Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus 
Controller (rev 02)
     Subsystem: Intel Corporation Device 24d2
     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Interrupt: pin B routed to IRQ 5
     Region 4: I/O ports at 0500 [size=32]
     Kernel driver in use: i801_smbus

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
     Subsystem: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC 
Gigabit Ethernet
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 5
     Region 0: I/O ports at c000 [size=256]
     Region 1: Memory at f8422000 (32-bit, non-prefetchable) [size=256]
     [virtual] Expansion ROM at 3f700000 [disabled] [size=128K]
     Capabilities: [dc] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: r8169

01:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
     Subsystem: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC 
Gigabit Ethernet
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 10
     Region 0: I/O ports at c400 [size=256]
     Region 1: Memory at f8420000 (32-bit, non-prefetchable) [size=256]
     [virtual] Expansion ROM at 3f720000 [disabled] [size=128K]
     Capabilities: [dc] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: r8169

01:0d.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
     Subsystem: KNC One Device 001b
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (3750ns min, 9500ns max)
     Interrupt: pin A routed to IRQ 9
     Region 0: Memory at f8421000 (32-bit, non-prefetchable) [size=512]
     Kernel driver in use: budget_av

---------------------------------------------------------------------------

DVB KMESG :

<4>[   39.220168] budget_av: ciintf_slot_reset(): ciintf_slot_reset
<4>[   39.400020] TUPLE type:0x1d length:4
<4>[   39.408025]   0x00: 0x00 .
<4>[   39.416026]   0x01: 0xdb .
<4>[   39.424025]   0x02: 0x08 .
<4>[   39.432025]   0x03: 0xff .
<4>[   39.448023] TUPLE type:0x1c length:3
<4>[   39.456025]   0x00: 0x00 .
<4>[   39.464025]   0x01: 0x08 .
<4>[   39.472025]   0x02: 0xff .
<4>[   39.488023] TUPLE type:0x15 length:18
<4>[   39.496024]   0x00: 0x05 .
<4>[   39.504025]   0x01: 0x00 .
<4>[   39.512025]   0x02: 0x4e N
<4>[   39.520025]   0x03: 0x45 E
<4>[   39.528025]   0x04: 0x4f O
<4>[   39.536025]   0x05: 0x54 T
<4>[   39.544025]   0x06: 0x49 I
<4>[   39.552025]   0x07: 0x4f O
<4>[   39.560025]   0x08: 0x4e N
<4>[   39.568032]   0x09: 0x00 .
<4>[   39.576025]   0x0a: 0x43 C
<4>[   39.584031]   0x0b: 0x41 A
<4>[   39.592025]   0x0c: 0x4d M
<4>[   39.600025]   0x0d: 0x00 .
<4>[   39.608025]   0x0e: 0x43 C
<4>[   39.616025]   0x0f: 0x49 I
<4>[   39.624025]   0x10: 0x00 .
<4>[   39.632025]   0x11: 0xff .
<4>[   39.648023] TUPLE type:0x20 length:4
<4>[   39.656024]   0x00: 0xff .
<4>[   39.664025]   0x01: 0xff .
<4>[   39.672025]   0x02: 0x01 .
<4>[   39.680025]   0x03: 0x00 .
<4>[   39.696023] TUPLE type:0x1a length:21
<4>[   39.704024]   0x00: 0x01 .
<4>[   39.712025]   0x01: 0x0f .
<4>[   39.720025]   0x02: 0xfe .
<4>[   39.728025]   0x03: 0x01 .
<4>[   39.736025]   0x04: 0x01 .
<4>[   39.744025]   0x05: 0xc0 .
<4>[   39.752025]   0x06: 0x0e .
<4>[   39.760025]   0x07: 0x41 A
<4>[   39.768029]   0x08: 0x02 .
<4>[   39.776025]   0x09: 0x44 D
<4>[   39.784025]   0x0a: 0x56 V
<4>[   39.792025]   0x0b: 0x42 B
<4>[   39.800025]   0x0c: 0x5f _
<4>[   39.808025]   0x0d: 0x43 C
<4>[   39.816029]   0x0e: 0x49 I
<4>[   39.824025]   0x0f: 0x5f _
<4>[   39.832031]   0x10: 0x56 V
<4>[   39.840025]   0x11: 0x31 1
<4>[   39.848025]   0x12: 0x2e .
<4>[   39.856025]   0x13: 0x30 0
<4>[   39.864025]   0x14: 0x30 0
<4>[   39.880023] TUPLE type:0x1b length:14
<4>[   39.888024]   0x00: 0xc2 .
<4>[   39.896025]   0x01: 0x41 A
<4>[   39.904025]   0x02: 0x09 .
<4>[   39.912025]   0x03: 0x37 7
<4>[   39.920025]   0x04: 0x55 U
<4>[   39.928025]   0x05: 0x4d M
<4>[   39.936025]   0x06: 0x5d ]
<4>[   39.944025]   0x07: 0x56 V
<4>[   39.952025]   0x08: 0x56 V
<4>[   39.960025]   0x09: 0xaa .
<4>[   39.968030]   0x0a: 0x60 `
<4>[   39.976025]   0x0b: 0x20
<4>[   39.984025]   0x0c: 0x03 .
<4>[   39.992025]   0x0d: 0x03 .
<4>[   40.008023] TUPLE type:0x1b length:38
<4>[   40.016024]   0x00: 0xcf .
<4>[   40.024025]   0x01: 0x04 .
<4>[   40.032025]   0x02: 0x19 .
<4>[   40.040025]   0x03: 0x37 7
<4>[   40.048025]   0x04: 0x55 U
<4>[   40.056025]   0x05: 0x4d M
<4>[   40.064025]   0x06: 0x5d ]
<4>[   40.072025]   0x07: 0x56 V
<4>[   40.080031]   0x08: 0x56 V
<4>[   40.088025]   0x09: 0x22 "
<4>[   40.096025]   0x0a: 0x20
<4>[   40.104025]   0x0b: 0xc0 .
<4>[   40.112025]   0x0c: 0x09 .
<4>[   40.120025]   0x0d: 0x44 D
<4>[   40.128025]   0x0e: 0x56 V
<4>[   40.136025]   0x0f: 0x42 B
<4>[   40.144025]   0x10: 0x5f _
<4>[   40.152025]   0x11: 0x48 H
<4>[   40.160025]   0x12: 0x4f O
<4>[   40.168029]   0x13: 0x53 S
<4>[   40.176025]   0x14: 0x54 T
<4>[   40.184025]   0x15: 0x00 .
<4>[   40.192025]   0x16: 0xc1 .
<4>[   40.200025]   0x17: 0x0e .
<4>[   40.208025]   0x18: 0x44 D
<4>[   40.216025]   0x19: 0x56 V
<4>[   40.224025]   0x1a: 0x42 B
<4>[   40.232025]   0x1b: 0x5f _
<4>[   40.240025]   0x1c: 0x43 C
<4>[   40.248025]   0x1d: 0x49 I
<4>[   40.256022]   0x1e: 0x5f _
<4>[   40.264022]   0x1f: 0x4d M
<4>[   40.272022]   0x20: 0x4f O
<4>[   40.280021]   0x21: 0x44 D
<4>[   40.288022]   0x22: 0x55 U
<4>[   40.296021]   0x23: 0x4c L
<4>[   40.304023]   0x24: 0x45 E
<4>[   40.312022]   0x25: 0x00 .
<4>[   40.328028] TUPLE type:0x14 length:0
<4>[   40.336024] END OF CHAIN TUPLE type:0xff
<4>[   40.336028] Valid DVB CAM detected MANID:ffff DEVID:1 
CONFIGBASE:0x1fe CONFIGOPTION:0xf
<4>[   40.336033] dvb_ca_en50221_set_configoption
<4>[   40.352022] Set configoption 0xf, read configoption 0xf
<4>[   40.352032] DVB CAM validated successfully
<4>[   40.352043] dvb_ca_en50221_link_init
<4>[   40.352052] dvb_ca_en50221_wait_if_status
<4>[   40.352062] dvb_ca_en50221_wait_if_status succeeded timeout:0
<4>[   40.352065] dvb_ca_en50221_read_data
<4>[   40.352117] Received CA packet for slot 0 connection id 0x1 
last_frag:1 size:0x2
<4>[   40.352126] Chosen link buffer size of 256
<4>[   40.352133] dvb_ca_en50221_wait_if_status
<4>[   40.352141] dvb_ca_en50221_wait_if_status succeeded timeout:0
<4>[   40.352143] dvb_ca_en50221_write_data
<4>[   40.352197] Wrote CA packet for slot 0, connection id 0x1 
last_frag:1 size:0x2
<4>[   40.352229] budget_av: ciintf_slot_ts_enable(): 
ciintf_slot_ts_enable: 8
<4>[   40.352232] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully
<4>[   40.452031] dvb_ca_en50221_read_data
<4>[   40.552032] dvb_ca_en50221_read_data
<4>[   40.652019] dvb_ca_en50221_read_data
<4>[   40.752021] dvb_ca_en50221_read_data
<4>[   40.852093] dvb_ca_en50221_read_data
<4>[   40.952019] dvb_ca_en50221_read_data
<4>[   41.052020] dvb_ca_en50221_read_data
<4>[   41.152018] dvb_ca_en50221_read_data
<4>[   41.252022] dvb_ca_en50221_read_data
<4>[   41.352021] dvb_ca_en50221_read_data
<4>[   41.452017] dvb_ca_en50221_read_data
<4>[   41.552026] dvb_ca_en50221_read_data
<4>[   41.652014] dvb_ca_en50221_read_data
<4>[   41.752029] dvb_ca_en50221_read_data
<4>[   41.852017] dvb_ca_en50221_read_data
<4>[   41.952024] dvb_ca_en50221_read_data
<4>[   42.052015] dvb_ca_en50221_read_data
<4>[   42.152025] dvb_ca_en50221_read_data
<4>[   42.252014] dvb_ca_en50221_read_data
<4>[   42.352018] dvb_ca_en50221_read_data
<4>[   42.452024] dvb_ca_en50221_read_data
<4>[   42.552013] dvb_ca_en50221_read_data
<4>[   42.652028] dvb_ca_en50221_read_data
<4>[   42.752013] dvb_ca_en50221_read_data
<4>[   42.852020] dvb_ca_en50221_read_data
<4>[   42.952022] dvb_ca_en50221_read_data
<4>[   43.052018] dvb_ca_en50221_read_data
<4>[   43.152026] dvb_ca_en50221_read_data
<4>[   43.252011] dvb_ca_en50221_read_data
<4>[   43.352021] dvb_ca_en50221_read_data
<4>[   43.452017] dvb_ca_en50221_read_data
<4>[   43.552032] dvb_ca_en50221_read_data
<4>[   43.652014] dvb_ca_en50221_read_data
<4>[   43.752028] dvb_ca_en50221_read_data
<4>[   43.852019] dvb_ca_en50221_read_data
<4>[   43.952020] dvb_ca_en50221_read_data
<4>[   44.052018] dvb_ca_en50221_read_data
<4>[   44.152017] dvb_ca_en50221_read_data
<4>[   44.220370] dvb_ca_en50221_io_do_ioctl
<4>[   44.220376] dvb_ca_en50221_io_do_ioctl
<4>[   44.220385] dvb_ca_en50221_io_poll
<4>[   44.240453] dvb_ca_en50221_io_poll
<4>[   44.240576] dvb_ca_en50221_io_write
<4>[   44.240578] dvb_ca_en50221_write_data
<4>[   44.240653] Wrote CA packet for slot 0, connection id 0x1 
last_frag:1 size:0x5
<4>[   44.240696] dvb_ca_en50221_io_do_ioctl
<4>[   44.240698] dvb_ca_en50221_io_poll
<4>[   44.252033] dvb_ca_en50221_read_data
<4>[   44.252136] Received CA packet for slot 0 connection id 0x1 
last_frag:1 size:0x9
<4>[   44.252138] dvb_ca_en50221_read_data
<4>[   44.252148] dvb_ca_en50221_io_poll
<4>[   44.252153] dvb_ca_en50221_io_read
<4>[   44.252192] dvb_ca_en50221_io_poll
<4>[   44.272260] dvb_ca_en50221_io_poll
<4>[   44.272347] dvb_ca_en50221_io_write
<4>[   44.272350] dvb_ca_en50221_write_data
<4>[   44.272431] Wrote CA packet for slot 0, connection id 0x1 
last_frag:1 size:0x5
<4>[   44.272443] dvb_ca_en50221_io_do_ioctl
<4>[   44.272445] dvb_ca_en50221_io_poll

ECT...

---------------------------------------------------------------------------
---------------------------------------------------------------------------

MACHINE 2 (DON'T WORK)

---------------------------------------------------------------------------

CPU INFO :

processor    : 0
vendor_id    : CentaurHauls
cpu family    : 6
model        : 9
model name    : VIA Nehemiah
stepping    : 8
cpu MHz        : 1002.222
cache size    : 64 KB
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 1
wp        : yes
flags        : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr 
sse up rng rng_en ace ace_en
bogomips    : 2004.44
clflush size    : 32
cache_alignment    : 32
address sizes    : 32 bits physical, 32 bits virtual
power management:

---------------------------------------------------------------------------

PCI INFO :

00:00.0 Host bridge: VIA Technologies, Inc. VT8623 [Apollo CLE266]
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 8
     Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
     Capabilities: [a0] AGP version 2.0
         Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW- AGP3- Rate=x1,x2,x4
         Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x4
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: agpgart-via

00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP] 
(prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR+ INTx-
     Latency: 0
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     Memory behind bridge: dc000000-ddffffff
     Prefetchable memory behind bridge: d8000000-dbffffff
     Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR+
     BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 Ethernet controller: VIA Technologies, Inc. VT6105/VT6106S 
[Rhine-III] (rev 8b)
     Subsystem: VIA Technologies, Inc. Device 0106
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 11
     Region 0: I/O ports at d000 [size=256]
     Region 1: Memory at de000000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [44] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: via-rhine

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 10
     Region 4: I/O ports at d400 [size=32]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: uhci_hcd

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin B routed to IRQ 12
     Region 4: I/O ports at d800 [size=32]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: uhci_hcd

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
Controller (rev 80) (prog-if 00 [UHCI])
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin C routed to IRQ 11
     Region 4: I/O ports at dc00 [size=32]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: uhci_hcd

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 
20 [EHCI])
     Subsystem: VIA Technologies, Inc. USB 2.0
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32, Cache Line Size: 32 bytes
     Interrupt: pin D routed to IRQ 11
     Region 0: Memory at de001000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [80] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: ehci_hcd

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) 
(prog-if 8a [Master SecP PriP])
     Subsystem: VIA Technologies, Inc. Device aa01
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32
     Interrupt: pin A routed to IRQ 10
     Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[size=8]
     Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[size=1]
     Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[size=8]
     Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[size=1]
     Region 4: I/O ports at e000 [size=16]
     Capabilities: [c0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: pata_via

00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] 
(rev 74)
     Subsystem: VIA Technologies, Inc. VT6102 [Rhine II] Embeded 
Ethernet Controller on VT8235
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 10
     Region 0: I/O ports at e400 [size=256]
     Region 1: Memory at de002000 (32-bit, non-prefetchable) [size=256]
     Capabilities: [40] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: via-rhine

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
     Subsystem: KNC One Device 001b
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (3750ns min, 9500ns max)
     Interrupt: pin A routed to IRQ 12
     Region 0: Memory at de003000 (32-bit, non-prefetchable) [size=512]
     Kernel driver in use: budget_av

01:00.0 VGA compatible controller: VIA Technologies, Inc. VT8623 [Apollo 
CLE266] integrated CastleRock graphics (rev 03) (prog-if 00 [VGA 
controller])
     Subsystem: VIA Technologies, Inc. VT8623 [Apollo CLE266] integrated 
CastleRock graphics
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 32 (500ns min)
     Interrupt: pin A routed to IRQ 255
     Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
     Region 1: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
     [virtual] Expansion ROM at dd000000 [disabled] [size=64K]
     Capabilities: [60] Power Management version 2
         Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [70] AGP version 2.0
         Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW- AGP3- Rate=x1,x2,x4
         Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- 
Rate=<none>

---------------------------------------------------------------------------

DVB KMESG :

<4>[   28.846120] budget_av: ciintf_slot_reset(): ciintf_slot_reset
<4>[   29.000072] TUPLE type:0x1d length:4
<4>[   29.000089]   0x00: 0x00 .
<4>[   29.000102]   0x01: 0xdb .
<4>[   29.000115]   0x02: 0x08 .
<4>[   29.000128]   0x03: 0xff .
<4>[   29.000146] TUPLE type:0x1c length:3
<4>[   29.000159]   0x00: 0x00 .
<4>[   29.000172]   0x01: 0x08 .
<4>[   29.000184]   0x02: 0xff .
<4>[   29.000203] TUPLE type:0x15 length:18
<4>[   29.000216]   0x00: 0x05 .
<4>[   29.000228]   0x01: 0x00 .
<4>[   29.000241]   0x02: 0x4e N
<4>[   29.000253]   0x03: 0x45 E
<4>[   29.000266]   0x04: 0x4f O
<4>[   29.000278]   0x05: 0x54 T
<4>[   29.000291]   0x06: 0x49 I
<4>[   29.000303]   0x07: 0x4f O
<4>[   29.000316]   0x08: 0x4e N
<4>[   29.000328]   0x09: 0x00 .
<4>[   29.000341]   0x0a: 0x43 C
<4>[   29.000354]   0x0b: 0x41 A
<4>[   29.000366]   0x0c: 0x4d M
<4>[   29.000378]   0x0d: 0x00 .
<4>[   29.000391]   0x0e: 0x43 C
<4>[   29.000403]   0x0f: 0x49 I
<4>[   29.000416]   0x10: 0x00 .
<4>[   29.000428]   0x11: 0xff .
<4>[   29.000447] TUPLE type:0x20 length:4
<4>[   29.000460]   0x00: 0xff .
<4>[   29.000472]   0x01: 0xff .
<4>[   29.000485]   0x02: 0x01 .
<4>[   29.000497]   0x03: 0x00 .
<4>[   29.000516] TUPLE type:0x1a length:21
<4>[   29.000529]   0x00: 0x01 .
<4>[   29.000541]   0x01: 0x0f .
<4>[   29.000554]   0x02: 0xfe .
<4>[   29.000566]   0x03: 0x01 .
<4>[   29.000579]   0x04: 0x01 .
<4>[   29.000591]   0x05: 0xc0 .
<4>[   29.000604]   0x06: 0x0e .
<4>[   29.000616]   0x07: 0x41 A
<4>[   29.000629]   0x08: 0x02 .
<4>[   29.000641]   0x09: 0x44 D
<4>[   29.000654]   0x0a: 0x56 V
<4>[   29.000666]   0x0b: 0x42 B
<4>[   29.000679]   0x0c: 0x5f _
<4>[   29.000691]   0x0d: 0x43 C
<4>[   29.000704]   0x0e: 0x49 I
<4>[   29.000716]   0x0f: 0x5f _
<4>[   29.000729]   0x10: 0x56 V
<4>[   29.000741]   0x11: 0x31 1
<4>[   29.000754]   0x12: 0x2e .
<4>[   29.000766]   0x13: 0x30 0
<4>[   29.000779]   0x14: 0x30 0
<4>[   29.000799] TUPLE type:0x1b length:14
<4>[   29.000812]   0x00: 0xc2 .
<4>[   29.000825]   0x01: 0x41 A
<4>[   29.000837]   0x02: 0x09 .
<4>[   29.000850]   0x03: 0x37 7
<4>[   29.000862]   0x04: 0x55 U
<4>[   29.000875]   0x05: 0x4d M
<4>[   29.000887]   0x06: 0x5d ]
<4>[   29.000900]   0x07: 0x56 V
<4>[   29.000912]   0x08: 0x56 V
<4>[   29.000925]   0x09: 0xaa .
<4>[   29.000937]   0x0a: 0x60 `
<4>[   29.000950]   0x0b: 0x20
<4>[   29.000962]   0x0c: 0x03 .
<4>[   29.000975]   0x0d: 0x03 .
<4>[   29.000993] TUPLE type:0x1b length:38
<4>[   29.001007]   0x00: 0xcf .
<4>[   29.001019]   0x01: 0x04 .
<4>[   29.001032]   0x02: 0x19 .
<4>[   29.001044]   0x03: 0x37 7
<4>[   29.001057]   0x04: 0x55 U
<4>[   29.001069]   0x05: 0x4d M
<4>[   29.001082]   0x06: 0x5d ]
<4>[   29.001094]   0x07: 0x56 V
<4>[   29.001107]   0x08: 0x56 V
<4>[   29.001119]   0x09: 0x22 "
<4>[   29.001132]   0x0a: 0x20
<4>[   29.001144]   0x0b: 0xc0 .
<4>[   29.001157]   0x0c: 0x09 .
<4>[   29.001169]   0x0d: 0x44 D
<4>[   29.001182]   0x0e: 0x56 V
<4>[   29.001194]   0x0f: 0x42 B
<4>[   29.001207]   0x10: 0x5f _
<4>[   29.001219]   0x11: 0x48 H
<4>[   29.001232]   0x12: 0x4f O
<4>[   29.001244]   0x13: 0x53 S
<4>[   29.001257]   0x14: 0x54 T
<4>[   29.001269]   0x15: 0x00 .
<4>[   29.001282]   0x16: 0xc1 .
<4>[   29.001294]   0x17: 0x0e .
<4>[   29.001307]   0x18: 0x44 D
<4>[   29.001320]   0x19: 0x56 V
<4>[   29.001332]   0x1a: 0x42 B
<4>[   29.001345]   0x1b: 0x5f _
<4>[   29.001357]   0x1c: 0x43 C
<4>[   29.001369]   0x1d: 0x49 I
<4>[   29.001382]   0x1e: 0x5f _
<4>[   29.001394]   0x1f: 0x4d M
<4>[   29.001407]   0x20: 0x4f O
<4>[   29.001420]   0x21: 0x44 D
<4>[   29.001432]   0x22: 0x55 U
<4>[   29.001445]   0x23: 0x4c L
<4>[   29.001457]   0x24: 0x45 E
<4>[   29.001470]   0x25: 0x00 .
<4>[   29.001490] TUPLE type:0x14 length:0
<4>[   29.001503] END OF CHAIN TUPLE type:0xff
<4>[   29.001513] Valid DVB CAM detected MANID:ffff DEVID:1 
CONFIGBASE:0x1fe CONFIGOPTION:0xf
<4>[   29.001523] dvb_ca_en50221_set_configoption
<4>[   29.001543] Set configoption 0xf, read configoption 0xf
<4>[   29.001556] DVB CAM validated successfully
<4>[   29.500060] dvb_ca_en50221_link_init
<4>[   29.500078] dvb_ca_en50221_wait_if_status
<4>[   29.604054] dvb_ca_en50221_wait_if_status failed timeout:26
<4>[   29.604071] dvb_ca adapter 0: DVB CAM link initialisation failed :(
<4>[   33.846693] dvb_ca_en50221_io_do_ioctl

---------------------------------------------------------------------------
---------------------------------------------------------------------------

MACHINE 3

---------------------------------------------------------------------------

CPU INFO :

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Pentium(R) Dual-Core  CPU      E5400  @ 2.70GHz
stepping    : 10
cpu MHz        : 2691.722
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
apicid        : 0
initial apicid    : 0
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
vmx est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm dts tpr_shadow vnmi 
flexpriority
bogomips    : 5383.44
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 23
model name    : Pentium(R) Dual-Core  CPU      E5400  @ 2.70GHz
stepping    : 10
cpu MHz        : 2691.722
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
apicid        : 1
initial apicid    : 1
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 13
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
vmx est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm dts tpr_shadow vnmi 
flexpriority
bogomips    : 5382.86
clflush size    : 64
cache_alignment    : 64
address sizes    : 36 bits physical, 48 bits virtual
power management:

---------------------------------------------------------------------------

PCI INFO :

00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller 
(rev 02)
     Subsystem: Intel Corporation 82Q35 Express DRAM Controller
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0b <?>
     Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation 82Q35 Express 
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
     Subsystem: Intel Corporation 82Q35 Express Integrated Graphics 
Controller
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 44
     Region 0: Memory at fe880000 (32-bit, non-prefetchable) [size=512K]
     Region 1: I/O ports at dc00 [size=8]
     Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
     Region 3: Memory at fe700000 (32-bit, non-prefetchable) [size=1M]
     Expansion ROM at <unassigned> [disabled]
     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4189
     Capabilities: [d0] Power Management version 2
         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Kernel driver in use: i915

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation Optiplex 755
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 16
     Region 4: I/O ports at d880 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation Optiplex 755
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 21
     Region 4: I/O ports at d800 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin D routed to IRQ 19
     Region 4: I/O ports at d480 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02) (prog-if 20 [EHCI])
     Subsystem: Intel Corporation Optiplex 755
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 0: Memory at fe87bc00 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci_hcd

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 1 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
     I/O behind bridge: 00001000-00001fff
     Memory behind bridge: 3f700000-3f8fffff
     Prefetchable memory behind bridge: 000000003f900000-000000003fafffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- 
Interlock-
             Changed: MRL- PresDet- LinkState-
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4159
     Capabilities: [90] Subsystem: Intel Corporation Optiplex 755
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=01 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 2 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
     I/O behind bridge: 0000e000-0000efff
     Memory behind bridge: 3fb00000-3fcfffff
     Prefetchable memory behind bridge: 000000003fd00000-000000003fefffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4161
     Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 2
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=02 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 3 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
     I/O behind bridge: 00002000-00002fff
     Memory behind bridge: fe900000-fe9fffff
     Prefetchable memory behind bridge: 000000003ff00000-00000000400fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4169
     Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 3
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=03 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express 
Port 4 (rev 02) (prog-if 00 [Normal decode])
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
     I/O behind bridge: 00003000-00003fff
     Memory behind bridge: fea00000-feafffff
     Prefetchable memory behind bridge: 0000000040100000-00000000402fffff
     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 128 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <256ns, L1 <4us
             ClockPM- Surprise- LLActRep+ BwNot-
         LnkCtl:    ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ 
Surprise+
             Slot #0, PowerLimit 10.000W; Interlock- NoCompl-
         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
             Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ 
Interlock-
             Changed: MRL- PresDet+ LinkState+
         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- 
CRSVisible-
         RootCap: CRSVisible-
         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
     Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Address: fee0300c  Data: 4171
     Capabilities: [90] Subsystem: Intel Corporation 82801I (ICH9 
Family) PCI Express Port 4
     Capabilities: [a0] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [100 v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed+ WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [180 v1] Root Complex Link
         Desc:    PortNumber=04 ComponentID=00 EltType=Config
         Link0:    Desc:    TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
             Addr:    00000000fed1c000
     Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 4: I/O ports at d400 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 4: I/O ports at d080 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
     Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin C routed to IRQ 18
     Region 4: I/O ports at d000 [size=32]
     Capabilities: [50] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02) (prog-if 20 [EHCI])
     Subsystem: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin A routed to IRQ 23
     Region 0: Memory at fe87b800 (32-bit, non-prefetchable) [size=1K]
     Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [58] Debug port: BAR=1 offset=00a0
     Capabilities: [98] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 
01 [Subtractive decode])
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
     Memory behind bridge: feb00000-febfffff
     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
     BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
     Capabilities: [50] Subsystem: Intel Corporation 82801 PCI Bridge

00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface 
Controller (rev 02)
     Subsystem: Intel Corporation 82801IR (ICH9R) LPC Interface Controller
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4 
port SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
     Subsystem: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4 port 
SATA IDE Controller
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at cc00 [size=8]
     Region 1: I/O ports at c880 [size=4]
     Region 2: I/O ports at c800 [size=8]
     Region 3: I/O ports at c480 [size=4]
     Region 4: I/O ports at c400 [size=16]
     Region 5: I/O ports at c080 [size=16]
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [b0] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ata_piix

00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port 
SATA IDE Controller (rev 02) (prog-if 85 [Master SecO PriO])
     Subsystem: Intel Corporation 82801I (ICH9 Family) 2 port SATA IDE 
Controller
     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0
     Interrupt: pin B routed to IRQ 19
     Region 0: I/O ports at c000 [size=8]
     Region 1: I/O ports at bc00 [size=4]
     Region 2: I/O ports at b880 [size=8]
     Region 3: I/O ports at b800 [size=4]
     Region 4: I/O ports at b480 [size=16]
     Region 5: I/O ports at b400 [size=16]
     Capabilities: [70] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [b0] PCI Advanced Features
         AFCap: TP+ FLR+
         AFCtrl: FLR-
         AFStatus: TP-
     Kernel driver in use: ata_piix

02:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller 
(prog-if 85 [Master SecO PriO])
     Subsystem: JMicron Technology Corp. Device 2361
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 17
     Region 0: I/O ports at ec00 [size=8]
     Region 1: I/O ports at e880 [size=4]
     Region 2: I/O ports at e800 [size=8]
     Region 3: I/O ports at e480 [size=4]
     Region 4: I/O ports at e400 [size=16]
     Capabilities: [68] Power Management version 2
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
     Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 512 bytes
         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- 
TransPend-
         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency 
L0 unlimited, L1 unlimited
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Kernel driver in use: pata_jmicron

03:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M 
Gigabit Ethernet PCI Express (rev 02)
     Subsystem: Broadcom Corporation Device 9693
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 18
     Region 0: Memory at fe9f0000 (64-bit, non-prefetchable) [size=64K]
     Capabilities: [48] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [50] Vital Product Data
         Product Name: Broadcom NetLink Gigabit Ethernet Controller
         Read-only fields:
             [PN] Part number: BCM95787m
             [EC] Engineering changes: 106679-15
             [SN] Serial number: 0123456789
             [MN] Manufacture ID: 31 34 65 34
             [RV] Reserved: checksum good, 29 byte(s) reserved
         Read/write fields:
             [YA] Asset tag: XYZ01234567
             [RW] Read-write area: 107 byte(s) free
         End
     Capabilities: [58] Vendor Specific Information: Len=78 <?>
     Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
         Address: 10d011c14202c378  Data: 0e00
     Capabilities: [d0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <4us, L1 <64us
             ClockPM+ Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Capabilities: [13c v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [160 v1] Device Serial Number 00-18-7d-ff-fe-12-da-10
     Capabilities: [16c v1] Power Budgeting <?>
     Kernel driver in use: tg3

04:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M 
Gigabit Ethernet PCI Express (rev 02)
     Subsystem: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet 
PCI Express
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 0, Cache Line Size: 32 bytes
     Interrupt: pin A routed to IRQ 45
     Region 0: Memory at feaf0000 (64-bit, non-prefetchable) [size=64K]
     Expansion ROM at <ignored> [disabled]
     Capabilities: [48] Power Management version 3
         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
         Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=1 PME-
     Capabilities: [50] Vital Product Data
         Product Name: Broadcom NetXtreme Gigabit Ethernet Controller
         Read-only fields:
             [PN] Part number: BCM95751
             [EC] Engineering changes: 106679-15
             [SN] Serial number: 0123456789
             [MN] Manufacture ID: 31 34 65 34
             [RV] Reserved: checksum bad, 26 byte(s) reserved
         No end tag found
     Capabilities: [58] Vendor Specific Information: Len=78 <?>
     Capabilities: [e8] MSI: Enable+ Count=1/1 Maskable- 64bit+
         Address: 00000000fee0300c  Data: 4191
     Capabilities: [d0] Express (v1) Endpoint, MSI 00
         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, 
L1 unlimited
             ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
             RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
             MaxPayload 128 bytes, MaxReadReq 4096 bytes
         DevSta:    CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ 
TransPend-
         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <4us, L1 <64us
             ClockPM- Surprise- LLActRep- BwNot-
         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
     Capabilities: [100 v1] Advanced Error Reporting
         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
         CESta:    RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
     Capabilities: [13c v1] Virtual Channel
         Caps:    LPEVC=0 RefClk=100ns PATEntryBits=1
         Arb:    Fixed- WRR32- WRR64- WRR128-
         Ctrl:    ArbSelect=Fixed
         Status:    InProgress-
         VC0:    Caps:    PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
             Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
             Ctrl:    Enable+ ID=0 ArbSelect=Fixed TC/VC=01
             Status:    NegoPending- InProgress-
     Capabilities: [160 v1] Device Serial Number 00-18-7d-ff-fe-12-da-11
     Capabilities: [16c v1] Power Budgeting <?>
     Kernel driver in use: tg3

05:00.0 ISA bridge: Winbond Electronics Corp Device 0628
     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
     Latency: 0

05:0d.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
     Subsystem: KNC One Device 001b
     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
     Latency: 64 (3750ns min, 9500ns max)
     Interrupt: pin A routed to IRQ 19
     Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=512]
     Kernel driver in use: budget_av

---------------------------------------------------------------------------

DVB KMESG :

<4>[  465.860057] budget_av: ciintf_slot_reset(): ciintf_slot_reset
<4>[  466.016045] TUPLE type:0x1d length:4
<4>[  466.016056]   0x00: 0x00 .
<4>[  466.016066]   0x01: 0xdb .
<4>[  466.016075]   0x02: 0x08 .
<4>[  466.016085]   0x03: 0xff .
<4>[  466.016101] TUPLE type:0x1c length:3
<4>[  466.016111]   0x00: 0x00 .
<4>[  466.016120]   0x01: 0x08 .
<4>[  466.016130]   0x02: 0xff .
<4>[  466.016146] TUPLE type:0x15 length:18
<4>[  466.016156]   0x00: 0x05 .
<4>[  466.016165]   0x01: 0x00 .
<4>[  466.016175]   0x02: 0x4e N
<4>[  466.016184]   0x03: 0x45 E
<4>[  466.016194]   0x04: 0x4f O
<4>[  466.016208]   0x05: 0x54 T
<4>[  466.016216]   0x06: 0x49 I
<4>[  466.016224]   0x07: 0x4f O
<4>[  466.016231]   0x08: 0x4e N
<4>[  466.016239]   0x09: 0x00 .
<4>[  466.016247]   0x0a: 0x43 C
<4>[  466.016255]   0x0b: 0x41 A
<4>[  466.016263]   0x0c: 0x4d M
<4>[  466.016271]   0x0d: 0x00 .
<4>[  466.016278]   0x0e: 0x43 C
<4>[  466.016286]   0x0f: 0x49 I
<4>[  466.016294]   0x10: 0x00 .
<4>[  466.016302]   0x11: 0xff .
<4>[  466.016316] TUPLE type:0x20 length:4
<4>[  466.016324]   0x00: 0xff .
<4>[  466.016332]   0x01: 0xff .
<4>[  466.016340]   0x02: 0x01 .
<4>[  466.016348]   0x03: 0x00 .
<4>[  466.016362] TUPLE type:0x1a length:21
<4>[  466.016370]   0x00: 0x01 .
<4>[  466.016378]   0x01: 0x0f .
<4>[  466.016386]   0x02: 0xfe .
<4>[  466.016394]   0x03: 0x01 .
<4>[  466.016401]   0x04: 0x01 .
<4>[  466.016409]   0x05: 0xc0 .
<4>[  466.016417]   0x06: 0x0e .
<4>[  466.016425]   0x07: 0x41 A
<4>[  466.016433]   0x08: 0x02 .
<4>[  466.016440]   0x09: 0x44 D
<4>[  466.016448]   0x0a: 0x56 V
<4>[  466.016456]   0x0b: 0x42 B
<4>[  466.016464]   0x0c: 0x5f _
<4>[  466.016472]   0x0d: 0x43 C
<4>[  466.016479]   0x0e: 0x49 I
<4>[  466.016487]   0x0f: 0x5f _
<4>[  466.016495]   0x10: 0x56 V
<4>[  466.016503]   0x11: 0x31 1
<4>[  466.016511]   0x12: 0x2e .
<4>[  466.016518]   0x13: 0x30 0
<4>[  466.016526]   0x14: 0x30 0
<4>[  466.016541] TUPLE type:0x1b length:14
<4>[  466.016549]   0x00: 0xc2 .
<4>[  466.016557]   0x01: 0x41 A
<4>[  466.016565]   0x02: 0x09 .
<4>[  466.016573]   0x03: 0x37 7
<4>[  466.016580]   0x04: 0x55 U
<4>[  466.016588]   0x05: 0x4d M
<4>[  466.016596]   0x06: 0x5d ]
<4>[  466.016604]   0x07: 0x56 V
<4>[  466.016612]   0x08: 0x56 V
<4>[  466.016619]   0x09: 0xaa .
<4>[  466.016627]   0x0a: 0x60 `
<4>[  466.016635]   0x0b: 0x20
<4>[  466.016643]   0x0c: 0x03 .
<4>[  466.016651]   0x0d: 0x03 .
<4>[  466.016665] TUPLE type:0x1b length:38
<4>[  466.016673]   0x00: 0xcf .
<4>[  466.016681]   0x01: 0x04 .
<4>[  466.016689]   0x02: 0x19 .
<4>[  466.016697]   0x03: 0x37 7
<4>[  466.016704]   0x04: 0x55 U
<4>[  466.016712]   0x05: 0x4d M
<4>[  466.016720]   0x06: 0x5d ]
<4>[  466.016728]   0x07: 0x56 V
<4>[  466.016736]   0x08: 0x56 V
<4>[  466.016743]   0x09: 0x22 "
<4>[  466.016751]   0x0a: 0x20
<4>[  466.016759]   0x0b: 0xc0 .
<4>[  466.016767]   0x0c: 0x09 .
<4>[  466.016775]   0x0d: 0x44 D
<4>[  466.016782]   0x0e: 0x56 V
<4>[  466.016790]   0x0f: 0x42 B
<4>[  466.016798]   0x10: 0x5f _
<4>[  466.016806]   0x11: 0x48 H
<4>[  466.016814]   0x12: 0x4f O
<4>[  466.016821]   0x13: 0x53 S
<4>[  466.016829]   0x14: 0x54 T
<4>[  466.016837]   0x15: 0x00 .
<4>[  466.016845]   0x16: 0xc1 .
<4>[  466.016853]   0x17: 0x0e .
<4>[  466.016860]   0x18: 0x44 D
<4>[  466.016868]   0x19: 0x56 V
<4>[  466.016876]   0x1a: 0x42 B
<4>[  466.016884]   0x1b: 0x5f _
<4>[  466.016892]   0x1c: 0x43 C
<4>[  466.016900]   0x1d: 0x49 I
<4>[  466.016907]   0x1e: 0x5f _
<4>[  466.016915]   0x1f: 0x4d M
<4>[  466.016923]   0x20: 0x4f O
<4>[  466.016931]   0x21: 0x44 D
<4>[  466.016939]   0x22: 0x55 U
<4>[  466.016946]   0x23: 0x4c L
<4>[  466.016954]   0x24: 0x45 E
<4>[  466.016962]   0x25: 0x00 .
<4>[  466.016977] TUPLE type:0x14 length:0
<4>[  466.016985] END OF CHAIN TUPLE type:0xff
<4>[  466.016987] Valid DVB CAM detected MANID:ffff DEVID:1 
CONFIGBASE:0x1fe CONFIGOPTION:0xf
<4>[  466.016989] dvb_ca_en50221_set_configoption
<4>[  466.017003] Set configoption 0xf, read configoption 0xf
<4>[  466.017011] DVB CAM validated successfully
<4>[  466.516016] dvb_ca_en50221_link_init
<4>[  466.516025] dvb_ca_en50221_wait_if_status
<4>[  466.620015] dvb_ca_en50221_wait_if_status failed timeout:26
<4>[  466.620025] dvb_ca adapter 0: DVB CAM link initialisation failed :(

---------------------------------------------------------------------------
---------------------------------------------------------------------------

Best regards,

Stéphane Railhet

