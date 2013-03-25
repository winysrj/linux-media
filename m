Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3CYTQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 15:16:40 -0400
From: Sebastian Frei <sebastian@familie-frei.net>
To: linux-media@vger.kernel.org
Subject: BUG: Null pointer dereference when loading mceusb (0471:0613)
Date: Mon, 25 Mar 2013 20:16:44 +0100
Message-ID: <2532933.qOEr2AnA4m@nop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello *,

I get a null pointer dereference when loading the mceusb module with a
0471:0613 "Philips (or NXP) Infrared Transceiver" (kernel 3.9.0-rc4, but
using an older kernel makes no difference).

Below is the output of dmesg and lsusb -vvv.
Please note the usbhid.quirks parameter, it prevents the usbhid module from grabbing the device.
At 222 seconds I issued a "modprobe mceusb" command.
The remote is not working.

Best regards
Sebastian


dmesg:
[    0.000000] Linux version 3.9.0-rc4 (root@VDR-SF) (gcc version 4.7.2 (GCC) ) #29 SMP PREEMPT Mon Mar 25 19:43:35 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda1 rw rootfstype=ext4 modprobe.blacklist=cx8800 modprobe.blacklist=mceusb quiet usbhid.quirks=0x0471:0x0613:0x4
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
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
[    0.000000] ACPI: XSDT 000000005ff90100 0006C (v01 091010 XSDT1510 20100910 MSFT 00000097)
[    0.000000] ACPI: FACP 000000005ff90290 000F4 (v03 091010 FACP1510 20100910 MSFT 00000097)
[    0.000000] ACPI: DSDT 000000005ff90460 0AAF1 (v01  A1043 A1043000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 000000005ff9e000 00040
[    0.000000] ACPI: APIC 000000005ff90390 00090 (v01 091010 APIC1510 20100910 MSFT 00000097)
[    0.000000] ACPI: MCFG 000000005ff90420 0003C (v01 091010 OEMMCFG  20100910 MSFT 00000097)
[    0.000000] ACPI: OEMB 000000005ff9e040 00072 (v01 091010 OEMB1510 20100910 MSFT 00000097)
[    0.000000] ACPI: SRAT 000000005ff9af60 000A0 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
[    0.000000] ACPI: HPET 000000005ff9b000 00038 (v01 091010 OEMHPET0 20100910 MSFT 00000097)
[    0.000000] ACPI: INFO 000000005ff9e0c0 00124 (v01 091010 AMDINFO  20100910 MSFT 00000097)
[    0.000000] ACPI: NVHD 000000005ff9e1f0 00284 (v01 091010  NVHDCP  20100910 MSFT 00000097)
[    0.000000] ACPI: SSDT 000000005ff9b040 0030E (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00017fffff] PMD -> [ffff88005de00000-ffff88005f5fffff] on node 0
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
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88005fc00000 s73088 r8192 d21120 u1048576
[    0.000000] pcpu-alloc: s73088 r8192 d21120 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 386840
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda1 rw rootfstype=ext4 modprobe.blacklist=cx8800 modprobe.blacklist=mceusb quiet usbhid.quirks=0x0471:0x0613:0x4
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 1536596k/1572416k available (3553k kernel code, 400k absent, 35420k reserved, 2842k data, 592k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2999.698 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.003336] Calibrating delay loop (skipped), value calculated using timer frequency.. 6001.37 BogoMIPS (lpj=9998993)
[    0.003339] pid_max: default: 32768 minimum: 301
[    0.003366] Mount-cache hash table entries: 256
[    0.003536] tseg: 0000000000
[    0.003541] CPU: Physical Processor ID: 0
[    0.003542] CPU: Processor Core ID: 0
[    0.003544] mce: CPU supports 5 MCE banks
[    0.003550] LVT offset 0 assigned for vector 0xf9
[    0.003553] process: using AMD E400 aware idle routine
[    0.003555] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
tlb_flushall_shift: 4
[    0.003597] Freeing SMP alternatives: 16k freed
[    0.003607] ACPI: Core revision 20130117
[    0.006761] ACPI: All ACPI Tables successfully acquired
[    0.007876] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040882] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ (fam: 0f, model: 43, stepping: 03)
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
[    0.146721] Brought up 2 CPUs
[    0.146723] smpboot: Total of 2 processors activated (12003.91 BogoMIPS)
[    0.147281] devtmpfs: initialized
[    0.147281] NET: Registered protocol family 16
[    0.147281] node 0 link 0: io port [1000, ffffff]
[    0.147281] node 0 link 0: io port [1000, 1fff]
[    0.147281] TOM: 0000000080000000 aka 2048M
[    0.147281] node 0 link 0: mmio [e0000000, efffffff]
[    0.147281] node 0 link 0: mmio [a0000, bffff]
[    0.147281] node 0 link 0: mmio [80000000, fe0bffff]
[    0.147281] bus: [bus 00-07] on node 0 link 0
[    0.147281] bus: 00 [io  0x0000-0xffff]
[    0.147281] bus: 00 [mem 0x80000000-0xfcffffffff]
[    0.147281] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.147281] ACPI: bus type PCI registered
[    0.147291] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.147293] PCI: not using MMCONFIG
[    0.147294] PCI: Using configuration type 1 for base access
[    0.147350] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.147351] mtrr: probably your BIOS does not setup all CPUs.
[    0.147352] mtrr: corrected configuration.
[    0.147705] bio: create slab <bio-0> at 0
[    0.147705] ACPI: Added _OSI(Module Device)
[    0.147705] ACPI: Added _OSI(Processor Device)
[    0.147705] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.147705] ACPI: Added _OSI(Processor Aggregator Device)
[    0.147705] ACPI: EC: Look up EC in DSDT
[    0.150829] ACPI: Executed 1 blocks of module-level executable AML code
[    0.153757] ACPI: Interpreter enabled
[    0.153762] ACPI: (supports S0 S5)
[    0.153763] ACPI: Using IOAPIC for interrupt routing
[    0.153777] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.154720] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.162041] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.169142] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.169297] acpi PNP0A03:00: Requesting ACPI _OSC control (0x15)
[    0.169428] acpi PNP0A03:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x04
[    0.169563] PCI host bridge to bus 0000:00
[    0.169565] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.169568] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.169570] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.169572] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.169574] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.169576] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff]
[    0.169578] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.169611] pci 0000:00:00.0: [10de:0754] type 00 class 0x050000
[    0.169911] pci 0000:00:01.0: [10de:075c] type 00 class 0x060100
[    0.169918] pci 0000:00:01.0: reg 10: [io  0x0900-0x09ff]
[    0.169970] pci 0000:00:01.1: [10de:0752] type 00 class 0x0c0500
[    0.169981] pci 0000:00:01.1: reg 10: [io  0x0e00-0x0e3f]
[    0.170002] pci 0000:00:01.1: reg 20: [io  0x0600-0x063f]
[    0.170007] pci 0000:00:01.1: reg 24: [io  0x0700-0x073f]
[    0.170036] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.170070] pci 0000:00:01.2: [10de:0751] type 00 class 0x050000
[    0.170154] pci 0000:00:01.3: [10de:0753] type 00 class 0x0b4000
[    0.170170] pci 0000:00:01.3: reg 10: [mem 0xf8e80000-0xf8efffff]
[    0.170318] pci 0000:00:01.4: [10de:0568] type 00 class 0x050000
[    0.170405] pci 0000:00:02.0: [10de:077b] type 00 class 0x0c0310
[    0.170413] pci 0000:00:02.0: reg 10: [mem 0xf8e7e000-0xf8e7efff]
[    0.170447] pci 0000:00:02.0: supports D1 D2
[    0.170449] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170482] pci 0000:00:02.1: [10de:077c] type 00 class 0x0c0320
[    0.170492] pci 0000:00:02.1: reg 10: [mem 0xf8e7fc00-0xf8e7fcff]
[    0.170533] pci 0000:00:02.1: supports D1 D2
[    0.170535] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170576] pci 0000:00:04.0: [10de:077d] type 00 class 0x0c0310
[    0.170584] pci 0000:00:04.0: reg 10: [mem 0xf8e7d000-0xf8e7dfff]
[    0.170618] pci 0000:00:04.0: supports D1 D2
[    0.170620] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170653] pci 0000:00:04.1: [10de:077e] type 00 class 0x0c0320
[    0.170663] pci 0000:00:04.1: reg 10: [mem 0xf8e7f800-0xf8e7f8ff]
[    0.170704] pci 0000:00:04.1: supports D1 D2
[    0.170705] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170747] pci 0000:00:06.0: [10de:0759] type 00 class 0x01018a
[    0.170768] pci 0000:00:06.0: reg 20: [io  0xffa0-0xffaf]
[    0.170838] pci 0000:00:07.0: [10de:0774] type 00 class 0x040300
[    0.170849] pci 0000:00:07.0: reg 10: [mem 0xf8e78000-0xf8e7bfff]
[    0.170890] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.170930] pci 0000:00:08.0: [10de:075a] type 01 class 0x060401
[    0.170996] pci 0000:00:09.0: [10de:0ad4] type 00 class 0x010601
[    0.171004] pci 0000:00:09.0: reg 10: [io  0xd480-0xd487]
[    0.171008] pci 0000:00:09.0: reg 14: [io  0xd400-0xd403]
[    0.171012] pci 0000:00:09.0: reg 18: [io  0xd080-0xd087]
[    0.171016] pci 0000:00:09.0: reg 1c: [io  0xd000-0xd003]
[    0.171021] pci 0000:00:09.0: reg 20: [io  0xcc00-0xcc0f]
[    0.171025] pci 0000:00:09.0: reg 24: [mem 0xf8e76000-0xf8e77fff]
[    0.171080] pci 0000:00:0a.0: [10de:0760] type 00 class 0x020000
[    0.171090] pci 0000:00:0a.0: reg 10: [mem 0xf8e7c000-0xf8e7cfff]
[    0.171094] pci 0000:00:0a.0: reg 14: [io  0xc880-0xc887]
[    0.171098] pci 0000:00:0a.0: reg 18: [mem 0xf8e7f400-0xf8e7f4ff]
[    0.171103] pci 0000:00:0a.0: reg 1c: [mem 0xf8e7f000-0xf8e7f00f]
[    0.171132] pci 0000:00:0a.0: supports D1 D2
[    0.171134] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171171] pci 0000:00:0b.0: [10de:0569] type 01 class 0x060400
[    0.171195] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171278] pci 0000:00:10.0: [10de:0778] type 01 class 0x060400
[    0.171501] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171623] pci 0000:00:12.0: [10de:075b] type 01 class 0x060400
[    0.171846] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171929] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.171972] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.172021] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.172063] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.172150] pci 0000:01:06.0: [14f1:8800] type 00 class 0x040000
[    0.172163] pci 0000:01:06.0: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.172247] pci 0000:01:06.1: [14f1:8811] type 00 class 0x048000
[    0.172259] pci 0000:01:06.1: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.172333] pci 0000:01:06.2: [14f1:8802] type 00 class 0x048000
[    0.172345] pci 0000:01:06.2: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.172419] pci 0000:01:06.4: [14f1:8804] type 00 class 0x048000
[    0.172431] pci 0000:01:06.4: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.172505] pci 0000:01:07.0: [1131:7146] type 00 class 0x048000
[    0.172515] pci 0000:01:07.0: reg 10: [mem 0xf8fffc00-0xf8fffdff]
[    0.172589] pci 0000:00:08.0: PCI bridge to [bus 01] (subtractive decode)
[    0.172593] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.172596] pci 0000:00:08.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.172598] pci 0000:00:08.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.172600] pci 0000:00:08.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.172602] pci 0000:00:08.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.172604] pci 0000:00:08.0:   bridge window [mem 0x80000000-0xdfffffff] (subtractive decode)
[    0.172606] pci 0000:00:08.0:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.172635] pci 0000:02:00.0: [10de:0848] type 00 class 0x030000
[    0.172642] pci 0000:02:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.172648] pci 0000:02:00.0: reg 14: [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.172654] pci 0000:02:00.0: reg 1c: [mem 0xd6000000-0xd7ffffff 64bit pref]
[    0.172658] pci 0000:02:00.0: reg 24: [io  0xec00-0xec7f]
[    0.172662] pci 0000:02:00.0: reg 30: [mem 0xfeae0000-0xfeafffff pref]
[    0.172707] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.172710] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.172713] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.172716] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit pref]
[    0.172874] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.173066] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.173123] pci_bus 0000:00: on NUMA node 0
[    0.173124] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.173905] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.173985] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *11
[    0.174064] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.174142] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.174221] ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *10
[    0.174299] ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, disabled.
[    0.174377] ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, disabled.
[    0.174456] ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, disabled.
[    0.174535] ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, disabled.
[    0.174613] ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, disabled.
[    0.174691] ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, disabled.
[    0.174769] ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, disabled.
[    0.174849] ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *11
[    0.174927] ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, disabled.
[    0.175005] ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, disabled.
[    0.175083] ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, disabled.
[    0.175163] ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *15
[    0.175241] ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, disabled.
[    0.175319] ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, disabled.
[    0.175398] ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, disabled.
[    0.175476] ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *0, disabled.
[    0.175555] ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, disabled.
[    0.175633] ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, disabled.
[    0.175711] ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, disabled.
[    0.175789] ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, disabled.
[    0.175868] ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, disabled.
[    0.175946] ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, disabled.
[    0.176024] ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, disabled.
[    0.176103] ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, disabled.
[    0.176181] ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, disabled.
[    0.176259] ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, disabled.
[    0.176337] ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, disabled.
[    0.176416] ACPI: PCI Interrupt Link [LN7A] (IRQs 16 17 18 19) *0, disabled.
[    0.176494] ACPI: PCI Interrupt Link [LN7B] (IRQs 16 17 18 19) *0, disabled.
[    0.176572] ACPI: PCI Interrupt Link [LN7C] (IRQs 16 17 18 19) *0, disabled.
[    0.176650] ACPI: PCI Interrupt Link [LN7D] (IRQs 16 17 18 19) *0, disabled.
[    0.176737] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    0.176816] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *15
[    0.176895] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
[    0.176974] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *15
[    0.177051] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *0, disabled.
[    0.177131] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.177210] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *10
[    0.177289] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.177375] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.177455] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *11
[    0.177534] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *10
[    0.177598] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.177700] acpi root: \_SB_.PCI0 notify handler is installed
[    0.177739] Found 1 acpi root devices
[    0.177819] SCSI subsystem initialized
[    0.177821] ACPI: bus type ATA registered
[    0.177838] libata version 3.00 loaded.
[    0.177838] ACPI: bus type USB registered
[    0.177838] usbcore: registered new interface driver usbfs
[    0.177838] usbcore: registered new interface driver hub
[    0.177838] usbcore: registered new device driver usb
[    0.177838] Advanced Linux Sound Architecture Driver Initialized.
[    0.177838] PCI: Using ACPI for IRQ routing
[    0.184260] PCI: pci_cache_line_size set to 64 bytes
[    0.184313] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.184315] e820: reserve RAM buffer [mem 0x5ff90000-0x5fffffff]
[    0.184426] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.184431] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.184434] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.200019] Switching to clocksource hpet
[    0.200065] pnp: PnP ACPI init
[    0.200071] ACPI: bus type PNP registered
[    0.200101] pnp 00:00: [dma 4]
[    0.200118] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.200137] pnp 00:01: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.200165] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.200785] pnp 00:03: [dma 3]
[    0.200950] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.201201] pnp 00:04: disabling [io  0x0900-0x097f] because it overlaps 0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201204] pnp 00:04: disabling [io  0x0980-0x09ff] because it overlaps 0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201252] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.201254] system 00:04: [io  0x0800-0x080f] has been reserved
[    0.201256] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.201258] system 00:04: [io  0x0580-0x05ff] has been reserved
[    0.201261] system 00:04: [io  0x0800-0x087f] could not be reserved
[    0.201263] system 00:04: [io  0x0880-0x08ff] has been reserved
[    0.201266] system 00:04: [io  0x0d00-0x0d7f] has been reserved
[    0.201268] system 00:04: [io  0x0d80-0x0dff] has been reserved
[    0.201271] system 00:04: [mem 0x000d0000-0x000d3fff window] has been reserved
[    0.201274] system 00:04: [mem 0x000d4000-0x000d7fff window] has been reserved
[    0.201276] system 00:04: [mem 0x000de000-0x000dffff window] has been reserved
[    0.201279] system 00:04: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.201281] system 00:04: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.201284] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201378] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.201405] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.201497] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.201499] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.201502] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201664] system 00:08: [io  0x0230-0x023f] has been reserved
[    0.201666] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.201668] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.201670] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.201673] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201874] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.201877] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.202022] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.202025] system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.202027] system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.202029] system 00:0a: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.202032] system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.202034] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.202522] pnp: PnP ACPI: found 11 devices
[    0.202523] ACPI: bus type PNP unregistered
[    0.208935] pci 0000:00:08.0: PCI bridge to [bus 01]
[    0.208939] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.208945] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.208947] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.208949] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.208952] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit pref]
[    0.208955] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.208980] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.209009] pci 0000:00:08.0: setting latency timer to 64
[    0.209013] pci 0000:00:0b.0: setting latency timer to 64
[    0.209198] ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
[    0.209374] ACPI: PCI Interrupt Link [LN2A] enabled at IRQ 18
[    0.209386] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.209388] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.209390] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209392] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209394] pci_bus 0000:00: resource 8 [mem 0x80000000-0xdfffffff]
[    0.209396] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.209399] pci_bus 0000:01: resource 1 [mem 0xf8f00000-0xfcffffff]
[    0.209401] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.209403] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.209405] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209407] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209409] pci_bus 0000:01: resource 8 [mem 0x80000000-0xdfffffff]
[    0.209411] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.209413] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.209415] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfeafffff]
[    0.209417] pci_bus 0000:02: resource 2 [mem 0xd6000000-0xdfffffff 64bit pref]
[    0.209444] NET: Registered protocol family 2
[    0.209541] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.209655] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.209775] TCP: Hash tables configured (established 16384 bind 16384)
[    0.209842] TCP: reno registered
[    0.209844] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209861] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209911] NET: Registered protocol family 1
[    0.210187] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    0.210433] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    0.210667] ACPI: PCI Interrupt Link [UB11] enabled at IRQ 21
[    0.210897] ACPI: PCI Interrupt Link [UB12] enabled at IRQ 20
[    0.211060] pci 0000:00:07.0: Enabling HT MSI Mapping
[    0.211154] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.211253] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.211357] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.211460] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.211589] pci 0000:02:00.0: Boot video device
[    0.211591] PCI: CLS 64 bytes, default 64
[    0.212971] fuse init (API version 7.21)
[    0.213047] msgmni has been set to 3001
[    0.213263] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.213265] io scheduler noop registered
[    0.213266] io scheduler deadline registered (default)
[    0.213613] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.213616] ACPI: Power Button [PWRB]
[    0.213658] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.213660] ACPI: Power Button [PWRF]
[    0.213689] ACPI: processor limited to max C-state 1
[    0.216606] ppdev: user-space parallel port driver
[    0.216620] [drm] Initialized drm 1.1.0 20060810
[    0.216652] parport_pc 00:03: reported by Plug and Play ACPI
[    0.216728] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    0.296889] ahci 0000:00:09.0: version 3.0
[    0.297076] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.297117] ahci 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.297125] ahci 0000:00:09.0: controller can't do PMP, turning off CAP_PMP
[    0.297186] ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.297189] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pio boh 
[    0.297192] ahci 0000:00:09.0: setting latency timer to 64
[    0.297866] scsi0 : ahci
[    0.297954] scsi1 : ahci
[    0.298020] scsi2 : ahci
[    0.298081] scsi3 : ahci
[    0.298143] scsi4 : ahci
[    0.298203] scsi5 : ahci
[    0.298234] ata1: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76100 irq 40
[    0.298236] ata2: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76180 irq 40
[    0.298238] ata3: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76200 irq 40
[    0.298239] ata4: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76280 irq 40
[    0.298241] ata5: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76300 irq 40
[    0.298243] ata6: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76380 irq 40
[    0.298306] pata_amd 0000:00:06.0: version 0.4.1
[    0.298339] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.298532] scsi6 : pata_amd
[    0.298762] scsi7 : pata_amd
[    0.298920] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.298923] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.298954] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    0.299155] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
[    0.299161] forcedeth 0000:00:0a.0: setting latency timer to 64
[    0.357640] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 3, addr 00:26:18:77:ed:11
[    0.357643] forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt gbit lnktim msi desc-v3
[    0.357656] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.357658] ehci-pci: EHCI PCI platform driver
[    0.357734] ehci-pci 0000:00:02.1: setting latency timer to 64
[    0.357737] ehci-pci 0000:00:02.1: EHCI Host Controller
[    0.357743] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    0.357752] ehci-pci 0000:00:02.1: debug port 1
[    0.357769] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    0.357791] ehci-pci 0000:00:02.1: irq 22, io mem 0xf8e7fc00
[    0.366692] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.366809] hub 1-0:1.0: USB hub found
[    0.366813] hub 1-0:1.0: 6 ports detected
[    0.366947] ehci-pci 0000:00:04.1: setting latency timer to 64
[    0.366949] ehci-pci 0000:00:04.1: EHCI Host Controller
[    0.366954] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus number 2
[    0.366960] ehci-pci 0000:00:04.1: debug port 1
[    0.366977] ehci-pci 0000:00:04.1: cache line size of 64 is not supported
[    0.366992] ehci-pci 0000:00:04.1: irq 20, io mem 0xf8e7f800
[    0.376691] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.376768] hub 2-0:1.0: USB hub found
[    0.376771] hub 2-0:1.0: 6 ports detected
[    0.376838] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.376907] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.376909] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.376913] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 3
[    0.376933] ohci_hcd 0000:00:02.0: irq 23, io mem 0xf8e7e000
[    0.432099] hub 3-0:1.0: USB hub found
[    0.432103] hub 3-0:1.0: 6 ports detected
[    0.432227] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.432229] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.432233] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 4
[    0.432255] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf8e7d000
[    0.450177] ata7.01: NODEV after polling detection
[    0.457239] ata7.00: ATAPI: BENQ    DVD DD DW1620, B7W9, max UDMA/33
[    0.457245] ata7: nv_mode_filter: 0x739f&0xfffff->0x739f, BIOS=0x0 (0x0) ACPI=0x0 (900:900:0x10)
[    0.470484] ata7.00: configured for UDMA/33
[    0.485435] hub 4-0:1.0: USB hub found
[    0.485439] hub 4-0:1.0: 6 ports detected
[    0.485528] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.485932] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.485936] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.486022] rtc_cmos 00:06: RTC can wake from S4
[    0.486261] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.486314] rtc_cmos 00:06: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[    0.486440] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    0.486459] cpuidle: using governor ladder
[    0.486460] cpuidle: using governor menu
[    0.486482] usbcore: registered new interface driver usbhid
[    0.486483] usbhid: USB HID core driver
[    0.486556] TCP: cubic registered
[    0.487267] powernow-k8: fid 0x16 (3000 MHz), vid 0xc
[    0.487269] powernow-k8: fid 0x14 (2800 MHz), vid 0xe
[    0.487270] powernow-k8: fid 0x12 (2600 MHz), vid 0x10
[    0.487271] powernow-k8: fid 0x10 (2400 MHz), vid 0x10
[    0.487272] powernow-k8: fid 0xe (2200 MHz), vid 0x10
[    0.487273] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    0.487274] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    0.487275] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    0.487315] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ (2 cpu cores) (version 2.20.00)
[    0.487335] ALSA device list:
[    0.487336]   No soundcards found.
[    0.616713] ata3: SATA link down (SStatus 0 SControl 300)
[    0.616740] ata2: SATA link down (SStatus 0 SControl 300)
[    0.616761] ata6: SATA link down (SStatus 0 SControl 300)
[    0.616780] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.616798] ata4: SATA link down (SStatus 0 SControl 300)
[    0.616814] ata5: SATA link down (SStatus 0 SControl 300)
[    0.617489] ata1.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
[    0.617495] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.618231] ata1.00: configured for UDMA/133
[    0.618500] scsi 0:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 01.0 PQ: 0 ANSI: 5
[    0.618729] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    0.618899] sd 0:0:0:0: [sda] Write Protect is off
[    0.618906] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.618942] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.620924] scsi 6:0:0:0: CD-ROM            BENQ     DVD DD DW1620    B7W9 PQ: 0 ANSI: 5
[    0.624406] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    0.624499] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.624664] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    0.624883] ata8: port disabled--ignoring
[    0.655900]  sda: sda1
[    0.656374] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.699852] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    0.699889] VFS: Mounted root (ext4 filesystem) on device 8:1.
[    0.750715] devtmpfs: mounted
[    0.752235] Freeing unused kernel memory: 592k freed
[    0.752828] Write protecting the kernel read-only data: 6144k
[    0.756316] Freeing unused kernel memory: 536k freed
[    0.760532] Freeing unused kernel memory: 600k freed
[    1.511945] systemd-udevd[65]: starting version 197
[    1.609056] forcedeth 0000:00:0a.0: irq 41 for MSI/MSI-X
[    1.609125] forcedeth 0000:00:0a.0 eth0: MSI enabled
[    1.609404] forcedeth 0000:00:0a.0 eth0: no link during initialization
[    1.918122] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.918137] hda_intel: Disabling MSI
[    1.918189] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[    1.957732] Linux video capture interface: v2.00
[    1.960681] forcedeth 0000:00:0a.0 eth0: link up
[    1.984446] saa7146: register extension 'budget dvb'
[    1.985004] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
[    1.985104] saa7146: found saa7146 @ mem ffffc9000000ac00 (revision 1, irq 17) (0x13c2,0x1003)
[    1.985110] saa7146 (0): dma buffer size 192512
[    1.985200] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
[    2.017695] adapter has MAC addr = 00:d0:5c:1e:eb:d5
[    2.048523] DVB: Unable to find symbol ves1x93_attach()
[    2.162804] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    2.253585] budget dvb 0000:01:07.0: DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
[    2.256809] cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[    2.256818] cx88[0]: TV tuner type 63, Radio tuner type -1
[    2.375486] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 tuner
[    2.741875] tda9887 1-0043: creating new instance
[    2.741884] tda9887 1-0043: tda988[5/6/7] found
[    2.742712] tuner 1-0043: Tuner 74 found with type(s) Radio TV.
[    2.745535] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
[    2.786053] tveeprom 1-0050: Hauppauge model 69009, rev B2D3, serial# 2931872
[    2.786060] tveeprom 1-0050: MAC address is 00:0d:fe:2c:bc:a0
[    2.786065] tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, type 78)
[    2.786071] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.786076] tveeprom 1-0050: audio processor is CX882 (idx 33)
[    2.786080] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[    2.786084] tveeprom 1-0050: has radio, has IR receiver, has no IR transmitter
[    2.786088] cx88[0]: hauppauge eeprom: model=69009
[    2.798591] tuner-simple 1-0061: creating new instance
[    2.798602] tuner-simple 1-0061: type set to 78 (Philips FMD1216MEX MK3 Hybrid Tuner)
[    2.923377] Registered IR keymap rc-hauppauge
[    2.923620] input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0/input2
[    2.923774] rc0: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0
[    2.927122] cx88[0]/2: cx2388x 8802 Driver Manager
[    2.927763] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
[    2.927806] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 16, latency: 64, mmio: 0xfb000000
[    2.981574] IR RC6 protocol handler initialized
[    2.982183] input: MCE IR Keyboard/Mouse (cx88xx) as /devices/virtual/input/input3
[    2.982288] IR MCE Keyboard/mouse protocol handler initialized
[    2.993482] IR RC5(x) protocol handler initialized
[    3.030205] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    3.030216] cx88/2: registering cx8802 driver, type: dvb access: shared
[    3.030222] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[    3.030227] cx88[0]/2: cx2388x based DVB/ATSC card
[    3.030230] cx8802_alloc_frontends() allocating 2 frontend(s)
[    3.113090] tuner-simple 1-0061: attaching existing instance
[    3.113095] tuner-simple 1-0061: couldn't set type to 63. Using 78 (Philips FMD1216MEX MK3 Hybrid Tuner) instead
[    3.117612] DVB: registering new adapter (cx88[0])
[    3.117617] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 1 frontend 0 (Conexant CX24116/CX24118)...
[    3.118372] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 1 frontend 1 (Conexant CX22702 DVB-T)...
[    4.793696] cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...
[    4.835740] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[    9.992994] cx24116_load_firmware: FW version 1.26.90.0
[    9.993005] cx24116_firmware_ondemand: Firmware upload complete
[  120.373357] usb 4-5: new low-speed USB device number 2 using ohci_hcd
[  222.318730] Registered IR keymap rc-rc6-mce
[  222.318831] input: Media Center Ed. eHome Infrared Remote Transceiver (0471:0613) as /devices/pci0000:00/0000:00:04.0/usb4/4-5/4-5:1.0/rc/rc1/input4
[  222.318886] rc1: Media Center Ed. eHome Infrared Remote Transceiver (0471:0613) as /devices/pci0000:00/0000:00:04.0/usb4/4-5/4-5:1.0/rc/rc1
[  222.319024] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input5
[  222.319075] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
[  222.319133] IP: [<ffffffffa0307cf4>] mce_request_packet+0x134/0x220 [mceusb]
[  222.319178] PGD 5bd23067 PUD 5bc09067 PMD 0 
[  222.319243] Oops: 0000 [#1] PREEMPT SMP 
[  222.319304] Modules linked in: mceusb(+) rc_winfast_usbii_deluxe rc_winfast rc_videomate_tv_pvr rc_videomate_s350 rc_videomate_m1f rc_twinhan1027 rc_tt_1500 rc_trekstor rc_total_media_in_hand rc_total_media_in_hand_02 rc_tivo rc_tevii_nec rc_terratec_slim rc_terratec_slim_2 rc_terratec_cinergy_xs rc_technisat_usb2 rc_tbs_nec rc_streamzap rc_snapstream_firefly rc_real_audio_220_32_keys rc_rc6_mce rc_pv951 rc_purpletv rc_proteus_2309 rc_powercolor_real_angel rc_pixelview_new rc_pixelview_mk12 rc_pixelview rc_pixelview_002t rc_pinnacle_pctv_hd rc_pinnacle_grey rc_pinnacle_color rc_pctv_sedna rc_npgtech rc_norwood rc_nec_terratec_cinergy_xs rc_nebula rc_msi_tvanywhere_plus rc_msi_tvanywhere rc_msi_digivox_ii rc_msi_digivox_iii rc_medion_x10_or2x rc_medion_x10 rc_medion_x10_digitainer rc_manli rc_lme2510
[  222.320072]  rc_lirc rc_leadtek_y04g0051 rc_kworld_plus_tv_analog rc_kworld_pc150u rc_kworld_315u rc_kaiomy rc_it913x_v2 rc_it913x_v1 rc_iodata_bctv7e rc_imon_pad rc_imon_mce rc_gotview7135 rc_genius_tvgo_a11mce rc_gadmei_rm008z rc_fusionhdtv_mce rc_flyvideo rc_flydvb rc_eztv rc_evga_indtube rc_encore_enltv rc_encore_enltv_fm53 rc_encore_enltv2 rc_em_terratec rc_dntv_live_dvbt_pro rc_dntv_live_dvb_t rc_dm1105_nec rc_digittrade rc_digitalnow_tinytwin rc_dib0700_rc5 rc_dib0700_nec rc_cinergy rc_cinergy_1400 rc_budget_ci_old rc_behold rc_behold_columbus rc_azurewave_ad_tu700 rc_avertv_303 rc_avermedia_rm_ks rc_avermedia_m733a_rm_k6 rc_avermedia_m135a rc_avermedia rc_avermedia_dvbt rc_avermedia_cardbus rc_avermedia_a16d rc_ati_x10 rc_ati_tv_wonder_hd_600 rc_asus_ps3_100 rc_asus_pc39 rc_apac_viewcomp
[  222.320951]  rc_anysee rc_alink_dtu_m rc_adstech_dvb_t_pci snd_hda_codec_hdmi cx22702 isl6421 cx24116 cx88_dvb videobuf_dvb ir_rc5_decoder ir_mce_kbd_decoder ir_rc6_decoder rc_hauppauge tuner_simple tuner_types tda9887 tda8290 snd_hda_codec_realtek tuner cx8802 cx88xx stv0299 tveeprom btcx_risc videobuf_dma_sg videobuf_core v4l2_common budget budget_core ttpci_eeprom videodev rc_core saa7146 snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc dvb_core
[  222.321843] CPU 1 
[  222.321862] Pid: 608, comm: modprobe Not tainted 3.9.0-rc4 #29  
[  222.322002] RIP: 0010:[<ffffffffa0307cf4>]  [<ffffffffa0307cf4>] mce_request_packet+0x134/0x220 [mceusb]
[  222.322031] RSP: 0018:ffff88005bc319c8  EFLAGS: 00010282
[  222.322031] RAX: ffff88005cfcef38 RBX: ffff88005d2e5c00 RCX: 0000000000000000
[  222.322031] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000000
[  222.322031] RBP: ffff88005bc31a08 R08: ffff88005a57d000 R09: ffff88005cfcef38
[  222.322031] R10: 0000000000000001 R11: ffff88005a531060 R12: ffff88005bd20300
[  222.322031] R13: 0000000000000002 R14: ffff88005d2ee430 R15: ffffffffa030a0b3
[  222.322031] FS:  00007fb9e0fcb700(0000) GS:ffff88005fd00000(0000) knlGS:0000000000000000
[  222.322031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  222.322031] CR2: 0000000000000002 CR3: 000000005a50e000 CR4: 00000000000007e0
[  222.322031] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  222.322031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  222.322031] Process modprobe (pid: 608, threadinfo ffff88005bc30000, task ffff88005bcc1c20)
[  222.322031] Stack:
[  222.322031]  ffff88005d2ee430 0000000000000002 ffff88005bc319e8 ffff88005d2e5c00
[  222.322031]  ffffffffa030a0b3 0000000000000002 ffff88005bed2c00 0000000000000008
[  222.322031]  ffff88005bc31a38 ffffffffa0307e40 ffff88005bdd76c0 ffff88005d2e5c00
[  222.322031] Call Trace:
[  222.322031]  [<ffffffffa0307e40>] mce_async_out+0x60/0x80 [mceusb]
[  222.322031]  [<ffffffffa03088ac>] mceusb_dev_probe+0x65c/0xcf0 [mceusb]
[  222.322031]  [<ffffffff8208f94d>] ? kstrdup+0x4d/0x70
[  222.322031]  [<ffffffff8210769e>] ? sysfs_addrm_finish+0x2e/0xc0
[  222.322031]  [<ffffffff822961a9>] usb_probe_interface+0x199/0x250
[  222.322031]  [<ffffffff8223dcc6>] driver_probe_device+0x76/0x230
[  222.322031]  [<ffffffff8223df1b>] __driver_attach+0x9b/0xa0
[  222.322031]  [<ffffffff8223de80>] ? driver_probe_device+0x230/0x230
[  222.322031]  [<ffffffff8223c055>] bus_for_each_dev+0x55/0x90
[  222.322031]  [<ffffffff8223d7d9>] driver_attach+0x19/0x20
[  222.322031]  [<ffffffff8223d35e>] bus_add_driver+0xfe/0x260
[  222.322031]  [<ffffffff8223e392>] driver_register+0x72/0x160
[  222.322031]  [<ffffffff82294bf8>] usb_register_driver+0x88/0x150
[  222.322031]  [<ffffffffa030c000>] ? 0xffffffffa030bfff
[  222.322031]  [<ffffffffa030c01e>] mceusb_dev_driver_init+0x1e/0x20 [mceusb]
[  222.322031]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  222.322031]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  222.322031]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  222.322031]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  222.322031]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  222.322031] Code: 00 00 49 63 d5 be d0 80 00 00 48 89 d7 48 89 55 c8 e8 e1 29 da e1 48 85 c0 48 8b 55 c8 0f 84 b4 00 00 00 48 8b 7b 28 4c 8b 43 18 <0f> b6 77 02 41 8b 08 c1 e1 08 c1 e6 0f 81 ce 00 00 00 40 09 ce 
[  222.322031] RIP  [<ffffffffa0307cf4>] mce_request_packet+0x134/0x220 [mceusb]
[  222.322031]  RSP <ffff88005bc319c8>
[  222.322031] CR2: 0000000000000002
[  222.326896] ---[ end trace 2b3dbd06de76ea94 ]---


