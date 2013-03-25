Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab3CYTYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 15:24:20 -0400
From: Sebastian Frei <sebastian@familie-frei.net>
To: linux-media@vger.kernel.org
Subject: BUG: Null pointer dereference when loading cx88_dvb
Date: Mon, 25 Mar 2013 20:24:24 +0100
Message-ID: <1878410.e3hmu5fkNR@nop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello *,

I get a null pointer dereference when loading the cx88_dvb module (kernel 
3.9.0-rc4, but using an older kernel makes no difference).
If I blacklist the cx8800 module, everything works fine.
I have a Hauppauge HVR4000 card with multiple tuners (DVB-T, DVB-S, DVB-S2, 
analog). I'm using only the DVB-S and DVB-S2 tuners, so I don't need the 
cx8800 module.

Below is the output of dmesg and lspci.

Best regards
Sebastian

dmesg:
[    0.000000] Linux version 3.9.0-rc4 (root@VDR-SF) (gcc version 4.7.2 (GCC) 
) #29 SMP PREEMPT Mon Mar 25 19:43:35 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda1 rw 
rootfstype=ext4 modprobe.blacklist=mceusb quiet 
usbhid.quirks=0x0471:0x0613:0x4
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e3000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005ff8ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000005ff90000-0x000000005ff9dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000005ff9e000-0x000000005ffdffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000005ffe0000-0x000000005ffedfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000005fff0000-0x000000005fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000feefffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x5ff90 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02731000, 0x02731fff] PGTABLE
[    0.000000] BRK [0x02732000, 0x02732fff] PGTABLE
[    0.000000] BRK [0x02733000, 0x02733fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x5fc00000-0x5fdfffff]
[    0.000000]  [mem 0x5fc00000-0x5fdfffff] page 2M
[    0.000000] BRK [0x02734000, 0x02734fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x5c000000-0x5fbfffff]
[    0.000000]  [mem 0x5c000000-0x5fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x5bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x5bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x5fe00000-0x5ff8ffff]
[    0.000000]  [mem 0x5fe00000-0x5ff8ffff] page 4k
[    0.000000] BRK [0x02735000, 0x02735fff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000fb770 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 000000005ff90100 0006C (v01 091010 XSDT1510 20100910 
MSFT 00000097)
[    0.000000] ACPI: FACP 000000005ff90290 000F4 (v03 091010 FACP1510 20100910 
MSFT 00000097)
[    0.000000] ACPI: DSDT 000000005ff90460 0AAF1 (v01  A1043 A1043000 00000000 
INTL 20060113)
[    0.000000] ACPI: FACS 000000005ff9e000 00040
[    0.000000] ACPI: APIC 000000005ff90390 00090 (v01 091010 APIC1510 20100910 
MSFT 00000097)
[    0.000000] ACPI: MCFG 000000005ff90420 0003C (v01 091010 OEMMCFG  20100910 
MSFT 00000097)
[    0.000000] ACPI: OEMB 000000005ff9e040 00072 (v01 091010 OEMB1510 20100910 
MSFT 00000097)
[    0.000000] ACPI: SRAT 000000005ff9af60 000A0 (v01 AMD    FAM_F_10 00000002 
AMD  00000001)
[    0.000000] ACPI: HPET 000000005ff9b000 00038 (v01 091010 OEMHPET0 20100910 
MSFT 00000097)
[    0.000000] ACPI: INFO 000000005ff9e0c0 00124 (v01 091010 AMDINFO  20100910 
MSFT 00000097)
[    0.000000] ACPI: NVHD 000000005ff9e1f0 00284 (v01 091010  NVHDCP  20100910 
MSFT 00000097)
[    0.000000] ACPI: SSDT 000000005ff9b040 0030E (v01 A M I  POWERNOW 00000001 
AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00017fffff] PMD -> [ffff88005de00000-
ffff88005f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x5ff8ffff]
[    0.000000] On node 0 totalpages: 393004
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6079 pages used for memmap
[    0.000000]   DMA32 zone: 389008 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] smpboot: 6 Processors exceeds NR_CPUS limit of 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x60000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88005fc00000 s73088 r8192 
d21120 u1048576
[    0.000000] pcpu-alloc: s73088 r8192 d21120 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 386840
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda1 rw 
rootfstype=ext4 modprobe.blacklist=mceusb quiet 
usbhid.quirks=0x0471:0x0613:0x4
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 1536596k/1572416k available (3553k kernel code, 400k 
absent, 35420k reserved, 2842k data, 592k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, 
Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.979 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.003336] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6002.95 BogoMIPS (lpj=9999930)
[    0.003338] pid_max: default: 32768 minimum: 301
[    0.003366] Mount-cache hash table entries: 256
[    0.003535] tseg: 0000000000
[    0.003540] CPU: Physical Processor ID: 0
[    0.003541] CPU: Processor Core ID: 0
[    0.003543] mce: CPU supports 5 MCE banks
[    0.003549] LVT offset 0 assigned for vector 0xf9
[    0.003552] process: using AMD E400 aware idle routine
[    0.003554] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
tlb_flushall_shift: 4
[    0.003595] Freeing SMP alternatives: 16k freed
[    0.003606] ACPI: Core revision 20130117
[    0.006974] ACPI: All ACPI Tables successfully acquired
[    0.008092] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041101] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ 
(fam: 0f, model: 43, stepping: 03)
[    0.043333] Performance Events: AMD PMU driver.
[    0.043333] ... version:                0
[    0.043333] ... bit width:              48
[    0.043333] ... generic registers:      4
[    0.043333] ... value mask:             0000ffffffffffff
[    0.043333] ... max period:             00007fffffffffff
[    0.043333] ... fixed-purpose events:   0
[    0.043333] ... event mask:             000000000000000f
[    0.043333] process: System has AMD C1E enabled
[    0.043333] process: Switch to broadcast mode on CPU0
[    0.053468] smpboot: Booting Node   0, Processors  #1 OK
[    0.006666] process: Switch to broadcast mode on CPU1
[    0.146737] Brought up 2 CPUs
[    0.146739] smpboot: Total of 2 processors activated (12004.08 BogoMIPS)
[    0.147299] devtmpfs: initialized
[    0.147299] NET: Registered protocol family 16
[    0.147299] node 0 link 0: io port [1000, ffffff]
[    0.147299] node 0 link 0: io port [1000, 1fff]
[    0.147299] TOM: 0000000080000000 aka 2048M
[    0.147299] node 0 link 0: mmio [e0000000, efffffff]
[    0.147299] node 0 link 0: mmio [a0000, bffff]
[    0.147299] node 0 link 0: mmio [80000000, fe0bffff]
[    0.147299] bus: [bus 00-07] on node 0 link 0
[    0.147299] bus: 00 [io  0x0000-0xffff]
[    0.147299] bus: 00 [mem 0x80000000-0xfcffffffff]
[    0.147299] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.147299] ACPI: bus type PCI registered
[    0.147299] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.147299] PCI: not using MMCONFIG
[    0.147299] PCI: Using configuration type 1 for base access
[    0.147334] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.147335] mtrr: probably your BIOS does not setup all CPUs.
[    0.147336] mtrr: corrected configuration.
[    0.147689] bio: create slab <bio-0> at 0
[    0.147689] ACPI: Added _OSI(Module Device)
[    0.147689] ACPI: Added _OSI(Processor Device)
[    0.147689] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.147689] ACPI: Added _OSI(Processor Aggregator Device)
[    0.147690] ACPI: EC: Look up EC in DSDT
[    0.150832] ACPI: Executed 1 blocks of module-level executable AML code
[    0.153761] ACPI: Interpreter enabled
[    0.153765] ACPI: (supports S0 S5)
[    0.153767] ACPI: Using IOAPIC for interrupt routing
[    0.153781] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.154724] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI 
motherboard resources
[    0.162203] PCI: Using host bridge windows from ACPI; if necessary, use 
"pci=nocrs" and report a bug
[    0.169308] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.169464] acpi PNP0A03:00: Requesting ACPI _OSC control (0x15)
[    0.169595] acpi PNP0A03:00: ACPI _OSC request failed (AE_SUPPORT), 
returned control mask: 0x04
[    0.169729] PCI host bridge to bus 0000:00
[    0.169732] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.169734] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.169736] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.169738] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.169740] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.169742] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff]
[    0.169744] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.169780] pci 0000:00:00.0: [10de:0754] type 00 class 0x050000
[    0.170091] pci 0000:00:01.0: [10de:075c] type 00 class 0x060100
[    0.170098] pci 0000:00:01.0: reg 10: [io  0x0900-0x09ff]
[    0.170150] pci 0000:00:01.1: [10de:0752] type 00 class 0x0c0500
[    0.170160] pci 0000:00:01.1: reg 10: [io  0x0e00-0x0e3f]
[    0.170175] pci 0000:00:01.1: reg 20: [io  0x0600-0x063f]
[    0.170181] pci 0000:00:01.1: reg 24: [io  0x0700-0x073f]
[    0.170210] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.170243] pci 0000:00:01.2: [10de:0751] type 00 class 0x050000
[    0.170326] pci 0000:00:01.3: [10de:0753] type 00 class 0x0b4000
[    0.170343] pci 0000:00:01.3: reg 10: [mem 0xf8e80000-0xf8efffff]
[    0.170490] pci 0000:00:01.4: [10de:0568] type 00 class 0x050000
[    0.170577] pci 0000:00:02.0: [10de:077b] type 00 class 0x0c0310
[    0.170586] pci 0000:00:02.0: reg 10: [mem 0xf8e7e000-0xf8e7efff]
[    0.170620] pci 0000:00:02.0: supports D1 D2
[    0.170621] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170655] pci 0000:00:02.1: [10de:077c] type 00 class 0x0c0320
[    0.170665] pci 0000:00:02.1: reg 10: [mem 0xf8e7fc00-0xf8e7fcff]
[    0.170706] pci 0000:00:02.1: supports D1 D2
[    0.170708] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170749] pci 0000:00:04.0: [10de:077d] type 00 class 0x0c0310
[    0.170758] pci 0000:00:04.0: reg 10: [mem 0xf8e7d000-0xf8e7dfff]
[    0.170791] pci 0000:00:04.0: supports D1 D2
[    0.170793] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170827] pci 0000:00:04.1: [10de:077e] type 00 class 0x0c0320
[    0.170837] pci 0000:00:04.1: reg 10: [mem 0xf8e7f800-0xf8e7f8ff]
[    0.170878] pci 0000:00:04.1: supports D1 D2
[    0.170879] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170921] pci 0000:00:06.0: [10de:0759] type 00 class 0x01018a
[    0.170942] pci 0000:00:06.0: reg 20: [io  0xffa0-0xffaf]
[    0.171012] pci 0000:00:07.0: [10de:0774] type 00 class 0x040300
[    0.171023] pci 0000:00:07.0: reg 10: [mem 0xf8e78000-0xf8e7bfff]
[    0.171064] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.171104] pci 0000:00:08.0: [10de:075a] type 01 class 0x060401
[    0.171170] pci 0000:00:09.0: [10de:0ad4] type 00 class 0x010601
[    0.171178] pci 0000:00:09.0: reg 10: [io  0xd480-0xd487]
[    0.171183] pci 0000:00:09.0: reg 14: [io  0xd400-0xd403]
[    0.171187] pci 0000:00:09.0: reg 18: [io  0xd080-0xd087]
[    0.171191] pci 0000:00:09.0: reg 1c: [io  0xd000-0xd003]
[    0.171195] pci 0000:00:09.0: reg 20: [io  0xcc00-0xcc0f]
[    0.171199] pci 0000:00:09.0: reg 24: [mem 0xf8e76000-0xf8e77fff]
[    0.171255] pci 0000:00:0a.0: [10de:0760] type 00 class 0x020000
[    0.171265] pci 0000:00:0a.0: reg 10: [mem 0xf8e7c000-0xf8e7cfff]
[    0.171269] pci 0000:00:0a.0: reg 14: [io  0xc880-0xc887]
[    0.171273] pci 0000:00:0a.0: reg 18: [mem 0xf8e7f400-0xf8e7f4ff]
[    0.171277] pci 0000:00:0a.0: reg 1c: [mem 0xf8e7f000-0xf8e7f00f]
[    0.171307] pci 0000:00:0a.0: supports D1 D2
[    0.171309] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171346] pci 0000:00:0b.0: [10de:0569] type 01 class 0x060400
[    0.171370] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171453] pci 0000:00:10.0: [10de:0778] type 01 class 0x060400
[    0.171677] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171799] pci 0000:00:12.0: [10de:075b] type 01 class 0x060400
[    0.172021] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.172104] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.172147] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.172196] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.172238] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.172325] pci 0000:01:06.0: [14f1:8800] type 00 class 0x040000
[    0.172339] pci 0000:01:06.0: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.172423] pci 0000:01:06.1: [14f1:8811] type 00 class 0x048000
[    0.172435] pci 0000:01:06.1: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.172509] pci 0000:01:06.2: [14f1:8802] type 00 class 0x048000
[    0.172520] pci 0000:01:06.2: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.172595] pci 0000:01:06.4: [14f1:8804] type 00 class 0x048000
[    0.172607] pci 0000:01:06.4: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.172682] pci 0000:01:07.0: [1131:7146] type 00 class 0x048000
[    0.172692] pci 0000:01:07.0: reg 10: [mem 0xf8fffc00-0xf8fffdff]
[    0.172766] pci 0000:00:08.0: PCI bridge to [bus 01] (subtractive decode)
[    0.172770] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.172773] pci 0000:00:08.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.172775] pci 0000:00:08.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.172777] pci 0000:00:08.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.172779] pci 0000:00:08.0:   bridge window [mem 0x000d0000-0x000dffff] 
(subtractive decode)
[    0.172781] pci 0000:00:08.0:   bridge window [mem 0x80000000-0xdfffffff] 
(subtractive decode)
[    0.172783] pci 0000:00:08.0:   bridge window [mem 0xf0000000-0xfebfffff] 
(subtractive decode)
[    0.172812] pci 0000:02:00.0: [10de:0848] type 00 class 0x030000
[    0.172819] pci 0000:02:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.172825] pci 0000:02:00.0: reg 14: [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.172831] pci 0000:02:00.0: reg 1c: [mem 0xd6000000-0xd7ffffff 64bit pref]
[    0.172835] pci 0000:02:00.0: reg 24: [io  0xec00-0xec7f]
[    0.172839] pci 0000:02:00.0: reg 30: [mem 0xfeae0000-0xfeafffff pref]
[    0.172884] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.172888] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.172890] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.172893] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit 
pref]
[    0.173052] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.173245] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.173302] pci_bus 0000:00: on NUMA node 0
[    0.173303] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.174082] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.174163] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *11
[    0.174242] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174320] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174400] ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *10
[    0.174477] ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174555] ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174634] ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174712] ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174791] ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174869] ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174947] ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175027] ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *11
[    0.175105] ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175183] ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175261] ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175341] ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *15
[    0.175419] ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175497] ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175575] ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175653] ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175732] ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175811] ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175889] ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175967] ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176046] ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176125] ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176203] ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176281] ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176360] ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176438] ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176516] ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176595] ACPI: PCI Interrupt Link [LN7A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176679] ACPI: PCI Interrupt Link [LN7B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176757] ACPI: PCI Interrupt Link [LN7C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176835] ACPI: PCI Interrupt Link [LN7D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176915] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    0.176994] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *15
[    0.177073] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
[    0.177152] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *15
[    0.177230] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *0, 
disabled.
[    0.177310] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.177389] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *10
[    0.177468] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.177554] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.177634] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *11
[    0.177714] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *10
[    0.177777] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.177880] acpi root: \_SB_.PCI0 notify handler is installed
[    0.177919] Found 1 acpi root devices
[    0.177999] SCSI subsystem initialized
[    0.178001] ACPI: bus type ATA registered
[    0.178020] libata version 3.00 loaded.
[    0.178020] ACPI: bus type USB registered
[    0.178020] usbcore: registered new interface driver usbfs
[    0.178020] usbcore: registered new interface driver hub
[    0.178020] usbcore: registered new device driver usb
[    0.178020] Advanced Linux Sound Architecture Driver Initialized.
[    0.178020] PCI: Using ACPI for IRQ routing
[    0.184444] PCI: pci_cache_line_size set to 64 bytes
[    0.184496] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.184498] e820: reserve RAM buffer [mem 0x5ff90000-0x5fffffff]
[    0.184606] HPET: 3 timers in total, 0 timers will be used for per-cpu 
timer
[    0.184611] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.184614] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.200019] Switching to clocksource hpet
[    0.200066] pnp: PnP ACPI init
[    0.200072] ACPI: bus type PNP registered
[    0.200102] pnp 00:00: [dma 4]
[    0.200118] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.200138] pnp 00:01: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.200165] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.200780] pnp 00:03: [dma 3]
[    0.200944] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.201195] pnp 00:04: disabling [io  0x0900-0x097f] because it overlaps 
0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201198] pnp 00:04: disabling [io  0x0980-0x09ff] because it overlaps 
0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201246] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.201248] system 00:04: [io  0x0800-0x080f] has been reserved
[    0.201250] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.201253] system 00:04: [io  0x0580-0x05ff] has been reserved
[    0.201255] system 00:04: [io  0x0800-0x087f] could not be reserved
[    0.201257] system 00:04: [io  0x0880-0x08ff] has been reserved
[    0.201260] system 00:04: [io  0x0d00-0x0d7f] has been reserved
[    0.201262] system 00:04: [io  0x0d80-0x0dff] has been reserved
[    0.201266] system 00:04: [mem 0x000d0000-0x000d3fff window] has been 
reserved
[    0.201268] system 00:04: [mem 0x000d4000-0x000d7fff window] has been 
reserved
[    0.201270] system 00:04: [mem 0x000de000-0x000dffff window] has been 
reserved
[    0.201273] system 00:04: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.201275] system 00:04: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.201278] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201372] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.201399] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.201490] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.201493] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.201495] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201657] system 00:08: [io  0x0230-0x023f] has been reserved
[    0.201659] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.201662] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.201664] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.201667] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201868] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.201871] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.202016] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.202019] system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.202021] system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.202023] system 00:0a: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.202026] system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.202028] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.202516] pnp: PnP ACPI: found 11 devices
[    0.202517] ACPI: bus type PNP unregistered
[    0.208954] pci 0000:00:08.0: PCI bridge to [bus 01]
[    0.208958] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.208963] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.208966] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.208968] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.208971] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit 
pref]
[    0.208974] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.208999] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.209028] pci 0000:00:08.0: setting latency timer to 64
[    0.209032] pci 0000:00:0b.0: setting latency timer to 64
[    0.209217] ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
[    0.209394] ACPI: PCI Interrupt Link [LN2A] enabled at IRQ 18
[    0.209406] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.209408] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.209410] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209412] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209414] pci_bus 0000:00: resource 8 [mem 0x80000000-0xdfffffff]
[    0.209416] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.209418] pci_bus 0000:01: resource 1 [mem 0xf8f00000-0xfcffffff]
[    0.209420] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.209422] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.209424] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209426] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209428] pci_bus 0000:01: resource 8 [mem 0x80000000-0xdfffffff]
[    0.209430] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.209432] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.209434] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfeafffff]
[    0.209436] pci_bus 0000:02: resource 2 [mem 0xd6000000-0xdfffffff 64bit pref]
[    0.209463] NET: Registered protocol family 2
[    0.209560] TCP established hash table entries: 16384 (order: 6, 262144 
bytes)
[    0.209674] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.209792] TCP: Hash tables configured (established 16384 bind 16384)
[    0.209858] TCP: reno registered
[    0.209861] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209878] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209928] NET: Registered protocol family 1
[    0.210206] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    0.210452] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    0.210686] ACPI: PCI Interrupt Link [UB11] enabled at IRQ 21
[    0.210916] ACPI: PCI Interrupt Link [UB12] enabled at IRQ 20
[    0.211080] pci 0000:00:07.0: Enabling HT MSI Mapping
[    0.211175] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.211275] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.211381] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.211485] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.211615] pci 0000:02:00.0: Boot video device
[    0.211617] PCI: CLS 64 bytes, default 64
[    0.212995] fuse init (API version 7.21)
[    0.213070] msgmni has been set to 3001
[    0.213287] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.213289] io scheduler noop registered
[    0.213290] io scheduler deadline registered (default)
[    0.213633] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.213636] ACPI: Power Button [PWRB]
[    0.213678] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.213680] ACPI: Power Button [PWRF]
[    0.213708] ACPI: processor limited to max C-state 1
[    0.216626] ppdev: user-space parallel port driver
[    0.216640] [drm] Initialized drm 1.1.0 20060810
[    0.216678] parport_pc 00:03: reported by Plug and Play ACPI
[    0.216748] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    0.296889] ahci 0000:00:09.0: version 3.0
[    0.297076] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.297117] ahci 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.297126] ahci 0000:00:09.0: controller can't do PMP, turning off CAP_PMP
[    0.297187] ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode
[    0.297190] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pio boh 
[    0.297193] ahci 0000:00:09.0: setting latency timer to 64
[    0.297870] scsi0 : ahci
[    0.297957] scsi1 : ahci
[    0.298023] scsi2 : ahci
[    0.298085] scsi3 : ahci
[    0.298146] scsi4 : ahci
[    0.298206] scsi5 : ahci
[    0.298237] ata1: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76100 
irq 40
[    0.298239] ata2: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76180 
irq 40
[    0.298240] ata3: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76200 
irq 40
[    0.298242] ata4: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76280 
irq 40
[    0.298244] ata5: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76300 
irq 40
[    0.298245] ata6: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76380 
irq 40
[    0.298306] pata_amd 0000:00:06.0: version 0.4.1
[    0.298340] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.298533] scsi6 : pata_amd
[    0.298763] scsi7 : pata_amd
[    0.298922] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.298924] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.298956] forcedeth: Reverse Engineered nForce ethernet driver. Version 
0.64.
[    0.299156] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
[    0.299163] forcedeth 0000:00:0a.0: setting latency timer to 64
[    0.357641] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 3, addr 
00:26:18:77:ed:11
[    0.357644] forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt gbit lnktim 
msi desc-v3
[    0.357657] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.357658] ehci-pci: EHCI PCI platform driver
[    0.357735] ehci-pci 0000:00:02.1: setting latency timer to 64
[    0.357737] ehci-pci 0000:00:02.1: EHCI Host Controller
[    0.357744] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[    0.357752] ehci-pci 0000:00:02.1: debug port 1
[    0.357769] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    0.357790] ehci-pci 0000:00:02.1: irq 22, io mem 0xf8e7fc00
[    0.366692] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.366808] hub 1-0:1.0: USB hub found
[    0.366812] hub 1-0:1.0: 6 ports detected
[    0.366946] ehci-pci 0000:00:04.1: setting latency timer to 64
[    0.366948] ehci-pci 0000:00:04.1: EHCI Host Controller
[    0.366952] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus 
number 2
[    0.366959] ehci-pci 0000:00:04.1: debug port 1
[    0.366975] ehci-pci 0000:00:04.1: cache line size of 64 is not supported
[    0.366991] ehci-pci 0000:00:04.1: irq 20, io mem 0xf8e7f800
[    0.376691] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.376769] hub 2-0:1.0: USB hub found
[    0.376772] hub 2-0:1.0: 6 ports detected
[    0.376839] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.376908] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.376910] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.376914] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 3
[    0.376934] ohci_hcd 0000:00:02.0: irq 23, io mem 0xf8e7e000
[    0.432099] hub 3-0:1.0: USB hub found
[    0.432103] hub 3-0:1.0: 6 ports detected
[    0.432227] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.432229] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.432234] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus 
number 4
[    0.432255] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf8e7d000
[    0.450177] ata7.01: NODEV after polling detection
[    0.457384] ata7.00: ATAPI: BENQ    DVD DD DW1620, B7W9, max UDMA/33
[    0.457389] ata7: nv_mode_filter: 0x739f&0xfffff->0x739f, BIOS=0x0 (0x0) 
ACPI=0x0 (900:900:0x10)
[    0.470485] ata7.00: configured for UDMA/33
[    0.485436] hub 4-0:1.0: USB hub found
[    0.485440] hub 4-0:1.0: 6 ports detected
[    0.485530] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.485940] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.485944] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.486029] rtc_cmos 00:06: RTC can wake from S4
[    0.486263] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.486317] rtc_cmos 00:06: alarms up to one year, y3k, 114 bytes nvram, 
hpet irqs
[    0.486444] k8temp 0000:00:18.3: Temperature readouts might be wrong - 
check erratum #141
[    0.486462] cpuidle: using governor ladder
[    0.486463] cpuidle: using governor menu
[    0.486485] usbcore: registered new interface driver usbhid
[    0.486486] usbhid: USB HID core driver
[    0.486559] TCP: cubic registered
[    0.487266] powernow-k8: fid 0x16 (3000 MHz), vid 0xc
[    0.487268] powernow-k8: fid 0x14 (2800 MHz), vid 0xe
[    0.487269] powernow-k8: fid 0x12 (2600 MHz), vid 0x10
[    0.487270] powernow-k8: fid 0x10 (2400 MHz), vid 0x10
[    0.487271] powernow-k8: fid 0xe (2200 MHz), vid 0x10
[    0.487272] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    0.487273] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    0.487274] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    0.487315] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ (2 cpu cores) (version 2.20.00)
[    0.487335] ALSA device list:
[    0.487336]   No soundcards found.
[    0.616715] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.616742] ata5: SATA link down (SStatus 0 SControl 300)
[    0.616763] ata6: SATA link down (SStatus 0 SControl 300)
[    0.616784] ata3: SATA link down (SStatus 0 SControl 300)
[    0.616802] ata4: SATA link down (SStatus 0 SControl 300)
[    0.616819] ata2: SATA link down (SStatus 0 SControl 300)
[    0.617423] ata1.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
[    0.617429] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.618186] ata1.00: configured for UDMA/133
[    0.618454] scsi 0:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 01.0 
PQ: 0 ANSI: 5
[    0.618686] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 
GB/596 GiB)
[    0.618851] sd 0:0:0:0: [sda] Write Protect is off
[    0.618857] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.618887] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    0.620721] scsi 6:0:0:0: CD-ROM            BENQ     DVD DD DW1620    B7W9 
PQ: 0 ANSI: 5
[    0.624261] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    0.624354] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.624517] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    0.624735] ata8: port disabled--ignoring
[    0.655920]  sda: sda1
[    0.656219] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.699879] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: 
(null)
[    0.699918] VFS: Mounted root (ext4 filesystem) on device 8:1.
[    0.750722] devtmpfs: mounted
[    0.752254] Freeing unused kernel memory: 592k freed
[    0.752849] Write protecting the kernel read-only data: 6144k
[    0.756363] Freeing unused kernel memory: 536k freed
[    0.760588] Freeing unused kernel memory: 600k freed
[    1.511980] systemd-udevd[66]: starting version 197
[    1.617981] forcedeth 0000:00:0a.0: irq 41 for MSI/MSI-X
[    1.618052] forcedeth 0000:00:0a.0 eth0: MSI enabled
[    1.618330] forcedeth 0000:00:0a.0 eth0: no link during initialization
[    1.917567] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.917582] hda_intel: Disabling MSI
[    1.917633] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[    1.957874] Linux video capture interface: v2.00
[    2.001171] forcedeth 0000:00:0a.0 eth0: link up
[    2.062819] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    2.064787] cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[    2.064792] cx88[0]: TV tuner type 63, Radio tuner type -1
[    2.078199] saa7146: register extension 'budget dvb'
[    2.099950] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[    2.182160] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 
tuner
[    2.459083] tda9887 0-0043: creating new instance
[    2.459093] tda9887 0-0043: tda988[5/6/7] found
[    2.459921] tuner 0-0043: Tuner 74 found with type(s) Radio TV.
[    2.462816] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[    2.502563] tveeprom 0-0050: Hauppauge model 69009, rev B2D3, serial# 
2931872
[    2.502575] tveeprom 0-0050: MAC address is 00:0d:fe:2c:bc:a0
[    2.502581] tveeprom 0-0050: tuner model is Philips FMD1216MEX (idx 133, 
type 78)
[    2.502587] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.502593] tveeprom 0-0050: audio processor is CX882 (idx 33)
[    2.502597] tveeprom 0-0050: decoder processor is CX882 (idx 25)
[    2.502602] tveeprom 0-0050: has radio, has IR receiver, has no IR 
transmitter
[    2.502606] cx88[0]: hauppauge eeprom: model=69009
[    2.513199] tuner-simple 0-0061: creating new instance
[    2.513211] tuner-simple 0-0061: type set to 78 (Philips FMD1216MEX MK3 
Hybrid Tuner)
[    2.740035] Registered IR keymap rc-hauppauge
[    2.740260] input: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0/input2
[    2.740417] rc0: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0
[    2.742599] cx88[0]/2: cx2388x 8802 Driver Manager
[    2.743201] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 17
[    2.743242] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 17, latency: 64, 
mmio: 0xfb000000
[    2.743937] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 16
[    2.744058] saa7146: found saa7146 @ mem ffffc9000000ac00 (revision 1, irq 
16) (0x13c2,0x1003)
[    2.744066] saa7146 (0): dma buffer size 192512
[    2.744157] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
[    2.751835] IR RC5(x) protocol handler initialized
[    2.774367] adapter has MAC addr = 00:d0:5c:1e:eb:d5
[    2.776978] DVB: Unable to find symbol ves1x93_attach()
[    2.779820] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    2.779830] cx88/2: registering cx8802 driver, type: dvb access: shared
[    2.779837] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68]
[    2.779842] cx88[0]/2: cx2388x based DVB/ATSC card
[    2.779847] cx8802_alloc_frontends() allocating 2 frontend(s)
[    2.789531] IR RC6 protocol handler initialized
[    2.790272] input: MCE IR Keyboard/Mouse (cx88xx) as 
/devices/virtual/input/input3
[    2.790682] IR MCE Keyboard/mouse protocol handler initialized
[    2.929686] tuner-simple 0-0061: attaching existing instance
[    2.929699] tuner-simple 0-0061: couldn't set type to 63. Using 78 (Philips 
FMD1216MEX MK3 Hybrid Tuner) instead
[    2.933737] DVB: registering new adapter (cx88[0])
[    2.933749] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 0 (Conexant CX24116/CX24118)...
[    2.935273] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 1 (Conexant CX22702 DVB-T)...
[    3.000240] budget dvb 0000:01:07.0: DVB: registering adapter 0 frontend 0 
(ST STV0299 DVB-S)...
[    3.001097] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 17, latency: 64, 
mmio: 0xf9000000
[    3.021488] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000038
[    3.021753] IP: [<ffffffffa016b419>] cx8800_s_aud_ctrl+0x229/0x2e0 [cx8800]
[    3.021915] PGD 5ce1c067 PUD 5ce1d067 PMD 0 
[    3.022105] Oops: 0000 [#1] PREEMPT SMP 
[    3.022292] Modules linked in: cx22702 isl6421 cx24116 stv0299 
ir_mce_kbd_decoder ir_rc6_decoder cx88_dvb videobuf_dvb ir_rc5_decoder 
snd_hda_codec_realtek rc_hauppauge tuner_simple tuner_types tda9887 tda8290 
tuner cx8800(+) budget budget_core cx8802 cx88xx ttpci_eeprom tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common saa7146 videodev rc_core 
snd_hda_intel(+) snd_hda_codec snd_pcm snd_page_alloc dvb_core
[    3.023342] CPU 1 
[    3.023342] Pid: 93, comm: udevd Not tainted 3.9.0-rc4 #29  
[    3.023342] RIP: 0010:[<ffffffffa016b419>]  [<ffffffffa016b419>] 
cx8800_s_aud_ctrl+0x229/0x2e0 [cx8800]
[    3.023342] RSP: 0018:ffff88005ce41a88  EFLAGS: 00010246
[    3.023342] RAX: 0000000000000000 RBX: ffff88005a659180 RCX: 0000000000000000
[    3.023342] RDX: 0000000000980909 RSI: 0000000000980909 RDI: ffff88005a659180
[    3.023342] RBP: ffff88005ce41ae8 R08: 000000000000005a R09: 0000000000000000
[    3.023342] R10: 0000000000001800 R11: 0000000000000000 R12: ffffffffa016df60
[    3.023342] R13: ffff88005d21e700 R14: ffff88005d21e000 R15: ffff88005a659180
[    3.023342] FS:  00007f9ba6e53780(0000) GS:ffff88005fd00000(0000) 
knlGS:0000000000000000
[    3.023342] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.023342] CR2: 0000000000000038 CR3: 000000005ce1b000 CR4: 
00000000000007e0
[    3.023342] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    3.023342] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.023342] Process udevd (pid: 93, threadinfo ffff88005ce40000, task 
ffff88005ce38000)
[    3.023342] Stack:
[    3.023342]  ffff88005d21e600 0000000000001000 ffff88005ce41b38 ffffffffa01218df
[    3.023342]  ffff88005ce41ac8 ffffffff8219f72b ffff88005ce41ad8 ffff88005a659180
[    3.023342]  0000000000000001 0000000000000000 ffff88005d21e728 
ffff88005a659180
[    3.023342] Call Trace:
[    3.023342]  [<ffffffffa01218df>] ? cx88_set_tvnorm+0x3af/0x980 [cx88xx]
[    3.023342]  [<ffffffff8219f72b>] ? kobject_put+0x2b/0x60
[    3.023342]  [<ffffffffa009301d>] v4l2_ctrl_handler_setup+0xdd/0x120 [videodev]
[    3.023342]  [<ffffffffa016d3c4>] cx8800_initdev+0x424/0x810 [cx8800]
[    3.023342]  [<ffffffff821b98b4>] pci_device_probe+0x94/0xd0
[    3.023342]  [<ffffffff8223dcc6>] driver_probe_device+0x76/0x230
[    3.023342]  [<ffffffff8223df1b>] __driver_attach+0x9b/0xa0
[    3.023342]  [<ffffffff8223de80>] ? driver_probe_device+0x230/0x230
[    3.023342]  [<ffffffff8223c055>] bus_for_each_dev+0x55/0x90
[    3.023342]  [<ffffffff8223d7d9>] driver_attach+0x19/0x20
[    3.023342]  [<ffffffff8223d35e>] bus_add_driver+0xfe/0x260
[    3.023342]  [<ffffffffa0173000>] ? 0xffffffffa0172fff
[    3.023342]  [<ffffffff8223e392>] driver_register+0x72/0x160
[    3.023342]  [<ffffffffa0173000>] ? 0xffffffffa0172fff
[    3.023342]  [<ffffffff821b9196>] __pci_register_driver+0x46/0x50
[    3.023342]  [<ffffffffa0173033>] cx8800_init+0x33/0x35 [cx8800]
[    3.023342]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[    3.023342]  [<ffffffff82066638>] load_module+0x1888/0x2140
[    3.023342]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[    3.023342]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[    3.023342]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[    3.023342] Code: 48 89 45 c8 be 01 00 00 00 4c 89 f7 ff d2 48 8b 45 c8 8b 
b3 80 00 00 00 c1 e6 09 eb 53 0f 1f 44 00 00 49 8b 45 70 be 09 09 98 00 <48> 
8b 78 38 e8 ae 6d f2 ff 48 85 c0 0f 84 00 fe ff ff 41 8b b5 
[    3.023342] RIP  [<ffffffffa016b419>] cx8800_s_aud_ctrl+0x229/0x2e0 [cx8800]
[    3.023342]  RSP <ffff88005ce41a88>
[    3.023342] CR2: 0000000000000038
[    3.044530] ---[ end trace b2ee0c48b1b6ba03 ]---

