Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ozlabs.org ([203.10.76.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <grog@lemis.com>) id 1LCkGV-0004Qt-5m
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 01:28:02 +0100
Received: from dereel.lemis.com (ozlabs.org [203.10.76.45])
	by ozlabs.org (Postfix) with ESMTP id D2D8FDDF4A
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 11:27:38 +1100 (EST)
Date: Wed, 17 Dec 2008 11:27:35 +1100
From: Greg 'groggy' Lehey <grog@lemis.com>
To: linux-dvb@linuxtv.org
Message-ID: <20081217002735.GF45924@dereel.lemis.com>
Mime-Version: 1.0
Subject: [linux-dvb] Support for Afatech 9035 (Aldi Fission USB tuner)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0335390375=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0335390375==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MrRUTeZlqqNo1jQ9"
Content-Disposition: inline


--MrRUTeZlqqNo1jQ9
Content-Type: multipart/mixed; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have a dual USB tuner from Aldi, which they call a Fission dual high
definition DVB-T receiver.  There's almost no identification on it,
but I've put some photos at
http://www.lemis.com/grog/photos/Photos.php?size=tiny&dirdate=20081217
in case somebody recognizes the form.  The lsusb output identifies it
as an Afa Technologies Inc. AF9035A USB Device, but the supplied
(Microsoft-only) software often refers to it as a 9015.  I'm attaching
lsusb output.

My first questions: is anybody working on this or a similar device?
Can I help?  Is there any hope of getting it to work with a reasonable
amount of effort?

More details:

I'm using Ubuntu 8.10 on i386 with the latest v4l Hg sources, and I
can't get it recognized.   dmesg output (complete version is attached)
says:

[  789.696018] usb 4-3: new high speed USB device using ehci_hcd and address 2
[  789.846003] usb 4-3: configuration #1 chosen from 1 choice
[  790.052259] usbcore: registered new interface driver hiddev
[  790.056703] input: Afa Technologies Inc. AF9035A USB Device as /devices/pci0000:00/0000:00:10.3/usb4/4-3/4-3:1.1/input/input8
[  790.057902] input,hidraw0: USB HID v1.01 Keyboard [Afa Technologies Inc. AF9035A USB Device] on usb-0000:00:10.3-3
[  790.058287] usbcore: registered new interface driver usbhid
[  790.058511] usbhid: v2.6:USB HID core driver

I've been following the instructions on the wiki, and I've got hold of
the firmware files dvb-usb-af9015.fw and xc3028-v27.fw.  The former
doesn't get loaded; the latter gets loaded even if the stick isn't
present:

[   15.559113] firmware: requesting xc3028-v27.fw
[   18.046874] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   18.060053] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   26.604094] xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.
[   37.240018] xc2028 1-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
[   45.560019] xc2028 1-0061: Loading firmware for type=FM (400), id 0000000000000000.
[   45.928030] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   54.456030] xc2028 1-0061: Loading firmware for type=(0), id 0000000100000007.

How does that happen?  I've checked configuration files and things,
but I can't see any mechanism for autoloading on boot.  What makes it
load automatically?  Should I be using the same method to load the
dvb-usb-af9015.fw firmware too?  I've put it in /lib/firmware, but
nothing exciting happens.

Looking at v4l/af9015.c, it seems that I need to match the ID string
to one of the entries in the af9015_properties structure.  I did that
(copying the details for another device), but it didn't make any
difference: it's still just recognized as a HID device.

Where do I go from here?  If somebody's prepared to give me a bit of
guidance, I'd like to get the thing working.  Here in Australia
they're very cheap ($79 for a dual tuner), and the results under
Microsoft don't look bad.  My main questions are: how do I go about
the problem most effectively?

Greg
--
Finger grog@Freebsd.org for PGP public key.
See complete headers for address and phone numbers.

--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lsusb
Content-Transfer-Encoding: quoted-printable

