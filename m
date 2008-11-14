Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jon.the.wise.gdrive@gmail.com>) id 1L15aF-0002Zg-QR
	for linux-dvb@linuxtv.org; Fri, 14 Nov 2008 21:48:09 +0100
Received: by yw-out-2324.google.com with SMTP id 3so675891ywj.41
	for <linux-dvb@linuxtv.org>; Fri, 14 Nov 2008 12:47:58 -0800 (PST)
Message-Id: <5314D9F8-88CC-4FD4-9369-B44E5E5C7733@gmail.com>
From: Jon Bishop <jon.the.wise.gdrive@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Fri, 14 Nov 2008 12:47:43 -0800
Subject: [linux-dvb] Tuning Problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I'm having trouble with a pvr150 card that I just added to my system.  
I don't know if I should post it here, or what, but I've been using  
the dvb drivers for months with no problems, so I figured it's a good  
place to start.

My system is opensuse 10.3 with kernel 2.6.24.3 compiled by me. I just  
downloaded the latest v4l sources a half hour ago and compiled and  
installed those. Everything appears to be working on my pinnacle PCTV  
800i cards. The hauppage appears to be detected right, but it's not  
working properly. When I attempt to use tvtime I can connect to the  
analogue side of the pinnacle cards at /dev/video1 and /dev/video2,  
but I can't open /dev/video0, which is my hauppage. When using mythtv,  
it connects, and tunes, and reports no issues, but it only seems to  
tune channels 3-13. I have connected the coax to the tv set, and can  
tune most of 3-70, but myth just shows snow for channels 14 and up. My  
pinnacle cards are hooked up to rabbit ears, and tune ATSC just fine.  
Anybody know what I'm doing wrong?