lspci:
00:00.0 RAM memory: NVIDIA Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0
	Capabilities: [94] HyperTransport: #1a
	Capabilities: [60] HyperTransport: Retry Mode
	Capabilities: [44] HyperTransport: Slave or Primary Interface
	Capabilities: [d0] HyperTransport: #1c

00:01.0 ISA bridge: NVIDIA Corporation MCP78S [GeForce 8200] LPC Bridge (rev 
a2)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at 0900 [size=256]

00:01.1 SMBus: NVIDIA Corporation MCP78S [GeForce 8200] SMBus (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at 0e00 [size=64]
	I/O ports at 0600 [size=64]
	I/O ports at 0700 [size=64]
	Capabilities: [44] Power Management version 2

00:01.2 RAM memory: NVIDIA Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: 66MHz, fast devsel

00:01.3 Co-processor: NVIDIA Corporation MCP78S [GeForce 8200] Co-Processor 
(rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
	Memory at f8e80000 (32-bit, non-prefetchable) [size=512K]

00:01.4 RAM memory: NVIDIA Corporation MCP78S [GeForce 8200] Memory Controller 
(rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: 66MHz, fast devsel

00:02.0 USB controller: NVIDIA Corporation MCP78S [GeForce 8200] OHCI USB 1.1 
Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	Memory at f8e7e000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ohci_hcd

00:02.1 USB controller: NVIDIA Corporation MCP78S [GeForce 8200] EHCI USB 2.0 
Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at f8e7fc00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci-pci

00:04.0 USB controller: NVIDIA Corporation MCP78S [GeForce 8200] OHCI USB 1.1 
Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
	Memory at f8e7d000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ohci_hcd

00:04.1 USB controller: NVIDIA Corporation MCP78S [GeForce 8200] EHCI USB 2.0 
Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
	Memory at f8e7f800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci-pci

00:06.0 IDE interface: NVIDIA Corporation MCP78S [GeForce 8200] IDE (rev a1) 
(prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable)
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable)
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: pata_amd

00:07.0 Audio device: NVIDIA Corporation MCP72XE/MCP72P/MCP78U/MCP78S High 
Definition Audio (rev a1)
	Subsystem: ASUSTeK Computer Inc. M3N72-D
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
	Memory at f8e78000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: snd_hda_intel

00:08.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Bridge (rev 
a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	Memory behind bridge: f8f00000-fcffffff
	Capabilities: [b8] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-

00:09.0 SATA controller: NVIDIA Corporation MCP78S [GeForce 8200] AHCI 
Controller (rev a2) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 40
	I/O ports at d480 [size=8]
	I/O ports at d400 [size=4]
	I/O ports at d080 [size=8]
	I/O ports at d000 [size=4]
	I/O ports at cc00 [size=16]
	Memory at f8e76000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [8c] SATA HBA v1.0
	Capabilities: [b0] MSI: Enable+ Count=1/8 Maskable- 64bit+
	Capabilities: [ec] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: ahci

00:0a.0 Ethernet controller: NVIDIA Corporation MCP77 Ethernet (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 41
	Memory at f8e7c000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at c880 [size=8]
	Memory at f8e7f400 (32-bit, non-prefetchable) [size=256]
	Memory at f8e7f000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] MSI: Enable+ Count=1/16 Maskable+ 64bit+
	Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: forcedeth

00:0b.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Express 
Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fd000000-feafffff
	Prefetchable memory behind bridge: 00000000d6000000-00000000dfffffff
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 2
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-

00:10.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Express 
Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Kernel driver in use: pcieport

00:12.0 PCI bridge: NVIDIA Corporation MCP78S [GeForce 8200] PCI Express 
Bridge (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82f2
	Capabilities: [48] Power Management version 3
	Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Kernel driver in use: pcieport

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
	Flags: fast devsel
	Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
	Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
	Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
	Flags: fast devsel
	Capabilities: [f0] Secure device <?>
	Kernel driver in use: k8temp

01:06.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI 
Video and Audio Decoder (rev 05)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

01:06.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [Audio Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2

01:06.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
	Flags: bus master, medium devsel, latency 64, IRQ 16
	Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: cx88-mpeg driver manager

01:06.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video 
and Audio Decoder [IR Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. WinTV HVR-4000-HD
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2

01:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Technotrend-Budget/Hauppauge 
WinTV-NOVA-S DVB card
	Flags: bus master, medium devsel, latency 64, IRQ 17
	Memory at f8fffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget dvb

02:00.0 VGA compatible controller: NVIDIA Corporation C77 [GeForce 8300] (rev 
a2) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 82f2
	Flags: bus master, fast devsel, latency 0
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d8000000 (64-bit, prefetchable) [size=128M]
	Memory at d6000000 (64-bit, prefetchable) [size=32M]
	I/O ports at ec00 [size=128]
	Expansion ROM at feae0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+


