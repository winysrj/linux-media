Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:42800 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab0AZAJ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 19:09:59 -0500
Subject: Re: [PATCH] [RFC] support for fly dvb duo on medion laptop
From: hermann pitton <hermann-pitton@arcor.de>
To: jpnews13@free.fr
Cc: "tomlohave@gmail.com" <tomlohave@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4B5CB56A.4080709@free.fr>
References: <4B53FCF2.7000303@gmail.com>
	 <1264119876.31090.14.camel@pc07.localdom.local>
	 <4B597186.6000702@gmail.com>  <4B5CB56A.4080709@free.fr>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Jan 2010 01:10:06 +0100
Message-Id: <1264464607.3194.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean Philippe, Thomas and all,

Am Sonntag, den 24.01.2010, 22:02 +0100 schrieb jpnews13:
> Hi everybody and thanks for you reply
> 
> > hermann pitton a écrit : 
> > 
> > hi hermann 
> > 
> > thanks for your reply :) 
> > > Hi. 
> > > 
> > > Am Montag, den 18.01.2010, 07:17 +0100 schrieb
> > > tomlohave@gmail.com: 
> > >   
> > > > Hi list, 
> > > > 
> > > > this patch add support for lifeview fly dvb duo (hybrid card) on
> > > > medion laptop 
> > > > 
> > > > what works : dvb and analogic tv 
> > > > not tested :  svideo, composite, radio (i am not the owner of
> > > > this card) 
> > > > 
> > > > this card uses gpio 22 for the mode switch between analogic and
> > > > dvb 
> > > > 
> > > > gpio settings  should change when  svideo , composite an radio
> > > > will be tested 
> > > > 
> > > > 
> > > > Cheers, 
> > > > Thomas 
> > > > 
> > > > Signed-off-by : Thomas Genty <tomlohave@gmail.com> 
> > > >     
> > > 
> > > Thomas, 
> > > 
> > > if at all, the special on that card should be, and why it did take
> > > so 
> > > long, that this so called "Duo" has only a single hybrid tuner
> > > against 
> > > all other "DUOs" previously with dual tuners IMHO. 
> > >   
> > jp, can you tell us how is called this card under windows ? is it
> > really named duo or not ? 

> In windows, the name of this card is "FlyDVB-T Duo mini", you can see
> it on the screenshot

Thanks, seems we see a first breakage of naming rules on LifeView.

> > > For what, within the current functions now, you need .i2c_gate
> > > = 0x4b ? 
> > >   
> > copy paste too fast when searching for good settings 
> > Will test without this. 
> > > Please provide output with i2c_debug=1, already previously asked
> > > for, 
> > > to get a better idea about this hardware. 
> > >   
> > attached. But this output is _before_ the use of gpio 22 for the
> > mode switch 
> > (many errors on log ..). i haven't got  a more recent one. 
> > 
> > Jp, can you send us a more recent dmesg output with the latest
> > modifications, please ? 
> 
> I send You the recent dmesg output whit the latest modifications. the
> name is dmesg20100124.txt
> > 
> > and regspy log attached too with this tests : (in french) 

For what he have now, without any physical inspection of the device,
caused by the huge RF shielding around it, and it is likely close to
impossible to remove that shielding under average and even more than
good conditions, without to destroy the device, it looks not bad.

