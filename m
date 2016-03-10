Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:57372 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcCJNxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 08:53:52 -0500
Received: from JONSBO ([31.29.113.71]) by mrelayeu.kundenserver.de (mreue104)
 with ESMTPA (Nemesis) id 0MZls6-1aQBdq0VJu-00LXtg for
 <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 14:53:48 +0100
Reply-To: <neil@ferme-de-la-motte.com>
From: "Neil Cordwell" <neil@ferme-de-la-motte.com>
To: <linux-media@vger.kernel.org>
Subject: Driver Technisat Skystar S2 and Compro VideoMate S350
Date: Thu, 10 Mar 2016 14:53:48 +0100
Message-ID: <014e01d17ad4$45f1e070$d1d5a150$@ferme-de-la-motte.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
Please be gentle as this is my first posting.
I am trying to set up machine for recording satellite TV using MythTV.

Before playing around on my HP Microserver I thought I should check it all
out on a sandbox machine AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ with
4G of memory and Technisat Skystar S2 and Compro VideoMate S350 capture
cards.

I started with Ubuntu 14.04 LTS Desktop, but had great difficulty with the
Technisat card driver. I found out that these had been rolled into the
latest kernel so decided to install Ubuntu 15.10 instead.

Technisat Skystar S2

When I first installed this card I couldn't find the firmware
dvb-fe-cx24120-1.20.58.2.fw. Downloaded this from github and now there are
no errors in dmesg, but I cannot get the card to tune in MythTV. I wondered
if the <access denied> in the output of lspci is anything?

3:05.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: Compro Technology, Inc. VideoMate T750 [185b:c900]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (21000ns min, 8000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: <access denied>
        Kernel driver in use: saa7134

Compro VideoMate S350

This card could not find its firmware (xc3028-v27.fw) which was again
available on github and then I had to create a conf file containing
options saa7134 card=169 
otherwise it is recognised as a Compro Videomate T750. Again, I cannot get
the card to tune in MythTV.

03:06.0 Network controller [0280]: Techsan Electronics Co Ltd B2C2 FlexCopII
DVB chip / Technisat SkyStar2 DVB card [13d0:2103] (rev 02)
        Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip /
Technisat SkyStar2 DVB card [13d0:2103]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at febe0000 (32-bit, non-prefetchable) [size=64K]
        Region 1: I/O ports at e800 [size=32]
        Kernel driver in use: b2c2_flexcop_pci


I tried to use dvbv5-scan with a simple channel file and get an error. Scan
does nothing

neil@Sonata-Linux:~/Documents$ dvbv5-scan --input-format=CHANNEL Astra-28.2E
ERROR Doesn't know how to handle delimiter '[CHANNEL]' while parsing line 2
of Astra-28.2E


[CHANNEL]
                DELIVERY_SYSTEM = DVBS2
                FREQUENCY = 11719500
                POLARIZATION = HORIZONTAL
                SYMBOL_RATE = 29500000
                INNER_FEC = 3/4
                MODULATION = QPSK
                INVERSION = AUTO

Any ideas where to go next?
Many thanks
Neil

===========================dmesg output============
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.2.0-30-generic (buildd@lgw01-60) (gcc version
5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #36-Ubuntu SMP Fri Feb 26 00:58:07
UTC 2016 (Ubuntu 4.2.0-30.36-generic 4.2.8-ckt3)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.2.0-30-generic
root=UUID=06d63f26-50ba-4d29-b46a-e4e736b83f2a ro quiet splash vt.handoff=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] tseg: 0000000000
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e6000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfe8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe90000-0x00000000cfe9dfff] ACPI
data
[    0.000000] BIOS-e820: [mem 0x00000000cfe9e000-0x00000000cfedffff] ACPI
NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfee0000-0x00000000cfefffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: MICRO-STAR INTERNATIONAL CO.,LTD MS-7551/KA790GX
(MS-7551), BIOS V1.6 10/30/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT

[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfe90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at
[ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ff1000, 0x01ff1fff] PGTABLE
[    0.000000] BRK [0x01ff2000, 0x01ff2fff] PGTABLE
[    0.000000] BRK [0x01ff3000, 0x01ff3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x01ff4000, 0x01ff4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11fdfffff]
[    0.000000]  [mem 0x100000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfe8ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfe8ffff] page 4k
[    0.000000] RAMDISK: [mem 0x33fe0000-0x35fe7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FA970 000014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 0x00000000CFE90000 00003C (v01 7551MS A7551010
20091030 MSFT 00000097)
[    0.000000] ACPI: FACP 0x00000000CFE90200 000084 (v01 7551MS A7551010
20091030 MSFT 00000097)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock
has zero address or length: 0x0000000000000000/0x1 (20150619/tbfadt-654)
[    0.000000] ACPI: DSDT 0x00000000CFE90450 009822 (v01 A7551  A7551010
00000010 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000CFE9E000 000040
[    0.000000] ACPI: APIC 0x00000000CFE90390 00007C (v01 7551MS A7551010
20091030 MSFT 00000097)
[    0.000000] ACPI: MCFG 0x00000000CFE90410 00003C (v01 7551MS OEMMCFG
20091030 MSFT 00000097)
[    0.000000] ACPI: OEMB 0x00000000CFE9E040 000072 (v01 7551MS A7551010
20091030 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000CFE99C80 000038 (v01 7551MS OEMHPET
20091030 MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000CFE99CC0 00030E (v01 A M I  POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11fff7000-0x11fffbfff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD ->
[ffff88011ba00000-ffff88011f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000cfe8ffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem
0x0000000000001000-0x000000011fffffff]
[    0.000000] On node 0 totalpages: 982574
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13243 pages used for memmap
[    0.000000]   DMA32 zone: 847504 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] smpboot: Allowing 6 CPUs, 4 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000e5fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e6000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe90000-0xcfe9dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe9e000-0xcfedffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfee0000-0xcfefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcff00000-0xffefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff00000-0xffffffff]
[    0.000000] e820: [mem 0xcff00000-0xffefffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:6
nr_node_ids:1
[    0.000000] PERCPU: Embedded 33 pages/cpu @ffff88011fc00000 s96728 r8192
d30248 u262144
[    0.000000] pcpu-alloc: s96728 r8192 d30248 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 - - 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total
pages: 967198
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-4.2.0-30-generic
root=UUID=06d63f26-50ba-4d29-b46a-e4e736b83f2a ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0xdf1c000000-0xdf1dffffff]
(32MB)
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] AGP: Your BIOS doesn't leave an aperture memory hole
[    0.000000] AGP: Please enable the IOMMU option in the BIOS setup
[    0.000000] AGP: This costs you 64MB of RAM
[    0.000000] AGP: Mapping aperture over RAM [mem 0xc4000000-0xc7ffffff]
(65536KB)
[    0.000000] PM: Registered nosave memory: [mem 0xc4000000-0xc7ffffff]
[    0.000000] Memory: 3686960K/3930296K available (8158K kernel code, 1238K
rwdata, 3804K rodata, 1464K init, 1292K bss, 243336K reserved, 0K
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=6, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=6.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=6
[    0.000000] NR_IRQS:16640 nr_irqs:472 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-5.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] vt handoff: transparent VT on vt#7
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff,
max_idle_ns: 133484873504 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2900.379 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004014] Calibrating delay loop (skipped), value calculated using
timer frequency.. 5800.75 BogoMIPS (lpj=11601516)
[    0.004017] pid_max: default: 32768 minimum: 301
[    0.004025] ACPI: Core revision 20150619
[    0.010869] ACPI: All ACPI Tables successfully acquired
[    0.010895] Security Framework initialized
[    0.010910] AppArmor: AppArmor initialized
[    0.010912] Yama: becoming mindful.
[    0.011316] Dentry cache hash table entries: 524288 (order: 10, 4194304
bytes)
[    0.013659] Inode-cache hash table entries: 262144 (order: 9, 2097152
bytes)
[    0.014696] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.014703] Mountpoint-cache hash table entries: 8192 (order: 4, 65536
bytes)
[    0.015016] Initializing cgroup subsys blkio
[    0.015021] Initializing cgroup subsys memory
[    0.015033] Initializing cgroup subsys devices
[    0.015036] Initializing cgroup subsys freezer
[    0.015039] Initializing cgroup subsys net_cls
[    0.015042] Initializing cgroup subsys perf_event
[    0.015046] Initializing cgroup subsys net_prio
[    0.015049] Initializing cgroup subsys hugetlb
[    0.015070] CPU: Physical Processor ID: 0
[    0.015071] CPU: Processor Core ID: 0
[    0.015073] mce: CPU supports 5 MCE banks
[    0.015082] LVT offset 0 assigned for vector 0xf9
[    0.015085] process: using AMD E400 aware idle routine
[    0.015087] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.015089] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.015333] Freeing SMP alternatives memory: 28K (ffffffff81ea5000 -
ffffffff81eac000)
[    0.017737] ftrace: allocating 30940 entries in 121 pages
[    0.032406] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076000] smpboot: CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
(fam: 0f, model: 6b, stepping: 02)
[    0.076000] Performance Events: AMD PMU driver.
[    0.076000] ... version:                0
[    0.076000] ... bit width:              48
[    0.076000] ... generic registers:      4
[    0.076000] ... value mask:             0000ffffffffffff
[    0.076000] ... max period:             00007fffffffffff
[    0.076000] ... fixed-purpose events:   0
[    0.076000] ... event mask:             000000000000000f
[    0.076000] x86: Booting SMP configuration:
[    0.076000] .... node  #0, CPUs:      #1
[    0.076228] NMI watchdog: enabled on all CPUs, permanently consumes one
hw-PMU counter.
[    0.152086] x86: Booted up 1 node, 2 CPUs
[    0.152088] smpboot: Total of 2 processors activated (11601.27 BogoMIPS)
[    0.152542] devtmpfs: initialized
[    0.156998] evm: security.selinux
[    0.157000] evm: security.SMACK64
[    0.157001] evm: security.SMACK64EXEC
[    0.157002] evm: security.SMACK64TRANSMUTE
[    0.157003] evm: security.SMACK64MMAP
[    0.157004] evm: security.ima
[    0.157005] evm: security.capability
[    0.157052] PM: Registering ACPI NVS region [mem 0xcfe9e000-0xcfedffff]
(270336 bytes)
[    0.157052] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.157052] pinctrl core: initialized pinctrl subsystem
[    0.157052] RTC time: 13:14:58, date: 03/10/16
[    0.157052] NET: Registered protocol family 16
[    0.164006] cpuidle: using governor ladder
[    0.168008] cpuidle: using governor menu
[    0.168017] node 0 link 0: io port [1000, ffffff]
[    0.168019] TOM: 00000000d0000000 aka 3328M
[    0.168022] node 0 link 0: mmio [a0000, bffff]
[    0.168025] node 0 link 0: mmio [d0000000, efffffff]
[    0.168026] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.168028] node 0 link 0: mmio [fe800000, fe8fffff]
[    0.168029] node 0 link 0: mmio [fe900000, ffefffff]
[    0.168031] TOM2: 0000000130000000 aka 4864M
[    0.168033] bus: [bus 00-07] on node 0 link 0
[    0.168034] bus: 00 [io  0x0000-0xffff]
[    0.168036] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.168037] bus: 00 [mem 0xd0000000-0xffffffff]
[    0.168038] bus: 00 [mem 0x130000000-0xfcffffffff]
[    0.168125] ACPI: bus type PCI registered
[    0.168127] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.168217] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.168220] PCI: not using MMCONFIG
[    0.168221] PCI: Using configuration type 1 for base access
[    0.168417] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.168418] mtrr: probably your BIOS does not setup all CPUs.
[    0.168419] mtrr: corrected configuration.
[    0.172123] ACPI: Added _OSI(Module Device)
[    0.172125] ACPI: Added _OSI(Processor Device)
[    0.172126] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.172127] ACPI: Added _OSI(Processor Aggregator Device)
[    0.173583] ACPI: Executed 4 blocks of module-level executable AML code
[    0.176369] ACPI: Interpreter enabled
[    0.176382] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S2_] (20150619/hwxface-580)
[    0.176386] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S3_] (20150619/hwxface-580)
[    0.176397] ACPI: (supports S0 S1 S4 S5)
[    0.176398] ACPI: Using IOAPIC for interrupt routing
[    0.176423] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.177042] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
[    0.177071] PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[    0.181785] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.181793] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.181798] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.181872] acpi PNP0A03:00: ignoring host bridge window [mem
0x000d0000-0x000dffff window] (conflicts with Adapter ROM [mem
0x000cf000-0x000d09ff])
[    0.182057] PCI host bridge to bus 0000:00
[    0.182060] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.182063] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.182065] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.182067] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff
window]
[    0.182069] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdfffffff
window]
[    0.182071] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfebfffff
window]
[    0.182081] pci 0000:00:00.0: [1022:9600] type 00 class 0x060000
[    0.182193] pci 0000:00:01.0: [1462:9602] type 01 class 0x060400
[    0.182290] pci 0000:00:05.0: [1022:9605] type 01 class 0x060400
[    0.182330] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.182374] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.182430] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.182449] pci 0000:00:11.0: reg 0x10: [io  0xb000-0xb007]
[    0.182461] pci 0000:00:11.0: reg 0x14: [io  0xa000-0xa003]
[    0.182472] pci 0000:00:11.0: reg 0x18: [io  0x9000-0x9007]
[    0.182483] pci 0000:00:11.0: reg 0x1c: [io  0x8000-0x8003]
[    0.182494] pci 0000:00:11.0: reg 0x20: [io  0x7000-0x700f]
[    0.182504] pci 0000:00:11.0: reg 0x24: [mem 0xfe7ffc00-0xfe7fffff]
[    0.182618] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.182633] pci 0000:00:12.0: reg 0x10: [mem 0xfe7fd000-0xfe7fdfff]
[    0.182735] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.182777] pci 0000:00:12.1: [1002:4398] type 00 class 0x0c0310
[    0.182791] pci 0000:00:12.1: reg 0x10: [mem 0xfe7fe000-0xfe7fefff]
[    0.182893] pci 0000:00:12.1: System wakeup disabled by ACPI
[    0.182940] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.182959] pci 0000:00:12.2: reg 0x10: [mem 0xfe7ff800-0xfe7ff8ff]
[    0.183044] pci 0000:00:12.2: supports D1 D2
[    0.183046] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.183087] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.183135] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.183151] pci 0000:00:13.0: reg 0x10: [mem 0xfe7f7000-0xfe7f7fff]
[    0.183254] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.183295] pci 0000:00:13.1: [1002:4398] type 00 class 0x0c0310
[    0.183311] pci 0000:00:13.1: reg 0x10: [mem 0xfe7fc000-0xfe7fcfff]
[    0.183412] pci 0000:00:13.1: System wakeup disabled by ACPI
[    0.183457] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.183478] pci 0000:00:13.2: reg 0x10: [mem 0xfe7ff400-0xfe7ff4ff]
[    0.183565] pci 0000:00:13.2: supports D1 D2
[    0.183567] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.183608] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.183656] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.183815] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.183832] pci 0000:00:14.1: reg 0x10: [io  0x0000-0x0007]
[    0.183843] pci 0000:00:14.1: reg 0x14: [io  0x0000-0x0003]
[    0.183854] pci 0000:00:14.1: reg 0x18: [io  0x0000-0x0007]
[    0.183864] pci 0000:00:14.1: reg 0x1c: [io  0x0000-0x0003]
[    0.183875] pci 0000:00:14.1: reg 0x20: [io  0xff00-0xff0f]
[    0.183898] pci 0000:00:14.1: legacy IDE quirk: reg 0x10: [io
0x01f0-0x01f7]
[    0.183900] pci 0000:00:14.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.183902] pci 0000:00:14.1: legacy IDE quirk: reg 0x18: [io
0x0170-0x0177]
[    0.183903] pci 0000:00:14.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.184011] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.184034] pci 0000:00:14.2: reg 0x10: [mem 0xfe7f0000-0xfe7f3fff 64bit]
[    0.184104] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.184146] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.184188] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.184335] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.184408] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.184449] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.184466] pci 0000:00:14.5: reg 0x10: [mem 0xfe7f6000-0xfe7f6fff]
[    0.184565] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.184609] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.184680] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.184747] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.184817] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.184940] pci 0000:01:05.0: [1002:9614] type 00 class 0x030000
[    0.184949] pci 0000:01:05.0: reg 0x10: [mem 0xd0000000-0xdfffffff pref]
[    0.184953] pci 0000:01:05.0: reg 0x14: [io  0xc000-0xc0ff]
[    0.184958] pci 0000:01:05.0: reg 0x18: [mem 0xfe9e0000-0xfe9effff]
[    0.184971] pci 0000:01:05.0: reg 0x24: [mem 0xfe800000-0xfe8fffff]
[    0.184990] pci 0000:01:05.0: supports D1 D2
[    0.185034] pci 0000:01:05.1: [1002:960f] type 00 class 0x040300
[    0.185042] pci 0000:01:05.1: reg 0x10: [mem 0xfe9fc000-0xfe9fffff]
[    0.185078] pci 0000:01:05.1: supports D1 D2
[    0.185150] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.185154] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.185157] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.185161] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.185208] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.185224] pci 0000:02:00.0: reg 0x10: [io  0xd800-0xd8ff]
[    0.185246] pci 0000:02:00.0: reg 0x18: [mem 0xfeaff000-0xfeafffff 64bit]
[    0.185261] pci 0000:02:00.0: reg 0x20: [mem 0xfdff0000-0xfdffffff 64bit
pref]
[    0.185271] pci 0000:02:00.0: reg 0x30: [mem 0xfeac0000-0xfeadffff pref]
[    0.185326] pci 0000:02:00.0: supports D1 D2
[    0.185327] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.192021] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.192025] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.192028] pci 0000:00:05.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.192033] pci 0000:00:05.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.192081] pci 0000:03:05.0: [1131:7133] type 00 class 0x048000
[    0.192103] pci 0000:03:05.0: reg 0x10: [mem 0xfebff800-0xfebfffff]
[    0.192204] pci 0000:03:05.0: supports D1 D2
[    0.192247] pci 0000:03:06.0: [13d0:2103] type 00 class 0x028000
[    0.192265] pci 0000:03:06.0: reg 0x10: [mem 0xfebe0000-0xfebeffff]
[    0.192278] pci 0000:03:06.0: reg 0x14: [io  0xe800-0xe81f]
[    0.192421] pci 0000:00:14.4: PCI bridge to [bus 03] (subtractive decode)
[    0.192425] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    0.192430] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.192435] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7 window]
(subtractive decode)
[    0.192437] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff window]
(subtractive decode)
[    0.192439] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff
window] (subtractive decode)
[    0.192442] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfffffff
window] (subtractive decode)
[    0.192444] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff
window] (subtractive decode)
[    0.192460] pci_bus 0000:00: on NUMA node 0
[    0.192970] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.193013] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.193055] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.193096] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
[    0.193137] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 *10 11 12 14 15)
[    0.193178] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 12 14 15)
[    0.193219] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 *10 11 12 14 15)
[    0.193259] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0,
disabled.
[    0.193452] vgaarb: setting as boot device: PCI:0000:01:05.0
[    0.193452] vgaarb: device added:
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.193452] vgaarb: loaded
[    0.193452] vgaarb: bridge control possible 0000:01:05.0
[    0.193452] SCSI subsystem initialized
[    0.193452] libata version 3.00 loaded.
[    0.193452] ACPI: bus type USB registered
[    0.193452] usbcore: registered new interface driver usbfs
[    0.193452] usbcore: registered new interface driver hub
[    0.193452] usbcore: registered new device driver usb
[    0.193452] PCI: Using ACPI for IRQ routing
[    0.203533] PCI: pci_cache_line_size set to 64 bytes
[    0.203602] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.203604] e820: reserve RAM buffer [mem 0xcfe90000-0xcfffffff]
[    0.203740] NetLabel: Initializing
[    0.203741] NetLabel:  domain hash size = 128
[    0.203742] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.203754] NetLabel:  unlabeled traffic allowed by default
[    0.203780] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.203780] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.205049] clocksource: Switched to clocksource hpet
[    0.213255] AppArmor: AppArmor Filesystem Enabled
[    0.213345] pnp: PnP ACPI init
[    0.213546] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.213616] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.213831] pnp 00:02: [dma 0 disabled]
[    0.213887] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.214090] system 00:03: [mem 0xfec00000-0xfec00fff] could not be
reserved
[    0.214093] system 00:03: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.214096] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.214312] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.214314] system 00:04: [io  0x040b] has been reserved
[    0.214317] system 00:04: [io  0x04d6] has been reserved
[    0.214321] system 00:04: [io  0x0c00-0x0c01] has been reserved
[    0.214323] system 00:04: [io  0x0c14] has been reserved
[    0.214325] system 00:04: [io  0x0c50-0x0c51] has been reserved
[    0.214328] system 00:04: [io  0x0c52] has been reserved
[    0.214331] system 00:04: [io  0x0c6c] has been reserved
[    0.214333] system 00:04: [io  0x0c6f] has been reserved
[    0.214335] system 00:04: [io  0x0cd0-0x0cd1] has been reserved
[    0.214338] system 00:04: [io  0x0cd2-0x0cd3] has been reserved
[    0.214340] system 00:04: [io  0x0cd4-0x0cd5] has been reserved
[    0.214342] system 00:04: [io  0x0cd6-0x0cd7] has been reserved
[    0.214345] system 00:04: [io  0x0cd8-0x0cdf] has been reserved
[    0.214348] system 00:04: [io  0x0800-0x089f] could not be reserved
[    0.214350] system 00:04: [io  0x0b00-0x0b0f] has been reserved
[    0.214353] system 00:04: [io  0x0b20-0x0b3f] has been reserved
[    0.214355] system 00:04: [io  0x0900-0x090f] has been reserved
[    0.214357] system 00:04: [io  0x0910-0x091f] has been reserved
[    0.214360] system 00:04: [io  0xfe00-0xfefe] has been reserved
[    0.214363] system 00:04: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.214365] system 00:04: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.214369] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.214521] system 00:05: [io  0x0500-0x05df] has been reserved
[    0.214523] system 00:05: [io  0x0ae0-0x0aef] has been reserved
[    0.214526] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.214603] system 00:06: [mem 0xe0000000-0xefffffff] has been reserved
[    0.214606] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.214774] system 00:07: [mem 0x00000000-0x0009ffff] could not be
reserved
[    0.214777] system 00:07: [mem 0x000c0000-0x000cffff] could not be
reserved
[    0.214779] system 00:07: [mem 0x000e0000-0x000fffff] could not be
reserved
[    0.214782] system 00:07: [mem 0x00100000-0xcfefffff] could not be
reserved
[    0.214785] system 00:07: [mem 0xfec00000-0xffffffff] could not be
reserved
[    0.214788] system 00:07: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.214893] pnp: PnP ACPI: found 8 devices
[    0.222445] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,
max_idle_ns: 2085701024 ns
[    0.222479] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.222482] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
[    0.222486] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.222489] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.222493] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.222495] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.222499] pci 0000:00:05.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.222501] pci 0000:00:05.0:   bridge window [mem 0xfdf00000-0xfdffffff
64bit pref]
[    0.222505] pci 0000:00:14.4: PCI bridge to [bus 03]
[    0.222508] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    0.222514] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.222525] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.222527] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.222530] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff
window]
[    0.222532] pci_bus 0000:00: resource 7 [mem 0xcff00000-0xdfffffff
window]
[    0.222534] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfebfffff
window]
[    0.222536] pci_bus 0000:01: resource 0 [io  0xc000-0xcfff]
[    0.222538] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
[    0.222540] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit
pref]
[    0.222543] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.222545] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.222547] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit
pref]
[    0.222549] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.222551] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.222553] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7 window]
[    0.222555] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff window]
[    0.222557] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff
window]
[    0.222559] pci_bus 0000:03: resource 7 [mem 0xcff00000-0xdfffffff
window]
[    0.222561] pci_bus 0000:03: resource 8 [mem 0xf0000000-0xfebfffff
window]
[    0.222606] NET: Registered protocol family 2
[    0.222811] TCP established hash table entries: 32768 (order: 6, 262144
bytes)
[    0.222968] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.223204] TCP: Hash tables configured (established 32768 bind 32768)
[    0.223288] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.223329] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.223458] NET: Registered protocol family 1
[    0.223476] pci 0000:00:01.0: MSI quirk detected; subordinate MSI
disabled
[    0.592118] pci 0000:01:05.0: Video device with shadowed ROM
[    0.592129] PCI: CLS 64 bytes, default 64
[    0.592213] Trying to unpack rootfs image as initramfs...
[    1.162304] Freeing initrd memory: 32800K (ffff880033fe0000 -
ffff880035fe8000)
[    1.162581] PCI-DMA: Disabling AGP.
[    1.162668] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    1.162669] PCI-DMA: using GART IOMMU.
[    1.162674] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.165660] clocksource: tsc: mask: 0xffffffffffffffff max_cycles:
0x29cea8e0d08, max_idle_ns: 440795203669 ns
[    1.165688] microcode: AMD CPU family 0xf not supported
[    1.165855] Scanning for low memory corruption every 60 seconds
[    1.166297] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.166348] Initialise system trusted keyring
[    1.166376] audit: initializing netlink subsys (disabled)
[    1.166400] audit: type=2000 audit(1457615698.164:1): initialized
[    1.166789] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.168894] zpool: loaded
[    1.168896] zbud: loaded
[    1.169139] VFS: Disk quotas dquot_6.6.0
[    1.169194] VFS: Dquot-cache hash table entries: 512 (order 0, 4096
bytes)
[    1.169948] fuse init (API version 7.23)
[    1.170150] Key type big_key registered
[    1.170689] Key type asymmetric registered
[    1.170693] Asymmetric key parser 'x509' registered
[    1.170712] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 249)
[    1.170763] io scheduler noop registered
[    1.170766] io scheduler deadline registered (default)
[    1.170812] io scheduler cfq registered
[    1.171191] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.171200] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.171239] vesafb: mode is 1600x1200x32, linelength=6400, pages=0
[    1.171241] vesafb: scrolling: redraw
[    1.171243] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    1.171260] vesafb: framebuffer at 0xd0000000, mapped to
0xffffc90000800000, using 7552k, total 7552k
[    1.171434] Console: switching to colour frame buffer device 200x75
[    1.171471] fb0: VESA VGA frame buffer device
[    1.171576] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.171580] ACPI: Power Button [PWRB]
[    1.171629] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.171632] ACPI: Power Button [PWRF]
[    1.171832] GHES: HEST is not enabled!
[    1.171957] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.192499] 00:02: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a
16550A
[    1.194787] Linux agpgart interface v0.103
[    1.197712] brd: module loaded
[    1.199104] loop: module loaded
[    1.199415] libphy: Fixed MDIO Bus: probed
[    1.199419] tun: Universal TUN/TAP device driver, 1.6
[    1.199420] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.199491] PPP generic driver version 2.4.2
[    1.199588] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.199595] ehci-pci: EHCI PCI platform driver
[    1.199760] QUIRK: Enable AMD PLL fix
[    1.199790] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.199797] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus
number 1
[    1.199802] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3
EHCI dummy qh workaround
[    1.199804] ehci-pci 0000:00:12.2: applying AMD SB600/SB700 USB freeze
workaround
[    1.199818] ehci-pci 0000:00:12.2: debug port 1
[    1.199868] ehci-pci 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    1.208033] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.208081] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.208083] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.208085] usb usb1: Product: EHCI Host Controller
[    1.208087] usb usb1: Manufacturer: Linux 4.2.0-30-generic ehci_hcd
[    1.208089] usb usb1: SerialNumber: 0000:00:12.2
[    1.208230] hub 1-0:1.0: USB hub found
[    1.208238] hub 1-0:1.0: 6 ports detected
[    1.208551] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.208557] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus
number 2
[    1.208561] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3
EHCI dummy qh workaround
[    1.208562] ehci-pci 0000:00:13.2: applying AMD SB600/SB700 USB freeze
workaround
[    1.208576] ehci-pci 0000:00:13.2: debug port 1
[    1.208613] ehci-pci 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    1.220020] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.220059] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.220061] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.220063] usb usb2: Product: EHCI Host Controller
[    1.220064] usb usb2: Manufacturer: Linux 4.2.0-30-generic ehci_hcd
[    1.220066] usb usb2: SerialNumber: 0000:00:13.2
[    1.220193] hub 2-0:1.0: USB hub found
[    1.220199] hub 2-0:1.0: 6 ports detected
[    1.220389] ehci-platform: EHCI generic platform driver
[    1.220406] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.220412] ohci-pci: OHCI PCI platform driver
[    1.220542] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    1.220548] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus
number 3
[    1.220582] ohci-pci 0000:00:12.0: irq 16, io mem 0xfe7fd000
[    1.280065] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.280067] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.280069] usb usb3: Product: OHCI PCI host controller
[    1.280071] usb usb3: Manufacturer: Linux 4.2.0-30-generic ohci_hcd
[    1.280073] usb usb3: SerialNumber: 0000:00:12.0
[    1.280201] hub 3-0:1.0: USB hub found
[    1.280211] hub 3-0:1.0: 3 ports detected
[    1.280454] ohci-pci 0000:00:12.1: OHCI PCI host controller
[    1.280459] ohci-pci 0000:00:12.1: new USB bus registered, assigned bus
number 4
[    1.280479] ohci-pci 0000:00:12.1: irq 16, io mem 0xfe7fe000
[    1.340058] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.340060] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.340062] usb usb4: Product: OHCI PCI host controller
[    1.340064] usb usb4: Manufacturer: Linux 4.2.0-30-generic ohci_hcd
[    1.340066] usb usb4: SerialNumber: 0000:00:12.1
[    1.340223] hub 4-0:1.0: USB hub found
[    1.340234] hub 4-0:1.0: 3 ports detected
[    1.340572] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    1.340579] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus
number 5
[    1.340621] ohci-pci 0000:00:13.0: irq 18, io mem 0xfe7f7000
[    1.400078] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.400080] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.400082] usb usb5: Product: OHCI PCI host controller
[    1.400084] usb usb5: Manufacturer: Linux 4.2.0-30-generic ohci_hcd
[    1.400086] usb usb5: SerialNumber: 0000:00:13.0
[    1.400248] hub 5-0:1.0: USB hub found
[    1.400259] hub 5-0:1.0: 3 ports detected
[    1.400493] ohci-pci 0000:00:13.1: OHCI PCI host controller
[    1.400499] ohci-pci 0000:00:13.1: new USB bus registered, assigned bus
number 6
[    1.400519] ohci-pci 0000:00:13.1: irq 18, io mem 0xfe7fc000
[    1.460069] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.460071] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.460073] usb usb6: Product: OHCI PCI host controller
[    1.460075] usb usb6: Manufacturer: Linux 4.2.0-30-generic ohci_hcd
[    1.460077] usb usb6: SerialNumber: 0000:00:13.1
[    1.460211] hub 6-0:1.0: USB hub found
[    1.460221] hub 6-0:1.0: 3 ports detected
[    1.460501] ohci-pci 0000:00:14.5: OHCI PCI host controller
[    1.460507] ohci-pci 0000:00:14.5: new USB bus registered, assigned bus
number 7
[    1.460530] ohci-pci 0000:00:14.5: irq 18, io mem 0xfe7f6000
[    1.520060] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.520062] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    1.520064] usb usb7: Product: OHCI PCI host controller
[    1.520066] usb usb7: Manufacturer: Linux 4.2.0-30-generic ohci_hcd
[    1.520068] usb usb7: SerialNumber: 0000:00:14.5
[    1.520216] hub 7-0:1.0: USB hub found
[    1.520225] hub 7-0:1.0: 2 ports detected
[    1.520336] ohci-platform: OHCI generic platform driver
[    1.520359] uhci_hcd: USB Universal Host Controller Interface driver
[    1.520433] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.522647] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.522652] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.522807] mousedev: PS/2 mouse device common for all mice
[    1.522975] rtc_cmos 00:01: RTC can wake from S4
[    1.523116] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.523143] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram,
hpet irqs
[    1.523153] i2c /dev entries driver
[    1.523269] device-mapper: uevent: version 1.0.3
[    1.523360] device-mapper: ioctl: 4.33.0-ioctl (2015-8-18) initialised:
dm-devel@redhat.com
[    1.523385] ledtrig-cpu: registered to indicate activity on CPUs
[    1.523567] PCCT header not found.
[    1.523851] NET: Registered protocol family 10
[    1.524127] NET: Registered protocol family 17
[    1.524143] Key type dns_resolver registered
[    1.524553] Loading compiled-in X.509 certificates
[    1.525558] Loaded X.509 cert 'Build time autogenerated kernel key:
aa46912a20e4e17b1e4a6ccc08bd3c70d4d8f464'
[    1.525583] registered taskstats version 1
[    1.525604] zswap: loading zswap
[    1.525606] zswap: using zbud pool
[    1.525613] zswap: using lzo compressor
[    1.528401] Key type trusted registered
[    1.533567] Key type encrypted registered
[    1.533578] AppArmor: AppArmor sha1 policy hashing enabled
[    1.533582] ima: No TPM chip found, activating TPM-bypass!
[    1.533611] evm: HMAC attrs: 0x1
[    1.533957]   Magic number: 8:278:230
[    1.534071] rtc_cmos 00:01: setting system clock to 2016-03-10 13:14:59
UTC (1457615699)
[    1.534304] powernow_k8: fid 0x15 (2900 MHz), vid 0x9
[    1.534305] powernow_k8: fid 0x14 (2800 MHz), vid 0xa
[    1.534307] powernow_k8: fid 0x12 (2600 MHz), vid 0xc
[    1.534308] powernow_k8: fid 0x10 (2400 MHz), vid 0xe
[    1.534309] powernow_k8: fid 0xe (2200 MHz), vid 0x10
[    1.534310] powernow_k8: fid 0xc (2000 MHz), vid 0x10
[    1.534311] powernow_k8: fid 0xa (1800 MHz), vid 0x10
[    1.534312] powernow_k8: fid 0x2 (1000 MHz), vid 0x12
[    1.534340] powernow_k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor
5600+ (2 cpu cores) (version 2.20.00)
[    1.534351] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.534352] EDD information not available.
[    1.534419] PM: Hibernation image not present or could not be loaded.
[    1.535245] Freeing unused kernel memory: 1464K (ffffffff81d37000 -
ffffffff81ea5000)
[    1.535249] Write protecting the kernel read-only data: 12288k
[    1.535410] Freeing unused kernel memory: 20K (ffff8800017fb000 -
ffff880001800000)
[    1.535599] Freeing unused kernel memory: 292K (ffff880001bb7000 -
ffff880001c00000)
[    1.552380] random: systemd-udevd urandom read with 2 bits of entropy
available
[    1.601652] ahci 0000:00:11.0: version 3.0
[    1.601972] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps
0x3f impl SATA mode
[    1.601976] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp
pio slum part ccc 
[    1.606121] scsi host0: ahci
[    1.606251] scsi host1: ahci
[    1.606353] scsi host2: ahci
[    1.606451] scsi host3: ahci
[    1.606544] scsi host4: ahci
[    1.606645] scsi host5: ahci
[    1.606708] ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00
irq 22
[    1.606712] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80
irq 22
[    1.606715] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00
irq 22
[    1.606718] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80
irq 22
[    1.606721] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00
irq 22
[    1.606723] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80
irq 22
[    1.610161] Floppy drive(s): fd0 is 1.44M
[    1.612883] wmi: Mapper loaded
[    1.615013] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.615028] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM
control
[    1.615434] r8169 0000:02:00.0 eth0: RTL8168c/8111c at
0xffffc90000748000, 00:21:85:9d:65:7a, XID 1c4000c0 IRQ 25
[    1.615437] r8169 0000:02:00.0 eth0: jumbo features [frames: 6128 bytes,
tx checksumming: ko]
[    1.625148] [drm] Initialized drm 1.1.0 20060810
[    1.628600] scsi host6: pata_atiixp
[    1.632982] scsi host7: pata_atiixp
[    1.634382] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq
14
[    1.634387] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq
15
[    1.663124] [drm] radeon kernel modesetting enabled.
[    1.666030] AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>
[    1.666034] AMD IOMMUv2 functionality not available on this system
[    1.669710] CRAT table not found
[    1.669714] Finished initializing topology ret=0
[    1.669777] kfd kfd: Initialized module
[    1.670391] checking generic (d0000000 760000) vs hw (d0000000 10000000)
[    1.670394] fb: switching to radeondrmfb from VESA VGA
[    1.670435] Console: switching to colour dummy device 80x25
[    1.670841] [drm] initializing kernel modesetting (RS780 0x1002:0x9614
0x1462:0x7550).
[    1.670854] [drm] register mmio base: 0xFE9E0000
[    1.670855] [drm] register mmio size: 65536
[    1.671635] ATOM BIOS: 113
[    1.671672] radeon 0000:01:05.0: VRAM: 256M 0x00000000C0000000 -
0x00000000CFFFFFFF (256M used)
[    1.671674] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 -
0x00000000BFFFFFFF
[    1.671678] [drm] Detected VRAM RAM=256M, BAR=256M
[    1.671680] [drm] RAM width 32bits DDR
[    1.671768] [TTM] Zone  kernel: Available graphics memory: 1893758 kiB
[    1.671769] [TTM] Initializing pool allocator
[    1.671777] [TTM] Initializing DMA pool allocator
[    1.671802] [drm] radeon: 256M of VRAM memory ready
[    1.671803] [drm] radeon: 512M of GTT memory ready.
[    1.671814] [drm] Loading RS780 Microcode
[    1.671905] [drm] radeon: power management initialized
[    1.672055] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.690813] [drm] PCIE GART of 512M enabled (table at
0x00000000C0258000).
[    1.691722] radeon 0000:01:05.0: WB enabled
[    1.691728] radeon 0000:01:05.0: fence driver on ring 0 use gpu addr
0x00000000a0000c00 and cpu addr 0xffff8800cf055c00
[    1.692608] r8169 0000:02:00.0 enp2s0: renamed from eth0
[    1.698579] radeon 0000:01:05.0: fence driver on ring 5 use gpu addr
0x00000000c0056038 and cpu addr 0xffffc90001016038
[    1.698583] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.698584] [drm] Driver supports precise vblank timestamp query.
[    1.698586] radeon 0000:01:05.0: radeon: MSI limited to 32-bit
[    1.698601] [drm] radeon: irq initialized.
[    1.729643] [drm] ring test on 0 succeeded in 1 usecs
[    1.800519] ata8.00: ATAPI: _NEC DVD_RW ND-4550A, 1.07, max UDMA/33
[    1.816495] ata8.00: configured for UDMA/33
[    1.904313] [drm] ring test on 5 succeeded in 1 usecs
[    1.904319] [drm] UVD initialized successfully.
[    1.904476] [drm] ib test on ring 0 succeeded in 0 usecs
[    1.924043] ata4: SATA link down (SStatus 0 SControl 300)
[    1.924081] ata6: SATA link down (SStatus 0 SControl 300)
[    1.924112] ata5: SATA link down (SStatus 0 SControl 300)
[    1.924165] ata2: SATA link down (SStatus 0 SControl 300)
[    1.924196] ata1: SATA link down (SStatus 0 SControl 300)
[    1.960023] usb 6-1: new low-speed USB device number 2 using ohci-pci
[    2.129997] usb 6-1: New USB device found, idVendor=045e, idProduct=009d
[    2.129999] usb 6-1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    2.130001] usb 6-1: Product: Microsoft Wireless Optical DesktopR 2.10
[    2.130003] usb 6-1: Manufacturer: Microsoft
[    2.135602] hidraw: raw HID events driver (C) Jiri Kosina
[    2.158043] usbcore: registered new interface driver usbhid
[    2.158047] usbhid: USB HID core driver
[    2.160161] input: Microsoft Microsoft Wireless Optical DesktopR 2.10 as
/devices/pci0000:00/0000:00:13.1/usb6/6-1/6-1:1.0/0003:045E:009D.0001/input/
input5
[    2.216141] microsoft 0003:045E:009D.0001: input,hidraw0: USB HID v1.11
Keyboard [Microsoft Microsoft Wireless Optical DesktopR 2.10] on
usb-0000:00:13.1-1/input0
[    2.217581] input: Microsoft Microsoft Wireless Optical DesktopR 2.10 as
/devices/pci0000:00/0000:00:13.1/usb6/6-1/6-1:1.1/0003:045E:009D.0002/input/
input6
[    2.264021] ata3: softreset failed (device not ready)
[    2.264024] ata3: applying PMP SRST workaround and retrying
[    2.272226] microsoft 0003:045E:009D.0002: input,hidraw1: USB HID v1.11
Mouse [Microsoft Microsoft Wireless Optical DesktopR 2.10] on
usb-0000:00:13.1-1/input1
[    2.552042] [drm] ib test on ring 5 succeeded
[    2.552627] [drm] Radeon Display Connectors
[    2.552629] [drm] Connector 0:
[    2.552630] [drm]   VGA-1
[    2.552632] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c
0x7e4c
[    2.552633] [drm]   Encoders:
[    2.552634] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.552635] [drm] Connector 1:
[    2.552636] [drm]   HDMI-A-1
[    2.552637] [drm]   HPD3
[    2.552638] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c
0x7e5c
[    2.552639] [drm]   Encoders:
[    2.552640] [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
[    2.604058] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.608287] ata3.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    2.608289] ata3.00: 390721968 sectors, multi 0: LBA48 
[    2.610441] [drm] fb mappable at 0xD0359000
[    2.610442] [drm] vram apper at 0xD0000000
[    2.610443] [drm] size 9216000
[    2.610444] [drm] fb depth is 24
[    2.610445] [drm]    pitch is 7680
[    2.610510] fbcon: radeondrmfb (fb0) is primary device
[    2.610620] Console: switching to colour frame buffer device 240x75
[    2.610665] radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
[    2.610667] radeon 0000:01:05.0: registered panic notifier
[    2.612469] ata3.00: configured for UDMA/133
[    2.612632] scsi 2:0:0:0: Direct-Access     ATA      ST3200822AS
3.01 PQ: 0 ANSI: 5
[    2.612909] sd 2:0:0:0: [sda] 390721968 512-byte logical blocks: (200
GB/186 GiB)
[    2.612960] sd 2:0:0:0: [sda] Write Protect is off
[    2.612963] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.612985] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    2.613001] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[    2.614341] scsi 7:0:0:0: CD-ROM            _NEC     DVD_RW ND-4550A
1.07 PQ: 0 ANSI: 5
[    2.616147] [drm] Initialized radeon 2.43.0 20080528 for 0000:01:05.0 on
minor 0
[    2.621250] sr 7:0:0:0: [sr0] scsi3-mmc drive: 48x/48x writer dvd-ram
cd/rw xa/form2 cdda tray
[    2.621255] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.621413] sr 7:0:0:0: Attached scsi CD-ROM sr0
[    2.621568] sr 7:0:0:0: Attached scsi generic sg1 type 5
[    2.657314]  sda: sda1 sda2 < sda5 >
[    2.657676] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.624041] floppy0: no floppy controllers found
[    4.830505] EXT4-fs (sda1): mounted filesystem with ordered data mode.
Opts: (null)
[    5.725290] systemd[1]: Failed to insert module 'kdbus': Function not
implemented
[    5.871871] systemd[1]: systemd 225 running in system mode. (+PAM +AUDIT
+SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT
+GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[    5.872099] systemd[1]: Detected architecture x86-64.
[    5.886892] systemd[1]: Set hostname to <Sonata-Linux>.
[    6.046433] random: nonblocking pool is initialized
[    6.713649] systemd[1]: Set up automount Arbitrary Executable File
Formats File System Automount Point.
[    6.713736] systemd[1]: Created slice Root Slice.
[    6.713842] systemd[1]: Created slice User and Session Slice.
[    6.713937] systemd[1]: Created slice System Slice.
[    6.714018] systemd[1]: Listening on Journal Socket.
[    6.714912] systemd[1]: Starting Create list of required static device
nodes for the current kernel...
[    6.786440] systemd[1]: Starting Load Kernel Modules...
[    6.786632] systemd[1]: Listening on Journal Audit Socket.
[    6.786826] systemd[1]: Created slice system-getty.slice.
[    6.787732] systemd[1]: Starting Uncomplicated firewall...
[    6.788781] systemd[1]: Mounting Huge Pages File System...
[    6.788910] systemd[1]: Listening on fsck to fsckd communication Socket.
[    6.790059] systemd[1]: Starting Increase datagram queue length...
[    6.791079] systemd[1]: Mounting Debug File System...
[    6.909078] systemd[1]: Started Braille Device Support.
[    6.910592] systemd[1]: Mounting POSIX Message Queue File System...
[    6.911701] systemd[1]: Starting Setup Virtual Console...
[    6.911826] systemd[1]: Listening on /dev/initctl Compatibility Named
Pipe.
[    6.911950] systemd[1]: Started Forward Password Requests to Wall
Directory Watch.
[    6.911974] systemd[1]: Reached target User and Group Name Lookups.
[    6.912122] systemd[1]: Listening on udev Kernel Socket.
[    6.912204] systemd[1]: Listening on udev Control Socket.
[    6.912264] systemd[1]: Listening on Journal Socket (/dev/log).
[    6.912299] systemd[1]: Reached target Encrypted Volumes.
[    6.913293] systemd[1]: Started Read required files in advance.
[    6.914551] systemd[1]: Starting udev Coldplug all Devices...
[    6.914614] systemd[1]: Reached target Remote File Systems (Pre).
[    6.914651] systemd[1]: Reached target Slices.
[    6.951158] systemd[1]: Started Create list of required static device
nodes for the current kernel.
[    6.952351] systemd[1]: Starting Create Static Device Nodes in /dev...
[    7.056516] systemd[1]: Started Setup Virtual Console.
[    7.289292] systemd[1]: Started Uncomplicated firewall.
[    7.509943] systemd[1]: Mounted Debug File System.
[    7.509998] systemd[1]: Mounted POSIX Message Queue File System.
[    7.510020] systemd[1]: Mounted Huge Pages File System.
[    7.510412] systemd[1]: Started Increase datagram queue length.
[    7.510771] systemd[1]: Listening on Syslog Socket.
[    7.511731] systemd[1]: Starting Journal Service...
[    7.547421] systemd[1]: Started udev Coldplug all Devices.
[    7.647914] lp: driver loaded but no devices found
[    7.728686] ppdev: user-space parallel port driver
[    7.834458] systemd[1]: Started Load Kernel Modules.
[    7.835437] systemd[1]: Mounting FUSE Control File System...
[    7.838276] systemd[1]: Starting Apply Kernel Variables...
[    7.839783] systemd[1]: Mounted FUSE Control File System.
[    8.519335] systemd[1]: Started Journal Service.
[    9.101443] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    9.414045] systemd-journald[232]: Received request to flush runtime
journal from PID 1
[   10.237994] ACPI Warning: SystemIO range
0x0000000000000B00-0x0000000000000B07 conflicts with OpRegion
0x0000000000000B00-0x0000000000000B0F (\SOR1) (20150619/utaddress-254)
[   10.238003] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[   10.268387] Floppy drive(s): fd0 is 1.44M
[   10.433840] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.497748] MCE: In-kernel MCE decoding enabled.
[   10.609080] k8temp 0000:00:18.3: Temperature readouts might be wrong -
check erratum #141
[   10.677336] EDAC MC: Ver: 3.0.0
[   10.731018] AMD64 EDAC driver v3.4.0
[   10.731059] EDAC amd64: DRAM ECC disabled.
[   10.731064] EDAC amd64: ECC disabled in the BIOS or no ECC capability,
module will not load.
                Either enable ECC checking or force module loading by
