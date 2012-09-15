Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50907 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2IOS3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 14:29:04 -0400
Received: by lbbgj3 with SMTP id gj3so3433096lbb.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 11:29:01 -0700 (PDT)
Message-ID: <5054C8E8.6060507@gmail.com>
Date: Sat, 15 Sep 2012 20:28:56 +0200
From: Anders Thomson <aeriksson2@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
References: <503F4E19.1050700@gmail.com> <20120915133417.27cb82a1@redhat.com> <5054BD53.7060109@gmail.com> <20120915145834.0b763f73@redhat.com>
In-Reply-To: <20120915145834.0b763f73@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-09-15 19:58, Mauro Carvalho Chehab wrote:
> Em Sat, 15 Sep 2012 19:39:31 +0200
> Anders Thomson<aeriksson2@gmail.com>  escreveu:
>
> >  On 2012-09-15 18:34, Mauro Carvalho Chehab wrote:
> >  >  >   $ cat /TV_CARD.diff
> >  >  >   diff --git a/drivers/media/common/tuners/tda8290.c
> >  >  >   b/drivers/media/common/tuners/tda8290.c
> >  >  >   index 064d14c..498cc7b 100644
> >  >  >   --- a/drivers/media/common/tuners/tda8290.c
> >  >  >   +++ b/drivers/media/common/tuners/tda8290.c
> >  >  >   @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >  >  >
> >  >  >                    dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> >  >  >                               priv->i2c_props.adap,&priv->cfg);
> >  >  >   +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new
> >  >  >   0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> >  >  >                    priv->cfg.switch_addr = priv->i2c_props.addr;
> >  >  >   +               priv->cfg.switch_addr = 0xc2 / 2;
> >  >
> >  >  No, this is wrong. The I2C address is passed by the bridge driver or by
> >  >  the tuner_core attachment, being stored at priv->i2c_props.addr.
> >  >
> >  >  What's the driver and card you're using?
> >  >
> >  lspci -vv:
> >  03:06.0 Multimedia controller: Philips Semiconductors
> >  SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
> >           Subsystem: Pinnacle Systems Inc. Device 002f
>
> There are lots of Pinnacle device supported by saa7134 driver. Without its
> PCI ID that's not much we can do.
>
> Also, please post the dmesg showing what happens without and with your patch.
dmesg, vanilla 3.3.8:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.8 (root@tv) (gcc version 4.5.3 (Gentoo 
4.5.3-r2 p1.1, pie-0.4.7) ) #70 SMP PREEMPT Sat Sep 15 20:22:03 CEST 2012
[    0.000000] Command line: root=/dev/sda3 hpet=disable crashkernel=128M
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077ee0000 (usable)
[    0.000000]  BIOS-e820: 0000000077ee0000 - 0000000077ee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077ee3000 - 0000000077ef0000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077ef0000 - 0000000077f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/M2A-VM HDMI, 
BIOS ASUS M2A-VM HDMI ACPI BIOS Revision 2201 10/22/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77ee0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 base 0060000000 mask FFF0000000 write-back
[    0.000000]   3 base 0070000000 mask FFF8000000 write-back
[    0.000000]   4 base 0077F00000 mask FFFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f6560] f6560
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-0000000077ee0000
[    0.000000]  0000000000 - 0077e00000 page 2M
[    0.000000]  0077e00000 - 0077ee0000 page 4k
[    0.000000] kernel direct mapping tables up to 77ee0000 @ 
1fffc000-20000000
[    0.000000] Reserving 128MB of memory at 768MB for crashkernel 
(System RAM: 1918MB)
[    0.000000] ACPI: RSDP 00000000000f8210 00024 (v02 ATI   )
[    0.000000] ACPI: XSDT 0000000077ee3100 00044 (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 0000000077ee8500 000F4 (v03 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 0000000077ee3280 05210 (v01 ATI    ASUSACPI 
00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 0000000077ee0000 00040
[    0.000000] ACPI: SSDT 0000000077ee8740 002CC (v01 PTLTD  POWERNOW 
00000001  LTP 00000001)
[    0.000000] ACPI: MCFG 0000000077ee8b00 0003C (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 0000000077ee8640 00084 (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> 
[ffff880075800000-ffff8800773fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077ee0
[    0.000000] On node 0 totalpages: 491119
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6661 pages used for memmap
[    0.000000]   DMA32 zone: 480475 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 77f00000 (gap: 
77f00000:68100000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880077c00000 s71424 
r8192 d22784 u524288
[    0.000000] pcpu-alloc: s71424 r8192 d22784 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 484397
[    0.000000] Kernel command line: root=/dev/sda3 hpet=disable 
crashkernel=128M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 1066000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1791420k/1964928k available (5100k kernel code, 
452k absent, 173056k reserved, 3466k data, 456k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2799.741 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.002038] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5599.48 BogoMIPS (lpj=2799741)
[    0.002109] pid_max: default: 32768 minimum: 301
[    0.002215] Mount-cache hash table entries: 256
[    0.002390] Initializing cgroup subsys cpuacct
[    0.002426] Initializing cgroup subsys memory
[    0.002474] Initializing cgroup subsys devices
[    0.003003] Initializing cgroup subsys freezer
[    0.003038] Initializing cgroup subsys blkio
[    0.003108] tseg: 0077f00000
[    0.003110] CPU: Physical Processor ID: 0
[    0.003145] CPU: Processor Core ID: 0
[    0.003180] mce: CPU supports 5 MCE banks
[    0.003226] using AMD E400 aware idle routine
[    0.003299] ACPI: Core revision 20120111
[    0.006535] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.016582] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ 
stepping 03
[    0.016998] Performance Events: AMD PMU driver.
[    0.016998] ... version:                0
[    0.016998] ... bit width:              48
[    0.016998] ... generic registers:      4
[    0.016998] ... value mask:             0000ffffffffffff
[    0.016998] ... max period:             00007fffffffffff
[    0.016998] ... fixed-purpose events:   0
[    0.016998] ... event mask:             000000000000000f
[    0.028011] Booting Node   0, Processors  #1
[    0.028073] smpboot cpu 1: start_ip = 9a000
[    0.099087] Brought up 2 CPUs
[    0.099121] Total of 2 processors activated (11198.19 BogoMIPS).
[    0.099618] PM: Registering ACPI NVS region at 77ee0000 (12288 bytes)
[    0.100061] NET: Registered protocol family 16
[    0.100114] node 0 link 0: io port [c000, ffff]
[    0.100114] TOM: 0000000080000000 aka 2048M
[    0.100114] node 0 link 0: mmio [a0000, bffff]
[    0.100114] node 0 link 0: mmio [80000000, dfffffff]
[    0.100114] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.100114] node 0 link 0: mmio [e0000000, e03fffff]
[    0.100114] bus: [00, 03] on node 0 link 0
[    0.100114] bus: 00 index 0 [io  0x0000-0xffff]
[    0.100114] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.100114] bus: 00 index 2 [mem 0x80000000-0xefffffff]
[    0.100114] bus: 00 index 3 [mem 0xf0000000-0xfcffffffff]
[    0.100114] ACPI: bus type pci registered
[    0.100121] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.100121] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.118731] PCI: Using configuration type 1 for base access
[    0.126068] bio: create slab <bio-0> at 0
[    0.126123] ACPI: Added _OSI(Module Device)
[    0.126123] ACPI: Added _OSI(Processor Device)
[    0.126123] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.126125] ACPI: Added _OSI(Processor Aggregator Device)
[    0.127242] ACPI: EC: Look up EC in DSDT
[    0.130804] ACPI: Interpreter enabled
[    0.130842] ACPI: (supports S0 S1 S3 S4 S5)
[    0.131024] ACPI: Using IOAPIC for interrupt routing
[    0.136096] ACPI: No dock devices found.
[    0.136139] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.136238] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.136344] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.136381] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.136418] pci_root PNP0A03:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.136457] pci_root PNP0A03:00: host bridge window [mem 
0x000c0000-0x000dffff]
[    0.136497] pci_root PNP0A03:00: host bridge window [mem 
0x80000000-0xfebfffff]
[    0.137066] PCI host bridge to bus 0000:00
[    0.137066] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.137078] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.137114] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff]
[    0.137150] pci_bus 0000:00: root bus resource [mem 
0x000c0000-0x000dffff]
[    0.137187] pci_bus 0000:00: root bus resource [mem 
0x80000000-0xfebfffff]
[    0.137233] pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
[    0.137262] pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
[    0.137299] pci 0000:00:07.0: [1002:7917] type 1 class 0x000604
[    0.137328] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.137358] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.137377] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.137387] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.137398] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.137408] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.137418] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.137429] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.137450] pci 0000:00:12.0: set SATA to AHCI mode
[    0.137522] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.137536] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.137604] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.137619] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.137687] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.137702] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.137770] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.137784] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.137854] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.137868] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.138040] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.138060] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.138147] pci 0000:00:13.5: supports D1 D2
[    0.138149] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.138174] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.138197] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.138284] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.138298] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.138309] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.138319] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.138329] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.138340] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.138380] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.138403] pci 0000:00:14.2: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.138473] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.138489] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.138567] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.138616] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.138634] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.138647] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.138662] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.138705] pci 0000:01:05.0: [1002:791e] type 0 class 0x000300
[    0.138713] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff 
64bit pref]
[    0.138719] pci 0000:01:05.0: reg 18: [mem 0xfdbe0000-0xfdbeffff 64bit]
[    0.138724] pci 0000:01:05.0: reg 20: [io  0xde00-0xdeff]
[    0.138729] pci 0000:01:05.0: reg 24: [mem 0xfda00000-0xfdafffff]
[    0.138744] pci 0000:01:05.0: supports D1 D2
[    0.138755] pci 0000:01:05.2: [1002:7919] type 0 class 0x000403
[    0.138763] pci 0000:01:05.2: reg 10: [mem 0xfdbfc000-0xfdbfffff 64bit]
[    0.138799] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.138836] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.138839] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.138843] pci 0000:00:01.0:   bridge window [mem 
0xf0000000-0xf7ffffff 64bit pref]
[    0.138883] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.138897] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.138921] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit]
[    0.138950] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.139028] pci 0000:02:00.0: supports D1 D2
[    0.139030] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.139047] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.139094] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.139131] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.139134] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.139138] pci 0000:00:07.0:   bridge window [mem 
0xfdc00000-0xfdcfffff 64bit pref]
[    0.139175] pci 0000:03:06.0: [1131:7133] type 0 class 0x000480
[    0.139200] pci 0000:03:06.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
[    0.139302] pci 0000:03:06.0: supports D1 D2
[    0.139325] pci 0000:03:07.0: [1106:3044] type 0 class 0x000c00
[    0.139348] pci 0000:03:07.0: reg 10: [mem 0xfdefe000-0xfdefe7ff]
[    0.139362] pci 0000:03:07.0: reg 14: [io  0xcf00-0xcf7f]
[    0.139457] pci 0000:03:07.0: supports D2
[    0.139459] pci 0000:03:07.0: PME# supported from D2 D3hot D3cold
[    0.139509] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive 
decode)
[    0.139547] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.139552] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.139556] pci 0000:00:14.4:   bridge window [mem 
0xfdd00000-0xfddfffff pref]
[    0.139559] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.139562] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.139564] pci 0000:00:14.4:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    0.139567] pci 0000:00:14.4:   bridge window [mem 
0x000c0000-0x000dffff] (subtractive decode)
[    0.139570] pci 0000:00:14.4:   bridge window [mem 
0x80000000-0xfebfffff] (subtractive decode)
[    0.139581] pci_bus 0000:00: on NUMA node 0
[    0.139584] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.139730] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.139801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.139828] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.139859]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.139897]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), 
returned control mask: 0x1d
[    0.139936] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.154048] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.154443] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.155085] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.155482] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.155877] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.156289] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.156683] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.157033] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.157418] vgaarb: device added: 
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.157418] vgaarb: loaded
[    0.157418] vgaarb: bridge control possible 0000:01:05.0
[    0.157418] SCSI subsystem initialized
[    0.158009] libata version 3.00 loaded.
[    0.158021] usbcore: registered new interface driver usbfs
[    0.158051] usbcore: registered new interface driver hub
[    0.158051] usbcore: registered new device driver usb
[    0.158051] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.158051] PCI: Using ACPI for IRQ routing
[    0.167908] PCI: pci_cache_line_size set to 64 bytes
[    0.167992] reserve RAM buffer: 000000000009f000 - 000000000009ffff
[    0.167994] reserve RAM buffer: 0000000077ee0000 - 0000000077ffffff
[    0.168064] Bluetooth: Core ver 2.16
[    0.168068] NET: Registered protocol family 31
[    0.168068] Bluetooth: HCI device and connection manager initialized
[    0.168070] Bluetooth: HCI socket layer initialized
[    0.168105] Bluetooth: L2CAP socket layer initialized
[    0.168985] Bluetooth: SCO socket layer initialized
[    0.169090] pnp: PnP ACPI init
[    0.169090] ACPI: bus type pnp registered
[    0.169150] pnp 00:00: [bus 00-ff]
[    0.169153] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.169155] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.169157] pnp 00:00: [io  0x0d00-0xffff window]
[    0.169160] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.169162] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.169165] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.169222] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.169222] pnp 00:01: [io  0x4100-0x411f]
[    0.169222] pnp 00:01: [io  0x0228-0x022f]
[    0.169222] pnp 00:01: [io  0x040b]
[    0.169222] pnp 00:01: [io  0x04d6]
[    0.169222] pnp 00:01: [io  0x0c00-0x0c01]
[    0.169222] pnp 00:01: [io  0x0c14]
[    0.169222] pnp 00:01: [io  0x0c50-0x0c52]
[    0.169222] pnp 00:01: [io  0x0c6c-0x0c6d]
[    0.169222] pnp 00:01: [io  0x0c6f]
[    0.169222] pnp 00:01: [io  0x0cd0-0x0cd1]
[    0.169222] pnp 00:01: [io  0x0cd2-0x0cd3]
[    0.169222] pnp 00:01: [io  0x0cd4-0x0cdf]
[    0.169222] pnp 00:01: [io  0x4000-0x40fe]
[    0.169222] pnp 00:01: [io  0x4210-0x4217]
[    0.169222] pnp 00:01: [io  0x0b10-0x0b1f]
[    0.169222] pnp 00:01: [mem 0x00000000-0x00000fff window]
[    0.169222] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
[    0.169222] pnp 00:01: disabling [mem 0x00000000-0x00000fff window] 
because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.169222] system 00:01: [io  0x4100-0x411f] has been reserved
[    0.169222] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.169985] system 00:01: [io  0x040b] has been reserved
[    0.170022] system 00:01: [io  0x04d6] has been reserved
[    0.170058] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.170094] system 00:01: [io  0x0c14] has been reserved
[    0.170130] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.170166] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.170201] system 00:01: [io  0x0c6f] has been reserved
[    0.170237] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.170273] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.170309] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.170345] system 00:01: [io  0x4000-0x40fe] has been reserved
[    0.170381] system 00:01: [io  0x4210-0x4217] has been reserved
[    0.170417] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.170454] system 00:01: [mem 0xfee00400-0xfee00fff window] has been 
reserved
[    0.170494] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.170587] pnp 00:02: [dma 4]
[    0.170589] pnp 00:02: [io  0x0000-0x000f]
[    0.170592] pnp 00:02: [io  0x0080-0x0090]
[    0.170594] pnp 00:02: [io  0x0094-0x009f]
[    0.170596] pnp 00:02: [io  0x00c0-0x00df]
[    0.170634] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.170634] pnp 00:03: [io  0x0070-0x0073]
[    0.170634] pnp 00:03: [irq 8]
[    0.170634] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.170634] pnp 00:04: [io  0x0061]
[    0.170634] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.170634] pnp 00:05: [io  0x00f0-0x00ff]
[    0.170634] pnp 00:05: [irq 13]
[    0.170634] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.170634] pnp 00:06: [io  0x0010-0x001f]
[    0.170634] pnp 00:06: [io  0x0022-0x003f]
[    0.170634] pnp 00:06: [io  0x0044-0x005f]
[    0.170634] pnp 00:06: [io  0x0062-0x0063]
[    0.170634] pnp 00:06: [io  0x0065-0x006f]
[    0.170634] pnp 00:06: [io  0x0074-0x007f]
[    0.170634] pnp 00:06: [io  0x0091-0x0093]
[    0.170634] pnp 00:06: [io  0x00a2-0x00bf]
[    0.170634] pnp 00:06: [io  0x00e0-0x00ef]
[    0.170634] pnp 00:06: [io  0x04d0-0x04d1]
[    0.170984] pnp 00:06: [io  0x0220-0x0225]
[    0.171042] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.171042] system 00:06: [io  0x0220-0x0225] has been reserved
[    0.171076] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.171200] pnp 00:07: [io  0x03f0-0x03f5]
[    0.171203] pnp 00:07: [io  0x03f7]
[    0.171212] pnp 00:07: [irq 6]
[    0.171214] pnp 00:07: [dma 2]
[    0.171262] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.171262] pnp 00:08: [io  0x03f8-0x03ff]
[    0.171262] pnp 00:08: [irq 4]
[    0.171262] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.171262] pnp 00:09: [io  0x0378-0x037f]
[    0.171265] pnp 00:09: [irq 7]
[    0.171320] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.172084] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.172138] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.172138] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.172162] pnp 00:0b: [mem 0x000cd600-0x000cffff]
[    0.172165] pnp 00:0b: [mem 0x000f0000-0x000f7fff]
[    0.172167] pnp 00:0b: [mem 0x000f8000-0x000fbfff]
[    0.172169] pnp 00:0b: [mem 0x000fc000-0x000fffff]
[    0.172171] pnp 00:0b: [mem 0x77ef0000-0x77feffff]
[    0.172174] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
[    0.172176] pnp 00:0b: [mem 0x77ee0000-0x77efffff]
[    0.172179] pnp 00:0b: [mem 0xffff0000-0xffffffff]
[    0.172181] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.172183] pnp 00:0b: [mem 0x00100000-0x77edffff]
[    0.172185] pnp 00:0b: [mem 0x77ff0000-0x7ffeffff]
[    0.172188] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.172190] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.172192] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
[    0.172259] system 00:0b: [mem 0x000cd600-0x000cffff] has been reserved
[    0.172259] system 00:0b: [mem 0x000f0000-0x000f7fff] could not be 
reserved
[    0.172259] system 00:0b: [mem 0x000f8000-0x000fbfff] could not be 
reserved
[    0.172259] system 00:0b: [mem 0x000fc000-0x000fffff] could not be 
reserved
[    0.172259] system 00:0b: [mem 0x77ef0000-0x77feffff] could not be 
reserved
[    0.172259] system 00:0b: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.172259] system 00:0b: [mem 0x77ee0000-0x77efffff] could not be 
reserved
[    0.172260] system 00:0b: [mem 0xffff0000-0xffffffff] has been reserved
[    0.172297] system 00:0b: [mem 0x00000000-0x0009ffff] could not be 
reserved
[    0.172334] system 00:0b: [mem 0x00100000-0x77edffff] could not be 
reserved
[    0.172371] system 00:0b: [mem 0x77ff0000-0x7ffeffff] could not be 
reserved
[    0.172407] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be 
reserved
[    0.172444] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be 
reserved
[    0.172480] system 00:0b: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.172517] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.172524] pnp: PnP ACPI: found 12 devices
[    0.172984] ACPI: ACPI bus type pnp unregistered
[    0.181330] Switching to clocksource acpi_pm
[    0.181399] PCI: max bus depth: 1 pci_try_num: 2
[    0.181419] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.181455] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.181492] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.181529] pci 0000:00:01.0:   bridge window [mem 
0xf0000000-0xf7ffffff 64bit pref]
[    0.181573] pci 0000:02:00.0: BAR 6: assigned [mem 
0xfdc00000-0xfdc1ffff pref]
[    0.181612] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.181648] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.181684] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.181721] pci 0000:00:07.0:   bridge window [mem 
0xfdc00000-0xfdcfffff 64bit pref]
[    0.181762] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.181799] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.181838] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.181877] pci 0000:00:14.4:   bridge window [mem 
0xfdd00000-0xfddfffff pref]
[    0.181933] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.181935] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.181937] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.181940] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.181943] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfebfffff]
[    0.181945] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.181948] pci_bus 0000:01: resource 1 [mem 0xfda00000-0xfdbfffff]
[    0.181950] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 
64bit pref]
[    0.181953] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.181955] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.181958] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff 
64bit pref]
[    0.181960] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.181963] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.181965] pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff pref]
[    0.181968] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.181970] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.181972] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.181975] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.181977] pci_bus 0000:03: resource 8 [mem 0x80000000-0xfebfffff]
[    0.181977] NET: Registered protocol family 2
[    0.181977] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.182269] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.184768] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.185422] TCP: Hash tables configured (established 262144 bind 65536)
[    0.185459] TCP reno registered
[    0.185497] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.185551] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.185695] NET: Registered protocol family 1
[    0.185858] RPC: Registered named UNIX socket transport module.
[    0.185904] RPC: Registered udp transport module.
[    0.185939] RPC: Registered tcp transport module.
[    0.185973] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.463071] pci 0000:01:05.0: Boot video device
[    0.463083] PCI: CLS 32 bytes, default 64
[    0.463218] kvm: Nested Virtualization enabled
[    0.464192] audit: initializing netlink socket (disabled)
[    0.464241] type=2000 audit(1347733502.464:1): initialized
[    0.465367] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.465695] msgmni has been set to 3498
[    0.466202] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.466245] io scheduler noop registered
[    0.466306] io scheduler cfq registered (default)
[    0.466502] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
[    0.467202] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.467246] ACPI: Power Button [PWRB]
[    0.467394] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.467436] ACPI: Power Button [PWRF]
[    0.467614] ACPI: Fan [FAN] (on)
[    0.469243] ACPI Warning: For \_TZ_.THRM._PSL: Return Package has no 
elements (empty) (20120111/nspredef-463)
[    0.469346] ACPI: [Package] has zero elements (ffff880074b6ae80)
[    0.469381] ACPI: Invalid passive threshold
[    0.469659] thermal LNXTHERM:00: registered as thermal_zone0
[    0.469695] ACPI: Thermal Zone [THRM] (40 C)
[    0.469960] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.490721] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.511850] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.512309] [drm] Initialized drm 1.1.0 20060810
[    0.512402] [drm] radeon defaulting to kernel modesetting.
[    0.512438] [drm] radeon kernel modesetting enabled.
[    0.512724] [drm] initializing kernel modesetting (RS690 
0x1002:0x791E 0x1043:0x826D).
[    0.512780] [drm] register mmio base: 0xFDBE0000
[    0.512814] [drm] register mmio size: 65536
[    0.514392] ATOM BIOS: ATI
[    0.514444] radeon 0000:01:05.0: VRAM: 128M 0x0000000078000000 - 
0x000000007FFFFFFF (128M used)
[    0.514486] radeon 0000:01:05.0: GTT: 512M 0x0000000080000000 - 
0x000000009FFFFFFF
[    0.514526] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.514562] [drm] Driver supports precise vblank timestamp query.
[    0.514623] [drm] radeon: irq initialized.
[    0.515278] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.515318] [drm] RAM width 128bits DDR
[    0.515437] [TTM] Zone  kernel: Available graphics memory: 895710 kiB.
[    0.515477] [TTM] Initializing pool allocator.
[    0.515519] [TTM] Initializing DMA pool allocator.
[    0.515583] [drm] radeon: 128M of VRAM memory ready
[    0.515618] [drm] radeon: 512M of GTT memory ready.
[    0.515655] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.522364] [drm] radeon: ib pool ready.
[    0.523410] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    0.529504] [drm] PCIE GART of 512M enabled (table at 
0x0000000074680000).
[    0.529559] radeon 0000:01:05.0: WB enabled
[    0.529595] [drm] fence driver on ring 0 use gpu addr 0x80000000 and 
cpu addr 0xffff8800744c8000
[    0.529754] [drm] Loading RS690/RS740 Microcode
[    0.529971] [drm] radeon: ring at 0x0000000080001000
[    0.530031] [drm] ring test succeeded in 1 usecs
[    0.530178] [drm] ib test succeeded in 0 usecs
[    0.530978] [drm] Radeon Display Connectors
[    0.531023] [drm] Connector 0:
[    0.531058] [drm]   VGA
[    0.531092] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 
0x7e5c 0x7e4c
[    0.531130] [drm]   Encoders:
[    0.531164] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    0.531199] [drm] Connector 1:
[    0.531232] [drm]   S-video
[    0.531265] [drm]   Encoders:
[    0.531299] [drm]     TV1: INTERNAL_KLDSCP_DAC1
[    0.531333] [drm] Connector 2:
[    0.531367] [drm]   HDMI-A
[    0.531400] [drm]   HPD2
[    0.531434] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 
0x7e4c 0x7e6c
[    0.531472] [drm]   Encoders:
[    0.531506] [drm]     DFP2: INTERNAL_DDI
[    0.531539] [drm] Connector 3:
[    0.531573] [drm]   DVI-D
[    0.531607] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 
0x7e4c 0x7e5c
[    0.531645] [drm]   Encoders:
[    0.531678] [drm]     DFP3: INTERNAL_LVTM1
[    0.788240] [drm] fb mappable at 0xF0040000
[    0.788275] [drm] vram apper at 0xF0000000
[    0.788309] [drm] size 8294400
[    0.788343] [drm] fb depth is 24
[    0.788376] [drm]    pitch is 7680
[    0.788497] fbcon: radeondrmfb (fb0) is primary device
[    0.816768] Console: switching to colour frame buffer device 240x67
[    0.826047] fb0: radeondrmfb frame buffer device
[    0.826081] drm: registered panic notifier
[    0.826115] [drm] Initialized radeon 2.13.0 20080528 for 0000:01:05.0 
on minor 0
[    0.829054] brd: module loaded
[    0.830587] loop: module loaded
[    0.830669] Uniform Multi-Platform E-IDE driver
[    0.830841] ide-gd driver 1.18
[    0.831164] ahci 0000:00:12.0: version 3.0
[    0.831213] ahci 0000:00:12.0: ASUS M2A-VM: enabling 64bit DMA
[    0.831378] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0xf impl SATA mode
[    0.831442] ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo 
pmp pio slum part ccc
[    0.833119] scsi0 : ahci
[    0.833451] scsi1 : ahci
[    0.833680] scsi2 : ahci
[    0.833903] scsi3 : ahci
[    0.834164] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f100 irq 22
[    0.834221] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f180 irq 22
[    0.834277] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f200 irq 22
[    0.834333] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f280 irq 22
[    0.834643] tun: Universal TUN/TAP device driver, 1.6
[    0.834682] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.834813] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.834948] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    0.835349] r8169 0000:02:00.0: eth0: RTL8168b/8111b at 
0xffffc9000000c000, 00:1b:fc:89:fa:a2, XID 18000000 IRQ 41
[    0.835427] r8169 0000:02:00.0: eth0: jumbo features [frames: 4080 
bytes, tx checksumming: ko]
[    0.835552] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.835624] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    0.835669] ehci_hcd 0000:00:13.5: new USB bus registered, assigned 
bus number 1
[    0.835749] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB 
freeze workaround
[    0.835819] ehci_hcd 0000:00:13.5: debug port 1
[    0.835883] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[    0.841023] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    0.841309] hub 1-0:1.0: USB hub found
[    0.841343] hub 1-0:1.0: 10 ports detected
[    0.841527] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.841596] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.841638] ohci_hcd 0000:00:13.0: new USB bus registered, assigned 
bus number 2
[    0.841726] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    0.896247] hub 2-0:1.0: USB hub found
[    0.896282] hub 2-0:1.0: 2 ports detected
[    0.896386] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.896429] ohci_hcd 0000:00:13.1: new USB bus registered, assigned 
bus number 3
[    0.896515] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    0.951240] hub 3-0:1.0: USB hub found
[    0.953009] hub 3-0:1.0: 2 ports detected
[    0.954826] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    0.956591] ohci_hcd 0000:00:13.2: new USB bus registered, assigned 
bus number 4
[    0.958365] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    1.015242] hub 4-0:1.0: USB hub found
[    1.016984] hub 4-0:1.0: 2 ports detected
[    1.018772] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    1.020537] ohci_hcd 0000:00:13.3: new USB bus registered, assigned 
bus number 5
[    1.022346] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.079252] hub 5-0:1.0: USB hub found
[    1.080925] hub 5-0:1.0: 2 ports detected
[    1.082754] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    1.084523] ohci_hcd 0000:00:13.4: new USB bus registered, assigned 
bus number 6
[    1.086322] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.143028] usb 1-3: new high-speed USB device number 2 using ehci_hcd
[    1.143252] hub 6-0:1.0: USB hub found
[    1.143260] hub 6-0:1.0: 2 ports detected
[    1.143525] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.143978] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.143983] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.144220] mousedev: PS/2 mouse device common for all mice
[    1.144450] k8temp 0000:00:18.3: Temperature readouts might be wrong 
- check erratum #141
[    1.144564] md: linear personality registered for level -1
[    1.158755] device-mapper: uevent: version 1.0.3
[    1.160668] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) 
initialised: dm-devel@redhat.com
[    1.162540] usbcore: registered new interface driver btusb
[    1.164313] cpuidle: using governor ladder
[    1.166130] cpuidle: using governor menu
[    1.168397] ALSA device list:
[    1.170193]   No soundcards found.
[    1.171953] TCP cubic registered
[    1.173781] NET: Registered protocol family 10
[    1.175735] NET: Registered protocol family 17
[    1.177491] Bridge firewalling registered
[    1.179277] Bluetooth: RFCOMM TTY layer initialized
[    1.180977] Bluetooth: RFCOMM socket layer initialized
[    1.182769] Bluetooth: RFCOMM ver 1.11
[    1.184554] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.186338] Bluetooth: BNEP filters: protocol multicast
[    1.188111] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.189953] 8021q: 802.1Q VLAN Support v1.8
[    1.191910] PM: Checking hibernation image partition /dev/sda2
[    1.309022] ata4: softreset failed (device not ready)
[    1.310741] ata4: applying PMP SRST workaround and retrying
[    1.312429] ata3: softreset failed (device not ready)
[    1.314065] ata3: applying PMP SRST workaround and retrying
[    1.315762] ata1: softreset failed (device not ready)
[    1.317498] ata1: applying PMP SRST workaround and retrying
[    1.319217] ata2: softreset failed (device not ready)
[    1.320928] ata2: applying PMP SRST workaround and retrying
[    1.473036] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.474818] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.476574] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.478232] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100
[    1.479949] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.481558] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.483860] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.485565] ata4.00: configured for UDMA/100
[    1.487445] ata2.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    1.489196] ata2.00: 2930277168 sectors, multi 1: LBA48 NCQ (depth 
31/32), AA
[    1.490948] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.496101] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.497742] ata2.00: configured for UDMA/133
[    1.499609] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    1.501364] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 
31/32), AA
[    1.503116] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.504975] ata3.00: ATA-8: WDC WD3200BEVT-00ZCT0, 11.01A11, max UDMA/133
[    1.506724] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 
31/32), AA
[    1.508508] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.510425] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.512150] ata1.00: configured for UDMA/133
[    1.513976] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  
CR10 PQ: 0 ANSI: 5
[    1.514166] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.514168] ata3.00: configured for UDMA/133
[    1.519607] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.521549] scsi 1:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 
01.0 PQ: 0 ANSI: 5
[    1.521559] sd 0:0:0:0: [sda] Write Protect is off
[    1.521562] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.521578] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.527299] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: 
(1.50 TB/1.36 TiB)
[    1.529178] sd 1:0:0:0: [sdb] Write Protect is off
[    1.529275] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-0 
11.0 PQ: 0 ANSI: 5
[    1.529521] sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 
GB/298 GiB)
[    1.529560] sd 2:0:0:0: [sdc] Write Protect is off
[    1.529562] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.529580] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.530467] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  
SB00 PQ: 0 ANSI: 5
[    1.532395] sr0: scsi3-mmc drive: 8x/40x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    1.532397] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.532538] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.541566]  sda: sda1 sda2 sda3 sda4
[    1.545999] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.546031] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.546295] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.560610]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.562828] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.597293]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
[    1.600228] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.602242] PM: Hibernation image partition 8:2 present
[    1.602244] PM: Looking for hibernation image.
[    1.602378] PM: Image not found (code -22)
[    1.602380] PM: Hibernation image not present or could not be loaded.
[    1.602388] registered taskstats version 1
[    1.604688] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.606693] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core 
Processor 5600+ (2 cpu cores) (version 2.20.00)
[    1.608823] powernow-k8: fid 0x14 (2800 MHz), vid 0x8
[    1.610873] powernow-k8: fid 0x12 (2600 MHz), vid 0xa
[    1.612849] powernow-k8: fid 0x10 (2400 MHz), vid 0xc
[    1.614800] powernow-k8: fid 0xe (2200 MHz), vid 0xe
[    1.616810] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    1.618809] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    1.620776] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    1.622869] md: Skipping autodetection of RAID arrays. 
(raid=autodetect will force)
[    1.648118] kjournald starting.  Commit interval 5 seconds
[    1.648148] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    1.648165] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    1.654755] Freeing unused kernel memory: 456k freed
[    1.657047] Write protecting the kernel read-only data: 8192k
[    1.662058] Freeing unused kernel memory: 1024k freed
[    1.673039] usb 3-2: new full-speed USB device number 2 using ohci_hcd
[    2.075047] usb 5-1: new low-speed USB device number 2 using ohci_hcd
[    3.986226] udevd[871]: starting version 171
[    5.003771] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.003859] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.003945] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.004051] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    5.137890] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.166303] rtc_cmos 00:03: RTC can wake from S4
[    5.166425] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.166460] rtc0: alarms up to one month, 242 bytes nvram
[    5.227481] atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
[    5.227511] atiixp 0000:00:14.1: not 100% native mode: will probe 
irqs later
[    5.227517]     ide0: BM-DMA at 0xf900-0xf907
[    5.227523] Probing IDE interface ide0...
[    5.323772] input: iMON Panel, Knob and Mouse(15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/input/input3
[    5.330528] IR RC5(x) protocol handler initialized
[    5.345028] imon 5-1:1.0: 0xffdc iMON VFD, MCE IR (id 0x9e)
[    5.356252] IR RC6 protocol handler initialized
[    5.488675] IR MCE Keyboard/mouse protocol handler initialized
[    5.500657] IT8716 SuperIO detected.
[    5.501152] parport_pc 00:09: reported by Plug and Play ACPI
[    5.501198] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    5.514421] lirc_dev: IR Remote Control driver registered, major 252
[    5.521282] IR LIRC bridge handler initialized
[    5.534033] Registered IR keymap rc-imon-mce
[    5.534336] input: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0/input4
[    5.534437] rc0: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0
[    5.545139] imon 5-1:1.0: iMON device (15c2:ffdc, intf0) on usb<5:2> 
initialized
[    5.545196] usbcore: registered new interface driver imon
[    5.679564] Linux video capture interface: v2.00
[    5.742627] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    5.742791] saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21, 
latency: 64, mmio: 0xfdeff000
[    5.742807] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 
310i [card=101,autodetected]
[    5.742852] saa7133[0]: board init: gpio is 600c000
[    5.743251] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.743445] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, 
revision 0
[    5.752592] uvcvideo: Unable to create debugfs directory
[    5.773782] usbcore: registered new interface driver snd-usb-audio
[    5.773797] uvcvideo: Found UVC 1.00 device VF0700 Live! Cam Chat HD 
(041e:4088)
[    5.778989] input: VF0700 Live! Cam Chat HD as 
/devices/pci0000:00/0000:00:13.5/usb1/1-3/1-3:1.0/input/input5
[    5.779228] usbcore: registered new interface driver uvcvideo
[    5.779234] USB Video Class driver (1.1.1)
[    5.845168] saa7133[0]: i2c eeprom read error (err=-5)
[    6.030890] hda_codec: ALC883: BIOS auto-probing.
[    6.052822] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input6
[    6.053095] input: HDA ATI SB Front Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input7
[    6.053321] input: HDA ATI SB Rear Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input8
[    6.053550] input: HDA ATI SB Front Headphone as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input9
[    6.053785] input: HDA ATI SB Line Out as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input10
[    6.055663] snd_hda_intel 0000:01:05.2: irq 42 for MSI/MSI-X
[    6.062440] i2c-core: driver [tuner] using legacy suspend method
[    6.062447] i2c-core: driver [tuner] using legacy resume method
[    6.149032] tuner 5-004b: Tuner -1 found with type(s) Radio TV.
[    6.184028] tda829x 5-004b: setting tuner address to 61
[    6.435025] tda829x 5-004b: type set to tda8290+75a
[    9.067029] hda-intel: azx_get_response timeout, switching to polling 
mode: last cmd=0x000f0000
[    9.456159] saa7133[0]: registered device video1 [v4l2]
[    9.456234] saa7133[0]: registered device vbi0
[    9.456305] saa7133[0]: registered device radio0
[    9.510095] dvb_init() allocating 1 frontend
[    9.532052] DVB: registering new adapter (saa7133[0])
[    9.532064] DVB: registering adapter 0 frontend 0 (Philips TDA10046H 
DVB-T)...
[    9.574037] tda1004x: setting up plls for 48MHz sampling clock
[    9.780038] tda1004x: found firmware revision 0 -- invalid
[    9.780048] tda1004x: trying to boot from eeprom
[   10.068029] hda-intel: No response from codec, disabling MSI: last 
cmd=0x000f0000
[   11.069045] hda-intel: Codec #0 probe error; disabling it...
[   12.087023] tda1004x: timeout waiting for DSP ready
[   12.097024] tda1004x: found firmware revision 0 -- invalid
[   12.097029] tda1004x: waiting for firmware upload...
[   13.180031] hda_intel: azx_get_response timeout, switching to 
single_cmd mode: last cmd=0x00070503
[   13.185372] hda-codec: No codec parser is available
[   19.706153] EXT3-fs (sda3): using internal journal
[   19.904880] kjournald starting.  Commit interval 5 seconds
[   19.905091] EXT3-fs (sda1): using internal journal
[   19.905098] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   19.939997] kjournald starting.  Commit interval 5 seconds
[   19.940128] EXT3-fs (dm-2): using internal journal
[   19.940134] EXT3-fs (dm-2): mounted filesystem with writeback data mode
[   20.028599] kjournald starting.  Commit interval 5 seconds
[   20.028823] EXT3-fs (dm-3): using internal journal
[   20.028830] EXT3-fs (dm-3): mounted filesystem with writeback data mode
[   20.052466] kjournald starting.  Commit interval 5 seconds
[   20.052772] EXT3-fs (dm-4): using internal journal
[   20.052778] EXT3-fs (dm-4): mounted filesystem with writeback data mode
[   20.099494] EXT4-fs (dm-5): mounted filesystem with ordered data 
mode. Opts: (null)
[   20.223180] EXT4-fs (dm-8): mounted filesystem with ordered data 
mode. Opts: (null)
[   20.254644] kjournald starting.  Commit interval 5 seconds
[   20.254973] EXT3-fs (dm-6): using internal journal
[   20.254980] EXT3-fs (dm-6): mounted filesystem with writeback data mode
[   20.304321] EXT4-fs (dm-7): mounted filesystem with ordered data 
mode. Opts: (null)
[   20.368320] EXT4-fs (dm-0): mounted filesystem without journal. Opts: 
(null)
[   20.477077] EXT4-fs (dm-1): mounted filesystem with ordered data 
mode. Opts: (null)
[   22.181037] tda1004x: timeout waiting for DSP ready
[   22.191051] tda1004x: found firmware revision 0 -- invalid
[   22.191059] tda1004x: firmware upload failed
[   22.316459] saa7134 ALSA driver for DMA sound loaded
[   22.316521] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 
registered as card -1
[   22.954074] Adding 10490440k swap on /dev/sda2.  Priority:-1 
extents:1 across:10490440k
[   24.137485] r8169 0000:02:00.0: eth0: link down
[   24.138371] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   24.636526] ADDRCONF(NETDEV_UP): eth0.2: link is not ready
[   25.888644] r8169 0000:02:00.0: eth0: link up
[   25.889461] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.890216] ADDRCONF(NETDEV_CHANGE): eth0.2: link becomes ready
[   32.921380] input: lircmd as /devices/virtual/input/input11
[   36.226025] eth0.2: no IPv6 routers present
[   36.810028] eth0: no IPv6 routers present
[   37.025048] input: iMON Panel, Knob and Mouse(15c2:ffdc) (lircd 
bypass) as /devices/virtual/input/input12





