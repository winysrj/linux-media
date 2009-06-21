Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc2-s2.col0.hotmail.com ([65.55.34.76]:18318 "EHLO
	col0-omc2-s2.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbZFUTu7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2009 15:50:59 -0400
Message-ID: <COL103-W40B198179C2E84587DC71F88380@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <linux-media@vger.kernel.org>, <video4linux-list@redhat.com>
Subject: RE: Can't use my Pinnacle PCTV HD Pro stick - what am I doing wrong?
Date: Sun, 21 Jun 2009 15:51:02 -0400
In-Reply-To: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
References: <COL103-W53605D85359D631FC60D0F88380@phx.gbl>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Thank you so much, everyone who has replied to my question!  It's nice to find a community of people willing to help.  Here is the dmesg output that appears when the Pinnacle device gets plugged in, along with a few "ls" commands:

* usb 1-1: new high speed USB device using ehci_hcd and address 2
* usb 1-1: configuration #1 chosen from 1 choice
* Linux video capture interface: v2.00
* em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
* em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
* em28xx #0: chip ID is em2882/em2883
* em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
* em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
* em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
* em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
* em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
* em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
* em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
* em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
* em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
* em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
* em28xx #0: EEPROM info:
* em28xx #0:    AC97 audio (5 sample rates)
* em28xx #0:    500mA max power
* em28xx #0:    Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
* input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input6
* em28xx #0: Config register raw data: 0xd0
* em28xx #0: AC97 vendor ID = 0xffffffff
* em28xx #0: AC97 features = 0x6a90
* em28xx #0: Empia 202 AC97 audio processor detected
* em28xx #0: v4l2 driver version 0.1.2
* em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
* usbcore: registered new interface driver em28xx
* em28xx driver loaded
* xc2028 0-0061: creating new instance
* xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
* em28xx #0/2: xc3028 attached
* DVB: registering new adapter (em28xx #0)
* DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
* Successfully loaded em28xx-dvb
* Em28xx: Initialized (Em28xx dvb Extension) extension

> ls -lR /dev/dvb
/dev/dvb:
total 0
drwxr-xr-x 2 root root 120 2009-06-21 13:06 adapter0

/dev/dvb/adapter0:
total 0
crw-rw---- 1 root video 212, 1 2009-06-21 13:06 demux0
crw-rw---- 1 root video 212, 2 2009-06-21 13:06 dvr0
crw-rw---- 1 root video 212, 0 2009-06-21 13:06 frontend0
crw-rw---- 1 root video 212, 3 2009-06-21 13:06 net0

> ls -l /dev/vid*
crw-rw---- 1 root video 81, 0 2009-06-21 13:06 /dev/video0



A much fuller dmesg (from the system boot) is below, but everything that appears to be em28xx-related is shown above.  

Terry, you mentioned the program "Zapping".  I've just installed in Ubuntu and will give it a try when I get to the console later on.  Paul, thank you for your message.  I will try your mplayer suggestion once I'm at the console.  

One thing I failed to mention in the original e-mail is that I HAD this device working once before (back in February).  I put the device away for a few months after that.  Since then, Ubuntu has updated the kernel, so I updated and reinstalled the v4l drivers.  This time, though, something seems to be going wrong, and I don't know what's different.  Either 1) I've forgotten a criticial step that I did last time, or 2) something in the v4l drivers has changed resulting in a problem, or 3) the device itself has broken.  Assuming #2 is unlikely, I intend to try to rule out #3 by hooking the Pinnacle device up to a Windows box tomorrow.  Meanwhile, I'm operating on assumption #1: I'm missing something important.

I don't understand why there is no mention of the Xceive tuner in the dmesg output, though... or an attempt to load the firmware for it.

Anway, here's a much longer dmesg.  Any other information that would help, I'll be happy to add.




* Initializing cgroup subsys cpuset
* Initializing cgroup subsys cpu
* Linux version 2.6.24-24-server (buildd@rothera) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu4)) #1 SMP Wed Apr 15 16:36:01 UTC 2009 (Ubuntu 2.6.24-24.53-server)
* BIOS-provided physical RAM map:
*  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
*  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
*  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
*  BIOS-e820: 0000000000100000 - 00000000cfeb0000 (usable)
*  BIOS-e820: 00000000cfeb0000 - 00000000cfee2000 (ACPI NVS)
*  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
*  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
*  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
*  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
*  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
* 3968MB HIGHMEM available.
* 896MB LOWMEM available.
* found SMP MP-table at 000f57a0
* NX (Execute Disable) protection: active
* Entering add_active_range(0, 0, 1245184) 0 entries of 256 used
* Zone PFN ranges:
*   DMA             0 ->     4096
*   Normal       4096 ->   229376
*   HighMem    229376 ->  1245184
* Movable zone start PFN for each node
* early_node_map[1] active PFN ranges
*     0:        0 ->  1245184
* On node 0 totalpages: 1245184
*   DMA zone: 32 pages used for memmap
*   DMA zone: 0 pages reserved
*   DMA zone: 4064 pages, LIFO batch:0
*   Normal zone: 1760 pages used for memmap
*   Normal zone: 223520 pages, LIFO batch:31
*   HighMem zone: 7936 pages used for memmap
*   HighMem zone: 1007872 pages, LIFO batch:31
*   Movable zone: 0 pages used for memmap
* DMI 2.4 present.
* ACPI: RSDP signature @ 0xC00F75D0 checksum 0
* ACPI: RSDP 000F75D0, 0014 (r0 GBT   )
* ACPI: RSDT CFEE2040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
* ACPI: FACP CFEE20C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
* ACPI: DSDT CFEE2180, 50A9 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
* ACPI: FACS CFEB0000, 0040
* ACPI: EUDS CFEE79C0, 0500 (r1 GBT                    0             0)
* ACPI: HPET CFEE7880, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
* ACPI: MCFG CFEE7900, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
* ACPI: APIC CFEE7280, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
* ACPI: SSDT CFEE87F0, 03AB (r1  PmRef    CpuPm     3000 INTL 20040311)
* ACPI: PM-Timer IO Port: 0x408
* ACPI: Local APIC address 0xfee00000
* ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
* Processor #0 7:7 APIC version 20
* ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
* Processor #3 7:7 APIC version 20
* ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
* Processor #1 7:7 APIC version 20
* ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
* Processor #2 7:7 APIC version 20
* ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
* ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
* ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
* ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
* ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
* IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
* ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
* ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
* ACPI: IRQ0 used by override.
* ACPI: IRQ2 used by override.
* ACPI: IRQ9 used by override.
* Enabling APIC mode:  Flat.  Using 1 I/O APICs
* ACPI: HPET id: 0x8086a201 base: 0xfed00000
* Using ACPI (MADT) for SMP configuration information
* Allocating PCI resources starting at e6000000 (gap: e4000000:1ac00000)
* swsusp: Registered nosave memory region: 000000000009e000 - 00000000000a0000
* swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
* swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
* Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1235456
* Kernel command line: root=UUID=2f7e91eb-9b4a-4f03-aeda-c472bd2d7077 ro nosplash vga=0x034a
* mapped APIC to ffffb000 (fee00000)
* mapped IOAPIC to ffffa000 (fec00000)
* Enabling fast FPU save and restore... done.
* Enabling unmasked SIMD FPU exception support... done.
* Initializing CPU#0
* PID hash table entries: 4096 (order: 12, 16384 bytes)
* Detected 2833.082 MHz processor.
* Console: colour dummy device 80x25
* console [tty0] enabled
* Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
* Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
* Memory: 4140224k/4980736k available (2258k kernel code, 51520k reserved, 1037k data, 384k init, 3275456k highmem)
* virtual kernel memory layout:
*     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
*     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
*     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
*     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
*       .init : 0xc043e000 - 0xc049e000   ( 384 kB)
*       .data : 0xc0334a89 - 0xc0437fe4   (1037 kB)
*       .text : 0xc0100000 - 0xc0334a89   (2258 kB)
* Checking if this processor honours the WP bit even in supervisor mode... Ok.
* SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
* hpet clockevent registered
* Calibrating delay using timer specific routine.. 5669.07 BogoMIPS (lpj=28345371)
* Security Framework initialized
* SELinux:  Disabled at boot.
* AppArmor: AppArmor initialized
* Failure registering capabilities with primary security module.
* Mount-cache hash table entries: 512
* Initializing cgroup subsys ns
* Initializing cgroup subsys cpuacct
* CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
* monitor/mwait feature present.
* using mwait in idle threads.
* CPU: L1 I cache: 32K, L1 D cache: 32K
* CPU: L2 cache: 6144K
* CPU: Physical Processor ID: 0
* CPU: Processor Core ID: 0
* CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
* Compat vDSO mapped to ffffe000.
* Checking 'hlt' instruction... OK.
* SMP alternatives: switching to UP code
* Early unpacking initramfs... done
* ACPI: Core revision 20070126
* ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
* CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
* SMP alternatives: switching to SMP code
* Booting processor 1/1 eip 3000
* Initializing CPU#1
* Calibrating delay using timer specific routine.. 5666.00 BogoMIPS (lpj=28330022)
* CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
* monitor/mwait feature present.
* CPU: L1 I cache: 32K, L1 D cache: 32K
* CPU: L2 cache: 6144K
* CPU: Physical Processor ID: 0
* CPU: Processor Core ID: 1
* CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
* CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
* SMP alternatives: switching to SMP code
* Booting processor 2/2 eip 3000
* Initializing CPU#2
* Calibrating delay using timer specific routine.. 5666.03 BogoMIPS (lpj=28330195)
* CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
* monitor/mwait feature present.
* CPU: L1 I cache: 32K, L1 D cache: 32K
* CPU: L2 cache: 6144K
* CPU: Physical Processor ID: 0
* CPU: Processor Core ID: 2
* CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
* CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
* SMP alternatives: switching to SMP code
* Booting processor 3/3 eip 3000
* Initializing CPU#3
* Calibrating delay using timer specific routine.. 5666.05 BogoMIPS (lpj=28330266)
* CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0408e3fd 00000000 00000001 00000000
* monitor/mwait feature present.
* CPU: L1 I cache: 32K, L1 D cache: 32K
* CPU: L2 cache: 6144K
* CPU: Physical Processor ID: 0
* CPU: Processor Core ID: 3
* CPU: After all inits, caps: bfebfbff 20100000 00000000 00043940 0408e3fd 00000000 00000001 00000000
* CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
* Total of 4 processors activated (22667.17 BogoMIPS).
* ENABLING IO-APIC IRQs
* ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
* checking TSC synchronization [CPU#0 -> CPU#1]: passed.
* checking TSC synchronization [CPU#0 -> CPU#2]: passed.
* checking TSC synchronization [CPU#0 -> CPU#3]: passed.
* Brought up 4 CPUs
* CPU0 attaching sched-domain:
*  domain 0: span 03
*   groups: 01 02
*   domain 1: span 0f
*    groups: 03 0c
* CPU1 attaching sched-domain:
*  domain 0: span 03
*   groups: 02 01
*   domain 1: span 0f
*    groups: 03 0c
* CPU2 attaching sched-domain:
*  domain 0: span 0c
*   groups: 04 08
*   domain 1: span 0f
*    groups: 0c 03
* CPU3 attaching sched-domain:
*  domain 0: span 0c
*   groups: 08 04
*   domain 1: span 0f
*    groups: 0c 03
* net_namespace: 64 bytes
* Booting paravirtualized kernel on bare hardware
* Time: 23:43:18  Date: 06/20/09
* NET: Registered protocol family 16
* EISA bus registered
* ACPI: bus type pci registered
* PCI: PCI BIOS revision 3.00 entry at 0xfb9e0, last bus=6
* PCI: Using configuration type 1
* Setting up standard PCI resources
* ACPI: EC: Look up EC in DSDT
* ACPI: Interpreter enabled
* ACPI: (supports S0 S3 S4 S5)
* ACPI: Using IOAPIC for interrupt routing
* ACPI: PCI Root Bridge [PCI0] (0000:00)
* PCI: Transparent bridge - 0000:00:1e.0
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
* ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
* ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
* ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
* ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
* ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
* ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
* ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
* ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
* ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
* Linux Plug and Play Support v0.97 (c) Adam Belay
* pnp: PnP ACPI init
* ACPI: bus type pnp registered
* pnpacpi: exceeded the max number of mem resources: 12
* pnp: PnP ACPI: found 14 devices
* ACPI: ACPI bus type pnp unregistered
* PnPBIOS: Disabled by ACPI PNP
* PCI: Using ACPI for IRQ routing
* PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
* NET: Registered protocol family 8
* NET: Registered protocol family 20
* NetLabel: Initializing
* NetLabel:  domain hash size = 128
* NetLabel:  protocols = UNLABELED CIPSOv4
* NetLabel:  unlabeled traffic allowed by default
* hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
* hpet0: 4 64-bit timers, 14318180 Hz
* AppArmor: AppArmor Filesystem Enabled
* Time: tsc clocksource has been installed.
* Switched to high resolution mode on CPU 0
* Switched to high resolution mode on CPU 3
* Switched to high resolution mode on CPU 1
* Switched to high resolution mode on CPU 2
* system 00:01: ioport range 0x4d0-0x4d1 has been reserved
* system 00:01: ioport range 0x290-0x29f has been reserved
* system 00:01: ioport range 0x800-0x805 has been reserved
* system 00:01: ioport range 0x290-0x294 has been reserved
* system 00:01: ioport range 0x880-0x88f has been reserved
* system 00:0a: ioport range 0x400-0x4cf has been reserved
* system 00:0a: ioport range 0x4d2-0x4ff has been reserved
* system 00:0b: iomem range 0xe0000000-0xe3ffffff could not be reserved
* system 00:0c: iomem range 0xd5000-0xd7fff has been reserved
* system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
* system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
* system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
* system 00:0c: iomem range 0xcfeb0000-0xcfefffff could not be reserved
* system 00:0c: iomem range 0x0-0x9ffff could not be reserved
* system 00:0c: iomem range 0x100000-0xcfeaffff could not be reserved
* system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
* system 00:0c: iomem range 0xfed10000-0xfed1dfff could not be reserved
* system 00:0c: iomem range 0xfed20000-0xfed8ffff could not be reserved
* system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
* system 00:0c: iomem range 0xffb00000-0xffb7ffff could not be reserved
* PCI: Bridge: 0000:00:01.0
*   IO window: 9000-9fff
*   MEM window: e4000000-e7ffffff
*   PREFETCH window: d0000000-dfffffff
* PCI: Bridge: 0000:00:1c.0
*   IO window: disabled.
*   MEM window: disabled.
*   PREFETCH window: disabled.
* PCI: Bridge: 0000:00:1c.3
*   IO window: a000-afff
*   MEM window: ea100000-ea1fffff
*   PREFETCH window: disabled.
* PCI: Bridge: 0000:00:1c.4
*   IO window: b000-bfff
*   MEM window: e8000000-e8ffffff
*   PREFETCH window: ea000000-ea0fffff
* PCI: Bridge: 0000:00:1c.5
*   IO window: c000-cfff
*   MEM window: e9000000-e9ffffff
*   PREFETCH window: ea200000-ea2fffff
* PCI: Bridge: 0000:00:1e.0
*   IO window: d000-dfff
*   MEM window: ea300000-ea3fffff
*   PREFETCH window: disabled.
* ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:00:01.0 to 64
* ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:00:1c.0 to 64
* ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
* PCI: Setting latency timer of device 0000:00:1c.3 to 64
* ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:00:1c.4 to 64
* ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 18
* PCI: Setting latency timer of device 0000:00:1c.5 to 64
* PCI: Setting latency timer of device 0000:00:1e.0 to 64
* NET: Registered protocol family 2
* IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
* TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
* TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
* TCP: Hash tables configured (established 131072 bind 65536)
* TCP reno registered
* checking if image is initramfs... it is
* Freeing initrd memory: 7342k freed
* audit: initializing netlink socket (disabled)
* audit(1245541398.743:1): initialized
* highmem bounce pool size: 64 pages
* Total HugeTLB memory allocated, 0
* VFS: Disk quotas dquot_6.5.1
* Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
* io scheduler noop registered
* io scheduler anticipatory registered
* io scheduler deadline registered (default)
* io scheduler cfq registered
* Boot video device is 0000:01:00.0
* PCI: Setting latency timer of device 0000:00:01.0 to 64
* assign_interrupt_mode Found MSI capability
* Allocate Port Service[0000:00:01.0:pcie00]
* PCI: Setting latency timer of device 0000:00:1c.0 to 64
* assign_interrupt_mode Found MSI capability
* Allocate Port Service[0000:00:1c.0:pcie00]
* Allocate Port Service[0000:00:1c.0:pcie02]
* PCI: Setting latency timer of device 0000:00:1c.3 to 64
* assign_interrupt_mode Found MSI capability
* Allocate Port Service[0000:00:1c.3:pcie00]
* Allocate Port Service[0000:00:1c.3:pcie02]
* PCI: Setting latency timer of device 0000:00:1c.4 to 64
* assign_interrupt_mode Found MSI capability
* Allocate Port Service[0000:00:1c.4:pcie00]
* Allocate Port Service[0000:00:1c.4:pcie02]
* PCI: Setting latency timer of device 0000:00:1c.5 to 64
* assign_interrupt_mode Found MSI capability
* Allocate Port Service[0000:00:1c.5:pcie00]
* Allocate Port Service[0000:00:1c.5:pcie02]
* isapnp: Scanning for PnP cards...
* isapnp: No Plug & Play device found
* Real Time Clock Driver v1.12ac
* hpet_resources: 0xfed00000 is busy
* Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
* RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
* input: Macintosh mouse button emulation as /devices/virtual/input/input0
* PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
* serio: i8042 KBD port at 0x60,0x64 irq 1
* serio: i8042 AUX port at 0x60,0x64 irq 12
* mice: PS/2 mouse device common for all mice
* EISA: Probing bus 0 at eisa.0
* EISA: Detected 0 cards.
* cpuidle: using governor ladder
* cpuidle: using governor menu
* NET: Registered protocol family 1
* Using IPI No-Shortcut mode
* registered taskstats version 1
*   Magic number: 13:627:757
* BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
* Freeing unused kernel memory: 384k freed
* Write protecting the kernel read-only data: 828k
* input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
* vesafb: framebuffer at 0xe5000000, mapped to 0xf8880000, using 14336k, total 14336k
* vesafb: mode is 1600x1200x32, linelength=6400, pages=1
* vesafb: protected mode interface info at c000:c360
* vesafb: pmi: set display start = c00cc3c3, set palette = c00cc41e
* vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf 3d0 3d1 3d2 3d3 3d4 3d5 3da 
* vesafb: scrolling: redraw
* vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
* Console: switching to colour frame buffer device 200x75
* fb0: VESA VGA frame buffer device
* fuse init (API version 7.9)
* ACPI: SSDT CFEE7F10, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
* ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
* ACPI: Processor [CPU0] (supports 8 throttling states)
* ACPI: SSDT CFEE83D0, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
* ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
* ACPI: Processor [CPU1] (supports 8 throttling states)
* ACPI: SSDT CFEE8530, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20040311)
* ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
* ACPI: Processor [CPU2] (supports 8 throttling states)
* ACPI: SSDT CFEE8690, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20040311)
* ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
* ACPI: Processor [CPU3] (supports 8 throttling states)
* usbcore: registered new interface driver usbfs
* usbcore: registered new interface driver hub
* usbcore: registered new device driver usb
* USB Universal Host Controller Interface driver v3.0
* ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:00:1a.0 to 64
* uhci_hcd 0000:00:1a.0: UHCI Host Controller
* uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
* uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e500
* usb usb1: configuration #1 chosen from 1 choice
* hub 1-0:1.0: USB hub found
* hub 1-0:1.0: 2 ports detected
* SCSI subsystem initialized
* libata version 3.00 loaded.
* ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 19
* PCI: Setting latency timer of device 0000:00:1a.1 to 64
* uhci_hcd 0000:00:1a.1: UHCI Host Controller
* uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
* uhci_hcd 0000:00:1a.1: irq 19, io base 0x0000e000
* usb usb2: configuration #1 chosen from 1 choice
* hub 2-0:1.0: USB hub found
* hub 2-0:1.0: 2 ports detected
* ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 20
* PCI: Setting latency timer of device 0000:00:1a.2 to 64
* uhci_hcd 0000:00:1a.2: UHCI Host Controller
* uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
* uhci_hcd 0000:00:1a.2: irq 20, io base 0x0000e100
* usb usb3: configuration #1 chosen from 1 choice
* hub 3-0:1.0: USB hub found
* hub 3-0:1.0: 2 ports detected
* ahci 0000:00:1f.2: version 3.0
* ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 17
* usb 2-1: new full speed USB device using uhci_hcd and address 2
* usb 2-1: configuration #1 chosen from 1 choice
* ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
* ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part 
* PCI: Setting latency timer of device 0000:00:1f.2 to 64
* scsi0 : ahci
* scsi1 : ahci
* scsi2 : ahci
* scsi3 : ahci
* scsi4 : ahci
* scsi5 : ahci
* ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
* ata2: SATA max UDMA/133 irq_stat 0x00400040, connection status changed
* ata3: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406200 irq 218
* ata4: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406280 irq 218
* ata5: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406300 irq 218
* ata6: SATA max UDMA/133 abar m2048@0xea406000 port 0xea406380 irq 218
* ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
* ata1.00: ATA-8: ST3640323AS, SD35, max UDMA/133
* ata1.00: 1250263728 sectors, multi 0: LBA48 NCQ (depth 31/32)
* ata1.00: configured for UDMA/133
* ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
* ata2.00: ATA-8: WDC WD1001FALS-00J7B1, 05.00K05, max UDMA/133
* ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
* ata2.00: configured for UDMA/133
* ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
* ata3.00: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
* ata3.00: configured for UDMA/100
* ata4: SATA link down (SStatus 0 SControl 300)
* ata5: SATA link down (SStatus 0 SControl 300)
* ata6: SATA link down (SStatus 0 SControl 300)
* scsi 0:0:0:0: Direct-Access     ATA      ST3640323AS      SD35 PQ: 0 ANSI: 5
* scsi 1:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
* scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 PQ: 0 ANSI: 5
* ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 17
* ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
* ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
* PCI: Setting latency timer of device 0000:03:00.0 to 64
* scsi6 : ahci
* scsi7 : ahci
* ata7: SATA max UDMA/133 abar m8192@0xea100000 port 0xea100100 irq 17
* ata8: SATA max UDMA/133 abar m8192@0xea100000 port 0xea100180 irq 17
* ata7: SATA link down (SStatus 0 SControl 300)
* ata8: SATA link down (SStatus 0 SControl 300)
* ACPI: PCI Interrupt 0000:06:07.0[A] -> ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 20
* PCI: Setting latency timer of device 0000:00:1a.7 to 64
* ehci_hcd 0000:00:1a.7: EHCI Host Controller
* ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 4
* PCI: cache line size of 32 is not supported by device 0000:00:1a.7
* ehci_hcd 0000:00:1a.7: irq 20, io mem 0xea405000
* ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
* usb usb4: configuration #1 chosen from 1 choice
* hub 4-0:1.0: USB hub found
* hub 4-0:1.0: 6 ports detected
* GSI 23 (level, low) -> IRQ 21
* ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[ea344000-ea3447ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
* Driver 'sd' needs updating - please use bus_type methods
* ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
* PCI: Setting latency timer of device 0000:00:1d.7 to 64
* ehci_hcd 0000:00:1d.7: EHCI Host Controller
* ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
* PCI: cache line size of 32 is not supported by device 0000:00:1d.7
* ehci_hcd 0000:00:1d.7: irq 21, io mem 0xea404000
* ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
* usb usb5: configuration #1 chosen from 1 choice
* hub 5-0:1.0: USB hub found
* hub 5-0:1.0: 6 ports detected
* sd 0:0:0:0: [sda] 1250263728 512-byte hardware sectors (640135 MB)
* sd 0:0:0:0: [sda] Write Protect is off
* sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
* sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
* ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
* ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:00:1d.0 to 64
* uhci_hcd 0000:00:1d.0: UHCI Host Controller
* uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
* PCI: Setting latency timer of device 0000:03:00.1 to 64
* ACPI: PCI interrupt for device 0000:03:00.1 disabled
* uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000e200
* usb usb6: configuration #1 chosen from 1 choice
* hub 6-0:1.0: USB hub found
* hub 6-0:1.0: 2 ports detected
* sd 0:0:0:0: [sda] 1250263728 512-byte hardware sectors (640135 MB)
* sd 0:0:0:0: [sda] Write Protect is off
* Driver 'sr' needs updating - please use bus_type methods
* ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
* PCI: Setting latency timer of device 0000:00:1d.1 to 64
* uhci_hcd 0000:00:1d.1: UHCI Host Controller
* uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
* uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e300
* usb usb7: configuration #1 chosen from 1 choice
* hub 7-0:1.0: USB hub found
* hub 7-0:1.0: 2 ports detected
* sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
* usb 4-3: new high speed USB device using ehci_hcd and address 2
* sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
*  sda:ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
*  sda1PCI: Setting latency timer of device 0000:00:1d.2 to 64
* uhci_hcd 0000:00:1d.2: UHCI Host Controller
* uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
* uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000e400
* usb usb8: configuration #1 chosen from 1 choice
* hub 8-0:1.0: USB hub found
* hub 8-0:1.0: 2 ports detected
*  sda2 <r8169 Gigabit Ethernet driver 2.2LK loaded
* ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
*  sda5>
* PCI: Setting latency timer of device 0000:04:00.0 to 64
* sd 0:0:0:0: [sda] Attached SCSI disk
* eth0: RTL8168c/8111c at 0xf8836000, 00:1f:d0:d5:14:97, XID 3c4000c0 IRQ 217
* r8169 Gigabit Ethernet driver 2.2LK loaded
* ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 17 (level, low) -> IRQ 18
* PCI: Setting latency timer of device 0000:05:00.0 to 64
* eth1: RTL8168c/8111c at 0xf9708000, 00:1f:d0:81:2d:a3, XID 3c4000c0 IRQ 216
* ACPI: PCI Interrupt 0000:03:00.1[B] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:03:00.1 to 64
* scsi8 : pata_jmicron
* scsi9 : pata_jmicron
* ata9: PATA max UDMA/100 cmd 0xa000 ctl 0xa100 bmdma 0xa400 irq 16
* ata10: PATA max UDMA/100 cmd 0xa200 ctl 0xa300 bmdma 0xa408 irq 16
* sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
* usb 4-3: configuration #1 chosen from 1 choice
* sd 1:0:0:0: [sdb] Write Protect is off
* sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
* sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
* sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
* sd 1:0:0:0: [sdb] Write Protect is off
* sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
* sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
*  sdb: sdb1
* sd 1:0:0:0: [sdb] Attached SCSI disk
* usb 2-1: USB disconnect, address 2
* sr0: scsi3-mmc drive: 40x/48x writer dvd-ram cd/rw xa/form2 cdda tray
* Uniform CD-ROM driver Revision: 3.20
* sr 2:0:0:0: Attached scsi CD-ROM sr0
* sd 0:0:0:0: Attached scsi generic sg0 type 0
* sd 1:0:0:0: Attached scsi generic sg1 type 0
* sr 2:0:0:0: Attached scsi generic sg2 type 5
* ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00ee5c5400001fd0]
* Attempting manual resume
* swsusp: Resume From Partition 8:5
* PM: Checking swsusp image.
* PM: Resume from disk failed.
* kjournald starting.  Commit interval 5 seconds
* EXT3-fs: mounted filesystem with ordered data mode.
* input: PC Speaker as /devices/platform/pcspkr/input/input2
* pci_hotplug: PCI Hot Plug PCI Core version: 0.5
* input: Power Button (FF) as /devices/virtual/input/input3
* shpchp: Unknown symbol acpi_run_oshp
* shpchp: Unknown symbol pci_hp_change_slot_info
* shpchp: Unknown symbol pci_hp_register
* shpchp: Unknown symbol pci_hp_deregister
* shpchp: Unknown symbol acpi_get_hp_params_from_firmware
* shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
* r8169: eth0: link up
* r8169: eth0: link up
* r8169: eth1: link up
* r8169: eth1: link up
* Linux agpgart interface v0.102
* ACPI: Power Button (FF) [PWRF]
* input: Power Button (CM) as /devices/virtual/input/input4
* ACPI: Power Button (CM) [PWRB]
* input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input5
* parport_pc 00:07: reported by Plug and Play ACPI
* parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
* nvidia: module license 'NVIDIA' taints kernel.
* ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
* PCI: Setting latency timer of device 0000:01:00.0 to 64
* NVRM: loading NVIDIA UNIX x86 Kernel Module  185.18.14  Wed May 27 02:23:13 PDT 2009
* Linux video capture interface: v2.00
* NET: Registered protocol family 10
* lo: Disabled Privacy Extensions
* ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 19 (level, low) -> IRQ 17
* parport1: PC-style at 0xd400 [PCSPP,TRISTATE,EPP]
* 0000:06:01.0: ttyS0 at I/O 0xd200 (irq = 17) is a 16550A
* 0000:06:01.0: ttyS1 at I/O 0xd300 (irq = 17) is a 16550A
* em28xx: New device Pinnacle Systems PCTV 800e @ 480 Mbps (2304:0227, interface 0, class 0)
* em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
* em28xx #0: chip ID is em2882/em2883
* ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
* PCI: Setting latency timer of device 0000:00:1b.0 to 64
* em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12 5c 03 8e 16 a4 1c
* em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
* em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
* em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
* em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
* em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
* em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 38 00 30 00 30 00
* em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00 31 00 30 00 30 00
* em28xx #0: i2c eeprom b0: 31 00 30 00 33 00 39 00 34 00 34 00 32 00 00 00
* em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
* em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x2de5abbf
* em28xx #0: EEPROM info:
* em28xx #0:    AC97 audio (5 sample rates)
* em28xx #0:    500mA max power
* em28xx #0:    Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
* hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
* input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb4/4-3/input/input6
* ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 20 (level, low) -> IRQ 23
* Vortex: init.... em28xx #0: Config register raw data: 0xd0
* em28xx #0: AC97 vendor ID = 0xffffffff
* em28xx #0: AC97 features = 0x6a90
* em28xx #0: Empia 202 AC97 audio processor detected
* em28xx #0: v4l2 driver version 0.1.2
* em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
* usbcore: registered new interface driver em28xx
* em28xx driver loaded
* xc2028 0-0061: creating new instance
* xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
* em28xx #0/2: xc3028 attached
* DVB: registering new adapter (em28xx #0)
* DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
* Successfully loaded em28xx-dvb
* Em28xx: Initialized (Em28xx dvb Extension) extension
* done.
* gameport: AU88x0 Gameport is pci0000:06:00.0/gameport0, speed 596kHz
* loop: module loaded
* lp0: using parport0 (interrupt-driven).
* lp1: using parport1 (polling).
* it87: Found IT8718F chip at 0x290, revision 5
* it87: in3 is VCC (+5V)
* Adding 9863868k swap on /dev/sda5.  Priority:-1 extents:1 across:9863868k
* EXT3 FS on sda1, internal journal
* kjournald starting.  Commit interval 5 seconds
* EXT3 FS on sdb1, internal journal
* EXT3-fs: mounted filesystem with ordered data mode.
* ip_tables: (C) 2000-2006 Netfilter Core Team
* nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

_________________________________________________________________
Lauren found her dream laptop. Find the PC that’s right for you.
http://www.microsoft.com/windows/choosepc/?ocid=ftp_val_wl_290