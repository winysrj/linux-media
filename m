Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:47520 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab2DHNYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Apr 2012 09:24:43 -0400
From: Michael Hagner <mikahagner@arcor.de>
To: pdickeybeta@gmail.com, Edd Barker <eddb@rker.me.uk>
Subject: Re: DVB-T USB Stick Pinnacle PCTV
Date: Sun, 8 Apr 2012 15:24:31 +0200
Cc: linux-media@vger.kernel.org
References: <201204070522.06252.mikahagner@arcor.de> <1333858747.3950.95.camel@dcky-ubuntu64>
In-Reply-To: <1333858747.3950.95.camel@dcky-ubuntu64>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QGZgPl1pf8FS5ZW"
Message-Id: <201204081524.32461.mikahagner@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_QGZgPl1pf8FS5ZW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Am Sonntag, 8. April 2012, um 06:19:07 schrieb Patrick Dickey:
> Hello Michael,
> 
> Which Pinnacle PCTV tuner do you have (PCTV 290e, PCTV 80e, etc)? The
> 80e is not supported yet, although it's in the works. What does lsusb
> show for information about the tuner?
> 
> Have a great day:)
> Patrick.
> 
> On Sat, 2012-04-07 at 05:22 +0200, Michael Hagner wrote:
> > Hello,
> > 
> > I' ve tried to install the above mentioned USB-device,
> > but the system doesn't work e.g. the device hasn't
> > been recognized from the system.
> > 
> > Kubuntu 10.10 Kernel ...35.28
> > 
> > Do you have some information to solve that problem ?
> > 
> >  I believe, that's  the USB port....maybe I've to use the insmod....see
> >  the
> > 
> > bold red mark in the syslog.
> > 
> > Thanks in advance...
> > 
> > Michael
> > 
> > Att.: Syslog
------------------------------------------------------------
Hi Michael.

If I remember right this stick needs the media_build git. Try:

git clone git://linuxtv.org/media_build.git
cd media_build
./build

I can check more when I'm at my pc if that doesn't work.

Edd
---------------------------------------------------------------
Hello Edd and Patrick,

at first I've upgraded as Edd mentioned, but it didn't work.
So, I've added the following command lines:

sudo rmmod em28xx
sudo modprobe em28xx card=45     'card no. for the PCTV DVB-T USB-Stick'
sudo modprobe em28xx-dvb 

But it didnt work anyway....

No, here are the results for the lsusb- and dmesg-commands afterwards.

By the way, do you know, where I will get the 
'xc3028-v.27.sh'-script-file ????
Is there any firmware-file from pinnacle for my Stick, that means an file like 
'hcw85bda.sys' for the 'Cinergy Hybrid T USB XS' card ?


Thanks...and happy Easter....:o))  Mike


















--Boundary-00=_QGZgPl1pf8FS5ZW
Content-Type: text/plain;
  charset="UTF-8";
  name="20120804_lsusb.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="20120804_lsusb.txt"

mika@mika-X51R:~$ lsusb
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
mika@mika-X51R:~$ 































                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    
                                                                                                                                                                                    

--Boundary-00=_QGZgPl1pf8FS5ZW
Content-Type: text/plain;
  charset="UTF-8";
  name="20120804_dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="20120804_dmesg.txt"

