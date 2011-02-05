Return-path: <mchehab@pedra>
Received: from mx6.orcon.net.nz ([219.88.242.56]:44411 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1BEKLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Feb 2011 05:11:44 -0500
Received: from Debian-exim by mx6.orcon.net.nz with local (Exim 4.69)
	(envelope-from <lists@whitehouse.org.nz>)
	id 1PleoE-0005dq-UN
	for linux-media@vger.kernel.org; Sat, 05 Feb 2011 22:52:03 +1300
Received: from [121.98.204.64] (helo=[192.168.0.104])
	by mx6.orcon.net.nz with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <lists@whitehouse.org.nz>)
	id 1PleoB-0005dL-MK
	for linux-media@vger.kernel.org; Sat, 05 Feb 2011 22:52:02 +1300
Message-ID: <4D4D1DBE.5000004@whitehouse.org.nz>
Date: Sat, 05 Feb 2011 22:51:58 +1300
From: Aaron Whitehouse <lists@whitehouse.org.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge hvr-2200 stops working when Hauppauge hvr-1110 is connected
References: <4C6F68C6.4080007@whitehouse.org.nz>
In-Reply-To: <4C6F68C6.4080007@whitehouse.org.nz>
Content-Type: multipart/mixed;
 boundary="------------000107030801050707000805"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------000107030801050707000805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello again,

I posted this:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg21610.html
some time ago now.


On 21/08/10 17:48, Aaron Whitehouse wrote:
> I have been happily using Mythbuntu with a Hauppauge hvr-2200 dual tuner
> DVB-T for many months (thanks Steven Toth!) and it records all my TV in
> MythTV.
> NZ has three DVB-T multiplexes, so I bought a second single-tuner DVB-T
> card, a Hauppauge hvr-1110, to cover the third multiplex and mean that,
> with multirec, I can record all channels and never hit a conflict.

> Unfortunately, when I have both cards in with their firmware, the
> hvr-1110 stops the hvr-2220 registering its two adapters. 

This is still happening to me with the latest Mythbuntu (10.10).

Please let me know if anybody is interested in helping me resolve the
issue, as I intend to sell the card given that it's been a paperweight
for months.

Thanks all for your work so far,

Aaron

