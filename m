Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3CYTda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 15:33:30 -0400
From: Sebastian Frei <sebastian@familie-frei.net>
To: linux-media@vger.kernel.org
Subject: Problem when unloading cx88_dvb (DVB devices are not freed)
Date: Mon, 25 Mar 2013 20:33:32 +0100
Message-ID: <9345987.7rqyBpTRI7@nop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello *,

I have a problem when unloading the drivers for a Hauppauge HVR4000 card:
Somehow the DVB device are not freed, udev does not remove the device files and 
modprobe complains when I load the modules again.
The device works though.

Below is the output of dmesg.
At 118 seconds I unload all media related modules with a very long rmmod 
command.
At 178 seconds I load the cx88_dvb module via modprobe.

Best regards
Sebastian

dmesg:
[    0.000000] Linux version 3.9.0-rc4 (root@VDR-SF) (gcc version 4.7.2 (GCC) 
) #29 SMP PREEMPT Mon Mar 25 19:43:35 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda1 rw 
rootfstype=ext4 modprobe.blacklist=cx8800 modprobe.blacklist=mceusb quiet 
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
rootfstype=ext4 modprobe.blacklist=cx8800 modprobe.blacklist=mceusb quiet 
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
[    0.000000] tsc: Detected 2999.962 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.003336] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6002.92 BogoMIPS (lpj=9999873)
[    0.003338] pid_max: default: 32768 minimum: 301
[    0.003366] Mount-cache hash table entries: 256
[    0.003535] tseg: 0000000000
[    0.003541] CPU: Physical Processor ID: 0
[    0.003542] CPU: Processor Core ID: 0
[    0.003543] mce: CPU supports 5 MCE banks
[    0.003550] LVT offset 0 assigned for vector 0xf9
[    0.003553] process: using AMD E400 aware idle routine
[    0.003555] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
tlb_flushall_shift: 4
[    0.003596] Freeing SMP alternatives: 16k freed
[    0.003607] ACPI: Core revision 20130117
[    0.006975] ACPI: All ACPI Tables successfully acquired
[    0.008093] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041102] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ 
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
[    0.053469] smpboot: Booting Node   0, Processors  #1 OK
[    0.006666] process: Switch to broadcast mode on CPU1
[    0.146737] Brought up 2 CPUs
[    0.146739] smpboot: Total of 2 processors activated (12004.80 BogoMIPS)
[    0.147293] devtmpfs: initialized
[    0.147293] NET: Registered protocol family 16
[    0.147293] node 0 link 0: io port [1000, ffffff]
[    0.147293] node 0 link 0: io port [1000, 1fff]
[    0.147293] TOM: 0000000080000000 aka 2048M
[    0.147293] node 0 link 0: mmio [e0000000, efffffff]
[    0.147293] node 0 link 0: mmio [a0000, bffff]
[    0.147293] node 0 link 0: mmio [80000000, fe0bffff]
[    0.147293] bus: [bus 00-07] on node 0 link 0
[    0.147293] bus: 00 [io  0x0000-0xffff]
[    0.147293] bus: 00 [mem 0x80000000-0xfcffffffff]
[    0.147293] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.147293] ACPI: bus type PCI registered
[    0.147293] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.147294] PCI: not using MMCONFIG
[    0.147295] PCI: Using configuration type 1 for base access
[    0.147351] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.147352] mtrr: probably your BIOS does not setup all CPUs.
[    0.147353] mtrr: corrected configuration.
[    0.147706] bio: create slab <bio-0> at 0
[    0.147706] ACPI: Added _OSI(Module Device)
[    0.147706] ACPI: Added _OSI(Processor Device)
[    0.147706] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.147706] ACPI: Added _OSI(Processor Aggregator Device)
[    0.147706] ACPI: EC: Look up EC in DSDT
[    0.150844] ACPI: Executed 1 blocks of module-level executable AML code
[    0.153773] ACPI: Interpreter enabled
[    0.153777] ACPI: (supports S0 S5)
[    0.153778] ACPI: Using IOAPIC for interrupt routing
[    0.153792] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.154735] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI 
motherboard resources
[    0.162214] PCI: Using host bridge windows from ACPI; if necessary, use 
"pci=nocrs" and report a bug
[    0.169317] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.169472] acpi PNP0A03:00: Requesting ACPI _OSC control (0x15)
[    0.169603] acpi PNP0A03:00: ACPI _OSC request failed (AE_SUPPORT), 
returned control mask: 0x04
[    0.169738] PCI host bridge to bus 0000:00
[    0.169741] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.169743] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.169745] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.169747] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.169749] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.169751] pci_bus 0000:00: root bus resource [mem 0x80000000-0xdfffffff]
[    0.169753] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff]
[    0.169787] pci 0000:00:00.0: [10de:0754] type 00 class 0x050000
[    0.170097] pci 0000:00:01.0: [10de:075c] type 00 class 0x060100
[    0.170104] pci 0000:00:01.0: reg 10: [io  0x0900-0x09ff]
[    0.170156] pci 0000:00:01.1: [10de:0752] type 00 class 0x0c0500
[    0.170167] pci 0000:00:01.1: reg 10: [io  0x0e00-0x0e3f]
[    0.170182] pci 0000:00:01.1: reg 20: [io  0x0600-0x063f]
[    0.170187] pci 0000:00:01.1: reg 24: [io  0x0700-0x073f]
[    0.170216] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.170249] pci 0000:00:01.2: [10de:0751] type 00 class 0x050000
[    0.170333] pci 0000:00:01.3: [10de:0753] type 00 class 0x0b4000
[    0.170349] pci 0000:00:01.3: reg 10: [mem 0xf8e80000-0xf8efffff]
[    0.170496] pci 0000:00:01.4: [10de:0568] type 00 class 0x050000
[    0.170584] pci 0000:00:02.0: [10de:077b] type 00 class 0x0c0310
[    0.170593] pci 0000:00:02.0: reg 10: [mem 0xf8e7e000-0xf8e7efff]
[    0.170626] pci 0000:00:02.0: supports D1 D2
[    0.170628] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170661] pci 0000:00:02.1: [10de:077c] type 00 class 0x0c0320
[    0.170672] pci 0000:00:02.1: reg 10: [mem 0xf8e7fc00-0xf8e7fcff]
[    0.170712] pci 0000:00:02.1: supports D1 D2
[    0.170714] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170756] pci 0000:00:04.0: [10de:077d] type 00 class 0x0c0310
[    0.170764] pci 0000:00:04.0: reg 10: [mem 0xf8e7d000-0xf8e7dfff]
[    0.170798] pci 0000:00:04.0: supports D1 D2
[    0.170800] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170833] pci 0000:00:04.1: [10de:077e] type 00 class 0x0c0320
[    0.170843] pci 0000:00:04.1: reg 10: [mem 0xf8e7f800-0xf8e7f8ff]
[    0.170884] pci 0000:00:04.1: supports D1 D2
[    0.170886] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.170927] pci 0000:00:06.0: [10de:0759] type 00 class 0x01018a
[    0.170948] pci 0000:00:06.0: reg 20: [io  0xffa0-0xffaf]
[    0.171019] pci 0000:00:07.0: [10de:0774] type 00 class 0x040300
[    0.171029] pci 0000:00:07.0: reg 10: [mem 0xf8e78000-0xf8e7bfff]
[    0.171071] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.171111] pci 0000:00:08.0: [10de:075a] type 01 class 0x060401
[    0.171177] pci 0000:00:09.0: [10de:0ad4] type 00 class 0x010601
[    0.171185] pci 0000:00:09.0: reg 10: [io  0xd480-0xd487]
[    0.171189] pci 0000:00:09.0: reg 14: [io  0xd400-0xd403]
[    0.171193] pci 0000:00:09.0: reg 18: [io  0xd080-0xd087]
[    0.171198] pci 0000:00:09.0: reg 1c: [io  0xd000-0xd003]
[    0.171202] pci 0000:00:09.0: reg 20: [io  0xcc00-0xcc0f]
[    0.171206] pci 0000:00:09.0: reg 24: [mem 0xf8e76000-0xf8e77fff]
[    0.171262] pci 0000:00:0a.0: [10de:0760] type 00 class 0x020000
[    0.171271] pci 0000:00:0a.0: reg 10: [mem 0xf8e7c000-0xf8e7cfff]
[    0.171276] pci 0000:00:0a.0: reg 14: [io  0xc880-0xc887]
[    0.171280] pci 0000:00:0a.0: reg 18: [mem 0xf8e7f400-0xf8e7f4ff]
[    0.171284] pci 0000:00:0a.0: reg 1c: [mem 0xf8e7f000-0xf8e7f00f]
[    0.171314] pci 0000:00:0a.0: supports D1 D2
[    0.171316] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171352] pci 0000:00:0b.0: [10de:0569] type 01 class 0x060400
[    0.171377] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171460] pci 0000:00:10.0: [10de:0778] type 01 class 0x060400
[    0.171683] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.171806] pci 0000:00:12.0: [10de:075b] type 01 class 0x060400
[    0.172028] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.172111] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.172155] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.172203] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.172245] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.172332] pci 0000:01:06.0: [14f1:8800] type 00 class 0x040000
[    0.172346] pci 0000:01:06.0: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.172430] pci 0000:01:06.1: [14f1:8811] type 00 class 0x048000
[    0.172441] pci 0000:01:06.1: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.172516] pci 0000:01:06.2: [14f1:8802] type 00 class 0x048000
[    0.172527] pci 0000:01:06.2: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.172602] pci 0000:01:06.4: [14f1:8804] type 00 class 0x048000
[    0.172614] pci 0000:01:06.4: reg 10: [mem 0xfc000000-0xfcffffff]
[    0.172689] pci 0000:01:07.0: [1131:7146] type 00 class 0x048000
[    0.172699] pci 0000:01:07.0: reg 10: [mem 0xf8fffc00-0xf8fffdff]
[    0.172773] pci 0000:00:08.0: PCI bridge to [bus 01] (subtractive decode)
[    0.172777] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.172780] pci 0000:00:08.0:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.172782] pci 0000:00:08.0:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.172784] pci 0000:00:08.0:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.172786] pci 0000:00:08.0:   bridge window [mem 0x000d0000-0x000dffff] 
(subtractive decode)
[    0.172788] pci 0000:00:08.0:   bridge window [mem 0x80000000-0xdfffffff] 
(subtractive decode)
[    0.172790] pci 0000:00:08.0:   bridge window [mem 0xf0000000-0xfebfffff] 
(subtractive decode)
[    0.172819] pci 0000:02:00.0: [10de:0848] type 00 class 0x030000
[    0.172826] pci 0000:02:00.0: reg 10: [mem 0xfd000000-0xfdffffff]
[    0.172832] pci 0000:02:00.0: reg 14: [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.172838] pci 0000:02:00.0: reg 1c: [mem 0xd6000000-0xd7ffffff 64bit pref]
[    0.172842] pci 0000:02:00.0: reg 24: [io  0xec00-0xec7f]
[    0.172846] pci 0000:02:00.0: reg 30: [mem 0xfeae0000-0xfeafffff pref]
[    0.172891] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.172894] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.172897] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.172900] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit 
pref]
[    0.173059] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.173251] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.173308] pci_bus 0000:00: on NUMA node 0
[    0.173310] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.174089] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.174170] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *11
[    0.174249] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174327] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174406] ACPI: PCI Interrupt Link [LN0A] (IRQs 16 17 18 19) *10
[    0.174484] ACPI: PCI Interrupt Link [LN0B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174562] ACPI: PCI Interrupt Link [LN0C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174640] ACPI: PCI Interrupt Link [LN0D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174719] ACPI: PCI Interrupt Link [LN1A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174798] ACPI: PCI Interrupt Link [LN1B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174876] ACPI: PCI Interrupt Link [LN1C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.174954] ACPI: PCI Interrupt Link [LN1D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175034] ACPI: PCI Interrupt Link [LN2A] (IRQs 16 17 18 19) *11
[    0.175111] ACPI: PCI Interrupt Link [LN2B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175190] ACPI: PCI Interrupt Link [LN2C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175268] ACPI: PCI Interrupt Link [LN2D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175348] ACPI: PCI Interrupt Link [LN3A] (IRQs 16 17 18 19) *15
[    0.175426] ACPI: PCI Interrupt Link [LN3B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175504] ACPI: PCI Interrupt Link [LN3C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175582] ACPI: PCI Interrupt Link [LN3D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175660] ACPI: PCI Interrupt Link [LN4A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175739] ACPI: PCI Interrupt Link [LN4B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175817] ACPI: PCI Interrupt Link [LN4C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175895] ACPI: PCI Interrupt Link [LN4D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.175973] ACPI: PCI Interrupt Link [LN5A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176052] ACPI: PCI Interrupt Link [LN5B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176131] ACPI: PCI Interrupt Link [LN5C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176209] ACPI: PCI Interrupt Link [LN5D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176287] ACPI: PCI Interrupt Link [LN6A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176366] ACPI: PCI Interrupt Link [LN6B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176444] ACPI: PCI Interrupt Link [LN6C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176522] ACPI: PCI Interrupt Link [LN6D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176600] ACPI: PCI Interrupt Link [LN7A] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176685] ACPI: PCI Interrupt Link [LN7B] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176763] ACPI: PCI Interrupt Link [LN7C] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176841] ACPI: PCI Interrupt Link [LN7D] (IRQs 16 17 18 19) *0, 
disabled.
[    0.176920] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    0.177000] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *15
[    0.177079] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *10
[    0.177158] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *15
[    0.177235] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *0, 
disabled.
[    0.177315] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.177394] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *10
[    0.177473] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.177560] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, 
disabled.
[    0.177639] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *11
[    0.177718] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *10
[    0.177782] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.177885] acpi root: \_SB_.PCI0 notify handler is installed
[    0.177924] Found 1 acpi root devices
[    0.178004] SCSI subsystem initialized
[    0.178006] ACPI: bus type ATA registered
[    0.178024] libata version 3.00 loaded.
[    0.178024] ACPI: bus type USB registered
[    0.178024] usbcore: registered new interface driver usbfs
[    0.178024] usbcore: registered new interface driver hub
[    0.178024] usbcore: registered new device driver usb
[    0.178024] Advanced Linux Sound Architecture Driver Initialized.
[    0.178024] PCI: Using ACPI for IRQ routing
[    0.184453] PCI: pci_cache_line_size set to 64 bytes
[    0.184505] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.184507] e820: reserve RAM buffer [mem 0x5ff90000-0x5fffffff]
[    0.184618] HPET: 3 timers in total, 0 timers will be used for per-cpu 
timer
[    0.184623] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.184626] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.200019] Switching to clocksource hpet
[    0.200065] pnp: PnP ACPI init
[    0.200071] ACPI: bus type PNP registered
[    0.200101] pnp 00:00: [dma 4]
[    0.200118] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.200137] pnp 00:01: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.200165] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.200780] pnp 00:03: [dma 3]
[    0.200943] pnp 00:03: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.201195] pnp 00:04: disabling [io  0x0900-0x097f] because it overlaps 
0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201197] pnp 00:04: disabling [io  0x0980-0x09ff] because it overlaps 
0000:00:01.0 BAR 0 [io  0x0900-0x09ff]
[    0.201245] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.201247] system 00:04: [io  0x0800-0x080f] has been reserved
[    0.201250] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.201252] system 00:04: [io  0x0580-0x05ff] has been reserved
[    0.201254] system 00:04: [io  0x0800-0x087f] could not be reserved
[    0.201256] system 00:04: [io  0x0880-0x08ff] has been reserved
[    0.201259] system 00:04: [io  0x0d00-0x0d7f] has been reserved
[    0.201261] system 00:04: [io  0x0d80-0x0dff] has been reserved
[    0.201265] system 00:04: [mem 0x000d0000-0x000d3fff window] has been 
reserved
[    0.201267] system 00:04: [mem 0x000d4000-0x000d7fff window] has been 
reserved
[    0.201269] system 00:04: [mem 0x000de000-0x000dffff window] has been 
reserved
[    0.201272] system 00:04: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.201274] system 00:04: [mem 0xfee01000-0xfeefffff] has been reserved
[    0.201277] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201372] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.201399] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.201490] system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.201493] system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.201495] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201657] system 00:08: [io  0x0230-0x023f] has been reserved
[    0.201660] system 00:08: [io  0x0290-0x029f] has been reserved
[    0.201662] system 00:08: [io  0x0a00-0x0a0f] has been reserved
[    0.201664] system 00:08: [io  0x0a10-0x0a1f] has been reserved
[    0.201667] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.201869] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.201871] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.202016] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.202019] system 00:0a: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.202021] system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.202023] system 00:0a: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.202026] system 00:0a: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.202029] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.202516] pnp: PnP ACPI: found 11 devices
[    0.202517] ACPI: bus type PNP unregistered
[    0.208953] pci 0000:00:08.0: PCI bridge to [bus 01]
[    0.208957] pci 0000:00:08.0:   bridge window [mem 0xf8f00000-0xfcffffff]
[    0.208962] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    0.208964] pci 0000:00:0b.0:   bridge window [io  0xe000-0xefff]
[    0.208967] pci 0000:00:0b.0:   bridge window [mem 0xfd000000-0xfeafffff]
[    0.208970] pci 0000:00:0b.0:   bridge window [mem 0xd6000000-0xdfffffff 64bit 
pref]
[    0.208973] pci 0000:00:10.0: PCI bridge to [bus 03]
[    0.208997] pci 0000:00:12.0: PCI bridge to [bus 04]
[    0.209027] pci 0000:00:08.0: setting latency timer to 64
[    0.209031] pci 0000:00:0b.0: setting latency timer to 64
[    0.209216] ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
[    0.209393] ACPI: PCI Interrupt Link [LN2A] enabled at IRQ 18
[    0.209405] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.209407] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.209409] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.209411] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.209413] pci_bus 0000:00: resource 8 [mem 0x80000000-0xdfffffff]
[    0.209415] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
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
[    0.209793] TCP: Hash tables configured (established 16384 bind 16384)
[    0.209859] TCP: reno registered
[    0.209862] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209879] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.209928] NET: Registered protocol family 1
[    0.210206] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    0.210452] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    0.210687] ACPI: PCI Interrupt Link [UB11] enabled at IRQ 21
[    0.210918] ACPI: PCI Interrupt Link [UB12] enabled at IRQ 20
[    0.211082] pci 0000:00:07.0: Enabling HT MSI Mapping
[    0.211178] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.211277] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.211383] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.211487] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.211618] pci 0000:02:00.0: Boot video device
[    0.211620] PCI: CLS 64 bytes, default 64
[    0.213002] fuse init (API version 7.21)
[    0.213077] msgmni has been set to 3001
[    0.213293] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.213295] io scheduler noop registered
[    0.213296] io scheduler deadline registered (default)
[    0.213641] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.213645] ACPI: Power Button [PWRB]
[    0.213686] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.213688] ACPI: Power Button [PWRF]
[    0.213717] ACPI: processor limited to max C-state 1
[    0.216635] ppdev: user-space parallel port driver
[    0.216648] [drm] Initialized drm 1.1.0 20060810
[    0.216688] parport_pc 00:03: reported by Plug and Play ACPI
[    0.216753] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    0.296890] ahci 0000:00:09.0: version 3.0
[    0.297077] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    0.297119] ahci 0000:00:09.0: irq 40 for MSI/MSI-X
[    0.297127] ahci 0000:00:09.0: controller can't do PMP, turning off CAP_PMP
[    0.297188] ahci 0000:00:09.0: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode
[    0.297191] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pio boh 
[    0.297194] ahci 0000:00:09.0: setting latency timer to 64
[    0.297868] scsi0 : ahci
[    0.297955] scsi1 : ahci
[    0.298021] scsi2 : ahci
[    0.298083] scsi3 : ahci
[    0.298144] scsi4 : ahci
[    0.298205] scsi5 : ahci
[    0.298235] ata1: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76100 
irq 40
[    0.298237] ata2: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76180 
irq 40
[    0.298239] ata3: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76200 
irq 40
[    0.298241] ata4: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76280 
irq 40
[    0.298242] ata5: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76300 
irq 40
[    0.298244] ata6: SATA max UDMA/133 abar m8192@0xf8e76000 port 0xf8e76380 
irq 40
[    0.298306] pata_amd 0000:00:06.0: version 0.4.1
[    0.298340] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.298533] scsi6 : pata_amd
[    0.298763] scsi7 : pata_amd
[    0.298922] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.298924] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.298955] forcedeth: Reverse Engineered nForce ethernet driver. Version 
0.64.
[    0.299156] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
[    0.299162] forcedeth 0000:00:0a.0: setting latency timer to 64
[    0.357641] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 3, addr 
00:26:18:77:ed:11
[    0.357644] forcedeth 0000:00:0a.0: highdma csum pwrctl mgmt gbit lnktim 
msi desc-v3
[    0.357657] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.357658] ehci-pci: EHCI PCI platform driver
[    0.357734] ehci-pci 0000:00:02.1: setting latency timer to 64
[    0.357737] ehci-pci 0000:00:02.1: EHCI Host Controller
[    0.357743] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus 
number 1
[    0.357751] ehci-pci 0000:00:02.1: debug port 1
[    0.357769] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    0.357790] ehci-pci 0000:00:02.1: irq 22, io mem 0xf8e7fc00
[    0.366692] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    0.366809] hub 1-0:1.0: USB hub found
[    0.366813] hub 1-0:1.0: 6 ports detected
[    0.366947] ehci-pci 0000:00:04.1: setting latency timer to 64
[    0.366949] ehci-pci 0000:00:04.1: EHCI Host Controller
[    0.366953] ehci-pci 0000:00:04.1: new USB bus registered, assigned bus 
number 2
[    0.366960] ehci-pci 0000:00:04.1: debug port 1
[    0.366977] ehci-pci 0000:00:04.1: cache line size of 64 is not supported
[    0.366992] ehci-pci 0000:00:04.1: irq 20, io mem 0xf8e7f800
[    0.376690] ehci-pci 0000:00:04.1: USB 2.0 started, EHCI 1.00
[    0.376769] hub 2-0:1.0: USB hub found
[    0.376771] hub 2-0:1.0: 6 ports detected
[    0.376839] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.376908] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    0.376910] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    0.376914] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus 
number 3
[    0.376934] ohci_hcd 0000:00:02.0: irq 23, io mem 0xf8e7e000
[    0.432100] hub 3-0:1.0: USB hub found
[    0.432104] hub 3-0:1.0: 6 ports detected
[    0.432227] ohci_hcd 0000:00:04.0: setting latency timer to 64
[    0.432229] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    0.432234] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus 
number 4
[    0.432255] ohci_hcd 0000:00:04.0: irq 21, io mem 0xf8e7d000
[    0.450177] ata7.01: NODEV after polling detection
[    0.457230] ata7.00: ATAPI: BENQ    DVD DD DW1620, B7W9, max UDMA/33
[    0.457235] ata7: nv_mode_filter: 0x739f&0xfffff->0x739f, BIOS=0x0 (0x0) 
ACPI=0x0 (900:900:0x10)
[    0.470636] ata7.00: configured for UDMA/33
[    0.485436] hub 4-0:1.0: USB hub found
[    0.485440] hub 4-0:1.0: 6 ports detected
[    0.485529] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.485934] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.485937] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.486023] rtc_cmos 00:06: RTC can wake from S4
[    0.486257] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.486311] rtc_cmos 00:06: alarms up to one year, y3k, 114 bytes nvram, 
hpet irqs
[    0.486437] k8temp 0000:00:18.3: Temperature readouts might be wrong - 
check erratum #141
[    0.486455] cpuidle: using governor ladder
[    0.486457] cpuidle: using governor menu
[    0.486479] usbcore: registered new interface driver usbhid
[    0.486480] usbhid: USB HID core driver
[    0.486552] TCP: cubic registered
[    0.487272] powernow-k8: fid 0x16 (3000 MHz), vid 0xc
[    0.487274] powernow-k8: fid 0x14 (2800 MHz), vid 0xe
[    0.487275] powernow-k8: fid 0x12 (2600 MHz), vid 0x10
[    0.487276] powernow-k8: fid 0x10 (2400 MHz), vid 0x10
[    0.487277] powernow-k8: fid 0xe (2200 MHz), vid 0x10
[    0.487278] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    0.487279] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    0.487280] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    0.487320] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 
6000+ (2 cpu cores) (version 2.20.00)
[    0.487341] ALSA device list:
[    0.487342]   No soundcards found.
[    0.616712] ata6: SATA link down (SStatus 0 SControl 300)
[    0.616739] ata3: SATA link down (SStatus 0 SControl 300)
[    0.616761] ata4: SATA link down (SStatus 0 SControl 300)
[    0.616778] ata5: SATA link down (SStatus 0 SControl 300)
[    0.616798] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.616819] ata2: SATA link down (SStatus 0 SControl 300)
[    0.617503] ata1.00: ATA-8: WDC WD6400AAKS-65A7B2, 01.03B01, max UDMA/133
[    0.617509] ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.618247] ata1.00: configured for UDMA/133
[    0.618518] scsi 0:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-6 01.0 
PQ: 0 ANSI: 5
[    0.618750] sd 0:0:0:0: [sda] 1250263728 512-byte logical blocks: (640 
GB/596 GiB)
[    0.618905] sd 0:0:0:0: [sda] Write Protect is off
[    0.618912] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.618941] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    0.621016] scsi 6:0:0:0: CD-ROM            BENQ     DVD DD DW1620    B7W9 
PQ: 0 ANSI: 5
[    0.624345] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    0.624438] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.624596] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    0.624815] ata8: port disabled--ignoring
[    0.655890]  sda: sda1
[    0.656180] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.699855] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: 
(null)
[    0.699894] VFS: Mounted root (ext4 filesystem) on device 8:1.
[    0.750692] devtmpfs: mounted
[    0.752222] Freeing unused kernel memory: 592k freed
[    0.752821] Write protecting the kernel read-only data: 6144k
[    0.756336] Freeing unused kernel memory: 536k freed
[    0.760559] Freeing unused kernel memory: 600k freed
[    1.511943] systemd-udevd[66]: starting version 197
[    1.609185] forcedeth 0000:00:0a.0: irq 41 for MSI/MSI-X
[    1.609254] forcedeth 0000:00:0a.0 eth0: MSI enabled
[    1.609532] forcedeth 0000:00:0a.0 eth0: no link during initialization
[    1.925811] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    1.925826] hda_intel: Disabling MSI
[    1.925877] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[    1.966006] Linux video capture interface: v2.00
[    2.008314] forcedeth 0000:00:0a.0 eth0: link up
[    2.071102] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    2.073034] cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[    2.073038] cx88[0]: TV tuner type 63, Radio tuner type -1
[    2.086559] saa7146: register extension 'budget dvb'
[    2.188825] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 
tuner
[    2.766967] tda9887 0-0043: creating new instance
[    2.766977] tda9887 0-0043: tda988[5/6/7] found
[    2.767807] tuner 0-0043: Tuner 74 found with type(s) Radio TV.
[    2.770711] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[    2.811633] tveeprom 0-0050: Hauppauge model 69009, rev B2D3, serial# 
2931872
[    2.811640] tveeprom 0-0050: MAC address is 00:0d:fe:2c:bc:a0
[    2.811645] tveeprom 0-0050: tuner model is Philips FMD1216MEX (idx 133, 
type 78)
[    2.811651] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.811656] tveeprom 0-0050: audio processor is CX882 (idx 33)
[    2.811660] tveeprom 0-0050: decoder processor is CX882 (idx 25)
[    2.811664] tveeprom 0-0050: has radio, has IR receiver, has no IR 
transmitter
[    2.811668] cx88[0]: hauppauge eeprom: model=69009
[    2.821417] tuner-simple 0-0061: creating new instance
[    2.821428] tuner-simple 0-0061: type set to 78 (Philips FMD1216MEX MK3 
Hybrid Tuner)
[    2.916696] Registered IR keymap rc-hauppauge
[    2.916936] input: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0/input2
[    2.917091] rc0: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0
[    2.919269] cx88[0]/2: cx2388x 8802 Driver Manager
[    2.919907] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 17
[    2.919950] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 17, latency: 64, 
mmio: 0xfb000000
[    2.920969] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 16
[    2.921054] saa7146: found saa7146 @ mem ffffc9000000ac00 (revision 1, irq 
16) (0x13c2,0x1003)
[    2.921060] saa7146 (0): dma buffer size 192512
[    2.921145] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
[    2.940481] IR RC6 protocol handler initialized
[    2.951042] adapter has MAC addr = 00:d0:5c:1e:eb:d5
[    2.951790] IR RC5(x) protocol handler initialized
[    2.954055] DVB: Unable to find symbol ves1x93_attach()
[    2.956601] input: MCE IR Keyboard/Mouse (cx88xx) as 
/devices/virtual/input/input3
[    2.956853] IR MCE Keyboard/mouse protocol handler initialized
[    3.021511] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    3.021522] cx88/2: registering cx8802 driver, type: dvb access: shared
[    3.021529] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68]
[    3.021534] cx88[0]/2: cx2388x based DVB/ATSC card
[    3.021538] cx8802_alloc_frontends() allocating 2 frontend(s)
[    3.147025] tuner-simple 0-0061: attaching existing instance
[    3.147038] tuner-simple 0-0061: couldn't set type to 63. Using 78 (Philips 
FMD1216MEX MK3 Hybrid Tuner) instead
[    3.151477] DVB: registering new adapter (cx88[0])
[    3.151489] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 0 (Conexant CX24116/CX24118)...
[    3.153698] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 1 (Conexant CX22702 DVB-T)...
[    3.166912] budget dvb 0000:01:07.0: DVB: registering adapter 0 frontend 0 
(ST STV0299 DVB-S)...
[    4.821200] cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-
cx24116.fw)...
[    4.877434] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[   10.036332] cx24116_load_firmware: FW version 1.26.90.0
[   10.036348] cx24116_firmware_ondemand: Firmware upload complete
[  118.145574] cx88/2: unregistering cx8802 driver, type: dvb access: shared
[  118.145582] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68]
[  118.193438] tda9887 0-0043: destroying instance
[  118.193465] tuner-simple 0-0061: destroying instance
[  118.194207] saa7146: unregister extension 'budget dvb'
[  166.843811] saa7146: register extension 'budget dvb'
[  166.843958] saa7146: found saa7146 @ mem ffffc90000076c00 (revision 1, irq 
16) (0x13c2,0x1003)
[  166.843962] saa7146 (0): dma buffer size 192512
[  166.843988] DVB: registering new adapter (TT-Budget/WinTV-NOVA-S  PCI)
[  166.844963] adapter has MAC addr = 00:d0:5c:1e:eb:d5
[  166.846933] DVB: Unable to find symbol ves1x93_attach()
[  167.050204] budget dvb 0000:01:07.0: DVB: registering adapter 0 frontend 0 
(ST STV0299 DVB-S)...
[  178.506505] Linux video capture interface: v2.00
[  178.512347] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[  178.513459] cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[  178.513462] cx88[0]: TV tuner type 63, Radio tuner type -1
[  178.632109] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000 
tuner
[  178.642160] tda9887 1-0043: creating new instance
[  178.642166] tda9887 1-0043: tda988[5/6/7] found
[  178.642975] tuner 1-0043: Tuner 74 found with type(s) Radio TV.
[  178.644963] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
[  178.684113] tveeprom 1-0050: Hauppauge model 69009, rev B2D3, serial# 
2931872
[  178.684117] tveeprom 1-0050: MAC address is 00:0d:fe:2c:bc:a0
[  178.684120] tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx 133, 
type 78)
[  178.684123] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[  178.684126] tveeprom 1-0050: audio processor is CX882 (idx 33)
[  178.684128] tveeprom 1-0050: decoder processor is CX882 (idx 25)
[  178.684131] tveeprom 1-0050: has radio, has IR receiver, has no IR 
transmitter
[  178.684133] cx88[0]: hauppauge eeprom: model=69009
[  178.689391] tuner-simple 1-0061: creating new instance
[  178.689398] tuner-simple 1-0061: type set to 78 (Philips FMD1216MEX MK3 
Hybrid Tuner)
[  178.723336] Registered IR keymap rc-hauppauge
[  178.723460] input: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0/input4
[  178.723510] rc0: cx88 IR (Hauppauge WinTV-HVR400 as 
/devices/pci0000:00/0000:00:08.0/0000:01:06.2/rc/rc0
[  178.724716] IR RC5(x) protocol handler initialized
[  178.726222] cx88[0]/2: cx2388x 8802 Driver Manager
[  178.726349] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 17, latency: 64, 
mmio: 0xfb000000
[  178.727326] input: MCE IR Keyboard/Mouse (cx88xx) as 
/devices/virtual/input/input5
[  178.728008] IR MCE Keyboard/mouse protocol handler initialized
[  178.728343] IR RC6 protocol handler initialized
[  178.729029] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[  178.729036] cx88/2: registering cx8802 driver, type: dvb access: shared
[  178.729040] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 
DVB-S/S2/T/Hybrid [card=68]
[  178.729043] cx88[0]/2: cx2388x based DVB/ATSC card
[  178.729045] cx8802_alloc_frontends() allocating 2 frontend(s)
[  178.739377] tuner-simple 1-0061: attaching existing instance
[  178.739384] tuner-simple 1-0061: couldn't set type to 63. Using 78 (Philips 
FMD1216MEX MK3 Hybrid Tuner) instead
[  178.743314] DVB: registering new adapter (cx88[0])
[  178.743396] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 0 (Conexant CX24116/CX24118)...
[  178.743409] ------------[ cut here ]------------
[  178.743416] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.743419] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.743421] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.744001] Pid: 480, comm: modprobe Not tainted 3.9.0-rc4 #29
[  178.744025] Call Trace:
[  178.744049]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.744075]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.744102]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.744126]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.744150]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.744175]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.744200]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.744226]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.744253]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.744279]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.744357]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.744435]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.744513]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.744590]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.744668]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.744746]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.744830]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.744912]  [<ffffffff82045101>] ? __mutex_init+0x11/0x30
[  178.744993]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.745126]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.745263]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.745343]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.745422]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.745501]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.745579]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.745658]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.745736]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.745813]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.745891]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.745969]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.746046] ---[ end trace d2b70e7cf3a6025c ]---
[  178.746049] ------------[ cut here ]------------
[  178.746052] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.746055] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.746192] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747031] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747032] Call Trace:

[  178.747035]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0

[  178.747037]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50

[  178.747040]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0

[  178.747042]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0

[  178.747046]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0

[  178.747048]  [<ffffffff8223b131>] device_add+0xc1/0x660

[  178.747050]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747054]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747056]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747058]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747061]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747063]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747068]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747071]  [<ffffffff82045101>] ? __mutex_init+0x11/0x30
[  178.747077]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.747080]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.747084]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747087]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747090]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747092]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747096]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747098]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747101]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747103]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747106]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747108]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747109] ---[ end trace d2b70e7cf3a6025d ]---
[  178.747119] ------------[ cut here ]------------
[  178.747121] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.747122] sysfs: cannot create duplicate filename '/dev/char/212:67'
[  178.747138] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747139] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747140] Call Trace:
[  178.747142]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747145]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747147]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.747149]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.747152]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.747154]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.747156]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.747159]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.747161]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747163]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747166]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747168]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747170]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747173]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747177]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747181]  [<ffffffff82045101>] ? __mutex_init+0x11/0x30
[  178.747186]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.747189]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.747194]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747196]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747199]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747203]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747206]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747208]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747211]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747213]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747216]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747218]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747220] ---[ end trace d2b70e7cf3a6025e ]---
[  178.747239] dvb_register_device: failed to create device dvb1.frontend0 
(-17)
[  178.747456] ------------[ cut here ]------------
[  178.747459] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.747460] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.747476] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747478] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747479] Call Trace:
[  178.747481]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747484]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747486]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.747488]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.747490]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.747493]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.747496]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.747498]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.747501]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.747503]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.747506]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747508]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747511]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747513]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747515]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747518]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747523]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747529]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.747531]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.747536]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747538]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747542]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747544]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747547]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747549]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747552]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747554]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747557]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747560]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747561] ---[ end trace d2b70e7cf3a6025f ]---
[  178.747562] ------------[ cut here ]------------
[  178.747564] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.747565] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.747580] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747582] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747583] Call Trace:
[  178.747586]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747588]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747590]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0
[  178.747593]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.747596]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.747598]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.747600]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747603]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747605]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747607]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747610]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747612]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747617]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747622]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.747625]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.747629]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747631]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747635]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747637]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747640]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747643]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747645]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747647]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747650]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747653]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747654] ---[ end trace d2b70e7cf3a60260 ]---
[  178.747659] ------------[ cut here ]------------
[  178.747661] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.747662] sysfs: cannot create duplicate filename '/dev/char/212:68'
[  178.747677] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747678] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747678] Call Trace:
[  178.747681]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747683]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747686]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.747688]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.747690]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.747692]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.747694]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.747697]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.747699]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747701]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747704]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747706]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747708]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747711]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747715]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747721]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.747724]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.747728]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747730]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747734]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747736]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747739]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747742]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747744]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747747]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747751]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747753]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747754] ---[ end trace d2b70e7cf3a60261 ]---
[  178.747769] dvb_register_device: failed to create device dvb1.demux0 (-17)
[  178.747774] ------------[ cut here ]------------
[  178.747776] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.747777] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.747791] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747792] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747792] Call Trace:
[  178.747795]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747797]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747800]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.747802]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.747804]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.747806]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.747808]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.747810]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.747814]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.747816]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.747818]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747821]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747823]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747825]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747828]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747830]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.747835]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.747841]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.747843]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.747848]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.747850]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747854]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.747855]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.747859]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.747861]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.747864]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.747866]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.747869]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.747871]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.747872] ---[ end trace d2b70e7cf3a60262 ]---
[  178.747874] ------------[ cut here ]------------
[  178.747876] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.747877] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.747967] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.747969] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.747969] Call Trace:
[  178.747972]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.747974]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.747977]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0
[  178.747979]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.747983]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.747985]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.747987]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.747990]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.747992]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.747994]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.747997]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.747999]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748004]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748009]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.748012]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.748017]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748019]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748022]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748026]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748029]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748032]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748034]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748036]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748040]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748043]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748044] ---[ end trace d2b70e7cf3a60263 ]---
[  178.748050] ------------[ cut here ]------------
[  178.748052] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.748053] sysfs: cannot create duplicate filename '/dev/char/212:69'
[  178.748067] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748068] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748068] Call Trace:
[  178.748071]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748073]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748076]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.748078]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.748080]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.748082]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.748085]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.748087]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.748089]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748091]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748094]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748096]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748099]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748101]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748106]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748111]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.748115]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.748120]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748122]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748125]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748127]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748130]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748133]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748136]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748138]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748141]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748143]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748144] ---[ end trace d2b70e7cf3a60264 ]---
[  178.748158] dvb_register_device: failed to create device dvb1.dvr0 (-17)
[  178.748161] cx88-mpeg driver manager 0000:01:06.2: DVB: registering adapter 
1 frontend 1 (Conexant CX22702 DVB-T)...
[  178.748167] ------------[ cut here ]------------
[  178.748169] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.748170] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.748184] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748185] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748186] Call Trace:
[  178.748188]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748191]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748193]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.748195]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.748197]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.748199]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.748202]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.748204]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.748207]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.748209]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.748211]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748214]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748216]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748218]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748221]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748223]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748228]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748235]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.748237]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.748242]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748244]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748247]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748249]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748253]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748255]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748258]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748260]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748263]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748265]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748266] ---[ end trace d2b70e7cf3a60265 ]---
[  178.748268] ------------[ cut here ]------------
[  178.748270] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.748271] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.748359] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748360] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748361] Call Trace:
[  178.748364]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748366]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748369]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0
[  178.748371]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.748374]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.748377]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.748379]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748381]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748384]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748386]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748388]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748390]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748395]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748402]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.748405]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.748411]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748413]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748416]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748418]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748422]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748424]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748427]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748429]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748432]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748434]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748435] ---[ end trace d2b70e7cf3a60266 ]---
[  178.748441] ------------[ cut here ]------------
[  178.748443] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.748444] sysfs: cannot create duplicate filename '/dev/char/212:83'
[  178.748458] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748459] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748460] Call Trace:
[  178.748462]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748464]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748467]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.748469]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.748471]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.748473]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.748476]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.748478]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.748480]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748483]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748486]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748488]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748490]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748493]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748498]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748504]  [<ffffffffa018553b>] dvb_register_frontend+0x12b/0x190 [dvb_core]
[  178.748507]  [<ffffffffa025e2e4>] videobuf_dvb_register_bus+0xd4/0x3c0 
[videobuf_dvb]
[  178.748511]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748513]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748517]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748519]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748522]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748524]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748527]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748529]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748532]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748535]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748536] ---[ end trace d2b70e7cf3a60267 ]---
[  178.748549] dvb_register_device: failed to create device dvb1.frontend1 
(-17)
[  178.748742] ------------[ cut here ]------------
[  178.748745] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.748745] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.748760] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748762] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748762] Call Trace:
[  178.748765]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748767]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748770]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.748772]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.748774]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.748776]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.748778]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.748780]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.748784]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.748786]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.748788]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748791]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748793]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748795]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748798]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748800]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748805]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748811]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.748814]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.748818]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748821]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748824]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748826]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748829]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748832]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748834]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748837]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748840]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748842]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748843] ---[ end trace d2b70e7cf3a60268 ]---
[  178.748844] ------------[ cut here ]------------
[  178.748847] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.748847] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.748861] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748863] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748863] Call Trace:
[  178.748866]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748868]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748870]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0
[  178.748872]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.748876]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.748878]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.748880]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748884]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748886]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748888]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748891]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748893]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748898]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.748903]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.748906]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.748910]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.748913]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748916]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.748918]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.748921]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.748924]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.748926]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.748928]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.748932]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.748934]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.748935] ---[ end trace d2b70e7cf3a60269 ]---
[  178.748941] ------------[ cut here ]------------
[  178.748943] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.748944] sysfs: cannot create duplicate filename '/dev/char/212:84'
[  178.748957] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.748959] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.748959] Call Trace:
[  178.748962]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.748964]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.748966]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.748968]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.748971]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.748973]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.748975]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.748977]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.748980]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.748982]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.748984]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.748986]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.748989]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.748991]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.748996]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.749002]  [<ffffffffa017c86f>] dvb_dmxdev_init+0xef/0x140 [dvb_core]
[  178.749004]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.749009]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.749011]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749015]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.749017]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749020]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.749023]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.749026]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.749028]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.749031]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.749033]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.749034] ---[ end trace d2b70e7cf3a6026a ]---
[  178.749048] dvb_register_device: failed to create device dvb1.demux1 (-17)
[  178.749054] ------------[ cut here ]------------
[  178.749056] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.749057] sysfs: cannot create duplicate filename 
'/devices/pci0000:00/0000:00:08.0/0000:01:06.2/dvb'
[  178.749071] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.749072] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.749073] Call Trace:
[  178.749075]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.749078]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.749080]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.749082]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.749084]  [<ffffffff821077e3>] create_dir+0x73/0xc0
[  178.749086]  [<ffffffff82107b01>] sysfs_create_dir+0x81/0xe0
[  178.749088]  [<ffffffff8219f81a>] kobject_add_internal+0x9a/0x1f0
[  178.749091]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.749094]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.749096]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.749098]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.749101]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.749103]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.749105]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.749108]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.749110]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.749115]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.749121]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.749123]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.749128]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.749130]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749133]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.749135]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749138]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.749141]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.749143]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.749146]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.749149]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.749151]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.749152] ---[ end trace d2b70e7cf3a6026b ]---
[  178.749153] ------------[ cut here ]------------
[  178.749156] WARNING: at lib/kobject.c:196 
kobject_add_internal+0x1dc/0x1f0()
[  178.749157] kobject_add_internal failed for dvb with -EEXIST, don't try to 
register things with the same name in the same directory.
[  178.749170] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.749172] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.749172] Call Trace:
[  178.749174]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.749177]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.749179]  [<ffffffff8219f95c>] kobject_add_internal+0x1dc/0x1f0
[  178.749181]  [<ffffffff8219fd77>] kobject_add+0x67/0xc0
[  178.749186]  [<ffffffff8223ad6f>] get_device_parent.isra.20+0x10f/0x1e0
[  178.749188]  [<ffffffff8223b131>] device_add+0xc1/0x660
[  178.749191]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.749194]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.749196]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.749199]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.749201]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.749203]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.749208]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.749214]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.749217]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.749221]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.749224]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749227]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.749229]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749233]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.749235]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.749238]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.749240]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.749243]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.749246]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.749319] ---[ end trace d2b70e7cf3a6026c ]---
[  178.749326] ------------[ cut here ]------------
[  178.749328] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc7/0xf0()
[  178.749329] sysfs: cannot create duplicate filename '/dev/char/212:85'
[  178.749343] Modules linked in: cx22702 isl6421 cx24116 cx88_dvb(+) 
videobuf_dvb ir_mce_kbd_decoder ir_rc6_decoder ir_rc5_decoder rc_hauppauge 
tuner_simple tuner_types tda9887 tda8290 tuner cx8802 cx88xx tveeprom 
btcx_risc videobuf_dma_sg videobuf_core v4l2_common videodev rc_core stv0299 
budget budget_core ttpci_eeprom saa7146 dvb_core snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_page_alloc [last 
unloaded: rc_core]
[  178.749345] Pid: 480, comm: modprobe Tainted: G        W    3.9.0-rc4 #29
[  178.749345] Call Trace:
[  178.749348]  [<ffffffff82026d4b>] warn_slowpath_common+0x6b/0xa0
[  178.749351]  [<ffffffff82026e21>] warn_slowpath_fmt+0x41/0x50
[  178.749353]  [<ffffffff821a37e4>] ? strlcat+0x64/0x90
[  178.749355]  [<ffffffff821075d7>] sysfs_add_one+0xc7/0xf0
[  178.749357]  [<ffffffff82108215>] sysfs_do_create_link_sd+0xf5/0x1f0
[  178.749360]  [<ffffffff821a58f0>] ? sprintf+0x40/0x50
[  178.749362]  [<ffffffff8210832c>] sysfs_create_link+0x1c/0x40
[  178.749364]  [<ffffffff8223b25c>] device_add+0x1ec/0x660
[  178.749366]  [<ffffffff821a8404>] ? kvasprintf+0x74/0x90
[  178.749369]  [<ffffffff822456f0>] ? pm_runtime_init+0xe0/0xf0
[  178.749371]  [<ffffffff8223b6e9>] device_register+0x19/0x20
[  178.749373]  [<ffffffff8223b7cb>] device_create_vargs+0xdb/0x110
[  178.749376]  [<ffffffff8223b82c>] device_create+0x2c/0x30
[  178.749378]  [<ffffffff820aa479>] ? kmem_cache_alloc+0xa9/0xb0
[  178.749383]  [<ffffffffa017b7d6>] dvb_register_device+0x266/0x440 [dvb_core]
[  178.749390]  [<ffffffffa017c88b>] dvb_dmxdev_init+0x10b/0x140 [dvb_core]
[  178.749392]  [<ffffffffa025e377>] videobuf_dvb_register_bus+0x167/0x3c0 
[videobuf_dvb]
[  178.749397]  [<ffffffffa026457a>] cx8802_dvb_probe+0x30a/0x24d0 [cx88_dvb]
[  178.749399]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749403]  [<ffffffffa0220c1c>] cx8802_register_driver+0x1cc/0x274 [cx8802]
[  178.749405]  [<ffffffffa026b000>] ? 0xffffffffa026afff
[  178.749408]  [<ffffffffa026b025>] dvb_init+0x25/0x27 [cx88_dvb]
[  178.749411]  [<ffffffff820002fa>] do_one_initcall+0x11a/0x160
[  178.749413]  [<ffffffff82066638>] load_module+0x1888/0x2140
[  178.749415]  [<ffffffff82063570>] ? free_notes_attrs+0x60/0x60
[  178.749418]  [<ffffffff82066f82>] sys_init_module+0x92/0xb0
[  178.749421]  [<ffffffff82376b92>] system_call_fastpath+0x16/0x1b
[  178.749422] ---[ end trace d2b70e7cf3a6026d ]---
[  178.749436] dvb_register_device: failed to create device dvb1.dvr1 (-17)
[  178.750007] CE: hpet increased min_delta_ns to 11520 nsec

