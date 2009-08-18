Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from twoway.no-way.org ([212.55.208.154])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lists.fcu@no-way.org>) id 1MdJ1i-0004HR-58
	for linux-dvb@linuxtv.org; Tue, 18 Aug 2009 09:22:39 +0200
Message-ID: <20090818093340.19375t7yq5oo4hhc@webmail.no-way.org>
Date: Tue, 18 Aug 2009 09:33:40 +0200
From: lists.fcu@no-way.org
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=_5r0kmqmcm5j4"
Content-Transfer-Encoding: 7bit
Subject: [linux-dvb] Unable to get IR Remote working (Hauppauge
	HVR-1110/1120(?))
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This message is in MIME format.

--=_5r0kmqmcm5j4
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hello All

I have a Hauppauge HVR-1100 up and running. The V4L modules detect it  
as a HVR-1120 (dmesg & lsmod attached). I'm using the v4l source,  
checked out yesterday evening. TV/Radio works fine with mythtv.  
However, there is no sign of the IR remote. The saa7134 module detects  
an IR receiver, however no device nodes or entries in  
/proc/bus/input/devices are created (also attached).

I'm using the latest LIRC source, also checked out from the repository  
yesterday. I tried lirc_i2c as found in some how-to's. dev/input will  
obviously not work (no input device created).

Can anyone guide me into the right direction, or tell me how to debug  
this further?

Thank you and kind regards

Flavio Curti

-- 
http://no-way.org/

--=_5r0kmqmcm5j4
Content-Type: text/plain;
	charset=UTF-8;
	name="dmesg.tv.20090817.txt"
Content-Disposition: attachment;
	filename="dmesg.tv.20090817.txt"
Content-Transfer-Encoding: quoted-printable

