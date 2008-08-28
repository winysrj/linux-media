Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48B6E525.7070306@glidos.net>
Date: Thu, 28 Aug 2008 18:49:25 +0100
From: Paul Gardiner <lists@glidos.net>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>	
	<48B64690.4060205@glidos.net>	
	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>	
	<37219a840808280825i4c867c03u3c2d48888f51dde4@mail.gmail.com>	
	<48B6CDEB.2060305@glidos.net>
	<37219a840808280921g3e602acco6697c4f4af43ec74@mail.gmail.com>
In-Reply-To: <37219a840808280921g3e602acco6697c4f4af43ec74@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------080509030009020309060004"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Looks like there's a new unsupported WinTV Nova T
 500 out there
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------080509030009020309060004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Michael Krufky wrote:
> On Thu, Aug 28, 2008 at 12:10 PM, Paul Gardiner <lists@glidos.net> wrote:
>> Michael Krufky wrote:
>>> Hauppauge Nova-T-500 model 99101 works out-of-the-box , if you are
>>> using the latest drivers hosted on linuxtv.org.
>>>
>>> This was a false alarm -- it's all supported.
>> Great news, and sorry for the false alarm, but did you see my reply?
>> Turned out I had built the latest drivers. Any idea what else I
>> might be doing wrong?
> 
> 
> Try a different PCI slot.
> 
> If that doesnt work, then please show full dmesg.

Tried a different slot. Tried a different computer (running
SuSE 10.3, plust latest build of drivers from linuxtv.org.
Still nothing. Here's my dmesg output.

I'm going to try the card in a Windows machine. Didn't
want to pollute that machine with the extra drivers, but
I guess now it's looking like a dead card.

Cheers,
	Paul.

--------------080509030009020309060004
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.25.11-0.1-pae (geeko@buildhost) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #1 SMP 2008-07-13 20:48:28 +0200
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000037fd0000 (usable)
 BIOS-e820: 0000000037fd0000 - 0000000037fde000 (ACPI data)
 BIOS-e820: 0000000037fde000 - 0000000038000000 (ACPI NVS)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
895MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00ff780] 000ff780
NX (Execute Disable) protection: active
Entering add_active_range(0, 0, 229328) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229328
  HighMem    229328 ->   229328
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   229328
On node 0 totalpages: 229328
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1759 pages used for memmap
  Normal zone: 223473 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI present.