--------------000107030801050707000805
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-24-generic (buildd@yellow) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC 2010 (Ubuntu 2.6.35-24.42-generic 2.6.35.8)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fde0000 (usable)
[    0.000000]  BIOS-e820: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fde3000 - 000000007fdf0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fdf0000 - 000000007fe00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7fde0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 007FE00000 mask FFFFE00000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007fde0000 (usable)
[    0.000000]  modified: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
[    0.000000]  modified: 000000007fde3000 - 000000007fdf0000 (ACPI data)
[    0.000000]  modified: 000000007fdf0000 - 000000007fe00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5820] f5820
[    0.000000] init_memory_mapping: 0000000000000000-000000007fde0000
[    0.000000]  0000000000 - 007fc00000 page 2M
[    0.000000]  007fc00000 - 007fde0000 page 4k
[    0.000000] kernel direct mapping tables up to 7fde0000 @ 16000-1a000
[    0.000000] RAMDISK: 37571000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f71a0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 000000007fde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 000000007fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 000000007fde30c0 06467 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 000000007fde0000 00040
[    0.000000] ACPI: SSDT 000000007fde9600 00115 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 000000007fde9740 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 000000007fde9780 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 000000007fde9540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fde0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007fde0000
[    0.000000]   NODE_DATA [0000000001d18100 - 0000000001d1d0ff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fde0
[    0.000000] On node 0 totalpages: 523631
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7105 pages used for memmap
[    0.000000]   DMA32 zone: 512543 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 3 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 7fe00000 (gap: 7fe00000:60200000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u524288
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516470
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 3e0000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (48 early reservations)
[    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
[    0.000000]   #2 [0037571000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d18000 - 0001d180fe]             BRK
[    0.000000]   #4 [00000f5830 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f5820 - 00000f5830]    MP-table mpf
[    0.000000]   #6 [000009f800 - 00000f0f00]   BIOS reserved
[    0.000000]   #7 [00000f1070 - 00000f5820]   BIOS reserved
[    0.000000]   #8 [00000f0f00 - 00000f1070]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001d18100 - 0001d1d100]       NODE_DATA
[    0.000000]   #13 [0001d1d100 - 0001d1e100]         BOOTMEM
[    0.000000]   #14 [0001d17140 - 0001d172c0]         BOOTMEM
[    0.000000]   #15 [000251f000 - 0002520000]         BOOTMEM
[    0.000000]   #16 [0002520000 - 0002521000]         BOOTMEM
[    0.000000]   #17 [0002600000 - 0004200000]        MEMMAP 0
[    0.000000]   #18 [0001d172c0 - 0001d17440]         BOOTMEM
[    0.000000]   #19 [0001d1e100 - 0001d2a100]         BOOTMEM
[    0.000000]   #20 [0001d2b000 - 0001d2c000]         BOOTMEM
[    0.000000]   #21 [0001d17440 - 0001d17481]         BOOTMEM
[    0.000000]   #22 [0001d174c0 - 0001d17503]         BOOTMEM
[    0.000000]   #23 [0001d17540 - 0001d17770]         BOOTMEM
[    0.000000]   #24 [0001d17780 - 0001d177e8]         BOOTMEM
[    0.000000]   #25 [0001d17800 - 0001d17868]         BOOTMEM
[    0.000000]   #26 [0001d17880 - 0001d178e8]         BOOTMEM
[    0.000000]   #27 [0001d17900 - 0001d17968]         BOOTMEM
[    0.000000]   #28 [0001d17980 - 0001d179e8]         BOOTMEM
[    0.000000]   #29 [0001d17a00 - 0001d17a68]         BOOTMEM
[    0.000000]   #30 [0001d17a80 - 0001d17ae8]         BOOTMEM
[    0.000000]   #31 [0001d17b00 - 0001d17b68]         BOOTMEM
[    0.000000]   #32 [0001d17b80 - 0001d17be8]         BOOTMEM
[    0.000000]   #33 [0001d17c00 - 0001d17c20]         BOOTMEM
[    0.000000]   #34 [0001d17c40 - 0001d17caa]         BOOTMEM
[    0.000000]   #35 [0001d17cc0 - 0001d17d2a]         BOOTMEM
[    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #37 [0001e80000 - 0001e9e000]         BOOTMEM
[    0.000000]   #38 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #39 [0001f80000 - 0001f9e000]         BOOTMEM
[    0.000000]   #40 [0001d17d40 - 0001d17d48]         BOOTMEM
[    0.000000]   #41 [0001d17d80 - 0001d17d88]         BOOTMEM
[    0.000000]   #42 [0001d17dc0 - 0001d17dd0]         BOOTMEM
[    0.000000]   #43 [0001d17e00 - 0001d17e20]         BOOTMEM
[    0.000000]   #44 [0001d17e40 - 0001d17f70]         BOOTMEM
[    0.000000]   #45 [0001d17f80 - 0001d17fd0]         BOOTMEM
[    0.000000]   #46 [0001d2a100 - 0001d2a150]         BOOTMEM
[    0.000000]   #47 [0001d2c000 - 0001d34000]         BOOTMEM
[    0.000000] Memory: 2041064k/2094976k available (5711k kernel code, 452k absent, 53460k reserved, 5379k data, 908k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2104.783 MHz processor.
[    0.010011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4209.56 BogoMIPS (lpj=21047830)
[    0.010016] pid_max: default: 32768 minimum: 301
[    0.010045] Security Framework initialized
[    0.010066] AppArmor: AppArmor initialized
[    0.010068] Yama: becoming mindful.
[    0.010375] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.012018] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.012797] Mount-cache hash table entries: 256
[    0.012983] Initializing cgroup subsys ns
[    0.012987] Initializing cgroup subsys cpuacct
[    0.012992] Initializing cgroup subsys memory
[    0.013003] Initializing cgroup subsys devices
[    0.013006] Initializing cgroup subsys freezer
[    0.013009] Initializing cgroup subsys net_cls
[    0.013042] tseg: 007fe00000
[    0.013045] mce: CPU supports 5 MCE banks
[    0.013057] using C1E aware idle routine
[    0.013059] Performance Events: AMD PMU driver.
[    0.013065] ... version:                0
[    0.013067] ... bit width:              48
[    0.013068] ... generic registers:      4
[    0.013070] ... value mask:             0000ffffffffffff
[    0.013072] ... max period:             00007fffffffffff
[    0.013074] ... fixed-purpose events:   0
[    0.013076] ... event mask:             000000000000000f
[    0.013111] SMP alternatives: switching to UP code
[    0.023844] ACPI: Core revision 20100428
[    0.040026] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040039] ftrace: allocating 22678 entries in 89 pages
[    0.050099] Setting APIC routing to flat
[    0.050666] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.158631] CPU0: AMD Sempron(tm) Processor LE-1200 stepping 01
[    0.160000] Brought up 1 CPUs
[    0.160000] Total of 1 processors activated (4209.56 BogoMIPS).
[    0.160000] devtmpfs: initialized
[    0.160000] regulator: core version 0.5
[    0.160000] Time:  2:36:00  Date: 01/16/11
[    0.160000] NET: Registered protocol family 16
[    0.160000] node 0 link 0: io port [b000, ffff]
[    0.160000] TOM: 0000000080000000 aka 2048M
[    0.160000] node 0 link 0: mmio [a0000, bffff]
[    0.160000] node 0 link 0: mmio [80000000, fe02ffff]
[    0.160000] node 0 link 0: mmio [e0000000, efffffff]
[    0.160000] bus: [00, 04] on node 0 link 0
[    0.160000] bus: 00 index 0 [io  0x0000-0xffff]
[    0.160000] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.160000] bus: 00 index 2 [mem 0x80000000-0xfcffffffff]
[    0.160000] ACPI: bus type pci registered
[    0.160000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.160000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.171594] PCI: Using configuration type 1 for base access
[    0.172811] bio: create slab <bio-0> at 0
[    0.173702] ACPI: EC: Look up EC in DSDT
[    0.185281] ACPI: Interpreter enabled
[    0.185287] ACPI: (supports S0 S3 S4 S5)
[    0.185332] ACPI: Using IOAPIC for interrupt routing
[    0.195523] ACPI: No dock devices found.
[    0.195527] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.195714] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.196093] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.196096] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.196100] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.196103] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.196107] pci_root PNP0A03:00: host bridge window [mem 0x7ff00000-0xfebfffff]
[    0.196136] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.196209] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.196212] pci 0000:00:02.0: PME# disabled
[    0.196259] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.196262] pci 0000:00:04.0: PME# disabled
[    0.196313] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.196316] pci 0000:00:0a.0: PME# disabled
[    0.196365] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.196372] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.196380] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.196387] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.196394] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.196402] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.196459] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.196519] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.196592] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.196650] pci 0000:00:12.2: supports D1 D2
[    0.196652] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.196657] pci 0000:00:12.2: PME# disabled
[    0.196696] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.196756] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.196829] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.196886] pci 0000:00:13.2: supports D1 D2
[    0.196889] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.196893] pci 0000:00:13.2: PME# disabled
[    0.197013] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.197021] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.197028] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.197035] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.197043] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.197111] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.197159] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.197163] pci 0000:00:14.2: PME# disabled
[    0.197283] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.197450] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.197460] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.197470] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.197477] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
[    0.197483] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.210016] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.210020] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.210024] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.210029] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.210092] pci 0000:02:00.0: reg 10: [mem 0xfd400000-0xfd7fffff 64bit]
[    0.210107] pci 0000:02:00.0: reg 18: [mem 0xfd000000-0xfd3fffff 64bit]
[    0.210164] pci 0000:02:00.0: supports D1 D2
[    0.210166] pci 0000:02:00.0: PME# supported from D0 D1 D2
[    0.210171] pci 0000:02:00.0: PME# disabled
[    0.230011] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.230015] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.230019] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
[    0.230024] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.230079] pci 0000:03:00.0: reg 10: [io  0xce00-0xceff]
[    0.230096] pci 0000:03:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
[    0.230109] pci 0000:03:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
[    0.230116] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.230150] pci 0000:03:00.0: supports D1 D2
[    0.230152] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.230156] pci 0000:03:00.0: PME# disabled
[    0.250011] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.250016] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.250019] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.250024] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.250086] pci 0000:04:06.0: reg 10: [mem 0xfddff000-0xfddff7ff]
[    0.250153] pci 0000:04:06.0: supports D1 D2
[    0.250208] pci 0000:04:0e.0: reg 10: [mem 0xfddfe000-0xfddfe7ff]
[    0.250217] pci 0000:04:0e.0: reg 14: [mem 0xfddf8000-0xfddfbfff]
[    0.250280] pci 0000:04:0e.0: supports D1 D2
[    0.250282] pci 0000:04:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.250287] pci 0000:04:0e.0: PME# disabled
[    0.250325] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.250331] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.250335] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.250341] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    0.250343] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.250346] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.250349] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.250351] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.250354] pci 0000:00:14.4:   bridge window [mem 0x7ff00000-0xfebfffff] (subtractive decode)
[    0.250375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.250975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.251143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.251245] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.251365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.296172] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.296318] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.296462] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.296606] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.296749] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.296893] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.297037] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.297181] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.297232] HEST: Table is not found!
[    0.297332] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.297337] vgaarb: loaded
[    0.297507] SCSI subsystem initialized
[    0.297580] libata version 3.00 loaded.
[    0.297645] usbcore: registered new interface driver usbfs
[    0.297658] usbcore: registered new interface driver hub
[    0.297694] usbcore: registered new device driver usb
[    0.297929] ACPI: WMI: Mapper loaded
[    0.297931] PCI: Using ACPI for IRQ routing
[    0.297934] PCI: pci_cache_line_size set to 64 bytes
[    0.297945] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.298043] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.298047] reserve RAM buffer: 000000007fde0000 - 000000007fffffff 
[    0.298158] NetLabel: Initializing
[    0.298161] NetLabel:  domain hash size = 128
[    0.298162] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.298178] NetLabel:  unlabeled traffic allowed by default
[    0.298225] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.298230] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.300032] Switching to clocksource hpet
[    0.314460] AppArmor: AppArmor Filesystem Enabled
[    0.314482] pnp: PnP ACPI init
[    0.314504] ACPI: bus type pnp registered
[    0.316155] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.316206] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.316217] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.322097] pnp 00:0d: disabling [mem 0x000d1a00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322102] pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322108] pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322113] pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322118] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322123] pnp 00:0d: disabling [mem 0x00100000-0x7fddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.322290] pnp: PnP ACPI: found 14 devices
[    0.322292] ACPI: ACPI bus type pnp unregistered
[    0.322309] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.322314] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.322319] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.322329] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.322334] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.322339] system 00:02: [io  0x0238-0x023f] has been reserved
[    0.322344] system 00:02: [io  0x040b] has been reserved
[    0.322349] system 00:02: [io  0x04d6] has been reserved
[    0.322354] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.322359] system 00:02: [io  0x0c14] has been reserved
[    0.322364] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.322369] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.322374] system 00:02: [io  0x0c6f] has been reserved
[    0.322379] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.322384] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.322389] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.322394] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.322399] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.322404] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.322409] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.322414] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.322420] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.322433] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.322445] system 00:0d: [mem 0x7fde0000-0x7fdfffff] could not be reserved
[    0.322450] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
[    0.322456] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.322462] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.322467] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.330615] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb01ffff pref]
[    0.330620] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.330624] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
[    0.330628] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
[    0.330631] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.330636] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.330639] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.330643] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
[    0.330646] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.330652] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
[    0.330656] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.330658] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
[    0.330662] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.330666] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.330671] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.330675] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
[    0.330681] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.330686] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
[    0.330703]   alloc irq_desc for 18 on node 0
[    0.330706]   alloc kstat_irqs on node 0
[    0.330720] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.330725] pci 0000:00:02.0: setting latency timer to 64
[    0.330733]   alloc irq_desc for 16 on node 0
[    0.330736]   alloc kstat_irqs on node 0
[    0.330746] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.330750] pci 0000:00:04.0: setting latency timer to 64
[    0.330758] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.330761] pci 0000:00:0a.0: setting latency timer to 64
[    0.330770] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.330773] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.330775] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.330778] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.330780] pci_bus 0000:00: resource 8 [mem 0x7ff00000-0xfebfffff]
[    0.330783] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.330786] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
[    0.330788] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.330791] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.330793] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfd7fffff]
[    0.330796] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.330799] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.330801] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.330804] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.330807] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
[    0.330809] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.330811] pci_bus 0000:04: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
[    0.330814] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
[    0.330816] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
[    0.330819] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
[    0.330821] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
[    0.330824] pci_bus 0000:04: resource 8 [mem 0x7ff00000-0xfebfffff]
[    0.330882] NET: Registered protocol family 2
[    0.331171] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.332227] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.335327] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.335999] TCP: Hash tables configured (established 262144 bind 65536)
[    0.336002] TCP reno registered
[    0.336018] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.336051] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.336279] NET: Registered protocol family 1
[    1.360021] pci 0000:00:12.1: OHCI: BIOS handoff failed (BIOS bug?) 00000184
[    1.450065] pci 0000:01:00.0: Boot video device
[    1.450086] PCI: CLS 4 bytes, default 64
[    1.450339] Trying to unpack rootfs image as initramfs...
[    1.510603] Scanning for low memory corruption every 60 seconds
[    1.510823] audit: initializing netlink socket (disabled)
[    1.510840] type=2000 audit(1295145361.510:1): initialized
[    1.540235] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.544354] VFS: Disk quotas dquot_6.5.2
[    1.544490] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.546061] fuse init (API version 7.14)
[    1.546299] msgmni has been set to 3986
[    1.560418] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.560423] io scheduler noop registered
[    1.560425] io scheduler deadline registered
[    1.560533] io scheduler cfq registered (default)
[    1.560863] pcieport 0000:00:02.0: setting latency timer to 64
[    1.560891]   alloc irq_desc for 40 on node 0
[    1.560893]   alloc kstat_irqs on node 0
[    1.560904] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    1.561060] pcieport 0000:00:04.0: setting latency timer to 64
[    1.561084]   alloc irq_desc for 41 on node 0
[    1.561086]   alloc kstat_irqs on node 0
[    1.561092] pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
[    1.561218] pcieport 0000:00:0a.0: setting latency timer to 64
[    1.561242]   alloc irq_desc for 42 on node 0
[    1.561244]   alloc kstat_irqs on node 0
[    1.561249] pcieport 0000:00:0a.0: irq 42 for MSI/MSI-X
[    1.561396] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.561456] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.561842] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.561851] ACPI: Power Button [PWRB]
[    1.561960] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.561967] ACPI: Power Button [PWRF]
[    1.562889] ACPI: acpi_idle registered with cpuidle
[    1.581287] ERST: Table is not found!
[    1.581724] Linux agpgart interface v0.103
[    1.581729] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.581890] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.582479] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.585267] brd: module loaded
[    1.586377] loop: module loaded
[    1.590094] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.601039] Fixed MDIO Bus: probed
[    1.601143] PPP generic driver version 2.4.2
[    1.601266] tun: Universal TUN/TAP device driver, 1.6
[    1.601269] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.601540] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.601650]   alloc irq_desc for 17 on node 0
[    1.601654]   alloc kstat_irqs on node 0
[    1.601670] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.601704] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.601819] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.601871] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    1.601888] ehci_hcd 0000:00:12.2: debug port 1
[    1.601941] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    1.620050] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.620471] hub 1-0:1.0: USB hub found
[    1.620484] hub 1-0:1.0: 6 ports detected
[    1.630298]   alloc irq_desc for 19 on node 0
[    1.630302]   alloc kstat_irqs on node 0
[    1.630318] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.630354] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.630505] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.630551] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    1.630568] ehci_hcd 0000:00:13.2: debug port 1
[    1.630618] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    1.650188] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.650564] hub 2-0:1.0: USB hub found
[    1.650572] hub 2-0:1.0: 6 ports detected
[    1.650802] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.660172] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.660213] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.660390] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.660476] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    1.724601] hub 3-0:1.0: USB hub found
[    1.724619] hub 3-0:1.0: 3 ports detected
[    1.730342] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.730388] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.730536] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.730572] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.794757] hub 4-0:1.0: USB hub found
[    1.794771] hub 4-0:1.0: 3 ports detected
[    1.800257] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.800299] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.800459] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.800527] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.855951] Freeing initrd memory: 10748k freed
[    1.866561] hub 5-0:1.0: USB hub found
[    1.866574] hub 5-0:1.0: 3 ports detected
[    1.866831] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.866867] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.867015] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.867053] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.924348] hub 6-0:1.0: USB hub found
[    1.924358] hub 6-0:1.0: 3 ports detected
[    1.924539] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.924559] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.924664] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.924692] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.984341] hub 7-0:1.0: USB hub found
[    1.984351] hub 7-0:1.0: 2 ports detected
[    1.984511] uhci_hcd: USB Universal Host Controller Interface driver
[    1.984773] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.984775] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.984980] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.985186] mice: PS/2 mouse device common for all mice
[    1.985485] rtc_cmos 00:05: RTC can wake from S4
[    1.985592] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.985639] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.985878] device-mapper: uevent: version 1.0.3
[    1.986128] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    1.986217] device-mapper: multipath: version 1.1.1 loaded
[    1.986220] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.986470] cpuidle: using governor ladder
[    1.986472] cpuidle: using governor menu
[    1.987055] TCP cubic registered
[    1.987404] NET: Registered protocol family 10
[    1.989355] lo: Disabled Privacy Extensions
[    1.990282] NET: Registered protocol family 17
[    1.990365] powernow-k8: Found 1 AMD Sempron(tm) Processor LE-1200 (1 cpu cores) (version 2.20.00)
[    1.990478] powernow-k8:    0 : fid 0xd (2100 MHz), vid 0xa
[    1.990482] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xb
[    1.990485] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xd
[    1.990489] powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
[    1.990860] PM: Resume from disk failed.
[    1.990886] registered taskstats version 1
[    1.991386]   Magic number: 11:958:611
[    1.991437] pci 0000:04:0e.0: hash matches
[    1.991490] rtc_cmos 00:05: setting system clock to 2011-01-16 02:36:02 UTC (1295145362)
[    1.991493] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.991494] EDD information not available.
[    1.991649] Freeing unused kernel memory: 908k freed
[    1.992089] Write protecting the kernel read-only data: 10240k
[    1.992269] Freeing unused kernel memory: 412k freed
[    1.992657] Freeing unused kernel memory: 1644k freed
[    2.003110] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.035578] udev[100]: starting version 163
[    2.285599] Floppy drive(s): fd0 is 1.44M
[    2.534032] FDC 0 is a post-1991 82077
[    2.609536] scsi0 : pata_atiixp
[    2.650110] usb 3-2: new low speed USB device using ohci_hcd and address 2
[    2.690954] scsi1 : pata_atiixp
[    2.694092] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    2.694097] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    2.718179] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.718205] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.718260] r8169 0000:03:00.0: setting latency timer to 64
[    2.718300]   alloc irq_desc for 43 on node 0
[    2.718302]   alloc kstat_irqs on node 0
[    2.718319] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
[    2.720176] r8169 0000:03:00.0: eth0: RTL8168c/8111c at 0xffffc9000034c000, 00:1f:d0:9f:ee:1a, XID 1c4000c0 IRQ 43
[    2.723550] ahci 0000:00:11.0: version 3.0
[    2.723566]   alloc irq_desc for 22 on node 0
[    2.723568]   alloc kstat_irqs on node 0
[    2.723580] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.723723] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.723727] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    2.745142] scsi2 : ahci
[    2.757901] scsi3 : ahci
[    2.764729] scsi4 : ahci
[    2.772714] scsi5 : ahci
[    2.773346] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    2.773351] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    2.773355] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    2.773359] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    2.910376] ata2.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
[    2.910382] ata2.00: ATA-8: WDC WD10EARS-00Z5B1, 80.00A80, max UDMA/133
[    2.910386] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.930606] ata2.00: configured for UDMA/100
[    2.930797] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Z 80.0 PQ: 0 ANSI: 5
[    2.931267] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.931784] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.931977] sd 1:0:0:0: [sda] Write Protect is off
[    2.931981] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.932063] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.932562]  sda: sda1
[    2.939142] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.120044] ata5: SATA link down (SStatus 0 SControl 300)
[    3.120078] ata4: SATA link down (SStatus 0 SControl 300)
[    3.220025] usb 3-3: new low speed USB device using ohci_hcd and address 3
[    3.320021] ata3: softreset failed (device not ready)
[    3.320024] ata3: applying SB600 PMP SRST workaround and retrying
[    3.320045] ata6: softreset failed (device not ready)
[    3.320048] ata6: applying SB600 PMP SRST workaround and retrying
[    3.480246] usbcore: registered new interface driver hiddev
[    3.481074] usbcore: registered new interface driver usbhid
[    3.481077] usbhid: USB HID core driver
[    3.520036] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.520068] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.520289] ata6.00: ATAPI: ATAPI   iHAS120   6, 7L0F, max UDMA/100
[    3.520991] ata6.00: configured for UDMA/100
[    3.536173] ata3.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
[    3.536285] ata3.00: ATA-8: WDC WD10EURS-630AB1, 80.00A80, max UDMA/133
[    3.536288] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    3.539356] ata3.00: configured for UDMA/133
[    3.550183] scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EURS-630 80.0 PQ: 0 ANSI: 5
[    3.550631] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    3.551257] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.551261] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[    3.551483] sd 2:0:0:0: [sdb] Write Protect is off
[    3.551488] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.551564] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.552008] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS120   6      7L0F PQ: 0 ANSI: 5
[    3.552850]  sdb:sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.557947] Uniform CD-ROM driver Revision: 3.20
[    3.558227] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    3.558387] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    3.561987]  sdb1 < sdb5 sdb6 sdb7 >
[    3.594252] sd 2:0:0:0: [sdb] Attached SCSI disk
[    3.632400] firewire_ohci 0000:04:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.661647] input: A4Tech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input3
[    3.662236] a4tech 0003:09DA:0006.0001: input,hidraw0: USB HID v1.10 Mouse [A4Tech USB Optical Mouse] on usb-0000:00:12.0-2/input0
[    3.690091] firewire_ohci: Added fw-ohci device 0000:04:0e.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    3.719374] input: Logitech Logitech Cordless RumblePad 2 as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input4
[    3.719786] logitech 0003:046D:C219.0002: input,hidraw1: USB HID v1.10 Gamepad [Logitech Logitech Cordless RumblePad 2] on usb-0000:00:12.0-3/input0
[    3.719792] Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>
[    3.800032] usb 4-1: new full speed USB device using ohci_hcd and address 2
[    4.190176] firewire_core: created device fw0: GUID 007d8c7800001fd0, S400
[    4.286192] EXT4-fs (sdb6): INFO: recovery required on readonly filesystem
[    4.286197] EXT4-fs (sdb6): write access will be enabled during recovery
[    4.509746] EXT4-fs (sdb6): recovery complete
[    4.510150] EXT4-fs (sdb6): mounted filesystem with ordered data mode. Opts: (null)
[   14.352139] Adding 3905532k swap on /dev/sdb5.  Priority:-1 extents:1 across:3905532k 
[   14.487577] udev[401]: starting version 163
[   14.598599] lp: driver loaded but no devices found
[   15.155403] parport_pc 00:0a: reported by Plug and Play ACPI
[   15.155495] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   15.332764] lp0: using parport0 (interrupt-driven).
[   15.708073] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f disabled]
[   15.708077] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   15.730233] ppdev: user-space parallel port driver
[   15.835090] saa7164 driver loaded
[   15.886761] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro
[   15.990123] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[   15.991204] saa7164 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.991960] CORE saa7164[0]: subsystem: 0070:8940, board: Hauppauge WinTV-HVR2200 [card=4,insmod option]
[   15.991968] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xfd400000
[   15.991975] saa7164 0000:02:00.0: setting latency timer to 64
[   16.047853] type=1400 audit(1295145376.546:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=560 comm="apparmor_parser"
[   16.048181] type=1400 audit(1295145376.546:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=560 comm="apparmor_parser"
[   16.048370] type=1400 audit(1295145376.546:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=560 comm="apparmor_parser"
[   16.130435] EDAC MC: Ver: 2.1.0 Dec  2 2010
[   16.190105] saa7164_downloadfirmware() no first image
[   16.190173] saa7164_downloadfirmware() Waiting for firmware upload (v4l-saa7164-1.0.3.fw)
[   16.315691] EDAC amd64_edac:  Ver: 3.3.0 Dec  2 2010
[   16.380129] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[   16.380136] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   16.380137]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   16.380139]  (Note that use of the override may cause unknown side effects.)
[   16.380180] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   16.397691] type=1400 audit(1295145376.896:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=621 comm="apparmor_parser"
[   16.618472] IR NEC protocol handler initialized
[   16.710070] Registered IR keymap rc-rc6-mce
[   16.820321] input: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0/input5
[   16.820488] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0
[   16.820561] mceusb 4-1:1.0: Registered ECS eHome Infrared Transceiver on usb4:2
[   16.820626] usbcore: registered new interface driver mceusb
[   16.825707] Linux video capture interface: v2.00
[   16.842271] IR RC5(x) protocol handler initialized
[   17.032785] IR RC6 protocol handler initialized
[   17.090724] nvidia: module license 'NVIDIA' taints kernel.
[   17.090729] Disabling lock debugging due to kernel taint
[   17.712266] IR JVC protocol handler initialized
[   17.822358] saa7130/34: v4l2 driver version 0.2.16 loaded
[   17.824011] IR Sony protocol handler initialized
[   17.852798]   alloc irq_desc for 20 on node 0
[   17.852803]   alloc kstat_irqs on node 0
[   17.852819] saa7134 0000:04:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   17.852828] saa7133[0]: found at 0000:04:06.0, rev: 209, irq: 20, latency: 32, mmio: 0xfddff000
[   17.852837] saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
[   17.853004] saa7133[0]: board init: gpio is 400000
[   17.969932] saa7164_downloadfirmware() firmware read 3978608 bytes.
[   17.969935] saa7164_downloadfirmware() firmware loaded.
[   17.969937] Firmware file header part 1:
[   17.969940]  .FirmwareSize = 0x0
[   17.969941]  .BSLSize = 0x0
[   17.969942]  .Reserved = 0x3cb57
[   17.969944]  .Version = 0x3
[   17.969946] saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608
[   17.969953] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
[   17.969955] saa7164_downloadfirmware() BSLSize = 0x0
[   17.969957] saa7164_downloadfirmware() Reserved = 0x0
[   17.969959] saa7164_downloadfirmware() Version = 0x51cc1
[   17.976029] lirc_dev: IR Remote Control driver registered, major 249 
[   18.013787] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[   18.013793] IR LIRC bridge handler initialized
[   18.406614] saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   18.406624] saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff
[   18.406633] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff
[   18.406641] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   18.406648] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
[   18.406656] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406664] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406671] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406679] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 49 f1 38 f0 73 05 29 00
[   18.406687] saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 48 89 72 07 70 73 09
[   18.406695] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
[   18.406703] saa7133[0]: i2c eeprom b0: 11 ff 79 32 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406710] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406718] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406726] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.406733] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   18.407112] tveeprom 0-0050: Hauppauge model 67559, rev B4B4, serial# 3731785
[   18.407116] tveeprom 0-0050: MAC address is 00:0d:fe:38:f1:49
[   18.407119] tveeprom 0-0050: tuner model is Philips 8275A (idx 114, type 4)
[   18.407122] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   18.407126] tveeprom 0-0050: audio processor is SAA7131 (idx 41)
[   18.407128] tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
[   18.407131] tveeprom 0-0050: has radio
[   18.407133] saa7133[0]: hauppauge eeprom: model=67559
[   18.423582] EXT4-fs (sdb7): mounted filesystem with ordered data mode. Opts: (null)
[   18.550150] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   18.640389] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[   18.676183] hda_codec: ALC889A: BIOS auto-probing.
[   18.810063] tda829x 0-004b: setting tuner address to 61
[   19.012431] tda829x 0-004b: type set to tda8290+75a
[   19.269911] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   19.269926] nvidia 0000:01:00.0: setting latency timer to 64
[   19.269931] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   19.273692] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  260.19.06  Mon Sep 13 04:29:19 PDT 2010
[   19.967500] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   20.364910] type=1400 audit(1295145380.866:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=963 comm="apparmor_parser"
[   20.365234] type=1400 audit(1295145380.866:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=963 comm="apparmor_parser"
[   20.365431] type=1400 audit(1295145380.866:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=963 comm="apparmor_parser"
[   20.412231] type=1400 audit(1295145380.916:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=967 comm="apparmor_parser"
[   20.456933] type=1400 audit(1295145380.956:10): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=968 comm="apparmor_parser"
[   20.476459] r8169 0000:03:00.0: eth0: link up
[   20.476470] r8169 0000:03:00.0: eth0: link up
[   20.491451] type=1400 audit(1295145380.996:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=969 comm="apparmor_parser"
[   21.169588] type=1400 audit(1295145381.666:12): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/mysqld" pid=1059 comm="apparmor_parser"
[   23.679761] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro,commit=0
[   23.811822] EXT4-fs (sdb7): re-mounted. Opts: commit=0
[   23.836229] EXT4-fs (sda1): re-mounted. Opts: commit=0
[   24.940125] Registered IR keymap rc-hauppauge-new
[   24.940400] input: i2c IR (HVR 1110) as /devices/virtual/rc/rc1/input6
[   24.940575] rc1: i2c IR (HVR 1110) as /devices/virtual/rc/rc1
[   24.940581] ir-kbd-i2c: i2c IR (HVR 1110) detected at i2c-0/0-0071/ir0 [saa7133[0]]
[   25.070418] saa7133[0]: registered device video0 [v4l2]
[   25.070535] saa7133[0]: registered device vbi0
[   25.070651] saa7133[0]: registered device radio0
[   25.097597] saa7134 ALSA driver for DMA sound loaded
[   25.097712] saa7133[0]/alsa: saa7133[0] at 0xfddff000 irq 20 registered as card -2
[   25.192281] dvb_init() allocating 1 frontend
[   25.390108] saa7164_downloadimage() Image downloaded, booting...
[   25.500165] saa7164_downloadimage() Image booted successfully.
[   25.500198] starting firmware download(2)
[   26.160759] DVB: registering new adapter (saa7133[0])
[   26.160768] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
[   27.560035] tda1004x: setting up plls for 48MHz sampling clock
[   27.840028] saa7164_downloadimage() Image downloaded, booting...
[   28.290019] tda1004x: found firmware revision 0 -- invalid
[   28.290023] tda1004x: trying to boot from eeprom
[   28.880023] tda1004x: found firmware revision 0 -- invalid
[   28.880027] tda1004x: waiting for firmware upload...
[   29.270020] saa7164_downloadimage() Image booted successfully.
[   29.270054] firmware download complete.
[   31.070018] eth0: no IPv6 routers present
[   39.270020] Event timed out
[   39.270080] saa7164_api_get_fw_version() error, ret = 0x32
[   39.270135] Failed to communicate with the firmware
[   49.270021] Event timed out
[   49.270081] saa7164_api_modify_gpio() error, ret = 0x32
[   59.270020] Event timed out
[   59.270079] saa7164_api_modify_gpio() error, ret = 0x32
[   59.930024] tda1004x: found firmware revision 29 -- ok
[   60.797792] saa7164_irq_dequeue() found timed out command on the bus
[   69.290022] Event timed out
[   69.290082] saa7164_api_modify_gpio() error, ret = 0x32
[   69.290547] saa7164_irq_dequeue() found timed out command on the bus
[   79.290031] Event timed out
[   79.290091] saa7164_api_modify_gpio() error, ret = 0x32
[   79.290548] saa7164_irq_dequeue() found timed out command on the bus
[   84.510025] Clocksource tsc unstable (delta = -115275693 ns)
[   89.290057] Event timed out
[   89.290129] saa7164_api_i2c_read() error, ret(1) = 0x32
[   89.290586] saa7164_irq_dequeue() found timed out command on the bus
[   99.290057] Event timed out
[   99.290129] saa7164_api_enum_subdevs() error, ret = 0x32
[   99.290199] saa7164_cmd_send() Invalid param
[   99.290266] saa7164_api_enum_subdevs() error, ret = 0x9
[   99.305969] saa7164_irq_dequeue() found timed out command on the bus
[  109.300032] Event timed out
[  109.300114] saa7164_api_i2c_read() error, ret(1) = 0x32
[  109.300187] tda10048_readreg: readreg error (ret == -5)
[  109.300478] saa7164_dvb_register() Frontend initialization failed
[  109.300549] saa7164_initdev() Failed to register dvb adapters on porta
[  109.301236] saa7164_irq_dequeue() found timed out command on the bus
[  119.300031] Event timed out
[  119.300113] saa7164_api_i2c_read() error, ret(1) = 0x32
[  119.300185] tda10048_readreg: readreg error (ret == -5)
[  119.300477] saa7164_dvb_register() Frontend initialization failed
[  119.300562] saa7164_initdev() Failed to register dvb adapters on portb
[  122.300045] tda1004x: setting up plls for 48MHz sampling clock
[  122.830047] tda1004x: found firmware revision 29 -- ok

--------------000107030801050707000805
Content-Type: text/x-log;
 name="kern.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kern.log"

Jan 16 15:36:20 mythbuntu-server kernel: imklog 4.2.0, log source = /proc/kmsg started.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Initializing cgroup subsys cpu
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Linux version 2.6.35-24-generic (buildd@yellow) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC 2010 (Ubuntu 2.6.35-24.42-generic 2.6.35.8)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] BIOS-provided physical RAM map:
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fde0000 (usable)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fde3000 - 000000007fdf0000 (ACPI data)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fdf0000 - 000000007fe00000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] NX (Execute Disable) protection: active
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] DMI 2.4 present.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] No AGP bridge found
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] last_pfn = 0x7fde0 max_arch_pfn = 0x400000000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] MTRR default type: uncachable
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] MTRR fixed ranges enabled:
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   00000-9FFFF write-back
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   A0000-BFFFF uncachable
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   C0000-C7FFF write-protect
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   C8000-FFFFF uncachable
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] MTRR variable ranges enabled:
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   0 base 0000000000 mask FF80000000 write-back
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   1 base 007FE00000 mask FFFFE00000 uncachable
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   2 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   3 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   4 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   5 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   6 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   7 disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Scanning 1 areas for low memory corruption
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] modified physical RAM map:
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 0000000000100000 - 000000007fde0000 (usable)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 000000007fde3000 - 000000007fdf0000 (ACPI data)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 000000007fdf0000 - 000000007fe00000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] initial memory mapped : 0 - 20000000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] found SMP MP-table at [ffff8800000f5820] f5820
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000007fde0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  0000000000 - 007fc00000 page 2M
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  007fc00000 - 007fde0000 page 4k
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] kernel direct mapping tables up to 7fde0000 @ 16000-1a000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] RAMDISK: 37571000 - 37ff0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: RSDP 00000000000f71a0 00014 (v00 GBT   )
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: RSDT 000000007fde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: FACP 000000007fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: DSDT 000000007fde30c0 06467 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: FACS 000000007fde0000 00040
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: SSDT 000000007fde9600 00115 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: HPET 000000007fde9740 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: MCFG 000000007fde9780 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: APIC 000000007fde9540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Scanning NUMA topology in Northbridge 24
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] No NUMA configuration found
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Faking a node at 0000000000000000-000000007fde0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Initmem setup node 0 0000000000000000-000000007fde0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   NODE_DATA [0000000001d18100 - 0000000001d1d0ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Zone PFN ranges:
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   Normal   empty
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Movable zone start PFN for each node
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] early_node_map[2] active PFN ranges
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]     0: 0x00000100 -> 0x0007fde0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] On node 0 totalpages: 523631
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA zone: 0 pages reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA zone: 3927 pages, LIFO batch:0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA32 zone: 7105 pages used for memmap
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   DMA32 zone: 512543 pages, LIFO batch:31
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] SMP: Allowing 4 CPUs, 3 hotplug CPUs
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] nr_irqs_gsi: 40
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Allocating PCI resources starting at 7fe00000 (gap: 7fe00000:60200000)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u524288
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] pcpu-alloc: s91520 r8192 d23168 u524288 alloc=1*2097152
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516470
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Policy zone: DMA32
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Checking aperture...
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] No AGP bridge found
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Node 0: aperture @ 3e0000000 size 32 MB
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Aperture beyond 4GB. Ignoring.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Subtract (48 early reservations)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #2 [0037571000 - 0037ff0000]         RAMDISK
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #3 [0001d18000 - 0001d180fe]             BRK
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #4 [00000f5830 - 0000100000]   BIOS reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #5 [00000f5820 - 00000f5830]    MP-table mpf
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #6 [000009f800 - 00000f0f00]   BIOS reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #7 [00000f1070 - 00000f5820]   BIOS reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #8 [00000f0f00 - 00000f1070]    MP-table mpc
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #12 [0001d18100 - 0001d1d100]       NODE_DATA
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #13 [0001d1d100 - 0001d1e100]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #14 [0001d17140 - 0001d172c0]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #15 [000251f000 - 0002520000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #16 [0002520000 - 0002521000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #17 [0002600000 - 0004200000]        MEMMAP 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #18 [0001d172c0 - 0001d17440]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #19 [0001d1e100 - 0001d2a100]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #20 [0001d2b000 - 0001d2c000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #21 [0001d17440 - 0001d17481]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #22 [0001d174c0 - 0001d17503]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #23 [0001d17540 - 0001d17770]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #24 [0001d17780 - 0001d177e8]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #25 [0001d17800 - 0001d17868]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #26 [0001d17880 - 0001d178e8]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #27 [0001d17900 - 0001d17968]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #28 [0001d17980 - 0001d179e8]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #29 [0001d17a00 - 0001d17a68]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #30 [0001d17a80 - 0001d17ae8]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #31 [0001d17b00 - 0001d17b68]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #32 [0001d17b80 - 0001d17be8]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #33 [0001d17c00 - 0001d17c20]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #34 [0001d17c40 - 0001d17caa]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #35 [0001d17cc0 - 0001d17d2a]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #37 [0001e80000 - 0001e9e000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #38 [0001f00000 - 0001f1e000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #39 [0001f80000 - 0001f9e000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #40 [0001d17d40 - 0001d17d48]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #41 [0001d17d80 - 0001d17d88]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #42 [0001d17dc0 - 0001d17dd0]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #43 [0001d17e00 - 0001d17e20]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #44 [0001d17e40 - 0001d17f70]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #45 [0001d17f80 - 0001d17fd0]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #46 [0001d2a100 - 0001d2a150]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000]   #47 [0001d2c000 - 0001d34000]         BOOTMEM
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Memory: 2041064k/2094976k available (5711k kernel code, 452k absent, 53460k reserved, 5379k data, 908k init)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Hierarchical RCU implementation.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] 	RCU-based detection of stalled CPUs is disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] 	Verbose stalled-CPUs detection is disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] NR_IRQS:4352 nr_irqs:712
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] spurious 8259A interrupt: IRQ7.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Console: colour VGA+ 80x25
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] console [tty0] enabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] allocated 20971520 bytes of page_cgroup
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] hpet clockevent registered
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Fast TSC calibration using PIT
Jan 16 15:36:20 mythbuntu-server kernel: [    0.000000] Detected 2104.783 MHz processor.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4209.56 BogoMIPS (lpj=21047830)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010016] pid_max: default: 32768 minimum: 301
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010045] Security Framework initialized
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010066] AppArmor: AppArmor initialized
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010068] Yama: becoming mindful.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.010375] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.012018] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.012797] Mount-cache hash table entries: 256
Jan 16 15:36:20 mythbuntu-server kernel: [    0.012983] Initializing cgroup subsys ns
Jan 16 15:36:20 mythbuntu-server kernel: [    0.012987] Initializing cgroup subsys cpuacct
Jan 16 15:36:20 mythbuntu-server kernel: [    0.012992] Initializing cgroup subsys memory
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013003] Initializing cgroup subsys devices
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013006] Initializing cgroup subsys freezer
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013009] Initializing cgroup subsys net_cls
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013042] tseg: 007fe00000
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013045] mce: CPU supports 5 MCE banks
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013057] using C1E aware idle routine
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013059] Performance Events: AMD PMU driver.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013065] ... version:                0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013067] ... bit width:              48
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013068] ... generic registers:      4
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013070] ... value mask:             0000ffffffffffff
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013072] ... max period:             00007fffffffffff
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013074] ... fixed-purpose events:   0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013076] ... event mask:             000000000000000f
Jan 16 15:36:20 mythbuntu-server kernel: [    0.013111] SMP alternatives: switching to UP code
Jan 16 15:36:20 mythbuntu-server kernel: [    0.023844] ACPI: Core revision 20100428
Jan 16 15:36:20 mythbuntu-server kernel: [    0.040026] ftrace: converting mcount calls to 0f 1f 44 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [    0.040039] ftrace: allocating 22678 entries in 89 pages
Jan 16 15:36:20 mythbuntu-server kernel: [    0.050099] Setting APIC routing to flat
Jan 16 15:36:20 mythbuntu-server kernel: [    0.050666] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 16 15:36:20 mythbuntu-server kernel: [    0.158631] CPU0: AMD Sempron(tm) Processor LE-1200 stepping 01
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] Brought up 1 CPUs
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] Total of 1 processors activated (4209.56 BogoMIPS).
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] devtmpfs: initialized
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] regulator: core version 0.5
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] Time:  2:36:00  Date: 01/16/11
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] NET: Registered protocol family 16
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] node 0 link 0: io port [b000, ffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] TOM: 0000000080000000 aka 2048M
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [a0000, bffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [80000000, fe02ffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [e0000000, efffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] bus: [00, 04] on node 0 link 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] bus: 00 index 0 [io  0x0000-0xffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] bus: 00 index 2 [mem 0x80000000-0xfcffffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] ACPI: bus type pci registered
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.160000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Jan 16 15:36:20 mythbuntu-server kernel: [    0.171594] PCI: Using configuration type 1 for base access
Jan 16 15:36:20 mythbuntu-server kernel: [    0.172811] bio: create slab <bio-0> at 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.173702] ACPI: EC: Look up EC in DSDT
Jan 16 15:36:20 mythbuntu-server kernel: [    0.185281] ACPI: Interpreter enabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.185287] ACPI: (supports S0 S3 S4 S5)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.185332] ACPI: Using IOAPIC for interrupt routing
Jan 16 15:36:20 mythbuntu-server kernel: [    0.195523] ACPI: No dock devices found.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.195527] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 16 15:36:20 mythbuntu-server kernel: [    0.195714] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196093] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196096] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196100] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196103] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196107] pci_root PNP0A03:00: host bridge window [mem 0x7ff00000-0xfebfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196136] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196209] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196212] pci 0000:00:02.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196259] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196262] pci 0000:00:04.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196313] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196316] pci 0000:00:0a.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196365] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196372] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196380] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196387] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196394] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196402] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196459] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196519] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196592] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196650] pci 0000:00:12.2: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196652] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196657] pci 0000:00:12.2: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196696] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196756] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196829] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196886] pci 0000:00:13.2: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196889] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jan 16 15:36:20 mythbuntu-server kernel: [    0.196893] pci 0000:00:13.2: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197013] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197021] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197028] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197035] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197043] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197111] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197159] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197163] pci 0000:00:14.2: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197283] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197450] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197460] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197470] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197477] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.197483] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210016] pci 0000:00:02.0: PCI bridge to [bus 01-01]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210020] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210024] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210029] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210092] pci 0000:02:00.0: reg 10: [mem 0xfd400000-0xfd7fffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210107] pci 0000:02:00.0: reg 18: [mem 0xfd000000-0xfd3fffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210164] pci 0000:02:00.0: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210166] pci 0000:02:00.0: PME# supported from D0 D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.210171] pci 0000:02:00.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230011] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230015] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230019] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230024] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230079] pci 0000:03:00.0: reg 10: [io  0xce00-0xceff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230096] pci 0000:03:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230109] pci 0000:03:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230116] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230150] pci 0000:03:00.0: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230152] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jan 16 15:36:20 mythbuntu-server kernel: [    0.230156] pci 0000:03:00.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250011] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250016] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250019] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250024] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250086] pci 0000:04:06.0: reg 10: [mem 0xfddff000-0xfddff7ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250153] pci 0000:04:06.0: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250208] pci 0000:04:0e.0: reg 10: [mem 0xfddfe000-0xfddfe7ff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250217] pci 0000:04:0e.0: reg 14: [mem 0xfddf8000-0xfddfbfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250280] pci 0000:04:0e.0: supports D1 D2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250282] pci 0000:04:0e.0: PME# supported from D0 D1 D2 D3hot
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250287] pci 0000:04:0e.0: PME# disabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250325] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250331] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250335] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250341] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250343] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250346] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250349] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250351] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250354] pci 0000:00:14.4:   bridge window [mem 0x7ff00000-0xfebfffff] (subtractive decode)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250375] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.250975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.251143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.251245] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.251365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296172] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296318] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296462] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296606] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296749] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.296893] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297037] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297181] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297232] HEST: Table is not found!
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297332] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297337] vgaarb: loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297507] SCSI subsystem initialized
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297580] libata version 3.00 loaded.
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297645] usbcore: registered new interface driver usbfs
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297658] usbcore: registered new interface driver hub
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297694] usbcore: registered new device driver usb
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297929] ACPI: WMI: Mapper loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297931] PCI: Using ACPI for IRQ routing
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297934] PCI: pci_cache_line_size set to 64 bytes
Jan 16 15:36:20 mythbuntu-server kernel: [    0.297945] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298043] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298047] reserve RAM buffer: 000000007fde0000 - 000000007fffffff 
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298158] NetLabel: Initializing
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298161] NetLabel:  domain hash size = 128
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298162] NetLabel:  protocols = UNLABELED CIPSOv4
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298178] NetLabel:  unlabeled traffic allowed by default
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298225] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.298230] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Jan 16 15:36:20 mythbuntu-server kernel: [    0.300032] Switching to clocksource hpet
Jan 16 15:36:20 mythbuntu-server kernel: [    0.314460] AppArmor: AppArmor Filesystem Enabled
Jan 16 15:36:20 mythbuntu-server kernel: [    0.314482] pnp: PnP ACPI init
Jan 16 15:36:20 mythbuntu-server kernel: [    0.314504] ACPI: bus type pnp registered
Jan 16 15:36:20 mythbuntu-server kernel: [    0.316155] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.316206] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.316217] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322097] pnp 00:0d: disabling [mem 0x000d1a00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322102] pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322108] pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322113] pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322118] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322123] pnp 00:0d: disabling [mem 0x00100000-0x7fddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322290] pnp: PnP ACPI: found 14 devices
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322292] ACPI: ACPI bus type pnp unregistered
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322309] system 00:01: [io  0x04d0-0x04d1] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322314] system 00:01: [io  0x0220-0x0225] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322319] system 00:01: [io  0x0290-0x0294] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322329] system 00:02: [io  0x4100-0x411f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322334] system 00:02: [io  0x0228-0x022f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322339] system 00:02: [io  0x0238-0x023f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322344] system 00:02: [io  0x040b] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322349] system 00:02: [io  0x04d6] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322354] system 00:02: [io  0x0c00-0x0c01] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322359] system 00:02: [io  0x0c14] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322364] system 00:02: [io  0x0c50-0x0c52] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322369] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322374] system 00:02: [io  0x0c6f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322379] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322384] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322389] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322394] system 00:02: [io  0x4000-0x40fe] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322399] system 00:02: [io  0x4210-0x4217] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322404] system 00:02: [io  0x0b00-0x0b0f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322409] system 00:02: [io  0x0b10-0x0b1f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322414] system 00:02: [io  0x0b20-0x0b3f] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322420] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322433] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322445] system 00:0d: [mem 0x7fde0000-0x7fdfffff] could not be reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322450] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322456] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322462] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.322467] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330615] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb01ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330620] pci 0000:00:02.0: PCI bridge to [bus 01-01]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330624] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330628] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330631] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330636] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330639] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330643] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330646] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330652] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330656] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330658] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330662] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330666] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330671] pci 0000:00:14.4: PCI bridge to [bus 04-04]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330675] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330681] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330686] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330703]   alloc irq_desc for 18 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330706]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330720] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330725] pci 0000:00:02.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330733]   alloc irq_desc for 16 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330736]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330746] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330750] pci 0000:00:04.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330758] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330761] pci 0000:00:0a.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330770] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330773] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330775] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330778] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330780] pci_bus 0000:00: resource 8 [mem 0x7ff00000-0xfebfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330783] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330786] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330788] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330791] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330793] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfd7fffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330796] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330799] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330801] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330804] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330807] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330809] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfddfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330811] pci_bus 0000:04: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330814] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330816] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330819] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330821] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330824] pci_bus 0000:04: resource 8 [mem 0x7ff00000-0xfebfffff]
Jan 16 15:36:20 mythbuntu-server kernel: [    0.330882] NET: Registered protocol family 2
Jan 16 15:36:20 mythbuntu-server kernel: [    0.331171] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.332227] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.335327] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.335999] TCP: Hash tables configured (established 262144 bind 65536)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.336002] TCP reno registered
Jan 16 15:36:20 mythbuntu-server kernel: [    0.336018] UDP hash table entries: 1024 (order: 3, 32768 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.336051] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    0.336279] NET: Registered protocol family 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.360021] pci 0000:00:12.1: OHCI: BIOS handoff failed (BIOS bug?) 00000184
Jan 16 15:36:20 mythbuntu-server kernel: [    1.450065] pci 0000:01:00.0: Boot video device
Jan 16 15:36:20 mythbuntu-server kernel: [    1.450086] PCI: CLS 4 bytes, default 64
Jan 16 15:36:20 mythbuntu-server kernel: [    1.450339] Trying to unpack rootfs image as initramfs...
Jan 16 15:36:20 mythbuntu-server kernel: [    1.510603] Scanning for low memory corruption every 60 seconds
Jan 16 15:36:20 mythbuntu-server kernel: [    1.510823] audit: initializing netlink socket (disabled)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.510840] type=2000 audit(1295145361.510:1): initialized
Jan 16 15:36:20 mythbuntu-server kernel: [    1.540235] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jan 16 15:36:20 mythbuntu-server kernel: [    1.544354] VFS: Disk quotas dquot_6.5.2
Jan 16 15:36:20 mythbuntu-server kernel: [    1.544490] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.546061] fuse init (API version 7.14)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.546299] msgmni has been set to 3986
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560418] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560423] io scheduler noop registered
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560425] io scheduler deadline registered
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560533] io scheduler cfq registered (default)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560863] pcieport 0000:00:02.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560891]   alloc irq_desc for 40 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560893]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.560904] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561060] pcieport 0000:00:04.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561084]   alloc irq_desc for 41 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561086]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561092] pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561218] pcieport 0000:00:0a.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561242]   alloc irq_desc for 42 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561244]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561249] pcieport 0000:00:0a.0: irq 42 for MSI/MSI-X
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561396] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561456] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561842] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561851] ACPI: Power Button [PWRB]
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561960] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.561967] ACPI: Power Button [PWRF]
Jan 16 15:36:20 mythbuntu-server kernel: [    1.562889] ACPI: acpi_idle registered with cpuidle
Jan 16 15:36:20 mythbuntu-server kernel: [    1.581287] ERST: Table is not found!
Jan 16 15:36:20 mythbuntu-server kernel: [    1.581724] Linux agpgart interface v0.103
Jan 16 15:36:20 mythbuntu-server kernel: [    1.581729] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jan 16 15:36:20 mythbuntu-server kernel: [    1.581890] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jan 16 15:36:20 mythbuntu-server kernel: [    1.582479] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jan 16 15:36:20 mythbuntu-server kernel: [    1.585267] brd: module loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    1.586377] loop: module loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    1.590094] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601039] Fixed MDIO Bus: probed
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601143] PPP generic driver version 2.4.2
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601266] tun: Universal TUN/TAP device driver, 1.6
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601269] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601540] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601650]   alloc irq_desc for 17 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601654]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601670] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601704] ehci_hcd 0000:00:12.2: EHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601819] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601871] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601888] ehci_hcd 0000:00:12.2: debug port 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.601941] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.620050] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Jan 16 15:36:20 mythbuntu-server kernel: [    1.620471] hub 1-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.620484] hub 1-0:1.0: 6 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630298]   alloc irq_desc for 19 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630302]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630318] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630354] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630505] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630551] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630568] ehci_hcd 0000:00:13.2: debug port 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.630618] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.650188] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jan 16 15:36:20 mythbuntu-server kernel: [    1.650564] hub 2-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.650572] hub 2-0:1.0: 6 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.650802] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jan 16 15:36:20 mythbuntu-server kernel: [    1.660172] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [    1.660213] ohci_hcd 0000:00:12.0: OHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.660390] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Jan 16 15:36:20 mythbuntu-server kernel: [    1.660476] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.724601] hub 3-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.724619] hub 3-0:1.0: 3 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.730342] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [    1.730388] ohci_hcd 0000:00:12.1: OHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.730536] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Jan 16 15:36:20 mythbuntu-server kernel: [    1.730572] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.794757] hub 4-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.794771] hub 4-0:1.0: 3 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.800257] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    1.800299] ohci_hcd 0000:00:13.0: OHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.800459] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Jan 16 15:36:20 mythbuntu-server kernel: [    1.800527] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.855951] Freeing initrd memory: 10748k freed
Jan 16 15:36:20 mythbuntu-server kernel: [    1.866561] hub 5-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.866574] hub 5-0:1.0: 3 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.866831] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    1.866867] ohci_hcd 0000:00:13.1: OHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.867015] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Jan 16 15:36:20 mythbuntu-server kernel: [    1.867053] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924348] hub 6-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924358] hub 6-0:1.0: 3 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924539] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924559] ohci_hcd 0000:00:14.5: OHCI Host Controller
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924664] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Jan 16 15:36:20 mythbuntu-server kernel: [    1.924692] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984341] hub 7-0:1.0: USB hub found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984351] hub 7-0:1.0: 2 ports detected
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984511] uhci_hcd: USB Universal Host Controller Interface driver
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984773] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984775] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Jan 16 15:36:20 mythbuntu-server kernel: [    1.984980] serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.985186] mice: PS/2 mouse device common for all mice
Jan 16 15:36:20 mythbuntu-server kernel: [    1.985485] rtc_cmos 00:05: RTC can wake from S4
Jan 16 15:36:20 mythbuntu-server kernel: [    1.985592] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Jan 16 15:36:20 mythbuntu-server kernel: [    1.985639] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
Jan 16 15:36:20 mythbuntu-server kernel: [    1.985878] device-mapper: uevent: version 1.0.3
Jan 16 15:36:20 mythbuntu-server kernel: [    1.986128] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
Jan 16 15:36:20 mythbuntu-server kernel: [    1.986217] device-mapper: multipath: version 1.1.1 loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    1.986220] device-mapper: multipath round-robin: version 1.0.0 loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    1.986470] cpuidle: using governor ladder
Jan 16 15:36:20 mythbuntu-server kernel: [    1.986472] cpuidle: using governor menu
Jan 16 15:36:20 mythbuntu-server kernel: [    1.987055] TCP cubic registered
Jan 16 15:36:20 mythbuntu-server kernel: [    1.987404] NET: Registered protocol family 10
Jan 16 15:36:20 mythbuntu-server kernel: [    1.989355] lo: Disabled Privacy Extensions
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990282] NET: Registered protocol family 17
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990365] powernow-k8: Found 1 AMD Sempron(tm) Processor LE-1200 (1 cpu cores) (version 2.20.00)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990478] powernow-k8:    0 : fid 0xd (2100 MHz), vid 0xa
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990482] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xb
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990485] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xd
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990489] powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990860] PM: Resume from disk failed.
Jan 16 15:36:20 mythbuntu-server kernel: [    1.990886] registered taskstats version 1
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991386]   Magic number: 11:958:611
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991437] pci 0000:04:0e.0: hash matches
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991490] rtc_cmos 00:05: setting system clock to 2011-01-16 02:36:02 UTC (1295145362)
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991493] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991494] EDD information not available.
Jan 16 15:36:20 mythbuntu-server kernel: [    1.991649] Freeing unused kernel memory: 908k freed
Jan 16 15:36:20 mythbuntu-server kernel: [    1.992089] Write protecting the kernel read-only data: 10240k
Jan 16 15:36:20 mythbuntu-server kernel: [    1.992269] Freeing unused kernel memory: 412k freed
Jan 16 15:36:20 mythbuntu-server kernel: [    1.992657] Freeing unused kernel memory: 1644k freed
Jan 16 15:36:20 mythbuntu-server kernel: [    2.003110] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Jan 16 15:36:20 mythbuntu-server kernel: [    2.035578] udev[100]: starting version 163
Jan 16 15:36:20 mythbuntu-server kernel: [    2.285599] Floppy drive(s): fd0 is 1.44M
Jan 16 15:36:20 mythbuntu-server kernel: [    2.534032] FDC 0 is a post-1991 82077
Jan 16 15:36:20 mythbuntu-server kernel: [    2.609536] scsi0 : pata_atiixp
Jan 16 15:36:20 mythbuntu-server kernel: [    2.650110] usb 3-2: new low speed USB device using ohci_hcd and address 2
Jan 16 15:36:20 mythbuntu-server kernel: [    2.690954] scsi1 : pata_atiixp
Jan 16 15:36:20 mythbuntu-server kernel: [    2.694092] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
Jan 16 15:36:20 mythbuntu-server kernel: [    2.694097] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718179] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718205] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718260] r8169 0000:03:00.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718300]   alloc irq_desc for 43 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718302]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.718319] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
Jan 16 15:36:20 mythbuntu-server kernel: [    2.720176] r8169 0000:03:00.0: eth0: RTL8168c/8111c at 0xffffc9000034c000, 00:1f:d0:9f:ee:1a, XID 1c4000c0 IRQ 43
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723550] ahci 0000:00:11.0: version 3.0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723566]   alloc irq_desc for 22 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723568]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723580] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723723] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jan 16 15:36:20 mythbuntu-server kernel: [    2.723727] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Jan 16 15:36:20 mythbuntu-server kernel: [    2.745142] scsi2 : ahci
Jan 16 15:36:20 mythbuntu-server kernel: [    2.757901] scsi3 : ahci
Jan 16 15:36:20 mythbuntu-server kernel: [    2.764729] scsi4 : ahci
Jan 16 15:36:20 mythbuntu-server kernel: [    2.772714] scsi5 : ahci
Jan 16 15:36:20 mythbuntu-server kernel: [    2.773346] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
Jan 16 15:36:20 mythbuntu-server kernel: [    2.773351] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
Jan 16 15:36:20 mythbuntu-server kernel: [    2.773355] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
Jan 16 15:36:20 mythbuntu-server kernel: [    2.773359] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
Jan 16 15:36:20 mythbuntu-server kernel: [    2.910376] ata2.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
Jan 16 15:36:20 mythbuntu-server kernel: [    2.910382] ata2.00: ATA-8: WDC WD10EARS-00Z5B1, 80.00A80, max UDMA/133
Jan 16 15:36:20 mythbuntu-server kernel: [    2.910386] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jan 16 15:36:20 mythbuntu-server kernel: [    2.930606] ata2.00: configured for UDMA/100
Jan 16 15:36:20 mythbuntu-server kernel: [    2.930797] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Z 80.0 PQ: 0 ANSI: 5
Jan 16 15:36:20 mythbuntu-server kernel: [    2.931267] sd 1:0:0:0: Attached scsi generic sg0 type 0
Jan 16 15:36:20 mythbuntu-server kernel: [    2.931784] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 16 15:36:20 mythbuntu-server kernel: [    2.931977] sd 1:0:0:0: [sda] Write Protect is off
Jan 16 15:36:20 mythbuntu-server kernel: [    2.931981] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [    2.932063] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 16 15:36:20 mythbuntu-server kernel: [    2.932562]  sda: sda1
Jan 16 15:36:20 mythbuntu-server kernel: [    2.939142] sd 1:0:0:0: [sda] Attached SCSI disk
Jan 16 15:36:20 mythbuntu-server kernel: [    3.120044] ata5: SATA link down (SStatus 0 SControl 300)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.120078] ata4: SATA link down (SStatus 0 SControl 300)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.220025] usb 3-3: new low speed USB device using ohci_hcd and address 3
Jan 16 15:36:20 mythbuntu-server kernel: [    3.320021] ata3: softreset failed (device not ready)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.320024] ata3: applying SB600 PMP SRST workaround and retrying
Jan 16 15:36:20 mythbuntu-server kernel: [    3.320045] ata6: softreset failed (device not ready)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.320048] ata6: applying SB600 PMP SRST workaround and retrying
Jan 16 15:36:20 mythbuntu-server kernel: [    3.480246] usbcore: registered new interface driver hiddev
Jan 16 15:36:20 mythbuntu-server kernel: [    3.481074] usbcore: registered new interface driver usbhid
Jan 16 15:36:20 mythbuntu-server kernel: [    3.481077] usbhid: USB HID core driver
Jan 16 15:36:20 mythbuntu-server kernel: [    3.520036] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.520068] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.520289] ata6.00: ATAPI: ATAPI   iHAS120   6, 7L0F, max UDMA/100
Jan 16 15:36:20 mythbuntu-server kernel: [    3.520991] ata6.00: configured for UDMA/100
Jan 16 15:36:20 mythbuntu-server kernel: [    3.536173] ata3.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
Jan 16 15:36:20 mythbuntu-server kernel: [    3.536285] ata3.00: ATA-8: WDC WD10EURS-630AB1, 80.00A80, max UDMA/133
Jan 16 15:36:20 mythbuntu-server kernel: [    3.536288] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Jan 16 15:36:20 mythbuntu-server kernel: [    3.539356] ata3.00: configured for UDMA/133
Jan 16 15:36:20 mythbuntu-server kernel: [    3.550183] scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EURS-630 80.0 PQ: 0 ANSI: 5
Jan 16 15:36:20 mythbuntu-server kernel: [    3.550631] sd 2:0:0:0: Attached scsi generic sg1 type 0
Jan 16 15:36:20 mythbuntu-server kernel: [    3.551257] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 16 15:36:20 mythbuntu-server kernel: [    3.551261] sd 2:0:0:0: [sdb] 4096-byte physical blocks
Jan 16 15:36:20 mythbuntu-server kernel: [    3.551483] sd 2:0:0:0: [sdb] Write Protect is off
Jan 16 15:36:20 mythbuntu-server kernel: [    3.551488] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [    3.551564] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 16 15:36:20 mythbuntu-server kernel: [    3.552008] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS120   6      7L0F PQ: 0 ANSI: 5
Jan 16 15:36:20 mythbuntu-server kernel: [    3.552850]  sdb:sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 16 15:36:20 mythbuntu-server kernel: [    3.557947] Uniform CD-ROM driver Revision: 3.20
Jan 16 15:36:20 mythbuntu-server kernel: [    3.558227] sr 5:0:0:0: Attached scsi CD-ROM sr0
Jan 16 15:36:20 mythbuntu-server kernel: [    3.558387] sr 5:0:0:0: Attached scsi generic sg2 type 5
Jan 16 15:36:20 mythbuntu-server kernel: [    3.561987]  sdb1 < sdb5 sdb6 sdb7 >
Jan 16 15:36:20 mythbuntu-server kernel: [    3.594252] sd 2:0:0:0: [sdb] Attached SCSI disk
Jan 16 15:36:20 mythbuntu-server kernel: [    3.632400] firewire_ohci 0000:04:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jan 16 15:36:20 mythbuntu-server kernel: [    3.661647] input: A4Tech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input3
Jan 16 15:36:20 mythbuntu-server kernel: [    3.662236] a4tech 0003:09DA:0006.0001: input,hidraw0: USB HID v1.10 Mouse [A4Tech USB Optical Mouse] on usb-0000:00:12.0-2/input0
Jan 16 15:36:20 mythbuntu-server kernel: [    3.690091] firewire_ohci: Added fw-ohci device 0000:04:0e.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
Jan 16 15:36:20 mythbuntu-server kernel: [    3.719374] input: Logitech Logitech Cordless RumblePad 2 as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input4
Jan 16 15:36:20 mythbuntu-server kernel: [    3.719786] logitech 0003:046D:C219.0002: input,hidraw1: USB HID v1.10 Gamepad [Logitech Logitech Cordless RumblePad 2] on usb-0000:00:12.0-3/input0
Jan 16 15:36:20 mythbuntu-server kernel: [    3.719792] Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>
Jan 16 15:36:20 mythbuntu-server kernel: [    3.800032] usb 4-1: new full speed USB device using ohci_hcd and address 2
Jan 16 15:36:20 mythbuntu-server kernel: [    4.190176] firewire_core: created device fw0: GUID 007d8c7800001fd0, S400
Jan 16 15:36:20 mythbuntu-server kernel: [    4.286192] EXT4-fs (sdb6): INFO: recovery required on readonly filesystem
Jan 16 15:36:20 mythbuntu-server kernel: [    4.286197] EXT4-fs (sdb6): write access will be enabled during recovery
Jan 16 15:36:20 mythbuntu-server kernel: [    4.509746] EXT4-fs (sdb6): recovery complete
Jan 16 15:36:20 mythbuntu-server kernel: [    4.510150] EXT4-fs (sdb6): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 15:36:20 mythbuntu-server kernel: [   14.352139] Adding 3905532k swap on /dev/sdb5.  Priority:-1 extents:1 across:3905532k 
Jan 16 15:36:20 mythbuntu-server kernel: [   14.487577] udev[401]: starting version 163
Jan 16 15:36:20 mythbuntu-server kernel: [   14.598599] lp: driver loaded but no devices found
Jan 16 15:36:20 mythbuntu-server kernel: [   15.155403] parport_pc 00:0a: reported by Plug and Play ACPI
Jan 16 15:36:20 mythbuntu-server kernel: [   15.155495] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Jan 16 15:36:20 mythbuntu-server kernel: [   15.332764] lp0: using parport0 (interrupt-driven).
Jan 16 15:36:20 mythbuntu-server kernel: [   15.708073] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f disabled]
Jan 16 15:36:20 mythbuntu-server kernel: [   15.708077] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jan 16 15:36:20 mythbuntu-server kernel: [   15.730233] ppdev: user-space parallel port driver
Jan 16 15:36:20 mythbuntu-server kernel: [   15.835090] saa7164 driver loaded
Jan 16 15:36:20 mythbuntu-server kernel: [   15.886761] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro
Jan 16 15:36:20 mythbuntu-server kernel: [   15.990123] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Jan 16 15:36:20 mythbuntu-server kernel: [   15.991204] saa7164 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [   15.991960] CORE saa7164[0]: subsystem: 0070:8940, board: Hauppauge WinTV-HVR2200 [card=4,insmod option]
Jan 16 15:36:20 mythbuntu-server kernel: [   15.991968] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xfd400000
Jan 16 15:36:20 mythbuntu-server kernel: [   15.991975] saa7164 0000:02:00.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [   16.047853] type=1400 audit(1295145376.546:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=560 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   16.048181] type=1400 audit(1295145376.546:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=560 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   16.048370] type=1400 audit(1295145376.546:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=560 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   16.130435] EDAC MC: Ver: 2.1.0 Dec  2 2010
Jan 16 15:36:20 mythbuntu-server kernel: [   16.190105] saa7164_downloadfirmware() no first image
Jan 16 15:36:20 mythbuntu-server kernel: [   16.190173] saa7164_downloadfirmware() Waiting for firmware upload (v4l-saa7164-1.0.3.fw)
Jan 16 15:36:20 mythbuntu-server kernel: [   16.315691] EDAC amd64_edac:  Ver: 3.3.0 Dec  2 2010
Jan 16 15:36:20 mythbuntu-server kernel: [   16.380129] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
Jan 16 15:36:20 mythbuntu-server kernel: [   16.380136] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
Jan 16 15:36:20 mythbuntu-server kernel: [   16.380137]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
Jan 16 15:36:20 mythbuntu-server kernel: [   16.380139]  (Note that use of the override may cause unknown side effects.)
Jan 16 15:36:20 mythbuntu-server kernel: [   16.380180] amd64_edac: probe of 0000:00:18.2 failed with error -22
Jan 16 15:36:20 mythbuntu-server kernel: [   16.397691] type=1400 audit(1295145376.896:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=621 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   16.618472] IR NEC protocol handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   16.710070] Registered IR keymap rc-rc6-mce
Jan 16 15:36:20 mythbuntu-server kernel: [   16.820321] input: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0/input5
Jan 16 15:36:20 mythbuntu-server kernel: [   16.820488] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0
Jan 16 15:36:20 mythbuntu-server kernel: [   16.820561] mceusb 4-1:1.0: Registered ECS eHome Infrared Transceiver on usb4:2
Jan 16 15:36:20 mythbuntu-server kernel: [   16.820626] usbcore: registered new interface driver mceusb
Jan 16 15:36:20 mythbuntu-server kernel: [   16.825707] Linux video capture interface: v2.00
Jan 16 15:36:20 mythbuntu-server kernel: [   16.842271] IR RC5(x) protocol handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   17.032785] IR RC6 protocol handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   17.090724] nvidia: module license 'NVIDIA' taints kernel.
Jan 16 15:36:20 mythbuntu-server kernel: [   17.090729] Disabling lock debugging due to kernel taint
Jan 16 15:36:20 mythbuntu-server kernel: [   17.712266] IR JVC protocol handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   17.822358] saa7130/34: v4l2 driver version 0.2.16 loaded
Jan 16 15:36:20 mythbuntu-server kernel: [   17.824011] IR Sony protocol handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   17.852798]   alloc irq_desc for 20 on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.852803]   alloc kstat_irqs on node 0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.852819] saa7134 0000:04:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Jan 16 15:36:20 mythbuntu-server kernel: [   17.852828] saa7133[0]: found at 0000:04:06.0, rev: 209, irq: 20, latency: 32, mmio: 0xfddff000
Jan 16 15:36:20 mythbuntu-server kernel: [   17.852837] saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
Jan 16 15:36:20 mythbuntu-server kernel: [   17.853004] saa7133[0]: board init: gpio is 400000
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969932] saa7164_downloadfirmware() firmware read 3978608 bytes.
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969935] saa7164_downloadfirmware() firmware loaded.
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969937] Firmware file header part 1:
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969940]  .FirmwareSize = 0x0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969941]  .BSLSize = 0x0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969942]  .Reserved = 0x3cb57
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969944]  .Version = 0x3
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969946] saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969953] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969955] saa7164_downloadfirmware() BSLSize = 0x0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969957] saa7164_downloadfirmware() Reserved = 0x0
Jan 16 15:36:20 mythbuntu-server kernel: [   17.969959] saa7164_downloadfirmware() Version = 0x51cc1
Jan 16 15:36:20 mythbuntu-server kernel: [   17.976029] lirc_dev: IR Remote Control driver registered, major 249 
Jan 16 15:36:20 mythbuntu-server kernel: [   18.013787] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
Jan 16 15:36:20 mythbuntu-server kernel: [   18.013793] IR LIRC bridge handler initialized
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406614] saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406624] saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406633] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406641] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406648] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406656] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406664] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406671] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406679] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 49 f1 38 f0 73 05 29 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406687] saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 48 89 72 07 70 73 09
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406695] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406703] saa7133[0]: i2c eeprom b0: 11 ff 79 32 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406710] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406718] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406726] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.406733] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407112] tveeprom 0-0050: Hauppauge model 67559, rev B4B4, serial# 3731785
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407116] tveeprom 0-0050: MAC address is 00:0d:fe:38:f1:49
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407119] tveeprom 0-0050: tuner model is Philips 8275A (idx 114, type 4)
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407122] tveeprom 0-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407126] tveeprom 0-0050: audio processor is SAA7131 (idx 41)
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407128] tveeprom 0-0050: decoder processor is SAA7131 (idx 35)
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407131] tveeprom 0-0050: has radio
Jan 16 15:36:20 mythbuntu-server kernel: [   18.407133] saa7133[0]: hauppauge eeprom: model=67559
Jan 16 15:36:20 mythbuntu-server kernel: [   18.423582] EXT4-fs (sdb7): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 15:36:20 mythbuntu-server kernel: [   18.550150] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 15:36:20 mythbuntu-server kernel: [   18.640389] tuner 0-004b: chip found @ 0x96 (saa7133[0])
Jan 16 15:36:20 mythbuntu-server kernel: [   18.676183] hda_codec: ALC889A: BIOS auto-probing.
Jan 16 15:36:20 mythbuntu-server kernel: [   18.810063] tda829x 0-004b: setting tuner address to 61
Jan 16 15:36:20 mythbuntu-server kernel: [   19.012431] tda829x 0-004b: type set to tda8290+75a
Jan 16 15:36:20 mythbuntu-server kernel: [   19.269911] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 15:36:20 mythbuntu-server kernel: [   19.269926] nvidia 0000:01:00.0: setting latency timer to 64
Jan 16 15:36:20 mythbuntu-server kernel: [   19.269931] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
Jan 16 15:36:20 mythbuntu-server kernel: [   19.273692] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  260.19.06  Mon Sep 13 04:29:19 PDT 2010
Jan 16 15:36:20 mythbuntu-server kernel: [   19.967500] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 15:36:20 mythbuntu-server kernel: [   20.364910] type=1400 audit(1295145380.866:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=963 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   20.365234] type=1400 audit(1295145380.866:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=963 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   20.365431] type=1400 audit(1295145380.866:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=963 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   20.412231] type=1400 audit(1295145380.916:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=967 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   20.456933] type=1400 audit(1295145380.956:10): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=968 comm="apparmor_parser"
Jan 16 15:36:20 mythbuntu-server kernel: [   20.476459] r8169 0000:03:00.0: eth0: link up
Jan 16 15:36:20 mythbuntu-server kernel: [   20.476470] r8169 0000:03:00.0: eth0: link up
Jan 16 15:36:21 mythbuntu-server kernel: [   20.491451] type=1400 audit(1295145380.996:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=969 comm="apparmor_parser"
Jan 16 15:36:21 mythbuntu-server kernel: [   21.169588] type=1400 audit(1295145381.666:12): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/mysqld" pid=1059 comm="apparmor_parser"
Jan 16 15:36:23 mythbuntu-server kernel: [   23.679761] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro,commit=0
Jan 16 15:36:23 mythbuntu-server kernel: [   23.811822] EXT4-fs (sdb7): re-mounted. Opts: commit=0
Jan 16 15:36:23 mythbuntu-server kernel: [   23.836229] EXT4-fs (sda1): re-mounted. Opts: commit=0
Jan 16 15:36:24 mythbuntu-server kernel: [   24.940125] Registered IR keymap rc-hauppauge-new
Jan 16 15:36:24 mythbuntu-server kernel: [   24.940400] input: i2c IR (HVR 1110) as /devices/virtual/rc/rc1/input6
Jan 16 15:36:24 mythbuntu-server kernel: [   24.940575] rc1: i2c IR (HVR 1110) as /devices/virtual/rc/rc1
Jan 16 15:36:24 mythbuntu-server kernel: [   24.940581] ir-kbd-i2c: i2c IR (HVR 1110) detected at i2c-0/0-0071/ir0 [saa7133[0]]
Jan 16 15:36:25 mythbuntu-server kernel: [   25.070418] saa7133[0]: registered device video0 [v4l2]
Jan 16 15:36:25 mythbuntu-server kernel: [   25.070535] saa7133[0]: registered device vbi0
Jan 16 15:36:25 mythbuntu-server kernel: [   25.070651] saa7133[0]: registered device radio0
Jan 16 15:36:25 mythbuntu-server kernel: [   25.097597] saa7134 ALSA driver for DMA sound loaded
Jan 16 15:36:25 mythbuntu-server kernel: [   25.097712] saa7133[0]/alsa: saa7133[0] at 0xfddff000 irq 20 registered as card -2
Jan 16 15:36:25 mythbuntu-server kernel: [   25.192281] dvb_init() allocating 1 frontend
Jan 16 15:36:25 mythbuntu-server kernel: [   25.390108] saa7164_downloadimage() Image downloaded, booting...
Jan 16 15:36:25 mythbuntu-server kernel: [   25.500165] saa7164_downloadimage() Image booted successfully.
Jan 16 15:36:25 mythbuntu-server kernel: [   25.500198] starting firmware download(2)
Jan 16 15:36:26 mythbuntu-server kernel: [   26.160759] DVB: registering new adapter (saa7133[0])
Jan 16 15:36:26 mythbuntu-server kernel: [   26.160768] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
Jan 16 15:36:27 mythbuntu-server kernel: [   27.560035] tda1004x: setting up plls for 48MHz sampling clock
Jan 16 15:36:27 mythbuntu-server kernel: [   27.840028] saa7164_downloadimage() Image downloaded, booting...
Jan 16 15:36:28 mythbuntu-server kernel: [   28.290019] tda1004x: found firmware revision 0 -- invalid
Jan 16 15:36:28 mythbuntu-server kernel: [   28.290023] tda1004x: trying to boot from eeprom
Jan 16 15:36:28 mythbuntu-server kernel: [   28.880023] tda1004x: found firmware revision 0 -- invalid
Jan 16 15:36:28 mythbuntu-server kernel: [   28.880027] tda1004x: waiting for firmware upload...
Jan 16 15:36:29 mythbuntu-server kernel: [   29.270020] saa7164_downloadimage() Image booted successfully.
Jan 16 15:36:29 mythbuntu-server kernel: [   29.270054] firmware download complete.
Jan 16 15:36:31 mythbuntu-server kernel: [   31.070018] eth0: no IPv6 routers present
Jan 16 15:36:39 mythbuntu-server kernel: [   39.270020] Event timed out
Jan 16 15:36:39 mythbuntu-server kernel: [   39.270080] saa7164_api_get_fw_version() error, ret = 0x32
Jan 16 15:36:39 mythbuntu-server kernel: [   39.270135] Failed to communicate with the firmware
Jan 16 15:36:49 mythbuntu-server kernel: [   49.270021] Event timed out
Jan 16 15:36:49 mythbuntu-server kernel: [   49.270081] saa7164_api_modify_gpio() error, ret = 0x32
Jan 16 15:36:59 mythbuntu-server kernel: [   59.270020] Event timed out
Jan 16 15:36:59 mythbuntu-server kernel: [   59.270079] saa7164_api_modify_gpio() error, ret = 0x32
Jan 16 15:36:59 mythbuntu-server kernel: [   59.930024] tda1004x: found firmware revision 29 -- ok
Jan 16 15:37:00 mythbuntu-server kernel: [   60.797792] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:09 mythbuntu-server kernel: [   69.290022] Event timed out
Jan 16 15:37:09 mythbuntu-server kernel: [   69.290082] saa7164_api_modify_gpio() error, ret = 0x32
Jan 16 15:37:09 mythbuntu-server kernel: [   69.290547] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:19 mythbuntu-server kernel: [   79.290031] Event timed out
Jan 16 15:37:19 mythbuntu-server kernel: [   79.290091] saa7164_api_modify_gpio() error, ret = 0x32
Jan 16 15:37:19 mythbuntu-server kernel: [   79.290548] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:24 mythbuntu-server kernel: [   84.510025] Clocksource tsc unstable (delta = -115275693 ns)
Jan 16 15:37:29 mythbuntu-server kernel: [   89.290057] Event timed out
Jan 16 15:37:29 mythbuntu-server kernel: [   89.290129] saa7164_api_i2c_read() error, ret(1) = 0x32
Jan 16 15:37:29 mythbuntu-server kernel: [   89.290586] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:39 mythbuntu-server kernel: [   99.290057] Event timed out
Jan 16 15:37:39 mythbuntu-server kernel: [   99.290129] saa7164_api_enum_subdevs() error, ret = 0x32
Jan 16 15:37:39 mythbuntu-server kernel: [   99.290199] saa7164_cmd_send() Invalid param
Jan 16 15:37:39 mythbuntu-server kernel: [   99.290266] saa7164_api_enum_subdevs() error, ret = 0x9
Jan 16 15:37:39 mythbuntu-server kernel: [   99.305969] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:49 mythbuntu-server kernel: [  109.300032] Event timed out
Jan 16 15:37:49 mythbuntu-server kernel: [  109.300114] saa7164_api_i2c_read() error, ret(1) = 0x32
Jan 16 15:37:49 mythbuntu-server kernel: [  109.300187] tda10048_readreg: readreg error (ret == -5)
Jan 16 15:37:49 mythbuntu-server kernel: [  109.300478] saa7164_dvb_register() Frontend initialization failed
Jan 16 15:37:49 mythbuntu-server kernel: [  109.300549] saa7164_initdev() Failed to register dvb adapters on porta
Jan 16 15:37:49 mythbuntu-server kernel: [  109.301236] saa7164_irq_dequeue() found timed out command on the bus
Jan 16 15:37:59 mythbuntu-server kernel: [  119.300031] Event timed out
Jan 16 15:37:59 mythbuntu-server kernel: [  119.300113] saa7164_api_i2c_read() error, ret(1) = 0x32
Jan 16 15:37:59 mythbuntu-server kernel: [  119.300185] tda10048_readreg: readreg error (ret == -5)
Jan 16 15:37:59 mythbuntu-server kernel: [  119.300477] saa7164_dvb_register() Frontend initialization failed
Jan 16 15:37:59 mythbuntu-server kernel: [  119.300562] saa7164_initdev() Failed to register dvb adapters on portb
Jan 16 15:38:02 mythbuntu-server kernel: [  122.300045] tda1004x: setting up plls for 48MHz sampling clock
Jan 16 15:38:02 mythbuntu-server kernel: [  122.830047] tda1004x: found firmware revision 29 -- ok

--------------000107030801050707000805
Content-Type: text/x-log;
 name="kern_no_1110.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kern_no_1110.log"

Jan 16 16:00:05 mythbuntu-server kernel: imklog 4.2.0, log source = /proc/kmsg started.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Initializing cgroup subsys cpuset
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Initializing cgroup subsys cpu
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Linux version 2.6.35-24-generic (buildd@yellow) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC 2010 (Ubuntu 2.6.35-24.42-generic 2.6.35.8)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] BIOS-provided physical RAM map:
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fde0000 (usable)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fde3000 - 000000007fdf0000 (ACPI data)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 000000007fdf0000 - 000000007fe00000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] NX (Execute Disable) protection: active
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] DMI 2.4 present.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] No AGP bridge found
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] last_pfn = 0x7fde0 max_arch_pfn = 0x400000000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] MTRR default type: uncachable
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] MTRR fixed ranges enabled:
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   00000-9FFFF write-back
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   A0000-BFFFF uncachable
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   C0000-C7FFF write-protect
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   C8000-FFFFF uncachable
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] MTRR variable ranges enabled:
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   0 base 0000000000 mask FF80000000 write-back
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   1 base 007FE00000 mask FFFFE00000 uncachable
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   2 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   3 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   4 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   5 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   6 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   7 disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Scanning 1 areas for low memory corruption
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] modified physical RAM map:
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 0000000000100000 - 000000007fde0000 (usable)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 000000007fde0000 - 000000007fde3000 (ACPI NVS)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 000000007fde3000 - 000000007fdf0000 (ACPI data)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 000000007fdf0000 - 000000007fe00000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] initial memory mapped : 0 - 20000000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] found SMP MP-table at [ffff8800000f5820] f5820
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000007fde0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  0000000000 - 007fc00000 page 2M
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  007fc00000 - 007fde0000 page 4k
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] kernel direct mapping tables up to 7fde0000 @ 16000-1a000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] RAMDISK: 37571000 - 37ff0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: RSDP 00000000000f71a0 00014 (v00 GBT   )
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: RSDT 000000007fde3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: FACP 000000007fde3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: DSDT 000000007fde30c0 06467 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: FACS 000000007fde0000 00040
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: SSDT 000000007fde9600 00115 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: HPET 000000007fde9740 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: MCFG 000000007fde9780 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: APIC 000000007fde9540 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Scanning NUMA topology in Northbridge 24
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] No NUMA configuration found
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Faking a node at 0000000000000000-000000007fde0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Initmem setup node 0 0000000000000000-000000007fde0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   NODE_DATA [0000000001d18100 - 0000000001d1d0ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Zone PFN ranges:
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA      0x00000010 -> 0x00001000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   Normal   empty
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Movable zone start PFN for each node
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] early_node_map[2] active PFN ranges
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]     0: 0x00000010 -> 0x0000009f
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]     0: 0x00000100 -> 0x0007fde0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] On node 0 totalpages: 523631
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA zone: 0 pages reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA zone: 3927 pages, LIFO batch:0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA32 zone: 7105 pages used for memmap
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   DMA32 zone: 512543 pages, LIFO batch:31
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Detected use of extended apic ids on hypertransport bus
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x4008
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] SMP: Allowing 4 CPUs, 3 hotplug CPUs
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] nr_irqs_gsi: 40
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Allocating PCI resources starting at 7fe00000 (gap: 7fe00000:60200000)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u524288
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] pcpu-alloc: s91520 r8192 d23168 u524288 alloc=1*2097152
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516470
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Policy zone: DMA32
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-24-generic root=UUID=b71732a7-07cc-419d-9869-a5ddd32b69d4 ro quiet splash
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Checking aperture...
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] No AGP bridge found
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Node 0: aperture @ 1e0000000 size 32 MB
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Aperture beyond 4GB. Ignoring.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Subtract (48 early reservations)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #2 [0037571000 - 0037ff0000]         RAMDISK
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #3 [0001d18000 - 0001d180fe]             BRK
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #4 [00000f5830 - 0000100000]   BIOS reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #5 [00000f5820 - 00000f5830]    MP-table mpf
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #6 [000009f800 - 00000f0f00]   BIOS reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #7 [00000f1068 - 00000f5820]   BIOS reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #8 [00000f0f00 - 00000f1068]    MP-table mpc
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #12 [0001d18100 - 0001d1d100]       NODE_DATA
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #13 [0001d1d100 - 0001d1e100]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #14 [0001d17140 - 0001d172c0]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #15 [000251f000 - 0002520000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #16 [0002520000 - 0002521000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #17 [0002600000 - 0004200000]        MEMMAP 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #18 [0001d172c0 - 0001d17440]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #19 [0001d1e100 - 0001d2a100]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #20 [0001d2b000 - 0001d2c000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #21 [0001d17440 - 0001d17481]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #22 [0001d174c0 - 0001d17503]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #23 [0001d17540 - 0001d17770]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #24 [0001d17780 - 0001d177e8]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #25 [0001d17800 - 0001d17868]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #26 [0001d17880 - 0001d178e8]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #27 [0001d17900 - 0001d17968]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #28 [0001d17980 - 0001d179e8]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #29 [0001d17a00 - 0001d17a68]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #30 [0001d17a80 - 0001d17ae8]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #31 [0001d17b00 - 0001d17b68]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #32 [0001d17b80 - 0001d17be8]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #33 [0001d17c00 - 0001d17c20]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #34 [0001d17c40 - 0001d17caa]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #35 [0001d17cc0 - 0001d17d2a]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #37 [0001e80000 - 0001e9e000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #38 [0001f00000 - 0001f1e000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #39 [0001f80000 - 0001f9e000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #40 [0001d17d40 - 0001d17d48]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #41 [0001d17d80 - 0001d17d88]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #42 [0001d17dc0 - 0001d17dd0]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #43 [0001d17e00 - 0001d17e20]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #44 [0001d17e40 - 0001d17f70]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #45 [0001d17f80 - 0001d17fd0]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #46 [0001d2a100 - 0001d2a150]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000]   #47 [0001d2c000 - 0001d34000]         BOOTMEM
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Memory: 2041064k/2094976k available (5711k kernel code, 452k absent, 53460k reserved, 5379k data, 908k init)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Hierarchical RCU implementation.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] 	RCU-based detection of stalled CPUs is disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] 	Verbose stalled-CPUs detection is disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] NR_IRQS:4352 nr_irqs:712
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] spurious 8259A interrupt: IRQ7.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Console: colour VGA+ 80x25
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] console [tty0] enabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] allocated 20971520 bytes of page_cgroup
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] hpet clockevent registered
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Fast TSC calibration using PIT
Jan 16 16:00:05 mythbuntu-server kernel: [    0.000000] Detected 2104.523 MHz processor.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4209.04 BogoMIPS (lpj=21045230)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010016] pid_max: default: 32768 minimum: 301
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010045] Security Framework initialized
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010066] AppArmor: AppArmor initialized
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010068] Yama: becoming mindful.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.010375] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.012029] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.012804] Mount-cache hash table entries: 256
Jan 16 16:00:05 mythbuntu-server kernel: [    0.012991] Initializing cgroup subsys ns
Jan 16 16:00:05 mythbuntu-server kernel: [    0.012996] Initializing cgroup subsys cpuacct
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013001] Initializing cgroup subsys memory
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013012] Initializing cgroup subsys devices
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013014] Initializing cgroup subsys freezer
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013017] Initializing cgroup subsys net_cls
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013050] tseg: 007fe00000
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013053] mce: CPU supports 5 MCE banks
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013065] using C1E aware idle routine
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013068] Performance Events: AMD PMU driver.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013073] ... version:                0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013075] ... bit width:              48
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013076] ... generic registers:      4
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013078] ... value mask:             0000ffffffffffff
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013080] ... max period:             00007fffffffffff
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013082] ... fixed-purpose events:   0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013084] ... event mask:             000000000000000f
Jan 16 16:00:05 mythbuntu-server kernel: [    0.013119] SMP alternatives: switching to UP code
Jan 16 16:00:05 mythbuntu-server kernel: [    0.024073] ACPI: Core revision 20100428
Jan 16 16:00:05 mythbuntu-server kernel: [    0.040026] ftrace: converting mcount calls to 0f 1f 44 00 00
Jan 16 16:00:05 mythbuntu-server kernel: [    0.040039] ftrace: allocating 22678 entries in 89 pages
Jan 16 16:00:05 mythbuntu-server kernel: [    0.050099] Setting APIC routing to flat
Jan 16 16:00:05 mythbuntu-server kernel: [    0.050666] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jan 16 16:00:05 mythbuntu-server kernel: [    0.158643] CPU0: AMD Sempron(tm) Processor LE-1200 stepping 01
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] Brought up 1 CPUs
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] Total of 1 processors activated (4209.04 BogoMIPS).
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] devtmpfs: initialized
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] regulator: core version 0.5
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] Time:  2:59:46  Date: 01/16/11
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] NET: Registered protocol family 16
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] node 0 link 0: io port [b000, ffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] TOM: 0000000080000000 aka 2048M
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [a0000, bffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [80000000, fe02ffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] node 0 link 0: mmio [e0000000, efffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] bus: [00, 04] on node 0 link 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] bus: 00 index 0 [io  0x0000-0xffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] bus: 00 index 2 [mem 0x80000000-0xfcffffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] ACPI: bus type pci registered
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.160000] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Jan 16 16:00:05 mythbuntu-server kernel: [    0.171595] PCI: Using configuration type 1 for base access
Jan 16 16:00:05 mythbuntu-server kernel: [    0.172812] bio: create slab <bio-0> at 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.173703] ACPI: EC: Look up EC in DSDT
Jan 16 16:00:05 mythbuntu-server kernel: [    0.185281] ACPI: Interpreter enabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.185286] ACPI: (supports S0 S3 S4 S5)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.185331] ACPI: Using IOAPIC for interrupt routing
Jan 16 16:00:05 mythbuntu-server kernel: [    0.195441] ACPI: No dock devices found.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.195446] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 16 16:00:05 mythbuntu-server kernel: [    0.195632] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196006] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196009] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196013] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196017] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196021] pci_root PNP0A03:00: host bridge window [mem 0x7ff00000-0xfebfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196050] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196123] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196126] pci 0000:00:02.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196173] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196176] pci 0000:00:04.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196227] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196230] pci 0000:00:0a.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196279] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196286] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196294] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196301] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196308] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196316] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196373] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196433] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196507] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196564] pci 0000:00:12.2: supports D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196566] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196571] pci 0000:00:12.2: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196611] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196671] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196744] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196801] pci 0000:00:13.2: supports D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196803] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196808] pci 0000:00:13.2: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196928] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196935] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196943] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196950] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.196957] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197026] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197073] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197078] pci 0000:00:14.2: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197198] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197365] pci 0000:01:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197375] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197385] pci 0000:01:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197391] pci 0000:01:00.0: reg 24: [io  0xef00-0xef7f]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.197398] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210016] pci 0000:00:02.0: PCI bridge to [bus 01-01]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210021] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210024] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210029] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210093] pci 0000:02:00.0: reg 10: [mem 0xfd400000-0xfd7fffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210107] pci 0000:02:00.0: reg 18: [mem 0xfd000000-0xfd3fffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210165] pci 0000:02:00.0: supports D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210167] pci 0000:02:00.0: PME# supported from D0 D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.210172] pci 0000:02:00.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230011] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230016] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230019] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230024] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230079] pci 0000:03:00.0: reg 10: [io  0xce00-0xceff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230096] pci 0000:03:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230109] pci 0000:03:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230116] pci 0000:03:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230150] pci 0000:03:00.0: supports D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230152] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Jan 16 16:00:05 mythbuntu-server kernel: [    0.230156] pci 0000:03:00.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250011] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250016] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250019] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250024] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250101] pci 0000:04:0e.0: reg 10: [mem 0xfddff000-0xfddff7ff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250110] pci 0000:04:0e.0: reg 14: [mem 0xfddf8000-0xfddfbfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250173] pci 0000:04:0e.0: supports D1 D2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250175] pci 0000:04:0e.0: PME# supported from D0 D1 D2 D3hot
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250181] pci 0000:04:0e.0: PME# disabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250219] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250224] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250229] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250234] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250237] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250239] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250242] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250245] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250248] pci 0000:00:14.4:   bridge window [mem 0x7ff00000-0xfebfffff] (subtractive decode)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250269] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.250875] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.251039] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.251138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.251255] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296112] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296255] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296397] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296538] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296679] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296821] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.296962] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297103] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297155] HEST: Table is not found!
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297248] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297253] vgaarb: loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297423] SCSI subsystem initialized
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297495] libata version 3.00 loaded.
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297565] usbcore: registered new interface driver usbfs
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297578] usbcore: registered new interface driver hub
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297608] usbcore: registered new device driver usb
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297839] ACPI: WMI: Mapper loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297842] PCI: Using ACPI for IRQ routing
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297845] PCI: pci_cache_line_size set to 64 bytes
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297856] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297948] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
Jan 16 16:00:05 mythbuntu-server kernel: [    0.297952] reserve RAM buffer: 000000007fde0000 - 000000007fffffff 
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298064] NetLabel: Initializing
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298066] NetLabel:  domain hash size = 128
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298068] NetLabel:  protocols = UNLABELED CIPSOv4
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298083] NetLabel:  unlabeled traffic allowed by default
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298130] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.298135] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Jan 16 16:00:05 mythbuntu-server kernel: [    0.300031] Switching to clocksource hpet
Jan 16 16:00:05 mythbuntu-server kernel: [    0.314284] AppArmor: AppArmor Filesystem Enabled
Jan 16 16:00:05 mythbuntu-server kernel: [    0.314306] pnp: PnP ACPI init
Jan 16 16:00:05 mythbuntu-server kernel: [    0.314333] ACPI: bus type pnp registered
Jan 16 16:00:05 mythbuntu-server kernel: [    0.315979] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.316031] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:01:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.316041] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:03:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321891] pnp 00:0d: disabling [mem 0x000d1a00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321896] pnp 00:0d: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321902] pnp 00:0d: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321907] pnp 00:0d: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321912] pnp 00:0d: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.321917] pnp 00:0d: disabling [mem 0x00100000-0x7fddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322087] pnp: PnP ACPI: found 14 devices
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322089] ACPI: ACPI bus type pnp unregistered
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322106] system 00:01: [io  0x04d0-0x04d1] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322111] system 00:01: [io  0x0220-0x0225] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322116] system 00:01: [io  0x0290-0x0294] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322126] system 00:02: [io  0x4100-0x411f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322131] system 00:02: [io  0x0228-0x022f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322136] system 00:02: [io  0x0238-0x023f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322141] system 00:02: [io  0x040b] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322146] system 00:02: [io  0x04d6] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322151] system 00:02: [io  0x0c00-0x0c01] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322156] system 00:02: [io  0x0c14] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322161] system 00:02: [io  0x0c50-0x0c52] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322166] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322171] system 00:02: [io  0x0c6f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322176] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322181] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322186] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322191] system 00:02: [io  0x4000-0x40fe] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322196] system 00:02: [io  0x4210-0x4217] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322201] system 00:02: [io  0x0b00-0x0b0f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322206] system 00:02: [io  0x0b10-0x0b1f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322211] system 00:02: [io  0x0b20-0x0b3f] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322217] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322230] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322240] system 00:0d: [mem 0x7fde0000-0x7fdfffff] could not be reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322246] system 00:0d: [mem 0xffff0000-0xffffffff] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322252] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322257] system 00:0d: [mem 0xfee00000-0xfee00fff] could not be reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.322263] system 00:0d: [mem 0xfff80000-0xfffeffff] has been reserved
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330391] pci 0000:01:00.0: BAR 6: assigned [mem 0xfb000000-0xfb01ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330396] pci 0000:00:02.0: PCI bridge to [bus 01-01]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330400] pci 0000:00:02.0:   bridge window [io  0xe000-0xefff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330403] pci 0000:00:02.0:   bridge window [mem 0xf8000000-0xfbffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330407] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330412] pci 0000:00:04.0: PCI bridge to [bus 02-02]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330415] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330419] pci 0000:00:04.0:   bridge window [mem 0xfd000000-0xfd7fffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330422] pci 0000:00:04.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330428] pci 0000:03:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330432] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330434] pci 0000:00:0a.0:   bridge window [io  0xc000-0xcfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330438] pci 0000:00:0a.0:   bridge window [mem 0xfde00000-0xfdefffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330442] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330447] pci 0000:00:14.4: PCI bridge to [bus 04-04]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330450] pci 0000:00:14.4:   bridge window [io  0xb000-0xbfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330456] pci 0000:00:14.4:   bridge window [mem 0xfdd00000-0xfddfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330461] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330478]   alloc irq_desc for 18 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330481]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330496] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330501] pci 0000:00:02.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330509]   alloc irq_desc for 16 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330512]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330522] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330526] pci 0000:00:04.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330533] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330536] pci 0000:00:0a.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330545] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330548] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330550] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330553] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330555] pci_bus 0000:00: resource 8 [mem 0x7ff00000-0xfebfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330558] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330560] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfbffffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330563] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330566] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330568] pci_bus 0000:02: resource 1 [mem 0xfd000000-0xfd7fffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330571] pci_bus 0000:02: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330574] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330576] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330579] pci_bus 0000:03: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330581] pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330584] pci_bus 0000:04: resource 1 [mem 0xfdd00000-0xfddfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330586] pci_bus 0000:04: resource 2 [mem 0xfdc00000-0xfdcfffff pref]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330589] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330591] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330594] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330596] pci_bus 0000:04: resource 7 [mem 0x000c0000-0x000dffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330599] pci_bus 0000:04: resource 8 [mem 0x7ff00000-0xfebfffff]
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330659] NET: Registered protocol family 2
Jan 16 16:00:05 mythbuntu-server kernel: [    0.330945] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.332045] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.335145] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.335813] TCP: Hash tables configured (established 262144 bind 65536)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.335817] TCP reno registered
Jan 16 16:00:05 mythbuntu-server kernel: [    0.335831] UDP hash table entries: 1024 (order: 3, 32768 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.335863] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    0.336090] NET: Registered protocol family 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.360021] pci 0000:00:12.1: OHCI: BIOS handoff failed (BIOS bug?) 00000184
Jan 16 16:00:05 mythbuntu-server kernel: [    1.450065] pci 0000:01:00.0: Boot video device
Jan 16 16:00:05 mythbuntu-server kernel: [    1.450082] PCI: CLS 4 bytes, default 64
Jan 16 16:00:05 mythbuntu-server kernel: [    1.450335] Trying to unpack rootfs image as initramfs...
Jan 16 16:00:05 mythbuntu-server kernel: [    1.500798] Scanning for low memory corruption every 60 seconds
Jan 16 16:00:05 mythbuntu-server kernel: [    1.501029] audit: initializing netlink socket (disabled)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.501047] type=2000 audit(1295146787.500:1): initialized
Jan 16 16:00:05 mythbuntu-server kernel: [    1.530573] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jan 16 16:00:05 mythbuntu-server kernel: [    1.544386] VFS: Disk quotas dquot_6.5.2
Jan 16 16:00:05 mythbuntu-server kernel: [    1.544523] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.546103] fuse init (API version 7.14)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.546340] msgmni has been set to 3986
Jan 16 16:00:05 mythbuntu-server kernel: [    1.550553] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.550558] io scheduler noop registered
Jan 16 16:00:05 mythbuntu-server kernel: [    1.550560] io scheduler deadline registered
Jan 16 16:00:05 mythbuntu-server kernel: [    1.550657] io scheduler cfq registered (default)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560119] pcieport 0000:00:02.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560149]   alloc irq_desc for 40 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560151]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560162] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560378] pcieport 0000:00:04.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560404]   alloc irq_desc for 41 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560406]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560411] pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560570] pcieport 0000:00:0a.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560596]   alloc irq_desc for 42 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560598]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560603] pcieport 0000:00:0a.0: irq 42 for MSI/MSI-X
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560782] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jan 16 16:00:05 mythbuntu-server kernel: [    1.560843] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jan 16 16:00:05 mythbuntu-server kernel: [    1.561262] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.561272] ACPI: Power Button [PWRB]
Jan 16 16:00:05 mythbuntu-server kernel: [    1.561375] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.561381] ACPI: Power Button [PWRF]
Jan 16 16:00:05 mythbuntu-server kernel: [    1.562303] ACPI: acpi_idle registered with cpuidle
Jan 16 16:00:05 mythbuntu-server kernel: [    1.580655] ERST: Table is not found!
Jan 16 16:00:05 mythbuntu-server kernel: [    1.581097] Linux agpgart interface v0.103
Jan 16 16:00:05 mythbuntu-server kernel: [    1.581103] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jan 16 16:00:05 mythbuntu-server kernel: [    1.581267] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jan 16 16:00:05 mythbuntu-server kernel: [    1.581858] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jan 16 16:00:05 mythbuntu-server kernel: [    1.584243] brd: module loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    1.585378] loop: module loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    1.590114] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [    1.591089] Fixed MDIO Bus: probed
Jan 16 16:00:05 mythbuntu-server kernel: [    1.591176] PPP generic driver version 2.4.2
Jan 16 16:00:05 mythbuntu-server kernel: [    1.591294] tun: Universal TUN/TAP device driver, 1.6
Jan 16 16:00:05 mythbuntu-server kernel: [    1.591296] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Jan 16 16:00:05 mythbuntu-server kernel: [    1.591524] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600273]   alloc irq_desc for 17 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600278]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600295] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600331] ehci_hcd 0000:00:12.2: EHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600479] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600536] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600552] ehci_hcd 0000:00:12.2: debug port 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.600607] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.620168] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Jan 16 16:00:05 mythbuntu-server kernel: [    1.620582] hub 1-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.620590] hub 1-0:1.0: 6 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630394]   alloc irq_desc for 19 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630398]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630414] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630449] ehci_hcd 0000:00:13.2: EHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630581] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630626] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630643] ehci_hcd 0000:00:13.2: debug port 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.630695] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.650129] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Jan 16 16:00:05 mythbuntu-server kernel: [    1.650468] hub 2-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.650475] hub 2-0:1.0: 6 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.650708] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jan 16 16:00:05 mythbuntu-server kernel: [    1.660304] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [    1.660343] ohci_hcd 0000:00:12.0: OHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.660509] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Jan 16 16:00:05 mythbuntu-server kernel: [    1.660592] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.724613] hub 3-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.724626] hub 3-0:1.0: 3 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.730494] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [    1.730541] ohci_hcd 0000:00:12.1: OHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.730711] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Jan 16 16:00:05 mythbuntu-server kernel: [    1.730750] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.794741] hub 4-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.794755] hub 4-0:1.0: 3 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.800394] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    1.800433] ohci_hcd 0000:00:13.0: OHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.800602] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Jan 16 16:00:05 mythbuntu-server kernel: [    1.800666] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.851540] Freeing initrd memory: 10748k freed
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864442] hub 5-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864454] hub 5-0:1.0: 3 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864729] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864764] ohci_hcd 0000:00:13.1: OHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864903] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Jan 16 16:00:05 mythbuntu-server kernel: [    1.864939] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924333] hub 6-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924341] hub 6-0:1.0: 3 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924526] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924542] ohci_hcd 0000:00:14.5: OHCI Host Controller
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924644] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Jan 16 16:00:05 mythbuntu-server kernel: [    1.924671] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984328] hub 7-0:1.0: USB hub found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984336] hub 7-0:1.0: 2 ports detected
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984459] uhci_hcd: USB Universal Host Controller Interface driver
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984729] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984731] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Jan 16 16:00:05 mythbuntu-server kernel: [    1.984929] serio: i8042 KBD port at 0x60,0x64 irq 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.985118] mice: PS/2 mouse device common for all mice
Jan 16 16:00:05 mythbuntu-server kernel: [    1.985399] rtc_cmos 00:05: RTC can wake from S4
Jan 16 16:00:05 mythbuntu-server kernel: [    1.985508] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
Jan 16 16:00:05 mythbuntu-server kernel: [    1.985554] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
Jan 16 16:00:05 mythbuntu-server kernel: [    1.985807] device-mapper: uevent: version 1.0.3
Jan 16 16:00:05 mythbuntu-server kernel: [    1.986067] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
Jan 16 16:00:05 mythbuntu-server kernel: [    1.986192] device-mapper: multipath: version 1.1.1 loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    1.986195] device-mapper: multipath round-robin: version 1.0.0 loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    1.986468] cpuidle: using governor ladder
Jan 16 16:00:05 mythbuntu-server kernel: [    1.986471] cpuidle: using governor menu
Jan 16 16:00:05 mythbuntu-server kernel: [    1.987088] TCP cubic registered
Jan 16 16:00:05 mythbuntu-server kernel: [    1.987418] NET: Registered protocol family 10
Jan 16 16:00:05 mythbuntu-server kernel: [    1.989414] lo: Disabled Privacy Extensions
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990367] NET: Registered protocol family 17
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990444] powernow-k8: Found 1 AMD Sempron(tm) Processor LE-1200 (1 cpu cores) (version 2.20.00)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990552] powernow-k8:    0 : fid 0xd (2100 MHz), vid 0xa
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990555] powernow-k8:    1 : fid 0xc (2000 MHz), vid 0xb
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990559] powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xd
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990562] powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990899] PM: Resume from disk failed.
Jan 16 16:00:05 mythbuntu-server kernel: [    1.990922] registered taskstats version 1
Jan 16 16:00:05 mythbuntu-server kernel: [    1.991400]   Magic number: 11:820:965
Jan 16 16:00:05 mythbuntu-server kernel: [    1.991500] rtc_cmos 00:05: setting system clock to 2011-01-16 02:59:48 UTC (1295146788)
Jan 16 16:00:05 mythbuntu-server kernel: [    1.991503] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jan 16 16:00:05 mythbuntu-server kernel: [    1.991505] EDD information not available.
Jan 16 16:00:05 mythbuntu-server kernel: [    1.991668] Freeing unused kernel memory: 908k freed
Jan 16 16:00:05 mythbuntu-server kernel: [    1.992106] Write protecting the kernel read-only data: 10240k
Jan 16 16:00:05 mythbuntu-server kernel: [    1.992286] Freeing unused kernel memory: 412k freed
Jan 16 16:00:05 mythbuntu-server kernel: [    1.992674] Freeing unused kernel memory: 1644k freed
Jan 16 16:00:05 mythbuntu-server kernel: [    2.003130] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
Jan 16 16:00:05 mythbuntu-server kernel: [    2.034347] udev[99]: starting version 163
Jan 16 16:00:05 mythbuntu-server kernel: [    2.296007] Floppy drive(s): fd0 is 1.44M
Jan 16 16:00:05 mythbuntu-server kernel: [    2.564722] FDC 0 is a post-1991 82077
Jan 16 16:00:05 mythbuntu-server kernel: [    2.650077] usb 3-2: new low speed USB device using ohci_hcd and address 2
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669176] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669203] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669253] r8169 0000:03:00.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669292]   alloc irq_desc for 43 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669294]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.669310] r8169 0000:03:00.0: irq 43 for MSI/MSI-X
Jan 16 16:00:05 mythbuntu-server kernel: [    2.680970] r8169 0000:03:00.0: eth0: RTL8168c/8111c at 0xffffc90000338000, 00:1f:d0:9f:ee:1a, XID 1c4000c0 IRQ 43
Jan 16 16:00:05 mythbuntu-server kernel: [    2.698321] scsi0 : pata_atiixp
Jan 16 16:00:05 mythbuntu-server kernel: [    2.713699] scsi1 : pata_atiixp
Jan 16 16:00:05 mythbuntu-server kernel: [    2.717200] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
Jan 16 16:00:05 mythbuntu-server kernel: [    2.717203] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747629] ahci 0000:00:11.0: version 3.0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747652]   alloc irq_desc for 22 on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747655]   alloc kstat_irqs on node 0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747668] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747825] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jan 16 16:00:05 mythbuntu-server kernel: [    2.747829] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Jan 16 16:00:05 mythbuntu-server kernel: [    2.748670] firewire_ohci 0000:04:0e.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.756113] scsi2 : ahci
Jan 16 16:00:05 mythbuntu-server kernel: [    2.756413] scsi3 : ahci
Jan 16 16:00:05 mythbuntu-server kernel: [    2.756637] scsi4 : ahci
Jan 16 16:00:05 mythbuntu-server kernel: [    2.756860] scsi5 : ahci
Jan 16 16:00:05 mythbuntu-server kernel: [    2.757450] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.757454] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.757458] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.757463] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
Jan 16 16:00:05 mythbuntu-server kernel: [    2.800091] firewire_ohci: Added fw-ohci device 0000:04:0e.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x2
Jan 16 16:00:05 mythbuntu-server kernel: [    2.930396] ata2.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
Jan 16 16:00:05 mythbuntu-server kernel: [    2.930403] ata2.00: ATA-8: WDC WD10EARS-00Z5B1, 80.00A80, max UDMA/133
Jan 16 16:00:05 mythbuntu-server kernel: [    2.930406] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jan 16 16:00:05 mythbuntu-server kernel: [    2.950594] ata2.00: configured for UDMA/100
Jan 16 16:00:05 mythbuntu-server kernel: [    2.950792] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Z 80.0 PQ: 0 ANSI: 5
Jan 16 16:00:05 mythbuntu-server kernel: [    2.951138] sd 1:0:0:0: Attached scsi generic sg0 type 0
Jan 16 16:00:05 mythbuntu-server kernel: [    2.951626] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 16 16:00:05 mythbuntu-server kernel: [    2.951831] sd 1:0:0:0: [sda] Write Protect is off
Jan 16 16:00:05 mythbuntu-server kernel: [    2.951835] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jan 16 16:00:05 mythbuntu-server kernel: [    2.951920] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 16 16:00:05 mythbuntu-server kernel: [    2.952401]  sda: sda1
Jan 16 16:00:05 mythbuntu-server kernel: [    2.960933] sd 1:0:0:0: [sda] Attached SCSI disk
Jan 16 16:00:05 mythbuntu-server kernel: [    3.100062] ata5: SATA link down (SStatus 0 SControl 300)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.100096] ata4: SATA link down (SStatus 0 SControl 300)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.240027] usb 3-3: new low speed USB device using ohci_hcd and address 3
Jan 16 16:00:05 mythbuntu-server kernel: [    3.300158] firewire_core: created device fw0: GUID 007d8c7800001fd0, S400
Jan 16 16:00:05 mythbuntu-server kernel: [    3.300188] ata6: softreset failed (device not ready)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.300191] ata6: applying SB600 PMP SRST workaround and retrying
Jan 16 16:00:05 mythbuntu-server kernel: [    3.300210] ata3: softreset failed (device not ready)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.300213] ata3: applying SB600 PMP SRST workaround and retrying
Jan 16 16:00:05 mythbuntu-server kernel: [    3.500052] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.500085] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.500274] ata6.00: ATAPI: ATAPI   iHAS120   6, 7L0F, max UDMA/100
Jan 16 16:00:05 mythbuntu-server kernel: [    3.501079] usbcore: registered new interface driver hiddev
Jan 16 16:00:05 mythbuntu-server kernel: [    3.501314] ata6.00: configured for UDMA/100
Jan 16 16:00:05 mythbuntu-server kernel: [    3.501908] usbcore: registered new interface driver usbhid
Jan 16 16:00:05 mythbuntu-server kernel: [    3.501910] usbhid: USB HID core driver
Jan 16 16:00:05 mythbuntu-server kernel: [    3.520820] ata3.00: HPA unlocked: 1953523055 -> 1953525168, native 1953525168
Jan 16 16:00:05 mythbuntu-server kernel: [    3.520913] ata3.00: ATA-8: WDC WD10EURS-630AB1, 80.00A80, max UDMA/133
Jan 16 16:00:05 mythbuntu-server kernel: [    3.520916] ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
Jan 16 16:00:05 mythbuntu-server kernel: [    3.523134] ata3.00: configured for UDMA/133
Jan 16 16:00:05 mythbuntu-server kernel: [    3.540205] scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EURS-630 80.0 PQ: 0 ANSI: 5
Jan 16 16:00:05 mythbuntu-server kernel: [    3.540561] sd 2:0:0:0: Attached scsi generic sg1 type 0
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541131] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541134] sd 2:0:0:0: [sdb] 4096-byte physical blocks
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541359] sd 2:0:0:0: [sdb] Write Protect is off
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541364] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541449] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 16 16:00:05 mythbuntu-server kernel: [    3.541801] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS120   6      7L0F PQ: 0 ANSI: 5
Jan 16 16:00:05 mythbuntu-server kernel: [    3.542822]  sdb: sdb1 <sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Jan 16 16:00:05 mythbuntu-server kernel: [    3.547714] Uniform CD-ROM driver Revision: 3.20
Jan 16 16:00:05 mythbuntu-server kernel: [    3.547985] sr 5:0:0:0: Attached scsi CD-ROM sr0
Jan 16 16:00:05 mythbuntu-server kernel: [    3.548143] sr 5:0:0:0: Attached scsi generic sg2 type 5
Jan 16 16:00:05 mythbuntu-server kernel: [    3.555517]  sdb5 sdb6 sdb7 >
Jan 16 16:00:05 mythbuntu-server kernel: [    3.579040] sd 2:0:0:0: [sdb] Attached SCSI disk
Jan 16 16:00:05 mythbuntu-server kernel: [    3.633524] input: A4Tech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input3
Jan 16 16:00:05 mythbuntu-server kernel: [    3.634087] a4tech 0003:09DA:0006.0001: input,hidraw0: USB HID v1.10 Mouse [A4Tech USB Optical Mouse] on usb-0000:00:12.0-2/input0
Jan 16 16:00:05 mythbuntu-server kernel: [    3.690444] input: Logitech Logitech Cordless RumblePad 2 as /devices/pci0000:00/0000:00:12.0/usb3/3-3/3-3:1.0/input/input4
Jan 16 16:00:05 mythbuntu-server kernel: [    3.690636] logitech 0003:046D:C219.0002: input,hidraw1: USB HID v1.10 Gamepad [Logitech Logitech Cordless RumblePad 2] on usb-0000:00:12.0-3/input0
Jan 16 16:00:05 mythbuntu-server kernel: [    3.690645] Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>
Jan 16 16:00:05 mythbuntu-server kernel: [    3.830028] usb 4-1: new full speed USB device using ohci_hcd and address 2
Jan 16 16:00:05 mythbuntu-server kernel: [    4.060791] EXT4-fs (sdb6): INFO: recovery required on readonly filesystem
Jan 16 16:00:05 mythbuntu-server kernel: [    4.060796] EXT4-fs (sdb6): write access will be enabled during recovery
Jan 16 16:00:05 mythbuntu-server kernel: [    4.401225] EXT4-fs (sdb6): recovery complete
Jan 16 16:00:05 mythbuntu-server kernel: [    4.403121] EXT4-fs (sdb6): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 16:00:05 mythbuntu-server kernel: [   13.928469] Adding 3905532k swap on /dev/sdb5.  Priority:-1 extents:1 across:3905532k 
Jan 16 16:00:05 mythbuntu-server kernel: [   14.081802] udev[379]: starting version 163
Jan 16 16:00:05 mythbuntu-server kernel: [   14.169435] lp: driver loaded but no devices found
Jan 16 16:00:05 mythbuntu-server kernel: [   14.670126] parport_pc 00:0a: reported by Plug and Play ACPI
Jan 16 16:00:05 mythbuntu-server kernel: [   14.670214] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Jan 16 16:00:05 mythbuntu-server kernel: [   14.960823] lp0: using parport0 (interrupt-driven).
Jan 16 16:00:05 mythbuntu-server kernel: [   15.054828] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro
Jan 16 16:00:05 mythbuntu-server kernel: [   15.055710] ppdev: user-space parallel port driver
Jan 16 16:00:05 mythbuntu-server kernel: [   15.146681] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [mem 0x00000b00-0x00000b0f disabled]
Jan 16 16:00:05 mythbuntu-server kernel: [   15.146686] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Jan 16 16:00:05 mythbuntu-server kernel: [   15.251142] EDAC MC: Ver: 2.1.0 Dec  2 2010
Jan 16 16:00:05 mythbuntu-server kernel: [   15.262514] saa7164 driver loaded
Jan 16 16:00:05 mythbuntu-server kernel: [   15.313060] type=1400 audit(1295146801.811:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=535 comm="apparmor_parser"
Jan 16 16:00:05 mythbuntu-server kernel: [   15.313437] type=1400 audit(1295146801.811:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=535 comm="apparmor_parser"
Jan 16 16:00:05 mythbuntu-server kernel: [   15.361388] saa7164 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [   15.362145] CORE saa7164[0]: subsystem: 0070:8940, board: Hauppauge WinTV-HVR2200 [card=4,insmod option]
Jan 16 16:00:05 mythbuntu-server kernel: [   15.362152] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16, latency: 0, mmio: 0xfd400000
Jan 16 16:00:05 mythbuntu-server kernel: [   15.362159] saa7164 0000:02:00.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [   15.365080] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
Jan 16 16:00:05 mythbuntu-server kernel: [   15.514137] type=1400 audit(1295146802.011:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=535 comm="apparmor_parser"
Jan 16 16:00:05 mythbuntu-server kernel: [   15.580086] saa7164_downloadfirmware() no first image
Jan 16 16:00:05 mythbuntu-server kernel: [   15.580151] saa7164_downloadfirmware() Waiting for firmware upload (v4l-saa7164-1.0.3.fw)
Jan 16 16:00:05 mythbuntu-server kernel: [   15.756838] type=1400 audit(1295146802.251:5): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=603 comm="apparmor_parser"
Jan 16 16:00:05 mythbuntu-server kernel: [   15.905813] EDAC amd64_edac:  Ver: 3.3.0 Dec  2 2010
Jan 16 16:00:05 mythbuntu-server kernel: [   15.939954] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
Jan 16 16:00:05 mythbuntu-server kernel: [   15.939959] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
Jan 16 16:00:05 mythbuntu-server kernel: [   15.939961]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
Jan 16 16:00:05 mythbuntu-server kernel: [   15.939963]  (Note that use of the override may cause unknown side effects.)
Jan 16 16:00:05 mythbuntu-server kernel: [   15.940102] amd64_edac: probe of 0000:00:18.2 failed with error -22
Jan 16 16:00:05 mythbuntu-server kernel: [   16.152482] IR NEC protocol handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   16.180091] Registered IR keymap rc-rc6-mce
Jan 16 16:00:05 mythbuntu-server kernel: [   16.218089] input: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0/input5
Jan 16 16:00:05 mythbuntu-server kernel: [   16.218242] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1019:0f38) as /devices/virtual/rc/rc0
Jan 16 16:00:05 mythbuntu-server kernel: [   16.218336] mceusb 4-1:1.0: Registered ECS eHome Infrared Transceiver on usb4:2
Jan 16 16:00:05 mythbuntu-server kernel: [   16.218399] usbcore: registered new interface driver mceusb
Jan 16 16:00:05 mythbuntu-server kernel: [   16.321387] IR RC5(x) protocol handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   16.390717] nvidia: module license 'NVIDIA' taints kernel.
Jan 16 16:00:05 mythbuntu-server kernel: [   16.390721] Disabling lock debugging due to kernel taint
Jan 16 16:00:05 mythbuntu-server kernel: [   16.995253] IR RC6 protocol handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   17.149553] IR JVC protocol handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188369] saa7164_downloadfirmware() firmware read 3978608 bytes.
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188373] saa7164_downloadfirmware() firmware loaded.
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188375] Firmware file header part 1:
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188378]  .FirmwareSize = 0x0
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188379]  .BSLSize = 0x0
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188380]  .Reserved = 0x3cb57
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188382]  .Version = 0x3
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188383] saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188390] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188392] saa7164_downloadfirmware() BSLSize = 0x0
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188394] saa7164_downloadfirmware() Reserved = 0x0
Jan 16 16:00:05 mythbuntu-server kernel: [   17.188396] saa7164_downloadfirmware() Version = 0x51cc1
Jan 16 16:00:05 mythbuntu-server kernel: [   17.317225] IR Sony protocol handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   17.446479] lirc_dev: IR Remote Control driver registered, major 249 
Jan 16 16:00:05 mythbuntu-server kernel: [   17.462807] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
Jan 16 16:00:05 mythbuntu-server kernel: [   17.462813] IR LIRC bridge handler initialized
Jan 16 16:00:05 mythbuntu-server kernel: [   17.738816] EXT4-fs (sdb7): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 16:00:05 mythbuntu-server kernel: [   17.768536] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jan 16 16:00:05 mythbuntu-server kernel: [   17.902076] hda_codec: ALC889A: BIOS auto-probing.
Jan 16 16:00:05 mythbuntu-server kernel: [   18.509858] nvidia 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Jan 16 16:00:05 mythbuntu-server kernel: [   18.509875] nvidia 0000:01:00.0: setting latency timer to 64
Jan 16 16:00:05 mythbuntu-server kernel: [   18.509880] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
Jan 16 16:00:05 mythbuntu-server kernel: [   18.510437] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  260.19.06  Mon Sep 13 04:29:19 PDT 2010
Jan 16 16:00:05 mythbuntu-server kernel: [   19.117210] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Jan 16 16:00:06 mythbuntu-server kernel: [   19.508549] type=1400 audit(1295146806.001:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=921 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.508897] type=1400 audit(1295146806.001:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=921 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.509115] type=1400 audit(1295146806.001:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=921 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.546809] type=1400 audit(1295146806.041:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld" pid=925 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.573596] type=1400 audit(1295146806.071:10): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=926 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.616529] type=1400 audit(1295146806.111:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=927 comm="apparmor_parser"
Jan 16 16:00:06 mythbuntu-server kernel: [   19.629617] r8169 0000:03:00.0: eth0: link up
Jan 16 16:00:06 mythbuntu-server kernel: [   19.629629] r8169 0000:03:00.0: eth0: link up
Jan 16 16:00:09 mythbuntu-server kernel: [   22.707035] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro,commit=0
Jan 16 16:00:09 mythbuntu-server kernel: [   22.829234] EXT4-fs (sdb7): re-mounted. Opts: commit=0
Jan 16 16:00:09 mythbuntu-server kernel: [   22.853751] EXT4-fs (sda1): re-mounted. Opts: commit=0
Jan 16 16:00:11 mythbuntu-server kernel: [   24.630026] saa7164_downloadimage() Image downloaded, booting...
Jan 16 16:00:11 mythbuntu-server kernel: [   24.740025] saa7164_downloadimage() Image booted successfully.
Jan 16 16:00:11 mythbuntu-server kernel: [   24.740054] starting firmware download(2)
Jan 16 16:00:13 mythbuntu-server kernel: [   27.080023] saa7164_downloadimage() Image downloaded, booting...
Jan 16 16:00:15 mythbuntu-server kernel: [   28.510023] saa7164_downloadimage() Image booted successfully.
Jan 16 16:00:15 mythbuntu-server kernel: [   28.510051] firmware download complete.
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550173] tveeprom 0-0000: Hauppauge model 89619, rev D3F2, serial# 7088544
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550177] tveeprom 0-0000: MAC address is 00:0d:fe:6c:29:a0
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550180] tveeprom 0-0000: tuner model is NXP 18271C2_716x (idx 152, type 4)
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550183] tveeprom 0-0000: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550187] tveeprom 0-0000: audio processor is SAA7164 (idx 43)
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550190] tveeprom 0-0000: decoder processor is SAA7164 (idx 40)
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550192] tveeprom 0-0000: has radio
Jan 16 16:00:15 mythbuntu-server kernel: [   28.550194] saa7164[0]: Hauppauge eeprom: model=89619
Jan 16 16:00:15 mythbuntu-server kernel: [   28.615872] tda18271 1-0060: creating new instance
Jan 16 16:00:15 mythbuntu-server kernel: [   28.620142] TDA18271HD/C2 detected @ 1-0060
Jan 16 16:00:15 mythbuntu-server kernel: [   28.964898] DVB: registering new adapter (saa7164)
Jan 16 16:00:15 mythbuntu-server kernel: [   28.964906] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
Jan 16 16:00:15 mythbuntu-server kernel: [   28.995200] tda18271 2-0060: creating new instance
Jan 16 16:00:15 mythbuntu-server kernel: [   28.999568] TDA18271HD/C2 detected @ 2-0060
Jan 16 16:00:15 mythbuntu-server kernel: [   29.344476] tda18271: performing RF tracking filter calibration
Jan 16 16:00:16 mythbuntu-server kernel: [   29.880017] eth0: no IPv6 routers present
Jan 16 16:00:18 mythbuntu-server kernel: [   31.977913] tda18271: RF tracking filter calibration complete
Jan 16 16:00:18 mythbuntu-server kernel: [   31.978218] DVB: registering new adapter (saa7164)
Jan 16 16:00:18 mythbuntu-server kernel: [   31.978226] DVB: registering adapter 1 frontend 0 (NXP TDA10048HN DVB-T)...
Jan 16 16:00:21 mythbuntu-server kernel: [   34.664706] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
Jan 16 16:00:21 mythbuntu-server kernel: [   34.670697] tda10048_firmware_upload: firmware read 24878 bytes.
Jan 16 16:00:21 mythbuntu-server kernel: [   34.670700] tda10048_firmware_upload: firmware uploading
Jan 16 16:00:24 mythbuntu-server kernel: [   37.632227] tda10048_firmware_upload: firmware uploaded
Jan 16 16:00:24 mythbuntu-server kernel: [   38.065157] tda18271: performing RF tracking filter calibration
Jan 16 16:00:27 mythbuntu-server kernel: [   40.697791] tda18271: RF tracking filter calibration complete
Jan 16 16:00:27 mythbuntu-server kernel: [   41.096938] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
Jan 16 16:00:27 mythbuntu-server kernel: [   41.104458] tda10048_firmware_upload: firmware read 24878 bytes.
Jan 16 16:00:27 mythbuntu-server kernel: [   41.104461] tda10048_firmware_upload: firmware uploading
Jan 16 16:00:30 mythbuntu-server kernel: [   44.102364] tda10048_firmware_upload: firmware uploaded
Jan 16 16:01:10 mythbuntu-server kernel: [   83.510028] Clocksource tsc unstable (delta = -188175216 ns)

--------------000107030801050707000805--