[    0.] Initializing cgroup subsys cpuset
[    0.] Initializing cgroup subsys cpu
[    0.] Linux version 2.6.30-02063004-generic (root@zinc) (gcc version 4.2.=
3 (Ubuntu 4.2.3-2ubuntu7)) #02063004 SMP Fri Jul 31 10:59:10 UTC 2009
[    0.] KERNEL supported cpus:
[    0.]   Intel GenuineIntel
[    0.]   AMD AuthenticAMD
[    0.]   NSC Geode by NSC
[    0.]   Cyrix CyrixInstead
[    0.]   Centaur CentaurHauls
[    0.]   Transmeta GenuineTMx86
[    0.]   Transmeta TransmetaCPU
[    0.]   UMC UMC UMC UMC
[    0.] BIOS-provided physical RAM map:
[    0.]  BIOS-e820: ?M4?M4? - ?M49f800 (usable)
[    0.]  BIOS-e820: ?M49f800 - ?M4?M4k (reserved)
[    0.]  BIOS-e820: ?M4?M4=7F - ?M4?M5? (reserved)
[    0.]  BIOS-e820: ?M4?M5? - ?M4?~?=7F (usable)
[    0.]  BIOS-e820: ?M4?~?=7F - ?M4?~?=7F (ACPI NVS)
[    0.]  BIOS-e820: ?M4?~?=7F - ?M4?~?? (ACPI data)
[    0.]  BIOS-e820: ?M4?=7F4? - ?M4?4? (reserved)
[    0.]  BIOS-e820: ?M4??4? - ?M4??4? (reserved)
[    0.]  BIOS-e820: ?M4???? - ?M4?M4? (reserved)
[    0.] DMI 2.3 present.
[    0.] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.] e820 update range: ?M4?M4? - ?M4?M4? (usable) =3D=3D> (reserved)
[    0.] last_pfn =3D 0x37ef0 max_arch_pfn =3D 0x100000
[    0.] MTRR default type: uncachable
[    0.] MTRR fixed ranges enabled:
[    0.]   00000-9FFFF write-back
[    0.]   A0000-BFFFF uncachable
[    0.]   C0000-C7FFF write-protect
[    0.]   C8000-FFFFF uncachable
[    0.] MTRR variable ranges enabled:
[    0.]   0 base ?M4 mask FFE write-back
[    0.]   1 base 002 mask FFF write-back
[    0.]   2 base 003 mask FFF8 write-back
[    0.]   3 base 0037F00000 mask FFFFF00000 uncachable
[    0.]   4 disabled
[    0.]   5 disabled
[    0.]   6 disabled
[    0.]   7 disabled
[    0.] Scanning 0 areas for low memory corruption
[    0.] modified physical RAM map:
[    0.]  modified: ?M4?M4? - ?M4?M4? (reserved)
[    0.]  modified: ?M4?M4? - ?M49f800 (usable)
[    0.]  modified: ?M49f800 - ?M4?M4k (reserved)
[    0.]  modified: ?M4?M4=7F - ?M4?M5? (reserved)
[    0.]  modified: ?M4?M5? - ?M4?~?=7F (usable)
[    0.]  modified: ?M4?~?=7F - ?M4?~?=7F (ACPI NVS)
[    0.]  modified: ?M4?~?=7F - ?M4?~?? (ACPI data)
[    0.]  modified: ?M4?=7F4? - ?M4?4? (reserved)
[    0.]  modified: ?M4??4? - ?M4??4? (reserved)
[    0.]  modified: ?M4???? - ?M4?M4? (reserved)
[    0.] init_memory_mapping: ?M4?M4?-?M4?~?}
[    0.]  ?M4 - ?4 page 4k
[    0.]  ?4 - 0037400000 page 2M
[    0.]  0037400000 - 00377fe000 page 4k
[    0.] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.] RAMDISK: 37798000 - 37edf89a
[    0.] Allocated new RAMDISK: 0083a000 - 00f8189a
[    0.] Move RAMDISK from ?M4?~?? - ?37edf899 to 0083a000 - 00f81899
[    0.] ACPI: RSDP 000f6d00 00014 (v00 Nvidia)
[    0.] ACPI: RSDT 37ef3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD ?)
[    0.] ACPI: FACP 37ef30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD ?)
[    0.] ACPI: DSDT 37ef3180 06E72 (v01 NVIDIA AWRDACPI ? MSFT 0100000E)
[    0.] ACPI: FACS 37ef0000 00040
[    0.] ACPI: SSDT 37efa100 00115 (v01 PTLTD  POWERNOW 1  LTP 1)
[    0.] ACPI: MCFG 37efa280 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD ?)
[    0.] ACPI: APIC 37efa040 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD ?)
[    0.] ACPI: Local APIC address 0xfee00000
[    0.] 6MB HIGHMEM available.
[    0.] 887MB LOWMEM available.
[    0.]   mapped low ram: 0 - 377fe000
[    0.]   low ram: 0 - 377fe000
[    0.]   node 0 low ram: ? - 377fe000
[    0.]   node 0 bootmap ? - 00017f00
[    0.] (9 early reservations) =3D=3D> bootmem [?M4 - 00377fe000]
[    0.]   #0 [?M4 - ?M5]   BIOS data page =3D=3D> [?M4 - ?M5]
[    0.]   #1 [?M5 - ?M6]    EX TRAMPOLINE =3D=3D> [?M5 - ?M6]
[    0.]   #2 [?M: - ?M;]       TRAMPOLINE =3D=3D> [?M: - ?M;]
[    0.]   #3 [?]4 - 0000835454]    TEXT DATA BSS =3D=3D> [?]4 - 0000835454]
[    0.]   #4 [000009f800 - ?]4]    BIOS reserved =3D=3D> [000009f800 - ?]4]
[    0.]   #5 [??? - 0000839145]              BRK =3D=3D> [??? - 0000839145]
[    0.]   #6 [?Mt - ?Mu]          PGTABLE =3D=3D> [?Mt - ?Mu]
[    0.]   #7 [??? - 0000f8189a]      NEW RAMDISK =3D=3D> [??? - 0000f8189a]
[    0.]   #8 [?Mu - ?M|]          BOOTMAP =3D=3D> [?Mu - ?M|]
[    0.] found SMP MP-table at [c00f5270] f5270
[    0.] Zone PFN ranges:
[    0.]   DMA      0x10 -> 0x?
[    0.]   Normal   0x? -> 0x000377fe
[    0.]   HighMem  0x000377fe -> 0x00037ef0
[    0.] Movable zone start PFN for each node
[    0.] early_node_map[2] active PFN ranges
[    0.]     0: 0x10 -> 0x9f
[    0.]     0: 0x00000100 -> 0x00037ef0
[    0.] On node 0 totalpages: 228991
[    0.] free_area_init_node: node 0, pgdat c06ef2c0, node_mem_map c1000200
[    0.]   DMA zone: 32 pages used for memmap
[    0.]   DMA zone: 0 pages reserved
[    0.]   DMA zone: 3951 pages, LIFO batch:0
[    0.]   Normal zone: 1744 pages used for memmap
[    0.]   Normal zone: 221486 pages, LIFO batch:31
[    0.]   HighMem zone: 14 pages used for memmap
[    0.]   HighMem zone: 1764 pages, LIFO batch:0
[    0.] Using APIC driver default
[    0.] Nvidia board detected. Ignoring ACPI timer override.
[    0.] If you got timer trouble try acpi_use_timer_override
[    0.] ACPI: PM-Timer IO Port: 0x4008
[    0.] ACPI: Local APIC address 0xfee00000
[    0.] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.] ACPI: IRQ9 used by override.
[    0.] ACPI: IRQ14 used by override.
[    0.] ACPI: IRQ15 used by override.
[    0.] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.] Using ACPI (MADT) for SMP configuration information
[    0.] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.] nr_irqs_gsi: 24
[    0.] PM: Registered nosave memory: ?M4?M4? - ?M4?M4k
[    0.] PM: Registered nosave memory: ?M4?M4k - ?M4?M4=7F
[    0.] PM: Registered nosave memory: ?M4?M4=7F - ?M4?M5?
[    0.] Allocating PCI resources starting at 5 (gap: 4:b)
[    0.] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.] PERCPU: Embedded 12 pages at c1704000, static data 25884 bytes
[    0.] Built 1 zonelists in Zone order, mobility grouping on.  Total pages=
: 227201
[    0.] Kernel command line: root=3DUUID=3D47d7310a-b187-493e-a59b-35d47fa2=
b16d ro quiet splash=20
[    0.] Enabling fast FPU save and restore... done.
[    0.] Enabling unmasked SIMD FPU exception support... done.
[    0.] Initializing CPU#0
[    0.] NR_IRQS:512
[    0.] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.] Fast TSC calibration using PIT
[    0.] Detected 2210.419 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 byt=
es)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes=
)
[    0.004000] allocated 4581760 bytes of page_cgroup
[    0.004000] please try cgroup_disable=3Dmemory option if you don't want
[    0.004000] Initializing HighMem for node 0 (000377fe:00037ef0)
[    0.004000] Memory: 888292k/916416k available (4181k kernel code, 27432k =
reserved, 2006k data, 528k init, 7112k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc - 0xf77fe000   ( 887 MB)
[    0.004000]       .init : 0xc0716000 - 0xc079a000   ( 528 kB)
[    0.004000]       .data : 0xc0515570 - 0xc070aee8   (2006 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0515570   (4181 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervi=
sor mode...Ok.
[    0.004000] SLUB: Genslabs=3D13, HWalign=3D64, Order=3D0-3, MinObjects=3D=
0, CPUs=3D2, Nodes=3D1
[    0.004007] Calibrating delay loop (skipped), value calculated using time=
r frequency.. 4420.83 BogoMIPS (lpj=3D8841676)
[    0.004028] Security Framework initialized
[    0.004033] SELinux:  Disabled at boot.
[    0.004040] Mount-cache hash table entries: 512
[    0.004157] Initializing cgroup subsys ns
[    0.004160] Initializing cgroup subsys cpuacct
[    0.004164] Initializing cgroup subsys memory
[    0.004169] Initializing cgroup subsys freezer
[    0.004180] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/l=
ine)
[    0.004182] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004186] using C1E aware idle routine
[    0.004193] Checking 'hlt' instruction... OK.
[    0.020453] SMP alternatives: switching to UP code
[    0.026478] ACPI: Core revision 20090320
[    0.036622] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1 pin2=3D-=
1
[    0.044001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.044001] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.044001] ..... (found apic 0 pin 0) ...
[    0.052001] ....... failed.
[    0.052001] ...trying to set up timer as Virtual Wire IRQ...
[    0.052001] ..... failed.
[    0.052001] ...trying to set up timer as ExtINT IRQ...
[    0.092064] ..... works.
[    0.092065] CPU0: AMD Athlon(tm) 64 Processor 3500+ stepping 02
[    0.096001] Brought up 1 CPUs
[    0.096001] Total of 1 processors activated (4420.83 BogoMIPS).
[    0.096001] CPU0 attaching NULL sched-domain.
[    0.096001] net_namespace: 1056 bytes
[    0.096001] Booting paravirtualized kernel on bare hardware
[    0.096001] regulator: core version 0.5
[    0.096001] Time: 21:02:55  Date: 08/17/09
[    0.096001] NET: Registered protocol family 16
[    0.096001] EISA bus registered
[    0.096001] ACPI: bus type pci registered
[    0.096001] PCI: MCFG configuration 0: base f segment 0 buses 0 - 255
[    0.096001] PCI: MCFG area at f reserved in E820
[    0.096001] PCI: updated MCFG configuration 0: base f segment 0 buses 0 -=
 63
