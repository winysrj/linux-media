Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:34649 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZGSOpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 10:45:20 -0400
Message-ID: <4A63317D.6040208@rtr.ca>
Date: Sun, 19 Jul 2009 10:45:17 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
 	branch
References: <4A631C8F.7000002@rtr.ca> <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
In-Reply-To: <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Sun, Jul 19, 2009 at 9:15 AM, Mark Lord<lkml@rtr.ca> wrote:
..
>> The mythbackend (recording) program tunes/records fine with it,
>> but any attempt to watch "Live TV" via mythfrontend just locks
>> up the UI for 30 seconds or so, and then it reverts to the menus.
..
> Could you please provide the following:
> 
> 1.  Exactly which product you are using (including the USB/PCI id)
..

Doh!  Yes, of course!
It's the popular Hauppauge HVR-950Q USB Stick:

   Bus 007 Device 006: ID 2040:7200 Hauppauge

> 3.  Whether you are using the device for digital, analog, or both, and
> which the mythtv attempted to use when running the mythfrontend.
..

Digital-only, since the tuner stick has never worked (and still doesn't)
for analog NTSC with MythTV-0.21-fixes.  That's okay, I really only use
it for digital ATSC over-the-air (OTA) reception.

> 2.  dmesg output from the time the card is inserted (or booted up if
> PCI) to the time *after* you attempted to use the frontend with mythtv.

The remainder of this email contains (only) the dmesg output.
Thanks.


rocessor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5319.72 BogoMIPS (lpj=2659862)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU          6700  @ 2.66GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (10639.55 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
dca service started, version 1.8
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0xfc00-0xfc1f]
pci 0000:00:1a.1: reg 20 io port: [0xf800-0xf81f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfdfff000-0xfdfff3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfdff4000-0xfdff7fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xf400-0xf41f]
pci 0000:00:1d.1: reg 20 io port: [0xf000-0xf01f]
pci 0000:00:1d.2: reg 20 io port: [0xec00-0xec1f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfdffe000-0xfdffe3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0800 (mask 003f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0290 (mask 003f)
pci 0000:00:1f.2: reg 10 io port: [0xe800-0xe807]
pci 0000:00:1f.2: reg 14 io port: [0xe400-0xe403]
pci 0000:00:1f.2: reg 18 io port: [0xe000-0xe007]
pci 0000:00:1f.2: reg 1c io port: [0xdc00-0xdc03]
pci 0000:00:1f.2: reg 20 io port: [0xd800-0xd81f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xfdffd000-0xfdffd7ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0xfdffc000-0xfdffc0ff]
pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
pci 0000:00:1f.6: reg 10 64bit mmio: [0xfdffb000-0xfdffbfff]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcfffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:01:00.0: reg 24 io port: [0x5c00-0x5c7f]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:00:01.0: bridge io port: [0x5000-0x5fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xc0000000-0xcfffffff]
pci 0000:00:1c.0: bridge io port: [0xa000-0xafff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdb00000-0xfdbfffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfdefc000-0xfdefffff]
pci 0000:04:00.0: reg 18 io port: [0x6c00-0x6cff]
pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.3: bridge io port: [0x6000-0x6fff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xfde00000-0xfdefffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xfdd00000-0xfddfffff]
pci 0000:05:00.0: reg 10 32bit mmio: [0xdbfff000-0xdbfff7ff]
pci 0000:05:00.0: reg 14 io port: [0x7c00-0x7c7f]
pci 0000:05:00.0: supports D2
pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:05:02.0: reg 10 32bit mmio: [0xf4000000-0xf7ffffff]
pci 0000:05:03.0: reg 10 32bit mmio: [0xd4000000-0xd7ffffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x7000-0x7fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xd4000000-0xdbffffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf4000000-0xf7ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 5 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 5 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs *5 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 9 10 11 12 14 *15)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x290-0x29f has been reserved
system 00:01: ioport range 0x800-0x87f has been reserved
system 00:01: ioport range 0x880-0x88f has been reserved
system 00:0a: ioport range 0x400-0x4bf could not be reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0xd3000-0xd3fff has been reserved
system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
system 00:0d: iomem range 0x7ff00000-0x7fffffff could not be reserved
system 00:0d: iomem range 0xfed00000-0xfed000ff has been reserved
system 00:0d: iomem range 0x7fee0000-0x7fefffff could not be reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x100000-0x7fedffff could not be reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfed13000-0xfed1ffff has been reserved
system 00:0d: iomem range 0xfed20000-0xfed9ffff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xffb00000-0xffb7ffff has been reserved
system 00:0d: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0d: iomem range 0xe0000-0xeffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x5000-0x5fff
pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0xa000-0xafff
pci 0000:00:1c.0:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.3:   IO window: 0x6000-0x6fff
pci 0000:00:1c.3:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000fdd00000-0x000000fddfffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x7000-0x7fff
pci 0000:00:1e.0:   MEM window: 0xd4000000-0xdbffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000f4000000-0x000000f7ffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbffffff]
pci_bus 0000:01: resource 2 pref mem [0xc0000000-0xcfffffff]
pci_bus 0000:02: resource 0 io:  [0xa000-0xafff]
pci_bus 0000:02: resource 1 mem: [0xfdc00000-0xfdcfffff]
pci_bus 0000:02: resource 2 pref mem [0xfdb00000-0xfdbfffff]
pci_bus 0000:04: resource 0 io:  [0x6000-0x6fff]
pci_bus 0000:04: resource 1 mem: [0xfde00000-0xfdefffff]
pci_bus 0000:04: resource 2 pref mem [0xfdd00000-0xfddfffff]
pci_bus 0000:05: resource 0 io:  [0x7000-0x7fff]
pci_bus 0000:05: resource 1 mem: [0xd4000000-0xdbffffff]
pci_bus 0000:05: resource 2 pref mem [0xf4000000-0xf7ffffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Scanning for low memory corruption every 60 seconds
HugeTLB registered 2 MB page size, pre-allocated 0 pages
SGI XFS with security attributes, realtime, large block/inode numbers, no debug enabled
msgmni has been set to 4020
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler cfq registered
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.3: setting latency timer to 64
lp: driver loaded but no devices found
Generic RTC Driver v1.07
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Platform driver 'serial8250' needs updating - please use dev_pm_ops
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
lp0: using parport0 (interrupt-driven).
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 17
ata6: SATA max UDMA/133 abar m2048@0xfdffd000 port 0xfdffd380 irq 17
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
md: raid0 personality registered for level 0
cpuidle: using governor ladder
TCP cubic registered
NET: Registered protocol family 17
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ata6: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATAPI: PIONEER DVD-RW  DVR-212D, 1.21, max UDMA/66
ata5.00: configured for UDMA/66
ata2.00: ATA-7: ST3750640NS, 3.BAF, max UDMA/133
ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: ATA-7: ST3750640NS, 3.BAF, max UDMA/133
ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3750640NS      3.BA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
scsi 1:0:0:0: Direct-Access     ATA      ST3750640NS      3.BA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb1
scsi 4:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212D 1.21 PQ: 0 ANSI: 5
 sdb2
 sda:
sd 1:0:0:0: [sdb] Attached SCSI disk
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
 sda1 sda2
sr 4:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: [sda] Attached SCSI disk
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 2 and added 2 devices.
md: autorun ...
md: considering sda2 ...
md:  adding sda2 ...
md:  adding sdb2 ...
md: created md0
md: bind<sdb2>
md: bind<sda2>
md: running: <sda2><sdb2>
raid0: looking at sda2
raid0:   comparing sda2(1433013760)
 with sda2(1433013760)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sdb2
raid0:   comparing sdb2(1433013760)
 with sda2(1433013760)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 2866027520 sectors.
******* md0 configuration *********
zone0=[sda2/sdb2/]
        zone offset=0kb device offset=0kb size=1433013760kb
**********************************

md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 352k freed
fuse init (API version 7.12)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
 md0:
ACPI: Invalid PBLK length [0]
ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU0._PDC] (Node ffff88007f858490), AE_ALREADY_EXISTS
ACPI: Marking method _PDC as Serialized because of AE_ALREADY_EXISTS error unknown partition table

processor LNXCPU:00: registered as cooling_device0
input: Power Button as /class/input/input0
ACPI: Power Button [PWRF]
ACPI: Invalid PBLK length [0]
input: Power Button as /class/input/input1
ACPI: Power Button [PWRB]
ACPI: SSDT 000000007fee8750 000CE (v01  PmRef  Cpu1Ist 00003000 INTL 20041203)
processor LNXCPU:01: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (34 C)
fan PNP0C0B:00: registered as cooling_device2
ACPI: Fan [FAN] (on)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sky2 driver version 1.23
sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 2
sky2 eth0: addr 00:15:58:8a:ae:e5
firewire_ohci 0000:05:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
firewire_ohci 0000:05:00.0: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:05:00.0, OHCI version 1.10
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fc00
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
sr 4:0:0:0: Attached scsi generic sg2 type 5
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.31-rc3-git4 uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000f800
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.31-rc3-git4 uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f400
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.31-rc3-git4 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.31-rc3-git4 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ec00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.31-rc3-git4 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdfff000
Linux video capture interface: v2.00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: EHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.31-rc3-git4 ehci_hcd
usb usb6: SerialNumber: 0000:00:1a.7
usb usb6: configuration #1 chosen from 1 choice
ivtv: Start initialization, version 1.4.1
ivtv0: Initializing card 0
ivtv0: Autodetected Hauppauge card (cx23416 based)
ivtv 0000:05:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
tveeprom 0-0050: Hauppauge model 32062, rev B185, serial# 2842715
cx18:  Start initialization, version 1.2.0
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: EHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.31-rc3-git4 ehci_hcd
usb usb7: SerialNumber: 0000:00:1d.7
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
firewire_core: created device fw0: GUID 00016c200022ce9e, S400
tveeprom 0-0050: tuner model is TCL 2002N 6A (idx 85, type 50)
tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 0-0050: audio processor is MSP3445 (idx 12)
tveeprom 0-0050: decoder processor is SAA7115 (idx 19)
tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter
ivtv0: Autodetected Hauppauge WinTV PVR-250
saa7115 0-0021: saa7115 found (1f7115d0e100000) @ 0x42 (ivtv i2c driver #0)
msp3400 0-0040: MSP3445G-B8 found @ 0x80 (ivtv i2c driver #0)
msp3400 0-0040: msp3400 supports radio, mode is autodetect and autoselect
tuner 0-0061: chip found @ 0xc2 (ivtv i2c driver #0)
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 50 (TCL 2002N)
IRQ 17/ivtv0: IRQF_DISABLED is not guaranteed on shared IRQs
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Initialized card: Hauppauge WinTV PVR-250
cx18-0: Initializing card 0
cx18-0: Autodetected Hauppauge card
cx18 0000:05:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ivtv: End initialization
cx18-0: Unreasonably low latency timer, setting to 64 (was 2)
cx18-0: cx23418 revision 01010000 (B)
tveeprom 1-0050: Hauppauge model 74551, rev C1A3, serial# 1752579
tveeprom 1-0050: MAC address is 00-0D-FE-1A-BE-03
tveeprom 1-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 1-0050: audio processor is CX23418 (idx 38)
tveeprom 1-0050: decoder processor is CX23418 (idx 31)
tveeprom 1-0050: has radio
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0: Simultaneous Digital and Analog TV capture supported
IRQ 18/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
tuner 2-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or FM1236/F))
cx18-0: Registered device video1 for encoder MPEG (64 x 32 kB)
DVB: registering new adapter (cx18)
usb 7-5: new high speed USB device using ehci_hcd and address 4
MXL5005S: Attached at address 0x63
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered DVB adapter0 for TS (32 x 32 kB)
cx18-0: Registered device video33 for encoder YUV (16 x 128 kB)
cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
cx18-0: Registered device video25 for encoder PCM audio (256 x 4 kB)
cx18-0: Registered device radio1 for encoder radio
cx18-0: Initialized card: Hauppauge HVR-1600
cx18:  End initialization
usb 7-5: New USB device found, idVendor=058f, idProduct=6254
usb 7-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 7-5: configuration #1 chosen from 1 choice
hub 7-5:1.0: USB hub found
hub 7-5:1.0: 4 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: New USB device found, idVendor=15c2, idProduct=ffdc
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-1: configuration #1 chosen from 1 choice
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb 3-2: New USB device found, idVendor=046d, idProduct=c51e
usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 3-2: configuration #1 chosen from 1 choice
usbcore: registered new interface driver hiddev
input: HID 046d:c51e as /class/input/input2
generic-usb 0003:046D:C51E.0001: input: USB HID v1.11 Keyboard [HID 046d:c51e] on usb-0000:00:1d.0-2/input0
input: HID 046d:c51e as /class/input/input3
generic-usb 0003:046D:C51E.0002: input,hiddev0: USB HID v1.11 Mouse [HID 046d:c51e] on usb-0000:00:1d.0-2/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 4-2: new full speed USB device using uhci_hcd and address 2
usb 4-2: New USB device found, idVendor=0403, idProduct=6001
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 4-2: Product: Frankenswitch Solenoid Controller
usb 4-2: Manufacturer: RTR
usb 4-2: SerialNumber: A4RGYNGQ
usb 4-2: configuration #1 chosen from 1 choice
usb 5-2: new low speed USB device using uhci_hcd and address 2
usb 5-2: New USB device found, idVendor=051d, idProduct=0002
usb 5-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
usb 5-2: Product: Back-UPS XS 1300 LCD FW:836.H8 .D USB FW:H8 
usb 5-2: Manufacturer: American Power Conversion
usb 5-2: SerialNumber: BB0820009163  
usb 5-2: configuration #1 chosen from 1 choice
generic-usb 0003:051D:0002.0003: hiddev1: USB HID v1.10 Device [American Power Conversion Back-UPS XS 1300 LCD FW:836.H8 .D USB FW:H8 ] on usb-0000:00:1d.2-2/input0
usb 7-5.3: new high speed USB device using ehci_hcd and address 6
usb 7-5.3: New USB device found, idVendor=2040, idProduct=7200
usb 7-5.3: New USB device strings: Mfr=1, Product=2, SerialNumber=10
usb 7-5.3: Product: WinTV HVR-950
usb 7-5.3: Manufacturer: Hauppauge
usb 7-5.3: SerialNumber: 4031688744
usb 7-5.3: configuration #1 chosen from 1 choice
au0828 driver loaded
au0828: i2c bus registered
tveeprom 3-0050: Hauppauge model 72001, rev B3F0, serial# 5156904
tveeprom 3-0050: MAC address is 00-0D-FE-4E-B0-28
tveeprom 3-0050: tuner model is Xceive XC5000 (idx 150, type 76)
tveeprom 3-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 3-0050: audio processor is AU8522 (idx 44)
tveeprom 3-0050: decoder processor is AU8522 (idx 42)
tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter
hauppauge_eeprom: hauppauge eeprom: model=72001
au8522 3-0047: creating new instance
au8522_decoder creating new instance...
tuner 3-0061: chip found @ 0xc2 (au0828)
xc5000 3-0061: creating new instance
xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously
au8522 3-0047: attaching existing instance
xc5000 3-0061: attaching existing instance
xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously
DVB: registering new adapter (au0828)
DVB: registering adapter 1 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
Registered device AU0828 [Hauppauge HVR950Q]
usbcore: registered new interface driver au0828
usbcore: registered new interface driver snd-usb-audio
Adding 16064960k swap on /dev/sdb1.  Priority:-1 extents:1 across:16064960k 
EXT3 FS on sda1, internal journal
Filesystem "md0": Disabling barriers, trial barrier write failed
XFS mounting filesystem md0
Ending clean XFS mount for filesystem: md0
sky2 eth0: enabling interface
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
cx18 0000:05:03.0: firmware: requesting v4l-cx23418-dig.fw
cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)
ivtv 0000:05:02.0: firmware: requesting v4l-cx2341x-enc.fw
ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
ivtv0: Encoder revision: 0x02060039
input: i2c IR (Hauppauge) as /class/input/input4
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
usb 7-5.3: firmware: requesting dvb-fe-xc5000-1.6.114.fw
xc5000: firmware read 12401 bytes.
xc5000: firmware uploading...
ata2.00: configured for UDMA/133
ata2: EH complete
ata1.00: configured for UDMA/133
ata1: EH complete
xc5000: firmware upload complete...
nvidia: module license 'NVIDIA' taints kernel.
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.14  Wed May 27 01:23:47 PDT 2009
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.14  Wed May 27 01:23:47 PDT 2009
input: i2c IR (Hauppauge) as /class/input/input5
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
input: i2c IR (Hauppauge) as /class/input/input6
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
usb 7-5.3: firmware: requesting dvb-fe-xc5000-1.6.114.fw
xc5000: firmware read 12401 bytes.
xc5000: firmware uploading...
xc5000: firmware upload complete...
