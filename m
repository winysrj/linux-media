Return-path: <mchehab@pedra>
Received: from contumacia.investici.org ([82.117.37.71]:34777 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab0JELgk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 07:36:40 -0400
Received: from [82.117.37.71] (contumacia [82.117.37.71]) (Authenticated sender: danlin@anche.no) by localhost (Postfix) with ESMTPSA id 3D5DA6C4CF
	for <linux-media@vger.kernel.org>; Tue,  5 Oct 2010 11:04:38 +0000 (UTC)
Subject: dvb-t pinnacle eb1a:2870
From: danlin <danlin@anche.no>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 13:04:32 +0200
Message-ID: <1286276672.2059.19.camel@ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

my lsusb 
my uname -am
my dmesg
my lsmod
at boot time

then i try to use two commands:
sudo rmmod em28xx
sudo modprobe em28xx card=45
sudo modprobe em28xx-dvb

and dmesg again
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 046d:c001 Logitech, Inc. N48/M-BB48 [FirstMouse
Plus]
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 004: ID 04f2:b159 Chicony Electronics Co., Ltd 
Bus 002 Device 003: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV
Stick
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Linux ubuntu 2.6.35-22-generic #33-Ubuntu SMP Sun Sep 19 20:32:27 UTC
2010 x86_64 GNU/Linux



@ubuntu:~$ dmesg 
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-22-generic (buildd@allspice) (gcc
version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu4) ) #33-Ubuntu SMP Sun Sep
19 20:32:27 UTC 2010 (Ubuntu 2.6.35-22.33-generic 2.6.35.4)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-22-generic
root=UUID=14af8c6b-4be4-4d26-96b3-5ef5e6739cd2 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c5400
(reserved)
[    0.000000]  BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI
NVS)
[    0.000000]  BIOS-e820: 000000007f7e7fb8 - 0000000080000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000
(reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000
(reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000
(reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000
(reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f7b0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 0FEDA0000 mask FFFFE0000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  modified: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  modified: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  modified: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f7b0000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f7b0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f7b0000 @ 16000-1a000
[    0.000000] RAMDISK: 37571000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6f60 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000007f7c81c4 00074 (v01 HPQOEM SLIC-MPC
00000001 HP   00000001)
[    0.000000] ACPI: FACP 000000007f7c8084 000F4 (v04 HP     308A
00000003 HP   00000001)
[    0.000000] ACPI: DSDT 000000007f7c8348 13057 (v01 HP      nc6xxxs
00010000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000007f7e7d80 00040
[    0.000000] ACPI: HPET 000000007f7c8238 00038 (v01 HP     308A
00000001 HP   00000001)
[    0.000000] ACPI: APIC 000000007f7c8270 00068 (v01 HP     308A
00000001 HP   00000001)
[    0.000000] ACPI: MCFG 000000007f7c82d8 0003C (v01 HP     308A
00000001 HP   00000001)
[    0.000000] ACPI: TCPA 000000007f7c8314 00032 (v02 HP     308A
00000001 HP   00000001)
[    0.000000] ACPI: SSDT 000000007f7db39f 00328 (v01 HP       HPQSAT
00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000007f7db6c7 0017D (v01 HP       HPQMRM
00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000007f7dc229 0025F (v01 HP      Cpu0Tst
00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007f7dc488 000A6 (v01 HP      Cpu1Tst
00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007f7dc52e 004D7 (v01 HP        CpuPm
00003000 INTL 20060317)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f7b0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f7b0000
[    0.000000]   NODE_DATA [0000000001d181c0 - 0000000001d1d1bf]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD ->
[ffff880002600000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f7b0
[    0.000000] On node 0 totalpages: 522047
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7083 pages used for memmap
[    0.000000]   DMA32 zone: 510981 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap:
80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520
r8192 d23168 u1048576
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 514908
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.35-22-generic
root=UUID=14af8c6b-4be4-4d26-96b3-5ef5e6739cd2 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -
bailing!
[    0.000000] Subtract (46 early reservations)
[    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
[    0.000000]   #2 [0037571000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001d18000 - 0001d18188]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #8 [0001d181c0 - 0001d1d1c0]       NODE_DATA
[    0.000000]   #9 [0001d1d1c0 - 0001d1e1c0]         BOOTMEM
[    0.000000]   #10 [0001d17140 - 0001d172c0]         BOOTMEM
[    0.000000]   #11 [000251f000 - 0002520000]         BOOTMEM
[    0.000000]   #12 [0002520000 - 0002521000]         BOOTMEM
[    0.000000]   #13 [0002600000 - 0004200000]        MEMMAP 0
[    0.000000]   #14 [0001d172c0 - 0001d17440]         BOOTMEM
[    0.000000]   #15 [0001d1e1c0 - 0001d2a1c0]         BOOTMEM
[    0.000000]   #16 [0001d2b000 - 0001d2c000]         BOOTMEM
[    0.000000]   #17 [0001d17440 - 0001d17481]         BOOTMEM
[    0.000000]   #18 [0001d174c0 - 0001d17503]         BOOTMEM
[    0.000000]   #19 [0001d17540 - 0001d17850]         BOOTMEM
[    0.000000]   #20 [0001d17880 - 0001d178e8]         BOOTMEM
[    0.000000]   #21 [0001d17900 - 0001d17968]         BOOTMEM
[    0.000000]   #22 [0001d17980 - 0001d179e8]         BOOTMEM
[    0.000000]   #23 [0001d17a00 - 0001d17a68]         BOOTMEM
[    0.000000]   #24 [0001d17a80 - 0001d17ae8]         BOOTMEM
[    0.000000]   #25 [0001d17b00 - 0001d17b68]         BOOTMEM
[    0.000000]   #26 [0001d17b80 - 0001d17be8]         BOOTMEM
[    0.000000]   #27 [0001d17c00 - 0001d17c68]         BOOTMEM
[    0.000000]   #28 [0001d17c80 - 0001d17ce8]         BOOTMEM
[    0.000000]   #29 [0001d17d00 - 0001d17d68]         BOOTMEM
[    0.000000]   #30 [0001d17d80 - 0001d17de8]         BOOTMEM
[    0.000000]   #31 [0001d17e00 - 0001d17e68]         BOOTMEM
[    0.000000]   #32 [0001d17e80 - 0001d17ee8]         BOOTMEM
[    0.000000]   #33 [0001d17f00 - 0001d17f20]         BOOTMEM
[    0.000000]   #34 [0001d17f40 - 0001d17faa]         BOOTMEM
[    0.000000]   #35 [0001d2a1c0 - 0001d2a22a]         BOOTMEM
[    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #37 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #38 [0001d17fc0 - 0001d17fc8]         BOOTMEM
[    0.000000]   #39 [0001d2a240 - 0001d2a248]         BOOTMEM
[    0.000000]   #40 [0001d2a280 - 0001d2a288]         BOOTMEM
[    0.000000]   #41 [0001d2a2c0 - 0001d2a2d0]         BOOTMEM
[    0.000000]   #42 [0001d2a300 - 0001d2a440]         BOOTMEM
[    0.000000]   #43 [0001d2a440 - 0001d2a4a0]         BOOTMEM
[    0.000000]   #44 [0001d2a4c0 - 0001d2a520]         BOOTMEM
[    0.000000]   #45 [0001d2c000 - 0001d34000]         BOOTMEM
[    0.000000] Memory: 2034968k/2088640k available (5708k kernel code,
452k absent, 53220k reserved, 5382k data, 908k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.797 MHz processor.
[    0.010011] Calibrating delay loop (skipped), value calculated using
timer frequency.. 3989.59 BogoMIPS (lpj=19947970)
[    0.010016] pid_max: default: 32768 minimum: 301
[    0.010042] Security Framework initialized
[    0.010065] AppArmor: AppArmor initialized
[    0.010067] Yama: becoming mindful.
[    0.010337] Dentry cache hash table entries: 262144 (order: 9,
2097152 bytes)
[    0.011652] Inode-cache hash table entries: 131072 (order: 8, 1048576
bytes)
[    0.012418] Mount-cache hash table entries: 256
[    0.012577] Initializing cgroup subsys ns
[    0.012583] Initializing cgroup subsys cpuacct
[    0.012586] Initializing cgroup subsys memory
[    0.012596] Initializing cgroup subsys devices
[    0.012599] Initializing cgroup subsys freezer
[    0.012601] Initializing cgroup subsys net_cls
[    0.012633] CPU: Physical Processor ID: 0
[    0.012635] CPU: Processor Core ID: 0
[    0.012638] mce: CPU supports 6 MCE banks
[    0.012645] CPU0: Thermal monitoring handled by SMI
[    0.012651] using mwait in idle threads.
[    0.012653] Performance Events: PEBS fmt0+, Core2 events, Intel PMU
driver.
[    0.012659] PEBS disabled due to CPU errata.
[    0.012663] ... version:                2
[    0.012665] ... bit width:              40
[    0.012666] ... generic registers:      2
[    0.012668] ... value mask:             000000ffffffffff
[    0.012670] ... max period:             000000007fffffff
[    0.012671] ... fixed-purpose events:   3
[    0.012673] ... event mask:             0000000700000003
[    0.020943] ACPI: Core revision 20100428
[    0.040010] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040016] ftrace: allocating 22680 entries in 89 pages
[    0.050065] Setting APIC routing to flat
[    0.050422] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.150941] CPU0: Intel(R) Core(TM)2 Duo CPU     T5870  @ 2.00GHz
stepping 0d
[    0.160000] Booting Node   0, Processors  #1 Ok.
[    0.020000] CPU1: Thermal monitoring handled by SMI
[    0.320016] Brought up 2 CPUs
[    0.320019] Total of 2 processors activated (7979.59 BogoMIPS).
[    0.320526] devtmpfs: initialized
[    0.320754] regulator: core version 0.5
[    0.320789] Time: 12:42:13  Date: 10/05/10
[    0.320822] NET: Registered protocol family 16
[    0.320846] Trying to unpack rootfs image as initramfs...
[    0.320960] ACPI FADT declares the system doesn't support PCIe ASPM,
so disable it
[    0.320964] ACPI: bus type pci registered
[    0.321038] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.321041] PCI: not using MMCONFIG
[    0.321043] PCI: Using configuration type 1 for base access
[    0.330142] bio: create slab <bio-0> at 0
[    0.332377] ACPI: EC: Look up EC in DSDT
[    0.366422] ACPI: SSDT 000000007f7db90c 0027F (v01 HP      Cpu0Ist
00003000 INTL 20060317)
[    0.367019] ACPI: Dynamic OEM Table Load:
[    0.367023] ACPI: SSDT (null) 0027F (v01 HP      Cpu0Ist 00003000
INTL 20060317)
[    0.367320] ACPI: SSDT 000000007f7dbc10 00619 (v01 HP      Cpu0Cst
00003001 INTL 20060317)
[    0.367895] ACPI: Dynamic OEM Table Load:
[    0.367899] ACPI: SSDT (null) 00619 (v01 HP      Cpu0Cst 00003001
INTL 20060317)
[    0.368298] ACPI: SSDT 000000007f7db844 000C8 (v01 HP      Cpu1Ist
00003000 INTL 20060317)
[    0.368886] ACPI: Dynamic OEM Table Load:
[    0.368890] ACPI: SSDT (null) 000C8 (v01 HP      Cpu1Ist 00003000
INTL 20060317)
[    0.369021] ACPI: SSDT 000000007f7dbb8b 00085 (v01 HP      Cpu1Cst
00003000 INTL 20060317)
[    0.369596] ACPI: Dynamic OEM Table Load:
[    0.369599] ACPI: SSDT (null) 00085 (v01 HP      Cpu1Cst 00003000
INTL 20060317)
[    0.402288] ACPI: Interpreter enabled
[    0.402288] ACPI: (supports S0 S3 S4 S5)
[    0.402288] ACPI: Using IOAPIC for interrupt routing
[    0.402288] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.402288] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in
ACPI motherboard resources
[    0.426416] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data =
0x62
[    0.426507] ACPI: Power Resource [C2A5] (on)
[    0.426561] ACPI: Power Resource [C1CE] (off)
[    0.426662] ACPI: Power Resource [C3C1] (off)
[    0.426759] ACPI: Power Resource [C3C2] (off)
[    0.426853] ACPI: Power Resource [C3C3] (off)
[    0.426951] ACPI: Power Resource [C3C4] (off)
[    0.427046] ACPI: Power Resource [C3C5] (off)
[    0.427358] ACPI: No dock devices found.
[    0.427361] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.431443] ACPI: PCI Root Bridge [C003] (domain 0000 [bus 00-ff])
[    0.439521] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7]
[    0.439525] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff]
[    0.439529] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.439532] pci_root PNP0A08:00: host bridge window [mem
0x7f800000-0xfedfffff]
[    0.439535] pci_root PNP0A08:00: host bridge window [mem
0xfee01000-0xffffffff]
[    0.439538] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000dffff]
[    0.439610] pci 0000:00:02.0: reg 10: [mem 0xe8400000-0xe84fffff
64bit]
[    0.439618] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.439624] pci 0000:00:02.0: reg 20: [io  0x6000-0x6007]
[    0.439665] pci 0000:00:02.1: reg 10: [mem 0xe8500000-0xe85fffff
64bit]
[    0.439782] pci 0000:00:1a.0: reg 20: [io  0x6020-0x603f]
[    0.439851] pci 0000:00:1a.7: reg 10: [mem 0xe8600000-0xe86003ff]
[    0.439920] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.439927] pci 0000:00:1a.7: PME# disabled
[    0.439975] pci 0000:00:1b.0: reg 10: [mem 0xe8604000-0xe8607fff
64bit]
[    0.440060] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.440065] pci 0000:00:1b.0: PME# disabled
[    0.440171] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.440176] pci 0000:00:1c.0: PME# disabled
[    0.440286] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.440291] pci 0000:00:1c.1: PME# disabled
[    0.440406] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.440411] pci 0000:00:1c.4: PME# disabled
[    0.440517] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.440522] pci 0000:00:1c.5: PME# disabled
[    0.440590] pci 0000:00:1d.0: reg 20: [io  0x6040-0x605f]
[    0.440659] pci 0000:00:1d.1: reg 20: [io  0x6060-0x607f]
[    0.440726] pci 0000:00:1d.2: reg 20: [io  0x6080-0x609f]
[    0.440793] pci 0000:00:1d.7: reg 10: [mem 0xe8608000-0xe86083ff]
[    0.440861] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.440867] pci 0000:00:1d.7: PME# disabled
[    0.441043] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.441048] pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by
ICH6 GPIO
[    0.441053] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0500 (mask 007f)
[    0.441062] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
02e8 (mask 0007)
[    0.441120] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.441129] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.441137] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.441145] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.441154] pci 0000:00:1f.1: reg 20: [io  0x60a0-0x60af]
[    0.441220] pci 0000:00:1f.2: reg 10: [io  0x13f0-0x13f7]
[    0.441229] pci 0000:00:1f.2: reg 14: [io  0x15f4-0x15f7]
[    0.441237] pci 0000:00:1f.2: reg 18: [io  0x1370-0x1377]
[    0.441245] pci 0000:00:1f.2: reg 1c: [io  0x1574-0x1577]
[    0.441253] pci 0000:00:1f.2: reg 20: [io  0x60e0-0x60ff]
[    0.441261] pci 0000:00:1f.2: reg 24: [mem 0xe8609000-0xe86097ff]
[    0.441307] pci 0000:00:1f.2: PME# supported from D3hot
[    0.441312] pci 0000:00:1f.2: PME# disabled
[    0.441400] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.441406] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000]
(disabled)
[    0.441412] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.441421] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.441580] pci 0000:10:00.0: reg 10: [mem 0xe8000000-0xe8001fff
64bit]
[    0.441719] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.441734] pci 0000:10:00.0: PME# disabled
[    0.441783] pci 0000:00:1c.1: PCI bridge to [bus 10-10]
[    0.441788] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000]
(disabled)
[    0.441794] pci 0000:00:1c.1:   bridge window [mem
0xe8000000-0xe80fffff]
[    0.441803] pci 0000:00:1c.1:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.441867] pci 0000:00:1c.4: PCI bridge to [bus 28-28]
[    0.441873] pci 0000:00:1c.4:   bridge window [io  0x4000-0x5fff]
[    0.441878] pci 0000:00:1c.4:   bridge window [mem
0xe4000000-0xe7ffffff]
[    0.441887] pci 0000:00:1c.4:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.442009] pci 0000:30:00.0: reg 10: [mem 0xe0000000-0xe0003fff
64bit]
[    0.442021] pci 0000:30:00.0: reg 18: [io  0x2000-0x20ff]
[    0.442114] pci 0000:30:00.0: supports D1 D2
[    0.442116] pci 0000:30:00.0: PME# supported from D0 D1 D2 D3hot
D3cold
[    0.442123] pci 0000:30:00.0: PME# disabled
[    0.442157] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.442162] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.442167] pci 0000:00:1c.5:   bridge window [mem
0xe0000000-0xe00fffff]
[    0.442176] pci 0000:00:1c.5:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.442280] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive
decode)
[    0.442286] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000]
(disabled)
[    0.442292] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
[    0.442300] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.442303] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.442306] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.442309] pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.442311] pci 0000:00:1e.0:   bridge window [mem
0x7f800000-0xfedfffff] (subtractive decode)
[    0.442314] pci 0000:00:1e.0:   bridge window [mem
0xfee01000-0xffffffff] (subtractive decode)
[    0.442317] pci 0000:00:1e.0:   bridge window [mem
0x000d4000-0x000dffff] (subtractive decode)
[    0.442357] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.442631] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B6._PRT]
[    0.442753] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C125._PRT]
[    0.442830] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C139._PRT]
[    0.442915] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C13C._PRT]
[    0.443039] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C13D._PRT]
[    0.484631] ACPI: PCI Interrupt Link [C135] (IRQs *10 11)
[    0.484849] ACPI: PCI Interrupt Link [C136] (IRQs *10 11)
[    0.485064] ACPI: PCI Interrupt Link [C137] (IRQs 10 *11)
[    0.485268] ACPI: PCI Interrupt Link [C138] (IRQs 10 11) *0,
disabled.
[    0.485479] ACPI: PCI Interrupt Link [C148] (IRQs *10 11)
[    0.485690] ACPI: PCI Interrupt Link [C149] (IRQs *10 11)
[    0.485895] ACPI: PCI Interrupt Link [C14A] (IRQs 10 11) *0,
disabled.
[    0.485993] ACPI Exception: AE_NOT_FOUND, Evaluating _PRS
(20100428/pci_link-185)
[    0.486103] HEST: Table is not found!
[    0.486203] vgaarb: device added: PCI:0000:00:02.0,decodes=io
+mem,owns=io+mem,locks=none
[    0.486219] vgaarb: loaded
[    0.486392] SCSI subsystem initialized
[    0.486507] libata version 3.00 loaded.
[    0.486561] usbcore: registered new interface driver usbfs
[    0.486574] usbcore: registered new interface driver hub
[    0.486604] usbcore: registered new device driver usb
[    0.487044] ACPI: WMI: Mapper loaded
[    0.487047] PCI: Using ACPI for IRQ routing
[    0.487050] PCI: pci_cache_line_size set to 64 bytes
[    0.487207] Expanded resource reserved due to conflict with PCI Bus
0000:00
[    0.487211] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.487214] reserve RAM buffer: 000000007f7b0000 - 000000007fffffff 
[    0.487313] NetLabel: Initializing
[    0.487315] NetLabel:  domain hash size = 128
[    0.487317] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.487335] NetLabel:  unlabeled traffic allowed by default
[    0.487371] HPET: 3 timers in total, 0 timers will be used for
per-cpu timer
[    0.487378] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.487383] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.490138] Switching to clocksource tsc
[    0.500964] AppArmor: AppArmor Filesystem Enabled
[    0.500988] pnp: PnP ACPI init
[    0.501011] ACPI: bus type pnp registered
[    0.510180] pnp: PnP ACPI: found 12 devices
[    0.510183] ACPI: ACPI bus type pnp unregistered
[    0.510198] system 00:00: [mem 0x00000000-0x0009ffff] could not be
reserved
[    0.510202] system 00:00: [mem 0x000e0000-0x000fffff] could not be
reserved
[    0.510205] system 00:00: [mem 0x00100000-0x7f7fffff] could not be
reserved
[    0.510215] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.510218] system 00:09: [io  0x0800-0x080f] has been reserved
[    0.510221] system 00:09: [mem 0xffb00000-0xffbfffff] has been
reserved
[    0.510224] system 00:09: [mem 0xfff00000-0xffffffff] has been
reserved
[    0.510230] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.510233] system 00:0a: [io  0x1000-0x107f] has been reserved
[    0.510235] system 00:0a: [io  0x1100-0x113f] has been reserved
[    0.510238] system 00:0a: [io  0x1200-0x121f] has been reserved
[    0.510241] system 00:0a: [mem 0xf8000000-0xfbffffff] has been
reserved
[    0.510244] system 00:0a: [mem 0xfec00000-0xfec000ff] could not be
reserved
[    0.510247] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been
reserved
[    0.510250] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been
reserved
[    0.510253] system 00:0a: [mem 0xfed90000-0xfed99fff] has been
reserved
[    0.510259] system 00:0b: [mem 0x000cec00-0x000cffff] has been
reserved
[    0.510262] system 00:0b: [mem 0x000d1000-0x000d3fff] has been
reserved
[    0.510265] system 00:0b: [mem 0xfeda0000-0xfedbffff] has been
reserved
[    0.510268] system 00:0b: [mem 0xfee00000-0xfee00fff] has been
reserved
[    0.516486] pci 0000:00:1c.1: BAR 15: assigned [mem
0x7f800000-0x7f9fffff 64bit pref]
[    0.516491] pci 0000:00:1c.4: BAR 15: assigned [mem
0x7fa00000-0x7fbfffff 64bit pref]
[    0.516495] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    0.516498] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.516500] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.516507] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.516512] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.516521] pci 0000:00:1c.1: PCI bridge to [bus 10-10]
[    0.516524] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.516531] pci 0000:00:1c.1:   bridge window [mem
0xe8000000-0xe80fffff]
[    0.516537] pci 0000:00:1c.1:   bridge window [mem
0x7f800000-0x7f9fffff 64bit pref]
[    0.516545] pci 0000:00:1c.4: PCI bridge to [bus 28-28]
[    0.516549] pci 0000:00:1c.4:   bridge window [io  0x4000-0x5fff]
[    0.516556] pci 0000:00:1c.4:   bridge window [mem
0xe4000000-0xe7ffffff]
[    0.516561] pci 0000:00:1c.4:   bridge window [mem
0x7fa00000-0x7fbfffff 64bit pref]
[    0.516570] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.516574] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.516581] pci 0000:00:1c.5:   bridge window [mem
0xe0000000-0xe00fffff]
[    0.516586] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    0.516594] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.516596] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.516603] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.516608] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.516631]   alloc irq_desc for 16 on node -1
[    0.516633]   alloc kstat_irqs on node -1
[    0.516642] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.516649] pci 0000:00:1c.0: setting latency timer to 64
[    0.516660]   alloc irq_desc for 17 on node -1
[    0.516662]   alloc kstat_irqs on node -1
[    0.516666] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ
17
[    0.516671] pci 0000:00:1c.1: setting latency timer to 64
[    0.516683] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    0.516688] pci 0000:00:1c.4: setting latency timer to 64
[    0.516700] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ
17
[    0.516705] pci 0000:00:1c.5: setting latency timer to 64
[    0.516715] pci 0000:00:1e.0: setting latency timer to 64
[    0.516721] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.516723] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.516726] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.516728] pci_bus 0000:00: resource 7 [mem 0x7f800000-0xfedfffff]
[    0.516730] pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
[    0.516733] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000dffff]
[    0.516735] pci_bus 0000:10: resource 0 [io  0x3000-0x3fff]
[    0.516738] pci_bus 0000:10: resource 1 [mem 0xe8000000-0xe80fffff]
[    0.516740] pci_bus 0000:10: resource 2 [mem 0x7f800000-0x7f9fffff
64bit pref]
[    0.516743] pci_bus 0000:28: resource 0 [io  0x4000-0x5fff]
[    0.516745] pci_bus 0000:28: resource 1 [mem 0xe4000000-0xe7ffffff]
[    0.516748] pci_bus 0000:28: resource 2 [mem 0x7fa00000-0x7fbfffff
64bit pref]
[    0.516751] pci_bus 0000:30: resource 0 [io  0x2000-0x2fff]
[    0.516753] pci_bus 0000:30: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.516755] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.516758] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.516760] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.516762] pci_bus 0000:02: resource 7 [mem 0x7f800000-0xfedfffff]
[    0.516765] pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
[    0.516767] pci_bus 0000:02: resource 9 [mem 0x000d4000-0x000dffff]
[    0.516813] NET: Registered protocol family 2
[    0.516952] IP route cache hash table entries: 65536 (order: 7,
524288 bytes)
[    0.517864] TCP established hash table entries: 262144 (order: 10,
4194304 bytes)
[    0.520728] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes)
[    0.521413] TCP: Hash tables configured (established 262144 bind
65536)
[    0.521416] TCP reno registered
[    0.521427] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.521454] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.521618] NET: Registered protocol family 1
[    0.521640] pci 0000:00:02.0: Boot video device
[    0.521821] PCI: CLS 64 bytes, default 64
[    0.522067] Scanning for low memory corruption every 60 seconds
[    0.522275] audit: initializing netlink socket (disabled)
[    0.522288] type=2000 audit(1286282532.510:1): initialized
[    0.537727] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.539279] VFS: Disk quotas dquot_6.5.2
[    0.539340] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.539974] fuse init (API version 7.14)
[    0.540064] msgmni has been set to 3974
[    0.540357] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    0.540361] io scheduler noop registered
[    0.540363] io scheduler deadline registered
[    0.540403] io scheduler cfq registered (default)
[    0.540521] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.540576]   alloc irq_desc for 40 on node -1
[    0.540578]   alloc kstat_irqs on node -1
[    0.540593] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.540693] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.540741]   alloc irq_desc for 41 on node -1
[    0.540743]   alloc kstat_irqs on node -1
[    0.540752] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.540858] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.540907]   alloc irq_desc for 42 on node -1
[    0.540909]   alloc kstat_irqs on node -1
[    0.540918] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    0.541020] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.541068]   alloc irq_desc for 43 on node -1
[    0.541070]   alloc kstat_irqs on node -1
[    0.541080] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    0.541187] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.541265] pciehp: PCI Express Hot Plug Controller Driver version:
0.4
[    0.541362] intel_idle: MWAIT substates: 0x22220
[    0.541364] intel_idle: does not run on family 6 model 15
[    0.545835] ACPI: AC Adapter [C244] (on-line)
[    0.545932] input: Sleep Button
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.545938] ACPI: Sleep Button [C2BE]
[    0.545983] input: Lid Switch
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.546051] ACPI: Lid Switch [C15B]
[    0.546100] input: Power Button
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.546104] ACPI: Power Button [PWRF]
[    0.546347] ACPI: Fan [C3C6] (off)
[    0.546547] ACPI: Fan [C3C7] (off)
[    0.546741] ACPI: Fan [C3C8] (off)
[    0.546936] ACPI: Fan [C3C9] (off)
[    0.547135] ACPI: Fan [C3CA] (off)
[    0.547395] ACPI: acpi_idle registered with cpuidle
[    0.549605] Monitor-Mwait will be used to enter C-1 state
[    0.549638] Monitor-Mwait will be used to enter C-2 state
[    0.549661] Monitor-Mwait will be used to enter C-3 state
[    0.549667] Marking TSC unstable due to TSC halts in idle
[    0.550065] Switching to clocksource hpet
[    0.559557] thermal LNXTHERM:01: registered as thermal_zone0
[    0.559567] ACPI: Thermal Zone [TZ3] (45 C)
[    0.569962] thermal LNXTHERM:02: registered as thermal_zone1
[    0.569976] ACPI: Thermal Zone [TZ4] (28 C)
[    0.573659] thermal LNXTHERM:03: registered as thermal_zone2
[    0.573668] ACPI: Thermal Zone [TZ5] (45 C)
[    0.589107] Freeing initrd memory: 10748k freed
[    0.590965] thermal LNXTHERM:04: registered as thermal_zone3
[    0.590996] ACPI: Thermal Zone [TZ0] (53 C)
[    0.595895] thermal LNXTHERM:05: registered as thermal_zone4
[    0.595933] ACPI: Thermal Zone [TZ1] (52 C)
[    0.596289] ERST: Table is not found!
[    0.596873] Linux agpgart interface v0.103
[    0.596907] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.598433] brd: module loaded
[    0.598977] loop: module loaded
[    0.599176] ata_piix 0000:00:1f.1: version 2.13
[    0.599192] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    0.599240] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.599339] scsi0 : ata_piix
[    0.599425] scsi1 : ata_piix
[    0.599960] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0
irq 14
[    0.599963] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8
irq 15
[    0.600065] ata2: port disabled. ignoring.
[    0.600285] Fixed MDIO Bus: probed
[    0.600317] PPP generic driver version 2.4.2
[    0.600359] tun: Universal TUN/TAP device driver, 1.6
[    0.600361] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.600442] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    0.600463]   alloc irq_desc for 18 on node -1
[    0.600466]   alloc kstat_irqs on node -1
[    0.600475] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    0.600490] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.600494] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.600531] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    0.600567] ehci_hcd 0000:00:1a.7: debug port 1
[    0.604455] ehci_hcd 0000:00:1a.7: cache line size of 64 is not
supported
[    0.604473] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8600000
[    0.622518] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.622672] hub 1-0:1.0: USB hub found
[    0.622678] hub 1-0:1.0: 4 ports detected
[    0.622753]   alloc irq_desc for 20 on node -1
[    0.622755]   alloc kstat_irqs on node -1
[    0.622760] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low)
-> IRQ 20
[    0.622773] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.622777] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.622817] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    0.622853] ehci_hcd 0000:00:1d.7: debug port 1
[    0.626732] ehci_hcd 0000:00:1d.7: cache line size of 64 is not
supported
[    0.626747] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8608000
[    0.638253] ACPI: Battery Slot [C245] (battery present)
[    0.652514] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.652612] hub 2-0:1.0: USB hub found
[    0.652617] hub 2-0:1.0: 6 ports detected
[    0.652692] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.652706] uhci_hcd: USB Universal Host Controller Interface driver
[    0.652760] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    0.652767] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.652771] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.652807] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    0.652846] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00006020
[    0.652973] hub 3-0:1.0: USB hub found
[    0.652978] hub 3-0:1.0: 2 ports detected
[    0.653046] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low)
-> IRQ 20
[    0.653053] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.653056] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.653089] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[    0.653118] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006040
[    0.653236] hub 4-0:1.0: USB hub found
[    0.653240] hub 4-0:1.0: 2 ports detected
[    0.653304]   alloc irq_desc for 21 on node -1
[    0.653306]   alloc kstat_irqs on node -1
[    0.653311] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low)
-> IRQ 21
[    0.653318] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.653321] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.653354] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 5
[    0.653392] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006060
[    0.653514] hub 5-0:1.0: USB hub found
[    0.653520] hub 5-0:1.0: 2 ports detected
[    0.653581] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    0.653587] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.653591] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.653626] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 6
[    0.653655] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006080
[    0.653772] hub 6-0:1.0: USB hub found
[    0.653776] hub 6-0:1.0: 2 ports detected
[    0.653896] PNP: PS/2 Controller [PNP0303:C2A2,PNP0f13:C2A3] at
0x60,0x64 irq 1,12
[    0.655477] i8042.c: Detected active multiplexing controller, rev
1.1.
[    0.656194] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.656201] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.656204] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.656207] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.656210] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.656282] mice: PS/2 mouse device common for all mice
[    0.656411] rtc_cmos 00:05: RTC can wake from S4
[    0.656449] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.656482] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet
irqs
[    0.656584] device-mapper: uevent: version 1.0.3
[    0.656675] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05)
initialised: dm-devel@redhat.com
[    0.656767] device-mapper: multipath: version 1.1.1 loaded
[    0.656770] device-mapper: multipath round-robin: version 1.0.0
loaded
[    0.657037] cpuidle: using governor ladder
[    0.657137] cpuidle: using governor menu
[    0.657423] TCP cubic registered
[    0.657555] NET: Registered protocol family 10
[    0.657907] lo: Disabled Privacy Extensions
[    0.658114] NET: Registered protocol family 17
[    0.658905] PM: Resume from disk failed.
[    0.658917] registered taskstats version 1
[    0.659243]   Magic number: 14:355:733
[    0.659266] hwmon hwmon0: hash matches
[    0.659388] rtc_cmos 00:05: setting system clock to 2010-10-05
12:42:13 UTC (1286282533)
[    0.659391] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.659393] EDD information not available.
[    0.678012] input: AT Translated Set 2 keyboard
as /devices/platform/i8042/serio0/input/input3
[    0.772218] Freeing unused kernel memory: 908k freed
[    0.772598] Write protecting the kernel read-only data: 10240k
[    0.772837] Freeing unused kernel memory: 416k freed
[    0.773168] Freeing unused kernel memory: 1644k freed
[    0.790844] udev[85]: starting version 163
[    0.863370] sky2: driver version 1.28
[    0.863439] sky2 0000:30:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[    0.863459] sky2 0000:30:00.0: setting latency timer to 64
[    0.863506] sky2 0000:30:00.0: Yukon-2 FE+ chip revision 0
[    0.863624]   alloc irq_desc for 44 on node -1
[    0.863627]   alloc kstat_irqs on node -1
[    0.863647] sky2 0000:30:00.0: irq 44 for MSI/MSI-X
[    0.923893] sky2 0000:30:00.0: eth0: addr 18:a9:05:d5:70:8e
[    0.936144] ahci 0000:00:1f.2: version 3.0
[    0.936168] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) ->
IRQ 17
[    0.936220]   alloc irq_desc for 45 on node -1
[    0.936223]   alloc kstat_irqs on node -1
[    0.936237] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.936283] ahci: SSS flag set, parallel bus scan disabled
[    0.936319] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps
0x7 impl SATA mode
[    0.936323] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo
pio slum part ccc 
[    0.936329] ahci 0000:00:1f.2: setting latency timer to 64
[    0.953109] scsi2 : ahci
[    0.953248] scsi3 : ahci
[    0.953327] scsi4 : ahci
[    0.953428] ata3: SATA max UDMA/133 abar m2048@0xe8609000 port
0xe8609100 irq 45
[    0.953432] ata4: SATA max UDMA/133 abar m2048@0xe8609000 port
0xe8609180 irq 45
[    0.953436] ata5: SATA max UDMA/133 abar m2048@0xe8609000 port
0xe8609200 irq 45
[    1.032553] usb 2-3: new high speed USB device using ehci_hcd and
address 3
[    1.302594] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.302615] usb 2-5: new high speed USB device using ehci_hcd and
address 4
[    1.304972] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    1.304977] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.305185] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE
MODE) succeeded
[    1.305190] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    1.306214] ata3.00: ATA-8: Hitachi HTS723225L9A360, FCDOC60D, max
UDMA/100
[    1.306218] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    1.308827] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[    1.308831] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE
CONFIGURATION OVERLAY) filtered out
[    1.309042] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE
MODE) succeeded
[    1.309046] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[    1.310079] ata3.00: configured for UDMA/100
[    1.333259] ata3.00: configured for UDMA/100
[    1.333263] ata3: EH complete
[    1.333437] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72322
FCDO PQ: 0 ANSI: 5
[    1.333608] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.333693] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250
GB/232 GiB)
[    1.333749] sd 2:0:0:0: [sda] Write Protect is off
[    1.333752] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.333776] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.333919]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11
sda12 sda13 sda14 sda15 > sda3
[    1.475634] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.680090] ata4: SATA link down (SStatus 0 SControl 300)
[    1.770063] usb 4-2: new low speed USB device using uhci_hcd and
address 2
[    2.050067] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.054160] ata5.00: ATAPI: hp       DVDRAM GT20L, DC05, max UDMA/100
[    2.059042] ata5.00: configured for UDMA/100
[    2.083188] scsi 4:0:0:0: CD-ROM            hp       DVDRAM GT20L
DC05 PQ: 0 ANSI: 5
[    2.094370] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.094373] Uniform CD-ROM driver Revision: 3.20
[    2.094486] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    2.094548] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    2.099923] usbcore: registered new interface driver hiddev
[    2.114518] input: Logitech USB Mouse
as /devices/pci0000:00/0000:00:1d.0/usb4/4-2/4-2:1.0/input/input4
[    2.114646] generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID
v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:1d.0-2/input0
[    2.114670] usbcore: registered new interface driver usbhid
[    2.114673] usbhid: USB HID core driver
[    3.342307] EXT4-fs (sda14): mounted filesystem with ordered data
mode. Opts: (null)
[   12.833971] udev[417]: starting version 163
[   12.882554] Adding 2000056k swap on /dev/sda8.  Priority:-1 extents:1
across:2000056k 
[   12.895333] agpgart-intel 0000:00:00.0: Intel 965GME/GLE Chipset
[   12.896039] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   13.040321] agpgart-intel 0000:00:00.0: AGP aperture is 256M @
0xd0000000
[   13.067702] lp: driver loaded but no devices found
[   13.232963] cfg80211: Calling CRDA to update world regulatory domain
[   13.233520] Linux video capture interface: v2.00
[   13.237747] input: HP WMI hotkeys as /devices/virtual/input/input5
[   13.241336] type=1400 audit(1286275346.075:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient3" pid=720
comm="apparmor_parser"
[   13.242089] type=1400 audit(1286275346.075:3): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=720
comm="apparmor_parser"
[   13.242485] type=1400 audit(1286275346.075:4): apparmor="STATUS"
operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script"
pid=720 comm="apparmor_parser"
[   13.265289] uvcvideo: Found UVC 1.00 device CNF8243 (04f2:b159)
[   13.290538] [drm] Initialized drm 1.1.0 20060810
[   13.301397] EXT4-fs (sda14): re-mounted. Opts: errors=remount-ro
[   13.304738] cfg80211: World regulatory domain updated:
[   13.304742]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   13.304746]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[   13.304749]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[   13.304752]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[   13.304755]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[   13.304757]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[   13.308106] IR NEC protocol handler initialized
[   13.317726] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[   13.319853] em28xx #0: chip ID is em2870
[   13.329442] input: CNF8243
as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input6
[   13.329508] usbcore: registered new interface driver uvcvideo
[   13.329510] USB Video Class driver (v0.1.0)
[   13.351460] IR RC5(x) protocol handler initialized
[   13.358886] IR RC6 protocol handler initialized
[   13.361282] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   13.361289] i915 0000:00:02.0: setting latency timer to 64
[   13.399987] IR JVC protocol handler initialized
[   13.435953] IR Sony protocol handler initialized
[   13.440835]   alloc irq_desc for 46 on node -1
[   13.440838]   alloc kstat_irqs on node -1
[   13.440849] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   13.440865] [drm] set up 7M of stolen space
[   13.444045] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,
in-tree:
[   13.444047] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   13.444159] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   13.444181] iwlagn 0000:10:00.0: setting latency timer to 64
[   13.444242] iwlagn 0000:10:00.0: Detected Intel(R) WiFi Link 5100
AGN, REV=0x54
[   13.469134] iwlagn 0000:10:00.0: Tunable channels: 13 802.11bg, 24
802.11a channels
[   13.469278]   alloc irq_desc for 47 on node -1
[   13.469281]   alloc kstat_irqs on node -1
[   13.469322] iwlagn 0000:10:00.0: irq 47 for MSI/MSI-X
[   13.481776] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[   13.481787] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[   13.481797] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[   13.481807] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 10 1d 8c 49
[   13.481817] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481826] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481836] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[   13.481845] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[   13.481855] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[   13.481864] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481873] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481883] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481892] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481901] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481911] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481920] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   13.481931] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x5e2c36c0
[   13.481933] em28xx #0: EEPROM info:
[   13.481934] em28xx #0:	No audio on board.
[   13.481936] em28xx #0:	500mA max power
[   13.481938] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   13.483658] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[   13.486784] em28xx #0: found i2c device @ 0xe [???]
[   13.514825] lirc_dev: IR Remote Control driver registered, major 250 
[   13.516435] IR LIRC bridge handler initialized
[   13.549120] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.549444] [drm] initialized overlay support
[   13.559911] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   13.566035] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[   13.577784] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[   13.577878] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[   13.577965] em28xx #0: Please send an email with this log to:
[   13.578037] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[   13.578103] em28xx #0: Board eeprom hash is 0x5e2c36c0
[   13.578264] em28xx #0: Board i2c devicelist hash is 0xdba00087
[   13.578346] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[   13.578453] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   13.578547] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[   13.578751] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   13.578844] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   13.578987] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   13.579080] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   13.579211] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   13.579286] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   13.579384] em28xx #0:     card=8 -> Kworld USB2800
[   13.579466] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   13.579624] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   13.579741] em28xx #0:     card=11 -> Terratec Hybrid XS
[   13.579825] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   13.579896] em28xx #0:     card=13 -> Terratec Prodigy XS
[   13.580021] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[   13.580236] em28xx #0:     card=15 -> V-Gear PocketTV
[   13.580329] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   13.580497] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   13.580642] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   13.580743] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   13.580969] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   13.581096] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[   13.581255] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[   13.581368] em28xx #0:     card=23 -> Huaqi DLCW-130
[   13.581508] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   13.581696] em28xx #0:     card=25 -> Gadmei UTV310
[   13.581814] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   13.581961] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[   13.582080] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   13.582289] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[   13.582452] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   13.582608] em28xx #0:     card=31 -> Usbgear VD204v9
[   13.582714] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   13.582830] em28xx #0:     card=33 -> (null)
[   13.582962] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   13.583065] em28xx #0:     card=35 -> Typhoon DVD Maker
[   13.583150] em28xx #0:     card=36 -> NetGMBH Cam
[   13.583288] em28xx #0:     card=37 -> Gadmei UTV330
[   13.583404] em28xx #0:     card=38 -> Yakumo MovieMixer
[   13.583490] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   13.583714] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   13.583841] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   13.583935] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   13.584037] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   13.584167] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   13.584271] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   13.584365] em28xx #0:     card=46 -> Compro, VideoMate U3
[   13.584479] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   13.584565] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   13.584679] em28xx #0:     card=49 -> MSI DigiVox A/D
[   13.584802] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   13.584897] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   13.585060] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   13.585178] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   13.585323] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   13.585420] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   13.585520] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   13.585647] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   13.585750] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   13.585866] em28xx #0:     card=59 -> (null)
[   13.586028] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   13.586120] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   13.586276] em28xx #0:     card=62 -> Gadmei TVR200
[   13.586514] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   13.586628] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   13.586847] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   13.586995] em28xx #0:     card=66 -> Empire dual TV
[   13.587088] em28xx #0:     card=67 -> Terratec Grabby
[   13.587237] em28xx #0:     card=68 -> Terratec AV350
[   13.587368] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   13.587494] em28xx #0:     card=70 -> Evga inDtube
[   13.587596] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   13.587740] em28xx #0:     card=72 -> Gadmei UTV330+
[   13.587845] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   13.587964] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[   13.588056] em28xx #0:     card=75 -> Dikom DK300
[   13.588168] em28xx #0: v4l2 driver version 0.1.2
[   13.593037] em28xx #0: V4L2 video device registered as video1
[   13.593609] usbcore: registered new interface driver em28xx
[   13.593612] em28xx driver loaded
[   13.612128] iwlagn 0000:10:00.0: loaded firmware version 8.24.2.12
[   13.625092] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   13.860043] Skipping EDID probe due to cached edid
[   13.878514] EXT4-fs (sda15): mounted filesystem with ordered data
mode. Opts: (null)
[   13.888406] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps:
0xd04731/0xa40000/0xa0000
[   13.929888] input: SynPS/2 Synaptics TouchPad
as /devices/platform/i8042/serio4/input/input7
[   14.030959] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   14.283734] Console: switching to colour frame buffer device 170x48
[   14.286462] fb0: inteldrmfb frame buffer device
[   14.286464] drm: registered panic notifier
[   14.286467] Slow work thread pool: Starting up
[   14.286602] Slow work thread pool: Ready
[   14.289420] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index
(0x0000000000000004) is beyond end of object (20100428/exoparg2-418)
[   14.289437] ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.C003.C09E._DOD] (Node ffff88007cf30d20), AE_AML_PACKAGE_LIMIT
[   14.289475] ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD
(20100428/video-1937)
[   14.294420] acpi device:00: registered as cooling_device7
[   14.296005] input: Video Bus
as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   14.296156] ACPI: Video Device [C09E] (multi-head: yes  rom: no
post: no)
[   14.296697] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
minor 0
[   14.301973] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   14.302029] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   14.302040] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[   14.302106]   alloc irq_desc for 48 on node -1
[   14.302108]   alloc kstat_irqs on node -1
[   14.302126] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   14.302171] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.440308] input: HDA Intel Mic at Ext Front Jack
as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   14.440504] input: HDA Intel HP Out at Ext Front Jack
as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.573616] type=1400 audit(1286275347.405:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1138
comm="apparmor_parser"
[   14.574344] type=1400 audit(1286275347.405:6): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1138
comm="apparmor_parser"
[   14.574742] type=1400 audit(1286275347.405:7): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=1138
comm="apparmor_parser"
[   14.576683] type=1400 audit(1286275347.405:8): apparmor="STATUS"
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
pid=1137 comm="apparmor_parser"
[   14.581361] type=1400 audit(1286275347.415:9): apparmor="STATUS"
operation="profile_load" name="/usr/bin/evince" pid=1139
comm="apparmor_parser"
[   14.581839] sky2 0000:30:00.0: eth0: enabling interface
[   14.582191] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   14.586388] type=1400 audit(1286275347.415:10): apparmor="STATUS"
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1142
comm="apparmor_parser"
[   14.587286] type=1400 audit(1286275347.415:11): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/cupsd" pid=1142
comm="apparmor_parser"
[   14.602671] Skipping EDID probe due to cached edid
[   15.322614] Skipping EDID probe due to cached edid
[   15.782663] Skipping EDID probe due to cached edid
[   16.493726] ppdev: user-space parallel port driver
[   17.302566] Skipping EDID probe due to cached edid
[   17.663082] EXT4-fs (sda14): re-mounted. Opts:
errors=remount-ro,commit=0
[   17.666225] EXT4-fs (sda15): re-mounted. Opts: commit=0
[   17.762595] Skipping EDID probe due to cached edid
[   18.232595] Skipping EDID probe due to cached edid
[   18.690083] Skipping EDID probe due to cached edid
[   20.243487] EXT4-fs (sda14): re-mounted. Opts:
errors=remount-ro,commit=0
[   20.247039] EXT4-fs (sda15): re-mounted. Opts: commit=0
[   26.952578] Skipping EDID probe due to cached edid
[   27.410090] Skipping EDID probe due to cached edid
[   27.872586] Skipping EDID probe due to cached edid
[   28.330087] Skipping EDID probe due to cached edid
[   34.062566] Skipping EDID probe due to cached edid
[  300.434234] wlan0: authenticate with 00:24:01:56:76:ac (try 1)
[  300.436201] wlan0: authenticated
[  300.436258] wlan0: associate with 00:24:01:56:76:ac (try 1)
[  300.438814] wlan0: RX AssocResp from 00:24:01:56:76:ac (capab=0x401
status=0 aid=2)
[  300.438823] wlan0: associated
[  300.441414] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  310.500081] wlan0: no IPv6 routers present


