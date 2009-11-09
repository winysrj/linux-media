Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:49762 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZKIF7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 00:59:34 -0500
Received: by pzk26 with SMTP id 26so1897231pzk.4
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 21:59:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911082117h632bc437t28124ba727e7f915@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	<829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	<cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	<829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
	<cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
	<829197380911082006s5a575789rd1e2881e874177cd@mail.gmail.com>
	<cd9524450911082035j7fa14b75q2b9edcdb1b1e85c3@mail.gmail.com>
	<829197380911082047i5111615eo9e900290455b81dd@mail.gmail.com>
	<cd9524450911082117h632bc437t28124ba727e7f915@mail.gmail.com>
From: Barry Williams <bazzawill@gmail.com>
Date: Mon, 9 Nov 2009 16:29:19 +1030
Message-ID: <cd9524450911082159p39f922b9r73d731b62789e7a8@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 3:47 PM, Barry Williams <bazzawill@gmail.com> wrote:
> On Mon, Nov 9, 2009 at 3:17 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Sun, Nov 8, 2009 at 11:35 PM, Barry Williams <bazzawill@gmail.com> wrote:
>>> Devin
>>> Attached is the output from dmesg, I hope you're right
>>> Thanks
>>> Barry
>>
>> Ah, based on the dmesg I can see it wasn't what I thought it was (I
>> saw it was dib7000 and improperly assumed it had an xc3028 tuner like
>> the rev1 board does).
>>
>> You should probably start a new thread on the mailing list regarding
>> the problems you are having with this tuner.  And you will probably
>> need to bisect the v4l-dvb tree and see when the breakage was
>> introduced.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>
> I'd be happy to help with that however I am unfamiliar with the
> concept of bisecting a tree if you could provide more info that would
> be helpful and then I will start a new thread with the information I
> can gather.
> Thanks
> Barry
>