[    0.096001] PCI: Using MMCONFIG for extended config space
[    0.096001] PCI: Using configuration type 1 for base access
[    0.096001] bio: create slab <bio-0> at 0
[    0.096001] ACPI: EC: Look up EC in DSDT
[    0.103142] ACPI: Interpreter enabled
[    0.103147] ACPI: (supports S0 S1 S3 S4 S5)
[    0.103171] ACPI: Using IOAPIC for interrupt routing
[    0.112926] ACPI: No dock devices found.
[    0.112940] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.113147] pci 0000:00:05.0: reg 10 32bit mmio: [0xfb-0xfbffffff]
[    0.113152] pci 0000:00:05.0: reg 14 64bit mmio: [0xe-0xefffffff]
[    0.113157] pci 0000:00:05.0: reg 1c 64bit mmio: [0xfc-0xfcffffff]
[    0.113162] pci 0000:00:05.0: reg 30 32bit mmio: [0x-0x01ffff]
[    0.113347] HPET not enabled in BIOS. You might try hpet=3Dforce boot opt=
ion
[    0.113387] pci 0000:00:0a.1: reg 20 io port: [0x4c00-0x4c3f]
[    0.113393] pci 0000:00:0a.1: reg 24 io port: [0x4c40-0x4c7f]
[    0.113415] pci 0000:00:0a.1: PME# supported from D3hot D3cold
[    0.113421] pci 0000:00:0a.1: PME# disabled
[    0.113480] pci 0000:00:0b.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
[    0.113506] pci 0000:00:0b.0: supports D1 D2
[    0.113507] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113511] pci 0000:00:0b.0: PME# disabled
[    0.113534] pci 0000:00:0b.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
[    0.113561] pci 0000:00:0b.1: supports D1 D2
[    0.113563] pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113566] pci 0000:00:0b.1: PME# disabled
[    0.113599] pci 0000:00:0d.0: reg 20 io port: [0xf400-0xf40f]
[    0.113636] pci 0000:00:0e.0: reg 10 io port: [0x9f0-0x9f7]
[    0.113641] pci 0000:00:0e.0: reg 14 io port: [0xbf0-0xbf3]
[    0.113645] pci 0000:00:0e.0: reg 18 io port: [0x970-0x977]
[    0.113649] pci 0000:00:0e.0: reg 1c io port: [0xb70-0xb73]
[    0.113654] pci 0000:00:0e.0: reg 20 io port: [0xe000-0xe00f]
[    0.113658] pci 0000:00:0e.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.113733] pci 0000:00:10.1: reg 10 32bit mmio: [0xfe028000-0xfe02bfff]
[    0.113764] pci 0000:00:10.1: PME# supported from D3hot D3cold
[    0.113767] pci 0000:00:10.1: PME# disabled
[    0.113796] pci 0000:00:14.0: reg 10 32bit mmio: [0xfe02c000-0xfe02cfff]
[    0.113801] pci 0000:00:14.0: reg 14 io port: [0xdc00-0xdc07]
[    0.113821] pci 0000:00:14.0: supports D1 D2
[    0.113823] pci 0000:00:14.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.113826] pci 0000:00:14.0: PME# disabled
[    0.113917] pci 0000:01:03.0: reg 10 32bit mmio: [0xfddff000-0xfddff7ff]
[    0.113923] pci 0000:01:03.0: reg 14 io port: [0xcc00-0xcc7f]
[    0.113955] pci 0000:01:03.0: supports D2
[    0.113957] pci 0000:01:03.0: PME# supported from D2 D3hot D3cold
[    0.113961] pci 0000:01:03.0: PME# disabled
[    0.113990] pci 0000:01:09.0: reg 10 32bit mmio: [0xfddfe000-0xfddfe7ff]
[    0.114024] pci 0000:01:09.0: supports D1 D2
[    0.114049] pci 0000:00:10.0: transparent bridge
[    0.114052] pci 0000:00:10.0: bridge io port: [0xc000-0xcfff]
[    0.114055] pci 0000:00:10.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.114059] pci 0000:00:10.0: bridge 32bit mmio pref: [0xfde00000-0xfdeff=
fff]
[    0.114064] pci_bus 0000:00: on NUMA node 0
[    0.114071] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.114242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.209542] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.209753] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.209963] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.210172] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.210381] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.210590] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.210801] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 *10 11 14 15)
[    0.211010] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.211219] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.211429] ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.211640] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
[    0.211856] ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.212073] ACPI: PCI Interrupt Link [LAZA] (IRQs *5 7 9 10 11 14 15)
[    0.212287] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.212497] ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.212707] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.212917] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.213129] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.213341] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
[    0.213564] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 14 15) *0, =
disabled.
[    0.213815] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.214060] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.214304] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.214549] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.214796] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.215040] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    0.215284] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.215527] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.215772] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.216022] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.216269] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.216514] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.216760] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.217006] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.217251] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.217497] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.217742] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.217988] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.218234] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.218481] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.218730] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabl=
ed.
[    0.218905] SCSI subsystem initialized
[    0.218993] libata version 3.00 loaded.
[    0.219056] usbcore: registered new interface driver usbfs
[    0.219071] usbcore: registered new interface driver hub
[    0.219092] usbcore: registered new device driver usb
[    0.219194] ACPI: WMI: Mapper loaded
[    0.219195] PCI: Using ACPI for IRQ routing
[    0.219328] Bluetooth: Core ver 2.15
[    0.219349] NET: Registered protocol family 31
[    0.219351] Bluetooth: HCI device and connection manager initialized
[    0.219354] Bluetooth: HCI socket layer initialized
[    0.219356] NET: Registered protocol family 8
[    0.219358] NET: Registered protocol family 20
[    0.219366] NetLabel: Initializing
[    0.219368] NetLabel:  domain hash size =3D 128
[    0.219370] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.219382] NetLabel:  unlabeled traffic allowed by default
[    0.219471] pnp: PnP ACPI init
[    0.219478] ACPI: bus type pnp registered
[    0.225352] pnp: PnP ACPI: found 12 devices
[    0.225353] ACPI: ACPI bus type pnp unregistered
[    0.225357] PnPBIOS: Disabled by ACPI PNP
[    0.225366] system 00:01: ioport range 0x4000-0x407f has been reserved
[    0.225369] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    0.225372] system 00:01: ioport range 0x4400-0x447f has been reserved
[    0.225375] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    0.225377] system 00:01: ioport range 0x4800-0x487f has been reserved
[    0.225380] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    0.225383] system 00:01: ioport range 0x2000-0x207f has been reserved
[    0.225386] system 00:01: ioport range 0x2080-0x20ff has been reserved
[    0.225389] system 00:01: iomem range 0x38-0x3fffffff has been reserved
[    0.225395] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.225397] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.225404] system 00:0a: iomem range 0xf-0xf3ffffff has been reserved
[    0.225409] system 00:0b: iomem range 0xf0000-0xf3fff could not be reserv=
ed
[    0.225412] system 00:0b: iomem range 0xf4000-0xf7fff could not be reserv=
ed
[    0.225415] system 00:0b: iomem range 0xf8000-0xfbfff could not be reserv=
ed
[    0.225417] system 00:0b: iomem range 0xfc000-0xfffff could not be reserv=
ed
[    0.225420] system 00:0b: iomem range 0x37ef0000-0x37efffff could not be =
reserved
[    0.225423] system 00:0b: iomem range 0xffff0000-0xffffffff has been rese=
rved
[    0.225426] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.225429] system 00:0b: iomem range 0x100000-0x37eeffff could not be re=
served
[    0.225432] system 00:0b: iomem range 0x37f00000-0x3fefffff could not be =
reserved
[    0.225435] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be =
reserved
[    0.225438] system 00:0b: iomem range 0xfee00000-0xfeefffff has been rese=
rved
[    0.225441] system 00:0b: iomem range 0xfefff000-0xfeffffff has been rese=
rved
[    0.225444] system 00:0b: iomem range 0xfff80000-0xfff80fff has been rese=
rved
[    0.225447] system 00:0b: iomem range 0xfff90000-0xfffbffff has been rese=
rved
[    0.225450] system 00:0b: iomem range 0xfffed000-0xfffeffff has been rese=
rved
[    0.260092] pci 0000:00:10.0: PCI bridge, secondary bus 0000:01
[    0.260095] pci 0000:00:10.0:   IO window: 0xc000-0xcfff
[    0.260099] pci 0000:00:10.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.260103] pci 0000:00:10.0:   PREFETCH window: 0x?M=1Fu?4-0xfdefffff
[    0.260112] pci 0000:00:10.0: setting latency timer to 64
[    0.260116] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.260119] pci_bus 0000:00: resource 1 mem: [0x-0xffffffff]
[    0.260121] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.260124] pci_bus 0000:01: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.260126] pci_bus 0000:01: resource 2 pref mem [0xfde00000-0xfdefffff]
[    0.260129] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.260131] pci_bus 0000:01: resource 4 mem: [0x-0xffffffff]
[    0.260161] NET: Registered protocol family 2
[    0.260248] IP route cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.260581] TCP established hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.261387] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.261799] TCP: Hash tables configured (established 131072 bind 65536)
[    0.261802] TCP reno registered
[    0.261892] NET: Registered protocol family 1
[    0.261956] Trying to unpack rootfs image as initramfs...
[    0.264032] Switched to high resolution mode on CPU 0
[    0.481275] Freeing initrd memory: 7454k freed
[    0.486185] cpufreq-nforce2: No nForce2 chipset.
[    0.486216] Scanning for low memory corruption every 60 seconds
[    0.486324] audit: initializing netlink socket (disabled)
[    0.486340] type=3D2000 audit(1250542974.484:1): initialized
[    0.495722] highmem bounce pool size: 64 pages
[    0.495727] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.496824] VFS: Disk quotas dquot_6.5.2
[    0.496873] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.497354] fuse init (API version 7.11)
[    0.497422] msgmni has been set to 1736
[    0.497587] alg: No test for stdrng (krng)
[    0.497597] io scheduler noop registered
[    0.497599] io scheduler anticipatory registered
[    0.497600] io scheduler deadline registered
[    0.497638] io scheduler cfq registered (default)
[    0.497666] pci 0000:00:05.0: Boot video device
[    0.512078] pci 0000:00:09.0: Found disabled HT MSI Mapping
[    0.512085] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    0.512133] pci 0000:00:09.0: Found disabled HT MSI Mapping
[    0.512138] pci 0000:00:10.0: Enabling HT MSI Mapping
[    0.512188] pci 0000:00:09.0: Found disabled HT MSI Mapping
[    0.512196] pci 0000:00:10.1: Enabling HT MSI Mapping
[    0.512282] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.512305] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.512430] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input=
/input0
[    0.512433] ACPI: Power Button [PWRF]
[    0.512480] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C=
:00/input/input1
[    0.512482] ACPI: Power Button [PWRB]
[    0.512537] fan PNP0C0B:00: registered as cooling_device0
[    0.512542] ACPI: Fan [FAN] (on)
[    0.512996] processor ACPI_CPU:00: registered as cooling_device1
[    0.519900] thermal LNXTHERM:01: registered as thermal_zone0
[    0.519907] ACPI: Thermal Zone [THRM] (40 C)
[    0.519952] isapnp: Scanning for PnP cards...
[    0.872871] isapnp: No Plug & Play device found
[    0.873785] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.873890] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.874142] 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.874807] brd: module loaded
[    0.875097] loop: module loaded
[    0.875165] input: Macintosh mouse button emulation as /devices/virtual/i=
nput/input2
[    0.875189] Driver 'sd' needs updating - please use bus_type methods
[    0.875196] Driver 'sr' needs updating - please use bus_type methods
[    0.875366] sata_nv 0000:00:0e.0: version 3.5
[    0.875799] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    0.875813] sata_nv 0000:00:0e.0: PCI INT A -> Link[APSI] -> GSI 23 (leve=
l, low) -> IRQ 23
[    0.875816] sata_nv 0000:00:0e.0: Using SWNCQ mode
[    0.875864] sata_nv 0000:00:0e.0: setting latency timer to 64
[    0.876138] scsi0 : sata_nv
[    0.876225] scsi1 : sata_nv
[    0.876399] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xe000 irq =
23
[    0.876403] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xe008 irq =
23
[    0.876488] pata_amd 0000:00:0d.0: version 0.4.1
[    0.876522] pata_amd 0000:00:0d.0: setting latency timer to 64
[    0.876617] scsi2 : pata_amd
[    0.876669] scsi3 : pata_amd
[    0.877272] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf400 irq =
14
[    0.877275] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf408 irq =
15
[    0.877740] Fixed MDIO Bus: probed
[    0.877746] PPP generic driver version 2.4.2
[    0.877850] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.878243] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[    0.878254] ehci_hcd 0000:00:0b.1: PCI INT B -> Link[APCL] -> GSI 22 (lev=
el, low) -> IRQ 22
[    0.878266] ehci_hcd 0000:00:0b.1: setting latency timer to 64
[    0.878269] ehci_hcd 0000:00:0b.1: EHCI Host Controller
[    0.878330] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus n=
umber 1
[    0.878357] ehci_hcd 0000:00:0b.1: debug port 1
[    0.878361] ehci_hcd 0000:00:0b.1: cache line size of 64 is not supported
[    0.878382] ehci_hcd 0000:00:0b.1: irq 22, io mem 0xfe02e000
[    0.888017] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00
[    0.888092] usb usb1: configuration #1 chosen from 1 choice
[    0.888121] hub 1-0:1.0: USB hub found
[    0.888130] hub 1-0:1.0: 8 ports detected
[    0.888220] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.888616] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[    0.888625] ohci_hcd 0000:00:0b.0: PCI INT A -> Link[APCF] -> GSI 21 (lev=
el, low) -> IRQ 21
[    0.888633] ohci_hcd 0000:00:0b.0: setting latency timer to 64
[    0.888636] ohci_hcd 0000:00:0b.0: OHCI Host Controller
[    0.888676] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus n=
umber 2
[    0.888703] ohci_hcd 0000:00:0b.0: irq 21, io mem 0xfe02f000
[    0.946061] usb usb2: configuration #1 chosen from 1 choice
[    0.946081] hub 2-0:1.0: USB hub found
[    0.946090] hub 2-0:1.0: 8 ports detected
[    0.946162] uhci_hcd: USB Universal Host Controller Interface driver
[    0.946239] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.946241] PNP: PS/2 appears to have AUX port disabled, if this is incor=
rect please boot with i8042.nopnp
[    0.946636] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.946686] mice: PS/2 mouse device common for all mice
[    0.946771] rtc_cmos 00:04: RTC can wake from S4
[    0.946804] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.946839] rtc0: alarms up to one year, y3k, 242 bytes nvram
[    0.946927] device-mapper: uevent: version 1.0.3
[    0.947036] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: =
dm-devel@redhat.com
[    0.947106] device-mapper: multipath: version 1.0.5 loaded
[    0.947108] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.947181] EISA: Probing bus 0 at eisa.0
[    0.947190] Cannot allocate resource for EISA slot 2
[    0.947194] Cannot allocate resource for EISA slot 4
[    0.947205] EISA: Detected 0 cards.
[    0.947248] cpuidle: using governor ladder
[    0.947250] cpuidle: using governor menu
[    0.947672] TCP cubic registered
[    0.947803] NET: Registered protocol family 10
[    0.948206] lo: Disabled Privacy Extensions
[    0.948490] NET: Registered protocol family 17
[    0.948505] Bluetooth: L2CAP ver 2.13
[    0.948506] Bluetooth: L2CAP socket layer initialized
[    0.948509] Bluetooth: SCO (Voice Link) ver 0.6
[    0.948510] Bluetooth: SCO socket layer initialized
[    0.948531] Bluetooth: RFCOMM socket layer initialized
[    0.948538] Bluetooth: RFCOMM TTY layer initialized
[    0.948540] Bluetooth: RFCOMM ver 1.11
[    0.948561] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3500+ proces=
sors (1 cpu cores) (version 2.20.00)
[    0.948609] powernow-k8:    0 : fid 0xe (2200 MHz), vid 0xc
[    0.948611] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xe
[    0.948613] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0x10
[    0.948615] powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
[    0.948649] Using IPI No-Shortcut mode
[    0.948708] PM: Resume from disk failed.
[    0.948720] registered taskstats version 1
[    0.948836]   Magic number: 5:479:45
[    0.948951] rtc_cmos 00:04: setting system clock to 2009-08-17 21:02:55 U=
TC (1250542975)
[    0.948954] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.948956] EDD information not available.
[    0.967951] input: AT Translated Set 2 keyboard as /devices/platform/i804=
2/serio0/input/input3
[    1.312026] usb 1-7: new high speed USB device using ehci_hcd and address=
 4
