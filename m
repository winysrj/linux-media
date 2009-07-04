Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n64EI7Ul001697
	for <video4linux-list@redhat.com>; Sat, 4 Jul 2009 10:18:07 -0400
Received: from mtah31.telenor.se (mtah31.telenor.se [213.150.131.4])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n64EHn8f009935
	for <video4linux-list@redhat.com>; Sat, 4 Jul 2009 10:17:49 -0400
Received: from iph2.telenor.se (iph2.telenor.se [195.54.127.133])
	by mtah31.telenor.se (Postfix) with ESMTP id E91E56260E
	for <video4linux-list@redhat.com>;
	Sat,  4 Jul 2009 16:07:13 +0200 (CEST)
Message-ID: <4A4F620E.6050705@home.se>
Date: Sat, 04 Jul 2009 16:07:10 +0200
From: Andreas Lunderhage <lunderhage@home.se>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Pinnacle Hybrid Stick not detected
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I have problems using my Pinnacle Hybrid Stick using the in-kernel drivers:

It looks like it can't identify it correctly. I'll attach my dmesg output.

Before, I was using the em28xx-new module written by Marcus Rechberger, 
but it looks like he got fed up in maintaining this one and it doesn't 
build on kernel 2.6.28+.

I'm running Ubuntu 32/64-bit 9.04 with all updates applied.

Any ideas?

BR

/Andreas

