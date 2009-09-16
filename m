Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.agmk.net ([91.192.224.71]:59630 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZIPIWx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 04:22:53 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Date: Wed, 16 Sep 2009 10:03:32 +0200
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
References: <200909160300.28382.pluto@agmk.net> <20090916085701.6e883600@hyperion.delvare>
In-Reply-To: <20090916085701.6e883600@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VvJsKt76p37KlA1"
Message-Id: <200909161003.33090.pluto@agmk.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_VvJsKt76p37KlA1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wednesday 16 September 2009 08:57:01 Jean Delvare wrote:
> Hi Pawel,
> 
> I think this would be fixed by the following patch:
> http://patchwork.kernel.org/patch/45707/

still oopses. this time i've attached full dmesg.

--Boundary-00=_VvJsKt76p37KlA1
Content-Type: text/plain;
  charset="utf-8";
  name="log.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
	filename="log.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-0.4 (pluto@pldmachine) (gcc version 4.4.1 20090724 (release) (PLD-Linux) ) #1 SMP Wed Sep 16 09:45:40 CEST 2009
[    0.000000] Command line: root=/dev/md0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
[    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff7e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 220000000 mask FF0000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff70 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009cc00 (usable)
[    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff70000 (usable)
[    0.000000]  modified: 00000000cff70000 - 00000000cff7e000 (ACPI data)
[    0.000000]  modified: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff70000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff70000 page 4k
[    0.000000] kernel direct mapping tables up to cff70000 @ 10000-16000
[    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0100000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ 11000-1b000
[    0.000000] RAMDISK: 37f50000 - 37fefb03
[    0.000000] ACPI: RSDP 00000000000fb460 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cff70100 0005C (v01 A_M_I_ OEMXSDT  08000820 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cff70290 000F4 (v03 A_M_I_ OEMFACP  08000820 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cff70440 0964B (v01  A1012 A1012001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000cff7e000 00040
[    0.000000] ACPI: APIC 00000000cff70390 0006C (v01 A_M_I_ OEMAPIC  08000820 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cff70400 0003C (v01 A_M_I_ OEMMCFG  08000820 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cff7e040 00081 (v01 A_M_I_ AMI_OEM  08000820 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cff79a90 00038 (v01 A_M_I_ OEMHPET  08000820 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000cff79ad0 000B0 (v01 A_M_I_ OEMOSFR  08000820 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cff7e8d0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000230000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
[    0.000000]   NODE_DATA [0000000000016000 - 000000000001afff]
[    0.000000]   bootmap [000000000001b000 -  0000000000060fff] pages 46
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001780a40]    TEXT DATA BSS ==> [0001000000 - 0001780a40]
[    0.000000]   #3 [0037f50000 - 0037fefb03]          RAMDISK ==> [0037f50000 - 0037fefb03]
[    0.000000]   #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
[    0.000000]   #5 [0001781000 - 0001781278]              BRK ==> [0001781000 - 0001781278]
[    0.000000]   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #7 [0000011000 - 0000016000]          PGTABLE ==> [0000011000 - 0000016000]
[    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000cff70
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2096892
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3816 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833448 pages, LIFO batch:31
[    0.000000]   Normal zone: 17024 pages used for memmap
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff70000 - 00000000cff7e000
[    0.000000] PM: Registered nosave memory: 00000000cff7e000 - 00000000cffd0000
[    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028032000, static data 72416 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065424
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 8195868k/9175040k available (3915k kernel code, 787472k absent, 191700k reserved, 2352k data, 504k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2499.742 MHz processor.
[    0.000604] Console: colour VGA+ 80x25
[    0.000606] console [tty0] enabled
[    0.003333] allocated 83886080 bytes of page_cgroup
[    0.003333] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5001.79 BogoMIPS (lpj=8332473)
[    0.003333] Security Framework initialized
[    0.003333] SELinux:  Disabled at boot.
[    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.003936] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.005422] Mount-cache hash table entries: 256
[    0.005589] Initializing cgroup subsys ns
[    0.005623] Initializing cgroup subsys cpuacct
[    0.005654] Initializing cgroup subsys memory
[    0.005689] Initializing cgroup subsys devices
[    0.005718] Initializing cgroup subsys freezer
[    0.005748] Initializing cgroup subsys net_cls
[    0.005789] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005841] CPU: L2 cache: 3072K
[    0.005871] CPU 0/0x0 -> Node 0
[    0.005900] CPU: Physical Processor ID: 0
[    0.005929] CPU: Processor Core ID: 0
[    0.005959] mce: CPU supports 6 MCE banks
[    0.005993] CPU0: Thermal monitoring enabled (TM2)
[    0.006025] using mwait in idle threads.
[    0.006054] Performance Counters: Core2 events, Intel PMU driver.
[    0.006133] ... version:                 2
[    0.006162] ... bit width:               40
[    0.006191] ... generic counters:        2
[    0.006219] ... value mask:              000000ffffffffff
[    0.006248] ... max period:              000000007fffffff
[    0.006278] ... fixed-purpose counters:  3
[    0.006306] ... counter mask:            0000000700000003
[    0.006352] ACPI: Core revision 20090521
[    0.020054] Setting APIC routing to flat
[    0.020381] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.053489] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.056666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5001.74 BogoMIPS (lpj=8332387)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 3072K
[    0.003333] CPU 1/0x1 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU1: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.147999] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.148362] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.150088] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 5001.75 BogoMIPS (lpj=8332403)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 3072K
[    0.003333] CPU 2/0x2 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU2: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.244619] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.245313] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.246726] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 5001.75 BogoMIPS (lpj=8332402)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 3072K
[    0.003333] CPU 3/0x3 -> Node 0
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] CPU3: Thermal monitoring enabled (TM2)
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.341338] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
[    0.341698] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.343342] Brought up 4 CPUs
[    0.343380] Total of 4 processors activated (20005.04 BogoMIPS).
[    0.343536] regulator: core version 0.5
[    0.343536] NET: Registered protocol family 16
[    0.343536] ACPI: bus type pci registered
[    0.346701] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.346732] PCI: Not using MMCONFIG.
[    0.346760] PCI: Using configuration type 1 for base access
[    0.347351] bio: create slab <bio-0> at 0
[    0.350099] ACPI: EC: Look up EC in DSDT
[    0.361906] ACPI: Interpreter enabled
[    0.361942] ACPI: (supports S0 S1 S3 S4 S5)
[    0.362115] ACPI: Using IOAPIC for interrupt routing
[    0.362188] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.364494] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.370452] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.376835] ACPI: No dock devices found.
[    0.376973] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.377033] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.377033] pci 0000:00:01.0: PME# disabled
[    0.377033] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
[    0.377033] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
[    0.377033] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
[    0.377033] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.377063] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.377095] pci 0000:00:1a.7: PME# disabled
[    0.377154] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe7f8000-0xfe7fbfff]
[    0.377187] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.377218] pci 0000:00:1b.0: PME# disabled
[    0.377293] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.377324] pci 0000:00:1c.0: PME# disabled
[    0.377400] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.377431] pci 0000:00:1c.4: PME# disabled
[    0.377505] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.377536] pci 0000:00:1c.5: PME# disabled
[    0.377606] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
[    0.377661] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
[    0.377716] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
[    0.377774] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe7ff800-0xfe7ffbff]
[    0.377818] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.377850] pci 0000:00:1d.7: PME# disabled
[    0.377975] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.378010] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.378041] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.380003] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
[    0.380086] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
[    0.380090] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
[    0.380094] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
[    0.380099] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
[    0.380103] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
[    0.380107] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe7fe800-0xfe7fefff]
[    0.380132] pci 0000:00:1f.2: PME# supported from D3hot
[    0.380163] pci 0000:00:1f.2: PME# disabled
[    0.380212] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.380223] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.380257] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.380261] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    0.380265] pci 0000:01:00.0: reg 18 32bit mmio: [0xfe8e0000-0xfe8effff]
[    0.380277] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe8c0000-0xfe8dffff]
[    0.380291] pci 0000:01:00.0: supports D1 D2
[    0.380313] pci 0000:01:00.1: reg 10 32bit mmio: [0xfe8f0000-0xfe8fffff]
[    0.380341] pci 0000:01:00.1: supports D1 D2
[    0.380376] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.380378] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.380381] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.380416] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.380454] pci 0000:03:00.0: reg 10 io port: [0xdc00-0xdc07]
[    0.380461] pci 0000:03:00.0: reg 14 io port: [0xd880-0xd883]
[    0.380467] pci 0000:03:00.0: reg 18 io port: [0xd800-0xd807]
[    0.380474] pci 0000:03:00.0: reg 1c io port: [0xd480-0xd483]
[    0.380481] pci 0000:03:00.0: reg 20 io port: [0xd400-0xd40f]
[    0.380487] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
[    0.380522] pci 0000:03:00.0: supports D1
[    0.380523] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.380556] pci 0000:03:00.0: PME# disabled
[    0.380622] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.380625] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.380673] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9c0000-0xfe9fffff]
[    0.380680] pci 0000:02:00.0: reg 18 io port: [0xcc00-0xcc7f]
[    0.380731] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.380763] pci 0000:02:00.0: PME# disabled
[    0.380832] pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]
[    0.380835] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.380865] pci 0000:05:00.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
[    0.380903] pci 0000:05:00.0: supports D1 D2
[    0.380933] pci 0000:05:01.0: reg 10 io port: [0xe800-0xe8ff]
[    0.380939] pci 0000:05:01.0: reg 14 32bit mmio: [0xfebff400-0xfebff4ff]
[    0.380961] pci 0000:05:01.0: reg 30 32bit mmio: [0xfebe0000-0xfebeffff]
[    0.380977] pci 0000:05:01.0: PME# supported from D0
[    0.381009] pci 0000:05:01.0: PME# disabled
[    0.381074] pci 0000:00:1e.0: transparent bridge
[    0.381105] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    0.381108] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.381128] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.381243] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.381290] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.381380] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.381424] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.381488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.394031] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.394031] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.394212] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.396807] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.397206] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.397656] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.398055] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.398464] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.398829] PCI: Using ACPI for IRQ routing
[    0.410005] NetLabel: Initializing
[    0.410035] NetLabel:  domain hash size = 128
[    0.410066] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.410115] NetLabel:  unlabeled traffic allowed by default
[    0.410176] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.410323] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.430006] pnp: PnP ACPI init
[    0.430046] ACPI: bus type pnp registered
[    0.433099] pnp: PnP ACPI: found 14 devices
[    0.433129] ACPI: ACPI bus type pnp unregistered
[    0.433164] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.433198] system 00:06: ioport range 0x290-0x29f has been reserved
[    0.433231] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.433261] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.433292] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.433323] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
[    0.433358] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.433389] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.433419] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.433453] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
[    0.433486] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.433520] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.433552] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.433585] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.433616] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.433646] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.433677] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
[    0.438890] pci 0000:05:01.0: BAR 6: address space collision on of device [0xfebe0000-0xfebeffff]
[    0.438951] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.438982] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.439012] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
[    0.439043] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.439079] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.439108] pci 0000:00:1c.0:   IO window: disabled
[    0.439139] pci 0000:00:1c.0:   MEM window: disabled
[    0.439170] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.439207] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    0.439237] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.439269] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
[    0.439300] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.439331] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
[    0.439361] pci 0000:00:1c.5:   IO window: 0xc000-0xcfff
[    0.439393] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
[    0.439424] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.439456] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.439486] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    0.439518] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.439549] pci 0000:00:1e.0:   PREFETCH window: 0xf0000000-0xf00fffff
[    0.439584]   alloc irq_desc for 16 on node 0
[    0.439586]   alloc kstat_irqs on node 0
[    0.439590] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.439621] pci 0000:00:01.0: setting latency timer to 64
[    0.439626]   alloc irq_desc for 17 on node 0
[    0.439627]   alloc kstat_irqs on node 0
[    0.439630] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.439661] pci 0000:00:1c.0: setting latency timer to 64
[    0.439666] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.439698] pci 0000:00:1c.4: setting latency timer to 64
[    0.439703] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.439734] pci 0000:00:1c.5: setting latency timer to 64
[    0.439739] pci 0000:00:1e.0: setting latency timer to 64
[    0.439742] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.439743] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.439745] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.439747] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe8fffff]
[    0.439749] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.439750] pci_bus 0000:04: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.439752] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.439754] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.439756] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.439757] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
[    0.439759] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.439761] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.439762] pci_bus 0000:05: resource 2 pref mem [0xf0000000-0xf00fffff]
[    0.439764] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.439766] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.439776] NET: Registered protocol family 2
[    0.439959] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.440937] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.443886] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.444282] TCP: Hash tables configured (established 524288 bind 65536)
[    0.444313] TCP reno registered
[    0.444419] NET: Registered protocol family 1
[    0.444510] Trying to unpack rootfs image as initramfs...
[    0.445177] rootfs image is not initramfs (no cpio magic); looks like an initrd
[    0.445809] Freeing initrd memory: 638k freed
[    0.447425] Scanning for low memory corruption every 60 seconds
[    0.447760] audit: initializing netlink socket (disabled)
[    0.447797] type=2000 audit(1253091292.446:1): initialized
[    0.453371] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.459912] VFS: Disk quotas dquot_6.5.2
[    0.460009] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.460142] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.460238] msgmni has been set to 16008
[    0.460523] alg: No test for stdrng (krng)
[    0.460667] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.460702] io scheduler noop registered
[    0.460731] io scheduler anticipatory registered
[    0.460760] io scheduler deadline registered
[    0.460914] io scheduler cfq registered (default)
[    0.461090] pci 0000:01:00.0: Boot video device
[    0.461233]   alloc irq_desc for 24 on node 0
[    0.461235]   alloc kstat_irqs on node 0
[    0.461241] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.461245] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.461418]   alloc irq_desc for 25 on node 0
[    0.461419]   alloc kstat_irqs on node 0
[    0.461424] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.461430] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.461661]   alloc irq_desc for 26 on node 0
[    0.461663]   alloc kstat_irqs on node 0
[    0.461668] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.461674] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.461925]   alloc irq_desc for 27 on node 0
[    0.461927]   alloc kstat_irqs on node 0
[    0.461932] pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
[    0.461938] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.501865] Linux agpgart interface v0.103
[    0.501929] Switched to high resolution mode on CPU 1
[    0.501984] Switched to high resolution mode on CPU 3
[    0.502124] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.502256] Switched to high resolution mode on CPU 2
[    0.503495] Switched to high resolution mode on CPU 0
[    0.505531] brd: module loaded
[    0.505712] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.505889] Fixed MDIO Bus: probed
[    0.506190] PNP: No PS/2 controller found. Probing ports directly.
[    0.508905] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.508944] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.509164] mice: PS/2 mouse device common for all mice
[    0.509247] rtc_cmos 00:03: RTC can wake from S4
[    0.509335] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.509384] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.509446] cpuidle: using governor ladder
[    0.509475] cpuidle: using governor menu
[    0.509633] TCP cubic registered
[    0.509897] NET: Registered protocol family 10
[    0.510268] lo: Disabled Privacy Extensions
[    0.510658] Mobile IPv6
[    0.510687] NET: Registered protocol family 17
[    0.510981] TuxOnIce: Ignoring late initcall, as requested.
[    0.511025] registered taskstats version 1
[    0.511118] No TPM chip found, activating TPM-bypass!
[    0.511333] rtc_cmos 00:03: setting system clock to 2009-09-16 08:54:52 UTC (1253091292)
[    0.511400] Initalizing network drop monitor service
[    0.551748] RAMDISK: gzip image found at block 0
[    0.564758] VFS: Mounted root (romfs filesystem) readonly on device 1:0.
[    0.576350] SCSI subsystem initialized
[    0.587464] libata version 3.00 loaded.
[    0.590247] ahci 0000:00:1f.2: version 3.0
[    0.590259]   alloc irq_desc for 19 on node 0
[    0.590261]   alloc kstat_irqs on node 0
[    0.590266] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.590344]   alloc irq_desc for 28 on node 0
[    0.590345]   alloc kstat_irqs on node 0
[    0.590351] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.590383] ahci: SSS flag set, parallel bus scan disabled
[    0.590439] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.590473] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    0.590509] ahci 0000:00:1f.2: setting latency timer to 64
[    0.623376] scsi0 : ahci
[    0.623766] scsi1 : ahci
[    0.623985] scsi2 : ahci
[    0.624201] scsi3 : ahci
[    0.624420] scsi4 : ahci
[    0.624613] scsi5 : ahci
[    0.624862] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 28
[    0.624896] ata2: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe980 irq 28
[    0.624931] ata3: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea00 irq 28
[    0.624965] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 28
[    0.624998] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 28
[    0.625032] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 28
[    1.103352] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.103849] ata1.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
[    1.103883] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
[    1.104481] ata1.00: configured for UDMA/133
[    1.116765] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
[    1.996684] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.997172] ata2.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
[    1.997205] ata2.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
[    1.997783] ata2.00: configured for UDMA/133
[    2.010066] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
[    2.330011] ata3: SATA link down (SStatus 0 SControl 300)
[    2.663344] ata4: SATA link down (SStatus 0 SControl 300)
[    2.996677] ata5: SATA link down (SStatus 0 SControl 300)
[    3.330011] ata6: SATA link down (SStatus 0 SControl 300)
[    3.346342] JFS: nTxBlock = 8192, nTxLock = 65536
[    3.362439] md: raid1 personality registered for level 1
[    3.365712] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
[    3.365777] sd 0:0:0:0: [sda] Write Protect is off
[    3.365807] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.365824] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.365956]  sda:
[    3.366104] sd 1:0:0:0: [sdb] 321672960 512-byte logical blocks: (164 GB/153 GiB)
[    3.366191] sd 1:0:0:0: [sdb] Write Protect is off
[    3.366222] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.366238] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.366348]  sdb: sda1 sda2 sda3
[    3.386740] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.389359]  sdb1 sdb2 sdb3
[    3.390291] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.391731] md: md0 stopped.
[    3.524993] md: bind<sda2>
[    3.525140] md: bind<sdb2>
[    3.525300] raid1: raid set md0 active with 2 out of 2 mirrors
[    3.525357] md0: detected capacity change from 0 to 12000559104
[    3.526908]  md0: unknown partition table
[    3.586166] VFS: Mounted root (jfs filesystem) readonly on device 9:0.
[    3.586199] Trying to move old root to /initrd ... okay
[    3.612355] Freeing unused kernel memory: 504k freed
[    6.352658] iTCO_vendor_support: vendor-support=0
[    6.353702] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    6.353786] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
[    6.353863] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.354784] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    6.354790] ACPI: Power Button [PWRF]
[    6.354847] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    6.354851] ACPI: Power Button [PWRB]
[    6.389144] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.389156] ATL1E 0000:02:00.0: setting latency timer to 64
[    6.392113] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    6.394763] ACPI: SSDT 00000000cff7e0d0 001F3 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    6.395208] processor LNXCPU:00: registered as cooling_device0
[    6.395597] ACPI: SSDT 00000000cff7e2d0 001F3 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
[    6.396645] processor LNXCPU:01: registered as cooling_device1
[    6.397008] ACPI: SSDT 00000000cff7e4d0 001F3 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
[    6.397434] processor LNXCPU:02: registered as cooling_device2
[    6.397771] ACPI: SSDT 00000000cff7e6d0 001F3 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
[    6.398190] processor LNXCPU:03: registered as cooling_device3
[    6.405950] usbcore: registered new interface driver usbfs
[    6.406052] usbcore: registered new interface driver hub
[    6.406085] usbcore: registered new device driver usb
[    6.432386] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.432459]   alloc irq_desc for 18 on node 0
[    6.432461]   alloc kstat_irqs on node 0
[    6.432466] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.432503] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.432506] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.432537] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.436445] ehci_hcd 0000:00:1a.7: debug port 1
[    6.436450] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.436508] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
[    6.439704] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.439738] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    6.450008] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.450034] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    6.450036] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.450038] usb usb1: Product: EHCI Host Controller
[    6.450040] usb usb1: Manufacturer: Linux 2.6.31-0.4 ehci_hcd
[    6.450042] usb usb1: SerialNumber: 0000:00:1a.7
[    6.450166] usb usb1: configuration #1 chosen from 1 choice
[    6.450208] hub 1-0:1.0: USB hub found
[    6.450215] hub 1-0:1.0: 6 ports detected
[    6.450363]   alloc irq_desc for 23 on node 0
[    6.450365]   alloc kstat_irqs on node 0
[    6.450370] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.450409] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.450412] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.450420] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.454333] ehci_hcd 0000:00:1d.7: debug port 1
[    6.454337] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.454351] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
[    6.470010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.470028] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    6.470031] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.470033] usb usb2: Product: EHCI Host Controller
[    6.470035] usb usb2: Manufacturer: Linux 2.6.31-0.4 ehci_hcd
[    6.470037] usb usb2: SerialNumber: 0000:00:1d.7
[    6.470340] usb usb2: configuration #1 chosen from 1 choice
[    6.470390] hub 2-0:1.0: USB hub found
[    6.470396] hub 2-0:1.0: 6 ports detected
[    6.497136] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[    6.497217] via-rhine 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.501474] eth1: VIA Rhine II at 0xfebff400, 00:05:5d:e1:f9:45, IRQ 17.
[    6.502181] eth1: MII PHY found at address 8, status 0x7809 advertising 01e1 Link 0000.
[    6.547365] uhci_hcd: USB Universal Host Controller Interface driver
[    6.547523] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.547533] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.547537] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.547551] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.547587] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    6.547624] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.547626] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.547627] usb usb3: Product: UHCI Host Controller
[    6.547629] usb usb3: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.547630] usb usb3: SerialNumber: 0000:00:1a.0
[    6.547725] usb usb3: configuration #1 chosen from 1 choice
[    6.547750] hub 3-0:1.0: USB hub found
[    6.547755] hub 3-0:1.0: 2 ports detected
[    6.548119]   alloc irq_desc for 21 on node 0
[    6.548121]   alloc kstat_irqs on node 0
[    6.548125] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.548130] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.548132] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.548142] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.548167] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    6.548192] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.548193] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.548195] usb usb4: Product: UHCI Host Controller
[    6.548196] usb usb4: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.548198] usb usb4: SerialNumber: 0000:00:1a.1
[    6.548252] usb usb4: configuration #1 chosen from 1 choice
[    6.548275] hub 4-0:1.0: USB hub found
[    6.548280] hub 4-0:1.0: 2 ports detected
[    6.548368] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.548373] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.548375] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.548383] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.548402] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
[    6.548428] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.548429] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.548431] usb usb5: Product: UHCI Host Controller
[    6.548432] usb usb5: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.548434] usb usb5: SerialNumber: 0000:00:1a.2
[    6.548482] usb usb5: configuration #1 chosen from 1 choice
[    6.548504] hub 5-0:1.0: USB hub found
[    6.548509] hub 5-0:1.0: 2 ports detected
[    6.548596] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.548600] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.548602] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.548610] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.548629] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
[    6.548655] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.548657] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.548658] usb usb6: Product: UHCI Host Controller
[    6.548660] usb usb6: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.548661] usb usb6: SerialNumber: 0000:00:1d.0
[    6.548706] usb usb6: configuration #1 chosen from 1 choice
[    6.548728] hub 6-0:1.0: USB hub found
[    6.548732] hub 6-0:1.0: 2 ports detected
[    6.548816] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.548820] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.548823] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.548832] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.548856] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    6.548881] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    6.548882] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.548884] usb usb7: Product: UHCI Host Controller
[    6.548885] usb usb7: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.548887] usb usb7: SerialNumber: 0000:00:1d.1
[    6.548931] usb usb7: configuration #1 chosen from 1 choice
[    6.548953] hub 7-0:1.0: USB hub found
[    6.548957] hub 7-0:1.0: 2 ports detected
[    6.549042] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.549046] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.549048] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.549056] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.549075] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
[    6.549100] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    6.549101] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.549103] usb usb8: Product: UHCI Host Controller
[    6.549104] usb usb8: Manufacturer: Linux 2.6.31-0.4 uhci_hcd
[    6.549106] usb usb8: SerialNumber: 0000:00:1d.2
[    6.549148] usb usb8: configuration #1 chosen from 1 choice
[    6.549175] hub 8-0:1.0: USB hub found
[    6.549184] hub 8-0:1.0: 2 ports detected
[    6.556790]   alloc irq_desc for 22 on node 0
[    6.556792]   alloc kstat_irqs on node 0
[    6.556798] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    6.556849] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.705609] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.705637] pata_marvell 0000:03:00.0: setting latency timer to 64
[    6.705704] scsi6 : pata_marvell
[    6.705823] scsi7 : pata_marvell
[    6.705885] ata7: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 16
[    6.705887] ata8: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 16
[    6.867439] ata7.00: ATAPI: ASUS    DRW-1814BL, 1.10, max UDMA/66
[    6.884109] ata7.00: configured for UDMA/66
[    6.974640] scsi 6:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.10 PQ: 0 ANSI: 5
[    6.974788] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[    7.006678] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    7.138212] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
[    7.144969] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    7.144973] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
[    7.144976] ACPI: Device needs an ACPI driver
[    7.145002] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    7.151425] Linux video capture interface: v2.00
[    7.177650] usb 6-1: New USB device found, idVendor=046d, idProduct=c051
[    7.177654] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.177656] usb 6-1: Product: USB-PS/2 Optical Mouse
[    7.177658] usb 6-1: Manufacturer: Logitech
[    7.177766] usb 6-1: configuration #1 chosen from 1 choice
[    7.190784] Uniform Multi-Platform E-IDE driver
[    7.214809] usbcore: registered new interface driver hiddev
[    7.228682] saa7130/34: v4l2 driver version 0.2.15 loaded
[    7.228799] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.228805] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
[    7.228810] saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
[    7.228862] saa7133[0]: board init: gpio is 200e000
[    7.228867] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    7.230910] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input5
[    7.231025] generic-usb 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
[    7.231040] usbcore: registered new interface driver usbhid
[    7.231043] usbhid: v2.6:USB HID core driver
[    7.271305] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    7.271309] Uniform CD-ROM driver Revision: 3.20
[    7.271453] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    7.383339] saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[    7.383347] saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
[    7.383355] saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e2 ff 22 00 c2
[    7.383362] saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff 15 13 25 53 89 01 45 32 7b
[    7.383369] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383376] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383383] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383391] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383398] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383405] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383412] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383419] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383426] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383434] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383441] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383452] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.383459] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
[    7.404598] usb 6-2: new low speed USB device using uhci_hcd and address 3
[    7.463393] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[    7.536671] tda829x 0-004b: setting tuner address to 61
[    7.579645] usb 6-2: New USB device found, idVendor=045e, idProduct=00db
[    7.579648] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.579651] usb 6-2: Product: Natural® Ergonomic Keyboard 4000
[    7.579652] usb 6-2: Manufacturer: Microsoft
[    7.579766] usb 6-2: configuration #1 chosen from 1 choice
[    7.620006] tda829x 0-004b: type set to tda8290+75a
[    7.640906] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input6
[    7.641014] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input0
[    7.664789] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input7
[    7.664874] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input1
[   11.286881] BUG: unable to handle kernel paging request at ffff880233ad9e8c
[   11.286968] IP: [<ffffffffa02fb864>] ir_input_init+0x64/0x1a52 [ir_common]
[   11.287025] PGD 80000000013e0063 PUD 15067 PMD 0 
[   11.287125] Oops: 0002 [#1] SMP 
[   11.287201] last sysfs file: /sys/module/i2c_core/initstate
[   11.287231] CPU 3 
[   11.287282] Modules linked in: ir_kbd_i2c(+) joydev hid_microsoft tda827x tda8290 tuner sr_mod cdrom saa7134(+) ide_pci_generic usbhid hid ide_core ir_common pata_acpi v4l2_common videodev ata_generic snd_hda_codec_realtek v4l1_compat pata_marvell v4l2_compat_ioctl32 asus_atk0110 i2c_i801 videobuf_dma_sg intel_agp videobuf_core snd_hda_intel tveeprom snd_hda_codec uhci_hcd hwmon thermal via_rhine snd_hwdep snd_pcm i2c_core mii snd_timer snd sg ehci_hcd soundcore usbcore serio_raw processor pcspkr atl1e psmouse evdev snd_page_alloc button iTCO_wdt iTCO_vendor_support sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache jfs ahci libata scsi_mod [last unloaded: scsi_wait_scan]
[   11.288932] Pid: 1815, comm: modprobe Not tainted 2.6.31-0.4 #1 P5Q-PRO
[   11.288962] RIP: 0010:[<ffffffffa02fb864>]  [<ffffffffa02fb864>] ir_input_init+0x64/0x1a52 [ir_common]
[   11.289022] RSP: 0018:ffff880221165dc0  EFLAGS: 00010246
[   11.289052] RAX: ffff8802251b0c18 RBX: ffff8802251b0c00 RCX: ffff880226815028
[   11.289082] RDX: 0000000000000000 RSI: 000000006962732f RDI: ffff8802251b0e18
[   11.289112] RBP: ffff88022101b800 R08: ffff880226815000 R09: 0000000000000004
[   11.289124] R10: ffff8802251b0ea0 R11: 0000000000000000 R12: ffff880226815000
[   11.289124] R13: ffff8802251b0ec0 R14: ffffffff815c86c0 R15: ffff88022150c230
[   11.289124] FS:  00007f62036346f0(0000) GS:ffff88002807d000(0000) knlGS:0000000000000000
[   11.289124] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.289124] CR2: ffff880233ad9e8c CR3: 000000022113a000 CR4: 00000000000006e0
[   11.289124] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   11.289124] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   11.289124] Process modprobe (pid: 1815, threadinfo ffff880221164000, task ffff880222a9ebd0)
[   11.289124] Stack:
[   11.289124]  ffffffffa03a31e3 ffff8802251b0ea0 0000000000000063 0000000000000000
[   11.289124] <0> ffffffffa03a3e60 ffff88022101b828 ffff88022101b804 ffff88022101b800
[   11.289124] <0> ffffffffa03a3030 000000000060df10 ffffffffa01cc3a1 ffffffffa03a0048
[   11.289124] Call Trace:
[   11.289124]  [<ffffffffa03a31e3>] ? __this_module+0x3103/0x39e4 [ir_kbd_i2c]
[   11.289124]  [<ffffffffa03a3e60>] ? cleanup_module+0x39c/0xd00 [ir_kbd_i2c]
[   11.289124]  [<ffffffffa03a3030>] ? __this_module+0x2f50/0x39e4 [ir_kbd_i2c]
[   11.289124]  [<ffffffffa01cc3a1>] ? i2c_verify_client+0x2c1/0x390 [i2c_core]
[   11.289124]  [<ffffffff812a4008>] ? driver_probe_device+0x88/0x180
[   11.289124]  [<ffffffff812a4193>] ? __driver_attach+0x93/0xa0
[   11.289124]  [<ffffffff812a4100>] ? __driver_attach+0x0/0xa0
[   11.289124]  [<ffffffff812a3788>] ? bus_for_each_dev+0x58/0x80
[   11.289124]  [<ffffffffa03a3f80>] ? cleanup_module+0x4bc/0xd00 [ir_kbd_i2c]
[   11.289124]  [<ffffffff812a2f46>] ? bus_add_driver+0xc6/0x290
[   11.289124]  [<ffffffffa03a7000>] ? init_module+0x0/0x18 [ir_kbd_i2c]
[   11.289124]  [<ffffffff812a447a>] ? driver_register+0x6a/0x130
[   11.289124]  [<ffffffffa03a7000>] ? init_module+0x0/0x18 [ir_kbd_i2c]
[   11.289124]  [<ffffffffa01cd0f0>] ? i2c_register_driver+0x30/0xd0 [i2c_core]
[   11.289124]  [<ffffffffa03a7000>] ? init_module+0x0/0x18 [ir_kbd_i2c]
[   11.289124]  [<ffffffff81001044>] ? do_one_initcall+0x34/0x170
[   11.289124]  [<ffffffff8108893f>] ? sys_init_module+0xdf/0x250
[   11.289124]  [<ffffffff81003f2b>] ? system_call_fastpath+0x16/0x1b
[   11.289124] Code: 90 d0 00 00 00 41 c7 80 cc 00 00 00 04 00 00 00 41 c7 80 c8 00 00 00 80 00 00 00 31 d2 66 2e 0f 1f 84 00 00 00 00 00 8b 74 10 04 <f0> 0f ab 31 48 83 c2 04 48 81 fa 00 02 00 00 75 eb f0 41 80 60 
[   11.289124] RIP  [<ffffffffa02fb864>] ir_input_init+0x64/0x1a52 [ir_common]
[   11.289124]  RSP <ffff880221165dc0>
[   11.289124] CR2: ffff880233ad9e8c
[   11.289124] ---[ end trace d9ab3f6ed1cfb88d ]---
[   11.346818] saa7133[0]: registered device video0 [v4l2]
[   11.346894] saa7133[0]: registered device vbi0
[   11.346969] saa7133[0]: registered device radio0
[   11.418715] saa7134 ALSA driver for DMA sound loaded
[   11.418754] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.418799] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card 1
[   13.694719] Adding 6000236k swap on /dev/sda1.  Priority:0 extents:1 across:6000236k 
[   13.697219] Adding 6000236k swap on /dev/sdb1.  Priority:0 extents:1 across:6000236k 
[   14.841828] device-mapper: uevent: version 1.0.3
[   14.842353] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   48.270184] md: md1 stopped.
[   48.271246] md: bind<sdb3>
[   48.271375] md: bind<sda3>
[   48.283978] md: raid10 personality registered for level 10
[   48.284246] raid10: raid set md1 active with 2 out of 2 devices
[   48.284295] md1: detected capacity change from 0 to 146549637120
[   48.381965]  md1: unknown partition table
[   50.073491] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   50.138344] ip_tables: (C) 2000-2006 Netfilter Core Team
[   50.169365] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   50.169637] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   50.169672] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[   50.169705] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   51.325347]   alloc irq_desc for 29 on node 0
[   51.325384]   alloc kstat_irqs on node 0
[   51.325424] ATL1E 0000:02:00.0: irq 29 for MSI/MSI-X
[   51.325572] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   57.140579] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   57.142139] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   57.245737] eth1: link down
[   57.246633] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   59.062061] Bluetooth: Core ver 2.15
[   59.062170] NET: Registered protocol family 31
[   59.062200] Bluetooth: HCI device and connection manager initialized
[   59.062231] Bluetooth: HCI socket layer initialized
[   59.069023] Bluetooth: L2CAP ver 2.13
[   59.069056] Bluetooth: L2CAP socket layer initialized
[   59.072152] Bluetooth: RFCOMM TTY layer initialized
[   59.072187] Bluetooth: RFCOMM socket layer initialized
[   59.072224] Bluetooth: RFCOMM ver 1.11
[   59.545469] coretemp coretemp.0: Using relative temperature scale!
[   59.545657] coretemp coretemp.1: Using relative temperature scale!
[   59.545764] coretemp coretemp.2: Using relative temperature scale!
[   59.545827] coretemp coretemp.3: Using relative temperature scale!
[   59.874164] dummy0: no IPv6 routers present
[   63.643767] radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   63.644253] radeonfb: Found Intel x86 BIOS ROM Image
[   63.644284] radeonfb: Retrieved PLL infos from BIOS
[   63.644314] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=400.00 Mhz, System=350.00 MHz
[   63.644348] radeonfb: PLL min 20000 max 40000
[   63.904412] i2c-adapter i2c-3: unable to read EDID block.
[   64.047745] i2c-adapter i2c-3: unable to read EDID block.
[   64.191078] i2c-adapter i2c-3: unable to read EDID block.
[   64.494338] radeonfb: Monitor 1 type DFP found
[   64.494367] radeonfb: EDID probed
[   64.494396] radeonfb: Monitor 2 type no found
[   64.511222] Console: switching to colour frame buffer device 210x65
[   64.522426] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   64.522520] radeonfb (0000:01:00.0): ATI Radeon 5b63 "[c"

--Boundary-00=_VvJsKt76p37KlA1--