Bus 001 Device 003: ID 15a4:1001 =20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x15a4=20
  idProduct          0x1001=20
  bcdDevice            2.00
  iManufacturer           1 Afa Technologies Inc.
  iProduct                2 AF9035A USB Device
  iSerial                 3 AF0103250800001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          122
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0=20
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           5
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0=20
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0=20
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               1.01
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 Report
          wDescriptorLength      65
         Report Descriptors:=20
           ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              10
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.27-9-generic (buildd@rothera) (gcc version=
 4.3.2 (Ubuntu 4.3.2-1ubuntu11) ) #1 SMP Thu Nov 20 21:57:00 UTC 2008 (Ubun=
tu 2.6.27-9.19-generic)
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
[    0.000000] last_pfn =3D 0x3fff0 max_arch_pfn =3D 0x100000
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] RAMDISK: 03936000 - 040fe3ff
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FA940, 0014 (r0 AMI   )
[    0.000000] ACPI: RSDT 3FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT =
      97)
[    0.000000] ACPI: FACP 3FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT =
      97)
[    0.000000] ACPI: DSDT 3FFF0120, 32BF (r1    VIA   VIA_K7     1000 MSFT =
 100000D)
[    0.000000] ACPI: FACS 3FFF8000, 0040
[    0.000000] ACPI: APIC 3FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT =
      97)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00008000 - 0000f000
