Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45196 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZI3Xth (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 19:49:37 -0400
Subject: Re: [2.6.31] ir-kbd-i2c oops.
From: Andy Walls <awalls@radix.net>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <200909301822.29010.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	 <200909301352.28362.pluto@agmk.net>
	 <20090930142516.23eb09df@hyperion.delvare>
	 <200909301822.29010.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 19:52:07 -0400
Message-Id: <1254354727.4771.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-09-30 at 18:22 +0200, Paweł Sikora wrote:
> On Wednesday 30 September 2009 14:25:16 Jean Delvare wrote:
> > On Wed, 30 Sep 2009 13:52:27 +0200, Paweł Sikora wrote:
> > > On Wednesday 30 September 2009 12:57:37 Jean Delvare wrote:
> > > > Are you running distribution kernels or self-compiled ones?
> > > > Any local patches applied?
> > > > Would you be able to apply debug patches and rebuild your kernel?
> > >
> > > yes, i'm using patched (vserver,grsec) modular kernel from pld-linux
> > > but i'm able to boot custom git build and do the bisect if necessary.
> > 
> > OK, then it would be great if you could try the patch below on top of
> > kernel 2.6.31, and report everything that gets logged before the oops.
> 
> dmesg from git v2.6.31 w/ debugging patch attached.
> plain text document attachment (dmesg-2.6.31.txt)
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.31-0.4-dirty (pluto@vmx) (gcc version 4.4.1 20090918 (release) (PLD-Linux) ) #1 SMP Wed Sep 30 16:34:43 CEST 2009
> [    0.000000] Command line: root=/dev/md0
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff70000 (usable)
> [    0.000000]  BIOS-e820: 00000000cff70000 - 00000000cff7e000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
> [    0.000000] DMI present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-DFFFF write-protect
> [    0.000000]   E0000-EFFFF write-through
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask E00000000 write-back
> [    0.000000]   1 base 200000000 mask FE0000000 write-back
> [    0.000000]   2 base 220000000 mask FF0000000 write-back
> [    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
> [    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
> [    0.000000] last_pfn = 0xcff70 max_arch_pfn = 0x400000000
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009cc00 (usable)
> [    0.000000]  modified: 000000000009cc00 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000cff70000 (usable)
> [    0.000000]  modified: 00000000cff70000 - 00000000cff7e000 (ACPI data)
> [    0.000000]  modified: 00000000cff7e000 - 00000000cffd0000 (ACPI NVS)
> [    0.000000]  modified: 00000000cffd0000 - 00000000d0000000 (reserved)
> [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 0000000230000000 (usable)
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] init_memory_mapping: 0000000000000000-00000000cff70000
> [    0.000000]  0000000000 - 00cfe00000 page 2M
> [    0.000000]  00cfe00000 - 00cff70000 page 4k
> [    0.000000] kernel direct mapping tables up to cff70000 @ 10000-16000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
> [    0.000000]  0100000000 - 0230000000 page 2M
> [    0.000000] kernel direct mapping tables up to 230000000 @ 14000-1e000
> [    0.000000] RAMDISK: 37ef8000 - 37fef142
> [    0.000000] ACPI: RSDP 00000000000fb460 00024 (v02 ACPIAM)
> [    0.000000] ACPI: XSDT 00000000cff70100 0005C (v01 A_M_I_ OEMXSDT  08000820 MSFT 00000097)
> [    0.000000] ACPI: FACP 00000000cff70290 000F4 (v03 A_M_I_ OEMFACP  08000820 MSFT 00000097)
> [    0.000000] ACPI: DSDT 00000000cff70440 0964B (v01  A1012 A1012001 00000001 INTL 20060113)
> [    0.000000] ACPI: FACS 00000000cff7e000 00040
> [    0.000000] ACPI: APIC 00000000cff70390 0006C (v01 A_M_I_ OEMAPIC  08000820 MSFT 00000097)
> [    0.000000] ACPI: MCFG 00000000cff70400 0003C (v01 A_M_I_ OEMMCFG  08000820 MSFT 00000097)
> [    0.000000] ACPI: OEMB 00000000cff7e040 00081 (v01 A_M_I_ AMI_OEM  08000820 MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000cff79a90 00038 (v01 A_M_I_ OEMHPET  08000820 MSFT 00000097)
> [    0.000000] ACPI: OSFR 00000000cff79ad0 000B0 (v01 A_M_I_ OEMOSFR  08000820 MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000cff7e8d0 00A7C (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at 0000000000000000-0000000230000000
> [    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
> [    0.000000]   NODE_DATA [0000000000019000 - 000000000001dfff]
> [    0.000000]   bootmap [000000000001e000 -  0000000000063fff] pages 46
> [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0230000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> [    0.000000]   #2 [0001000000 - 0001669b80]    TEXT DATA BSS ==> [0001000000 - 0001669b80]
> [    0.000000]   #3 [0037ef8000 - 0037fef142]          RAMDISK ==> [0037ef8000 - 0037fef142]
> [    0.000000]   #4 [000009cc00 - 0000100000]    BIOS reserved ==> [000009cc00 - 0000100000]
> [    0.000000]   #5 [000166a000 - 000166a278]              BRK ==> [000166a000 - 000166a278]
> [    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
> [    0.000000]   #7 [0000014000 - 0000019000]          PGTABLE ==> [0000014000 - 0000019000]
> [    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 -> 0x00001000
> [    0.000000]   DMA32    0x00001000 -> 0x00100000
> [    0.000000]   Normal   0x00100000 -> 0x00230000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000010 -> 0x0000009c
> [    0.000000]     0: 0x00000100 -> 0x000cff70
> [    0.000000]     0: 0x00100000 -> 0x00230000
> [    0.000000] On node 0 totalpages: 2096892
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 111 pages reserved
> [    0.000000]   DMA zone: 3813 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 833448 pages, LIFO batch:31
> [    0.000000]   Normal zone: 17024 pages used for memmap
> [    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000cff70000 - 00000000cff7e000
> [    0.000000] PM: Registered nosave memory: 00000000cff7e000 - 00000000cffd0000
> [    0.000000] PM: Registered nosave memory: 00000000cffd0000 - 00000000d0000000
> [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
> [    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
> [    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
> [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages at ffff880028034000, static data 82208 bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065421
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: root=/dev/md0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
> [    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
> [    0.000000] Memory: 8196540k/9175040k available (3620k kernel code, 787472k absent, 191028k reserved, 1776k data, 512k init)
> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.000000] NR_IRQS:4352 nr_irqs:440
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2499.885 MHz processor.
> [    0.000604] Console: colour VGA+ 80x25
> [    0.000606] console [tty0] enabled
> [    0.003333] allocated 83886080 bytes of page_cgroup
> [    0.003333] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.003333] hpet clockevent registered
> [    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
> [    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5001.09 BogoMIPS (lpj=8332950)
> [    0.003333] Security Framework initialized
> [    0.003333] SELinux:  Disabled at boot.
> [    0.003333] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.003933] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.005419] Mount-cache hash table entries: 256
> [    0.005582] Initializing cgroup subsys ns
> [    0.005617] Initializing cgroup subsys cpuacct
> [    0.005647] Initializing cgroup subsys memory
> [    0.005680] Initializing cgroup subsys devices
> [    0.005710] Initializing cgroup subsys freezer
> [    0.005739] Initializing cgroup subsys net_cls
> [    0.005781] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.005834] CPU: L2 cache: 3072K
> [    0.005863] CPU 0/0x0 -> Node 0
> [    0.005892] CPU: Physical Processor ID: 0
> [    0.005921] CPU: Processor Core ID: 0
> [    0.005950] mce: CPU supports 6 MCE banks
> [    0.005984] CPU0: Thermal monitoring enabled (TM2)
> [    0.006015] using mwait in idle threads.
> [    0.006044] Performance Counters: Core2 events, Intel PMU driver.
> [    0.006123] ... version:                 2
> [    0.006152] ... bit width:               40
> [    0.006180] ... generic counters:        2
> [    0.006209] ... value mask:              000000ffffffffff
> [    0.006238] ... max period:              000000007fffffff
> [    0.006267] ... fixed-purpose counters:  3
> [    0.006295] ... counter mask:            0000000700000003
> [    0.006342] ACPI: Core revision 20090521
> [    0.020047] Setting APIC routing to flat
> [    0.020375] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.053465] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.056666] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.003333] Initializing CPU#1
> [    0.003333] Calibrating delay using timer specific routine.. 5001.66 BogoMIPS (lpj=8332262)
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.003333] CPU: L2 cache: 3072K
> [    0.003333] CPU 1/0x1 -> Node 0
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 1
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] CPU1: Thermal monitoring enabled (TM2)
> [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> [    0.147946] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.148309] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.150087] Booting processor 2 APIC 0x2 ip 0x6000
> [    0.003333] Initializing CPU#2
> [    0.003333] Calibrating delay using timer specific routine.. 5001.67 BogoMIPS (lpj=8332281)
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.003333] CPU: L2 cache: 3072K
> [    0.003333] CPU 2/0x2 -> Node 0
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 2
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] CPU2: Thermal monitoring enabled (TM2)
> [    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
> [    0.244571] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.245264] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
> [    0.246723] Booting processor 3 APIC 0x3 ip 0x6000
> [    0.003333] Initializing CPU#3
> [    0.003333] Calibrating delay using timer specific routine.. 4971.40 BogoMIPS (lpj=8282243)
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.003333] CPU: L2 cache: 3072K
> [    0.003333] CPU 3/0x3 -> Node 0
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 3
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] CPU3: Thermal monitoring enabled (TM2)
> [    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
> [    0.341305] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9300  @ 2.50GHz stepping 07
> [    0.341666] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
> [    0.343342] Brought up 4 CPUs
> [    0.343379] Total of 4 processors activated (19975.83 BogoMIPS).
> [    0.343515] regulator: core version 0.5
> [    0.343515] NET: Registered protocol family 16
> [    0.343515] ACPI: bus type pci registered
> [    0.346686] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.346717] PCI: Not using MMCONFIG.
> [    0.346745] PCI: Using configuration type 1 for base access
> [    0.347306] bio: create slab <bio-0> at 0
> [    0.347306] ACPI: EC: Look up EC in DSDT
> [    0.361893] ACPI: Interpreter enabled
> [    0.361929] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.362100] ACPI: Using IOAPIC for interrupt routing
> [    0.362173] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.364525] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
> [    0.369937] PCI: Using MMCONFIG at e0000000 - efffffff
> [    0.376835] ACPI: No dock devices found.
> [    0.376963] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.377023] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.377023] pci 0000:00:01.0: PME# disabled
> [    0.377023] pci 0000:00:1a.0: reg 20 io port: [0xb800-0xb81f]
> [    0.377023] pci 0000:00:1a.1: reg 20 io port: [0xb880-0xb89f]
> [    0.377023] pci 0000:00:1a.2: reg 20 io port: [0xbc00-0xbc1f]
> [    0.377023] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe7ffc00-0xfe7fffff]
> [    0.377060] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
> [    0.377091] pci 0000:00:1a.7: PME# disabled
> [    0.377151] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe7f8000-0xfe7fbfff]
> [    0.377183] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.377214] pci 0000:00:1b.0: PME# disabled
> [    0.377299] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.377330] pci 0000:00:1c.0: PME# disabled
> [    0.377406] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.377437] pci 0000:00:1c.4: PME# disabled
> [    0.377510] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.377541] pci 0000:00:1c.5: PME# disabled
> [    0.377611] pci 0000:00:1d.0: reg 20 io port: [0xb080-0xb09f]
> [    0.377666] pci 0000:00:1d.1: reg 20 io port: [0xb400-0xb41f]
> [    0.377720] pci 0000:00:1d.2: reg 20 io port: [0xb480-0xb49f]
> [    0.377778] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe7ff800-0xfe7ffbff]
> [    0.377822] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    0.377854] pci 0000:00:1d.7: PME# disabled
> [    0.377978] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [    0.378013] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> [    0.378044] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
> [    0.378080] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
> [    0.378162] pci 0000:00:1f.2: reg 10 io port: [0xac00-0xac07]
> [    0.378166] pci 0000:00:1f.2: reg 14 io port: [0xa880-0xa883]
> [    0.378171] pci 0000:00:1f.2: reg 18 io port: [0xa800-0xa807]
> [    0.378175] pci 0000:00:1f.2: reg 1c io port: [0xa480-0xa483]
> [    0.378179] pci 0000:00:1f.2: reg 20 io port: [0xa400-0xa41f]
> [    0.378184] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe7fe800-0xfe7fefff]
> [    0.378208] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.378239] pci 0000:00:1f.2: PME# disabled
> [    0.378288] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe7ff400-0xfe7ff4ff]
> [    0.378298] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
> [    0.378333] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
> [    0.378337] pci 0000:01:00.0: reg 14 io port: [0xc000-0xc0ff]
> [    0.378341] pci 0000:01:00.0: reg 18 32bit mmio: [0xfe8e0000-0xfe8effff]
> [    0.378353] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe8c0000-0xfe8dffff]
> [    0.378367] pci 0000:01:00.0: supports D1 D2
> [    0.378389] pci 0000:01:00.1: reg 10 32bit mmio: [0xfe8f0000-0xfe8fffff]
> [    0.378417] pci 0000:01:00.1: supports D1 D2
> [    0.378451] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
> [    0.378453] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
> [    0.378456] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
> [    0.378491] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
> [    0.378529] pci 0000:03:00.0: reg 10 io port: [0xec00-0xec07]
> [    0.378536] pci 0000:03:00.0: reg 14 io port: [0xe880-0xe883]
> [    0.378542] pci 0000:03:00.0: reg 18 io port: [0xe800-0xe807]
> [    0.378549] pci 0000:03:00.0: reg 1c io port: [0xe480-0xe483]
> [    0.378556] pci 0000:03:00.0: reg 20 io port: [0xe400-0xe40f]
> [    0.380001] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
> [    0.380036] pci 0000:03:00.0: supports D1
> [    0.380037] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
> [    0.380069] pci 0000:03:00.0: PME# disabled
> [    0.380135] pci 0000:00:1c.4: bridge io port: [0xe000-0xefff]
> [    0.380138] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
> [    0.380186] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9c0000-0xfe9fffff]
> [    0.380193] pci 0000:02:00.0: reg 18 io port: [0xdc00-0xdc7f]
> [    0.380243] pci 0000:02:00.0: PME# supported from D3hot D3cold
> [    0.380276] pci 0000:02:00.0: PME# disabled
> [    0.380344] pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
> [    0.380347] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
> [    0.380377] pci 0000:05:00.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
> [    0.380416] pci 0000:05:00.0: supports D1 D2
> [    0.380445] pci 0000:05:01.0: reg 10 32bit mmio: [0xfebe0000-0xfebeffff]
> [    0.380520] pci 0000:00:1e.0: transparent bridge
> [    0.380553] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
> [    0.380573] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.380684] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [    0.380732] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [    0.380822] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [    0.380866] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
> [    0.380930] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [    0.394048] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [    0.394048] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [    0.394227] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [    0.394627] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [    0.396832] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [    0.397283] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
> [    0.397684] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [    0.398084] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> [    0.398447] PCI: Using ACPI for IRQ routing
> [    0.410007] NetLabel: Initializing
> [    0.410038] NetLabel:  domain hash size = 128
> [    0.410068] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.410119] NetLabel:  unlabeled traffic allowed by default
> [    0.410180] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
> [    0.410327] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
> [    0.430004] pnp: PnP ACPI init
> [    0.430044] ACPI: bus type pnp registered
> [    0.433058] pnp: PnP ACPI: found 14 devices
> [    0.433088] ACPI: ACPI bus type pnp unregistered
> [    0.433124] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [    0.433158] system 00:06: ioport range 0x290-0x29f has been reserved
> [    0.433191] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
> [    0.433221] system 00:07: ioport range 0x800-0x87f has been reserved
> [    0.433251] system 00:07: ioport range 0x500-0x57f could not be reserved
> [    0.433282] system 00:07: iomem range 0xfed08000-0xfed08fff has been reserved
> [    0.433313] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [    0.433347] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
> [    0.433378] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
> [    0.433411] system 00:0a: iomem range 0xffc00000-0xffefffff has been reserved
> [    0.433444] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
> [    0.433478] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
> [    0.433511] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.433543] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
> [    0.433574] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
> [    0.433604] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
> [    0.433635] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
> [    0.438810] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    0.438841] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
> [    0.438872] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
> [    0.438902] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
> [    0.438938] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
> [    0.438967] pci 0000:00:1c.0:   IO window: disabled
> [    0.438998] pci 0000:00:1c.0:   MEM window: disabled
> [    0.439029] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
> [    0.439066] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
> [    0.439096] pci 0000:00:1c.4:   IO window: 0xe000-0xefff
> [    0.439128] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
> [    0.439159] pci 0000:00:1c.4:   PREFETCH window: disabled
> [    0.439190] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
> [    0.439220] pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
> [    0.439251] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
> [    0.439282] pci 0000:00:1c.5:   PREFETCH window: disabled
> [    0.439313] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
> [    0.439343] pci 0000:00:1e.0:   IO window: disabled
> [    0.439374] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
> [    0.439405] pci 0000:00:1e.0:   PREFETCH window: disabled
> [    0.439440]   alloc irq_desc for 16 on node 0
> [    0.439441]   alloc kstat_irqs on node 0
> [    0.439445] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    0.439477] pci 0000:00:01.0: setting latency timer to 64
> [    0.439481]   alloc irq_desc for 17 on node 0
> [    0.439483]   alloc kstat_irqs on node 0
> [    0.439485] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.439516] pci 0000:00:1c.0: setting latency timer to 64
> [    0.439521] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    0.439552] pci 0000:00:1c.4: setting latency timer to 64
> [    0.439557] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
> [    0.439589] pci 0000:00:1c.5: setting latency timer to 64
> [    0.439593] pci 0000:00:1e.0: setting latency timer to 64
> [    0.439596] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.439598] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    0.439600] pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
> [    0.439602] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe8fffff]
> [    0.439604] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
> [    0.439606] pci_bus 0000:04: resource 2 pref mem [0xfdf00000-0xfdffffff]
> [    0.439607] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
> [    0.439609] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
> [    0.439611] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
> [    0.439612] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
> [    0.439614] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
> [    0.439616] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
> [    0.439618] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
> [    0.439630] NET: Registered protocol family 2
> [    0.439810] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.440788] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> [    0.443740] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.444135] TCP: Hash tables configured (established 524288 bind 65536)
> [    0.444166] TCP reno registered
> [    0.444277] NET: Registered protocol family 1
> [    0.444365] Trying to unpack rootfs image as initramfs...
> [    0.461772] Freeing initrd memory: 988k freed
> [    0.463527] Scanning for low memory corruption every 60 seconds
> [    0.463941] audit: initializing netlink socket (disabled)
> [    0.463980] type=2000 audit(1254327177.463:1): initialized
> [    0.469394] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.472826] VFS: Disk quotas dquot_6.5.2
> [    0.472924] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.473049] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    0.473142] msgmni has been set to 16010
> [    0.473702] alg: No test for stdrng (krng)
> [    0.473871] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> [    0.473906] io scheduler noop registered
> [    0.473935] io scheduler anticipatory registered
> [    0.473964] io scheduler deadline registered
> [    0.474061] io scheduler cfq registered (default)
> [    0.474220] pci 0000:01:00.0: Boot video device
> [    0.474385]   alloc irq_desc for 24 on node 0
> [    0.474386]   alloc kstat_irqs on node 0
> [    0.474392] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
> [    0.474397] pcieport-driver 0000:00:01.0: setting latency timer to 64
> [    0.474585]   alloc irq_desc for 25 on node 0
> [    0.474586]   alloc kstat_irqs on node 0
> [    0.474591] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
> [    0.474598] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    0.474843]   alloc irq_desc for 26 on node 0
> [    0.474845]   alloc kstat_irqs on node 0
> [    0.474850] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
> [    0.474856] pcieport-driver 0000:00:1c.4: setting latency timer to 64
> [    0.475093]   alloc irq_desc for 27 on node 0
> [    0.475094]   alloc kstat_irqs on node 0
> [    0.475099] pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
> [    0.475105] pcieport-driver 0000:00:1c.5: setting latency timer to 64
> [    0.501814] Switched to high resolution mode on CPU 1
> [    0.501929] Switched to high resolution mode on CPU 3
> [    0.502187] Switched to high resolution mode on CPU 2
> [    0.503443] Switched to high resolution mode on CPU 0
> [    0.517972] Linux agpgart interface v0.103
> [    0.518078] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    0.521418] brd: module loaded
> [    0.521597] input: Macintosh mouse button emulation as /devices/virtual/input/input0
> [    0.521779] Fixed MDIO Bus: probed
> [    0.522066] PNP: No PS/2 controller found. Probing ports directly.
> [    0.524645] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.524685] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.524936] mice: PS/2 mouse device common for all mice
> [    0.525025] rtc_cmos 00:03: RTC can wake from S4
> [    0.525111] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    0.525160] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.525220] cpuidle: using governor ladder
> [    0.525250] cpuidle: using governor menu
> [    0.525341] TCP cubic registered
> [    0.525533] NET: Registered protocol family 10
> [    0.525715] lo: Disabled Privacy Extensions
> [    0.525763] Mobile IPv6
> [    0.525792] NET: Registered protocol family 17
> [    0.525987] registered taskstats version 1
> [    0.526054] No TPM chip found, activating TPM-bypass!
> [    0.526236] rtc_cmos 00:03: setting system clock to 2009-09-30 16:12:58 UTC (1254327178)
> [    0.526299] Initalizing network drop monitor service
> [    0.526364] Freeing unused kernel memory: 512k freed
> [    0.526830] Write protecting the kernel read-only data: 4944k
> [    0.537773] SCSI subsystem initialized
> [    0.548619] libata version 3.00 loaded.
> [    0.551380] ahci 0000:00:1f.2: version 3.0
> [    0.551394]   alloc irq_desc for 19 on node 0
> [    0.551395]   alloc kstat_irqs on node 0
> [    0.551401] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    0.551479]   alloc irq_desc for 28 on node 0
> [    0.551480]   alloc kstat_irqs on node 0
> [    0.551486] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
> [    0.551515] ahci: SSS flag set, parallel bus scan disabled
> [    0.551571] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
> [    0.551605] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
> [    0.551641] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.586710] scsi0 : ahci
> [    0.586974] scsi1 : ahci
> [    0.587193] scsi2 : ahci
> [    0.587408] scsi3 : ahci
> [    0.587622] scsi4 : ahci
> [    0.587841] scsi5 : ahci
> [    0.588098] ata1: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe900 irq 28
> [    0.588133] ata2: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fe980 irq 28
> [    0.588167] ata3: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea00 irq 28
> [    0.588201] ata4: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7fea80 irq 28
> [    0.588235] ata5: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb00 irq 28
> [    0.588269] ata6: SATA max UDMA/133 abar m2048@0xfe7fe800 port 0xfe7feb80 irq 28
> [    1.066676] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.067190] ata1.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
> [    1.067223] ata1.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
> [    1.067808] ata1.00: configured for UDMA/133
> [    1.080089] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
> [    1.960010] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.960500] ata2.00: ATA-7: WDC WD1600YD-01NVB1, 10.02E01, max UDMA/133
> [    1.960534] ata2.00: 321672960 sectors, multi 0: LBA48 NCQ (depth 1)
> [    1.961108] ata2.00: configured for UDMA/133
> [    1.973396] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600YD-01N 10.0 PQ: 0 ANSI: 5
> [    2.293343] ata3: SATA link down (SStatus 0 SControl 300)
> [    2.626676] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.960009] ata5: SATA link down (SStatus 0 SControl 300)
> [    3.293342] ata6: SATA link down (SStatus 0 SControl 300)
> [    3.309187] JFS: nTxBlock = 8192, nTxLock = 65536
> [    3.324481] md: raid1 personality registered for level 1
> [    3.327544] sd 0:0:0:0: [sda] 321672960 512-byte logical blocks: (164 GB/153 GiB)
> [    3.327620] sd 1:0:0:0: [sdb] 321672960 512-byte logical blocks: (164 GB/153 GiB)
> [    3.327631] sd 0:0:0:0: [sda] Write Protect is off
> [    3.327633] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.327648] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.327752]  sda:
> [    3.327757] sd 1:0:0:0: [sdb] Write Protect is off
> [    3.327759] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    3.327775] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.327969]  sdb: sda1 sda2 sda3
> [    3.343970] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.350132]  sdb1 sdb2 sdb3
> [    3.350947] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    3.485159] md: md0 stopped.
> [    3.485919] md: bind<sda2>
> [    3.486104] md: bind<sdb2>
> [    3.486262] raid1: raid set md0 active with 2 out of 2 mirrors
> [    3.486314] md0: detected capacity change from 0 to 12000559104
> [    3.488386]  md0: unknown partition table
> [    6.276464] ACPI: SSDT 00000000cff7e0d0 001F3 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
> [    6.276918] processor LNXCPU:00: registered as cooling_device0
> [    6.277270] ACPI: SSDT 00000000cff7e2d0 001F3 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
> [    6.277712] processor LNXCPU:01: registered as cooling_device1
> [    6.278059] ACPI: SSDT 00000000cff7e4d0 001F3 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
> [    6.278494] processor LNXCPU:02: registered as cooling_device2
> [    6.278838] ACPI: SSDT 00000000cff7e6d0 001F3 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
> [    6.279273] processor LNXCPU:03: registered as cooling_device3
> [    6.305074] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    6.305112] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    6.307547] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    6.307554] ACPI: Power Button [PWRF]
> [    6.307620] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> [    6.307623] ACPI: Power Button [PWRB]
> [    6.321250] input: PC Speaker as /devices/platform/pcspkr/input/input3
> [    6.403806] cfg80211: Using static regulatory domain info
> [    6.403809] cfg80211: Regulatory domain: US
> [    6.403810] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [    6.403813] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
> [    6.403816] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    6.403818] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    6.403820] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    6.403822] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
> [    6.403825] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> [    6.403831] cfg80211: Calling CRDA for country: US
> [    6.431001] usbcore: registered new interface driver usbfs
> [    6.431039] usbcore: registered new interface driver hub
> [    6.431242] usbcore: registered new device driver usb
> [    6.485442] iTCO_vendor_support: vendor-support=0
> [    6.515088]   alloc irq_desc for 18 on node 0
> [    6.515091]   alloc kstat_irqs on node 0
> [    6.515097] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    6.515101] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> [    6.515102] ACPI: Device needs an ACPI driver
> [    6.515110] i801_smbus: probe of 0000:00:1f.3 failed with error -16
> [    6.527788] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
> [    6.527889] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
> [    6.527979] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    6.541373] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    6.541584] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    6.541617] ehci_hcd 0000:00:1a.7: setting latency timer to 64
> [    6.541620] ehci_hcd 0000:00:1a.7: EHCI Host Controller
> [    6.541657] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
> [    6.545561] ehci_hcd 0000:00:1a.7: debug port 1
> [    6.545565] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
> [    6.545581] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe7ffc00
> [    6.550893] uhci_hcd: USB Universal Host Controller Interface driver
> [    6.556677] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
> [    6.556702] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    6.556705] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.556707] usb usb1: Product: EHCI Host Controller
> [    6.556709] usb usb1: Manufacturer: Linux 2.6.31-0.4-dirty ehci_hcd
> [    6.556711] usb usb1: SerialNumber: 0000:00:1a.7
> [    6.556818] usb usb1: configuration #1 chosen from 1 choice
> [    6.556841] hub 1-0:1.0: USB hub found
> [    6.556848] hub 1-0:1.0: 6 ports detected
> [    6.557203] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    6.557210] uhci_hcd 0000:00:1a.0: setting latency timer to 64
> [    6.557213] uhci_hcd 0000:00:1a.0: UHCI Host Controller
> [    6.557225] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
> [    6.557262] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b800
> [    6.557297] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.557299] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.557301] usb usb2: Product: UHCI Host Controller
> [    6.557302] usb usb2: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.557303] usb usb2: SerialNumber: 0000:00:1a.0
> [    6.557371] usb usb2: configuration #1 chosen from 1 choice
> [    6.557412] hub 2-0:1.0: USB hub found
> [    6.557418] hub 2-0:1.0: 2 ports detected
> [    6.557565]   alloc irq_desc for 23 on node 0
> [    6.557567]   alloc kstat_irqs on node 0
> [    6.557571] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    6.557609] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    6.557611] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    6.557620] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
> [    6.561522] ehci_hcd 0000:00:1d.7: debug port 1
> [    6.561526] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    6.561641] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe7ff800
> [    6.573347] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    6.573378] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    6.573381] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.573383] usb usb3: Product: EHCI Host Controller
> [    6.573385] usb usb3: Manufacturer: Linux 2.6.31-0.4-dirty ehci_hcd
> [    6.573386] usb usb3: SerialNumber: 0000:00:1d.7
> [    6.573684] usb usb3: configuration #1 chosen from 1 choice
> [    6.573736] hub 3-0:1.0: USB hub found
> [    6.573743] hub 3-0:1.0: 6 ports detected
> [    6.574089]   alloc irq_desc for 21 on node 0
> [    6.574091]   alloc kstat_irqs on node 0
> [    6.574096] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
> [    6.574103] uhci_hcd 0000:00:1a.1: setting latency timer to 64
> [    6.574105] uhci_hcd 0000:00:1a.1: UHCI Host Controller
> [    6.574117] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
> [    6.574145] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
> [    6.574173] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.574175] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.574177] usb usb4: Product: UHCI Host Controller
> [    6.574179] usb usb4: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.574181] usb usb4: SerialNumber: 0000:00:1a.1
> [    6.574817] usb usb4: configuration #1 chosen from 1 choice
> [    6.574874] hub 4-0:1.0: USB hub found
> [    6.574881] hub 4-0:1.0: 2 ports detected
> [    6.575010] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    6.575016] uhci_hcd 0000:00:1a.2: setting latency timer to 64
> [    6.575018] uhci_hcd 0000:00:1a.2: UHCI Host Controller
> [    6.575028] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
> [    6.575062] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000bc00
> [    6.575092] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.575094] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.575095] usb usb5: Product: UHCI Host Controller
> [    6.575097] usb usb5: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.575098] usb usb5: SerialNumber: 0000:00:1a.2
> [    6.575177] usb usb5: configuration #1 chosen from 1 choice
> [    6.575221] hub 5-0:1.0: USB hub found
> [    6.575227] hub 5-0:1.0: 2 ports detected
> [    6.575346] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    6.575350] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    6.575353] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    6.575363] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
> [    6.575383] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b080
> [    6.575411] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.575413] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.575414] usb usb6: Product: UHCI Host Controller
> [    6.575416] usb usb6: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.575417] usb usb6: SerialNumber: 0000:00:1d.0
> [    6.576026] usb usb6: configuration #1 chosen from 1 choice
> [    6.576072] hub 6-0:1.0: USB hub found
> [    6.576077] hub 6-0:1.0: 2 ports detected
> [    6.576221] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    6.576226] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    6.576228] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    6.576238] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
> [    6.576265] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
> [    6.576290] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.576292] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.576293] usb usb7: Product: UHCI Host Controller
> [    6.576295] usb usb7: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.576296] usb usb7: SerialNumber: 0000:00:1d.1
> [    6.576365] usb usb7: configuration #1 chosen from 1 choice
> [    6.576407] hub 7-0:1.0: USB hub found
> [    6.576413] hub 7-0:1.0: 2 ports detected
> [    6.576549] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    6.576554] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    6.576556] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    6.576568] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
> [    6.576587] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b480
> [    6.576612] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
> [    6.576614] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    6.576615] usb usb8: Product: UHCI Host Controller
> [    6.576616] usb usb8: Manufacturer: Linux 2.6.31-0.4-dirty uhci_hcd
> [    6.576618] usb usb8: SerialNumber: 0000:00:1d.2
> [    6.576692] usb usb8: configuration #1 chosen from 1 choice
> [    6.576733] hub 8-0:1.0: USB hub found
> [    6.576742] hub 8-0:1.0: 2 ports detected
> [    6.612672] Uniform Multi-Platform E-IDE driver
> [    6.642794] ATL1E 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    6.642803] ATL1E 0000:02:00.0: setting latency timer to 64
> [    6.804078]   alloc irq_desc for 22 on node 0
> [    6.804080]   alloc kstat_irqs on node 0
> [    6.804086] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [    6.804137] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    6.885076] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
> [    7.033350] ath5k 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    7.033407] ath5k 0000:05:01.0: registered as 'phy0'
> [    7.085422] Linux video capture interface: v2.00
> [    7.107933] usb 6-1: new low speed USB device using uhci_hcd and address 2
> [    7.228301] ath: EEPROM regdomain: 0x809c
> [    7.228303] ath: EEPROM indicates we should expect a country code
> [    7.228304] ath: doing EEPROM country->regdmn map search
> [    7.228305] ath: country maps to regdmn code: 0x52
> [    7.228307] ath: Country alpha2 being used: CN
> [    7.228308] ath: Regpair used: 0x52
> [    7.244922] saa7130/34: v4l2 driver version 0.2.15 loaded
> [    7.275369] usb 6-1: New USB device found, idVendor=046d, idProduct=c051
> [    7.275372] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.275374] usb 6-1: Product: USB-PS/2 Optical Mouse
> [    7.275376] usb 6-1: Manufacturer: Logitech
> [    7.275485] usb 6-1: configuration #1 chosen from 1 choice
> [    7.281025] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    7.281052] pata_marvell 0000:03:00.0: setting latency timer to 64
> [    7.281127] scsi6 : pata_marvell
> [    7.281270] scsi7 : pata_marvell
> [    7.281336] ata7: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 16
> [    7.281338] ata8: PATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 16
> [    7.441603] ata7.00: ATAPI: ASUS    DRW-1814BL, 1.10, max UDMA/66
> [    7.454940] ata7.00: configured for UDMA/66
> [    7.456117] scsi 6:0:0:0: CD-ROM            ASUS     DRW-1814BL       1.10 PQ: 0 ANSI: 5
> [    7.456341] scsi 6:0:0:0: Attached scsi generic sg2 type 5
> [    7.503342] usb 6-2: new low speed USB device using uhci_hcd and address 3
> [    7.618928] phy0: Selected rate control algorithm 'minstrel'
> [    7.619031] ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
> [    7.619056] cfg80211: Calling CRDA for country: CN
> [    7.619199] saa7134 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    7.619205] saa7133[0]: found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
> [    7.619210] saa7133[0]: subsystem: 11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133) [card=77,autodetected]
> [    7.619243] saa7133[0]: board init: gpio is 200e000
> [    7.619247] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [    7.620893] usbcore: registered new interface driver hiddev
> [    7.636595] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input5
> [    7.636722] generic-usb 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
> [    7.636735] usbcore: registered new interface driver usbhid
> [    7.636737] usbhid: v2.6:USB HID core driver
> [    7.674068] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
> [    7.674072] Uniform CD-ROM driver Revision: 3.20
> [    7.674241] sr 6:0:0:0: Attached scsi CD-ROM sr0
> [    7.683338] usb 6-2: New USB device found, idVendor=045e, idProduct=00db
> [    7.683341] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    7.683344] usb 6-2: Product: Natural® Ergonomic Keyboard 4000
> [    7.683345] usb 6-2: Manufacturer: Microsoft
> [    7.683452] usb 6-2: configuration #1 chosen from 1 choice
> [    7.739588] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input6
> [    7.739779] microsoft 0003:045E:00DB.0002: input,hidraw1: USB HID v1.11 Keyboard [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input0
> [    7.763452] input: Microsoft Natural® Ergonomic Keyboard 4000 as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input7
> [    7.763556] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.11 Device [Microsoft Natural® Ergonomic Keyboard 4000] on usb-0000:00:1d.0-2/input1
> [    7.766681] saa7133[0]: i2c eeprom 00: bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [    7.766690] saa7133[0]: i2c eeprom 10: ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
> [    7.766697] saa7133[0]: i2c eeprom 20: 01 2c 01 23 23 01 04 30 98 ff 00 e2 ff 22 00 c2
> [    7.766704] saa7133[0]: i2c eeprom 30: 96 ff 03 30 15 01 ff 15 13 25 53 89 01 45 32 7b
> [    7.766711] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766718] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766725] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766732] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766739] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766746] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766753] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766760] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766767] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766774] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766786] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766791] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    7.766798] i2c-adapter i2c-0: Invalid 7-bit address 0x7a
> [    7.870057] tuner 0-004b: chip found @ 0x96 (saa7133[0])
> [    7.946670] tda829x 0-004b: setting tuner address to 61
> [    8.020005] tda829x 0-004b: type set to tda8290+75a
> [   11.701267] ir_probe: addr=0x47
> [   11.701271] ir_probe: [before override] ir_codes=(null), name=SAA713x remote, get_key=(null)
> [   11.701273] ir_probe: [after  override] ir_codes=ffffffff814edde0, name=-q, get_key=ffffffff81479204
> [   11.701276] ir_input_init: dev=ffff880227177000, ir=ffff880221186018, ir_type=99, ir_codes=ffffffff814edde0
> [   11.701278] ir_input_init: [i=0] Setting bit 1768059695 of dev->keybit


