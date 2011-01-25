Return-path: <mchehab@pedra>
Received: from mail.mattjan.us ([209.160.42.105]:61880 "EHLO mail.mattjan.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1AYCWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 21:22:10 -0500
Received: from [192.168.1.100] (c-76-19-95-158.hsd1.ct.comcast.net [76.19.95.158])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: hello@mattjan.us)
	by mail.mattjan.us (Postfix) with ESMTPSA id 572CE1700E
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 21:11:36 -0500 (EST)
From: Matt Janus <hello@mattjan.us>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: oops cx2341x control handler
Date: Mon, 24 Jan 2011 21:10:38 -0500
Message-Id: <9AA38BEC-4364-4F45-968B-E33BA5098C34@mattjan.us>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A quick test with mplayer didn't error, when i tried to use mythtv the driver crashed and resulted in this:


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36-020636-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #201010210905 SMP Thu Oct 21 10:17:53 UTC 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000009fe88c00 (usable)
[    0.000000]  BIOS-e820: 000000009fe88c00 - 000000009fe8ac00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000009fe8ac00 - 000000009fe8cc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000009fe8cc00 - 00000000a0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x9fe88 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FE0000000 write-back
[    0.000000]   2 base 09FF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000002000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (reserved)
[    0.000000]  modified: 0000000000001000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 00000000000a0000 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000009fe88c00 (usable)
[    0.000000]  modified: 000000009fe88c00 - 000000009fe8ac00 (ACPI NVS)
[    0.000000]  modified: 000000009fe8ac00 - 000000009fe8cc00 (ACPI data)
[    0.000000]  modified: 000000009fe8cc00 - 00000000a0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] found SMP MP-table at [c00fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-0000000026ffe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0026c00000 page 2M
[    0.000000]  0026c00000 - 0026ffe000 page 4k
[    0.000000] kernel direct mapping tables up to 26ffe000 @ 15000-1a000
[    0.000000] RAMDISK: 37584000 - 37ff0000
[    0.000000] Allocated new RAMDISK: 009da000 - 0144528d
[    0.000000] Move RAMDISK from 0000000037584000 - 0000000037fef28c to 009da000 - 0144528c
[    0.000000] ACPI: RSDP 000fec00 00014 (v00 DELL  )
[    0.000000] ACPI: RSDT 000fcc12 00040 (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: FACP 000fcc52 00074 (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: DSDT fffc3358 02DC8 (v01   DELL    dt_ex 00001000 MSFT 0100000D)
[    0.000000] ACPI: FACS 9fe88c00 00040
[    0.000000] ACPI: SSDT fffc6120 000A7 (v01   DELL    st_ex 00001000 MSFT 0100000D)
[    0.000000] ACPI: APIC 000fccc6 00072 (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: BOOT 000fcd38 00028 (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: ASF! 000fcd60 00067 (v16 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: MCFG 000fcdc7 0003E (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: HPET 000fce05 00038 (v01 DELL    4700    00000007 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1934MB HIGHMEM available.
[    0.000000] 623MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 26ffe000
[    0.000000]   low ram: 0 - 26ffe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00026ffe
[    0.000000]   HighMem  0x00026ffe -> 0x0009fe88
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x00000002
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0009fe88
[    0.000000] On node 0 totalpages: 654873
[    0.000000] free_area_init_node: node 0, pgdat c0822bc0, node_mem_map c1447020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3953 pages, LIFO batch:0
[    0.000000]   Normal zone: 1216 pages used for memmap
[    0.000000]   Normal zone: 154430 pages, LIFO batch:31
[    0.000000]   HighMem zone: 3870 pages used for memmap
[    0.000000]   HighMem zone: 491372 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at a0000000 (gap: a0000000:40000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @c2c00000 s32896 r0 d24448 u1048576
[    0.000000] pcpu-alloc: s32896 r0 d24448 u1048576 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 649755
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.36-020636-generic root=UUID=f4d89831-8241-45d3-8866-1f238b2d4f44 ro quiet splash vmalloc=384M
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 13099660 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Subtract (53 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 00009d5824]   TEXT DATA BSS
[    0.000000]   #3 [00009d6000 - 00009d918c]             BRK
[    0.000000]   #4 [00000fe720 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000fe710 - 00000fe720]    MP-table mpf
[    0.000000]   #6 [000009fc00 - 00000f0000]   BIOS reserved
[    0.000000]   #7 [00000f0210 - 00000fe710]   BIOS reserved
[    0.000000]   #8 [00000f0000 - 00000f0210]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #11 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #12 [00009da000 - 0001446000]     NEW RAMDISK
[    0.000000]   #13 [0001446000 - 0001447000]         BOOTMEM
[    0.000000]   #14 [0001447000 - 0002847000]         BOOTMEM
[    0.000000]   #15 [0002847000 - 0002847004]         BOOTMEM
[    0.000000]   #16 [0002847040 - 0002847100]         BOOTMEM
[    0.000000]   #17 [0002847100 - 000284713c]         BOOTMEM
[    0.000000]   #18 [0002847140 - 000284a140]         BOOTMEM
[    0.000000]   #19 [000284a140 - 000284a1f8]         BOOTMEM
[    0.000000]   #20 [000284a200 - 0002850200]         BOOTMEM
[    0.000000]   #21 [0002850200 - 0002850225]         BOOTMEM
[    0.000000]   #22 [0002850240 - 0002850267]         BOOTMEM
[    0.000000]   #23 [0002850280 - 0002850408]         BOOTMEM
[    0.000000]   #24 [0002850440 - 0002850480]         BOOTMEM
[    0.000000]   #25 [0002850480 - 00028504c0]         BOOTMEM
[    0.000000]   #26 [00028504c0 - 0002850500]         BOOTMEM
[    0.000000]   #27 [0002850500 - 0002850540]         BOOTMEM
[    0.000000]   #28 [0002850540 - 0002850580]         BOOTMEM
[    0.000000]   #29 [0002850580 - 00028505c0]         BOOTMEM
[    0.000000]   #30 [00028505c0 - 0002850600]         BOOTMEM
[    0.000000]   #31 [0002850600 - 0002850640]         BOOTMEM
[    0.000000]   #32 [0002850640 - 0002850680]         BOOTMEM
[    0.000000]   #33 [0002850680 - 00028506c0]         BOOTMEM
[    0.000000]   #34 [00028506c0 - 0002850700]         BOOTMEM
[    0.000000]   #35 [0002850700 - 0002850710]         BOOTMEM
[    0.000000]   #36 [0002850740 - 0002850750]         BOOTMEM
[    0.000000]   #37 [0002850780 - 00028507fb]         BOOTMEM
[    0.000000]   #38 [0002850800 - 000285087b]         BOOTMEM
[    0.000000]   #39 [0002c00000 - 0002c0e000]         BOOTMEM
[    0.000000]   #40 [0002d00000 - 0002d0e000]         BOOTMEM
[    0.000000]   #41 [0002e00000 - 0002e0e000]         BOOTMEM
[    0.000000]   #42 [0002f00000 - 0002f0e000]         BOOTMEM
[    0.000000]   #43 [0002852880 - 0002852884]         BOOTMEM
[    0.000000]   #44 [00028528c0 - 00028528c4]         BOOTMEM
[    0.000000]   #45 [0002852900 - 0002852910]         BOOTMEM
[    0.000000]   #46 [0002852940 - 0002852950]         BOOTMEM
[    0.000000]   #47 [0002852980 - 0002852a20]         BOOTMEM
[    0.000000]   #48 [0002852a40 - 0002852a88]         BOOTMEM
[    0.000000]   #49 [0002852ac0 - 0002856ac0]         BOOTMEM
[    0.000000]   #50 [0002856ac0 - 00028d6ac0]         BOOTMEM
[    0.000000]   #51 [00028d6ac0 - 0002916ac0]         BOOTMEM
[    0.000000]   #52 [0002f0e000 - 0003b8c28c]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00026ffe:0009fe88)
[    0.000000] Memory: 2565392k/2619936k available (5000k kernel code, 54100k reserved, 2406k data, 740k init, 1980968k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xe77fe000 - 0xff7fe000   ( 384 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xe6ffe000   ( 623 MB)
[    0.000000]       .init : 0xc083c000 - 0xc08f5000   ( 740 kB)
[    0.000000]       .data : 0xc05e2039 - 0xc083bb28   (2406 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05e2039   (5000 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304 nr_irqs:712
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2793.249 MHz processor.
[    0.004008] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.49 BogoMIPS (lpj=11172996)
[    0.004016] pid_max: default: 32768 minimum: 301
[    0.004044] Security Framework initialized
[    0.004072] AppArmor: AppArmor initialized
[    0.004149] Mount-cache hash table entries: 512
[    0.008095] Initializing cgroup subsys ns
[    0.008101] Initializing cgroup subsys cpuacct
[    0.008109] Initializing cgroup subsys memory
[    0.008123] Initializing cgroup subsys devices
[    0.008127] Initializing cgroup subsys freezer
[    0.008130] Initializing cgroup subsys net_cls
[    0.008182] CPU: Physical Processor ID: 0
[    0.008185] CPU: Processor Core ID: 0
[    0.008190] mce: CPU supports 4 MCE banks
[    0.008205] CPU0: Thermal monitoring enabled (TM1)
[    0.008211] using mwait in idle threads.
[    0.008223] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.008246] ... version:                0
[    0.008249] ... bit width:              40
[    0.008251] ... generic registers:      18
[    0.008254] ... value mask:             000000ffffffffff
[    0.008257] ... max period:             0000007fffffffff
[    0.008260] ... fixed-purpose events:   0
[    0.008262] ... event mask:             000000000003ffff
[    0.013577] ACPI: Core revision 20100702
[    0.045613] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.045621] ftrace: allocating 26011 entries in 51 pages
[    0.048081] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.048417] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.091069] CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 01
[    0.092000] Booting Node   0, Processors  #1
[    0.008000] Initializing CPU#1
[    0.180027] Brought up 2 CPUs
[    0.180033] Total of 2 processors activated (11172.53 BogoMIPS).
[    0.180533] devtmpfs: initialized
[    0.181603] regulator: core version 0.5
[    0.181634] Time:  1:43:12  Date: 01/25/11
[    0.181696] NET: Registered protocol family 16
[    0.181882] EISA bus registered
[    0.181895] ACPI: bus type pci registered
[    0.181993] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.182000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.182003] PCI: Using MMCONFIG for extended config space
[    0.182006] PCI: Using configuration type 1 for base access
[    0.184589] bio: create slab <bio-0> at 0
[    0.184982] ACPI: EC: Look up EC in DSDT
[    0.203190] ACPI: Interpreter enabled
[    0.203199] ACPI: (supports S0 S1 S3 S4 S5)
[    0.203241] ACPI: Using IOAPIC for interrupt routing
[    0.240081] ACPI: No dock devices found.
[    0.240089] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.243093] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.249115] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.249120] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.249125] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.249129] pci_root PNP0A03:00: host bridge window [mem 0x9ff00000-0xdfffffff] (ignored)
[    0.249133] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.249261] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.249267] pci 0000:00:01.0: PME# disabled
[    0.249392] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.249397] pci 0000:00:1c.0: PME# disabled
[    0.249479] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.249565] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.249650] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.249735] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.249806] pci 0000:00:1d.7: reg 10: [mem 0xffa80800-0xffa80bff]
[    0.249891] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.249898] pci 0000:00:1d.7: PME# disabled
[    0.250003] pci 0000:00:1e.2: reg 10: [io  0xec00-0xecff]
[    0.250015] pci 0000:00:1e.2: reg 14: [io  0xe8c0-0xe8ff]
[    0.250027] pci 0000:00:1e.2: reg 18: [mem 0xdffffe00-0xdfffffff]
[    0.250039] pci 0000:00:1e.2: reg 1c: [mem 0xdffffd00-0xdffffdff]
[    0.250084] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.250089] pci 0000:00:1e.2: PME# disabled
[    0.250199] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.250205] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.250211] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0c00-0c7f
[    0.250216] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 00e0-00ef
[    0.250249] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.250262] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.250274] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.250286] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.250299] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.250357] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.250369] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.250380] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.250391] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.250402] pci 0000:00:1f.2: reg 20: [io  0xfea0-0xfeaf]
[    0.250440] pci 0000:00:1f.2: PME# supported from D3hot
[    0.250445] pci 0000:00:1f.2: PME# disabled
[    0.250521] pci 0000:00:1f.3: reg 20: [io  0xe8a0-0xe8bf]
[    0.250632] pci 0000:01:00.0: reg 10: [mem 0xc8000000-0xcfffffff pref]
[    0.250644] pci 0000:01:00.0: reg 14: [io  0xdc00-0xdcff]
[    0.250655] pci 0000:01:00.0: reg 18: [mem 0xdfde0000-0xdfdeffff]
[    0.250689] pci 0000:01:00.0: reg 30: [mem 0xdfe00000-0xdfe1ffff pref]
[    0.250715] pci 0000:01:00.0: supports D1 D2
[    0.250752] pci 0000:01:00.1: reg 10: [mem 0xdfdf0000-0xdfdfffff]
[    0.250820] pci 0000:01:00.1: supports D1 D2
[    0.250840] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.250854] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.250861] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.250867] pci 0000:00:01.0:   bridge window [mem 0xdfd00000-0xdfefffff]
[    0.250872] pci 0000:00:01.0:   bridge window [mem 0xc8000000-0xcfffffff pref]
[    0.250926] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.250932] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.250938] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    0.250947] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.251012] pci 0000:03:00.0: reg 10: [mem 0xd4000000-0xd7ffffff]
[    0.251143] pci 0000:03:01.0: reg 10: [mem 0xd8000000-0xdbffffff]
[    0.251277] pci 0000:03:08.0: reg 10: [mem 0xdfbff000-0xdfbfffff]
[    0.251290] pci 0000:03:08.0: reg 14: [io  0xccc0-0xccff]
[    0.251362] pci 0000:03:08.0: supports D1 D2
[    0.251365] pci 0000:03:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.251371] pci 0000:03:08.0: PME# disabled
[    0.251416] pci 0000:00:1e.0: PCI bridge to [bus 03-03] (subtractive decode)
[    0.251423] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.251430] pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xdfbfffff]
[    0.251438] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.251442] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.251446] pci 0000:00:1e.0:   bridge window [mem 0x00000000-0xffffffff] (subtractive decode)
[    0.251465] pci_bus 0000:00: on NUMA node 0
[    0.251472] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.251870] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.252374] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.252630] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.524101] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    0.524462] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.524818] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.525171] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.525526] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.525881] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.526236] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.526589] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    0.526702] HEST: Table is not found!
[    0.526827] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.526835] vgaarb: loaded
[    0.527096] SCSI subsystem initialized
[    0.527118] libata version 3.00 loaded.
[    0.527118] usbcore: registered new interface driver usbfs
[    0.527118] usbcore: registered new interface driver hub
[    0.527118] usbcore: registered new device driver usb
[    0.527118] ACPI: WMI: Mapper loaded
[    0.527118] PCI: Using ACPI for IRQ routing
[    0.527118] PCI: pci_cache_line_size set to 64 bytes
[    0.527118] reserve RAM buffer: 0000000000002000 - 000000000000ffff 
[    0.527118] reserve RAM buffer: 000000009fe88c00 - 000000009fffffff 
[    0.527118] NetLabel: Initializing
[    0.527118] NetLabel:  domain hash size = 128
[    0.527118] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.527118] NetLabel:  unlabeled traffic allowed by default
[    0.528016] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.528023] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.528031] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.532032] Switching to clocksource tsc
[    0.543878] AppArmor: AppArmor Filesystem Enabled
[    0.543908] pnp: PnP ACPI init
[    0.543942] ACPI: bus type pnp registered
[    0.548661] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    0.548668] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    0.569150] pnp: PnP ACPI: found 12 devices
[    0.569153] ACPI: ACPI bus type pnp unregistered
[    0.569160] PnPBIOS: Disabled by ACPI PNP
[    0.569178] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    0.569195] system 00:09: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.569201] system 00:09: [mem 0x00100000-0x00ffffff] could not be reserved
[    0.569206] system 00:09: [mem 0x01000000-0x9fe88bff] could not be reserved
[    0.569210] system 00:09: [mem 0x000c0000-0x000fffff] could not be reserved
[    0.569215] system 00:09: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.569220] system 00:09: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.569224] system 00:09: [mem 0xfed20000-0xfed9ffff] has been reserved
[    0.569228] system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.569233] system 00:09: [mem 0xffc00000-0xffffffff] has been reserved
[    0.569243] system 00:0a: [io  0x0100-0x01fe] could not be reserved
[    0.569248] system 00:0a: [io  0x0200-0x0277] has been reserved
[    0.569253] system 00:0a: [io  0x0280-0x02e7] has been reserved
[    0.569257] system 00:0a: [io  0x02e8-0x02ef] has been reserved
[    0.569261] system 00:0a: [io  0x02f0-0x02f7] has been reserved
[    0.569265] system 00:0a: [io  0x02f8-0x02ff] has been reserved
[    0.569269] system 00:0a: [io  0x0300-0x0377] could not be reserved
[    0.569274] system 00:0a: [io  0x0380-0x03bb] has been reserved
[    0.569278] system 00:0a: [io  0x03c0-0x03e7] could not be reserved
[    0.569282] system 00:0a: [io  0x03f6-0x03f7] could not be reserved
[    0.569287] system 00:0a: [io  0x0400-0x04cf] has been reserved
[    0.569291] system 00:0a: [io  0x04d2-0x057f] has been reserved
[    0.569295] system 00:0a: [io  0x0580-0x0677] has been reserved
[    0.569299] system 00:0a: [io  0x0680-0x0777] has been reserved
[    0.569303] system 00:0a: [io  0x0780-0x07bb] has been reserved
[    0.569307] system 00:0a: [io  0x07c0-0x07ff] has been reserved
[    0.569312] system 00:0a: [io  0x08e0-0x08ff] has been reserved
[    0.569316] system 00:0a: [io  0x0900-0x09fe] has been reserved
[    0.569320] system 00:0a: [io  0x0a00-0x0afe] has been reserved
[    0.569324] system 00:0a: [io  0x0b00-0x0bfe] has been reserved
[    0.569329] system 00:0a: [io  0x0c80-0x0caf] has been reserved
[    0.569333] system 00:0a: [io  0x0cb0-0x0cbf] has been reserved
[    0.569337] system 00:0a: [io  0x0cc0-0x0cf7] has been reserved
[    0.569341] system 00:0a: [io  0x0d00-0x0dfe] has been reserved
[    0.569346] system 00:0a: [io  0x0e00-0x0efe] has been reserved
[    0.569350] system 00:0a: [io  0x0f00-0x0ffe] has been reserved
[    0.569354] system 00:0a: [io  0x2000-0x20fe] has been reserved
[    0.569359] system 00:0a: [io  0x2100-0x21fe] has been reserved
[    0.569363] system 00:0a: [io  0x2200-0x22fe] has been reserved
[    0.569367] system 00:0a: [io  0x2300-0x23fe] has been reserved
[    0.569372] system 00:0a: [io  0x2400-0x24fe] has been reserved
[    0.569376] system 00:0a: [io  0x2500-0x25fe] has been reserved
[    0.569380] system 00:0a: [io  0x2600-0x26fe] has been reserved
[    0.569385] system 00:0a: [io  0x2700-0x27fe] has been reserved
[    0.569389] system 00:0a: [io  0x2800-0x28fe] has been reserved
[    0.569394] system 00:0a: [io  0x2900-0x29fe] has been reserved
[    0.569398] system 00:0a: [io  0x2a00-0x2afe] has been reserved
[    0.569402] system 00:0a: [io  0x2b00-0x2bfe] has been reserved
[    0.569407] system 00:0a: [io  0x2c00-0x2cfe] has been reserved
[    0.569411] system 00:0a: [io  0x2d00-0x2dfe] has been reserved
[    0.569416] system 00:0a: [io  0x2e00-0x2efe] has been reserved
[    0.569420] system 00:0a: [io  0x2f00-0x2ffe] has been reserved
[    0.569424] system 00:0a: [io  0x5000-0x50fe] has been reserved
[    0.569432] system 00:0a: [io  0x5100-0x51fe] has been reserved
[    0.569437] system 00:0a: [io  0x5200-0x52fe] has been reserved
[    0.569441] system 00:0a: [io  0x5300-0x53fe] has been reserved
[    0.569446] system 00:0a: [io  0x5400-0x54fe] has been reserved
[    0.569450] system 00:0a: [io  0x5500-0x55fe] has been reserved
[    0.569455] system 00:0a: [io  0x5600-0x56fe] has been reserved
[    0.569459] system 00:0a: [io  0x5700-0x57fe] has been reserved
[    0.569464] system 00:0a: [io  0x5800-0x58fe] has been reserved
[    0.569468] system 00:0a: [io  0x5900-0x59fe] has been reserved
[    0.569473] system 00:0a: [io  0x5a00-0x5afe] has been reserved
[    0.569477] system 00:0a: [io  0x5b00-0x5bfe] has been reserved
[    0.569482] system 00:0a: [io  0x5c00-0x5cfe] has been reserved
[    0.569486] system 00:0a: [io  0x5d00-0x5dfe] has been reserved
[    0.569491] system 00:0a: [io  0x5e00-0x5efe] has been reserved
[    0.569496] system 00:0a: [io  0x5f00-0x5ffe] has been reserved
[    0.569500] system 00:0a: [io  0x6000-0x60fe] has been reserved
[    0.569505] system 00:0a: [io  0x6100-0x61fe] has been reserved
[    0.569509] system 00:0a: [io  0x6200-0x62fe] has been reserved
[    0.569514] system 00:0a: [io  0x6300-0x63fe] has been reserved
[    0.569518] system 00:0a: [io  0x6400-0x64fe] has been reserved
[    0.569523] system 00:0a: [io  0x6500-0x65fe] has been reserved
[    0.569528] system 00:0a: [io  0x6600-0x66fe] has been reserved
[    0.569532] system 00:0a: [io  0x6700-0x67fe] has been reserved
[    0.569537] system 00:0a: [io  0x6800-0x68fe] has been reserved
[    0.569542] system 00:0a: [io  0x6900-0x69fe] has been reserved
[    0.569546] system 00:0a: [io  0x6a00-0x6afe] has been reserved
[    0.569551] system 00:0a: [io  0x6b00-0x6bfe] has been reserved
[    0.569556] system 00:0a: [io  0x6c00-0x6cfe] has been reserved
[    0.569560] system 00:0a: [io  0x6d00-0x6dfe] has been reserved
[    0.569565] system 00:0a: [io  0x6e00-0x6efe] has been reserved
[    0.569570] system 00:0a: [io  0x6f00-0x6ffe] has been reserved
[    0.569575] system 00:0a: [io  0xa000-0xa0fe] has been reserved
[    0.569580] system 00:0a: [io  0xa100-0xa1fe] has been reserved
[    0.569585] system 00:0a: [io  0xa200-0xa2fe] has been reserved
[    0.569589] system 00:0a: [io  0xa300-0xa3fe] has been reserved
[    0.569594] system 00:0a: [io  0xa400-0xa4fe] has been reserved
[    0.569599] system 00:0a: [io  0xa500-0xa5fe] has been reserved
[    0.569604] system 00:0a: [io  0xa600-0xa6fe] has been reserved
[    0.569609] system 00:0a: [io  0xa700-0xa7fe] has been reserved
[    0.569614] system 00:0a: [io  0xa800-0xa8fe] has been reserved
[    0.569618] system 00:0a: [io  0xa900-0xa9fe] has been reserved
[    0.569623] system 00:0a: [io  0xaa00-0xaafe] has been reserved
[    0.569628] system 00:0a: [io  0xab00-0xabfe] has been reserved
[    0.569637] system 00:0a: [io  0xac00-0xacfe] has been reserved
[    0.569643] system 00:0a: [io  0xad00-0xadfe] has been reserved
[    0.569648] system 00:0a: [io  0xae00-0xaefe] has been reserved
[    0.569654] system 00:0a: [io  0xaf00-0xaffe] has been reserved
[    0.569659] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.569663] system 00:0a: [mem 0xfeda0000-0xfedacfff] has been reserved
[    0.607019] pci 0000:00:1c.0: BAR 15: assigned [mem 0xa0000000-0xa01fffff 64bit pref]
[    0.607026] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.607031] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.607036] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.607042] pci 0000:00:01.0:   bridge window [mem 0xdfd00000-0xdfefffff]
[    0.607047] pci 0000:00:01.0:   bridge window [mem 0xc8000000-0xcfffffff pref]
[    0.607054] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.607059] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.607066] pci 0000:00:1c.0:   bridge window [mem 0xdfc00000-0xdfcfffff]
[    0.607072] pci 0000:00:1c.0:   bridge window [mem 0xa0000000-0xa01fffff 64bit pref]
[    0.607081] pci 0000:00:1e.0: PCI bridge to [bus 03-03]
[    0.607085] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    0.607092] pci 0000:00:1e.0:   bridge window [mem 0xd4000000-0xdfbfffff]
[    0.607098] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.607117]   alloc irq_desc for 16 on node -1
[    0.607120]   alloc kstat_irqs on node -1
[    0.607130] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.607136] pci 0000:00:01.0: setting latency timer to 64
[    0.607149] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.607155] pci 0000:00:1c.0: setting latency timer to 64
[    0.607164] pci 0000:00:1e.0: setting latency timer to 64
[    0.607170] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.607174] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.607178] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.607182] pci_bus 0000:01: resource 1 [mem 0xdfd00000-0xdfefffff]
[    0.607186] pci_bus 0000:01: resource 2 [mem 0xc8000000-0xcfffffff pref]
[    0.607190] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.607193] pci_bus 0000:02: resource 1 [mem 0xdfc00000-0xdfcfffff]
[    0.607197] pci_bus 0000:02: resource 2 [mem 0xa0000000-0xa01fffff 64bit pref]
[    0.607201] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.607205] pci_bus 0000:03: resource 1 [mem 0xd4000000-0xdfbfffff]
[    0.607209] pci_bus 0000:03: resource 4 [io  0x0000-0xffff]
[    0.607212] pci_bus 0000:03: resource 5 [mem 0x00000000-0xffffffff]
[    0.607271] NET: Registered protocol family 2
[    0.607383] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.607794] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.608542] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.609022] TCP: Hash tables configured (established 131072 bind 65536)
[    0.609026] TCP reno registered
[    0.609031] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.609049] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.609240] NET: Registered protocol family 1
[    0.609400] pci 0000:01:00.0: Boot video device
[    0.609430] pci 0000:03:08.0: Firmware left e100 interrupts enabled; disabling
[    0.609440] PCI: CLS 64 bytes, default 64
[    0.609534] Trying to unpack rootfs image as initramfs...
[    1.016404] Freeing initrd memory: 10672k freed
[    1.025890] Simple Boot Flag value 0x87 read from CMOS RAM was invalid
[    1.025895] Simple Boot Flag at 0x7a set to 0x1
[    1.026162] cpufreq-nforce2: No nForce2 chipset.
[    1.026212] Scanning for low memory corruption every 60 seconds
[    1.026443] audit: initializing netlink socket (disabled)
[    1.026462] type=2000 audit(1295919792.024:1): initialized
[    1.039168] highmem bounce pool size: 64 pages
[    1.039178] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.041379] VFS: Disk quotas dquot_6.5.2
[    1.041477] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.042424] fuse init (API version 7.15)
[    1.042567] msgmni has been set to 1162
[    1.042942] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.042947] io scheduler noop registered
[    1.042950] io scheduler deadline registered
[    1.042971] io scheduler cfq registered (default)
[    1.043221] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.043259] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.043569] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.043579] ACPI: Power Button [VBTN]
[    1.043667] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.043672] ACPI: Power Button [PWRF]
[    1.044103] ACPI: acpi_idle registered with cpuidle
[    1.071941] ERST: Table is not found!
[    1.071967] isapnp: Scanning for PnP cards...
[    1.425117] isapnp: No Plug & Play device found
[    1.425422] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.445848] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.466673] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.468632] brd: module loaded
[    1.469525] loop: module loaded
[    1.469814] ata_piix 0000:00:1f.1: version 2.13
[    1.469833] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.469895] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.470027] scsi0 : ata_piix
[    1.470170] scsi1 : ata_piix
[    1.470241] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.470246] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.470285]   alloc irq_desc for 20 on node -1
[    1.470290]   alloc kstat_irqs on node -1
[    1.470303] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    1.470315] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.470467] ata2: port disabled. ignoring.
[    1.624045] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.624184] scsi2 : ata_piix
[    1.624314] scsi3 : ata_piix
[    1.624387] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[    1.624391] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[    1.624993] Fixed MDIO Bus: probed
[    1.625050] PPP generic driver version 2.4.2
[    1.625123] tun: Universal TUN/TAP device driver, 1.6
[    1.625127] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.625273] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.625301]   alloc irq_desc for 21 on node -1
[    1.625304]   alloc kstat_irqs on node -1
[    1.625314] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.625336] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.625342] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.625399] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.625437] ehci_hcd 0000:00:1d.7: debug port 1
[    1.629336] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.629359] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    1.633540] ata1.00: ATAPI: HL-DT-STDVD-ROM GDR8163B, 0D20, max UDMA/33
[    1.644017] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.644207] hub 1-0:1.0: USB hub found
[    1.644216] hub 1-0:1.0: 8 ports detected
[    1.644360] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.644387] uhci_hcd: USB Universal Host Controller Interface driver
[    1.644431] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    1.644444] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.644449] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.644504] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.644538] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    1.644720] hub 2-0:1.0: USB hub found
[    1.644728] hub 2-0:1.0: 2 ports detected
[    1.644822]   alloc irq_desc for 22 on node -1
[    1.644826]   alloc kstat_irqs on node -1
[    1.644835] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    1.644845] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.644850] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.644909] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.644952] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    1.645129] hub 3-0:1.0: USB hub found
[    1.645137] hub 3-0:1.0: 2 ports detected
[    1.645230]   alloc irq_desc for 18 on node -1
[    1.645234]   alloc kstat_irqs on node -1
[    1.645241] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.645250] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.645255] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.645309] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.645348] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    1.645531] hub 4-0:1.0: USB hub found
[    1.645538] hub 4-0:1.0: 2 ports detected
[    1.645630]   alloc irq_desc for 23 on node -1
[    1.645634]   alloc kstat_irqs on node -1
[    1.645641] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.645650] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.645655] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.645718] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.645757] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    1.645948] hub 5-0:1.0: USB hub found
[    1.645955] hub 5-0:1.0: 2 ports detected
[    1.646152] PNP: PS/2 Controller [PNP0303:KBD] at 0x60,0x64 irq 1
[    1.646156] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.646917] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.647048] mice: PS/2 mouse device common for all mice
[    1.647240] rtc_cmos 00:05: RTC can wake from S4
[    1.647303] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.647336] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    1.647501] device-mapper: uevent: version 1.0.3
[    1.647691] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) initialised: dm-devel@redhat.com
[    1.647781] device-mapper: multipath: version 1.1.1 loaded
[    1.647788] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.647981] EISA: Probing bus 0 at eisa.0
[    1.647986] EISA: Cannot allocate resource for mainboard
[    1.647990] Cannot allocate resource for EISA slot 1
[    1.647993] Cannot allocate resource for EISA slot 2
[    1.648023] Cannot allocate resource for EISA slot 5
[    1.648029] Cannot allocate resource for EISA slot 6
[    1.648046] EISA: Detected 0 cards.
[    1.648144] cpuidle: using governor ladder
[    1.648148] cpuidle: using governor menu
[    1.648228] ata1.00: configured for UDMA/33
[    1.648714] TCP cubic registered
[    1.649002] NET: Registered protocol family 10
[    1.649632] lo: Disabled Privacy Extensions
[    1.650098] NET: Registered protocol family 17
[    1.650127] Registering the dns_resolver key type
[    1.650196] Using IPI No-Shortcut mode
[    1.650341] PM: Resume from disk failed.
[    1.650358] registered taskstats version 1
[    1.650749]   Magic number: 11:633:711
[    1.650842] rtc_cmos 00:05: setting system clock to 2011-01-25 01:43:13 UTC (1295919793)
[    1.650847] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.650850] EDD information not available.
[    1.652193] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8163B 0D20 PQ: 0 ANSI: 5
[    1.659623] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    1.659627] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.659781] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.659869] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.680066] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    1.796343] ata3.00: ATA-8: ST31000528AS, CC38, max UDMA/133
[    1.796349] ata3.00: 1953525168 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    1.812340] ata3.00: configured for UDMA/133
[    1.812504] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC38 PQ: 0 ANSI: 5
[    1.812724] sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.812754] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.812883] sd 2:0:0:0: [sda] Write Protect is off
[    1.812889] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.812956] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.855930]  sda: sda1 sda2 < sda5 >
[    1.856497] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.252021] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    2.672020] usb 3-2: new full speed USB device using uhci_hcd and address 3
[    5.820095] Freeing unused kernel memory: 740k freed
[    5.820824] Write protecting the kernel text: 5004k
[    5.820889] Write protecting the kernel read-only data: 2048k
[    5.849568] udev[71]: starting version 163
[    6.067425] usbcore: registered new interface driver hiddev
[    6.081802] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/input/input3
[    6.082047] generic-usb 0003:046D:C044.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.1-1/input0
[    6.082095] usbcore: registered new interface driver usbhid
[    6.082100] usbhid: USB HID core driver
[    6.098212] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    6.098221] e100: Copyright(c) 1999-2006 Intel Corporation
[    6.098301] e100 0000:03:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.122682] e100 0000:03:08.0: PME# disabled
[    6.133210] e100 0000:03:08.0: eth0: addr 0xdfbff000, irq 20, MAC addr 00:11:11:c1:b0:9d
[    6.233507] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    7.498784] Adding 6384636k swap on /dev/sda5.  Priority:-1 extents:1 across:6384636k 
[    8.204635] udev[257]: starting version 163
[    8.256308] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    9.129782] type=1400 audit(1295919800.976:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=389 comm="apparmor_parser"
[    9.129870] type=1400 audit(1295919800.976:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=389 comm="apparmor_parser"
[    9.129943] type=1400 audit(1295919800.976:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=389 comm="apparmor_parser"
[    9.661407] type=1400 audit(1295919801.508:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=415 comm="apparmor_parser"
[    9.682522] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    9.780831] type=1400 audit(1295919801.628:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=477 comm="apparmor_parser"
[    9.780928] type=1400 audit(1295919801.628:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=477 comm="apparmor_parser"
[    9.781003] type=1400 audit(1295919801.628:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=477 comm="apparmor_parser"
[    9.825102] intel_rng: Firmware space is locked read-only. If you can't or
[    9.825107] intel_rng: don't want to disable this in firmware setup, and if
[    9.825110] intel_rng: you are certain that your system has a functional
[    9.825114] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    9.887471] Linux agpgart interface v0.103
[    9.902954] type=1400 audit(1295919801.748:9): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=489 comm="apparmor_parser"
[    9.941734] lp: driver loaded but no devices found
[    9.961427] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   10.013530] [drm] Initialized drm 1.1.0 20060810
[   10.080756] Linux video capture interface: v2.00
[   10.107669] parport_pc 00:07: reported by Plug and Play ACPI
[   10.107737] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   10.147674] ppdev: user-space parallel port driver
[   10.216303] lp0: using parport0 (interrupt-driven).
[   10.757956] [drm] radeon defaulting to kernel modesetting.
[   10.757965] [drm] radeon kernel modesetting enabled.
[   10.758075] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.758087] radeon 0000:01:00.0: setting latency timer to 64
[   10.760780] [drm] initializing kernel modesetting (RV380 0x1002:0x5B60).
[   10.760917] [drm] register mmio base: 0xDFDE0000
[   10.760922] [drm] register mmio size: 65536
[   10.761149] [drm] Generation 2 PCI interface, using max accessible memory
[   10.761162] radeon 0000:01:00.0: VRAM: 128M 0xC8000000 - 0xCFFFFFFF (128M used)
[   10.761168] radeon 0000:01:00.0: GTT: 512M 0xA8000000 - 0xC7FFFFFF
[   10.761235]   alloc irq_desc for 40 on node -1
[   10.761243]   alloc kstat_irqs on node -1
[   10.761265] radeon 0000:01:00.0: irq 40 for MSI/MSI-X
[   10.761276] radeon 0000:01:00.0: radeon: using MSI.
[   10.761318] [drm] radeon: irq initialized.
[   10.761768] [drm] Detected VRAM RAM=128M, BAR=128M
[   10.761774] [drm] RAM width 64bits DDR
[   10.761916] [TTM] Zone  kernel: Available graphics memory: 297918 kiB.
[   10.761921] [TTM] Zone highmem: Available graphics memory: 1288402 kiB.
[   10.761926] [TTM] Initializing pool allocator.
[   10.761973] [drm] radeon: 128M of VRAM memory ready
[   10.761978] [drm] radeon: 512M of GTT memory ready.
[   10.762017] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   10.763366] [drm] radeon: 1 quad pipes, 1 Z pipes initialized.
[   10.765112] [drm] PCIE GART of 512M enabled (table at 0xC8040000).
[   10.765441] [drm] Loading R300 Microcode
[   11.094236] cx18:  Start initialization, version 1.4.0
[   11.094567] cx18-0: Initializing card 0
[   11.094575] cx18-0:  info: Stream type 0 options: 2 MB, 64 buffers, 32768 bytes
[   11.094581] cx18-0:  info: Stream type 1 options: 1 MB, 32 buffers, 32768 bytes
[   11.094588] cx18-0:  info: Stream type 2 options: 2 MB, 20 buffers, 103680 bytes
[   11.094593] cx18-0:  info: Stream type 3 options: 1 MB, 20 buffers, 51984 bytes
[   11.094599] cx18-0:  info: Stream type 4 options: 1 MB, 256 buffers, 4096 bytes
[   11.094605] cx18-0:  info: Stream type 5 options: 0 MB, 63 buffers, 1536 bytes
[   11.094610] cx18-0: Autodetected Hauppauge card
[   11.094884] cx18-0:  info: base addr: 0xd4000000
[   11.094889] cx18-0:  info: Enabling pci device
[   11.094915] cx18 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.094933] cx18-0:  info: cx23418 (rev 0) at 03:00.0, irq: 16, latency: 64, memory: 0xd4000000
[   11.094936] cx18-0:  info: attempting ioremap at 0xd4000000 len 0x04000000
[   11.098544] CIFS VFS: Error connecting to socket. Aborting operation
[   11.098609] CIFS VFS: cifs_mount failed w/return code = -101
[   11.113568] cx18-0: cx23418 revision 01010000 (B)
[   11.120927] CIFS VFS: Error connecting to socket. Aborting operation
[   11.120999] CIFS VFS: cifs_mount failed w/return code = -101
[   11.216472] [drm] radeon: ring at 0x00000000A8000000
[   11.216502] [drm] ring test succeeded in 0 usecs
[   11.216915] [drm] radeon: ib pool ready.
[   11.217053] [drm] ib test succeeded in 0 usecs
[   11.221386] [drm] Radeon Display Connectors
[   11.221393] [drm] Connector 0:
[   11.221396] [drm]   VGA
[   11.221402] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   11.221406] [drm]   Encoders:
[   11.221410] [drm]     CRT1: INTERNAL_DAC1
[   11.221414] [drm] Connector 1:
[   11.221418] [drm]   DVI-I
[   11.221421] [drm]   HPD1
[   11.221426] [drm]   DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
[   11.221430] [drm]   Encoders:
[   11.221434] [drm]     CRT2: INTERNAL_DAC2
[   11.221438] [drm]     DFP1: INTERNAL_TMDS1
[   11.221443] [drm] Connector 2:
[   11.221447] [drm]   S-video
[   11.221451] [drm]   Encoders:
[   11.221455] [drm]     TV1: INTERNAL_DAC2
[   11.223516] cx18-0:  info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000
[   11.223560] cx18-0:  info: activating i2c...
[   11.223564] cx18-0:  i2c: i2c init
[   11.225375] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   11.228145] e100 0000:03:08.0: eth0: NIC Link is Up 100 Mbps Full Duplex
[   11.272613] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   11.348423] tveeprom 4-0050: Hauppauge model 74041, rev C6G8, serial# 7249482
[   11.348431] tveeprom 4-0050: MAC address is 00:0d:fe:6e:9e:4a
[   11.348436] tveeprom 4-0050: tuner model is TCL M30WTP-4N-E (idx 168, type 85)
[   11.348443] tveeprom 4-0050: TV standards NTSC(M) (eeprom 0x08)
[   11.348448] tveeprom 4-0050: audio processor is CX23418 (idx 38)
[   11.348453] tveeprom 4-0050: decoder processor is CX23418 (idx 31)
[   11.348458] tveeprom 4-0050: has no radio, has IR receiver, has IR transmitter
[   11.348463] cx18-0: Autodetected Hauppauge HVR-1600
[   11.348467] cx18-0:  info: NTSC tuner detected
[   11.348471] cx18-0: Simultaneous Digital and Analog TV capture supported
[   11.487592] [drm] fb mappable at 0xC80C0000
[   11.487599] [drm] vram apper at 0xC8000000
[   11.487603] [drm] size 4177920
[   11.487606] [drm] fb depth is 24
[   11.487610] [drm]    pitch is 5440
[   11.524411] usbcore: registered new interface driver snd-usb-audio
[   11.545354] Console: switching to colour frame buffer device 170x48
[   11.550811] fb0: radeondrmfb frame buffer device
[   11.550814] drm: registered panic notifier
[   11.550827] [drm] Initialized radeon 2.6.0 20080528 for 0000:01:00.0 on minor 0
[   11.784984] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   11.785037] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   12.208027] intel8x0_measure_ac97_clock: measured 52313 usecs (2521 samples)
[   12.208033] intel8x0: clocking to 48000
[   12.556035] tda8290_probe: tda8290 couldn't read register 0x1f
[   12.556931] tda8295_probe: tda8290 couldn't read register 0x2f
[   12.559682] tuner 5-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
[   12.585615] tda9887 5-0043: creating new instance
[   12.585623] tda9887 5-0043: tda988[5/6/7] found
[   12.589103] tuner 5-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[   13.323022] cs5345 4-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[   13.477117] tuner-simple 5-0061: creating new instance
[   13.477127] tuner-simple 5-0061: type set to 85 (Philips FQ1236 MK5)
[   13.478984] cx18-0:  info: Allocate encoder MPEG stream: 64 x 32768 buffers (2048.00 kB total)
[   13.479085] cx18-0:  info: Allocate TS stream: 32 x 32768 buffers (1024.00 kB total)
[   13.479138] cx18-0:  info: Allocate encoder YUV stream: 20 x 103680 buffers (2025.00 kB total)
[   13.479183] cx18-0:  info: Allocate encoder VBI stream: 20 x 51984 buffers (1015.31 kB total)
[   13.479223] cx18-0:  info: Allocate encoder PCM audio stream: 256 x 4096 buffers (1024.00 kB total)
[   13.479450] cx18-0:  info: Allocate encoder IDX stream: 63 x 1536 buffers (94.50 kB total)
[   13.479626] cx18-0: Registered device video0 for encoder MPEG (64 x 32.00 kB)
[   13.479632] DVB: registering new adapter (cx18)
[   13.796354] cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
[   13.905534] MXL5005S: Attached at address 0x63
[   13.905546] DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[   13.905766] cx18-0: DVB Frontend registered
[   13.905773] cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
[   13.905846] cx18-0: Registered device video32 for encoder YUV (20 x 101.25 kB)
[   13.905914] cx18-0: Registered device vbi0 for encoder VBI (20 x 51984 bytes)
[   13.905981] cx18-0: Registered device video24 for encoder PCM audio (256 x 4.00 kB)
[   13.905988] cx18-0: Initialized card: Hauppauge HVR-1600
[   13.906026] cx18-1: Initializing card 1
[   13.906032] cx18-1:  info: Stream type 0 options: 2 MB, 64 buffers, 32768 bytes
[   13.906038] cx18-1:  info: Stream type 1 options: 1 MB, 32 buffers, 32768 bytes
[   13.906043] cx18-1:  info: Stream type 2 options: 2 MB, 20 buffers, 103680 bytes
[   13.906049] cx18-1:  info: Stream type 3 options: 1 MB, 20 buffers, 51984 bytes
[   13.906054] cx18-1:  info: Stream type 4 options: 1 MB, 256 buffers, 4096 bytes
[   13.906060] cx18-1:  info: Stream type 5 options: 0 MB, 63 buffers, 1536 bytes
[   13.906065] cx18-1: Autodetected Hauppauge card
[   13.906312] cx18-1:  info: base addr: 0xd8000000
[   13.906317] cx18-1:  info: Enabling pci device
[   13.906343]   alloc irq_desc for 17 on node -1
[   13.906349]   alloc kstat_irqs on node -1
[   13.906366] cx18 0000:03:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.906387] cx18-1:  info: cx23418 (rev 0) at 03:01.0, irq: 17, latency: 64, memory: 0xd8000000
[   13.906393] cx18-1:  info: attempting ioremap at 0xd8000000 len 0x04000000
[   13.927270] cx18-1: cx23418 revision 01010000 (B)
[   14.022956] cx18-1:  info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000
[   14.022998] cx18-1:  info: activating i2c...
[   14.023002] cx18-1:  i2c: i2c init
[   14.069991] cx18-0:  info: load segment a00000-a07fff
[   14.094344] cx18-0:  info: load segment ae0000-ae00ff
[   14.094535] cx18-0:  info: load segment b00000-b1a65f
[   14.163476] tveeprom 6-0050: Hauppauge model 74041, rev C6G8, serial# 7318913
[   14.163483] tveeprom 6-0050: MAC address is 00:0d:fe:6f:ad:81
[   14.163488] tveeprom 6-0050: tuner model is TCL M30WTP-4N-E (idx 168, type 85)
[   14.163494] tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
[   14.163500] tveeprom 6-0050: audio processor is CX23418 (idx 38)
[   14.163504] tveeprom 6-0050: decoder processor is CX23418 (idx 31)
[   14.163509] tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
[   14.163514] cx18-1: Autodetected Hauppauge HVR-1600
[   14.163518] cx18-1:  info: NTSC tuner detected
[   14.163522] cx18-1: Simultaneous Digital and Analog TV capture supported
[   14.189618] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
[   14.196018] cx18-0:  info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
[   14.196022] cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
[   14.266235] tda8290_probe: tda8290 couldn't read register 0x1f
[   14.267101] tda8295_probe: tda8290 couldn't read register 0x2f
[   14.269905] tuner 7-0043: chip found @ 0x86 (cx18 i2c driver #1-1)
[   14.270033] tda9887 7-0043: creating new instance
[   14.270037] tda9887 7-0043: tda988[5/6/7] found
[   14.273487] tuner 7-0061: chip found @ 0xc2 (cx18 i2c driver #1-1)
[   14.275711] cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #1-0)
[   14.280317] tuner-simple 7-0061: creating new instance
[   14.280324] tuner-simple 7-0061: type set to 85 (Philips FQ1236 MK5)
[   14.282198] cx18-1:  info: Allocate encoder MPEG stream: 64 x 32768 buffers (2048.00 kB total)
[   14.282294] cx18-1:  info: Allocate TS stream: 32 x 32768 buffers (1024.00 kB total)
[   14.282345] cx18-1:  info: Allocate encoder YUV stream: 20 x 103680 buffers (2025.00 kB total)
[   14.282389] cx18-1:  info: Allocate encoder VBI stream: 20 x 51984 buffers (1015.31 kB total)
[   14.282426] cx18-1:  info: Allocate encoder PCM audio stream: 256 x 4096 buffers (1024.00 kB total)
[   14.282652] cx18-1:  info: Allocate encoder IDX stream: 63 x 1536 buffers (94.50 kB total)
[   14.282928] cx18-1: Registered device video1 for encoder MPEG (64 x 32.00 kB)
[   14.282933] DVB: registering new adapter (cx18)
[   14.334127] MXL5005S: Attached at address 0x63
[   14.334136] DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[   14.334439] cx18-1: DVB Frontend registered
[   14.334447] cx18-1: Registered DVB adapter1 for TS (32 x 32.00 kB)
[   14.334605] cx18-1: Registered device video33 for encoder YUV (20 x 101.25 kB)
[   14.334748] cx18-1: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
[   14.334810] cx18-1: Registered device video25 for encoder PCM audio (256 x 4.00 kB)
[   14.334817] cx18-1: Initialized card: Hauppauge HVR-1600
[   14.336443] cx18:  End initialization
[   14.400032] cx18-0:  api: CX18_CPU_DEBUG_PEEK32	cmd 0x20000003 args 0x00000000
[   14.400125] cx18-0:  api: CX18_APU_START	cmd 0x10000001 args 0x000000b9 0x00000000
[   14.401347] cx18-0:  api: CX18_APU_RESETAI	cmd 0x10000005 args
[   14.401809] cx18-0:  api: CX18_APU_STOP	cmd 0x10000002 args 0x00000000
[   14.522275] cx18-1: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
[   14.579405] cx18-1:  info: load segment a00000-a07fff
[   14.623884] cx18-1:  info: load segment ae0000-ae00ff
[   14.624272] cx18-1:  info: load segment b00000-b1a65f
[   14.676017] cx18-alsa: module loading...
[   14.711766] cx18-0:  info: load segment a00000-a07fff
[   14.736394] cx18-1: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
[   14.743024] cx18-1:  info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
[   14.743032] cx18-1: FW version: 0.0.74.0 (Release 2007/03/12)
[   14.747369] cx18-0:  info: load segment ae0000-ae00ff
[   14.747559] cx18-0:  info: load segment b00000-b1a65f
[   14.830961] cx18-0:  info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
[   14.948033] cx18-1:  api: CX18_CPU_DEBUG_PEEK32	cmd 0x20000003 args 0x00000000
[   14.948103] cx18-1:  api: CX18_APU_START	cmd 0x10000001 args 0x000000b9 0x00000000
[   14.949222] cx18-1:  api: CX18_APU_RESETAI	cmd 0x10000005 args
[   14.949658] cx18-1:  api: CX18_APU_STOP	cmd 0x10000002 args 0x00000000
[   15.036107] cx18-0:  api: CX18_CPU_DEBUG_PEEK32	cmd 0x20000003 args 0x00000000
[   15.036218] cx18-0:  api: CX18_APU_START	cmd 0x10000001 args 0x000000b9 0x00000000
[   15.037420] cx18-0:  api: CX18_APU_RESETAI	cmd 0x10000005 args
[   15.037909] cx18-0:  api: CX18_APU_STOP	cmd 0x10000002 args 0x00000000
[   15.115378] cx18-1:  info: load segment a00000-a07fff
[   15.141829] cx18-1:  info: load segment ae0000-ae00ff
[   15.142042] cx18-1:  info: load segment b00000-b1a65f
[   15.236850] cx18-1:  info: 1 MiniMe Encoder Firmware 0.0.74.0 (Release 2007/03/12)
[   15.280739] cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[   15.301792] cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
[   15.301959] cx18-0:  info: Changing input from 1 to 0
[   15.301963] cx18-0:  info: Mute
[   15.301967] cx18-0 843:  info: decoder set video input 7, audio input 8
[   15.303172] cx18-0 843:  info: decoder set video input 7, audio input 8
[   15.303247] cx18-0:  info: Unmute
[   15.303251] cx18-0:  info: Switching standard to 1000.
[   15.303254] cx18-0 843:  info: changing video std to fmt 1
[   15.303273] cx18-0 843:  info: PLL regs = int: 15, frac: 2876158, post: 4
[   15.303277] cx18-0 843:  info: Video PLL = 107.999999 MHz
[   15.303280] cx18-0 843:  info: Pixel rate = 13.499999 Mpixel/sec
[   15.303283] cx18-0 843:  info: ADC XTAL/pixel clock decimation ratio = 2.121
[   15.303287] cx18-0 843:  info: Chroma sub-carrier initial freq = 3.579545 MHz
[   15.303293] cx18-0 843:  info: hblank 122, hactive 720, vblank 26, vactive 481, vblank656 38, src_dec 543, burst 0x5a, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c00
[   15.305219] cx18-0:  info: Mute
[   15.305223] cx18-0:  info: v4l2 ioctl: set frequency 1076
[   15.308120] cx18-0:  info: Unmute
[   15.308124] cx18-0:  file: open encoder MPEG
[   15.308140] cx18-0:  file: open encoder YUV
[   15.308151] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   15.308168] cx18-0 encoder YUV: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   15.308246] cx18-0:  ioctl: close() of encoder MPEG
[   15.308256] cx18-0:  ioctl: close() of encoder YUV
[   15.308402] cx18-0:  file: open encoder PCM audio
[   15.308426] cx18-0 encoder PCM audio: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   15.308503] cx18-0:  ioctl: close() of encoder PCM audio
[   15.309309] cx18-0:  file: open encoder VBI
[   15.309333] cx18-0 encoder VBI: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   15.309418] cx18-0:  ioctl: close() of encoder VBI
[   15.440037] cx18-1:  api: CX18_CPU_DEBUG_PEEK32	cmd 0x20000003 args 0x00000000
[   15.440103] cx18-1:  api: CX18_APU_START	cmd 0x10000001 args 0x000000b9 0x00000000
[   15.441311] cx18-1:  api: CX18_APU_RESETAI	cmd 0x10000005 args
[   15.441756] cx18-1:  api: CX18_APU_STOP	cmd 0x10000002 args 0x00000000
[   15.632320] cx18-1 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[   15.653218] cx18-1 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
[   15.653392] cx18-1:  info: Changing input from 1 to 0
[   15.653396] cx18-1:  info: Mute
[   15.653400] cx18-1 843:  info: decoder set video input 7, audio input 8
[   15.654685] cx18-1 843:  info: decoder set video input 7, audio input 8
[   15.654770] cx18-1:  info: Unmute
[   15.654776] cx18-1:  info: Switching standard to 1000.
[   15.654782] cx18-1 843:  info: changing video std to fmt 1
[   15.654803] cx18-1 843:  info: PLL regs = int: 15, frac: 2876158, post: 4
[   15.654809] cx18-1 843:  info: Video PLL = 107.999999 MHz
[   15.654814] cx18-1 843:  info: Pixel rate = 13.499999 Mpixel/sec
[   15.654819] cx18-1 843:  info: ADC XTAL/pixel clock decimation ratio = 2.121
[   15.654824] cx18-1 843:  info: Chroma sub-carrier initial freq = 3.579545 MHz
[   15.654832] cx18-1 843:  info: hblank 122, hactive 720, vblank 26, vactive 481, vblank656 38, src_dec 543, burst 0x5a, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c00
[   15.656810] cx18-1:  info: Mute
[   15.656815] cx18-1:  info: v4l2 ioctl: set frequency 1076
[   15.659590] cx18-1:  info: Unmute
[   15.659593] cx18-1:  file: open encoder YUV
[   15.659615] cx18-1:  file: open encoder PCM audio
[   15.659624] cx18-1 encoder YUV: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   15.659660] cx18-1:  file: open encoder VBI
[   15.659671] cx18-1:  file: open encoder MPEG
[   15.659685] cx18-1 encoder VBI: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   15.659696] cx18-1 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   15.659774] cx18-1:  ioctl: close() of encoder VBI
[   15.659783] cx18-1:  ioctl: close() of encoder MPEG
[   15.661356] cx18-1 encoder PCM audio: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   15.661444] cx18-1:  ioctl: close() of encoder PCM audio
[   15.661528] cx18-1:  ioctl: close() of encoder YUV
[   17.374000] sshd (920): /proc/920/oom_adj is deprecated, please use /proc/920/oom_score_adj instead.
[   17.693277] type=1400 audit(1295919809.847:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=899 comm="apparmor_parser"
[   17.693489] type=1400 audit(1295919809.847:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=899 comm="apparmor_parser"
[   18.426543] type=1400 audit(1295919810.579:12): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=1052 comm="apparmor_parser"
[   18.478198] type=1400 audit(1295919810.631:13): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=1053 comm="apparmor_parser"
[   18.478335] type=1400 audit(1295919810.631:14): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1053 comm="apparmor_parser"
[   18.478456] type=1400 audit(1295919810.631:15): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1053 comm="apparmor_parser"
[   19.264290] type=1400 audit(1295919811.419:16): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=1068 comm="apparmor_parser"
[   19.264588] type=1400 audit(1295919811.419:17): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=1068 comm="apparmor_parser"
[   19.505011] type=1400 audit(1295919811.659:18): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=1076 comm="apparmor_parser"
[   19.737624] type=1400 audit(1295919811.891:19): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=1079 comm="apparmor_parser"
[   22.072026] eth0: no IPv6 routers present
[   24.368119] cx18-0:  file: open encoder VBI
[   24.368140] cx18-0 encoder VBI: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   24.382090] cx18-0:  file: open encoder MPEG
[   24.382109] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   24.389738] cx18-0:  file: open encoder PCM audio
[   24.389756] cx18-0 encoder PCM audio: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   24.395813] cx18-0:  file: open encoder YUV
[   24.395834] cx18-0 encoder YUV: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   24.405694] cx18-1:  file: open encoder VBI
[   24.405715] cx18-1 encoder VBI: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   24.415125] cx18-1:  file: open encoder MPEG
[   24.415143] cx18-1 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   24.424290] cx18-1:  file: open encoder PCM audio
[   24.424309] cx18-1 encoder PCM audio: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   24.431323] cx18-1:  file: open encoder YUV
[   24.431343] cx18-1 encoder YUV: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:01.0, version=0x00010400, capabilities=0x01030051
[   24.467630] cx18-0:  ioctl: close() of encoder VBI
[   24.469235] cx18-0:  ioctl: close() of encoder MPEG
[   24.470717] cx18-0:  ioctl: close() of encoder PCM audio
[   24.471895] cx18-0:  ioctl: close() of encoder YUV
[   24.473987] cx18-1:  ioctl: close() of encoder VBI
[   24.477810] cx18-1:  ioctl: close() of encoder MPEG
[   24.479280] cx18-1:  ioctl: close() of encoder PCM audio
[   24.480098] cx18-1:  ioctl: close() of encoder YUV
[   25.864690] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   27.597967] audit_printk_skb: 3 callbacks suppressed
[   27.597975] type=1400 audit(1295919819.751:21): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1063 comm="apparmor_parser"
[   27.599438] type=1400 audit(1295919819.751:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=1063 comm="apparmor_parser"
[   27.601342] type=1400 audit(1295919819.755:23): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1063 comm="apparmor_parser"
[   28.496036] Registered IR keymap rc-hauppauge-new
[   28.496282] input: i2c IR (Hauppauge HVR-1600) as /devices/virtual/rc/rc0/input4
[   28.496412] rc0: i2c IR (Hauppauge HVR-1600) as /devices/virtual/rc/rc0
[   28.496420] ir-kbd-i2c: i2c IR (Hauppauge HVR-1600) detected at i2c-4/4-0071/ir0 [cx18 i2c driver #0-0]
[   28.496451] Registered IR keymap rc-hauppauge-new
[   28.496643] input: i2c IR (Hauppauge HVR-1600) as /devices/virtual/rc/rc1/input5
[   28.496754] rc1: i2c IR (Hauppauge HVR-1600) as /devices/virtual/rc/rc1
[   28.496761] ir-kbd-i2c: i2c IR (Hauppauge HVR-1600) detected at i2c-6/6-0071/ir0 [cx18 i2c driver #1-0]
[   28.498452] IR NEC protocol handler initialized
[   28.593445] IR RC5(x) protocol handler initialized
[   28.628375] IR RC6 protocol handler initialized
[   28.785653] IR JVC protocol handler initialized
[   28.804104] IR Sony protocol handler initialized
[   28.816482] lirc_dev: IR Remote Control driver registered, major 250 
[   28.819600] IR LIRC bridge handler initialized
[   39.126445] cx18-0:  file: open encoder MPEG
[   39.126511] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   39.126541] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   39.552717] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[   39.552735] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=0, name=Tuner 1, type=1, audioset=7, tuner=0, std=00001000, status=0
[   39.552759] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=1, name=S-Video 1, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[   39.552774] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=2, name=Composite 1, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[   39.552788] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=3, name=S-Video 2, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[   39.552802] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=4, name=Composite 2, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[   39.552817] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT error -22
[   39.552915] cx18-0 encoder MPEG: VIDIOC_S_INPUT value=0
[   39.552923] cx18-0:  info: Input unchanged
[   39.552930] cx18-0 encoder MPEG: VIDIOC_S_STD std=0000b000
[   39.552937] cx18-0:  info: Switching standard to b000.
[   39.552943] cx18-0 843:  info: changing video std to fmt 1
[   39.552967] cx18-0 843:  info: PLL regs = int: 15, frac: 2876158, post: 4
[   39.552972] cx18-0 843:  info: Video PLL = 107.999999 MHz
[   39.552976] cx18-0 843:  info: Pixel rate = 13.499999 Mpixel/sec
[   39.552981] cx18-0 843:  info: ADC XTAL/pixel clock decimation ratio = 2.121
[   39.552986] cx18-0 843:  info: Chroma sub-carrier initial freq = 3.579545 MHz
[   39.552993] cx18-0 843:  info: hblank 122, hactive 720, vblank 26, vactive 481, vblank656 38, src_dec 543, burst 0x5a, luma_lpf 1, uv_lpf 1, comb 0x66, sc 0x087c00
[   39.560599] cx18-0 encoder MPEG: VIDIOC_S_INPUT value=0
[   39.560612] cx18-0:  info: Input unchanged
[   39.560621] cx18-0 encoder MPEG: VIDIOC_S_STD std=0000b000
[   39.576097] cx18-0 encoder MPEG: VIDIOC_G_MODULATOR error -22
[   39.576122] cx18-0 encoder MPEG: VIDIOC_S_FREQUENCY tuner=0, type=2, frequency=884
[   39.576133] cx18-0:  info: Mute
[   39.576137] cx18-0:  info: v4l2 ioctl: set frequency 884
[   39.578979] cx18-0:  info: Unmute
[   39.578988] cx18-0 encoder MPEG: VIDIOC_G_FREQUENCY tuner=0, type=2, frequency=884
[   39.582429] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980900, type=1, name=Brightness, min/max=0/255, step=1, default=128, flags=0x00000020
[   39.582490] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980900, value=127
[   39.585278] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980901, type=1, name=Contrast, min/max=0/127, step=1, default=64, flags=0x00000020
[   39.585309] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980901, value=63
[   39.587494] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980902, type=1, name=Saturation, min/max=0/127, step=1, default=64, flags=0x00000020
[   39.587524] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980902, value=63
[   39.590595] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980903, type=1, name=Hue, min/max=-128/127, step=1, default=0, flags=0x00000020
[   39.590626] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980903, value=0
[   39.590724] cx18-0:  ioctl: close() of encoder MPEG
[  117.371871] cx18-0:  file: open encoder MPEG
[  117.371899] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[  117.371920] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[  117.475804] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[  117.475825] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=0, name=Tuner 1, type=1, audioset=7, tuner=0, std=00001000, status=0
[  117.475849] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=1, name=S-Video 1, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[  117.475866] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=2, name=Composite 1, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[  117.475881] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=3, name=S-Video 2, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[  117.475897] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT index=4, name=Composite 2, type=2, audioset=7, tuner=0, std=00ffffff, status=0
[  117.475912] cx18-0 encoder MPEG: VIDIOC_ENUMINPUT error -22
[  118.117531] cx18-0 encoder MPEG: VIDIOC_S_INPUT value=0
[  118.117543] cx18-0:  info: Input unchanged
[  118.117552] cx18-0 encoder MPEG: VIDIOC_S_STD std=0000b000
[  118.126612] cx18-0 encoder MPEG: VIDIOC_G_MODULATOR error -22
[  118.126630] cx18-0 encoder MPEG: VIDIOC_S_FREQUENCY tuner=0, type=2, frequency=884
[  118.126641] cx18-0:  info: Mute
[  118.126646] cx18-0:  info: v4l2 ioctl: set frequency 884
[  118.130332] cx18-0:  info: Unmute
[  118.130354] cx18-0 encoder MPEG: VIDIOC_G_FREQUENCY tuner=0, type=2, frequency=884
[  118.133705] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980900, type=1, name=Brightness, min/max=0/255, step=1, default=128, flags=0x00000020
[  118.133732] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980900, value=127
[  118.135123] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980901, type=1, name=Contrast, min/max=0/127, step=1, default=64, flags=0x00000020
[  118.135146] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980901, value=63
[  118.137372] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980902, type=1, name=Saturation, min/max=0/127, step=1, default=64, flags=0x00000020
[  118.137398] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980902, value=63
[  118.138791] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980903, type=1, name=Hue, min/max=-128/127, step=1, default=0, flags=0x00000020
[  118.138815] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980903, value=0
[  118.652323] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980900, type=1, name=Brightness, min/max=0/255, step=1, default=128, flags=0x00000020
[  118.652349] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980900, value=127
[  118.653685] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980901, type=1, name=Contrast, min/max=0/127, step=1, default=64, flags=0x00000020
[  118.653708] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980901, value=63
[  118.655064] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980902, type=1, name=Saturation, min/max=0/127, step=1, default=64, flags=0x00000020
[  118.655087] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980902, value=63
[  118.657854] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980903, type=1, name=Hue, min/max=-128/127, step=1, default=0, flags=0x00000020
[  118.657882] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980903, value=0
[  118.657906] cx18-0:  ioctl: close() of encoder MPEG
[  118.658705] cx18-0:  file: open encoder MPEG
[  118.658725] cx18-0 encoder MPEG: VIDIOC_QUERYCAP driver=cx18, card=Hauppauge HVR-1600, bus=PCI:0000:03:00.0, version=0x00010400, capabilities=0x01030051
[  118.658789] cx18-0 encoder MPEG: VIDIOC_G_FMT type=vid-cap
[  118.658801] cx18-0 encoder MPEG: width=720, height=480, format=MPEG, field=interlaced, bytesperline=0 sizeimage=131072, colorspace=1
[  118.658809] cx18-0 encoder MPEG: VIDIOC_S_FMT type=vid-cap
[  118.658820] cx18-0 encoder MPEG: width=480, height=480, format=MPEG, field=interlaced, bytesperline=0 sizeimage=131072, colorspace=1
[  118.658835] cx18-0 843:  info: decoder set size 480x480 -> scale  524288x0
[  118.659267] cx18-0 encoder MPEG: VIDIOC_G_TUNER index=0, name=cx18 TV Tuner, type=2, capability=0x72, rangelow=704, rangehigh=15328, signal=65535, afc=-12500, rxsubchans=0x6, audmode=3
[  118.659343] cx18-0 encoder MPEG: VIDIOC_S_TUNER index=0, name=cx18 TV Tuner, type=2, capability=0x72, rangelow=704, rangehigh=15328, signal=65535, afc=-12500, rxsubchans=0x6, audmode=3
[  118.659369] cx18-0 encoder MPEG: VIDIOC_QUERYCTRL id=0x980905, type=1, name=Volume, min/max=0/65535, step=655, default=60928, flags=0x00000020
[  118.659388] cx18-0 encoder MPEG: VIDIOC_S_CTRL id=0x980905, value=58981
[  118.659554] cx18-0 encoder MPEG: VIDIOC_S_EXT_CTRLS class=0x990000 id/val=0x990964/0x1
[  118.659576] cx18-0 encoder MPEG: VIDIOC_S_EXT_CTRLS class=0x990000 id/val=0x990965/0x1
[  118.659593] cx18-0 encoder MPEG: VIDIOC_S_EXT_CTRLS class=0x990000 id/val=0x990967/0xd
[  118.659628] BUG: unable to handle kernel NULL pointer dereference at 00000008
[  118.673399] IP: [<e8350370>] cx18_api_func+0x10/0x350 [cx18]
[  118.675855] *pde = 00000000 
[  118.675855] Oops: 0000 [#1] SMP 
[  118.675855] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:03:08.0/net/eth0/statistics/collisions
[  118.675855] Modules linked in: binfmt_misc ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_hauppauge_new ir_kbd_i2c rc_core cx18_alsa mxl5005s s5h1409 tuner_simple tuner_types cs5345 tda9887 tda8290 tuner snd_intel8x0 snd_usb_audio snd_ac97_codec snd_hwdep ac97_bus snd_usbmidi_lib snd_pcm nls_utf8 cx18 snd_seq_midi radeon dvb_core cifs snd_rawmidi snd_seq_midi_event ttm cx2341x snd_seq drm_kms_helper snd_timer v4l2_common ppdev parport_pc videodev drm i2c_algo_bit snd_seq_device dcdbas snd lp intel_agp agpgart tveeprom shpchp soundcore snd_page_alloc parport e100 usbhid hid mii
[  118.675855] 
[  118.675855] Pid: 2269, comm: mythbackend Not tainted 2.6.36-020636-generic #201010210905 0M3918/Dimension 4700               
[  118.739039] EIP: 0060:[<e8350370>] EFLAGS: 00010286 CPU: 1
[  118.739039] EIP is at cx18_api_func+0x10/0x350 [cx18]
[  118.739039] EAX: 00000000 EBX: e58a815c ECX: e2289bdc EDX: 000000bd
[  118.739039] ESI: e2289bdc EDI: e2289c3c EBP: e2289bcc ESP: e2289ba0
[  118.739039]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  118.739039] Process mythbackend (pid: 2269, ti=e2288000 task=e2270000 task.ti=e2288000)
[  118.739039] Stack:
[  118.739039]  00000000 0000005b 1a1f61d9 e78739ac 00000002 e78739ab c092cfe0 e2289bfc
[  118.739039] <0> c0363562 e58a815c e2289bdc e2289c28 e7c5a811 00000000 e2289bdc 000000e9
[  118.739039] <0> c092cfe0 e2289c24 c0363678 00000000 e2289bf8 c012edf8 e2289c0c c05da2ff
[  118.739039] Call Trace:
[  118.739039]  [<c0363562>] ? vsnprintf+0x182/0x380
[  118.739039]  [<e7c5a811>] ? cx2341x_hdl_api+0x41/0x50 [cx2341x]
[  118.739039]  [<c0363678>] ? vsnprintf+0x298/0x380
[  118.739039]  [<c012edf8>] ? default_spin_lock_flags+0x8/0x10
[  118.811859]  [<c05da2ff>] ? _raw_spin_lock_irqsave+0x2f/0x50
[  118.811859]  [<e7c5b58e>] ? cx2341x_s_ctrl+0x56e/0x670 [cx2341x]
[  118.811859]  [<e787170e>] ? try_or_set_control_cluster+0x23e/0x2d0 [videodev]
[  118.811859]  [<e7871a22>] ? try_or_set_ext_ctrls+0x182/0x1c0 [videodev]
[  118.811859]  [<e7872070>] ? user_to_new+0x0/0xb0 [videodev]
[  118.811859]  [<e787266a>] ? try_set_ext_ctrls+0x10a/0x140 [videodev]
[  118.811859]  [<e78693b4>] ? v4l_print_ext_ctrls+0xe4/0x100 [videodev]
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<e78726f2>] ? v4l2_s_ext_ctrls+0x12/0x20 [videodev]
[  118.811859]  [<e786a884>] ? __video_do_ioctl+0x1444/0x5850 [videodev]
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<c0145932>] ? update_curr+0x102/0x1b0
[  118.811859]  [<c0101c7f>] ? __switch_to+0x10f/0x180
[  118.811859]  [<c0141761>] ? finish_task_switch+0x51/0xa0
[  118.811859]  [<c05d840d>] ? schedule+0x2bd/0x5f0
[  118.811859]  [<c035f02d>] ? radix_tree_lookup_slot+0xd/0x10
[  118.811859]  [<c01de2b8>] ? find_get_page+0x28/0x90
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<e786edee>] ? video_ioctl2+0xde/0x590 [videodev]
[  118.811859]  [<c01f9a55>] ? do_linear_fault+0x85/0xa0
[  118.811859]  [<c01faa0e>] ? handle_mm_fault+0xfe/0x2c0
[  118.811859]  [<e834f276>] ? cx18_v4l2_ioctl+0x56/0x80 [cx18]
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<e7868392>] ? v4l2_ioctl+0x82/0x130 [videodev]
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859]  [<e7868310>] ? v4l2_ioctl+0x0/0x130 [videodev]
[  118.811859]  [<c022d24b>] ? vfs_ioctl+0x3b/0x50
[  118.811859]  [<c022dde4>] ? do_vfs_ioctl+0x64/0x1c0
[  118.811859]  [<c030b5a5>] ? security_file_ioctl+0x15/0x20
[  118.811859]  [<c022df97>] ? sys_ioctl+0x57/0x70
[  118.811859]  [<c0102cdf>] ? sysenter_do_call+0x12/0x28
[  118.811859]  [<c0185648>] ? layout_sections+0x208/0x210
[  118.811859] Code: 44 24 04 09 00 02 20 89 44 24 0c e8 5b fe ff ff 83 c4 1c 5b 5e 5d c3 8d 74 26 00 55 89 e5 56 53 83 ec 24 0f 1f 44 00 00 8b 4d 0c <8b> 70 08 8d 9a 71 ff ff ff 83 fb 4d 76 22 83 c6 18 89 54 24 08 
[  118.811859] EIP: [<e8350370>] cx18_api_func+0x10/0x350 [cx18] SS:ESP 0068:e2289ba0
[  118.811859] CR2: 0000000000000008
[  118.972527] ---[ end trace 9489272c93f5f755 ]---