[    1.514455] usb 1-7: configuration #1 chosen from 1 choice
[    1.756048] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.778832] ata1.00: ATA-7: WDC WD5000YS-01MPB0, 07.02E07, max UDMA/133
[    1.778834] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.784470] ata1.00: configured for UDMA/133
[    1.784577] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 07.=
0 PQ: 0 ANSI: 5
[    1.784664] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.784711] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: (500 G=
B/465 GiB)
[    1.784725] sd 0:0:0:0: [sda] Write Protect is off
[    1.784728] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.784747] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, =
doesn't support DPO or FUA
[    1.784828]  sda: sda1 sda2 < sda5 sda6 >
[    1.807990] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.816024] usb 2-1: new low speed USB device using ohci_hcd and address =
2
[    2.032089] usb 2-1: configuration #1 chosen from 1 choice
[    2.336023] usb 2-3: new low speed USB device using ohci_hcd and address =
3
[    2.552084] usb 2-3: configuration #1 chosen from 1 choice
[    2.664047] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.672183] ata2.00: ATAPI: Optiarc DVD RW AD-7170S, 1.00, max UDMA/66
[    2.688194] ata2.00: configured for UDMA/66
[    2.690094] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7170S  1.0=
0 PQ: 0 ANSI: 5
[    2.693204] sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 c=
dda tray
[    2.693207] Uniform CD-ROM driver Revision: 3.20
[    2.693261] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.693292] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.693324] ata4: port disabled. ignoring.
[    2.693341] Freeing unused kernel memory: 528k freed
[    2.693687] Write protecting the kernel text: 4184k
[    2.693710] Write protecting the kernel read-only data: 1664k
[    3.098426] forcedeth: Reverse Engineered nForce ethernet driver. Version=
 0.64.
