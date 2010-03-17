Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50758 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751638Ab0CQBKF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 21:10:05 -0400
Subject: Hauppauge WinTV HVR-1400 firmware loading problem
From: Alina Friedrichsen <x-alina@gmx.net>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-OLprgaohrrYkz4Smo39H"
Date: Wed, 17 Mar 2010 02:09:56 +0100
Message-ID: <1268788196.1536.18.camel@destiny>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-OLprgaohrrYkz4Smo39H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

My kernel is 2.6.33.
When I want to watch DVB-T with VLC, loading the firmwares stops after
the following and don't see any pictures:

cx23885 0000:03:00.0: firmware: requesting xc3028L-v36.fw
xc2028 3-0064: Loading 81 firmware images from xc3028L-v36.fw, type:
xc2028 firmware, ver 3.6
xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
0000000000000000.

And hangs forever. Any retries has the same effect.

But if I start "scan /usr/share/dvb/dvb-t/de-Berlin" the tuning fails
two times, then all firmwares load correctly and scanning works.

xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
0000000000000000.
xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id
0000000000000000.
xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id
0000000000000000.
xc2028 3-0064: Loading firmware for type=D2633 DTV78 (110), id
0000000000000000.
xc2028 3-0064: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE
HAS_IF_5200 (61000300), id 0000000000000000.

After that all other firmware loadings works fine and I can watch TV.

Any idea whats goes wrong? Is this a problem of the driver, or is my
express card broken? I unfortunately has no other card to test.

Thanks!
Alina