---------------------------------------------------------
----------------------------------------------------------
---------------------------------------------------------
MY LSMOD at boot time


Module                  Size  Used by
parport_pc             30086  0 
ppdev                   6804  0 
binfmt_misc             7984  1 
snd_hda_codec_idt      64667  1 
joydev                 11363  0 
arc4                    1497  2 
ir_lirc_codec           3888  0 
lirc_dev               11209  1 ir_lirc_codec
snd_hda_intel          26019  2 
iwlagn                202721  0 
ir_sony_decoder         2381  0 
snd_hda_codec         100919  2 snd_hda_codec_idt,snd_hda_intel
snd_hwdep               6660  1 snd_hda_codec
snd_pcm                89104  2 snd_hda_intel,snd_hda_codec
ir_jvc_decoder          2442  0 
snd_seq_midi            5932  0 
snd_rawmidi            22207  1 snd_seq_midi
i915                  330089  2 
ir_rc6_decoder          3018  0 
snd_seq_midi_event      7291  1 snd_seq_midi
ir_rc5_decoder          2474  0 
iwlcore               146875  1 iwlagn
snd_seq                57512  3 snd_seq_midi,snd_seq_midi_event
em28xx                 99392  0 
ir_nec_decoder          2442  0 
drm_kms_helper         32836  1 i915
mac80211              266657  2 iwlagn,iwlcore
v4l2_common            20635  1 em28xx
snd_timer              23850  2 snd_pcm,snd_seq
uvcvideo               62379  0 
ir_core                16906  7
ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,em28xx
videobuf_vmalloc        5480  1 em28xx
snd_seq_device          6912  3 snd_seq_midi,snd_rawmidi,snd_seq
videobuf_core          20040  2 em28xx,videobuf_vmalloc
tveeprom               14098  1 em28xx
videodev               49359  3 em28xx,v4l2_common,uvcvideo
hp_wmi                  6435  0 
v4l1_compat            15519  2 uvcvideo,videodev
v4l2_compat_ioctl32    12646  1 videodev
drm                   206161  3 i915,drm_kms_helper
cfg80211              170293  3 iwlagn,iwlcore,mac80211
snd                    64117  14
snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
psmouse                62080  0 
serio_raw               4910  0 
lp                     10201  0 
i2c_algo_bit            6208  1 i915
video                  22176  1 i915
soundcore               1240  1 snd
output                  2527  1 video
snd_page_alloc          8588  2 snd_hda_intel,snd_pcm
parport                37032  3 parport_pc,ppdev,lp
intel_agp              32080  2 i915
usbhid                 42062  0 
hid                    84678  1 usbhid
ahci                   21857  0 
sky2                   53371  0 
libahci                26167  4 ahci