I appear to be good at doing silly things I of course forgot I
unplugged the antenna cable from my first box to watch normal tv so
that is why it is not tuning. However now my rev 1 tuner appears to no
longer be working mythtv says it is asleep here is the output from
dmesg.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-14-generic (buildd@rothera) (gcc
version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #48-Ubuntu SMP Fri Oct 16
14:04:26 UTC 2009 (Ubuntu 2.6.31-14.48-generic)
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
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff8000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fff8000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 base 0E0000000 mask FF8000000 write-combining
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff8000 (ACPI data)
[    0.000000]  modified: 000000003fff8000 - 0000000040000000 (ACPI NVS)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000] Using x86 segment limits to approximate NX protection
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 10000-15000
[    0.000000] RAMDISK: 2f8e8000 - 3003314d
[    0.000000] ACPI: RSDP 000fa9e0 00014 (v00 AMI   )
[    0.000000] ACPI: RSDT 3fff0000 0002C (v01 AMIINT VIA_K7   00000010
MSFT 00000097)
[    0.000000] ACPI: FACP 3fff0030 00081 (v01 AMIINT VIA_K7   00000011
MSFT 00000097)
[    0.000000] ACPI: DSDT 3fff0120 03311 (v01    VIA   VIA_K7 00001000
MSFT 0100000D)
[    0.000000] ACPI: FACS 3fff8000 00040
[    0.000000] ACPI: APIC 3fff00c0 00054 (v01 AMIINT VIA_K7   00000009
MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00011000 - 00017f00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00008a80a0]    TEXT DATA BSS ==>
[0000100000 - 00008a80a0]
[    0.000000]   #4 [002f8e8000 - 003003314d]          RAMDISK ==>
[002f8e8000 - 003003314d]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [00008a9000 - 00008ac108]              BRK ==>
[00008a9000 - 00008ac108]
[    0.000000]   #7 [0000010000 - 0000011000]          PGTABLE ==>
[0000010000 - 0000011000]
[    0.000000]   #8 [0000011000 - 0000018000]          BOOTMAP ==>
[0000011000 - 0000018000]
[    0.000000] found SMP MP-table at [c00fb930] fb930
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000] free_area_init_node: node 0, pgdat c0784900,
node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 272 pages used for memmap
[    0.000000]   HighMem zone: 34530 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
40000000:bec00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c1805000, static data 35612 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 259967
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.31-14-generic
root=UUID=caa12c49-5f0b-4099-96ed-e937239185ca ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 5242240 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:0003fff0)
[    0.000000] Memory: 1018136k/1048512k available (4565k kernel code,
29532k reserved, 2143k data, 540k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1d000 - 0xfffff000   ( 904 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc078e000 - 0xc0815000   ( 540 kB)
[    0.000000]       .data : 0xc0575554 - 0xc078d308   (2143 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0575554   (4565 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:256
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1666.651 MHz processor.
[    0.001970] Console: colour VGA+ 80x25
[    0.001976] console [tty0] enabled
[    0.002056] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3333.30 BogoMIPS (lpj=6666604)
[    0.002097] Security Framework initialized
[    0.002144] AppArmor: AppArmor initialized
[    0.002157] Mount-cache hash table entries: 512
[    0.002384] Initializing cgroup subsys ns
[    0.002392] Initializing cgroup subsys cpuacct
[    0.002398] Initializing cgroup subsys memory
[    0.002412] Initializing cgroup subsys freezer
[    0.002416] Initializing cgroup subsys net_cls
[    0.002436] CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
[    0.002442] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002446] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002453] mce: CPU supports 4 MCE banks
[    0.002483] Performance Counters: AMD PMU driver.
[    0.002494] ... version:                 0
[    0.002496] ... bit width:               48
[    0.002499] ... generic counters:        4
[    0.002502] ... value mask:              0000ffffffffffff
[    0.002505] ... max period:              00007fffffffffff
[    0.002507] ... fixed-purpose counters:  0
[    0.002510] ... counter mask:            000000000000000f
[    0.002517] Checking 'hlt' instruction... OK.
[    0.016738] SMP alternatives: switching to UP code
[    0.024034] Freeing SMP alternatives: 19k freed
[    0.024068] ACPI: Core revision 20090521
[    0.032803] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072502] CPU0: AMD Athlon(tm) XP 2200+ stepping 00
[    0.076001] Brought up 1 CPUs
[    0.076001] Total of 1 processors activated (3333.30 BogoMIPS).
[    0.076001] CPU0 attaching NULL sched-domain.
[    0.076001] Booting paravirtualized kernel on bare hardware
[    0.076001] regulator: core version 0.5
[    0.076001] Time:  5:49:48  Date: 11/09/09
[    0.076001] NET: Registered protocol family 16
[    0.076001] EISA bus registered
[    0.076001] ACPI: bus type pci registered
[    0.077865] PCI: PCI BIOS revision 2.10 entry at 0xfdaf1, last bus=1
[    0.077869] PCI: Using configuration type 1 for base access
[    0.079201] bio: create slab <bio-0> at 0
[    0.079830] ACPI: EC: Look up EC in DSDT
[    0.086017] ACPI: Interpreter enabled
[    0.086024] ACPI: (supports S0 S1 S4 S5)
[    0.086050] ACPI: Using IOAPIC for interrupt routing
[    0.090261] ACPI: Power Resource [URP1] (off)
[    0.090298] ACPI: Power Resource [URP2] (off)
[    0.090343] ACPI: Power Resource [FDDP] (off)
[    0.090380] ACPI: Power Resource [LPTP] (off)
[    0.090534] ACPI: No dock devices found.
[    0.090691] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.090755] pci 0000:00:00.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
[    0.090844] pci 0000:00:01.0: supports D1
[    0.090881] pci 0000:00:07.0: reg 10 io port: [0xec00-0xecff]
[    0.090890] pci 0000:00:07.0: reg 14 32bit mmio: [0xdfffff00-0xdfffffff]
[    0.090926] pci 0000:00:07.0: supports D1 D2
[    0.090930] pci 0000:00:07.0: PME# supported from D1 D2 D3hot
[    0.090935] pci 0000:00:07.0: PME# disabled
[    0.090985] pci 0000:00:0b.0: reg 20 io port: [0xe400-0xe41f]
[    0.091009] pci 0000:00:0b.0: supports D1 D2
[    0.091012] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091017] pci 0000:00:0b.0: PME# disabled
[    0.091063] pci 0000:00:0b.1: reg 20 io port: [0xe800-0xe81f]
[    0.091087] pci 0000:00:0b.1: supports D1 D2
[    0.091090] pci 0000:00:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091095] pci 0000:00:0b.1: PME# disabled
[    0.091127] pci 0000:00:0b.2: reg 10 32bit mmio: [0xdffffe00-0xdffffeff]
[    0.091166] pci 0000:00:0b.2: supports D1 D2
[    0.091169] pci 0000:00:0b.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091174] pci 0000:00:0b.2: PME# disabled
[    0.091216] pci 0000:00:0c.0: reg 10 io port: [0xe000-0xe0ff]
[    0.091257] pci 0000:00:0c.0: supports D1 D2
[    0.091308] pci 0000:00:10.0: reg 20 io port: [0xd400-0xd41f]
[    0.091332] pci 0000:00:10.0: supports D1 D2
[    0.091335] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091340] pci 0000:00:10.0: PME# disabled
[    0.091386] pci 0000:00:10.1: reg 20 io port: [0xd800-0xd81f]
[    0.091410] pci 0000:00:10.1: supports D1 D2
[    0.091413] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091418] pci 0000:00:10.1: PME# disabled
[    0.091464] pci 0000:00:10.2: reg 20 io port: [0xdc00-0xdc1f]
[    0.091488] pci 0000:00:10.2: supports D1 D2
[    0.091491] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091496] pci 0000:00:10.2: PME# disabled
[    0.091527] pci 0000:00:10.3: reg 10 32bit mmio: [0xdffffd00-0xdffffdff]
[    0.091567] pci 0000:00:10.3: supports D1 D2
[    0.091570] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.091575] pci 0000:00:10.3: PME# disabled
[    0.091636] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.091645] pci 0000:00:11.0: quirk: region 0800-087f claimed by vt8235 PM
[    0.091650] pci 0000:00:11.0: quirk: region 0400-040f claimed by vt8235 SMB
[    0.091711] pci 0000:00:11.1: reg 20 io port: [0xfc00-0xfc0f]
[    0.091801] pci 0000:01:00.0: reg 10 32bit mmio: [0xde000000-0xdeffffff]
[    0.091810] pci 0000:01:00.0: reg 14 32bit mmio: [0xc0000000-0xcfffffff]
[    0.091818] pci 0000:01:00.0: reg 18 32bit mmio: [0xdd000000-0xddffffff]
[    0.091838] pci 0000:01:00.0: reg 30 32bit mmio: [0xdfee0000-0xdfefffff]
[    0.091895] pci 0000:00:01.0: bridge 32bit mmio: [0xdbe00000-0xdfefffff]
[    0.091901] pci 0000:00:01.0: bridge 32bit mmio pref: [0xbbd00000-0xdbcfffff]
[    0.091910] pci_bus 0000:00: on NUMA node 0
[    0.091916] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.094170] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.094293] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.094413] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[    0.094531] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.094786] SCSI subsystem initialized
[    0.094877] libata version 3.00 loaded.
[    0.094995] usbcore: registered new interface driver usbfs
[    0.095020] usbcore: registered new interface driver hub
[    0.095062] usbcore: registered new device driver usb
[    0.095250] ACPI: WMI: Mapper loaded
[    0.095253] PCI: Using ACPI for IRQ routing
[    0.095432] Bluetooth: Core ver 2.15
[    0.095478] NET: Registered protocol family 31
[    0.095481] Bluetooth: HCI device and connection manager initialized
[    0.095486] Bluetooth: HCI socket layer initialized
[    0.095490] NetLabel: Initializing
[    0.095492] NetLabel:  domain hash size = 128
[    0.095494] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.095526] NetLabel:  unlabeled traffic allowed by default
[    0.098749] pnp: PnP ACPI init
[    0.098785] ACPI: bus type pnp registered
[    0.102285] pnp: PnP ACPI: found 10 devices
[    0.102289] ACPI: ACPI bus type pnp unregistered
[    0.102295] PnPBIOS: Disabled by ACPI PNP
[    0.102315] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.102320] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
[    0.102324] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.102328] system 00:01: ioport range 0x400-0x40f has been reserved
[    0.102333] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.102338] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.137089] AppArmor: AppArmor Filesystem Enabled
[    0.137114] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.137117] pci 0000:00:01.0:   IO window: disabled
[    0.137126] pci 0000:00:01.0:   MEM window: 0xdbe00000-0xdfefffff
[    0.137131] pci 0000:00:01.0:   PREFETCH window: 0xbbd00000-0xdbcfffff
[    0.137149] pci 0000:00:01.0: setting latency timer to 64
[    0.137158] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.137162] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.137166] pci_bus 0000:01: resource 1 mem: [0xdbe00000-0xdfefffff]
[    0.137170] pci_bus 0000:01: resource 2 pref mem [0xbbd00000-0xdbcfffff]
[    0.137226] NET: Registered protocol family 2
[    0.137364] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.138004] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.140239] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.141365] TCP: Hash tables configured (established 131072 bind 65536)
[    0.141369] TCP reno registered
[    0.141538] NET: Registered protocol family 1
[    0.141657] Trying to unpack rootfs image as initramfs...
[    0.422975] Freeing initrd memory: 7468k freed
[    0.437160] cpufreq-nforce2: No nForce2 chipset.
[    0.437223] Scanning for low memory corruption every 60 seconds
[    0.437396] audit: initializing netlink socket (disabled)
[    0.437422] type=2000 audit(1257745787.436:1): initialized
[    0.448551] highmem bounce pool size: 64 pages
[    0.448561] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.450627] VFS: Disk quotas dquot_6.5.2
[    0.450704] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.451436] fuse init (API version 7.12)
[    0.451548] msgmni has been set to 1732
[    0.451844] alg: No test for stdrng (krng)
[    0.451863] io scheduler noop registered
[    0.451866] io scheduler anticipatory registered
[    0.451870] io scheduler deadline registered
[    0.451925] io scheduler cfq registered (default)
[    0.451942] pci 0000:00:01.0: disabling DAC on VIA PCI bridge
[    0.452072] pci 0000:01:00.0: Boot video device
[    0.452180] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.452214] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.452391] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.452398] ACPI: Power Button [PWRF]
[    0.452468] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.452472] ACPI: Power Button [PWRB]
[    0.452541] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.452549] ACPI: Sleep Button [SLPB]
[    0.452787] processor LNXCPU:00: registered as cooling_device0
[    0.452792] ACPI: Processor [CPU0] (supports 16 throttling states)
[    0.454882] isapnp: Scanning for PnP cards...
[    0.640062] Switched to high resolution mode on CPU 0
[    0.808501] isapnp: No Plug & Play device found
[    0.810012] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.810145] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.810239] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.810535] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.810663] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.812097] brd: module loaded
[    0.812726] loop: module loaded
[    0.812840] input: Macintosh mouse button emulation as
/devices/virtual/input/input3
[    0.813569] pata_via 0000:00:11.1: version 0.3.4
[    0.813593] pata_via 0000:00:11.1: can't derive routing for PCI INT A
[    0.813878] scsi0 : pata_via
[    0.814040] scsi1 : pata_via
[    0.817968] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    0.817974] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    0.818486] Fixed MDIO Bus: probed
[    0.818543] PPP generic driver version 2.4.2
[    0.818699] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.818727]   alloc irq_desc for 16 on node -1
[    0.818731]   alloc kstat_irqs on node -1
[    0.818742] ehci_hcd 0000:00:0b.2: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    0.818768] ehci_hcd 0000:00:0b.2: EHCI Host Controller
[    0.818845] ehci_hcd 0000:00:0b.2: new USB bus registered, assigned
bus number 1
[    0.818921] ehci_hcd 0000:00:0b.2: irq 16, io mem 0xdffffe00
[    0.828014] ehci_hcd 0000:00:0b.2: USB 2.0 started, EHCI 1.00
[    0.828132] usb usb1: configuration #1 chosen from 1 choice
[    0.828180] hub 1-0:1.0: USB hub found
[    0.828196] hub 1-0:1.0: 4 ports detected
[    0.828262]   alloc irq_desc for 21 on node -1
[    0.828265]   alloc kstat_irqs on node -1
[    0.828272] ehci_hcd 0000:00:10.3: PCI INT D -> GSI 21 (level, low) -> IRQ 21
[    0.828284] ehci_hcd 0000:00:10.3: EHCI Host Controller
[    0.828333] ehci_hcd 0000:00:10.3: new USB bus registered, assigned
bus number 2
[    0.828426] ehci_hcd 0000:00:10.3: irq 21, io mem 0xdffffd00
[    0.840009] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00
[    0.840104] usb usb2: configuration #1 chosen from 1 choice
[    0.840139] hub 2-0:1.0: USB hub found
[    0.840154] hub 2-0:1.0: 6 ports detected
[    0.840223] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.840245] uhci_hcd: USB Universal Host Controller Interface driver
[    0.840310]   alloc irq_desc for 18 on node -1
[    0.840313]   alloc kstat_irqs on node -1
[    0.840319] uhci_hcd 0000:00:0b.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.840330] uhci_hcd 0000:00:0b.0: UHCI Host Controller
[    0.840371] uhci_hcd 0000:00:0b.0: new USB bus registered, assigned
bus number 3
[    0.840419] uhci_hcd 0000:00:0b.0: irq 18, io base 0x0000e400
[    0.840545] usb usb3: configuration #1 chosen from 1 choice
[    0.840582] hub 3-0:1.0: USB hub found
[    0.840596] hub 3-0:1.0: 2 ports detected
[    0.840652]   alloc irq_desc for 19 on node -1
[    0.840655]   alloc kstat_irqs on node -1
[    0.840661] uhci_hcd 0000:00:0b.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.840669] uhci_hcd 0000:00:0b.1: UHCI Host Controller
[    0.840718] uhci_hcd 0000:00:0b.1: new USB bus registered, assigned
bus number 4
[    0.840764] uhci_hcd 0000:00:0b.1: irq 19, io base 0x0000e800
[    0.840897] usb usb4: configuration #1 chosen from 1 choice
[    0.840933] hub 4-0:1.0: USB hub found
[    0.840947] hub 4-0:1.0: 2 ports detected
[    0.841005] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.841013] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    0.841062] uhci_hcd 0000:00:10.0: new USB bus registered, assigned
bus number 5
[    0.841084] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
[    0.841199] usb usb5: configuration #1 chosen from 1 choice
[    0.841241] hub 5-0:1.0: USB hub found
[    0.841255] hub 5-0:1.0: 2 ports detected
[    0.841319] uhci_hcd 0000:00:10.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.841327] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    0.841369] uhci_hcd 0000:00:10.1: new USB bus registered, assigned
bus number 6
[    0.841391] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
[    0.841514] usb usb6: configuration #1 chosen from 1 choice
[    0.841558] hub 6-0:1.0: USB hub found
[    0.841572] hub 6-0:1.0: 2 ports detected
[    0.841643] uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
[    0.841651] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    0.841700] uhci_hcd 0000:00:10.2: new USB bus registered, assigned
bus number 7
[    0.841723] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000dc00
[    0.841835] usb usb7: configuration #1 chosen from 1 choice
[    0.841870] hub 7-0:1.0: USB hub found
[    0.841884] hub 7-0:1.0: 2 ports detected
[    0.842015] PNP: No PS/2 controller found. Probing ports directly.
[    0.842405] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.842415] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.842500] mice: PS/2 mouse device common for all mice
[    0.842656] rtc_cmos 00:03: RTC can wake from S4
[    0.842713] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.842762] rtc0: alarms up to one year, y3k, 114 bytes nvram
[    0.842863] device-mapper: uevent: version 1.0.3
[    0.843026] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
initialised: dm-devel@redhat.com
[    0.843161] device-mapper: multipath: version 1.1.0 loaded
[    0.843166] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.843340] EISA: Probing bus 0 at eisa.0
[    0.843381] EISA: Detected 0 cards.
[    0.843468] cpuidle: using governor ladder
[    0.843472] cpuidle: using governor menu
[    0.844196] TCP cubic registered
[    0.844404] NET: Registered protocol family 10
[    0.845016] lo: Disabled Privacy Extensions
[    0.845457] NET: Registered protocol family 17
[    0.845483] Bluetooth: L2CAP ver 2.13
[    0.845486] Bluetooth: L2CAP socket layer initialized
[    0.845491] Bluetooth: SCO (Voice Link) ver 0.6
[    0.845493] Bluetooth: SCO socket layer initialized
[    0.845542] Bluetooth: RFCOMM TTY layer initialized
[    0.845547] Bluetooth: RFCOMM socket layer initialized
[    0.845550] Bluetooth: RFCOMM ver 1.11
[    0.845569] powernow-k8: Processor cpuid 6a0 not supported
[    0.845603] Using IPI No-Shortcut mode
[    0.845692] PM: Resume from disk failed.
[    0.845725] registered taskstats version 1
[    0.845875]   Magic number: 1:23:820
[    0.846027] rtc_cmos 00:03: setting system clock to 2009-11-09
05:49:48 UTC (1257745788)
[    0.846032] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.846035] EDD information not available.
[    0.988463] ata1.00: ATA-6: SAMSUNG SV2042H, PK100-16, max UDMA/100
[    0.988467] ata1.00: 39865392 sectors, multi 16: LBA
[    0.989830] ata1.01: ATA-6: WDC WD2000JB-55GVA0, 08.02D08, max UDMA/100
[    0.989834] ata1.01: 390721968 sectors, multi 16: LBA48
[    0.989863] ata1.00: limited to UDMA/33 due to 40-wire cable
[    0.989867] ata1.01: limited to UDMA/33 due to 40-wire cable
[    0.996313] ata1.00: configured for UDMA/33
[    1.013534] ata1.01: configured for UDMA/33
[    1.013734] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
SV2042H  PK10 PQ: 0 ANSI: 5
[    1.013915] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.014008] scsi 0:0:1:0: Direct-Access     ATA      WDC
WD2000JB-55G 08.0 PQ: 0 ANSI: 5
[    1.014149] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    1.014211] sd 0:0:0:0: [sda] 39865392 512-byte logical blocks:
(20.4 GB/19.0 GiB)
[    1.014288] sd 0:0:0:0: [sda] Write Protect is off
[    1.014293] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.014333] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.014541]  sda: sda1 sda2 < sda5 >
[    1.055787] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.055801] sd 0:0:1:0: [sdb] 390721968 512-byte logical blocks:
(200 GB/186 GiB)
[    1.055871] sd 0:0:1:0: [sdb] Write Protect is off
[    1.055876] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.055913] sd 0:0:1:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.056096]  sdb: sdb1
[    1.084626] sd 0:0:1:0: [sdb] Attached SCSI disk
[    1.140014] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    1.176377] ata2.00: ATAPI: IOMEGA  CDRW64896INT-B, 6OS2, max UDMA/33
[    1.192246] ata2.00: configured for UDMA/33
[    1.205379] scsi 1:0:0:0: CD-ROM            IOMEGA   CDRW64896INT-B
  6OS2 PQ: 0 ANSI: 5