[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 8 pages used for memmap
[    0.000000]   HighMem zone: 930 pages, LIFO batch:0
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [16000 - 167ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 38000000 (gap: 38000000:c6e00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages/cpu @c1800000 s39872 r0 d21568 u1048576
[    0.000000] pcpu-alloc: s39872 r0 d21568 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227383
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-28-generic-pae root=UUID=4fa23b85-2a59-4489-ae80-6803e76fa8bc ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4585440 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Subtract (48 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 00009fd65c]   TEXT DATA BSS
[    0.000000]   #3 [00295be000 - 0029ffe000]         RAMDISK
[    0.000000]   #4 [00009fe000 - 0000a051f6]             BRK
[    0.000000]   #5 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #6 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #7 [000009fc00 - 00000fcaf0]   BIOS reserved
[    0.000000]   #8 [00000fcc5c - 00000ff780]   BIOS reserved
[    0.000000]   #9 [00000fcaf0 - 00000fcc5c]    MP-table mpc
[    0.000000]   #10 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #11 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #12 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #13 [0001000000 - 0001001000]         BOOTMEM
[    0.000000]   #14 [0001001000 - 0001701000]         BOOTMEM
[    0.000000]   #15 [0001701000 - 0001701004]         BOOTMEM
[    0.000000]   #16 [0001701040 - 0001701100]         BOOTMEM
[    0.000000]   #17 [0001701100 - 00017011a8]         BOOTMEM
[    0.000000]   #18 [00017011c0 - 00017041c0]         BOOTMEM
[    0.000000]   #19 [00017041c0 - 00017041c4]         BOOTMEM
[    0.000000]   #20 [0001704200 - 0001704230]         BOOTMEM
[    0.000000]   #21 [0001704240 - 000170426f]         BOOTMEM
[    0.000000]   #22 [0001704280 - 000170440c]         BOOTMEM
[    0.000000]   #23 [0001704440 - 0001704480]         BOOTMEM
[    0.000000]   #24 [0001704480 - 00017044c0]         BOOTMEM
[    0.000000]   #25 [00017044c0 - 0001704500]         BOOTMEM
[    0.000000]   #26 [0001704500 - 0001704540]         BOOTMEM
[    0.000000]   #27 [0001704540 - 0001704580]         BOOTMEM
[    0.000000]   #28 [0001704580 - 00017045c0]         BOOTMEM
[    0.000000]   #29 [00017045c0 - 0001704600]         BOOTMEM
[    0.000000]   #30 [0001704600 - 0001704640]         BOOTMEM
[    0.000000]   #31 [0001704640 - 0001704680]         BOOTMEM
[    0.000000]   #32 [0001704680 - 00017046c0]         BOOTMEM
[    0.000000]   #33 [00017046c0 - 00017046d0]         BOOTMEM
[    0.000000]   #34 [0001704700 - 000170476e]         BOOTMEM
[    0.000000]   #35 [0001704780 - 00017047ee]         BOOTMEM
[    0.000000]   #36 [0001800000 - 000180f000]         BOOTMEM
[    0.000000]   #37 [0001900000 - 000190f000]         BOOTMEM
[    0.000000]   #38 [0001706800 - 0001706804]         BOOTMEM
[    0.000000]   #39 [0001706840 - 0001706844]         BOOTMEM
[    0.000000]   #40 [0001706880 - 0001706888]         BOOTMEM
[    0.000000]   #41 [00017068c0 - 00017068c8]         BOOTMEM
[    0.000000]   #42 [0001706900 - 00017069a0]         BOOTMEM
[    0.000000]   #43 [00017069c0 - 0001706a08]         BOOTMEM
[    0.000000]   #44 [0001706a40 - 000170aa40]         BOOTMEM
[    0.000000]   #45 [000170aa40 - 000178aa40]         BOOTMEM
[    0.000000]   #46 [000178aa40 - 00017caa40]         BOOTMEM
[    0.000000]   #47 [000190f000 - 0001d6e7e0]         BOOTMEM
[    0.000000] Initializing HighMem for node 0 (00037bfe:00037fa8)
[    0.000000] Memory: 884364k/917152k available (5092k kernel code, 32336k reserved, 2433k data, 708k init, 3752k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
[    0.000000]       .init : 0xc085a000 - 0xc090b000   ( 708 kB)
[    0.000000]       .data : 0xc05f931a - 0xc0859908   (2433 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05f931a   (5092 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.054 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.10 BogoMIPS (lpj=7980216)
[    0.004011] pid_max: default: 32768 minimum: 301
[    0.004031] Security Framework initialized
[    0.004054] AppArmor: AppArmor initialized
[    0.004057] Yama: becoming mindful.
[    0.004119] Mount-cache hash table entries: 512
[    0.004263] Initializing cgroup subsys ns
[    0.004268] Initializing cgroup subsys cpuacct
[    0.004273] Initializing cgroup subsys memory
[    0.004283] Initializing cgroup subsys devices
[    0.004286] Initializing cgroup subsys freezer
[    0.004288] Initializing cgroup subsys net_cls
[    0.004319] CPU: Physical Processor ID: 0
[    0.004322] CPU: Processor Core ID: 0
[    0.004325] mce: CPU supports 6 MCE banks
[    0.004335] CPU0: Thermal monitoring handled by SMI
[    0.004339] using mwait in idle threads.
[    0.004346] Performance Events: Core events, core PMU driver.
[    0.004354] ... version:                1
[    0.004356] ... bit width:              40
[    0.004358] ... generic registers:      2
[    0.004361] ... value mask:             000000ffffffffff
[    0.004363] ... max period:             000000007fffffff
[    0.004365] ... fixed-purpose events:   0
[    0.004367] ... event mask:             0000000000000003
[    0.009030] ACPI: Core revision 20100428
[    0.022494] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.022501] ftrace: allocating 22398 entries in 44 pages
[    0.024086] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024437] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.066894] CPU0: Intel(R) Core(TM) Duo CPU      T2450  @ 2.00GHz stepping 0c
[    0.068000] Booting Node   0, Processors  #1 Ok.
[    0.008000] Initializing CPU#1
[    0.008000] CPU1: Thermal monitoring handled by SMI
[    0.156033] Brought up 2 CPUs
[    0.156038] Total of 2 processors activated (7980.59 BogoMIPS).
[    0.156666] devtmpfs: initialized
[    0.157145] regulator: core version 0.5
[    0.157176] Time: 12:07:19  Date: 04/08/12
[    0.157225] NET: Registered protocol family 16
[    0.157262] Trying to unpack rootfs image as initramfs...
[    0.157387] EISA bus registered
[    0.157397] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.157401] ACPI: bus type pci registered
[    0.157495] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.157500] PCI: not using MMCONFIG
[    0.157693] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=9
[    0.157696] PCI: Using configuration type 1 for base access
[    0.164086] bio: create slab <bio-0> at 0
[    0.166396] ACPI: EC: Look up EC in DSDT
[    0.169079] ACPI: Executed 4 blocks of module-level executable AML code
[    0.212537] ACPI: SSDT 37fbe2a0 00D1C (v01    AMI   CPU1PM 00000001 INTL 20051117)
[    0.213215] ACPI: Dynamic OEM Table Load:
[    0.213219] ACPI: SSDT (null) 00D1C (v01    AMI   CPU1PM 00000001 INTL 20051117)
[    0.214013] ACPI: SSDT 37fbefc0 00D1C (v01    AMI   CPU2PM 00000001 INTL 20051117)
[    0.214681] ACPI: Dynamic OEM Table Load:
[    0.214685] ACPI: SSDT (null) 00D1C (v01    AMI   CPU2PM 00000001 INTL 20051117)
[    0.215012] ACPI: Interpreter enabled
[    0.215020] ACPI: (supports S0 S3 S4 S5)
[    0.215051] ACPI: Using IOAPIC for interrupt routing
[    0.215134] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.216364] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.216367] PCI: Using MMCONFIG for extended config space
[    0.226445] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.226704] ACPI: No dock devices found.
[    0.226711] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.226882] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.227223] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.227226] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.227230] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.227233] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.227236] pci_root PNP0A03:00: host bridge window [mem 0x38000000-0xffffffff] (ignored)
[    0.227390] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.227394] pci 0000:00:04.0: PME# disabled
[    0.227483] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.227487] pci 0000:00:05.0: PME# disabled
[    0.227552] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.227556] pci 0000:00:06.0: PME# disabled
[    0.227621] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.227625] pci 0000:00:07.0: PME# disabled
[    0.227692] pci 0000:00:12.0: reg 10: [io  0xe800-0xe807]
[    0.227702] pci 0000:00:12.0: reg 14: [io  0xe400-0xe403]
[    0.227712] pci 0000:00:12.0: reg 18: [io  0xe000-0xe007]
[    0.227722] pci 0000:00:12.0: reg 1c: [io  0xdc00-0xdc03]
[    0.227731] pci 0000:00:12.0: reg 20: [io  0xd800-0xd80f]
[    0.227741] pci 0000:00:12.0: reg 24: [mem 0xfebffc00-0xfebfffff]
[    0.227768] pci 0000:00:12.0: set SATA to AHCI mode
[    0.227830] pci 0000:00:13.0: reg 10: [mem 0xfebfe000-0xfebfefff]
[    0.227921] pci 0000:00:13.1: reg 10: [mem 0xfebfd000-0xfebfdfff]
[    0.228010] pci 0000:00:13.2: reg 10: [mem 0xfebfc000-0xfebfcfff]
[    0.228092] pci 0000:00:13.3: reg 10: [mem 0xfebfb000-0xfebfbfff]
[    0.228174] pci 0000:00:13.4: reg 10: [mem 0xfebfa000-0xfebfafff]
[    0.228294] pci 0000:00:13.5: reg 10: [mem 0xfebff800-0xfebff8ff]
[    0.228372] pci 0000:00:13.5: supports D1 D2
[    0.228375] pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
[    0.228381] pci 0000:00:13.5: PME# disabled
[    0.228430] pci 0000:00:14.0: reg 10: [io  0x0b00-0x0b0f]
[    0.228513] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.228523] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.228533] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.228542] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.228552] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.228625] pci 0000:00:14.2: reg 10: [mem 0xfebf4000-0xfebf7fff 64bit]
[    0.228703] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.228711] pci 0000:00:14.2: PME# disabled
[    0.228923] pci 0000:01:05.0: reg 10: [mem 0x90000000-0x9fffffff pref]
[    0.228929] pci 0000:01:05.0: reg 14: [io  0x7800-0x78ff]
[    0.228935] pci 0000:01:05.0: reg 18: [mem 0xf88f0000-0xf88fffff]
[    0.228951] pci 0000:01:05.0: reg 30: [mem 0xf88c0000-0xf88dffff pref]
[    0.228968] pci 0000:01:05.0: supports D1 D2
[    0.228997] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.229003] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.229008] pci 0000:00:01.0:   bridge window [mem 0xf8800000-0xf88fffff]
[    0.229012] pci 0000:00:01.0:   bridge window [mem 0x8ff00000-0xafefffff pref]
[    0.229100] pci 0000:02:00.0: reg 10: [mem 0xf89f0000-0xf89fffff 64bit]
[    0.229226] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.229229] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.229236] pci 0000:00:04.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.229241] pci 0000:00:04.0:   bridge window [mem 0xf8900000-0xf89fffff]
[    0.229247] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.229292] pci 0000:00:05.0: PCI bridge to [bus 03-05]
[    0.229298] pci 0000:00:05.0:   bridge window [io  0x8000-0x9fff]
[    0.229303] pci 0000:00:05.0:   bridge window [mem 0xf8a00000-0xfc9fffff]
[    0.229309] pci 0000:00:05.0:   bridge window [mem 0xaff00000-0xcfefffff 64bit pref]
[    0.229354] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    0.229360] pci 0000:00:06.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.229365] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.229371] pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.229417] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.229423] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.229427] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.229434] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.229497] pci 0000:08:01.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.229531] pci 0000:08:01.0: supports D1 D2
[    0.229533] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229540] pci 0000:08:01.0: PME# disabled
[    0.229602] pci 0000:08:01.1: reg 10: [mem 0xfeaffc00-0xfeaffcff]
[    0.229693] pci 0000:08:01.1: supports D1 D2
[    0.229695] pci 0000:08:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229702] pci 0000:08:01.1: PME# disabled
[    0.229754] pci 0000:08:01.2: reg 10: [mem 0xfeaff800-0xfeaff8ff]
[    0.229838] pci 0000:08:01.2: supports D1 D2
[    0.229841] pci 0000:08:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.229847] pci 0000:08:01.2: PME# disabled
[    0.229922] pci 0000:08:07.0: reg 10: [io  0xb800-0xb8ff]
[    0.229933] pci 0000:08:07.0: reg 14: [mem 0xfeaff400-0xfeaff4ff]
[    0.230010] pci 0000:08:07.0: supports D1 D2
[    0.230013] pci 0000:08:07.0: PME# supported from D1 D2 D3hot D3cold
[    0.230020] pci 0000:08:07.0: PME# disabled
[    0.230103] pci 0000:00:14.4: PCI bridge to [bus 08-09] (subtractive decode)
[    0.230110] pci 0000:00:14.4:   bridge window [io  0xa000-0xbfff]
[    0.230117] pci 0000:00:14.4:   bridge window [mem 0xfca00000-0xfeafffff]
[    0.230123] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfefffff pref]
[    0.230127] pci 0000:00:14.4:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    0.230130] pci 0000:00:14.4:   bridge window [mem 0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.230193] pci_bus 0000:09: [bus 09-0c] partially hidden behind transparent bridge 0000:08 [bus 08-09]
[    0.230224] pci_bus 0000:00: on NUMA node 0
[    0.230233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.230368] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.230525] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.230618] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
[    0.230700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.230809] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.230986] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
[    0.239263] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *11 12)
[    0.239434] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 12)
[    0.239582] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 12)
[    0.239722] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 12) *10
[    0.239869] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 12)
[    0.240015] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 12)
[    0.240155] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12)
[    0.240310] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 12)
[    0.240364] HEST: Table is not found!
[    0.240501] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.240508] vgaarb: loaded
[    0.240734] SCSI subsystem initialized
[    0.240876] libata version 3.00 loaded.
[    0.240970] usbcore: registered new interface driver usbfs
[    0.240986] usbcore: registered new interface driver hub
[    0.241023] usbcore: registered new device driver usb
[    0.241188] ACPI: WMI: Mapper loaded
[    0.241191] PCI: Using ACPI for IRQ routing
[    0.241252] PCI: pci_cache_line_size set to 64 bytes
[    0.241411] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.241415] reserve RAM buffer: 0000000037fa8000 - 0000000037ffffff 
[    0.241555] NetLabel: Initializing
[    0.241558] NetLabel:  domain hash size = 128
[    0.241559] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.241577] NetLabel:  unlabeled traffic allowed by default
[    0.241631] Switching to clocksource tsc
[    0.255062] AppArmor: AppArmor Filesystem Enabled
[    0.255104] pnp: PnP ACPI init
[    0.255159] ACPI: bus type pnp registered
[    0.258085] pnp: PnP ACPI: found 12 devices
[    0.258090] ACPI: ACPI bus type pnp unregistered
[    0.258095] PnPBIOS: Disabled by ACPI PNP
[    0.258119] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.258122] system 00:05: [io  0x040b] has been reserved
[    0.258126] system 00:05: [io  0x04d6] has been reserved
[    0.258129] system 00:05: [io  0x0c00-0x0c01] has been reserved
[    0.258132] system 00:05: [io  0x0c14] has been reserved
[    0.258135] system 00:05: [io  0x0c50-0x0c51] has been reserved
[    0.258139] system 00:05: [io  0x0c52] has been reserved
[    0.258142] system 00:05: [io  0x0c6c] has been reserved
[    0.258145] system 00:05: [io  0x0c6f] has been reserved
[    0.258148] system 00:05: [io  0x0cd0-0x0cd1] has been reserved
[    0.258152] system 00:05: [io  0x0cd2-0x0cd3] has been reserved
[    0.258155] system 00:05: [io  0x0cd4-0x0cd5] has been reserved
[    0.258158] system 00:05: [io  0x0cd6-0x0cd7] has been reserved
[    0.258162] system 00:05: [io  0x0cd8-0x0cdf] has been reserved
[    0.258165] system 00:05: [io  0x0800-0x089f] has been reserved
[    0.258168] system 00:05: [io  0x0b00-0x0b1f] could not be reserved
[    0.258172] system 00:05: [io  0x0900-0x090f] has been reserved
[    0.258175] system 00:05: [io  0x0910-0x091f] has been reserved
[    0.258179] system 00:05: [io  0xfe00-0xfefe] has been reserved
[    0.258182] system 00:05: [io  0x4000-0x40fe] has been reserved
[    0.258196] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.258199] system 00:05: [mem 0xfed45000-0xfed89fff] has been reserved
[    0.258203] system 00:05: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.258217] system 00:05: [mem 0xfff80000-0xffffffff] has been reserved
[    0.258225] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.258229] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.258243] system 00:09: [io  0x025c] has been reserved
[    0.258246] system 00:09: [io  0x025d] has been reserved
[    0.258249] system 00:09: [io  0x025e] has been reserved
[    0.258252] system 00:09: [io  0x025f] has been reserved
[    0.258258] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.258265] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.258268] system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.258272] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.258275] system 00:0b: [mem 0x00100000-0x37ffffff] could not be reserved
[    0.294756] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.294767] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.294772] pci 0000:00:01.0:   bridge window [mem 0xf8800000-0xf88fffff]
[    0.294777] pci 0000:00:01.0:   bridge window [mem 0x8ff00000-0xafefffff pref]
[    0.294783] pci 0000:00:04.0: PCI bridge to [bus 02-02]
[    0.294785] pci 0000:00:04.0:   bridge window [io  disabled]
[    0.294790] pci 0000:00:04.0:   bridge window [mem 0xf8900000-0xf89fffff]
[    0.294794] pci 0000:00:04.0:   bridge window [mem pref disabled]
[    0.294800] pci 0000:00:05.0: PCI bridge to [bus 03-05]
[    0.294804] pci 0000:00:05.0:   bridge window [io  0x8000-0x9fff]
[    0.294809] pci 0000:00:05.0:   bridge window [mem 0xf8a00000-0xfc9fffff]
[    0.294813] pci 0000:00:05.0:   bridge window [mem 0xaff00000-0xcfefffff 64bit pref]
[    0.294819] pci 0000:00:06.0: PCI bridge to [bus 06-06]
[    0.294821] pci 0000:00:06.0:   bridge window [io  disabled]
[    0.294826] pci 0000:00:06.0:   bridge window [mem disabled]
[    0.294829] pci 0000:00:06.0:   bridge window [mem pref disabled]
[    0.294835] pci 0000:00:07.0: PCI bridge to [bus 07-07]
[    0.294837] pci 0000:00:07.0:   bridge window [io  disabled]
[    0.294842] pci 0000:00:07.0:   bridge window [mem disabled]
[    0.294845] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.294861] pci 0000:08:01.0: BAR 15: assigned [mem 0xd0000000-0xd3ffffff pref]
[    0.294867] pci 0000:08:01.0: BAR 16: assigned [mem 0x38000000-0x3bffffff]
[    0.294870] pci 0000:08:01.0: BAR 0: assigned [mem 0xfca00000-0xfca00fff]
[    0.294879] pci 0000:08:01.0: BAR 0: set to [mem 0xfca00000-0xfca00fff] (PCI address [0xfca00000-0xfca00fff]
[    0.294883] pci 0000:08:01.0: BAR 13: assigned [io  0xa000-0xa0ff]
[    0.294886] pci 0000:08:01.0: BAR 14: assigned [io  0xa400-0xa4ff]
[    0.294889] pci 0000:08:01.0: CardBus bridge to [bus 09-0c]
[    0.294892] pci 0000:08:01.0:   bridge window [io  0xa000-0xa0ff]
[    0.294899] pci 0000:08:01.0:   bridge window [io  0xa400-0xa4ff]
[    0.294906] pci 0000:08:01.0:   bridge window [mem 0xd0000000-0xd3ffffff pref]
[    0.294914] pci 0000:08:01.0:   bridge window [mem 0x38000000-0x3bffffff]
[    0.294921] pci 0000:00:14.4: PCI bridge to [bus 08-09]
[    0.294925] pci 0000:00:14.4:   bridge window [io  0xa000-0xbfff]
[    0.294933] pci 0000:00:14.4:   bridge window [mem 0xfca00000-0xfeafffff]
[    0.294939] pci 0000:00:14.4:   bridge window [mem 0xcff00000-0xdfefffff pref]
[    0.294991] pci 0000:00:04.0: setting latency timer to 64
[    0.295003] pci 0000:00:05.0: setting latency timer to 64
[    0.295014] pci 0000:00:06.0: setting latency timer to 64
[    0.295023] pci 0000:00:07.0: setting latency timer to 64
[    0.295055]   alloc irq_desc for 21 on node -1
[    0.295058]   alloc kstat_irqs on node -1
[    0.295071] pci 0000:08:01.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    0.295080] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.295083] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.295086] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.295089] pci_bus 0000:01: resource 1 [mem 0xf8800000-0xf88fffff]
[    0.295092] pci_bus 0000:01: resource 2 [mem 0x8ff00000-0xafefffff pref]
[    0.295095] pci_bus 0000:02: resource 1 [mem 0xf8900000-0xf89fffff]
[    0.295098] pci_bus 0000:03: resource 0 [io  0x8000-0x9fff]
[    0.295101] pci_bus 0000:03: resource 1 [mem 0xf8a00000-0xfc9fffff]
[    0.295104] pci_bus 0000:03: resource 2 [mem 0xaff00000-0xcfefffff 64bit pref]
[    0.295107] pci_bus 0000:08: resource 0 [io  0xa000-0xbfff]
[    0.295110] pci_bus 0000:08: resource 1 [mem 0xfca00000-0xfeafffff]
[    0.295113] pci_bus 0000:08: resource 2 [mem 0xcff00000-0xdfefffff pref]
[    0.295116] pci_bus 0000:08: resource 4 [io  0x0000-0xffff]
[    0.295119] pci_bus 0000:08: resource 5 [mem 0x00000000-0xffffffffffffffff]
[    0.295122] pci_bus 0000:09: resource 0 [io  0xa000-0xa0ff]
[    0.295125] pci_bus 0000:09: resource 1 [io  0xa400-0xa4ff]
[    0.295128] pci_bus 0000:09: resource 2 [mem 0xd0000000-0xd3ffffff pref]
[    0.295131] pci_bus 0000:09: resource 3 [mem 0x38000000-0x3bffffff]
[    0.295210] NET: Registered protocol family 2
[    0.295317] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.295797] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.297720] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.298883] TCP: Hash tables configured (established 131072 bind 65536)
[    0.298889] TCP reno registered
[    0.298896] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.298938] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.299160] NET: Registered protocol family 1
[    0.299191] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.299364] pci 0000:01:05.0: Boot video device
[    0.299390] PCI: CLS 64 bytes, default 64
[    0.299439] Simple Boot Flag at 0xff set to 0x1
[    0.299759] cpufreq-nforce2: No nForce2 chipset.
[    0.299799] Scanning for low memory corruption every 60 seconds
[    0.299977] audit: initializing netlink socket (disabled)
[    0.299997] type=2000 audit(1333886839.296:1): initialized
[    0.312239] highmem bounce pool size: 64 pages
[    0.312248] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.314397] VFS: Disk quotas dquot_6.5.2
[    0.314478] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.315223] fuse init (API version 7.14)
[    0.315331] msgmni has been set to 1719
[    0.489863] Freeing initrd memory: 10496k freed
[    0.517600] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.517606] io scheduler noop registered
[    0.517608] io scheduler deadline registered
[    0.517632] io scheduler cfq registered (default)
[    0.517815] pcieport 0000:00:04.0: setting latency timer to 64
[    0.517856]   alloc irq_desc for 40 on node -1
[    0.517859]   alloc kstat_irqs on node -1
[    0.517875] pcieport 0000:00:04.0: irq 40 for MSI/MSI-X
[    0.517944] pcieport 0000:00:05.0: setting latency timer to 64
[    0.517978]   alloc irq_desc for 41 on node -1
[    0.517980]   alloc kstat_irqs on node -1
[    0.517987] pcieport 0000:00:05.0: irq 41 for MSI/MSI-X
[    0.518066] pcieport 0000:00:06.0: setting latency timer to 64
[    0.518101]   alloc irq_desc for 42 on node -1
[    0.518103]   alloc kstat_irqs on node -1
[    0.518109] pcieport 0000:00:06.0: irq 42 for MSI/MSI-X
[    0.518171] pcieport 0000:00:07.0: setting latency timer to 64
[    0.518205]   alloc irq_desc for 43 on node -1
[    0.518207]   alloc kstat_irqs on node -1
[    0.518214] pcieport 0000:00:07.0: irq 43 for MSI/MSI-X
[    0.518303] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.518412] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.518529] intel_idle: MWAIT substates: 0x22220
[    0.518531] intel_idle: does not run on family 6 model 14
[    0.518770] ACPI: AC Adapter [AC0] (on-line)
[    0.518872] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.519856] ACPI: Lid Switch [LID]
[    0.519930] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.519942] ACPI: Power Button [PWRB]
[    0.519995] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.520000] ACPI: Sleep Button [SLPB]
[    0.520059] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.520063] ACPI: Power Button [PWRF]
[    0.520522] ACPI: acpi_idle registered with cpuidle
[    0.521324] Marking TSC unstable due to TSC halts in idle
[    0.521459] Switching to clocksource acpi_pm
[    0.525685] thermal LNXTHERM:01: registered as thermal_zone0
[    0.525695] ACPI: Thermal Zone [THRM] (33 C)
[    0.525786] ERST: Table is not found!
[    0.526003] isapnp: Scanning for PnP cards...
[    0.526046] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.527875] brd: module loaded
[    0.528541] loop: module loaded
[    0.528836]   alloc irq_desc for 16 on node -1
[    0.528839]   alloc kstat_irqs on node -1
[    0.528847] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.528916] pata_acpi 0000:00:14.1: setting latency timer to 64
[    0.529279] Fixed MDIO Bus: probed
[    0.529317] PPP generic driver version 2.4.2
[    0.529366] tun: Universal TUN/TAP device driver, 1.6
[    0.529368] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.529474] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.529496]   alloc irq_desc for 19 on node -1
[    0.529499]   alloc kstat_irqs on node -1
[    0.529503] ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.529528] ehci_hcd 0000:00:13.5: EHCI Host Controller
[    0.529571] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[    0.529610] ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
[    0.529630] ehci_hcd 0000:00:13.5: debug port 1
[    0.529663] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfebff800
[    0.545135] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
[    0.545330] hub 1-0:1.0: USB hub found
[    0.545337] hub 1-0:1.0: 10 ports detected
[    0.545450] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.545465] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.545476] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.545511] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[    0.545546] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfebfe000
[    0.548727] ACPI: Battery Slot [BAT0] (battery present)
[    0.608116] hub 2-0:1.0: USB hub found
[    0.608125] hub 2-0:1.0: 2 ports detected
[    0.608200]   alloc irq_desc for 17 on node -1
[    0.608202]   alloc kstat_irqs on node -1
[    0.608207] ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.608217] ohci_hcd 0000:00:13.1: OHCI Host Controller

