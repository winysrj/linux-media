Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m137PbQ6001719
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 02:25:37 -0500
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m137P6Bu028836
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 02:25:06 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JLZDq-0002JT-Jz
	for video4linux-list@redhat.com; Sun, 03 Feb 2008 07:25:02 +0000
Received: from psilocybe.update.uu.se ([130.238.19.25])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 03 Feb 2008 07:25:02 +0000
Received: from fstx+u by psilocybe.update.uu.se with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 03 Feb 2008 07:25:02 +0000
To: video4linux-list@redhat.com
From: Fredrik Staxeng <fstx+u@update.uu.se>
Date: Sun, 03 Feb 2008 08:23:02 +0100
Message-ID: <1modaysdux.fsf@Psilocybe.Update.UU.SE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Adding a second card (hvr-1110),
	video from old card (bt878) stutters
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


I have a working mythtv box with an old Hauappauge card in it. I tried to add
another card, a HVR-1110, the version with an saa7133 on it. 

I added some udev rules to keep the old card on video0. Then I put the card 
in the box and rebooted. First I checked whether mythtv was still working.
I got picure, but it was stuttery, about 10 frames per second or so, and
there was no sound. 

I did not try to use the new card, not configuring it and not even
connecting the antenna. There was a message about missing firmware for
that when booting. Gdm did not log automatically.

I removed the new card, and rebooted. Fortunately everything worked, even
the gdm login.

Why would the mere presence of the new card in the system interfere with
the old one? 

I use mythtv on ubuntu 7.10. The bttv driver is version 0.9.17, 
the saa7130 is 0.2.14, mythtv is 0.20.2.   

The motherboard is an ASUS M2NPV-VM, the kernel says the old card is a
Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb. 

The udev lines I used are these

KERNEL=="video[0-9]*", DRIVERS=="bttv" , NAME="video0", SYMLINK += "video-bttv"
KERNEL=="vbi[0-9]*", DRIVERS=="bttv" , NAME="vbi0", SYMLINK += "vbi-bttv"
KERNEL=="radio[0-9]*", DRIVERS=="bttv" , NAME="radio0", SYMLINK += "radio-bttv"

KERNEL=="video[0-9]*", DRIVERS!="bttv" , NAME="v4l/video%n"
KERNEL=="vbi[0-9]*", DRIVERS!="bttv" , NAME="v4l/vbi%n"
KERNEL=="radio[0-9]*", DRIVERS!="bttv" , NAME="v4l/radio%n"


This is the dmesg output:

[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Dec 18 08:02:57 UTC 2007 (Ubuntu 2.6.22-14.47-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003dee0000 (usable)
[    0.000000]  BIOS-e820: 000000003dee0000 - 000000003dee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003dee3000 - 000000003def0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003def0000 - 000000003df00000 (reserved)
[    0.000000]  BIOS-e820: 000000003e000000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] 94MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f59c0
[    0.000000] Entering add_active_range(0, 0, 253664) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   253664
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   253664
[    0.000000] On node 0 totalpages: 253664
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 189 pages used for memmap
[    0.000000]   HighMem zone: 24099 pages, LIFO batch:3
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xC00F74B0 checksum 0
[    0.000000] ACPI: RSDP 000F74B0, 0024 (r2 Nvidia)
[    0.000000] ACPI: XSDT 3DEE30C0, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3DEEB4C0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3DEE3240, 821E (r1 NVIDIA ASUSACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS 3DEE0000, 0040
[    0.000000] ACPI: SSDT 3DEEB6C0, 0248 (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET 3DEEB980, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
[    0.000000] ACPI: MCFG 3DEEBA00, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3DEEB600, 007C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists.  Total pages: 251683
[    0.000000] Kernel command line: root=UUID=98eb5c1c-ff35-4492-a3d8-8e1839a89c03 ro quiet splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2304.840 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 994256k/1014656k available (2015k kernel code, 19764k reserved, 916k data, 364k init, 97152k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000000]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[    0.000000]       .data : 0xc02f7de6 - 0xc03dce84   ( 916 kB)
[    0.000000]       .text : 0xc0100000 - 0xc02f7de6   (2015 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    0.000000] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.000000] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.000000] hpet0: 3 32-bit timers, 25000000 Hz
[    0.080000] Calibrating delay using timer specific routine.. 4613.39 BogoMIPS (lpj=9226789)
[    0.080000] Security Framework v1.0.0 initialized
[    0.080000] SELinux:  Disabled at boot.
[    0.080000] Mount-cache hash table entries: 512
[    0.080000] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f
[    0.080000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.080000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.080000] CPU 0(2) -> Core 0
[    0.080000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f
[    0.080000] Compat vDSO mapped to ffffe000.
[    0.080000] Checking 'hlt' instruction... OK.
[    0.096000] SMP alternatives: switching to UP code
[    0.096000] Early unpacking initramfs... done
[    0.348000] ACPI: Core revision 20070126
[    0.348000] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[    0.352000] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
[    0.352000] SMP alternatives: switching to SMP code
[    0.352000] Booting processor 1/1 eip 3000
[    0.360000] Initializing CPU#1
[    0.444000] Calibrating delay using timer specific routine.. 4609.65 BogoMIPS (lpj=9219306)
[    0.444000] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f
[    0.444000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.444000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.444000] CPU 1(2) -> Core 1
[    0.444000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f
[    0.444000] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
[    0.444000] Total of 2 processors activated (9223.04 BogoMIPS).
[    0.444000] ENABLING IO-APIC IRQs
[    0.444000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.488000] Brought up 2 CPUs
[    0.500000] migration_cost=4000
[    0.500000] Booting paravirtualized kernel on bare hardware
[    0.500000] Time: 16:22:43  Date: 01/02/108
[    0.500000] NET: Registered protocol family 16
[    0.500000] EISA bus registered
[    0.500000] ACPI: bus type pci registered
[    0.508000] PCI: PCI BIOS revision 3.00 entry at 0xf1ff0, last bus=4
[    0.508000] PCI: Using configuration type 1
[    0.508000] Setting up standard PCI resources
[    0.512000] ACPI: EC: Look up EC in DSDT
[    0.520000] ACPI: Interpreter enabled
[    0.520000] ACPI: (supports S0 S1 S3 S4 S5)
[    0.520000] ACPI: Using IOAPIC for interrupt routing
[    0.528000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.528000] PCI: Probing PCI hardware (bus 00)
[    0.532000] PCI: Transparent bridge - 0000:00:10.0
[    0.532000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.532000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.600000] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 *10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LNK7] (IRQs *5 7 9 10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LUBA] (IRQs *5 7 9 10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LUBB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 *11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LACI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LMCI] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.600000] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 *10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
[    0.600000] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
[    0.604000] ACPI: PCI Interrupt Link [LFID] (IRQs *5 7 9 10 11 14 15)
[    0.604000] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
[    0.604000] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.604000] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
[    0.604000] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.604000] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[    0.604000] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.604000] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.604000] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    0.604000] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.604000] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[    0.604000] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.608000] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.608000] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.608000] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.608000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.608000] pnp: PnP ACPI init
[    0.608000] ACPI: bus type pnp registered
[    0.612000] pnp: PnP ACPI: found 15 devices
[    0.612000] ACPI: ACPI bus type pnp unregistered
[    0.612000] PnPBIOS: Disabled by ACPI PNP
[    0.612000] PCI: Using ACPI for IRQ routing
[    0.612000] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.708000] NET: Registered protocol family 8
[    0.708000] NET: Registered protocol family 20
[    0.708000] pnp: 00:01: ioport range 0x4000-0x407f has been reserved
[    0.708000] pnp: 00:01: ioport range 0x4080-0x40ff has been reserved
[    0.708000] pnp: 00:01: ioport range 0x4400-0x447f has been reserved
[    0.708000] pnp: 00:01: ioport range 0x4480-0x44ff has been reserved
[    0.708000] pnp: 00:01: ioport range 0x4800-0x487f has been reserved
[    0.708000] pnp: 00:01: ioport range 0x4880-0x48ff has been reserved
[    0.708000] pnp: 00:01: ioport range 0x2000-0x207f has been reserved
[    0.708000] pnp: 00:01: ioport range 0x2080-0x20ff has been reserved
[    0.708000] pnp: 00:01: iomem range 0x3e000000-0x3fffffff could not be reserved
[    0.708000] pnp: 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.708000] pnp: 00:0e: iomem range 0xcec00-0xcffff has been reserved
[    0.708000] pnp: 00:0e: iomem range 0xf0000-0xf7fff could not be reserved
[    0.708000] pnp: 00:0e: iomem range 0xf8000-0xfbfff could not be reserved
[    0.708000] pnp: 00:0e: iomem range 0xfc000-0xfffff could not be reserved
[    0.712000] Time: hpet clocksource has been installed.
[    0.712000] Switched to high resolution mode on CPU 0
[    0.712000] Switched to high resolution mode on CPU 1
[    0.740000] PCI: Bridge: 0000:00:02.0
[    0.740000]   IO window: a000-afff
[    0.740000]   MEM window: fd800000-fd8fffff
[    0.740000]   PREFETCH window: fd700000-fd7fffff
[    0.740000] PCI: Bridge: 0000:00:03.0
[    0.740000]   IO window: 8000-8fff
[    0.740000]   MEM window: fde00000-fdefffff
[    0.740000]   PREFETCH window: fdd00000-fddfffff
[    0.740000] PCI: Bridge: 0000:00:04.0
[    0.740000]   IO window: b000-bfff
[    0.740000]   MEM window: fdc00000-fdcfffff
[    0.740000]   PREFETCH window: fd900000-fd9fffff
[    0.740000] PCI: Bridge: 0000:00:10.0
[    0.740000]   IO window: 9000-9fff
[    0.740000]   MEM window: fdb00000-fdbfffff
[    0.740000]   PREFETCH window: fda00000-fdafffff
[    0.740000] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.740000] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    0.740000] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    0.740000] PCI: Setting latency timer of device 0000:00:10.0 to 64
[    0.740000] NET: Registered protocol family 2
[    0.784000] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.784000] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[    0.784000] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.784000] TCP: Hash tables configured (established 131072 bind 65536)
[    0.784000] TCP reno registered
[    0.800000] checking if image is initramfs... it is
[    1.296000] Freeing initrd memory: 7114k freed
[    1.296000] audit: initializing netlink socket (disabled)
[    1.296000] audit(1201969363.212:1): initialized
[    1.296000] highmem bounce pool size: 64 pages
[    1.296000] VFS: Disk quotas dquot_6.5.1
[    1.296000] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.296000] io scheduler noop registered
[    1.296000] io scheduler anticipatory registered
[    1.296000] io scheduler deadline registered
[    1.296000] io scheduler cfq registered (default)
[    1.296000] Boot video device is 0000:00:05.0
[    1.312000] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    1.312000] assign_interrupt_mode Found MSI capability
[    1.312000] Allocate Port Service[0000:00:02.0:pcie00]
[    1.312000] PCI: Setting latency timer of device 0000:00:03.0 to 64
[    1.312000] assign_interrupt_mode Found MSI capability
[    1.312000] Allocate Port Service[0000:00:03.0:pcie00]
[    1.312000] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    1.312000] assign_interrupt_mode Found MSI capability
[    1.312000] Allocate Port Service[0000:00:04.0:pcie00]
[    1.312000] isapnp: Scanning for PnP cards...
[    1.664000] isapnp: No Plug & Play device found
[    1.680000] Real Time Clock Driver v1.12ac
[    1.680000] hpet_resources: 0xfefff000 is busy
[    1.680000] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.680000] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.684000] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.684000] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.684000] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.684000] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    1.684000] input: Macintosh mouse button emulation as /class/input/input0
[    1.684000] PNP: No PS/2 controller found. Probing ports directly.
[    1.684000] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.684000] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.684000] mice: PS/2 mouse device common for all mice
[    1.684000] EISA: Probing bus 0 at eisa.0
[    1.684000] Cannot allocate resource for EISA slot 2
[    1.684000] Cannot allocate resource for EISA slot 4
[    1.684000] Cannot allocate resource for EISA slot 8
[    1.684000] EISA: Detected 0 cards.
[    1.684000] TCP cubic registered
[    1.684000] NET: Registered protocol family 1
[    1.684000] Using IPI No-Shortcut mode
[    1.684000]   Magic number: 12:642:387
[    1.684000] Freeing unused kernel memory: 364k freed
[    2.880000] AppArmor: AppArmor initialized<5>audit(1201969364.712:2):  type=1505 info="AppArmor initialized" pid=1286
[    2.884000] fuse init (API version 7.8)
[    2.892000] Failure registering capabilities with primary security module.
[    2.920000] ACPI: Fan [FAN] (on)
[    2.928000] ACPI: Thermal Zone [THRM] (40 C)
[    3.464000] SCSI subsystem initialized
[    3.468000] libata version 2.21 loaded.
[    3.480000] sata_nv 0000:00:0e.0: version 3.4
[    3.480000] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    3.480000] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [APSI] -> GSI 23 (level, low) -> IRQ 16
[    3.480000] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    3.480000] scsi0 : sata_nv
[    3.480000] scsi1 : sata_nv
[    3.480000] ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001e000 irq 16
[    3.480000] ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001e008 irq 16
[    3.516000] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    3.516000] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    3.532000] usbcore: registered new interface driver usbfs
[    3.532000] usbcore: registered new interface driver hub
[    3.556000] usbcore: registered new device driver usb
[    3.556000] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
[    3.568000] Floppy drive(s): fd0 is 1.44M
[    3.608000] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.608000] FDC 0 is a post-1991 82077
[    3.792000] ata1: SATA link down (SStatus 0 SControl 300)
[    4.112000] ata2: SATA link down (SStatus 0 SControl 300)
[    4.120000] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
[    4.120000] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [APSJ] -> GSI 22 (level, low) -> IRQ 17
[    4.120000] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    4.120000] scsi2 : sata_nv
[    4.120000] scsi3 : sata_nv
[    4.120000] ata3: SATA max UDMA/133 cmd 0x000109e0 ctl 0x00010be2 bmdma 0x0001cc00 irq 17
[    4.120000] ata4: SATA max UDMA/133 cmd 0x00010960 ctl 0x00010b62 bmdma 0x0001cc08 irq 17
[    4.432000] ata3: SATA link down (SStatus 0 SControl 300)
[    4.752000] ata4: SATA link down (SStatus 0 SControl 300)
[    4.760000] NFORCE-MCP51: IDE controller at PCI slot 0000:00:0d.0
[    4.760000] NFORCE-MCP51: chipset revision 161
[    4.760000] NFORCE-MCP51: not 100% native mode: will probe irqs later
[    4.760000] NFORCE-MCP51: 0000:00:0d.0 (rev a1) UDMA133 controller
[    4.760000]     ide0: BM-DMA at 0xf400-0xf407, BIOS settings: hda:DMA, hdb:DMA
[    4.760000]     ide1: BM-DMA at 0xf408-0xf40f, BIOS settings: hdc:DMA, hdd:DMA
[    4.760000] Probing IDE interface ide0...
[    5.048000] hda: SAMSUNG SP2514N, ATA DISK drive
[    5.748000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.752000] Probing IDE interface ide1...
[    6.492000] hdc: ASUS DVD-ROM E608, ATAPI CD/DVD-ROM drive
[    6.828000] ide1 at 0x170-0x177,0x376 on irq 15
[    6.828000] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
[    6.828000] ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 18
[    6.828000] PCI: Setting latency timer of device 0000:00:14.0 to 64
[    6.828000] forcedeth: using HIGHDMA
[    7.348000] eth0: forcedeth.c: subsystem: 01043:816a bound to 0000:00:14.0
[    7.348000] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 20
[    7.348000] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [APCF] -> GSI 20 (level, low) -> IRQ 19
[    7.348000] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    7.348000] ohci_hcd 0000:00:0b.0: OHCI Host Controller
[    7.348000] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 1
[    7.348000] ohci_hcd 0000:00:0b.0: irq 19, io mem 0xfe02f000
[    7.404000] usb usb1: configuration #1 chosen from 1 choice
[    7.404000] hub 1-0:1.0: USB hub found
[    7.404000] hub 1-0:1.0: 8 ports detected
[    7.508000] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
[    7.508000] ACPI: PCI Interrupt 0000:00:0b.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 16
[    7.508000] PCI: Setting latency timer of device 0000:00:0b.1 to 64
[    7.508000] ehci_hcd 0000:00:0b.1: EHCI Host Controller
[    7.508000] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 2
[    7.508000] ehci_hcd 0000:00:0b.1: debug port 1
[    7.508000] PCI: cache line size of 64 is not supported by device 0000:00:0b.1
[    7.508000] ehci_hcd 0000:00:0b.1: irq 16, io mem 0xfe02e000
[    7.508000] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.508000] usb usb2: configuration #1 chosen from 1 choice
[    7.508000] hub 2-0:1.0: USB hub found
[    7.508000] hub 2-0:1.0: 8 ports detected
[    7.612000] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    7.612000] ACPI: PCI Interrupt 0000:04:05.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 20
[    7.660000] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[fdbff000-fdbff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    7.664000] hda: max request size: 512KiB
[    7.664000] hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(100)
[    7.664000] hda: cache flushes supported
[    7.664000]  hda:<6>hdc: ATAPI 40X DVD-ROM drive, 128kB Cache, UDMA(33)
[    7.664000] Uniform CD-ROM driver Revision: 3.20
[    7.672000]  hda1 hda2 hda3
[    7.896000] Attempting manual resume
[    7.896000] swsusp: Resume From Partition 3:2
[    7.896000] PM: Checking swsusp image.
[    7.900000] PM: Resume from disk failed.
[    7.928000] kjournald starting.  Commit interval 5 seconds
[    7.928000] EXT3-fs: mounted filesystem with ordered data mode.
[    8.552000] usb 1-1: new full speed USB device using ohci_hcd and address 2
[    8.752000] usb 1-1: configuration #1 chosen from 1 choice
[    8.932000] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d8000123f756]
[    9.060000] usb 1-2: new low speed USB device using ohci_hcd and address 3
[    9.276000] usb 1-2: configuration #1 chosen from 1 choice
[   14.156000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   14.200000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   14.300000] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   14.300000] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   14.484000] Linux video capture interface: v2.00
[   14.528000] Linux agpgart interface v0.102 (c) Dave Jones
[   14.644000] saa7130/34: v4l2 driver version 0.2.14 loaded
[   14.644000] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   14.644000] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC2] -> GSI 17 (level, low) -> IRQ 21
[   14.644000] saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 21, latency: 32, mmio: 0xfdbfe000
[   14.644000] saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
[   14.644000] saa7133[0]: board init: gpio is 6400000
[   14.684000] input: PC Speaker as /class/input/input1
[   14.700000] nvidia: module license 'NVIDIA' taints kernel.
[   14.956000] bttv: driver version 0.9.17 loaded
[   14.956000] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   14.976000] input: HVR 1110 as /class/input/input2
[   14.976000] ir-kbd-i2c: HVR 1110 detected at i2c-2/2-0071/ir0 [saa7133[0]]
[   15.012000] usbcore: registered new interface driver hiddev
[   15.020000] saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   15.020000] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[   15.020000] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff
[   15.020000] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.020000] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
[   15.020000] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   15.020000] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   15.020000] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   15.020000] input: ruwido austria GmbH ruwido austria GmbH USB Infrared Keyboard V2.07 as /class/input/input3
[   15.020000] input: USB HID v1.10 Keyboard [ruwido austria GmbH ruwido austria GmbH USB Infrared Keyboard V2.07] on usb-0000:00:0b.0-2
[   15.024000] lirc_dev: IR Remote Control driver registered, at major 61 
[   15.028000] input: ruwido austria GmbH ruwido austria GmbH USB Infrared Keyboard V2.07 as /class/input/input4
[   15.028000] input: USB HID v1.10 Mouse [ruwido austria GmbH ruwido austria GmbH USB Infrared Keyboard V2.07] on usb-0000:00:0b.0-2
[   15.028000] usbcore: registered new interface driver usbhid
[   15.028000] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   15.072000] 
[   15.072000] lirc_mceusb2: Philips eHome USB IR Transciever and Microsoft MCE 2005 Remote Control driver for LIRC $Revision: 1.33 $
[   15.072000] lirc_mceusb2: Daniel Melander <lirc@rajidae.se>, Martin Blatter <martin_a_blatter@yahoo.com>
[   15.072000] parport_pc 00:0b: reported by Plug and Play ACPI
[   15.072000] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   15.128000] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[   15.192000] tuner 2-004b: setting tuner address to 61
[   15.232000] tuner 2-004b: type set to tda8290+75a
[   15.256000] usb 1-1: reset full speed USB device using ohci_hcd and address 2
[   15.460000] lirc_dev: lirc_register_plugin: sample_rate: 0
[   15.468000] lirc_mceusb2[2]: Philips eHome Infrared Transceiver on usb1:2
[   15.468000] usbcore: registered new interface driver lirc_mceusb2
[   16.624000] tuner 2-004b: setting tuner address to 61
[   16.664000] tuner 2-004b: type set to tda8290+75a
[   18.008000] saa7133[0]: registered device video0 [v4l2]
[   18.008000] saa7133[0]: registered device vbi0
[   18.008000] saa7133[0]: registered device radio0
[   18.072000] bttv: Bt8xx card found (0).
[   18.072000] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   18.072000] ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 22
[   18.072000] bttv0: Bt878 (rev 2) at 0000:04:08.0, irq: 22, latency: 32, mmio: 0xfdaff000
[   18.072000] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
[   18.072000] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   18.072000] bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
[   18.072000] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   18.076000] input: i2c IR (Hauppauge) as /class/input/input5
[   18.076000] ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-3/3-0018/ir0 [bt878 #0 [sw]]
[   18.076000] i2c-adapter i2c-3: sendbytes: error - bailout.
[   18.084000] saa7134 ALSA driver for DMA sound loaded
[   18.084000] saa7133[0]/alsa: saa7133[0] at 0xfdbfe000 irq 21 registered as card -2
[   18.100000] tuner 3-0042: chip found @ 0x84 (bt878 #0 [sw])
[   18.100000] tda9887 3-0042: tda988[5/6/7] found @ 0x42 (tuner)
[   18.108000] tuner 3-0061: chip found @ 0xc2 (bt878 #0 [sw])
[   18.140000] tveeprom 3-0050: Hauppauge model 61344, rev D121, serial# 3507592
[   18.140000] tveeprom 3-0050: tuner model is Philips FM1216 (idx 21, type 5)
[   18.140000] tveeprom 3-0050: TV standards PAL(B/G) (eeprom 0x04)
[   18.140000] tveeprom 3-0050: audio processor is MSP3415 (idx 6)
[   18.140000] tveeprom 3-0050: has radio
[   18.140000] bttv0: Hauppauge eeprom indicates model#61344
[   18.140000] bttv0: using tuner=5
[   18.140000] tuner 3-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[   18.140000] bttv0: i2c: checking for MSP34xx @ 0x80... found
[   18.164000] msp3400 3-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
[   18.164000] msp3400 3-0040: MSP3410D-B4 supports nicam, mode is autodetect
[   18.172000] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   18.176000] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   18.200000] DVB: registering new adapter (saa7133[0]).
[   18.200000] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   18.204000] bttv0: i2c: checking for TDA9887 @ 0x86... not found
[   18.208000] bttv0: registered device video1
[   18.208000] bttv0: registered device vbi1
[   18.208000] bttv0: registered device radio1
[   18.220000] bttv0: PLL: 28636363 => 35468950 .. ok
[   18.256000] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
[   18.256000] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 17
[   18.256000] PCI: Setting latency timer of device 0000:00:10.1 to 64
[   18.260000] bt878: AUDIO driver version 0.0.0 loaded
[   18.276000] tda1004x: setting up plls for 48MHz sampling clock
[   18.564000] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   18.564000] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 22
[   18.564000] PCI: Setting latency timer of device 0000:00:05.0 to 64
[   18.564000] NVRM: loading NVIDIA Linux x86 Kernel Module  1.0-9639  Mon Apr 16 20:20:06 PDT 2007
[   18.564000] bt878: Bt878 AUDIO function found (0).
[   18.564000] ACPI: PCI Interrupt 0000:04:08.1[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 22
[   18.564000] bt878_probe: card id=[0x13eb0070], Unknown card.
[   18.564000] Exiting..
[   18.564000] ACPI: PCI interrupt for device 0000:04:08.1 disabled
[   18.564000] bt878: probe of 0000:04:08.1 failed with error -22
[   18.600000] ACPI: PCI Interrupt 0000:04:08.1[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 22
[   18.784000] lp0: using parport0 (interrupt-driven).
[   19.064000] it87: Found IT8716F chip at 0x290, revision 1
[   19.064000] it87: in3 is VCC (+5V)
[   19.064000] it87: in7 is VCCH (+5V Stand-By)
[   19.064000] it87-isa 9191-0290: Detected broken BIOS defaults, disabling PWM interface
[   19.112000] Adding 4883752k swap on /dev/hda2.  Priority:-1 extents:1 across:4883752k
[   19.424000] EXT3 FS on hda1, internal journal
[   19.740000] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
[   19.740000] SGI XFS Quota Management subsystem
[   19.788000] XFS mounting filesystem hda3
[   19.892000] Ending clean XFS mount for filesystem: hda3
[   20.516000] tda1004x: timeout waiting for DSP ready
[   20.556000] tda1004x: found firmware revision 0 -- invalid
[   20.556000] tda1004x: trying to boot from eeprom
[   20.796000] input: Power Button (FF) as /class/input/input6
[   20.796000] ACPI: Power Button (FF) [PWRF]
[   20.796000] input: Power Button (CM) as /class/input/input7
[   20.796000] ACPI: Power Button (CM) [PWRB]
[   20.900000] No dock devices found.
[   21.124000] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ processors (version 2.00.00)
[   21.124000] powernow-k8:    0 : fid 0xf (2300 MHz), vid 0x9
[   21.124000] powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xa
[   21.124000] powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xc
[   21.124000] powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xe
[   21.128000] powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
[   22.888000] tda1004x: timeout waiting for DSP ready
[   22.928000] tda1004x: found firmware revision 0 -- invalid
[   22.928000] tda1004x: waiting for firmware upload...
[   22.956000] tda1004x: no firmware upload (timeout or file not found?)
[   22.956000] tda1004x: firmware upload failed
[   27.588000] NET: Registered protocol family 10
[   27.588000] lo: Disabled Privacy Extensions
[   28.064000] ppdev: user-space parallel port driver
[   28.196000] audit(1201969390.014:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5765 profile="/usr/sbin/cupsd"
[   29.872000] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   29.872000] apm: disabled - APM is not SMP safe.
[   31.000000] Clocksource tsc unstable (delta = -192129348 ns)
[   31.388000] Failure registering capabilities with primary security module.
[   34.740000] Bluetooth: Core ver 2.11
[   34.740000] NET: Registered protocol family 31
[   34.740000] Bluetooth: HCI device and connection manager initialized
[   34.740000] Bluetooth: HCI socket layer initialized
[   34.840000] Bluetooth: L2CAP ver 2.8
[   34.840000] Bluetooth: L2CAP socket layer initialized
[   34.936000] Bluetooth: RFCOMM socket layer initialized
[   34.936000] Bluetooth: RFCOMM TTY layer initialized
[   34.936000] Bluetooth: RFCOMM ver 1.8
[   35.668000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[   36.056000] NET: Registered protocol family 17
[   48.356000] eth0: no IPv6 routers present
[  102.480000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  102.492000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  102.492000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  102.496000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  102.844000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  102.864000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.588000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.600000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.600000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.604000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.672000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  234.700000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)
[  245.212000] tda9887 3-0042: i2c i/o error: rc == -121 (should be 4)





 
-- 
Fredrik Stax\"ang | rot13: sfgk@hcqngr.hh.fr
This is all you need to know about vi: ESC : q ! RET

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
