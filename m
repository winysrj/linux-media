Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53532 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2EBG6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 02:58:14 -0400
Received: by yenl12 with SMTP id l12so319002yen.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 23:58:13 -0700 (PDT)
MIME-Version: 1.0
From: Alexey Savartsov <asavartsov@gmail.com>
Date: Wed, 2 May 2012 10:57:52 +0400
Message-ID: <CAEvF=+b4zGaUKbBqfOBuO6DqZZ_JPXBw4gAfV_k2N=SYhJC__g@mail.gmail.com>
Subject: Stack trace when trying to zap to channel
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have got a fresh Ubuntu 10.04 (i386) installation with all updates
at hp ProLiant DL380 G3 server and two TT-Budget S2-3200 PCI cards.

My ~/.szap/channels.conf file:

TEST1:11900:v:1:27500:321:401:16101
TEST2:11900:v:0:27500:324:404:16104

root@pixie:~# szap -n 1
reading channels from file '/root/.szap/channels.conf'
zapping to 1 'TEST1':
sat 1, frequency = 11900 MHz V, symbolrate 27500000, vpid = 0x0141,
apid = 0x0191 sid = 0x3ee5
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_VOLTAGE failed: Input/output error
FE_DISEQC_SEND_MASTER_CMD failed: Connection timed out
FE_SET_TONE failed: Input/output error

dmesg output:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-41-generic-pae (buildd@palmer)
(gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #88-Ubuntu SMP Thu Mar
29 14:24:36 UTC 2012 (Ubuntu 2.6.32-41.88-generic-pae
2.6.32.59+drm33.24)
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
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fffa000 (usable)
[    0.000000]  BIOS-e820: 000000007fffa000 - 0000000080000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x7fffa max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 400020000 mask FFFFF0000 uncachable
[    0.000000]   2 base 400040000 mask FFFFF0000 uncachable
[    0.000000]   3 base 400060000 mask FFFFF0000 uncachable
[    0.000000]   4 base 400080000 mask FFFFF0000 uncachable
[    0.000000]   5 base 4000A0000 mask FFFFF0000 uncachable
[    0.000000]   6 base 4000C0000 mask FFFFF0000 uncachable
[    0.000000]   7 base 4000E0000 mask FFFFF0000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fffa000 (usable)
[    0.000000]  modified: 000000007fffa000 - 0000000080000000 (ACPI data)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] Using x86 segment limits to approximate NX protection
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] RAMDISK: 3779b000 - 37fefedf
[    0.000000] Allocated new RAMDISK: 00947000 - 0119bedf
[    0.000000] Move RAMDISK from 000000003779b000 - 0000000037fefede
to 00947000 - 0119bede
[    0.000000] ACPI: RSDP 000f4f70 00014 (v00 COMPAQ)
[    0.000000] ACPI: RSDT 7fffa000 00030 (v01 COMPAQ P29      00000002
  <D2>? 0000162E)
[    0.000000] ACPI: FACP 7fffa040 00074 (v01 COMPAQ P29      00000002
  <D2>? 0000162E)
[    0.000000] ACPI Warning: Invalid length for Pm1aControlBlock: 32,
using default 16 (20090903/tbfadt-607)
[    0.000000] ACPI Warning: Invalid length for Pm1bControlBlock: 32,
using default 16 (20090903/tbfadt-607)
[    0.000000] ACPI: DSDT 7fffa240 03C44 (v01 COMPAQ     DSDT 00000001
MSFT 0100000B)
[    0.000000] ACPI: FACS 7fffa0c0 00040
[    0.000000] ACPI: APIC 7fffa100 000AC (v01 COMPAQ 00000083 00000002
     00000000)
[    0.000000] ACPI: SPCR 7fffa1c0 00050 (v01 COMPAQ SPCRRBSU 00000001
  <D2>? 0000162E)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1157MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00009000 - 0000ff40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000093e858]    TEXT DATA BSS ==>