dmesg output:

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-13-generic (buildd@vernadsky) (gcc 
version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #45-Ubuntu SMP Tue Jun 30 
19:49:51 UTC 2009 (Ubuntu 2.6.28-13.45-generic)
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffd0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 000000007fff0c00 (reserved)
[    0.000000]  BIOS-e820: 000000007fff0c00 - 000000007fffc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fffc000 - 0000000080000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x7ffd0 max_arch_pfn = 0x100000
[    0.000000] Scanning 2 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
[    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000092c00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007ffd0000 (usable)
[    0.000000]  modified: 000000007ffd0000 - 000000007fff0c00 (reserved)
[    0.000000]  modified: 000000007fff0c00 - 000000007fffc000 (ACPI NVS)
[    0.000000]  modified: 000000007fffc000 - 0000000080000000 (reserved)
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 378bb000 - 37fef830
[    0.000000] Allocated new RAMDISK: 0087b000 - 00faf830
[    0.000000] Move RAMDISK from 00000000378bb000 - 0000000037fef82f to 
0087b000 - 00faf82f
[    0.000000] ACPI: RSDP 000F6560, 0014 (r0 COMPAQ)
[    0.000000] ACPI: RSDT 7FFF0C84, 002C (r1 HP     CPQ0860  14070520 
CPQ         1)
[    0.000000] ACPI: FACP 7FFF0C00, 0084 (r2 HP     CPQ0860         2 
CPQ         1)
[    0.000000] ACPI: DSDT 7FFF0CB0, 4F8C (r1 HP       nx7000    10000 
MSFT  100000E)
[    0.000000] ACPI: FACS 7FFFBE80, 0040
[    0.000000] ACPI: SSDT 7FFF5C3C, 028A (r1 COMPAQ  CPQGysr     1001 
MSFT  100000E)
[    0.000000] 1163MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 00000000 - 373fe000
[    0.000000]   bootmap 00012000 - 00018e80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008760ac]    TEXT DATA BSS ==> 
[0000100000 - 00008760ac]
[    0.000000]   #4 [0000877000 - 000087b000]    INIT_PG_TABLE ==> 
[0000877000 - 000087b000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> 
[0000010000 - 0000012000]
[    0.000000]   #7 [000087b000 - 0000faf830]      NEW RAMDISK ==> 
[000087b000 - 0000faf830]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> 
[0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0007ffd0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x00000007
[    0.000000]     0: 0x00000010 -> 0x00000092
[    0.000000]     0: 0x00000100 -> 0x0007ffd0
[    0.000000] On node 0 totalpages: 524117
[    0.000000] free_area_init_node: node 0, pgdat c06c9500, node_mem_map 
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3941 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2328 pages used for memmap
[    0.000000]   HighMem zone: 295610 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 0000000000007000 - 
0000000000010000
[    0.000000] PM: Registered nosave memory: 0000000000092000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:80000000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 1, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 520021
[    0.000000] Kernel command line: 
root=UUID=8e9bfc48-2439-4eab-a040-45876ce18c6a ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 1594.819 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.004000] allocated 10484800 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Memory: 2053016k/2096960k available (4110k kernel code, 
42584k reserved, 2196k data, 532k init, 1191752k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.004000]       .init : 0xc0731000 - 0xc07b6000   ( 532 kB)
[    0.004000]       .data : 0xc0503b9f - 0xc0728e60   (2196 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0503b9f   (4110 kB)
[    0.004000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[    0.004017] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 3189.63 BogoMIPS (lpj=6379276)
[    0.004045] Security Framework initialized
[    0.004062] SELinux:  Disabled at boot.
[    0.004097] AppArmor: AppArmor initialized
[    0.004108] Mount-cache hash table entries: 512
[    0.004311] Initializing cgroup subsys ns
[    0.004318] Initializing cgroup subsys cpuacct
[    0.004321] Initializing cgroup subsys memory
[    0.004327] Initializing cgroup subsys freezer
[    0.004348] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004352] CPU: L2 cache: 1024K
[    0.004372] Checking 'hlt' instruction... OK.
[    0.020827] SMP alternatives: switching to UP code
[    0.140504] Freeing SMP alternatives: 18k freed
[    0.140510] ACPI: Core revision 20080926
[    0.142799] ACPI: Checking initramfs for custom DSDT
[    0.517244] ACPI: setting ELCR to 0200 (from 0c20)
[    0.520066] weird, boot CPU (#0) not listedby the BIOS.
[    0.520069] SMP motherboard not detected.
[    0.520072] Local APIC not detected. Using dummy APIC emulation.
[    0.520074] SMP disabled
[    0.520366] Brought up 1 CPUs
[    0.520369] Total of 1 processors activated (3189.63 BogoMIPS).
[    0.520383] CPU0 attaching NULL sched-domain.
[    0.524139] net_namespace: 776 bytes
[    0.524155] Booting paravirtualized kernel on bare hardware
[    0.524445] Time:  6:39:51  Date: 07/02/09
[    0.524451] regulator: core version 0.5
[    0.524488] NET: Registered protocol family 16
[    0.524645] EISA bus registered
[    0.524663] ACPI: bus type pci registered
[    0.526058] PCI: PCI BIOS revision 2.10 entry at 0xf031f, last bus=3
[    0.526060] PCI: Using configuration type 1 for base access
[    0.527945] ACPI: EC: Look up EC in DSDT
[    0.538082] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.538293] ACPI: EC: GPE storm detected, transactions will use 
polling mode
[    0.576870] ACPI: Interpreter enabled
[    0.576877] ACPI: (supports S0 S3 S4 S5)
[    0.576897] ACPI: Using PIC for interrupt routing
[    0.599852] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.599855] ACPI: EC: driver started in interrupt mode
[    0.600032] ACPI: No dock devices found.
[    0.600042] ACPI: PCI Root Bridge [C046] (0000:00)
[    0.600090] pci 0000:00:00.0: reg 10 32bit mmio: [0xb0000000-0xbfffffff]
[    0.600194] pci 0000:00:1d.0: reg 20 io port: [0x48c0-0x48df]
[    0.600243] pci 0000:00:1d.1: reg 20 io port: [0x48e0-0x48ff]
[    0.600294] pci 0000:00:1d.2: reg 20 io port: [0x4c00-0x4c1f]
[    0.600351] pci 0000:00:1d.7: reg 10 32bit mmio: [0xa0000000-0xa00003ff]
[    0.600394] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.600400] pci 0000:00:1d.7: PME# disabled
[    0.600478] HPET not enabled in BIOS. You might try hpet=force boot 
option
[    0.600485] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 
ACPI/GPIO/TCO
[    0.600489] pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH4 
GPIO
[    0.600509] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.600516] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.600523] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.600530] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.600537] pci 0000:00:1f.1: reg 20 io port: [0x4c40-0x4c4f]
[    0.600545] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.600592] pci 0000:00:1f.3: reg 20 io port: [0x4c20-0x4c3f]
[    0.600633] pci 0000:00:1f.5: reg 10 io port: [0x4000-0x40ff]
[    0.600639] pci 0000:00:1f.5: reg 14 io port: [0x4880-0x48bf]
[    0.600646] pci 0000:00:1f.5: reg 18 32bit mmio: [0xa0200000-0xa02001ff]
[    0.600653] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xa0300000-0xa03000ff]
[    0.600675] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.600680] pci 0000:00:1f.5: PME# disabled
[    0.600708] pci 0000:00:1f.6: reg 10 io port: [0x4400-0x44ff]
[    0.600715] pci 0000:00:1f.6: reg 14 io port: [0x4800-0x487f]
[    0.600745] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.600749] pci 0000:00:1f.6: PME# disabled
[    0.600786] pci 0000:01:00.0: reg 10 32bit mmio: [0x98000000-0x9fffffff]
[    0.600792] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.600798] pci 0000:01:00.0: reg 18 32bit mmio: [0x90400000-0x9040ffff]
[    0.600813] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.600823] pci 0000:01:00.0: supports D1 D2
[    0.600858] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.600862] pci 0000:00:01.0: bridge 32bit mmio: [0x90400000-0x904fffff]
[    0.600866] pci 0000:00:01.0: bridge 32bit mmio pref: 
[0x98000000-0x9fffffff]
[    0.600900] pci 0000:02:00.0: reg 10 32bit mmio: [0x90200000-0x902007ff]
[    0.600907] pci 0000:02:00.0: reg 14 io port: [0x2400-0x247f]
[    0.600938] pci 0000:02:00.0: supports D2
[    0.600941] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    0.600945] pci 0000:02:00.0: PME# disabled
[    0.600976] pci 0000:02:01.0: reg 10 io port: [0x2000-0x20ff]
[    0.600983] pci 0000:02:01.0: reg 14 32bit mmio: [0x90300000-0x903000ff]
[    0.601014] pci 0000:02:01.0: supports D1 D2
[    0.601016] pci 0000:02:01.0: PME# supported from D1 D2 D3hot D3cold
[    0.601021] pci 0000:02:01.0: PME# disabled
[    0.601052] pci 0000:02:02.0: reg 10 32bit mmio: [0x90000000-0x90000fff]
[    0.601118] pci 0000:02:04.0: reg 10 32bit mmio: [0x90100000-0x90100fff]
[    0.601128] pci 0000:02:04.0: supports D1 D2
[    0.601130] pci 0000:02:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.601135] pci 0000:02:04.0: PME# disabled
[    0.601171] pci 0000:00:1e.0: transparent bridge
[    0.601176] pci 0000:00:1e.0: bridge io port: [0x2000-0x2fff]
[    0.601181] pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x903fffff]
[    0.601208] bus 00 -> node 0
[    0.601215] ACPI: PCI Interrupt Routing Table [\_SB_.C046._PRT]
[    0.601288] ACPI: PCI Interrupt Routing Table [\_SB_.C046.C047._PRT]
[    0.601311] ACPI: PCI Interrupt Routing Table [\_SB_.C046.C058._PRT]
[    0.612938] ACPI: PCI Interrupt Link [C0C2] (IRQs 5 *10)
[    0.613172] ACPI: PCI Interrupt Link [C0C3] (IRQs 5 *10)
[    0.613402] ACPI: PCI Interrupt Link [C0C4] (IRQs *5 10)
[    0.613632] ACPI: PCI Interrupt Link [C0C5] (IRQs *5 10)
[    0.613851] ACPI: PCI Interrupt Link [C0C6] (IRQs 5 10) *0, disabled.
[    0.614082] ACPI: PCI Interrupt Link [C0C7] (IRQs 5 10) *11
[    0.614302] ACPI: PCI Interrupt Link [C0C8] (IRQs 5 10) *0, disabled.
[    0.614537] ACPI: PCI Interrupt Link [C0C9] (IRQs *5 10)
[    0.614833] ACPI: Power Resource [C18D] (on)
[    0.615019] ACPI: Power Resource [C195] (on)
[    0.615192] ACPI: Power Resource [C19C] (on)
[    0.615237] ACPI: Power Resource [C1A6] (on)
[    0.615303] ACPI: WMI: Mapper loaded
[    0.615505] SCSI subsystem initialized
[    0.615547] libata version 3.00 loaded.
[    0.615599] usbcore: registered new interface driver usbfs
[    0.615624] usbcore: registered new interface driver hub
[    0.615653] usbcore: registered new device driver usb
[    0.615783] PCI: Using ACPI for IRQ routing
[    0.615882] Bluetooth: Core ver 2.13
[    0.615882] NET: Registered protocol family 31
[    0.615882] Bluetooth: HCI device and connection manager initialized
[    0.615882] Bluetooth: HCI socket layer initialized
[    0.615882] NET: Registered protocol family 8
[    0.615882] NET: Registered protocol family 20
[    0.615882] NetLabel: Initializing
[    0.615882] NetLabel:  domain hash size = 128
[    0.615882] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.616008] NetLabel:  unlabeled traffic allowed by default
[    0.616093] AppArmor: AppArmor Filesystem Enabled
[    0.616101] pnp: PnP ACPI init
[    0.616101] ACPI: bus type pnp registered
[    0.629018] pnp: PnP ACPI: found 15 devices
[    0.629021] ACPI: ACPI bus type pnp unregistered
[    0.629025] PnPBIOS: Disabled by ACPI PNP
[    0.629035] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.629039] system 00:00: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.629042] system 00:00: iomem range 0x100000-0x7fffffff could not 
be reserved
[    0.629054] system 00:0c: ioport range 0x140-0x14f has been reserved
[    0.629057] system 00:0c: ioport range 0x200-0x20f has been reserved
[    0.629061] system 00:0c: iomem range 0xffb00000-0xffbfffff has been 
reserved
[    0.629064] system 00:0c: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.629070] system 00:0d: ioport range 0x4d0-0x4d1 has been reserved
[    0.629074] system 00:0d: ioport range 0x1000-0x107f has been reserved
[    0.629077] system 00:0d: ioport range 0x1100-0x113f has been reserved
[    0.629080] system 00:0d: ioport range 0x1200-0x121f has been reserved
[    0.629083] system 00:0d: iomem range 0xfec00000-0xfec000ff has been 
reserved
[    0.629090] system 00:0e: iomem range 0xd5000-0xd7fff has been reserved
[    0.629093] system 00:0e: iomem range 0xfec01000-0xfec01fff has been 
reserved
[    0.663814] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.663818] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.663823] pci 0000:00:01.0:   MEM window: 0x90400000-0x904fffff
[    0.663827] pci 0000:00:01.0:   PREFETCH window: 
0x00000098000000-0x0000009fffffff
[    0.663835] pci 0000:02:04.0: CardBus bridge, secondary bus 0000:03
[    0.663838] pci 0000:02:04.0:   IO window: 0x002800-0x0028ff
[    0.663842] pci 0000:02:04.0:   IO window: 0x002c00-0x002cff
[    0.663847] pci 0000:02:04.0:   PREFETCH window: 0x88000000-0x8bffffff
[    0.663852] pci 0000:02:04.0:   MEM window: 0x94000000-0x97ffffff
[    0.663857] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.663860] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.663866] pci 0000:00:1e.0:   MEM window: 0x90000000-0x903fffff
[    0.663871] pci 0000:00:1e.0:   PREFETCH window: 
0x00000088000000-0x0000008bffffff
[    0.663888] pci 0000:00:1e.0: setting latency timer to 64
[    0.664240] ACPI: PCI Interrupt Link [C0C4] enabled at IRQ 5
[    0.664243] PCI: setting IRQ 5 as level-triggered
[    0.664248] pci 0000:02:04.0: PCI INT A -> Link[C0C4] -> GSI 5 
(level, low) -> IRQ 5
[    0.664255] bus: 00 index 0 io port: [0x00-0xffff]
[    0.664258] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.664261] bus: 01 index 0 io port: [0x3000-0x3fff]
[    0.664263] bus: 01 index 1 mmio: [0x90400000-0x904fffff]
[    0.664266] bus: 01 index 2 mmio: [0x98000000-0x9fffffff]
[    0.664269] bus: 01 index 3 mmio: [0x0-0x0]
[    0.664271] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.664274] bus: 02 index 1 mmio: [0x90000000-0x903fffff]
[    0.664277] bus: 02 index 2 mmio: [0x88000000-0x8bffffff]
[    0.664279] bus: 02 index 3 io port: [0x00-0xffff]
[    0.664282] bus: 02 index 4 mmio: [0x000000-0xffffffff]
[    0.664285] bus: 03 index 0 io port: [0x2800-0x28ff]
[    0.664287] bus: 03 index 1 io port: [0x2c00-0x2cff]
[    0.664290] bus: 03 index 2 mmio: [0x88000000-0x8bffffff]
[    0.664293] bus: 03 index 3 mmio: [0x94000000-0x97ffffff]
[    0.664303] NET: Registered protocol family 2
[    0.664442] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.664812] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.666175] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.667160] TCP: Hash tables configured (established 131072 bind 65536)
[    0.667164] TCP reno registered
[    0.667363] NET: Registered protocol family 1
[    0.667549] checking if image is initramfs... it is
[    1.164060] Switched to high resolution mode on CPU 0
[    1.445386] Freeing initrd memory: 7378k freed
[    1.445477] cpufreq: No nForce2 chipset.
[    1.445657] audit: initializing netlink socket (disabled)
[    1.445684] type=2000 audit(1246516791.444:1): initialized
[    1.455151] highmem bounce pool size: 64 pages
[    1.455160] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.456944] VFS: Disk quotas dquot_6.5.1
[    1.457021] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.457865] fuse init (API version 7.10)
[    1.457978] msgmni has been set to 1698
[    1.458210] alg: No test for stdrng (krng)
[    1.458224] io scheduler noop registered
[    1.458227] io scheduler anticipatory registered
[    1.458229] io scheduler deadline registered
[    1.458253] io scheduler cfq registered (default)
[    1.458349] pci 0000:01:00.0: Boot video device
[    1.463169] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.463183] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.463358] ACPI: AC Adapter [C134] (on-line)
[    1.546411] ACPI: Battery Slot [C11F] (battery present)
[    1.546491] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.546494] ACPI: Power Button (FF) [PWRF]
[    1.546564] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.546568] ACPI: Power Button (CM) [C1BE]
[    1.546618] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    1.546691] ACPI: Lid Switch [C136]
[    1.547021] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.547049] processor ACPI_CPU:00: registered as cooling_device0
[    1.547053] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.549899] isapnp: Scanning for PnP cards...
[    1.903674] isapnp: No Plug & Play device found
[    1.905248] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.905338] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.905458] serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
[    1.905715] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.906353] ACPI: PCI Interrupt Link [C0C3] enabled at IRQ 10
[    1.906357] PCI: setting IRQ 10 as level-triggered
[    1.906362] serial 0000:00:1f.6: PCI INT B -> Link[C0C3] -> GSI 10 
(level, low) -> IRQ 10
[    1.906370] serial 0000:00:1f.6: PCI INT B disabled
[    1.907141] brd: module loaded
[    1.907499] loop: module loaded
[    1.907592] Fixed MDIO Bus: probed
[    1.907600] PPP generic driver version 2.4.2
[    1.907669] input: Macintosh mouse button emulation as 
/devices/virtual/input/input3
[    1.907704] Driver 'sd' needs updating - please use bus_type methods
[    1.907715] Driver 'sr' needs updating - please use bus_type methods
[    1.907801] ata_piix 0000:00:1f.1: version 2.12
[    1.907808] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    1.907814] ata_piix 0000:00:1f.1: PCI INT A -> Link[C0C4] -> GSI 5 
(level, low) -> IRQ 5
[    1.907861] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.907965] scsi0 : ata_piix
[    1.908087] scsi1 : ata_piix
[    1.908913] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x4c40 
irq 14
[    1.908916] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x4c48 
irq 15
[    2.072463] ata1.00: ATA-7: SAMSUNG HM120JC, YL100-19, max UDMA/100
[    2.072466] ata1.00: 234441648 sectors, multi 16: LBA48
[    2.080412] ata1.00: configured for UDMA/100
[    2.244369] ata2.00: ATAPI: HL-DT-ST DVD+RW GCA-4040N, 1.17, max MWDMA2
[    2.260328] ata2.00: configured for MWDMA2
[    2.261371] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM120JC  
YL10 PQ: 0 ANSI: 5
[    2.261483] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: 
(120 GB/111 GiB)
[    2.261503] sd 0:0:0:0: [sda] Write Protect is off
[    2.261506] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.261534] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.261601] sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: 
(120 GB/111 GiB)
[    2.261616] sd 0:0:0:0: [sda] Write Protect is off
[    2.261619] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.261645] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.261649]  sda: sda1 sda2 sda3
[    2.281258] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.281312] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.281971] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+RW GCA-4040N 
1.17 PQ: 0 ANSI: 5
[    2.285096] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.285100] Uniform CD-ROM driver Revision: 3.20
[    2.285197] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.285244] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.285998] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.286371] ACPI: PCI Interrupt Link [C0C9] enabled at IRQ 5
[    2.286376] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[C0C9] -> GSI 5 
(level, low) -> IRQ 5
[    2.286405] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.286409] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.286487] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    2.290385] ehci_hcd 0000:00:1d.7: debug port 1
[    2.290392] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.290401] ehci_hcd 0000:00:1d.7: irq 5, io mem 0xa0000000
[    2.304026] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.304105] usb usb1: configuration #1 chosen from 1 choice
[    2.304137] hub 1-0:1.0: USB hub found
[    2.304146] hub 1-0:1.0: 6 ports detected
[    2.304274] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.304293] uhci_hcd: USB Universal Host Controller Interface driver
[    2.304659] ACPI: PCI Interrupt Link [C0C2] enabled at IRQ 10
[    2.304663] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[C0C2] -> GSI 10 
(level, low) -> IRQ 10
[    2.304671] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.304675] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.304721] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    2.304744] uhci_hcd 0000:00:1d.0: irq 10, io base 0x000048c0
[    2.304846] usb usb2: configuration #1 chosen from 1 choice
[    2.304875] hub 2-0:1.0: USB hub found
[    2.304883] hub 2-0:1.0: 2 ports detected
[    2.305302] ACPI: PCI Interrupt Link [C0C5] enabled at IRQ 5
[    2.305306] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[C0C5] -> GSI 5 
(level, low) -> IRQ 5
[    2.305313] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.305316] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.305363] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    2.305383] uhci_hcd 0000:00:1d.1: irq 5, io base 0x000048e0
[    2.305472] usb usb3: configuration #1 chosen from 1 choice
[    2.305500] hub 3-0:1.0: USB hub found
[    2.305508] hub 3-0:1.0: 2 ports detected
[    2.305602] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[C0C4] -> GSI 5 
(level, low) -> IRQ 5
[    2.305608] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.305612] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.305656] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    2.305676] uhci_hcd 0000:00:1d.2: irq 5, io base 0x00004c00
[    2.305763] usb usb4: configuration #1 chosen from 1 choice
[    2.305796] hub 4-0:1.0: USB hub found
[    2.305804] hub 4-0:1.0: 2 ports detected
[    2.305967] PNP: PS/2 Controller [PNP0303:C1A3,PNP0f13:C1A4] at 
0x60,0x64 irq 1,12
[    2.316132] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.321931] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.321937] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.321940] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.321943] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.321946] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.322125] mice: PS/2 mouse device common for all mice
[    2.322300] rtc_cmos 00:09: RTC can wake from S4
[    2.322346] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    2.322366] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    2.322454] device-mapper: uevent: version 1.0.3
[    2.323551] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) 
initialised: dm-devel@redhat.com
[    2.323610] device-mapper: multipath: version 1.0.5 loaded
[    2.323613] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.323718] EISA: Probing bus 0 at eisa.0
[    2.323726] Cannot allocate resource for EISA slot 1
[    2.323729] Cannot allocate resource for EISA slot 2
[    2.323732] Cannot allocate resource for EISA slot 3
[    2.323734] Cannot allocate resource for EISA slot 4
[    2.323753] EISA: Detected 0 cards.
[    2.323831] cpuidle: using governor ladder
[    2.323903] cpuidle: using governor menu
[    2.324605] TCP cubic registered
[    2.324750] NET: Registered protocol family 10
[    2.325297] lo: Disabled Privacy Extensions
[    2.325716] NET: Registered protocol family 17
[    2.325736] Bluetooth: L2CAP ver 2.11
[    2.325738] Bluetooth: L2CAP socket layer initialized
[    2.325741] Bluetooth: SCO (Voice Link) ver 0.6
[    2.325743] Bluetooth: SCO socket layer initialized
[    2.325770] Bluetooth: RFCOMM socket layer initialized
[    2.325778] Bluetooth: RFCOMM TTY layer initialized
[    2.325780] Bluetooth: RFCOMM ver 1.10
[    2.326019] IO APIC resources could be not be allocated.
[    2.326063] Using IPI No-Shortcut mode
[    2.326165] registered taskstats version 1
[    2.326299]   Magic number: 1:920:669
[    2.326425] rtc_cmos 00:09: setting system clock to 2009-07-02 
06:39:53 UTC (1246516793)
[    2.326429] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.326431] EDD information not available.
[    2.326798] Freeing unused kernel memory: 532k freed
[    2.326932] Write protecting the kernel text: 4112k
[    2.326977] Write protecting the kernel read-only data: 1524k
[    2.360729] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input4
[    2.879032] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    2.879094] 8139cp 0000:02:01.0: PCI INT A -> Link[C0C3] -> GSI 10 
(level, low) -> IRQ 10
[    2.880681] eth0: RTL-8139C+ at 0xf7d7c000, 00:02:3f:6b:c3:73, IRQ 10
[    2.887624] 8139too Fast Ethernet driver 0.9.28
[    2.893523] ohci1394 0000:02:00.0: PCI INT A -> Link[C0C2] -> GSI 10 
(level, low) -> IRQ 10
[    2.946277] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  
MMIO=[90200000-902007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.248731] Marking TSC unstable due to TSC halts in idle
[    3.506726] PM: Starting manual resume from disk
[    3.506731] PM: Resume from partition 8:1
[    3.506733] PM: Checking hibernation image.
[    3.506964] PM: Resume from disk failed.
[    3.529108] kjournald starting.  Commit interval 5 seconds
[    3.529120] EXT3-fs: mounted filesystem with ordered data mode.
[    4.244173] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00023f414a0045b2]
[   14.527605] udev: starting version 141
[   14.702209] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.821343] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/device:02/input/input5
[   14.844225] ACPI: Video Device [C0D0] (multi-head: yes  rom: no  
post: no)
[   14.920691] ieee80211_crypt: registered algorithm 'NULL'
[   14.935982] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   14.935987] ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
[   15.155267] Linux agpgart interface v0.103
[   15.183900] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   15.183904] wbsd: Copyright(c) Pierre Ossman
[   15.184823] wbsd 00:02: activated
[   15.190099] mmc0: W83L51xD id 7112 at 0x248 irq 6 dma 0 PnP
[   15.337382] parport_pc 00:05: reported by Plug and Play ACPI
[   15.337431] parport0: PC-style at 0x378 (0x778), irq 7, dma 1 
[PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   15.404608] intel_rng: FWH not detected
[   15.561065] agpgart-intel 0000:00:00.0: Intel 855PM Chipset
[   15.575083] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xb0000000
[   15.818620] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   15.886446] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   15.886451] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   15.887827] ipw2100 0000:02:02.0: PCI INT A -> Link[C0C5] -> GSI 5 
(level, low) -> IRQ 5
[   15.888566] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[   15.888587] ipw2100 0000:02:02.0: firmware: requesting ipw2100-1.3.fw
[   15.941327] ppdev: user-space parallel port driver
[   16.080812] iTCO_vendor_support: vendor-support=0
[   16.102987] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   16.103125] iTCO_wdt: Found a ICH4-M TCO device (Version=1, 
TCOBASE=0x1060)
[   16.103232] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   16.142651] eth1: Radio is disabled by RF switch.
[   16.226838] synaptics was reset on resume, see synaptics_resume_reset 
if you have trouble on resume
[   16.305235] yenta_cardbus 0000:02:04.0: CardBus bridge found [0e11:0860]
[   16.305257] yenta_cardbus 0000:02:04.0: Using CSCINT to route CSC 
interrupts to PCI
[   16.305260] yenta_cardbus 0000:02:04.0: Routing CardBus interrupts to PCI
[   16.305266] yenta_cardbus 0000:02:04.0: TI: mfunc 0x001c1112, devctl 0x44
[   16.341682] Intel ICH 0000:00:1f.5: PCI INT B -> Link[C0C3] -> GSI 10 
(level, low) -> IRQ 10
[   16.341736] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   16.536657] yenta_cardbus 0000:02:04.0: ISA IRQ mask 0x0818, PCI irq 5
[   16.536662] yenta_cardbus 0000:02:04.0: Socket status: 30000006
[   16.536666] pci_bus 0000:02: Raising subordinate bus# of parent bus 
(#02) from #03 to #06
[   16.536675] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge I/O 
window: 0x2000 - 0x2fff
[   16.536680] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x2000-0x2fff: clean.
[   16.536918] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge 
Memory window: 0x90000000 - 0x903fffff
[   16.536923] yenta_cardbus 0000:02:04.0: pcmcia: parent PCI bridge 
Memory window: 0x88000000 - 0x8bffffff
[   16.660114] Clocksource tsc unstable (delta = -247095788 ns)
[   16.879406] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x100-0x3af: clean.
[   16.881114] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x3e0-0x4ff: clean.
[   16.881839] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x820-0x8ff: clean.
[   16.882477] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xc00-0xcf7: clean.
[   16.883295] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xa00-0xaff: clean.
[   17.211729] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x236eb3, 
caps: 0x904713/0x10008
[   17.265570] intel8x0_measure_ac97_clock: measured 56938 usecs
[   17.265574] intel8x0: clocking to 48000
[   17.266231] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio4/input/input7
[   17.424161] lp0: using parport0 (interrupt-driven).
[   17.615978] Adding 1052216k swap on /dev/sda1.  Priority:-1 extents:1 
across:1052216k
[   18.273742] EXT3 FS on sda2, internal journal
[   19.197181] kjournald starting.  Commit interval 5 seconds
[   19.197465] EXT3 FS on sda3, internal journal
[   19.197470] EXT3-fs: mounted filesystem with ordered data mode.
[   19.508166] type=1505 audit(1246516810.681:2): 
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" 
name2="default" pid=2043
[   19.572511] type=1505 audit(1246516810.745:3): 
operation="profile_load" name="/sbin/dhclient-script" name2="default" 
pid=2047
[   19.572713] type=1505 audit(1246516810.745:4): 
operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2047
[   19.572786] type=1505 audit(1246516810.745:5): 
operation="profile_load" 
name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" 
pid=2047
[   19.572841] type=1505 audit(1246516810.745:6): 
operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" 
name2="default" pid=2047
[   19.763941] type=1505 audit(1246516810.933:7): 
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" 
name2="default" pid=2052
[   19.764334] type=1505 audit(1246516810.937:8): 
operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2052
[   19.801664] type=1505 audit(1246516810.973:9): 
operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2056
[   20.594799] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   25.446134] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   25.446138] Bluetooth: BNEP filters: protocol multicast
[   25.501053] Bridge firewalling registered
[   26.790680] pci 0000:01:00.0: PCI INT A -> Link[C0C2] -> GSI 10 
(level, low) -> IRQ 10
[   26.960389] [drm] Initialized drm 1.1.0 20060810
[   27.207866] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   27.430302] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   27.430323] agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x 
mode
[   27.430362] pci 0000:01:00.0: putting AGP V2 device into 4x mode
[   27.662399] [drm] Setting GART location based on new memory map
[   27.662410] [drm] Loading R200 Microcode
[   27.662466] [drm] writeback test succeeded in 2 usecs
[   30.827098] eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[   36.970708]  CIFS VFS: cifs_mount failed w/return code = -6
[   36.972295]  CIFS VFS: cifs_mount failed w/return code = -6
[   40.880114] eth0: no IPv6 routers present
[   42.980187]  CIFS VFS: Error connecting to socket. Aborting operation
[   42.980196]  CIFS VFS: cifs_mount failed w/return code = -113
[   48.988159]  CIFS VFS: Error connecting to socket. Aborting operation
[   48.988168]  CIFS VFS: cifs_mount failed w/return code = -113
[   54.996182]  CIFS VFS: Error connecting to socket. Aborting operation
[   54.996190]  CIFS VFS: cifs_mount failed w/return code = -113
[   96.239343]  CIFS VFS: cifs_mount failed w/return code = -6
[   96.241072]  CIFS VFS: cifs_mount failed w/return code = -6
[  102.248196]  CIFS VFS: Error connecting to socket. Aborting operation
[  102.248211]  CIFS VFS: cifs_mount failed w/return code = -113
[  108.256201]  CIFS VFS: Error connecting to socket. Aborting operation
[  108.256217]  CIFS VFS: cifs_mount failed w/return code = -113
[  114.264208]  CIFS VFS: Error connecting to socket. Aborting operation
[  114.264224]  CIFS VFS: cifs_mount failed w/return code = -113
[ 1944.340158] ACPI: EC: missing confirmations, switch off interrupt mode.
[198911.216042] usb 1-5: new high speed USB device using ehci_hcd and 
address 2
[198911.351588] usb 1-5: configuration #1 chosen from 1 choice
[198912.593153] Linux video capture interface: v2.00
[198912.880723] em28xx v4l2 driver version 0.1.0 loaded
[198912.883307] em28xx new video device (eb1a:2881): interface 0, class 255
[198912.883315] em28xx Has usb audio class
[198912.883318] em28xx #0: Alternate settings: 8
[198912.883320] em28xx #0: Alternate setting 0, max size= 0
[198912.883323] em28xx #0: Alternate setting 1, max size= 0
[198912.883326] em28xx #0: Alternate setting 2, max size= 1448
[198912.883329] em28xx #0: Alternate setting 3, max size= 2048
[198912.883331] em28xx #0: Alternate setting 4, max size= 2304
[198912.883334] em28xx #0: Alternate setting 5, max size= 2580
[198912.883337] em28xx #0: Alternate setting 6, max size= 2892
[198912.883339] em28xx #0: Alternate setting 7, max size= 3072
[198912.883535] em28xx #0: chip ID is em2882/em2883
[198912.914658] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 
5c 00 6a 20 6a 00
[198912.914670] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 
00 00 02 02 00 00
[198912.914680] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 
00 00 5b 1e 00 00
[198912.914691] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 
00 00 00 00 00 00
[198912.914701] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914711] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914721] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
20 03 55 00 53 00
[198912.914731] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 
31 00 20 00 56 00
[198912.914741] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 
00 00 00 00 00 00
[198912.914751] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914761] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914771] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914781] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914791] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914800] em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 
98 01 00 00 00 00
[198912.914811] em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 
00 00 00 00 00 00
[198912.914822] EEPROM ID= 0x9567eb1a, hash = 0xb8846b20
[198912.914825] Vendor/Product ID= eb1a:2881
[198912.914827] AC97 audio (5 sample rates)
[198912.914829] USB Remote wakeup capable
[198912.914831] 500mA max power
[198912.914833] Table at 0x04, strings=0x206a, 0x006a, 0x0000
[198912.951650] em28xx #0: found i2c device @ 0xa0 [eeprom]
[198912.956522] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[198912.970051] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[198912.970056] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[198912.970059] em28xx #0: Please send an email with this log to:
[198912.970062] em28xx #0:     V4L Mailing List 
<video4linux-list@redhat.com>
[198912.970064] em28xx #0: Board eeprom hash is 0xb8846b20
[198912.970067] em28xx #0: Board i2c devicelist hash is 0x27800080
[198912.970070] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[198912.970073] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[198912.970076] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[198912.970079] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[198912.970082] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[198912.970084] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[198912.970087] em28xx #0:     card=5 -> MSI VOX USB 2.0
[198912.970089] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[198912.970092] em28xx #0:     card=7 -> Leadtek Winfast USB II
[198912.970094] em28xx #0:     card=8 -> Kworld USB2800
[198912.970097] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
[198912.970099] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[198912.970102] em28xx #0:     card=11 -> Terratec Hybrid XS
[198912.970105] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[198912.970107] em28xx #0:     card=13 -> Terratec Prodigy XS
[198912.970110] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
[198912.970112] em28xx #0:     card=15 -> V-Gear PocketTV
[198912.970115] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[198912.970117] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[198912.970120] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[198912.970123] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
[198912.970125] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[198912.970128] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[198912.970131] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam 
grabber
[198912.970134] em28xx #0:     card=23 -> Huaqi DLCW-130
[198912.970136] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[198912.970139] em28xx #0:     card=25 -> Gadmei UTV310
[198912.970141] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[198912.970144] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[198912.970147] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[198912.970150] em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
[198912.970152] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[198912.970155] em28xx #0:     card=31 -> Usbgear VD204v9
[198912.970157] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[198912.970160] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink 
PlayTV USB 2.0
[198912.970163] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[198912.970165] em28xx #0:     card=35 -> Typhoon DVD Maker
[198912.970168] em28xx #0:     card=36 -> NetGMBH Cam
[198912.970170] em28xx #0:     card=37 -> Gadmei UTV330
[198912.970172] em28xx #0:     card=38 -> Yakumo MovieMixer
[198912.970175] em28xx #0:     card=39 -> KWorld PVRTV 300U
[198912.970177] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[198912.970180] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[198912.970182] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[198912.970185] em28xx #0:     card=43 -> Terratec Cinergy T XS
[198912.970188] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[198912.970190] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[198912.970193] em28xx #0:     card=46 -> Compro, VideoMate U3
[198912.970195] em28xx #0:     card=47 -> KWorld DVB-T 305U
[198912.970198] em28xx #0:     card=48 -> KWorld DVB-T 310U
[198912.970200] em28xx #0:     card=49 -> MSI DigiVox A/D
[198912.970203] em28xx #0:     card=50 -> MSI DigiVox A/D II
[198912.970205] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[198912.970208] em28xx #0:     card=52 -> DNT DA2 Hybrid
[198912.970210] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[198912.970213] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[198912.970215] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[198912.970218] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[198912.970221] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[198912.970223] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[198913.258102] tvp5150 0-005c: tvp5150am1 detected.
[198913.417081] em28xx #0: V4L2 device registered as /dev/video0 and 
/dev/vbi0
[198913.417086] em28xx #0: Found Unknown EM2750/28xx video grabber
[198913.425831] usbcore: registered new interface driver snd-usb-audio
[198913.448852] usbcore: registered new interface driver em28xx
[198913.640535] tvp5150 0-005c: tvp5150am1 detected.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
