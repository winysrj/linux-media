Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc4-s5.col0.hotmail.com ([65.55.34.207]:35418 "EHLO
	col0-omc4-s5.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbZFWAN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 20:13:57 -0400
Message-ID: <COL103-W296EA037978E28B1E297D688360@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <dheitmueller@kernellabs.com>
CC: <linux-media@vger.kernel.org>, <video4linux-list@redhat.com>
Subject: RE: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
Date: Mon, 22 Jun 2009 20:14:00 -0400
In-Reply-To: <829197380906221448l5739e2f1j19757687ceba31e8@mail.gmail.com>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
	 <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
 	 <829197380906211429k7176a93fm49d49851e6d2df1e@mail.gmail.com>
 	 <COL103-W308B321250A646D788B25188390@phx.gbl>
 <829197380906221448l5739e2f1j19757687ceba31e8@mail.gmail.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> Ok, here's something to try. I assume you are rebooting the box,
> keeping the stick plugged in. Please unplug the device, plug it back
> in, and then post the full dmesg output.
>
> Devin

Actually I've been unplugging the device, booting, letting the system settle down, then plugging the device in.  But here is the dmesg output that you requested, showing a boot with the device plugged in, then the device removed, then the device plugged back in.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.24-24-server (buildd@rothera) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu4)) #1 SMP Wed Apr 15 16:36:01 UTC 2009 (Ubuntu 2.6.24-24.53-server)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfeb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfeb0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] 3968MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f57a0
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Entering add_active_range(0, 0, 1245184) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1245184
[    0.000000] On node 0 totalpages: 1245184
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7936 pages used for memmap
[    0.000000]   HighMem zone: 1007872 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xC00F75D0 checksum 0
[    0.000000] ACPI: RSDP 000F75D0, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFEE2040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: FACP CFEE20C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: DSDT CFEE2180, 50A9 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
[    0.000000] ACPI: FACS CFEB0000, 0040
[    0.000000] ACPI: EUDS CFEE79C0, 0500 (r1 GBT                    0             0)
[    0.000000] ACPI: HPET CFEE7880, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
[    0.000000] ACPI: MCFG CFEE7900, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: APIC CFEE7280, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
[    0.000000] ACPI: SSDT CFEE87F0, 03AB (r1  PmRef    CpuPm     3000 INTL 20040311)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 7:7 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] Processor #3 7:7 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 7:7 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2 7:7 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at e6000000 (gap: e4000000:1ac00000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1235456
[    0.000000] Kernel command line: root=UUID=2f7e91eb-9b4a-4f03-aeda-c472bd2d7077 ro nosplash vga=0x034a
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2833.055 MHz processor.
[   25.149648] Console: colour dummy device 80x25
[   25.149650] console [tty0] enabled
[   25.149862] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   25.150021] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   25.301649] Memory: 4140224k/4980736k available (2258k kernel code, 51520k reserved, 1037k data, 384k init, 3275456k highmem)
[   25.301658] virtual kernel memory layout:
[   25.301659]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[   25.301659]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[   25.301660]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[   25.301660]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   25.301661]       .init : 0xc043e000 - 0xc049e000   ( 384 kB)
[   25.301662]       .data : 0xc0334a89 - 0xc0437fe4   (1037 kB)
[   25.301662]       .text : 0xc0100000 - 0xc0334a89   (2258 kB)
[   25.301673] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   25.301699] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
[   25.301788] hpet clockevent registered
[   25.451604] Calibrating delay using timer specific routine.. 5669.18 BogoMIPS (lpj=28345913)
[   25.451620] Security Framework initialized
[   25.451625] SELinux:  Disabled at boot.
[   25.451633] AppArmor: AppArmor initialized
[   25.451637] Failure registering capabilities with primary security module.
[   25.451643] Mount-cache hash table entries: 512
[   25.451718] Initializing cgroup subsys ns
[   25.451722] Initializing cgroup subsys cpuacct
[   25.451730] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
[   25.451734] monitor/mwait feature present.
[   25.451736] using mwait in idle threads.
[   25.451739] CPU: L1 I cache: 32K, L1 D cache: 32K
[   25.451742] CPU: L2 cache: 6144K
[   25.451744] CPU: Physical Processor ID: 0
[   25.451746] CPU: Processor Core ID: 0
[   25.451748] CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
[   25.451753] Compat vDSO mapped to ffffe000.
[   25.451762] Checking 'hlt' instruction... OK.
[   25.491877] SMP alternatives: switching to UP code
[   25.492938] Early unpacking initramfs... done
[   25.697565] ACPI: Core revision 20070126
[   25.697592] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   25.699413] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
[   25.699424] SMP alternatives: switching to SMP code
[   25.699936] Booting processor 1/1 eip 3000
[   25.710509] Initializing CPU#1
[   25.851098] Calibrating delay using timer specific routine.. 5666.02 BogoMIPS (lpj=28330102)
[   25.851103] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
[   25.851106] monitor/mwait feature present.
[   25.851107] CPU: L1 I cache: 32K, L1 D cache: 32K
[   25.851108] CPU: L2 cache: 6144K
[   25.851109] CPU: Physical Processor ID: 0
[   25.851110] CPU: Processor Core ID: 1
[   25.851111] CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
[   25.851891] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
[   25.851920] SMP alternatives: switching to SMP code
[   25.852457] Booting processor 2/2 eip 3000
[   25.863027] Initializing CPU#2
[   26.010897] Calibrating delay using timer specific routine.. 5666.05 BogoMIPS (lpj=28330270)
[   26.010902] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
[   26.010905] monitor/mwait feature present.
[   26.010906] CPU: L1 I cache: 32K, L1 D cache: 32K
[   26.010907] CPU: L2 cache: 6144K
[   26.010909] CPU: Physical Processor ID: 0
[   26.010909] CPU: Processor Core ID: 2
[   26.010910] CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
[   26.011708] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
[   26.011729] SMP alternatives: switching to SMP code
[   26.012096] Booting processor 3/3 eip 3000
[   26.022666] Initializing CPU#3
[   26.170696] Calibrating delay using timer specific routine.. 5666.05 BogoMIPS (lpj=28330287)
[   26.170700] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
[   26.170703] monitor/mwait feature present.
[   26.170705] CPU: L1 I cache: 32K, L1 D cache: 32K
[   26.170706] CPU: L2 cache: 6144K
[   26.170707] CPU: Physical Processor ID: 0
[   26.170708] CPU: Processor Core ID: 3
[   26.170709] CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
[   26.171543] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
[   26.171564] Total of 4 processors activated (22667.31 BogoMIPS).
[   26.171701] ENABLING IO-APIC IRQs
[   26.171856] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   26.390475] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   26.410477] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[   26.430489] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[   26.450483] Brought up 4 CPUs
[   26.450515] CPU0 attaching sched-domain:
[   26.450521]  domain 0: span 03
[   26.450522]   groups: 01 02
[   26.450524]   domain 1: span 0f
[   26.450525]    groups: 03 0c
[   26.450527] CPU1 attaching sched-domain:
[   26.450527]  domain 0: span 03
[   26.450528]   groups: 02 01
[   26.450530]   domain 1: span 0f
[   26.450531]    groups: 03 0c
[   26.450532] CPU2 attaching sched-domain:
[   26.450533]  domain 0: span 0c
[   26.450534]   groups: 04 08
[   26.450535]   domain 1: span 0f
[   26.450536]    groups: 0c 03
[   26.450538] CPU3 attaching sched-domain:
[   26.450539]  domain 0: span 0c
[   26.450539]   groups: 08 04
[   26.450541]   domain 1: span 0f
[   26.450542]    groups: 0c 03
[   26.450736] net_namespace: 64 bytes
[   26.450745] Booting paravirtualized kernel on bare hardware
[   26.451021] Time: 22:55:06  Date: 06/22/09
[   26.451038] NET: Registered protocol family 16
[   26.451141] EISA bus registered
[   26.451145] ACPI: bus type pci registered
[   26.457064] PCI: PCI BIOS revision 3.00 entry at 0xfb9e0, last bus=6
[   26.457066] PCI: Using configuration type 1
[   26.457084] Setting up standard PCI resources
[   26.459899] ACPI: EC: Look up EC in DSDT
[   26.462862] ACPI: Interpreter enabled
[   26.462868] ACPI: (supports S0 S3 S4 S5)
[   26.462882] ACPI: Using IOAPIC for interrupt routing
[   26.465771] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   26.467154] PCI: Transparent bridge - 0000:00:1e.0
[   26.467182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   26.467270] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   26.467315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[   26.467360] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   26.467403] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[   26.467446] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   26.477695] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
[   26.477760] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[   26.477824] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
[   26.477887] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[   26.477951] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
[   26.478014] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[   26.478078] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[   26.478141] ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
[   26.478216] Linux Plug and Play Support v0.97 (c) Adam Belay
[   26.478233] pnp: PnP ACPI init
[   26.478238] ACPI: bus type pnp registered
[   26.479627] pnpacpi: exceeded the max number of mem resources: 12
[   26.479708] pnp: PnP ACPI: found 14 devices
[   26.479710] ACPI: ACPI bus type pnp unregistered
[   26.479714] PnPBIOS: Disabled by ACPI PNP
[   26.479831] PCI: Using ACPI for IRQ routing
[   26.479834] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   26.570203] NET: Registered protocol family 8
[   26.570207] NET: Registered protocol family 20
[   26.570229] NetLabel: Initializing
[   26.570232] NetLabel:  domain hash size = 128
[   26.570235] NetLabel:  protocols = UNLABELED CIPSOv4
[   26.570245] NetLabel:  unlabeled traffic allowed by default
[   26.570251] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[   26.570257] hpet0: 4 64-bit timers, 14318180 Hz
[   26.571277] AppArmor: AppArmor Filesystem Enabled
[   26.580180] Time: tsc clocksource has been installed.
[   26.580187] Switched to high resolution mode on CPU 0
[   26.580239] Switched to high resolution mode on CPU 1
[   26.590125] Switched to high resolution mode on CPU 2
[   26.590160] Switched to high resolution mode on CPU 3
[   26.620151] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[   26.620156] system 00:01: ioport range 0x290-0x29f has been reserved
[   26.620160] system 00:01: ioport range 0x800-0x805 has been reserved
[   26.620164] system 00:01: ioport range 0x290-0x294 has been reserved
[   26.620168] system 00:01: ioport range 0x880-0x88f has been reserved
[   26.620178] system 00:0a: ioport range 0x400-0x4cf has been reserved
[   26.620182] system 00:0a: ioport range 0x4d2-0x4ff has been reserved
[   26.620189] system 00:0b: iomem range 0xe0000000-0xe3ffffff could not be reserved
[   26.620196] system 00:0c: iomem range 0xd5000-0xd7fff has been reserved
[   26.620200] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[   26.620205] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[   26.620209] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[   26.620213] system 00:0c: iomem range 0xcfeb0000-0xcfefffff could not be reserved
[   26.620218] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   26.620222] system 00:0c: iomem range 0x100000-0xcfeaffff could not be reserved
[   26.620227] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[   26.620232] system 00:0c: iomem range 0xfed10000-0xfed1dfff could not be reserved
[   26.620237] system 00:0c: iomem range 0xfed20000-0xfed8ffff could not be reserved
[   26.620242] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[   26.620247] system 00:0c: iomem range 0xffb00000-0xffb7ffff could not be reserved
[   26.650457] PCI: Bridge: 0000:00:01.0
[   26.650459]   IO window: 9000-9fff
[   26.650462]   MEM window: e4000000-e7ffffff
[   26.650465]   PREFETCH window: d0000000-dfffffff
[   26.650468] PCI: Bridge: 0000:00:1c.0
[   26.650470]   IO window: disabled.
[   26.650474]   MEM window: disabled.
[   26.650477]   PREFETCH window: disabled.
[   26.650481] PCI: Bridge: 0000:00:1c.3
[   26.650483]   IO window: a000-afff
[   26.650487]   MEM window: ea100000-ea1fffff
[   26.650490]   PREFETCH window: disabled.
[   26.650495] PCI: Bridge: 0000:00:1c.4
[   26.650497]   IO window: b000-bfff
[   26.650501]   MEM window: e8000000-e8ffffff
[   26.650504]   PREFETCH window: ea000000-ea0fffff
[   26.650509] PCI: Bridge: 0000:00:1c.5
[   26.650511]   IO window: c000-cfff
[   26.650515]   MEM window: e9000000-e9ffffff
[   26.650518]   PREFETCH window: ea200000-ea2fffff
[   26.650523] PCI: Bridge: 0000:00:1e.0
[   26.650525]   IO window: d000-dfff
[   26.650529]   MEM window: ea300000-ea3fffff
[   26.650532]   PREFETCH window: disabled.
[   26.650541] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   26.650546] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   26.650558] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   26.650563] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   26.650575] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
[   26.650580] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   26.650592] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[   26.650597] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   26.650609] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 18
[   26.650614] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   26.650621] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   26.650627] NET: Registered protocol family 2
[   26.750003] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   26.750162] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   26.750409] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   26.750519] TCP: Hash tables configured (established 131072 bind 65536)
[   26.750522] TCP reno registered
[   26.780011] checking if image is initramfs... it is
[   27.183680] Freeing initrd memory: 7342k freed
[   27.184741] audit: initializing netlink socket (disabled)
[   27.184753] audit(1245711306.732:1): initialized
[   27.185110] highmem bounce pool size: 64 pages
[   27.185113] Total HugeTLB memory allocated, 0
[   27.187303] VFS: Disk quotas dquot_6.5.1
[   27.187368] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   27.187520] io scheduler noop registered
[   27.187522] io scheduler anticipatory registered
[   27.187525] io scheduler deadline registered (default)
[   27.187532] io scheduler cfq registered
[   27.219405] Boot video device is 0000:01:00.0
[   27.219493] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   27.219519] assign_interrupt_mode Found MSI capability
[   27.219556] Allocate Port Service[0000:00:01.0:pcie00]
[   27.219622] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   27.219651] assign_interrupt_mode Found MSI capability
[   27.219675] Allocate Port Service[0000:00:1c.0:pcie00]
[   27.219717] Allocate Port Service[0000:00:1c.0:pcie02]
[   27.219791] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   27.219820] assign_interrupt_mode Found MSI capability
[   27.219844] Allocate Port Service[0000:00:1c.3:pcie00]
[   27.219884] Allocate Port Service[0000:00:1c.3:pcie02]
[   27.219957] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   27.219986] assign_interrupt_mode Found MSI capability
[   27.220010] Allocate Port Service[0000:00:1c.4:pcie00]
[   27.220051] Allocate Port Service[0000:00:1c.4:pcie02]
[   27.220125] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   27.220154] assign_interrupt_mode Found MSI capability
[   27.220178] Allocate Port Service[0000:00:1c.5:pcie00]
[   27.220213] Allocate Port Service[0000:00:1c.5:pcie02]
[   27.220489] isapnp: Scanning for PnP cards...
[   27.575694] isapnp: No Plug & Play device found
[   27.603318] Real Time Clock Driver v1.12ac
[   27.603452] hpet_resources: 0xfed00000 is busy
[   27.603484] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   27.604756] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   27.604820] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[   27.604923] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   27.605278] serio: i8042 KBD port at 0x60,0x64 irq 1
[   27.605285] serio: i8042 AUX port at 0x60,0x64 irq 12
[   27.651393] mice: PS/2 mouse device common for all mice
[   27.651486] EISA: Probing bus 0 at eisa.0
[   27.651516] EISA: Detected 0 cards.
[   27.651518] cpuidle: using governor ladder
[   27.651520] cpuidle: using governor menu
[   27.651564] NET: Registered protocol family 1
[   27.651580] Using IPI No-Shortcut mode
[   27.651595] registered taskstats version 1
[   27.651674]   Magic number: 13:877:957
[   27.651681]   hash matches device ptyze
[   27.651690] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   27.652039] Freeing unused kernel memory: 384k freed
[   27.652067] Write protecting the kernel read-only data: 828k
[   27.681807] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   27.745291] vesafb: framebuffer at 0xe5000000, mapped to 0xf8880000, using 14336k, total 14336k
[   27.745299] vesafb: mode is 1600x1200x32, linelength=6400, pages=1
[   27.745303] vesafb: protected mode interface info at c000:c360
[   27.745306] vesafb: pmi: set display start = c00cc3c3, set palette = c00cc41e
[   27.745310] vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
[   27.745323] vesafb: scrolling: redraw
[   27.745327] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[   27.745455] Console: switching to colour frame buffer device 200x75
[   27.792243] fb0: VESA VGA frame buffer device
[   27.898829] fuse init (API version 7.9)
[   27.909053] ACPI: SSDT CFEE7F10, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
[   27.909466] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   27.909697] ACPI: Processor [CPU0] (supports 8 throttling states)
[   27.910003] ACPI: SSDT CFEE83D0, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
[   27.910480] ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
[   27.910714] ACPI: Processor [CPU1] (supports 8 throttling states)
[   27.911046] ACPI: SSDT CFEE8530, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20040311)
[   27.911471] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   27.911704] ACPI: Processor [CPU2] (supports 8 throttling states)
[   27.912015] ACPI: SSDT CFEE8690, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20040311)
[   27.912510] ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
[   27.912743] ACPI: Processor [CPU3] (supports 8 throttling states)
[   27.998766] usbcore: registered new interface driver usbfs
[   27.998986] usbcore: registered new interface driver hub
[   28.003540] usbcore: registered new device driver usb
[   28.005711] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 19
[   28.006001] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   28.006004] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   28.006329] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   28.010489] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   28.010494] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xea405000
[   28.014580] USB Universal Host Controller Interface driver v3.0
[   28.034931] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   28.035307] usb usb1: configuration #1 chosen from 1 choice
[   28.035536] hub 1-0:1.0: USB hub found
[   28.035683] hub 1-0:1.0: 6 ports detected
[   28.061516] SCSI subsystem initialized
[   28.082186] libata version 3.00 loaded.
[   28.142086] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   28.142368] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   28.142370] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   28.142573] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
[   28.142859] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e500
[   28.143129] usb usb2: configuration #1 chosen from 1 choice
[   28.143343] hub 2-0:1.0: USB hub found
[   28.143480] hub 2-0:1.0: 2 ports detected
[   28.248159] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 20
[   28.248443] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   28.248445] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   28.248649] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
[   28.248939] uhci_hcd 0000:00:1a.1: irq 20, io base 0x0000e000
[   28.249208] usb usb3: configuration #1 chosen from 1 choice
[   28.249425] hub 3-0:1.0: USB hub found
[   28.249564] hub 3-0:1.0: 2 ports detected
[   28.358015] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 19
[   28.370024] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[   28.370026] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   28.381994] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   28.394119] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000e100
[   28.406322] usb usb4: configuration #1 chosen from 1 choice
[   28.417881] usb 1-3: new high speed USB device using ehci_hcd and address 2
[   28.430878] hub 4-0:1.0: USB hub found
[   28.443170] hub 4-0:1.0: 2 ports detected
[   28.557759] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
[   28.570348] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   28.570355] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   28.578077] usb 1-3: configuration #1 chosen from 1 choice
[   28.595435] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   28.608107] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000e200
[   28.620665] usb usb5: configuration #1 chosen from 1 choice
[   28.633089] hub 5-0:1.0: USB hub found
[   28.645357] hub 5-0:1.0: 2 ports detected
[   28.757509] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
[   28.769736] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   28.769738] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   28.781867] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   28.794105] uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e300
[   28.806274] usb usb6: configuration #1 chosen from 1 choice
[   28.818410] hub 6-0:1.0: USB hub found
[   28.830407] hub 6-0:1.0: 2 ports detected
[   28.947270] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
[   28.959445] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   28.959447] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   28.971548] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   28.983689] uhci_hcd 0000:00:1d.2: irq 19, io base 0x0000e400
[   28.995866] usb usb7: configuration #1 chosen from 1 choice
[   29.008003] hub 7-0:1.0: USB hub found
[   29.020014] hub 7-0:1.0: 2 ports detected
[   29.139582] ACPI: PCI Interrupt 0000:06:07.0[A] -> GSI 23 (level, low) -> IRQ 21
[   29.202012] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[ea344000-ea3447ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   29.214462] r8169 Gigabit Ethernet driver 2.2LK loaded
[   29.226763] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   29.239260] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   29.239452] eth0: RTL8168c/8111c at 0xf8852000, 00:1f:d0:d5:14:97, XID 3c4000c0 IRQ 218
[   29.253608] r8169 Gigabit Ethernet driver 2.2LK loaded
[   29.266034] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 17 (level, low) -> IRQ 18
[   29.278604] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   29.278783] eth1: RTL8168c/8111c at 0xf968e000, 00:1f:d0:81:2d:a3, XID 3c4000c0 IRQ 217
[   29.293140] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
[   29.305841] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   29.305843] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   29.318486] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[   29.335018] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   29.335021] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xea404000
[   29.370510] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   29.383254] usb usb8: configuration #1 chosen from 1 choice
[   29.396009] hub 8-0:1.0: USB hub found
[   29.408735] hub 8-0:1.0: 6 ports detected
[   29.530296] ahci 0000:00:1f.2: version 3.0
[   29.530317] ACPI: PCI Interrupt 0000:03:00.1[B] -> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 17
[   29.543566] GSI 16 (level, low) -> IRQ 16
[   29.543589] PCI: Setting latency timer of device 0000:03:00.1 to 64
[   29.543599] ACPI: PCI interrupt for device 0000:03:00.1 disabled
[   30.526570] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00ee5c5400001fd0]
[   30.536493] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[   30.550006] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
[   30.550010] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   30.550219] scsi0 : ahci
[   30.550250] scsi1 : ahci
[   30.550275] scsi2 : ahci
[   30.550303] scsi3 : ahci
[   30.550328] scsi4 : ahci
[   30.550353] scsi5 : ahci
[   30.550408] ata1: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406100 irq 216
[   30.550410] ata2: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406180 irq 216
[   30.550412] ata3: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406200 irq 216
[   30.550414] ata4: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406280 irq 216
[   30.550415] ata5: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406300 irq 216
[   30.550417] ata6: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406380 irq 216
[   32.255569] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   32.296241] ata1.00: ATA-8: ST3640323AS, SD35, max UDMA/133
[   32.308304] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   32.362095] ata1.00: configured for UDMA/133
[   32.374241] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[   32.386393] ata1: irq_stat 0x00400040, connection status changed
[   32.468796] ata1.00: configured for UDMA/133
[   32.480879] ata1: EH complete
[   33.201882] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   33.214690] ata2.00: ATA-8: WDC WD1001FALS-00J7B1, 05.00K05, max UDMA/133
[   33.226886] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   33.239933] ata2.00: configured for UDMA/133
[   33.940956] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   34.111889] ata3.00: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[   34.285450] ata3.00: configured for UDMA/100
[   34.640080] ata4: SATA link down (SStatus 0 SControl 300)
[   35.003374] ata5: SATA link down (SStatus 0 SControl 300)
[   35.361676] ata6: SATA link down (SStatus 0 SControl 300)
[   35.373699] scsi 0:0:0:0: Direct-Access     ATA      ST3640323AS      SD35 PQ: 0 ANSI: 5
[   35.385953] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[   35.399112] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 PQ: 0 ANSI: 5
[   35.411198] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 17
[   36.427857] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   36.439967] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   36.452053] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   36.452154] scsi6 : ahci
[   36.464179] scsi7 : ahci
[   36.476073] ata7: SATA max UDMA/133 abar m8192@0xea100000 port 0xea100100 irq 17
[   36.488227] ata8: SATA max UDMA/133 abar m8192@0xea100000 port 0xea100180 irq 17
[   36.847320] ata7: SATA link down (SStatus 0 SControl 300)
[   37.210615] ata8: SATA link down (SStatus 0 SControl 300)
[   37.222451] ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 16 (level, low) -> IRQ 16
[   37.234621] PCI: Setting latency timer of device 0000:03:00.1 to 64
[   37.234671] scsi8 : pata_jmicron
[   37.234691] Driver 'sd' needs updating - please use bus_type methods
[   37.234727] sd 0:0:0:0: [sda] 1250263728 512-byte hardware sectors (640135 MB)
[   37.234733] sd 0:0:0:0: [sda] Write Protect is off
[   37.234735] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.234743] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.234769] sd 0:0:0:0: [sda] 1250263728 512-byte hardware sectors (640135 MB)
[   37.234774] sd 0:0:0:0: [sda] Write Protect is off
[   37.234775] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   37.234784] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.234786]  sda: sda1 sda2 <scsi9 : pata_jmicron
[   37.343025] ata9: PATA max UDMA/100 cmd 0xa000 ctl 0xa100 bmdma 0xa400 irq 16
[   37.355318] ata10: PATA max UDMA/100 cmd 0xa200 ctl 0xa300 bmdma 0xa408 irq 16
[   37.367621]  sda5>
[   37.379764] sd 0:0:0:0: [sda] Attached SCSI disk
[   37.391719] sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[   37.391763] Driver 'sr' needs updating - please use bus_type methods
[   37.415453] sd 1:0:0:0: [sdb] Write Protect is off
[   37.427196] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.427225] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.439129] sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[   37.450912] sd 1:0:0:0: [sdb] Write Protect is off
[   37.462524] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   37.462537] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   37.474266]  sdb: sdb1
[   37.501085] sd 1:0:0:0: [sdb] Attached SCSI disk
[   37.514592] sr0: scsi3-mmc drive: 40x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   37.526436] Uniform CD-ROM driver Revision: 3.20
[   37.538156] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   37.538254] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   37.550040] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   37.561800] sr 2:0:0:0: Attached scsi generic sg2 type 5
[   40.550287] Attempting manual resume
[   40.561576] swsusp: Resume From Partition 8:5
[   40.561577] PM: Checking swsusp image.
[   40.561816] PM: Resume from disk failed.
[   40.630963] kjournald starting.  Commit interval 5 seconds
[   40.630972] EXT3-fs: mounted filesystem with ordered data mode.
[   44.512839] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   44.845696] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   44.940928] input: Power Button (FF) as /devices/virtual/input/input3
[   44.970233] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   45.082560] r8169: eth1: link up
[   45.094924] r8169: eth1: link up
[   45.119541] r8169: eth0: link up
[   45.131411] r8169: eth0: link up
[   45.147179] ACPI: Power Button (FF) [PWRF]
[   45.159059] input: Power Button (CM) as /devices/virtual/input/input4
[   45.186094] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   45.198640] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   45.250138] Linux agpgart interface v0.102
[   45.281073] hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
[   45.316728] ACPI: Power Button (CM) [PWRB]
[   45.496918] Linux video capture interface: v2.00
[   45.707263] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input5
[   45.812361] parport_pc 00:07: reported by Plug and Play ACPI
[   45.824744] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   46.050280] nvidia: module license 'NVIDIA' taints kernel.
[   46.315025] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   46.327436] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   46.327507] NVRM: loading NVIDIA UNIX x86 Kernel Module  185.18.14  Wed May 27 02:23:13 PDT 2009
[   46.342689] NET: Registered protocol family 10
[   46.355506] lo: Disabled Privacy Extensions
[   46.410920] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 19 (level, low) -> IRQ 17
[   46.423671] parport1: PC-style at 0xd400 [PCSPP,TRISTATE,EPP]
[   46.516652] 0000:06:01.0: ttyS0 at I/O 0xd200 (irq = 17) is a 16550A
[   46.529508] 0000:06:01.0: ttyS1 at I/O 0xd300 (irq = 17) is a 16550A
[   46.544027] em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
[   46.556798] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[   46.569704] em28xx #0: chip ID is em2882/em2883
[   46.793546] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
[   46.806421] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[   46.819162] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[   46.831734] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[   46.844187] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.856693] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.868917] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[   46.880961] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[   46.892895] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[   46.904710] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
[   46.916375] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
[   46.927936] em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
[   46.939369] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.950614] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.961755] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.972704] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.983480] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
[   46.994127] em28xx #0: EEPROM info:
[   47.004768] em28xx #0:       AC97 audio (5 sample rates)
[   47.015532] em28xx #0:       500mA max power
[   47.026194] em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[   47.118089] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/input/input6
[   47.186548] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 20 (level, low) -> IRQ 23
[   47.197498] Vortex: init.... em28xx #0: Config register raw data: 0xd0
[   47.259584] em28xx #0: AC97 vendor ID = 0xffffffff
[   47.270945] em28xx #0: AC97 features = 0x6a90
[   47.281843] em28xx #0: Empia 202 AC97 audio processor detected
[   47.377814] em28xx #0: v4l2 driver version 0.1.2
[   47.480729] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[   47.491553] usbcore: registered new interface driver em28xx
[   47.502375] em28xx driver loaded
[   47.866639] xc2028 0-0061: creating new instance
[   47.877624] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   47.888597] em28xx #0/2: xc3028 attached
[   47.899512] DVB: registering new adapter (em28xx #0)
[   47.910493] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[   47.921867] Successfully loaded em28xx-dvb
[   47.933257] Em28xx: Initialized (Em28xx dvb Extension) extension
[   48.639971] done.
[   48.696420] gameport: AU88x0 Gameport is pci0000:06:00.0/gameport0, speed 596kHz
[   48.869430] loop: module loaded
[   48.906864] lp0: using parport0 (interrupt-driven).
[   48.918367] lp1: using parport1 (polling).
[   49.037457] it87: Found IT8718F chip at 0x290, revision 5
[   49.048437] it87: in3 is VCC (+5V)
[   49.227251] Adding 9863868k swap on /dev/sda5.  Priority:-1 extents:1 across:9863868k
[   49.671109] EXT3 FS on sda1, internal journal
[   50.274615] kjournald starting.  Commit interval 5 seconds
[   50.275004] EXT3 FS on sdb1, internal journal
[   50.275008] EXT3-fs: mounted filesystem with ordered data mode.
[   50.868230] ip_tables: (C) 2000-2006 Netfilter Core Team
[   50.885931] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   53.396969] HTB: quantum of class 20002 is small. Consider r2q change.
[   53.406812] HTB: quantum of class 20004 is small. Consider r2q change.
[   53.408246] HTB: quantum of class 20005 is small. Consider r2q change.
[   53.416163] tcindex_init(tp f7018a80)
[   53.416165] tcindex_get(tp f7018a80,handle 0x00000000)
[   53.416167] tcindex_change(tp f7018a80,handle 0x00000000,tca f7ca3660,arg f51afca0),opt f5996630,p f697d440,r 00000000,*arg 0x0
[   53.416170] tcindex_dump(tp f7018a80,fh 0x0,skb f687a6c0,t f55bb010),p f697d440,r 00000000,b f55bb038
[   53.416172] p->perfect f5993c00 p->h 00000000
[   53.416865] tcindex_get(tp f7018a80,handle 0x00000004)
[   53.416867] tcindex_change(tp f7018a80,handle 0x00000004,tca f7ca3660,arg f501dca0),opt f5996030,p f697d440,r 00000000,*arg 0x0
[   53.416870] tcindex_dump(tp f7018a80,fh 0x0,skb f6842900,t f55bb010),p f697d440,r 00000000,b f55bb038
[   53.416872] p->perfect f5993c00 p->h 00000000
[   53.417556] tcindex_get(tp f7018a80,handle 0x00000003)
[   53.417558] tcindex_change(tp f7018a80,handle 0x00000003,tca f7ca3660,arg f51a5ca0),opt f6eb0a30,p f697d440,r 00000000,*arg 0x0
[   53.417562] tcindex_dump(tp f7018a80,fh 0x0,skb f683f240,t f59a1010),p f697d440,r 00000000,b f59a1038
[   53.417563] p->perfect f5993c00 p->h 00000000
[   53.418245] tcindex_get(tp f7018a80,handle 0x00000002)
[   53.418247] tcindex_change(tp f7018a80,handle 0x00000002,tca f7ca3660,arg f5133ca0),opt f5996630,p f697d440,r 00000000,*arg 0x0
[   53.418250] tcindex_dump(tp f7018a80,fh 0x0,skb f6951540,t f55bb010),p f697d440,r 00000000,b f55bb038
[   53.418252] p->perfect f5993c00 p->h 00000000
[   53.418946] tcindex_get(tp f7018a80,handle 0x00000001)
[   53.418949] tcindex_change(tp f7018a80,handle 0x00000001,tca f7ca3660,arg f50e3ca0),opt f6eb0030,p f697d440,r 00000000,*arg 0x0
[   53.418952] tcindex_dump(tp f7018a80,fh 0x0,skb f683fc00,t f59a1010),p f697d440,r 00000000,b f59a1038
[   53.418953] p->perfect f5993c00 p->h 00000000
[   53.427994] u32 classifier
[   53.427995]     Actions configured 
[   54.060535] No dock devices found.
[   56.502420] eth1: no IPv6 routers present
[   57.051700] eth0: no IPv6 routers present
[   61.135182] apm: BIOS not found.
[   68.323825] ppdev: user-space parallel port driver
[   69.107634] audit(1245711348.345:2): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=8614 profile="/usr/sbin/cupsd" namespace="default"
[   75.402541] NET: Registered protocol family 17