[    3.098886] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 20
[    3.098901] forcedeth 0000:00:14.0: PCI INT A -> Link[APCH] -> GSI 20 (le=
vel, low) -> IRQ 20
[    3.098906] forcedeth 0000:00:14.0: setting latency timer to 64
[    3.098944] nv_probe: set workaround bit for reversed mac addr
[    3.103121] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    3.103134] ohci1394 0000:01:03.0: PCI INT A -> Link[APC4] -> GSI 19 (lev=
el, low) -> IRQ 19
[    3.124068] usbcore: registered new interface driver hiddev
[    3.132417] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:0b.0=
/usb2/2-1/2-1:1.0/input/input4
[    3.132493] generic-usb 0003:046D:C00B.0001: input,hidraw0: USB HID v1.10=
 Mouse [Logitech USB Mouse] on usb-0000:00:0b.0-1/input0
[    3.145678] input: Cypress Cypress USB Keyboard as /devices/pci0000:00/00=
00:00:0b.0/usb2/2-3/2-3:1.0/input/input5
[    3.145771] generic-usb 0003:04B4:0100.0002: input,hidraw1: USB HID v1.10=
 Keyboard [Cypress Cypress USB Keyboard] on usb-0000:00:0b.0-3/input0
[    3.145790] usbcore: registered new interface driver usbhid
[    3.145794] usbhid: v2.6:USB HID core driver
[    3.162088] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[19]  MMIO=3D[=
fddff000-fddff7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
[    3.186081] Initializing USB Mass Storage driver...
[    3.186175] scsi4 : SCSI emulation for USB Mass Storage devices
[    3.186264] usbcore: registered new interface driver usb-storage
[    3.186267] USB Mass Storage support registered.
[    3.197421] usb-storage: device found at 4
[    3.197426] usb-storage: waiting for device to settle before scanning
[    3.616811] forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 11, add=
r 00:18:f3:e3:cc:a5
[    3.616817] forcedeth 0000:00:14.0: highdma pwrctl gbit lnktim desc-v3
[    3.806619] PM: Starting manual resume from disk
[    3.806624] PM: Resume from partition 8:5
[    3.806625] PM: Checking hibernation image.
[    3.806796] PM: Resume from disk failed.
[    3.820976] kjournald starting.  Commit interval 5 seconds
[    3.820987] EXT3-fs: mounted filesystem with writeback data mode.
[    4.436214] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d800010a349=
0]
[    4.724610] udev: starting version 141
[    5.129152] k8temp 0000:00:18.3: Temperature readouts might be wrong - ch=
eck erratum #141
[    5.252989] Linux agpgart interface v0.103
[    5.455498] parport_pc 00:08: reported by Plug and Play ACPI
[    5.455530] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    5.458895] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[    5.458912] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[    5.473810] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    6.045131] nvidia: module license 'NVIDIA' taints kernel.
[    6.045136] Disabling lock debugging due to kernel taint
[    6.302684] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[    6.302702] nvidia 0000:00:05.0: PCI INT A -> Link[APC7] -> GSI 16 (level=
, low) -> IRQ 16
[    6.302708] nvidia 0000:00:05.0: setting latency timer to 64
[    6.303952] NVRM: loading NVIDIA UNIX x86 Kernel Module  185.18.14  Wed M=
ay 27 02:23:13 PDT 2009
[    6.380567] ppdev: user-space parallel port driver
[    6.468025] Linux video capture interface: v2.00
[    6.607247] saa7130/34: v4l2 driver version 0.2.15 loaded
[    6.607768] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[    6.607773] saa7134 0000:01:09.0: PCI INT A -> Link[APC1] -> GSI 16 (leve=
l, low) -> IRQ 16
[    6.607780] saa7133[0]: found at 0000:01:09.0, rev: 209, irq: 16, latency=
: 32, mmio: 0xfddfe000
[    6.607787] saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1=
120 DVB-T/Hybrid [card=3D156,autodetected]
[    6.607807] saa7133[0]: board init: gpio is 40000
[    6.628048] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared =
IRQs
[    6.780020] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1=
c 55 d2 b2 92
[    6.780029] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff f=
f ff ff ff ff
[    6.780036] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b=
0 ff ff ff ff
[    6.780043] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff
[    6.780050] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 2=
0 00 ff ff ff
[    6.780056] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780063] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780069] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780076] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 66 8b 5e f=
0 73 05 29 00
[    6.780082] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 19 8d 7=
2 07 70 73 09
[    6.780089] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 0=
1 72 0f 01 72
[    6.780095] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 aa 0=
0 00 00 00 00
[    6.780102] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780108] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780115] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780121] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00
[    6.780129] i2c-adapter i2c-2: Invalid 7-bit address 0x7a
[    6.780538] tveeprom 2-0050: Hauppauge model 67209, rev C1F5, serial# 619=
6070
[    6.780541] tveeprom 2-0050: MAC address is 00-0D-FE-5E-8B-66
[    6.780544] tveeprom 2-0050: tuner model is NXP 18271C2 (idx 155, type 54=
)
[    6.780547] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL=
(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    6.780550] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
[    6.780552] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
[    6.780555] tveeprom 2-0050: has radio, has IR receiver, has no IR transm=
itter
[    6.780557] saa7133[0]: hauppauge eeprom: model=3D67209
[    6.806063] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
[    6.806070] HDA Intel 0000:00:10.1: PCI INT B -> Link[AAZA] -> GSI 23 (le=
vel, low) -> IRQ 23
[    6.806101] HDA Intel 0000:00:10.1: setting latency timer to 64
[    6.876127] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[    6.956023] tda829x 2-004b: setting tuner address to 60
[    7.007038] tda18271 2-0060: creating new instance
[    7.052031] TDA18271HD/C2 detected @ 2-0060
[    8.201822] usb-storage: device scan complete
[    8.206190] scsi 4:0:0:0: Direct-Access     ASUS     Flash HS-CF      3.9=
5 PQ: 0 ANSI: 0
[    8.209796] scsi 4:0:0:1: Direct-Access     ASUS     Flash HS-COMBO   3.9=
5 PQ: 0 ANSI: 0
[    8.210144] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    8.210210] sd 4:0:0:1: Attached scsi generic sg3 type 0
[    8.215534] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    8.265796] sd 4:0:0:1: [sdc] Attached SCSI removable disk
[    8.384026] tda18271: performing RF tracking filter calibration
[   15.764017] eth0: no IPv6 routers present
[   26.588021] tda18271: RF tracking filter calibration complete
[   26.644019] tda829x 2-004b: type set to tda8290+18271
[   31.620097] saa7133[0]: registered device video0 [v4l2]
[   31.620119] saa7133[0]: registered device vbi0
[   31.620138] saa7133[0]: registered device radio0
[   31.637378] saa7134 ALSA driver for DMA sound loaded
[   31.637393] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared =
IRQs
[   31.637414] saa7133[0]/alsa: saa7133[0] at 0xfddfe000 irq 16 registered a=
s card -2
[   31.709298] dvb_init() allocating 1 frontend
[   31.836021] tda829x 2-004b: type set to tda8290
[   31.846263] lp0: using parport0 (interrupt-driven).
[   31.854589] tda18271 2-0060: attaching existing instance
[   31.854597] DVB: registering new adapter (saa7133[0])
[   31.854601] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T).=
..
[   32.019385] Adding 995988k swap on /dev/sda5.  Priority:-1 extents:1 acro=
ss:995988k=20
[   32.180019] tda10048_firmware_upload: waiting for firmware upload (dvb-fe=
-tda10048-1.0.fw)...
[   32.180024] saa7134 0000:01:09.0: firmware: requesting dvb-fe-tda10048-1.=
0.fw
[   32.244766] tda10048_firmware_upload: firmware read 24878 bytes.
[   32.244770] tda10048_firmware_upload: firmware uploading
[   32.667712] EXT3 FS on sda1, internal journal
[   34.565342] SGI XFS with ACLs, security attributes, realtime, large block=
/inode numbers, no debug enabled
[   34.570561] SGI XFS Quota Management subsystem
[   34.662219] XFS mounting filesystem sda6
[   35.014623] Ending clean XFS mount for filesystem: sda6
[   36.352074] tda10048_firmware_upload: firmware uploaded
[   38.135678] lirc_dev: IR Remote Control driver registered, major 61=20
[   38.198345] bttv: driver version 0.9.18 loaded
[   38.198349] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   38.243277] ivtv: Start initialization, version 1.4.1
[   38.243321] ivtv: End initialization
[   38.279342] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[   45.796027] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[   46.460019] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[   46.460025] tda18271_channel_configuration: error -5 on line 99
[   46.460028] tda18271_set_analog_params: error -5 on line 1005
[   49.411877] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   49.411883] Bluetooth: BNEP filters: protocol multicast
[   49.445789] Bridge firewalling registered
[   72.660050] sr 1:0:0:0: [sr0] Unhandled sense code
[   72.660055] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   72.660059] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   72.660064] Info fld=3D0x1ea790
[   72.660065] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   72.660069] end_request: I/O error, dev sr0, sector 8035904
[   72.660073] Buffer I/O error on device sr0, logical block 1004488
[   72.660076] Buffer I/O error on device sr0, logical block 1004489
[   72.660078] Buffer I/O error on device sr0, logical block 1004490
[   72.660080] Buffer I/O error on device sr0, logical block 1004491
[   72.660083] Buffer I/O error on device sr0, logical block 1004492
[   72.660085] Buffer I/O error on device sr0, logical block 1004493
[   72.660087] Buffer I/O error on device sr0, logical block 1004494
[   72.660090] Buffer I/O error on device sr0, logical block 1004495
[   72.660092] Buffer I/O error on device sr0, logical block 1004496
[   72.660094] Buffer I/O error on device sr0, logical block 1004497
[   73.469832] sr 1:0:0:0: [sr0] Unhandled sense code
[   73.469836] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   73.469840] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   73.469844] Info fld=3D0x20d1c6
[   73.469845] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   73.469849] end_request: I/O error, dev sr0, sector 8603416
[   74.164168] sr 1:0:0:0: [sr0] Unhandled sense code
[   74.164173] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   74.164176] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   74.164181] Info fld=3D0x20d1c6
[   74.164182] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   74.164186] end_request: I/O error, dev sr0, sector 8603416
[   74.858620] sr 1:0:0:0: [sr0] Unhandled sense code
[   74.858624] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   74.858627] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   74.858632] Info fld=3D0x20d1c6
[   74.858633] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   74.858637] end_request: I/O error, dev sr0, sector 8603416
[   75.553061] sr 1:0:0:0: [sr0] Unhandled sense code
[   75.553065] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   75.553068] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   75.553073] Info fld=3D0x20d1c6
[   75.553074] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   75.553078] end_request: I/O error, dev sr0, sector 8603416
[   76.247604] sr 1:0:0:0: [sr0] Unhandled sense code
[   76.247608] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   76.247611] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   76.247616] Info fld=3D0x20d1c6
[   76.247617] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   76.247620] end_request: I/O error, dev sr0, sector 8603416
[   76.942005] sr 1:0:0:0: [sr0] Unhandled sense code
[   76.942009] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   76.942013] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   76.942017] Info fld=3D0x20d1c6
[   76.942019] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   76.942022] end_request: I/O error, dev sr0, sector 8603416
[   77.636488] sr 1:0:0:0: [sr0] Unhandled sense code
[   77.636493] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   77.636496] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   77.636500] Info fld=3D0x20d1c6
[   77.636502] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   77.636505] end_request: I/O error, dev sr0, sector 8603416
[   78.331002] sr 1:0:0:0: [sr0] Unhandled sense code
[   78.331006] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   78.331010] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   78.331014] Info fld=3D0x20d1c6
[   78.331015] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   78.331019] end_request: I/O error, dev sr0, sector 8603416
[   78.331023] __ratelimit: 17 callbacks suppressed
[   78.331026] Buffer I/O error on device sr0, logical block 1075427
[   79.025490] sr 1:0:0:0: [sr0] Unhandled sense code
[   79.025494] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   79.025497] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   79.025502] Info fld=3D0x20d1c6
[   79.025503] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   79.025507] end_request: I/O error, dev sr0, sector 8603416
[   79.025512] Buffer I/O error on device sr0, logical block 1075427
[   79.720040] sr 1:0:0:0: [sr0] Unhandled sense code
[   79.720045] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   79.720048] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   79.720052] Info fld=3D0x20d1c6
[   79.720054] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   79.720057] end_request: I/O error, dev sr0, sector 8603416
[   79.720062] Buffer I/O error on device sr0, logical block 1075427
[   80.414436] sr 1:0:0:0: [sr0] Unhandled sense code
[   80.414440] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   80.414444] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   80.414448] Info fld=3D0x20d1c6
[   80.414450] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   80.414453] end_request: I/O error, dev sr0, sector 8603416
[   80.414458] Buffer I/O error on device sr0, logical block 1075427
[   81.108959] sr 1:0:0:0: [sr0] Unhandled sense code
[   81.108963] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   81.108966] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   81.108971] Info fld=3D0x20d1c6
[   81.108972] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   81.108975] end_request: I/O error, dev sr0, sector 8603416
[   81.108980] Buffer I/O error on device sr0, logical block 1075427
[   81.803427] sr 1:0:0:0: [sr0] Unhandled sense code
[   81.803431] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   81.803434] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   81.803439] Info fld=3D0x20d1c6
[   81.803440] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   81.803444] end_request: I/O error, dev sr0, sector 8603416
[   81.803448] Buffer I/O error on device sr0, logical block 1075427
[   82.497926] sr 1:0:0:0: [sr0] Unhandled sense code
[   82.497930] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   82.497934] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   82.497938] Info fld=3D0x20d1c6
[   82.497939] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   82.497943] end_request: I/O error, dev sr0, sector 8603416
[   82.497948] Buffer I/O error on device sr0, logical block 1075427
[   83.192421] sr 1:0:0:0: [sr0] Unhandled sense code
[   83.192425] sr 1:0:0:0: [sr0] Result: hostbyte=3DDID_OK driverbyte=3DDRIV=
ER_SENSE
[   83.192428] sr 1:0:0:0: [sr0] Sense Key : Medium Error [current]=20
[   83.192433] Info fld=3D0x20d1c6
[   83.192434] sr 1:0:0:0: [sr0] Add. Sense: No seek complete
[   83.192437] end_request: I/O error, dev sr0, sector 8603416
[   83.192442] Buffer I/O error on device sr0, logical block 1075427
[  113.564534] i2c /dev entries driver
[  114.260059] Clocksource tsc unstable (delta =3D -272754067 ns)
--=_5r0kmqmcm5j4
Content-Type: text/plain;
	charset=UTF-8;
	name="devinput.tv.20090817.txt"