[0000100000 - 000093e858]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==>
[000009ec00 - 0000100000]
[    0.000000]   #5 [000093f000 - 0000946089]              BRK ==>
[000093f000 - 0000946089]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==>
[0000007000 - 0000009000]
[    0.000000]   #7 [0000947000 - 000119bedf]      NEW RAMDISK ==>
[0000947000 - 000119bedf]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==>
[0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f4fd0] f4fd0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0007fffa
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0007fffa
[    0.000000] On node 0 totalpages: 524180
[    0.000000] free_area_init_node: node 0, pgdat c07df020,
node_mem_map c119d000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3962 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2316 pages used for memmap
[    0.000000]   HighMem zone: 294128 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x920
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec03000] gsi_base[48])
[    0.000000] IOAPIC[3]: apic_id 5, version 17, address 0xfec03000, GSI 48-63
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 8 CPUs, 6 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @c2200000 s39480 r0 d21960 u262144
[    0.000000] pcpu-alloc: s39480 r0 d21960 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 520084
[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-2.6.32-41-generic-pae root=/dev/mapper/pixie-root
ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 10485640 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000379fe:0007fffa)
[    0.000000] Memory: 2050288k/2097128k available (4852k kernel code,
44984k reserved, 2226k data, 680k init, 1185776k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc07ea000 - 0xc0894000   ( 680 kB)
[    0.000000]       .data : 0xc05bd03f - 0xc07e99c8   (2226 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05bd03f   (4852 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=128, Order=0-3,
MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:1152
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2782.344 MHz processor.
[    0.008012] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5564.68 BogoMIPS (lpj=11129376)
[    0.008042] Security Framework initialized
[    0.008092] AppArmor: AppArmor initialized
[    0.008108] Mount-cache hash table entries: 512
[    0.008388] Initializing cgroup subsys ns
[    0.008396] Initializing cgroup subsys cpuacct
[    0.008402] Initializing cgroup subsys memory
[    0.008415] Initializing cgroup subsys devices
[    0.008420] Initializing cgroup subsys freezer
[    0.008423] Initializing cgroup subsys net_cls
[    0.008464] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.008468] CPU: L2 cache: 512K
[    0.008473] CPU: Physical Processor ID: 3
[    0.008475] CPU: Processor Core ID: 0
[    0.008482] mce: CPU supports 4 MCE banks
[    0.008497] CPU0: Thermal monitoring enabled (TM1)
[    0.008516] Performance Events: no PMU driver, software events only.
[    0.008526] Checking 'hlt' instruction... OK.
[    0.027858] ACPI: Core revision 20090903
[    0.038419] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.038428] ftrace: allocating 22470 entries in 44 pages
[    0.040170] Enabling APIC mode:  Flat.  Using 4 I/O APICs
[    0.041005] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.083287] CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
[    0.084001] Booting processor 1 APIC 0x7 ip 0x6000
[    0.012000] Initializing CPU#1
[    0.012000] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.012000] CPU: L2 cache: 512K
[    0.012000] CPU: Physical Processor ID: 3
[    0.012000] CPU: Processor Core ID: 0
[    0.012000] CPU1: Thermal monitoring enabled (TM1)
[    0.168057] CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 09
[    0.168072] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.172061] Brought up 2 CPUs
[    0.172067] Total of 2 processors activated (11129.39 BogoMIPS).
[    0.172641] CPU0 attaching sched-domain:
[    0.172650]  domain 0: span 0-1 level SIBLING
[    0.172655]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[    0.172665]   domain 1: span 0-1 level MC
[    0.172669]    groups: 0-1 (cpu_power = 1178)
[    0.172679] CPU1 attaching sched-domain:
[    0.172682]  domain 0: span 0-1 level SIBLING
[    0.172686]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[    0.172695]   domain 1: span 0-1 level MC
[    0.172699]    groups: 0-1 (cpu_power = 1178)
[    0.172863] devtmpfs: initialized
[    0.172863] regulator: core version 0.5
[    0.172863] Time:  6:46:24  Date: 05/02/12
[    0.172863] NET: Registered protocol family 16
[    0.172863] Trying to unpack rootfs image as initramfs...
[    0.172863] EISA bus registered
[    0.172863] ACPI: bus type pci registered
[    0.188375] PCI: PCI BIOS revision 2.10 entry at 0xf0094, last bus=9
[    0.188382] PCI: Using configuration type 1 for base access
[    0.188405] PCI: HP ProLiant DL380 detected, enabling pci=bfsort.
[    0.191062] bio: create slab <bio-0> at 0
[    0.192806] ACPI: EC: Look up EC in DSDT
[    0.203284] ACPI: Interpreter enabled
[    0.203294] ACPI: (supports S0 S4 S5)
[    0.203336] ACPI: Using IOAPIC for interrupt routing
[    0.212612] ACPI: No dock devices found.
[    0.213500] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.213751] pci 0000:00:03.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
[    0.213764] pci 0000:00:03.0: reg 14 io port: [0x2400-0x24ff]
[    0.213776] pci 0000:00:03.0: reg 18 32bit mmio: [0xf5ff0000-0xf5ff0fff]
[    0.213807] pci 0000:00:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.213849] pci 0000:00:03.0: supports D1 D2
[    0.213924] pci 0000:00:04.0: reg 10 io port: [0x1800-0x18ff]
[    0.213940] pci 0000:00:04.0: reg 14 32bit mmio: [0xf5fe0000-0xf5fe01ff]
[    0.214061] pci 0000:00:04.2: reg 10 io port: [0x2800-0x28ff]
[    0.214074] pci 0000:00:04.2: reg 14 32bit mmio: [0xf5fd0000-0xf5fd07ff]
[    0.214086] pci 0000:00:04.2: reg 18 32bit mmio: [0xf5fc0000-0xf5fc1fff]
[    0.214099] pci 0000:00:04.2: reg 1c 32bit mmio: [0xf5f00000-0xf5f7ffff]
[    0.214124] pci 0000:00:04.2: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.214168] pci 0000:00:04.2: PME# supported from D0 D3hot D3cold
[    0.214177] pci 0000:00:04.2: PME# disabled
[    0.214309] pci 0000:00:0f.1: reg 10 io port: [0x1f0-0x1f7]
[    0.214328] pci 0000:00:0f.1: reg 14 io port: [0x3f4-0x3f7]
[    0.214351] pci 0000:00:0f.1: reg 18 io port: [0x170-0x177]
[    0.214374] pci 0000:00:0f.1: reg 1c io port: [0x374-0x377]
[    0.214386] pci 0000:00:0f.1: reg 20 io port: [0x2000-0x200f]
[    0.214442] pci 0000:00:0f.2: reg 10 32bit mmio: [0xf5ef0000-0xf5ef0fff]
[    0.214971] pci_bus 0000:00: on NUMA node 0
[    0.214984] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.217852] ACPI: PCI Root Bridge [PCI1] (0000:01)
[    0.217988] pci 0000:01:03.0: reg 10 64bit mmio: [0xf7cc0000-0xf7cfffff]
[    0.217999] pci 0000:01:03.0: reg 18 io port: [0x3000-0x30ff]
[    0.218015] pci 0000:01:03.0: reg 1c 64bit mmio pref: [0xf7bf0000-0xf7bf3fff]
[    0.218031] pci 0000:01:03.0: reg 30 32bit mmio pref: [0x000000-0x003fff]
[    0.218097] pci 0000:01:03.0: supports D1
[    0.218166] pci_bus 0000:01: on NUMA node 0
[    0.218180] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    0.218891] ACPI: PCI Root Bridge [PCI2] (0000:02)
[    0.219010] pci 0000:02:01.0: reg 10 64bit mmio: [0xf7df0000-0xf7dfffff]
[    0.219042] pci 0000:02:01.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.219106] pci 0000:02:01.0: PME# supported from D3hot D3cold
[    0.219113] pci 0000:02:01.0: PME# disabled
[    0.219182] pci 0000:02:02.0: reg 10 64bit mmio: [0xf7de0000-0xf7deffff]
[    0.219213] pci 0000:02:02.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.219273] pci 0000:02:02.0: PME# supported from D3hot D3cold
[    0.219280] pci 0000:02:02.0: PME# disabled
[    0.219336] pci_bus 0000:02: on NUMA node 0
[    0.219345] ACPI: PCI Interrupt Routing Table [\_SB_.PCI2._PRT]
[    0.220200] ACPI: PCI Root Bridge [PCI3] (0000:03)
[    0.220319] pci 0000:03:01.0: reg 10 64bit mmio: [0xf7ef0000-0xf7ef1fff]
[    0.220331] pci 0000:03:01.0: reg 18 io port: [0x4000-0x40ff]
[    0.220346] pci 0000:03:01.0: reg 1c 64bit mmio: [0xf7e80000-0xf7ebffff]
[    0.220362] pci 0000:03:01.0: reg 30 32bit mmio pref: [0x000000-0x03ffff]
[    0.220415] pci 0000:03:01.0: supports D1
[    0.220470] pci_bus 0000:03: on NUMA node 0
[    0.220478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI3._PRT]
[    0.221193] ACPI: PCI Root Bridge [PCI4] (0000:06)
[    0.221297] pci 0000:06:01.0: reg 10 32bit mmio: [0xf7ff0000-0xf7ff01ff]
[    0.221377] pci 0000:06:02.0: reg 10 32bit mmio: [0xf7fe0000-0xf7fe01ff]
[    0.221517] pci 0000:06:1e.0: reg 10 32bit mmio: [0xf7fd0000-0xf7fd0fff]
[    0.221612] pci_bus 0000:06: on NUMA node 0
[    0.221621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI4._PRT]
[    0.222267] ACPI: PCI Interrupt Link [IUSB] (IRQs 4 5 *7 10 11 15)
[    0.222538] ACPI: PCI Interrupt Link [IN16] (IRQs 4 5 7 10 11 15) *3
[    0.222773] ACPI: PCI Interrupt Link [IN17] (IRQs 4 *5 7 10 11 15)
[    0.223010] ACPI: PCI Interrupt Link [IN18] (IRQs 4 5 7 10 11 *15)
[    0.223273] ACPI: PCI Interrupt Link [IN19] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.223506] ACPI: PCI Interrupt Link [IN20] (IRQs 4 5 7 *10 11 15)
[    0.223773] ACPI: PCI Interrupt Link [IN21] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.224051] ACPI: PCI Interrupt Link [IN22] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.224327] ACPI: PCI Interrupt Link [IN23] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.224561] ACPI: PCI Interrupt Link [IN24] (IRQs 4 5 7 10 *11 15)
[    0.224791] ACPI: PCI Interrupt Link [IN25] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.225063] ACPI: PCI Interrupt Link [IN26] (IRQs 4 5 *7 10 11 15)
[    0.225293] ACPI: PCI Interrupt Link [IN27] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.225561] ACPI: PCI Interrupt Link [IN28] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.225794] ACPI: PCI Interrupt Link [IN29] (IRQs 4 5 7 10 *11 15)
[    0.226064] ACPI: PCI Interrupt Link [IN30] (IRQs 4 5 7 *10 11 15)
[    0.226310] ACPI: PCI Interrupt Link [IN31] (IRQs 4 5 7 10 11 *15)
[    0.226587] ACPI: PCI Interrupt Link [IN32] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.226824] ACPI: PCI Interrupt Link [IN33] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.227056] ACPI: PCI Interrupt Link [IN34] (IRQs 4 5 7 10 11 15)
*0, disabled.
[    0.227414] vgaarb: device added:
PCI:0000:00:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.227457] vgaarb: loaded
[    0.227726] SCSI subsystem initialized
[    0.228044] libata version 3.00 loaded.
[    0.228243] usbcore: registered new interface driver usbfs
[    0.228272] usbcore: registered new interface driver hub
[    0.228337] usbcore: registered new device driver usb
[    0.228705] ACPI: WMI: Mapper loaded
[    0.228710] PCI: Using ACPI for IRQ routing
[    0.229328] NetLabel: Initializing
[    0.229333] NetLabel:  domain hash size = 128
[    0.229336] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.229364] NetLabel:  unlabeled traffic allowed by default
[    0.229498] Switching to clocksource tsc
[    0.232986] AppArmor: AppArmor Filesystem Enabled
[    0.233028] pnp: PnP ACPI init
[    0.233067] ACPI: bus type pnp registered
[    0.239818] pnp: PnP ACPI: found 13 devices
[    0.239835] ACPI: ACPI bus type pnp unregistered
[    0.239852] PnPBIOS: Disabled by ACPI PNP
[    0.239902] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    0.239909] system 00:01: ioport range 0x408-0x40f has been reserved
[    0.239915] system 00:01: ioport range 0x900-0x903 has been reserved
[    0.239923] system 00:01: ioport range 0x910-0x911 has been reserved
[    0.239929] system 00:01: ioport range 0x920-0x923 has been reserved
[    0.239935] system 00:01: ioport range 0x930-0x937 has been reserved
[    0.239942] system 00:01: ioport range 0x940-0x947 has been reserved
[    0.239949] system 00:01: ioport range 0x950-0x957 has been reserved
[    0.239955] system 00:01: ioport range 0xc06-0xc08 has been reserved
[    0.239962] system 00:01: ioport range 0xc14-0xc14 has been reserved
[    0.239968] system 00:01: ioport range 0xc49-0xc4a has been reserved
[    0.239975] system 00:01: ioport range 0xc50-0xc52 has been reserved
[    0.239981] system 00:01: ioport range 0xc6c-0xc6f has been reserved
[    0.239988] system 00:01: ioport range 0x230-0x233 has been reserved
[    0.239997] system 00:01: ioport range 0x260-0x267 has been reserved
[    0.240003] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.240010] system 00:01: ioport range 0x700-0x70f has been reserved
[    0.240017] system 00:01: ioport range 0x800-0x81f has been reserved
[    0.240024] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    0.240032] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    0.240040] system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
[    0.275064] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.275073] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.275080] pci_bus 0000:01: resource 0 io:  [0x00-0xffff]
[    0.275086] pci_bus 0000:01: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.275092] pci_bus 0000:02: resource 0 io:  [0x00-0xffff]
[    0.275098] pci_bus 0000:02: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.275104] pci_bus 0000:03: resource 0 io:  [0x00-0xffff]
[    0.275109] pci_bus 0000:03: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.275115] pci_bus 0000:06: resource 0 io:  [0x00-0xffff]
[    0.275121] pci_bus 0000:06: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.275211] NET: Registered protocol family 2
[    0.275506] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.276387] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.278115] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.279176] TCP: Hash tables configured (established 131072 bind 65536)
[    0.279189] TCP reno registered
[    0.279577] NET: Registered protocol family 1
[    0.279668] pci 0000:00:03.0: Boot video device
[    0.280226] ACPI: PCI Interrupt Link [IUSB] enabled at IRQ 11
[    0.280249] pci 0000:00:0f.2: PCI INT A -> Link[IUSB] -> GSI 11
(level, low) -> IRQ 11
[    0.294276] pci 0000:00:0f.2: PCI INT A disabled
[    0.294461] platform rtc_cmos: registered platform RTC device (no
PNP device found)
[    0.294634] cpufreq-nforce2: No nForce2 chipset.
[    0.294728] Scanning for low memory corruption every 60 seconds
[    0.295037] audit: initializing netlink socket (disabled)
[    0.295062] type=2000 audit(1335941183.294:1): initialized
[    0.308973] highmem bounce pool size: 64 pages
[    0.308987] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.312610] VFS: Disk quotas dquot_6.5.2
[    0.312790] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.314275] fuse init (API version 7.13)
[    0.314533] msgmni has been set to 1691
[    0.315199] alg: No test for stdrng (krng)
[    0.315390] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.315397] io scheduler noop registered
[    0.315401] io scheduler anticipatory registered
[    0.315406] io scheduler deadline registered
[    0.315491] io scheduler cfq registered (default)
[    0.315787] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.315852] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.316110] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.316119] ACPI: Power Button [PWRF]
[    0.316948] processor LNXCPU:06: registered as cooling_device0
[    0.317057] processor LNXCPU:07: registered as cooling_device1
[    0.320898] thermal LNXTHERM:01: registered as thermal_zone0
[    0.320922] ACPI: Thermal Zone [THM0] (8 C)
[    0.324717] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.324879] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.325539] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.328288] brd: module loaded
[    0.329537] loop: module loaded
[    0.329803] input: Macintosh mouse button emulation as
/devices/virtual/input/input1
[    0.330377] pata_acpi 0000:00:0f.1: setting latency timer to 64
[    0.330666] isapnp: Scanning for PnP cards...
[    0.331104] Fixed MDIO Bus: probed
[    0.331175] PPP generic driver version 2.4.2
[    0.331286] tun: Universal TUN/TAP device driver, 1.6
[    0.331290] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.331486] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.331527] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.331563] ohci_hcd 0000:00:0f.2: PCI INT A -> Link[IUSB] -> GSI
11 (level, low) -> IRQ 11
[    0.331597] ohci_hcd 0000:00:0f.2: OHCI Host Controller
[    0.331670] ohci_hcd 0000:00:0f.2: new USB bus registered, assigned
bus number 1
[    0.331716] ohci_hcd 0000:00:0f.2: irq 11, io mem 0xf5ef0000
[    0.388488] usb usb1: configuration #1 chosen from 1 choice
[    0.388550] hub 1-0:1.0: USB hub found
[    0.388573] hub 1-0:1.0: 4 ports detected
[    0.388701] uhci_hcd: USB Universal Host Controller Interface driver
[    0.388890] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at
0x60,0x64 irq 1,12
[    0.395148] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.395171] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.395492] mice: PS/2 mouse device common for all mice
[    0.395722] rtc_cmos rtc_cmos: RTC can wake from S4
[    0.395814] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.395852] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    0.396069] device-mapper: uevent: version 1.0.3
[    0.422558] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
initialised: dm-devel@redhat.com
[    0.436190] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    0.518331] device-mapper: multipath: version 1.1.0 loaded
[    0.518341] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.536764] Freeing initrd memory: 8531k freed
[    0.550161] EISA: Probing bus 0 at eisa.0
[    0.550189] EISA: Cannot allocate resource for mainboard
[    0.550196] Cannot allocate resource for EISA slot 1
[    0.550200] Cannot allocate resource for EISA slot 2
[    0.550205] Cannot allocate resource for EISA slot 3
[    0.550209] Cannot allocate resource for EISA slot 4
[    0.550237] EISA: Detected 0 cards.
[    0.550454] cpuidle: using governor ladder
[    0.550458] cpuidle: using governor menu
[    0.551327] TCP cubic registered
[    0.551589] NET: Registered protocol family 10
[    0.553306] NET: Registered protocol family 17
[    0.553419] Using IPI No-Shortcut mode
[    0.553642] PM: Resume from disk failed.
[    0.553666] registered taskstats version 1
[    0.554266]   Magic number: 12:13:771
[    0.554445] rtc_cmos rtc_cmos: setting system clock to 2012-05-02
06:46:24 UTC (1335941184)
[    0.554453] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.554456] EDD information not available.
[    0.641620] isapnp: No Plug & Play device found
[    0.641658] Freeing unused kernel memory: 680k freed
[    0.642901] Write protecting the kernel text: 4856k
[    0.643037] Write protecting the kernel read-only data: 1884k
[    0.683256] udev: starting version 151
[    0.914697] scsi0 : pata_serverworks
[    0.931720] scsi1 : pata_serverworks
[    0.931893] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2000 irq 14
[    0.931900] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2008 irq 15
[    0.932234] HP CISS Driver (v 3.6.20)
[    0.938952] tg3.c:v3.102 (September 1, 2009)
[    0.938983]   alloc irq_desc for 29 on node -1
[    0.938989]   alloc kstat_irqs on node -1
[    0.939005] tg3 0000:02:01.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
[    0.939297]   alloc irq_desc for 30 on node -1
[    0.939302]   alloc kstat_irqs on node -1
[    0.939314] cciss 0000:01:03.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
[    0.939749] Floppy drive(s): fd0 is 1.44M
[    0.978916] eth0: Tigon3 [partno(TBD) rev 1002]
(PCIX:100MHz:64-bit) MAC address 00:0d:9d:93:1d:df
[    0.978923] eth0: attached PHY is 5703 (10/100/1000Base-T Ethernet)
(WireSpeed[1])
[    0.978927] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.978931] eth0: dma_rwctrl[769c4000] dma_mask[64-bit]
[    0.978985]   alloc irq_desc for 31 on node -1
[    0.978989]   alloc kstat_irqs on node -1
[    0.979001] tg3 0000:02:02.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
[    0.982358] IRQ 30/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
[    0.982396] cciss0: <0xb178> at PCI 0000:01:03.0 IRQ 30 using DAC
[    0.985474]   alloc irq_desc for 20 on node -1
[    0.985484]   alloc kstat_irqs on node -1
[    0.985503] cciss 0000:03:01.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.026025] eth1: Tigon3 [partno(TBD) rev 1002]
(PCIX:100MHz:64-bit) MAC address 00:0d:9d:93:1d:de
[    1.026031] eth1: attached PHY is 5703 (10/100/1000Base-T Ethernet)
(WireSpeed[1])
[    1.026035] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.026038] eth1: dma_rwctrl[769c4000] dma_mask[64-bit]
[    1.070228] IRQ 20/cciss1: IRQF_DISABLED is not guaranteed on shared IRQs
[    1.070264] cciss1: <0x46> at PCI 0000:03:01.0 IRQ 20 using DAC
[    1.073015]  cciss/c1d0: p1 p2 < p5 >
[    1.208446] ata1.00: ATAPI: COMPAQ  CD-ROM SN-124, N104, max PIO4
[    1.224549] ata1.00: configured for PIO4
[    1.225478] scsi 0:0:0:0: CD-ROM            COMPAQ   CD-ROM SN-124
  N104 PQ: 0 ANSI: 5
