Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6FJKIo1031441
	for <video4linux-list@redhat.com>; Wed, 15 Jul 2009 15:20:18 -0400
Received: from mail-pz0-f172.google.com (mail-pz0-f172.google.com
	[209.85.222.172])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6FJJWBB017954
	for <video4linux-list@redhat.com>; Wed, 15 Jul 2009 15:20:03 -0400
Received: by mail-pz0-f172.google.com with SMTP id 2so2944481pzk.23
	for <video4linux-list@redhat.com>; Wed, 15 Jul 2009 12:20:03 -0700 (PDT)
Message-ID: <4A5E2BAF.80809@gmail.com>
Date: Wed, 15 Jul 2009 12:19:11 -0700
From: Mark <madutam@gmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: ZoneMinder Linux Mint Hauppauge impact vcb 
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

I have been tweaking with zoneminder to see if I can get a simple camera 
setup working.
So far I have been able to load zoneminder and get it working, but I 
cannot get it to display the camera.
When I use VLC I can see the camera is working, but its in black and 
white. I am using the bttv878 driver for the capture card. So far no 
luck getting it to work. Printed below is a copy of my dmesg and lspci. 
I'd appreciate any help I could get on this, I have over 30 hours 
already invested in this.

*DMSG

*[    0.000000] BIOS EBDA/lowmem at: 00000000/000a0000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-11-generic (buildd@palmer) (gcc 
version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #42-Ubuntu SMP Fri Apr 17 
01:57:59 UTC 2009 (Ubuntu 2.6.28-11.42-generic)
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
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fff3000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.2 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working 
it around.
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x100000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 00000000000a0000 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  modified: 000000001fff0000 - 000000001fff3000 (ACPI NVS)
[    0.000000]  modified: 000000001fff3000 - 0000000020000000 (ACPI data)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 1fff0000 @ 10000-16000
[    0.000000] RAMDISK: 1f8a9000 - 1ffdf612
[    0.000000] ACPI: RSDP 000F6C90, 0014 (r0 IntelR)
[    0.000000] ACPI: RSDT 1FFF3000, 002C (r1 IntelR AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: FACP 1FFF3040, 0074 (r1 IntelR AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: DSDT 1FFF30C0, 360C (r1 INTELR AWRDACPI     1000 
MSFT  100000D)
[    0.000000] ACPI: FACS 1FFF0000, 0040
[    0.000000] ACPI: APIC 1FFF6700, 0068 (r1 IntelR AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 511MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1fff0000
[    0.000000]   low ram: 00000000 - 1fff0000
[    0.000000]   bootmap 00012000 - 00016000
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 001fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000087c52c]    TEXT DATA BSS ==> 
[0000100000 - 000087c52c]
[    0.000000]   #4 [001f8a9000 - 001ffdf612]          RAMDISK ==> 
[001f8a9000 - 001ffdf612]
[    0.000000]   #5 [000087d000 - 0000881000]    INIT_PG_TABLE ==> 
[000087d000 - 0000881000]
[    0.000000]   #6 [000009f000 - 0000100000]    BIOS reserved ==> 
[000009f000 - 0000100000]
[    0.000000]   #7 [0000010000 - 0000012000]          PGTABLE ==> 
[0000010000 - 0000012000]
[    0.000000]   #8 [0000012000 - 0000016000]          BOOTMAP ==> 
[0000012000 - 0000016000]
[    0.000000] found SMP MP-table at [c00f51d0] 000f51d0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001fff0
[    0.000000]   HighMem  0x0001fff0 -> 0x0001fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] On node 0 totalpages: 130944
[    0.000000] free_area_init_node: node 0, pgdat c06d0f80, node_mem_map 
c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3952 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125968 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 
20000000:dec00000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 129920
[    0.000000] Kernel command line: root=/dev/sda1 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2004.490 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.004000] Inode-cache hash table entries: 32768 (order: 5, 131072 
bytes)
[    0.004000] allocated 2620800 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Memory: 501404k/524224k available (4126k kernel code, 
22256k reserved, 2208k data, 532k init, 0k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xe07f0000 - 0xff3fe000   ( 492 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
[    0.004000]       .init : 0xc0737000 - 0xc07bc000   ( 532 kB)
[    0.004000]       .data : 0xc0507a6f - 0xc072fe60   (2208 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0507a6f   (4126 kB)
[    0.004000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.004014] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4008.98 BogoMIPS (lpj=8017960)
[    0.004044] Security Framework initialized
[    0.004055] SELinux:  Disabled at boot.
[    0.004083] AppArmor: AppArmor initialized
[    0.004101] Mount-cache hash table entries: 512
[    0.004320] Initializing cgroup subsys ns
[    0.004328] Initializing cgroup subsys cpuacct
[    0.004334] Initializing cgroup subsys memory
[    0.004342] Initializing cgroup subsys freezer
[    0.004365] CPU: Trace cache: 12K uops, L1 D cache: 8K
[    0.004372] CPU: L2 cache: 512K
[    0.004378] CPU: Hyper-Threading is disabled
[    0.004401] Checking 'hlt' instruction... OK.
[    0.021032] SMP alternatives: switching to UP code
[    0.163954] ACPI: Core revision 20080926
[    0.167596] ACPI: Checking initramfs for custom DSDT
[    0.628606] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.669916] CPU0: Intel(R) Pentium(R) 4 CPU 2.00GHz stepping 04
[    0.672002] Brought up 1 CPUs
[    0.672002] Total of 1 processors activated (4008.98 BogoMIPS).
[    0.672002] CPU0 attaching NULL sched-domain.
[    0.672002] net_namespace: 776 bytes
[    0.672002] Booting paravirtualized kernel on bare hardware
[    0.672002] Time:  5:14:56  Date: 07/15/09
[    0.672002] regulator: core version 0.5
[    0.672002] NET: Registered protocol family 16
[    0.672002] EISA bus registered
[    0.672002] ACPI: bus type pci registered
[    0.698338] PCI: PCI BIOS revision 2.10 entry at 0xfb5d0, last bus=2
[    0.698342] PCI: Using configuration type 1 for base access
[    0.700804] ACPI: EC: Look up EC in DSDT
[    0.708041] ACPI: Interpreter enabled
[    0.708048] ACPI: (supports S0 S1 S4 S5)
[    0.708080] ACPI: Using IOAPIC for interrupt routing
[    0.714211] ACPI: No dock devices found.
[    0.714235] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.714317] pci 0000:00:00.0: reg 10 32bit mmio: [0xe0000000-0xe3ffffff]
[    0.714486] pci 0000:00:1d.0: reg 20 io port: [0xb800-0xb81f]
[    0.714549] pci 0000:00:1d.1: reg 20 io port: [0xb000-0xb01f]
[    0.714612] pci 0000:00:1d.2: reg 20 io port: [0xb400-0xb41f]
[    0.714674] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe6200000-0xe62003ff]
[    0.714727] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.714734] pci 0000:00:1d.7: PME# disabled
[    0.714788] * The chipset may have PM-Timer Bug. Due to workarounds 
for a bug,
[    0.714790] * this clock source is slow. If you are sure your timer 
does not have
[    0.714792] * this bug, please use "acpi_pm_good" to disable the 
workaround
[    0.714839] HPET not enabled in BIOS. You might try hpet=force boot 
option
[    0.714849] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 
ACPI/GPIO/TCO
[    0.714854] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 
GPIO
[    0.714880] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.714890] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.714899] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.714908] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.714917] pci 0000:00:1f.1: reg 20 io port: [0xf000-0xf00f]
[    0.714925] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.714986] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.715037] pci 0000:00:1f.5: reg 10 io port: [0xc000-0xc0ff]
[    0.715046] pci 0000:00:1f.5: reg 14 io port: [0xc400-0xc43f]
[    0.715054] pci 0000:00:1f.5: reg 18 32bit mmio: [0xe6201000-0xe62011ff]
[    0.715063] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xe6202000-0xe62020ff]
[    0.715091] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.715097] pci 0000:00:1f.5: PME# disabled
[    0.715149] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    0.715157] pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
[    0.715165] pci 0000:01:00.0: reg 18 32bit mmio: [0xe5000000-0xe500ffff]
[    0.715186] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.715199] pci 0000:01:00.0: supports D1 D2
[    0.715237] pci 0000:01:00.1: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
[    0.715246] pci 0000:01:00.1: reg 14 32bit mmio: [0xe5010000-0xe501ffff]
[    0.715279] pci 0000:01:00.1: supports D1 D2
[    0.715331] pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
[    0.715337] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe5ffffff]
[    0.715344] pci 0000:00:01.0: bridge 32bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.715394] pci 0000:02:06.0: reg 10 io port: [0xa000-0xa0ff]
[    0.715403] pci 0000:02:06.0: reg 14 32bit mmio: [0xe6000000-0xe60000ff]
[    0.715441] pci 0000:02:06.0: supports D1 D2
[    0.715445] pci 0000:02:06.0: PME# supported from D1 D2 D3hot D3cold
[    0.715450] pci 0000:02:06.0: PME# disabled
[    0.715489] pci 0000:02:07.0: reg 10 32bit mmio: [0xe6001000-0xe60017ff]
[    0.715498] pci 0000:02:07.0: reg 14 io port: [0xa400-0xa47f]
[    0.715537] pci 0000:02:07.0: supports D2
[    0.715540] pci 0000:02:07.0: PME# supported from D2 D3hot D3cold
[    0.715546] pci 0000:02:07.0: PME# disabled
[    0.715592] pci 0000:02:08.0: reg 10 32bit mmio: [0xe6100000-0xe6100fff]
[    0.715679] pci 0000:02:08.1: reg 10 32bit mmio: [0xe6101000-0xe6101fff]
[    0.715769] pci 0000:00:1e.0: transparent bridge
[    0.715775] pci 0000:00:1e.0: bridge io port: [0xa000-0xafff]
[    0.715782] pci 0000:00:1e.0: bridge 32bit mmio: [0xe6000000-0xe60fffff]
[    0.715788] pci 0000:00:1e.0: bridge 32bit mmio pref: 
[0xe6100000-0xe61fffff]
[    0.715804] bus 00 -> node 0
[    0.715815] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.716174] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.741443] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12 
14 15)
[    0.741632] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 12 
14 15)
[    0.741812] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12 
14 15)
[    0.741991] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12 
14 15)
[    0.742171] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 *12 
14 15)
[    0.742351] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 
14 15) *0, disabled.
[    0.742533] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 
14 15) *0, disabled.
[    0.742714] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 *11 12 
14 15)
[    0.742907] ACPI: WMI: Mapper loaded
[    0.743251] SCSI subsystem initialized
[    0.743313] libata version 3.00 loaded.
[    0.743394] usbcore: registered new interface driver usbfs
[    0.743425] usbcore: registered new interface driver hub
[    0.743469] usbcore: registered new device driver usb
[    0.743659] PCI: Using ACPI for IRQ routing
[    0.743810] Bluetooth: Core ver 2.13
[    0.743810] NET: Registered protocol family 31
[    0.743810] Bluetooth: HCI device and connection manager initialized
[    0.743810] Bluetooth: HCI socket layer initialized
[    0.743810] NET: Registered protocol family 8
[    0.743810] NET: Registered protocol family 20
[    0.743810] NetLabel: Initializing
[    0.743810] NetLabel:  domain hash size = 128
[    0.743810] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.743810] NetLabel:  unlabeled traffic allowed by default
[    0.744112] AppArmor: AppArmor Filesystem Enabled
[    0.744152] pnp: PnP ACPI init
[    0.744171] ACPI: bus type pnp registered
[    0.748882] pnp: PnP ACPI: found 13 devices
[    0.748886] ACPI: ACPI bus type pnp unregistered
[    0.748892] PnPBIOS: Disabled by ACPI PNP
[    0.748909] system 00:00: iomem range 0xcd000-0xcffff has been reserved
[    0.748914] system 00:00: iomem range 0xf0000-0xf7fff could not be 
reserved
[    0.748918] system 00:00: iomem range 0xf8000-0xfbfff could not be 
reserved
[    0.748922] system 00:00: iomem range 0xfc000-0xfffff could not be 
reserved
[    0.748927] system 00:00: iomem range 0x1fff0000-0x1fffffff could not 
be reserved
[    0.748931] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.748935] system 00:00: iomem range 0x100000-0x1ffeffff could not 
be reserved
[    0.748940] system 00:00: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.748944] system 00:00: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.748948] system 00:00: iomem range 0xffb00000-0xffbfffff has been 
reserved
[    0.748953] system 00:00: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.748957] system 00:00: iomem range 0xe0000-0xeffff has been reserved
[    0.748967] system 00:02: ioport range 0x400-0x4bf could not be reserved
[    0.748976] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
[    0.748980] system 00:03: ioport range 0x290-0x29f has been reserved
[    0.748984] system 00:03: ioport range 0x800-0x805 has been reserved
[    0.783850] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.783856] pci 0000:00:01.0:   IO window: 0x9000-0x9fff
[    0.783863] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe5ffffff
[    0.783870] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.783880] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.783884] pci 0000:00:1e.0:   IO window: 0xa000-0xafff
[    0.783891] pci 0000:00:1e.0:   MEM window: 0xe6000000-0xe60fffff
[    0.783897] pci 0000:00:1e.0:   PREFETCH window: 
0x000000e6100000-0x000000e61fffff
[    0.783919] pci 0000:00:1e.0: setting latency timer to 64
[    0.783926] bus: 00 index 0 io port: [0x00-0xffff]
[    0.783929] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.783932] bus: 01 index 0 io port: [0x9000-0x9fff]
[    0.783936] bus: 01 index 1 mmio: [0xe4000000-0xe5ffffff]
[    0.783939] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.783942] bus: 01 index 3 mmio: [0x0-0x0]
[    0.783946] bus: 02 index 0 io port: [0xa000-0xafff]
[    0.783949] bus: 02 index 1 mmio: [0xe6000000-0xe60fffff]
[    0.783953] bus: 02 index 2 mmio: [0xe6100000-0xe61fffff]
[    0.783956] bus: 02 index 3 io port: [0x00-0xffff]
[    0.783959] bus: 02 index 4 mmio: [0x000000-0xffffffff]
[    0.783975] NET: Registered protocol family 2
[    0.784180] IP route cache hash table entries: 4096 (order: 2, 16384 
bytes)
[    0.784544] TCP established hash table entries: 16384 (order: 5, 
131072 bytes)
[    0.784664] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    0.784777] TCP: Hash tables configured (established 16384 bind 16384)
[    0.784781] TCP reno registered
[    0.784929] NET: Registered protocol family 1
[    0.785127] checking if image is initramfs... it is
[    1.284060] Switched to high resolution mode on CPU 0
[    1.753843] Freeing initrd memory: 7385k freed
[    1.753957] cpufreq: No nForce2 chipset.
[    1.754199] audit: initializing netlink socket (disabled)
[    1.754230] type=2000 audit(1247634896.752:1): initialized
[    1.763439] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.765351] VFS: Disk quotas dquot_6.5.1
[    1.765442] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.766431] fuse init (API version 7.10)
[    1.766560] msgmni has been set to 993
[    1.766834] alg: No test for stdrng (krng)
[    1.766856] io scheduler noop registered
[    1.766859] io scheduler anticipatory registered
[    1.766862] io scheduler deadline registered
[    1.766891] io scheduler cfq registered (default)
[    1.767007] pci 0000:01:00.0: Boot video device
[    1.771375] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.771391] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.771598] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.771602] ACPI: Power Button (FF) [PWRF]
[    1.771672] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    1.771676] ACPI: Power Button (CM) [PWRB]
[    1.771744] fan PNP0C0B:00: registered as cooling_device0
[    1.771754] ACPI: Fan [FAN] (on)
[    1.772108] processor ACPI_CPU:00: registered as cooling_device1
[    1.775159] thermal LNXTHERM:01: registered as thermal_zone0
[    1.775544] ACPI: Thermal Zone [THRM] (35 C)
[    1.775610] isapnp: Scanning for PnP cards...
[    2.129521] isapnp: No Plug & Play device found
[    2.131661] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    2.131774] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.131875] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.132355] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.132517] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.133751] brd: module loaded
[    2.134315] loop: module loaded
[    2.134457] Fixed MDIO Bus: probed
[    2.134467] PPP generic driver version 2.4.2
[    2.134565] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    2.134614] Driver 'sd' needs updating - please use bus_type methods
[    2.134631] Driver 'sr' needs updating - please use bus_type methods
[    2.134749] ata_piix 0000:00:1f.1: version 2.12
[    2.134778] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    2.134861] ata_piix 0000:00:1f.1: setting latency timer to 64
[    2.135036] scsi0 : ata_piix
[    2.135198] scsi1 : ata_piix
[    2.136431] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 
irq 14
[    2.136436] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 
irq 15
[    2.520573] ata2.00: ATAPI: BENQ    DVD LS DW1655, BCGB, max UDMA/33
[    2.521070] ata2.01: ATA-6: ST340014A, 3.06, max UDMA/100
[    2.521074] ata2.01: 78165360 sectors, multi 16: LBA48
[    2.536654] ata2.00: configured for UDMA/33
[    2.552456] ata2.01: configured for UDMA/100
[    2.555090] scsi 1:0:0:0: CD-ROM            BENQ     DVD LS DW1655    
BCGB PQ: 0 ANSI: 5
[    2.563287] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    2.563292] Uniform CD-ROM driver Revision: 3.20
[    2.563464] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.563551] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.563676] scsi 1:0:1:0: Direct-Access     ATA      ST340014A        
3.06 PQ: 0 ANSI: 5
[    2.563825] sd 1:0:1:0: [sda] 78165360 512-byte hardware sectors: 
(40.0 GB/37.2 GiB)
[    2.563851] sd 1:0:1:0: [sda] Write Protect is off
[    2.563855] sd 1:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.563895] sd 1:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.563989] sd 1:0:1:0: [sda] 78165360 512-byte hardware sectors: 
(40.0 GB/37.2 GiB)
[    2.564025] sd 1:0:1:0: [sda] Write Protect is off
[    2.564029] sd 1:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.564068] sd 1:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.564073]  sda: sda1 sda2 < sda5 >
[    2.602941] sd 1:0:1:0: [sda] Attached SCSI disk
[    2.603020] sd 1:0:1:0: Attached scsi generic sg1 type 0
[    2.603991] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.604052] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) 
-> IRQ 23
[    2.604086] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.604092] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.604190] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    2.608121] ehci_hcd 0000:00:1d.7: cache line size of 128 is not 
supported
[    2.608143] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe6200000
[    2.624014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.624130] usb usb1: configuration #1 chosen from 1 choice
[    2.624173] hub 1-0:1.0: USB hub found
[    2.624192] hub 1-0:1.0: 6 ports detected
[    2.624375] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.624405] uhci_hcd: USB Universal Host Controller Interface driver
[    2.624472] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    2.624484] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.624489] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.624564] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    2.624600] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000b800
[    2.624716] usb usb2: configuration #1 chosen from 1 choice
[    2.624757] hub 2-0:1.0: USB hub found
[    2.624773] hub 2-0:1.0: 2 ports detected
[    2.624900] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    2.624910] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.624914] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.624981] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    2.625015] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b000
[    2.625121] usb usb3: configuration #1 chosen from 1 choice
[    2.625160] hub 3-0:1.0: USB hub found
[    2.625177] hub 3-0:1.0: 2 ports detected
[    2.625300] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    2.625309] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.625313] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.625377] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    2.625412] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b400
[    2.625529] usb usb4: configuration #1 chosen from 1 choice
[    2.625583] hub 4-0:1.0: USB hub found
[    2.625597] hub 4-0:1.0: 2 ports detected
[    2.625775] usbcore: registered new interface driver libusual
[    2.625844] usbcore: registered new interface driver usbserial
[    2.625862] USB Serial support registered for generic
[    2.625889] usbcore: registered new interface driver usbserial_generic
[    2.625893] usbserial: USB Serial Driver core
[    2.625962] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.625966] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp
[    2.626357] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.626529] mice: PS/2 mouse device common for all mice
[    2.626725] rtc_cmos 00:05: RTC can wake from S4
[    2.626782] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.626810] rtc0: alarms up to one month, 242 bytes nvram
[    2.626930] device-mapper: uevent: version 1.0.3
[    2.627119] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) 
initialised: dm-devel@redhat.com
[    2.627197] device-mapper: multipath: version 1.0.5 loaded
[    2.627202] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.627337] EISA: Probing bus 0 at eisa.0
[    2.627381] EISA: Detected 0 cards.
[    2.627425] cpuidle: using governor ladder
[    2.627429] cpuidle: using governor menu
[    2.628220] TCP cubic registered
[    2.628341] NET: Registered protocol family 10
[    2.628996] lo: Disabled Privacy Extensions
[    2.629459] NET: Registered protocol family 17
[    2.629494] Bluetooth: L2CAP ver 2.11
[    2.629497] Bluetooth: L2CAP socket layer initialized
[    2.629502] Bluetooth: SCO (Voice Link) ver 0.6
[    2.629505] Bluetooth: SCO socket layer initialized
[    2.629557] Bluetooth: RFCOMM socket layer initialized
[    2.629570] Bluetooth: RFCOMM TTY layer initialized
[    2.629573] Bluetooth: RFCOMM ver 1.10
[    2.629639] Using IPI No-Shortcut mode
[    2.629793] registered taskstats version 1
[    2.629984]   Magic number: 1:827:213
[    2.630093] rtc_cmos 00:05: setting system clock to 2009-07-15 
05:14:58 UTC (1247634898)
[    2.630098] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.630100] EDD information not available.
[    2.630979] Freeing unused kernel memory: 532k freed
[    2.631146] Write protecting the kernel text: 4128k
[    2.631201] Write protecting the kernel read-only data: 1532k
[    2.674595] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input3
[    3.121945] usb 2-1: new low speed USB device using uhci_hcd and 
address 2
[    3.285929] Floppy drive(s): fd0 is 1.44M
[    3.303823] FDC 0 is a post-1991 82077
[    3.314678] usb 2-1: configuration #1 chosen from 1 choice
[    3.668173] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    3.668222] 8139cp 0000:02:06.0: This (id 10ec:8139 rev 10) is not an 
8139C+ compatible chip, use 8139too
[    3.672900] 8139too Fast Ethernet driver 0.9.28
[    3.672963] 8139too 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> 
IRQ 18
[    3.674321] eth0: RealTek RTL8139 at 0xa000, 00:30:1b:ac:e9:43, IRQ 18
[    3.674325] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[    3.718257] ohci1394 0000:02:07.0: PCI INT A -> GSI 19 (level, low) 
-> IRQ 19
[    3.771115] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  
MMIO=[e6001000-e60017ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    4.652630] usbcore: registered new interface driver hiddev
[    4.652775] usbcore: registered new interface driver usbhid
[    4.652780] usbhid: v2.6:USB HID core driver
[    4.695919] input: Microsft Microsoft Wireless Desktop Receiver 3.1 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4
[    4.699429] microsoft 0003:045E:00F9.0001: input,hidraw0: USB HID 
v1.11 Keyboard [Microsft Microsoft Wireless Desktop Receiver 3.1] on 
usb-0000:00:1d.0-1/input0
[    4.787369] microsoft 0003:045E:00F9.0002: fixing up Microsoft 
Wireless Receiver Model 1028 report descriptor
[    4.837590] input: Microsft Microsoft Wireless Desktop Receiver 3.1 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/input/input5
[    4.842714] microsoft 0003:045E:00F9.0002: input,hidraw1: USB HID 
v1.11 Mouse [Microsft Microsoft Wireless Desktop Receiver 3.1] on 
usb-0000:00:1d.0-1/input1
[    4.970152] PM: Starting manual resume from disk
[    4.970159] PM: Resume from partition 8:5
[    4.970162] PM: Checking hibernation image.
[    4.970389] PM: Resume from disk failed.
[    5.015361] kjournald starting.  Commit interval 5 seconds
[    5.015381] EXT3-fs: mounted filesystem with ordered data mode.
[    5.104189] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00301bac0000e9a7]
[   10.999732] udev: starting version 141
[   11.155920] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.224078] parport_pc 00:0b: reported by Plug and Play ACPI
[   11.224125] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   11.241706] Linux agpgart interface v0.103
[   11.306574] agpgart-intel 0000:00:00.0: Intel 830M Chipset
[   11.310936] agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xe0000000
[   11.340766] intel_rng: FWH not detected
[   11.393811] iTCO_vendor_support: vendor-support=0
[   11.396654] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   11.396831] iTCO_wdt: Found a ICH4 TCO device (Version=1, TCOBASE=0x0460)
[   11.396952] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.565248] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   12.228960] ppdev: user-space parallel port driver
[   12.317071] Linux video capture interface: v2.00
[   12.378402] bttv: driver version 0.9.17 loaded
[   12.378408] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   12.378729] bttv: Bt8xx card found (0).
[   12.378760] bttv 0000:02:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   12.378775] bttv0: Bt878 (rev 17) at 0000:02:08.0, irq: 20, latency: 
32, mmio: 0xe6100000
[   12.378914] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem 
ID is 0070:13eb
[   12.378919] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   12.378968] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   12.381458] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   12.412672] tveeprom 0-0050: Hauppauge model 64405, rev C1  , serial# 
10684629
[   12.412677] tveeprom 0-0050: tuner model is Unspecified (idx 2, type 4)
[   12.412681] tveeprom 0-0050: TV standards UNKNOWN (eeprom 0x01)
[   12.412685] tveeprom 0-0050: audio processor is None (idx 0)
[   12.412688] tveeprom 0-0050: decoder processor is BT878 (idx 14)
[   12.412691] tveeprom 0-0050: has no radio
[   12.412694] bttv0: Hauppauge eeprom indicates model#64405
[   12.412698] bttv0: tuner absent
[   12.412702] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[   12.434126] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   12.447212] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   12.527382] bttv0: registered device video0
[   12.527470] bttv0: registered device vbi0
[   12.527495] bttv0: PLL: 28636363 => 35468950 .. ok
[   12.573459] Bt87x 0000:02:08.1: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[   12.573986] bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[   12.716771] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) 
-> IRQ 17
[   12.716844] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   13.040017] intel8x0_measure_ac97_clock: measured 52575 usecs
[   13.040022] intel8x0: clocking to 48000
[   13.253637] lp0: using parport0 (interrupt-driven).
[   13.392189] Adding 1485972k swap on /dev/sda5.  Priority:-1 extents:1 
across:1485972k
[   13.957653] EXT3 FS on sda1, internal journal
[   34.858682] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   34.858688] Bluetooth: BNEP filters: protocol multicast
[   34.891629] Bridge firewalling registered
[   36.486293] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   37.118925] [drm] Initialized drm 1.1.0 20060810
[   37.153430] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   37.604164] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
[   37.604191] agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x 
mode
[   37.604230] pci 0000:01:00.0: putting AGP V2 device into 4x mode
[   37.832266] [drm] Setting GART location based on new memory map
[   37.832282] [drm] Loading R200 Microcode
[   37.832339] [drm] writeback test succeeded in 1 usecs
[   41.131627] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   51.340011] eth0: no IPv6 routers present
[ 2900.333999] bttv0: PLL can sleep, using XTAL (28636363).

*LSPCI*

00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM 
Controller/Host-Hub Interface (rev 03)
00:01.0 PCI bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE 
Host-to-AGP Bridge (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 
EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82)
00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC 
Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller 
(rev 02)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
SMBus Controller (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 02)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If 
[Radeon 9000] (rev 01)
01:00.1 Display controller: ATI Technologies Inc Radeon RV250 [Radeon 
9000] (Secondary) (rev 01)
02:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
02:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 
1394 OHCI Link Layer Controller (rev 46)
02:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
02:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
