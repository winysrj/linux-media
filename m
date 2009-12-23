Return-path: <linux-media-owner@vger.kernel.org>
Received: from triton.gremlin.cz ([81.0.227.141]:44377 "EHLO triton"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751780AbZLWPQ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 10:16:27 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by triton (Postfix) with ESMTP id 7A56141FE7
	for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 16:07:31 +0100 (CET)
Subject: em28xx: new board id [0ccd:0092]
From: Alexander =?UTF-8?Q?Kr=C5=A1ek?= <merlin@gremlin.cz>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-iPKR2PKz0qCy576APv03"
Date: Wed, 23 Dec 2009 16:07:31 +0100
Message-Id: <1261580851.3057.23.camel@triton>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iPKR2PKz0qCy576APv03
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I have usb tv stick and have problem to run it in linux.

Model: TerraTec Cinergy Hybrid T USB XS FM
Vendor/Product id: [0ccd:0092]

I downloaded v4l-dvb sources from repository from 23.12.2009 and patched
v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c (see attachment,
but its simple addition of two lines with "my" ID).

And I ended with "Oops" after modprobe.

Kernel is 2.6.26-2-amd64 from Debian Lenny, tainted with nvidia kernel
driver. So, what should I do next? I have some programming skills but
with this null pointer dereference I simple do not know, where to start.

Thank you for the answer.

Alexander

--=-iPKR2PKz0qCy576APv03
Content-Disposition: attachment; filename=0092.diff
Content-Type: text/x-patch; name=0092.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- dvb/v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-12-23 15:06:18.000000000 +0100
+++ dvb.my/v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-12-23 14:45:09.000000000 +0100
@@ -1752,6 +1752,8 @@
 			.driver_info = EM2880_BOARD_TERRATEC_PRODIGY_XS },
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
+	{ USB_DEVICE(0x0ccd, 0x0092),
+			.driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0096),
 			.driver_info = EM2860_BOARD_TERRATEC_GRABBY },
 	{ USB_DEVICE(0x185b, 0x2870),

--=-iPKR2PKz0qCy576APv03
Content-Disposition: attachment; filename=0092.lsusb-v
Content-Type: text/plain; name=0092.lsusb-v; charset=UTF-8
Content-Transfer-Encoding: 7bit


Bus 005 Device 006: ID 0ccd:0092 TerraTec Electronic GmbH 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0ccd TerraTec Electronic GmbH
  idProduct          0x0092 
  bcdDevice            1.10
  iManufacturer           0 
  iProduct                1 Cinergy Hybrid T USB XS FM
  iSerial                 2 080502000097
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          305
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
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
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       2
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0ad4  2x 724 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       3
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       4
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1300  3x 768 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       5
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x135c  3x 860 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       6
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x13c4  3x 964 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       7
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol    255 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval              11
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0234  1x 564 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--=-iPKR2PKz0qCy576APv03
Content-Disposition: attachment; filename=0092.dmesg
Content-Type: text/plain; name=0092.dmesg; charset=UTF-8
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-amd64 (Debian 2.6.26-19lenny2) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Thu Nov 5 02:23:12 UTC 2009
[    0.000000] Command line: root=/dev/sda3 ro 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe87c00 (usable)
[    0.000000]  BIOS-e820: 000000007fe87c00 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 523911) 1 entries of 3200 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FC0E0, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 7FE8818A, 0048 (r1 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: FACP 7FE89000, 0074 (r1 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: DSDT 7FE89C00, 51B9 (r1 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS 7FE98400, 0040
[    0.000000] ACPI: HPET 7FE89700, 0038 (r1 DELL    M07            1 ASL        61)
[    0.000000] ACPI: APIC 7FE89800, 0068 (r1 DELL    M07     27D80A10 ASL        47)
[    0.000000] ACPI: ASF! 7FE89400, 005B (r16 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: MCFG 7FE897C0, 003E (r16 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: SLIC 7FE8989C, 0176 (r1 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: TCPA 7FE89B00, 0032 (r1 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: BOOT 7FE893C0, 0028 (r1 DELL    M07     27D80A10 ASL        61)
[    0.000000] ACPI: SSDT 7FE88215, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fe87000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 523911) 1 entries of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007fe87000
[    0.000000]   NODE_DATA [000000000000c000 - 0000000000010fff]
[    0.000000]   bootmap [0000000000011000 -  0000000000020fd7] pages 10
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-675397] TEXT DATA BSS
[    0.000000]   early res: 3 [37da8000-37fefbfa] RAMDISK
[    0.000000]   early res: 4 [9f000-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-bfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff810001200000-ffff810002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   523911
[    0.000000] On node 0 totalpages: 523814
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1245 pages reserved
[    0.000000]   DMA zone: 2698 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7107 pages used for memmap
[    0.000000]   DMA32 zone: 512708 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37168 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 2
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515406
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda3 ro 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 1997.339 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] Memory: 2059404k/2095644k available (2228k kernel code, 35852k reserved, 1081k data, 392k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.083885] Calibrating delay using timer specific routine.. 3998.91 BogoMIPS (lpj=7997834)
[    0.084005] Security Framework initialized
[    0.084005] SELinux:  Disabled at boot.
[    0.084005] Capability LSM initialized
[    0.084005] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.084005] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.084005] Mount-cache hash table entries: 256
[    0.084005] Initializing cgroup subsys ns
[    0.084005] Initializing cgroup subsys cpuacct
[    0.084005] Initializing cgroup subsys devices
[    0.084005] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084005] CPU: L2 cache: 4096K
[    0.084005] CPU 0/0 -> Node 0
[    0.084005] CPU: Physical Processor ID: 0
[    0.084005] CPU: Processor Core ID: 0
[    0.084005] CPU0: Thermal monitoring enabled (TM2)
[    0.084005] using mwait in idle threads.
[    0.085093] ACPI: Core revision 20080321
[    0.134905] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
[    0.135035] Using local APIC timer interrupts.
[    0.140008] APIC timer calibration result 10402814
[    0.140008] Detected 10.402 MHz APIC timer.
[    0.140008] Booting processor 1/1 ip 6000
[    0.148009] Initializing CPU#1
[    0.148009] Calibrating delay using timer specific routine.. 3994.77 BogoMIPS (lpj=7989548)
[    0.148009] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.148009] CPU: L2 cache: 4096K
[    0.148009] CPU 1/1 -> Node 0
[    0.148009] CPU: Physical Processor ID: 0
[    0.148009] CPU: Processor Core ID: 1
[    0.148009] CPU1: Thermal monitoring enabled (TM2)
[    0.228014] CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
[    0.228014] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.228014] Measured 3910523952 cycles TSC warp between CPUs, turning off TSC clock.
[    0.228014] Marking TSC unstable due to check_tsc_sync_source failed
[    0.228093] Brought up 2 CPUs
[    0.228145] Total of 2 processors activated (7993.69 BogoMIPS).
[    0.228280] CPU0 attaching sched-domain:
[    0.228282]  domain 0: span 0-1
[    0.228284]   groups: 0 1
[    0.228287]   domain 1: span 0-1
[    0.228289]    groups: 0-1
[    0.228293] CPU1 attaching sched-domain:
[    0.228295]  domain 0: span 0-1
[    0.228297]   groups: 1 0
[    0.228299]   domain 1: span 0-1
[    0.228301]    groups: 0-1
[    0.232014] net_namespace: 1224 bytes
[    0.232014] Booting paravirtualized kernel on bare hardware
[    0.232014] NET: Registered protocol family 16
[    0.232014] ACPI: bus type pci registered
[    0.232014] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.232014] PCI: MCFG area at f0000000 reserved in E820
[    0.235375] PCI: Using MMCONFIG at f0000000 - f3ffffff
[    0.235428] PCI: Using configuration type 1 for base access
[    0.236014] ACPI: EC: Look up EC in DSDT
[    0.260948] ACPI Warning (tbutils-0217): Incorrect checksum in table [TCPA] - 00, should be 95 [20080321]
[    0.261097] ACPI: SSDT 7FE881D2, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)
[    0.271798] ACPI: Interpreter enabled
[    0.272017] ACPI: (supports S0 S3 S4 S5)
[    0.276017] ACPI: Using IOAPIC for interrupt routing
[    0.334132] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.334132] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.334132] pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
[    0.335592] PCI: Transparent bridge - 0000:00:1e.0
[    0.335693] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.336276] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.336391] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.341287] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.341437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.341586] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXP0._PRT]
[    0.341677] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.366809] ACPI: PCI Interrupt Link [LNKA] (IRQs *9 10 11)
[    0.366809] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.366809] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *5
[    0.366809] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[    0.366809] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.366809] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    0.366809] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.366809] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.370809] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.370809] pnp: PnP ACPI init
[    0.370809] ACPI: bus type pnp registered
[    0.370809] pnp 00:00: parse allocated resources
[    0.390699] pnp 00:00:   add mem 0x0-0x9fbff flags 0x1
[    0.390701] pnp 00:00:   add mem 0x9fc00-0x9ffff flags 0x1
[    0.390703] pnp 00:00:   add mem 0xc0000-0xcffff flags 0x0
[    0.390705] pnp 00:00:   add mem 0xe0000-0xfffff flags 0x0
[    0.390708] pnp 00:00:   add mem 0x100000-0x7fe87bff flags 0x1
[    0.390710] pnp 00:00:   add mem 0x7fe87c00-0x7fefffff flags 0x1
[    0.390712] pnp 00:00:   add mem 0x7ff00000-0x7fffffff flags 0x1
[    0.390714] pnp 00:00:   add mem 0xffb00000-0xffffffff flags 0x0
[    0.390716] pnp 00:00:   add mem 0xfec00000-0xfec0ffff flags 0x1
[    0.390719] pnp 00:00:   add mem 0xfee00000-0xfee0ffff flags 0x1
[    0.390721] pnp 00:00:   add mem 0xfed20000-0xfed3ffff flags 0x0
[    0.390723] pnp 00:00:   add mem 0xfed45000-0xfed9ffff flags 0x0
[    0.390725] pnp 00:00:   add mem 0xffa80000-0xffa83fff flags 0x1
[    0.390727] pnp 00:00:   add mem 0xf4000000-0xf4003fff flags 0x1
[    0.390729] pnp 00:00:   add mem 0xf4004000-0xf4004fff flags 0x1
[    0.390732] pnp 00:00:   add mem 0xf4005000-0xf4005fff flags 0x1
[    0.390734] pnp 00:00:   add mem 0xf4006000-0xf4006fff flags 0x1
[    0.390736] pnp 00:00:   add mem 0xf4008000-0xf400bfff flags 0x1
[    0.390738] pnp 00:00:   add mem 0xf0000000-0xf3ffffff flags 0x1
[    0.390742] pnp 00:00: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.390810] pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.390810] pnp 00:01: parse allocated resources
[    0.402811] pnp 00:01:   add io  0xcf8-0xcff flags 0x1
[    0.402811] pnp 00:01: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.402811] pnp 00:02: parse allocated resources
[    0.402811] pnp 00:02:   add io  0x92-0x92 flags 0x1
[    0.402811] pnp 00:02:   add io  0xb2-0xb2 flags 0x1
[    0.402811] pnp 00:02:   add io  0x20-0x21 flags 0x1
[    0.402811] pnp 00:02:   add io  0xa0-0xa1 flags 0x1
[    0.402811] pnp 00:02:   add io  0x4d0-0x4d1 flags 0x1
[    0.402811] pnp 00:02:   add io  0x1000-0x1005 flags 0x1
[    0.402811] pnp 00:02:   add io  0x1008-0x100f flags 0x1
[    0.402811] pnp 00:02: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.402811] pnp 00:02: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.402811] pnp 00:03: parse allocated resources
[    0.402811] pnp 00:03:   add io  0xf400-0xf4fe flags 0x1
[    0.402811] pnp 00:03:   add io  0x86-0x86 flags 0x1
[    0.402811] pnp 00:03:   add io  0xb3-0xb3 flags 0x1
[    0.402811] pnp 00:03:   add io  0x1006-0x1007 flags 0x1
[    0.402811] pnp 00:03:   add io  0x100a-0x1059 flags 0x1
[    0.402811] pnp 00:03:   add io  0x1060-0x107f flags 0x1
[    0.402811] pnp 00:03:   add io  0x1080-0x10bf flags 0x1
[    0.402811] pnp 00:03:   add io  0x10c0-0x10df flags 0x1
[    0.402811] pnp 00:03:   add io  0x1010-0x102f flags 0x1
[    0.402811] pnp 00:03:   add io  0x809-0x809 flags 0x1
[    0.402811] pnp 00:03: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.402811] pnp 00:03: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.402811] pnp 00:04: parse allocated resources
[    0.402811] pnp 00:04:   add irq 12 flags 0x1
[    0.402811] pnp 00:04: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.402811] pnp 00:05: parse allocated resources
[    0.402811] pnp 00:05:   add io  0x60-0x60 flags 0x1
[    0.402811] pnp 00:05:   add io  0x64-0x64 flags 0x1
[    0.402811] pnp 00:05:   add io  0x62-0x62 flags 0x1
[    0.402811] pnp 00:05:   add io  0x66-0x66 flags 0x1
[    0.402811] pnp 00:05:   add irq 1 flags 0x1
[    0.402811] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.402811] pnp 00:06: parse allocated resources
[    0.402811] pnp 00:06:   add io  0x70-0x71 flags 0x1
[    0.402811] pnp 00:06:   add irq 8 flags 0x1
[    0.402811] pnp 00:06:   add io  0x72-0x77 flags 0x1
[    0.402811] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.402811] pnp 00:07: parse allocated resources
[    0.402811] pnp 00:07:   add io  0x61-0x61 flags 0x1
[    0.402811] pnp 00:07:   add io  0x63-0x63 flags 0x1
[    0.402811] pnp 00:07:   add io  0x65-0x65 flags 0x1
[    0.402811] pnp 00:07:   add io  0x67-0x67 flags 0x1
[    0.402811] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.402811] pnp 00:08: parse allocated resources
[    0.402811] pnp 00:08:   add io  0x2e-0x2f flags 0x1
[    0.402811] pnp 00:08:   add io  0xc80-0xcaf flags 0x1
[    0.402811] pnp 00:08:   add io  0xcc0-0xcff flags 0x1
[    0.402811] pnp 00:08:   add io  0x4e-0x4f flags 0x1
[    0.402811] pnp 00:08:   add io  0x910-0x91f flags 0x1
[    0.402811] pnp 00:08:   add io  0x920-0x92f flags 0x1
[    0.402811] pnp 00:08:   add io  0xcbc-0xcbf flags 0x1
[    0.402811] pnp 00:08:   add io  0x930-0x97f flags 0x1
[    0.402811] pnp 00:08: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.402811] pnp 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.402811] pnp 00:09: parse allocated resources
[    0.402811] pnp 00:09:   add dma 4 flags 0x4
[    0.402811] pnp 00:09:   add io  0x0-0xf flags 0x1
[    0.402811] pnp 00:09:   add io  0x80-0x85 flags 0x1
[    0.402811] pnp 00:09:   add io  0x87-0x8f flags 0x1
[    0.402811] pnp 00:09:   add io  0xc0-0xdf flags 0x1
[    0.402811] pnp 00:09:   add io  0x10-0x1f flags 0x1
[    0.402811] pnp 00:09:   add io  0x90-0x91 flags 0x1
[    0.402811] pnp 00:09:   add io  0x93-0x9f flags 0x1
[    0.402811] pnp 00:09: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.402811] pnp 00:0a: parse allocated resources
[    0.402811] pnp 00:0a:   add io  0xf0-0xff flags 0x1
[    0.402811] pnp 00:0a:   add irq 13 flags 0x1
[    0.402811] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.402811] pnp 00:0b: parse allocated resources
[    0.402811] pnp 00:0b:   add mem 0xfed00000-0xfed003ff flags 0x0
[    0.402811] pnp 00:0b: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.402811] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    0.419811] pnp 00:0c: parse allocated resources
[    0.419844] pnp 00:0c:   add mem 0xfed40000-0xfed44fff flags 0x1
[    0.419847] pnp 00:0c:   add io  0xcb0-0xcbb flags 0x1
[    0.419850] pnp 00:0c: PNP0c01: calling quirk_system_pci_resources+0x0/0x15c
[    0.422818] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.422818] pnp: PnP ACPI: found 13 devices
[    0.422818] ACPI: ACPI bus type pnp unregistered
[    0.422818] usbcore: registered new interface driver usbfs
[    0.422818] usbcore: registered new interface driver hub
[    0.422818] usbcore: registered new device driver usb
[    0.422818] PCI: Using ACPI for IRQ routing
[    0.437066] PCI-GART: No AMD northbridge found.
[    0.437124] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.437324] hpet0: 3 64-bit timers, 14318180 Hz
[    0.441037] ACPI: RTC can wake from S4
[    0.443665] Switched to high resolution mode on CPU 0
[    0.445039] Switched to high resolution mode on CPU 1
[    0.455622] pnp: the driver 'system' has been registered
[    0.455633] system 00:00: iomem range 0x0-0x9fbff could not be reserved
[    0.455689] system 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[    0.455742] system 00:00: iomem range 0xc0000-0xcffff has been reserved
[    0.455795] system 00:00: iomem range 0xe0000-0xfffff has been reserved
[    0.455848] system 00:00: iomem range 0x100000-0x7fe87bff could not be reserved
[    0.455909] system 00:00: iomem range 0x7fe87c00-0x7fefffff could not be reserved
[    0.455970] system 00:00: iomem range 0x7ff00000-0x7fffffff could not be reserved
[    0.456032] system 00:00: iomem range 0xffb00000-0xffffffff could not be reserved
[    0.456093] system 00:00: iomem range 0xfec00000-0xfec0ffff could not be reserved
[    0.462453] system 00:00: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    0.462515] system 00:00: iomem range 0xfed20000-0xfed3ffff could not be reserved
[    0.462576] system 00:00: iomem range 0xfed45000-0xfed9ffff could not be reserved
[    0.462638] system 00:00: iomem range 0xffa80000-0xffa83fff could not be reserved
[    0.462699] system 00:00: iomem range 0xf4000000-0xf4003fff could not be reserved
[    0.462760] system 00:00: iomem range 0xf4004000-0xf4004fff could not be reserved
[    0.462822] system 00:00: iomem range 0xf4005000-0xf4005fff could not be reserved
[    0.462883] system 00:00: iomem range 0xf4006000-0xf4006fff could not be reserved
[    0.462944] system 00:00: iomem range 0xf4008000-0xf400bfff could not be reserved
[    0.463005] system 00:00: iomem range 0xf0000000-0xf3ffffff could not be reserved
[    0.463064] system 00:00: driver attached
[    0.463071] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.463123] system 00:02: ioport range 0x1000-0x1005 has been reserved
[    0.463176] system 00:02: ioport range 0x1008-0x100f has been reserved
[    0.463229] system 00:02: driver attached
[    0.463234] system 00:03: ioport range 0xf400-0xf4fe has been reserved
[    0.463287] system 00:03: ioport range 0x1006-0x1007 has been reserved
[    0.463340] system 00:03: ioport range 0x100a-0x1059 could not be reserved
[    0.463392] system 00:03: ioport range 0x1060-0x107f has been reserved
[    0.463445] system 00:03: ioport range 0x1080-0x10bf has been reserved
[    0.463498] system 00:03: ioport range 0x10c0-0x10df has been reserved
[    0.463550] system 00:03: ioport range 0x1010-0x102f has been reserved
[    0.465637] system 00:03: ioport range 0x809-0x809 has been reserved
[    0.465689] system 00:03: driver attached
[    0.465696] system 00:08: ioport range 0xc80-0xcaf has been reserved
[    0.465748] system 00:08: ioport range 0xcc0-0xcff could not be reserved
[    0.465802] system 00:08: ioport range 0x910-0x91f has been reserved
[    0.465854] system 00:08: ioport range 0x920-0x92f has been reserved
[    0.465907] system 00:08: ioport range 0xcbc-0xcbf has been reserved
[    0.465958] system 00:08: ioport range 0x930-0x97f has been reserved
[    0.466011] system 00:08: driver attached
[    0.466017] system 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.466070] system 00:0b: driver attached
[    0.466075] system 00:0c: ioport range 0xcb0-0xcbb has been reserved
[    0.466129] system 00:0c: iomem range 0xfed40000-0xfed44fff could not be reserved
[    0.466189] system 00:0c: driver attached
[    0.467803] PCI: Bridge: 0000:00:01.0
[    0.467803]   IO window: e000-efff
[    0.467803]   MEM window: 0xed000000-0xefefffff
[    0.467803]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.467803] PCI: Bridge: 0000:00:1c.0
[    0.467803]   IO window: disabled.
[    0.467803]   MEM window: disabled.
[    0.467803]   PREFETCH window: disabled.
[    0.467803] PCI: Bridge: 0000:00:1c.1
[    0.467803]   IO window: disabled.
[    0.467803]   MEM window: 0xecf00000-0xecffffff
[    0.467803]   PREFETCH window: disabled.
[    0.467803] PCI: Bridge: 0000:00:1c.2
[    0.467803]   IO window: disabled.
[    0.467803]   MEM window: 0xece00000-0xecefffff
[    0.467803]   PREFETCH window: disabled.
[    0.467803] PCI: Bridge: 0000:00:1c.3
[    0.467803]   IO window: d000-dfff
[    0.467803]   MEM window: 0xecc00000-0xecdfffff
[    0.467803]   PREFETCH window: 0x00000000e0000000-0x00000000e01fffff
[    0.467803] PCI: Bridge: 0000:00:1e.0
[    0.467803]   IO window: disabled.
[    0.467803]   MEM window: 0xecb00000-0xecbfffff
[    0.467803]   PREFETCH window: disabled.
[    0.467803] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.467803] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.467803] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.467803] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.467803] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    0.467803] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.467803] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.467803] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.467803] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.467803] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.467803] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.467803] NET: Registered protocol family 2
[    0.507923] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.508741] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.511800] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.511800] TCP: Hash tables configured (established 262144 bind 65536)
[    0.511800] TCP reno registered
[    0.523956] NET: Registered protocol family 1
[    0.524123] checking if image is initramfs... it is
[    0.696033] Freeing initrd memory: 2334k freed
[    0.699799] Simple Boot Flag at 0x79 set to 0x1
[    0.703730] audit: initializing netlink socket (disabled)
[    0.703730] type=2000 audit(1261581881.681:1): initialized
[    0.703730] Total HugeTLB memory allocated, 0
[    0.703730] VFS: Disk quotas dquot_6.5.1
[    0.703730] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.703730] msgmni has been set to 4026
[    0.703730] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.703730] io scheduler noop registered
[    0.703730] io scheduler anticipatory registered
[    0.703730] io scheduler deadline registered
[    0.703730] io scheduler cfq registered (default)
[    0.703730] pci 0000:01:00.0: Boot video device
[    0.703730] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.703730] assign_interrupt_mode Found MSI capability
[    0.703730] Allocate Port Service[0000:00:01.0:pcie00]
[    0.703730] Allocate Port Service[0000:00:01.0:pcie03]
[    0.703730] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.703730] assign_interrupt_mode Found MSI capability
[    0.703730] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.703730] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.703730] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.703730] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.703730] assign_interrupt_mode Found MSI capability
[    0.703730] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.703730] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.703730] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.703730] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.703730] assign_interrupt_mode Found MSI capability
[    0.703730] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.703730] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.703730] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.703730] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.703730] assign_interrupt_mode Found MSI capability
[    0.703730] Allocate Port Service[0000:00:1c.3:pcie00]
[    0.703744] Allocate Port Service[0000:00:1c.3:pcie02]
[    0.705792] Allocate Port Service[0000:00:1c.3:pcie03]
[    0.707728] hpet_resources: 0xfed00000 is busy
[    0.707728] Linux agpgart interface v0.103
[    0.707728] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    0.711726] pnp: the driver 'serial' has been registered
[    0.711726] brd: module loaded
[    0.711726] input: Macintosh mouse button emulation as /class/input/input0
[    0.711726] pnp: the driver 'i8042 kbd' has been registered
[    0.711726] i8042 kbd 00:05: driver attached
[    0.711726] pnp: the driver 'i8042 aux' has been registered
[    0.711726] i8042 aux 00:04: driver attached
[    0.711726] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.715725] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.715725] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.739725] mice: PS/2 mouse device common for all mice
[    0.739725] pnp: the driver 'rtc_cmos' has been registered
[    0.739725] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.739725] rtc0: alarms up to one month, y3k
[    0.739725] rtc_cmos 00:06: driver attached
[    0.739725] cpuidle: using governor ladder
[    0.739725] cpuidle: using governor menu
[    0.739725] No iBFT detected.
[    0.740132] TCP cubic registered
[    0.740132] NET: Registered protocol family 17
[    0.740132] registered taskstats version 1
[    0.740132] rtc_cmos 00:06: setting system clock to 2009-12-23 15:24:42 UTC (1261581882)
[    0.740132] Freeing unused kernel memory: 392k freed
[    0.740132] input: AT Translated Set 2 keyboard as /class/input/input1
[    0.771226] Uniform Multi-Platform E-IDE driver
[    0.771226] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    0.775226] ACPI: ACPI Dock Station Driver
[    0.779226] SCSI subsystem initialized
[    0.783227] libata version 3.00 loaded.
[    0.786329] ata_piix 0000:00:1f.2: version 2.12
[    0.786354] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[    0.786458] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.786692] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.786753] scsi0 : ata_piix
[    0.786906] scsi1 : ata_piix
[    0.787226] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
[    0.787226] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
[    0.951235] ata1.00: ATA-7: TOSHIBA MK1637GSX, DL040D, max UDMA/100
[    0.951235] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    0.955687] ata1.00: configured for UDMA/100
[    1.022240] Clocksource tsc unstable (delta = 1957863377 ns)
[    1.134708] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, DW30, max UDMA/33
[    1.166653] ata2.00: configured for UDMA/33
[    1.166731] isa bounce pool size: 16 pages
[    1.166854] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1637GS DL04 PQ: 0 ANSI: 5
[    1.174580] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L632H DW30 PQ: 0 ANSI: 5
[    1.198521] ACPI: SSDT 7FE8893C, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[    1.198521] ACPI: SSDT 7FE886F1, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    1.198521] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.198521] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.198521] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.198521] ACPI: SSDT 7FE88B80, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    1.198702] ACPI: SSDT 7FE888B7, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[    1.198521] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.198771] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.198826] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.202554] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.205780] ACPI: Thermal Zone [THM] (66 C)
[    1.290874] Driver 'sd' needs updating - please use bus_type methods
[    1.290874] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.290874] sd 0:0:0:0: [sda] Write Protect is off
[    1.290874] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.290874] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.290874] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.290874] sd 0:0:0:0: [sda] Write Protect is off
[    1.290874] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.290874] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.290874]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.370873] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.757774] PM: Starting manual resume from disk
[    1.813214] kjournald starting.  Commit interval 5 seconds
[    1.813214] EXT3-fs: mounted filesystem with ordered data mode.
[    3.599218] udevd version 125 started
[    4.183421] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.404861] input: Lid Switch as /class/input/input2
[    4.433439] ACPI: Lid Switch [LID]
[    4.433546] input: Power Button (CM) as /class/input/input3
[    4.500876] ACPI: Power Button (CM) [PBTN]
[    4.500876] input: Sleep Button (CM) as /class/input/input4
[    4.562792] ACPI: Sleep Button (CM) [SBTN]
[    4.563397] ACPI: AC Adapter [AC] (on-line)
[    4.608347] ACPI: Battery Slot [BAT0] (battery present)
[    4.648702] ACPI: WMI: Mapper loaded
[    4.688348] Driver 'sr' needs updating - please use bus_type methods
[    4.704348] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.704348] Uniform CD-ROM driver Revision: 3.20
[    4.704348] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.062287] ACPI: device:2f is registered as cooling_device2
[    5.062287] input: Video Bus as /class/input/input5
[    5.124318] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    5.126659] USB Universal Host Controller Interface driver v3.0
[    5.126659] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
[    5.126659] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.126659] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.126659] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    5.126659] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000bf80
[    5.126659] usb usb1: configuration #1 chosen from 1 choice
[    5.126677] hub 1-0:1.0: USB hub found
[    5.126732] hub 1-0:1.0: 2 ports detected
[    5.213425] intel_rng: FWH not detected
[    5.227488] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.227546] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.227615] usb usb1: Product: UHCI Host Controller
[    5.227671] usb usb1: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    5.227724] usb usb1: SerialNumber: 0000:00:1d.0
[    5.229425] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
[    5.229425] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.229425] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.229425] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    5.229425] uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000bf60
[    5.229425] usb usb2: configuration #1 chosen from 1 choice
[    5.229425] hub 2-0:1.0: USB hub found
[    5.229425] hub 2-0:1.0: 2 ports detected
[    5.308041] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.308041] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.333193] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.333251] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.333311] usb usb2: Product: UHCI Host Controller
[    5.333360] usb usb2: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    5.333410] usb usb2: SerialNumber: 0000:00:1d.1
[    5.333546] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
[    5.333653] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.333657] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.333754] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    5.333847] uhci_hcd 0000:00:1d.2: irq 22, io base 0x0000bf40
[    5.333972] usb usb3: configuration #1 chosen from 1 choice
[    5.334049] hub 3-0:1.0: USB hub found
[    5.334106] hub 3-0:1.0: 2 ports detected
[    5.436578] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.436636] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.436695] usb usb3: Product: UHCI Host Controller
[    5.436744] usb usb3: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    5.436795] usb usb3: SerialNumber: 0000:00:1d.2
[    5.436904] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
[    5.437011] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    5.437015] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.437111] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    5.437203] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
[    5.437328] usb usb4: configuration #1 chosen from 1 choice
[    5.437405] hub 4-0:1.0: USB hub found
[    5.437462] hub 4-0:1.0: 2 ports detected
[    5.470945] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    5.496534] sdhci: Secure Digital Host Controller Interface driver
[    5.496534] sdhci: Copyright(c) Pierre Ossman
[    5.543630] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.543686] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.543745] usb usb4: Product: UHCI Host Controller
[    5.543794] usb usb4: Manufacturer: Linux 2.6.26-2-amd64 uhci_hcd
[    5.543845] usb usb4: SerialNumber: 0000:00:1d.3
[    5.544203] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
[    5.544312] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.544316] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.544414] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    5.548366] ehci_hcd 0000:00:1d.7: debug port 1
[    5.548422] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.548429] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffa80000
[    5.592837] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.592978] usb usb5: configuration #1 chosen from 1 choice
[    5.593061] hub 5-0:1.0: USB hub found
[    5.593119] hub 5-0:1.0: 8 ports detected
[    5.632547] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26ks
[    5.632547] iwl3945: Copyright(c) 2003-2008 Intel Corporation
[    5.696851] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    5.696911] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.696970] usb usb5: Product: EHCI Host Controller
[    5.697019] usb usb5: Manufacturer: Linux 2.6.26-2-amd64 ehci_hcd
[    5.697070] usb usb5: SerialNumber: 0000:00:1d.7
[    5.697258] tg3.c:v3.92.1 (June 9, 2008)
[    5.697371] ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[    5.697477] PCI: Setting latency timer of device 0000:09:00.0 to 64
[    5.716548] eth0: Tigon3 [partno(BCM5752KFBG) rev 6002 PHY(5752)] (PCI Express) 10/100/1000Base-T Ethernet 00:1c:23:25:8d:10
[    5.716548] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    5.716548] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    5.716697] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 19
[    5.771611] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[ecbff800-ecbfffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    5.775786] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
[    5.797634] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[    5.797789] PCI: Setting latency timer of device 0000:0c:00.0 to 64
[    5.797811] iwl3945: Detected Intel Wireless WiFi Link 3945ABG
[    5.797895] sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 19)
[    5.797970] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 18
[    5.800128] mmc0: SDHCI at 0xecbff500 irq 18 DMA
[    5.874434] iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
[    5.876743] phy0: Selected rate control algorithm 'iwl-3945-rs'
[    5.975800] Synaptics Touchpad, model: 1, fw: 6.2, id: 0xfa0b1, caps: 0xa44713/0x200000
[    6.001727] usb 1-1: device not accepting address 2, error -71
[    6.014912] input: SynPS/2 Synaptics TouchPad as /class/input/input6
[    6.059732] hub 1-0:1.0: unable to enumerate USB device on port 1
[    6.131521] ACPI: PCI interrupt for device 0000:0c:00.0 disabled
[    6.179191] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
[    6.179191] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    7.087132] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc00024e8b070]
[    7.535153] usb 1-1: new full speed USB device using uhci_hcd and address 4
[    7.617570] Adding 4610612k swap on /dev/sda5.  Priority:-1 extents:1 across:4610612k
[    7.692164] usb 1-1: configuration #1 chosen from 1 choice
[    7.694562] hub 1-1:1.0: USB hub found
[    7.696485] hub 1-1:1.0: 4 ports detected
[    7.806843] usb 1-1: New USB device found, idVendor=413c, idProduct=a005
[    7.806901] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.044794] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    8.049192] EXT3 FS on sda3, internal journal
[    8.207221] usb 2-2: configuration #1 chosen from 1 choice
[    8.210253] usb 2-2: New USB device found, idVendor=067b, idProduct=2303
[    8.210311] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.210364] usb 2-2: Product: USB-Serial Controller D
[    8.210415] usb 2-2: Manufacturer: Prolific Technology Inc. 
[    8.449241] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    8.630842] usb 3-1: configuration #1 chosen from 1 choice
[    8.634704] usb 3-1: New USB device found, idVendor=046d, idProduct=c01d
[    8.634760] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.634811] usb 3-1: Product: USB-PS/2 Optical Mouse
[    8.634861] usb 3-1: Manufacturer: Logitech
[    8.725501] loop: module loaded
[    8.873492] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    9.041447] nvidia: module license 'NVIDIA' taints kernel.
[    9.044103] usb 4-1: configuration #1 chosen from 1 choice
[    9.048535] usb 4-1: New USB device found, idVendor=0566, idProduct=3017
[    9.048535] usb 4-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.279421] usb 1-1.2: new full speed USB device using uhci_hcd and address 5
[    9.301308] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    9.301308] PCI: Setting latency timer of device 0000:01:00.0 to 64
[    9.301308] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.09  Wed Jun  4 23:40:50 PDT 2008
[    9.391764] usb 1-1.2: configuration #1 chosen from 1 choice
[    9.394361] hub 1-1.2:1.0: USB hub found
[    9.396318] hub 1-1.2:1.0: 3 ports detected
[    9.505451] usb 1-1.2: New USB device found, idVendor=0b97, idProduct=7761
[    9.505509] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.732413] usb 1-1.4: new full speed USB device using uhci_hcd and address 6
[    9.884166] usb 1-1.4: configuration #1 chosen from 1 choice
[    9.888322] usb 1-1.4: New USB device found, idVendor=413c, idProduct=8103
[    9.888378] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    9.994868] Bluetooth: Core ver 2.11
[    9.994885] NET: Registered protocol family 31
[    9.994885] Bluetooth: HCI device and connection manager initialized
[    9.994885] Bluetooth: HCI socket layer initialized
[   10.082891] Bluetooth: HCI USB driver ver 2.9
[   10.100151] usb 1-1.2.2: new full speed USB device using uhci_hcd and address 7
[   10.112012] kjournald starting.  Commit interval 5 seconds
[   10.113280] EXT3 FS on sda6, internal journal
[   10.113367] EXT3-fs: mounted filesystem with ordered data mode.
[   10.215158] usb 1-1.2.2: configuration #1 chosen from 1 choice
[   10.222173] usb 1-1.2.2: New USB device found, idVendor=0b97, idProduct=7762
[   10.222232] usb 1-1.2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   10.222292] usb 1-1.2.2: Product: O2Micro CCID SC Reader
[   10.222343] usb 1-1.2.2: Manufacturer: O2
[   10.231856] usbcore: registered new interface driver usbserial
[   10.231925] usbserial: USB Serial support registered for generic
[   10.232007] usbcore: registered new interface driver hiddev
[   10.232139] usbcore: registered new interface driver hci_usb
[   10.233026] usbcore: registered new interface driver usbserial_generic
[   10.233080] usbserial: USB Serial Driver core
[   10.249662] input: Logitech USB-PS/2 Optical Mouse as /class/input/input7
[   10.273641] usbserial: USB Serial support registered for pl2303
[   10.273641] pl2303 2-2:1.0: pl2303 converter detected
[   10.289640] usb 2-2: pl2303 converter now attached to ttyUSB0
[   10.306973] input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.2-1
[   10.319243] input: HID 0566:3017 as /class/input/input8
[   10.352039] input,hidraw1: USB HID v1.10 Keyboard [HID 0566:3017] on usb-0000:00:1d.3-1
[   10.389863] input: HID 0566:3017 as /class/input/input9
[   10.411711] input,hiddev96,hidraw2: USB HID v1.10 Device [HID 0566:3017] on usb-0000:00:1d.3-1
[   10.412022] usbcore: registered new interface driver usbhid
[   10.412074] usbhid: v2.6:USB HID core driver
[   10.412164] usbcore: registered new interface driver pl2303
[   10.412216] pl2303: Prolific PL2303 USB to serial adaptor driver
[   20.852287] pnp: the driver 'parport_pc' has been registered
[   20.852287] lp: driver loaded but no devices found
[   20.883191] ppdev: user-space parallel port driver
[   24.065715] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   51.138065] CPU1: Temperature/speed normal
[   51.138065] CPU0: Temperature/speed normal
[  101.800992] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[  101.800992] PM: Writing back config space on device 0000:0c:00.0 at offset 1 (was 100102, writing 100106)
[  101.800992] firmware: requesting iwlwifi-3945-1.ucode
[  101.906616] Registered led device: iwl-phy0:radio
[  101.906616] Registered led device: iwl-phy0:assoc
[  101.906616] Registered led device: iwl-phy0:RX
[  101.906616] Registered led device: iwl-phy0:TX
[  106.731254] wlan0: Initial auth_alg=0
[  106.731254] wlan0: authenticate with AP 00:17:31:b4:22:64
[  106.736218] wlan0: RX authentication from 00:17:31:b4:22:64 (alg=0 transaction=2 status=0)
[  106.736218] wlan0: authenticated
[  106.736218] wlan0: associate with AP 00:17:31:b4:22:64
[  106.743393] wlan0: RX AssocResp from 00:17:31:b4:22:64 (capab=0x411 status=0 aid=2)
[  106.743393] wlan0: associated
[  106.743393] wlan0: switched to short barker preamble (BSSID=00:17:31:b4:22:64)
[  112.831073] tg3: eth0: Link is up at 100 Mbps, full duplex.
[  112.831073] tg3: eth0: Flow control is off for TX and off for RX.
[  126.630530] QEMU Accelerator Module version 1.3.0, Copyright (c) 2005-2007 Fabrice Bellard
[  126.630530] KQEMU installed, max_locked_mem=1031064kB.
[  126.702531] tun: Universal TUN/TAP device driver, 1.6
[  126.702531] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  127.785372] ip_tables: (C) 2000-2006 Netfilter Core Team
[  127.820037] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  302.328012] Machine check events logged
[  325.784856] usb 5-3: new high speed USB device using ehci_hcd and address 6
[  325.926041] usb 5-3: configuration #1 chosen from 1 choice
[  325.926041] usb 5-3: New USB device found, idVendor=0ccd, idProduct=0092
[  325.926041] usb 5-3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[  325.926041] usb 5-3: Product: Cinergy Hybrid T USB XS FM
[  325.926051] usb 5-3: SerialNumber: 080502000097
[  326.029776] Linux video capture interface: v2.00
[  549.105718] CE: hpet increasing min_delta_ns to 15000 nsec
[ 1018.446062] CE: hpet increasing min_delta_ns to 22500 nsec
[ 1199.705542] atkbd.c: Unknown key pressed (translated set 2, code 0x85 on isa0060/serio0).
[ 1199.705548] atkbd.c: Use 'setkeycodes e005 <keycode>' to make it known.
[ 1199.900619] atkbd.c: Unknown key pressed (translated set 2, code 0x85 on isa0060/serio0).
[ 1199.900619] atkbd.c: Use 'setkeycodes e005 <keycode>' to make it known.
[ 1200.876954] atkbd.c: Unknown key pressed (translated set 2, code 0x86 on isa0060/serio0).
[ 1200.876954] atkbd.c: Use 'setkeycodes e006 <keycode>' to make it known.
[ 1994.170265] usb 5-3: USB disconnect, address 6
[ 2036.048932] usb 5-3: new high speed USB device using ehci_hcd and address 7
[ 2036.189811] usb 5-3: configuration #1 chosen from 1 choice
[ 2036.189811] usb 5-3: New USB device found, idVendor=0ccd, idProduct=0092
[ 2036.189811] usb 5-3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 2036.189811] usb 5-3: Product: Cinergy Hybrid T USB XS FM
[ 2036.189811] usb 5-3: SerialNumber: 080502000097
[ 2036.299557] em28xx: New device Cinergy Hybrid T USB XS FM @ 480 Mbps (0ccd:0092, interface 0, class 0)
[ 2036.299557] em28xx #0: chip ID is em2882/em2883
[ 2036.457480] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 92 00 f0 12 6a 03 6a 38 a2 1c
[ 2036.457480] em28xx #0: i2c eeprom 10: 00 00 24 57 46 07 09 00 60 00 00 00 02 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom 20: 5e 00 12 00 f0 10 01 89 88 00 00 00 5b 1e 00 00
[ 2036.457480] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 d3 c4 00 00
[ 2036.457480] em28xx #0: i2c eeprom 50: a1 00 00 00 a2 80 00 00 00 00 00 00 00 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 38 03 43 00 69 00
[ 2036.457480] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 48 00 79 00
[ 2036.457480] em28xx #0: i2c eeprom 80: 62 00 72 00 69 00 64 00 20 00 54 00 20 00 55 00
[ 2036.457480] em28xx #0: i2c eeprom 90: 53 00 42 00 20 00 58 00 53 00 20 00 46 00 4d 00
[ 2036.457480] em28xx #0: i2c eeprom a0: 00 00 1c 03 30 00 38 00 30 00 35 00 30 00 32 00
[ 2036.457480] em28xx #0: i2c eeprom b0: 30 00 30 00 30 00 30 00 39 00 37 00 00 00 31 00
[ 2036.457480] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2036.457480] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 2036.457480] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x5e326e34
[ 2036.457480] em28xx #0: EEPROM info:
[ 2036.457480] em28xx #0:	I2S audio, 3 sample rates
[ 2036.457480] em28xx #0:	500mA max power
[ 2036.457480] em28xx #0:	Table at 0x24, strings=0x386a, 0x1ca2, 0x0000
[ 2036.457480] em28xx #0: Identified as Terratec Hybrid XS (card=11)
[ 2036.505526] tuner 4-0061: chip found @ 0xc2 (em28xx #0)
[ 2036.545776] xc2028 4-0061: creating new instance
[ 2036.545776] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 2036.545776] firmware: requesting xc3028-v27.fw
[ 2036.550123] xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 2036.595099] xc2028 4-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 2037.230918] xc2028 4-0061: i2c output error: rc = -110 (should be 64)
[ 2037.238790] xc2028 4-0061: -110 returned from send
[ 2037.238790] xc2028 4-0061: Error -22 while loading base firmware
[ 2037.292893] input: em28xx IR (em28xx #0) as /class/input/input10
[ 2037.317445] BUG: unable to handle kernel NULL pointer dereference at 00000000000000da
[ 2037.317449] IP: [<ffffffffa0ba891c>] :ir_core:ir_register_class+0x61/0xc5
[ 2037.317457] PGD 7c989067 PUD 2e8e0067 PMD 0 
[ 2037.317460] Oops: 0000 [1] SMP 
[ 2037.317462] CPU 0 
[ 2037.317465] Modules linked in: tuner_xc2028 tuner tvp5150 em28xx(+) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 ir_common videobuf_vmalloc videobuf_core ir_core tveeprom ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables tun kqemu aes_x86_64 aes_generic ppdev parport_pc lp parport pl2303 hci_usb bluetooth nvidia(P) sbp2 usbhid hid loop ff_memless usbserial snd_hda_intel joydev arc4 ecb snd_pcm_oss crypto_blkcipher snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwl3945 snd_seq firmware_class snd_timer snd_seq_device mac80211 sdhci i2c_i801 snd serio_raw mmc_core led_class i2c_core sg ohci1394 ieee1394 psmouse rng_core ehci_hcd tg3 uhci_hcd cfg80211 video output soundcore sr_mod wmi battery ac snd_page_alloc button intel_agp cdrom dcdbas evdev ext3 jbd mbcache sd_mod thermal processor fan thermal_sys ata_piix ata_generic libata scsi_mod dock ide_pci_generic ide_core
[ 2037.317536] Pid: 4233, comm: modprobe Tainted: P          2.6.26-2-amd64 #1
[ 2037.317539] RIP: 0010:[<ffffffffa0ba891c>]  [<ffffffffa0ba891c>] :ir_core:ir_register_class+0x61/0xc5
[ 2037.317544] RSP: 0018:ffff81007c973978  EFLAGS: 00010292
[ 2037.317546] RAX: ffffffffffffffea RBX: 0000000000000000 RCX: ffff81007c973898
[ 2037.317548] RDX: 0000000000000007 RSI: 0000000000000040 RDI: 0000000000000286
[ 2037.317550] RBP: 0000000000000000 R08: ffff81005f9f0540 R09: 00000000ffffffff
[ 2037.317553] R10: 0000000000000001 R11: ffff81005b8fa000 R12: ffff81005f9f0540
[ 2037.317555] R13: ffff81005b8fa000 R14: ffffffffa0bbf020 R15: ffff81007e162428
[ 2037.317558] FS:  00007f58f369a6e0(0000) GS:ffffffff8053c000(0000) knlGS:0000000000000000
[ 2037.317560] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2037.317562] CR2: 00000000000000da CR3: 00000000670ae000 CR4: 00000000000006e0
[ 2037.317564] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2037.317567] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2037.317569] Process modprobe (pid: 4233, threadinfo ffff81007c972000, task ffff81006547d0a0)
[ 2037.317571] Stack:  ffff81007e162470 0000000000000000 ffff81005b8fa000 ffff81005f9f0540
[ 2037.317576]  000000000000002f ffffffffa0ba867d ffff81007e162400 ffff81005b8fa000
[ 2037.317580]  0000000000000000 ffff81005ad1a000 ffff81007e162448 ffffffffa0bed099
[ 2037.317583] Call Trace:
[ 2037.317590]  [<ffffffffa0ba867d>] :ir_core:ir_input_register+0x1b5/0x1fc
[ 2037.317603]  [<ffffffffa0bed099>] :em28xx:em28xx_ir_init+0x1af/0x1e0
[ 2037.317614]  [<ffffffffa0bea369>] :em28xx:em28xx_card_setup+0xd25/0xd31
[ 2037.317627]  [<ffffffffa01a8270>] :i2c_core:i2c_transfer+0x7b/0x86
[ 2037.317639]  [<ffffffffa0be8e8e>] :em28xx:em28xx_i2c_register+0x389/0x3e7
[ 2037.317648]  [<ffffffffa0be9157>] :em28xx:em28xx_tuner_callback+0x0/0x1c
[ 2037.317660]  [<ffffffffa0beaa36>] :em28xx:em28xx_usb_probe+0x6c1/0x8a3
[ 2037.317665]  [<ffffffff8031a975>] idr_get_empty_slot+0x15c/0x228
[ 2037.317686]  [<ffffffff80392361>] usb_match_one_id+0x26/0x82
[ 2037.317693]  [<ffffffff803932ed>] usb_probe_interface+0xd4/0x10e
[ 2037.317701]  [<ffffffff80385614>] driver_probe_device+0xd0/0x14d
[ 2037.317705]  [<ffffffff803856d7>] __driver_attach+0x46/0x6d
[ 2037.317709]  [<ffffffff80385691>] __driver_attach+0x0/0x6d
[ 2037.317712]  [<ffffffff80384db7>] bus_for_each_dev+0x44/0x6f
[ 2037.317719]  [<ffffffff803851ed>] bus_add_driver+0xb4/0x203
[ 2037.317723]  [<ffffffff8021a0c6>] do_flush_tlb_all+0x0/0x28
[ 2037.317730]  [<ffffffff80385933>] driver_register+0x8d/0x101
[ 2037.317737]  [<ffffffff80392eaa>] usb_register_driver+0x7e/0xe0
[ 2037.317746]  [<ffffffffa00e601b>] :em28xx:em28xx_module_init+0x1b/0x43
[ 2037.317752]  [<ffffffff802550fd>] sys_init_module+0x191b/0x1ab1
[ 2037.317767]  [<ffffffffa0bac458>] :videobuf_core:videobuf_mmap_free+0x0/0x2b
[ 2037.317784]  [<ffffffff8020beca>] system_call_after_swapgs+0x8a/0x8f
[ 2037.317793] 
[ 2037.317794] 
[ 2037.317795] Code: ba a0 41 8b 95 00 09 00 00 41 89 c1 48 8b 3d 0c 26 00 00 49 c7 c0 a3 8c ba a0 4c 89 e1 31 f6 31 c0 e8 f2 b3 7d df 49 89 44 24 48 <48> 8b b0 f0 00 00 00 48 8d 98 f0 00 00 00 48 c7 c7 ab 8c ba a0 
[ 2037.317822] RIP  [<ffffffffa0ba891c>] :ir_core:ir_register_class+0x61/0xc5
[ 2037.317827]  RSP <ffff81007c973978>
[ 2037.317829] CR2: 00000000000000da
[ 2037.317832] ---[ end trace 4f0e1610015f4b9d ]---

--=-iPKR2PKz0qCy576APv03--