--=-OLprgaohrrYkz4Smo39H
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.33 (x-alina@destiny) (gcc version 4.4.3 (Ubuntu 4.4.3-3ubuntu3) ) #1 SMP Sun Mar 14 19:57:25 CET 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33 root=UUID=9c140ba2-1f4d-4557-abeb-e42b86ad877b ro elevator=deadline quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e90000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e90000 - 00000000c7ea8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7ea8000 - 00000000c7ed0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7ed0000 - 00000000c7f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x138000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000138000000 aka 4992M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xc7e90 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7e90000 (usable)
[    0.000000]  modified: 00000000c7e90000 - 00000000c7ea8000 (ACPI data)
[    0.000000]  modified: 00000000c7ea8000 - 00000000c7ed0000 (ACPI NVS)
[    0.000000]  modified: 00000000c7ed0000 - 00000000c7f00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000138000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7e90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00c7e00000 page 2M
[    0.000000]  00c7e00000 - 00c7e90000 page 4k
[    0.000000] kernel direct mapping tables up to c7e90000 @ 16000-19000
[    0.000000] init_memory_mapping: 0000000100000000-0000000138000000
[    0.000000]  0100000000 - 0138000000 page 2M
[    0.000000] kernel direct mapping tables up to 138000000 @ 18000-1a000
[    0.000000] RAMDISK: 341f8000 - 37feffdb
[    0.000000] ACPI: RSDP 00000000000fb860 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000c7e90100 00054 (v01 111909 XSDT1708 20091119 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000c7e90290 000F4 (v03 111909 FACP1708 20091119 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20091214/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000c7e90440 0E638 (v01  A1160 A1160000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 00000000c7ea8000 00040
[    0.000000] ACPI: APIC 00000000c7e90390 0006C (v01 111909 APIC1708 20091119 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000c7e90400 0003C (v01 111909 OEMMCFG  20091119 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000c7ea8040 00072 (v01 111909 OEMB1708 20091119 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000c7e9f440 00038 (v01 111909 OEMHPET  20091119 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000c7e9f480 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000138000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000138000000
[    0.000000]   NODE_DATA [0000000000019000 - 000000000001dfff]
[    0.000000]   bootmap [000000000001e000 -  0000000000044fff] pages 27
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 0138000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 0001cb4154]    TEXT DATA BSS ==> [0001000000 - 0001cb4154]
[    0.000000]   #2 [00341f8000 - 0037feffdb]          RAMDISK ==> [00341f8000 - 0037feffdb]
[    0.000000]   #3 [0001cb5000 - 0001cb529c]              BRK ==> [0001cb5000 - 0001cb529c]
[    0.000000]   #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #6 [000009fc00 - 00000f1160]    BIOS reserved ==> [000009fc00 - 00000f1160]
[    0.000000]   #7 [00000f1334 - 00000ff780]    BIOS reserved ==> [00000f1334 - 00000ff780]
[    0.000000]   #8 [00000f1160 - 00000f1334]     MP-table mpc ==> [00000f1160 - 00000f1334]
[    0.000000]   #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #11 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
[    0.000000]   #12 [0000018000 - 0000019000]          PGTABLE ==> [0000018000 - 0000019000]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00138000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000c7e90
[    0.000000]     0: 0x00100000 -> 0x00138000
[    0.000000] On node 0 totalpages: 1048095
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3822 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800456 pages, LIFO batch:31
[    0.000000]   Normal zone: 3136 pages used for memmap
[    0.000000]   Normal zone: 226240 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c7e90000 - 00000000c7ea8000
[    0.000000] PM: Registered nosave memory: 00000000c7ea8000 - 00000000c7ed0000
[    0.000000] PM: Registered nosave memory: 00000000c7ed0000 - 00000000c7f00000
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: c7f00000:38000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s91544 r8192 d23144 u524288
[    0.000000] pcpu-alloc: s91544 r8192 d23144 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1030518
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33 root=UUID=9c140ba2-1f4d-4557-abeb-e42b86ad877b ro elevator=deadline quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 864a000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 3924296k/5111808k available (5446k kernel code, 919428k absent, 268084k reserved, 5550k data, 876k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3411.284 MHz processor.
[    0.020004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6822.55 BogoMIPS (lpj=34112790)
[    0.020020] Security Framework initialized
[    0.020024] SELinux:  Disabled at boot.
[    0.020226] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.021238] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.021692] Mount-cache hash table entries: 256
[    0.021773] Initializing cgroup subsys ns
[    0.021775] Initializing cgroup subsys cpuacct
[    0.021778] Initializing cgroup subsys memory
[    0.021783] Initializing cgroup subsys devices
[    0.021784] Initializing cgroup subsys freezer
[    0.021786] Initializing cgroup subsys net_cls
[    0.021798] tseg: 0000000000
[    0.021809] CPU: Physical Processor ID: 0
[    0.021810] CPU: Processor Core ID: 0
[    0.021811] mce: CPU supports 6 MCE banks
[    0.021818] using C1E aware idle routine
[    0.021819] Performance Events: AMD PMU driver.
[    0.021822] ... version:                0
[    0.021823] ... bit width:              48
[    0.021824] ... generic registers:      4
[    0.021825] ... value mask:             0000ffffffffffff
[    0.021826] ... max period:             00007fffffffffff
[    0.021827] ... fixed-purpose events:   0
[    0.021828] ... event mask:             000000000000000f
[    0.022902] ACPI: Core revision 20091214
[    0.040005] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040008] ftrace: allocating 21547 entries in 85 pages
[    0.044509] Setting APIC routing to flat
[    0.044801] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.148016] CPU0: AMD Phenom(tm) II X4 965 Processor stepping 03
[    0.150000] Booting Node   0, Processors  #1 #2 #3 Ok.
[    0.650008] Brought up 4 CPUs
[    0.650009] Total of 4 processors activated (27292.35 BogoMIPS).
[    0.651709] devtmpfs: initialized
[    0.651709] regulator: core version 0.5
[    0.651709] Time:  0:38:17  Date: 03/17/10
[    0.651709] NET: Registered protocol family 16
[    0.651709] node 0 link 0: io port [1000, ffffff]
[    0.651709] TOM: 00000000c8000000 aka 3200M
[    0.651709] Fam 10h mmconf [e0000000, efffffff]
[    0.651709] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.651709] node 0 link 0: mmio [f0000000, ffffffff]
[    0.651709] node 0 link 0: mmio [a0000, bffff]
[    0.651709] node 0 link 0: mmio [c8000000, dfffffff]
[    0.651709] TOM2: 0000000138000000 aka 4992M
[    0.651709] bus: [00, 07] on node 0 link 0
[    0.651709] bus: 00 index 0 io port: [0, ffff]
[    0.651709] bus: 00 index 1 mmio: [f0000000, ffffffff]
[    0.651709] bus: 00 index 2 mmio: [a0000, bffff]
[    0.651709] bus: 00 index 3 mmio: [c8000000, dfffffff]
[    0.651709] bus: 00 index 4 mmio: [138000000, fcffffffff]
[    0.651709] ACPI: bus type pci registered
[    0.651709] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.651709] PCI: not using MMCONFIG
[    0.651709] PCI: Using configuration type 1 for base access
[    0.651709] PCI: Using configuration type 1 for extended access
[    0.651709] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.651709] mtrr: probably your BIOS does not setup all CPUs.
[    0.651709] mtrr: corrected configuration.
[    0.651709] bio: create slab <bio-0> at 0
[    0.651709] ACPI: EC: Look up EC in DSDT
[    0.653182] ACPI: Executed 3 blocks of module-level executable AML code
[    0.852106] ACPI: Interpreter enabled
[    0.852110] ACPI: (supports S0 S1 S3 S4 S5)
[    0.852126] ACPI: Using IOAPIC for interrupt routing
[    0.852168] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.855405] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.865869] ACPI Warning: Incorrect checksum in table [OEMB] - 71, should be 68 (20091214/tbutils-314)
[    0.865972] ACPI: No dock devices found.
[    0.866080] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.866095] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.866305] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.866306] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.866308] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.866309] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.866311] pci_root PNP0A03:00: host bridge window [mem 0xc7f00000-0xdfffffff] (ignored)
[    0.866312] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.866331] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.866379] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.866382] pci 0000:00:02.0: PME# disabled
[    0.866416] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.866418] pci 0000:00:06.0: PME# disabled
[    0.866448] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.866450] pci 0000:00:07.0: PME# disabled
[    0.866483] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.866485] pci 0000:00:0a.0: PME# disabled
[    0.866515] pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
[    0.866517] pci 0000:00:0b.0: PME# disabled
[    0.866555] pci 0000:00:11.0: reg 10: [io  0xa000-0xa007]
[    0.866561] pci 0000:00:11.0: reg 14: [io  0x9000-0x9003]
[    0.866567] pci 0000:00:11.0: reg 18: [io  0x8000-0x8007]
[    0.866573] pci 0000:00:11.0: reg 1c: [io  0x7000-0x7003]
[    0.866579] pci 0000:00:11.0: reg 20: [io  0x6000-0x600f]
[    0.866585] pci 0000:00:11.0: reg 24: [mem 0xfb1fe400-0xfb1fe7ff]
[    0.866601] pci 0000:00:11.0: set SATA to AHCI mode
[    0.866646] pci 0000:00:12.0: reg 10: [mem 0xfb1f6000-0xfb1f6fff]
[    0.866696] pci 0000:00:12.1: reg 10: [mem 0xfb1f7000-0xfb1f7fff]
[    0.866758] pci 0000:00:12.2: reg 10: [mem 0xfb1fe800-0xfb1fe8ff]
[    0.866808] pci 0000:00:12.2: supports D1 D2
[    0.866809] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.866812] pci 0000:00:12.2: PME# disabled
[    0.866840] pci 0000:00:13.0: reg 10: [mem 0xfb1fc000-0xfb1fcfff]
[    0.866891] pci 0000:00:13.1: reg 10: [mem 0xfb1fd000-0xfb1fdfff]
[    0.866952] pci 0000:00:13.2: reg 10: [mem 0xfb1fec00-0xfb1fecff]
[    0.867002] pci 0000:00:13.2: supports D1 D2
[    0.867003] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.867007] pci 0000:00:13.2: PME# disabled
[    0.867108] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.867114] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.867120] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.867126] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.867131] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.867190] pci 0000:00:14.2: reg 10: [mem 0xfb1f8000-0xfb1fbfff 64bit]
[    0.867231] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.867234] pci 0000:00:14.2: PME# disabled
[    0.867330] pci 0000:00:14.5: reg 10: [mem 0xfb1ff000-0xfb1fffff]
[    0.867465] pci 0000:07:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.867472] pci 0000:07:00.0: reg 18: [mem 0xfbfe0000-0xfbfeffff 64bit]
[    0.867476] pci 0000:07:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.867483] pci 0000:07:00.0: reg 30: [mem 0xfbfc0000-0xfbfdffff pref]
[    0.867498] pci 0000:07:00.0: supports D1 D2
[    0.867521] pci 0000:07:00.1: reg 10: [mem 0xfbff0000-0xfbffffff 64bit]
[    0.867549] pci 0000:07:00.1: supports D1 D2
[    0.867597] pci 0000:00:02.0: PCI bridge to [bus 07-07]
[    0.867600] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.867602] pci 0000:00:02.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.867605] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.867635] pci 0000:06:00.0: reg 10: [io  0xd800-0xd8ff]
[    0.867651] pci 0000:06:00.0: reg 18: [mem 0xfbeff000-0xfbefffff 64bit]
[    0.867667] pci 0000:06:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    0.867702] pci 0000:06:00.0: supports D1 D2
[    0.867703] pci 0000:06:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.867707] pci 0000:06:00.0: PME# disabled
[    0.867760] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    0.867762] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.867764] pci 0000:00:06.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.867815] pci 0000:05:00.0: reg 10: [mem 0xfbdff800-0xfbdfffff 64bit]
[    0.867824] pci 0000:05:00.0: reg 18: [io  0xc800-0xc8ff]
[    0.867898] pci 0000:05:00.0: supports D2
[    0.867899] pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
[    0.867904] pci 0000:05:00.0: PME# disabled
[    0.867965] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    0.867968] pci 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
[    0.867970] pci 0000:00:07.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.867998] pci 0000:04:00.0: reg 10: [mem 0xfbcfe000-0xfbcfffff 64bit]
[    0.868041] pci 0000:04:00.0: PME# supported from D0 D3hot
[    0.868044] pci 0000:04:00.0: PME# disabled
[    0.868095] pci 0000:00:0a.0: PCI bridge to [bus 04-04]
[    0.868099] pci 0000:00:0a.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.868141] pci 0000:03:00.0: reg 10: [mem 0xfba00000-0xfbbfffff 64bit]
[    0.868224] pci 0000:03:00.0: supports D1 D2
[    0.868226] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot
[    0.868231] pci 0000:03:00.0: PME# disabled
[    0.868290] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.868294] pci 0000:00:0b.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    0.868337] pci 0000:01:06.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.868360] pci 0000:01:06.0: supports D1 D2
[    0.868361] pci 0000:01:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.868365] pci 0000:01:06.0: PME# disabled
[    0.868410] pci 0000:00:14.4: PCI bridge to [bus 01-02] (subtractive decode)
[    0.868414] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.868417] pci 0000:00:14.4:   bridge window [mem 0xfb200000-0xfb9fffff]
[    0.868421] pci 0000:00:14.4:   bridge window [mem 0xce000000-0xcfffffff pref]
[    0.868456] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.868591] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.868636] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.868671] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.868709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.868745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEB._PRT]
[    0.868793] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.872379] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.872456] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.872532] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.872607] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.872682] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.872758] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 12 14 15)
[    0.872832] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 *11 12 14 15)
[    0.872909] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.872980] vgaarb: device added: PCI:0000:07:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.872983] vgaarb: loaded
[    0.873034] SCSI subsystem initialized
[    0.873047] libata version 3.00 loaded.
[    0.873047] usbcore: registered new interface driver usbfs
[    0.873047] usbcore: registered new interface driver hub
[    0.873047] usbcore: registered new device driver usb
[    0.873047] ACPI: WMI: Mapper loaded
[    0.873047] PCI: Using ACPI for IRQ routing
[    0.873047] PCI: pci_cache_line_size set to 64 bytes
[    0.873047] pci 0000:00:00.0: address space collision: [mem 0xe0000000-0xffffffff 64bit] already in use
[    0.873047] pci 0000:00:00.0: can't reserve [mem 0xe0000000-0xffffffff 64bit]
[    0.873047] NetLabel: Initializing
[    0.873047] NetLabel:  domain hash size = 128
[    0.873047] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.873047] NetLabel:  unlabeled traffic allowed by default
[    0.873047] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.873047] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.873047] Switching to clocksource tsc
[    0.873047] pnp: PnP ACPI init
[    0.873047] ACPI: bus type pnp registered
[    0.873598] pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.873601] pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.873603] pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.873605] pnp 00:0e: disabling [mem 0x00100000-0xc7efffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.873850] pnp: PnP ACPI: found 15 devices
[    0.873851] ACPI: ACPI bus type pnp unregistered
[    0.873858] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.873859] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.873862] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.873864] system 00:07: [io  0x040b] has been reserved
[    0.873865] system 00:07: [io  0x04d6] has been reserved
[    0.873867] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.873868] system 00:07: [io  0x0c14] has been reserved
[    0.873869] system 00:07: [io  0x0c50-0x0c51] has been reserved
[    0.873871] system 00:07: [io  0x0c52] has been reserved
[    0.873872] system 00:07: [io  0x0c6c] has been reserved
[    0.873874] system 00:07: [io  0x0c6f] has been reserved
[    0.873875] system 00:07: [io  0x0cd0-0x0cd1] has been reserved
[    0.873876] system 00:07: [io  0x0cd2-0x0cd3] has been reserved
[    0.873878] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
[    0.873879] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
[    0.873881] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
[    0.873882] system 00:07: [io  0x0b00-0x0b3f] has been reserved
[    0.873884] system 00:07: [io  0x0800-0x089f] has been reserved
[    0.873885] system 00:07: [io  0x0b00-0x0b0f] has been reserved
[    0.873887] system 00:07: [io  0x0b20-0x0b3f] has been reserved
[    0.873888] system 00:07: [io  0x0900-0x090f] has been reserved
[    0.873890] system 00:07: [io  0x0910-0x091f] has been reserved
[    0.873891] system 00:07: [io  0xfe00-0xfefe] has been reserved
[    0.873893] system 00:07: [mem 0xc7f00000-0xc7ffffff] could not be reserved
[    0.873895] system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.873896] system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.873900] system 00:0c: [io  0x0230-0x023f] has been reserved
[    0.873901] system 00:0c: [io  0x0290-0x029f] has been reserved
[    0.873903] system 00:0c: [io  0x0f40-0x0f4f] has been reserved
[    0.873904] system 00:0c: [io  0x0a30-0x0a3f] has been reserved
[    0.873907] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.873911] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.878547] pci 0000:00:02.0: PCI bridge to [bus 07-07]
[    0.878549] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.878551] pci 0000:00:02.0:   bridge window [mem 0xfbf00000-0xfbffffff]
[    0.878553] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.878556] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    0.878558] pci 0000:00:06.0:   bridge window [io  0xd000-0xdfff]
[    0.878560] pci 0000:00:06.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.878562] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.878565] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    0.878566] pci 0000:00:07.0:   bridge window [io  0xc000-0xcfff]
[    0.878569] pci 0000:00:07.0:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.878570] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.878573] pci 0000:00:0a.0: PCI bridge to [bus 04-04]
[    0.878574] pci 0000:00:0a.0:   bridge window [io  disabled]
[    0.878576] pci 0000:00:0a.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    0.878578] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    0.878581] pci 0000:00:0b.0: PCI bridge to [bus 03-03]
[    0.878582] pci 0000:00:0b.0:   bridge window [io  disabled]
[    0.878584] pci 0000:00:0b.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    0.878586] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    0.878590] pci 0000:01:06.0: BAR 15: assigned [mem 0xc8000000-0xcbffffff pref]
[    0.878592] pci 0000:01:06.0: BAR 16: assigned [mem 0xf0000000-0xf3ffffff]
[    0.878594] pci 0000:01:06.0: BAR 0: assigned [mem 0xfb200000-0xfb200fff]
[    0.878598] pci 0000:01:06.0: BAR 0: set to [mem 0xfb200000-0xfb200fff] (PCI address [0xfb200000-0xfb200fff]
[    0.878600] pci 0000:01:06.0: BAR 13: assigned [io  0xb000-0xb0ff]
[    0.878602] pci 0000:01:06.0: BAR 14: assigned [io  0xb400-0xb4ff]
[    0.878603] pci 0000:01:06.0: CardBus bridge to [bus 02-02]
[    0.878604] pci 0000:01:06.0:   bridge window [io  0xb000-0xb0ff]
[    0.878608] pci 0000:01:06.0:   bridge window [io  0xb400-0xb4ff]
[    0.878613] pci 0000:01:06.0:   bridge window [mem 0xc8000000-0xcbffffff pref]
[    0.878617] pci 0000:01:06.0:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.878621] pci 0000:00:14.4: PCI bridge to [bus 01-02]
[    0.878623] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.878628] pci 0000:00:14.4:   bridge window [mem 0xfb200000-0xfb9fffff]
[    0.878631] pci 0000:00:14.4:   bridge window [mem 0xce000000-0xcfffffff pref]
[    0.878641]   alloc irq_desc for 18 on node 0
[    0.878642]   alloc kstat_irqs on node 0
[    0.878645] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.878647] pci 0000:00:02.0: setting latency timer to 64
[    0.878651] pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.878654] pci 0000:00:06.0: setting latency timer to 64
[    0.878657]   alloc irq_desc for 19 on node 0
[    0.878658]   alloc kstat_irqs on node 0
[    0.878660] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.878662] pci 0000:00:07.0: setting latency timer to 64
[    0.878666] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.878668] pci 0000:00:0a.0: setting latency timer to 64
[    0.878671] pci 0000:00:0b.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.878673] pci 0000:00:0b.0: setting latency timer to 64
[    0.878686]   alloc irq_desc for 21 on node 0
[    0.878687]   alloc kstat_irqs on node 0
[    0.878689] pci 0000:01:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.878694] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.878695] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.878696] pci_bus 0000:07: resource 0 [io  0xe000-0xefff]
[    0.878698] pci_bus 0000:07: resource 1 [mem 0xfbf00000-0xfbffffff]
[    0.878699] pci_bus 0000:07: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.878701] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    0.878702] pci_bus 0000:06: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.878704] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.878705] pci_bus 0000:05: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.878707] pci_bus 0000:04: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.878708] pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbbfffff]
[    0.878709] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    0.878711] pci_bus 0000:01: resource 1 [mem 0xfb200000-0xfb9fffff]
[    0.878712] pci_bus 0000:01: resource 2 [mem 0xce000000-0xcfffffff pref]
[    0.878714] pci_bus 0000:01: resource 3 [io  0x0000-0xffff]
[    0.878715] pci_bus 0000:01: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.878717] pci_bus 0000:02: resource 0 [io  0xb000-0xb0ff]
[    0.878718] pci_bus 0000:02: resource 1 [io  0xb400-0xb4ff]
[    0.878719] pci_bus 0000:02: resource 2 [mem 0xc8000000-0xcbffffff pref]
[    0.878721] pci_bus 0000:02: resource 3 [mem 0xf0000000-0xf3ffffff]
[    0.878734] NET: Registered protocol family 2
[    0.878809] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.879395] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.881248] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.881479] TCP: Hash tables configured (established 524288 bind 65536)
[    0.881481] TCP reno registered
[    0.881486] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.881510] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.881582] NET: Registered protocol family 1
[    1.034461] pci 0000:07:00.0: Boot video device
[    1.034502] PCI: CLS 64 bytes, default 64
[    1.034536] Trying to unpack rootfs image as initramfs...
[    1.955743] Freeing initrd memory: 63455k freed
[    1.970064] PCI-DMA: Disabling AGP.
[    1.970152] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    1.970153] PCI-DMA: using GART IOMMU.
[    1.970156] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.973069] Scanning for low memory corruption every 60 seconds
[    1.973145] audit: initializing netlink socket (disabled)
[    1.973153] type=2000 audit(1268786297.970:1): initialized
[    1.980564] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.981373] VFS: Disk quotas dquot_6.5.2
[    1.981396] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.981706] fuse init (API version 7.13)
[    1.981747] msgmni has been set to 7917
[    1.981913] alg: No test for stdrng (krng)
[    1.981921] io scheduler noop registered
[    1.981922] io scheduler deadline registered (default)
[    1.981955] io scheduler cfq registered
[    1.982037] pcieport 0000:00:02.0: setting latency timer to 64
[    1.982058]   alloc irq_desc for 24 on node 0
[    1.982059]   alloc kstat_irqs on node 0
[    1.982065] pcieport 0000:00:02.0: irq 24 for MSI/MSI-X
[    1.982134] pcieport 0000:00:06.0: setting latency timer to 64
[    1.982151]   alloc irq_desc for 25 on node 0
[    1.982152]   alloc kstat_irqs on node 0
[    1.982155] pcieport 0000:00:06.0: irq 25 for MSI/MSI-X
[    1.982206] pcieport 0000:00:07.0: setting latency timer to 64
[    1.982222]   alloc irq_desc for 26 on node 0
[    1.982223]   alloc kstat_irqs on node 0
[    1.982226] pcieport 0000:00:07.0: irq 26 for MSI/MSI-X
[    1.982277] pcieport 0000:00:0a.0: setting latency timer to 64
[    1.982293]   alloc irq_desc for 27 on node 0
[    1.982294]   alloc kstat_irqs on node 0
[    1.982297] pcieport 0000:00:0a.0: irq 27 for MSI/MSI-X
[    1.982347] pcieport 0000:00:0b.0: setting latency timer to 64
[    1.982364]   alloc irq_desc for 28 on node 0
[    1.982365]   alloc kstat_irqs on node 0
[    1.982368] pcieport 0000:00:0b.0: irq 28 for MSI/MSI-X
[    1.982417] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.982430] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.982497] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.982508] ACPI: Power Button [PWRB]
[    1.982529] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.982530] ACPI: Power Button [PWRF]
[    1.986693] Linux agpgart interface v0.103
[    1.986695] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.986793] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.986998] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.987509] brd: module loaded
[    1.987728] loop: module loaded
[    1.987775] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.987848] ahci 0000:00:11.0: version 3.0
[    1.987855]   alloc irq_desc for 22 on node 0
[    1.987856]   alloc kstat_irqs on node 0
[    1.987859] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.987901]   alloc irq_desc for 29 on node 0
[    1.987902]   alloc kstat_irqs on node 0
[    1.987910] ahci 0000:00:11.0: irq 29 for MSI/MSI-X
[    1.987978] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.987981] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc sxs 
[    1.988161] scsi0 : ahci
[    1.988211] scsi1 : ahci
[    1.988239] scsi2 : ahci
[    1.988266] scsi3 : ahci
[    1.988331] ata1: SATA max UDMA/133 abar m1024@0xfb1fe400 port 0xfb1fe500 irq 29
[    1.988334] ata2: SATA max UDMA/133 abar m1024@0xfb1fe400 port 0xfb1fe580 irq 29
[    1.988336] ata3: SATA max UDMA/133 abar m1024@0xfb1fe400 port 0xfb1fe600 irq 29
[    1.988339] ata4: SATA max UDMA/133 abar m1024@0xfb1fe400 port 0xfb1fe680 irq 29
[    1.988522]   alloc irq_desc for 16 on node 0
[    1.988524]   alloc kstat_irqs on node 0
[    1.988526] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.988543] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.988589] scsi4 : pata_atiixp
[    1.988616] scsi5 : pata_atiixp
[    1.989431] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.989433] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.989799] Fixed MDIO Bus: probed
[    1.989815] PPP generic driver version 2.4.2
[    1.989844] tun: Universal TUN/TAP device driver, 1.6
[    1.989845] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.989887] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.989916]   alloc irq_desc for 17 on node 0
[    1.989917]   alloc kstat_irqs on node 0
[    1.989919] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.989932] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.989958] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.989983] ehci_hcd 0000:00:12.2: debug port 1
[    1.989998] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfb1fe800
[    2.000024] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.000090] hub 1-0:1.0: USB hub found
[    2.000093] hub 1-0:1.0: 6 ports detected
[    2.000176] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.000187] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.000204] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.000228] ehci_hcd 0000:00:13.2: debug port 1
[    2.000244] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfb1fec00
[    2.030017] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.030080] hub 2-0:1.0: USB hub found
[    2.030082] hub 2-0:1.0: 6 ports detected
[    2.030128] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.030169] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.030181] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.030198] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    2.030218] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfb1f6000
[    2.084093] hub 3-0:1.0: USB hub found
[    2.084098] hub 3-0:1.0: 3 ports detected
[    2.084167] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.084178] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    2.084195] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    2.084208] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfb1f7000
[    2.144085] hub 4-0:1.0: USB hub found
[    2.144091] hub 4-0:1.0: 3 ports detected
[    2.144161] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.144174] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.144193] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    2.144213] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfb1fc000
[    2.204092] hub 5-0:1.0: USB hub found
[    2.204097] hub 5-0:1.0: 3 ports detected
[    2.204166] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.204176] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    2.204194] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    2.204207] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfb1fd000
[    2.264087] hub 6-0:1.0: USB hub found
[    2.264092] hub 6-0:1.0: 3 ports detected
[    2.264162] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.264173] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    2.264190] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    2.264204] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfb1ff000
[    2.324091] hub 7-0:1.0: USB hub found
[    2.324096] hub 7-0:1.0: 2 ports detected
[    2.324139] uhci_hcd: USB Universal Host Controller Interface driver
[    2.324193] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    2.324535] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.324538] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.324587] mice: PS/2 mouse device common for all mice
[    2.324640] rtc_cmos 00:02: RTC can wake from S4
[    2.324658] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.324679] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.324727] device-mapper: uevent: version 1.0.3
[    2.324791] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    2.324874] device-mapper: multipath: version 1.1.1 loaded
[    2.324876] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.325036] cpuidle: using governor ladder
[    2.325037] cpuidle: using governor menu
[    2.325174] TCP cubic registered
[    2.325247] NET: Registered protocol family 10
[    2.325447] lo: Disabled Privacy Extensions
[    2.325557] NET: Registered protocol family 17
[    2.325593] powernow-k8: Found 1 AMD Phenom(tm) II X4 965 Processor processors (4 cpu cores) (version 2.20.00)
[    2.325619] powernow-k8:    0 : pstate 0 (3400 MHz)
[    2.325620] powernow-k8:    1 : pstate 1 (2700 MHz)
[    2.325621] powernow-k8:    2 : pstate 2 (2200 MHz)
[    2.325622] powernow-k8:    3 : pstate 3 (800 MHz)
[    2.326127] PM: Resume from disk failed.
[    2.326133] registered taskstats version 1
[    2.326388]   Magic number: 2:834:607
[    2.326442] rtc_cmos 00:02: setting system clock to 2010-03-17 00:38:18 UTC (1268786298)
[    2.326444] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.326444] EDD information not available.
[    2.330561] ata1: SATA link down (SStatus 0 SControl 300)
[    2.330587] ata4: SATA link down (SStatus 0 SControl 300)
[    2.330628] ata2: SATA link down (SStatus 0 SControl 300)
[    2.353334] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.460029] usb 2-6: new high speed USB device using ehci_hcd and address 3
[    2.510036] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.510198] ata3.00: ATA-7: OCZ-VERTEX, 1.30, max UDMA/133
[    2.510200] ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    2.510377] ata3.00: configured for UDMA/133
[    2.531332] scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.30 PQ: 0 ANSI: 5
[    2.531410] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    2.531418] sd 2:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    2.531461] sd 2:0:0:0: [sda] Write Protect is off
[    2.531462] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.531472] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.531546]  sda: sda1
[    2.531813] sd 2:0:0:0: [sda] Attached SCSI disk
[    2.710341] ata6.00: ATAPI: HL-DT-ST DVDRAM GH22LS50, TL01, max UDMA/100
[    2.750349] ata6.00: configured for UDMA/100
[    2.758796] scsi 5:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22LS50  TL01 PQ: 0 ANSI: 5
[    2.760025] usb 6-2: new full speed USB device using ohci_hcd and address 2
[    2.779848] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.779850] Uniform CD-ROM driver Revision: 3.20
[    2.779893] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    2.779918] sr 5:0:0:0: Attached scsi generic sg1 type 5
[    2.779940] Freeing unused kernel memory: 876k freed
[    2.780105] Write protecting the kernel read-only data: 10240k
[    2.780205] Freeing unused kernel memory: 676k freed
[    2.780426] Freeing unused kernel memory: 1796k freed
[    2.788719] udev: starting version 151
[    2.807420] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.807436] r8169 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.807487] r8169 0000:06:00.0: setting latency timer to 64
[    2.807530]   alloc irq_desc for 30 on node 0
[    2.807531]   alloc kstat_irqs on node 0
[    2.807542] r8169 0000:06:00.0: irq 30 for MSI/MSI-X
[    2.807799] eth0: RTL8168b/8111b at 0xffffc90011172000, 00:26:18:78:3a:5d, XID 18000000 IRQ 30
[    2.823880] Initializing USB Mass Storage driver...
[    2.824975] Floppy drive(s): fd0 is 1.44M
[    2.825221] scsi6 : usb-storage 2-6:1.0
[    2.825294] usbcore: registered new interface driver usb-storage
[    2.825295] USB Mass Storage support registered.
[    2.826387] EXT4-fs (sda1): mounted filesystem without journal
[    2.827749] ohci1394 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.827756] ohci1394 0000:05:00.0: setting latency timer to 64
[    2.846356] FDC 0 is a post-1991 82077
[    2.882059] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[fbdff800-fbdfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.013505] udev: starting version 151
[    3.084368] lp: driver loaded but no devices found
[    3.120253] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.120287] xhci_hcd 0000:04:00.0: setting latency timer to 64
[    3.120289] xhci_hcd 0000:04:00.0: xHCI Host Controller
[    3.120341] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[    3.120441] xhci_hcd 0000:04:00.0: irq 18, io mem 0xfbcfe000
[    3.120467] usb usb8: config 1 interface 0 altsetting 0 endpoint 0x81 has no SuperSpeed companion descriptor
[    3.120518] xHCI xhci_add_endpoint called for root hub
[    3.120519] xHCI xhci_check_bandwidth called for root hub
[    3.120538] hub 8-0:1.0: USB hub found
[    3.120541] hub 8-0:1.0: 4 ports detected
[    3.134916] EDAC MC: Ver: 2.1.0 Mar 14 2010
[    3.137294] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    3.137337] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.170179] EDAC amd64_edac:  Ver: 3.3.0 Mar 14 2010
[    3.170227] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[    3.170232] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    3.170233]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    3.170234]  (Note that use of the override may cause unknown side effects.)
[    3.170243] amd64_edac: probe of 0000:00:18.2 failed with error -22
[    3.276945] [drm] Initialized drm 1.1.0 20060810
[    3.328879] Bluetooth: Core ver 2.15
[    3.328975] NET: Registered protocol family 31
[    3.328976] Bluetooth: HCI device and connection manager initialized
[    3.328978] Bluetooth: HCI socket layer initialized
[    3.357480] yenta_cardbus 0000:01:06.0: CardBus bridge found [0000:0000]
[    3.366203] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    3.366271] usbcore: registered new interface driver btusb
[    3.422573] Bluetooth: L2CAP ver 2.14
[    3.422575] Bluetooth: L2CAP socket layer initialized
[    3.490670] yenta_cardbus 0000:01:06.0: ISA IRQ mask 0x0000, PCI irq 21
[    3.490673] yenta_cardbus 0000:01:06.0: Socket status: 30000820
[    3.490678] yenta_cardbus 0000:01:06.0: pcmcia: parent PCI bridge I/O window: 0xb000 - 0xbfff
[    3.490681] yenta_cardbus 0000:01:06.0: pcmcia: parent PCI bridge Memory window: 0xfb200000 - 0xfb9fffff
[    3.490683] yenta_cardbus 0000:01:06.0: pcmcia: parent PCI bridge Memory window: 0xce000000 - 0xcfffffff
[    3.507140] r8169: eth0: link down
[    3.507147] r8169: eth0: link down
[    3.507450] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    3.625607] [drm] radeon defaulting to kernel modesetting.
[    3.625609] [drm] radeon kernel modesetting enabled.
[    3.625697] radeon 0000:07:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.625701] radeon 0000:07:00.0: setting latency timer to 64
[    3.626801] [drm] radeon: Initializing kernel modesetting.
[    3.626943] [drm] register mmio base: 0xFBFE0000
[    3.626945] [drm] register mmio size: 65536
[    3.627469] ATOM BIOS: RV570
[    3.627682] [drm] GPU reset succeed (RBBM_STATUS=0x10000140)
[    3.627693] [drm] Generation 2 PCI interface, using max accessible memory
[    3.627695] [drm] radeon: VRAM 256M
[    3.627696] [drm] radeon: VRAM from 0x00000000 to 0x0FFFFFFF
[    3.627697] [drm] radeon: GTT 512M
[    3.627698] [drm] radeon: GTT from 0x20000000 to 0x3FFFFFFF
[    3.627731]   alloc irq_desc for 31 on node 0
[    3.627732]   alloc kstat_irqs on node 0
[    3.627740] radeon 0000:07:00.0: irq 31 for MSI/MSI-X
[    3.627744] [drm] radeon: using MSI.
[    3.627762] [drm] radeon: irq initialized.
[    3.629858] [drm] Detected VRAM RAM=256M, BAR=256M
[    3.629861] [drm] RAM width 256bits DDR
[    3.630022] [TTM] Zone  kernel: Available graphics memory: 2028526 kiB.
[    3.630033] [drm] radeon: 256M of VRAM memory ready
[    3.630034] [drm] radeon: 512M of GTT memory ready.
[    3.630045] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.631596] [drm] radeon: 3 quad pipes, 1 z pipes initialized.
[    3.631637] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[    3.631649] [drm] radeon: cp idle (0x10000C03)
[    3.631682] [drm] Loading R500 Microcode
[    3.631684] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[    3.642978] [drm] radeon: ring at 0x0000000020000000
[    3.642998] [drm] ring test succeeded in 2 usecs
[    3.643055] [drm] radeon: ib pool ready.
[    3.643097] [drm] ib test succeeded in 0 usecs
[    3.643158] [drm] Default TV standard: PAL
[    3.643192] [drm] Radeon Display Connectors
[    3.643193] [drm] Connector 0:
[    3.643193] [drm]   DVI-I
[    3.643194] [drm]   HPD2
[    3.643196] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    3.643197] [drm]   Encoders:
[    3.643197] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.643198] [drm]     DFP3: INTERNAL_LVTM1
[    3.643199] [drm] Connector 1:
[    3.643200] [drm]   S-video
[    3.643201] [drm]   Encoders:
[    3.643201] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    3.643202] [drm] Connector 2:
[    3.643203] [drm]   DVI-I
[    3.643203] [drm]   HPD1
[    3.643205] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    3.643206] [drm]   Encoders:
[    3.643206] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    3.643207] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[    3.647207] ppdev: user-space parallel port driver
[    3.682137] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.682138] Bluetooth: BNEP filters: protocol multicast
[    3.758372] Bridge firewalling registered
[    3.785698] Linux video capture interface: v2.00
[    3.786553] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
[    3.791000] Bluetooth: SCO (Voice Link) ver 0.6
[    3.791001] Bluetooth: SCO socket layer initialized
[    3.813373] [drm] fb mappable at 0xD00C0000
[    3.813376] [drm] vram apper at 0xD0000000
[    3.813377] [drm] size 8294400
[    3.813377] [drm] fb depth is 24
[    3.813378] [drm]    pitch is 7680
[    3.813450] fb0: radeondrmfb frame buffer device
[    3.813451] registered panic notifier
[    3.813454] [drm] Initialized radeon 2.0.0 20080528 for 0000:07:00.0 on minor 0
[    3.878843] cx23885 driver version 0.0.2 loaded
[    3.879293] cx23885 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    3.879383] CORE cx23885[0]: subsystem: 0070:8010, board: Hauppauge WinTV-HVR1400 [card=9,autodetected]
[    3.947566] Console: switching to colour frame buffer device 240x67
[    4.021502] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.049325] tveeprom 2-0050: Hauppauge model 80019, rev B2F1, serial# 4943475
[    4.049327] tveeprom 2-0050: MAC address is 00-0D-FE-4B-6E-73
[    4.049328] tveeprom 2-0050: tuner model is Xceive XC3028L (idx 151, type 4)
[    4.049330] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    4.049332] tveeprom 2-0050: audio processor is CX23885 (idx 39)
[    4.049334] tveeprom 2-0050: decoder processor is CX23885 (idx 33)
[    4.049335] tveeprom 2-0050: has radio
[    4.049336] cx23885[0]: hauppauge eeprom: model=80019
[    4.049337] cx23885_dvb_register() allocating 1 frontend(s)
[    4.049355] cx23885[0]: cx23885 based dvb card
[    4.069380] Bluetooth: RFCOMM TTY layer initialized
[    4.069382] Bluetooth: RFCOMM socket layer initialized
[    4.069383] Bluetooth: RFCOMM ver 1.11
[    4.150983] xc2028 3-0064: creating new instance
[    4.150985] xc2028 3-0064: type set to XCeive xc2028/xc3028 tuner
[    4.150988] DVB: registering new adapter (cx23885[0])
[    4.150990] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[    4.151155] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    4.151161] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xfba00000
[    4.151167] cx23885 0000:03:00.0: setting latency timer to 64
[    4.151171] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    4.152514] pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
[    4.152559] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x0000ffff]
[    4.152655] pci 0000:02:00.0: BAR 0: assigned [mem 0xf0000000-0xf000ffff]
[    4.152662] pci 0000:02:00.0: BAR 0: set to [mem 0xf0000000-0xf000ffff] (PCI address [0xf0000000-0xf000ffff]
[    4.165738] hda_codec: ALC1200: BIOS auto-probing.
[    4.167274] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input5
[    4.225341] cfg80211: Calling CRDA to update world regulatory domain
[    4.234778] cfg80211: World regulatory domain updated:
[    4.234780]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    4.234782]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.234784]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.234785]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    4.234786]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.234788]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    4.331348] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c0001f9746f]
[    4.414400] ath5k 0000:02:00.0: enabling device (0000 -> 0002)
[    4.414410] ath5k 0000:02:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    4.414494] ath5k 0000:02:00.0: registered as 'phy0'
[    4.948687] r8169: eth0: link up
[    4.948979] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    5.006307] ath: EEPROM regdomain: 0x80d0
[    5.006308] ath: EEPROM indicates we should expect a country code
[    5.006309] ath: doing EEPROM country->regdmn map search
[    5.006310] ath: country maps to regdmn code: 0x37
[    5.006311] ath: Country alpha2 being used: DK
[    5.006312] ath: Regpair used: 0x37
[    5.010364] phy0: Selected rate control algorithm 'minstrel'
[    5.010663] ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
[    5.010673] cfg80211: Calling CRDA for country: DK
[    5.011634] cfg80211: Regulatory domain changed to country: DK
[    5.011636]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.011638]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    5.011639]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    5.011640]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[    5.011642]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[    5.056158] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    6.118627] cfg80211: Found new beacon on frequency: 2472 MHz (Ch 13) on phy0
[    7.820717] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    7.821337] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    7.821837] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    7.822461] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    7.822737] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    7.822796] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    7.822855] sd 6:0:0:2: Attached scsi generic sg4 type 0
[    7.825780] sd 6:0:0:3: Attached scsi generic sg5 type 0
[    8.375881] sd 6:0:0:3: [sde] Attached SCSI removable disk
[    8.376453] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    8.377076] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[    8.377452] sd 6:0:0:0: [sdb] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
[    8.380078] sd 6:0:0:0: [sdb] Write Protect is off
[    8.380080] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    8.380081] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.387332] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.387335]  sdb: sdb1
[    8.409957] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    8.409960] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   11.510028] usb 8-4: new high speed USB device using xhci_hcd and address 0
[   11.538289] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.539037] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.539661] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.540411] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.541913] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.542663] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[   11.543128] scsi7 : usb-storage 8-4:1.0
[   16.580439] scsi 7:0:0:0: Direct-Access     WDC WD16 00BEVS-08VAT2    1A14 PQ: 0 ANSI: 2 CCS
[   16.580660] sd 7:0:0:0: Attached scsi generic sg6 type 0
[   16.580980] sd 7:0:0:0: [sdf] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[   16.582134] sd 7:0:0:0: [sdf] Write Protect is off
[   16.582136] sd 7:0:0:0: [sdf] Mode Sense: 00 38 00 00
[   16.582138] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[   16.582923] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[   16.582925]  sdf: sdf1 sdf2
[   16.621658] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[   16.621661] sd 7:0:0:0: [sdf] Attached SCSI disk
[   16.714236] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[   16.715152] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[   25.179260] FAT: Filesystem error (dev sdb1)
[   25.179263]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179265]     File system has been set read-only
[   25.179371] FAT: Filesystem error (dev sdb1)
[   25.179372]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179457] FAT: Filesystem error (dev sdb1)
[   25.179458]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179539] FAT: Filesystem error (dev sdb1)
[   25.179540]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179619] FAT: Filesystem error (dev sdb1)
[   25.179620]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179700] FAT: Filesystem error (dev sdb1)
[   25.179701]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179780] FAT: Filesystem error (dev sdb1)
[   25.179781]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179859] FAT: Filesystem error (dev sdb1)
[   25.179860]     invalid access to FAT (entry 0xb7bbd5af)
[   25.179939] FAT: Filesystem error (dev sdb1)
[   25.179940]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180038] FAT: Filesystem error (dev sdb1)
[   25.180038]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180116] FAT: Filesystem error (dev sdb1)
[   25.180116]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180186] FAT: Filesystem error (dev sdb1)
[   25.180186]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180255] FAT: Filesystem error (dev sdb1)
[   25.180256]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180324] FAT: Filesystem error (dev sdb1)
[   25.180325]     invalid access to FAT (entry 0xb7bbd5af)
[   25.180394] FAT: Filesystem error (dev sdb1)
[   25.180394]     invalid access to FAT (entry 0xb7bbd5af)
[   25.183937] EXT4-fs (sdf2): warning: maximal mount count reached, running e2fsck is recommended
[   25.184793] EXT4-fs (sdf2): mounted filesystem with ordered data mode
[   25.185597] FAT: Filesystem error (dev sdb1)
[   25.185599]     invalid access to FAT (entry 0xb7bbd5af)
[   25.185696] FAT: Filesystem error (dev sdb1)
[   25.185698]     invalid access to FAT (entry 0xb7bbd5af)
[   25.186864] FAT: Filesystem error (dev sdb1)
[   25.186865]     invalid access to FAT (entry 0xb7bbd5af)
[   25.186955] FAT: Filesystem error (dev sdb1)
[   25.186956]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187041] FAT: Filesystem error (dev sdb1)
[   25.187042]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187124] FAT: Filesystem error (dev sdb1)
[   25.187125]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187205] FAT: Filesystem error (dev sdb1)
[   25.187206]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187285] FAT: Filesystem error (dev sdb1)
[   25.187286]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187365] FAT: Filesystem error (dev sdb1)
[   25.187366]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187444] FAT: Filesystem error (dev sdb1)
[   25.187445]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187524] FAT: Filesystem error (dev sdb1)
[   25.187525]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187601] FAT: Filesystem error (dev sdb1)
[   25.187602]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187677] FAT: Filesystem error (dev sdb1)
[   25.187678]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187747] FAT: Filesystem error (dev sdb1)
[   25.187748]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187816] FAT: Filesystem error (dev sdb1)
[   25.187817]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187885] FAT: Filesystem error (dev sdb1)
[   25.187886]     invalid access to FAT (entry 0xb7bbd5af)
[   25.187954] FAT: Filesystem error (dev sdb1)
[   25.187955]     invalid access to FAT (entry 0xb7bbd5af)
[   25.188128] FAT: Filesystem error (dev sdb1)
[   25.188129]     invalid access to FAT (entry 0xb7bbd5af)
[   25.188341] FAT: Filesystem error (dev sdb1)
[   25.188342]     invalid access to FAT (entry 0xb7bbd5af)
[   25.332786] FAT: Filesystem error (dev sdb1)
[   25.332789]     invalid access to FAT (entry 0xb7bbd5af)
[   25.333228] FAT: Filesystem error (dev sdb1)
[   25.333231]     invalid access to FAT (entry 0xb7bbd5af)
[   25.333271] FAT: Filesystem error (dev sdb1)
[   25.333272]     invalid access to FAT (entry 0xba29fcb1)
[   25.336563] FAT: Filesystem error (dev sdb1)
[   25.336565]     invalid access to FAT (entry 0xba29fcb1)
[   84.276882] cx23885 0000:03:00.0: firmware: requesting xc3028L-v36.fw
[   84.280859] xc2028 3-0064: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[   84.481088] xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   85.690168] xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[  153.345839] xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  154.560167] xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[  192.695780] xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  193.910163] xc2028 3-0064: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
[  205.180525] xc2028 3-0064: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[  205.194604] xc2028 3-0064: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
[  245.624934] xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  246.840157] xc2028 3-0064: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[  246.854188] xc2028 3-0064: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
[ 1230.095203] xc2028 3-0064: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[ 1231.310161] xc2028 3-0064: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1231.324207] xc2028 3-0064: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.

--=-OLprgaohrrYkz4Smo39H--