dmesg, patched:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.8-dirty (anders@tv) (gcc version 4.5.3 
(Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #68 SMP PREEMPT Fri Jul 6 19:39:29 
CEST 2012
[    0.000000] Command line: root=/dev/sda3 hpet=disable crashkernel=128M
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077ee0000 (usable)
[    0.000000]  BIOS-e820: 0000000077ee0000 - 0000000077ee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077ee3000 - 0000000077ef0000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077ef0000 - 0000000077f00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: System manufacturer System Product Name/M2A-VM HDMI, 
BIOS ASUS M2A-VM HDMI ACPI BIOS Revision 2201 10/22/2008
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77ee0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 base 0040000000 mask FFE0000000 write-back
[    0.000000]   2 base 0060000000 mask FFF0000000 write-back
[    0.000000]   3 base 0070000000 mask FFF8000000 write-back
[    0.000000]   4 base 0077F00000 mask FFFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f6560] f6560
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-0000000077ee0000
[    0.000000]  0000000000 - 0077e00000 page 2M
[    0.000000]  0077e00000 - 0077ee0000 page 4k
[    0.000000] kernel direct mapping tables up to 77ee0000 @ 
1fffc000-20000000
[    0.000000] Reserving 128MB of memory at 768MB for crashkernel 
(System RAM: 1918MB)
[    0.000000] ACPI: RSDP 00000000000f8210 00024 (v02 ATI   )
[    0.000000] ACPI: XSDT 0000000077ee3100 00044 (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 0000000077ee8500 000F4 (v03 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 0000000077ee3280 05210 (v01 ATI    ASUSACPI 
00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 0000000077ee0000 00040
[    0.000000] ACPI: SSDT 0000000077ee8740 002CC (v01 PTLTD  POWERNOW 
00000001  LTP 00000001)
[    0.000000] ACPI: MCFG 0000000077ee8b00 0003C (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 0000000077ee8640 00084 (v01 ATI    ASUSACPI 
42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> 
[ffff880075800000-ffff8800773fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077ee0
[    0.000000] On node 0 totalpages: 491119
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3922 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6661 pages used for memmap
[    0.000000]   DMA32 zone: 480475 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 77f00000 (gap: 
77f00000:68100000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880077c00000 s71424 
r8192 d22784 u524288
[    0.000000] pcpu-alloc: s71424 r8192 d22784 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 484397
[    0.000000] Kernel command line: root=/dev/sda3 hpet=disable 
crashkernel=128M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 
2097152 bytes)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 1066000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1791420k/1964928k available (5100k kernel code, 
452k absent, 173056k reserved, 3466k data, 456k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 7864320 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't 
want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2799.805 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.002039] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 5599.61 BogoMIPS (lpj=2799805)
[    0.002110] pid_max: default: 32768 minimum: 301
[    0.002216] Mount-cache hash table entries: 256
[    0.003098] Initializing cgroup subsys cpuacct
[    0.003134] Initializing cgroup subsys memory
[    0.003180] Initializing cgroup subsys devices
[    0.003214] Initializing cgroup subsys freezer
[    0.003250] Initializing cgroup subsys blkio
[    0.003313] tseg: 0077f00000
[    0.003315] CPU: Physical Processor ID: 0
[    0.003349] CPU: Processor Core ID: 0
[    0.003384] mce: CPU supports 5 MCE banks
[    0.003427] using AMD E400 aware idle routine
[    0.003490] ACPI: Core revision 20120111
[    0.006669] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.016866] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ 
stepping 03
[    0.016998] Performance Events: AMD PMU driver.
[    0.016998] ... version:                0
[    0.016998] ... bit width:              48
[    0.016998] ... generic registers:      4
[    0.016998] ... value mask:             0000ffffffffffff
[    0.016998] ... max period:             00007fffffffffff
[    0.016998] ... fixed-purpose events:   0
[    0.016998] ... event mask:             000000000000000f
[    0.028011] Booting Node   0, Processors  #1
[    0.028072] smpboot cpu 1: start_ip = 9a000
[    0.099086] Brought up 2 CPUs
[    0.099121] Total of 2 processors activated (11198.38 BogoMIPS).
[    0.099618] PM: Registering ACPI NVS region at 77ee0000 (12288 bytes)
[    0.100060] NET: Registered protocol family 16
[    0.100113] node 0 link 0: io port [c000, ffff]
[    0.100113] TOM: 0000000080000000 aka 2048M
[    0.100113] node 0 link 0: mmio [a0000, bffff]
[    0.100113] node 0 link 0: mmio [80000000, dfffffff]
[    0.100113] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.100113] node 0 link 0: mmio [e0000000, e03fffff]
[    0.100113] bus: [00, 03] on node 0 link 0
[    0.100113] bus: 00 index 0 [io  0x0000-0xffff]
[    0.100113] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.100113] bus: 00 index 2 [mem 0x80000000-0xefffffff]
[    0.100113] bus: 00 index 3 [mem 0xf0000000-0xfcffffffff]
[    0.100113] ACPI: bus type pci registered
[    0.100126] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.100126] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.118729] PCI: Using configuration type 1 for base access
[    0.126035] bio: create slab <bio-0> at 0
[    0.126133] ACPI: Added _OSI(Module Device)
[    0.126133] ACPI: Added _OSI(Processor Device)
[    0.126133] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.126133] ACPI: Added _OSI(Processor Aggregator Device)
[    0.127170] ACPI: EC: Look up EC in DSDT
[    0.130793] ACPI: Interpreter enabled
[    0.130833] ACPI: (supports S0 S1 S3 S4 S5)
[    0.131029] ACPI: Using IOAPIC for interrupt routing
[    0.136087] ACPI: No dock devices found.
[    0.136126] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.136218] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.136323] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.136359] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.136395] pci_root PNP0A03:00: host bridge window [mem 
0x000a0000-0x000bffff]
[    0.136435] pci_root PNP0A03:00: host bridge window [mem 
0x000c0000-0x000dffff]
[    0.136474] pci_root PNP0A03:00: host bridge window [mem 
0x80000000-0xfebfffff]
[    0.137057] PCI host bridge to bus 0000:00
[    0.137057] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.137073] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.137109] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff]
[    0.137144] pci_bus 0000:00: root bus resource [mem 
0x000c0000-0x000dffff]
[    0.137180] pci_bus 0000:00: root bus resource [mem 
0x80000000-0xfebfffff]
[    0.137224] pci 0000:00:00.0: [1002:7910] type 0 class 0x000600
[    0.137249] pci 0000:00:01.0: [1002:7912] type 1 class 0x000604
[    0.137285] pci 0000:00:07.0: [1002:7917] type 1 class 0x000604
[    0.137314] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.137344] pci 0000:00:12.0: [1002:4380] type 0 class 0x000101
[    0.137362] pci 0000:00:12.0: reg 10: [io  0xff00-0xff07]
[    0.137373] pci 0000:00:12.0: reg 14: [io  0xfe00-0xfe03]
[    0.137383] pci 0000:00:12.0: reg 18: [io  0xfd00-0xfd07]
[    0.137393] pci 0000:00:12.0: reg 1c: [io  0xfc00-0xfc03]
[    0.137403] pci 0000:00:12.0: reg 20: [io  0xfb00-0xfb0f]
[    0.137414] pci 0000:00:12.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.137435] pci 0000:00:12.0: set SATA to AHCI mode
[    0.137508] pci 0000:00:13.0: [1002:4387] type 0 class 0x000c03
[    0.137523] pci 0000:00:13.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.137590] pci 0000:00:13.1: [1002:4388] type 0 class 0x000c03
[    0.137605] pci 0000:00:13.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.137673] pci 0000:00:13.2: [1002:4389] type 0 class 0x000c03
[    0.137687] pci 0000:00:13.2: reg 10: [mem 0xfe02c000-0xfe02cfff]
[    0.137755] pci 0000:00:13.3: [1002:438a] type 0 class 0x000c03
[    0.137769] pci 0000:00:13.3: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.137840] pci 0000:00:13.4: [1002:438b] type 0 class 0x000c03
[    0.137854] pci 0000:00:13.4: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.138006] pci 0000:00:13.5: [1002:4386] type 0 class 0x000c03
[    0.138026] pci 0000:00:13.5: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.138113] pci 0000:00:13.5: supports D1 D2
[    0.138115] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.138140] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.138163] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.138250] pci 0000:00:14.1: [1002:438c] type 0 class 0x000101
[    0.138264] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.138274] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.138285] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.138295] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.138306] pci 0000:00:14.1: reg 20: [io  0xf900-0xf90f]
[    0.138346] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.138369] pci 0000:00:14.2: reg 10: [mem 0xfe020000-0xfe023fff 64bit]
[    0.138438] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.138455] pci 0000:00:14.3: [1002:438d] type 0 class 0x000601
[    0.138533] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.138581] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    0.138598] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    0.138612] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    0.138628] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    0.138669] pci 0000:01:05.0: [1002:791e] type 0 class 0x000300
[    0.138678] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff 
64bit pref]
[    0.138684] pci 0000:01:05.0: reg 18: [mem 0xfdbe0000-0xfdbeffff 64bit]
[    0.138689] pci 0000:01:05.0: reg 20: [io  0xde00-0xdeff]
[    0.138693] pci 0000:01:05.0: reg 24: [mem 0xfda00000-0xfdafffff]
[    0.138708] pci 0000:01:05.0: supports D1 D2
[    0.138718] pci 0000:01:05.2: [1002:7919] type 0 class 0x000403
[    0.138726] pci 0000:01:05.2: reg 10: [mem 0xfdbfc000-0xfdbfffff 64bit]
[    0.138762] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.138799] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.138802] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.138806] pci 0000:00:01.0:   bridge window [mem 
0xf0000000-0xf7ffffff 64bit pref]
[    0.138845] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.138860] pci 0000:02:00.0: reg 10: [io  0xee00-0xeeff]
[    0.138884] pci 0000:02:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit]
[    0.138912] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.138973] pci 0000:02:00.0: supports D1 D2
[    0.138975] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
[    0.139017] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  
You can enable it with 'pcie_aspm=force'
[    0.139064] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.139100] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.139103] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.139107] pci 0000:00:07.0:   bridge window [mem 
0xfdc00000-0xfdcfffff 64bit pref]
[    0.139142] pci 0000:03:06.0: [1131:7133] type 0 class 0x000480
[    0.139165] pci 0000:03:06.0: reg 10: [mem 0xfdeff000-0xfdeff7ff]
[    0.139266] pci 0000:03:06.0: supports D1 D2
[    0.139289] pci 0000:03:07.0: [1106:3044] type 0 class 0x000c00
[    0.139313] pci 0000:03:07.0: reg 10: [mem 0xfdefe000-0xfdefe7ff]
[    0.139326] pci 0000:03:07.0: reg 14: [io  0xcf00-0xcf7f]
[    0.139422] pci 0000:03:07.0: supports D2
[    0.139424] pci 0000:03:07.0: PME# supported from D2 D3hot D3cold
[    0.139473] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive 
decode)
[    0.139511] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.139516] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.139521] pci 0000:00:14.4:   bridge window [mem 
0xfdd00000-0xfddfffff pref]
[    0.139523] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.139526] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.139529] pci 0000:00:14.4:   bridge window [mem 
0x000a0000-0x000bffff] (subtractive decode)
[    0.139532] pci 0000:00:14.4:   bridge window [mem 
0x000c0000-0x000dffff] (subtractive decode)
[    0.139534] pci 0000:00:14.4:   bridge window [mem 
0x80000000-0xfebfffff] (subtractive decode)
[    0.139546] pci_bus 0000:00: on NUMA node 0
[    0.139548] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.139698] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.139769] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.139796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.139825]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.139861]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), 
returned control mask: 0x1d
[    0.139901] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.154036] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.154429] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.154820] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.155318] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.155709] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.156112] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.156504] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 *11)
[    0.156833] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) 
*0, disabled.
[    0.157228] vgaarb: device added: 
PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.157228] vgaarb: loaded
[    0.157228] vgaarb: bridge control possible 0000:01:05.0
[    0.157228] SCSI subsystem initialized
[    0.157228] libata version 3.00 loaded.
[    0.157228] usbcore: registered new interface driver usbfs
[    0.157997] usbcore: registered new interface driver hub
[    0.158037] usbcore: registered new device driver usb
[    0.158049] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.158049] PCI: Using ACPI for IRQ routing
[    0.167425] PCI: pci_cache_line_size set to 64 bytes
[    0.167512] reserve RAM buffer: 000000000009f000 - 000000000009ffff
[    0.167514] reserve RAM buffer: 0000000077ee0000 - 0000000077ffffff
[    0.167533] Bluetooth: Core ver 2.16
[    0.167533] NET: Registered protocol family 31
[    0.167533] Bluetooth: HCI device and connection manager initialized
[    0.167533] Bluetooth: HCI socket layer initialized
[    0.167533] Bluetooth: L2CAP socket layer initialized
[    0.169985] Bluetooth: SCO socket layer initialized
[    0.170997] pnp: PnP ACPI init
[    0.170997] ACPI: bus type pnp registered
[    0.171109] pnp 00:00: [bus 00-ff]
[    0.171111] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.171114] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.171116] pnp 00:00: [io  0x0d00-0xffff window]
[    0.171119] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.171121] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.171124] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.171181] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.171181] pnp 00:01: [io  0x4100-0x411f]
[    0.171181] pnp 00:01: [io  0x0228-0x022f]
[    0.171181] pnp 00:01: [io  0x040b]
[    0.171181] pnp 00:01: [io  0x04d6]
[    0.171181] pnp 00:01: [io  0x0c00-0x0c01]
[    0.171181] pnp 00:01: [io  0x0c14]
[    0.171181] pnp 00:01: [io  0x0c50-0x0c52]
[    0.171181] pnp 00:01: [io  0x0c6c-0x0c6d]
[    0.171181] pnp 00:01: [io  0x0c6f]
[    0.171181] pnp 00:01: [io  0x0cd0-0x0cd1]
[    0.171181] pnp 00:01: [io  0x0cd2-0x0cd3]
[    0.171181] pnp 00:01: [io  0x0cd4-0x0cdf]
[    0.171181] pnp 00:01: [io  0x4000-0x40fe]
[    0.171181] pnp 00:01: [io  0x4210-0x4217]
[    0.171181] pnp 00:01: [io  0x0b10-0x0b1f]
[    0.171181] pnp 00:01: [mem 0x00000000-0x00000fff window]
[    0.171181] pnp 00:01: [mem 0xfee00400-0xfee00fff window]
[    0.171181] pnp 00:01: disabling [mem 0x00000000-0x00000fff window] 
because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0001ffff pref]
[    0.171203] system 00:01: [io  0x4100-0x411f] has been reserved
[    0.171203] system 00:01: [io  0x0228-0x022f] has been reserved
[    0.171203] system 00:01: [io  0x040b] has been reserved
[    0.171203] system 00:01: [io  0x04d6] has been reserved
[    0.171203] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.171203] system 00:01: [io  0x0c14] has been reserved
[    0.171219] system 00:01: [io  0x0c50-0x0c52] has been reserved
[    0.171256] system 00:01: [io  0x0c6c-0x0c6d] has been reserved
[    0.171291] system 00:01: [io  0x0c6f] has been reserved
[    0.171327] system 00:01: [io  0x0cd0-0x0cd1] has been reserved
[    0.171363] system 00:01: [io  0x0cd2-0x0cd3] has been reserved
[    0.171399] system 00:01: [io  0x0cd4-0x0cdf] has been reserved
[    0.171434] system 00:01: [io  0x4000-0x40fe] has been reserved
[    0.171470] system 00:01: [io  0x4210-0x4217] has been reserved
[    0.171506] system 00:01: [io  0x0b10-0x0b1f] has been reserved
[    0.171993] system 00:01: [mem 0xfee00400-0xfee00fff window] has been 
reserved
[    0.172033] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.172125] pnp 00:02: [dma 4]
[    0.172127] pnp 00:02: [io  0x0000-0x000f]
[    0.172130] pnp 00:02: [io  0x0080-0x0090]
[    0.172132] pnp 00:02: [io  0x0094-0x009f]
[    0.172134] pnp 00:02: [io  0x00c0-0x00df]
[    0.172171] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.172171] pnp 00:03: [io  0x0070-0x0073]
[    0.172171] pnp 00:03: [irq 8]
[    0.172171] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.172171] pnp 00:04: [io  0x0061]
[    0.172171] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.172171] pnp 00:05: [io  0x00f0-0x00ff]
[    0.172171] pnp 00:05: [irq 13]
[    0.172171] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.172171] pnp 00:06: [io  0x0010-0x001f]
[    0.172171] pnp 00:06: [io  0x0022-0x003f]
[    0.172171] pnp 00:06: [io  0x0044-0x005f]
[    0.172171] pnp 00:06: [io  0x0062-0x0063]
[    0.172171] pnp 00:06: [io  0x0065-0x006f]
[    0.172171] pnp 00:06: [io  0x0074-0x007f]
[    0.172171] pnp 00:06: [io  0x0091-0x0093]
[    0.172171] pnp 00:06: [io  0x00a2-0x00bf]
[    0.172171] pnp 00:06: [io  0x00e0-0x00ef]
[    0.172171] pnp 00:06: [io  0x04d0-0x04d1]
[    0.172171] pnp 00:06: [io  0x0220-0x0225]
[    0.172171] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.172171] system 00:06: [io  0x0220-0x0225] has been reserved
[    0.172171] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.172198] pnp 00:07: [io  0x03f0-0x03f5]
[    0.172200] pnp 00:07: [io  0x03f7]
[    0.172208] pnp 00:07: [irq 6]
[    0.172210] pnp 00:07: [dma 2]
[    0.172259] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.173030] pnp 00:08: [io  0x03f8-0x03ff]
[    0.173038] pnp 00:08: [irq 4]
[    0.173103] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.173256] pnp 00:09: [io  0x0378-0x037f]
[    0.173264] pnp 00:09: [irq 7]
[    0.173321] pnp 00:09: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.173321] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.173321] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.173321] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.173321] pnp 00:0b: [mem 0x000cd600-0x000cffff]
[    0.173321] pnp 00:0b: [mem 0x000f0000-0x000f7fff]
[    0.173321] pnp 00:0b: [mem 0x000f8000-0x000fbfff]
[    0.173321] pnp 00:0b: [mem 0x000fc000-0x000fffff]
[    0.173321] pnp 00:0b: [mem 0x77ef0000-0x77feffff]
[    0.173321] pnp 00:0b: [mem 0xfed00000-0xfed000ff]
[    0.173321] pnp 00:0b: [mem 0x77ee0000-0x77efffff]
[    0.173321] pnp 00:0b: [mem 0xffff0000-0xffffffff]
[    0.173321] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.173321] pnp 00:0b: [mem 0x00100000-0x77edffff]
[    0.173321] pnp 00:0b: [mem 0x77ff0000-0x7ffeffff]
[    0.173321] pnp 00:0b: [mem 0xfec00000-0xfec00fff]
[    0.173321] pnp 00:0b: [mem 0xfee00000-0xfee00fff]
[    0.173321] pnp 00:0b: [mem 0xfff80000-0xfffeffff]
[    0.174001] system 00:0b: [mem 0x000cd600-0x000cffff] has been reserved
[    0.174001] system 00:0b: [mem 0x000f0000-0x000f7fff] could not be 
reserved
[    0.174030] system 00:0b: [mem 0x000f8000-0x000fbfff] could not be 
reserved
[    0.174066] system 00:0b: [mem 0x000fc000-0x000fffff] could not be 
reserved
[    0.174103] system 00:0b: [mem 0x77ef0000-0x77feffff] could not be 
reserved
[    0.174140] system 00:0b: [mem 0xfed00000-0xfed000ff] has been reserved
[    0.174176] system 00:0b: [mem 0x77ee0000-0x77efffff] could not be 
reserved
[    0.174212] system 00:0b: [mem 0xffff0000-0xffffffff] has been reserved
[    0.174248] system 00:0b: [mem 0x00000000-0x0009ffff] could not be 
reserved
[    0.174285] system 00:0b: [mem 0x00100000-0x77edffff] could not be 
reserved
[    0.174321] system 00:0b: [mem 0x77ff0000-0x7ffeffff] could not be 
reserved
[    0.174357] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be 
reserved
[    0.174393] system 00:0b: [mem 0xfee00000-0xfee00fff] could not be 
reserved
[    0.174430] system 00:0b: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.174466] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.174474] pnp: PnP ACPI: found 12 devices
[    0.174508] ACPI: ACPI bus type pnp unregistered
[    0.182882] Switching to clocksource acpi_pm
[    0.182959] PCI: max bus depth: 1 pci_try_num: 2
[    0.182979] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.182979] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.182979] pci 0000:00:01.0:   bridge window [mem 0xfda00000-0xfdbfffff]
[    0.182979] pci 0000:00:01.0:   bridge window [mem 
0xf0000000-0xf7ffffff 64bit pref]
[    0.182979] pci 0000:02:00.0: BAR 6: assigned [mem 
0xfdc00000-0xfdc1ffff pref]
[    0.182979] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.182979] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.182979] pci 0000:00:07.0:   bridge window [mem 0xfdf00000-0xfdffffff]
[    0.182979] pci 0000:00:07.0:   bridge window [mem 
0xfdc00000-0xfdcfffff 64bit pref]
[    0.182979] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.182979] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.182979] pci 0000:00:14.4:   bridge window [mem 0xfde00000-0xfdefffff]
[    0.182979] pci 0000:00:14.4:   bridge window [mem 
0xfdd00000-0xfddfffff pref]
[    0.182979] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.182979] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.182979] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.182979] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.182979] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfebfffff]
[    0.182979] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.182979] pci_bus 0000:01: resource 1 [mem 0xfda00000-0xfdbfffff]
[    0.182979] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 
64bit pref]
[    0.182979] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.182979] pci_bus 0000:02: resource 1 [mem 0xfdf00000-0xfdffffff]
[    0.182979] pci_bus 0000:02: resource 2 [mem 0xfdc00000-0xfdcfffff 
64bit pref]
[    0.182979] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.182979] pci_bus 0000:03: resource 1 [mem 0xfde00000-0xfdefffff]
[    0.182979] pci_bus 0000:03: resource 2 [mem 0xfdd00000-0xfddfffff pref]
[    0.182979] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.182979] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.182979] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.182979] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.182979] pci_bus 0000:03: resource 8 [mem 0x80000000-0xfebfffff]
[    0.182979] NET: Registered protocol family 2
[    0.182979] IP route cache hash table entries: 65536 (order: 7, 
524288 bytes)
[    0.183272] TCP established hash table entries: 262144 (order: 10, 
4194304 bytes)
[    0.185158] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.185689] TCP: Hash tables configured (established 262144 bind 65536)
[    0.185727] TCP reno registered
[    0.185763] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.185816] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.185961] NET: Registered protocol family 1
[    0.186147] RPC: Registered named UNIX socket transport module.
[    0.186193] RPC: Registered udp transport module.
[    0.186227] RPC: Registered tcp transport module.
[    0.186262] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.463080] pci 0000:01:05.0: Boot video device
[    0.463092] PCI: CLS 32 bytes, default 64
[    0.463220] kvm: Nested Virtualization enabled
[    0.464180] audit: initializing netlink socket (disabled)
[    0.464227] type=2000 audit(1347732948.463:1): initialized
[    0.465327] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.465646] msgmni has been set to 3498
[    0.466119] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    0.466162] io scheduler noop registered
[    0.466220] io scheduler cfq registered (default)
[    0.466402] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
[    0.467042] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.467085] ACPI: Power Button [PWRB]
[    0.467222] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.467262] ACPI: Power Button [PWRF]
[    0.467426] ACPI: Fan [FAN] (on)
[    0.469041] ACPI Warning: For \_TZ_.THRM._PSL: Return Package has no 
elements (empty) (20120111/nspredef-463)
[    0.469143] ACPI: [Package] has zero elements (ffff880074b409c0)
[    0.469178] ACPI: Invalid passive threshold
[    0.469443] thermal LNXTHERM:00: registered as thermal_zone0
[    0.469479] ACPI: Thermal Zone [THRM] (40 C)
[    0.469742] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.490475] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.511604] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.512070] [drm] Initialized drm 1.1.0 20060810
[    0.512162] [drm] radeon defaulting to kernel modesetting.
[    0.512198] [drm] radeon kernel modesetting enabled.
[    0.512484] [drm] initializing kernel modesetting (RS690 
0x1002:0x791E 0x1043:0x826D).
[    0.512538] [drm] register mmio base: 0xFDBE0000
[    0.512572] [drm] register mmio size: 65536
[    0.514171] ATOM BIOS: ATI
[    0.514224] radeon 0000:01:05.0: VRAM: 128M 0x0000000078000000 - 
0x000000007FFFFFFF (128M used)
[    0.514264] radeon 0000:01:05.0: GTT: 512M 0x0000000080000000 - 
0x000000009FFFFFFF
[    0.514306] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.514342] [drm] Driver supports precise vblank timestamp query.
[    0.514403] [drm] radeon: irq initialized.
[    0.515085] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.515124] [drm] RAM width 128bits DDR
[    0.515235] [TTM] Zone  kernel: Available graphics memory: 895710 kiB.
[    0.515275] [TTM] Initializing pool allocator.
[    0.515313] [TTM] Initializing DMA pool allocator.
[    0.515381] [drm] radeon: 128M of VRAM memory ready
[    0.515417] [drm] radeon: 512M of GTT memory ready.
[    0.515454] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.522330] [drm] radeon: ib pool ready.
[    0.523376] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[    0.529478] [drm] PCIE GART of 512M enabled (table at 
0x0000000074680000).
[    0.529532] radeon 0000:01:05.0: WB enabled
[    0.529568] [drm] fence driver on ring 0 use gpu addr 0x80000000 and 
cpu addr 0xffff880074b46000
[    0.529724] [drm] Loading RS690/RS740 Microcode
[    0.529940] [drm] radeon: ring at 0x0000000080001000
[    0.529989] [drm] ring test succeeded in 1 usecs
[    0.530147] [drm] ib test succeeded in 0 usecs
[    0.530935] [drm] Radeon Display Connectors
[    0.530970] [drm] Connector 0:
[    0.531013] [drm]   VGA
[    0.531047] [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 
0x7e5c 0x7e4c
[    0.531085] [drm]   Encoders:
[    0.531119] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    0.531153] [drm] Connector 1:
[    0.531186] [drm]   S-video
[    0.531219] [drm]   Encoders:
[    0.531252] [drm]     TV1: INTERNAL_KLDSCP_DAC1
[    0.531286] [drm] Connector 2:
[    0.531319] [drm]   HDMI-A
[    0.531352] [drm]   HPD2
[    0.531386] [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 
0x7e4c 0x7e6c
[    0.531424] [drm]   Encoders:
[    0.531457] [drm]     DFP2: INTERNAL_DDI
[    0.531490] [drm] Connector 3:
[    0.531524] [drm]   DVI-D
[    0.531558] [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 
0x7e4c 0x7e5c
[    0.531596] [drm]   Encoders:
[    0.531629] [drm]     DFP3: INTERNAL_LVTM1
[    0.788229] [drm] fb mappable at 0xF0040000
[    0.788263] [drm] vram apper at 0xF0000000
[    0.788297] [drm] size 8294400
[    0.788330] [drm] fb depth is 24
[    0.788364] [drm]    pitch is 7680
[    0.788487] fbcon: radeondrmfb (fb0) is primary device
[    0.816877] Console: switching to colour frame buffer device 240x67
[    0.826222] fb0: radeondrmfb frame buffer device
[    0.826256] drm: registered panic notifier
[    0.826291] [drm] Initialized radeon 2.13.0 20080528 for 0000:01:05.0 
on minor 0
[    0.829192] brd: module loaded
[    0.830680] loop: module loaded
[    0.830760] Uniform Multi-Platform E-IDE driver
[    0.830928] ide-gd driver 1.18
[    0.831250] ahci 0000:00:12.0: version 3.0
[    0.831301] ahci 0000:00:12.0: ASUS M2A-VM: enabling 64bit DMA
[    0.831468] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0xf impl SATA mode
[    0.831531] ahci 0000:00:12.0: flags: 64bit ncq sntf ilck pm led clo 
pmp pio slum part ccc
[    0.833190] scsi0 : ahci
[    0.833520] scsi1 : ahci
[    0.833748] scsi2 : ahci
[    0.833973] scsi3 : ahci
[    0.834237] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f100 irq 22
[    0.834296] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f180 irq 22
[    0.834354] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f200 irq 22
[    0.834411] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 
0xfe02f280 irq 22
[    0.834699] tun: Universal TUN/TAP device driver, 1.6
[    0.834738] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.834874] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.835051] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    0.835336] r8169 0000:02:00.0: eth0: RTL8168b/8111b at 
0xffffc9000000c000, 00:1b:fc:89:fa:a2, XID 18000000 IRQ 41
[    0.835415] r8169 0000:02:00.0: eth0: jumbo features [frames: 4080 
bytes, tx checksumming: ko]
[    0.835551] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.835624] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    0.835670] ehci_hcd 0000:00:13.5: new USB bus registered, assigned 
bus number 1
[    0.835748] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB 
freeze workaround
[    0.835818] ehci_hcd 0000:00:13.5: debug port 1
[    0.835882] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
[    0.841024] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    0.841320] hub 1-0:1.0: USB hub found
[    0.841351] hub 1-0:1.0: 10 ports detected
[    0.841536] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.841607] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.841649] ohci_hcd 0000:00:13.0: new USB bus registered, assigned 
bus number 2
[    0.841737] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
[    0.896251] hub 2-0:1.0: USB hub found
[    0.896291] hub 2-0:1.0: 2 ports detected
[    0.896439] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.896486] ohci_hcd 0000:00:13.1: new USB bus registered, assigned 
bus number 3
[    0.896580] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
[    0.951252] hub 3-0:1.0: USB hub found
[    0.953016] hub 3-0:1.0: 2 ports detected
[    0.954833] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    0.956599] ohci_hcd 0000:00:13.2: new USB bus registered, assigned 
bus number 4
[    0.958385] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
[    1.015230] hub 4-0:1.0: USB hub found
[    1.016980] hub 4-0:1.0: 2 ports detected
[    1.018802] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    1.020562] ohci_hcd 0000:00:13.3: new USB bus registered, assigned 
bus number 5
[    1.022370] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
[    1.079228] hub 5-0:1.0: USB hub found
[    1.080897] hub 5-0:1.0: 2 ports detected
[    1.082725] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    1.084501] ohci_hcd 0000:00:13.4: new USB bus registered, assigned 
bus number 6
[    1.086279] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
[    1.143032] usb 1-3: new high-speed USB device number 2 using ehci_hcd
[    1.143185] hub 6-0:1.0: USB hub found
[    1.143191] hub 6-0:1.0: 2 ports detected
[    1.143437] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.150211] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.152106] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.154048] mousedev: PS/2 mouse device common for all mice
[    1.156117] k8temp 0000:00:18.3: Temperature readouts might be wrong 
- check erratum #141
[    1.158076] md: linear personality registered for level -1
[    1.159986] device-mapper: uevent: version 1.0.3
[    1.161805] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) 
initialised: dm-devel@redhat.com
[    1.163693] usbcore: registered new interface driver btusb
[    1.165442] cpuidle: using governor ladder
[    1.167252] cpuidle: using governor menu
[    1.169525] ALSA device list:
[    1.171312]   No soundcards found.
[    1.173092] TCP cubic registered
[    1.174949] NET: Registered protocol family 10
[    1.176904] NET: Registered protocol family 17
[    1.178629] Bridge firewalling registered
[    1.180410] Bluetooth: RFCOMM TTY layer initialized
[    1.182144] Bluetooth: RFCOMM socket layer initialized
[    1.183937] Bluetooth: RFCOMM ver 1.11
[    1.185721] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    1.187521] Bluetooth: BNEP filters: protocol multicast
[    1.189319] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    1.191179] 8021q: 802.1Q VLAN Support v1.8
[    1.193154] PM: Checking hibernation image partition /dev/sda2
[    1.294030] ata1: softreset failed (device not ready)
[    1.295711] ata1: applying PMP SRST workaround and retrying
[    1.297355] ata3: softreset failed (device not ready)
[    1.299075] ata3: applying PMP SRST workaround and retrying
[    1.300850] ata4: softreset failed (device not ready)
[    1.302563] ata4: applying PMP SRST workaround and retrying
[    1.304269] ata2: softreset failed (device not ready)
[    1.305988] ata2: applying PMP SRST workaround and retrying
[    1.458035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.459802] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.461490] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.463265] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.464860] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S203P, SB00, max UDMA/100
[    1.466559] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.468262] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    1.469961] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 
31/32), AA
[    1.471668] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.473555] ata2.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    1.475331] ata2.00: 2930277168 sectors, multi 1: LBA48 NCQ (depth 
31/32), AA
[    1.477072] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.478752] ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.480460] ata4.00: configured for UDMA/100
[    1.482198] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.483912] ata1.00: configured for UDMA/133
[    1.485770] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  
CR10 PQ: 0 ANSI: 5
[    1.485983] ata2.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.485986] ata2.00: configured for UDMA/133
[    1.491337] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    1.492329] ata3.00: ATA-8: WDC WD3200BEVT-00ZCT0, 11.01A11, max UDMA/133
[    1.492331] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 
31/32), AA
[    1.492335] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.493287] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.493290] ata3.00: configured for UDMA/133
[    1.496102] scsi 1:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P 
01.0 PQ: 0 ANSI: 5
[    1.496315] sd 1:0:0:0: [sdb] 2930277168 512-byte logical blocks: 
(1.50 TB/1.36 TiB)
[    1.496355] sd 1:0:0:0: [sdb] Write Protect is off
[    1.496358] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.496374] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.506240]  sdb: sdb1 sdb2 sdb3 sdb4
[    1.511092] sd 0:0:0:0: [sda] Write Protect is off
[    1.511124] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-0 
11.0 PQ: 0 ANSI: 5
[    1.511419] sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 
GB/298 GiB)
[    1.511456] sd 2:0:0:0: [sdc] Write Protect is off
[    1.511458] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.511474] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.520249] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.520285] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.520638] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.524200] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S203P  
SB00 PQ: 0 ANSI: 5
[    1.528046] sr0: scsi3-mmc drive: 8x/40x writer dvd-ram cd/rw 
xa/form2 cdda tray
[    1.529903] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.530825]  sda: sda1 sda2 sda3 sda4
[    1.533742] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.534035] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.596783]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
[    1.599583] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.601542] PM: Hibernation image partition 8:2 present
[    1.601544] PM: Looking for hibernation image.
[    1.601676] PM: Image not found (code -22)
[    1.601678] PM: Hibernation image not present or could not be loaded.
[    1.601687] registered taskstats version 1
[    1.603907] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.605848] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core 
Processor 5600+ (2 cpu cores) (version 2.20.00)
[    1.607910] powernow-k8: fid 0x14 (2800 MHz), vid 0x8
[    1.609904] powernow-k8: fid 0x12 (2600 MHz), vid 0xa
[    1.611836] powernow-k8: fid 0x10 (2400 MHz), vid 0xc
[    1.613752] powernow-k8: fid 0xe (2200 MHz), vid 0xe
[    1.615692] powernow-k8: fid 0xc (2000 MHz), vid 0x10
[    1.617646] powernow-k8: fid 0xa (1800 MHz), vid 0x10
[    1.619578] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
[    1.621622] md: Skipping autodetection of RAID arrays. 
(raid=autodetect will force)
[    1.645665] kjournald starting.  Commit interval 5 seconds
[    1.645699] EXT3-fs (sda3): mounted filesystem with writeback data mode
[    1.645715] VFS: Mounted root (ext3 filesystem) readonly on device 8:3.
[    1.652041] Freeing unused kernel memory: 456k freed
[    1.654290] Write protecting the kernel read-only data: 8192k
[    1.659253] Freeing unused kernel memory: 1024k freed
[    1.669040] usb 3-2: new full-speed USB device number 2 using ohci_hcd
[    2.072042] usb 5-1: new low-speed USB device number 2 using ohci_hcd
[    3.979588] udevd[872]: starting version 171
[    5.070436] atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
[    5.070502] atiixp 0000:00:14.1: not 100% native mode: will probe 
irqs later
[    5.070520]     ide0: BM-DMA at 0xf900-0xf907
[    5.070534] Probing IDE interface ide0...
[    5.195189] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    5.223764] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.223850] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.223928] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.224032] sr 3:0:0:0: Attached scsi generic sg3 type 5
[    5.237442] input: iMON Panel, Knob and Mouse(15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/input/input3
[    5.257039] imon 5-1:1.0: 0xffdc iMON VFD, MCE IR (id 0x9e)
[    5.308271] IT8716 SuperIO detected.
[    5.309299] parport_pc 00:09: reported by Plug and Play ACPI
[    5.309344] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[    5.348300] IR RC5(x) protocol handler initialized
[    5.391188] rtc_cmos 00:03: RTC can wake from S4
[    5.391501] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.391554] rtc0: alarms up to one month, 242 bytes nvram
[    5.404400] Linux video capture interface: v2.00
[    5.406857] IR RC6 protocol handler initialized
[    5.429034] Registered IR keymap rc-imon-mce
[    5.429339] input: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0/input4
[    5.429441] rc0: iMON Remote (15c2:ffdc) as 
/devices/pci0000:00/0000:00:13.3/usb5/5-1/5-1:1.0/rc/rc0
[    5.441151] imon 5-1:1.0: iMON device (15c2:ffdc, intf0) on usb<5:2> 
initialized
[    5.441212] usbcore: registered new interface driver imon
[    5.445549] uvcvideo: Unable to create debugfs directory
[    5.583247] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.583447] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, 
revision 0
[    5.587445] IR MCE Keyboard/mouse protocol handler initialized
[    5.612856] lirc_dev: IR Remote Control driver registered, major 61
[    5.617640] ir_lirc_codec: disagrees about version of symbol 
lirc_dev_fop_poll
[    5.617648] ir_lirc_codec: Unknown symbol lirc_dev_fop_poll (err -22)
[    5.617664] ir_lirc_codec: disagrees about version of symbol 
lirc_dev_fop_open
[    5.617671] ir_lirc_codec: Unknown symbol lirc_dev_fop_open (err -22)
[    5.617683] ir_lirc_codec: disagrees about version of symbol 
lirc_get_pdata
[    5.617689] ir_lirc_codec: Unknown symbol lirc_get_pdata (err -22)
[    5.617703] ir_lirc_codec: disagrees about version of symbol 
lirc_dev_fop_close
[    5.617709] ir_lirc_codec: Unknown symbol lirc_dev_fop_close (err -22)
[    5.617720] ir_lirc_codec: disagrees about version of symbol 
lirc_dev_fop_read
[    5.617726] ir_lirc_codec: Unknown symbol lirc_dev_fop_read (err -22)
[    5.617734] ir_lirc_codec: disagrees about version of symbol 
lirc_register_driver
[    5.617740] ir_lirc_codec: Unknown symbol lirc_register_driver (err -22)
[    5.617769] ir_lirc_codec: disagrees about version of symbol 
lirc_dev_fop_ioctl
[    5.617775] ir_lirc_codec: Unknown symbol lirc_dev_fop_ioctl (err -22)
[    5.678523] hda_codec: ALC883: BIOS auto-probing.
[    5.701422] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input5
[    5.701660] input: HDA ATI SB Front Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input6
[    5.701870] input: HDA ATI SB Rear Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input7
[    5.702100] input: HDA ATI SB Front Headphone as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input8
[    5.702345] input: HDA ATI SB Line Out as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input9
[    5.704117] snd_hda_intel 0000:01:05.2: irq 42 for MSI/MSI-X
[    5.733517] usbcore: registered new interface driver snd-usb-audio
[    5.733529] uvcvideo: Found UVC 1.00 device VF0700 Live! Cam Chat HD 
(041e:4088)
[    5.735727] input: VF0700 Live! Cam Chat HD as 
/devices/pci0000:00/0000:00:13.5/usb1/1-3/1-3:1.0/input/input10
[    5.735866] usbcore: registered new interface driver uvcvideo
[    5.735871] USB Video Class driver (1.1.1)
[    5.758334] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    5.758498] saa7133[0]: found at 0000:03:06.0, rev: 209, irq: 21, 
latency: 64, mmio: 0xfdeff000
[    5.758514] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 
310i [card=101,autodetected]
[    5.758569] saa7133[0]: board init: gpio is 600c000
[    5.861175] saa7133[0]: i2c eeprom read error (err=-5)
[    6.063369] i2c-core: driver [tuner] using legacy suspend method
[    6.063382] i2c-core: driver [tuner] using legacy resume method
[    6.487041] tuner 5-004b: Tuner -1 found with type(s) Radio TV.
[    6.523079] tda829x 5-004b: setting tuner address to 61
[    6.565254] tda829x 5-004b: ANDERS: setting switch_addr. was 0x00, 
new 0x4b
[    6.565265] tda829x 5-004b: ANDERS: new 0x61
[    6.571031] tda829x 5-004b: type set to tda8290+75a
[    8.715040] hda-intel: azx_get_response timeout, switching to polling 
mode: last cmd=0x000f0000
[    9.568135] saa7133[0]: registered device video1 [v4l2]
[    9.568213] saa7133[0]: registered device vbi0
[    9.568285] saa7133[0]: registered device radio0
[    9.597534] dvb_init() allocating 1 frontend
[    9.615047] DVB: registering new adapter (saa7133[0])
[    9.615060] DVB: registering adapter 0 frontend 0 (Philips TDA10046H 
DVB-T)...
[    9.667056] tda1004x: setting up plls for 48MHz sampling clock
[    9.716022] hda-intel: No response from codec, disabling MSI: last 
cmd=0x000f0000
[   10.717036] hda-intel: Codec #0 probe error; disabling it...
[   11.851032] tda1004x: timeout waiting for DSP ready
[   11.861026] tda1004x: found firmware revision 0 -- invalid
[   11.861032] tda1004x: trying to boot from eeprom
[   12.828031] hda_intel: azx_get_response timeout, switching to 
single_cmd mode: last cmd=0x00070503
[   12.833029] hda-codec: No codec parser is available
[   14.169029] tda1004x: timeout waiting for DSP ready
[   14.179024] tda1004x: found firmware revision 0 -- invalid
[   14.179047] tda1004x: waiting for firmware upload...
[   24.195035] tda1004x: timeout waiting for DSP ready
[   24.205025] tda1004x: found firmware revision 0 -- invalid
[   24.205031] tda1004x: firmware upload failed
[   24.327099] saa7134 ALSA driver for DMA sound loaded
[   24.327166] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 21 
registered as card -1
[   86.067258] EXT3-fs (sda3): using internal journal
[   86.282706] kjournald starting.  Commit interval 5 seconds
[   86.283033] EXT3-fs (sda1): using internal journal
[   86.283057] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   86.317804] kjournald starting.  Commit interval 5 seconds
[   86.318048] EXT3-fs (dm-2): using internal journal
[   86.318055] EXT3-fs (dm-2): mounted filesystem with writeback data mode
[   86.414727] kjournald starting.  Commit interval 5 seconds
[   86.415075] EXT3-fs (dm-3): using internal journal
[   86.415082] EXT3-fs (dm-3): mounted filesystem with writeback data mode
[   86.439344] kjournald starting.  Commit interval 5 seconds
[   86.439857] EXT3-fs (dm-4): using internal journal
[   86.439864] EXT3-fs (dm-4): mounted filesystem with writeback data mode
[   86.502842] EXT4-fs (dm-5): mounted filesystem with ordered data 
mode. Opts: (null)
[   86.664276] EXT4-fs (dm-8): mounted filesystem with ordered data 
mode. Opts: (null)
[   86.719547] kjournald starting.  Commit interval 5 seconds
[   86.719916] EXT3-fs (dm-6): using internal journal
[   86.719924] EXT3-fs (dm-6): mounted filesystem with writeback data mode
[   86.745408] EXT4-fs (dm-7): mounted filesystem with ordered data 
mode. Opts: (null)
[   86.805303] EXT4-fs (dm-0): mounted filesystem without journal. Opts: 
(null)
[   86.892045] EXT4-fs (dm-1): mounted filesystem with ordered data 
mode. Opts: (null)
[   89.622234] Adding 10490440k swap on /dev/sda2.  Priority:-1 
extents:1 across:10490440k
[   90.770896] r8169 0000:02:00.0: eth0: link down
[   90.771780] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   91.263841] ADDRCONF(NETDEV_UP): eth0.2: link is not ready
[   92.469649] r8169 0000:02:00.0: eth0: link up
[   92.470545] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   92.471305] ADDRCONF(NETDEV_CHANGE): eth0.2: link becomes ready
[   99.765095] input: lircmd as /devices/virtual/input/input11
[  102.962022] eth0: no IPv6 routers present
[  102.962033] eth0.2: no IPv6 routers present
[  103.857743] input: iMON Panel, Knob and Mouse(15c2:ffdc) (lircd 
bypass) as /devices/virtual/input/input12