[    1.232186] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    1.232198] Uniform CD-ROM driver Revision: 3.20
[    1.233482] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.234071] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.417720] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[    3.414565] Adding 1499128k swap on /dev/mapper/pixie-swap_1.
Priority:-1 extents:1 across:1499128k
[    3.419741] udev: starting version 151
[    3.626031] Linux agpgart interface v0.103
[    3.677407]   alloc irq_desc for 17 on node -1
[    3.677414]   alloc kstat_irqs on node -1
[    3.677428] hpilo 0000:00:04.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.678452] piix4_smbus 0000:00:0f.0: SMBus Host Controller at
0x700, revision 0
[    3.686640] vga16fb: initializing
[    3.686651] vga16fb: mapped to 0xc00a0000
[    3.686798] fb0: VGA16 VGA frame buffer device
[    3.691598] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.691709]   alloc irq_desc for 18 on node -1
[    3.691716]   alloc kstat_irqs on node -1
[    3.691731] compaq_pci_hotplug 0000:06:1e.0: PCI INT A -> GSI 18
(level, low) -> IRQ 18
[    3.691745] cpqphp: Hot Plug Subsystem Device ID: a2fe
[    3.691752] cpqphp: Initializing the PCI hot plug controller
residing on PCI bus 6
[    3.691771] PCI: Using BIOS Interrupt Routing Table
[    3.712650] WARNING: You are using an experimental version of the
media stack.
[    3.712654]  As the driver is backported to an older kernel, it doesn't offer
[    3.712657]  enough quality for its usage in production.
[    3.712659]  Use it with care.
[    3.712660] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    3.712666]  bcb2cf6e0bf033d79821c89e5ccb328bfbd44907 [media]
ngene: remove an unneeded condition
[    3.712669]  2e71064f2f9009c6ef672abc4f9160d16a3d50bd [media]
saa7164: saa7164_vbi_stop_port() returns linux error codes
[    3.712672]  b72d66770953c2177d70a7a5d24521a447d2b443 [media] V4L:
fix a compiler warning
[    3.731133] lp: driver loaded but no devices found
[    3.861747] WARNING: You are using an experimental version of the
media stack.
[    3.861755]  As the driver is backported to an older kernel, it doesn't offer
[    3.861758]  enough quality for its usage in production.
[    3.861761]  Use it with care.
[    3.861762] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    3.861765]  bcb2cf6e0bf033d79821c89e5ccb328bfbd44907 [media]
ngene: remove an unneeded condition
[    3.861768]  2e71064f2f9009c6ef672abc4f9160d16a3d50bd [media]
saa7164: saa7164_vbi_stop_port() returns linux error codes
[    3.861771]  b72d66770953c2177d70a7a5d24521a447d2b443 [media] V4L:
fix a compiler warning
[    3.932748] saa7146: register extension 'budget_ci dvb'
[    3.956363] floppy0: no floppy controllers found
[    4.002219] psmouse serio1: ID: 10 00 64
[    4.015008] type=1505 audit(1335941187.957:2):
operation="profile_load" pid=469 name="/sbin/dhclient3"
[    4.015767] type=1505 audit(1335941187.957:3):
operation="profile_load" pid=469
name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[    4.019689] type=1505 audit(1335941187.961:4):
operation="profile_load" pid=469
name="/usr/lib/connman/scripts/dhclient-script"
[    4.067736] Floppy drive(s): fd0 is 1.44M
[    4.279555] Console: switching to colour frame buffer device 80x30
[    4.347096] tg3 0000:02:01.0: firmware: requesting tigon/tg3_tso.bin
[    4.461089] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.575641] type=1505 audit(1335941188.517:5):
operation="profile_load" pid=604 name="/usr/sbin/tcpdump"
[    4.578311] type=1505 audit(1335941188.521:6):
operation="profile_replace" pid=603 name="/sbin/dhclient3"
[    4.579056] type=1505 audit(1335941188.521:7):
operation="profile_replace" pid=603
name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[    4.579498] type=1505 audit(1335941188.521:8):
operation="profile_replace" pid=603
name="/usr/lib/connman/scripts/dhclient-script"
[    4.612544] input: PS/2 Logitech Mouse as
/devices/platform/i8042/serio1/input/input3
[    4.844354]   alloc irq_desc for 24 on node -1
[    4.844363]   alloc kstat_irqs on node -1
[    4.844379] budget_ci dvb 0000:06:01.0: PCI INT A -> GSI 24 (level,
low) -> IRQ 24
[    4.844470] IRQ 24/: IRQF_DISABLED is not guaranteed on shared IRQs
[    4.844537] saa7146: found saa7146 @ mem f88e6000 (revision 1, irq
24) (0x13c2,0x1019)
[    4.844547] saa7146 (0): dma buffer size 192512
[    4.844552] DVB: registering new adapter (TT-Budget S2-3200 PCI)
[    4.881271] adapter has MAC addr = 00:d0:5c:67:bd:c4
[    4.924026] Registered IR keymap rc-tt-1500
[    4.924244] input: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:06/0000:06:01.0/rc/rc0/input4
[    4.924395] rc0: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:06/0000:06:01.0/rc/rc0
[    5.257422] stb0899_attach: Attaching STB0899
[    5.268343] stb6100_attach: Attaching STB6100
[    5.279784] LNBx2x attached on addr=8
[    5.279797] DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
[    5.280086]   alloc irq_desc for 26 on node -1
[    5.280093]   alloc kstat_irqs on node -1
[    5.280107] budget_ci dvb 0000:06:02.0: PCI INT A -> GSI 26 (level,
low) -> IRQ 26
[    5.280203] IRQ 26/: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.280280] saa7146: found saa7146 @ mem f8a8a000 (revision 1, irq
26) (0x13c2,0x1019)
[    5.280290] saa7146 (1): dma buffer size 192512
[    5.280296] DVB: registering new adapter (TT-Budget S2-3200 PCI)
[    5.317105] adapter has MAC addr = 00:d0:5c:0b:1a:2f
[    5.318610] Registered IR keymap rc-tt-1500
[    5.319785] input: Budget-CI dvb ir receiver saa7146 (1) as
/devices/pci0000:06/0000:06:02.0/rc/rc1/input5
[    5.320170] rc1: Budget-CI dvb ir receiver saa7146 (1) as
/devices/pci0000:06/0000:06:02.0/rc/rc1
[    5.637261] stb0899_attach: Attaching STB0899
[    5.637395] stb6100_attach: Attaching STB6100
[    5.637613] LNBx2x attached on addr=8
[    5.637620] DVB: registering adapter 1 frontend 0 (STB0899 Multistandard)...
[    7.080041] floppy0: no floppy controllers found
[    7.578461] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[    7.578466] tg3: eth0: Flow control is on for TX and on for RX.
[    7.578880] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.268011] eth0: no IPv6 routers present
[  232.430774] Uhhuh. NMI received for unknown reason b1 on CPU 0.
[  232.431096] You have some hardware problem, likely on the PCI bus.
[  232.431415] Dazed and confused, but trying to continue
[  232.434228] cpqphp: power fault interrupt
[  232.434232] cpqphp: power fault bit 0 set
[  232.444021] saa7146 (0) saa7146_i2c_writeout [irq]: timed out
waiting for end of xfer
[  234.744035] divide error: 0000 [#1] SMP
[  234.747436] last sysfs file:
/sys/devices/system/cpu/cpu1/topology/core_siblings
[  234.748002] Modules linked in: lnbp21 stb6100 stb0899 rc_tt_1500
fbcon tileblit font bitblit softcursor scb2_flash budget_ci mtd
chipreg budget_core map_funcs psmouse dvb_core saa7146 ttpci_eeprom
rc_core cpqphp serio_raw vga16fb vgastate i2c_piix4 hpilo sworks_agp
lp parport agpgart tg3 cciss pata_serverworks
[  234.748002]
[  234.748002] Pid: 1014, comm: kdvb-ad-0-fe-0 Not tainted
(2.6.32-41-generic-pae #88-Ubuntu) ProLiant DL380 G3
[  234.748002] EIP: 0060:[<f8a6a103>] EFLAGS: 00010246 CPU: 1
[  234.748002] EIP is at stb0899_dvbs_algo+0xa3/0x1264 [stb0899]
[  234.748002] EAX: 00003473 EBX: f6dc8000 ECX: bc000000 EDX: 00000000
[  234.748002] ESI: 00003473 EDI: 00003473 EBP: f6219f30 ESP: f6219e78
[  234.748002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  234.748002] Process kdvb-ad-0-fe-0 (pid: 1014, ti=f6218000
task=f6d2f2c0 task.ti=f6218000)
[  234.748002] Stack:
[  234.748002]  00000003 00000001 00000001 f5c9c200 f6e61000 00000003
00000000 f6219ea4
[  234.748002] <0> f8746258 f8806e20 00000000 f6219ec8 c049c3e4
00000000 bc000000 00003473
[  234.748002] <0> 00000025 00000022 00000020 0000001f 00000025
00000023 00000021 0000001f
[  234.748002] Call Trace:
[  234.748002]  [<c049c3e4>] ? i2c_transfer+0x94/0xc0
[  234.748002]  [<f8803060>] ? stb6100_set_bandwidth+0x0/0x50 [budget_ci]
[  234.748002]  [<f8803060>] ? stb6100_set_bandwidth+0x0/0x50 [budget_ci]
[  234.748002]  [<f8a68030>] ? stb0899_search+0x410/0x6c0 [stb0899]
[  234.748002]  [<f8777103>] ? dvb_frontend_thread+0x503/0x660 [dvb_core]
[  234.748002]  [<c05b5d5b>] ? schedule+0x46b/0x870
[  234.748002]  [<c0170da0>] ? autoremove_wake_function+0x0/0x50
[  234.748002]  [<f8776c00>] ? dvb_frontend_thread+0x0/0x660 [dvb_core]
[  234.748002]  [<c0170b14>] ? kthread+0x74/0x80
[  234.748002]  [<c0170aa0>] ? kthread+0x0/0x80
[  234.748002]  [<c010a467>] ? kernel_thread_helper+0x7/0x10
[  234.748002] Code: ff 8b 7d 84 0f a4 f7 15 c1 e6 15 89 75 80 01 55
80 8b 45 80 89 7d 84 11 4d 84 8b 55 84 89 d6 31 d2 85 f6 89 c1 74 0c
89 f0 31 d2 <f7> b5 7c ff ff ff 89 c6 89 c8 f7 b5 7c ff ff ff 89 f2 89
c1 c1
[  234.748002] EIP: [<f8a6a103>] stb0899_dvbs_algo+0xa3/0x1264
[stb0899] SS:ESP 0068:f6219e78
[  235.149070] ---[ end trace 5ffa16826bc96d69 ]---


-- Alexey Savartsov