Using APIC driver default
ACPI: RSDP 000F9730, 0014 (r0 ACPIAM)
ACPI: RSDT 37FD0000, 0038 (r1 040407 RSDT1502 20070404 MSFT       97)
ACPI: FACP 37FD0200, 0084 (r2 040407 FACP1502 20070404 MSFT       97)
ACPI: DSDT 37FD0430, 45D7 (r1  1ADNC 1ADNCB36      B36 INTL 20051117)
ACPI: FACS 37FDE000, 0040
ACPI: APIC 37FD0390, 005C (r1 040407 APIC1502 20070404 MSFT       97)
ACPI: MCFG 37FD03F0, 003C (r1 040407 OEMMCFG  20070404 MSFT       97)
ACPI: OEMB 37FDE040, 0071 (r1 040407 OEMB1502 20070404 MSFT       97)
ACPI: HPET 37FD4A10, 0038 (r1 040407 OEMHPET  20070404 MSFT       97)
ATI board detected. Disabling timer routing over 8254.
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:15 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8300 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 40000000 (gap: 38000000:c7f80000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227537
Kernel command line: root=/dev/disk/by-id/scsi-SATA_SAMSUNG_HD501LJS0MUJ1KPA71657-part2 resume=/dev/sda1 splash=silent vga=0x31a
bootsplash: silent mode.
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2394.335 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 898928k/917312k available (1953k kernel code, 17864k reserved, 1676k data, 264k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xff8b2000 - 0xfffff000   (7476 kB)
    pkmap   : 0xff400000 - 0xff600000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
    lowmem  : 0xc0000000 - 0xf7fd0000   ( 895 MB)
      .init : 0xc0493000 - 0xc04d5000   ( 264 kB)
      .data : 0xc02e85e2 - 0xc048b784   (1676 kB)
      .text : 0xc0100000 - 0xc02e85e2   (1953 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4924.95 BogoMIPS (lpj=9849918)
Security Framework initialized
AppArmor: AppArmor initialized <NULL>
AppArmor: Registered secondary security module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 18k freed
ACPI: Core revision 20070126
ACPI: Checking initramfs for custom DSDT
Parsing all Control Methods:
Table [DSDT](id 0001) - 748 Objects with 64 Devices 207 Methods 18 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
CPU0: AMD Athlon(tm) 64 Processor 3800+ stepping 02
Total of 1 processors activated (4924.95 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000001
  groups: 00000000,00000000,00000000,00000001
net_namespace: 548 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 11 Runtime GPEs in this block
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.........................................................................................
Initialized 8/18 Regions 22/22 Fields 30/30 Buffers 29/31 Packages (757 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:..
Executed 2 _INI methods requiring 0 _STA executions (examined 70 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:12.0: set SATA to AHCI mode
PCI: Transparent bridge - 0000:00:14.4
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 7 10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  AD, should be A1 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
AppArmor: AppArmor Filesystem Enabled 
ACPI: RTC can wake from S4
system 00:01: iomem range 0x38000000-0x3fffffff has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x40b-0x40b has been reserved
system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
system 00:0a: ioport range 0xc00-0xc01 has been reserved
system 00:0a: ioport range 0xc14-0xc14 has been reserved
system 00:0a: ioport range 0xc50-0xc51 has been reserved
system 00:0a: ioport range 0xc52-0xc52 has been reserved
system 00:0a: ioport range 0xc6c-0xc6c has been reserved
system 00:0a: ioport range 0xc6f-0xc6f has been reserved
system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
system 00:0a: ioport range 0xcd8-0xcdf has been reserved
system 00:0a: ioport range 0x800-0x89f has been reserved
system 00:0a: ioport range 0xb10-0xb1f has been reserved
system 00:0a: ioport range 0x900-0x90f has been reserved
system 00:0a: ioport range 0x910-0x91f has been reserved
system 00:0a: ioport range 0xfe00-0xfefe has been reserved
system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
system 00:0a: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:0b: ioport range 0x600-0x6df has been reserved
system 00:0b: ioport range 0xae0-0xaef has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0x37ffffff could not be reserved
system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: c000-cfff
  MEM window: 0xfe800000-0xfe9fffff
  PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
PCI: Bridge: 0000:00:07.0
  IO window: d000-dfff
  MEM window: 0xfea00000-0xfeafffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:14.4
  IO window: e000-efff
  MEM window: 0xfeb00000-0xfebfffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:07.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Unpacking initramfs...<7>Switched to high resolution mode on CPU 0
 done
Freeing initrd memory: 5357k freed
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
type=2000 audit(1219945465.508:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:05.0: Boot video device
PCI: Setting latency timer of device 0000:00:07.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:07.0:pcie00]
vesafb: framebuffer at 0xf0000000, mapped to 0xf8880000, using 10240k, total 16384k
vesafb: mode is 1280x1024x16, linelength=2560, pages=5
vesafb: protected mode interface info at c000:9f9e
vesafb: pmi: set display start = c00ca028, set palette = c00ca0e6
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...
bootsplash: silentjpeg size 208945 bytes
bootsplash: ...found (1280x1024, 220863 bytes, v3).
Console: switching to colour frame buffer device 156x60
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
NET: Registered protocol family 1
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 264k freed
Write protecting the kernel read-only data: 1432k
ACPI: duty_cycle spans bit 4
ACPI: ACPI0007:00 is registered as cooling_device0
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:14.1 to 64
scsi0 : pata_atiixp
scsi1 : pata_atiixp
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
ata1.00: ATAPI: ASUS    CD-S520/A4, 1.0, max UDMA/33
ata1.00: configured for UDMA/33
scsi 0:0:0:0: CD-ROM            ASUS     CD-S520/A4       1.0  PQ: 0 ANSI: 5
ahci 0000:00:12.0: version 3.0
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part 
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ff900 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ff980 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa00 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa80 irq 22
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usbcore: registered new device driver usb
 sda:<7>ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:13.0: OHCI Host Controller
 sda1 sda2 sda3
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe7fe000
sd 2:0:0:0: [sda] Attached SCSI disk
USB Universal Host Controller Interface driver v3.0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25.11-0.1-pae ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:03:02.0: UHCI Host Controller
ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:03:02.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: EHCI Host Controller
uhci_hcd 0000:03:02.0: irq 22, io base 0x0000e800
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 3
usb usb2: configuration #1 chosen from 1 choice
ehci_hcd 0000:00:13.5: debug port 1
hub 2-0:1.0: USB hub found
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe7ff000
hub 2-0:1.0: 2 ports detected
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.11-0.1-pae uhci_hcd
usb usb2: SerialNumber: 0000:03:02.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 10 ports detected
ACPI: PCI Interrupt 0000:03:02.1[B] -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:03:02.1: UHCI Host Controller
usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: EHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25.11-0.1-pae ehci_hcd
usb usb3: SerialNumber: 0000:00:13.5
ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe7fd000
uhci_hcd 0000:03:02.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:03:02.1: irq 23, io base 0x0000e400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
usb 2-1: new full speed USB device using uhci_hcd and address 2
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25.11-0.1-pae uhci_hcd
usb usb5: SerialNumber: 0000:03:02.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: not running at top speed; connect to a high speed hub
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=10b8, idProduct=0066
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: HOOK
usb 2-1: Manufacturer: DiBcom SA
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25.11-0.1-pae ohci_hcd
usb usb4: SerialNumber: 0000:00:13.1
ACPI: PCI Interrupt 0000:03:02.2[C] -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:03:02.2: EHCI Host Controller
ehci_hcd 0000:03:02.2: new USB bus registered, assigned bus number 6
ehci_hcd 0000:03:02.2: irq 20, io mem 0xfebffc00
ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:03:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
ohci_hcd 0000:00:13.2: OHCI Host Controller
hub 6-0:1.0: 4 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: EHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25.11-0.1-pae ehci_hcd
usb usb6: SerialNumber: 0000:03:02.2
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe7fc000
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb 2-1: USB disconnect, address 2
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.25.11-0.1-pae ohci_hcd
usb usb7: SerialNumber: 0000:00:13.2
ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 8
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe7fb000
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb 6-1: new high speed USB device using ehci_hcd and address 2
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: OHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.25.11-0.1-pae ohci_hcd
usb usb8: SerialNumber: 0000:00:13.3
ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 9
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe7fa000
usb 6-1: configuration #1 chosen from 1 choice
usb 6-1: New USB device found, idVendor=10b8, idProduct=0066
usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 6-1: Product: HOOK
usb 6-1: Manufacturer: DiBcom SA
usb usb9: configuration #1 chosen from 1 choice
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 2 ports detected
usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb9: Product: OHCI Host Controller
usb usb9: Manufacturer: Linux 2.6.25.11-0.1-pae ohci_hcd
usb usb9: SerialNumber: 0000:00:13.4
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
scsi 0:0:0:0: Attached scsi generic sg0 type 5
sd 2:0:0:0: Attached scsi generic sg1 type 0
Linux agpgart interface v0.103
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: RTL8101e at 0xf9612000, 00:19:db:68:45:da, XID 34000000 IRQ 222
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
ACPI: Power Button (CM) [PWRB]
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SMOV [0xb00-0xb06]
ACPI: Device needs an ACPI driver
ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
ppdev: user-space parallel port driver
Adding 2104472k swap on /dev/sda1.  Priority:-1 extents:1 across:2104472k
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
type=1505 audit(1219945484.551:2): operation="profile_load" name="/bin/ping" name2="default" pid=1230
type=1505 audit(1219945484.599:3): operation="profile_load" name="/sbin/klogd" name2="default" pid=1231
type=1505 audit(1219945484.659:4): operation="profile_load" name="/sbin/syslog-ng" name2="default" pid=1232
type=1505 audit(1219945484.715:5): operation="profile_load" name="/sbin/syslogd" name2="default" pid=1235
type=1505 audit(1219945484.775:6): operation="profile_load" name="/usr/sbin/avahi-daemon" name2="default" pid=1238
type=1505 audit(1219945484.831:7): operation="profile_load" name="/usr/sbin/identd" name2="default" pid=1242
type=1505 audit(1219945484.887:8): operation="profile_load" name="/usr/sbin/mdnsd" name2="default" pid=1245
type=1505 audit(1219945484.983:9): operation="profile_load" name="/usr/sbin/named" name2="default" pid=1250
type=1505 audit(1219945485.039:10): operation="profile_load" name="/usr/sbin/nscd" name2="default" pid=1263
type=1505 audit(1219945485.111:11): operation="profile_load" name="/usr/sbin/ntpd" name2="default" pid=1266
fuse init (API version 7.9)
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3800+ processors (1 cpu cores) (version 2.20.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects
powernow: This module only works with AMD K7 CPUs
r8169: eth0: link up
r8169: eth0: link up
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
printk: 3 messages suppressed.
type=1503 audit(1219945490.679:13): operation="inode_permission" requested_mask="x::" denied_mask="x::" fsuid=0 name="/bin/bash" pid=2143 profile="/sbin/syslog-ng"
warning: `named' uses deprecated v2 capabilities in a way that may be insecure.
eth0: no IPv6 routers present
NET: Registered protocol family 17
dib0700: loaded with support for 7 different device-types
usbcore: registered new interface driver dvb_usb_dib0700

--------------080509030009020309060004
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------080509030009020309060004--