lsusb -vvv:

Bus 004 Device 002: ID 0471:0613 Philips (or NXP) Infrared Transceiver
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x0471 Philips (or NXP)
  idProduct          0x0613 Infrared Transceiver
  bcdDevice            1.01
  iManufacturer           1 PHILIPS
  iProduct                2 MCE USB IR Receiver- Spinel plus
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.00
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength     427
          Report Descriptor: (length is 427)
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x06 ] 6
                            Keyboard
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x01 ] 1
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0xe0 ] 224
                            Control Left
            Item(Local ): Usage Maximum, data= [ 0xe7 ] 231
                            GUI Right
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x05 ] 5
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Usage Page, data= [ 0x08 ] 8
                            LEDs
            Item(Local ): Usage Minimum, data= [ 0x01 ] 1
                            NumLock
            Item(Local ): Usage Maximum, data= [ 0x05 ] 5
                            Kana
            Item(Main  ): Output, data= [ 0x02 ] 2
                            Data Variable Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x03 ] 3
            Item(Main  ): Output, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x06 ] 6
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x68 ] 104
            Item(Global): Usage Page, data= [ 0x07 ] 7
                            Keyboard
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            No Event
            Item(Local ): Usage Maximum, data= [ 0x68 ] 104
                            F13
            Item(Main  ): Input, data= [ 0x00 ] 0
                            Data Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage, data= [ 0x80 ] 128
                            System Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x04 ] 4
            Item(Global): Usage Page, data= [ 0x01 ] 1
                            Generic Desktop Controls
            Item(Local ): Usage Minimum, data= [ 0x81 ] 129
                            System Power Down
            Item(Local ): Usage Maximum, data= [ 0x83 ] 131
                            System Wake Up
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x03 ] 3
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Main  ): Input, data= [ 0x06 ] 6
                            Data Variable Relative No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Report Count, data= [ 0x01 ] 1
            Item(Global): Report Size, data= [ 0x05 ] 5
            Item(Main  ): Input, data= [ 0x01 ] 1
                            Constant Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x0c ] 12
                            Consumer
            Item(Local ): Usage, data= [ 0x01 ] 1
                            Consumer Control
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x02 ] 2
            Item(Local ): Usage, data= [ 0xe2 0x00 ] 226
                            Mute
            Item(Local ): Usage, data= [ 0xe9 0x00 ] 233
                            Volume Increment
            Item(Local ): Usage, data= [ 0xea 0x00 ] 234
                            Volume Decrement
            Item(Local ): Usage, data= [ 0x9c 0x00 ] 156
                            Channel Increment
            Item(Local ): Usage, data= [ 0x9d 0x00 ] 157
                            Channel Decrement
            Item(Local ): Usage, data= [ 0xb5 0x00 ] 181
                            Scan Next Track
            Item(Local ): Usage, data= [ 0xb6 0x00 ] 182
                            Scan Previous Track
            Item(Local ): Usage, data= [ 0xb3 0x00 ] 179
                            Fast Forward
            Item(Local ): Usage, data= [ 0xb4 0x00 ] 180
                            Rewind
            Item(Local ): Usage, data= [ 0xb0 0x00 ] 176
                            Play
            Item(Local ): Usage, data= [ 0xb1 0x00 ] 177
                            Pause
            Item(Local ): Usage, data= [ 0xb7 0x00 ] 183
                            Stop
            Item(Local ): Usage, data= [ 0xb2 0x00 ] 178
                            Record
            Item(Local ): Usage, data= [ 0x8d 0x00 ] 141
                            Media Select Program Guide
            Item(Local ): Usage, data= [ 0x24 0x02 ] 548
                            AC Back
            Item(Local ): Usage, data= [ 0x08 0x02 ] 520
                            AC Print
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Local ): Usage, data= [ 0x09 0x02 ] 521
                            AC Properties
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x18 ] 24
            Item(Main  ): Input, data= [ 0x06 ] 6
                            Data Variable Relative No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0xbc 0xff ] 65468
                            (null)
            Item(Local ): Usage, data= [ 0x88 ] 136
                            (null)
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x03 ] 3
            Item(Local ): Usage, data= [ 0x42 0x00 ] 66
                            (null)
            Item(Local ): Usage, data= [ 0x41 0x00 ] 65
                            (null)
            Item(Local ): Usage, data= [ 0x4f 0x00 ] 79
                            (null)
            Item(Local ): Usage, data= [ 0x25 0x00 ] 37
                            (null)
            Item(Local ): Usage, data= [ 0x5a 0x00 ] 90
                            (null)
            Item(Local ): Usage, data= [ 0x2e 0x00 ] 46
                            (null)
            Item(Local ): Usage, data= [ 0x28 0x00 ] 40
                            (null)
            Item(Local ): Usage, data= [ 0x2b 0x00 ] 43
                            (null)
            Item(Local ): Usage, data= [ 0x4d 0x00 ] 77
                            (null)
            Item(Local ): Usage, data= [ 0x4c 0x00 ] 76
                            (null)
            Item(Local ): Usage, data= [ 0x50 0x00 ] 80
                            (null)
            Item(Local ): Usage, data= [ 0x2d 0x00 ] 45
                            (null)
            Item(Local ): Usage, data= [ 0x24 0x00 ] 36
                            (null)
            Item(Local ): Usage, data= [ 0x0d 0x00 ] 13
                            (null)
            Item(Local ): Usage, data= [ 0x5b 0x00 ] 91
                            (null)
            Item(Local ): Usage, data= [ 0x5c 0x00 ] 92
                            (null)
            Item(Local ): Usage, data= [ 0x5d 0x00 ] 93
                            (null)
            Item(Local ): Usage, data= [ 0x5e 0x00 ] 94
                            (null)
            Item(Local ): Usage, data= [ 0x3e 0x00 ] 62
                            (null)
            Item(Local ): Usage, data= [ 0x3f 0x00 ] 63
                            (null)
            Item(Local ): Usage, data= [ 0x40 0x00 ] 64
                            (null)
            Item(Local ): Usage, data= [ 0x31 0x00 ] 49
                            (null)
            Item(Local ): Usage, data= [ 0x4b 0x00 ] 75
                            (null)
            Item(Local ): Usage, data= [ 0x47 0x00 ] 71
                            (null)
            Item(Local ): Usage, data= [ 0x49 0x00 ] 73
                            (null)
            Item(Local ): Usage, data= [ 0x6a 0x00 ] 106
                            (null)
            Item(Local ): Usage, data= [ 0x2c 0x00 ] 44
                            (null)
            Item(Local ): Usage, data= [ 0x44 0x00 ] 68
                            (null)
            Item(Local ): Usage, data= [ 0x81 0x00 ] 129
                            (null)
            Item(Local ): Usage, data= [ 0x6f 0x00 ] 111
                            (null)
            Item(Local ): Usage, data= [ 0x48 0x00 ] 72
                            (null)
            Item(Local ): Usage, data= [ 0x4a 0x00 ] 74
                            (null)
            Item(Local ): Usage, data= [ 0x3c 0x00 ] 60
                            (null)
            Item(Local ): Usage, data= [ 0x3d 0x00 ] 61
                            (null)
            Item(Local ): Usage, data= [ 0x32 0x00 ] 50
                            (null)
            Item(Local ): Usage, data= [ 0x33 0x00 ] 51
                            (null)
            Item(Local ): Usage, data= [ 0x34 0x00 ] 52
                            (null)
            Item(Local ): Usage, data= [ 0x35 0x00 ] 53
                            (null)
            Item(Local ): Usage, data= [ 0x36 0x00 ] 54
                            (null)
            Item(Local ): Usage, data= [ 0x37 0x00 ] 55
                            (null)
            Item(Local ): Usage, data= [ 0x38 0x00 ] 56
                            (null)
            Item(Local ): Usage, data= [ 0x39 0x00 ] 57
                            (null)
            Item(Local ): Usage, data= [ 0x3a 0x00 ] 58
                            (null)
            Item(Local ): Usage, data= [ 0x80 0x00 ] 128
                            (null)
            Item(Local ): Usage, data= [ 0x52 0x00 ] 82
                            (null)
            Item(Local ): Usage, data= [ 0x53 0x00 ] 83
                            (null)
            Item(Local ): Usage, data= [ 0x54 0x00 ] 84
                            (null)
            Item(Local ): Usage, data= [ 0x55 0x00 ] 85
                            (null)
            Item(Local ): Usage, data= [ 0x56 0x00 ] 86
                            (null)
            Item(Local ): Usage, data= [ 0x58 0x00 ] 88
                            (null)
            Item(Local ): Usage, data= [ 0x57 0x00 ] 87
                            (null)
            Item(Local ): Usage, data= [ 0x59 0x00 ] 89
                            (null)
            Item(Local ): Usage, data= [ 0x51 0x00 ] 81
                            (null)
            Item(Local ): Usage, data= [ 0x30 0x00 ] 48
                            (null)
            Item(Local ): Usage, data= [ 0x2f 0x00 ] 47
                            (null)
            Item(Local ): Usage, data= [ 0x27 0x00 ] 39
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Local ): Usage, data= [ 0x78 0x00 ] 120
                            (null)
            Item(Global): Report Size, data= [ 0x01 ] 1
            Item(Global): Report Count, data= [ 0x40 ] 64
            Item(Main  ): Input, data= [ 0x06 ] 6
                            Data Variable Relative No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0x01 ] 1
            Item(Main  ): End Collection, data=none
            Item(Global): Usage Page, data= [ 0x00 0xff ] 65280
                            (null)
            Item(Local ): Usage, data= [ 0x00 ] 0
                            (null)
            Item(Main  ): Collection, data= [ 0x01 ] 1
                            Application
            Item(Global): Report ID, data= [ 0x05 ] 5
            Item(Local ): Usage, data= [ 0x00 ] 0
                            (null)
            Item(Local ): Usage Minimum, data= [ 0x00 ] 0
                            (null)
            Item(Local ): Usage Maximum, data= [ 0xff 0x00 ] 255
                            (null)
            Item(Global): Logical Minimum, data= [ 0x00 ] 0
            Item(Global): Logical Maximum, data= [ 0xff 0x00 ] 255
            Item(Global): Report Size, data= [ 0x08 ] 8
            Item(Global): Report Count, data= [ 0x05 ] 5
            Item(Main  ): Input, data= [ 0x00 ] 0
                            Data Array Absolute No_Wrap Linear
                            Preferred_State No_Null_Position Non_Volatile Bitfield
            Item(Main  ): End Collection, data=none
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0002
  (Bus Powered)
  Remote Wakeup Enabled

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.09
  iManufacturer           3 Linux 3.9.0-rc4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:02.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            3.09
  iManufacturer           3 Linux 3.9.0-rc4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:04.1
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.09
  iManufacturer           3 Linux 3.9.0-rc4 ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:02.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0001 1.1 root hub
  bcdDevice            3.09
  iManufacturer           3 Linux 3.9.0-rc4 ohci_hcd
  iProduct                2 OHCI Host Controller
  iSerial                 1 0000:00:04.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x0012
    No power switching (usb 1.0)
    No overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0100 power
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0303 lowspeed power enable connect
   Port 6: 0000.0100 power
Device Status:     0x0001
  Self Powered


