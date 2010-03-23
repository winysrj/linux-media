Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hans@ginder.xs4all.nl>) id 1Nu6yw-0003Uv-F3
	for linux-dvb@linuxtv.org; Tue, 23 Mar 2010 17:29:32 +0100
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Nu6yv-0002nZ-8q; Tue, 23 Mar 2010 17:29:30 +0100
Received: from ginder.xs4all.nl (ginder.xs4all.nl [82.95.166.210])
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id o2NGTPUp078348
	for <linux-dvb@linuxtv.org>; Tue, 23 Mar 2010 17:29:26 +0100 (CET)
	(envelope-from hans@ginder.xs4all.nl)
Received: from localhost (localhost [127.0.0.1])
	by ginder.xs4all.nl (Postfix) with ESMTP id AA82F10022
	for <linux-dvb@linuxtv.org>; Tue, 23 Mar 2010 17:29:25 +0100 (CET)
Received: from ginder.xs4all.nl ([127.0.0.1])
	by localhost (ginder.xs4all.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SPUde9Kh6twR for <linux-dvb@linuxtv.org>;
	Tue, 23 Mar 2010 17:29:24 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by ginder.xs4all.nl (Postfix) with ESMTP id 7339610021
	for <linux-dvb@linuxtv.org>; Tue, 23 Mar 2010 17:29:24 +0100 (CET)
Message-ID: <4BA8EC64.3060208@ginder.xs4all.nl>
Date: Tue, 23 Mar 2010 17:29:24 +0100
From: Hans Houwaard <hans@ginder.xs4all.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------010400050305040504080306"
Subject: [linux-dvb] TeVii S470 card problems
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

This is a multi-part message in MIME format.
--------------010400050305040504080306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have recently swapped my TeVii S470 card for a new one, the old one 
was broken. I now have a revision 1.1 card and this card no longer 
works. It gets recognized and the modules are loaded, but the firmware 
never loads.  Maybe as a result of this I get errors and timeouts after 
mythtv loads.

see attached dmesg.txt. There is also a Hauppauge Nova S2 HD card, for 
which the firmware is loaded succesfully.

Can anyone help me solve this issue?

Hans Houwaard

--------------010400050305040504080306
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-14-generic (buildd@rothera) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #48-Ubuntu SMP Fri Oct 16 14:04:26 UTC 2009 (Ubuntu 2.6.31-14.48-generic)
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfde0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfdf0000 - 00000000cfe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0xcfde0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 base 00CFE00000 mask FFFFE00000 uncachable
[    0.000000]   4 base 0100000000 mask FFE0000000 write-back
[    0.000000]   5 base 0120000000 mask FFF0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cfe00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cfde0000 (usable)
[    0.000000]  modified: 00000000cfde0000 - 00000000cfde3000 (ACPI NVS)
[    0.000000]  modified: 00000000cfde3000 - 00000000cfdf0000 (ACPI data)
[    0.000000]  modified: 00000000cfdf0000 - 00000000cfe00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000] Using x86 segment limits to approximate NX protection
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37866000 - 37fef734
[    0.000000] Allocated new RAMDISK: 008ad000 - 01036734
[    0.000000] Move RAMDISK from 0000000037866000 - 0000000037fef733 to 008ad000 - 01036733
[    0.000000] ACPI: RSDP 000f6e40 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT cfde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP cfde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT cfde30c0 069CD (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS cfde0000 00040
[    0.000000] ACPI: SSDT cfde9b80 0030E (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET cfde9ec0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG cfde9f00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC cfde9ac0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2437MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008a80a0]    TEXT DATA BSS ==> [0000100000 - 00008a80a0]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [00008a9000 - 00008ac116]              BRK ==> [00008a9000 - 00008ac116]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [00008ad000 - 0001036734]      NEW RAMDISK ==> [00008ad000 - 0001036734]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00f54e0] f54e0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000cfde0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfde0
[    0.000000] On node 0 totalpages: 851323
[    0.000000] free_area_init_node: node 0, pgdat c0784900, node_mem_map c1037000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4876 pages used for memmap
[    0.000000]   HighMem zone: 619222 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at cfe00000 (gap: cfe00000:10200000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c2a47000, static data 35612 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 844671
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.31-14-generic root=UUID=bd37d665-f558-4fd1-a609-48216cb20a52 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 17028480 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:000cfde0)
[    0.000000] Memory: 3344460k/3405696k available (4565k kernel code, 59944k reserved, 2143k data, 540k init, 2496392k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc078e000 - 0xc0815000   ( 540 kB)
[    0.000000]       .data : 0xc0575554 - 0xc078d308   (2143 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0575554   (4565 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2912.972 MHz processor.
[    0.000009] spurious 8259A interrupt: IRQ7.
[    0.001918] Console: colour VGA+ 80x25
[    0.001920] console [tty0] enabled
[    0.002058] hpet clockevent registered
[    0.002064]   alloc irq_desc for 24 on node 0
[    0.002066]   alloc kstat_irqs on node 0
[    0.002073] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 5825.94 BogoMIPS (lpj=11651888)
[    0.004020] Security Framework initialized
[    0.004034] AppArmor: AppArmor initialized
[    0.004039] Mount-cache hash table entries: 512
[    0.004131] Initializing cgroup subsys ns
[    0.004134] Initializing cgroup subsys cpuacct
[    0.004137] Initializing cgroup subsys memory
[    0.004141] Initializing cgroup subsys freezer
[    0.004143] Initializing cgroup subsys net_cls
[    0.004152] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004154] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004156] CPU: Physical Processor ID: 0
[    0.004157] CPU: Processor Core ID: 0
[    0.004159] mce: CPU supports 5 MCE banks
[    0.004166] using C1E aware idle routine
[    0.004172] Performance Counters: AMD PMU driver.
[    0.004176] ... version:                 0
[    0.004177] ... bit width:               48
[    0.004178] ... generic counters:        4
[    0.004180] ... value mask:              0000ffffffffffff
[    0.004181] ... max period:              00007fffffffffff
[    0.004183] ... fixed-purpose counters:  0
[    0.004184] ... counter mask:            000000000000000f
[    0.004187] Checking 'hlt' instruction... OK.
[    0.021463] ACPI: Core revision 20090521
[    0.028586] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069268] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ stepping 02
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5826.52 BogoMIPS (lpj=11653046)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 5 MCE banks
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.156368] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ stepping 02
[    0.156387] Brought up 2 CPUs
[    0.156389] Total of 2 processors activated (11652.46 BogoMIPS).
[    0.156491] CPU0 attaching sched-domain:
[    0.156493]  domain 0: span 0-1 level MC
[    0.156495]   groups: 0 1
[    0.156499] CPU1 attaching sched-domain:
[    0.156501]  domain 0: span 0-1 level MC
[    0.156503]   groups: 1 0
[    0.156551] Booting paravirtualized kernel on bare hardware
[    0.156551] regulator: core version 0.5
[    0.156551] Time: 12:22:16  Date: 03/17/10
[    0.156551] NET: Registered protocol family 16
[    0.156551] EISA bus registered
[    0.156551] ACPI: bus type pci registered
[    0.156551] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.156551] PCI: MCFG area at e0000000 reserved in E820
[    0.156551] PCI: Using MMCONFIG for extended config space
[    0.156551] PCI: Using configuration type 1 for base access
[    0.156854] bio: create slab <bio-0> at 0
[    0.156854] ACPI: EC: Look up EC in DSDT
[    0.163272] ACPI: Interpreter enabled
[    0.163280] ACPI: (supports S0 S3 S4 S5)
[    0.163298] ACPI: Using IOAPIC for interrupt routing
[    0.166613] ACPI: No dock devices found.
[    0.166695] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.166736] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.166790] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.166793] pci 0000:00:02.0: PME# disabled
[    0.166826] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.166829] pci 0000:00:04.0: PME# disabled
[    0.166867] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.166869] pci 0000:00:0a.0: PME# disabled
[    0.166919] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.166925] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.166932] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.166939] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.166945] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.166952] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.167004] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.167059] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.167134] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.167186] pci 0000:00:12.2: supports D1 D2
[    0.167188] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.167192] pci 0000:00:12.2: PME# disabled
[    0.167223] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.167277] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.167350] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.167402] pci 0000:00:13.2: supports D1 D2
[    0.167404] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.167408] pci 0000:00:13.2: PME# disabled
[    0.167525] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.167532] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.167539] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.167545] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.167552] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.167619] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.167662] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.167666] pci 0000:00:14.2: PME# disabled
[    0.167770] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.167893] pci 0000:01:00.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
[    0.167902] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.167910] pci 0000:01:00.0: reg 1c 64bit mmio: [0xf4000000-0xf5ffffff]
[    0.167916] pci 0000:01:00.0: reg 24 io port: [0xef00-0xef7f]
[    0.167921] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x07ffff]
[    0.168017] pci 0000:00:02.0: bridge io port: [0xe000-0xefff]
[    0.168020] pci 0000:00:02.0: bridge 32bit mmio: [0xf4000000-0xf7ffffff]
[    0.168023] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.168075] pci 0000:02:00.0: reg 10 64bit mmio: [0xfda00000-0xfdbfffff]
[    0.168162] pci 0000:02:00.0: supports D1 D2
[    0.168164] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[    0.168170] pci 0000:02:00.0: PME# disabled
[    0.168234] pci 0000:00:04.0: bridge io port: [0xd000-0xdfff]
[    0.168237] pci 0000:00:04.0: bridge 32bit mmio: [0xfda00000-0xfdbfffff]
[    0.168240] pci 0000:00:04.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.168275] pci 0000:03:00.0: reg 10 io port: [0xce00-0xceff]
[    0.168290] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdcff000-0xfdcfffff]
[    0.168301] pci 0000:03:00.0: reg 20 64bit mmio: [0xfdce0000-0xfdceffff]
[    0.168307] pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.168337] pci 0000:03:00.0: supports D1 D2
[    0.168339] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.168342] pci 0000:03:00.0: PME# disabled
[    0.168402] pci 0000:00:0a.0: bridge io port: [0xc000-0xcfff]
[    0.168405] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.168409] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdc00000-0xfdcfffff]
[    0.168468] pci 0000:04:06.0: reg 10 32bit mmio: [0xf9000000-0xf9ffffff]
[    0.168576] pci 0000:04:06.1: reg 10 32bit mmio: [0xf8000000-0xf8ffffff]
[    0.168677] pci 0000:04:06.2: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
[    0.168779] pci 0000:04:06.4: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.168889] pci 0000:00:14.4: transparent bridge
[    0.168893] pci 0000:00:14.4: bridge io port: [0xb000-0xbfff]
[    0.168897] pci 0000:00:14.4: bridge 32bit mmio: [0xf8000000-0xfcffffff]
[    0.168901] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfdd00000-0xfddfffff]
[    0.168914] pci_bus 0000:00: on NUMA node 0
[    0.168918] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.169144] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.169211] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.169253] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.169303] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.186285] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186356] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186426] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186496] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186565] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186635] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186705] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186775] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.186904] SCSI subsystem initialized
[    0.186938] libata version 3.00 loaded.
[    0.186938] usbcore: registered new interface driver usbfs
[    0.186938] usbcore: registered new interface driver hub
[    0.186938] usbcore: registered new device driver usb
[    0.186938] ACPI: WMI: Mapper loaded
[    0.186938] PCI: Using ACPI for IRQ routing
[    0.186938] pci 0000:00:00.0: BAR 3: address space collision on of device [0xe0000000-0xffffffff]
[    0.186938] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.196006] Bluetooth: Core ver 2.15
[    0.196017] NET: Registered protocol family 31
[    0.196017] Bluetooth: HCI device and connection manager initialized
[    0.196017] Bluetooth: HCI socket layer initialized
[    0.196017] NetLabel: Initializing
[    0.196017] NetLabel:  domain hash size = 128
[    0.196017] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.196027] NetLabel:  unlabeled traffic allowed by default
[    0.196052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.196056] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.200027] hpet: hpet2 irq 24 for MSI
[    0.204030] Switched to high resolution mode on CPU 0
[    0.204351] Switched to high resolution mode on CPU 1
[    0.212022] pnp: PnP ACPI init
[    0.212036] ACPI: bus type pnp registered
[    0.213705] pnp 00:09: mem resource (0xd1c00-0xd3fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213708] pnp 00:09: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213711] pnp 00:09: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213714] pnp 00:09: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213717] pnp 00:09: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213719] pnp 00:09: mem resource (0x100000-0xcfddffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.213787] pnp: PnP ACPI: found 10 devices
[    0.213789] ACPI: ACPI bus type pnp unregistered
[    0.213791] PnPBIOS: Disabled by ACPI PNP
[    0.213801] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.213803] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.213805] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.213809] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.213812] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.213814] system 00:02: ioport range 0x238-0x23f has been reserved
[    0.213816] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.213818] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.213821] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.213823] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.213825] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.213827] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.213830] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.213832] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.213834] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.213843] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.213845] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.213848] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.213850] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.213853] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.213855] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.213860] system 00:08: iomem range 0xe0000000-0xefffffff has been reserved
[    0.213865] system 00:09: iomem range 0xcfde0000-0xcfdfffff could not be reserved
[    0.213867] system 00:09: iomem range 0xffff0000-0xffffffff has been reserved
[    0.213870] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.213872] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.213875] system 00:09: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.248502] AppArmor: AppArmor Filesystem Enabled
[    0.248535] pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
[    0.248538] pci 0000:00:02.0:   IO window: 0xe000-0xefff
[    0.248541] pci 0000:00:02.0:   MEM window: 0xf4000000-0xf7ffffff
[    0.248544] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.248548] pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
[    0.248550] pci 0000:00:04.0:   IO window: 0xd000-0xdfff
[    0.248553] pci 0000:00:04.0:   MEM window: 0xfda00000-0xfdbfffff
[    0.248556] pci 0000:00:04.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.248560] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
[    0.248562] pci 0000:00:0a.0:   IO window: 0xc000-0xcfff
[    0.248565] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.248567] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdc00000-0x000000fdcfffff
[    0.248571] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.248574] pci 0000:00:14.4:   IO window: 0xb000-0xbfff
[    0.248579] pci 0000:00:14.4:   MEM window: 0xf8000000-0xfcffffff
[    0.248583] pci 0000:00:14.4:   PREFETCH window: 0xfdd00000-0xfddfffff
[    0.248593]   alloc irq_desc for 18 on node -1
[    0.248594]   alloc kstat_irqs on node -1
[    0.248602] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.248606] pci 0000:00:02.0: setting latency timer to 64
[    0.248610]   alloc irq_desc for 16 on node -1
[    0.248611]   alloc kstat_irqs on node -1
[    0.248618] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.248621] pci 0000:00:04.0: setting latency timer to 64
[    0.248626] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.248628] pci 0000:00:0a.0: setting latency timer to 64
[    0.248636] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.248638] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.248640] pci_bus 0000:01: resource 0 io:  [0xe000-0xefff]
[    0.248642] pci_bus 0000:01: resource 1 mem: [0xf4000000-0xf7ffffff]
[    0.248644] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.248646] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
[    0.248648] pci_bus 0000:02: resource 1 mem: [0xfda00000-0xfdbfffff]
[    0.248650] pci_bus 0000:02: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.248652] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.248654] pci_bus 0000:03: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.248656] pci_bus 0000:03: resource 2 pref mem [0xfdc00000-0xfdcfffff]
[    0.248658] pci_bus 0000:04: resource 0 io:  [0xb000-0xbfff]
[    0.248660] pci_bus 0000:04: resource 1 mem: [0xf8000000-0xfcffffff]
[    0.248662] pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
[    0.248664] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.248666] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.248694] NET: Registered protocol family 2
[    0.248765] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.249006] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.249519] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.249811] TCP: Hash tables configured (established 131072 bind 65536)
[    0.249813] TCP reno registered
[    0.249886] NET: Registered protocol family 1
[    0.249933] Trying to unpack rootfs image as initramfs...
[    0.397733] Freeing initrd memory: 7717k freed
[    0.401407] cpufreq-nforce2: No nForce2 chipset.
[    0.401427] Scanning for low memory corruption every 60 seconds
[    0.401500] audit: initializing netlink socket (disabled)
[    0.401511] type=2000 audit(1268828535.400:1): initialized
[    0.407894] highmem bounce pool size: 64 pages
[    0.407898] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.408930] VFS: Disk quotas dquot_6.5.2
[    0.408975] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.409421] fuse init (API version 7.12)
[    0.409477] msgmni has been set to 1673
[    0.409667] alg: No test for stdrng (krng)
[    0.409684] io scheduler noop registered
[    0.409686] io scheduler anticipatory registered
[    0.409687] io scheduler deadline registered
[    0.409717] io scheduler cfq registered (default)
[    1.236027] pci 0000:00:12.1: OHCI: BIOS handoff failed (BIOS bug?) 00000184
[    1.308055] pci 0000:01:00.0: Boot video device
[    1.308164]   alloc irq_desc for 25 on node -1
[    1.308166]   alloc kstat_irqs on node -1
[    1.308173] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
[    1.308178] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    1.308250]   alloc irq_desc for 26 on node -1
[    1.308252]   alloc kstat_irqs on node -1
[    1.308256] pcieport-driver 0000:00:04.0: irq 26 for MSI/MSI-X
[    1.308260] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    1.308326]   alloc irq_desc for 27 on node -1
[    1.308327]   alloc kstat_irqs on node -1
[    1.308331] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
[    1.308335] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    1.308385] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.308402] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.308493] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.308496] ACPI: Power Button [PWRF]
[    1.308534] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.308536] ACPI: Power Button [PWRB]
[    1.308770] processor LNXCPU:00: registered as cooling_device0
[    1.308799] processor LNXCPU:01: registered as cooling_device1
[    1.310312] isapnp: Scanning for PnP cards...
[    1.664144] isapnp: No Plug & Play device found
[    1.664988] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.665857] brd: module loaded
[    1.666169] loop: module loaded
[    1.666225] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.666272] ahci 0000:00:11.0: version 3.0
[    1.666286]   alloc irq_desc for 22 on node -1
[    1.666288]   alloc kstat_irqs on node -1
[    1.666297] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.666426] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.666429] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    1.666958] scsi0 : ahci
[    1.667058] scsi1 : ahci
[    1.667117] scsi2 : ahci
[    1.667170] scsi3 : ahci
[    1.667222] scsi4 : ahci
[    1.667277] scsi5 : ahci
[    1.667375] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    1.667378] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.667382] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    1.667385] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.667388] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    1.667391] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    1.667596] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.667701] scsi6 : pata_atiixp
[    1.667758] scsi7 : pata_atiixp
[    1.668502] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    1.668504] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    1.669047] Fixed MDIO Bus: probed
[    1.669074] PPP generic driver version 2.4.2
[    1.669152] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.669167]   alloc irq_desc for 17 on node -1
[    1.669169]   alloc kstat_irqs on node -1
[    1.669177] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.669191] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.669230] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.669250] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    1.669268] ehci_hcd 0000:00:12.2: debug port 1
[    1.669292] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    1.680030] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.680080] usb usb1: configuration #1 chosen from 1 choice
[    1.680101] hub 1-0:1.0: USB hub found
[    1.680108] hub 1-0:1.0: 6 ports detected
[    1.680158]   alloc irq_desc for 19 on node -1
[    1.680160]   alloc kstat_irqs on node -1
[    1.680167] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.680176] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.680195] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.680212] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    1.680229] ehci_hcd 0000:00:13.2: debug port 1
[    1.680251] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    1.692027] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.692065] usb usb2: configuration #1 chosen from 1 choice
[    1.692084] hub 2-0:1.0: USB hub found
[    1.692089] hub 2-0:1.0: 6 ports detected
[    1.692139] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.692150] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.692158] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.692179] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.692209] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    1.752054] usb usb3: configuration #1 chosen from 1 choice
[    1.752076] hub 3-0:1.0: USB hub found
[    1.752084] hub 3-0:1.0: 3 ports detected
[    1.752123] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.752130] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.752154] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.752168] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.812057] usb usb4: configuration #1 chosen from 1 choice
[    1.812078] hub 4-0:1.0: USB hub found
[    1.812086] hub 4-0:1.0: 3 ports detected
[    1.812125] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.812133] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.812154] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.812180] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.872055] usb usb5: configuration #1 chosen from 1 choice
[    1.872074] hub 5-0:1.0: USB hub found
[    1.872081] hub 5-0:1.0: 3 ports detected
[    1.872120] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.872127] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.872149] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.872168] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.932058] usb usb6: configuration #1 chosen from 1 choice
[    1.932077] hub 6-0:1.0: USB hub found
[    1.932084] hub 6-0:1.0: 3 ports detected
[    1.932125] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.932133] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.932157] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.932170] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.984053] ata6: SATA link down (SStatus 0 SControl 300)
[    1.984080] ata4: SATA link down (SStatus 0 SControl 300)
[    1.984131] ata5: SATA link down (SStatus 0 SControl 300)
[    1.992062] usb usb7: configuration #1 chosen from 1 choice
[    1.992081] hub 7-0:1.0: USB hub found
[    1.992089] hub 7-0:1.0: 2 ports detected
[    1.992128] uhci_hcd: USB Universal Host Controller Interface driver
[    1.992194] PNP: No PS/2 controller found. Probing ports directly.
[    2.025347] Failed to disable AUX port, but continuing anyway... Is this a SiS?
[    2.025348] If AUX port is really absent please use the 'i8042.noaux' option.
[    2.148015] ata3: softreset failed (device not ready)
[    2.148018] ata3: applying SB600 PMP SRST workaround and retrying
[    2.148034] ata1: softreset failed (device not ready)
[    2.148036] ata1: applying SB600 PMP SRST workaround and retrying
[    2.276116] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.276165] mice: PS/2 mouse device common for all mice
[    2.276238] rtc_cmos 00:05: RTC can wake from S4
[    2.276264] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.276298] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    2.276375] device-mapper: uevent: version 1.0.3
[    2.276462] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    2.276550] device-mapper: multipath: version 1.1.0 loaded
[    2.276552] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.276668] EISA: Probing bus 0 at eisa.0
[    2.276685] Cannot allocate resource for EISA slot 4
[    2.276701] EISA: Detected 0 cards.
[    2.276833] cpuidle: using governor ladder
[    2.276835] cpuidle: using governor menu
[    2.277183] TCP cubic registered
[    2.277305] NET: Registered protocol family 10
[    2.277643] lo: Disabled Privacy Extensions
[    2.277861] NET: Registered protocol family 17
[    2.277877] Bluetooth: L2CAP ver 2.13
[    2.277878] Bluetooth: L2CAP socket layer initialized
[    2.277880] Bluetooth: SCO (Voice Link) ver 0.6
[    2.277881] Bluetooth: SCO socket layer initialized
[    2.277909] Bluetooth: RFCOMM TTY layer initialized
[    2.277911] Bluetooth: RFCOMM socket layer initialized
[    2.277913] Bluetooth: RFCOMM ver 1.11
[    2.277926] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ processors (2 cpu cores) (version 2.20.00)
[    2.277966] powernow-k8:    0 : fid 0x15 (2900 MHz), vid 0x6
[    2.277968] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x7
[    2.277969] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0x9
[    2.277971] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xb
[    2.277973] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xd
[    2.277975] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0xf
[    2.277976] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x11
[    2.277978] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    2.278008] Using IPI No-Shortcut mode
[    2.278052] PM: Resume from disk failed.
[    2.278065] registered taskstats version 1
[    2.278181]   Magic number: 2:353:380
[    2.278264] rtc_cmos 00:05: setting system clock to 2010-03-17 12:22:18 UTC (1268828538)
[    2.278266] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.278268] EDD information not available.
[    2.312027] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.312048] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.318366] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01113, max UDMA7
[    2.318368] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.318391] ata3.00: ATA-7: SAMSUNG HD103SI, 1AG01113, max UDMA7
[    2.318393] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.324772] ata1.00: configured for UDMA/133
[    2.324825] ata3.00: configured for UDMA/133
[    2.340596] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    2.340693] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.340722] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.340752] sd 0:0:0:0: [sda] Write Protect is off
[    2.340754] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.340770] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.340861]  sda: sda1 sda2 <
[    2.372514] ata2: softreset failed (device not ready)
[    2.372517] ata2: applying SB600 PMP SRST workaround and retrying
[    2.394225]  sda5 > sda3
[    2.394423] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.536025] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.536036] usb 3-2: new low speed USB device using ohci_hcd and address 2
[    2.538971] ata2.00: ATAPI: Optiarc BD ROM BC-5100S, 1.10, max UDMA/66
[    2.542065] ata2.00: configured for UDMA/66
[    2.567927] scsi 1:0:0:0: CD-ROM            Optiarc  BD ROM BC-5100S  1.10 PQ: 0 ANSI: 5
[    2.586270] sr0: scsi3-mmc drive: 32x/32x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.586273] Uniform CD-ROM driver Revision: 3.20
[    2.586328] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.586359] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.586416] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103SI  1AG0 PQ: 0 ANSI: 5
[    2.586489] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.586513] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.586541] sd 2:0:0:0: [sdb] Write Protect is off
[    2.586543] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.586558] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.586630]  sdb: sdb1 sdb2 < sdb5 > sdb3
[    2.642325] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.706141] usb 3-2: configuration #1 chosen from 1 choice
[    2.740097] Freeing unused kernel memory: 540k freed
[    2.740392] Write protecting the kernel text: 4568k
[    2.740420] Write protecting the kernel read-only data: 1836k
[    2.870730] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.870748] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.870781] r8169 0000:03:00.0: setting latency timer to 64
[    2.870818]   alloc irq_desc for 28 on node -1
[    2.870820]   alloc kstat_irqs on node -1
[    2.870832] r8169 0000:03:00.0: irq 28 for MSI/MSI-X
[    2.871286] eth0: RTL8168c/8111c at 0xf8038000, 00:1f:d0:5a:d4:cc, XID 3c4000c0 IRQ 28
[    2.905296] usbcore: registered new interface driver hiddev
[    2.905362] usbcore: registered new interface driver usbhid
[    2.905364] usbhid: v2.6:USB HID core driver
[    2.913328] input: MLK Trust Keyboard 14909 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input3
[    2.913381] sunplus 0003:04FC:05D8.0001: input,hidraw0: USB HID v1.00 Keyboard [MLK Trust Keyboard 14909] on usb-0000:00:12.0-2/input0
[    2.920098] sunplus 0003:04FC:05D8.0002: fixing up Sunplus Wireless Desktop report descriptor
[    2.920839] input: MLK Trust Keyboard 14909 as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input4
[    2.920924] sunplus 0003:04FC:05D8.0002: input,hiddev96,hidraw1: USB HID v1.00 Mouse [MLK Trust Keyboard 14909] on usb-0000:00:12.0-2/input1
[    3.008540] usb 3-3: new full speed USB device using ohci_hcd and address 3
[    3.057939] md: bind<sda1>
[    3.059034] md: bind<sda3>
[    3.183190] usb 3-3: configuration #1 chosen from 1 choice
[    3.191220] md: bind<sdb1>
[    3.193094] md: raid0 personality registered for level 0
[    3.193176] raid0: looking at sdb1
[    3.193178] raid0:   comparing sdb1(916652544)
[    3.193180]  with sdb1(916652544)
[    3.193181] raid0:   END
[    3.193182] raid0:   ==> UNIQUE
[    3.193183] raid0: 1 zones
[    3.193185] raid0: looking at sda1
[    3.193187] raid0:   comparing sda1(916652544)
[    3.193188]  with sdb1(916652544)
[    3.193189] raid0:   EQUAL
[    3.193191] raid0: FINAL 1 zones
[    3.193193] raid0: done.
[    3.193195] raid0 : md_size is 1833305088 sectors.
[    3.193196] ******* md1 configuration *********
[    3.193198] zone0=[sda1/sdb1/]
[    3.193201]         zone offset=0kb device offset=0kb size=916652544kb
[    3.193202] **********************************
[    3.193203] 
[    3.193210] md1: detected capacity change from 0 to 938652205056
[    3.194307]  md1: unknown partition table
[    3.202139] md: bind<sdb3>
[    3.214536] md: raid1 personality registered for level 1
[    3.214670] raid1: raid set md0 active with 2 out of 2 mirrors
[    3.214694] md0: detected capacity change from 0 to 21467889664
[    3.215883]  md0: unknown partition table
[    3.460522] usb 4-1: new full speed USB device using ohci_hcd and address 2
[    3.679191] usb 4-1: configuration #1 chosen from 1 choice
[    4.004018] usb 6-1: new full speed USB device using ohci_hcd and address 2
[    4.100340] md: linear personality registered for level -1
[    4.102372] md: multipath personality registered for level -4
[    4.106639] xor: automatically using best checksumming function: pIII_sse
[    4.124014]    pIII_sse  :  8713.000 MB/sec
[    4.124015] xor: using function: pIII_sse (8713.000 MB/sec)
[    4.124510] async_tx: api initialized (async)
[    4.177206] usb 6-1: configuration #1 chosen from 1 choice
[    4.192045] raid6: int32x1   1310 MB/s
[    4.260025] raid6: int32x2   1266 MB/s
[    4.328071] raid6: int32x4    791 MB/s
[    4.396084] raid6: int32x8    611 MB/s
[    4.464039] raid6: mmxx1     2315 MB/s
[    4.532019] raid6: mmxx2     4107 MB/s
[    4.600024] raid6: sse1x1    2349 MB/s
[    4.668026] raid6: sse1x2    3951 MB/s
[    4.736029] raid6: sse2x1    3881 MB/s
[    4.804023] raid6: sse2x2    5333 MB/s
[    4.804024] raid6: using algorithm sse2x2 (5333 MB/s)
[    4.806260] md: raid6 personality registered for level 6
[    4.806262] md: raid5 personality registered for level 5
[    4.806264] md: raid4 personality registered for level 4
[    4.812087] md: raid10 personality registered for level 10
[    4.832458] PM: Starting manual resume from disk
[    4.832461] PM: Resume from partition 8:5
[    4.832463] PM: Checking hibernation image.
[    4.832583] PM: Resume from disk failed.
[    4.848155] kjournald starting.  Commit interval 5 seconds
[    4.848163] EXT3-fs: mounted filesystem with writeback data mode.
[    6.116075] Adding 9092748k swap on /dev/sda5.  Priority:-1 extents:1 across:9092748k 
[    6.140221] Adding 9092748k swap on /dev/sdb5.  Priority:-2 extents:1 across:9092748k 
[    6.268211] EXT3 FS on md0, internal journal
[    6.537158] udev: starting version 147
[    7.733441] r8169: eth0: link up
[    7.733447] r8169: eth0: link up
[    8.217938] lp: driver loaded but no devices found
[    8.293141] Linux agpgart interface v0.103
[    8.575343] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    8.575439] usbcore: registered new interface driver btusb
[    8.839686] usbcore: registered new interface driver usbserial
[    8.839698] USB Serial support registered for generic
[    8.839737] usbcore: registered new interface driver usbserial_generic
[    8.839739] usbserial: USB Serial Driver core
[    8.894998] USB Serial support registered for FTDI USB Serial Device
[    8.895075] ftdi_sio 4-1:1.0: FTDI USB Serial Device converter detected
[    8.895100] usb 4-1: Detected FT232BM
[    8.895102] usb 4-1: Number of endpoints 2
[    8.895104] usb 4-1: Endpoint 1 MaxPacketSize 64
[    8.895105] usb 4-1: Endpoint 2 MaxPacketSize 64
[    8.895107] usb 4-1: Setting MaxPacketSize 64
[    8.895535] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    8.895538] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    8.895543] piix4_smbus: probe of 0000:00:14.0 failed with error -16
[    8.901112] ftdi_sio ttyUSB0: Unable to read latency timer: -32
[    8.901180] usb 4-1: FTDI USB Serial Device converter now attached to ttyUSB0
[    8.901213] usbcore: registered new interface driver ftdi_sio
[    8.901215] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[    9.834162] nvidia: module license 'NVIDIA' taints kernel.
[    9.834166] Disabling lock debugging due to kernel taint
[    9.951138] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   10.087460] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   10.087468] nvidia 0000:01:00.0: setting latency timer to 64
[   10.087658] NVRM: loading NVIDIA UNIX x86 Kernel Module  190.53  Tue Dec  8 18:51:41 PST 2009
[   10.219364] Linux video capture interface: v2.00
[   10.391980] cx23885 driver version 0.0.2 loaded
[   10.392023] cx23885 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.392095] CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
[   10.520007] cx23885_dvb_register() allocating 1 frontend(s)
[   10.520164] cx23885[0]: cx23885 based dvb card
[   10.691343] DS3000 chip version: 0.192 attached.
[   10.691347] DVB: registering new adapter (cx23885[0])
[   10.691350] DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
[   10.691562] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   10.691569] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfda00000
[   10.691576] cx23885 0000:02:00.0: setting latency timer to 64
[   10.691581] IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.742988] cx2388x alsa driver version 0.0.7 loaded
[   10.743040]   alloc irq_desc for 20 on node -1
[   10.743042]   alloc kstat_irqs on node -1
[   10.743053] cx88_audio 0000:04:06.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   10.743448] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[   10.743450] cx88[0]: TV tuner type -1, Radio tuner type -1
[   10.747333] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[   10.749436] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[   10.935780] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.992048] tveeprom 3-0050: Hauppauge model 69100, rev B2C3, serial# 5208002
[   10.992051] tveeprom 3-0050: MAC address is 00:0d:fe:4f:77:c2
[   10.992054] tveeprom 3-0050: tuner model is Conexant CX24118A (idx 123, type 4)
[   10.992056] tveeprom 3-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
[   10.992058] tveeprom 3-0050: audio processor is None (idx 0)
[   10.992060] tveeprom 3-0050: decoder processor is CX882 (idx 25)
[   10.992062] tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter
[   10.992064] cx88[0]: hauppauge eeprom: model=69100
[   10.994024] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:14.4/0000:04:06.1/input/input5
[   10.994072] Creating IR device irrcv0
[   10.994076] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.994115] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   11.004974] cx8800 0000:04:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.004983] cx88[0]/0: found at 0000:04:06.0, rev: 5, irq: 20, latency: 32, mmio: 0xf9000000
[   11.004995] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.005051] cx88[0]/0: registered device video0 [v4l2]
[   11.005070] cx88[0]/0: registered device vbi0
[   11.005243] cx88[0]/2: cx2388x 8802 Driver Manager
[   11.005255] cx88-mpeg driver manager 0000:04:06.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.005264] cx88[0]/2: found at 0000:04:06.2, rev: 5, irq: 20, latency: 32, mmio: 0xfb000000
[   11.005267] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.099136] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[   11.099139] cx88/2: registering cx8802 driver, type: dvb access: shared
[   11.099142] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   11.099144] cx88[0]/2: cx2388x based DVB/ATSC card
[   11.099146] cx8802_alloc_frontends() allocating 1 frontend(s)
[   11.774398] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input6
[   11.796232] DVB: registering new adapter (cx88[0])
[   11.796238] DVB: registering adapter 1 frontend 0 (Conexant CX24116/CX24118)...
[   12.067188] kjournald starting.  Commit interval 5 seconds
[   12.068421] EXT3 FS on md1, internal journal
[   12.068429] EXT3-fs: mounted filesystem with writeback data mode.
[   18.154464] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   18.154466] Bluetooth: BNEP filters: protocol multicast
[   18.176939] Bridge firewalling registered
[   18.272517] eth0: no IPv6 routers present
[   20.101836] lirc_dev: IR Remote Control driver registered, major 61 
[   20.661049] CPU0 attaching NULL sched-domain.
[   20.661055] CPU1 attaching NULL sched-domain.
[   20.672552] CPU0 attaching sched-domain:
[   20.672555]  domain 0: span 0-1 level MC
[   20.672557]   groups: 0 1
[   20.672560]   domain 1: span 0-1 level CPU
[   20.672562]    groups: 0-1 (__cpu_power = 2048)
[   20.672565] CPU1 attaching sched-domain:
[   20.672567]  domain 0: span 0-1 level MC
[   20.672569]   groups: 1 0
[   20.672571]   domain 1: span 0-1 level CPU
[   20.672573]    groups: 0-1 (__cpu_power = 2048)
[   81.500022] Clocksource tsc unstable (delta = -189284661 ns)
[   95.870879] cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...
[   95.870886] cx88_audio 0000:04:06.1: firmware: requesting dvb-fe-cx24116.fw
[   95.944922] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[  101.980080] cx24116_load_firmware: FW version 1.23.86.1
[  101.980090] cx24116_firmware_ondemand: Firmware upload complete
[  104.364519] f300_xfer: timeout, the slave no response
[  104.704023] f300_xfer: timeout, the slave no response
[  105.044030] f300_xfer: timeout, the slave no response
[  105.384517] f300_xfer: timeout, the slave no response
[  105.724518] f300_xfer: timeout, the slave no response
[  106.064516] f300_xfer: timeout, the slave no response
[  106.404837] f300_xfer: timeout, the slave no response
[  106.744034] f300_xfer: timeout, the slave no response
[  107.084029] f300_xfer: timeout, the slave no response
[  107.424522] f300_xfer: timeout, the slave no response
[  108.480033] f300_xfer: timeout, the slave no response
[  108.820519] f300_xfer: timeout, the slave no response
[  109.160518] f300_xfer: timeout, the slave no response
[  109.500518] f300_xfer: timeout, the slave no response
[  109.840021] f300_xfer: timeout, the slave no response
[  110.180520] f300_xfer: timeout, the slave no response
[  110.520519] f300_xfer: timeout, the slave no response
[  110.860034] f300_xfer: timeout, the slave no response
[  111.200026] f300_xfer: timeout, the slave no response
[  111.540686] f300_xfer: timeout, the slave no response

--------------010400050305040504080306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010400050305040504080306--