jon@theboss:~> dmesg
Linux version 2.6.24.3-default (root@theboss) (gcc version 4.2.1 (SUSE  
Linux)) #1 Wed Mar 19 08:47:29 PDT 2008
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000003ff40000 (usable)
BIOS-e820: 000000003ff40000 - 000000003ff50000 (ACPI data)
BIOS-e820: 000000003ff50000 - 0000000040000000 (ACPI NVS)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 261952) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261952
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261952
On node 0 totalpages: 261952
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32322 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F7300, 0014 (r0 ACPIAM)
ACPI: RSDT 3FF40000, 0030 (r1 INTEL  D845GBV  20030714 MSFT       97)
ACPI: FACP 3FF40200, 0081 (r2 INTEL  D845GBV  20030714 MSFT       97)
ACPI: DSDT 3FF40370, 3FD7 (r1 INTEL  D845GBV       10A MSFT  100000D)
ACPI: FACS 3FF50000, 0040
ACPI: APIC 3FF40300, 0068 (r1 INTEL  D845GBV  20030714 MSFT       97)
ACPI: ASF! 3FF44350, 0084 (r16 AMIASF I845GASF        1 MSFT  100000D)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:c0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:  
259906
Kernel command line: root=/dev/disk/by-id/scsi-SATA_IC35L060AVV207- 
_VNVB20G2GMVG5R-part3 vga=normal    resume=/dev/sda2 sp
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2400.159 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1027624k/1047808k available (1688k kernel code, 19468k  
reserved, 725k data, 192k init, 130304k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa6000 - 0xfffff000   ( 356 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc035e000 - 0xc038e000   ( 192 kB)
      .data : 0xc02a63c8 - 0xc035bbc0   ( 725 kB)
      .text : 0xc0100000 - 0xc02a63c8   (1688 kB)
Checking if this processor honours the WP bit even in supervisor  
mode... Ok.
Calibrating delay using timer specific routine.. 4803.73 BogoMIPS  
(lpj=9607476)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000  
00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: 3febfbff 00000000 00000000 0000b080  
00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 Family CPU 2.40GHz stepping 04
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 592 Objects with 46 Devices 164 Methods 21  
Regions
tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully  
acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode  
successful
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs  
on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 7 Wake, Enabled 0  
Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package  
initialization 
:............................................................................................................
Initialized 18/21 Regions 29/29 Fields 47/47 Buffers 14/14 Packages  
(601 nodes)
Initializing Device/Processor/Thermal objects by executing _INI  
methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 50  
objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post  
a report
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x400-0x47f has been reserved
system 00:09: ioport range 0x680-0x6ff has been reserved
system 00:09: ioport range 0x480-0x4bf has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0a: iomem range 0x0-0x9ffff could not be reserved
system 00:0a: iomem range 0xc0000-0xdffff could not be reserved
system 00:0a: iomem range 0xe0000-0xfffff could not be reserved
system 00:0a: iomem range 0x100000-0x3fffffff could not be reserved
system 00:0a: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: f2800000-f28fffff
  PREFETCH window: aa500000-ca5fffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: f2900000-feafffff
  PREFETCH window: ca600000-d26fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 7408k freed
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
audit(1226693893.696:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Firmware left 0000:02:08.0 e100 interrupts enabled, disabling
isapnp: Scanning for PnP cards...
Switched to NOHz mode on CPU #0
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
floppy0: no floppy controllers found
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
NET: Registered protocol family 1
Using IPI Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 192k freed
ACPI: Processor [CPU1] (supports 8 throttling states)
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.12
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATA-6: IC35L060AVV207-0, V22OA66A, max UDMA/100
ata1.00: 78165360 sectors, multi 16: LBA48
ata1.01: ATAPI: Hewlett-Packard DVD Writer 100, 1.30, max UDMA/33
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
ata1.01: configured for UDMA/33
ata2.00: ATA-6: WDC WD2000JB-00DUA0, 63.13F63, max UDMA/100
ata2.00: 390721968 sectors, multi 16: LBA48
ata2.01: ATA-5: MAXTOR 6L080J4, A93.0500, max UDMA/133
ata2.01: 156355584 sectors, multi 16: LBA
ata2.00: configured for UDMA/100
ata2.01: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      IC35L060AVV207-0 V22O PQ: 0  
ANSI: 5
scsi 0:0:1:0: CD-ROM            HP       DVD Writer 100j  1.30 PQ: 0  
ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD2000JB-00D 63.1 PQ: 0  
ANSI: 5
scsi 1:0:1:0: Direct-Access     ATA      MAXTOR 6L080J4   A93. PQ: 0  
ANSI: 5
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 17, io base 0x0000e800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors (40021 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors (40021 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 1:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:1:0: [sdc] 156355584 512-byte hardware sectors (80054 MB)
sd 1:0:1:0: [sdc] Write Protect is off
sd 1:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 1:0:1:0: [sdc] 156355584 512-byte hardware sectors (80054 MB)
sd 1:0:1:0: [sdc] Write Protect is off
sd 1:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sdc: sdc1
sd 1:0:1:0: [sdc] Attached SCSI disk
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000e880
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000ec00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfebffc00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 5 ports detected
usb 2-1.1: new low speed USB device using uhci_hcd and address 3
usb 2-1.1: configuration #1 chosen from 1 choice
usb 2-1.5: new full speed USB device using uhci_hcd and address 4
usb 2-1.5: configuration #1 chosen from 1 choice
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Attached scsi generic sg1 type 5
sd 1:0:0:0: Attached scsi generic sg2 type 0
sd 1:0:1:0: Attached scsi generic sg3 type 0
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/virtual/input/input1
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/virtual/input/input2
ACPI: Sleep Button (CM) [SLPB]
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH4 TCO device (Version=1, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:1:0: Attached scsi CD-ROM sr0
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
Linux video capture interface: v2.00
Linux agpgart interface v0.102
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/ 
usb2/2-1/2-1.1/2-1.1:1.0/input/input3
input: USB HID v1.10 Keyboard [Logitech USB Receiver] on  
usb-0000:00:1d.1-1.1
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with  
idebus=xx
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.1/ 
usb2/2-1/2-1.1/2-1.1:1.1/input/input4
HPT370A: IDE controller (0x1103:0x0004 rev 0x04) at  PCI slot  
0000:02:01.0
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 22 (level, low) -> IRQ 20
HPT370A: DPLL base: 48 MHz, f_CNT: 141, assuming 33 MHz PCI
HPT370A: using 33 MHz PCI clock
HPT370A: 100% native mode on irq 20
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d. 
1-1.1
input: FTDI  PS/2 Keyboard And Mouse I/F as /devices/ 
pci0000:00/0000:00:1d.1/usb2/2-1/2-1.5/2-1.5:1.0/input/input5
input: USB HID v1.00 Keyboard [FTDI  PS/2 Keyboard And Mouse I/F] on  
usb-0000:00:1d.1-1.5
input: FTDI  PS/2 Keyboard And Mouse I/F as /devices/ 
pci0000:00/0000:00:1d.1/usb2/2-1/2-1.5/2-1.5:1.1/input/input6
agpgart: Detected an Intel 830M Chipset.
agpgart: AGP aperture is 256M @ 0xe0000000
input: USB HID v1.00 Mouse [FTDI  PS/2 Keyboard And Mouse I/F] on  
usb-0000:00:1d.1-1.5
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
rtc_cmos: probe of 00:02 failed with error -16
fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies,  
Starnberg, GERMANY' taints kernel.
[fglrx] Maximum main memory to use for locked dma buffers: 929 MBytes.
[fglrx]   vendor: 1002 device: 9587 count: 1
[fglrx] ioport: bar 1, base 0xc800, size: 0x100
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 17
[fglrx] PAT is enabled successfully!
[fglrx] module loaded - fglrx 8.54.3 [Oct  3 2008] with 1 minors
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
Probing IDE interface ide1...
ivtv:  Start initialization, version 1.4.0
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx2388x alsa driver version 0.0.6 loaded
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
hdd: WDC WD1000BB-32CCB0, ATA DISK drive
hdc: Maxtor 6L160P0, ATA DISK drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/66 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/66 mode selected
ide1 at 0xd800-0xd807,0xd482 on irq 20
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 21
sata_sil 0000:02:05.0: version 2.3
ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 18 (level, low) -> IRQ 16
sata_sil 0000:02:05.0: Applying R_ERR on DMA activate FIS errata fix
scsi2 : sata_sil
scsi3 : sata_sil
scsi4 : sata_sil
scsi5 : sata_sil
ata3: SATA max UDMA/100 mmio m1024@0xfeadf400 tf 0xfeadf480 irq 16
ata4: SATA max UDMA/100 mmio m1024@0xfeadf400 tf 0xfeadf4c0 irq 16
ata5: SATA max UDMA/100 mmio m1024@0xfeadf400 tf 0xfeadf680 irq 16
ata6: SATA max UDMA/100 mmio m1024@0xfeadf400 tf 0xfeadf6c0 irq 16
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATA-8: WDC WD6400AACS-00G8B0, 05.04C05, max UDMA/133
ata3.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: ATA-8: WDC WD6400AACS-00G8B0, 05.04C05, max UDMA/133
ata4.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/100
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata5.00: ATA-8: WDC WD6400AACS-00G8B0, 05.04C05, max UDMA/133
ata5.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/100
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata6.00: ATA-8: WDC WD6400AACS-00G8B0, 05.04C05, max UDMA/133
ata6.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400AACS-0 05.0 PQ: 0  
ANSI: 5
sd 2:0:0:0: [sdd] 1250263728 512-byte hardware sectors (640135 MB)
sd 2:0:0:0: [sdd] Write Protect is off
sd 2:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 2:0:0:0: [sdd] 1250263728 512-byte hardware sectors (640135 MB)
sd 2:0:0:0: [sdd] Write Protect is off
sd 2:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sdd: sdd1
sd 2:0:0:0: [sdd] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg4 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD6400AACS-0 05.0 PQ: 0  
ANSI: 5
sd 3:0:0:0: [sde] 1250263728 512-byte hardware sectors (640135 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 3:0:0:0: [sde] 1250263728 512-byte hardware sectors (640135 MB)
sd 3:0:0:0: [sde] Write Protect is off
sd 3:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sde: sde1
sd 3:0:0:0: [sde] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg5 type 0
scsi 4:0:0:0: Direct-Access     ATA      WDC WD6400AACS-0 05.0 PQ: 0  
ANSI: 5
sd 4:0:0:0: [sdf] 1250263728 512-byte hardware sectors (640135 MB)
sd 4:0:0:0: [sdf] Write Protect is off
sd 4:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 4:0:0:0: [sdf] 1250263728 512-byte hardware sectors (640135 MB)
sd 4:0:0:0: [sdf] Write Protect is off
sd 4:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sdf: sdf1
sd 4:0:0:0: [sdf] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg6 type 0
scsi 5:0:0:0: Direct-Access     ATA      WDC WD6400AACS-0 05.0 PQ: 0  
ANSI: 5
sd 5:0:0:0: [sdg] 1250263728 512-byte hardware sectors (640135 MB)
sd 5:0:0:0: [sdg] Write Protect is off
sd 5:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sd 5:0:0:0: [sdg] 1250263728 512-byte hardware sectors (640135 MB)
sd 5:0:0:0: [sdg] Write Protect is off
sd 5:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't  
support DPO or FUA
sdg: sdg1
sd 5:0:0:0: [sdg] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg7 type 0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 21 (level, low) -> IRQ 22
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[feadf800- 
feadffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 20 (level, low) -> IRQ 23
e100: eth0: e100_probe: addr 0xfeade000, irq 23, MAC addr  
00:07:e9:ad:bb:07
ivtv0: Initializing card #0
ivtv0: Autodetected Hauppauge card (cx23416 based)
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 18 (level, low) -> IRQ 16
ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
ivtv i2c driver #0: Test OK
tveeprom 1-0050: Hauppauge model 26552, rev F1B6, serial# 9968811
tveeprom 1-0050: tuner model is Philips FM1236 MK5 (idx 116, type 43)
tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 1-0050: audio processor is CX25843 (idx 37)
tveeprom 1-0050: decoder processor is CX25843 (idx 30)
tveeprom 1-0050: has radio
ivtv0: Autodetected Hauppauge WinTV PVR-150
cx25840 1-0044: cx25843-24 found @ 0x88 (ivtv i2c driver #0)
tuner 1-0043: chip found @ 0x86 (ivtv i2c driver #0)
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
tuner 1-0061: chip found @ 0xc2 (ivtv i2c driver #0)
wm8775 1-001b: chip found @ 0x36 (ivtv i2c driver #0)
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or  
FM1236/F))
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011066645556173]
cx25840 1-0044: loaded v4l-cx25840.fw firmware (16382 bytes)
ivtv0: Registered device video0 for encoder MPG (4096 kB)
ivtv0: Registered device video32 for encoder YUV (2048 kB)
ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
ivtv0: Registered device video24 for encoder PCM (320 kB)
ivtv0: Registered device radio0 for encoder radio
ivtv0: Initialized card #0: Hauppauge WinTV PVR-150
ACPI: PCI Interrupt 0000:02:03.1[A] -> GSI 19 (level, low) -> IRQ 18
cx88[0]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i  
[card=58,autodetected], frontend(s): 1
cx88[0]: TV tuner type 76, Radio tuner type -1
cx88[0]: Test OK
tuner' 2-0064: chip found @ 0xc8 (cx88[0])
xc5000 2-0064: creating new instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[0]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /devices/ 
pci0000:00/0000:00:1e.0/0000:02:03.1/input/input7
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:02:03.2[A] -> GSI 19 (level, low) -> IRQ 18
cx88[0]/2: found at 0000:02:03.2, rev: 5, irq: 18, latency: 32, mmio:  
0xfd000000
cx8802_probe() allocating 1 frontend(s)
cx88[1]: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i  
[card=58,autodetected], frontend(s): 1
cx88[1]: TV tuner type 76, Radio tuner type -1
cx88[1]: Test OK
tuner' 3-0064: chip found @ 0xc8 (cx88[1])
xc5000 3-0064: creating new instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has not been loaded previously
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
xc5000: firmware read 12332 bytes.
xc5000: firmware upload
cx88[1]: Calling XC5000 callback
input: cx88 IR (Pinnacle PCTV HD 800i) as /devices/ 
pci0000:00/0000:00:1e.0/0000:02:04.2/input/input8
cx88[1]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:02:04.2[A] -> GSI 17 (level, low) -> IRQ 21
cx88[1]/2: found at 0000:02:04.2, rev: 5, irq: 21, latency: 32, mmio:  
0xfa000000
cx8802_probe() allocating 1 frontend(s)
ivtv:  End initialization
ALSA sound/core/init.c:137: cannot find the slot for index 0 (range  
0-0), error: -16
Intel ICH: probe of 0000:00:1f.5 failed with error -12
ACPI: PCI Interrupt 0000:02:04.1[A] -> GSI 17 (level, low) -> IRQ 21
cx88[1]/1: CX88x/1: ALSA support for cx2388x boards
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 19 (level, low) -> IRQ 18
cx88[0]/0: found at 0000:02:03.0, rev: 5, irq: 18, latency: 32, mmio:  
0xfb000000
cx88[0]/0: registered device video1 [v4l2]
cx88[0]/0: registered device vbi1
ACPI: PCI Interrupt 0000:02:04.0[A] -> GSI 17 (level, low) -> IRQ 21
cx88[1]/0: found at 0000:02:04.0, rev: 5, irq: 21, latency: 32, mmio:  
0xf8000000
cx88[1]/0: registered device video2 [v4l2]
cx88[1]/0: registered device vbi2
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[0]/2: cx2388x based DVB/ATSC card
xc5000 2-0064: attaching existing instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB  
Frontend)...
cx88[1]/2: subsystem: 11bd:0051, board: Pinnacle PCTV HD 800i [card=58]
cx88[1]/2: cx2388x based DVB/ATSC card
xc5000 3-0064: attaching existing instance
xc5000: Successfully identified at address 0x64
xc5000: Firmware has been loaded previously
DVB: registering new adapter (cx88[1])
DVB: registering adapter 1 frontend 0 (Samsung S5H1409 QAM/8VSB  
Frontend)...
hdc: max request size: 512KiB
hdc: 320173056 sectors (163928 MB) w/8192KiB Cache, CHS=19929/255/63
hdc: cache flushes supported
hdc: hdc1
hdd: max request size: 128KiB
hdd: 195371568 sectors (100030 MB) w/2048KiB Cache, CHS=65535/16/63
hdd: cache flushes not supported
hdd: hdd1
Adding 1052248k swap on /dev/sda2.  Priority:-1 extents:1 across: 
1052248k
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, realtime, large block numbers,  
no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sdb1
Ending clean XFS mount for filesystem: sdb1
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
XFS mounting filesystem sde1
Ending clean XFS mount for filesystem: sde1
XFS mounting filesystem sdd1
Ending clean XFS mount for filesystem: sdd1
XFS mounting filesystem sdf1
Ending clean XFS mount for filesystem: sdf1
XFS mounting filesystem sdg1
Ending clean XFS mount for filesystem: sdg1
Filesystem "hdd1": Disabling barriers, not supported by the underlying  
device
XFS mounting filesystem hdd1
Ending clean XFS mount for filesystem: hdd1
XFS mounting filesystem hdc1
Ending clean XFS mount for filesystem: hdc1
powernow: This module only works with AMD K7 CPUs
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
[fglrx] AGP detected, AgpState   = 0x1f000217 (hardware caps of chipset)
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[fglrx] AGP enabled,  AgpCommand = 0x1f000314 (selected caps)
[fglrx] Setup AGP aperture
[fglrx] CMM init INV FB MC:0xd0000000, length:0x10000000
[fglrx] Reserved FB block: Shared offset:0, size:1000000
[fglrx] Reserved FB block: Unshared offset:ff77000, size:88000
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
eth0: no IPv6 routers present
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
ivtv0: Encoder revision: 0x02060039

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