Content-Disposition: attachment;
	filename="devinput.tv.20090817.txt"
Content-Transfer-Encoding: quoted-printable

I: Bus=3D0019 Vendor=3D0000 Product=3D0001 Version=3D0000
N: Name=3D"Power Button"
P: Phys=3DLNXPWRBN/button/input0
S: Sysfs=3D/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
U: Uniq=3D
H: Handlers=3Dkbd event0=20
B: EV=3D3
B: KEY=3D100000 0 0 0

I: Bus=3D0019 Vendor=3D0000 Product=3D0001 Version=3D0000
N: Name=3D"Power Button"
P: Phys=3DPNP0C0C/button/input0
S: Sysfs=3D/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
U: Uniq=3D
H: Handlers=3Dkbd event1=20
B: EV=3D3
B: KEY=3D100000 0 0 0

I: Bus=3D0017 Vendor=3D0001 Product=3D0001 Version=3D0100
N: Name=3D"Macintosh mouse button emulation"
P: Phys=3D
S: Sysfs=3D/devices/virtual/input/input2
U: Uniq=3D
H: Handlers=3Dmouse0 event2=20
B: EV=3D7
B: KEY=3D70000 0 0 0 0 0 0 0 0
B: REL=3D3

I: Bus=3D0011 Vendor=3D0001 Product=3D0001 Version=3Dab41
N: Name=3D"AT Translated Set 2 keyboard"
P: Phys=3Disa0060/serio0/input0
S: Sysfs=3D/devices/platform/i8042/serio0/input/input3
U: Uniq=3D
H: Handlers=3Dkbd event3=20
B: EV=3D120013
B: KEY=3D4 2 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=3D10
B: LED=3D7

