Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:47735 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959Ab0C0E7d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Mar 2010 00:59:33 -0400
Subject: Re: dmsg dump for Tevion High Speed DVD Maker
From: hermann pitton <hermann-pitton@arcor.de>
To: ourmail@kconline.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BAD7AE5.6000608@kconline.com>
References: <4BAD7AE5.6000608@kconline.com>
Content-Type: text/plain
Date: Sat, 27 Mar 2010 05:59:10 +0100
Message-Id: <1269665950.3216.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 26.03.2010, 23:26 -0400 schrieb OurMail:
> Hi,
> 
> Was trying to get a firewire port working in Ubuntu 9.10 when I noticed
> that I had my USB Tevion DVD Maker plugged in and that you had a message
> requesting a copy of the dump for the unidentified DVD Maker. Attached
> is that dump as requested.
> 
> Not sure where you are located but a German food store chain operating
> in the US under the name Aldi Food Stores has sold these a couple times
> that I know of. There are at least two versions although they function
> the same. A couple years ago they had them for $40 US. Last fall they
> had them for $20. At that price they should have been popular so should
> be other Linux users with them. Have seen a few users on the boards
> trying to get them going.
> 
> They work well under Windows Vista but have never gotten one to work
> under Linux. Have been trying to get away from Windows for video work
> but have not been able to get either the this USB device or my Sony
> DSR-20 DV/DVCAM firewire deck to work under Linux.
> 
> Am not all that good at Linux and any help you care to provide would be
> most welcome.
> 
> Dave

just a hint. If Aldi stuff is called Medion as well, you usually find
the device at http://www.creatix.de.

If it is called Tevion, it can be some AverMedia Kworld or whatever
clone.

Cheers,
Hermann