[    0.000000] (9 early reservations) =3D=3D> bootmem [0000000000 - 0038000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [000=
0001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005c0a20]    TEXT DATA BSS =3D=3D> [000=
0100000 - 00005c0a20]
[    0.000000]   #4 [0003936000 - 00040fe3ff]          RAMDISK =3D=3D> [000=
3936000 - 00040fe3ff]
[    0.000000]   #5 [00005c1000 - 00005c4000]    INIT_PG_TABLE =3D=3D> [000=
05c1000 - 00005c4000]
[    0.000000]   #6 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00 - 0000100000]
[    0.000000]   #7 [0000007000 - 0000008000]          PGTABLE =3D=3D> [000=
0007000 - 0000008000]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP =3D=3D> [000=
0008000 - 000000f000]
[    0.000000] found SMP MP-table at [c00fb930] 000fb930
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262031
[    0.000000] free_area_init_node: node 0, pgdat c048a580, node_mem_map c1=
000000
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 223300 pages, LIFO batch:31
[    0.000000]   HighMem zone: 32464 pages, LIFO batch:7
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
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000=
:bec00000)
[    0.000000] PERCPU: Allocating 41628 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 1, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 259727
[    0.000000] Kernel command line: auto BOOT_IMAGE=3DLinux ro root=3D/dev/=
sda1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PMTIMER calibration value
[    0.000000] Detected 1837.495 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.004000] Memory: 1024740k/1048512k available (2572k kernel code, 2294=
8k reserved, 1160k data, 424k init, 131008k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xffc77000 - 0xfffff000   (3616 kB)
[    0.004000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc04ab000 - 0xc0515000   ( 424 kB)
[    0.004000]       .data : 0xc038335a - 0xc04a5680   (1160 kB)
[    0.004000]       .text : 0xc0100000 - 0xc038335a   (2572 kB)
[    0.004000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.004018] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 3674.99 BogoMIPS (lpj=3D7349980)
[    0.004170] Security Framework initialized
[    0.004241] SELinux:  Disabled at boot.
[    0.004339] AppArmor: AppArmor initialized
[    0.004410] Mount-cache hash table entries: 512
[    0.004715] Initializing cgroup subsys ns
[    0.004780] Initializing cgroup subsys cpuacct
[    0.004842] Initializing cgroup subsys memory
[    0.004922] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.004988] CPU: L2 Cache: 512K (64 bytes/line)
[    0.005069] Checking 'hlt' instruction... OK.
[    0.020455] SMP alternatives: switching to UP code
[    0.026611] Freeing SMP alternatives: 11k freed
[    0.026676] ACPI: Core revision 20080609
[    0.028536] ACPI: Checking initramfs for custom DSDT
[    0.390184] ENABLING IO-APIC IRQs
[    0.390558] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.430315] CPU0: AMD Athlon(tm) XP 2500+ stepping 00
[    0.432027] Brought up 1 CPUs
[    0.432027] Total of 1 processors activated (3674.99 BogoMIPS).
[    0.432027] CPU0 attaching sched-domain:
[    0.432027]  domain 0: span 0 level CPU
[    0.432027]   groups: 0
[    0.432027] net_namespace: 840 bytes
[    0.432027] Booting paravirtualized kernel on bare hardware
[    0.432027] Time: 23:50:24  Date: 12/16/08
[    0.432027] NET: Registered protocol family 16
[    0.432027] EISA bus registered
[    0.432027] ACPI: bus type pci registered
[    0.433930] PCI: PCI BIOS revision 2.10 entry at 0xfdaf1, last bus=3D1
[    0.433996] PCI: Using configuration type 1 for base access
[    0.435956] ACPI: EC: Look up EC in DSDT
[    0.443284] ACPI: Interpreter enabled
[    0.443348] ACPI: (supports S0 S1 S4 S5)
[    0.443586] ACPI: Using IOAPIC for interrupt routing
[    0.450191] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.450355] PCI: 0000:00:00.0 reg 10 32bit mmio: [e0000000, e7ffffff]
[    0.450421] pci 0000:00:01.0: supports D1
[    0.450453] PCI: 0000:00:06.0 reg 10 32bit mmio: [dffff800, dfffffff]
[    0.450488] pci 0000:00:06.0: supports D1
[    0.450490] pci 0000:00:06.0: supports D2
[    0.450519] PCI: 0000:00:07.0 reg 10 32bit mmio: [dd000000, ddffffff]
[    0.450576] PCI: 0000:00:07.2 reg 10 32bit mmio: [de000000, deffffff]
[    0.450659] PCI: 0000:00:10.0 reg 20 io port: [e400, e41f]
[    0.450678] pci 0000:00:10.0: supports D1
[    0.450680] pci 0000:00:10.0: supports D2
[    0.450683] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.450751] pci 0000:00:10.0: PME# disabled
[    0.450848] PCI: 0000:00:10.1 reg 20 io port: [e800, e81f]
[    0.450868] pci 0000:00:10.1: supports D1
[    0.450870] pci 0000:00:10.1: supports D2
[    0.450873] pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.450939] pci 0000:00:10.1: PME# disabled
[    0.451036] PCI: 0000:00:10.2 reg 20 io port: [ec00, ec1f]
[    0.451056] pci 0000:00:10.2: supports D1
[    0.451058] pci 0000:00:10.2: supports D2
[    0.451060] pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.451127] pci 0000:00:10.2: PME# disabled
[    0.451209] PCI: 0000:00:10.3 reg 10 32bit mmio: [dffff700, dffff7ff]
[    0.451243] pci 0000:00:10.3: supports D1
[    0.451246] pci 0000:00:10.3: supports D2
[    0.451248] pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.451315] pci 0000:00:10.3: PME# disabled
[    0.451431] HPET not enabled in BIOS. You might try hpet=3Dforce boot op=
tion
[    0.451501] pci 0000:00:11.0: quirk: region 0800-087f claimed by vt8235 =
PM
[    0.451568] pci 0000:00:11.0: quirk: region 0400-040f claimed by vt8235 =
SMB
[    0.451677] PCI: 0000:00:11.1 reg 20 io port: [fc00, fc0f]
[    0.451725] PCI: 0000:00:11.5 reg 10 io port: [e000, e0ff]
[    0.451762] pci 0000:00:11.5: supports D1
[    0.451764] pci 0000:00:11.5: supports D2
[    0.451790] PCI: 0000:00:12.0 reg 10 io port: [dc00, dcff]
[    0.451797] PCI: 0000:00:12.0 reg 14 32bit mmio: [dffff600, dffff6ff]
[    0.451829] pci 0000:00:12.0: supports D1
[    0.451831] pci 0000:00:12.0: supports D2
[    0.451833] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.451900] pci 0000:00:12.0: PME# disabled
[    0.452001] PCI: 0000:01:00.0 reg 10 32bit mmio: [da000000, daffffff]
[    0.452007] PCI: 0000:01:00.0 reg 14 32bit mmio: [d0000000, d7ffffff]
[    0.452024] PCI: 0000:01:00.0 reg 30 32bit mmio: [dbee0000, dbefffff]
[    0.452069] PCI: bridge 0000:00:01.0 32bit mmio: [d9e00000, dbefffff]
[    0.452075] PCI: bridge 0000:00:01.0 32bit mmio pref: [c9d00000, d9cffff=
f]
[    0.452082] bus 00 -> node 0
[    0.452091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.455188] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14=
 15)