I: Bus=3D0003 Vendor=3D046d Product=3Dc00b Version=3D0110
N: Name=3D"Logitech USB Mouse"
P: Phys=3Dusb-0000:00:0b.0-1/input0
S: Sysfs=3D/devices/pci0000:00/0000:00:0b.0/usb2/2-1/2-1:1.0/input/input4
U: Uniq=3D
H: Handlers=3Dmouse1 event4=20
B: EV=3D17
B: KEY=3Df0000 0 0 0 0 0 0 0 0
B: REL=3D103
B: MSC=3D10

I: Bus=3D0003 Vendor=3D04b4 Product=3D0100 Version=3D0110
N: Name=3D"Cypress Cypress USB Keyboard"
P: Phys=3Dusb-0000:00:0b.0-3/input0
S: Sysfs=3D/devices/pci0000:00/0000:00:0b.0/usb2/2-3/2-3:1.0/input/input5
U: Uniq=3D
H: Handlers=3Dkbd mouse2 event5=20
B: EV=3D100017
B: KEY=3D70000 0 2 3878 d801c001 e08effdf 1cfffff ffffffff fffffffe
B: REL=3D103
B: MSC=3D10

I: Bus=3D0010 Vendor=3D001f Product=3D0001 Version=3D0100
N: Name=3D"PC Speaker"
P: Phys=3Disa0061/input0
S: Sysfs=3D/devices/platform/pcspkr/input/input6
U: Uniq=3D
H: Handlers=3Dkbd event6=20
B: EV=3D40001
B: SND=3D6
--=_5r0kmqmcm5j4
Content-Type: text/plain;
	charset=UTF-8;
	name="lsmod.tv.20090817.txt"