> einfaches Textdokument-Anlage (dmesg-dump-ourmailATkconlineDOTcom)
> dave@systemax1:~$ dmesg
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.31-20-generic (buildd@palmer) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #58-Ubuntu SMP Fri Mar 12 05:23:09 UTC 2010 (Ubuntu 2.6.31-20.58-generic)
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6a0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf6a0000 - 00000000bf6ae000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf6ae000 - 00000000bf6f0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf6f0000 - 00000000bf6fe000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] DMI present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xbf6a0 max_arch_pfn = 0x100000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-CBFFF write-protect
> [    0.000000]   CC000-DFFFF uncachable
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0BF700000 mask FFFF00000 uncachable
> [    0.000000]   3 base 0BF800000 mask FFF800000 uncachable
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
> [    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000bf6a0000 (usable)
> [    0.000000]  modified: 00000000bf6a0000 - 00000000bf6ae000 (ACPI data)
> [    0.000000]  modified: 00000000bf6ae000 - 00000000bf6f0000 (ACPI NVS)
> [    0.000000]  modified: 00000000bf6f0000 - 00000000bf6fe000 (reserved)
> [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
> [    0.000000] initial memory mapped : 0 - 00c00000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
> [    0.000000] Using x86 segment limits to approximate NX protection
> [    0.000000]  0000000000 - 0000400000 page 4k
> [    0.000000]  0000400000 - 0037400000 page 2M
> [    0.000000]  0037400000 - 00377fe000 page 4k
> [    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
> [    0.000000] RAMDISK: 378a5000 - 37fef6df
> [    0.000000] Allocated new RAMDISK: 008b2000 - 00ffc6df
> [    0.000000] Move RAMDISK from 00000000378a5000 - 0000000037fef6de to 008b2000 - 00ffc6de
> [    0.000000] ACPI: RSDP 000f9640 00014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT bf6a0000 00044 (v01 SYSMAX SYXSUKIT 20090306 MSFT 00000097)
> [    0.000000] ACPI: FACP bf6a0200 00084 (v01 7529MS A7529200 20090306 MSFT 00000097)
> [    0.000000] ACPI: DSDT bf6a05c0 05A56 (v01  A7529 A7529200 00000200 INTL 20051117)
> [    0.000000] ACPI: FACS bf6ae000 00040
> [    0.000000] ACPI: APIC bf6a0390 0006C (v01 7529MS A7529200 20090306 MSFT 00000097)
> [    0.000000] ACPI: MCFG bf6a0400 0003C (v01 7529MS OEMMCFG  20090306 MSFT 00000097)
> [    0.000000] ACPI: SLIC bf6a0440 00176 (v01 SYSMAX SYXSUKIT 20090306 MSFT 00000097)
> [    0.000000] ACPI: OEMB bf6ae040 00071 (v01 7529MS A7529200 20090306 MSFT 00000097)
> [    0.000000] ACPI: HPET bf6a6020 00038 (v01 7529MS OEMHPET  20090306 MSFT 00000097)
> [    0.000000] ACPI: GSCI bf6ae0c0 02024 (v01 7529MS GMCHSCI  20090306 MSFT 00000097)
> [    0.000000] ACPI: SSDT bf6b05f0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 2174MB HIGHMEM available.
> [    0.000000] 887MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 377fe000
> [    0.000000]   low ram: 0 - 377fe000
> [    0.000000]   node 0 low ram: 00000000 - 377fe000
> [    0.000000]   node 0 bootmap 00011000 - 00017f00
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> [    0.000000]   #3 [0000100000 - 00008ad060]    TEXT DATA BSS ==> [0000100000 - 00008ad060]
> [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
> [    0.000000]   #5 [00008ae000 - 00008b1191]              BRK ==> [00008ae000 - 00008b1191]
> [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
> [    0.000000]   #7 [00008b2000 - 0000ffc6df]      NEW RAMDISK ==> [00008b2000 - 0000ffc6df]
> [    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
> [    0.000000] found SMP MP-table at [c00ff780] ff780
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000377fe
> [    0.000000]   HighMem  0x000377fe -> 0x000bf6a0
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[2] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009f
> [    0.000000]     0: 0x00000100 -> 0x000bf6a0
> [    0.000000] On node 0 totalpages: 783919
> [    0.000000] free_area_init_node: node 0, pgdat c0788900, node_mem_map c1000200
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1744 pages used for memmap
> [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 4350 pages used for memmap
> [    0.000000]   HighMem zone: 552356 pages, LIFO batch:31
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at bf6fe000 (gap: bf6fe000:3f702000)
> [    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 14 pages at c2800000, static data 35612 bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 777793
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-20-generic root=UUID=862ff519-00d8-4af1-8781-8c0dc43c83eb ro quiet splash
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
> [    0.000000] allocated 15680320 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] Initializing HighMem for node 0 (000377fe:000bf6a0)
> [    0.000000] Memory: 3078572k/3136128k available (4578k kernel code, 56280k reserved, 2146k data, 540k init, 2226824k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
> [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
> [    0.000000]       .init : 0xc0792000 - 0xc0819000   ( 540 kB)
> [    0.000000]       .data : 0xc0578948 - 0xc0791408   (2146 kB)
> [    0.000000]       .text : 0xc0100000 - 0xc0578948   (4578 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] NR_IRQS:2304 nr_irqs:440
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2520.620 MHz processor.
> [    0.001343] Console: colour VGA+ 80x25
> [    0.001346] console [tty0] enabled
> [    0.001477] hpet clockevent registered
> [    0.001479] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    0.001484] Calibrating delay loop (skipped), value calculated using timer frequency.. 5041.24 BogoMIPS (lpj=10082480)
> [    0.001501] Security Framework initialized
> [    0.001519] AppArmor: AppArmor initialized
> [    0.001525] Mount-cache hash table entries: 512
> [    0.001641] Initializing cgroup subsys ns
> [    0.001645] Initializing cgroup subsys cpuacct
> [    0.001649] Initializing cgroup subsys memory
> [    0.001654] Initializing cgroup subsys freezer
> [    0.001656] Initializing cgroup subsys net_cls
> [    0.001669] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.001671] CPU: L2 cache: 2048K
> [    0.001673] CPU: Physical Processor ID: 0
> [    0.001674] CPU: Processor Core ID: 0
> [    0.001678] mce: CPU supports 6 MCE banks
> [    0.001685] CPU0: Thermal monitoring enabled (TM2)
> [    0.001688] using mwait in idle threads.
> [    0.001694] Performance Counters: Core2 events, Intel PMU driver.
> [    0.001700] ... version:                 2
> [    0.001702] ... bit width:               40
> [    0.001703] ... generic counters:        2
> [    0.001704] ... value mask:              000000ffffffffff
> [    0.001706] ... max period:              000000007fffffff
> [    0.001707] ... fixed-purpose counters:  3
> [    0.001709] ... counter mask:            0000000700000003
> [    0.001715] Checking 'hlt' instruction... OK.
> [    0.018381] ACPI: Core revision 20090521
> [    0.028350] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.069445] CPU0: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 0a
> [    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.004000] Initializing CPU#1
> [    0.004000] Calibrating delay using timer specific routine.. 5041.24 BogoMIPS (lpj=10082489)
> [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.004000] CPU: L2 cache: 2048K
> [    0.004000] CPU: Physical Processor ID: 0
> [    0.004000] CPU: Processor Core ID: 1
> [    0.004000] mce: CPU supports 6 MCE banks
> [    0.004000] CPU1: Thermal monitoring enabled (TM2)
> [    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.157502] CPU1: Intel Pentium(R) Dual-Core  CPU      E5200  @ 2.50GHz stepping 0a
> [    0.157515] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.160022] Brought up 2 CPUs
> [    0.160024] Total of 2 processors activated (10082.48 BogoMIPS).
> [    0.160067] CPU0 attaching sched-domain:
> [    0.160069]  domain 0: span 0-1 level MC
> [    0.160071]   groups: 0 1
> [    0.160076] CPU1 attaching sched-domain:
> [    0.160077]  domain 0: span 0-1 level MC
> [    0.160079]   groups: 1 0
> [    0.160145] Booting paravirtualized kernel on bare hardware
> [    0.160174] regulator: core version 0.5
> [    0.160174] Time: 22:02:53  Date: 03/26/10
> [    0.160174] NET: Registered protocol family 16
> [    0.160174] EISA bus registered
> [    0.160178] ACPI: bus type pci registered
> [    0.160233] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.160235] PCI: Not using MMCONFIG.
> [    0.160381] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
> [    0.160383] PCI: Using configuration type 1 for base access
> [    0.161179] bio: create slab <bio-0> at 0
> [    0.161179] ACPI: EC: Look up EC in DSDT
> [    0.170234] ACPI: Interpreter enabled
> [    0.170243] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.170261] ACPI: Using IOAPIC for interrupt routing
> [    0.170301] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.173399] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.173401] PCI: Using MMCONFIG for extended config space
> [    0.179478] ACPI Warning: Incorrect checksum in table [OEMB] - B9, should be B4 20090521 tbutils-246
> [    0.180273] ACPI: No dock devices found.
> [    0.180526] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.180603] pci 0000:00:02.0: reg 10 32bit mmio: [0xfe980000-0xfe9fffff]
> [    0.180607] pci 0000:00:02.0: reg 14 io port: [0xdc00-0xdc07]
> [    0.180612] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
> [    0.180616] pci 0000:00:02.0: reg 1c 32bit mmio: [0xfe800000-0xfe8fffff]
> [    0.180686] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe978000-0xfe97bfff]
> [    0.180724] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.180728] pci 0000:00:1b.0: PME# disabled
> [    0.180782] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.180785] pci 0000:00:1c.0: PME# disabled
> [    0.180839] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.180842] pci 0000:00:1c.1: PME# disabled
> [    0.180888] pci 0000:00:1d.0: reg 20 io port: [0xd880-0xd89f]
> [    0.180932] pci 0000:00:1d.1: reg 20 io port: [0xd800-0xd81f]
> [    0.180975] pci 0000:00:1d.2: reg 20 io port: [0xd480-0xd49f]
> [    0.181019] pci 0000:00:1d.3: reg 20 io port: [0xd400-0xd41f]
> [    0.181068] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe977c00-0xfe977fff]
> [    0.181115] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.181119] pci 0000:00:1d.7: PME# disabled
> [    0.181228] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    0.181231] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
> [    0.181234] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
> [    0.181237] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0a00 (mask 0017)
> [    0.181240] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 00ff)
> [    0.181278] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
> [    0.181284] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
> [    0.181290] pci 0000:00:1f.1: reg 18 io port: [0x8f0-0x8f7]
> [    0.181296] pci 0000:00:1f.1: reg 1c io port: [0x8f8-0x8fb]
> [    0.181301] pci 0000:00:1f.1: reg 20 io port: [0xffa0-0xffaf]
> [    0.181339] pci 0000:00:1f.2: reg 10 io port: [0xd080-0xd087]
> [    0.181345] pci 0000:00:1f.2: reg 14 io port: [0xd000-0xd003]
> [    0.181350] pci 0000:00:1f.2: reg 18 io port: [0xcc00-0xcc07]
> [    0.181355] pci 0000:00:1f.2: reg 1c io port: [0xc880-0xc883]
> [    0.181360] pci 0000:00:1f.2: reg 20 io port: [0xc800-0xc80f]
> [    0.181382] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.181385] pci 0000:00:1f.2: PME# disabled
> [    0.181426] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
> [    0.181540] pci 0000:02:00.0: reg 10 io port: [0xe800-0xe8ff]
> [    0.181561] pci 0000:02:00.0: reg 18 64bit mmio: [0xfeaff000-0xfeafffff]
> [    0.181583] pci 0000:02:00.0: reg 30 32bit mmio: [0xfeac0000-0xfeadffff]
> [    0.181628] pci 0000:02:00.0: supports D1 D2
> [    0.181630] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.181634] pci 0000:02:00.0: PME# disabled
> [    0.181684] pci 0000:00:1c.1: bridge io port: [0xe000-0xefff]
> [    0.181687] pci 0000:00:1c.1: bridge 32bit mmio: [0xfea00000-0xfeafffff]
> [    0.181723] pci 0000:03:01.0: reg 10 32bit mmio: [0xfebff000-0xfebfffff]
> [    0.181766] pci 0000:03:01.0: supports D1 D2
> [    0.181767] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot
> [    0.181771] pci 0000:03:01.0: PME# disabled
> [    0.181813] pci 0000:00:1e.0: transparent bridge
> [    0.181818] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
> [    0.181835] pci_bus 0000:00: on NUMA node 0
> [    0.181838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.181966] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.182062] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.182112] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
> [    0.188894] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.188988] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.189079] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 *6 7 10 11 12 14 15)
> [    0.189169] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.189259] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.189352] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.189444] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.189536] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.189679] SCSI subsystem initialized
> [    0.189695] libata version 3.00 loaded.
> [    0.189695] usbcore: registered new interface driver usbfs
> [    0.189695] usbcore: registered new interface driver hub
> [    0.189695] usbcore: registered new device driver usb
> [    0.189695] ACPI: WMI: Mapper loaded
> [    0.189695] PCI: Using ACPI for IRQ routing
> [    0.200010] Bluetooth: Core ver 2.15
> [    0.200031] NET: Registered protocol family 31
> [    0.200031] Bluetooth: HCI device and connection manager initialized
> [    0.200031] Bluetooth: HCI socket layer initialized
> [    0.200031] NetLabel: Initializing
> [    0.200031] NetLabel:  domain hash size = 128
> [    0.200032] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.200058] NetLabel:  unlabeled traffic allowed by default
> [    0.200099] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    0.200107] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    0.216012] pnp: PnP ACPI init
> [    0.216027] ACPI: bus type pnp registered
> [    0.219444] pnp: PnP ACPI: found 18 devices
> [    0.219446] ACPI: ACPI bus type pnp unregistered
> [    0.219449] PnPBIOS: Disabled by ACPI PNP
> [    0.219458] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [    0.219465] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
> [    0.219467] system 00:07: ioport range 0x800-0x87f has been reserved
> [    0.219469] system 00:07: ioport range 0x480-0x4bf has been reserved
> [    0.219472] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.219474] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.219476] system 00:07: iomem range 0xfed45000-0xfed89fff has been reserved
> [    0.219481] system 00:0a: iomem range 0xffc00000-0xfff7ffff has been reserved
> [    0.219486] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
> [    0.219488] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.219493] system 00:0e: ioport range 0xa00-0xadf has been reserved
> [    0.219495] system 00:0e: ioport range 0xae0-0xaef has been reserved
> [    0.219500] system 00:10: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.219504] system 00:11: iomem range 0x0-0x9ffff could not be reserved
> [    0.219507] system 00:11: iomem range 0xc0000-0xcffff could not be reserved
> [    0.219509] system 00:11: iomem range 0xe0000-0xfffff could not be reserved
> [    0.219511] system 00:11: iomem range 0x100000-0xbf6fffff could not be reserved
> [    0.254131] AppArmor: AppArmor Filesystem Enabled
> [    0.254161] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
> [    0.254163] pci 0000:00:1c.0:   IO window: disabled
> [    0.254167] pci 0000:00:1c.0:   MEM window: disabled
> [    0.254170] pci 0000:00:1c.0:   PREFETCH window: disabled
> [    0.254174] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
> [    0.254176] pci 0000:00:1c.1:   IO window: 0xe000-0xefff
> [    0.254181] pci 0000:00:1c.1:   MEM window: 0xfea00000-0xfeafffff
> [    0.254184] pci 0000:00:1c.1:   PREFETCH window: disabled
> [    0.254188] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
> [    0.254189] pci 0000:00:1e.0:   IO window: disabled
> [    0.254194] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
> [    0.254197] pci 0000:00:1e.0:   PREFETCH window: disabled
> [    0.254207]   alloc irq_desc for 16 on node -1
> [    0.254209]   alloc kstat_irqs on node -1
> [    0.254213] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.254217] pci 0000:00:1c.0: setting latency timer to 64
> [    0.254223]   alloc irq_desc for 17 on node -1
> [    0.254224]   alloc kstat_irqs on node -1
> [    0.254227] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> [    0.254230] pci 0000:00:1c.1: setting latency timer to 64
> [    0.254235] pci 0000:00:1e.0: setting latency timer to 64
> [    0.254239] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.254241] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> [    0.254243] pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
> [    0.254245] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
> [    0.254248] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
> [    0.254250] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
> [    0.254252] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffff]
> [    0.254279] NET: Registered protocol family 2
> [    0.254357] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.254609] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.255146] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.255388] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.255390] TCP reno registered
> [    0.255450] NET: Registered protocol family 1
> [    0.255499] Trying to unpack rootfs image as initramfs...
> [    0.408228] Freeing initrd memory: 7465k freed
> [    0.411831] cpufreq-nforce2: No nForce2 chipset.
> [    0.411855] Scanning for low memory corruption every 60 seconds
> [    0.411946] audit: initializing netlink socket (disabled)
> [    0.411962] type=2000 audit(1269640973.407:1): initialized
> [    0.418920] highmem bounce pool size: 64 pages
> [    0.418924] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    0.420085] VFS: Disk quotas dquot_6.5.2
> [    0.420134] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    0.420566] fuse init (API version 7.12)
> [    0.420635] msgmni has been set to 1679
> [    0.420808] alg: No test for stdrng (krng)
> [    0.420819] io scheduler noop registered
> [    0.420821] io scheduler anticipatory registered
> [    0.420822] io scheduler deadline registered
> [    0.420855] io scheduler cfq registered (default)
> [    0.420866] pci 0000:00:02.0: Boot video device
> [    0.421033]   alloc irq_desc for 24 on node -1
> [    0.421035]   alloc kstat_irqs on node -1
> [    0.421045] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
> [    0.421052] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    0.421150]   alloc irq_desc for 25 on node -1
> [    0.421152]   alloc kstat_irqs on node -1
> [    0.421158] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
> [    0.421164] pcieport-driver 0000:00:1c.1: setting latency timer to 64
> [    0.421237] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.421255] Firmware did not grant requested _OSC control
> [    0.421270] Firmware did not grant requested _OSC control
> [    0.421295] Firmware did not grant requested _OSC control
> [    0.421305] Firmware did not grant requested _OSC control
> [    0.421317] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.421428] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.421431] ACPI: Power Button [PWRF]
> [    0.421478] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.421480] ACPI: Power Button [PWRB]
> [    0.422037] ACPI: SSDT bf6b00f0 00277 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
> [    0.422277] processor LNXCPU:00: registered as cooling_device0
> [    0.422618] ACPI: SSDT bf6b0370 00277 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
> [    0.422844] processor LNXCPU:01: registered as cooling_device1
> [    0.425133] isapnp: Scanning for PnP cards...
> [    0.501540] Switched to high resolution mode on CPU 1
> [    0.504001] Switched to high resolution mode on CPU 0
> [    0.777933] isapnp: No Plug & Play device found
> [    0.778790] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.778885] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.779160] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.780077] brd: module loaded
> [    0.780431] loop: module loaded
> [    0.780483] input: Macintosh mouse button emulation as /devices/virtual/input/input2
> [    0.780566] ata_piix 0000:00:1f.1: version 2.13
> [    0.780576]   alloc irq_desc for 18 on node -1
> [    0.780577]   alloc kstat_irqs on node -1
> [    0.780582] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [    0.780612] ata_piix 0000:00:1f.1: setting latency timer to 64
> [    0.780667] scsi0 : ata_piix
> [    0.780726] scsi1 : ata_piix
> [    0.781668] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [    0.781671] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [    0.781688]   alloc irq_desc for 19 on node -1
> [    0.781690]   alloc kstat_irqs on node -1
> [    0.781694] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    0.781699] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [    0.781733] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    0.781772] scsi2 : ata_piix
> [    0.781904] scsi3 : ata_piix
> [    0.783074] ata3: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xc800 irq 19
> [    0.783076] ata4: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc808 irq 19
> [    0.783725] Fixed MDIO Bus: probed
> [    0.783751] PPP generic driver version 2.4.2
> [    0.783814] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.783828]   alloc irq_desc for 23 on node -1
> [    0.783830]   alloc kstat_irqs on node -1
> [    0.783833] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    0.783841] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    0.783844] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    0.783866] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    0.783870] ehci_hcd 0000:00:1d.7: using broken periodic workaround
> [    0.787763] ehci_hcd 0000:00:1d.7: debug port 1
> [    0.787769] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    0.787779] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe977c00
> [    0.800011] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    0.800124] usb usb1: configuration #1 chosen from 1 choice
> [    0.800164] hub 1-0:1.0: USB hub found
> [    0.800170] hub 1-0:1.0: 8 ports detected
> [    0.800220] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.800231] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.800250] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    0.800255] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    0.800258] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    0.800279] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    0.800298] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d880
> [    0.800360] usb usb2: configuration #1 chosen from 1 choice
> [    0.800379] hub 2-0:1.0: USB hub found
> [    0.800384] hub 2-0:1.0: 2 ports detected
> [    0.800417] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    0.800421] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    0.800424] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    0.800444] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    0.800463] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
> [    0.800520] usb usb3: configuration #1 chosen from 1 choice
> [    0.800539] hub 3-0:1.0: USB hub found
> [    0.800543] hub 3-0:1.0: 2 ports detected
> [    0.800575] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    0.800580] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    0.800582] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    0.800607] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    0.800632] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d480
> [    0.800689] usb usb4: configuration #1 chosen from 1 choice
> [    0.800708] hub 4-0:1.0: USB hub found
> [    0.800713] hub 4-0:1.0: 2 ports detected
> [    0.800744] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
> [    0.800749] uhci_hcd 0000:00:1d.3: setting latency timer to 64
> [    0.800751] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    0.800771] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
> [    0.800796] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d400
> [    0.800858] usb usb5: configuration #1 chosen from 1 choice
> [    0.800877] hub 5-0:1.0: USB hub found
> [    0.800882] hub 5-0:1.0: 2 ports detected
> [    0.800960] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    0.802940] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.802944] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.802993] mice: PS/2 mouse device common for all mice
> [    0.803072] rtc_cmos 00:03: RTC can wake from S4
> [    0.803098] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    0.803119] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.803197] device-mapper: uevent: version 1.0.3
> [    0.803283] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> [    0.803332] device-mapper: multipath: version 1.1.0 loaded
> [    0.803334] device-mapper: multipath round-robin: version 1.0.0 loaded
> [    0.803415] EISA: Probing bus 0 at eisa.0
> [    0.803438] EISA: Detected 0 cards.
> [    0.803496] cpuidle: using governor ladder
> [    0.803498] cpuidle: using governor menu
> [    0.803880] TCP cubic registered
> [    0.803997] NET: Registered protocol family 10
> [    0.804351] lo: Disabled Privacy Extensions
> [    0.804614] NET: Registered protocol family 17
> [    0.804629] Bluetooth: L2CAP ver 2.13
> [    0.804630] Bluetooth: L2CAP socket layer initialized
> [    0.804632] Bluetooth: SCO (Voice Link) ver 0.6
> [    0.804634] Bluetooth: SCO socket layer initialized
> [    0.804655] Bluetooth: RFCOMM TTY layer initialized
> [    0.804661] Bluetooth: RFCOMM socket layer initialized
> [    0.804662] Bluetooth: RFCOMM ver 1.11
> [    0.805098] Using IPI No-Shortcut mode
> [    0.805143] PM: Resume from disk failed.
> [    0.805153] registered taskstats version 1
> [    0.805237]   Magic number: 2:232:48
> [    0.805291] rtc_cmos 00:03: setting system clock to 2010-03-26 22:02:54 UTC (1269640974)
> [    0.805294] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.805295] EDD information not available.
> [    0.816516] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    0.946862] ata4.01: NODEV after polling detection
> [    0.952334] ata4.00: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.02, max UDMA/100
> [    0.960210] ata3.00: ATA-8: WDC WD3200AAJS-65M0A0, 01.03E01, max UDMA/133
> [    0.960212] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    0.960432] ata3.01: ATA-8: ST3500418AS, CC35, max UDMA/133
> [    0.960437] ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    0.968342] ata4.00: configured for UDMA/100
> [    0.976221] ata3.00: configured for UDMA/133
> [    0.992399] ata3.01: configured for UDMA/133
> [    0.992552] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAJS-6 01.0 PQ: 0 ANSI: 5
> [    0.992638] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [    0.992692] scsi 2:0:1:0: Direct-Access     ATA      ST3500418AS      CC35 PQ: 0 ANSI: 5
> [    0.992761] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [    0.992789] sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
> [    0.992823] sd 2:0:0:0: [sda] Write Protect is off
> [    0.992826] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.992843] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.992942]  sda:
> [    0.994279] scsi 3:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.02 PQ: 0 ANSI: 5
> [    0.996536] sr0: scsi3-mmc drive: 125x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> [    0.996540] Uniform CD-ROM driver Revision: 3.20
> [    0.996659] sr 3:0:0:0: Attached scsi CD-ROM sr0
> [    0.996688] sr 3:0:0:0: Attached scsi generic sg2 type 5
> [    1.013873] sd 2:0:1:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    1.013940] sd 2:0:1:0: [sdb] Write Protect is off
> [    1.013944] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.013981] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.014062]  sdb: sda1 sda2 < sdb1 sdb2 < sda5 > sda3
> [    1.068801]  sdb5 >
> [    1.068914] sd 2:0:0:0: [sda] Attached SCSI disk
> [    1.069062] sd 2:0:1:0: [sdb] Attached SCSI disk
> [    1.069077] Freeing unused kernel memory: 540k freed
> [    1.069346] Write protecting the kernel text: 4580k
> [    1.069379] Write protecting the kernel read-only data: 1840k
> [    1.112524] usb 1-5: new high speed USB device using ehci_hcd and address 2
> [    1.155314] Linux agpgart interface v0.103
> [    1.157446] agpgart-intel 0000:00:00.0: Intel G33 Chipset
> [    1.157974] agpgart-intel 0000:00:00.0: detected 7164K stolen memory
> [    1.161043] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [    1.178722] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    1.178741] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.178778] r8169 0000:02:00.0: setting latency timer to 64
> [    1.178835]   alloc irq_desc for 26 on node -1
> [    1.178837]   alloc kstat_irqs on node -1
> [    1.178853] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
> [    1.179365] eth0: RTL8101e at 0xf80bc000, 00:24:21:3e:ee:8c, XID 34300000 IRQ 26
> [    1.229661] [drm] Initialized drm 1.1.0 20060810
> [    1.245135] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.245142] i915 0000:00:02.0: setting latency timer to 64
> [    1.252674]   alloc irq_desc for 27 on node -1
> [    1.252677]   alloc kstat_irqs on node -1
> [    1.252685] i915 0000:00:02.0: irq 27 for MSI/MSI-X
> [    1.253393] usb 1-5: configuration #1 chosen from 1 choice
> [    1.259195] ohci1394 0000:03:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.361458] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 64
> [    1.361462] [drm:edid_is_valid] *ERROR* Raw EDID:
> [    1.361465] <3>00 ff ff ff ff ff ff 00 42 93 18 17 d4 e2 00 00  ........B.......
> [    1.361466] <3>25 0e 01 03 08 22 1b 96 28 67 55 a5 5b 47 9c 25  %...."..(gU.[G.%
> [    1.361468] <3>1e 4f 54 bf ef 00 81 80 01 01 01 01 01 01 01 01  .OT.............
> [    1.361470] <3>01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70  ......0*..Q.*@0p
> [    1.361472] <3>13 00 51 0e 11 00 00 1e 00 00 00 fc 00 4c 43 44  ..Q..........LCD
> [    1.361474] <3>20 31 37 53 0a 20 20 20 60 20 00 00 00 fd 00 3c   17S.   ` .....<
> [    1.361476] <3>4b 1e 50 0e 00 0a 20 20 20 20 20 20 00 00 00 ff  K.P...      ....
> [    1.361477] <3>00 46 49 42 5a 34 39 30 35 38 30 36 38 55 00 9d  .FIBZ49058068U..
> [    1.361479] 
> [    1.361481] i915 0000:00:02.0: VGA-1: EDID invalid.
> [    1.361484] [drm:drm_helper_initial_config] *ERROR* connectors have no modes, using standard modes
> [    1.363504] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[febff000-febff7ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [    1.372979] [drm] fb0: inteldrmfb frame buffer device
> [    1.373031] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [    1.438392] [drm] DAC-6: set mode 800x600 9
> [    1.460038] Console: switching to colour frame buffer device 100x37
> [    1.893442] PM: Starting manual resume from disk
> [    1.893445] PM: Resume from partition 8:21
> [    1.893447] PM: Checking hibernation image.
> [    1.893653] PM: Resume from disk failed.
> [    1.925675] EXT4-fs (sdb1): barriers enabled
> [    1.945444] kjournald2 starting: pid 426, dev sdb1:8, commit interval 5 seconds
> [    1.945513] EXT4-fs (sdb1): delayed allocation enabled
> [    1.945518] EXT4-fs: file extents enabled
> [    1.974410] EXT4-fs: mballoc enabled
> [    1.974422] EXT4-fs (sdb1): mounted filesystem with ordered data mode
> [    2.501011] type=1505 audit(1269640976.194:2): operation="profile_load" pid=451 name=/usr/share/gdm/guest-session/Xsession
> [    2.503580] type=1505 audit(1269640976.194:3): operation="profile_load" pid=452 name=/sbin/dhclient3
> [    2.504176] type=1505 audit(1269640976.194:4): operation="profile_load" pid=452 name=/usr/lib/NetworkManager/nm-dhcp-client.action
> [    2.504487] type=1505 audit(1269640976.194:5): operation="profile_load" pid=452 name=/usr/lib/connman/scripts/dhclient-script
> [    2.544551] type=1505 audit(1269640976.238:6): operation="profile_load" pid=453 name=/usr/bin/evince
> [    2.553822] type=1505 audit(1269640976.246:7): operation="profile_load" pid=453 name=/usr/bin/evince-previewer
> [    2.559245] type=1505 audit(1269640976.250:8): operation="profile_load" pid=453 name=/usr/bin/evince-thumbnailer
> [    2.570227] type=1505 audit(1269640976.263:9): operation="profile_load" pid=455 name=/usr/lib/cups/backend/cups-pdf
> [    2.570900] type=1505 audit(1269640976.263:10): operation="profile_load" pid=455 name=/usr/sbin/cupsd
> [    2.644184] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00004c0100003ffc]
> [   13.747941] udev: starting version 147
> [   13.761875] Adding 4980108k swap on /dev/sdb5.  Priority:-1 extents:1 across:4980108k 
> [   13.786601] parport_pc 00:0f: reported by Plug and Play ACPI
> [   13.786643] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [   13.810228] intel_rng: FWH not detected
> [   13.839486] lp: driver loaded but no devices found
> [   13.868355] lp0: using parport0 (interrupt-driven).
> [   13.892765] ppdev: user-space parallel port driver
> [   13.914629] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   13.922229] Linux video capture interface: v2.00
> [   13.935389] r8169: eth0: link up
> [   13.935396] r8169: eth0: link up
> [   13.940612] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)
> [   13.940981] em28xx #0: chip ID is em2860
> [   13.978236] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   13.978267] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   13.991955] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [   13.991960] sr 3:0:0:0: [sr0] Sense Key : Illegal Request [current] 
> [   13.991964] sr 3:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [   13.991970] end_request: I/O error, dev sr0, sector 0
> [   13.991973] __ratelimit: 12 callbacks suppressed
> [   13.991975] Buffer I/O error on device sr0, logical block 0
> [   13.993366] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [   13.993372] sr 3:0:0:0: [sr0] Sense Key : Illegal Request [current] 
> [   13.993378] sr 3:0:0:0: [sr0] Add. Sense: Illegal mode for this track
> [   13.993386] end_request: I/O error, dev sr0, sector 0
> [   13.993390] Buffer I/O error on device sr0, logical block 0
> [   14.036998] em28xx #0: board has no eeprom
> [   14.046924] hda_codec: Unknown model for ALC888, trying auto-probe from BIOS...
> [   14.047096] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
> [   14.048374] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
> [   14.053726] psmouse serio1: ID: 10 00 64
> [   14.060735] EXT4-fs (sdb1): internal journal on sdb1:8
> [   14.090255] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
> [   14.101020] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
> [   14.101023] em28xx #0: You may try to use card=<n> insmod option to workaround that.
> [   14.101024] em28xx #0: Please send an email with this log to:
> [   14.101026] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
> [   14.101028] em28xx #0: Board eeprom hash is 0x00000000
> [   14.101029] em28xx #0: Board i2c devicelist hash is 0x77800080
> [   14.101031] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
> [   14.101033] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> [   14.101035] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
> [   14.101037] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> [   14.101038] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> [   14.101040] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> [   14.101042] em28xx #0:     card=5 -> MSI VOX USB 2.0
> [   14.101043] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> [   14.101045] em28xx #0:     card=7 -> Leadtek Winfast USB II
> [   14.101047] em28xx #0:     card=8 -> Kworld USB2800
> [   14.101048] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker
> [   14.101051] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> [   14.101052] em28xx #0:     card=11 -> Terratec Hybrid XS
> [   14.101054] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> [   14.101056] em28xx #0:     card=13 -> Terratec Prodigy XS
> [   14.101057] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
> [   14.101059] em28xx #0:     card=15 -> V-Gear PocketTV
> [   14.101061] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> [   14.101063] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
> [   14.101065] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
> [   14.101067] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
> [   14.101068] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
> [   14.101070] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
> [   14.101072] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
> [   14.101074] em28xx #0:     card=23 -> Huaqi DLCW-130
> [   14.101076] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
> [   14.101077] em28xx #0:     card=25 -> Gadmei UTV310
> [   14.101079] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
> [   14.101081] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
> [   14.101083] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
> [   14.101085] em28xx #0:     card=29 -> <NULL>
> [   14.101086] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
> [   14.101088] em28xx #0:     card=31 -> Usbgear VD204v9
> [   14.101090] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
> [   14.101091] em28xx #0:     card=33 -> <NULL>
> [   14.101093] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
> [   14.101095] em28xx #0:     card=35 -> Typhoon DVD Maker
> [   14.101097] em28xx #0:     card=36 -> NetGMBH Cam
> [   14.101098] em28xx #0:     card=37 -> Gadmei UTV330
> [   14.101100] em28xx #0:     card=38 -> Yakumo MovieMixer
> [   14.101101] em28xx #0:     card=39 -> KWorld PVRTV 300U
> [   14.101103] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
> [   14.101105] em28xx #0:     card=41 -> Kworld 350 U DVB-T
> [   14.101107] em28xx #0:     card=42 -> Kworld 355 U DVB-T
> [   14.101108] em28xx #0:     card=43 -> Terratec Cinergy T XS
> [   14.101110] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
> [   14.101112] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
> [   14.101114] em28xx #0:     card=46 -> Compro, VideoMate U3
> [   14.101115] em28xx #0:     card=47 -> KWorld DVB-T 305U
> [   14.101117] em28xx #0:     card=48 -> KWorld DVB-T 310U
> [   14.101119] em28xx #0:     card=49 -> MSI DigiVox A/D
> [   14.101120] em28xx #0:     card=50 -> MSI DigiVox A/D II
> [   14.101122] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
> [   14.101124] em28xx #0:     card=52 -> DNT DA2 Hybrid
> [   14.101125] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
> [   14.101127] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
> [   14.101129] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
> [   14.101131] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
> [   14.101132] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> [   14.101134] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> [   14.101136] em28xx #0:     card=59 -> <NULL>
> [   14.101137] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
> [   14.101139] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
> [   14.101141] em28xx #0:     card=62 -> Gadmei TVR200
> [   14.101143] em28xx #0:     card=63 -> Kaiomy TVnPC U2
> [   14.101144] em28xx #0:     card=64 -> Easy Cap Capture DC-60
> [   14.101146] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
> [   14.101148] em28xx #0:     card=66 -> Empire dual TV
> [   14.101149] em28xx #0:     card=67 -> Terratec Grabby
> [   14.101151] em28xx #0:     card=68 -> Terratec AV350
> [   14.101153] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
> [   14.101154] em28xx #0:     card=70 -> Evga inDtube
> [   14.101156] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
> [   14.101251] em28xx #0: Config register raw data: 0x10
> [   14.124880] em28xx #0: AC97 vendor ID = 0xffffffff
> [   14.139372] em28xx #0: AC97 features = 0x6a90
> [   14.139375] em28xx #0: Empia 202 AC97 audio processor detected
> [   14.561978] em28xx #0: v4l2 driver version 0.1.2
> [   14.587315] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
> [   14.620775] type=1505 audit(1269655388.314:15): operation="profile_replace" pid=1111 name=/usr/share/gdm/guest-session/Xsession
> [   14.622220] type=1505 audit(1269655388.314:16): operation="profile_replace" pid=1112 name=/sbin/dhclient3
> [   14.622795] type=1505 audit(1269655388.314:17): operation="profile_replace" pid=1112 name=/usr/lib/NetworkManager/nm-dhcp-client.action
> [   14.623110] type=1505 audit(1269655388.314:18): operation="profile_replace" pid=1112 name=/usr/lib/connman/scripts/dhclient-script
> [   14.626613] type=1505 audit(1269655388.318:19): operation="profile_replace" pid=1113 name=/usr/bin/evince
> [   14.638779] type=1505 audit(1269655388.330:20): operation="profile_replace" pid=1113 name=/usr/bin/evince-previewer
> [   14.644350] type=1505 audit(1269655388.338:21): operation="profile_replace" pid=1113 name=/usr/bin/evince-thumbnailer
> [   14.653139] type=1505 audit(1269655388.346:22): operation="profile_replace" pid=1120 name=/usr/lib/cups/backend/cups-pdf
> [   14.702788] cdrom: This disc doesn't have any tracks I recognize!
> [   15.416579] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> [   15.416592] em28xx audio device (eb1a:2861): interface 1, class 1
> [   15.416601] em28xx audio device (eb1a:2861): interface 2, class 1
> [   15.416617] usbcore: registered new interface driver em28xx
> [   15.416619] em28xx driver loaded
> [   15.430042] usbcore: registered new interface driver snd-usb-audio
> [   15.713049] [drm:edid_is_valid] *ERROR* EDID checksum is invalid, remainder is 32
> [   15.713053] [drm:edid_is_valid] *ERROR* Raw EDID:
> [   15.713056] <3>00 ff ff ff ff ff ff 00 42 93 18 17 d4 f2 00 00  ........B.......
> [   15.713058] <3>25 0e 01 03 08 22 1b 96 28 67 55 a5 5b 47 9c 25  %...."..(gU.[G.%
> [   15.713060] <3>1e 4f 54 bf ef 00 81 80 01 01 01 01 01 01 01 01  .OT.............
> [   15.713061] <3>01 01 01 01 01 01 30 2a 00 98 51 00 2a 40 30 70  ......0*..Q.*@0p
> [   15.713063] <3>13 00 51 0e 11 00 00 1e 00 00 00 fc 00 4c 43 44  ..Q..........LCD
> [   15.713065] <3>20 31 37 53 0a 20 20 20 20 20 00 00 00 fd 00 3c   17S.     .....<
> [   15.713067] <3>5b 1e 50 0e 00 0a 20 20 20 20 20 20 00 00 00 ff  [.P...      ....
> [   15.713069] <3>00 46 49 42 5a 34 39 30 35 38 30 36 38 55 00 9d  .FIBZ49058068U..
> [   15.713070] 
> [   15.713072] i915 0000:00:02.0: VGA-1: EDID invalid.
> [   15.876786] [drm:edid_is_valid] *ERROR* Raw EDID:
> [   15.876792] <3>10 ff ff ff ff ff ff 00 42 93 18 17 d4 e2 00 00  ........B.......
> [   15.876794] <3>25 0e 01 03 08 22 1b 96 28 67 55 a5 5b 47 9c 2d  %...."..(gU.[G.-
> [   15.876796] <3>1e 4f 54 bf ef 00 81 81 01 01 01 01 01 01 01 01  .OT.............
> [   15.876798] <3>01 01 01 01 11 01 30 2a 00 98 51 00 2a 40 30 70  ......0*..Q.*@0p
> [   15.876799] <3>13 00 51 0e 11 00 00 1e 00 00 00 fc 00 4c 43 44  ..Q..........LCD
> [   15.876801] <3>20 31 37 53 0a 20 20 20 20 20 00 00 00 fd 00 3c   17S.     .....<
> [   15.876803] <3>4b 1e 50 0e 00 0a 20 20 20 20 20 20 00 00 00 ff  K.P...      ....
> [   15.876805] <3>00 46 49 42 5a 34 39 30 35 38 30 36 38 55 00 9d  .FIBZ49058068U..
> [   15.876806] 
> [   15.876809] i915 0000:00:02.0: VGA-1: EDID invalid.
> [   18.230985] CPU0 attaching NULL sched-domain.
> [   18.230990] CPU1 attaching NULL sched-domain.
> [   18.240075] CPU0 attaching sched-domain:
> [   18.240079]  domain 0: span 0-1 level MC
> [   18.240081]   groups: 0 1
> [   18.240085] CPU1 attaching sched-domain:
> [   18.240087]  domain 0: span 0-1 level MC
> [   18.240089]   groups: 1 0
> [   24.440008] eth0: no IPv6 routers present
> dave@systemax1:~$ 
> 