[    0.455897] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14=
 15)
[    0.456609] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14=
 15)
[    0.457314] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 *6 7 10 11 12 14=
 15)
[    0.458020] ACPI: Power Resource [URP1] (off)
[    0.458129] ACPI: Power Resource [URP2] (off)
[    0.458236] ACPI: Power Resource [FDDP] (off)
[    0.458342] ACPI: Power Resource [LPTP] (off)
[    0.458511] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.458626] pnp: PnP ACPI init
[    0.458694] ACPI: bus type pnp registered
[    0.463394] pnp: PnP ACPI: found 12 devices
[    0.463456] ACPI: ACPI bus type pnp unregistered
[    0.463520] PnPBIOS: Disabled by ACPI PNP
[    0.464239] PCI: Using ACPI for IRQ routing
[    0.464438] NET: Registered protocol family 8
[    0.464438] NET: Registered protocol family 20
[    0.464438] NetLabel: Initializing
[    0.464438] NetLabel:  domain hash size =3D 128
[    0.464438] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.464438] NetLabel:  unlabeled traffic allowed by default
[    0.464818] tracer: 772 pages allocated for 65536 entries of 48 bytes
[    0.464883]    actual entries 65620
[    0.465212] AppArmor: AppArmor Filesystem Enabled
[    0.465290] ACPI: RTC can wake from S4
[    0.465359] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.465359] system 00:01: ioport range 0x3f0-0x3f1 has been reserved
[    0.465359] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.465359] system 00:01: ioport range 0x400-0x40f has been reserved
[    0.465359] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.465359] system 00:01: iomem range 0xfee00000-0xfee00fff could not be=
 reserved