Content-Disposition: attachment;
	filename="lsmod.tv.20090817.txt"
Content-Transfer-Encoding: quoted-printable


Module                  Size  Used by
i2c_dev                 6228  0=20
bridge                 47904  0=20
stp                     2224  1 bridge
bnep                   12140  2=20
cx8800                 31000  0=20
cx88xx                 76876  1 cx8800
ivtv                  142852  0=20
cx2341x                13808  1 ivtv
bttv                  120468  0=20
i2c_algo_bit            5776  3 cx88xx,ivtv,bttv
btcx_risc               4756  3 cx8800,cx88xx,bttv
lirc_i2c                8496  0=20
lirc_dev               10948  1 lirc_i2c
video                  19744  0=20
output                  2764  1 video
xfs                   518592  1=20
exportfs                4268  1 xfs
lp                      8900  0=20
tda10048               11440  1=20
saa7134_dvb            23064  0=20
videobuf_dvb            6928  1 saa7134_dvb
dvb_core               87172  1 videobuf_dvb
saa7134_alsa           11776  0=20
snd_hda_codec_realtek   199152  1=20
tda18271               34612  2=20
tda8290                12852  2=20
snd_hda_intel          27304  0=20
tuner                  21896  1=20
snd_hda_codec          74092  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               7024  1 snd_hda_codec
snd_pcm_oss            40224  0=20
snd_mixer_oss          16684  1 snd_pcm_oss
snd_pcm                76272  4 saa7134_alsa,snd_hda_intel,snd_hda_codec,snd=
_pcm_oss
snd_seq_dummy           2672  0=20
snd_seq_oss            28448  0=20
snd_seq_midi            6304  0=20
saa7134               152856  2 saa7134_dvb,saa7134_alsa
snd_rawmidi            21536  1 snd_seq_midi
snd_seq_midi_event      6860  2 snd_seq_oss,snd_seq_midi
ir_common              49328  3 cx88xx,bttv,saa7134
snd_seq                48560  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_s=
eq_midi_event
v4l2_common            17452  7 cx8800,cx88xx,ivtv,cx2341x,bttv,tuner,saa713=
4
snd_timer              21908  2 snd_pcm,snd_seq
snd_seq_device          7000  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_r=
awmidi,snd_seq
videodev               36640  7 cx8800,cx88xx,ivtv,bttv,tuner,saa7134,v4l2_c=
ommon
v4l1_compat            14288  1 videodev
videobuf_dma_sg        12336  6 cx8800,cx88xx,bttv,saa7134_dvb,saa7134_alsa,=
saa7134
videobuf_core          17936  6 cx8800,cx88xx,bttv,videobuf_dvb,saa7134,vide=
obuf_dma_sg
ppdev                   7280  0=20
tveeprom               11984  4 cx88xx,ivtv,bttv,saa7134
snd                    58276  13 saa7134_alsa,snd_hda_codec_realtek,snd_hda_=
intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,=
snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               7168  1 snd
nvidia               9542308  58=20
pcspkr                  2284  0=20
i2c_nforce2             7120  0=20
parport_pc             33476  1=20
parport                35020  3 lp,ppdev,parport_pc
snd_page_alloc          8980  2 snd_hda_intel,snd_pcm
agpgart                35884  1 nvidia
k8temp                  4428  0=20
usb_storage            51904  0=20
usbhid                 37632  0=20
ohci1394               31292  0=20
forcedeth              56280  0=20
ieee1394               88756  1 ohci1394  
--=_5r0kmqmcm5j4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=_5r0kmqmcm5j4--