> > state 0 démarrage de regspy 
> > state 1 demarrage de powercinema(logiciel qui fait fonctionner ma
> > carte avec l'initial source(DVB-T) state 2 selection de la source
> > Analogique 
> > state 3 selection de la source Numerique(DVB) 
> > state 4 selection de la source Analogique (2ème essai) 
> > state 5 selection de la source Numerique (2ème essai) 
> > state 6 log après fermeture de powercinema 

So gpio 22 is clearly involved and without i2c gate control the tuner
does not show up.

> > 
> > > Cheers, 
> > > Hermann 
> > >   
> > Cheers, 
> > Thomas 
> For the another input (Svideo and composite) on my PC, the S-video and
> composite connectors input are same, if I want to use S-video, I must
> use with adapter S-video and If I want to use composite (RCA), I must
> use a adapter RCA, I have just adapter composite (RCA) then I have
> tested composite whit my camera, just pictures and video, not sound,
> when I plug my camera and I switch on composite on Tvtime, I can see
> the picture in my camera, it's ok.
> 
> I must to buy a cable to test with Portable DVD Player in composite
> with video and sound? I send you the result.

If it has analog audio in at all, you will get it to work and the
S-Video vmux is most likely already right. Analog audio is for both,
Composite and S-Video in, the same.

Try to test on the radio stuff too.

We need to run finally "make checkpatch" on it, to catch some coding
stile stuff, we are asked to watch out for.

Stick with Thomas on it for now and any better comments you can get on
it.

Cheers,
Hermann

> Cheers,
> Jean Philippe 
> einfaches Textdokument-Anlage (dmesg20100124.txt)
> [    0.000000] BIOS EBDA/lowmem at: 0009f800/0009f800
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.28-17-generic (buildd@rothera) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #58-Ubuntu SMP Tue Dec 1 18:57:07 UTC 2009 (Ubuntu 2.6.28-17.58-generic)
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   NSC Geode by NSC
> [    0.000000]   Cyrix CyrixInstead
> [    0.000000]   Centaur CentaurHauls
> [    0.000000]   Transmeta GenuineTMx86
> [    0.000000]   Transmeta TransmetaCPU
> [    0.000000]   UMC UMC UMC UMC
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000dc000 - 00000000000e4000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003fe80000 (usable)
> [    0.000000]  BIOS-e820: 000000003fe80000 - 000000003fe91000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003fe91000 - 000000003ff00000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0006000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000] DMI present.
> [    0.000000] last_pfn = 0x3fe80 max_arch_pfn = 0x100000
> [    0.000000] Scanning 2 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
> [    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
> [    0.000000]  modified: 0000000000006000 - 0000000000007000 (usable)
> [    0.000000]  modified: 0000000000007000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 0000000000092800 (usable)
> [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000dc000 - 00000000000e4000 (reserved)
> [    0.000000]  modified: 00000000000e8000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 000000003fe80000 (usable)
> [    0.000000]  modified: 000000003fe80000 - 000000003fe91000 (ACPI data)
> [    0.000000]  modified: 000000003fe91000 - 000000003ff00000 (ACPI NVS)
> [    0.000000]  modified: 000000003ff00000 - 0000000040000000 (reserved)
> [    0.000000]  modified: 00000000e0000000 - 00000000f0006000 (reserved)
> [    0.000000]  modified: 00000000f0008000 - 00000000f000c000 (reserved)
> [    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
> [    0.000000]  modified: 00000000ff000000 - 0000000100000000 (reserved)
> [    0.000000] kernel direct mapping tables up to 373fe000 @ 10000-16000
> [    0.000000] RAMDISK: 378ba000 - 37fef705
> [    0.000000] Allocated new RAMDISK: 0087d000 - 00fb2705
> [    0.000000] Move RAMDISK from 00000000378ba000 - 0000000037fef704 to 0087d000 - 00fb2704
> [    0.000000] ACPI: RSDP 000F6E50, 0014 (r0 PTLTD )
> [    0.000000] ACPI: RSDT 3FE8AE02, 0048 (r1 PTLTD  Ohlone00  6040000  LTP        0)
> [    0.000000] ACPI: FACP 3FE90E88, 0074 (r1 INTEL  ALVISO    6040000 LOHR       5F)
> [    0.000000] ACPI: DSDT 3FE8C36B, 4B1D (r1 INTEL  ALVISO    6040000 INTL 20030224)
> [    0.000000] ACPI: FACS 3FEA1FC0, 0040
> [    0.000000] ACPI: APIC 3FE90EFC, 0068 (r1 INTEL  ALVISO    6040000 LOHR       5F)
> [    0.000000] ACPI: BOOT 3FE90FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
> [    0.000000] ACPI: MCFG 3FE90F9C, 003C (r1 INTEL  ALVISO    6040000 LOHR       5F)
> [    0.000000] ACPI: SSDT 3FE8BD18, 064F (r1 SataRe  SataPri     1000 INTL 20030224)
> [    0.000000] ACPI: SSDT 3FE8B686, 0692 (r1 SataRe  SataSec     1000 INTL 20030224)
> [    0.000000] ACPI: SSDT 3FE8B241, 0235 (r1  PmRef  Cpu0Ist     3000 INTL 20030224)
> [    0.000000] ACPI: SSDT 3FE8B063, 01DE (r1  PmRef  Cpu0Cst     3001 INTL 20030224)
> [    0.000000] ACPI: SSDT 3FE8AE4A, 0219 (r1  PmRef    CpuPm     3000 INTL 20030224)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] 138MB HIGHMEM available.
> [    0.000000] 883MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 373fe000
> [    0.000000]   low ram: 00000000 - 373fe000
> [    0.000000]   bootmap 00012000 - 00018e80
> [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
> [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
> [    0.000000]   #3 [0000100000 - 00008780ac]    TEXT DATA BSS ==> [0000100000 - 00008780ac]
> [    0.000000]   #4 [0000879000 - 000087d000]    INIT_PG_TABLE ==> [0000879000 - 000087d000]
> [    0.000000]   #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
> [    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
> [    0.000000]   #7 [000087d000 - 0000fb2705]      NEW RAMDISK ==> [000087d000 - 0000fb2705]
> [    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000373fe
> [    0.000000]   HighMem  0x000373fe -> 0x0003fe80
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[4] active PFN ranges
> [    0.000000]     0: 0x00000000 -> 0x00000002
> [    0.000000]     0: 0x00000006 -> 0x00000007
> [    0.000000]     0: 0x00000010 -> 0x00000092
> [    0.000000]     0: 0x00000100 -> 0x0003fe80
> [    0.000000] On node 0 totalpages: 261637
> [    0.000000] free_area_init_node: node 0, pgdat c06cb780, node_mem_map c1000000
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3941 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1736 pages used for memmap
> [    0.000000]   Normal zone: 220470 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 278 pages used for memmap
> [    0.000000]   HighMem zone: 35180 pages, LIFO batch:7
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
> [    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
> [    0.000000] PM: Registered nosave memory: 0000000000007000 - 0000000000010000
> [    0.000000] PM: Registered nosave memory: 0000000000092000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
> [    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000000e4000
> [    0.000000] PM: Registered nosave memory: 00000000000e4000 - 00000000000e8000
> [    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
> [    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
> [    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
> [    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259591
> [    0.000000] Kernel command line: root=UUID=45458f2b-4dcb-43eb-bd3c-4895b0bb88dc ro quiet splash 
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 797.946 MHz processor.
> [    0.004000] Console: colour VGA+ 80x25
> [    0.004000] console [tty0] enabled
> [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.004000] allocated 5235200 bytes of page_cgroup
> [    0.004000] please try cgroup_disable=memory option if you don't want
> [    0.004000] Scanning for low memory corruption every 60 seconds
> [    0.004000] Memory: 1016976k/1047040k available (4116k kernel code, 29296k reserved, 2199k data, 532k init, 141832k highmem)
> [    0.004000] virtual kernel memory layout:
> [    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
> [    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
> [    0.004000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
> [    0.004000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
> [    0.004000]       .init : 0xc0733000 - 0xc07b8000   ( 532 kB)
> [    0.004000]       .data : 0xc050525d - 0xc072ae60   (2199 kB)
> [    0.004000]       .text : 0xc0100000 - 0xc050525d   (4116 kB)
> [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.004014] Calibrating delay loop (skipped), value calculated using timer frequency.. 1595.89 BogoMIPS (lpj=3191784)
> [    0.004046] Security Framework initialized
> [    0.004058] SELinux:  Disabled at boot.
> [    0.004095] AppArmor: AppArmor initialized
> [    0.004111] Mount-cache hash table entries: 512
> [    0.004355] Initializing cgroup subsys ns
> [    0.004363] Initializing cgroup subsys cpuacct
> [    0.004369] Initializing cgroup subsys memory
> [    0.004377] Initializing cgroup subsys freezer
> [    0.004403] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.004409] CPU: L2 cache: 2048K
> [    0.004427] Checking 'hlt' instruction... OK.
> [    0.021230] SMP alternatives: switching to UP code
> [    0.264027] ACPI: Core revision 20080926
> [    0.269143] ACPI: Checking initramfs for custom DSDT
> [    1.011539] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    1.051234] CPU0: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
> [    1.052003] Brought up 1 CPUs
> [    1.052003] Total of 1 processors activated (1595.89 BogoMIPS).
> [    1.052003] CPU0 attaching NULL sched-domain.
> [    1.052003] net_namespace: 776 bytes
> [    1.052003] Booting paravirtualized kernel on bare hardware
> [    1.052003] Time: 20:29:38  Date: 01/24/10
> [    1.052003] regulator: core version 0.5
> [    1.052003] NET: Registered protocol family 16
> [    1.052003] EISA bus registered
> [    1.052003] ACPI: bus type pci registered
> [    1.052003] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    1.052003] PCI: MCFG area at e0000000 reserved in E820
> [    1.052003] PCI: Using MMCONFIG for extended config space
> [    1.052003] PCI: Using configuration type 1 for base access
> [    1.053523] ACPI: EC: Look up EC in DSDT
> [    1.059135] ACPI: Interpreter enabled
> [    1.059145] ACPI: (supports S0 S3 S4 S5)
> [    1.059184] ACPI: Using IOAPIC for interrupt routing
> [    1.059866] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    1.069615] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    1.069621] ACPI: EC: driver started in interrupt mode
> [    1.069936] ACPI: No dock devices found.
> [    1.069958] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    1.070102] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    1.070109] pci 0000:00:01.0: PME# disabled
> [    1.070187] pci 0000:00:1b.0: reg 10 64bit mmio: [0x80000000-0x80003fff]
> [    1.070224] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    1.070231] pci 0000:00:1b.0: PME# disabled
> [    1.070288] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    1.070295] pci 0000:00:1c.0: PME# disabled
> [    1.070356] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
> [    1.070414] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
> [    1.070471] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
> [    1.070536] pci 0000:00:1d.7: reg 10 32bit mmio: [0x80004000-0x800043ff]
> [    1.070583] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
> [    1.070590] pci 0000:00:1d.7: PME# disabled
> [    1.070720] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
> [    1.070730] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> [    1.070738] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
> [    1.070774] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
> [    1.070783] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
> [    1.070793] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
> [    1.070802] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
> [    1.070812] pci 0000:00:1f.2: reg 20 io port: [0x1870-0x187f]
> [    1.070835] pci 0000:00:1f.2: PME# supported from D3hot
> [    1.070842] pci 0000:00:1f.2: PME# disabled
> [    1.070895] pci 0000:00:1f.3: reg 20 io port: [0x18a0-0x18bf]
> [    1.070974] pci 0000:01:00.0: reg 10 32bit mmio: [0xa0000000-0xa0ffffff]
> [    1.070992] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
> [    1.071010] pci 0000:01:00.0: reg 1c 64bit mmio: [0x90000000-0x90ffffff]
> [    1.071029] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
> [    1.071099] pci 0000:00:01.0: bridge 32bit mmio: [0x90000000-0xafffffff]
> [    1.071106] pci 0000:00:01.0: bridge 32bit mmio pref: [0xc0000000-0xcfffffff]
> [    1.071180] pci 0000:02:00.0: reg 10 64bit mmio: [0xb0000000-0xb0003fff]
> [    1.071192] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
> [    1.071237] pci 0000:02:00.0: supports D1 D2
> [    1.071241] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.071250] pci 0000:02:00.0: PME# disabled
> [    1.071301] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
> [    1.071309] pci 0000:00:1c.0: bridge 32bit mmio: [0xb0000000-0xb3ffffff]
> [    1.071320] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xd0000000-0xd3ffffff]
> [    1.071371] pci 0000:06:02.0: reg 10 32bit mmio: [0x000000-0x000fff]
> [    1.071386] pci 0000:06:02.0: supports D1 D2
> [    1.071391] pci 0000:06:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    1.071398] pci 0000:06:02.0: PME# disabled
> [    1.071443] pci 0000:06:02.2: reg 10 32bit mmio: [0xb4006000-0xb40067ff]
> [    1.071455] pci 0000:06:02.2: reg 14 32bit mmio: [0xb4000000-0xb4003fff]
> [    1.071502] pci 0000:06:02.2: supports D1 D2
> [    1.071507] pci 0000:06:02.2: PME# supported from D0 D1 D2 D3hot
> [    1.071514] pci 0000:06:02.2: PME# disabled
> [    1.071557] pci 0000:06:02.3: reg 10 32bit mmio: [0xb4004000-0xb4005fff]
> [    1.071605] pci 0000:06:02.3: supports D1 D2
> [    1.071610] pci 0000:06:02.3: PME# supported from D0 D1 D2 D3hot
> [    1.071617] pci 0000:06:02.3: PME# disabled
> [    1.071660] pci 0000:06:02.4: reg 10 32bit mmio: [0xb4007000-0xb40070ff]
> [    1.071671] pci 0000:06:02.4: reg 14 32bit mmio: [0xb4006c00-0xb4006cff]
> [    1.071683] pci 0000:06:02.4: reg 18 32bit mmio: [0xb4006800-0xb40068ff]
> [    1.071720] pci 0000:06:02.4: supports D1 D2
> [    1.071725] pci 0000:06:02.4: PME# supported from D0 D1 D2 D3hot
> [    1.071732] pci 0000:06:02.4: PME# disabled
> [    1.071779] pci 0000:06:03.0: reg 10 32bit mmio: [0xb4007800-0xb4007fff]
> [    1.071827] pci 0000:06:03.0: supports D1 D2
> [    1.071876] pci 0000:06:08.0: reg 10 32bit mmio: [0xb4008000-0xb4008fff]
> [    1.071926] pci 0000:06:08.0: PME# supported from D0 D3hot D3cold
> [    1.071934] pci 0000:06:08.0: PME# disabled
> [    1.071977] pci 0000:00:1e.0: transparent bridge
> [    1.071986] pci 0000:00:1e.0: bridge 32bit mmio: [0xb4000000-0xb40fffff]
> [    1.072038] bus 00 -> node 0
> [    1.072053] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    1.072852] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
> [    1.073176] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    1.073522] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> [    1.084121] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 6 7 10) *4
> [    1.084355] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> [    1.084589] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
> [    1.084821] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
> [    1.085053] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> [    1.085287] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    1.085518] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> [    1.085751] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    1.086232] ACPI: WMI: Mapper loaded
> [    1.086565] SCSI subsystem initialized
> [    1.086640] libata version 3.00 loaded.
> [    1.086732] usbcore: registered new interface driver usbfs
> [    1.086766] usbcore: registered new interface driver hub
> [    1.086819] usbcore: registered new device driver usb
> [    1.087050] PCI: Using ACPI for IRQ routing
> [    1.087215] Bluetooth: Core ver 2.13
> [    1.087215] NET: Registered protocol family 31
> [    1.087215] Bluetooth: HCI device and connection manager initialized
> [    1.087215] Bluetooth: HCI socket layer initialized
> [    1.087215] NET: Registered protocol family 8
> [    1.087215] NET: Registered protocol family 20
> [    1.087215] NetLabel: Initializing
> [    1.087215] NetLabel:  domain hash size = 128
> [    1.087215] NetLabel:  protocols = UNLABELED CIPSOv4
> [    1.087215] NetLabel:  unlabeled traffic allowed by default
> [    1.087215] hpet clockevent registered
> [    1.087215] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
> [    1.087215] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [    1.087215] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> [    1.092113] AppArmor: AppArmor Filesystem Enabled
> [    1.092127] pnp: PnP ACPI init
> [    1.092127] ACPI: bus type pnp registered
> [    1.098522] pnp: PnP ACPI: found 11 devices
> [    1.098527] ACPI: ACPI bus type pnp unregistered
> [    1.098534] PnPBIOS: Disabled by ACPI PNP
> [    1.098552] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
> [    1.098559] system 00:01: iomem range 0xf0000000-0xf0003fff has been reserved
> [    1.098575] system 00:01: iomem range 0xf0004000-0xf0004fff has been reserved
> [    1.098582] system 00:01: iomem range 0xf0005000-0xf0005fff has been reserved
> [    1.098588] system 00:01: iomem range 0xf0008000-0xf000bfff has been reserved
> [    1.098595] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
> [    1.098611] system 00:05: ioport range 0x800-0x80f has been reserved
> [    1.098617] system 00:05: ioport range 0x1000-0x107f has been reserved
> [    1.098623] system 00:05: ioport range 0x1180-0x11bf has been reserved
> [    1.098630] system 00:05: ioport range 0x1640-0x164f has been reserved
> [    1.133541] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> [    1.133546] pci 0000:00:01.0:   IO window: disabled
> [    1.133555] pci 0000:00:01.0:   MEM window: 0x90000000-0xafffffff
> [    1.133562] pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
> [    1.133571] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
> [    1.133578] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
> [    1.133586] pci 0000:00:1c.0:   MEM window: 0xb0000000-0xb3ffffff
> [    1.133594] pci 0000:00:1c.0:   PREFETCH window: 0x000000d0000000-0x000000d3ffffff
> [    1.133613] pci 0000:06:02.0: CardBus bridge, secondary bus 0000:07
> [    1.133619] pci 0000:06:02.0:   IO window: 0x003000-0x0030ff
> [    1.133626] pci 0000:06:02.0:   IO window: 0x003400-0x0034ff
> [    1.133634] pci 0000:06:02.0:   PREFETCH window: 0x50000000-0x53ffffff
> [    1.133643] pci 0000:06:02.0:   MEM window: 0x54000000-0x57ffffff
> [    1.133651] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
> [    1.133657] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
> [    1.133665] pci 0000:00:1e.0:   MEM window: 0xb4000000-0xb40fffff
> [    1.133673] pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00000053ffffff
> [    1.133694] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.133702] pci 0000:00:01.0: setting latency timer to 64
> [    1.133715] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [    1.133722] pci 0000:00:1c.0: setting latency timer to 64
> [    1.133733] pci 0000:00:1e.0: setting latency timer to 64
> [    1.133745] pci 0000:06:02.0: enabling device (0000 -> 0003)
> [    1.133752] pci 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    1.133762] pci 0000:06:02.0: setting latency timer to 64
> [    1.133770] bus: 00 index 0 io port: [0x00-0xffff]
> [    1.133775] bus: 00 index 1 mmio: [0x000000-0xffffffff]
> [    1.133780] bus: 01 index 0 mmio: [0x0-0x0]
> [    1.133786] bus: 01 index 1 mmio: [0x90000000-0xafffffff]
> [    1.133791] bus: 01 index 2 mmio: [0xc0000000-0xcfffffff]
> [    1.133796] bus: 01 index 3 mmio: [0x0-0x0]
> [    1.133801] bus: 02 index 0 io port: [0x2000-0x2fff]
> [    1.133806] bus: 02 index 1 mmio: [0xb0000000-0xb3ffffff]
> [    1.133812] bus: 02 index 2 mmio: [0xd0000000-0xd3ffffff]
> [    1.133816] bus: 02 index 3 mmio: [0x0-0x0]
> [    1.133821] bus: 06 index 0 io port: [0x3000-0x3fff]
> [    1.133827] bus: 06 index 1 mmio: [0xb4000000-0xb40fffff]
> [    1.133832] bus: 06 index 2 mmio: [0x50000000-0x53ffffff]
> [    1.133837] bus: 06 index 3 io port: [0x00-0xffff]
> [    1.133842] bus: 06 index 4 mmio: [0x000000-0xffffffff]
> [    1.133847] bus: 07 index 0 io port: [0x3000-0x30ff]
> [    1.133852] bus: 07 index 1 io port: [0x3400-0x34ff]
> [    1.133858] bus: 07 index 2 mmio: [0x50000000-0x53ffffff]
> [    1.133863] bus: 07 index 3 mmio: [0x54000000-0x57ffffff]
> [    1.133880] NET: Registered protocol family 2
> [    1.134246] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    1.134764] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    1.135743] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    1.136259] TCP: Hash tables configured (established 131072 bind 65536)
> [    1.136264] TCP reno registered
> [    1.136547] NET: Registered protocol family 1
> [    1.136793] checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
> [    1.864987]  it is
> [    2.640855] Freeing initrd memory: 7381k freed
> [    2.640923] Simple Boot Flag at 0x36 set to 0x1
> [    2.640975] cpufreq: No nForce2 chipset.
> [    2.641269] audit: initializing netlink socket (disabled)
> [    2.641297] type=2000 audit(1264364979.640:1): initialized
> [    2.659409] highmem bounce pool size: 64 pages
> [    2.659420] HugeTLB registered 4 MB page size, pre-allocated 0 pages
> [    2.662492] VFS: Disk quotas dquot_6.5.1
> [    2.662646] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    2.664047] fuse init (API version 7.10)
> [    2.664241] msgmni has been set to 1724
> [    2.664721] alg: No test for stdrng (krng)
> [    2.664746] io scheduler noop registered
> [    2.664751] io scheduler anticipatory registered
> [    2.664756] io scheduler deadline registered
> [    2.664788] io scheduler cfq registered (default)
> [    2.664975] pci 0000:01:00.0: Boot video device
> [    2.706109] pcieport-driver 0000:00:01.0: setting latency timer to 64
> [    2.706158] pcieport-driver 0000:00:01.0: found MSI capability
> [    2.706192] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
> [    2.706208] pci_express 0000:00:01.0:pcie00: allocate port service
> [    2.706240] pci_express 0000:00:01.0:pcie03: allocate port service
> [    2.706317] pcieport-driver 0000:00:1c.0: setting latency timer to 64
> [    2.706358] pcieport-driver 0000:00:1c.0: found MSI capability
> [    2.706389] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
> [    2.706405] pci_express 0000:00:1c.0:pcie00: allocate port service
> [    2.706434] pci_express 0000:00:1c.0:pcie02: allocate port service
> [    2.706462] pci_express 0000:00:1c.0:pcie03: allocate port service
> [    2.706571] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    2.706772] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    2.707442] ACPI: AC Adapter [AC] (on-line)
> [    2.737582] ACPI: Battery Slot [BAT0] (battery present)
> [    2.737731] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    2.737737] ACPI: Power Button (FF) [PWRF]
> [    2.737834] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> [    2.738640] ACPI: Lid Switch [LID0]
> [    2.738746] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
> [    2.738757] ACPI: Power Button (CM) [PWRB]
> [    2.739590] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    2.739651] processor ACPI_CPU:00: registered as cooling_device0
> [    2.739659] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    2.744127] isapnp: Scanning for PnP cards...
> [    3.097982] isapnp: No Plug & Play device found
> [    3.100534] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
> [    3.100701] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    3.102793] brd: module loaded
> [    3.103427] loop: module loaded
> [    3.103578] Fixed MDIO Bus: probed
> [    3.103591] PPP generic driver version 2.4.2
> [    3.103716] input: Macintosh mouse button emulation as /devices/virtual/input/input3
> [    3.103777] Driver 'sd' needs updating - please use bus_type methods
> [    3.103798] Driver 'sr' needs updating - please use bus_type methods
> [    3.103876] ahci 0000:00:1f.2: version 3.0
> [    3.103899] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.103918] ahci 0000:00:1f.2: PCI INT B disabled
> [    3.103926] ahci: probe of 0000:00:1f.2 failed with error -22
> [    3.104019] ata_piix 0000:00:1f.2: version 2.12
> [    3.104030] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.104037] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> [    3.104098] ata_piix 0000:00:1f.2: setting latency timer to 64
> [    3.104220] scsi0 : ata_piix
> [    3.104462] scsi1 : ata_piix
> [    3.106637] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1870 irq 14
> [    3.106644] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1878 irq 15
> [    3.268346] ata1.00: ATA-7: SAMSUNG MP0804H, UE100-14, max UDMA/100
> [    3.268353] ata1.00: 156368016 sectors, multi 16: LBA48 
> [    3.268384] ata1.00: applying bridge limits
> [    3.276389] ata1.00: configured for UDMA/100
> [    3.440509] ata2.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.00, max UDMA/33
> [    3.456518] ata2.00: configured for UDMA/33
> [    3.457056] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MP0804H  UE10 PQ: 0 ANSI: 5
> [    3.457249] sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    3.457285] sd 0:0:0:0: [sda] Write Protect is off
> [    3.457291] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.457347] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.457459] sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80.0 GB/74.5 GiB)
> [    3.457492] sd 0:0:0:0: [sda] Write Protect is off
> [    3.457497] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.457551] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    3.457559]  sda: sda1 sda2 < sda5 sda6 >
> [    3.501288] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.501376] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    3.503274] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  1.00 PQ: 0 ANSI: 5
> [    3.507772] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    3.507779] Uniform CD-ROM driver Revision: 3.20
> [    3.507967] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.508058] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    3.509365] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    3.509397] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    3.509428] ehci_hcd 0000:00:1d.7: setting latency timer to 64
> [    3.509435] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    3.509538] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
> [    3.513474] ehci_hcd 0000:00:1d.7: debug port 1
> [    3.513484] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
> [    3.513507] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x80004000
> [    3.528016] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
> [    3.528140] usb usb1: configuration #1 chosen from 1 choice
> [    3.528202] hub 1-0:1.0: USB hub found
> [    3.528217] hub 1-0:1.0: 6 ports detected
> [    3.528418] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    3.528449] uhci_hcd: USB Universal Host Controller Interface driver
> [    3.528490] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
> [    3.528500] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [    3.528507] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    3.528594] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    3.528624] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001800
> [    3.528772] usb usb2: configuration #1 chosen from 1 choice
> [    3.528825] hub 2-0:1.0: USB hub found
> [    3.528838] hub 2-0:1.0: 2 ports detected
> [    3.528999] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
> [    3.529009] uhci_hcd 0000:00:1d.1: setting latency timer to 64
> [    3.529016] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    3.529097] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
> [    3.529137] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
> [    3.529277] usb usb3: configuration #1 chosen from 1 choice
> [    3.529336] hub 3-0:1.0: USB hub found
> [    3.529349] hub 3-0:1.0: 2 ports detected
> [    3.529504] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
> [    3.529514] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [    3.529521] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    3.529617] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
> [    3.529656] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
> [    3.529805] usb usb4: configuration #1 chosen from 1 choice
> [    3.529858] hub 4-0:1.0: USB hub found
> [    3.529871] hub 4-0:1.0: 2 ports detected
> [    3.530150] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    3.533238] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    3.533248] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    3.533456] mice: PS/2 mouse device common for all mice
> [    3.533761] rtc_cmos 00:06: RTC can wake from S4
> [    3.533827] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> [    3.533859] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    3.533989] device-mapper: uevent: version 1.0.3
> [    3.534176] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
> [    3.534277] device-mapper: multipath: version 1.0.5 loaded
> [    3.534283] device-mapper: multipath round-robin: version 1.0.0 loaded
> [    3.534428] EISA: Probing bus 0 at eisa.0
> [    3.534438] Cannot allocate resource for EISA slot 1
> [    3.534444] Cannot allocate resource for EISA slot 2
> [    3.534449] Cannot allocate resource for EISA slot 3
> [    3.534474] EISA: Detected 0 cards.
> [    3.534606] cpuidle: using governor ladder
> [    3.534738] cpuidle: using governor menu
> [    3.535788] TCP cubic registered
> [    3.536019] NET: Registered protocol family 10
> [    3.536896] lo: Disabled Privacy Extensions
> [    3.537574] NET: Registered protocol family 17
> [    3.537606] Bluetooth: L2CAP ver 2.11
> [    3.537610] Bluetooth: L2CAP socket layer initialized
> [    3.537616] Bluetooth: SCO (Voice Link) ver 0.6
> [    3.537620] Bluetooth: SCO socket layer initialized
> [    3.537667] Bluetooth: RFCOMM socket layer initialized
> [    3.537679] Bluetooth: RFCOMM TTY layer initialized
> [    3.537683] Bluetooth: RFCOMM ver 1.10
> [    3.538154] Marking TSC unstable due to cpufreq changes
> [    3.538173] Using IPI No-Shortcut mode
> [    3.538233] registered taskstats version 1
> [    3.538337]   Magic number: 10:819:498
> [    3.538406] rtc_cmos 00:06: setting system clock to 2010-01-24 20:29:40 UTC (1264364980)
> [    3.538410] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    3.538412] EDD information not available.
> [    3.538686] Freeing unused kernel memory: 532k freed
> [    3.538803] Write protecting the kernel text: 4120k
> [    3.538845] Write protecting the kernel read-only data: 1524k
> [    3.575658] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> [    4.084011] Clocksource tsc unstable (delta = 583399320 ns)
> [    4.222573] sky2 driver version 1.22
> [    4.222624] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    4.222636] sky2 0000:02:00.0: setting latency timer to 64
> [    4.222694] sky2 0000:02:00.0: Yukon-2 FE chip revision 1
> [    4.286362] sky2 0000:02:00.0: Marvell Yukon 88E8036 Fast Ethernet Controller
> [    4.286365]  Part Number: Yukon 88E8036
> [    4.286367]  Engineering Level: Rev. 1.1
> [    4.286369]  Manufacturer: Marvell
> [    4.286424] sky2 0000:02:00.0: irq 2301 for MSI/MSI-X
> [    4.290765] sky2 eth0: addr 00:03:25:24:43:e4
> [    4.322809] ohci1394 0000:06:02.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [    4.372561] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[b4006000-b40067ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> [    5.053721] PM: Starting manual resume from disk
> [    5.053724] PM: Resume from partition 8:5
> [    5.053726] PM: Checking hibernation image.
> [    5.053969] PM: Resume from disk failed.
> [    5.072319] EXT4-fs: barriers enabled
> [    5.090492] kjournald2 starting.  Commit interval 5 seconds
> [    5.090501] EXT4-fs: delayed allocation enabled
> [    5.090503] EXT4-fs: file extents enabled
> [    5.091786] EXT4-fs: mballoc enabled
> [    5.091791] EXT4-fs: mounted filesystem with ordered data mode.
> [    5.708130] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00032521400103ec]
> [   11.418266] udev: starting version 141
> [   11.834894] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/device:02/input/input5
> [   11.837927] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> [   11.838244] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/input/input6
> [   11.841858] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
> [   11.961804] parport_pc 00:08: reported by Plug and Play ACPI
> [   11.961831] parport0: PC-style at 0x378, irq 5 [PCSPP,TRISTATE,EPP]
> [   12.117236] input: PC Speaker as /devices/platform/pcspkr/input/input7
> [   12.280688] synaptics was reset on resume, see synaptics_resume_reset if you have trouble on resume
> [   12.667213] ppdev: user-space parallel port driver
> [   12.684084] Linux agpgart interface v0.103
> [   12.693318] intel_rng: FWH not detected
> [   12.707768] ieee80211_crypt: registered algorithm 'NULL'
> [   12.712310] ieee80211: 802.11 data/management/control stack, git-1.1.13
> [   12.712313] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> [   12.760573] sdhci: Secure Digital Host Controller Interface driver
> [   12.760577] sdhci: Copyright(c) Pierre Ossman
> [   12.770760] sdhci-pci 0000:06:02.4: SDHCI controller found [104c:8034] (rev 0)
> [   12.770777] sdhci-pci 0000:06:02.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   12.770880] mmc0: SDHCI controller on PCI [0000:06:02.4] using PIO
> [   12.770943] mmc1: SDHCI controller on PCI [0000:06:02.4] using PIO
> [   12.771001] mmc2: SDHCI controller on PCI [0000:06:02.4] using PIO
> [   12.921617] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
> [   12.921621] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [   12.921784] ipw2200 0000:06:08.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> [   12.922554] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
> [   12.922604] ipw2200 0000:06:08.0: firmware: requesting ipw2200-bss.fw
> [   13.023552] Linux video capture interface: v2.00
> [   13.165725] ipw2200: Detected geography ZZM (11 802.11bg channels, 0 802.11a channels)
> [   13.165823] yenta_cardbus 0000:06:02.0: CardBus bridge found [161f:203d]
> [   13.165841] yenta_cardbus 0000:06:02.0: Enabling burst memory read transactions
> [   13.165846] yenta_cardbus 0000:06:02.0: Using CSCINT to route CSC interrupts to PCI
> [   13.165849] yenta_cardbus 0000:06:02.0: Routing CardBus interrupts to PCI
> [   13.165854] yenta_cardbus 0000:06:02.0: TI: mfunc 0x00a01002, devctl 0x64
> [   13.175161] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   13.189502] iTCO_vendor_support: vendor-support=0
> [   13.191477] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
> [   13.191613] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
> [   13.191694] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   13.320228] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x6eb1, caps: 0xa04711/0x40a
> [   13.357764] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input8
> [   13.397107] yenta_cardbus 0000:06:02.0: ISA IRQ mask 0x0cd8, PCI irq 16
> [   13.397113] yenta_cardbus 0000:06:02.0: Socket status: 30000006
> [   13.397117] pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #06 to #0a
> [   13.397184] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
> [   13.397189] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x3fff: clean.
> [   13.397434] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge Memory window: 0xb4000000 - 0xb40fffff
> [   13.397438] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
> [   13.398103] tifm_7xx1 0000:06:02.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   13.484961] nvidia: module license 'NVIDIA' taints kernel.
> [   13.744994] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   13.745005] nvidia 0000:01:00.0: setting latency timer to 64
> [   13.745853] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44  Mon Mar 23 14:59:10 PST 2009
> [   13.912244] saa7130/34: v4l2 driver version 0.2.15 loaded
> [   13.912398] saa7134 0000:06:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [   13.912405] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, latency: 181, mmio: 0xb4007800
> [   13.912412] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T DUO Medion [card=176,autodetected]
> [   13.912483] saa7133[0]: board init: gpio is 10000
> [   13.912492] saa7133[0]: gpio: mode=0x0000000 in=0x0010000 out=0x0000000 [pre-init]
> [   13.958623] nf_conntrack version 0.5.0 (16360 buckets, 65440 max)
> [   13.961924] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [   13.961927] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
> [   13.961930] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [   14.025134] saa7133[0]: i2c xfer: < a0 00 >
> [   14.032192] saa7133[0]: i2c xfer: < a1 =68 =51 =07 =03 =54 =20 =1c =00 =43 =43 =a9 =1c =55 =d2 =b2 =92 =00 =00 =62 =08 =ff =20 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =01 =40 =01 =03 =03 =01 =01 =03 =08 =ff =01 =e7 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =24 =00 =c2 =96 =10 =05 =01 =01 =16 =22 =15 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
> [   14.077296] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [   14.077307] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
> [   14.077317] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e7 ff ff ff ff
> [   14.077327] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077336] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 22 15 ff ff ff ff
> [   14.077346] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077355] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077365] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077374] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077384] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077393] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077403] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077412] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077422] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077431] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077441] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   14.077452] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
> [   14.077629] saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
> [   14.077805] saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
> [   14.077981] saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
> [   14.078156] saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
> [   14.078332] saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
> [   14.078508] saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
> [   14.078683] saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
> [   14.078859] saa7133[0]: i2c xfer: < 11 >
> [   14.084027] saa7133[0]: i2c scan: found device @ 0x10  [???]
> [   14.084030] saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
> [   14.084206] saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
> [   14.084381] saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
> [   14.084557] saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
> [   14.084733] saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
> [   14.084908] saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
> [   14.085084] saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
> [   14.085260] saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
> [   14.085436] saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
> [   14.085611] saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
> [   14.085787] saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
> [   14.085963] saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
> [   14.086138] saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
> [   14.086314] saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
> [   14.086490] saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
> [   14.086665] saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
> [   14.086841] saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
> [   14.087017] saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
> [   14.087192] saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
> [   14.087368] saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
> [   14.087544] saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
> [   14.087719] saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
> [   14.087895] saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
> [   14.088073] saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
> [   14.088248] saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
> [   14.088424] saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
> [   14.088600] saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
> [   14.088866] saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
> [   14.089042] saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
> [   14.089218] saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
> [   14.089394] saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
> [   14.089570] saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
> [   14.089745] saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
> [   14.089921] saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
> [   14.090097] saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
> [   14.090272] saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
> [   14.090448] saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
> [   14.090624] saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
> [   14.090799] saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
> [   14.090975] saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
> [   14.091151] saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
> [   14.091326] saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
> [   14.091502] saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
> [   14.091678] saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
> [   14.091853] saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
> [   14.092031] saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
> [   14.092207] saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
> [   14.092382] saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
> [   14.092558] saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
> [   14.092734] saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
> [   14.092909] saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
> [   14.093085] saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
> [   14.093261] saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
> [   14.093436] saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
> [   14.093612] saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
> [   14.093788] saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
> [   14.093964] saa7133[0]: i2c xfer: < 83 ERROR: NO_DEVICE
> [   14.094139] saa7133[0]: i2c xfer: < 85 ERROR: NO_DEVICE
> [   14.094315] saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
> [   14.094491] saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
> [   14.094666] saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
> [   14.094842] saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
> [   14.095018] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
> [   14.095193] saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
> [   14.095369] saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
> [   14.095545] saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
> [   14.095720] saa7133[0]: i2c xfer: < 97 >
> [   14.100017] saa7133[0]: i2c scan: found device @ 0x96  [???]
> [   14.100020] saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
> [   14.100196] saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
> [   14.100372] saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
> [   14.100548] saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
> [   14.100724] saa7133[0]: i2c xfer: < a1 >
> [   14.108018] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [   14.108021] saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
> [   14.108197] saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
> [   14.108373] saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
> [   14.108548] saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
> [   14.108724] saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
> [   14.108900] saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
> [   14.109076] saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
> [   14.109252] saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
> [   14.109429] saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
> [   14.109605] saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
> [   14.109780] saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
> [   14.109956] saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
> [   14.110328] saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
> [   14.110505] saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
> [   14.110681] saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
> [   14.110858] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> [   14.111034] saa7133[0]: i2c xfer: < c3 ERROR: NO_DEVICE
> [   14.111210] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> [   14.111386] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> [   14.111562] saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
> [   14.111738] saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
> [   14.112057] saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
> [   14.112234] saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
> [   14.112410] saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
> [   14.112587] saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
> [   14.112763] saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
> [   14.112939] saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
> [   14.113115] saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
> [   14.113291] saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
> [   14.113467] saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
> [   14.113785] saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
> [   14.113961] saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
> [   14.114138] saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
> [   14.114313] saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
> [   14.114489] saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
> [   14.114665] saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
> [   14.114841] saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
> [   14.115017] saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
> [   14.115337] saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
> [   14.115514] saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
> [   14.115690] saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
> [   14.115866] saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
> [   14.116048] saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
> [   14.116224] saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
> [   14.116432] saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
> [   14.116608] saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
> [   14.116784] saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
> [   14.117105] saa7133[0]: i2c xfer: < 10 3c 33 60 ><6>HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   14.129795] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   14.130449] 
> [   14.166378] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> [   14.166557] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> [   14.166733] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> [   14.166909] saa7133[0]: i2c xfer: < 96 >
> [   14.205989] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
> [   14.207144] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
> [   14.207656] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
> [   14.208084] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
> [   14.208644] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
> [   14.258965] saa7133[0]: i2c xfer: < 96 00 >
> [   14.264026] saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
> [   14.272207] saa7133[0]: i2c xfer: < 96 1f >
> [   14.280153] saa7133[0]: i2c xfer: < 97 =89 >
> [   14.288264] tuner 0-004b: chip found @ 0x96 (saa7133[0])
> [   14.288373] saa7133[0]: i2c xfer: < 96 1f >
> [   14.296158] saa7133[0]: i2c xfer: < 97 =89 >
> [   14.304157] saa7133[0]: i2c xfer: < 96 2f >
> [   14.312156] saa7133[0]: i2c xfer: < 97 =00 >
> [   14.320154] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   14.352154] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> [   14.352330] saa7133[0]: i2c xfer: < c3 =80 >
> [   14.360152] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> [   14.360328] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> [   14.360503] saa7133[0]: i2c xfer: < 96 21 00 >
> [   14.368163] tda829x 0-004b: setting tuner address to 61
> [   14.368166] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   14.400152] saa7133[0]: i2c xfer: < c3 =00 >
> [   14.425317] saa7133[0]: i2c xfer: < c3 =00 >
> [   14.432023] saa7133[0]: i2c xfer: < c2 30 d0 >
> [   14.440155] saa7133[0]: i2c xfer: < 96 21 00 >
> [   14.448156] tda829x 0-004b: type set to tda8290+75
> [   14.448159] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   14.480152] saa7133[0]: i2c xfer: < c2 00 00 00 40 dc 04 af 3f 2a 04 ff 00 00 40 >
> [   14.488154] saa7133[0]: i2c xfer: < 96 21 00 >
> [   14.496157] saa7133[0]: i2c xfer: < 96 20 0b >
> [   14.504157] saa7133[0]: i2c xfer: < 96 30 6f >
> [   14.512158] saa7133[0]: i2c xfer: < 96 01 00 >
> [   14.520153] saa7133[0]: i2c xfer: < 96 02 00 >
> [   14.528155] saa7133[0]: i2c xfer: < 96 00 00 >
> [   14.544154] saa7133[0]: i2c xfer: < 96 01 90 >
> [   14.552153] saa7133[0]: i2c xfer: < 96 28 14 >
> [   14.560155] saa7133[0]: i2c xfer: < 96 0f 88 >
> [   14.568156] saa7133[0]: i2c xfer: < 96 05 04 >
> [   14.576156] saa7133[0]: i2c xfer: < 96 0d 47 >
> [   14.584156] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   14.616153] saa7133[0]: i2c xfer: < c2 00 32 f8 40 52 5b 9f 8f >
> [   14.624154] saa7133[0]: i2c xfer: < c2 80 00 >
> [   14.632157] saa7133[0]: i2c xfer: < c2 60 bf >
> [   14.640154] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   14.656155] saa7133[0]: i2c xfer: < c2 30 56 >
> [   14.672151] saa7133[0]: i2c xfer: < c2 30 52 >
> [   15.236161] saa7133[0]: i2c xfer: < c2 30 50 >
> [   15.244156] saa7133[0]: i2c xfer: < c2 60 3f >
> [   15.252154] saa7133[0]: i2c xfer: < c2 80 08 >
> [   15.260157] saa7133[0]: i2c xfer: < 96 1b >
> [   15.268152] saa7133[0]: i2c xfer: < 97 =4c >
> [   15.380155] saa7133[0]: i2c xfer: < 96 1b >
> [   15.388157] saa7133[0]: i2c xfer: < 97 =45 >
> [   15.500155] saa7133[0]: i2c xfer: < 96 1b >
> [   15.508158] saa7133[0]: i2c xfer: < 97 =40 >
> [   15.620155] saa7133[0]: i2c xfer: < 96 28 64 >
> [   15.732156] saa7133[0]: i2c xfer: < 96 1d >
> [   15.740156] saa7133[0]: i2c xfer: < 97 =ff >
> [   15.748155] saa7133[0]: i2c xfer: < 96 1b >
> [   15.756153] saa7133[0]: i2c xfer: < 97 =4b >
> [   15.764155] saa7133[0]: i2c xfer: < c2 80 0c >
> [   15.876152] saa7133[0]: i2c xfer: < 96 1d >
> [   15.884155] saa7133[0]: i2c xfer: < 97 =cf >
> [   15.892158] saa7133[0]: i2c xfer: < 96 1b >
> [   15.900153] saa7133[0]: i2c xfer: < 97 =49 >
> [   15.908157] saa7133[0]: i2c xfer: < 96 05 01 >
> [   15.916156] saa7133[0]: i2c xfer: < 96 0d 27 >
> [   16.028151] saa7133[0]: i2c xfer: < 96 21 00 >
> [   16.036152] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   16.044164] saa7133[0]: i2c xfer: < 96 01 10 >
> [   16.052156] saa7133[0]: i2c xfer: < 96 02 00 >
> [   16.060156] saa7133[0]: i2c xfer: < 96 00 00 >
> [   16.076151] saa7133[0]: i2c xfer: < 96 01 82 >
> [   16.084155] saa7133[0]: i2c xfer: < 96 28 14 >
> [   16.092154] saa7133[0]: i2c xfer: < 96 0f 88 >
> [   16.100157] saa7133[0]: i2c xfer: < 96 05 04 >
> [   16.108156] saa7133[0]: i2c xfer: < 96 0d 47 >
> [   16.116155] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   16.148154] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
> [   16.156152] saa7133[0]: i2c xfer: < c2 80 00 >
> [   16.164161] saa7133[0]: i2c xfer: < c2 60 bf >
> [   16.172156] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   16.188155] saa7133[0]: i2c xfer: < c2 30 56 >
> [   16.204155] saa7133[0]: i2c xfer: < c2 30 52 >
> [   16.768157] saa7133[0]: i2c xfer: < c2 30 50 >
> [   16.776154] saa7133[0]: i2c xfer: < c2 60 3f >
> [   16.784155] saa7133[0]: i2c xfer: < c2 80 08 >
> [   16.792154] saa7133[0]: i2c xfer: < 96 1b >
> [   16.800151] saa7133[0]: i2c xfer: < 97 =78 >
> [   16.912155] saa7133[0]: i2c xfer: < 96 1b >
> [   16.920152] saa7133[0]: i2c xfer: < 97 =08 >
> [   17.032152] saa7133[0]: i2c xfer: < 96 1b >
> [   17.040152] saa7133[0]: i2c xfer: < 97 =06 >
> [   17.152156] saa7133[0]: i2c xfer: < 96 28 64 >
> [   17.264157] saa7133[0]: i2c xfer: < 96 1d >
> [   17.272156] saa7133[0]: i2c xfer: < 97 =ff >
> [   17.280153] saa7133[0]: i2c xfer: < 96 1b >
> [   17.288155] saa7133[0]: i2c xfer: < 97 =0f >
> [   17.296154] saa7133[0]: i2c xfer: < c2 80 0c >
> [   17.408156] saa7133[0]: i2c xfer: < 96 1d >
> [   17.416155] saa7133[0]: i2c xfer: < 97 =cf >
> [   17.424154] saa7133[0]: i2c xfer: < 96 1b >
> [   17.432151] saa7133[0]: i2c xfer: < 97 =49 >
> [   17.440155] saa7133[0]: i2c xfer: < 96 05 01 >
> [   17.448157] saa7133[0]: i2c xfer: < 96 0d 27 >
> [   17.560155] saa7133[0]: i2c xfer: < 96 21 00 >
> [   17.568154] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   17.576162] saa7133[0]: i2c xfer: < 96 01 02 >
> [   17.584154] saa7133[0]: i2c xfer: < 96 02 00 >
> [   17.592156] saa7133[0]: i2c xfer: < 96 00 00 >
> [   17.608154] saa7133[0]: i2c xfer: < 96 01 82 >
> [   17.616154] saa7133[0]: i2c xfer: < 96 28 14 >
> [   17.624154] saa7133[0]: i2c xfer: < 96 0f 88 >
> [   17.632155] saa7133[0]: i2c xfer: < 96 05 04 >
> [   17.640155] saa7133[0]: i2c xfer: < 96 0d 47 >
> [   17.648157] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   17.680152] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
> [   17.688154] saa7133[0]: i2c xfer: < c2 80 00 >
> [   17.696154] saa7133[0]: i2c xfer: < c2 60 bf >
> [   17.704157] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   17.720153] saa7133[0]: i2c xfer: < c2 30 56 >
> [   17.736155] saa7133[0]: i2c xfer: < c2 30 52 >
> [   18.300157] saa7133[0]: i2c xfer: < c2 30 50 >
> [   18.308155] saa7133[0]: i2c xfer: < c2 60 3f >
> [   18.316154] saa7133[0]: i2c xfer: < c2 80 08 >
> [   18.324155] saa7133[0]: i2c xfer: < 96 1b >
> [   18.332157] saa7133[0]: i2c xfer: < 97 =63 >
> [   18.444156] saa7133[0]: i2c xfer: < 96 1b >
> [   18.452155] saa7133[0]: i2c xfer: < 97 =6f >
> [   18.564159] saa7133[0]: i2c xfer: < 96 1b >
> [   18.572155] saa7133[0]: i2c xfer: < 97 =5d >
> [   18.684155] saa7133[0]: i2c xfer: < 96 28 64 >
> [   18.796156] saa7133[0]: i2c xfer: < 96 1d >
> [   18.804157] saa7133[0]: i2c xfer: < 97 =ff >
> [   18.812156] saa7133[0]: i2c xfer: < 96 1b >
> [   18.820152] saa7133[0]: i2c xfer: < 97 =68 >
> [   18.828155] saa7133[0]: i2c xfer: < c2 80 0c >
> [   18.940154] saa7133[0]: i2c xfer: < 96 1d >
> [   18.948155] saa7133[0]: i2c xfer: < 97 =cf >
> [   18.956154] saa7133[0]: i2c xfer: < 96 1b >
> [   18.964155] saa7133[0]: i2c xfer: < 97 =7d >
> [   18.972158] saa7133[0]: i2c xfer: < 96 05 01 >
> [   18.980153] saa7133[0]: i2c xfer: < 96 0d 27 >
> [   19.092155] saa7133[0]: i2c xfer: < 96 21 00 >
> [   19.100154] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   19.108236] saa7133[0]: gpio: mode=0x0200000 in=0x0010000 out=0x0200000 [Television]
> [   19.108318] saa7133[0]: gpio: mode=0x0200000 in=0x0010000 out=0x0200000 [Television]
> [   19.108483] saa7133[0]: gpio: mode=0x0200000 in=0x0010000 out=0x0200000 [Television]
> [   19.108488] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   19.140153] saa7133[0]: i2c xfer: < c2 30 d0 >
> [   19.148156] saa7133[0]: i2c xfer: < 96 21 00 >
> [   19.156153] saa7133[0]: i2c xfer: < 96 02 20 >
> [   19.164160] saa7133[0]: i2c xfer: < 96 00 02 >
> [   19.172322] saa7133[0]: registered device video0 [v4l2]
> [   19.172425] saa7133[0]: registered device vbi0
> [   19.172539] saa7133[0]: registered device radio0
> [   19.190582] saa7134 ALSA driver for DMA sound loaded
> [   19.190613] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registered as card -2
> [   19.260778] dvb_init() allocating 1 frontend
> [   19.299262] saa7133[0]: i2c xfer: < 10 00 [fe quirk] < 11 =46 >
> [   19.308887] DVB: registering new adapter (saa7133[0])
> [   19.308892] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> [   19.309208] saa7133[0]: i2c xfer: < 10 07 80 >
> [   19.316025] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =ff >
> [   19.324020] saa7133[0]: i2c xfer: < 10 3b fe >
> [   19.332019] saa7133[0]: i2c xfer: < 10 3c 33 ><6>lp0: using parport0 (interrupt-driven).
> [   19.340016] 
> [   19.340021] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =60 >
> [   19.348020] saa7133[0]: i2c xfer: < 10 3d 62 >
> [   19.373936] saa7133[0]: i2c xfer: < 10 2d f0 >
> [   19.380017] tda1004x: setting up plls for 48MHz sampling clock
> [   19.380021] saa7133[0]: i2c xfer: < 10 2f 03 >
> [   19.388214] saa7133[0]: i2c xfer: < 10 30 03 >
> [   19.396327] saa7133[0]: i2c xfer: < 10 3e 72 >
> [   19.404184] saa7133[0]: i2c xfer: < 10 4d 0c >
> [   19.412411] saa7133[0]: i2c xfer: < 10 4e 00 >
> [   19.420284] saa7133[0]: i2c xfer: < 10 31 54 >
> [   19.428408] saa7133[0]: i2c xfer: < 10 32 03 >
> [   19.436019] saa7133[0]: i2c xfer: < 10 33 0c ><6>Adding 979924k swap on /dev/sda5.  Priority:-1 extents:1 across:979924k
> [   19.444320] 
> [   19.444326] saa7133[0]: i2c xfer: < 10 34 30 >
> [   19.452026] saa7133[0]: i2c xfer: < 10 35 c3 >
> [   19.460020] saa7133[0]: i2c xfer: < 10 4d 0d >
> [   19.468114] saa7133[0]: i2c xfer: < 10 4e 55 >
> [   19.600024] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =34 >
> [   19.608008] saa7133[0]: i2c xfer: < 10 37 34 >
> [   19.616008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.632025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.648156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.664154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.680151] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.696152] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.712155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.728154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.744153] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.760154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.776155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.792154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.808157] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.824156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.840153] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.856154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.872157] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.888156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.904155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.920152] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.936153] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.952152] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.968155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   19.984167] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 ><6>EXT4 FS on sda1, internal journal on sda1:8
> [   19.992626] 
> [   20.000019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.016026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.032296] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.048141] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.064067] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.080801] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.096644] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.112031] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.128017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.144017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.160016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.176017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.192012] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.208020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.228010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.244008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.260021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.276017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.292021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.308154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.324154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.340156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.356154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.372154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.388157] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.404157] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.420155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.436153] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.452153] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.468156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.484156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.500154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.516156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.532152] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.548155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.564155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.580157] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.596155] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.612074] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.628024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.644019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.660018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.676016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.692016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.708018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.724019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.740138] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.756017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.772294] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.788019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 ><6>EXT4-fs: barriers enabled
> [   20.796029] 
> [   20.804019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.814731] kjournald2 starting.  Commit interval 5 seconds
> [   20.816148] EXT4 FS on sda6, internal journal on sda6:8
> [   20.816151] EXT4-fs: delayed allocation enabled
> [   20.816153] EXT4-fs: file extents enabled
> [   20.816722] EXT4-fs: mballoc enabled
> [   20.816726] EXT4-fs: mounted filesystem with ordered data mode.
> [   20.820116] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.836729] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.852382] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.868025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.884017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.900017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.916017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.932019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.949052] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.964372] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.980023] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   20.996016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.012020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.028016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.044015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.060016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.080014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.093818] type=1505 audit(1264364998.053:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=2108
> [   21.096301] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.112038] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.128008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.144011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.152919] type=1505 audit(1264364998.113:3): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2112
> [   21.153050] type=1505 audit(1264364998.113:4): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2112
> [   21.153106] type=1505 audit(1264364998.113:5): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2112
> [   21.153155] type=1505 audit(1264364998.113:6): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2112
> [   21.168020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.184018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.200013] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.216017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.232041] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.248017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.264011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.280010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.296007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.312014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =80 >
> [   21.325712] type=1505 audit(1264364998.285:7): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2117
> [   21.325963] type=1505 audit(1264364998.285:8): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2117
> [   21.328935] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =b0 >
> [   21.340027] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
> [   21.348026] saa7133[0]: i2c xfer: < 10 07 80 >
> [   21.356024] saa7133[0]: i2c xfer: < 10 11 67 ><5>type=1505 audit(1264364998.317:9): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2121
> [   21.364356] 
> [   21.364363] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =67 >
> [   21.372055] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =23 >
> [   21.381327] tda1004x: found firmware revision 23 -- ok
> [   21.381332] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
> [   21.388660] saa7133[0]: i2c xfer: < 10 07 80 >
> [   21.396302] saa7133[0]: i2c xfer: < 10 01 87 >
> [   21.405003] saa7133[0]: i2c xfer: < 10 16 88 >
> [   21.412551] saa7133[0]: i2c xfer: < 10 43 02 >
> [   21.422610] saa7133[0]: i2c xfer: < 10 44 70 >
> [   21.428648] saa7133[0]: i2c xfer: < 10 45 08 >
> [   21.438269] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =62 >
> [   21.444016] saa7133[0]: i2c xfer: < 10 3d 62 >
> [   21.452594] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =ff >
> [   21.460542] saa7133[0]: i2c xfer: < 10 3b 7f >
> [   21.468027] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =00 >
> [   21.476018] saa7133[0]: i2c xfer: < 10 3a 00 >
> [   21.484019] saa7133[0]: i2c xfer: < 10 37 38 >
> [   21.492019] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =7f >
> [   21.500630] saa7133[0]: i2c xfer: < 10 3b 79 >
> [   21.508020] saa7133[0]: i2c xfer: < 10 47 00 >
> [   21.516017] saa7133[0]: i2c xfer: < 10 48 ff >
> [   21.524021] saa7133[0]: i2c xfer: < 10 49 00 >
> [   21.532018] saa7133[0]: i2c xfer: < 10 4a ff >
> [   21.540017] saa7133[0]: i2c xfer: < 10 46 12 >
> [   21.548019] saa7133[0]: i2c xfer: < 10 4f 1a >
> [   21.557453] saa7133[0]: i2c xfer: < 10 1e 07 >
> [   21.565625] saa7133[0]: i2c xfer: < 10 1f c0 >
> [   21.572731] saa7133[0]: i2c xfer: < 10 3b ff >
> [   21.580294] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =62 >
> [   21.588489] saa7133[0]: i2c xfer: < 10 3d 68 >
> [   21.596024] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =38 >
> [   21.604019] saa7133[0]: i2c xfer: < 10 37 f8 >
> [   21.612016] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
> [   21.620019] saa7133[0]: i2c xfer: < 10 07 81 >
> [   21.628166] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =81 >
> [   21.636206] saa7133[0]: i2c xfer: < 10 07 83 >
> [   21.668459] saa7133[0]: i2c xfer: < c3 =02 >
> [   21.676018] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =83 >
> [   21.684444] saa7133[0]: i2c xfer: < 10 07 81 >
> [   21.693421] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =81 >
> [   21.700026] saa7133[0]: i2c xfer: < 10 07 83 >
> [   21.732035] saa7133[0]: i2c xfer: < c2 30 d0 >
> [   21.740020] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =83 >
> [   21.750872] saa7133[0]: i2c xfer: < 10 07 81 >
> [   24.120887] saa7133[0]: gpio: mode=0x0600000 in=0x0010000 out=0x0000000 [Radio]
> [   24.120896] saa7133[0]: i2c xfer: < 96 01 02 >
> [   24.129596] saa7133[0]: i2c xfer: < 96 02 00 >
> [   24.136510] saa7133[0]: i2c xfer: < 96 00 00 >
> [   24.144027] saa7133[0]: i2c xfer: < 96 01 01 >
> [   24.152034] saa7133[0]: i2c xfer: < 96 02 00 >
> [   24.160040] saa7133[0]: i2c xfer: < 96 00 00 >
> [   24.169965] saa7133[0]: i2c xfer: < 96 01 02 >
> [   24.178321] saa7133[0]: i2c xfer: < 96 02 00 >
> [   24.184047] saa7133[0]: i2c xfer: < 96 00 00 >
> [   24.194246] saa7133[0]: i2c xfer: < 96 01 81 >
> [   24.201950] saa7133[0]: i2c xfer: < 96 03 48 >
> [   24.208036] saa7133[0]: i2c xfer: < 96 04 04 >
> [   24.216038] saa7133[0]: i2c xfer: < 96 05 04 >
> [   24.224428] saa7133[0]: i2c xfer: < 96 06 10 >
> [   24.232032] saa7133[0]: i2c xfer: < 96 07 00 >
> [   24.240027] saa7133[0]: i2c xfer: < 96 08 00 >
> [   24.248028] saa7133[0]: i2c xfer: < 96 09 80 >
> [   24.256158] saa7133[0]: i2c xfer: < 96 0a da >
> [   24.264156] saa7133[0]: i2c xfer: < 96 0b 4b >
> [   24.272156] saa7133[0]: i2c xfer: < 96 0c 68 >
> [   24.280154] saa7133[0]: i2c xfer: < 96 0d 00 >
> [   24.288154] saa7133[0]: i2c xfer: < 96 14 00 >
> [   24.296154] saa7133[0]: i2c xfer: < 96 13 01 >
> [   24.304157] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   24.312154] saa7133[0]: i2c xfer: < 96 01 82 >
> [   24.320156] saa7133[0]: i2c xfer: < 96 28 14 >
> [   24.328156] saa7133[0]: i2c xfer: < 96 0f 88 >
> [   24.336156] saa7133[0]: i2c xfer: < 96 05 04 >
> [   24.344155] saa7133[0]: i2c xfer: < 96 0d 47 >
> [   24.352154] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   24.360154] saa7133[0]: i2c xfer: < 96 01 82 >
> [   24.368157] saa7133[0]: i2c xfer: < 96 28 14 >
> [   24.376157] saa7133[0]: i2c xfer: < 96 0f 88 >
> [   24.384157] saa7133[0]: i2c xfer: < 96 05 04 >
> [   24.392156] saa7133[0]: i2c xfer: < 96 0d 47 >
> [   24.400155] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   24.408156] saa7133[0]: i2c xfer: < c2 00 2e 80 40 52 d0 9f 8f >
> [   24.416154] saa7133[0]: i2c xfer: < c2 80 00 >
> [   24.424154] saa7133[0]: i2c xfer: < c2 60 bf >
> [   24.432159] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   24.440157] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
> [   24.448157] saa7133[0]: i2c xfer: < c2 80 00 >
> [   24.456156] saa7133[0]: i2c xfer: < c2 60 bf >
> [   24.464155] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   24.472156] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
> [   24.480154] saa7133[0]: i2c xfer: < c2 80 00 >
> [   24.488158] saa7133[0]: i2c xfer: < c2 60 bf >
> [   24.496153] saa7133[0]: i2c xfer: < c2 30 d2 >
> [   24.504158] saa7133[0]: i2c xfer: < c2 30 56 >
> [   24.512159] saa7133[0]: i2c xfer: < c2 30 56 >
> [   24.520157] saa7133[0]: i2c xfer: < c2 30 56 >
> [   24.528157] saa7133[0]: i2c xfer: < c2 30 52 >
> [   24.536158] saa7133[0]: i2c xfer: < c2 30 52 >
> [   24.544156] saa7133[0]: i2c xfer: < c2 30 52 >
> [   25.092157] saa7133[0]: i2c xfer: < c2 30 50 >
> [   25.100156] saa7133[0]: i2c xfer: < c2 60 3f >
> [   25.108020] saa7133[0]: i2c xfer: < c2 80 08 >
> [   25.116019] saa7133[0]: i2c xfer: < 96 1b >
> [   25.124154] saa7133[0]: i2c xfer: < 97 =5b >
> [   25.132155] saa7133[0]: i2c xfer: < c2 30 50 >
> [   25.140157] saa7133[0]: i2c xfer: < c2 60 3f >
> [   25.148157] saa7133[0]: i2c xfer: < c2 80 08 >
> [   25.156156] saa7133[0]: i2c xfer: < 96 1b >
> [   25.164157] saa7133[0]: i2c xfer: < 97 =51 >
> [   25.172156] saa7133[0]: i2c xfer: < c2 30 50 >
> [   25.180154] saa7133[0]: i2c xfer: < c2 60 3f >
> [   25.188153] saa7133[0]: i2c xfer: < c2 80 08 >
> [   25.196153] saa7133[0]: i2c xfer: < 96 1b >
> [   25.204156] saa7133[0]: i2c xfer: < 97 =55 >
> [   25.236156] saa7133[0]: i2c xfer: < 96 1b >
> [   25.244153] saa7133[0]: i2c xfer: < 97 =52 >
> [   25.276158] saa7133[0]: i2c xfer: < 96 1b >
> [   25.284154] saa7133[0]: i2c xfer: < 97 =50 >
> [   25.316155] saa7133[0]: i2c xfer: < 96 1b >
> [   25.324155] saa7133[0]: i2c xfer: < 97 =50 >
> [   25.356156] saa7133[0]: i2c xfer: < 96 1b >
> [   25.364153] saa7133[0]: i2c xfer: < 97 =4b >
> [   25.396154] saa7133[0]: i2c xfer: < 96 1b >
> [   25.404155] saa7133[0]: i2c xfer: < 97 =45 >
> [   25.436156] saa7133[0]: i2c xfer: < 96 1b >
> [   25.444152] saa7133[0]: i2c xfer: < 97 =3e >
> [   25.476155] saa7133[0]: i2c xfer: < 96 21 00 >
> [   25.484154] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   25.492830] saa7133[0]: i2c xfer: < 96 21 c0 >
> [   25.516155] saa7133[0]: i2c xfer: < 96 28 64 >
> [   25.524153] saa7133[0]: i2c xfer: < c2 30 d0 >
> [   25.532156] saa7133[0]: i2c xfer: < 96 21 00 >
> [   25.540156] saa7133[0]: i2c xfer: < 96 02 20 >
> [   25.548155] saa7133[0]: i2c xfer: < 96 00 02 >
> [   25.556389] saa7133[0]: i2c xfer: < 96 28 64 >
> [   25.628158] saa7133[0]: i2c xfer: < 96 1d >
> [   25.636152] saa7133[0]: i2c xfer: < 97 =80 >
> [   25.644153] saa7133[0]: i2c xfer: < 96 1b >
> [   25.652156] saa7133[0]: i2c xfer: < 97 =3e >
> [   25.660157] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
> [   25.668192] saa7133[0]: i2c xfer: < 96 1d >
> [   25.676154] saa7133[0]: i2c xfer: < 97 =80 >
> [   25.684154] saa7133[0]: i2c xfer: < 96 1b >
> [   25.692154] saa7133[0]: i2c xfer: < 97 =3e >
> [   25.700153] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
> [   25.764192] saa7133[0]: i2c xfer: < 96 1d >
> [   25.772151] saa7133[0]: i2c xfer: < 97 =80 >
> [   25.780153] saa7133[0]: i2c xfer: < 96 1b >
> [   25.788156] saa7133[0]: i2c xfer: < 97 =3e >
> [   25.796155] saa7133[0]: i2c xfer: < 96 05 01 >
> [   25.804158] saa7133[0]: i2c xfer: < 96 0d 27 >
> [   25.812156] saa7133[0]: i2c xfer: < 96 1d >
> [   25.820154] saa7133[0]: i2c xfer: < 97 =80 >
> [   25.828153] saa7133[0]: i2c xfer: < 96 1b >
> [   25.836157] saa7133[0]: i2c xfer: < 97 =3e >
> [   25.844156] saa7133[0]: i2c xfer: < 96 05 01 >
> [   25.852156] saa7133[0]: i2c xfer: < 96 0d 27 >
> [   25.916157] saa7133[0]: i2c xfer: < 96 21 00 >
> [   25.924154] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   25.932201] saa7133[0]: gpio: mode=0x0600000 in=0x0010000 out=0x0200000 [Television]
> [   25.964164] saa7133[0]: i2c xfer: < 96 21 00 >
> [   25.972151] saa7133[0]: i2c xfer: < 96 0f 81 >
> [   25.980236] saa7133[0]: gpio: mode=0x0600000 in=0x0010000 out=0x0200000 [Television]
> [   26.094428] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   26.094432] Bluetooth: BNEP filters: protocol multicast
> [   26.145779] Bridge firewalling registered
> [   32.041245] sky2 eth0: enabling interface
> [   32.041490] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   36.602152] saa7133[0]: gpio: mode=0x0600000 in=0x0010000 out=0x0200000 [Television]
> [   41.607518] saa7133[0]: gpio: mode=0x0600000 in=0x0010000 out=0x0200000 [Television]
> [   42.404025] eth1: no IPv6 routers present
> [   53.307381] CPU0 attaching NULL sched-domain.
> [   53.316074] CPU0 attaching NULL sched-domain.
> [   74.185188] ieee80211_crypt: registered algorithm 'CCMP'
> [   74.317113] padlock: VIA PadLock not detected.