[    0.501503] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.501567] pci 0000:00:01.0:   IO window: disabled
[    0.501633] pci 0000:00:01.0:   MEM window: 0xd9e00000-0xdbefffff
[    0.501699] pci 0000:00:01.0:   PREFETCH window: 0x000000c9d00000-0x0000=
00d9cfffff
[    0.501792] pci 0000:00:01.0: setting latency timer to 64
[    0.501797] bus: 00 index 0 io port: [0, ffff]
[    0.501858] bus: 00 index 1 mmio: [0, ffffffff]
[    0.501920] bus: 01 index 0 mmio: [0, 0]
[    0.501980] bus: 01 index 1 mmio: [d9e00000, dbefffff]
[    0.502042] bus: 01 index 2 mmio: [c9d00000, d9cfffff]
[    0.502105] bus: 01 index 3 mmio: [0, 0]
[    0.502176] NET: Registered protocol family 2
[    0.502396] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    0.502944] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.504958] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.506022] TCP: Hash tables configured (established 131072 bind 65536)
[    0.506968] TCP reno registered
[    0.507205] NET: Registered protocol family 1
[    0.507435] checking if image is initramfs... it is
[    1.004080] Switched to high resolution mode on CPU 0
[    1.299823] Freeing initrd memory: 7968k freed
[    1.301095] audit: initializing netlink socket (disabled)
[    1.301182] type=3D2000 audit(1229471424.300:1): initialized
[    1.307662] highmem bounce pool size: 64 pages
[    1.307732] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.311114] VFS: Disk quotas dquot_6.5.1
[    1.311304] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.311519] msgmni has been set to 1762
[    1.311750] io scheduler noop registered
[    1.311812] io scheduler anticipatory registered
[    1.311873] io scheduler deadline registered
[    1.311946] io scheduler cfq registered (default)
[    1.312069] PCI: VIA PCI bridge detected.Disabling DAC.
[    1.312215] pci 0000:01:00.0: Boot video device
[    1.313049] isapnp: Scanning for PnP cards...
[    1.666710] isapnp: No Plug & Play device found
[    1.723868] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.724123] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.724371] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.725314] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.725779] 00:0a: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.728497] brd: module loaded
[    1.728663] input: Macintosh mouse button emulation as /devices/virtual/=
input/input0
[    1.728918] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x6=
4 irq 1,12
[    1.729427] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.729495] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.730322] mice: PS/2 mouse device common for all mice
[    1.730596] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.730692] rtc0: alarms up to one year, y3k
[    1.730928] EISA: Probing bus 0 at eisa.0
[    1.731028] EISA: Detected 0 cards.
[    1.731091] cpuidle: using governor ladder
[    1.731152] cpuidle: using governor menu
[    1.731876] TCP cubic registered
[    1.731972] Using IPI No-Shortcut mode
[    1.732333] registered taskstats version 1
[    1.732517]   Magic number: 4:468:858
[    1.732743] tty ptysd: hash matches
[    1.732910] rtc_cmos 00:03: setting system clock to 2008-12-16 23:50:25 =
UTC (1229471425)
[    1.732991] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.733054] EDD information not available.
[    1.733742] Freeing unused kernel memory: 424k freed
[    1.733869] Write protecting the kernel text: 2576k
[    1.733970] Write protecting the kernel read-only data: 936k
[    1.762048] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.870174] fuse init (API version 7.9)
[    1.903838] processor ACPI0007:00: registered as cooling_device0
[    2.552590] usbcore: registered new interface driver usbfs
[    2.552695] usbcore: registered new interface driver hub
[    2.552834] usbcore: registered new device driver usb
[    2.555582] USB Universal Host Controller Interface driver v3.0
[    2.559267] uhci_hcd 0000:00:10.0: PCI INT A -> GSI 21 (level, low) -> I=
RQ 21
[    2.559351] uhci_hcd 0000:00:10.0: UHCI Host Controller
[    2.559485] uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus =
number 1
[    2.559603] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e400
[    2.559924] usb usb1: configuration #1 chosen from 1 choice
[    2.560038] hub 1-0:1.0: USB hub found
[    2.560111] hub 1-0:1.0: 2 ports detected
[    2.605646] No dock devices found.
[    2.679261] SCSI subsystem initialized
[    2.682633] via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
[    2.732654] libata version 3.00 loaded.
[    2.768456] uhci_hcd 0000:00:10.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    2.768541] uhci_hcd 0000:00:10.1: UHCI Host Controller
[    2.768634] uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus =
number 2
[    2.768740] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e800
[    2.768938] usb usb2: configuration #1 chosen from 1 choice
[    2.769034] hub 2-0:1.0: USB hub found
[    2.769105] hub 2-0:1.0: 2 ports detected
[    2.976420] uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> I=
RQ 21
[    2.976504] uhci_hcd 0000:00:10.2: UHCI Host Controller
[    2.976605] uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus =
number 3
[    2.976709] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000ec00
[    2.976910] usb usb3: configuration #1 chosen from 1 choice
[    2.977014] hub 3-0:1.0: USB hub found
[    2.977086] hub 3-0:1.0: 2 ports detected
[    3.184499] ehci_hcd 0000:00:10.3: PCI INT D -> GSI 21 (level, low) -> I=
RQ 21
[    3.184592] ehci_hcd 0000:00:10.3: EHCI Host Controller
[    3.184687] ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus =
number 4
[    3.184819] ehci_hcd 0000:00:10.3: irq 21, io mem 0xdffff700
[    3.196044] ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    3.196399] usb usb4: configuration #1 chosen from 1 choice
[    3.196501] hub 4-0:1.0: USB hub found
[    3.196574] hub 4-0:1.0: 6 ports detected
[    3.300493] via-rhine 0000:00:12.0: PCI INT A -> GSI 23 (level, low) -> =
IRQ 23
[    3.304853] eth0: VIA Rhine II at 0xdffff600, 00:0c:76:96:49:98, IRQ 23.
[    3.305625] eth0: MII PHY found at address 1, status 0x786d advertising =
05e1 Link 45e1.
[    3.310020] pata_acpi 0000:00:11.1: can't derive routing for PCI INT A
[    3.310169] pata_acpi 0000:00:11.1: can't derive routing for PCI INT A
[    3.314661] pata_via 0000:00:11.1: version 0.3.3
[    3.314676] pata_via 0000:00:11.1: can't derive routing for PCI INT A
[    3.315310] scsi0 : pata_via
[    3.315551] scsi1 : pata_via
[    3.318042] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq=
 14
