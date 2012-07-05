Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45241 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2GEOIf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 10:08:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SmmjK-00023b-0T
	for linux-media@vger.kernel.org; Thu, 05 Jul 2012 16:08:26 +0200
Received: from btm86.neoplus.adsl.tpnet.pl ([83.29.158.86])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 16:08:25 +0200
Received: from acc.for.news by btm86.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 16:08:25 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: pctv452e
Date: Thu, 05 Jul 2012 15:14:56 +0200
Message-ID: <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl>
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FF4931B.7000708@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maybe i did something wrong because I'm new to git, so below are steps i 
followed to compile new driver set:
1) git clone git://linuxtv.org/anttip/media_tree.git
2) git checkout -b pctv452e origin/pctv452e
3) copy config file from 3.4 kernel
4) make menuconfig, check everything seems ok, quit & save
5) build kernel Debian way, and install it, reboot

wuwek:~# uname -a
Linux wuwek 3.5.0-rc5+ #1 SMP Thu Jul 5 09:22:36 CEST 2012 i686 GNU/Linux

wuwek:~# lsusb
Bus 001 Device 002: ID 2304:021f Pinnacle Systems, Inc. PCTV Sat HDTV 
Pro BDA Device
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


wuwek:~/pctv/pctv452e/media_tree# ls /dev/dvb*
ls: nie ma dostępu do /dev/dvb*: Nie ma takiego pliku ani katalogu

So, while device is recognized, and a driver seems to recognize device, 
there is no /dev/dvb* devices, so something went wrong.

What can I do more?

Marx

Ps. I'm attaching dmesg output. The second dvb card is internal Prof 
Revolution 8000.