[    0.608253] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[    0.608282] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfebfd000
[    0.668119] hub 3-0:1.0: USB hub found
[    0.668128] hub 3-0:1.0: 2 ports detected
[    0.668199]   alloc irq_desc for 18 on node -1
[    0.668201]   alloc kstat_irqs on node -1
[    0.668206] ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.668217] ohci_hcd 0000:00:13.2: OHCI Host Controller
[    0.668252] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    0.668283] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfebfc000
[    0.728130] hub 4-0:1.0: USB hub found
[    0.728138] hub 4-0:1.0: 2 ports detected
[    0.728214] ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.728225] ohci_hcd 0000:00:13.3: OHCI Host Controller
[    0.728260] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[    0.728279] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfebfb000
[    0.788138] hub 5-0:1.0: USB hub found
[    0.788148] hub 5-0:1.0: 2 ports detected
[    0.788231] ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.788241] ohci_hcd 0000:00:13.4: OHCI Host Controller
[    0.788276] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[    0.788295] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfebfa000
[    0.848122] hub 6-0:1.0: USB hub found
[    0.848130] hub 6-0:1.0: 2 ports detected
[    0.848200] uhci_hcd: USB Universal Host Controller Interface driver
[    0.848309] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.851749] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.852425] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.852435] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.852438] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.852442] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.852445] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.852512] mice: PS/2 mouse device common for all mice
[    0.852680] rtc_cmos 00:02: RTC can wake from S4
[    0.852723] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.852752] rtc0: alarms up to one month, y3k, 114 bytes nvram
[    0.852881] device-mapper: uevent: version 1.0.3
[    0.853018] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.853105] device-mapper: multipath: version 1.1.1 loaded
[    0.853108] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.853243] EISA: Probing bus 0 at eisa.0
[    0.853270] Cannot allocate resource for EISA slot 4
[    0.853283] Cannot allocate resource for EISA slot 7
[    0.853286] Cannot allocate resource for EISA slot 8
[    0.853288] EISA: Detected 0 cards.
[    0.853446] cpuidle: using governor ladder
[    0.853535] cpuidle: using governor menu
[    0.853902] TCP cubic registered
[    0.854051] NET: Registered protocol family 10
[    0.854498] lo: Disabled Privacy Extensions
[    0.854761] NET: Registered protocol family 17
[    0.872071] Using IPI No-Shortcut mode
[    0.872154] PM: Resume from disk failed.
[    0.872170] registered taskstats version 1
[    0.872520]   Magic number: 8:922:126
[    0.872609] acpi device:01: hash matches
[    0.872652] rtc_cmos 00:02: setting system clock to 2012-04-08 12:07:20 UTC (1333886840)
[    0.872656] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.872658] EDD information not available.
[    0.881013] isapnp: No Plug & Play device found
[    0.881053] Freeing unused kernel memory: 708k freed
[    0.881910] Write protecting the kernel text: 5096k
[    0.882024] Write protecting the kernel read-only data: 2016k
[    0.900558] udev[76]: starting version 163
[    0.904824] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.008008] scsi0 : pata_atiixp
[    1.022777] scsi1 : pata_atiixp
[    1.024075] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.024080] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.188634] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WR02, max UDMA/33
[    1.204590] ata1.01: configured for UDMA/33
[    1.209994] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WR02 PQ: 0 ANSI: 5
[    1.221219] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.221224] Uniform CD-ROM driver Revision: 3.20
[    1.221390] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    1.221483] sr 0:0:1:0: Attached scsi generic sg0 type 5
[    1.227469] ahci 0000:00:12.0: version 3.0
[    1.227495]   alloc irq_desc for 22 on node -1
[    1.227497]   alloc kstat_irqs on node -1
[    1.227508] ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.227548] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[    1.227688] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.227693] ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio ccc 
[    1.228536] sdhci: Secure Digital Host Controller Interface driver
[    1.228539] sdhci: Copyright(c) Pierre Ossman
[    1.233424] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[    1.233457] 8139cp 0000:08:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[    1.234114] sdhci-pci 0000:08:01.1: SDHCI controller found [1180:0822] (rev 17)
[    1.234142]   alloc irq_desc for 23 on node -1
[    1.234145]   alloc kstat_irqs on node -1
[    1.234155] sdhci-pci 0000:08:01.1: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[    1.235183] sdhci-pci 0000:08:01.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    1.236296] Registered led device: mmc0::
[    1.237444] mmc0: SDHCI controller on PCI [0000:08:01.1] using DMA
[    1.237732] 8139too: 8139too Fast Ethernet driver 0.9.28
[    1.237779]   alloc irq_desc for 20 on node -1
[    1.237781]   alloc kstat_irqs on node -1
[    1.237787] 8139too 0000:08:07.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.238836] scsi2 : ahci
[    1.238961] scsi3 : ahci
[    1.239177] scsi4 : ahci
[    1.239258] scsi5 : ahci
[    1.239464] ata3: SATA max UDMA/133 abar m1024@0xfebffc00 port 0xfebffd00 irq 22
[    1.239470] ata4: SATA max UDMA/133 abar m1024@0xfebffc00 port 0xfebffd80 irq 22
[    1.239474] ata5: SATA max UDMA/133 abar m1024@0xfebffc00 port 0xfebffe00 irq 22
[    1.239479] ata6: SATA max UDMA/133 abar m1024@0xfebffc00 port 0xfebffe80 irq 22
[    1.240105] 8139too 0000:08:07.0: eth0: RealTek RTL8139 at 0xb800, 00:1d:60:7f:c1:a9, IRQ 20
[    1.556118] ata6: SATA link down (SStatus 0 SControl 300)
[    1.556171] ata4: SATA link down (SStatus 0 SControl 300)
[    1.556203] ata5: SATA link down (SStatus 0 SControl 300)
[    1.728071] ata3: softreset failed (device not ready)
[    1.728075] ata3: applying SB600 PMP SRST workaround and retrying
[    1.900120] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.901256] ata3.00: ATA-7: Hitachi HTS541612J9SA00, SBDOC70P, max UDMA/100
[    1.901260] ata3.00: 234441648 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.901288] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.902610] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
[    1.902613] ata3.00: configured for UDMA/100
[    1.902805] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS54161 SBDO PQ: 0 ANSI: 5
[    1.903014] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    1.903130] sd 2:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
[    1.903331] sd 2:0:0:0: [sda] Write Protect is off
[    1.903335] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.903420] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.903649]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[    2.395312] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.203551] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[   21.397024] udev[375]: starting version 163
[   21.519433] Adding 1406972k swap on /dev/sda8.  Priority:-1 extents:1 across:1406972k 
[   21.569103] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SMB0 [??? 0x00000b00-0x00000b0f flags 0x30]
[   21.569110] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.570584] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   21.596832] asus_laptop: Asus Laptop Support version 0.42
[   21.606352] Linux agpgart interface v0.103
[   21.674315] cfg80211: Calling CRDA to update world regulatory domain
[   21.693973] asus_laptop: BSTS called, 0x22 returned
[   21.694021] asus_laptop:   X51R model detected
[   21.694514] asus_laptop: Backlight controlled by ACPI video driver
[   21.694584] input: Asus Laptop extra buttons as /devices/platform/asus_laptop/input/input5
[   21.718735] lp: driver loaded but no devices found
[   21.771768] yenta_cardbus 0000:08:01.0: CardBus bridge found [1043:1627]
[   21.799921] type=1400 audit(1333886861.420:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=618 comm="apparmor_parser"
[   21.800645] type=1400 audit(1333886861.424:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=618 comm="apparmor_parser"
[   21.801022] type=1400 audit(1333886861.424:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=618 comm="apparmor_parser"
[   21.834114] acpi device:02: registered as cooling_device2
[   21.834612] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/device:00/LNXVIDEO:00/input/input6
[   21.834760] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[   21.839275] cfg80211: World regulatory domain updated:
[   21.839279]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   21.839283]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   21.839286]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   21.839288]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   21.839291]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   21.839294]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   21.852893] [drm] Initialized drm 1.1.0 20060810
[   21.896876] yenta_cardbus 0000:08:01.0: ISA IRQ mask 0x0cb8, PCI irq 21
[   21.896882] yenta_cardbus 0000:08:01.0: Socket status: 30000006
[   21.896891] pci_bus 0000:08: Raising subordinate bus# of parent bus (#08) from #09 to #0c
[   21.896907] yenta_cardbus 0000:08:01.0: pcmcia: parent PCI bridge window: [io  0xa000-0xbfff]
[   21.896912] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa000-0xbfff: excluding 0xa000-0xa0ff 0xa400-0xa4ff 0xb800-0xb8ff
[   21.920995] ath5k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   21.921014] ath5k 0000:02:00.0: setting latency timer to 64
[   21.921105] ath5k 0000:02:00.0: registered as 'phy0'
[   21.955968] [drm] radeon defaulting to kernel modesetting.
[   21.955974] [drm] radeon kernel modesetting enabled.
[   21.956080] radeon 0000:01:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   21.959323] [drm] initializing kernel modesetting (RS400 0x1002:0x5A62).
[   21.959514] [drm] register mmio base: 0xF88F0000
[   21.959516] [drm] register mmio size: 65536
[   21.959770] [drm:rs400_gart_adjust_size] *ERROR* Forcing to 32M GART size (because of ASIC bug ?)
[   21.959826] [drm] Generation 2 PCI interface, using max accessible memory
[   21.959833] radeon 0000:01:05.0: VRAM: 128M 0x38000000 - 0x3FFFFFFF (128M used)
[   21.959837] radeon 0000:01:05.0: GTT: 32M 0x40000000 - 0x41FFFFFF
[   21.959870] [drm] radeon: irq initialized.
[   22.379201] 
[   22.379210] yenta_cardbus 0000:08:01.0: pcmcia: parent PCI bridge window: [mem 0xfca00000-0xfeafffff]
[   22.379216] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfca00000-0xfeafffff: excluding 0xfca00000-0xfcc0ffff 0xfe8f0000-0xfeafffff
[   22.379234] yenta_cardbus 0000:08:01.0: pcmcia: parent PCI bridge window: [mem 0xcff00000-0xdfefffff pref]
[   22.379238] pcmcia_socket pcmcia_socket0: cs: memory probe 0xcff00000-0xdfefffff: excluding 0xcff00000-0xdfefffff
[   22.396131] [drm] Detected VRAM RAM=128M, BAR=256M
[   22.396135] [drm] RAM width 128bits DDR
[   22.396208] [TTM] Zone  kernel: Available graphics memory: 445908 kiB.
[   22.396211] [TTM] Zone highmem: Available graphics memory: 447784 kiB.
[   22.396214] [TTM] Initializing pool allocator.
[   22.396244] [drm] radeon: 128M of VRAM memory ready
[   22.396247] [drm] radeon: 32M of GTT memory ready.
[   22.396276] [drm] GART: num cpu pages 8192, num gpu pages 8192
[   22.397738] [drm] radeon: 3 quad pipes, 1 z pipes initialized.
[   22.398218] [drm] Loading R300 Microcode
[   22.430612] ath: EEPROM regdomain: 0x60
[   22.430617] ath: EEPROM indicates we should expect a direct regpair map
[   22.430622] ath: Country alpha2 being used: 00
[   22.430624] ath: Regpair used: 0x60
[   22.440058] [drm] radeon: ring at 0x0000000040000000
[   22.440085] [drm] ring test succeeded in 1 usecs
[   22.440270] [drm] radeon: ib pool ready.
[   22.440349] [drm] ib test succeeded in 0 usecs
[   22.440499] [drm] Panel ID String: CMO                     
[   22.440502] [drm] Panel Size 1280x800
[   22.440563] [drm] Radeon Display Connectors
[   22.440565] [drm] Connector 0:
[   22.440567] [drm]   VGA
[   22.440570] [drm]   DDC: 0x68 0x68 0x68 0x68 0x68 0x68 0x68 0x68
[   22.440572] [drm]   Encoders:
[   22.440574] [drm]     CRT1: INTERNAL_DAC2
[   22.440576] [drm] Connector 1:
[   22.440578] [drm]   LVDS
[   22.440581] [drm]   DDC: 0x198 0x198 0x19c 0x19c 0x1a0 0x1a0 0x1a4 0x1a4
[   22.440583] [drm]   Encoders:
[   22.440585] [drm]     LCD1: INTERNAL_LVDS
[   22.441138] phy0: Selected rate control algorithm 'minstrel'
[   22.441891] Registered led device: ath5k-phy0::rx
[   22.441914] Registered led device: ath5k-phy0::tx
[   22.441918] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[   22.496394] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   22.516370] [drm] radeon: power management initialized
[   22.576537] hda_codec: ALC660-VD: BIOS auto-probing.
[   22.581433] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x170-0x177 0x1f0-0x1f7 0x258-0x25f 0x370-0x377
[   22.583793] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x3f0-0x3f7 0x408-0x40f 0x4d0-0x4d7
[   22.584829] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: excluding 0x820-0x89f
[   22.585283] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: excluding 0xc00-0xc07 0xc10-0xc17 0xc50-0xc57 0xc68-0xc6f 0xcd0-0xcdf
[   22.586049] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xe0000-0xfffff
[   22.586117] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[   22.586184] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: clean.
[   22.586258] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[   22.587215] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro
[   22.612675] Synaptics Touchpad, model: 1, fw: 6.1, id: 0xa3a0b3, caps: 0xa04713/0x10008/0x0
[   22.623681] [drm] fb mappable at 0x90040000
[   22.623687] [drm] vram apper at 0x90000000
[   22.623689] [drm] size 4096000
[   22.623691] [drm] fb depth is 24
[   22.623693] [drm]    pitch is 5120
[   22.652550] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
[   22.667239] Console: switching to colour frame buffer device 160x50
[   22.672479] fb0: radeondrmfb frame buffer device
[   22.672483] drm: registered panic notifier
[   22.672488] Slow work thread pool: Starting up
[   22.672567] Slow work thread pool: Ready
[   22.672579] [drm] Initialized radeon 2.5.0 20080528 for 0000:01:05.0 on minor 0
[   23.059474] type=1400 audit(1333886862.680:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=899 comm="apparmor_parser"
[   23.060625] type=1400 audit(1333886862.684:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=899 comm="apparmor_parser"
[   23.061011] type=1400 audit(1333886862.684:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=899 comm="apparmor_parser"
[   23.063622] type=1400 audit(1333886862.684:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/mysqld-akonadi" pid=902 comm="apparmor_parser"
[   23.065253] type=1400 audit(1333886862.688:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=901 comm="apparmor_parser"
[   23.066085] type=1400 audit(1333886862.688:10): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=901 comm="apparmor_parser"
[   23.066326] type=1400 audit(1333886862.688:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=903 comm="apparmor_parser"
[   23.151268] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   23.163387] eth0: link down
[   23.163702] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.643972] ppdev: user-space parallel port driver
[   24.838904] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro,commit=0
[  308.047577] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro,commit=0
[  374.486612] wlan0: authenticate with 00:19:cb:68:c3:24 (try 1)
[  374.489902] wlan0: authenticated
[  374.489943] wlan0: associate with 00:19:cb:68:c3:24 (try 1)
[  374.492223] wlan0: RX AssocResp from 00:19:cb:68:c3:24 (capab=0x431 status=0 aid=1)
[  374.492233] wlan0: associated
[  374.494401] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  378.415842] padlock: VIA PadLock not detected.
[  385.168095] wlan0: no IPv6 routers present
[ 1274.124124] usb 1-7: new high speed USB device using ehci_hcd and address 2
[ 1274.380978] WARNING: You are using an experimental version of the media stack.
[ 1274.380984]  As the driver is backported to an older kernel, it doesn't offer
[ 1274.380987]  enough quality for its usage in production.
[ 1274.380991]  Use it with care.
[ 1274.380993] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[ 1274.380997]  296da3cd14db9eb5606924962b2956c9c656dbb0 [media] pwc: poll(): Check that the device has not beem claimed for streaming already
[ 1274.381002]  0bf0f713d6e6b9f1c510d598c29ac17812a4eea5 [media] vivi: let vb2_poll handle events
[ 1274.381006]  95213ceb1b527b8102c589bd41fcb7c9163fdd79 [media] videobuf2-core: also test for pending events
[ 1274.562326] Linux media interface: v0.10
[ 1274.597627] Linux video capture interface: v2.00
[ 1274.597638] WARNING: You are using an experimental version of the media stack.
[ 1274.597642]  As the driver is backported to an older kernel, it doesn't offer
[ 1274.597645]  enough quality for its usage in production.
[ 1274.597649]  Use it with care.
[ 1274.597651] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[ 1274.597655]  296da3cd14db9eb5606924962b2956c9c656dbb0 [media] pwc: poll(): Check that the device has not beem claimed for streaming already
[ 1274.597660]  0bf0f713d6e6b9f1c510d598c29ac17812a4eea5 [media] vivi: let vb2_poll handle events
[ 1274.597664]  95213ceb1b527b8102c589bd41fcb7c9163fdd79 [media] videobuf2-core: also test for pending events
[ 1274.638153] em28xx: New device  USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class 0)
[ 1274.638162] em28xx: Video interface 0 found
[ 1274.638167] em28xx: DVB interface 0 found
[ 1274.638286] em28xx #0: chip ID is em2870
[ 1274.719679] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
[ 1274.719713] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
[ 1274.719744] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
[ 1274.719775] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 82 65 eb 49
[ 1274.719806] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.719836] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.719866] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 1274.719896] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
[ 1274.719927] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 1274.719957] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.719987] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720017] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720047] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720078] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720108] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720138] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1274.720172] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x988451c0
[ 1274.720178] em28xx #0: EEPROM info:
[ 1274.720182] em28xx #0:       No audio on board.
[ 1274.720187] em28xx #0:       500mA max power
[ 1274.720194] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 1274.799062] em28xx #0: found i2c device @ 0xa0 [eeprom]
[ 1274.805060] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[ 1274.816809] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[ 1274.816818] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[ 1274.816825] em28xx #0: Please send an email with this log to:
[ 1274.816831] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[ 1274.816838] em28xx #0: Board eeprom hash is 0x988451c0
[ 1274.816844] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 1274.816849] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[ 1274.816857] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 1274.816864] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 1274.816871] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 1274.816878] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 1274.816884] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 1274.816891] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 1274.816897] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 1274.816903] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 1274.816910] em28xx #0:     card=8 -> Kworld USB2800
[ 1274.816917] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
[ 1274.816926] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 1274.816932] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 1274.816939] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 1274.816945] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 1274.816952] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 1274.816959] em28xx #0:     card=15 -> V-Gear PocketTV
[ 1274.816965] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 1274.816972] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 1274.816978] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 1274.816985] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 1274.816992] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 1274.816998] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 1274.817039] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 1274.817046] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 1274.817054] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 1274.817067] em28xx #0:     card=25 -> Gadmei UTV310
[ 1274.817079] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 1274.817093] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 1274.817107] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 1274.817121] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[ 1274.817135] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 1274.817149] em28xx #0:     card=31 -> Usbgear VD204v9
[ 1274.817162] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 1274.817175] em28xx #0:     card=33 -> Elgato Video Capture
[ 1274.817188] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 1274.817202] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 1274.817214] em28xx #0:     card=36 -> NetGMBH Cam
[ 1274.817226] em28xx #0:     card=37 -> Gadmei UTV330
[ 1274.817238] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 1274.817251] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 1274.817263] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 1274.817277] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 1274.817290] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 1274.817302] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 1274.817316] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 1274.817330] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 1274.817342] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 1274.817356] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 1274.817369] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 1274.817381] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 1274.817394] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 1274.817407] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 1274.817420] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 1274.817433] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 1274.817445] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 1274.817458] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[ 1274.817474] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 1274.817488] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 1274.817502] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 1274.817515] em28xx #0:     card=59 -> (null)
[ 1274.817527] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 1274.817541] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 1274.817555] em28xx #0:     card=62 -> Gadmei TVR200
[ 1274.817566] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 1274.817579] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 1274.817592] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 1274.817604] em28xx #0:     card=66 -> Empire dual TV
[ 1274.817616] em28xx #0:     card=67 -> Terratec Grabby
[ 1274.817628] em28xx #0:     card=68 -> Terratec AV350
[ 1274.817640] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 1274.817655] em28xx #0:     card=70 -> Evga inDtube
[ 1274.817667] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 1274.817680] em28xx #0:     card=72 -> Gadmei UTV330+
[ 1274.817693] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[ 1274.817706] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 1274.817721] em28xx #0:     card=75 -> Dikom DK300
[ 1274.817733] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[ 1274.817748] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[ 1274.817761] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[ 1274.817775] em28xx #0:     card=79 -> Terratec Cinergy H5
[ 1274.817788] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 1274.817802] em28xx #0:     card=81 -> Hauppauge WinTV HVR 930C
[ 1274.817816] em28xx #0:     card=82 -> Terratec Cinergy HTC Stick
[ 1274.817830] em28xx #0:     card=83 -> Honestech Vidbox NW03
[ 1274.817843] em28xx #0:     card=84 -> MaxMedia UB425-TC
[ 1274.817856] em28xx #0:     card=85 -> PCTV QuatroStick (510e)
[ 1274.817870] em28xx #0:     card=86 -> PCTV QuatroStick nano (520e)
[ 1274.817883] em28xx #0: Board not discovered
[ 1274.817896] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[ 1274.817910] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[ 1274.817926] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[ 1274.817941] em28xx #0: Please send an email with this log to:
[ 1274.817954] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>
[ 1274.817968] em28xx #0: Board eeprom hash is 0x988451c0
[ 1274.817981] em28xx #0: Board i2c devicelist hash is 0x4b800080
[ 1274.817994] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[ 1274.818010] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[ 1274.818024] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[ 1274.818038] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[ 1274.818052] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[ 1274.818065] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[ 1274.818078] em28xx #0:     card=5 -> MSI VOX USB 2.0
[ 1274.818091] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[ 1274.818104] em28xx #0:     card=7 -> Leadtek Winfast USB II
[ 1274.818117] em28xx #0:     card=8 -> Kworld USB2800
[ 1274.818130] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U
[ 1274.818152] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[ 1274.818165] em28xx #0:     card=11 -> Terratec Hybrid XS
[ 1274.818178] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[ 1274.818191] em28xx #0:     card=13 -> Terratec Prodigy XS
[ 1274.818204] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[ 1274.818220] em28xx #0:     card=15 -> V-Gear PocketTV
[ 1274.818232] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[ 1274.818246] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[ 1274.818259] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[ 1274.818274] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[ 1274.818288] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[ 1274.818302] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[ 1274.818318] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[ 1274.818332] em28xx #0:     card=23 -> Huaqi DLCW-130
[ 1274.818344] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[ 1274.818358] em28xx #0:     card=25 -> Gadmei UTV310
[ 1274.818370] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[ 1274.818384] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[ 1274.818399] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[ 1274.818413] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[ 1274.818427] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[ 1274.818442] em28xx #0:     card=31 -> Usbgear VD204v9
[ 1274.818454] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[ 1274.818466] em28xx #0:     card=33 -> Elgato Video Capture
[ 1274.818479] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[ 1274.818493] em28xx #0:     card=35 -> Typhoon DVD Maker
[ 1274.818506] em28xx #0:     card=36 -> NetGMBH Cam
[ 1274.818517] em28xx #0:     card=37 -> Gadmei UTV330
[ 1274.818529] em28xx #0:     card=38 -> Yakumo MovieMixer
[ 1274.818541] em28xx #0:     card=39 -> KWorld PVRTV 300U
[ 1274.818554] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[ 1274.818568] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[ 1274.818580] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[ 1274.818592] em28xx #0:     card=43 -> Terratec Cinergy T XS
[ 1274.818605] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[ 1274.818619] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[ 1274.818632] em28xx #0:     card=46 -> Compro, VideoMate U3
[ 1274.818646] em28xx #0:     card=47 -> KWorld DVB-T 305U
[ 1274.818658] em28xx #0:     card=48 -> KWorld DVB-T 310U
[ 1274.818670] em28xx #0:     card=49 -> MSI DigiVox A/D
[ 1274.818683] em28xx #0:     card=50 -> MSI DigiVox A/D II
[ 1274.818695] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[ 1274.818708] em28xx #0:     card=52 -> DNT DA2 Hybrid
[ 1274.818720] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[ 1274.818733] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[ 1274.818746] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[ 1274.818762] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (330e)
[ 1274.818775] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 1274.818789] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 1274.818802] em28xx #0:     card=59 -> (null)
[ 1274.818814] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 1274.818828] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 1274.818842] em28xx #0:     card=62 -> Gadmei TVR200
[ 1274.818854] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 1274.818866] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 1274.818879] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 1274.818891] em28xx #0:     card=66 -> Empire dual TV
[ 1274.818903] em28xx #0:     card=67 -> Terratec Grabby
[ 1274.818916] em28xx #0:     card=68 -> Terratec AV350
[ 1274.818928] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 1274.818942] em28xx #0:     card=70 -> Evga inDtube
[ 1274.818955] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 1274.818968] em28xx #0:     card=72 -> Gadmei UTV330+
[ 1274.818981] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[ 1274.818995] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[ 1274.819009] em28xx #0:     card=75 -> Dikom DK300
[ 1274.819022] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[ 1274.819036] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[ 1274.819049] em28xx #0:     card=78 -> PCTV nanoStick T2 290e
[ 1274.819062] em28xx #0:     card=79 -> Terratec Cinergy H5
[ 1274.819075] em28xx #0:     card=80 -> PCTV DVB-S2 Stick (460e)
[ 1274.819089] em28xx #0:     card=81 -> Hauppauge WinTV HVR 930C
[ 1274.819102] em28xx #0:     card=82 -> Terratec Cinergy HTC Stick
[ 1274.819116] em28xx #0:     card=83 -> Honestech Vidbox NW03
[ 1274.819129] em28xx #0:     card=84 -> MaxMedia UB425-TC
[ 1274.819142] em28xx #0:     card=85 -> PCTV QuatroStick (510e)
[ 1274.819155] em28xx #0:     card=86 -> PCTV QuatroStick nano (520e)
[ 1274.819171] em28xx #0: v4l2 driver version 0.1.3
[ 1274.824283] em28xx #0: V4L2 video device registered as video0
[ 1274.826265] usbcore: registered new interface driver em28xx
[ 1886.031864] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0