1768059695 = 0x6962732f = 'ibs/'

That doesn't seem right for ir->ir_codes[0] ...

Regards,
Andy



> [   11.701286] BUG: unable to handle kernel paging request at ffff88023443be8c
> [   11.701378] IP: [<ffffffffa033a8ae>] ir_input_init+0xae/0x10c [ir_common]
> [   11.701436] PGD 1002063 PUD 18067 PMD 0 
> [   11.701535] Oops: 0002 [#1] SMP 
> [   11.701610] last sysfs file: /sys/module/i2c_core/initstate
> [   11.701641] CPU 2 
> [   11.701692] Modules linked in: ir_kbd_i2c(+) tda827x tda8290 tuner joydev hid_microsoft sr_mod cdrom ata_generic pata_acpi usbhid hid arc4 pata_marvell ecb saa7134(+) ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 ath5k mac80211 videobuf_dma_sg ide_pci_generic led_class videobuf_core snd_hda_codec_realtek tveeprom snd_hda_intel ath snd_hda_codec intel_agp atl1e asus_atk0110 ide_core snd_hwdep snd_pcm psmouse uhci_hcd ehci_hcd iTCO_wdt i2c_i801 hwmon snd_timer iTCO_vendor_support usbcore snd i2c_core evdev serio_raw cfg80211 soundcore pcspkr button thermal sg snd_page_alloc rfkill processor sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache jfs ahci libata scsi_mod [last unloaded: scsi_wait_scan]
> [   11.703488] Pid: 1792, comm: modprobe Not tainted 2.6.31-0.4-dirty #1 P5Q-PRO
> [   11.703518] RIP: 0010:[<ffffffffa033a8ae>]  [<ffffffffa033a8ae>] ir_input_init+0xae/0x10c [ir_common]
> [   11.703578] RSP: 0018:ffff880221163d88  EFLAGS: 00010292
> [   11.703608] RAX: 000000006962732f RBX: ffff880227177000 RCX: 000000000000ffff
> [   11.703638] RDX: ffffffff814eac58 RSI: 0000000000000046 RDI: ffffffff815e1e10
> [   11.703668] RBP: ffff880221186018 R08: 000000000000cca6 R09: 0000000000000005
> [   11.703698] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> [   11.703728] R13: ffff880227177028 R14: ffff880222ea6230 R15: ffffffff81479201
> [   11.703759] FS:  00007fb5955b16f0(0000) GS:ffff88002806c000(0000) knlGS:0000000000000000
> [   11.703793] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   11.703823] CR2: ffff88023443be8c CR3: 0000000224034000 CR4: 00000000000006e0
> [   11.703853] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   11.703883] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   11.703914] Process modprobe (pid: 1792, threadinfo ffff880221162000, task ffff880225aba260)
> [   11.703947] Stack:
> [   11.703975]  ffffffff814edde0 ffff880227177000 ffff880224510000 ffff880221186000
> [   11.704075] <0> ffff8802211862c0 ffffffffa01e0264 00000000007058a0 ffffffff00000063
> [   11.704166] <0> ffff8802211862a0 0000004700000000 0000000000000000 ffffffffa01e0c60
> [   11.704166] Call Trace:
> [   11.704166]  [<ffffffffa01e0264>] ? ir_probe+0x234/0x530 [ir_kbd_i2c]
> [   11.704166]  [<ffffffffa01e0030>] ? ir_probe+0x0/0x530 [ir_kbd_i2c]
> [   11.704166]  [<ffffffffa016c3a1>] ? i2c_device_probe+0xd1/0x100 [i2c_core]
> [   11.704166]  [<ffffffff8126cb58>] ? driver_probe_device+0x88/0x180
> [   11.704166]  [<ffffffff8126cce3>] ? __driver_attach+0x93/0xa0
> [   11.704166]  [<ffffffff8126cc50>] ? __driver_attach+0x0/0xa0
> [   11.704166]  [<ffffffff8126c2d8>] ? bus_for_each_dev+0x58/0x80
> [   11.704166]  [<ffffffff8126ba96>] ? bus_add_driver+0xc6/0x290
> [   11.704166]  [<ffffffff8126cfca>] ? driver_register+0x6a/0x130
> [   11.704166]  [<ffffffffa016d0f0>] ? i2c_register_driver+0x30/0xb0 [i2c_core]
> [   11.704166]  [<ffffffffa03bd000>] ? ir_init+0x0/0x19 [ir_kbd_i2c]
> [   11.704166]  [<ffffffff81009044>] ? do_one_initcall+0x34/0x1a0
> [   11.704166]  [<ffffffff8107be5f>] ? sys_init_module+0xdf/0x230
> [   11.704166]  [<ffffffff8100be2b>] ? system_call_fastpath+0x16/0x1b
> [   11.704166] Code: 00 00 80 00 00 00 45 31 e4 0f 1f 40 00 8b 4d 04 44 89 e2 48 c7 c6 30 a9 33 a0 48 c7 c7 38 ab 33 a0 31 c0 e8 31 50 04 e1 8b 45 04 <f0> 41 0f ab 45 00 41 83 c4 01 48 83 c5 04 41 81 fc 80 00 00 00 
> [   11.704166] RIP  [<ffffffffa033a8ae>] ir_input_init+0xae/0x10c [ir_common]
> [   11.704166]  RSP <ffff880221163d88>
> [   11.704166] CR2: ffff88023443be8c
> [   11.704166] ---[ end trace b50110ef9ceb49a3 ]---
> [   11.763454] saa7133[0]: registered device video0 [v4l2]
> [   11.763530] saa7133[0]: registered device vbi0
> [   11.763600] saa7133[0]: registered device radio0
> [   11.821992] saa7134 ALSA driver for DMA sound loaded
> [   11.822032] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   11.822079] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card 1
> [   59.218734] Adding 6000236k swap on /dev/sda1.  Priority:0 extents:1 across:6000236k 
> [   59.233319] Adding 6000236k swap on /dev/sdb1.  Priority:0 extents:1 across:6000236k 
> [   60.071981] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
> [   60.389291] device-mapper: uevent: version 1.0.3
> [   60.389669] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> [   60.698468] md: md1 stopped.
> [   60.785274] md: bind<sdb3>
> [   60.785442] md: bind<sda3>
> [   60.810076] md: raid10 personality registered for level 10
> [   60.810278] raid10: raid set md1 active with 2 out of 2 devices
> [   60.810339] md1: detected capacity change from 0 to 146549637120
> [   60.903482]  md1: unknown partition table
> [   62.291284] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   62.383610] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   62.401457] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [   62.401692] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [   62.401728] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> [   62.401767] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [   63.256222]   alloc irq_desc for 29 on node 0
> [   63.256260]   alloc kstat_irqs on node 0
> [   63.256299] ATL1E 0000:02:00.0: irq 29 for MSI/MSI-X
> [   63.256450] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [   69.446831] ATL1E 0000:02:00.0: ATL1E: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [   69.448397] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   69.614282] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   70.923176] Bluetooth: Core ver 2.15
> [   70.923310] NET: Registered protocol family 31
> [   70.923349] Bluetooth: HCI device and connection manager initialized
> [   70.923380] Bluetooth: HCI socket layer initialized
> [   70.926815] Bluetooth: L2CAP ver 2.13
> [   70.926848] Bluetooth: L2CAP socket layer initialized
> [   70.929820] Bluetooth: RFCOMM TTY layer initialized
> [   70.929857] Bluetooth: RFCOMM socket layer initialized
> [   70.929887] Bluetooth: RFCOMM ver 1.11
> [   71.448392] coretemp coretemp.0: Using relative temperature scale!
> [   71.448501] coretemp coretemp.1: Using relative temperature scale!
> [   71.448597] coretemp coretemp.2: Using relative temperature scale!
> [   71.448656] coretemp coretemp.3: Using relative temperature scale!
> [   71.780000] dummy0: no IPv6 routers present
> [   75.715040] radeonfb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   75.715469] radeonfb: Found Intel x86 BIOS ROM Image
> [   75.715500] radeonfb: Retrieved PLL infos from BIOS
> [   75.715530] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=400.00 Mhz, System=350.00 MHz
> [   75.715564] radeonfb: PLL min 20000 max 40000
> [   75.974409] i2c-adapter i2c-3: unable to read EDID block.
> [   76.117742] i2c-adapter i2c-3: unable to read EDID block.
> [   76.261075] i2c-adapter i2c-3: unable to read EDID block.
> [   76.564334] radeonfb: Monitor 1 type DFP found
> [   76.564364] radeonfb: EDID probed
> [   76.564392] radeonfb: Monitor 2 type no found
> [   76.581465] Console: switching to colour frame buffer device 210x65
> [   76.592672] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [   76.592765] radeonfb (0000:01:00.0): ATI Radeon 5b63 "[c"
> [   88.736661] wlan0: no IPv6 routers present
> [  170.301275] [drm] Initialized drm 1.1.0 20060810
> [  170.324481] radeonfb 0000:01:00.0: setting latency timer to 64
> [  170.325015] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
> [  170.325686] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [  170.577017] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [  170.577065] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [  170.577098] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
> [  170.788488] [drm] Setting GART location based on new memory map
> [  170.789201] [drm] Loading R300 Microcode
> [  170.789224] [drm] Num pipes: 1
> [  170.789229] [drm] writeback test succeeded in 1 usecs