wuwek:~# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc5+ (root@wuwek) (gcc version 4.7.1 
(Debian 4.7.1-2) ) #1 SMP Thu Jul 5 09:22:36 CEST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ec00-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000067c91fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000067c92000-0x0000000067ce0fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000067ce1000-0x0000000067ce3fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000067ce4000-0x0000000067ce6fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000067ce7000-0x0000000067d0ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000067d10000-0x0000000067d10fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000067d11000-0x0000000067d18fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000067d19000-0x0000000067d40fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000067d41000-0x0000000067d83fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000067d84000-0x0000000067efffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed61000-0x00000000fed70fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000ffffffff] 
reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.7 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By 
O.E.M./E350M1, BIOS P1.50 11/16/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x67f00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 067F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 068000000 mask FF8000000 uncachable
[    0.000000]   3 base 070000000 mask FF0000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000fcdf0-0x000fcdff] mapped 
at [c00fcdf0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x019fffff]
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x379fdfff]
[    0.000000]  [mem 0x00000000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x377fffff] page 2M
[    0.000000]  [mem 0x37800000-0x379fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x379fdfff @ [mem 
0x019f9000-0x019fffff]
[    0.000000] RAMDISK: [mem 0x36b78000-0x375b3fff]
[    0.000000] ACPI: RSDP 000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 67cd9070 0005C (v01 ALASKA    A M I 01072009 
AMI  00010013)
[    0.000000] ACPI: FACP 67cdea90 000F4 (v04 ALASKA    A M I 01072009 
AMI  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero 
address or length: 0x0000000000000000/0x1 (20120320/tbfadt-579)
[    0.000000] ACPI: DSDT 67cd9158 05933 (v02 ALASKA    A M I 00000000 
INTL 20051117)
[    0.000000] ACPI: FACS 67d18f80 00040
[    0.000000] ACPI: APIC 67cdeb88 00062 (v03 ALASKA    A M I 01072009 
AMI  00010013)
[    0.000000] ACPI: MCFG 67cdebf0 0003C (v01 ALASKA    A M I 01072009 
MSFT 00010013)
[    0.000000] ACPI: AAFT 67cdec30 0003A (v01 ALASKA OEMAAFT  01072009 
MSFT 00000097)
[    0.000000] ACPI: HPET 67cdec70 00038 (v01 ALASKA    A M I 01072009 
AMI  00000004)
[    0.000000] ACPI: SSDT 67cdeca8 003DE (v01 AMD    POWERNOW 00000001 
AMD  00000001)
[    0.000000] ACPI: SSDT 67cdf088 0168E (v02    AMD     ALIB 00000001 
MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 773MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x379fdfff]
[    0.000000]   HighMem  [mem 0x379fe000-0x67efffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x67c91fff]
[    0.000000]   node   0: [mem 0x67d10000-0x67d10fff]
[    0.000000]   node   0: [mem 0x67d84000-0x67efffff]
[    0.000000] On node 0 totalpages: 425373
[    0.000000] free_area_init_node: node 0, pgdat c14293c0, node_mem_map 
f5e78200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1547 pages used for memmap
[    0.000000]   HighMem zone: 196102 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] e820: [mem 0x67f00000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages/cpu @f79d8000 s32960 r0 d24384 
u57344
[    0.000000] pcpu-alloc: s32960 r0 d24384 u57344 alloc=14*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 422046
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.5.0-rc5+ 
root=UUID=756a2809-5b24-4f0e-aed3-6874268ad97d ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 3405696 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000379fe:00067f00)
[    0.000000] Memory: 1668100k/1702912k available (2910k kernel code, 
33392k reserved, 1380k data, 420k init, 790596k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc1431000 - 0xc149a000   ( 420 kB)
[    0.000000]       .data : 0xc12d7bb8 - 0xc1430f00   (1380 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12d7bb8   (2910 kB)
[    0.000000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=f5806000 soft=f5808000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 1600.000 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3200.00 BogoMIPS (lpj=6400000)
[    0.000009] pid_max: default: 32768 minimum: 301
[    0.000074] Security Framework initialized
[    0.000082] AppArmor: AppArmor disabled by boot time parameter
[    0.000108] Mount-cache hash table entries: 512
[    0.000429] Initializing cgroup subsys cpuacct
[    0.000435] Initializing cgroup subsys memory
[    0.000449] Initializing cgroup subsys devices
[    0.000453] Initializing cgroup subsys freezer
[    0.000455] Initializing cgroup subsys net_cls
[    0.000459] Initializing cgroup subsys blkio
[    0.000462] Initializing cgroup subsys perf_event
[    0.000509] CPU: Physical Processor ID: 0
[    0.000512] CPU: Processor Core ID: 0
[    0.000517] mce: CPU supports 6 MCE banks
[    0.001309] ACPI: Core revision 20120320
[    0.008610] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.008975] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.048667] CPU0: AMD E-350 Processor stepping 00
[    0.154605] Performance Events: AMD PMU driver.
[    0.154613] ... version:                0
[    0.154615] ... bit width:              48
[    0.154617] ... generic registers:      4
[    0.154620] ... value mask:             0000ffffffffffff
[    0.154623] ... max period:             00007fffffffffff
[    0.154625] ... fixed-purpose events:   0
[    0.154627] ... event mask:             000000000000000f
[    0.154880] NMI watchdog: enabled on all CPUs, permanently consumes 
one hw-PMU counter.
[    0.155077] CPU 1 irqstacks, hard=f5892000 soft=f5894000
[    0.155080] Booting Node   0, Processors  #1 Ok.
[    0.165063] Initializing CPU#1
[    0.168214] Brought up 2 CPUs
[    0.168220] Total of 2 processors activated (6400.00 BogoMIPS).
[    0.169107] devtmpfs: initialized
[    0.169486] PM: Registering ACPI NVS region [mem 
0x67c92000-0x67ce0fff] (323584 bytes)
[    0.169507] PM: Registering ACPI NVS region [mem 
0x67ce4000-0x67ce6fff] (12288 bytes)
[    0.169511] PM: Registering ACPI NVS region [mem 
0x67d11000-0x67d18fff] (32768 bytes)
[    0.169515] PM: Registering ACPI NVS region [mem 
0x67d41000-0x67d83fff] (274432 bytes)
[    0.169719] dummy:
[    0.169833] NET: Registered protocol family 16
[    0.170138] ACPI: bus type pci registered
[    0.170261] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.170266] PCI: not using MMCONFIG
[    0.178944] PCI: Using configuration type 1 for base access
[    0.178946] PCI: Using configuration type 1 for extended access
[    0.180066] bio: create slab <bio-0> at 0
[    0.180231] ACPI: Added _OSI(Module Device)
[    0.180237] ACPI: Added _OSI(Processor Device)
[    0.180240] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.180244] ACPI: Added _OSI(Processor Aggregator Device)
[    0.181630] ACPI: EC: Look up EC in DSDT
[    0.183429] ACPI: Executed 3 blocks of module-level executable AML code
[    0.187789] ACPI: Interpreter enabled
[    0.187803] ACPI: (supports S0 S4 S5)
[    0.187839] ACPI: Using IOAPIC for interrupt routing
[    0.188141] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.188238] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in 
ACPI motherboard resources
[    0.188242] PCI: Using MMCONFIG for extended config space
[    0.197307] ACPI: No dock devices found.
[    0.197319] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.197591] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.198043] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.198049] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.198055] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.198060] pci_root PNP0A08:00: host bridge window [mem 
0x000c8000-0x000dffff]
[    0.198065] pci_root PNP0A08:00: host bridge window [mem 
0x80000000-0xffffffff]
[    0.198076] pci_root PNP0A08:00: ignoring host bridge window [mem 
0x000c8000-0x000dffff] (conflicts with Video ROM [mem 
0x000c0000-0x000ce1ff])
[    0.198139] PCI host bridge to bus 0000:00
[    0.198145] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.198150] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.198156] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff]
[    0.198161] pci_bus 0000:00: root bus resource [mem 
0x80000000-0xffffffff]
[    0.198179] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    0.198243] pci 0000:00:01.0: [1002:9802] type 00 class 0x030000
[    0.198260] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.198272] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.198283] pci 0000:00:01.0: reg 18: [mem 0xfea00000-0xfea3ffff]
[    0.198352] pci 0000:00:01.0: supports D1 D2
[    0.198379] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    0.198393] pci 0000:00:01.1: reg 10: [mem 0xfea44000-0xfea47fff]
[    0.198471] pci 0000:00:01.1: supports D1 D2
[    0.198522] pci 0000:00:04.0: [1022:1512] type 01 class 0x060400
[    0.198614] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.198682] pci 0000:00:11.0: [1002:4390] type 00 class 0x01018f
[    0.198708] pci 0000:00:11.0: reg 10: [io  0xf190-0xf197]
[    0.198723] pci 0000:00:11.0: reg 14: [io  0xf180-0xf183]
[    0.198737] pci 0000:00:11.0: reg 18: [io  0xf170-0xf177]
[    0.198752] pci 0000:00:11.0: reg 1c: [io  0xf160-0xf163]
[    0.198766] pci 0000:00:11.0: reg 20: [io  0xf150-0xf15f]
[    0.198781] pci 0000:00:11.0: reg 24: [mem 0xfea4f000-0xfea4f3ff]
[    0.198809] pci 0000:00:11.0: set SATA to AHCI mode
[    0.198876] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.198895] pci 0000:00:12.0: reg 10: [mem 0xfea4e000-0xfea4efff]
[    0.198988] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.199014] pci 0000:00:12.2: reg 10: [mem 0xfea4d000-0xfea4d0ff]
[    0.199117] pci 0000:00:12.2: supports D1 D2
[    0.199121] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.199157] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.199177] pci 0000:00:13.0: reg 10: [mem 0xfea4c000-0xfea4cfff]
[    0.199269] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.199295] pci 0000:00:13.2: reg 10: [mem 0xfea4b000-0xfea4b0ff]
[    0.199398] pci 0000:00:13.2: supports D1 D2
[    0.199402] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.199436] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.199532] pci 0000:00:14.1: [1002:439c] type 00 class 0x01018a
[    0.199551] pci 0000:00:14.1: reg 10: [io  0xf140-0xf147]
[    0.199566] pci 0000:00:14.1: reg 14: [io  0xf130-0xf133]
[    0.199580] pci 0000:00:14.1: reg 18: [io  0xf120-0xf127]
[    0.199594] pci 0000:00:14.1: reg 1c: [io  0xf110-0xf113]
[    0.199608] pci 0000:00:14.1: reg 20: [io  0xf100-0xf10f]
[    0.199663] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.199691] pci 0000:00:14.2: reg 10: [mem 0xfea40000-0xfea43fff 64bit]
[    0.199776] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.199799] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.199897] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.199955] pci 0000:00:14.5: [1002:4399] type 00 class 0x0c0310
[    0.199973] pci 0000:00:14.5: reg 10: [mem 0xfea4a000-0xfea4afff]
[    0.200068] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    0.200168] pci 0000:00:15.0: supports D1 D2
[    0.200205] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    0.200304] pci 0000:00:15.1: supports D1 D2
[    0.200346] pci 0000:00:16.0: [1002:4397] type 00 class 0x0c0310
[    0.200366] pci 0000:00:16.0: reg 10: [mem 0xfea49000-0xfea49fff]
[    0.200458] pci 0000:00:16.2: [1002:4396] type 00 class 0x0c0320
[    0.200484] pci 0000:00:16.2: reg 10: [mem 0xfea48000-0xfea480ff]
[    0.200587] pci 0000:00:16.2: supports D1 D2
[    0.200591] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.200627] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    0.200680] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    0.200732] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    0.200782] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    0.200844] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    0.200892] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    0.200940] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    0.200987] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    0.201124] pci 0000:01:00.0: [14f1:8852] type 00 class 0x040000
[    0.201156] pci 0000:01:00.0: reg 10: [mem 0xfe800000-0xfe9fffff 64bit]
[    0.201306] pci 0000:01:00.0: supports D1 D2
[    0.201310] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot
[    0.201341] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device. 
  You can enable it with 'pcie_aspm=force'