setting 'ecc_enable_override'.
                (Note that use of the override may cause unknown side
effects.)
[   10.823520] media: Linux media interface: v0.10
[   11.217347] Linux video capture interface: v2.00
[   11.340716] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver
chip loaded successfully
[   11.468727] kvm: Nested Virtualization enabled
[   11.607875] flexcop-pci: will use the HW PID filter.
[   11.607880] flexcop-pci: card revision 2
[   11.624213] DVB: registering new adapter (FlexCop Digital TV device)
[   11.625970] b2c2-flexcop: MAC address = 00:08:c9:e1:12:58
[   11.626262] CX24123: wrong demod revision: 43
[   12.202447] saa7134: saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   12.207902] input: HDA ATI HDMI HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.0/0000:01:05.1/sound/card1/input7
[   12.278338] mt352_read_register: readreg error (reg=127, ret==-121)
[   12.338371] snd_hda_codec_realtek hdaudioC0D3: autoconfig for ALC888:
line_outs=4 (0x14/0x15/0x16/0x17/0x0) type:line
[   12.338377] snd_hda_codec_realtek hdaudioC0D3:    speaker_outs=0
(0x0/0x0/0x0/0x0/0x0)
[   12.338379] snd_hda_codec_realtek hdaudioC0D3:    hp_outs=1
(0x1b/0x0/0x0/0x0/0x0)
[   12.338381] snd_hda_codec_realtek hdaudioC0D3:    mono: mono_out=0x0
[   12.338383] snd_hda_codec_realtek hdaudioC0D3:    dig-out=0x1e/0x0
[   12.338384] snd_hda_codec_realtek hdaudioC0D3:    inputs:
[   12.338387] snd_hda_codec_realtek hdaudioC0D3:      Front Mic=0x19
[   12.338389] snd_hda_codec_realtek hdaudioC0D3:      Rear Mic=0x18
[   12.338391] snd_hda_codec_realtek hdaudioC0D3:      Line=0x1a
[   12.353485] nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err ==
-121)
[   12.353491] nxt200x: Unknown/Unsupported NXT chip: 00 00 00 00 00
[   12.358876] input: HDA ATI SB Front Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   12.358948] input: HDA ATI SB Rear Mic as
/devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   12.359632] input: HDA ATI SB Line as
/devices/pci0000:00/0000:00:14.2/sound/card0/input10
[   12.359710] input: HDA ATI SB Line Out Front as
/devices/pci0000:00/0000:00:14.2/sound/card0/input11
[   12.359770] input: HDA ATI SB Line Out Surround as
/devices/pci0000:00/0000:00:14.2/sound/card0/input12
[   12.359834] input: HDA ATI SB Line Out CLFE as
/devices/pci0000:00/0000:00:14.2/sound/card0/input13
[   12.359895] input: HDA ATI SB Line Out Side as
/devices/pci0000:00/0000:00:14.2/sound/card0/input14
[   12.359956] input: HDA ATI SB Front Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card0/input15
[   12.425159] lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02 error
(ret == -121)
[   12.583823] stv0297_readreg: readreg error (reg == 0x80, ret == -121)
[   12.638433] mt312_read: ret == -121
[   12.777565] cx24120: Conexant cx24120/cx24118 - DVBS/S2 Satellite
demod/tuner
[   12.777696] cx24120: Demod cx24120 rev. 0x07 detected.
[   12.777698] cx24120: Conexant cx24120/cx24118 attached.
[   12.913308] b2c2-flexcop: ISL6421 successfully attached.
[   12.913313] b2c2-flexcop: found 'Conexant CX24120/CX24118' .
[   12.913319] b2c2_flexcop_pci 0000:03:06.0: DVB: registering adapter 0
frontend 0 (Conexant CX24120/CX24118)...
[   12.913404] b2c2-flexcop: initialization of 'Sky2PC/SkyStar S2 DVB-S/S2
rev 3.3' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
[   12.915606] saa7134: saa7133[0]: found at 0000:03:05.0, rev: 209, irq:
20, latency: 64, mmio: 0xfebff800
[   12.915613] saa7134: saa7133[0]: subsystem: 185b:c900, board: Compro
VideoMate S350/S300 [card=169,insmod option]
[   12.915635] saa7134: saa7133[0]: board init: gpio is 843f00
[   13.056027] Registered IR keymap rc-videomate-s350
[   13.056128] input: saa7134 IR (Compro VideoMate S3 as
/devices/pci0000:00/0000:00:14.4/0000:03:05.0/rc/rc0/input16
[   13.056204] rc0: saa7134 IR (Compro VideoMate S3 as
/devices/pci0000:00/0000:00:14.4/0000:03:05.0/rc/rc0
[   13.212036] saa7134: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c
55 d2 b2 92
[   13.212041] saa7134: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff
ff ff ff ff
[   13.212043] saa7134: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87
ff ff ff ff
[   13.212044] saa7134: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212046] saa7134: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff
ff ff ff ff
[   13.212047] saa7134: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff cb
[   13.212048] saa7134: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212049] saa7134: i2c eeprom 70: 00 00 00 01 4d 24 ff ff ff ff ff ff
ff ff ff ff
[   13.212050] saa7134: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212051] saa7134: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212052] saa7134: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212054] saa7134: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212055] saa7134: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212056] saa7134: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212057] saa7134: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212058] saa7134: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[   13.212535] saa7134: saa7133[0]: registered device video0 [v4l2]
[   13.212662] saa7134: saa7133[0]: registered device vbi0
[   13.237365] saa7134_alsa: saa7134 ALSA driver for DMA sound loaded
[   13.237399] saa7134_alsa: saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq
20 registered as card -2
[   13.284052] floppy0: no floppy controllers found
[   13.286370] saa7134_dvb: dvb_init() allocating 1 frontend
[   13.376021] DVB: registering new adapter (saa7133[0])
[   13.376031] saa7134 0000:03:05.0: DVB: registering adapter 1 frontend 0
(Zarlink ZL10313 DVB-S)...
[   14.049041] Adding 3929084k swap on /dev/sda5.  Priority:-1 extents:1
across:3929084k FS
[   14.402744] audit: type=1400 audit(1457615712.364:2): apparmor="STATUS"
operation="profile_load" profile="unconfined"
name="/usr/lib/lightdm/lightdm-guest-session" pid=484 comm="apparmor_parser"
[   14.402756] audit: type=1400 audit(1457615712.364:3): apparmor="STATUS"
operation="profile_load" profile="unconfined" name="chromium" pid=484
comm="apparmor_parser"
[   14.503586] audit: type=1400 audit(1457615712.468:4): apparmor="STATUS"
operation="profile_load" profile="unconfined" name="/sbin/dhclient" pid=484
comm="apparmor_parser"
[   14.503600] audit: type=1400 audit(1457615712.468:5): apparmor="STATUS"
operation="profile_load" profile="unconfined"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=484
comm="apparmor_parser"
[   14.503605] audit: type=1400 audit(1457615712.468:6): apparmor="STATUS"
operation="profile_load" profile="unconfined"
name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=484 comm="apparmor_parser"
[   14.503610] audit: type=1400 audit(1457615712.468:7): apparmor="STATUS"
operation="profile_load" profile="unconfined"
name="/usr/lib/connman/scripts/dhclient-script" pid=484
comm="apparmor_parser"
[   14.664237] audit: type=1400 audit(1457615712.628:8): apparmor="STATUS"
operation="profile_load" profile="unconfined" name="/usr/bin/evince" pid=484
comm="apparmor_parser"
[   14.664251] audit: type=1400 audit(1457615712.628:9): apparmor="STATUS"
operation="profile_load" profile="unconfined" name="sanitized_helper"
pid=484 comm="apparmor_parser"
[   14.664257] audit: type=1400 audit(1457615712.628:10): apparmor="STATUS"
operation="profile_load" profile="unconfined"
name="/usr/bin/evince-previewer" pid=484 comm="apparmor_parser"
[   14.664262] audit: type=1400 audit(1457615712.628:11): apparmor="STATUS"
operation="profile_load" profile="unconfined" name="sanitized_helper"
pid=484 comm="apparmor_parser"
[   16.487527] cgroup: new mount options do not match the existing
superblock, will be ignored
[   25.887101] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   25.897406] r8169 0000:02:00.0 enp2s0: link down
[   25.897480] r8169 0000:02:00.0 enp2s0: link down
[   25.897564] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   28.719113] r8169 0000:02:00.0 enp2s0: link up
[   28.719126] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready


