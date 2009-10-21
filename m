Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.uludag.org.tr ([193.140.100.216]:56934 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZJUIRa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 04:17:30 -0400
Message-ID: <4ADEC4C5.8010707@pardus.org.tr>
Date: Wed, 21 Oct 2009 11:22:29 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910201101220.2887-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910201101220.2887-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote On 20-10-2009 18:07:
> Yes, sorry, my email client tends to hide messages with non-ASCII 
> characters in the From: address.  It's unforunate.  :-(
>
> I can't tell exactly what's wrong, but I've got a hunch that the patch 
> below might help.  If it doesn't, send another dmesg log but this time 
> with CONFIG_USB_DEBUG enabled in the kernel.
>   

Nope it didn't help. Here's the DEBUG enabled dmesg output:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31.4-128 (pardus@buildfarm) (gcc
version 4.3.3 (Pardus Linux) ) #1 SMP Wed Oct 21 10:03:01 EEST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f5b2000 (usable)
[    0.000000]  BIOS-e820: 000000003f5b2000 - 000000003f5d5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f5d5000 - 000000003f5e6000 (reserved)
[    0.000000]  BIOS-e820: 000000003f5e6000 - 000000003f5e9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f5e9000 - 000000003f605000 (reserved)
[    0.000000]  BIOS-e820: 000000003f605000 - 000000003f606000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f606000 - 000000003f608000 (reserved)
[    0.000000]  BIOS-e820: 000000003f608000 - 000000003f611000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f611000 - 000000003f617000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f617000 - 000000003f700000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working
around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x3f5b2 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DBFFF write-protect
[    0.000000]   DC000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 0C0000000 write-back
[    0.000000]   1 base 03F700000 mask 0FFF00000 uncachable
[    0.000000]   2 base 03F800000 mask 0FF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003f5b2000 (usable)
[    0.000000]  modified: 000000003f5b2000 - 000000003f5d5000 (ACPI NVS)
[    0.000000]  modified: 000000003f5d5000 - 000000003f5e6000 (reserved)
[    0.000000]  modified: 000000003f5e6000 - 000000003f5e9000 (ACPI NVS)
[    0.000000]  modified: 000000003f5e9000 - 000000003f605000 (reserved)
[    0.000000]  modified: 000000003f605000 - 000000003f606000 (ACPI NVS)
[    0.000000]  modified: 000000003f606000 - 000000003f608000 (reserved)
[    0.000000]  modified: 000000003f608000 - 000000003f611000 (ACPI data)
[    0.000000]  modified: 000000003f611000 - 000000003f617000 (ACPI NVS)
[    0.000000]  modified: 000000003f617000 - 000000003f700000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 37ad5000 - 37fef0fd
[    0.000000] Allocated new RAMDISK: 00767000 - 00c810fd
[    0.000000] Move RAMDISK from 0000000037ad5000 - 0000000037fef0fc to
00767000 - 00c810fc
[    0.000000] ACPI: RSDP 000f03c0 00024 (v02    LGE)
[    0.000000] ACPI: XSDT 3f60ff10 0004C (v01    LGE     LGPC 06222004
MSFT 00010013)
[    0.000000] ACPI: FACP 3f5e6c10 000F4 (v04    LGE     LGPC 06222004
MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two
FACS tables! 20090521 tbfadt-370
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT -
3F611E40/000000003F611D40, using 32 20090521 tbfadt-487
[    0.000000] ACPI: DSDT 3f608010 057B2 (v01    LGE     LGPC 00000000
INTL 20051117)
[    0.000000] ACPI: FACS 3f611e40 00040
[    0.000000] ACPI: APIC 3f610e90 0005C (v02    LGE     LGPC 06222004
MSFT 00010013)
[    0.000000] ACPI: SSDT 3f605510 004CE (v02  PmRef    CpuPm 00003000
INTL 20051117)
[    0.000000] ACPI: SSDT 3f5e8a10 00232 (v02  PmRef  Cpu0Tst 00003000
INTL 20051117)
[    0.000000] ACPI: SSDT 3f611a10 000A0 (v02  PmRef  Cpu1Tst 00003000
INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 129MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00012000 - 00018e80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000076260c]    TEXT DATA BSS ==>
[0000100000 - 000076260c]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==>
[000009ec00 - 0000100000]
[    0.000000]   #5 [0000763000 - 0000766180]              BRK ==>
[0000763000 - 0000766180]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==>
[0000010000 - 0000012000]
[    0.000000]   #7 [0000767000 - 0000c810fd]      NEW RAMDISK ==>
[0000767000 - 0000c810fd]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==>
[0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003f5b2
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0003f5b2
[    0.000000] On node 0 totalpages: 259392
[    0.000000] free_area_init_node: node 0, pgdat c0624ea0, node_mem_map
c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 260 pages used for memmap
[    0.000000]   HighMem zone: 32944 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 -
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 3f700000 (gap:
3f700000:c0400000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c17f5000, static data 36604
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 257364
[    0.000000] Kernel command line: root=LABEL=PARDUS_ROOT splash=silent
quiet vga=0x314 resume=/dev/sda5
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 5189800 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000373fe:0003f5b2)
[    0.000000] Memory: 1011276k/1038024k available (3317k kernel code,
25932k reserved, 1987k data, 468k init, 132816k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc062f000 - 0xc06a4000   ( 468 kB)
[    0.000000]       .data : 0xc043d7b3 - 0xc062e690   (1987 kB)
[    0.000000]       .text : 0xc0100000 - 0xc043d7b3   (3317 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] NR_IRQS:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1600.131 MHz processor.
[    0.000053] Console: colour dummy device 80x25
[    0.000059] console [tty0] enabled
[    0.001016] spurious 8259A interrupt: IRQ7.
[    0.001029] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3200.26 BogoMIPS (lpj=1600131)
[    0.001071] Security Framework initialized
[    0.001088] Mount-cache hash table entries: 512
[    0.001323] Initializing cgroup subsys ns
[    0.001332] Initializing cgroup subsys cpuacct
[    0.001341] Initializing cgroup subsys memory
[    0.001352] Initializing cgroup subsys devices
[    0.001358] Initializing cgroup subsys freezer
[    0.001386] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.001392] CPU: L2 cache: 512K
[    0.001397] CPU: Physical Processor ID: 0
[    0.001401] CPU: Processor Core ID: 0
[    0.001408] mce: CPU supports 5 MCE banks
[    0.001421] CPU0: Thermal monitoring enabled (TM2)
[    0.001428] using mwait in idle threads.
[    0.001440] Performance Counters: Atom events, Intel PMU driver.
[    0.001453] ... version:                 3
[    0.001458] ... bit width:               40
[    0.001462] ... generic counters:        2
[    0.001466] ... value mask:              000000ffffffffff
[    0.001470] ... max period:              000000007fffffff
[    0.001475] ... fixed-purpose counters:  3
[    0.001479] ... counter mask:            0000000700000003
[    0.001487] Checking 'hlt' instruction... OK.
[    0.006812] ACPI: Core revision 20090521
[    0.020447] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.030988] CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
[    0.031995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 3199.51
BogoMIPS (lpj=1599756)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 24K
[    0.000999] CPU: L2 cache: 512K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 0
[    0.000999] mce: CPU supports 5 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new
0x7010600070106
[    0.102960] CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
[    0.103005] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.104078] Brought up 2 CPUs
[    0.104085] Total of 2 processors activated (6399.77 BogoMIPS).
[    0.104164] CPU0 attaching sched-domain:
[    0.104171]  domain 0: span 0-1 level SIBLING
[    0.104176]   groups: 0 1
[    0.104186] CPU1 attaching sched-domain:
[    0.104191]  domain 0: span 0-1 level SIBLING
[    0.104196]   groups: 1 0
[    0.104754] Booting paravirtualized kernel on bare hardware
[    0.105255] regulator: core version 0.5
[    0.105376] NET: Registered protocol family 16
[    0.105630] EISA bus registered
[    0.105661] ACPI: bus type pci registered
[    0.190426] PCI: Using configuration type 1 for base access
[    0.192472] bio: create slab <bio-0> at 0
[    0.193784] ACPI: EC: Look up EC in DSDT
[    0.199601] ACPI: BIOS _OSI(Linux) query ignored
[    0.203706] ACPI: Interpreter enabled
[    0.203717] ACPI: (supports S0 S1 S3 S4 S5)
[    0.203766] ACPI: Using IOAPIC for interrupt routing
[    0.210558] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.220230] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.220237] ACPI: EC: driver started in interrupt mode
[    0.220623] ACPI: No dock devices found.
[    0.221180] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.221315] pci 0000:00:02.0: reg 10 32bit mmio: [0xdfe80000-0xdfefffff]
[    0.221325] pci 0000:00:02.0: reg 14 io port: [0xd0f0-0xd0f7]
[    0.221335] pci 0000:00:02.0: reg 18 32bit mmio: [0xc0000000-0xcfffffff]
[    0.221344] pci 0000:00:02.0: reg 1c 32bit mmio: [0xdff00000-0xdff3ffff]
[    0.221395] pci 0000:00:02.1: reg 10 32bit mmio: [0xdfe00000-0xdfe7ffff]
[    0.221500] pci 0000:00:1b.0: reg 10 64bit mmio: [0xffe00000-0xffe03fff]
[    0.221553] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.221561] pci 0000:00:1b.0: PME# disabled
[    0.221632] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.221639] pci 0000:00:1c.0: PME# disabled
[    0.221712] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.221720] pci 0000:00:1c.2: PME# disabled
[    0.221779] pci 0000:00:1d.0: reg 20 io port: [0xd080-0xd09f]
[    0.221801] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1f30
[    0.221806] pci 0000:00:1d.0: Performing full reset
[    0.221865] pci 0000:00:1d.1: reg 20 io port: [0xd060-0xd07f]
[    0.221886] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
[    0.221891] pci 0000:00:1d.1: Performing full reset
[    0.221949] pci 0000:00:1d.2: reg 20 io port: [0xd040-0xd05f]
[    0.221980] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
[    0.221985] pci 0000:00:1d.2: Performing full reset
[    0.222044] pci 0000:00:1d.3: reg 20 io port: [0xd020-0xd03f]
[    0.222065] pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0030
[    0.222070] pci 0000:00:1d.3: Performing full reset
[    0.222141] pci 0000:00:1d.7: reg 10 32bit mmio: [0xdff40000-0xdff403ff]
[    0.222320] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.222328] pci 0000:00:1d.7: PME# disabled
[    0.222473] pci 0000:00:1f.0: Force enabled HPET at 0xfed03000
[    0.222486] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6
ACPI/GPIO/TCO
[    0.222494] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6
GPIO
[    0.222502] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
004c (mask 0007)
[    0.222566] pci 0000:00:1f.2: reg 10 io port: [0xd0e0-0xd0e7]
[    0.222577] pci 0000:00:1f.2: reg 14 io port: [0xd0d0-0xd0d3]
[    0.222587] pci 0000:00:1f.2: reg 18 io port: [0xd0c0-0xd0c7]
[    0.222597] pci 0000:00:1f.2: reg 1c io port: [0xd0b0-0xd0b3]
[    0.222608] pci 0000:00:1f.2: reg 20 io port: [0xd0a0-0xd0af]
[    0.222639] pci 0000:00:1f.2: PME# supported from D3hot
[    0.222646] pci 0000:00:1f.2: PME# disabled
[    0.222714] pci 0000:01:00.0: reg 10 io port: [0xc000-0xc0ff]
[    0.222740] pci 0000:01:00.0: reg 18 64bit mmio: [0xffd10000-0xffd10fff]
[    0.222760] pci 0000:01:00.0: reg 20 64bit mmio: [0xffd00000-0xffd0ffff]
[    0.222773] pci 0000:01:00.0: reg 30 32bit mmio: [0xdfd00000-0xdfd0ffff]
[    0.222821] pci 0000:01:00.0: supports D1 D2
[    0.222826] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.222834] pci 0000:01:00.0: PME# disabled
[    0.224066] pci 0000:00:1c.0: bridge io port: [0xc000-0xcfff]
[    0.224074] pci 0000:00:1c.0: bridge 32bit mmio: [0xdfd00000-0xdfdfffff]
[    0.224087] pci 0000:00:1c.0: bridge 64bit mmio pref:
[0xffd00000-0xffdfffff]
[    0.224148] pci 0000:02:00.0: reg 10 io port: [0xb000-0xb0ff]
[    0.224162] pci 0000:02:00.0: reg 14 32bit mmio: [0xdfc00000-0xdfc03fff]
[    0.224237] pci 0000:02:00.0: supports D1 D2
[    0.224242] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[    0.224250] pci 0000:02:00.0: PME# disabled
[    0.226061] pci 0000:00:1c.2: bridge io port: [0xb000-0xbfff]
[    0.226070] pci 0000:00:1c.2: bridge 32bit mmio: [0xdfc00000-0xdfcfffff]
[    0.226136] pci 0000:00:1e.0: transparent bridge
[    0.226165] pci_bus 0000:00: on NUMA node 0
[    0.226176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.226490] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.226617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.243659] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12
14 15)
[    0.243862] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    0.244077] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12
14 15)
[    0.244283] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12
14 15)
[    0.244483] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    0.244685] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    0.244893] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    0.245110] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12
14 15)
[    0.245291] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.245310] vgaarb: loaded
[    0.245514] SCSI subsystem initialized
[    0.245725] usbcore: registered new interface driver usbfs
[    0.245765] usbcore: registered new interface driver hub
[    0.245828] usbcore: registered new device driver usb
[    0.245993] PCI: Using ACPI for IRQ routing
[    0.249134] hpet clockevent registered
[    0.249142] HPET: 3 timers in total, 0 timers will be used for
per-cpu timer
[    0.249151] hpet0: at MMIO 0xfed03000, IRQs 2, 8, 0
[    0.249162] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.257988] pnp: PnP ACPI init
[    0.258024] ACPI: bus type pnp registered
[    0.262502] pnp: PnP ACPI: found 11 devices
[    0.262508] ACPI: ACPI bus type pnp unregistered
[    0.262516] PnPBIOS: Disabled by ACPI PNP
[    0.262540] system 00:01: iomem range 0xfed14000-0xfed17fff has been
reserved
[    0.262548] system 00:01: iomem range 0xfed19000-0xfed19fff has been
reserved
[    0.262556] system 00:01: iomem range 0xfed18000-0xfed18fff has been
reserved
[    0.262563] system 00:01: iomem range 0xe0000000-0xefffffff has been
reserved
[    0.262580] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.262595] system 00:09: ioport range 0x400-0x47f has been reserved
[    0.262603] system 00:09: ioport range 0x1180-0x119f has been reserved
[    0.262610] system 00:09: ioport range 0x500-0x53f has been reserved
[    0.262618] system 00:09: iomem range 0xfec00000-0xfec00fff could not
be reserved
[    0.262626] system 00:09: iomem range 0xfee00000-0xfee00fff has been
reserved
[    0.262633] system 00:09: iomem range 0xfed20000-0xfed23fff has been
reserved
[    0.262650] system 00:09: iomem range 0xffb00000-0xffbfffff has been
reserved
[    0.262658] system 00:09: iomem range 0xfc800400-0xfc800fff has been
reserved
[    0.297674] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.297682] pci 0000:00:1c.0:   IO window: 0xc000-0xcfff
[    0.297691] pci 0000:00:1c.0:   MEM window: 0xdfd00000-0xdfdfffff
[    0.297700] pci 0000:00:1c.0:   PREFETCH window:
0x000000ffd00000-0x000000ffdfffff
[    0.297711] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:02
[    0.297717] pci 0000:00:1c.2:   IO window: 0xb000-0xbfff
[    0.297726] pci 0000:00:1c.2:   MEM window: 0xdfc00000-0xdfcfffff
[    0.297733] pci 0000:00:1c.2:   PREFETCH window: disabled
[    0.297741] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    0.297745] pci 0000:00:1e.0:   IO window: disabled
[    0.297753] pci 0000:00:1e.0:   MEM window: disabled
[    0.297759] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.297787] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.297796] pci 0000:00:1c.0: setting latency timer to 64
[    0.297812] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.297820] pci 0000:00:1c.2: setting latency timer to 64
[    0.297831] pci 0000:00:1e.0: setting latency timer to 64
[    0.297839] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.297846] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.297852] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
[    0.297859] pci_bus 0000:01: resource 1 mem: [0xdfd00000-0xdfdfffff]
[    0.297865] pci_bus 0000:01: resource 2 pref mem [0xffd00000-0xffdfffff]
[    0.297872] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.297878] pci_bus 0000:02: resource 1 mem: [0xdfc00000-0xdfcfffff]
[    0.297884] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.297890] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffff]
[    0.297969] NET: Registered protocol family 2
[    0.298169] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    0.298803] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.299782] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.300250] TCP: Hash tables configured (established 131072 bind 65536)
[    0.300257] TCP reno registered
[    0.300474] NET: Registered protocol family 1
[    0.300595] Unpacking initramfs...
[    0.651782] Freeing initrd memory: 5224k freed
[    0.657844] cpu0(2) debug files 135
[    0.659577] cpu1(2) debug files 135
[    0.659752] cpufreq-nforce2: No nForce2 chipset.
[    0.660005] Scanning for low memory corruption every 60 seconds
[    0.660237] audit: initializing netlink socket (disabled)
[    0.660263] type=2000 audit(1256123136.659:1): initialized
[    0.675904] highmem bounce pool size: 64 pages
[    0.675916] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.679435] VFS: Disk quotas dquot_6.5.2
[    0.679564] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.680586] fuse init (API version 7.12)
[    0.681307] aufs 2-31
[    0.681325] msgmni has been set to 1726
[    0.682028] alg: No test for stdrng (krng)
[    0.682162] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.682169] io scheduler noop registered
[    0.682173] io scheduler anticipatory registered
[    0.682178] io scheduler deadline registered
[    0.682271] io scheduler cfq registered (default)
[    0.682294] pci 0000:00:02.0: Boot video device
[    0.682477] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.682622] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.682758] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.682785] Firmware did not grant requested _OSC control
[    0.682816] Firmware did not grant requested _OSC control
[    0.682889] Firmware did not grant requested _OSC control
[    0.682914] Firmware did not grant requested _OSC control
[    0.682944] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.683327] vesafb: framebuffer at 0xc0000000, mapped to 0xf7c80000,
using 3750k, total 7872k
[    0.683334] vesafb: mode is 800x600x16, linelength=1600, pages=7
[    0.683339] vesafb: scrolling: redraw
[    0.683345] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.683941] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.702472] bootsplash: silentjpeg size 34362 bytes
[    0.721237] bootsplash: ...found (800x600, 26696 bytes, v3).
[    0.748973] Switched to high resolution mode on CPU 1
[    0.749846] Switched to high resolution mode on CPU 0
[    0.784939] Console: switching to colour frame buffer device 100x34
[    0.848286] fb0: VESA VGA frame buffer device
[    0.850064] ACPI: AC Adapter [ADP1] (on-line)
[    0.850276] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.850283] ACPI: Power Button [PWRF]
[    0.850442] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:11/PNP0C09:00/PNP0C0D:00/input/input1
[    0.852077] ACPI: Lid Switch [LID0]
[    0.852221] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.852228] ACPI: Power Button [PWRB]
[    0.852382] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    0.852388] ACPI: Sleep Button [SLPB]
[    0.853626] ACPI: SSDT 3f5e8c90 00253 (v02  PmRef  Cpu0Ist 00003000
INTL 20051117)
[    0.854458] ACPI: SSDT 3f5e7690 00653 (v02  PmRef  Cpu0Cst 00003001
INTL 20051117)
[    0.859312] Monitor-Mwait will be used to enter C-1 state
[    0.859378] Monitor-Mwait will be used to enter C-2 state
[    0.859432] Monitor-Mwait will be used to enter C-3 state
[    0.859451] Marking TSC unstable due to TSC halts in idle
[    0.859492] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.859550] processor LNXCPU:00: registered as cooling_device0
[    0.859559] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.860292] ACPI: SSDT 3f5e8f10 000D0 (v02  PmRef  Cpu1Ist 00003000
INTL 20051117)
[    0.860816] ACPI: SSDT 3f611b10 00083 (v02  PmRef  Cpu1Cst 00003000
INTL 20051117)
[    0.862473] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.862527] processor LNXCPU:01: registered as cooling_device1
[    0.862536] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.870374] thermal LNXTHERM:01: registered as thermal_zone0
[    0.870391] ACPI: Thermal Zone [THRM] (53 C)
[    0.870558] isapnp: Scanning for PnP cards...
[    1.125387] ACPI: Battery Slot [BAT1] (battery present)
[    1.183849] isapnp: No Plug & Play device found
[    1.186625] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.198046] floppy0: no floppy controllers found
[    4.199150] loop: module loaded
[    4.199296] input: Macintosh mouse button emulation as
/devices/virtual/input/input4
[    4.199499] Fixed MDIO Bus: probed
[    4.199551] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.199558] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    4.199611] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    4.199637] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.199644] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.199681] drivers/usb/core/inode.c: creating file 'devices'
[    4.199690] drivers/usb/core/inode.c: creating file '001'
[    4.199698] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    4.199713] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1
cc=4 pcc=2 ordered !ppc ports=8
[    4.199722] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7
uframes 1024 64 bit addr
[    4.199754] ehci_hcd 0000:00:1d.7: reset command 080012 (park)=0
ithresh=8 Periodic period=1024 Reset HALT
[    4.203655] ehci_hcd 0000:00:1d.7: debug port 1
[    4.203665] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    4.203670] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.203697] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xdff40000
[    4.203707] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0
ithresh=8 period=1024 Reset HALT
[    4.207586] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0
ithresh=1 period=1024 RUN
[    4.213026] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.213082] usb usb1: default language 0x0409
[    4.213099] usb usb1: udev 1, busnum 1, minor = 0
[    4.213105] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.213111] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.213117] usb usb1: Product: EHCI Host Controller
[    4.213122] usb usb1: Manufacturer: Linux 2.6.31.4-128 ehci_hcd
[    4.213127] usb usb1: SerialNumber: 0000:00:1d.7
[    4.213228] usb usb1: uevent
[    4.213266] usb usb1: usb_probe_device
[    4.213274] usb usb1: configuration #1 chosen from 1 choice
[    4.213291] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.213325] usb 1-0:1.0: uevent
[    4.213351] hub 1-0:1.0: usb_probe_interface
[    4.213356] hub 1-0:1.0: usb_probe_interface - got id
[    4.213361] hub 1-0:1.0: USB hub found
[    4.213378] hub 1-0:1.0: 8 ports detected
[    4.213382] hub 1-0:1.0: standalone hub
[    4.213386] hub 1-0:1.0: no power switching (usb 1.0)
[    4.213391] hub 1-0:1.0: individual port over-current protection
[    4.213396] hub 1-0:1.0: power on to power good time: 20ms
[    4.213405] hub 1-0:1.0: local power source is good
[    4.213411] hub 1-0:1.0: trying to enable port power on
non-switchable hub
[    4.213470] drivers/usb/core/inode.c: creating file '001'
[    4.213544] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.213550] ohci_hcd: block sizes: ed 64 td 64
[    4.213588] uhci_hcd: USB Universal Host Controller Interface driver
[    4.213658] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    4.213672] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.213679] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.213692] drivers/usb/core/inode.c: creating file '002'
[    4.213702] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    4.213714] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.213722] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.213727] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.213744] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[    4.213759] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d080
[    4.213827] usb usb2: default language 0x0409
[    4.213843] usb usb2: udev 1, busnum 2, minor = 128
[    4.213848] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.213854] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.213860] usb usb2: Product: UHCI Host Controller
[    4.213865] usb usb2: Manufacturer: Linux 2.6.31.4-128 uhci_hcd
[    4.213870] usb usb2: SerialNumber: 0000:00:1d.0
[    4.213960] usb usb2: uevent
[    4.213982] usb usb2: usb_probe_device
[    4.213988] usb usb2: configuration #1 chosen from 1 choice
[    4.214003] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.214043] usb 2-0:1.0: uevent
[    4.214068] hub 2-0:1.0: usb_probe_interface
[    4.214073] hub 2-0:1.0: usb_probe_interface - got id
[    4.214078] hub 2-0:1.0: USB hub found
[    4.214094] hub 2-0:1.0: 2 ports detected
[    4.214098] hub 2-0:1.0: standalone hub
[    4.214102] hub 2-0:1.0: no power switching (usb 1.0)
[    4.214106] hub 2-0:1.0: individual port over-current protection
[    4.214111] hub 2-0:1.0: power on to power good time: 2ms
[    4.214120] hub 2-0:1.0: local power source is good
[    4.214125] hub 2-0:1.0: trying to enable port power on
non-switchable hub
[    4.214161] drivers/usb/core/inode.c: creating file '001'
[    4.214223] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    4.214234] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.214240] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.214268] drivers/usb/core/inode.c: creating file '003'
[    4.214278] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    4.214289] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.214297] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.214302] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.214318] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[    4.214343] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d060
[    4.214410] usb usb3: default language 0x0409
[    4.214426] usb usb3: udev 1, busnum 3, minor = 256
[    4.214431] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.214437] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.214443] usb usb3: Product: UHCI Host Controller
[    4.214448] usb usb3: Manufacturer: Linux 2.6.31.4-128 uhci_hcd
[    4.214453] usb usb3: SerialNumber: 0000:00:1d.1
[    4.214540] usb usb3: uevent
[    4.214562] usb usb3: usb_probe_device
[    4.214567] usb usb3: configuration #1 chosen from 1 choice
[    4.214581] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.214614] usb 3-0:1.0: uevent
[    4.214638] hub 3-0:1.0: usb_probe_interface
[    4.214643] hub 3-0:1.0: usb_probe_interface - got id
[    4.214648] hub 3-0:1.0: USB hub found
[    4.214662] hub 3-0:1.0: 2 ports detected
[    4.214666] hub 3-0:1.0: standalone hub
[    4.214670] hub 3-0:1.0: no power switching (usb 1.0)
[    4.214674] hub 3-0:1.0: individual port over-current protection
[    4.214680] hub 3-0:1.0: power on to power good time: 2ms
[    4.214688] hub 3-0:1.0: local power source is good
[    4.214693] hub 3-0:1.0: trying to enable port power on
non-switchable hub
[    4.214728] drivers/usb/core/inode.c: creating file '001'
[    4.214785] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    4.214796] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.214802] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.214818] drivers/usb/core/inode.c: creating file '004'
[    4.214828] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    4.214839] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.214847] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.214851] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.214868] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[    4.214893] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d040
[    4.214958] usb usb4: default language 0x0409
[    4.214974] usb usb4: udev 1, busnum 4, minor = 384
[    4.214980] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.214986] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.214991] usb usb4: Product: UHCI Host Controller
[    4.214996] usb usb4: Manufacturer: Linux 2.6.31.4-128 uhci_hcd
[    4.215002] usb usb4: SerialNumber: 0000:00:1d.2
[    4.215093] usb usb4: uevent
[    4.215115] usb usb4: usb_probe_device
[    4.215121] usb usb4: configuration #1 chosen from 1 choice
[    4.215135] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.215168] usb 4-0:1.0: uevent
[    4.215192] hub 4-0:1.0: usb_probe_interface
[    4.215197] hub 4-0:1.0: usb_probe_interface - got id
[    4.215202] hub 4-0:1.0: USB hub found
[    4.215217] hub 4-0:1.0: 2 ports detected
[    4.215221] hub 4-0:1.0: standalone hub
[    4.215225] hub 4-0:1.0: no power switching (usb 1.0)
[    4.215229] hub 4-0:1.0: individual port over-current protection
[    4.215234] hub 4-0:1.0: power on to power good time: 2ms
[    4.215243] hub 4-0:1.0: local power source is good
[    4.215248] hub 4-0:1.0: trying to enable port power on
non-switchable hub
[    4.215299] drivers/usb/core/inode.c: creating file '001'
[    4.215357] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low)
-> IRQ 16
[    4.215368] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.215374] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.215387] drivers/usb/core/inode.c: creating file '005'
[    4.215396] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    4.215407] uhci_hcd 0000:00:1d.3: detected 2 ports
[    4.215415] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
[    4.215420] uhci_hcd 0000:00:1d.3: Performing full reset
[    4.215436] uhci_hcd 0000:00:1d.3: supports USB remote wakeup
[    4.215461] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d020
[    4.215527] usb usb5: default language 0x0409
[    4.215542] usb usb5: udev 1, busnum 5, minor = 512
[    4.215548] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.215554] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    4.215559] usb usb5: Product: UHCI Host Controller
[    4.215564] usb usb5: Manufacturer: Linux 2.6.31.4-128 uhci_hcd
[    4.215569] usb usb5: SerialNumber: 0000:00:1d.3
[    4.215662] usb usb5: uevent
[    4.215684] usb usb5: usb_probe_device
[    4.215689] usb usb5: configuration #1 chosen from 1 choice
[    4.215703] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.215736] usb 5-0:1.0: uevent
[    4.215760] hub 5-0:1.0: usb_probe_interface
[    4.215765] hub 5-0:1.0: usb_probe_interface - got id
[    4.215770] hub 5-0:1.0: USB hub found
[    4.215784] hub 5-0:1.0: 2 ports detected
[    4.215789] hub 5-0:1.0: standalone hub
[    4.215792] hub 5-0:1.0: no power switching (usb 1.0)
[    4.215797] hub 5-0:1.0: individual port over-current protection
[    4.215802] hub 5-0:1.0: power on to power good time: 2ms
[    4.215811] hub 5-0:1.0: local power source is good
[    4.215816] hub 5-0:1.0: trying to enable port power on
non-switchable hub
[    4.215849] drivers/usb/core/inode.c: creating file '001'
[    4.216005] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    4.234499] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.234513] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.234671] mice: PS/2 mouse device common for all mice
[    4.235962] rtc_cmos 00:04: RTC can wake from S4
[    4.236056] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    4.236092] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    4.236182] EISA: Probing bus 0 at eisa.0
[    4.236218] EISA: Detected 0 cards.
[    4.236492] cpuidle: using governor ladder
[    4.236749] cpuidle: using governor menu
[    4.237450] usbcore: registered new interface driver hiddev
[    4.237485] usbcore: registered new interface driver usbhid
[    4.237491] usbhid: v2.6:USB HID core driver
[    4.238359] NET: Registered protocol family 17
[    4.239549] Using IPI No-Shortcut mode
[    4.239706] TuxOnIce 3.0.1 (http://tuxonice.net)
[    4.239855] TuxOnIce: Ignoring late initcall, as requested.
[    4.250630] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
[    4.313175] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001803
POWER sig=j CSC CONNECT
[    4.313197] hub 1-0:1.0: port 5: status 0501 change 0001
[    4.313230] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803
POWER sig=j CSC CONNECT
[    4.313250] hub 1-0:1.0: port 6: status 0501 change 0001
[    4.313346] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.314433] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.315388] uhci_hcd 0000:00:1d.2: port 1 portsc 0082,00
[    4.315414] uhci_hcd 0000:00:1d.2: port 2 portsc 0082,00
[    4.315464] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.413144] hub 1-0:1.0: state 7 ports 8 chg 0060 evt 0000
[    4.413170] hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[    4.464364] ehci_hcd 0000:00:1d.7: port 5 high speed
[    4.464383] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005
POWER sig=se0 PE CONNECT
[    4.515150] usb 1-5: new high speed USB device using ehci_hcd and
address 2
[    4.584363] ehci_hcd 0000:00:1d.7: port 5 high speed
[    4.584383] ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001005
POWER sig=se0 PE CONNECT
[    4.749047] Clocksource tsc unstable (delta = -266799223 ns)
[    4.792467] usb 1-5: skipped 1 descriptor after configuration
[    4.792482] usb 1-5: skipped 6 descriptors after interface
[    4.792497] usb 1-5: skipped 1 descriptor after endpoint
[    4.792508] usb 1-5: skipped 8 descriptors after interface
[    4.794037] usb 1-5: default language 0x0409
[    4.841164] usb 1-5: udev 2, busnum 1, minor = 1
[    4.841177] usb 1-5: New USB device found, idVendor=5986, idProduct=0203
[    4.841190] usb 1-5: New USB device strings: Mfr=3, Product=1,
SerialNumber=0
[    4.841201] usb 1-5: Product: BisonCam, NB Pro
[    4.841211] usb 1-5: Manufacturer: Bison Electronics Inc.
[    4.841407] usb 1-5: uevent
[    4.841455] usb 1-5: usb_probe_device
[    4.841467] usb 1-5: configuration #1 chosen from 1 choice
[    4.841674] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[    4.875804] usb 1-5:1.0: uevent
[    4.875901] usb 1-5: adding 1-5:1.1 (config #1, interface 1)
[    4.875983] usb 1-5:1.1: uevent
[    4.876066] drivers/usb/core/inode.c: creating file '002'
[    4.876171] hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
[    4.927363] ehci_hcd 0000:00:1d.7: port 6 high speed
[    4.927384] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005
POWER sig=se0 PE CONNECT
[    4.978077] usb 1-6: new high speed USB device using ehci_hcd and
address 3
[    5.030239] ehci_hcd 0000:00:1d.7: port 6 high speed
[    5.030259] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005
POWER sig=se0 PE CONNECT
[    5.078523] Synaptics Touchpad, model: 1, fw: 6.5, id: 0x1c0b1, caps:
0xa04711/0xa00000
[    5.099781] usb 1-6: default language 0x0409
[    5.104913] usb 1-6: udev 3, busnum 1, minor = 2
[    5.104926] usb 1-6: New USB device found, idVendor=0bda, idProduct=0158
[    5.104938] usb 1-6: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    5.104949] usb 1-6: Product: USB2.0-CRW
[    5.104958] usb 1-6: Manufacturer: Generic
[    5.104968] usb 1-6: SerialNumber: 20071114173400000
[    5.105191] usb 1-6: uevent
[    5.105238] usb 1-6: usb_probe_device
[    5.105249] usb 1-6: configuration #1 chosen from 1 choice
[    5.107054] usb 1-6: adding 1-6:1.0 (config #1, interface 0)
[    5.110862] usb 1-6:1.0: uevent
[    5.110994] drivers/usb/core/inode.c: creating file '003'
[    5.111109] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    5.141633] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input6
[    5.146299] registered taskstats version 1
[    5.146786] rtc_cmos 00:04: setting system clock to 2009-10-21
11:05:42 UTC (1256123142)
[    5.147164] Freeing unused kernel memory: 468k freed
[    5.147925] Write protecting the kernel text: 3320k
[    5.148092] Write protecting the kernel read-only data: 1556k
[    5.364081] libata version 3.00 loaded.
[    5.373360] pata_acpi 0000:00:1f.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    5.373449] pata_acpi 0000:00:1f.2: setting latency timer to 64
[    5.373486] pata_acpi 0000:00:1f.2: PCI INT B disabled
[    5.395550] ata_piix 0000:00:1f.2: version 2.13
[    5.395572] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    5.395581] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    5.454131] usb usb2: suspend_rh (auto-stop)
[    5.454165] usb usb3: suspend_rh (auto-stop)
[    5.454196] usb usb5: suspend_rh (auto-stop)
[    5.454226] usb usb4: suspend_rh (auto-stop)
[    5.546160] ata_piix 0000:00:1f.2: setting latency timer to 64
[    5.546441] scsi0 : ata_piix
[    5.546836] scsi1 : ata_piix
[    5.546999] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xd0a0
irq 14
[    5.547016] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xd0a8
irq 15
[    5.710368] ata1.00: ATA-8: FUJITSU MHZ2160BH, 00000009, max UDMA/100
[    5.710385] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.716525] ata1.00: configured for UDMA/100
[    5.716869] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B
0000 PQ: 0 ANSI: 5
[    5.717576] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160
GB/149 GiB)
[    5.717606] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.717896] sd 0:0:0:0: [sda] Write Protect is off
[    5.717911] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.718037] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.718675]  sda: sda1 sda2 < sda5 sda6 >
[    5.720801] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.887210] Initializing USB Mass Storage driver...
[    5.887321] usb-storage 1-6:1.0: usb_probe_interface
[    5.887334] usb-storage 1-6:1.0: usb_probe_interface - got id
[    5.887507] scsi2 : SCSI emulation for USB Mass Storage devices
[    5.887697] usbcore: registered new interface driver usb-storage
[    5.887705] USB Mass Storage support registered.
[    5.887948] usb-storage: device found at 3
[    5.887952] usb-storage: waiting for device to settle before scanning
[    6.701154] hub 2-0:1.0: hub_suspend
[    6.701177] usb usb2: bus auto-suspend
[    6.701188] usb usb2: suspend_rh
[    6.701215] hub 3-0:1.0: hub_suspend
[    6.701227] usb usb3: bus auto-suspend
[    6.701236] usb usb3: suspend_rh
[    6.701292] hub 5-0:1.0: hub_suspend
[    6.701311] usb usb5: bus auto-suspend
[    6.701323] usb usb5: suspend_rh
[    6.887514] usb-storage: device scan complete
[    6.889627] scsi 2:0:0:0: Direct-Access     Generic- Multi-Card      
1.00 PQ: 0 ANSI: 0 CCS
[    6.891687] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    6.895561] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    7.704136] hub 4-0:1.0: hub_suspend
[    7.704161] usb usb4: bus auto-suspend
[    7.704175] usb usb4: suspend_rh
[    8.905980] PM: Starting manual resume from disk
[    8.906409] TuxOnIce: Normal swapspace found.
[    9.122870] brd: module loaded
[    9.140126] EXT4-fs (sda1): barriers enabled
[    9.164165] kjournald2 starting: pid 110, dev sda1:8, commit interval
5 seconds
[    9.164204] EXT4-fs (sda1): delayed allocation enabled
[    9.164214] EXT4-fs: file extents enabled
[    9.174364] EXT4-fs: mballoc enabled
[    9.174421] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   12.241013] udev: starting version 146
[   12.939723] usb usb2: uevent
[   12.941276] usb 2-0:1.0: uevent
[   12.941764] usb usb3: uevent
[   12.941944] usb 3-0:1.0: uevent
[   12.943427] usb usb4: uevent
[   12.945121] usb 4-0:1.0: uevent
[   12.945802] usb usb5: uevent
[   12.946101] usb 5-0:1.0: uevent
[   12.947307] usb usb1: uevent
[   12.947634] usb 1-0:1.0: uevent
[   12.947857] usb 1-5: uevent
[   12.948084] usb 1-5:1.0: uevent
[   12.948265] usb 1-5:1.1: uevent
[   12.948449] usb 1-6: uevent
[   12.948643] usb 1-6:1.0: uevent
[   13.055228] ACPI: WMI: Mapper loaded
[   13.064780] usb usb2: uevent
[   13.067834] usb usb1: uevent
[   13.070707] usb usb3: uevent
[   13.070712] usb usb5: uevent
[   13.074619] usb usb4: uevent
[   13.080667] usb 1-6: uevent
[   13.090751] usb 1-5: uevent
[   13.142266] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   13.171120] usb 1-6:1.0: uevent
[   13.171525] usb 1-6: uevent
[   13.193092] acpi device:1c: registered as cooling_device2
[   13.193459] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1a/input/input8
[   13.193570] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[   13.205120] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   13.205130] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   13.205988] usb 1-6:1.0: uevent
[   13.208563] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   13.208574] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   13.724874] Linux agpgart interface v0.103
[   13.728295] intel_rng: FWH not detected
[   13.749600] rtl8187se: module is from the staging directory, the
quality is unknown, you have been warned.
[   13.765354] ieee80211_crypt: registered algorithm 'NULL'
[   13.765372] ieee80211_crypt: registered algorithm 'TKIP'
[   13.765386] ieee80211_crypt: registered algorithm 'CCMP'
[   13.765399] ieee80211_crypt: registered algorithm 'WEP'
[   13.765411]
[   13.765415] Linux kernel driver for RTL8180 / RTL8185 based WLAN cards
[   13.765428] Copyright (c) 2004-2005, Andrea Merello
[   13.765438] r8180: Initializing module
[   13.765449] r8180: Wireless extensions version 22
[   13.765459] r8180: Initializing proc filesystem
[   13.765543] r8180: Configuring chip resources
[   13.765746] r8180 0000:02:00.0: PCI INT A -> GSI 18 (level, low) ->
IRQ 18
[   13.765770] r8180 0000:02:00.0: setting latency timer to 64
[   13.768675] r8180: Channel plan is 2
[   13.768683]
[   13.768694] Dot11d_Init()
[   13.768709] r8180: MAC controller is a RTL8187SE b/g
[   13.768720] r8180: This is a PCI NIC
[   13.771196] r8180: usValue is 0x100
[   13.771201]
[   13.796894] iTCO_vendor_support: vendor-support=0
[   13.805985] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   13.807276] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2,
TCOBASE=0x0460)
[   13.808409] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   13.827818] r8180: EEPROM version 104
[   13.832705] r8180: WW:**PLEASE** REPORT SUCCESSFUL/UNSUCCESSFUL TO
Realtek!
[   13.833739] r8180: IRQ 18
[   13.835232] r8180: Driver probe completed
[   13.835240]
[   14.041357] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[   14.041817] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[   14.046132] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[   14.063163] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   14.063229] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   14.063352] r8169 0000:01:00.0: setting latency timer to 64
[   14.063395] r8169 0000:01:00.0: no MSI. Back to INTx.
[   14.064962] eth0: RTL8102e at 0xf7c78000, 00:21:85:56:92:35, XID
34a00000 IRQ 16
[   14.107163] Linux video capture interface: v2.00
[   15.129919] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[   15.129988] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.331874] hda_codec: ALC888: BIOS auto-probing.
[   15.332927] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input9
[   15.599402] EXT4-fs (sda1): internal journal on sda1:8
[   15.927300] EXT4-fs (sda6): barriers enabled
[   15.954166] kjournald2 starting: pid 353, dev sda6:8, commit interval
5 seconds
[   15.954743] EXT4-fs (sda6): internal journal on sda6:8
[   15.954759] EXT4-fs (sda6): delayed allocation enabled
[   15.954771] EXT4-fs: file extents enabled
[   15.989628] EXT4-fs: mballoc enabled
[   15.989663] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   16.022740] Adding 1052216k swap on /dev/sda5.  Priority:-1 extents:1
across:1052216k
[   19.118886] r8180: Bringing up iface
[   19.319028] r8180: Card successfully reset
[   20.061985] r8180: WIRELESS_MODE_G
[   20.061988]
[   23.118815] r8180: Setting SW wep key
[   23.737202] r8180: Setting SW wep key
[   25.271069] r8180: Setting SW wep key
[   25.887304] microcode: CPU0 sig=0x106c2, pf=0x4, revision=0x20a
[   25.887318] platform microcode: firmware: requesting intel-ucode/06-1c-02
[   25.994575] microcode: CPU1 sig=0x106c2, pf=0x4, revision=0x20a
[   25.994590] platform microcode: firmware: requesting intel-ucode/06-1c-02
[   26.047675] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   26.068737] r8180: Setting SW wep key
[   26.870135] r8180: Bringing up iface
[   27.070556] r8180: Card successfully reset
[   27.816979] r8180: WIRELESS_MODE_G
[   27.816984]
[   27.831203] Linking with Pardus: channel is 6
[   29.208854] NET: Registered protocol family 10
[   29.491454] usb usb2: uevent
[   29.491857] usb 2-0:1.0: uevent
[   29.492218] usb usb3: uevent
[   29.493072] usb 3-0:1.0: uevent
[   29.493680] usb usb4: uevent
[   29.493997] usb 4-0:1.0: uevent
[   29.494719] usb usb5: uevent
[   29.495115] usb 5-0:1.0: uevent
[   29.495853] usb usb1: uevent
[   29.496175] usb 1-0:1.0: uevent
[   29.496720] usb 1-5: uevent
[   29.497047] usb 1-5:1.0: uevent
[   29.497232] usb 1-5:1.1: uevent
[   29.497891] usb 1-6: uevent
[   29.498660] usb 1-6:1.0: uevent
[   29.709009] microcode: CPU0 updated to revision 0x218, date = 2009-04-10
[   29.717996] microcode: CPU1 updated to revision 0x218, date = 2009-04-10
[   30.165670] [drm] Initialized drm 1.1.0 20060810
[   30.244767] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   30.244780] pci 0000:00:02.0: setting latency timer to 64
[   30.248475] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
minor 0
[   30.345026] Linking with Pardus: channel is 6
[   30.449280] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   30.449289] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   30.452653] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   30.452660] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   30.598658] lo: Disabled Privacy Extensions
[   30.599686] bootsplash: status on console 0 changed to on
[   30.608181] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   31.515721] atkbd.c: Unknown key pressed (translated set 2, code 0xf8
on isa0060/serio0).
[   31.515739] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   31.519118] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[   31.519137] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   31.670004] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   31.670005] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   31.673509] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   31.673518] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   32.032035] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   32.032054] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   32.035716] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   32.035734] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   32.314940] atkbd.c: Unknown key pressed (translated set 2, code 0xf8
on isa0060/serio0).
[   32.314960] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   32.318468] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[   32.318487] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   32.614104] Linking with Pardus: channel is 6
[   32.945130] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   32.945140] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   32.948543] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   32.948554] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   34.630080] Linking with Pardus: channel is 6
[   35.665474] Linking with Pardus: channel is 6
[   35.706384] Linking with Pardus: channel is 6
[   35.723889] Associated successfully
[   35.723902] Using G rates
[   35.738209] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   36.848758] padlock: VIA PadLock not detected.
[   40.698004] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   40.698023] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   40.701491] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   40.701507] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   41.718601] atkbd.c: Unknown key pressed (translated set 2, code 0xf8
on isa0060/serio0).
[   41.718612] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   41.721992] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[   41.722002] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   42.448795] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   42.448803] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   42.452207] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   42.452216] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   43.008204] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   43.008219] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   43.011758] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   43.011777] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   43.291435] atkbd.c: Unknown key pressed (translated set 2, code 0xf8
on isa0060/serio0).
[   43.291454] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   43.294937] atkbd.c: Unknown key released (translated set 2, code
0xf8 on isa0060/serio0).
[   43.294956] atkbd.c: Use 'setkeycodes e078 <keycode>' to make it known.
[   43.355400] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   43.355419] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   43.358777] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   43.358797] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   46.092052] wlan0: no IPv6 routers present
[   50.533266] usb usb1: uevent
[   50.533667] usb 1-0:1.0: uevent
[   50.533892] usb usb2: uevent
[   50.534468] usb 2-0:1.0: uevent
[   50.534711] usb usb3: uevent
[   50.535201] usb 3-0:1.0: uevent
[   50.535446] usb usb4: uevent
[   50.535801] usb 4-0:1.0: uevent
[   50.536228] usb usb5: uevent
[   50.537422] usb 5-0:1.0: uevent
[   50.537837] usb 1-5: uevent
[   50.538609] usb 1-5:1.0: uevent
[   50.538847] usb 1-5:1.1: uevent
[   50.539196] usb 1-6: uevent
[   50.539567] usb 1-6:1.0: uevent
[   58.130526] atkbd.c: Unknown key pressed (translated set 2, code 0xf7
on isa0060/serio0).
[   58.130546] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   58.134020] atkbd.c: Unknown key released (translated set 2, code
0xf7 on isa0060/serio0).
[   58.134040] atkbd.c: Use 'setkeycodes e077 <keycode>' to make it known.
[   58.362156] CPU0 attaching NULL sched-domain.
[   58.362167] CPU1 attaching NULL sched-domain.
[   58.365231] CPU0 attaching sched-domain:
[   58.365246]  domain 0: span 0-1 level SIBLING
[   58.365266]   groups: 0 1
[   58.365293] CPU1 attaching sched-domain:
[   58.365307]  domain 0: span 0-1 level SIBLING
[   58.365320]   groups: 1 0
[  209.834549] CCMP: replay detected: STA=00:c0:49:f1:29:0a previous PN
00000000002f received PN 00000000002f
[  209.840751] CCMP: replay detected: STA=00:c0:49:f1:29:0a previous PN
000000000034 received PN 000000000034
[  420.692160] uvcvideo 1-5:1.0: usb_probe_interface
[  420.692172] uvcvideo 1-5:1.0: usb_probe_interface - got id
[  420.692218] uvcvideo: Found UVC 1.00 device BisonCam, NB Pro (5986:0203)
[  420.696447] input: BisonCam, NB Pro as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input10
[  420.697847] usbcore: registered new interface driver uvcvideo
[  420.698411] USB Video Class driver (v0.1.0)
[  420.707352] usb 1-5:1.0: uevent
[  420.707592] usb 1-5: uevent
[  420.712895] usb 1-5:1.0: uevent
[  420.737748] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]
[  420.737891] usb 1-5: unlink qh1024-0001/f6ffe280 start 1 [1/0 us]
[  420.741605] usb 1-5:1.0: uevent
[  420.741957] usb 1-5: uevent
[  420.745592] usb 1-5:1.0: uevent
[  420.807880] ehci_hcd 0000:00:1d.7: reused qh f6ffe280 schedule
[  420.807894] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]
[  420.808780] ehci_hcd 0000:00:1d.7: force halt; handhake f7c6a024
00004000 00000000 -> -110
[  421.149911] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.149921] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.149932] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.149940] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.149950] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.149957] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.149966] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.149973] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.149983] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.149989] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.149996] hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable
is bad?
[  421.150007] hub 1-0:1.0: cannot disable port 6 (err = -108)
[  421.150017] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150024] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150034] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150040] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150049] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150056] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150066] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150072] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150081] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150087] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150095] hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable
is bad?
[  421.150105] hub 1-0:1.0: cannot disable port 6 (err = -108)
[  421.150117] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150124] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150134] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150141] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150151] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150158] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150167] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150174] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150184] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150190] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150197] hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable
is bad?
[  421.150206] hub 1-0:1.0: cannot disable port 6 (err = -108)
[  421.150217] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150223] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150232] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150238] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150247] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150287] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150299] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150305] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150315] hub 1-0:1.0: cannot reset port 6 (err = -108)
[  421.150322] hub 1-0:1.0: port 6 not enabled, trying reset again...
[  421.150330] hub 1-0:1.0: Cannot enable port 6.  Maybe the USB cable
is bad?
[  421.150340] hub 1-0:1.0: cannot disable port 6 (err = -108)
[  421.150348] hub 1-0:1.0: logical disconnect on port 6
[  421.150359] hub 1-0:1.0: cannot disable port 6 (err = -108)
[  421.150379] hub 1-0:1.0: state 7 ports 8 chg 0040 evt 0000
[  421.150393] hub 1-0:1.0: hub_port_status failed (err = -108)