----------------------------------------------------------
----------------------------------------------------------
-----------------------------------------------------------

now I remove em28xx.. modprobe card=45 ,that i suppose it's my dvb-t
card...
sudo rmmod em28xx
sudo modprobe em28xx card=45
sudo modprobe em28xx-dvb


and this is the dmesg

[ 1001.706624] usbcore: deregistering interface driver em28xx
[ 1001.706644] em28xx #0: disconnecting em28xx #0 video
[ 1001.706647] em28xx #0: V4L2 device video1 deregistered
[ 1011.612824] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[ 1011.612940] em28xx #0: chip ID is em2870
[ 1011.907464] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[ 1011.907493] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[ 1011.907518] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[ 1011.907542] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 10 1d 8c 49
[ 1011.907565] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907589] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907613] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[ 1011.907637] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[ 1011.907660] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[ 1011.907684] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907707] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907731] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907754] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907777] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907801] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907824] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1011.907851] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x5e2c36c0
[ 1011.907856] em28xx #0: EEPROM info:
[ 1011.907860] em28xx #0:	No audio on board.
[ 1011.907864] em28xx #0:	500mA max power
[ 1011.907870] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 1011.908957] em28xx #0: Identified as Pinnacle PCTV DVB-T (card=45)
[ 1011.908963] em28xx #0: 
[ 1011.908965] 
[ 1011.908970] em28xx #0: The support for this board weren't valid yet.
[ 1011.908975] em28xx #0: Please send a report of having this working
[ 1011.908980] em28xx #0: not to V4L mailing list (and/or to other
addresses)
[ 1011.908983] 
[ 1011.908991] em28xx #0: v4l2 driver version 0.1.2
[ 1011.916219] em28xx #0: V4L2 video device registered as video1
[ 1011.916293] usbcore: registered new interface driver em28xx
[ 1011.916298] em28xx driver loaded
[ 1017.990096] Em28xx: Initialized (Em28xx dvb Extension) extension


and also
ubuntu:~$ w_scan -c it
w_scan version 20100316 (compiled for DVB API 5.1)
using settings for ITALY
DVB aerial
DVB-T Europe
frontend_type DVB-T, channellist 4
output format vdr-1.6
Info: using DVB adapter auto detection.
main:2930: FATAL: ***** NO USEABLE DVB CARD FOUND. *****
Please check wether dvb driver is loaded and
verify that no dvb application (i.e. vdr) is running.


kaffeine and me-tv not working...i'd like to have this card work again.
it worked one times... thanks

good work

PS:let me know if i can help test




