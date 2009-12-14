Return-path: <linux-media-owner@vger.kernel.org>
Received: from nitrogen.vapor.com ([213.203.212.226]:42763 "EHLO
	nitrogen.vapor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753AbZLNXNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 18:13:49 -0500
Received: from firewall.vapor.com (ip-88-153-192-196.unitymediagroup.de [88.153.192.196])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 8002740C3B4
	for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 00:03:48 +0100 (CET)
Received: from [192.168.0.215] (ivymike.w [192.168.0.215])
	by firewall.vapor.com (Postfix) with ESMTP id 4A5565234AA
	for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 00:03:48 +0100 (CET)
Message-ID: <4B26C3FD.705@vapor.com>
Date: Tue, 15 Dec 2009 00:02:21 +0100
From: Oliver Wagner <owagner@vapor.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: budget_ci: "BUG: unable to handle kernel paging request"
References: <200912132327.28268.liplianin@me.by>
In-Reply-To: <200912132327.28268.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

a current build of http://mercurial.intuxication.org/hg/s2-liplianin
(changeset 13860:1944670e9fbe) yields a kernel paging error when
inserting budget_ci on a Ubuntu 9.10 system (2.6.31-16) with three
S2-3200 and one Tevii 470 cards:

Dec 14 23:35:54 tvserver kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec 14 23:35:54 tvserver kernel: [    0.000000] Initializing cgroup subsys cpu
Dec 14 23:35:54 tvserver kernel: [    0.000000] Linux version 2.6.31-16-generic (buildd@vernadsky) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #52-Ubuntu SMP Thu Dec 3 22:00:22 UTC 2009 (Ubuntu 2.6.31-16.52-generic)
Dec 14 23:35:54 tvserver kernel: [    0.000000] KERNEL supported cpus:
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Intel GenuineIntel
Dec 14 23:35:54 tvserver kernel: [    0.000000]   AMD AuthenticAMD
Dec 14 23:35:54 tvserver kernel: [    0.000000]   NSC Geode by NSC
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Cyrix CyrixInstead
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Centaur CentaurHauls
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Transmeta GenuineTMx86
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Transmeta TransmetaCPU
Dec 14 23:35:54 tvserver kernel: [    0.000000]   UMC UMC UMC UMC
Dec 14 23:35:54 tvserver kernel: [    0.000000] BIOS-provided physical RAM map:
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 00000000000e7000 - 0000000000100000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000] DMI present.
Dec 14 23:35:54 tvserver kernel: [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Dec 14 23:35:54 tvserver kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000] last_pfn = 0x7ffb0 max_arch_pfn = 0x100000
Dec 14 23:35:54 tvserver kernel: [    0.000000] MTRR default type: uncachable
Dec 14 23:35:54 tvserver kernel: [    0.000000] MTRR fixed ranges enabled:
Dec 14 23:35:54 tvserver kernel: [    0.000000]   00000-9FFFF write-back
Dec 14 23:35:54 tvserver kernel: [    0.000000]   A0000-EFFFF uncachable
Dec 14 23:35:54 tvserver kernel: [    0.000000]   F0000-FFFFF write-protect
Dec 14 23:35:54 tvserver kernel: [    0.000000] MTRR variable ranges enabled:
Dec 14 23:35:54 tvserver kernel: [    0.000000]   0 base 0000000000 mask FF80000000 write-back
Dec 14 23:35:54 tvserver kernel: [    0.000000]   1 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   2 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   3 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   4 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   5 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   6 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000]   7 disabled
Dec 14 23:35:54 tvserver kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Dec 14 23:35:54 tvserver kernel: [    0.000000] Scanning 0 areas for low memory corruption
Dec 14 23:35:54 tvserver kernel: [    0.000000] modified physical RAM map:
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 00000000000e7000 - 0000000000100000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 0000000000100000 - 000000007ffb0000 (usable)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 000000007fff0000 - 0000000080000000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
Dec 14 23:35:54 tvserver kernel: [    0.000000] initial memory mapped : 0 - 00c00000
Dec 14 23:35:54 tvserver kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
Dec 14 23:35:54 tvserver kernel: [    0.000000] Using x86 segment limits to approximate NX protection
Dec 14 23:35:54 tvserver kernel: [    0.000000]  0000000000 - 0000400000 page 4k
Dec 14 23:35:54 tvserver kernel: [    0.000000]  0000400000 - 0037400000 page 2M
Dec 14 23:35:54 tvserver kernel: [    0.000000]  0037400000 - 00377fe000 page 4k
Dec 14 23:35:54 tvserver kernel: [    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
Dec 14 23:35:54 tvserver kernel: [    0.000000] RAMDISK: 7f90b000 - 7ff7f1bd
Dec 14 23:35:54 tvserver kernel: [    0.000000] Allocated new RAMDISK: 008ad000 - 00f211bd
Dec 14 23:35:54 tvserver kernel: [    0.000000] Move RAMDISK from 000000007f90b000 - 000000007ff7f1bc to 008ad000 - 00f211bc
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: RSDP 000fa830 00014 (v00 ACPIAM)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: RSDT 7ffb0000 00040 (v01 A_M_I  OEMRSDT  11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: FACP 7ffb0200 00084 (v02 A M I  OEMFACP  12000601 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: DSDT 7ffb0450 0489F (v01  AS155 AS155113 00000113 INTL 20051117)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: FACS 7ffc0000 00040
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: APIC 7ffb0390 00080 (v01 A_M_I  OEMAPIC  11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: MCFG 7ffb0410 0003C (v01 A_M_I  OEMMCFG  11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: OEMB 7ffc0040 00060 (v01 A_M_I  AMI_OEM  11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: AAFT 7ffb4cf0 00027 (v01 A_M_I  OEMAAFT  11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: HPET 7ffb4d20 00038 (v01 A_M_I  OEMHPET0 11000821 MSFT 00000097)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: SSDT 7ffb4d60 0028A (v01 A M I  POWERNOW 00000001 AMD  00000001)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec 14 23:35:54 tvserver kernel: [    0.000000] 1159MB HIGHMEM available.
Dec 14 23:35:54 tvserver kernel: [    0.000000] 887MB LOWMEM available.
Dec 14 23:35:54 tvserver kernel: [    0.000000]   mapped low ram: 0 - 377fe000
Dec 14 23:35:54 tvserver kernel: [    0.000000]   low ram: 0 - 377fe000
Dec 14 23:35:54 tvserver kernel: [    0.000000]   node 0 low ram: 00000000 - 377fe000
Dec 14 23:35:54 tvserver kernel: [    0.000000]   node 0 bootmap 00011000 - 00017f00
Dec 14 23:35:54 tvserver kernel: [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #3 [0000100000 - 00008a80a0]    TEXT DATA BSS ==> [0000100000 - 00008a80a0]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #5 [00008a9000 - 00008ac12f]              BRK ==> [00008a9000 - 00008ac12f]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #7 [00008ad000 - 0000f211bd]      NEW RAMDISK ==> [00008ad000 - 0000f211bd]
Dec 14 23:35:54 tvserver kernel: [    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==> [0000011000 - 0000018000]
Dec 14 23:35:54 tvserver kernel: [    0.000000] found SMP MP-table at [c00ff780] ff780
Dec 14 23:35:54 tvserver kernel: [    0.000000] Zone PFN ranges:
Dec 14 23:35:54 tvserver kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Dec 14 23:35:54 tvserver kernel: [    0.000000]   HighMem  0x000377fe -> 0x0007ffb0
Dec 14 23:35:54 tvserver kernel: [    0.000000] Movable zone start PFN for each node
Dec 14 23:35:54 tvserver kernel: [    0.000000] early_node_map[2] active PFN ranges
Dec 14 23:35:54 tvserver kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Dec 14 23:35:54 tvserver kernel: [    0.000000]     0: 0x00000100 -> 0x0007ffb0
Dec 14 23:35:54 tvserver kernel: [    0.000000] On node 0 totalpages: 524095
Dec 14 23:35:54 tvserver kernel: [    0.000000] free_area_init_node: node 0, pgdat c0784940, node_mem_map c1000200
Dec 14 23:35:54 tvserver kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Dec 14 23:35:54 tvserver kernel: [    0.000000]   DMA zone: 0 pages reserved
Dec 14 23:35:54 tvserver kernel: [    0.000000]   DMA zone: 3951 pages, LIFO batch:0
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Normal zone: 1744 pages used for memmap
Dec 14 23:35:54 tvserver kernel: [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
Dec 14 23:35:54 tvserver kernel: [    0.000000]   HighMem zone: 2320 pages used for memmap
Dec 14 23:35:54 tvserver kernel: [    0.000000]   HighMem zone: 294562 pages, LIFO batch:31
Dec 14 23:35:54 tvserver kernel: [    0.000000] Using APIC driver default
Dec 14 23:35:54 tvserver kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Dec 14 23:35:54 tvserver kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IRQ0 used by override.
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IRQ2 used by override.
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IRQ9 used by override.
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IRQ14 used by override.
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: IRQ15 used by override.
Dec 14 23:35:54 tvserver kernel: [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
Dec 14 23:35:54 tvserver kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec 14 23:35:54 tvserver kernel: [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
Dec 14 23:35:54 tvserver kernel: [    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
Dec 14 23:35:54 tvserver kernel: [    0.000000] nr_irqs_gsi: 24
Dec 14 23:35:54 tvserver kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Dec 14 23:35:54 tvserver kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e7000
Dec 14 23:35:54 tvserver kernel: [    0.000000] PM: Registered nosave memory: 00000000000e7000 - 0000000000100000
Dec 14 23:35:54 tvserver kernel: [    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Dec 14 23:35:54 tvserver kernel: [    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
Dec 14 23:35:54 tvserver kernel: [    0.000000] PERCPU: Embedded 14 pages at c200a000, static data 35612 bytes
Dec 14 23:35:54 tvserver kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519999
Dec 14 23:35:54 tvserver kernel: [    0.000000] Kernel command line: root=/dev/nfs initrd=initrd.img-2.6.31-16-generic nfsroot=192.168.0.1:/nfsroot/tvserver,udp ip=dhcp BOOT_IMAGE=vmlinuz-2.6.31-16-generic auto
Dec 14 23:35:54 tvserver kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.000000] Enabling fast FPU save and restore... done.
Dec 14 23:35:54 tvserver kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Dec 14 23:35:54 tvserver kernel: [    0.000000] Initializing CPU#0
Dec 14 23:35:54 tvserver kernel: [    0.000000] allocated 10483840 bytes of page_cgroup
Dec 14 23:35:54 tvserver kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Dec 14 23:35:54 tvserver kernel: [    0.000000] Initializing HighMem for node 0 (000377fe:0007ffb0)
Dec 14 23:35:54 tvserver kernel: [    0.000000] Memory: 2053264k/2096832k available (4566k kernel code, 42172k reserved, 2142k data, 540k init, 1187528k highmem)
Dec 14 23:35:54 tvserver kernel: [    0.000000] virtual kernel memory layout:
Dec 14 23:35:54 tvserver kernel: [    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]       .init : 0xc078e000 - 0xc0815000   ( 540 kB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]       .data : 0xc0575b94 - 0xc078d3c8   (2142 kB)
Dec 14 23:35:54 tvserver kernel: [    0.000000]       .text : 0xc0100000 - 0xc0575b94   (4566 kB)
Dec 14 23:35:54 tvserver kernel: [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Dec 14 23:35:54 tvserver kernel: [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Dec 14 23:35:54 tvserver kernel: [    0.000000] NR_IRQS:2304 nr_irqs:440
Dec 14 23:35:54 tvserver kernel: [    0.000000] Fast TSC calibration using PIT
Dec 14 23:35:54 tvserver kernel: [    0.000000] Detected 2511.656 MHz processor.
Dec 14 23:35:54 tvserver kernel: [    0.000012] spurious 8259A interrupt: IRQ7.
Dec 14 23:35:54 tvserver kernel: [    0.000043] Console: colour dummy device 80x25
Dec 14 23:35:54 tvserver kernel: [    0.000045] console [tty0] enabled
Dec 14 23:35:54 tvserver kernel: [    0.000493] hpet clockevent registered
Dec 14 23:35:54 tvserver kernel: [    0.000496] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Dec 14 23:35:54 tvserver kernel: [    0.000505] Calibrating delay loop (skipped), value calculated using timer frequency.. 5023.31 BogoMIPS (lpj=10046624)
Dec 14 23:35:54 tvserver kernel: [    0.000528] Security Framework initialized
Dec 14 23:35:54 tvserver kernel: [    0.000548] AppArmor: AppArmor initialized
Dec 14 23:35:54 tvserver kernel: [    0.000556] Mount-cache hash table entries: 512
Dec 14 23:35:54 tvserver kernel: [    0.000678] Initializing cgroup subsys ns
Dec 14 23:35:54 tvserver kernel: [    0.000684] Initializing cgroup subsys cpuacct
Dec 14 23:35:54 tvserver kernel: [    0.000690] Initializing cgroup subsys memory
Dec 14 23:35:54 tvserver kernel: [    0.000697] Initializing cgroup subsys freezer
Dec 14 23:35:54 tvserver kernel: [    0.000701] Initializing cgroup subsys net_cls
Dec 14 23:35:54 tvserver kernel: [    0.000714] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Dec 14 23:35:54 tvserver kernel: [    0.000719] CPU: L2 Cache: 512K (64 bytes/line)
Dec 14 23:35:54 tvserver kernel: [    0.000723] CPU: Physical Processor ID: 0
Dec 14 23:35:54 tvserver kernel: [    0.000726] CPU: Processor Core ID: 0
Dec 14 23:35:54 tvserver kernel: [    0.000732] mce: CPU supports 5 MCE banks
Dec 14 23:35:54 tvserver kernel: [    0.000742] using C1E aware idle routine
Dec 14 23:35:54 tvserver kernel: [    0.000751] Performance Counters: AMD PMU driver.
Dec 14 23:35:54 tvserver kernel: [    0.000758] ... version:                 0
Dec 14 23:35:54 tvserver kernel: [    0.000761] ... bit width:               48
Dec 14 23:35:54 tvserver kernel: [    0.000765] ... generic counters:        4
Dec 14 23:35:54 tvserver kernel: [    0.000768] ... value mask:              0000ffffffffffff
Dec 14 23:35:54 tvserver kernel: [    0.000772] ... max period:              00007fffffffffff
Dec 14 23:35:54 tvserver kernel: [    0.000775] ... fixed-purpose counters:  0
Dec 14 23:35:54 tvserver kernel: [    0.000779] ... counter mask:            000000000000000f
Dec 14 23:35:54 tvserver kernel: [    0.000785] Checking 'hlt' instruction... OK.
Dec 14 23:35:54 tvserver kernel: [    0.017842] ACPI: Core revision 20090521
Dec 14 23:35:54 tvserver kernel: [    0.024528] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec 14 23:35:54 tvserver kernel: [    0.064425] CPU0: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
Dec 14 23:35:54 tvserver kernel: [    0.068001] Booting processor 1 APIC 0x1 ip 0x6000
Dec 14 23:35:54 tvserver kernel: [    0.004000] Initializing CPU#1
Dec 14 23:35:54 tvserver kernel: [    0.004000] Calibrating delay using timer specific routine.. 5022.77 BogoMIPS (lpj=10045540)
Dec 14 23:35:54 tvserver kernel: [    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Dec 14 23:35:54 tvserver kernel: [    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
Dec 14 23:35:54 tvserver kernel: [    0.004000] CPU: Physical Processor ID: 0
Dec 14 23:35:54 tvserver kernel: [    0.004000] CPU: Processor Core ID: 1
Dec 14 23:35:54 tvserver kernel: [    0.004000] mce: CPU supports 5 MCE banks
Dec 14 23:35:54 tvserver kernel: [    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Dec 14 23:35:54 tvserver kernel: [    0.152470] CPU1: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
Dec 14 23:35:54 tvserver kernel: [    0.152513] Brought up 2 CPUs
Dec 14 23:35:54 tvserver kernel: [    0.152517] Total of 2 processors activated (10046.08 BogoMIPS).
Dec 14 23:35:54 tvserver kernel: [    0.152512] System has AMD C1E enabled
Dec 14 23:35:54 tvserver kernel: [    0.152512] Switch to broadcast mode on CPU1
Dec 14 23:35:54 tvserver kernel: [    0.152608] CPU0 attaching sched-domain:
Dec 14 23:35:54 tvserver kernel: [    0.152611]  domain 0: span 0-1 level MC
Dec 14 23:35:54 tvserver kernel: [    0.152614]   groups: 0 1
Dec 14 23:35:54 tvserver kernel: [    0.152619] CPU1 attaching sched-domain:
Dec 14 23:35:54 tvserver rsyslogd-2039: Could no open output file '/dev/xconsole' [try http://www.rsyslog.com/e/2039 ]
Dec 14 23:35:54 tvserver kernel: [    0.152621]  domain 0: span 0-1 level MC
Dec 14 23:35:54 tvserver kernel: [    0.152623]   groups: 1 0
Dec 14 23:35:54 tvserver kernel: [    0.152686] Switch to broadcast mode on CPU0
Dec 14 23:35:54 tvserver kernel: [    0.152686] Booting paravirtualized kernel on bare hardware
Dec 14 23:35:54 tvserver kernel: [    0.152686] regulator: core version 0.5
Dec 14 23:35:54 tvserver kernel: [    0.152686] Time: 22:35:46  Date: 12/14/09
Dec 14 23:35:54 tvserver kernel: [    0.152686] NET: Registered protocol family 16
Dec 14 23:35:54 tvserver kernel: [    0.152686] EISA bus registered
Dec 14 23:35:54 tvserver kernel: [    0.152686] ACPI: bus type pci registered
Dec 14 23:35:54 tvserver kernel: [    0.152686] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 14 23:35:54 tvserver kernel: [    0.152686] PCI: Not using MMCONFIG.
Dec 14 23:35:54 tvserver kernel: [    0.153030] PCI: Using configuration type 1 for base access
Dec 14 23:35:54 tvserver kernel: [    0.153825] bio: create slab <bio-0> at 0
Dec 14 23:35:54 tvserver kernel: [    0.153825] ACPI: EC: Look up EC in DSDT
Dec 14 23:35:54 tvserver kernel: [    0.161615] ACPI: Interpreter enabled
Dec 14 23:35:54 tvserver kernel: [    0.161622] ACPI: (supports S0 S1 S3 S4 S5)
Dec 14 23:35:54 tvserver kernel: [    0.161643] ACPI: Using IOAPIC for interrupt routing
Dec 14 23:35:54 tvserver kernel: [    0.161684] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
Dec 14 23:35:54 tvserver kernel: [    0.165164] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
Dec 14 23:35:54 tvserver kernel: [    0.165170] PCI: Using MMCONFIG for extended config space
Dec 14 23:35:54 tvserver kernel: [    0.170638] ACPI: No dock devices found.
Dec 14 23:35:54 tvserver kernel: [    0.170860] ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec 14 23:35:54 tvserver kernel: [    0.171070] pci 0000:00:01.1: reg 10 io port: [0xec00-0xec3f]
Dec 14 23:35:54 tvserver kernel: [    0.171080] pci 0000:00:01.1: reg 20 io port: [0x5000-0x503f]
Dec 14 23:35:54 tvserver kernel: [    0.171084] pci 0000:00:01.1: reg 24 io port: [0x6000-0x603f]
Dec 14 23:35:54 tvserver kernel: [    0.171102] pci 0000:00:01.1: PME# supported from D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171110] pci 0000:00:01.1: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171157] pci 0000:00:02.0: reg 10 32bit mmio: [0xdfcff000-0xdfcfffff]
Dec 14 23:35:54 tvserver kernel: [    0.171178] pci 0000:00:02.0: supports D1 D2
Dec 14 23:35:54 tvserver kernel: [    0.171180] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171185] pci 0000:00:02.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171208] pci 0000:00:02.1: reg 10 32bit mmio: [0xdfcfec00-0xdfcfecff]
Dec 14 23:35:54 tvserver kernel: [    0.171234] pci 0000:00:02.1: supports D1 D2
Dec 14 23:35:54 tvserver kernel: [    0.171235] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171241] pci 0000:00:02.1: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171301] pci 0000:00:07.0: reg 10 32bit mmio: [0xdfcfd000-0xdfcfdfff]
Dec 14 23:35:54 tvserver kernel: [    0.171305] pci 0000:00:07.0: reg 14 io port: [0xe480-0xe487]
Dec 14 23:35:54 tvserver kernel: [    0.171326] pci 0000:00:07.0: supports D1 D2
Dec 14 23:35:54 tvserver kernel: [    0.171328] pci 0000:00:07.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171334] pci 0000:00:07.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171368] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171372] pci 0000:00:09.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171404] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171409] pci 0000:00:0b.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171440] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
Dec 14 23:35:54 tvserver kernel: [    0.171444] pci 0000:00:0c.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171542] pci 0000:01:08.0: reg 10 32bit mmio: [0xdfdffc00-0xdfdffdff]
Dec 14 23:35:54 tvserver kernel: [    0.171579] pci 0000:01:09.0: reg 10 32bit mmio: [0xdfdff800-0xdfdff9ff]
Dec 14 23:35:54 tvserver kernel: [    0.171616] pci 0000:01:0a.0: reg 10 32bit mmio: [0xdfdff400-0xdfdff5ff]
Dec 14 23:35:54 tvserver kernel: [    0.171660] pci 0000:00:04.0: transparent bridge
Dec 14 23:35:54 tvserver kernel: [    0.171666] pci 0000:00:04.0: bridge 32bit mmio: [0xdfd00000-0xdfdfffff]
Dec 14 23:35:54 tvserver kernel: [    0.171768] pci 0000:04:00.0: reg 10 64bit mmio: [0xdfe00000-0xdfffffff]
Dec 14 23:35:54 tvserver kernel: [    0.171823] pci 0000:04:00.0: supports D1 D2
Dec 14 23:35:54 tvserver kernel: [    0.171825] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot
Dec 14 23:35:54 tvserver kernel: [    0.171831] pci 0000:04:00.0: PME# disabled
Dec 14 23:35:54 tvserver kernel: [    0.171879] pci 0000:00:0c.0: bridge 32bit mmio: [0xdfe00000-0xdfffffff]
Dec 14 23:35:54 tvserver kernel: [    0.171888] pci_bus 0000:00: on NUMA node 0
Dec 14 23:35:54 tvserver kernel: [    0.171892] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Dec 14 23:35:54 tvserver kernel: [    0.172051] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Dec 14 23:35:54 tvserver kernel: [    0.172139] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
Dec 14 23:35:54 tvserver kernel: [    0.172191] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
Dec 14 23:35:54 tvserver kernel: [    0.172242] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
Dec 14 23:35:54 tvserver kernel: [    0.176899] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
Dec 14 23:35:54 tvserver kernel: [    0.177057] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *11
Dec 14 23:35:54 tvserver kernel: [    0.177213] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *5
Dec 14 23:35:54 tvserver kernel: [    0.177368] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.177524] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *14
Dec 14 23:35:54 tvserver kernel: [    0.177679] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.177839] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.177996] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.178152] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *11
Dec 14 23:35:54 tvserver kernel: [    0.178307] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *5
Dec 14 23:35:54 tvserver kernel: [    0.178462] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *7
Dec 14 23:35:54 tvserver kernel: [    0.178618] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *14
Dec 14 23:35:54 tvserver kernel: [    0.178773] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.178929] ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.179086] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *10
Dec 14 23:35:54 tvserver kernel: [    0.179241] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.179397] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.179553] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.179737] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
Dec 14 23:35:54 tvserver kernel: [    0.179897] SCSI subsystem initialized
Dec 14 23:35:54 tvserver kernel: [    0.179943] libata version 3.00 loaded.
Dec 14 23:35:54 tvserver kernel: [    0.180068] usbcore: registered new interface driver usbfs
Dec 14 23:35:54 tvserver kernel: [    0.180085] usbcore: registered new interface driver hub
Dec 14 23:35:54 tvserver kernel: [    0.180108] usbcore: registered new device driver usb
Dec 14 23:35:54 tvserver kernel: [    0.180219] ACPI: WMI: Mapper loaded
Dec 14 23:35:54 tvserver kernel: [    0.180223] PCI: Using ACPI for IRQ routing
Dec 14 23:35:54 tvserver kernel: [    0.192008] Bluetooth: Core ver 2.15
Dec 14 23:35:54 tvserver kernel: [    0.192025] NET: Registered protocol family 31
Dec 14 23:35:54 tvserver kernel: [    0.192025] Bluetooth: HCI device and connection manager initialized
Dec 14 23:35:54 tvserver kernel: [    0.192025] Bluetooth: HCI socket layer initialized
Dec 14 23:35:54 tvserver kernel: [    0.192025] NetLabel: Initializing
Dec 14 23:35:54 tvserver kernel: [    0.192027] NetLabel:  domain hash size = 128
Dec 14 23:35:54 tvserver kernel: [    0.192031] NetLabel:  protocols = UNLABELED CIPSOv4
Dec 14 23:35:54 tvserver kernel: [    0.192045] NetLabel:  unlabeled traffic allowed by default
Dec 14 23:35:54 tvserver kernel: [    0.192075] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
Dec 14 23:35:54 tvserver kernel: [    0.192083] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Dec 14 23:35:54 tvserver kernel: [    0.204027] Switched to high resolution mode on CPU 0
Dec 14 23:35:54 tvserver kernel: [    0.204037] Switched to high resolution mode on CPU 1
Dec 14 23:35:54 tvserver kernel: [    0.212143] pnp: PnP ACPI init
Dec 14 23:35:54 tvserver kernel: [    0.212167] ACPI: bus type pnp registered
Dec 14 23:35:54 tvserver kernel: [    0.215342] pnp: PnP ACPI: found 12 devices
Dec 14 23:35:54 tvserver kernel: [    0.215346] ACPI: ACPI bus type pnp unregistered
Dec 14 23:35:54 tvserver kernel: [    0.215351] PnPBIOS: Disabled by ACPI PNP
Dec 14 23:35:54 tvserver kernel: [    0.215368] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215373] system 00:05: ioport range 0x800-0x80f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215377] system 00:05: ioport range 0x4000-0x407f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215382] system 00:05: ioport range 0x4080-0x40ff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215387] system 00:05: ioport range 0x4400-0x447f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215392] system 00:05: ioport range 0x4480-0x44ff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215397] system 00:05: ioport range 0x4800-0x487f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215401] system 00:05: ioport range 0x4880-0x48ff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215406] system 00:05: ioport range 0x2000-0x207f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215411] system 00:05: ioport range 0x2080-0x20ff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215416] system 00:05: iomem range 0xfec80000-0xfd93ffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215423] system 00:05: iomem range 0xfefe0000-0xfefe01ff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215428] system 00:05: iomem range 0xfefe1000-0xfefe1fff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215433] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215441] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215447] system 00:07: iomem range 0xfee00000-0xfee00fff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215454] system 00:09: ioport range 0x290-0x29f has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215461] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
Dec 14 23:35:54 tvserver kernel: [    0.215469] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215473] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215478] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215483] system 00:0b: iomem range 0x100000-0x7fffffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.215489] system 00:0b: iomem range 0xff380000-0xffffffff could not be reserved
Dec 14 23:35:54 tvserver kernel: [    0.250143] AppArmor: AppArmor Filesystem Enabled
Dec 14 23:35:54 tvserver kernel: [    0.250169] pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
Dec 14 23:35:54 tvserver kernel: [    0.250174] pci 0000:00:04.0:   IO window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250180] pci 0000:00:04.0:   MEM window: 0xdfd00000-0xdfdfffff
Dec 14 23:35:54 tvserver kernel: [    0.250184] pci 0000:00:04.0:   PREFETCH window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250190] pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
Dec 14 23:35:54 tvserver kernel: [    0.250193] pci 0000:00:09.0:   IO window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250198] pci 0000:00:09.0:   MEM window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250201] pci 0000:00:09.0:   PREFETCH window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250206] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
Dec 14 23:35:54 tvserver kernel: [    0.250210] pci 0000:00:0b.0:   IO window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250214] pci 0000:00:0b.0:   MEM window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250218] pci 0000:00:0b.0:   PREFETCH window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250223] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
Dec 14 23:35:54 tvserver kernel: [    0.250226] pci 0000:00:0c.0:   IO window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250231] pci 0000:00:0c.0:   MEM window: 0xdfe00000-0xdfffffff
Dec 14 23:35:54 tvserver kernel: [    0.250235] pci 0000:00:0c.0:   PREFETCH window: disabled
Dec 14 23:35:54 tvserver kernel: [    0.250245] pci 0000:00:04.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.250250] pci 0000:00:09.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.250254] pci 0000:00:0b.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.250258] pci 0000:00:0c.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.250262] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Dec 14 23:35:54 tvserver kernel: [    0.250264] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
Dec 14 23:35:54 tvserver kernel: [    0.250267] pci_bus 0000:01: resource 1 mem: [0xdfd00000-0xdfdfffff]
Dec 14 23:35:54 tvserver kernel: [    0.250269] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
Dec 14 23:35:54 tvserver kernel: [    0.250271] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
Dec 14 23:35:54 tvserver kernel: [    0.250274] pci_bus 0000:04: resource 1 mem: [0xdfe00000-0xdfffffff]
Dec 14 23:35:54 tvserver kernel: [    0.250308] NET: Registered protocol family 2
Dec 14 23:35:54 tvserver kernel: [    0.250398] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.250699] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.251329] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.251634] TCP: Hash tables configured (established 131072 bind 65536)
Dec 14 23:35:54 tvserver kernel: [    0.251640] TCP reno registered
Dec 14 23:35:54 tvserver kernel: [    0.251736] NET: Registered protocol family 1
Dec 14 23:35:54 tvserver kernel: [    0.251805] Trying to unpack rootfs image as initramfs...
Dec 14 23:35:54 tvserver kernel: [    0.401092] Freeing initrd memory: 6608k freed
Dec 14 23:35:54 tvserver kernel: [    0.404792] cpufreq-nforce2: No nForce2 chipset.
Dec 14 23:35:54 tvserver kernel: [    0.404824] Scanning for low memory corruption every 60 seconds
Dec 14 23:35:54 tvserver kernel: [    0.404919] audit: initializing netlink socket (disabled)
Dec 14 23:35:54 tvserver kernel: [    0.404936] type=2000 audit(1260830146.404:1): initialized
Dec 14 23:35:54 tvserver kernel: [    0.412318] highmem bounce pool size: 64 pages
Dec 14 23:35:54 tvserver kernel: [    0.412327] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Dec 14 23:35:54 tvserver kernel: [    0.413467] VFS: Disk quotas dquot_6.5.2
Dec 14 23:35:54 tvserver kernel: [    0.413519] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Dec 14 23:35:54 tvserver kernel: [    0.413981] fuse init (API version 7.12)
Dec 14 23:35:54 tvserver kernel: [    0.414048] msgmni has been set to 1705
Dec 14 23:35:54 tvserver kernel: [    0.414281] alg: No test for stdrng (krng)
Dec 14 23:35:54 tvserver kernel: [    0.414306] io scheduler noop registered
Dec 14 23:35:54 tvserver kernel: [    0.414310] io scheduler anticipatory registered
Dec 14 23:35:54 tvserver kernel: [    0.414314] io scheduler deadline registered
Dec 14 23:35:54 tvserver kernel: [    0.414350] io scheduler cfq registered (default)
Dec 14 23:35:54 tvserver kernel: [    0.414460] pci 0000:00:00.0: Found enabled HT MSI Mapping
Dec 14 23:35:54 tvserver kernel: [    0.414510] pci 0000:00:00.0: Found enabled HT MSI Mapping
Dec 14 23:35:54 tvserver kernel: [    0.414562] pci 0000:00:00.0: Found enabled HT MSI Mapping
Dec 14 23:35:54 tvserver kernel: [    0.414619] pci 0000:00:00.0: Found enabled HT MSI Mapping
Dec 14 23:35:54 tvserver kernel: [    0.414679] pci 0000:00:00.0: Found enabled HT MSI Mapping
Dec 14 23:35:54 tvserver kernel: [    0.414768]   alloc irq_desc for 24 on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414770]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414779] pcieport-driver 0000:00:09.0: irq 24 for MSI/MSI-X
Dec 14 23:35:54 tvserver kernel: [    0.414784] pcieport-driver 0000:00:09.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.414843]   alloc irq_desc for 25 on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414845]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414849] pcieport-driver 0000:00:0b.0: irq 25 for MSI/MSI-X
Dec 14 23:35:54 tvserver kernel: [    0.414853] pcieport-driver 0000:00:0b.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.414911]   alloc irq_desc for 26 on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414912]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    0.414917] pcieport-driver 0000:00:0c.0: irq 26 for MSI/MSI-X
Dec 14 23:35:54 tvserver kernel: [    0.414920] pcieport-driver 0000:00:0c.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.414974] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Dec 14 23:35:54 tvserver kernel: [    0.414997] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Dec 14 23:35:54 tvserver kernel: [    0.415107] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Dec 14 23:35:54 tvserver kernel: [    0.415114] ACPI: Power Button [PWRF]
Dec 14 23:35:54 tvserver kernel: [    0.415166] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Dec 14 23:35:54 tvserver kernel: [    0.415173] ACPI: Power Button [PWRB]
Dec 14 23:35:54 tvserver kernel: [    0.415391] ACPI: processor limited to max C-state 1
Dec 14 23:35:54 tvserver kernel: [    0.415416] processor LNXCPU:00: registered as cooling_device0
Dec 14 23:35:54 tvserver kernel: [    0.415445] processor LNXCPU:01: registered as cooling_device1
Dec 14 23:35:54 tvserver kernel: [    0.418220] isapnp: Scanning for PnP cards...
Dec 14 23:35:54 tvserver kernel: [    0.770929] isapnp: No Plug & Play device found
Dec 14 23:35:54 tvserver kernel: [    0.771919] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Dec 14 23:35:54 tvserver kernel: [    0.772944] brd: module loaded
Dec 14 23:35:54 tvserver kernel: [    0.773318] loop: module loaded
Dec 14 23:35:54 tvserver kernel: [    0.773383] input: Macintosh mouse button emulation as /devices/virtual/input/input2
Dec 14 23:35:54 tvserver kernel: [    0.774169] Fixed MDIO Bus: probed
Dec 14 23:35:54 tvserver kernel: [    0.774202] PPP generic driver version 2.4.2
Dec 14 23:35:54 tvserver kernel: [    0.774268] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Dec 14 23:35:54 tvserver kernel: [    0.774560] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
Dec 14 23:35:54 tvserver kernel: [    0.774568]   alloc irq_desc for 23 on node -1
Dec 14 23:35:54 tvserver kernel: [    0.774569]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    0.774580] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 23 (level, low) -> IRQ 23
Dec 14 23:35:54 tvserver kernel: [    0.774597] ehci_hcd 0000:00:02.1: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.774600] ehci_hcd 0000:00:02.1: EHCI Host Controller
Dec 14 23:35:54 tvserver kernel: [    0.774654] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
Dec 14 23:35:54 tvserver kernel: [    0.774685] ehci_hcd 0000:00:02.1: debug port 1
Dec 14 23:35:54 tvserver kernel: [    0.774691] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
Dec 14 23:35:54 tvserver kernel: [    0.774711] ehci_hcd 0000:00:02.1: irq 23, io mem 0xdfcfec00
Dec 14 23:35:54 tvserver kernel: [    0.784145] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
Dec 14 23:35:54 tvserver kernel: [    0.784212] usb usb1: configuration #1 chosen from 1 choice
Dec 14 23:35:54 tvserver kernel: [    0.784248] hub 1-0:1.0: USB hub found
Dec 14 23:35:54 tvserver kernel: [    0.784258] hub 1-0:1.0: 10 ports detected
Dec 14 23:35:54 tvserver kernel: [    0.784318] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Dec 14 23:35:54 tvserver kernel: [    0.784551] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
Dec 14 23:35:54 tvserver kernel: [    0.784557]   alloc irq_desc for 22 on node -1
Dec 14 23:35:54 tvserver kernel: [    0.784558]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    0.784566] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
Dec 14 23:35:54 tvserver kernel: [    0.784576] ohci_hcd 0000:00:02.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    0.784579] ohci_hcd 0000:00:02.0: OHCI Host Controller
Dec 14 23:35:54 tvserver kernel: [    0.784611] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
Dec 14 23:35:54 tvserver kernel: [    0.784636] ohci_hcd 0000:00:02.0: irq 22, io mem 0xdfcff000
Dec 14 23:35:54 tvserver kernel: [    0.842109] usb usb2: configuration #1 chosen from 1 choice
Dec 14 23:35:54 tvserver kernel: [    0.842132] hub 2-0:1.0: USB hub found
Dec 14 23:35:54 tvserver kernel: [    0.842142] hub 2-0:1.0: 10 ports detected
Dec 14 23:35:54 tvserver kernel: [    0.842193] uhci_hcd: USB Universal Host Controller Interface driver
Dec 14 23:35:54 tvserver kernel: [    0.842268] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Dec 14 23:35:54 tvserver kernel: [    0.842273] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Dec 14 23:35:54 tvserver kernel: [    0.842677] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec 14 23:35:54 tvserver kernel: [    0.842727] mice: PS/2 mouse device common for all mice
Dec 14 23:35:54 tvserver kernel: [    0.842810] rtc_cmos 00:02: RTC can wake from S4
Dec 14 23:35:54 tvserver kernel: [    0.842842] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
Dec 14 23:35:54 tvserver kernel: [    0.842883] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
Dec 14 23:35:54 tvserver kernel: [    0.842969] device-mapper: uevent: version 1.0.3
Dec 14 23:35:54 tvserver kernel: [    0.843087] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Dec 14 23:35:54 tvserver kernel: [    0.843210] device-mapper: multipath: version 1.1.0 loaded
Dec 14 23:35:54 tvserver kernel: [    0.843215] device-mapper: multipath round-robin: version 1.0.0 loaded
Dec 14 23:35:54 tvserver kernel: [    0.843332] EISA: Probing bus 0 at eisa.0
Dec 14 23:35:54 tvserver kernel: [    0.843341] Cannot allocate resource for EISA slot 2
Dec 14 23:35:54 tvserver kernel: [    0.843347] Cannot allocate resource for EISA slot 4
Dec 14 23:35:54 tvserver kernel: [    0.843352] Cannot allocate resource for EISA slot 5
Dec 14 23:35:54 tvserver kernel: [    0.843355] Cannot allocate resource for EISA slot 6
Dec 14 23:35:54 tvserver kernel: [    0.843363] EISA: Detected 0 cards.
Dec 14 23:35:54 tvserver kernel: [    0.843507] cpuidle: using governor ladder
Dec 14 23:35:54 tvserver kernel: [    0.843511] cpuidle: using governor menu
Dec 14 23:35:54 tvserver kernel: [    0.843920] TCP cubic registered
Dec 14 23:35:54 tvserver kernel: [    0.844060] NET: Registered protocol family 10
Dec 14 23:35:54 tvserver kernel: [    0.844458] lo: Disabled Privacy Extensions
Dec 14 23:35:54 tvserver kernel: [    0.844714] NET: Registered protocol family 17
Dec 14 23:35:54 tvserver kernel: [    0.844731] Bluetooth: L2CAP ver 2.13
Dec 14 23:35:54 tvserver kernel: [    0.844735] Bluetooth: L2CAP socket layer initialized
Dec 14 23:35:54 tvserver kernel: [    0.844739] Bluetooth: SCO (Voice Link) ver 0.6
Dec 14 23:35:54 tvserver kernel: [    0.844742] Bluetooth: SCO socket layer initialized
Dec 14 23:35:54 tvserver kernel: [    0.844790] Bluetooth: RFCOMM TTY layer initialized
Dec 14 23:35:54 tvserver kernel: [    0.844795] Bluetooth: RFCOMM socket layer initialized
Dec 14 23:35:54 tvserver kernel: [    0.844799] Bluetooth: RFCOMM ver 1.11
Dec 14 23:35:54 tvserver kernel: [    0.844819] powernow-k8: Found 1 AMD Athlon(tm) Dual Core Processor 4850e processors (2 cpu cores) (version 2.20.00)
Dec 14 23:35:54 tvserver kernel: [    0.844866] powernow-k8:    0 : fid 0x11 (2500 MHz), vid 0x10
Dec 14 23:35:54 tvserver kernel: [    0.844870] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0x11
Dec 14 23:35:54 tvserver kernel: [    0.844875] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0x13
Dec 14 23:35:54 tvserver kernel: [    0.844879] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x15
Dec 14 23:35:54 tvserver kernel: [    0.844883] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x15
Dec 14 23:35:54 tvserver kernel: [    0.844888] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x16
Dec 14 23:35:54 tvserver kernel: [    0.844929] Using IPI No-Shortcut mode
Dec 14 23:35:54 tvserver kernel: [    0.844984] PM: Resume from disk failed.
Dec 14 23:35:54 tvserver kernel: [    0.844996] registered taskstats version 1
Dec 14 23:35:54 tvserver kernel: [    0.845091]   Magic number: 5:453:603
Dec 14 23:35:54 tvserver kernel: [    0.845137] pci_link PNP0C0F:0f: hash matches
Dec 14 23:35:54 tvserver kernel: [    0.845198] rtc_cmos 00:02: setting system clock to 2009-12-14 22:35:47 UTC (1260830147)
Dec 14 23:35:54 tvserver kernel: [    0.845204] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Dec 14 23:35:54 tvserver kernel: [    0.845208] EDD information not available.
Dec 14 23:35:54 tvserver kernel: [    0.845266] Freeing unused kernel memory: 540k freed
Dec 14 23:35:54 tvserver kernel: [    0.845663] Write protecting the kernel text: 4568k
Dec 14 23:35:54 tvserver kernel: [    0.845699] Write protecting the kernel read-only data: 1836k
Dec 14 23:35:54 tvserver kernel: [    1.013858] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
Dec 14 23:35:54 tvserver kernel: [    1.014164] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
Dec 14 23:35:54 tvserver kernel: [    1.014172]   alloc irq_desc for 21 on node -1
Dec 14 23:35:54 tvserver kernel: [    1.014174]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    1.014186] forcedeth 0000:00:07.0: PCI INT A -> Link[LMAC] -> GSI 21 (level, low) -> IRQ 21
Dec 14 23:35:54 tvserver kernel: [    1.014194] forcedeth 0000:00:07.0: setting latency timer to 64
Dec 14 23:35:54 tvserver kernel: [    1.533651] forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:66:8a:5c:db
Dec 14 23:35:54 tvserver kernel: [    1.533664] forcedeth 0000:00:07.0: highdma pwrctl mgmt gbit lnktim msi desc-v3
Dec 14 23:35:54 tvserver kernel: [    1.596730] RPC: Registered udp transport module.
Dec 14 23:35:54 tvserver kernel: [    1.596741] RPC: Registered tcp transport module.
Dec 14 23:35:54 tvserver kernel: [    1.617800]   alloc irq_desc for 27 on node -1
Dec 14 23:35:54 tvserver kernel: [    1.617804]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    1.617814] forcedeth 0000:00:07.0: irq 27 for MSI/MSI-X
Dec 14 23:35:54 tvserver kernel: [    1.617997] eth0: no link during initialization.
Dec 14 23:35:54 tvserver kernel: [    1.618429] ADDRCONF(NETDEV_UP): eth0: link is not ready
Dec 14 23:35:54 tvserver kernel: [    4.097135] eth0: link up.
Dec 14 23:35:54 tvserver kernel: [    4.097659] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Dec 14 23:35:54 tvserver kernel: [    7.060586] type=1505 audit(1260830153.715:2): operation="profile_load" pid=354 name=/sbin/dhclient3
Dec 14 23:35:54 tvserver kernel: [    7.060835] type=1505 audit(1260830153.715:3): operation="profile_load" pid=354 name=/usr/lib/NetworkManager/nm-dhcp-client.action
Dec 14 23:35:54 tvserver kernel: [    7.060975] type=1505 audit(1260830153.715:4): operation="profile_load" pid=354 name=/usr/lib/connman/scripts/dhclient-script
Dec 14 23:35:54 tvserver kernel: [    7.067105] type=1505 audit(1260830153.719:5): operation="profile_load" pid=355 name=/usr/sbin/tcpdump
Dec 14 23:35:54 tvserver kernel: [    7.326722] udev: starting version 147
Dec 14 23:35:54 tvserver kernel: [    7.391800] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
Dec 14 23:35:54 tvserver kernel: [    7.391818] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x6000
Dec 14 23:35:54 tvserver kernel: [    7.398048] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Dec 14 23:35:54 tvserver kernel: [    7.475382] input: PC Speaker as /devices/platform/pcspkr/input/input3
Dec 14 23:35:54 tvserver kernel: [    7.479312] w83627ehf: Found W83627EHG chip at 0x290
Dec 14 23:35:54 tvserver kernel: [    7.519509] saa7146: register extension 'budget_ci dvb'.
Dec 14 23:35:54 tvserver kernel: [    7.519842] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
Dec 14 23:35:54 tvserver kernel: [    7.519848]   alloc irq_desc for 19 on node -1
Dec 14 23:35:54 tvserver kernel: [    7.519850]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    7.519861] budget_ci dvb 0000:01:08.0: PCI INT A -> Link[LNKA] -> GSI 19 (level, low) -> IRQ 19
Dec 14 23:35:54 tvserver kernel: [    7.519880] IRQ 19/: IRQF_DISABLED is not guaranteed on shared IRQs
Dec 14 23:35:54 tvserver kernel: [    7.519924] saa7146: found saa7146 @ mem f83c0c00 (revision 1, irq 19) (0x13c2,0x1019).
Dec 14 23:35:54 tvserver kernel: [    7.519931] saa7146 (0): dma buffer size 192512
Dec 14 23:35:54 tvserver kernel: [    7.519934] DVB: registering new adapter (TT-Budget S2-3200 PCI)
Dec 14 23:35:54 tvserver kernel: [    7.524992] Linux video capture interface: v2.00
Dec 14 23:35:54 tvserver kernel: [    7.541716] cx23885 driver version 0.0.2 loaded
Dec 14 23:35:54 tvserver kernel: [    7.542634] ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 18
Dec 14 23:35:54 tvserver kernel: [    7.542640]   alloc irq_desc for 18 on node -1
Dec 14 23:35:54 tvserver kernel: [    7.542642]   alloc kstat_irqs on node -1
Dec 14 23:35:54 tvserver kernel: [    7.542653] cx23885 0000:04:00.0: PCI INT A -> Link[LNEA] -> GSI 18 (level, low) -> IRQ 18
Dec 14 23:35:54 tvserver kernel: [    7.542733] CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470 [card=15,autodetected]
Dec 14 23:35:54 tvserver kernel: [    7.605393] adapter has MAC addr = 00:d0:5c:64:fa:52
Dec 14 23:35:54 tvserver kernel: [    7.605674] input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00:04.0/0000:01:08.0/input/input4
Dec 14 23:35:54 tvserver kernel: [    7.605715] Creating IR device irrcv0
Dec 14 23:35:54 tvserver kernel: [    7.605726] BUG: unable to handle kernel paging request at 72727563
Dec 14 23:35:54 tvserver kernel: [    7.605736] IP: [<c0318af2>] strcmp+0x12/0x30
Dec 14 23:35:54 tvserver kernel: [    7.605745] *pde = 00000000 
Dec 14 23:35:54 tvserver kernel: [    7.605749] Oops: 0000 [#1] SMP 
Dec 14 23:35:54 tvserver kernel: [    7.605753] last sysfs file: /sys/devices/virtual/dmi/id/sys_vendor
Dec 14 23:35:54 tvserver kernel: [    7.605758] Modules linked in: x_tables cx23885(+) cx2341x stb6100 v4l2_common videodev v4l1_compat budget_ci(+) videobuf_dma_sg videobuf_dvb budget_core dvb_core saa7146 ttpci_eeprom videobuf_core w83627ehf pcspkr ir_common serio_raw hwmon_vid btcx_risc tveeprom ir_core k8temp i2c_nforce2 nfs lockd nfs_acl auth_rpcgss sunrpc forcedeth
Dec 14 23:35:54 tvserver kernel: [    7.605791] 
Dec 14 23:35:54 tvserver kernel: [    7.605795] Pid: 540, comm: modprobe Not tainted (2.6.31-16-generic #52-Ubuntu) To Be Filled By O.E.M.
Dec 14 23:35:54 tvserver kernel: [    7.605802] EIP: 0060:[<c0318af2>] EFLAGS: 00010292 CPU: 0
Dec 14 23:35:54 tvserver kernel: [    7.605806] EIP is at strcmp+0x12/0x30
Dec 14 23:35:54 tvserver kernel: [    7.605810] EAX: c06e3075 EBX: f668ef60 ECX: c023a390 EDX: 72727563
Dec 14 23:35:54 tvserver kernel: [    7.605814] ESI: c06e301f EDI: 72727563 EBP: f6675c94 ESP: f6675c8c
Dec 14 23:35:54 tvserver kernel: [    7.605819]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Dec 14 23:35:54 tvserver kernel: [    7.605824] Process modprobe (pid: 540, ti=f6674000 task=f6958000 task.ti=f6674000)
Dec 14 23:35:54 tvserver kernel: [    7.605828] Stack:
Dec 14 23:35:54 tvserver kernel: [    7.605831]  72727563 f6675cf8 f6675ca4 c023a6f1 f6686090 f6675cf8 f6675cb8 c023b2bf
Dec 14 23:35:54 tvserver kernel: [    7.605839] <0> f6675cf8 f6686090 f6675cf8 f6675cec c023b378 c01fb869 f668ef30 00000001
Dec 14 23:35:54 tvserver kernel: [    7.605848] <0> f668ef30 f6675cf8 f6675cec c023a89f f668ef30 f6675cf8 f6686090 fffffff4
Dec 14 23:35:54 tvserver kernel: [    7.605858] Call Trace:
Dec 14 23:35:54 tvserver kernel: [    7.605864]  [<c023a6f1>] ? sysfs_find_dirent+0x21/0x30
Dec 14 23:35:54 tvserver kernel: [    7.605869]  [<c023b2bf>] ? __sysfs_add_one+0x1f/0xc0
Dec 14 23:35:54 tvserver kernel: [    7.605874]  [<c023b378>] ? sysfs_add_one+0x18/0x100
Dec 14 23:35:54 tvserver kernel: [    7.605880]  [<c01fb869>] ? ilookup5+0x39/0x50
Dec 14 23:35:54 tvserver kernel: [    7.605885]  [<c023a89f>] ? sysfs_addrm_start+0x3f/0xa0
Dec 14 23:35:54 tvserver kernel: [    7.605891]  [<c0239bcc>] ? sysfs_add_file_mode+0x4c/0x80
Dec 14 23:35:54 tvserver kernel: [    7.605897]  [<c023c4e5>] ? create_files+0x55/0xc0
Dec 14 23:35:54 tvserver kernel: [    7.605902]  [<c023c5b5>] ? internal_create_group+0x65/0xc0
Dec 14 23:35:54 tvserver kernel: [    7.605907]  [<c023c63c>] ? sysfs_create_group+0xc/0x10
Dec 14 23:35:54 tvserver kernel: [    7.605915]  [<f823f8db>] ? ir_register_class+0x8b/0xd0 [ir_core]
Dec 14 23:35:54 tvserver kernel: [    7.605922]  [<f823f3dc>] ? ir_input_register+0x12c/0x1e0 [ir_core]
Dec 14 23:35:54 tvserver kernel: [    7.605930]  [<f83b621d>] ? budget_ci_attach+0x1bd/0xd50 [budget_ci]
Dec 14 23:35:54 tvserver kernel: [    7.605938]  [<f82d3176>] ? saa7146_init_one+0x836/0x8d0 [saa7146]
Dec 14 23:35:54 tvserver kernel: [    7.605946]  [<c0107770>] ? dma_generic_alloc_coherent+0x0/0xc0
Dec 14 23:35:54 tvserver kernel: [    7.605953]  [<c032853e>] ? local_pci_probe+0xe/0x10
Dec 14 23:35:54 tvserver kernel: [    7.605958]  [<c03292c0>] ? pci_device_probe+0x60/0x80
Dec 14 23:35:54 tvserver kernel: [    7.605965]  [<c03a2e70>] ? really_probe+0x50/0x140
Dec 14 23:35:54 tvserver kernel: [    7.605971]  [<c0570e1a>] ? _spin_lock_irqsave+0x2a/0x40
Dec 14 23:35:54 tvserver kernel: [    7.605976]  [<c03a2f79>] ? driver_probe_device+0x19/0x20
Dec 14 23:35:54 tvserver kernel: [    7.605981]  [<c03a2ff9>] ? __driver_attach+0x79/0x80
Dec 14 23:35:54 tvserver kernel: [    7.605987]  [<c03a24c8>] ? bus_for_each_dev+0x48/0x70
Dec 14 23:35:54 tvserver kernel: [    7.605992]  [<c03a2d39>] ? driver_attach+0x19/0x20
Dec 14 23:35:54 tvserver kernel: [    7.605997]  [<c03a2f80>] ? __driver_attach+0x0/0x80
Dec 14 23:35:54 tvserver kernel: [    7.606002]  [<c03a271f>] ? bus_add_driver+0xbf/0x2a0
Dec 14 23:35:54 tvserver kernel: [    7.606007]  [<c0329200>] ? pci_device_remove+0x0/0x40
Dec 14 23:35:54 tvserver kernel: [    7.606012]  [<c03a3285>] ? driver_register+0x65/0x120
Dec 14 23:35:54 tvserver kernel: [    7.606017]  [<c056fcc4>] ? mutex_lock+0x14/0x40
Dec 14 23:35:54 tvserver kernel: [    7.606022]  [<c03294e0>] ? __pci_register_driver+0x40/0xb0
Dec 14 23:35:54 tvserver kernel: [    7.606029]  [<f82d1d2e>] ? saa7146_register_extension+0x4e/0x90 [saa7146]
Dec 14 23:35:54 tvserver kernel: [    7.606036]  [<f83bd00d>] ? budget_ci_init+0xd/0xf [budget_ci]
Dec 14 23:35:54 tvserver kernel: [    7.606040]  [<c010112c>] ? do_one_initcall+0x2c/0x190
Dec 14 23:35:54 tvserver kernel: [    7.606047]  [<f83bd000>] ? budget_ci_init+0x0/0xf [budget_ci]
Dec 14 23:35:54 tvserver kernel: [    7.606053]  [<c0173751>] ? sys_init_module+0xb1/0x1f0
Dec 14 23:35:54 tvserver kernel: [    7.606058]  [<c010336c>] ? syscall_call+0x7/0xb
Dec 14 23:35:54 tvserver kernel: [    7.606062] Code: 8b 1c 24 8b 7c 24 08 89 ec 5d c3 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 08 89 34 24 89 c6 89 7c 24 04 89 d7 ac <ae> 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 8b 34 24 8b 7c 24 
Dec 14 23:35:54 tvserver kernel: [    7.606101] EIP: [<c0318af2>] strcmp+0x12/0x30 SS:ESP 0068:f6675c8c
Dec 14 23:35:54 tvserver kernel: [    7.606107] CR2: 0000000072727563
Dec 14 23:35:54 tvserver kernel: [    7.606111] ---[ end trace 6b4e61a6bb1580ce ]---


Best Regards,
Olli
