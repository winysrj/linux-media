Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51639 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZIFGzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2009 02:55:10 -0400
Received: by bwz19 with SMTP id 19so1013802bwz.37
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 23:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ef96b78e0909051137w188ef6ddw75f8c595e4498f0@mail.gmail.com>
References: <ef96b78e0909051137w188ef6ddw75f8c595e4498f0@mail.gmail.com>
Date: Sun, 6 Sep 2009 08:55:10 +0200
Message-ID: <ef96b78e0909052355q71f1f2ddudbc787bbffec39e1@mail.gmail.com>
Subject: Re: Hauppauge HVR 1110 : recognized but doesn't work
From: Morvan Le Meut <mlemeut@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/5 Morvan Le Meut <mlemeut@gmail.com>:
> ( new subject from my previous ec168 mail )
>
> got the firmware from http://steventoth.net/linux/hvr1200/
>
> using the latest code from linuxtv ( which autodetect the card as an HVR1120 )
> seems the problem is firmware uploading ... wrong file ?
> on the card PCB i got :
>  670000-038 LF
> the DVB part read
> hauppauge 1110
> dvb-t
> 67209 LF rev c2F5
> and the chip read Saa7131e/03/G
>
for those who may need it, here's a full dmesg output and i forgot to
say that this was on a mythbuntu 9.04 ( the other tv card is an
ADS-tech instant tv dvb-t PCI ) :

[    0.000000] BIOS EBDA/lowmem at: 0009f000/0009f000
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffce000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fffe000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x3ffc0 max_arch_pfn = 0x100000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  modified: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  modified: 000000003ffce000 - 000000003fff0000 (ACPI NVS)
[    0.000000]  modified: 000000003fff0000 - 000000003fffe000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
[    0.000000] RAMDISK: 378b2000 - 37fefe50
[    0.000000] Allocated new RAMDISK: 00881000 - 00fbee50
[    0.000000] Move RAMDISK from 00000000378b2000 - 0000000037fefe4f
to 00881000 - 00fbee4f
[    0.000000] ACPI: RSDP 000FA1F0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFC0000, 0038 (r1 021709 RSDT1317 20090217
MSFT       97)
[    0.000000] ACPI: FACP 3FFC0200, 0084 (r1 021709 FACP1317 20090217
MSFT       97)
[    0.000000] ACPI: DSDT 3FFC04A0, 4880 (r1  1ADKR 1ADKR017       17
INTL 20051117)
[    0.000000] ACPI: FACS 3FFCE000, 0040
[    0.000000] ACPI: APIC 3FFC0390, 0080 (r1 021709 APIC1317 20090217
MSFT       97)
[    0.000000] ACPI: MCFG 3FFC0410, 003C (r1 021709 OEMMCFG  20090217
MSFT       97)
[    0.000000] ACPI: WDRT 3FFC0450, 0047 (r1 021709 NV-WDRT  20090217
MSFT       97)
[    0.000000] ACPI: OEMB 3FFCE040, 0071 (r1 021709 OEMB1317 20090217
MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 139MB HIGHMEM available.
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
[    0.000000]   #3 [0000100000 - 000087c52c]    TEXT DATA BSS ==>
[0000100000 - 000087c52c]
[    0.000000]   #4 [000087d000 - 0000881000]    INIT_PG_TABLE ==>
[000087d000 - 0000881000]
[    0.000000]   #5 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==>
[0000010000 - 0000012000]
[    0.000000]   #7 [0000881000 - 0000fbee50]      NEW RAMDISK ==>
[0000881000 - 0000fbee50]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==>
[0000012000 - 0000019000]
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003ffc0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003ffc0
[    0.000000] On node 0 totalpages: 261967
[    0.000000] free_area_init_node: node 0, pgdat c06d0f80,
node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 280 pages used for memmap
[    0.000000]   HighMem zone: 35498 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 3 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
3fffe000:bec02000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 259919
[    0.000000] Kernel command line:
root=UUID=0771bfb9-de6b-48af-9bd7-f531a9fc3753 ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2612.353 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] allocated 5241280 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Memory: 1018140k/1048320k available (4126k kernel code,
29428k reserved, 2208k data, 532k init, 143112k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.004000]       .init : 0xc0737000 - 0xc07bc000   ( 532 kB)
[    0.004000]       .data : 0xc0507a6f - 0xc072fe60   (2208 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0507a6f   (4126 kB)
[    0.004000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=4, Nodes=1
[    0.004010] Calibrating delay loop (skipped), value calculated
using timer frequency.. 5224.70 BogoMIPS (lpj=10449412)
[    0.004025] Security Framework initialized
[    0.004031] SELinux:  Disabled at boot.
[    0.004051] AppArmor: AppArmor initialized
[    0.004058] Mount-cache hash table entries: 512
[    0.004183] Initializing cgroup subsys ns
[    0.004185] Initializing cgroup subsys cpuacct
[    0.004187] Initializing cgroup subsys memory
[    0.004191] Initializing cgroup subsys freezer
[    0.004201] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004203] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004207] using C1E aware idle routine
[    0.004215] Checking 'hlt' instruction... OK.
[    0.020454] SMP alternatives: switching to UP code
[    0.108021] ACPI: Core revision 20080926
[    0.109720] ACPI: Checking initramfs for custom DSDT
[    0.337414] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.377115] CPU0: AMD Athlon(tm) 64 Processor 4000+ stepping 03
[    0.380001] Brought up 1 CPUs
[    0.380001] Total of 1 processors activated (5224.70 BogoMIPS).
[    0.380001] CPU0 attaching NULL sched-domain.
[    0.380001] net_namespace: 776 bytes
[    0.380001] Booting paravirtualized kernel on bare hardware
[    0.380001] Time:  6:44:43  Date: 09/06/09
[    0.380001] regulator: core version 0.5
[    0.380001] NET: Registered protocol family 16
[    0.380001] EISA bus registered
[    0.380001] ACPI: bus type pci registered
[    0.380001] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.380001] PCI: Not using MMCONFIG.
[    0.380001] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    0.380001] PCI: Using configuration type 1 for base access
[    0.380001] ACPI: EC: Look up EC in DSDT
[    0.385727] ACPI: Interpreter enabled
[    0.385730] ACPI: (supports S0 S1 S3 S4 S5)
[    0.385744] ACPI: Using IOAPIC for interrupt routing
[    0.385784] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.389471] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.389472] PCI: Using MMCONFIG for extended config space
[    0.395161] ACPI: No dock devices found.
[    0.395208] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.395346] pci 0000:00:01.0: reg 10 io port: [0x4f00-0x4fff]
[    0.395378] pci 0000:00:01.1: reg 10 io port: [0x4900-0x493f]
[    0.395387] pci 0000:00:01.1: reg 20 io port: [0x4d00-0x4d3f]
[    0.395390] pci 0000:00:01.1: reg 24 io port: [0x4e00-0x4e3f]
[    0.395399] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.395404] pci 0000:00:01.1: PME# disabled
[    0.395447] pci 0000:00:01.3: reg 10 32bit mmio: [0xfec80000-0xfecfffff]
[    0.395516] pci 0000:00:02.0: reg 10 32bit mmio: [0xdaf7f000-0xdaf7ffff]
[    0.395532] pci 0000:00:02.0: supports D1 D2
[    0.395533] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.395535] pci 0000:00:02.0: PME# disabled
[    0.395555] pci 0000:00:02.1: reg 10 32bit mmio: [0xdaf7ec00-0xdaf7ecff]
[    0.395572] pci 0000:00:02.1: supports D1 D2
[    0.395574] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.395576] pci 0000:00:02.1: PME# disabled
[    0.395623] pci 0000:00:05.0: reg 10 32bit mmio: [0xdaf78000-0xdaf7bfff]
[    0.395638] pci 0000:00:05.0: PME# supported from D3hot D3cold
[    0.395641] pci 0000:00:05.0: PME# disabled
[    0.395665] pci 0000:00:08.0: reg 10 io port: [0xee00-0xee07]
[    0.395668] pci 0000:00:08.0: reg 14 io port: [0xed80-0xed83]
[    0.395671] pci 0000:00:08.0: reg 18 io port: [0xed00-0xed07]
[    0.395674] pci 0000:00:08.0: reg 1c io port: [0xec00-0xec03]
[    0.395677] pci 0000:00:08.0: reg 20 io port: [0xeb80-0xeb8f]
[    0.395680] pci 0000:00:08.0: reg 24 32bit mmio: [0xdaf7d000-0xdaf7dfff]
[    0.395708] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.395710] pci 0000:00:09.0: PME# disabled
[    0.395729] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.395731] pci 0000:00:0b.0: PME# disabled
[    0.395749] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.395751] pci 0000:00:0c.0: PME# disabled
[    0.395833] pci 0000:01:09.0: reg 10 32bit mmio: [0xddeff800-0xddefffff]
[    0.395858] pci 0000:01:09.0: supports D1 D2
[    0.395882] pci 0000:01:0a.0: reg 10 32bit mmio: [0xdc000000-0xdcffffff]
[    0.395925] pci 0000:01:0a.2: reg 10 32bit mmio: [0xdb000000-0xdbffffff]
[    0.395972] pci 0000:00:04.0: transparent bridge
[    0.395975] pci 0000:00:04.0: bridge 32bit mmio: [0xdb000000-0xddefffff]
[    0.396008] pci 0000:02:00.0: reg 10 32bit mmio: [0xdf000000-0xdfffffff]
[    0.396014] pci 0000:02:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
[    0.396020] pci 0000:02:00.0: reg 1c 64bit mmio: [0xde000000-0xdeffffff]
[    0.396026] pci 0000:02:00.0: reg 30 32bit mmio: [0xddfe0000-0xddffffff]
[    0.396063] pci 0000:00:09.0: bridge 32bit mmio: [0xddf00000-0xdfffffff]
[    0.396066] pci 0000:00:09.0: bridge 64bit mmio pref: [0xc0000000-0xcfffffff]
[    0.396134] bus 00 -> node 0
[    0.396139] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.396326] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.396437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.396517] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.396596] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.401519] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.401710] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *5
[    0.401899] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *14
[    0.402084] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.402270] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.402456] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
[    0.402641] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.402830] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[    0.403019] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *14
[    0.403208] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[    0.403393] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
[    0.403582] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *10
[    0.403773] ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *0, disabled.
[    0.403962] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.404165] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *5
[    0.404358] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *11
[    0.404548] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
[    0.404764] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.404872] ACPI: WMI: Mapper loaded
[    0.405011] SCSI subsystem initialized
[    0.405042] libata version 3.00 loaded.
[    0.405077] usbcore: registered new interface driver usbfs
[    0.405092] usbcore: registered new interface driver hub
[    0.405110] usbcore: registered new device driver usb
[    0.405185] PCI: Using ACPI for IRQ routing
[    0.405251] Bluetooth: Core ver 2.13
[    0.405251] NET: Registered protocol family 31
[    0.405251] Bluetooth: HCI device and connection manager initialized
[    0.405251] Bluetooth: HCI socket layer initialized
[    0.405251] NET: Registered protocol family 8
[    0.405251] NET: Registered protocol family 20
[    0.405251] NetLabel: Initializing
[    0.405251] NetLabel:  domain hash size = 128
[    0.405251] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.405251] NetLabel:  unlabeled traffic allowed by default
[    0.405251] AppArmor: AppArmor Filesystem Enabled
[    0.405251] pnp: PnP ACPI init
[    0.405251] ACPI: bus type pnp registered
[    0.408681] pnp: PnP ACPI: found 12 devices
[    0.408683] ACPI: ACPI bus type pnp unregistered
[    0.408685] PnPBIOS: Disabled by ACPI PNP
[    0.408693] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.408695] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.408697] system 00:05: ioport range 0x4000-0x407f has been reserved
[    0.408699] system 00:05: ioport range 0x4080-0x40ff has been reserved
[    0.408701] system 00:05: ioport range 0x4400-0x447f has been reserved
[    0.408703] system 00:05: ioport range 0x4480-0x44ff has been reserved
[    0.408705] system 00:05: ioport range 0x4800-0x487f has been reserved
[    0.408707] system 00:05: ioport range 0x4880-0x48ff has been reserved
[    0.408709] system 00:05: ioport range 0x4c00-0x4c7f has been reserved
[    0.408711] system 00:05: ioport range 0x4c80-0x4cff has been reserved
[    0.408713] system 00:05: iomem range 0xfec80000-0xfd93ffff could
not be reserved
[    0.408716] system 00:05: iomem range 0xfefe0000-0xfefe01ff has been reserved
[    0.408718] system 00:05: iomem range 0xfefe1000-0xfefe1fff has been reserved
[    0.408723] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.408725] system 00:05: iomem range 0xffb80000-0xffffffff could
not be reserved
[    0.408729] system 00:06: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.408731] system 00:06: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.408736] system 00:09: ioport range 0xa00-0xadf has been reserved
[    0.408738] system 00:09: ioport range 0xae0-0xaef has been reserved
[    0.408741] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.408745] system 00:0b: iomem range 0x0-0x9ffff could not be reserved
[    0.408747] system 00:0b: iomem range 0xc0000-0xcffff could not be reserved
[    0.408749] system 00:0b: iomem range 0xe0000-0xfffff could not be reserved
[    0.408751] system 00:0b: iomem range 0x100000-0x3fffffff could not
be reserved
[    0.408753] system 00:0b: iomem range 0xfec00000-0xffffffff could
not be reserved
[    0.443399] pci 0000:00:04.0: PCI bridge, secondary bus 0000:01
[    0.443401] pci 0000:00:04.0:   IO window: disabled
[    0.443404] pci 0000:00:04.0:   MEM window: 0xdb000000-0xddefffff
[    0.443406] pci 0000:00:04.0:   PREFETCH window: disabled
[    0.443409] pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
[    0.443411] pci 0000:00:09.0:   IO window: disabled
[    0.443413] pci 0000:00:09.0:   MEM window: 0xddf00000-0xdfffffff
[    0.443415] pci 0000:00:09.0:   PREFETCH window:
0x000000c0000000-0x000000cfffffff
[    0.443418] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
[    0.443420] pci 0000:00:0b.0:   IO window: disabled
[    0.443422] pci 0000:00:0b.0:   MEM window: disabled
[    0.443423] pci 0000:00:0b.0:   PREFETCH window: disabled
[    0.443426] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:04
[    0.443427] pci 0000:00:0c.0:   IO window: disabled
[    0.443429] pci 0000:00:0c.0:   MEM window: disabled
[    0.443431] pci 0000:00:0c.0:   PREFETCH window: disabled
[    0.443437] pci 0000:00:04.0: setting latency timer to 64
[    0.443441] pci 0000:00:09.0: setting latency timer to 64
[    0.443445] pci 0000:00:0b.0: setting latency timer to 64
[    0.443448] pci 0000:00:0c.0: setting latency timer to 64
[    0.443451] bus: 00 index 0 io port: [0x00-0xffff]
[    0.443452] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.443454] bus: 01 index 0 mmio: [0x0-0x0]
[    0.443455] bus: 01 index 1 mmio: [0xdb000000-0xddefffff]
[    0.443457] bus: 01 index 2 mmio: [0x0-0x0]
[    0.443458] bus: 01 index 3 io port: [0x00-0xffff]
[    0.443459] bus: 01 index 4 mmio: [0x000000-0xffffffff]
[    0.443461] bus: 02 index 0 mmio: [0x0-0x0]
[    0.443462] bus: 02 index 1 mmio: [0xddf00000-0xdfffffff]
[    0.443464] bus: 02 index 2 mmio: [0xc0000000-0xcfffffff]
[    0.443465] bus: 02 index 3 mmio: [0x0-0x0]
[    0.443466] bus: 03 index 0 mmio: [0x0-0x0]
[    0.443468] bus: 03 index 1 mmio: [0x0-0x0]
[    0.443469] bus: 03 index 2 mmio: [0x0-0x0]
[    0.443470] bus: 03 index 3 mmio: [0x0-0x0]
[    0.443472] bus: 04 index 0 mmio: [0x0-0x0]
[    0.443473] bus: 04 index 1 mmio: [0x0-0x0]
[    0.443474] bus: 04 index 2 mmio: [0x0-0x0]
[    0.443475] bus: 04 index 3 mmio: [0x0-0x0]
[    0.443483] NET: Registered protocol family 2
[    0.443504] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.443504] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.444026] Switched to high resolution mode on CPU 0
[    0.444474] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.444802] TCP: Hash tables configured (established 131072 bind 65536)
[    0.444805] TCP reno registered
[    0.444937] NET: Registered protocol family 1
[    0.445032] checking if image is initramfs... it is
[    0.913238] Freeing initrd memory: 7415k freed
[    0.913317] cpufreq: No nForce2 chipset.
[    0.913423] audit: initializing netlink socket (disabled)
[    0.913436] type=2000 audit(1252219483.912:1): initialized
[    0.919378] highmem bounce pool size: 64 pages
[    0.919382] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.920248] VFS: Disk quotas dquot_6.5.1
[    0.920287] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.920703] fuse init (API version 7.10)
[    0.920760] msgmni has been set to 1724
[    0.920886] alg: No test for stdrng (krng)
[    0.920894] io scheduler noop registered
[    0.920895] io scheduler anticipatory registered
[    0.920896] io scheduler deadline registered
[    0.920908] io scheduler cfq registered (default)
[    0.920936] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.942499] pci 0000:00:04.0: Enabling HT MSI Mapping
[    0.942514] pci 0000:00:05.0: Enabling HT MSI Mapping
[    0.942527] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.942540] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.942553] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    0.942566] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    0.942588] pci 0000:02:00.0: Boot video device
[    0.946680] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.946700] pcieport-driver 0000:00:09.0: found MSI capability
[    0.946713] pcieport-driver 0000:00:09.0: irq 2303 for MSI/MSI-X
[    0.946718] pci_express 0000:00:09.0:pcie00: allocate port service
[    0.946729] pci_express 0000:00:09.0:pcie03: allocate port service
[    0.946756] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    0.946773] pcieport-driver 0000:00:0b.0: found MSI capability
[    0.946783] pcieport-driver 0000:00:0b.0: irq 2302 for MSI/MSI-X
[    0.946788] pci_express 0000:00:0b.0:pcie00: allocate port service
[    0.946796] pci_express 0000:00:0b.0:pcie03: allocate port service
[    0.946823] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    0.946840] pcieport-driver 0000:00:0c.0: found MSI capability
[    0.946849] pcieport-driver 0000:00:0c.0: irq 2301 for MSI/MSI-X
[    0.946854] pci_express 0000:00:0c.0:pcie00: allocate port service
[    0.946863] pci_express 0000:00:0c.0:pcie03: allocate port service
[    0.946899] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.946905] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.947005] input: Power Button (FF) as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.947008] ACPI: Power Button (FF) [PWRF]
[    0.947044] input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.947053] ACPI: Power Button (CM) [PWRB]
[    0.947214] processor ACPI_CPU:00: registered as cooling_device0
[    0.950082] isapnp: Scanning for PnP cards...
[    1.302798] isapnp: No Plug & Play device found
[    1.303660] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.304379] brd: module loaded
[    1.304624] loop: module loaded
[    1.304675] Fixed MDIO Bus: probed
[    1.304680] PPP generic driver version 2.4.2
[    1.304723] input: Macintosh mouse button emulation as
/devices/virtual/input/input2
[    1.304741] Driver 'sd' needs updating - please use bus_type methods
[    1.304747] Driver 'sr' needs updating - please use bus_type methods
[    1.304885] sata_nv 0000:00:08.0: version 3.5
[    1.305232] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[    1.305243] sata_nv 0000:00:08.0: PCI INT A -> Link[LSA0] -> GSI 23
(level, low) -> IRQ 23
[    1.305293] sata_nv 0000:00:08.0: setting latency timer to 64
[    1.305374] scsi0 : sata_nv
[    1.305447] scsi1 : sata_nv
[    1.305556] ata1: SATA max UDMA/133 cmd 0xee00 ctl 0xed80 bmdma 0xeb80 irq 23
[    1.305559] ata2: SATA max UDMA/133 cmd 0xed00 ctl 0xec00 bmdma 0xeb88 irq 23
[    1.772038] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.807522] ata1.00: ATA-8: MAXTOR STM3320613AS, MC1H, max UDMA/133
[    1.807524] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.863556] ata1.00: configured for UDMA/133
[    2.328036] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.336117] ata2.00: ATAPI: Optiarc DVD RW AD-5240S, 1.01, max UDMA/100
[    2.352129] ata2.00: configured for UDMA/100
[    2.352716] scsi 0:0:0:0: Direct-Access     ATA      MAXTOR
STM332061 MC1H PQ: 0 ANSI: 5
[    2.352782] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors:
(320 GB/298 GiB)
[    2.352794] sd 0:0:0:0: [sda] Write Protect is off
[    2.352796] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.352813] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.352862] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors:
(320 GB/298 GiB)
[    2.352872] sd 0:0:0:0: [sda] Write Protect is off
[    2.352874] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.352890] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.352893]  sda: sda1 sda2 < sda5 sda6 >
[    2.385316] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.385355] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.386635] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW
AD-5240S  1.01 PQ: 0 ANSI: 5
[    2.391079] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    2.391082] Uniform CD-ROM driver Revision: 3.20
[    2.391147] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.391172] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.391544] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.391888] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    2.391897] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI
22 (level, low) -> IRQ 22
[    2.391913] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    2.391915] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    2.391962] ehci_hcd 0000:00:02.1: new USB bus registered, assigned
bus number 1
[    2.391985] ehci_hcd 0000:00:02.1: debug port 1
[    2.391989] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    2.392024] ehci_hcd 0000:00:02.1: irq 22, io mem 0xdaf7ec00
[    2.404021] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    2.404078] usb usb1: configuration #1 chosen from 1 choice
[    2.404097] hub 1-0:1.0: USB hub found
[    2.404104] hub 1-0:1.0: 10 ports detected
[    2.404182] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.404479] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[    2.404485] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI
21 (level, low) -> IRQ 21
[    2.404493] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    2.404495] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.404522] ohci_hcd 0000:00:02.0: new USB bus registered, assigned
bus number 2
[    2.404541] ohci_hcd 0000:00:02.0: irq 21, io mem 0xdaf7f000
[    2.462038] usb usb2: configuration #1 chosen from 1 choice
[    2.462056] hub 2-0:1.0: USB hub found
[    2.462063] hub 2-0:1.0: 10 ports detected
[    2.462125] uhci_hcd: USB Universal Host Controller Interface driver
[    2.462173] usbcore: registered new interface driver libusual
[    2.462197] usbcore: registered new interface driver usbserial
[    2.462204] USB Serial support registered for generic
[    2.462213] usbcore: registered new interface driver usbserial_generic
[    2.462215] usbserial: USB Serial Driver core
[    2.462246] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at
0x60,0x64 irq 1,12
[    2.464210] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.464214] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.464305] mice: PS/2 mouse device common for all mice
[    2.464433] rtc_cmos 00:02: RTC can wake from S4
[    2.464460] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    2.464492] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    2.464538] device-mapper: uevent: version 1.0.3
[    2.464620] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    2.464660] device-mapper: multipath: version 1.0.5 loaded
[    2.464662] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.464726] EISA: Probing bus 0 at eisa.0
[    2.464737] Cannot allocate resource for EISA slot 4
[    2.464746] EISA: Detected 0 cards.
[    2.464769] cpuidle: using governor ladder
[    2.464771] cpuidle: using governor menu
[    2.465135] TCP cubic registered
[    2.465205] NET: Registered protocol family 10
[    2.465513] lo: Disabled Privacy Extensions
[    2.465737] NET: Registered protocol family 17
[    2.465748] Bluetooth: L2CAP ver 2.11
[    2.465750] Bluetooth: L2CAP socket layer initialized
[    2.465752] Bluetooth: SCO (Voice Link) ver 0.6
[    2.465753] Bluetooth: SCO socket layer initialized
[    2.465771] Bluetooth: RFCOMM socket layer initialized
[    2.465777] Bluetooth: RFCOMM TTY layer initialized
[    2.465778] Bluetooth: RFCOMM ver 1.10
[    2.465796] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 4000+
processors (1 cpu cores) (version 2.20.00)
[    2.469221] powernow-k8: BIOS error - no PSB or ACPI _PSS objects
[    2.469290] Using IPI No-Shortcut mode
[    2.469350] registered taskstats version 1
[    2.469445]   Magic number: 9:785:720
[    2.469459] block loop0: hash matches
[    2.469542] rtc_cmos 00:02: setting system clock to 2009-09-06
06:44:45 UTC (1252219485)
[    2.469544] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.469546] EDD information not available.
[    2.469850] Freeing unused kernel memory: 532k freed
[    2.469945] Write protecting the kernel text: 4128k
[    2.469977] Write protecting the kernel read-only data: 1532k
[    2.510484] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input3
[    2.772022] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    2.907492] usb 1-4: configuration #1 chosen from 1 choice
[    3.204039] usb 2-2: new low speed USB device using ohci_hcd and address 2
[    3.250188] PM: Starting manual resume from disk
[    3.250191] PM: Resume from partition 8:5
[    3.250193] PM: Checking hibernation image.
[    3.250400] PM: Resume from disk failed.
[    3.268901] kjournald starting.  Commit interval 5 seconds
[    3.268910] EXT3-fs: mounted filesystem with ordered data mode.
[    3.417100] usb 2-2: configuration #1 chosen from 1 choice
[    4.332815] udev: starting version 141
[    4.676155] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4d00
[    4.676185] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4e00
[    4.697584] usbcore: registered new interface driver hiddev
[    4.703323] input: Microsoft Microsoft 3-Button Mouse with
IntelliEye(TM) as
/devices/pci0000:00/0000:00:02.0/usb2/2-2/2-2:1.0/input/input4
[    4.724323] generic-usb 0003:045E:0053.0001: input,hidraw0: USB HID
v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)]
on usb-0000:00:02.0-2/input0
[    4.724342] usbcore: registered new interface driver usbhid
[    4.724359] usbhid: v2.6:USB HID core driver
[    4.724390] cfg80211: Calling CRDA to update world regulatory domain
[    4.995347] Linux agpgart interface v0.103
[    5.063761] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.357017] cfg80211: World regulatory domain updated:
[    5.357022] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    5.357024] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.357026] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.357028] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.357030] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.357032] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.434386] nvidia: module license 'NVIDIA' taints kernel.
[    5.690766] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 19
[    5.690778] nvidia 0000:02:00.0: PCI INT A -> Link[LNED] -> GSI 19
(level, low) -> IRQ 19
[    5.690784] nvidia 0000:02:00.0: setting latency timer to 64
[    5.691953] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44
Mon Mar 23 14:59:10 PST 2009
[    5.699787] Linux video capture interface: v2.00
[    5.826449] synaptics was reset on resume, see
synaptics_resume_reset if you have trouble on resume
[    5.840570] saa7130/34: v4l2 driver version 0.2.15 loaded
[    5.842324] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 18
[    5.842336] saa7134 0000:01:09.0: PCI INT A -> Link[LNKB] -> GSI 18
(level, low) -> IRQ 18
[    5.842341] saa7133[0]: found at 0000:01:09.0, rev: 209, irq: 18,
latency: 64, mmio: 0xddeff800
[    5.842346] saa7133[0]: subsystem: 0070:6707, board: Hauppauge
WinTV-HVR1120 DVB-T/Hybrid [card=156,autodetected]
[    5.842423] saa7133[0]: board init: gpio is 40000
[    5.885854] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    5.888171] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    5.948607] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
[    5.948619] HDA Intel 0000:00:05.0: PCI INT B -> Link[LAZA] -> GSI
20 (level, low) -> IRQ 20
[    5.948688] HDA Intel 0000:00:05.0: setting latency timer to 64
[    6.009471] usb 1-4: reset high speed USB device using ehci_hcd and address 3
[    6.016016] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[    6.016022] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff
ff ff ff ff ff ff ff
[    6.016027] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88
ff 00 b0 ff ff ff ff
[    6.016032] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    6.016037] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97
04 00 20 00 ff ff ff
[    6.016042] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016047] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016052] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016057] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 5c
05 5f f0 73 05 29 00
[    6.016064] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95
29 8d 72 07 70 73 09
[    6.016069] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f
72 0e 01 72 0f 01 72
[    6.016074] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69
79 29 00 00 00 00 00
[    6.016079] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016084] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016089] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016094] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00
[    6.016102] tveeprom 2-0050: Hauppauge model 67209, rev C2F5, serial# 6227292
[    6.016104] tveeprom 2-0050: MAC address is 00-0D-FE-5F-05-5C
[    6.016106] tveeprom 2-0050: tuner model is NXP 18271C2 (idx 155, type 54)
[    6.016108] tveeprom 2-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    6.016110] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
[    6.016112] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
[    6.016114] tveeprom 2-0050: has radio, has IR receiver, has no IR
transmitter
[    6.016115] saa7133[0]: hauppauge eeprom: model=67209
[    6.088079] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[    6.141336] phy0: Selected rate control algorithm 'pid'
[    6.168025] tda829x 2-004b: setting tuner address to 60
[    6.185859] zd1211rw 1-4:1.0: phy0
[    6.185880] usbcore: registered new interface driver zd1211rw
[    6.215792] tda18271 2-0060: creating new instance
[    6.264015] TDA18271HD/C2 detected @ 2-0060
[    6.272186] psmouse serio1: ID: 00 00 64<6>hda_codec: Unknown model
for ALC883, trying auto-probe from BIOS...
[    6.771086] input: ImPS/2 Generic Wheel Mouse as
/devices/platform/i8042/serio1/input/input6
[    7.596020] tda18271: performing RF tracking filter calibration
[   25.800017] tda18271: RF tracking filter calibration complete
[   25.856015] tda829x 2-004b: type set to tda8290+18271
[   30.832126] saa7133[0]: registered device video0 [v4l2]
[   30.832167] saa7133[0]: registered device vbi0
[   30.832202] saa7133[0]: registered device radio0
[   30.834032] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 17
[   30.834043] cx8800 0000:01:0a.0: PCI INT A -> Link[LNKC] -> GSI 17
(level, low) -> IRQ 17
[   30.834561] cx88[0]: subsystem: 1421:0334, board: ADS Tech Instant
TV DVB-T PCI [card=29,autodetected], frontend(s): 1
[   30.834563] cx88[0]: TV tuner type 4, Radio tuner type -1
[   30.861108] saa7134 ALSA driver for DMA sound loaded
[   30.861131] saa7133[0]/alsa: saa7133[0] at 0xddeff800 irq 18
registered as card -2
[   30.897279] dvb_init() allocating 1 frontend
[   30.979238] input: cx88 IR (ADS Tech Instant TV DV as
/devices/pci0000:00/0000:00:04.0/0000:01:0a.0/input/input7
[   30.979389] cx88[0]/0: found at 0000:01:0a.0, rev: 5, irq: 17,
latency: 64, mmio: 0xdc000000
[   30.979497] cx88[0]/0: registered device video1 [v4l2]
[   30.979575] cx88[0]/0: registered device vbi1
[   30.979623] cx88[0]/2: cx2388x 8802 Driver Manager
[   30.979636] cx88-mpeg driver manager 0000:01:0a.2: PCI INT A ->
Link[LNKC] -> GSI 17 (level, low) -> IRQ 17
[   30.979642] cx88[0]/2: found at 0000:01:0a.2, rev: 5, irq: 17,
latency: 64, mmio: 0xdb000000
[   31.033790] tda829x 2-004b: type set to tda8290
[   31.048102] tda18271 2-0060: attaching existing instance
[   31.048107] DVB: registering new adapter (saa7133[0])
[   31.048110] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[   31.142367] lp: driver loaded but no devices found
[   31.326177] Adding 995988k swap on /dev/sda5.  Priority:-1
extents:1 across:995988k
[   31.376020] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[   31.376025] saa7134 0000:01:09.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   31.491126] tda10048_firmware_upload: firmware read 24878 bytes.
[   31.491129] tda10048_firmware_upload: firmware uploading
[   32.262922] EXT3 FS on sda1, internal journal
[   34.068283] SGI XFS with ACLs, security attributes, realtime, large
block numbers, no debug enabled
[   34.071216] SGI XFS Quota Management subsystem
[   34.166219] XFS mounting filesystem sda6
[   34.390670] Ending clean XFS mount for filesystem: sda6
[   35.602762] type=1505 audit(1252219518.630:2):
operation="profile_load" name="/sbin/dhclient-script" name2="default"
pid=2129
[   35.602905] type=1505 audit(1252219518.630:3):
operation="profile_load" name="/sbin/dhclient3" name2="default"
pid=2129
[   35.602950] type=1505 audit(1252219518.630:4):
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default"
pid=2129
[   35.602990] type=1505 audit(1252219518.630:5):
operation="profile_load"
name="/usr/lib/connman/scripts/dhclient-script" name2="default"
pid=2129
[   35.624033] tda10048_firmware_upload: firmware uploaded
[   35.732088] type=1505 audit(1252219518.762:6):
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"
name2="default" pid=2134
[   35.732267] type=1505 audit(1252219518.762:7):
operation="profile_load" name="/usr/sbin/cupsd" name2="default"
pid=2134
[   35.756937] type=1505 audit(1252219518.786:8):
operation="profile_load" name="/usr/sbin/mysqld" name2="default"
pid=2138
[   35.782388] type=1505 audit(1252219518.810:9):
operation="profile_load" name="/usr/sbin/tcpdump" name2="default"
pid=2142
[   35.801808] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[   35.801812] cx88/2: registering cx8802 driver, type: dvb access: shared
[   35.801815] cx88[0]/2: subsystem: 1421:0334, board: ADS Tech
Instant TV DVB-T PCI [card=29]
[   35.801817] cx88[0]/2: cx2388x based DVB/ATSC card
[   35.801819] cx8802_alloc_frontends() allocating 1 frontend(s)
[   35.863408] DVB: registering new adapter (cx88[0])
[   35.863412] DVB: registering adapter 1 frontend 0 (Zarlink MT352 DVB-T)...
[   44.424021] tda18271_write_regs: ERROR: i2c_transfer returned: -5
[   44.424026] tda18271c2_rf_tracking_filters_correction: error -5 on line 244
[   47.550095] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   47.550098] Bluetooth: BNEP filters: protocol multicast
[   47.590635] Bridge firewalling registered
[   49.902629] ppdev: user-space parallel port driver
[   52.970522] usb 1-4: firmware: requesting zd1211/zd1211b_ub
[   53.009126] usb 1-4: firmware: requesting zd1211/zd1211b_uphr
[   53.074175] zd1211rw 1-4:1.0: firmware version 4725
[   53.114158] zd1211rw 1-4:1.0: zd1211b chip 0ace:1215 v4810 high
00-0e-8e AL2230_RF pa0 g--NS
[   53.116534] cfg80211: Calling CRDA for country: DE
[   53.118749] cfg80211: Regulatory domain changed to country: DE
[   53.118752] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   53.118754] 	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   53.118756] 	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   53.118758] 	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[   53.130556] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   53.974327] wlan0: direct probe to AP 00:17:33:ad:cd:28 try 1
[   53.976212] wlan0 direct probe responded
[   53.976215] wlan0: authenticate with AP 00:17:33:ad:cd:28
[   53.982121] wlan0: authenticated
[   53.982126] wlan0: associate with AP 00:17:33:ad:cd:28
[   53.986044] wlan0: RX AssocResp from 00:17:33:ad:cd:28 (capab=0x401
status=0 aid=1)
[   53.986047] wlan0: associated
[   53.986400] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   54.072521] wlan0: disassociating by local choice (reason=3)
[   61.215643] wlan0: authenticate with AP 00:40:f4:e8:c5:4d
[   61.217907] wlan0: authenticated
[   61.217912] wlan0: associate with AP 00:40:f4:e8:c5:4d
[   61.221403] wlan0: RX AssocResp from 00:40:f4:e8:c5:4d (capab=0x431
status=0 aid=1)
[   61.221406] wlan0: associated
[   64.908015] wlan0: no IPv6 routers present

thanks for any help