[    0.201357] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.201369] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.201462] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive 
decode)
[    0.201475] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.201481] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.201486] pci 0000:00:14.4:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    0.201491] pci 0000:00:14.4:   bridge window [mem 
0x80000000-0xffffffff] (subtractive decode)
[    0.201557] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.201658] pci 0000:04:00.0: [10ec:8168] type 00 class 0x020000
[    0.201682] pci 0000:04:00.0: reg 10: [io  0xe000-0xe0ff]
[    0.201721] pci 0000:04:00.0: reg 18: [mem 0xd0004000-0xd0004fff 
64bit pref]
[    0.201747] pci 0000:04:00.0: reg 20: [mem 0xd0000000-0xd0003fff 
64bit pref]
[    0.201846] pci 0000:04:00.0: supports D1 D2
[    0.201850] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.206647] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.206664] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.206684] pci 0000:00:15.1:   bridge window [mem 
0xd0000000-0xd00fffff 64bit pref]
[    0.206723] pci_bus 0000:00: on NUMA node 0
[    0.206736] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.207018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.207084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.207158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.207223]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.207230]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), 
returned control mask: 0x1d
[    0.207232] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.219509] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11 14 15) *0
[    0.219671] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11 14 15) *0
[    0.219835] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11 14 15) *0
[    0.219999] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11 14 15) *0
[    0.220135] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11 14 15) *0
[    0.220233] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11 14 15) *0
[    0.220331] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11 14 15) *0
[    0.220429] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11 14 15) *0
[    0.220653] vgaarb: device added: 
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.220674] vgaarb: loaded
[    0.220677] vgaarb: bridge control possible 0000:00:01.0
[    0.220741] PCI: Using ACPI for IRQ routing
[    0.230601] PCI: pci_cache_line_size set to 64 bytes
[    0.230741] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.230746] e820: reserve RAM buffer [mem 0x67c92000-0x67ffffff]
[    0.230752] e820: reserve RAM buffer [mem 0x67d11000-0x67ffffff]
[    0.230757] e820: reserve RAM buffer [mem 0x67f00000-0x67ffffff]
[    0.231006] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.231015] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.233049] Switching to clocksource hpet
[    0.235835] pnp: PnP ACPI init
[    0.235872] ACPI: bus type pnp registered
[    0.236213] pnp 00:00: [bus 00-ff]
[    0.236220] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.236225] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.236229] pnp 00:00: [io  0x0d00-0xffff window]
[    0.236234] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.236239] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.236244] pnp 00:00: [mem 0x80000000-0xffffffff window]
[    0.236248] pnp 00:00: [mem 0x00000000 window]
[    0.236343] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 
(active)
[    0.236417] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.236513] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.236521] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.237021] pnp 00:02: [io  0x040b]
[    0.237026] pnp 00:02: [io  0x04d6]
[    0.237030] pnp 00:02: [io  0x0c00-0x0c01]
[    0.237034] pnp 00:02: [io  0x0c14]
[    0.237038] pnp 00:02: [io  0x0c50-0x0c51]
[    0.237041] pnp 00:02: [io  0x0c52]
[    0.237045] pnp 00:02: [io  0x0c6c]
[    0.237049] pnp 00:02: [io  0x0c6f]
[    0.237052] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.237056] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.237060] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.237064] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.237067] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.237071] pnp 00:02: [io  0x0800-0x089f]
[    0.237119] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.237123] pnp 00:02: [io  0x0000-0x000f]
[    0.237128] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.237132] pnp 00:02: [io  0x0900-0x090f]
[    0.237136] pnp 00:02: [io  0x0910-0x091f]
[    0.237140] pnp 00:02: [io  0xfe00-0xfefe]
[    0.237144] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.237148] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.237152] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.237156] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.237160] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.237164] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.237168] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.237172] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.237176] pnp 00:02: [mem 0xffc00000-0xffffffff]
[    0.237315] system 00:02: [io  0x040b] has been reserved
[    0.237321] system 00:02: [io  0x04d6] has been reserved
[    0.237326] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.237331] system 00:02: [io  0x0c14] has been reserved
[    0.237337] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.237342] system 00:02: [io  0x0c52] has been reserved
[    0.237346] system 00:02: [io  0x0c6c] has been reserved
[    0.237351] system 00:02: [io  0x0c6f] has been reserved
[    0.237356] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.237361] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.237369] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.237374] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.237379] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.237384] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.237390] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.237395] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.237401] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.237407] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.237414] system 00:02: [mem 0xfec00000-0xfec00fff] could not be 
reserved
[    0.237420] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.237425] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.237431] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.237436] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.237442] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.237447] system 00:02: [mem 0xffc00000-0xffffffff] has been reserved
[    0.237453] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.237584] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.237589] pnp 00:03: [io  0x0290-0x029f]
[    0.237594] pnp 00:03: [io  0x0000-0xffffffffffffffff disabled]
[    0.237673] system 00:03: [io  0x0290-0x029f] has been reserved
[    0.237680] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.237894] pnp 00:04: [dma 4]
[    0.237899] pnp 00:04: [io  0x0000-0x000f]
[    0.237903] pnp 00:04: [io  0x0081-0x0083]
[    0.237907] pnp 00:04: [io  0x0087]
[    0.237911] pnp 00:04: [io  0x0089-0x008b]
[    0.237914] pnp 00:04: [io  0x008f]
[    0.237918] pnp 00:04: [io  0x00c0-0x00df]
[    0.237967] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.237991] pnp 00:05: [io  0x0070-0x0071]
[    0.238022] pnp 00:05: [irq 8]
[    0.238069] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.238087] pnp 00:06: [io  0x0061]
[    0.238136] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.238188] pnp 00:07: [io  0x0010-0x001f]
[    0.238192] pnp 00:07: [io  0x0022-0x003f]
[    0.238196] pnp 00:07: [io  0x0044-0x005f]
[    0.238200] pnp 00:07: [io  0x0072-0x007f]
[    0.238204] pnp 00:07: [io  0x0080]
[    0.238208] pnp 00:07: [io  0x0084-0x0086]
[    0.238211] pnp 00:07: [io  0x0088]
[    0.238215] pnp 00:07: [io  0x008c-0x008e]
[    0.238219] pnp 00:07: [io  0x0090-0x009f]
[    0.238222] pnp 00:07: [io  0x00a2-0x00bf]
[    0.238226] pnp 00:07: [io  0x00e0-0x00ef]
[    0.238230] pnp 00:07: [io  0x04d0-0x04d1]
[    0.238329] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.238335] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.238355] pnp 00:08: [io  0x00f0-0x00ff]
[    0.238377] pnp 00:08: [irq 13]
[    0.238426] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.238530] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.239633] pnp 00:0a: [mem 0x68000000-0x7fffffff]
[    0.239723] system 00:0a: [mem 0x68000000-0x7fffffff] has been reserved
[    0.239730] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.240010] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.240080] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.240088] pnp: PnP ACPI: found 12 devices
[    0.240091] ACPI: ACPI bus type pnp unregistered
[    0.240096] PnPBIOS: Disabled by ACPI PNP
[    0.278840] pci 0000:00:04.0: bridge window [io  0x1000-0x0fff] to 
[bus 01-01] add_size 1000
[    0.278851] pci 0000:00:04.0: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 01-01] add_size 200000
[    0.278900] pci 0000:00:04.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] get_res_add_size add_size 200000
[    0.278906] pci 0000:00:04.0: res[13]=[io  0x1000-0x0fff] 
get_res_add_size add_size 1000
[    0.278918] pci 0000:00:04.0: BAR 15: assigned [mem 
0x80000000-0x801fffff 64bit pref]
[    0.278928] pci 0000:00:04.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.278935] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.278941] pci 0000:00:04.0:   bridge window [io  0x1000-0x1fff]
[    0.278949] pci 0000:00:04.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.278956] pci 0000:00:04.0:   bridge window [mem 
0x80000000-0x801fffff 64bit pref]
[    0.278964] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.278995] pci 0000:00:15.0: PCI bridge to [bus 03-03]
[    0.279010] pci 0000:00:15.1: PCI bridge to [bus 04-04]
[    0.279016] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.279027] pci 0000:00:15.1:   bridge window [mem 
0xd0000000-0xd00fffff 64bit pref]
[    0.279080] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.279085] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.279091] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279096] pci_bus 0000:00: resource 7 [mem 0x80000000-0xffffffff]
[    0.279101] pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
[    0.279105] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
[    0.279110] pci_bus 0000:01: resource 2 [mem 0x80000000-0x801fffff 
64bit pref]
[    0.279115] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.279119] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.279125] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.279129] pci_bus 0000:02: resource 7 [mem 0x80000000-0xffffffff]
[    0.279134] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.279139] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd00fffff 
64bit pref]
[    0.279250] NET: Registered protocol family 2
[    0.279364] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.279658] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.280245] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.280569] TCP: Hash tables configured (established 131072 bind 65536)
[    0.280573] TCP: reno registered
[    0.280580] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.280594] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.280781] NET: Registered protocol family 1
[    0.280814] pci 0000:00:01.0: Boot video device
[    0.281159] PCI: CLS 64 bytes, default 64
[    0.281259] Unpacking initramfs...
[    0.753938] Freeing initrd memory: 10480k freed
[    0.760999] LVT offset 0 assigned for vector 0x400
[    0.761061] perf: AMD IBS detected (0x000000ff)
[    0.761453] audit: initializing netlink socket (disabled)
[    0.761476] type=2000 audit(1341493677.656:1): initialized
[    0.784993] highmem bounce pool size: 64 pages
[    0.785002] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.785683] VFS: Disk quotas dquot_6.5.2
[    0.785735] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.785881] msgmni has been set to 1734
[    0.786218] alg: No test for stdrng (krng)
[    0.786269] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 252)
[    0.786274] io scheduler noop registered
[    0.786277] io scheduler deadline registered
[    0.786303] io scheduler cfq registered (default)
[    0.786654] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.786694] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.786697] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.787215] GHES: HEST is not enabled!
[    0.787238] isapnp: Scanning for PnP cards...
[    1.153539] isapnp: No Plug & Play device found
[    1.153672] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.154544] Linux agpgart interface v0.103
[    1.154909] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.158114] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.158127] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.158347] mousedev: PS/2 mouse device common for all mice
[    1.158420] rtc_cmos 00:05: RTC can wake from S4
[    1.158578] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.158621] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.158637] cpuidle: using governor ladder
[    1.158640] cpuidle: using governor menu
[    1.158705] drop_monitor: Initializing network drop monitor service
[    1.158841] TCP: cubic registered
[    1.158923] NET: Registered protocol family 10
[    1.159262] mip6: Mobile IPv6
[    1.159267] NET: Registered protocol family 17
[    1.159289] Key type dns_resolver registered
[    1.159342] Using IPI No-Shortcut mode
[    1.159557] PM: Hibernation image not present or could not be loaded.
[    1.159572] registered taskstats version 1
[    1.160339] rtc_cmos 00:05: setting system clock to 2012-07-05 
13:07:58 UTC (1341493678)
[    1.160633] Freeing unused kernel memory: 420k freed
[    1.160960] Write protecting the kernel text: 2912k
[    1.161028] Write protecting the kernel read-only data: 1092k
[    1.161031] NX-protecting the kernel data: 3232k
[    1.183686] udevd[50]: starting version 175
[    1.228482] SCSI subsystem initialized
[    1.233991] ACPI: bus type usb registered
[    1.234060] usbcore: registered new interface driver usbfs
[    1.234086] usbcore: registered new interface driver hub
[    1.236163] usbcore: registered new device driver usb
[    1.236927] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.237013] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.237026] ehci_hcd 0000:00:12.2: new USB bus registered, assigned 
bus number 1
[    1.237043] ehci_hcd 0000:00:12.2: applying AMD 
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.237116] QUIRK: Enable AMD PLL fix
[    1.237135] ehci_hcd 0000:00:12.2: debug port 1
[    1.237179] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfea4d000
[    1.237261] libata version 3.00 loaded.
[    1.249310] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.249366] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.249372] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.249377] usb usb1: Product: EHCI Host Controller
[    1.249381] usb usb1: Manufacturer: Linux 3.5.0-rc5+ ehci_hcd
[    1.249385] usb usb1: SerialNumber: 0000:00:12.2
[    1.249614] hub 1-0:1.0: USB hub found
[    1.249625] hub 1-0:1.0: 5 ports detected
[    1.249874] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.249890] ehci_hcd 0000:00:13.2: new USB bus registered, assigned 
bus number 2
[    1.249903] ehci_hcd 0000:00:13.2: applying AMD 
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.249940] ehci_hcd 0000:00:13.2: debug port 1
[    1.249967] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfea4b000
[    1.261160] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.261219] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.261225] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.261230] usb usb2: Product: EHCI Host Controller
[    1.261234] usb usb2: Manufacturer: Linux 3.5.0-rc5+ ehci_hcd
[    1.261238] usb usb2: SerialNumber: 0000:00:13.2
[    1.261479] hub 2-0:1.0: USB hub found
[    1.261490] hub 2-0:1.0: 5 ports detected
[    1.261742] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    1.261756] ehci_hcd 0000:00:16.2: new USB bus registered, assigned 
bus number 3
[    1.261768] ehci_hcd 0000:00:16.2: applying AMD 
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.261807] ehci_hcd 0000:00:16.2: debug port 1
[    1.261834] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfea48000
[    1.268830] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.273137] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    1.273195] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.273200] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.273205] usb usb3: Product: EHCI Host Controller
[    1.273209] usb usb3: Manufacturer: Linux 3.5.0-rc5+ ehci_hcd
[    1.273213] usb usb3: SerialNumber: 0000:00:16.2
[    1.273463] hub 3-0:1.0: USB hub found
[    1.273473] hub 3-0:1.0: 4 ports detected
[    1.274173] ahci 0000:00:11.0: version 3.0
[    1.274390] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 6 Gbps 
0xf impl SATA mode
[    1.274397] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo 
pmp pio slum part sxs
[    1.278486] scsi0 : ahci
[    1.281214] scsi1 : ahci
[    1.284323] scsi2 : ahci
[    1.287153] scsi3 : ahci
[    1.287458] ata1: SATA max UDMA/133 abar m1024@0xfea4f000 port 
0xfea4f100 irq 19
[    1.287464] ata2: SATA max UDMA/133 abar m1024@0xfea4f000 port 
0xfea4f180 irq 19
[    1.287469] ata3: SATA max UDMA/133 abar m1024@0xfea4f000 port 
0xfea4f200 irq 19
[    1.287474] ata4: SATA max UDMA/133 abar m1024@0xfea4f000 port 
0xfea4f280 irq 19
[    1.287745] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.287760] ohci_hcd 0000:00:12.0: new USB bus registered, assigned 
bus number 4
[    1.287816] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfea4e000
[    1.345147] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.345156] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.345161] usb usb4: Product: OHCI Host Controller
[    1.345165] usb usb4: Manufacturer: Linux 3.5.0-rc5+ ohci_hcd
[    1.345170] usb usb4: SerialNumber: 0000:00:12.0
[    1.345401] hub 4-0:1.0: USB hub found
[    1.345413] hub 4-0:1.0: 5 ports detected
[    1.349634] scsi4 : pata_atiixp
[    1.353732] scsi5 : pata_atiixp
[    1.355160] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 
irq 14
[    1.355165] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 
irq 15
[    1.355345] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.355359] ohci_hcd 0000:00:13.0: new USB bus registered, assigned 
bus number 5
[    1.355399] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfea4c000
[    1.413147] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.413156] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.413161] usb usb5: Product: OHCI Host Controller
[    1.413165] usb usb5: Manufacturer: Linux 3.5.0-rc5+ ohci_hcd
[    1.413169] usb usb5: SerialNumber: 0000:00:13.0
[    1.413466] hub 5-0:1.0: USB hub found
[    1.413493] hub 5-0:1.0: 5 ports detected
[    1.414062] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.414076] ohci_hcd 0000:00:14.5: new USB bus registered, assigned 
bus number 6
[    1.414112] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfea4a000
[    1.473126] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.473133] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.473137] usb usb6: Product: OHCI Host Controller
[    1.473141] usb usb6: Manufacturer: Linux 3.5.0-rc5+ ohci_hcd
[    1.473145] usb usb6: SerialNumber: 0000:00:14.5
[    1.473421] hub 6-0:1.0: USB hub found
[    1.473447] hub 6-0:1.0: 2 ports detected
[    1.473599] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    1.473610] ohci_hcd 0000:00:16.0: new USB bus registered, assigned 
bus number 7
[    1.473638] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfea49000
[    1.535576] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.535584] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.535590] usb usb7: Product: OHCI Host Controller
[    1.535595] usb usb7: Manufacturer: Linux 3.5.0-rc5+ ohci_hcd
[    1.535599] usb usb7: SerialNumber: 0000:00:16.0
[    1.535868] hub 7-0:1.0: USB hub found
[    1.535896] hub 7-0:1.0: 4 ports detected
[    1.561146] usb 1-4: new high-speed USB device number 2 using ehci_hcd
[    1.613139] ata3: SATA link down (SStatus 0 SControl 300)
[    1.613196] ata2: SATA link down (SStatus 0 SControl 300)
[    1.613241] ata4: SATA link down (SStatus 0 SControl 300)
[    1.693910] usb 1-4: New USB device found, idVendor=2304, idProduct=021f
[    1.693920] usb 1-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    1.693928] usb 1-4: Product: PCTV452e
[    1.693936] usb 1-4: Manufacturer: Pinnacle
[    1.757131] Refined TSC clocksource calibration: 1599.999 MHz.
[    1.757148] Switching to clocksource tsc
[    1.773124] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.774246] ata1.00: ATA-8: ST3500414CS, SC13, max UDMA/133
[    1.774260] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.775521] ata1.00: configured for UDMA/133
[    1.775881] scsi 0:0:0:0: Direct-Access     ATA      ST3500414CS 
  SC13 PQ: 0 ANSI: 5