[    1.254069] sr0: scsi3-mmc drive: 186x/52x writer cd/rw xa/form2 cdda tray
[    1.254074] Uniform CD-ROM driver Revision: 3.20
[    1.254183] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.254250] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    1.254287] Freeing unused kernel memory: 540k freed
[    1.255204] Write protecting the kernel text: 4568k
[    1.255247] Write protecting the kernel read-only data: 1836k
[    1.292174] usb 1-1: configuration #1 chosen from 1 choice
[    1.416810] usb 1-2: new high speed USB device using ehci_hcd and address 3
[    1.478001] 8139too Fast Ethernet driver 0.9.28
[    1.478075] 8139too 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.479241] eth0: RealTek RTL8139 at 0xec00, 00:00:e8:82:18:f8, IRQ 19
[    1.537662] Linux agpgart interface v0.103
[    1.541335] agpgart: Detected VIA KT400/KT400A/KT600 chipset
[    1.553914] Floppy drive(s): fd0 is 1.44M
[    1.561674] usb 1-2: configuration #1 chosen from 1 choice
[    1.579259] FDC 0 is a post-1991 82077
[    1.677024] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[    1.884095] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    2.061780] usb 7-1: configuration #1 chosen from 1 choice
[    2.076501] usbcore: registered new interface driver hiddev
[    2.076659] usbcore: registered new interface driver usbhid
[    2.076663] usbhid: v2.6:USB HID core driver
[    2.096294] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:10.2/usb7/7-1/7-1:1.0/input/input4
[    2.096425] logitech 0003:046D:C512.0001: input,hidraw0: USB HID
v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:10.2-1/input0
[    2.130561] input: Logitech USB Receiver as
/devices/pci0000:00/0000:00:10.2/usb7/7-1/7-1:1.1/input/input5
[    2.130708] logitech 0003:046D:C512.0002: input,hidraw1: USB HID
v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:10.2-1/input1
[    3.500231] PM: Starting manual resume from disk
[    3.500238] PM: Resume from partition 8:5
[    3.500241] PM: Checking hibernation image.
[    3.500589] PM: Resume from disk failed.
[    3.542153] EXT4-fs (sda1): barriers enabled
[    3.568667] kjournald2 starting: pid 323, dev sda1:8, commit
interval 5 seconds
[    3.568686] EXT4-fs (sda1): delayed allocation enabled
[    3.568691] EXT4-fs: file extents enabled
[    3.571717] EXT4-fs: mballoc enabled
[    3.571740] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    4.530237] type=1505 audit(1257745792.181:2):
operation="profile_load" pid=346 name=/sbin/dhclient3
[    4.530642] type=1505 audit(1257745792.181:3):
operation="profile_load" pid=346
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[    4.530876] type=1505 audit(1257745792.181:4):
operation="profile_load" pid=346
name=/usr/lib/connman/scripts/dhclient-script
[    4.597037] type=1505 audit(1257745792.249:5):
operation="profile_load" pid=347 name=/usr/bin/evince
[    4.604396] type=1505 audit(1257745792.257:6):
operation="profile_load" pid=347 name=/usr/bin/evince-previewer
[    4.608709] type=1505 audit(1257745792.261:7):
operation="profile_load" pid=347 name=/usr/bin/evince-thumbnailer
[    4.627063] type=1505 audit(1257745792.277:8):
operation="profile_load" pid=349 name=/usr/sbin/tcpdump
[    5.805520] Adding 1373516k swap on /dev/sda5.  Priority:-1
extents:1 across:1373516k
[    6.436717] EXT4-fs (sda1): internal journal on sda1:8
[    7.717318] JFS: nTxBlock = 8020, nTxLock = 64160
[    7.795030] RPC: Registered udp transport module.
[    7.795035] RPC: Registered tcp transport module.
[    8.388451] udev: starting version 147
[    8.937864] type=1505 audit(1257745796.589:9):
operation="profile_replace" pid=622 name=/sbin/dhclient3
[    8.938430] type=1505 audit(1257745796.589:10):
operation="profile_replace" pid=622
name=/usr/lib/NetworkManager/nm-dhcp-client.action
[    8.938668] type=1505 audit(1257745796.589:11):
operation="profile_replace" pid=622
name=/usr/lib/connman/scripts/dhclient-script
[    8.972077] type=1505 audit(1257745796.625:12):
operation="profile_replace" pid=623 name=/usr/bin/evince
[    8.979518] type=1505 audit(1257745796.629:13):
operation="profile_replace" pid=623 name=/usr/bin/evince-previewer
[    8.991972] type=1505 audit(1257745796.641:14):
operation="profile_replace" pid=623 name=/usr/bin/evince-thumbnailer
[    9.001226] type=1505 audit(1257745796.653:15):
operation="profile_replace" pid=625 name=/usr/sbin/tcpdump
[   10.166438] lp: driver loaded but no devices found
[   10.719389] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.747376] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.761826] parport_pc 00:09: reported by Plug and Play ACPI
[   10.761959] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   10.856309] lp0: using parport0 (interrupt-driven).
[   10.899715] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.994772] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital
4' in warm state.
[   10.997449] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   11.026154] DVB: registering new adapter (DViCO FusionHDTV DVB-T
Dual Digital 4)
[   11.059305] ppdev: user-space parallel port driver
[   11.493181] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   11.873020] irda_init()
[   11.873049] NET: Registered protocol family 23
[   12.121289] xc2028 0-0061: creating new instance
[   12.121297] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[   12.130901] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.2/usb1/1-1/input/input6
[   12.130989] dvb-usb: schedule remote query interval to 100 msecs.
[   12.138323] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4
successfully initialized and connected.
[   12.138365] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital
4' in warm state.
[   12.139149] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[   12.169683] DVB: registering new adapter (DViCO FusionHDTV DVB-T
Dual Digital 4)
[   12.220477] cxusb: No IR receiver detected on this device.
[   12.220490] DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
[   12.220734] xc2028 1-0061: creating new instance
[   12.220739] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   12.222910] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4
successfully initialized and connected.
[   12.222986] usbcore: registered new interface driver dvb_usb_cxusb
[   12.654664] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts
with ACPI region SMOV [0x400-0x406]
[   12.654673] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[   12.654684] vt596_smbus: probe of 0000:00:11.0 failed with error -16
[   13.864550] C-Media PCI 0000:00:0c.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   16.638136] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
[   18.317914] svc: failed to register lockdv1 RPC service (errno 97).
[   18.319198] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state
recovery directory
[   18.327620] NFSD: starting 90-second grace period
[   27.032010] eth0: no IPv6 routers present
[   36.625452] usb 1-1: firmware: requesting xc3028-v27.fw
[   37.433205] xc2028 0-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   37.444275] xc2028 0-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[   43.192029] xc2028 0-0061: Loading firmware for type=D2633 DTV7
(90), id 0000000000000000.
[   43.324039] xc2028 0-0061: Loading SCODE for type=SCODE HAS_IF_5260
(60000000), id 0000000000000000.
[   43.636293] usb 1-2: firmware: requesting xc3028-v27.fw
[   43.645190] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   43.656475] xc2028 1-0061: Loading firmware for type=BASE F8MHZ
(3), id 0000000000000000.
[   48.788022] xc2028 1-0061: Loading firmware for type=D2633 DTV7
(90), id 0000000000000000.
[   48.912769] xc2028 1-0061: Loading SCODE for type=SCODE HAS_IF_5260
(60000000), id 0000000000000000.
[  344.425976] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[  344.435837] SGI XFS Quota Management subsystem
[  344.548852] NTFS driver 2.1.29 [Flags: R/O MODULE].
[  344.712243] QNX4 filesystem 0.2.3 registered.