[ 2258.873599] usbcore: deregistering interface driver em28xx
[ 2258.873641] em28xx #0: disconnecting em28xx #0 video
[ 2258.873650] em28xx #0: V4L2 device video0 deregistered
[ 2278.088566] em28xx: New device  USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class 0)
[ 2278.088571] em28xx: Video interface 0 found
[ 2278.088573] em28xx: DVB interface 0 found
[ 2278.088668] em28xx #0: chip ID is em2870
[ 2278.380099] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
[ 2278.380134] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
[ 2278.380165] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
[ 2278.380196] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 82 65 eb 49
[ 2278.380227] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380257] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380287] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[ 2278.380317] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
[ 2278.380348] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[ 2278.380378] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380408] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380439] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380469] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380499] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380529] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380559] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2278.380593] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x988451c0
[ 2278.380599] em28xx #0: EEPROM info:
[ 2278.380604] em28xx #0:       No audio on board.
[ 2278.380609] em28xx #0:       500mA max power
[ 2278.380615] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000
[ 2278.383611] em28xx #0: Identified as Pinnacle PCTV DVB-T (card=45)
[ 2278.383618] em28xx #0: 
[ 2278.383620] 
[ 2278.383627] em28xx #0: The support for this board weren't valid yet.
[ 2278.383633] em28xx #0: Please send a report of having this working
[ 2278.383639] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 2278.383643] 
[ 2278.383651] em28xx #0: v4l2 driver version 0.1.3
[ 2278.388996] em28xx #0: V4L2 video device registered as video0
[ 2278.390316] usbcore: registered new interface driver em28xx
[ 2290.078209] WARNING: You are using an experimental version of the media stack.
[ 2290.078214]  As the driver is backported to an older kernel, it doesn't offer
[ 2290.078218]  enough quality for its usage in production.
[ 2290.078221]  Use it with care.
[ 2290.078224] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[ 2290.078228]  296da3cd14db9eb5606924962b2956c9c656dbb0 [media] pwc: poll(): Check that the device has not beem claimed for streaming already
[ 2290.078233]  0bf0f713d6e6b9f1c510d598c29ac17812a4eea5 [media] vivi: let vb2_poll handle events
[ 2290.078237]  95213ceb1b527b8102c589bd41fcb7c9163fdd79 [media] videobuf2-core: also test for pending events
[ 2290.088741] em28xx_dvb: This device does not support the extension
[ 2290.088747] Em28xx: Initialized (Em28xx dvb Extension) extension
mika@mika-X51R:~$ 


--Boundary-00=_QGZgPl1pf8FS5ZW--