[    1.777200] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.777363] r8169 0000:04:00.0: irq 40 for MSI/MSI-X
[    1.777722] r8169 0000:04:00.0: eth0: RTL8168e/8111e at 0xf8220000, 
00:25:22:ad:f4:70, XID 0c200000 IRQ 40
[    1.777729] r8169 0000:04:00.0: eth0: jumbo features [frames: 9200 
bytes, tx checksumming: ko]
[    1.791119] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.791235] sd 0:0:0:0: [sda] Write Protect is off
[    1.791241] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.791288] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.810848]  sda: sda1 sda2 sda3 sda4
[    1.811650] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.297414] EXT4-fs (sda1): mounted filesystem with ordered data 
mode. Opts: (null)
[    4.324450] udevd[290]: starting version 175
[    4.725616] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    4.725631] ACPI: Power Button [PWRB]
[    4.725780] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.725785] ACPI: Power Button [PWRF]
[    4.840076] ACPI: acpi_idle registered with cpuidle
[    4.842386] microcode: CPU0: patch_level=0x05000028
[    4.965548] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.067007] microcode: failed to load file amd-ucode/microcode_amd.bin
[    5.067096] microcode: CPU1: patch_level=0x05000028
[    5.072193] microcode: failed to load file amd-ucode/microcode_amd.bin
[    5.072867] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.322252] kvm: Nested Virtualization enabled
[    5.322260] kvm: Nested Paging enabled
[    5.347790] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, 
revision 0
[    5.375994] Linux media interface: v0.10
[    5.396591] Linux video capture interface: v2.00
[    5.424756] powernow-k8: Found 1 AMD E-350 Processor (2 cpu cores) 
(version 2.20.00)
[    5.424835] powernow-k8:    0 : pstate 0 (1600 MHz)
[    5.424838] powernow-k8:    1 : pstate 1 (1280 MHz)
[    5.424841] powernow-k8:    2 : pstate 2 (800 MHz)
[    5.435398] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    5.435539] sp5100_tco: mmio address 0xbafe00 already in use
[    5.895514] snd_hda_intel 0000:00:01.1: irq 41 for MSI/MSI-X
[    5.930569] cx23885 driver version 0.0.3 loaded
[    5.930680] cx23885[0]: Your board isn't known (yet) to the driver.
[    5.930680] cx23885[0]: Try to pick one of the existing card configs via
[    5.930680] cx23885[0]: card=<n> insmod option.  Updating to the latest
[    5.930680] cx23885[0]: version might help as well.
[    5.930693] cx23885[0]: Here is a list of valid choices for the 
card=<n> insmod option:
[    5.930699] cx23885[0]:    card=0 -> UNKNOWN/GENERIC
[    5.930705] cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
[    5.930711] cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
[    5.930716] cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
[    5.930722] cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
[    5.930727] cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
[    5.930733] cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
[    5.930738] cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
[    5.930744] cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
[    5.930749] cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
[    5.930755] cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
[    5.930761] cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
[    5.930767] cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
[    5.930772] cx23885[0]:    card=13 -> Compro VideoMate E650F
[    5.930778] cx23885[0]:    card=14 -> TurboSight TBS 6920
[    5.930783] cx23885[0]:    card=15 -> TeVii S470
[    5.930788] cx23885[0]:    card=16 -> DVBWorld DVB-S2 2005
[    5.930794] cx23885[0]:    card=17 -> NetUP Dual DVB-S2 CI
[    5.930799] cx23885[0]:    card=18 -> Hauppauge WinTV-HVR1270
[    5.930805] cx23885[0]:    card=19 -> Hauppauge WinTV-HVR1275
[    5.930810] cx23885[0]:    card=20 -> Hauppauge WinTV-HVR1255
[    5.930816] cx23885[0]:    card=21 -> Hauppauge WinTV-HVR1210
[    5.930821] cx23885[0]:    card=22 -> Mygica X8506 DMB-TH
[    5.930826] cx23885[0]:    card=23 -> Magic-Pro ProHDTV Extreme 2
[    5.930832] cx23885[0]:    card=24 -> Hauppauge WinTV-HVR1850
[    5.930837] cx23885[0]:    card=25 -> Compro VideoMate E800
[    5.930843] cx23885[0]:    card=26 -> Hauppauge WinTV-HVR1290
[    5.930848] cx23885[0]:    card=27 -> Mygica X8558 PRO DMB-TH
[    5.930854] cx23885[0]:    card=28 -> LEADTEK WinFast PxTV1200
[    5.930859] cx23885[0]:    card=29 -> GoTView X5 3D Hybrid
[    5.930865] cx23885[0]:    card=30 -> NetUP Dual DVB-T/C-CI RF
[    5.930870] cx23885[0]:    card=31 -> Leadtek Winfast PxDVR3200 H XC4000
[    5.930875] cx23885[0]:    card=32 -> MPX-885
[    5.930881] cx23885[0]:    card=33 -> Mygica X8507
[    5.930886] cx23885[0]:    card=34 -> TerraTec Cinergy T PCIe Dual
[    5.930891] cx23885[0]:    card=35 -> TeVii S471
[    5.931609] CORE cx23885[0]: subsystem: 8000:3034, board: 
UNKNOWN/GENERIC [card=0,autodetected]
[    5.999862] input: HD-Audio Generic HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.1/sound/card0/input3
[    6.058751] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    6.058760] cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 16, 
latency: 0, mmio: 0xfe800000
[    6.088404] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input4
[    6.088613] input: HDA ATI SB Rear Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input5
[    6.088989] input: HDA ATI SB Line Out CLFE as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input6
[    6.095315] input: HDA ATI SB Line Out Surround as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input7
[    6.095942] input: HDA ATI SB Line Out Front as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input8
[    7.709547] Adding 2097148k swap on /dev/sda2.  Priority:-1 extents:1 
across:2097148k
[    7.757919] EXT4-fs (sda1): re-mounted. Opts: (null)
[    8.119681] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    8.234921] loop: module loaded
[    8.272569] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    8.376899] w83627ehf: Found NCT6775F chip at 0x290
[    8.377310] hwmon_vid: Unknown VRM version of your x86 CPU
[    9.961003] EXT4-fs (sda3): mounted filesystem with ordered data 
mode. Opts: errors=remount-ro
[   10.022057] EXT4-fs (sda4): mounted filesystem with ordered data 
mode. Opts: errors=remount-ro
[   12.929027] Netfilter messages via NETLINK v0.30.
[   13.109173] ip_set: protocol 6
[   15.010813] xt_nfacct: Unknown symbol nfnl_acct_put (err 0)
[   15.010920] xt_nfacct: Unknown symbol nfnl_acct_update (err 0)
[   15.011001] xt_nfacct: Unknown symbol nfnl_acct_find_get (err 0)
[   15.949706] xt_time: kernel timezone is +0200
[   19.925505] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.074708] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   22.039829] Bridge firewalling registered
[   22.540766] r8169 0000:04:00.0: eth6: link down
[   22.541456] IPv6: ADDRCONF(NETDEV_UP): eth6: link is not ready
[   34.451977] r8169 0000:04:00.0: eth6: link up
[   34.452479] IPv6: ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
[   37.956317] RPC: Registered named UNIX socket transport module.
[   37.956324] RPC: Registered udp transport module.
[   37.956327] RPC: Registered tcp transport module.
[   37.956330] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   38.003663] FS-Cache: Loaded
[   38.049705] NFS: Registering the id_resolver key type
[   38.049775] Key type id_resolver registered
[   38.049801] FS-Cache: Netfs 'nfs' registered for caching
[   38.065342] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   38.931600] fuse init (API version 7.19)
[   41.208657] Bluetooth: Core ver 2.16
[   41.208733] NET: Registered protocol family 31
[   41.208739] Bluetooth: HCI device and connection manager initialized
[   41.208747] Bluetooth: HCI socket layer initialized
[   41.208752] Bluetooth: L2CAP socket layer initialized
[   41.208768] Bluetooth: SCO socket layer initialized
[   41.220614] Bluetooth: RFCOMM TTY layer initialized
[   41.220632] Bluetooth: RFCOMM socket layer initialized
[   41.220638] Bluetooth: RFCOMM ver 1.11
[   41.238689] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   41.238702] Bluetooth: BNEP filters: protocol multicast