Device is removed:

[  148.085377] usb 1-3: USB disconnect, address 2
[  148.098527] em28xx #0: disconnecting em28xx #0 video
[  148.198316] em28xx #0: V4L2 device /dev/vbi0 deregistered
[  148.198343] em28xx #0: V4L2 device /dev/video0 deregistered
[  148.198537] xc2028 0-0061: destroying instance

Device is plugged back in:

[  167.080235] usb 1-1: new high speed USB device using ehci_hcd and address 3
[  167.238263] usb 1-1: configuration #1 chosen from 1 choice
[  167.238333] em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
[  167.238338] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[  167.242572] em28xx #0: chip ID is em2882/em2883
[  167.452168] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
[  167.452179] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[  167.452191] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[  167.452214] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[  167.452220] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452226] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452232] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[  167.452238] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[  167.452244] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[  167.452251] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
[  167.452257] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
[  167.452263] em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
[  167.452269] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452275] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452281] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452287] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  167.452294] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
[  167.452296] em28xx #0: EEPROM info:
[  167.452297] em28xx #0:       AC97 audio (5 sample rates)
[  167.452298] em28xx #0:       500mA max power
[  167.452300] em28xx #0:       Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[  167.463188] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input7
[  167.542180] em28xx #0: Config register raw data: 0xd0
[  167.542930] em28xx #0: AC97 vendor ID = 0xffffffff
[  167.543303] em28xx #0: AC97 features = 0x6a90
[  167.543305] em28xx #0: Empia 202 AC97 audio processor detected
[  167.623206] em28xx #0: v4l2 driver version 0.1.2
[  167.706140] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[  167.790026] xc2028 0-0061: creating new instance
[  167.790030] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[  167.790032] em28xx #0/2: xc3028 attached
[  167.790034] DVB: registering new adapter (em28xx #0)
[  167.790037] DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[  167.790200] Successfully loaded em28xx-dvb


_________________________________________________________________
Lauren found her dream laptop. Find the PC that’s right for you.
http://www.microsoft.com/windows/choosepc/?ocid=ftp_val_wl_290