[    3.318109] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq=
 15
[    3.481622] ata1.00: ATA-6: WDC WD2000JB-00GVC0, 08.02D08, max UDMA/100
[    3.481696] ata1.00: 390721968 sectors, multi 16: LBA48=20
[    3.497495] ata1.00: configured for UDMA/100
[    3.660424] ata2.00: ATAPI: PIONEER DVD-RW  DVR-109, 1.09, max UDMA/66
[    3.676378] ata2.00: configured for UDMA/66
[    3.676594] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2000JB-00G 08=
.0 PQ: 0 ANSI: 5
[    3.682939] scsi 1:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-109  1.=
09 PQ: 0 ANSI: 5
[    3.692624] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    3.692755] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    3.717800] Driver 'sd' needs updating - please use bus_type methods
[    3.718051] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (20005=
0 MB)
[    3.718145] sd 0:0:0:0: [sda] Write Protect is off
[    3.718208] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.718256] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.718440] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (20005=
0 MB)
[    3.718529] sd 0:0:0:0: [sda] Write Protect is off
[    3.718592] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.718635] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    3.718719]  sda:<4>Driver 'sr' needs updating - please use bus_type met=
hods
[    3.739609]  sda1 sda2
[    3.760047] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.767031] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    3.767109] Uniform CD-ROM driver Revision: 3.20
[    3.767322] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.980563] PM: Starting manual resume from disk
[    3.980629] PM: Resume from partition 8:2
[    3.980632] PM: Checking hibernation image.
[    3.980804] PM: Resume from disk failed.
[    3.997522] SGI XFS with ACLs, security attributes, realtime, large bloc=
k numbers, no debug enabled
[    3.999733] SGI XFS Quota Management subsystem
[    4.043310] XFS mounting filesystem sda1
[    4.257714] Ending clean XFS mount for filesystem: sda1
[   12.084581] udevd version 124 started
[   12.891280] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   12.943000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.103021] Linux agpgart interface v0.103
[   13.444388] agpgart: Detected VIA KT400/KT400A/KT600 chipset
[   13.452805] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[   13.598812] Linux video capture interface: v2.00
[   13.924853] irda_init()
[   13.924877] NET: Registered protocol family 23
[   14.234541] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input2
[   14.250357] ACPI: Power Button (FF) [PWRF]
[   14.250616] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0C:00/input/input3
[   14.260907] ACPI: Power Button (CM) [PWRB]
[   14.262107] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0E:00/input/input4
[   14.276046] ACPI: Sleep Button (CM) [SLPB]
[   14.467600] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   14.468379] cx88[0]: subsystem: 18ac:db10, board: DViCO FusionHDTV DVB-T=
 Plus [card=3D21,autodetected], frontend(s): 1
[   14.468464] cx88[0]: TV tuner type 4, Radio tuner type -1
[   14.534670] saa7130/34: v4l2 driver version 0.2.14 loaded
[   14.697654] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   14.714893] cx88[0]/2: cx2388x 8802 Driver Manager
[   14.714990] cx88-mpeg driver manager 0000:00:07.2: PCI INT A -> GSI 18 (=
level, low) -> IRQ 18
[   14.715077] cx88[0]/2: found at 0000:00:07.2, rev: 5, irq: 18, latency: =
32, mmio: 0xde000000
[   14.715188] cx8802_probe() allocating 1 frontend(s)
[   14.715336] saa7134 0000:00:06.0: PCI INT A -> GSI 17 (level, low) -> IR=
Q 17
[   14.715407] saa7133[0]: found at 0000:00:06.0, rev: 209, irq: 17, latenc=
y: 32, mmio: 0xdffff800
[   14.715493] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid TV=
/Radio (A16D) [card=3D137,autodetected]
[   14.715588] saa7133[0]: board init: gpio is 300000
[   14.736644] input: saa7134 IR (AVerMedia Hybrid TV as /devices/pci0000:0=
0/0000:00:06.0/input/input5
[   14.801006] parport_pc 00:0b: reported by Plug and Play ACPI
[   14.801180] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRI=
STATE,COMPAT,EPP,ECP,DMA]
[   15.048290] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00 00 =
00 00 00 00 00
[   15.049073] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff =
ff ff ff ff ff
[   15.049845] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff 00 =
0e ff ff ff ff
[   15.050616] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.051386] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff =
ff ff ff ff ff
[   15.052167] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.052937] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.053708] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.054478] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.055250] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.056026] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.056798] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.057568] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.058340] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.059111] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.059882] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[   15.271133] tuner' 1-0061: chip found @ 0xc2 (saa7133[0])
[   15.558957] xc2028 1-0061: creating new instance
[   15.559029] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   15.559113] firmware: requesting xc3028-v27.fw
[   15.664807] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   16.037666] input: PS2++ Logitech Wheel Mouse as /devices/platform/i8042=
/serio1/input/input7
[   18.046874] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw=
, type: xc2028 firmware, ver 2.7
[   18.060053] xc2028 1-0061: Loading firmware for type=3DBASE F8MHZ (3), i=
d 0000000000000000.
[   26.604024] (0), id 00000000000000ff:
[   26.604094] xc2028 1-0061: Loading firmware for type=3D(0), id 000000010=
0000007.
[   26.772010] xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_53=
20 (60008000), id 0000000f00000007.
[   27.212905] saa7133[0]: registered device video0 [v4l2]
[   27.213190] saa7133[0]: registered device vbi0
[   27.213461] saa7133[0]: registered device radio0
[   27.213653] cx8800 0000:00:07.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
[   27.213728] cx88[0]/0: found at 0000:00:07.0, rev: 5, irq: 18, latency: =
32, mmio: 0xdd000000
[   27.214044] cx88[0]/0: registered device video1 [v4l2]
[   27.214322] cx88[0]/0: registered device vbi1
[   27.215999] ACPI: I/O resource vt596_smbus [0x400-0x407] conflicts with =
ACPI region SMOV [0x400-0x406]
[   27.216114] ACPI: Device needs an ACPI driver
[   27.233343] VIA 82xx Audio 0000:00:11.5: PCI INT C -> GSI 22 (level, low=
) -> IRQ 22
[   27.233580] VIA 82xx Audio 0000:00:11.5: setting latency timer to 64
[   27.259426] saa7134 ALSA driver for DMA sound loaded
[   27.260485] saa7133[0]/alsa: saa7133[0] at 0xdffff800 irq 17 registered =
as card -2
[   27.332712] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   27.332786] cx88/2: registering cx8802 driver, type: dvb access: shared
[   27.332853] cx88[0]/2: subsystem: 18ac:db10, board: DViCO FusionHDTV DVB=
-T Plus [card=3D21]
[   27.332934] cx88[0]/2: cx2388x based DVB/ATSC card
[   27.479634] DVB: registering new adapter (cx88[0])
[   27.479709] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T=
)...
[   27.504389] dvb_init() allocating 1 frontend
[   27.512221] xc2028 1-0061: attaching existing instance
[   27.512295] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   27.512362] DVB: registering new adapter (saa7133[0])
[   27.512427] DVB: registering adapter 1 frontend 0 (Zarlink MT352 DVB-T).=
..
[   27.996419] loop: module loaded
[   28.045729] lp0: using parport0 (interrupt-driven).
[   28.229203] Adding 2000084k swap on /dev/sda2.  Priority:-1 extents:1 ac=
ross:2000084k
[   29.056191] type=3D1505 audit(1229471453.161:2): operation=3D"profile_lo=
ad" name=3D"/usr/share/gdm/guest-session/Xsession" name2=3D"default" pid=3D=
3769
[   29.332239] type=3D1505 audit(1229471453.437:3): operation=3D"profile_lo=
ad" name=3D"/usr/lib/cups/backend/cups-pdf" name2=3D"default" pid=3D3774
[   29.332660] type=3D1505 audit(1229471453.437:4): operation=3D"profile_lo=
ad" name=3D"/usr/sbin/cupsd" name2=3D"default" pid=3D3774
[   29.423877] type=3D1505 audit(1229471453.525:5): operation=3D"profile_lo=
ad" name=3D"/usr/sbin/mysqld" name2=3D"default" pid=3D3778
[   29.590474] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.652633] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   30.244775] NET: Registered protocol family 10
[   30.245369] lo: Disabled Privacy Extensions
[   30.923089] RPC: Registered udp transport module.
[   30.923096] RPC: Registered tcp transport module.
[   32.199784] ACPI: WMI: Mapper loaded
[   33.200640] warning: `avahi-daemon' uses 32-bit capabilities (legacy sup=
port in use)
[   35.489859] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   35.489871] apm: overridden by ACPI.
[   35.915358] ppdev: user-space parallel port driver
[   36.329595] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   36.419127] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   36.420530] NFSD: starting 90-second grace period
[   37.240018] xc2028 1-0061: Loading firmware for type=3DBASE FM (401), id=
 0000000000000000.
[   40.900008] eth0: no IPv6 routers present
[   45.560019] xc2028 1-0061: Loading firmware for type=3DFM (400), id 0000=
000000000000.
[   45.928030] xc2028 1-0061: Loading firmware for type=3DBASE F8MHZ (3), i=
d 0000000000000000.
[   54.456018] (0), id 00000000000000ff:
[   54.456030] xc2028 1-0061: Loading firmware for type=3D(0), id 000000010=
0000007.
[   54.624009] xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_53=
20 (60008000), id 0000000f00000007.
[   58.760993] Bluetooth: Core ver 2.13
[   58.764301] NET: Registered protocol family 31
[   58.764310] Bluetooth: HCI device and connection manager initialized
[   58.764317] Bluetooth: HCI socket layer initialized
[   58.812754] Bluetooth: L2CAP ver 2.11
[   58.812764] Bluetooth: L2CAP socket layer initialized
[   58.857237] Bluetooth: SCO (Voice Link) ver 0.6
[   58.857247] Bluetooth: SCO socket layer initialized
[   58.902772] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   58.902781] Bluetooth: BNEP filters: protocol multicast
[   58.943971] Bluetooth: RFCOMM socket layer initialized
[   58.944371] Bluetooth: RFCOMM TTY layer initialized
[   58.944379] Bluetooth: RFCOMM ver 1.10
[   59.030483] Bridge firewalling registered
[   59.031686] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
[  789.696018] usb 4-3: new high speed USB device using ehci_hcd and addres=
s 2
[  789.846003] usb 4-3: configuration #1 chosen from 1 choice
[  790.052259] usbcore: registered new interface driver hiddev
[  790.056703] input: Afa Technologies Inc. AF9035A USB Device as /devices/=
pci0000:00/0000:00:10.3/usb4/4-3/4-3:1.1/input/input8
[  790.057902] input,hidraw0: USB HID v1.01 Keyboard [Afa Technologies Inc.=
 AF9035A USB Device] on usb-0000:00:10.3-3
[  790.058287] usbcore: registered new interface driver usbhid
[  790.058511] usbhid: v2.6:USB HID core driver

--sDKAb4OeUBrWWL6P--

--MrRUTeZlqqNo1jQ9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (FreeBSD)

iEYEARECAAYFAklIR3YACgkQIubykFB6QiMIrACfXIs9DK5Sx9mkyxQUdi9x9Xqn
eSEAoKmMTOSdxYETXEUl4M2VukfrGByK
=Xog3
-----END PGP SIGNATURE-----

--MrRUTeZlqqNo1jQ9--


--===============0335390375==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0335390375==--
