Return-path: <linux-media-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52848 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2DDHQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2012 03:16:28 -0400
Received: from pat.hrz.tu-chemnitz.de ([134.109.133.4] helo=mailbox.hrz.tu-chemnitz.de)
	by nick.hrz.tu-chemnitz.de with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <jens.reimann@s2003.tu-chemnitz.de>)
	id 1SFKS7-0004yy-6y
	for linux-media@vger.kernel.org; Wed, 04 Apr 2012 09:16:27 +0200
Received: from boogie.hrz.tu-chemnitz.de ([134.109.133.10] helo=localhost)
	by mailbox.hrz.tu-chemnitz.de with esmtp (Exim 4.76)
	(envelope-from <jens.reimann@s2003.tu-chemnitz.de>)
	id 1SFKS7-0003nG-4i
	for linux-media@vger.kernel.org; Wed, 04 Apr 2012 09:16:23 +0200
Message-ID: <20120404091623.71588ruvviuzezbb@mail.tu-chemnitz.de>
Date: Wed, 04 Apr 2012 09:16:23 +0200
From: Jens Reimann <jens.reimann@s2003.tu-chemnitz.de>
To: linux-media@vger.kernel.org
Subject: tm6000: HVR-900H analog mode
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
there seems to be a problem in the tm6000 driver for the Hauppauge  
HVR-900H device (USBID: 2040:6600, model: 66009) in analog mode  
(Germany: PAL-BG). There is no picture and the sound stops a few  
milliseconds after switching the channel (tried with tvtime 1.0.3).  
MPlayer and xawtv do not work either. I tried several kernel staring  
from 2.6.38 to 3.3.0 without success. There is also an error message  
concerning the ir code (see dmesg output). I tried tvtime with ir  
disable as well as audio disable without luck. This could mean that  
these modules do not cause the problem.
May this card needs another version of the firmware code? IMHO, this  
could cause the problem for analog mode and for ir.
Thanks for any advice where to look further or what to try next.

Details:

md5sum of the firmware:
5260975b76ade7a1d37270129b6d6372  /lib/firmware/xc3028L-v36.fw

lsusb -v:

Bus 002 Device 002: ID 2040:6600 Hauppauge
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2040 Hauppauge
   idProduct          0x6600
   bcdDevice            0.69
   iManufacturer          16
   iProduct               32 HVR900H
   iSerial                64 4032338328
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength          129
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration         48 2.??
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       1
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       2
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0004  1x 4 bytes
         bInterval               1
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       3
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol    255
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            1
           Transfer Type            Isochronous
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x1400  3x 1024 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0000  1x 0 bytes
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
Device Status:     0x0002
   (Bus Powered)
   Remote Wakeup Enabled


dmesg after connect:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.3.0-030300-generic (apw@gomeisa) (gcc  
version 4.4.3 (Ubuntu 4.4.3-4ubuntu5.1) ) #201203182135 SMP Mon Mar 19  
01:36:20 UTC 2012
[    0.000000] Command line:  
root=UUID=78498293-0d9f-4bbb-80a2-243811e8832a ro quiet splash  
locale=de_DE  crashkernel=384M-2G:64M,2G-:128M
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df66d800 (usable)
[    0.000000]  BIOS-e820: 00000000df66d800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Dell Inc. Inspiron 1525                   /0WP007,  
BIOS A17 10/27/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000  
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new  
0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 512MB, type WB
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 3576MB, range: 8MB, type UC
[    0.000000] reg 5, base: 3575MB, range: 1MB, type UC
[    0.000000] total RAM covered: 7671M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 5  	lose  
cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 3575MB, range: 1MB, type UC
[    0.000000] reg 2, base: 3576MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 4, base: 4GB, range: 4GB, type WB
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000  
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf66d max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000df66d000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df66d000 page 4k
[    0.000000] kernel direct mapping tables up to df66d000 @ 1fffa000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @  
df667000-df66d000
[    0.000000] RAMDISK: 36be9000 - 37ff0000
[    0.000000] Reserving 128MB of memory at 736MB for crashkernel  
(System RAM: 4608MB)
[    0.000000] ACPI: RSDP 00000000000fbc60 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df66f200 00064 (v01 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: FACP 00000000df66f09c 000F4 (v04 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df66f800 05477 (v02 INT430 SYSFexxx  
00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df67e000 00040
[    0.000000] ACPI: HPET 00000000df66f300 00038 (v01 DELL    M08      
00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df66f400 00068 (v01 DELL    M08      
27D90A1B ASL  00000047)
[    0.000000] ACPI: MCFG 00000000df66f3c0 0003E (v16 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: SLIC 00000000df66f49c 00176 (v01 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: OSFR 00000000df66ea00 0002C (v01 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: BOOT 00000000df66efc0 00028 (v01 DELL    M08      
27D90A1B ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df66da44 004CC (v01  PmRef    CpuPm  
00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [000000011fffb000 - 000000011fffffff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD ->  
[ffff88011b600000-ffff88011f5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] Early memory PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df66d
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1046012
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3914 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 894637 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 129024 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 -  
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -  
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df66d000 -  
00000000df66e000
[    0.000000] PM: Registered nosave memory: 00000000df66e000 -  
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 -  
00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 -  
00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 -  
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 -  
00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 -  
00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 -  
00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 -  
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 -  
00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 -  
00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 -  
00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 -  
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 -  
00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 -  
00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 -  
0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap:  
e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256  
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fc00000 s82624  
r8192 d23872 u1048576
[    0.000000] pcpu-alloc: s82624 r8192 d23872 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.   
Total pages: 1027575
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:  
root=UUID=78498293-0d9f-4bbb-80a2-243811e8832a ro quiet splash  
locale=de_DE  crashkernel=384M-2G:64M,2G-:128M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3884856k/4718592k available (6579k kernel code,  
534544k absent, 299192k reserved, 6549k data, 912k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,  
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't  
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1662.669 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated  
using timer frequency.. 3325.33 BogoMIPS (lpj=6650676)
[    0.004012] pid_max: default: 32768 minimum: 301
[    0.004047] Security Framework initialized
[    0.004069] AppArmor: AppArmor initialized
[    0.004650] Dentry cache hash table entries: 524288 (order: 10,  
4194304 bytes)
[    0.009253] Inode-cache hash table entries: 262144 (order: 9,  
2097152 bytes)
[    0.010486] Mount-cache hash table entries: 256
[    0.010695] Initializing cgroup subsys cpuacct
[    0.010700] Initializing cgroup subsys memory
[    0.010714] Initializing cgroup subsys devices
[    0.010717] Initializing cgroup subsys freezer
[    0.010720] Initializing cgroup subsys blkio
[    0.010729] Initializing cgroup subsys perf_event
[    0.010773] CPU: Physical Processor ID: 0
[    0.010776] CPU: Processor Core ID: 0
[    0.010779] mce: CPU supports 6 MCE banks
[    0.010790] CPU0: Thermal monitoring enabled (TM2)
[    0.010796] using mwait in idle threads.
[    0.014795] ACPI: Core revision 20120111
[    0.020014] ftrace: allocating 25267 entries in 99 pages
[    0.032578] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.075202] CPU0: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz  
stepping 0d
[    0.076004] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.076004] PEBS disabled due to CPU errata.
[    0.076004] ... version:                2
[    0.076004] ... bit width:              40
[    0.076004] ... generic registers:      2
[    0.076004] ... value mask:             000000ffffffffff
[    0.076004] ... max period:             000000007fffffff
[    0.076004] ... fixed-purpose events:   3
[    0.076004] ... event mask:             0000000700000003
[    0.076004] NMI watchdog enabled, takes one hw-pmu counter.
[    0.076004] Booting Node   0, Processors  #1 Ok.
[    0.076004] smpboot cpu 1: start_ip = 9a000
[    0.084047] NMI watchdog enabled, takes one hw-pmu counter.
[    0.084100] Brought up 2 CPUs
[    0.084104] Total of 2 processors activated (6650.67 BogoMIPS).
[    0.088801] devtmpfs: initialized
[    0.094716] EVM: security.selinux
[    0.094719] EVM: security.SMACK64
[    0.094721] EVM: security.capability
[    0.094736] print_constraints: dummy:
[    0.094736] RTC time:  6:32:04, date: 04/04/12
[    0.094736] NET: Registered protocol family 16
[    0.094736] ACPI: bus type pci registered
[    0.094736] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem  
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.094736] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.104904] PCI: Using configuration type 1 for base access
[    0.104914] dmi type 0xB1 record - unknown flag
[    0.108047] bio: create slab <bio-0> at 0
[    0.108067] ACPI: Added _OSI(Module Device)
[    0.108070] ACPI: Added _OSI(Processor Device)
[    0.108073] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.108076] ACPI: Added _OSI(Processor Aggregator Device)
[    0.109586] ACPI: EC: Look up EC in DSDT
[    0.118021] ACPI: SSDT 00000000df66e57a 00202 (v01  PmRef  Cpu0Ist  
00003000 INTL 20050624)
[    0.118397] ACPI: Dynamic OEM Table Load:
[    0.118402] ACPI: SSDT           (null) 00202 (v01  PmRef  Cpu0Ist  
00003000 INTL 20050624)
[    0.118543] ACPI: SSDT 00000000df66df10 005E5 (v01  PmRef  Cpu0Cst  
00003001 INTL 20050624)
[    0.118899] ACPI: Dynamic OEM Table Load:
[    0.118903] ACPI: SSDT           (null) 005E5 (v01  PmRef  Cpu0Cst  
00003001 INTL 20050624)
[    0.119144] ACPI: SSDT 00000000df66e77c 000C4 (v01  PmRef  Cpu1Ist  
00003000 INTL 20050624)
[    0.119510] ACPI: Dynamic OEM Table Load:
[    0.119515] ACPI: SSDT           (null) 000C4 (v01  PmRef  Cpu1Ist  
00003000 INTL 20050624)
[    0.119608] ACPI: SSDT 00000000df66e4f5 00085 (v01  PmRef  Cpu1Cst  
00003000 INTL 20050624)
[    0.119966] ACPI: Dynamic OEM Table Load:
[    0.119970] ACPI: SSDT           (null) 00085 (v01  PmRef  Cpu1Cst  
00003000 INTL 20050624)
[    0.120199] ACPI: Interpreter enabled
[    0.120204] ACPI: (supports S0 S3 S4 S5)
[    0.120226] ACPI: Using IOAPIC for interrupt routing
[    0.155611] ACPI: No dock devices found.
[    0.155618] PCI: Using host bridge windows from ACPI; if necessary,  
use "pci=nocrs" and report a bug
[    0.165477] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.185038] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.185043] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.185047] pci_root PNP0A03:00: host bridge window [mem  
0x000a0000-0x000bffff]
[    0.185050] pci_root PNP0A03:00: host bridge window [mem  
0x000d0000-0x000dffff]
[    0.185054] pci_root PNP0A03:00: host bridge window [mem  
0xe0000000-0xf7ffffff]
[    0.185058] pci_root PNP0A03:00: host bridge window [mem  
0xfc000000-0xfebfffff]
[    0.185061] pci_root PNP0A03:00: host bridge window [mem  
0xfec10000-0xfecfffff]
[    0.185065] pci_root PNP0A03:00: host bridge window [mem  
0xfed1c000-0xfed1ffff]
[    0.185068] pci_root PNP0A03:00: host bridge window [mem  
0xfed90000-0xfed9ffff]
[    0.185071] pci_root PNP0A03:00: host bridge window [mem  
0xfeda7000-0xfedfffff]
[    0.185075] pci_root PNP0A03:00: host bridge window [mem  
0xfee10000-0xff9fffff]
[    0.185078] pci_root PNP0A03:00: host bridge window [mem  
0xffc00000-0xffdfffff]
[    0.185082] pci_root PNP0A03:00: host bridge window [mem  
0x120000000-0x317ffffff]
[    0.185144] PCI host bridge to bus 0000:00
[    0.185148] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.185151] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.185154] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.185158] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
[    0.185161] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
[    0.185164] pci_bus 0000:00: root bus resource [mem 0xfc000000-0xfebfffff]
[    0.185168] pci_bus 0000:00: root bus resource [mem 0xfec10000-0xfecfffff]
[    0.185171] pci_bus 0000:00: root bus resource [mem 0xfed1c000-0xfed1ffff]
[    0.185174] pci_bus 0000:00: root bus resource [mem 0xfed90000-0xfed9ffff]
[    0.185177] pci_bus 0000:00: root bus resource [mem 0xfeda7000-0xfedfffff]
[    0.185180] pci_bus 0000:00: root bus resource [mem 0xfee10000-0xff9fffff]
[    0.185184] pci_bus 0000:00: root bus resource [mem 0xffc00000-0xffdfffff]
[    0.185187] pci_bus 0000:00: root bus resource [mem  
0x120000000-0x317ffffff]
[    0.185202] pci 0000:00:00.0: [8086:2a00] type 0 class 0x000600
[    0.185266] pci 0000:00:02.0: [8086:2a02] type 0 class 0x000300
[    0.185284] pci 0000:00:02.0: reg 10: [mem 0xfea00000-0xfeafffff 64bit]
[    0.185296] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff  
64bit pref]
[    0.185305] pci 0000:00:02.0: reg 20: [io  0xeff8-0xefff]
[    0.185355] pci 0000:00:02.1: [8086:2a03] type 0 class 0x000380
[    0.185371] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfebfffff 64bit]
[    0.185482] pci 0000:00:1a.0: [8086:2834] type 0 class 0x000c03
[    0.185548] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.185598] pci 0000:00:1a.1: [8086:2835] type 0 class 0x000c03
[    0.185664] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.185731] pci 0000:00:1a.7: [8086:283a] type 0 class 0x000c03
[    0.185760] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.185883] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.185927] pci 0000:00:1b.0: [8086:284b] type 0 class 0x000403
[    0.185953] pci 0000:00:1b.0: reg 10: [mem 0xfe9fc000-0xfe9fffff 64bit]
[    0.186074] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.186114] pci 0000:00:1c.0: [8086:283f] type 1 class 0x000604
[    0.186241] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.186283] pci 0000:00:1c.1: [8086:2841] type 1 class 0x000604
[    0.186410] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.186456] pci 0000:00:1c.4: [8086:2847] type 1 class 0x000604
[    0.186583] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.186624] pci 0000:00:1d.0: [8086:2830] type 0 class 0x000c03
[    0.186689] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.186740] pci 0000:00:1d.1: [8086:2831] type 0 class 0x000c03
[    0.186805] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.186856] pci 0000:00:1d.2: [8086:2832] type 0 class 0x000c03
[    0.186921] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.186988] pci 0000:00:1d.7: [8086:2836] type 0 class 0x000c03
[    0.187016] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.187139] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.187174] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.187288] pci 0000:00:1f.0: [8086:2815] type 0 class 0x000601
[    0.187415] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by  
ICH6 ACPI/GPIO/TCO
[    0.187423] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by  
ICH6 GPIO
[    0.187429] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at  
0900 (mask 007f)
[    0.187435] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at  
006c (mask 0007)
[    0.187441] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at  
0c80 (mask 003f)
[    0.187507] pci 0000:00:1f.1: [8086:2850] type 0 class 0x000101
[    0.187527] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.187542] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.187556] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.187571] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.187585] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.187649] pci 0000:00:1f.2: [8086:2829] type 0 class 0x000106
[    0.187680] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.187695] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.187709] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.187723] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.187738] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.187752] pci 0000:00:1f.2: reg 24: [mem 0xfe9fb800-0xfe9fbfff]
[    0.187829] pci 0000:00:1f.2: PME# supported from D3hot
[    0.187859] pci 0000:00:1f.3: [8086:283e] type 0 class 0x000c05
[    0.188025] pci 0000:00:1f.3: reg 10: [mem 0xfe9fb700-0xfe9fb7ff]
[    0.188074] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.188223] pci 0000:09:00.0: [11ab:4354] type 0 class 0x000200
[    0.188262] pci 0000:09:00.0: reg 10: [mem 0xfe8fc000-0xfe8fffff 64bit]
[    0.188283] pci 0000:09:00.0: reg 18: [io  0xde00-0xdeff]
[    0.188449] pci 0000:09:00.0: supports D1 D2
[    0.188452] pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.196038] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.196046] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.196052] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.196238] pci 0000:0b:00.0: [8086:4222] type 0 class 0x000280
[    0.196297] pci 0000:0b:00.0: reg 10: [mem 0xfe7ff000-0xfe7fffff]
[    0.196733] pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
[    0.196817] pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe  
device.  You can enable it with 'pcie_aspm=force'
[    0.196848] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.196857] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.196936] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.196942] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.196949] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe6fffff]
[    0.196959] pci 0000:00:1c.4:   bridge window [mem  
0xf0000000-0xf01fffff 64bit pref]
[    0.197030] pci 0000:02:09.0: [1180:0832] type 0 class 0x000c00
[    0.197058] pci 0000:02:09.0: reg 10: [mem 0xfe3ff800-0xfe3fffff]
[    0.197173] pci 0000:02:09.0: supports D1 D2
[    0.197175] pci 0000:02:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197208] pci 0000:02:09.1: [1180:0822] type 0 class 0x000805
[    0.197235] pci 0000:02:09.1: reg 10: [mem 0xfe3ff500-0xfe3ff5ff]
[    0.197350] pci 0000:02:09.1: supports D1 D2
[    0.197353] pci 0000:02:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197383] pci 0000:02:09.2: [1180:0592] type 0 class 0x000880
[    0.197409] pci 0000:02:09.2: reg 10: [mem 0xfe3ff600-0xfe3ff6ff]
[    0.197523] pci 0000:02:09.2: supports D1 D2
[    0.197525] pci 0000:02:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197555] pci 0000:02:09.3: [1180:0852] type 0 class 0x000880
[    0.197581] pci 0000:02:09.3: reg 10: [mem 0xfe3ff700-0xfe3ff7ff]
[    0.197695] pci 0000:02:09.3: supports D1 D2
[    0.197698] pci 0000:02:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.197767] pci 0000:00:1e.0: PCI bridge to [bus 02-02]  
(subtractive decode)
[    0.197777] pci 0000:00:1e.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.197788] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7]  
(subtractive decode)
[    0.197791] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff]  
(subtractive decode)
[    0.197795] pci 0000:00:1e.0:   bridge window [mem  
0x000a0000-0x000bffff] (subtractive decode)
[    0.197802] pci 0000:00:1e.0:   bridge window [mem  
0x000d0000-0x000dffff] (subtractive decode)
[    0.197806] pci 0000:00:1e.0:   bridge window [mem  
0xe0000000-0xf7ffffff] (subtractive decode)
[    0.197810] pci 0000:00:1e.0:   bridge window [mem  
0xfc000000-0xfebfffff] (subtractive decode)
[    0.197814] pci 0000:00:1e.0:   bridge window [mem  
0xfec10000-0xfecfffff] (subtractive decode)
[    0.197817] pci 0000:00:1e.0:   bridge window [mem  
0xfed1c000-0xfed1ffff] (subtractive decode)
[    0.197821] pci 0000:00:1e.0:   bridge window [mem  
0xfed90000-0xfed9ffff] (subtractive decode)
[    0.197825] pci 0000:00:1e.0:   bridge window [mem  
0xfeda7000-0xfedfffff] (subtractive decode)
[    0.197829] pci 0000:00:1e.0:   bridge window [mem  
0xfee10000-0xff9fffff] (subtractive decode)
[    0.197833] pci 0000:00:1e.0:   bridge window [mem  
0xffc00000-0xffdfffff] (subtractive decode)
[    0.197836] pci 0000:00:1e.0:   bridge window [mem  
0x120000000-0x317ffffff] (subtractive decode)
[    0.197871] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.198115] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.198226] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.198282] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.198340] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.198392]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.198396]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND),  
returned control mask: 0x1d
[    0.198399] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.208988] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.209073] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[    0.209153] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *5
[    0.209222] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *0,  
disabled.
[    0.209304] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10  
11 12 14 15)
[    0.209387] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10  
11 12 14 15)
[    0.209471] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10  
11 12 14 15)
[    0.209549] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11  
12 14 15) *0, disabled.
[    0.212037] vgaarb: device added:  
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.212054] vgaarb: loaded
[    0.212056] vgaarb: bridge control possible 0000:00:02.0
[    0.212271] SCSI subsystem initialized
[    0.212285] libata version 3.00 loaded.
[    0.212285] usbcore: registered new interface driver usbfs
[    0.212285] usbcore: registered new interface driver hub
[    0.212285] usbcore: registered new device driver usb
[    0.212285] PCI: Using ACPI for IRQ routing
[    0.216616] PCI: pci_cache_line_size set to 64 bytes
[    0.216763] reserve RAM buffer: 000000000009f000 - 000000000009ffff
[    0.216766] reserve RAM buffer: 00000000df66d800 - 00000000dfffffff
[    0.216912] NetLabel: Initializing
[    0.216914] NetLabel:  domain hash size = 128
[    0.216917] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.216933] NetLabel:  unlabeled traffic allowed by default
[    0.216952] HPET: 3 timers in total, 0 timers will be used for  
per-cpu timer
[    0.216952] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.216952] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.220036] Switching to clocksource hpet
[    0.230964] AppArmor: AppArmor Filesystem Enabled
[    0.231011] pnp: PnP ACPI init
[    0.231035] ACPI: bus type pnp registered
[    0.240668] pnp 00:00: [bus 00-ff]
[    0.240673] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.240676] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.240679] pnp 00:00: [io  0x0d00-0xffff window]
[    0.240683] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.240686] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.240689] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    0.240692] pnp 00:00: [mem 0xfc000000-0xfebfffff window]
[    0.240695] pnp 00:00: [mem 0xfec10000-0xfecfffff window]
[    0.240698] pnp 00:00: [mem 0xfed1c000-0xfed1ffff window]
[    0.240706] pnp 00:00: [mem 0xfed90000-0xfed9ffff window]
[    0.240709] pnp 00:00: [mem 0xfeda7000-0xfedfffff window]
[    0.240712] pnp 00:00: [mem 0xfee10000-0xff9fffff window]
[    0.240715] pnp 00:00: [mem 0xffc00000-0xffdfffff window]
[    0.240718] pnp 00:00: [mem 0x120000000-0x317ffffff window]
[    0.240824] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.240841] pnp 00:01: [io  0x004e-0x004f]
[    0.240844] pnp 00:01: [io  0x0068-0x006f]
[    0.240846] pnp 00:01: [mem 0xff800000-0xff8fffff]
[    0.240849] pnp 00:01: [mem 0xffc00000-0xffcfffff]
[    0.240936] system 00:01: [mem 0xff800000-0xff8fffff] has been reserved
[    0.240945] system 00:01: [mem 0xffc00000-0xffcfffff] has been reserved
[    0.240950] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.240986] pnp 00:02: [irq 12]
[    0.241018] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.241038] pnp 00:03: [io  0x0060]
[    0.241041] pnp 00:03: [io  0x0064]
[    0.241043] pnp 00:03: [io  0x0062]
[    0.241046] pnp 00:03: [io  0x0066]
[    0.241053] pnp 00:03: [irq 1]
[    0.241088] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.241107] pnp 00:04: [io  0x0070-0x0071]
[    0.241115] pnp 00:04: [irq 8]
[    0.241118] pnp 00:04: [io  0x0072-0x0077]
[    0.241153] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.241174] pnp 00:05: [io  0x0061]
[    0.241177] pnp 00:05: [io  0x0063]
[    0.241180] pnp 00:05: [io  0x0065]
[    0.241182] pnp 00:05: [io  0x0067]
[    0.241217] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.241236] pnp 00:06: [io  0x0c80-0x0cff]
[    0.241299] system 00:06: [io  0x0c80-0x0cff] could not be reserved
[    0.241304] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.241327] pnp 00:07: [dma 4]
[    0.241330] pnp 00:07: [io  0x0000-0x000f]
[    0.241333] pnp 00:07: [io  0x0080-0x0085]
[    0.241336] pnp 00:07: [io  0x0087-0x008f]
[    0.241338] pnp 00:07: [io  0x00c0-0x00df]
[    0.241341] pnp 00:07: [io  0x0010-0x001f]
[    0.241344] pnp 00:07: [io  0x0090-0x0091]
[    0.241346] pnp 00:07: [io  0x0093-0x009f]
[    0.241384] pnp 00:07: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.241404] pnp 00:08: [io  0x00f0-0x00ff]
[    0.241411] pnp 00:08: [irq 13]
[    0.241448] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.241494] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    0.241556] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.241561] system 00:09: Plug and Play ACPI device, IDs PNP0103  
PNP0c01 (active)
[    0.241716] pnp 00:0a: [io  0x0900-0x097f]
[    0.241719] pnp 00:0a: [io  0x0092]
[    0.241722] pnp 00:0a: [io  0x00b2-0x00b3]
[    0.241724] pnp 00:0a: [io  0x0020-0x0021]
[    0.241727] pnp 00:0a: [io  0x00a0-0x00a1]
[    0.241730] pnp 00:0a: [irq 0 disabled]
[    0.241733] pnp 00:0a: [io  0x04d0-0x04d1]
[    0.241735] pnp 00:0a: [io  0x1000-0x1005]
[    0.241741] pnp 00:0a: [io  0x1008-0x100f]
[    0.241764] pnp 00:0a: disabling [io  0x1000-0x1005] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.241769] pnp 00:0a: disabling [io  0x1008-0x100f] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.241842] system 00:0a: [io  0x0900-0x097f] has been reserved
[    0.241846] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.241851] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.241872] pnp 00:0b: [io  0xf400-0xf4fe]
[    0.241875] pnp 00:0b: [io  0x0086]
[    0.241877] pnp 00:0b: [io  0x1006-0x1007]
[    0.241880] pnp 00:0b: [io  0x100a-0x1059]
[    0.241882] pnp 00:0b: [io  0x1060-0x107f]
[    0.241885] pnp 00:0b: [io  0x1080-0x10bf]
[    0.241888] pnp 00:0b: [io  0x10c0-0x10df]
[    0.241890] pnp 00:0b: [io  0x1010-0x102f]
[    0.241893] pnp 00:0b: [io  0x0809]
[    0.241914] pnp 00:0b: disabling [io  0x1006-0x1007] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.241918] pnp 00:0b: disabling [io  0x100a-0x1059] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.241923] pnp 00:0b: disabling [io  0x1060-0x107f] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.241928] pnp 00:0b: disabling [io  0x1010-0x102f] because it  
overlaps 0000:00:1f.0 BAR 13 [io  0x1000-0x107f]
[    0.242003] system 00:0b: [io  0xf400-0xf4fe] has been reserved
[    0.242007] system 00:0b: [io  0x1080-0x10bf] has been reserved
[    0.242011] system 00:0b: [io  0x10c0-0x10df] has been reserved
[    0.242015] system 00:0b: [io  0x0809] has been reserved
[    0.242020] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.253491] pnp 00:0c: [mem 0x00000000-0x0009efff]
[    0.253495] pnp 00:0c: [mem 0x0009f000-0x0009ffff]
[    0.253499] pnp 00:0c: [mem 0x000c0000-0x000cffff]
[    0.253501] pnp 00:0c: [mem 0x000e0000-0x000fffff]
[    0.253504] pnp 00:0c: [mem 0x00100000-0xdf66d7ff]
[    0.253507] pnp 00:0c: [mem 0xdf66d800-0xdf6fffff]
[    0.253510] pnp 00:0c: [mem 0xdf700000-0xdf7fffff]
[    0.253513] pnp 00:0c: [mem 0xdf700000-0xdfefffff]
[    0.253516] pnp 00:0c: [mem 0xffe00000-0xffffffff]
[    0.253518] pnp 00:0c: [mem 0xffa00000-0xffbfffff]
[    0.253521] pnp 00:0c: [mem 0xfec00000-0xfec0ffff]
[    0.253524] pnp 00:0c: [mem 0xfee00000-0xfee0ffff]
[    0.253527] pnp 00:0c: [mem 0xfed20000-0xfed8ffff]
[    0.253530] pnp 00:0c: [mem 0xfeda0000-0xfeda3fff]
[    0.253532] pnp 00:0c: [mem 0xfeda4000-0xfeda4fff]
[    0.253535] pnp 00:0c: [mem 0xfeda5000-0xfeda5fff]
[    0.253538] pnp 00:0c: [mem 0xfeda6000-0xfeda6fff]
[    0.253541] pnp 00:0c: [mem 0xfed18000-0xfed1bfff]
[    0.253544] pnp 00:0c: [mem 0xf8000000-0xfbffffff]
[    0.253659] system 00:0c: [mem 0x00000000-0x0009efff] could not be reserved
[    0.253664] system 00:0c: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.253668] system 00:0c: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.253672] system 00:0c: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.253676] system 00:0c: [mem 0x00100000-0xdf66d7ff] could not be reserved
[    0.253680] system 00:0c: [mem 0xdf66d800-0xdf6fffff] has been reserved
[    0.253684] system 00:0c: [mem 0xdf700000-0xdf7fffff] has been reserved
[    0.253687] system 00:0c: [mem 0xdf700000-0xdfefffff] could not be reserved
[    0.253691] system 00:0c: [mem 0xffe00000-0xffffffff] has been reserved
[    0.253695] system 00:0c: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.253699] system 00:0c: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.253703] system 00:0c: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.253707] system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.253711] system 00:0c: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.253715] system 00:0c: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.253719] system 00:0c: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.253722] system 00:0c: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.253726] system 00:0c: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.253730] system 00:0c: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.253735] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.253804] pnp: PnP ACPI: found 13 devices
[    0.253806] ACPI: ACPI bus type pnp unregistered
[    0.261681] PCI: max bus depth: 1 pci_try_num: 2
[    0.261742] pci 0000:00:1c.1: BAR 15: assigned [mem  
0xf0200000-0xf03fffff 64bit pref]
[    0.261748] pci 0000:00:1c.1: BAR 13: assigned [io  0x2000-0x2fff]
[    0.261753] pci 0000:00:1c.0: BAR 15: assigned [mem  
0xf0400000-0xf05fffff 64bit pref]
[    0.261758] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    0.261763] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.261771] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.261777] pci 0000:00:1c.0:   bridge window [mem  
0xf0400000-0xf05fffff 64bit pref]
[    0.261788] pci 0000:00:1c.1: PCI bridge to [bus 0b-0b]
[    0.261792] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
[    0.261800] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.261807] pci 0000:00:1c.1:   bridge window [mem  
0xf0200000-0xf03fffff 64bit pref]
[    0.261817] pci 0000:00:1c.4: PCI bridge to [bus 0c-0d]
[    0.261822] pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
[    0.261830] pci 0000:00:1c.4:   bridge window [mem 0xfe400000-0xfe6fffff]
[    0.261837] pci 0000:00:1c.4:   bridge window [mem  
0xf0000000-0xf01fffff 64bit pref]
[    0.261847] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.261855] pci 0000:00:1e.0:   bridge window [mem 0xfe300000-0xfe3fffff]
[    0.261910] pci 0000:00:1e.0: setting latency timer to 64
[    0.261916] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.261920] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.261923] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.261926] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.261930] pci_bus 0000:00: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.261933] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.261936] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.261939] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.261943] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.261946] pci_bus 0000:00: resource 13 [mem 0xfeda7000-0xfedfffff]
[    0.261950] pci_bus 0000:00: resource 14 [mem 0xfee10000-0xff9fffff]
[    0.261953] pci_bus 0000:00: resource 15 [mem 0xffc00000-0xffdfffff]
[    0.261956] pci_bus 0000:00: resource 16 [mem 0x120000000-0x317ffffff]
[    0.261960] pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
[    0.261963] pci_bus 0000:09: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.261967] pci_bus 0000:09: resource 2 [mem 0xf0400000-0xf05fffff  
64bit pref]
[    0.261971] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.261974] pci_bus 0000:0b: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.261977] pci_bus 0000:0b: resource 2 [mem 0xf0200000-0xf03fffff  
64bit pref]
[    0.261981] pci_bus 0000:0c: resource 0 [io  0xc000-0xcfff]
[    0.261984] pci_bus 0000:0c: resource 1 [mem 0xfe400000-0xfe6fffff]
[    0.261987] pci_bus 0000:0c: resource 2 [mem 0xf0000000-0xf01fffff  
64bit pref]
[    0.261991] pci_bus 0000:02: resource 1 [mem 0xfe300000-0xfe3fffff]
[    0.261995] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.261998] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.262001] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.262004] pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000dffff]
[    0.262008] pci_bus 0000:02: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.262011] pci_bus 0000:02: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.262015] pci_bus 0000:02: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.262018] pci_bus 0000:02: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.262021] pci_bus 0000:02: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.262025] pci_bus 0000:02: resource 13 [mem 0xfeda7000-0xfedfffff]
[    0.262028] pci_bus 0000:02: resource 14 [mem 0xfee10000-0xff9fffff]
[    0.262032] pci_bus 0000:02: resource 15 [mem 0xffc00000-0xffdfffff]
[    0.262035] pci_bus 0000:02: resource 16 [mem 0x120000000-0x317ffffff]
[    0.262083] NET: Registered protocol family 2
[    0.262287] IP route cache hash table entries: 131072 (order: 8,  
1048576 bytes)
[    0.263912] TCP established hash table entries: 524288 (order: 11,  
8388608 bytes)
[    0.268714] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.269309] TCP: Hash tables configured (established 524288 bind 65536)
[    0.269313] TCP reno registered
[    0.269328] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.269377] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.269541] NET: Registered protocol family 1
[    0.269566] pci 0000:00:02.0: Boot video device
[    0.269900] PCI: CLS 64 bytes, default 64
[    0.269974] Trying to unpack rootfs image as initramfs...
[    0.825558] Freeing initrd memory: 20508k freed
[    0.837220] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.837228] Placing 64MB software IO TLB between ffff8800db667000 -  
ffff8800df667000
[    0.837231] software IO TLB at phys 0xdb667000 - 0xdf667000
[    0.837256] Simple Boot Flag at 0x79 set to 0x1
[    0.837932] audit: initializing netlink socket (disabled)
[    0.837951] type=2000 audit(1333521123.832:1): initialized
[    0.871933] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.875039] VFS: Disk quotas dquot_6.5.2
[    0.875112] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.875797] fuse init (API version 7.18)
[    0.875924] msgmni has been set to 7627
[    0.876452] Block layer SCSI generic (bsg) driver version 0.4  
loaded (major 253)
[    0.876489] io scheduler noop registered
[    0.876492] io scheduler deadline registered
[    0.876569] io scheduler cfq registered (default)
[    0.876791] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.876955] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.877112] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    0.877235] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.877262] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.877334] intel_idle: MWAIT substates: 0x22220
[    0.877337] intel_idle: does not run on family 6 model 15
[    0.877431] ACPI: Deprecated procfs I/F for AC is loaded, please  
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.877492] ACPI: AC Adapter [AC] (on-line)
[    0.877590] input: Lid Switch as  
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.878519] ACPI: Lid Switch [LID]
[    0.878578] input: Power Button as  
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.878584] ACPI: Power Button [PBTN]
[    0.878644] input: Sleep Button as  
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.878648] ACPI: Sleep Button [SBTN]
[    0.878859] Monitor-Mwait will be used to enter C-1 state
[    0.878902] Monitor-Mwait will be used to enter C-2 state
[    0.878941] Monitor-Mwait will be used to enter C-3 state
[    0.878951] Marking TSC unstable due to TSC halts in idle
[    0.878970] ACPI: acpi_idle registered with cpuidle
[    0.880833] thermal LNXTHERM:00: registered as thermal_zone0
[    0.880837] ACPI: Thermal Zone [THM] (55 C)
[    0.880874] GHES: HEST is not enabled!
[    0.888199] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.897565] Linux agpgart interface v0.103
[    0.897822] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    0.898248] agpgart-intel 0000:00:00.0: detected gtt size: 524288K  
total, 262144K mappable
[    0.899340] agpgart-intel 0000:00:00.0: detected 8192K stolen memory
[    0.899660] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.902604] ACPI: Deprecated procfs I/F for battery is loaded,  
please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    0.902625] ACPI: Battery Slot [BAT0] (battery present)
[    0.903608] brd: module loaded
[    0.904672] loop: module loaded
[    0.904849] ahci 0000:00:1f.2: version 3.0
[    0.904928] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.905007] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3  
Gbps 0x5 impl SATA mode
[    0.905013] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio  
slum part ccc ems
[    0.905020] ahci 0000:00:1f.2: setting latency timer to 64
[    0.912449] scsi0 : ahci
[    0.912576] scsi1 : ahci
[    0.912680] scsi2 : ahci
[    0.912855] ata1: SATA max UDMA/133 abar m2048@0xfe9fb800 port  
0xfe9fb900 irq 43
[    0.912858] ata2: DUMMY
[    0.912862] ata3: SATA max UDMA/133 abar m2048@0xfe9fb800 port  
0xfe9fba00 irq 43
[    0.912946] ata_piix 0000:00:1f.1: version 2.13
[    0.912995] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.913417] scsi3 : ata_piix
[    0.913524] scsi4 : ata_piix
[    0.913891] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    0.913895] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    0.913989] ata5: port disabled--ignoring
[    0.914330] Fixed MDIO Bus: probed
[    0.914353] tun: Universal TUN/TAP device driver, 1.6
[    0.914356] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.914543] PPP generic driver version 2.4.2
[    0.914697] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.914743] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.914748] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.914813] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned  
bus number 1
[    0.914855] ehci_hcd 0000:00:1a.7: debug port 1
[    0.918751] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.918771] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    0.928026] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.928193] hub 1-0:1.0: USB hub found
[    0.928199] hub 1-0:1.0: 4 ports detected
[    0.928314] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.928319] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.928382] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned  
bus number 2
[    0.928420] ehci_hcd 0000:00:1d.7: debug port 1
[    0.932302] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.932320] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    0.944025] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.944172] hub 2-0:1.0: USB hub found
[    0.944178] hub 2-0:1.0: 6 ports detected
[    0.944285] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.944302] uhci_hcd: USB Universal Host Controller Interface driver
[    0.944331] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.944335] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.944403] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned  
bus number 3
[    0.944435] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    0.944610] hub 3-0:1.0: USB hub found
[    0.944616] hub 3-0:1.0: 2 ports detected
[    0.944717] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.944722] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.944792] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned  
bus number 4
[    0.944840] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    0.945009] hub 4-0:1.0: USB hub found
[    0.945014] hub 4-0:1.0: 2 ports detected
[    0.945114] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.945119] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.945195] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned  
bus number 5
[    0.945228] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    0.945396] hub 5-0:1.0: USB hub found
[    0.945401] hub 5-0:1.0: 2 ports detected
[    0.945498] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.945503] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.945565] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned  
bus number 6
[    0.945603] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    0.945775] hub 6-0:1.0: USB hub found
[    0.945780] hub 6-0:1.0: 2 ports detected
[    0.945878] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.945883] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.945957] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned  
bus number 7
[    0.945989] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    0.946156] hub 7-0:1.0: USB hub found
[    0.946161] hub 7-0:1.0: 2 ports detected
[    0.946318] usbcore: registered new interface driver libusual
[    0.946385] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M]  
at 0x60,0x64 irq 1,12
[    0.963380] i8042: Detected active multiplexing controller, rev 1.1
[    0.973866] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.973874] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.973916] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.973950] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.973981] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.974151] mousedev: PS/2 mouse device common for all mice
[    0.974656] rtc_cmos 00:04: RTC can wake from S4
[    0.974809] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.974847] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.974962] device-mapper: uevent: version 1.0.3
[    0.975069] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)  
initialised: dm-devel@redhat.com
[    0.975134] cpuidle: using governor ladder
[    0.975212] cpuidle: using governor menu
[    0.975215] EFI Variables Facility v0.08 2004-May-17
[    0.975511] TCP cubic registered
[    0.975663] NET: Registered protocol family 10
[    0.976340] NET: Registered protocol family 17
[    0.976358] Registering the dns_resolver key type
[    0.976568] PM: Hibernation image not present or could not be loaded.
[    0.976587] registered taskstats version 1
[    0.985780]   Magic number: 8:398:518
[    0.985957] rtc_cmos 00:04: setting system clock to 2012-04-04  
06:32:04 UTC (1333521124)
[    0.986880] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.986883] EDD information not available.
[    1.001949] input: AT Translated Set 2 keyboard as  
/devices/platform/i8042/serio0/input/input3
[    1.139643] ata4.00: ATAPI: TSSTcorp DVD+/-RW TS-L632H, D600, max UDMA/33
[    1.168347] ata4.00: configured for UDMA/33
[    1.244074] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.244111] ata3: SATA link down (SStatus 0 SControl 300)
[    1.281439] ata1.00: ATA-8: WDC WD2500BEVS-75UST0, 01.01A01, max UDMA/133
[    1.281447] ata1.00: 488397168 sectors, multi 8: LBA48 NCQ (depth  
31/32), AA
[    1.282397] ata1.00: configured for UDMA/133
[    1.282595] scsi 0:0:0:0: Direct-Access     ATA      WDC  
WD2500BEVS-7 01.0 PQ: 0 ANSI: 5
[    1.282772] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks:  
(250 GB/232 GiB)
[    1.282789] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.282838] sd 0:0:0:0: [sda] Write Protect is off
[    1.282842] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.282898] sd 0:0:0:0: [sda] Write cache: enabled, read cache:  
enabled, doesn't support DPO or FUA
[    1.286531] scsi 3:0:0:0: CD-ROM            TSSTcorp DVD+-RW  
TS-L632H D600 PQ: 0 ANSI: 5
[    1.294063] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw  
xa/form2 cdda tray
[    1.294070] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.294304] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    1.294445] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    1.338998]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.339997] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.342330] Freeing unused kernel memory: 912k freed
[    1.342667] Write protecting the kernel read-only data: 12288k
[    1.350371] Freeing unused kernel memory: 1592k freed
[    1.356927] Freeing unused kernel memory: 1220k freed
[    1.381621] udevd[103]: starting version 175
[    1.474021] wmi: Mapper loaded
[    1.478884] [drm] Initialized drm 1.1.0 20060810
[    1.512826] i915 0000:00:02.0: setting latency timer to 64
[    1.516509] sky2: driver version 1.30
[    1.516601] sky2 0000:09:00.0: Yukon-2 FE+ chip revision 0
[    1.516722] sky2 0000:09:00.0: irq 44 for MSI/MSI-X
[    1.518372] sky2 0000:09:00.0: eth0: addr 00:1d:09:3e:37:f7
[    1.562590] sdhci: Secure Digital Host Controller Interface driver
[    1.562593] sdhci: Copyright(c) Pierre Ossman
[    1.562933] sdhci-pci 0000:02:09.1: SDHCI controller found  
[1180:0822] (rev 22)
[    1.575488] mmc0: no vmmc regulator found
[    1.578539] Registered led device: mmc0::
[    1.580588] mmc0: SDHCI controller on PCI [0000:02:09.1] using DMA
[    1.582339] mtrr: type mismatch for e0000000,10000000 old:  
write-back new: write-combining
[    1.582344] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    1.583513] i915 0000:00:02.0: irq 45 for MSI/MSI-X
[    1.583527] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.583529] [drm] Driver supports precise vblank timestamp query.
[    1.583709] vgaarb: device changed decodes:  
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.636551] fixme: max PWM is zero.
[    1.644121] firewire_ohci: Added fw-ohci device 0000:02:09.0, OHCI  
v1.10, 4 IR + 4 IT contexts, quirks 0x11
[    2.144276] firewire_core: created device fw0: GUID 334fc0002e8b3c70, S400
[    2.177097] [drm] initialized overlay support
[    2.347951] fbcon: inteldrmfb (fb0) is primary device
[    2.682709] Console: switching to colour frame buffer device 160x50
[    2.686137] fb0: inteldrmfb frame buffer device
[    2.686139] drm: registered panic notifier
[    2.697484] acpi device:30: registered as cooling_device2
[    2.697925] input: Video Bus as  
/devices/LNXSYSTM:00/device:00/PNP0A03:00/LNXVIDEO:00/input/input4
[    2.697986] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    2.698009] [Firmware Bug]: Duplicate ACPI video bus devices for  
the same VGA controller, please try module parameter  
"video.allow_duplicates=1"if the current driver doesn't work.
[    2.698613] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0  
on minor 0
[   52.682765] Adding 4000148k swap on /dev/sda6.  Priority:-1  
extents:1 across:4000148k
[   52.728935] udevd[600]: starting version 175
[   53.659794] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   53.875254] device-mapper: multipath: version 1.3.0 loaded
[   53.957553] lp: driver loaded but no devices found
[   53.984219] type=1400 audit(1333521177.497:2): apparmor="STATUS"  
operation="profile_load" name="/sbin/dhclient" pid=909  
comm="apparmor_parser"
[   53.984313] type=1400 audit(1333521177.497:3): apparmor="STATUS"  
operation="profile_load"  
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=909  
comm="apparmor_parser"
[   53.984391] type=1400 audit(1333521177.497:4): apparmor="STATUS"  
operation="profile_load"  
name="/usr/lib/connman/scripts/dhclient-script" pid=909  
comm="apparmor_parser"
[   54.163288] udevd[608]: renamed network interface eth0 to eth1
[   54.321724] dcdbas dcdbas: Dell Systems Management Base Driver  
(version 5.6.0-3.2)
[   54.869939] r592: driver successfully loaded
[   55.073718] cfg80211: Calling CRDA to update world regulatory domain
[   55.082781] cfg80211: World regulatory domain updated:
[   55.082785] cfg80211:   (start_freq - end_freq @ bandwidth),  
(max_antenna_gain, max_eirp)
[   55.082789] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.082793] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),  
(300 mBi, 2000 mBm)
[   55.082797] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),  
(300 mBi, 2000 mBm)
[   55.082801] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.082805] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.086092] cfg80211: World regulatory domain updated:
[   55.086097] cfg80211:   (start_freq - end_freq @ bandwidth),  
(max_antenna_gain, max_eirp)
[   55.086101] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.086105] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),  
(300 mBi, 2000 mBm)
[   55.086109] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),  
(300 mBi, 2000 mBm)
[   55.086113] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.086116] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),  
(300 mBi, 2000 mBm)
[   55.299233] input: PS/2 Mouse as  
/devices/platform/i8042/serio2/input/input5
[   55.325623] input: AlpsPS/2 ALPS GlidePoint as  
/devices/platform/i8042/serio2/input/input6
[   55.357940] input: Dell WMI hotkeys as /devices/virtual/input/input7
[   56.611176] r852: driver loaded successfully
[   56.944361] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network  
Connection driver for Linux, in-tree:s
[   56.944365] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   57.000030] iwl3945 0000:0b:00.0: Tunable channels: 13 802.11bg, 23  
802.11a channels
[   57.000035] iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
[   57.000191] iwl3945 0000:0b:00.0: irq 46 for MSI/MSI-X
[   57.000441] Registered led device: phy0-led
[   57.000515] cfg80211: Ignoring regulatory request Set by core since  
the driver uses its own custom regulatory domain
[   57.111297] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   57.179173] ieee80211 phy0: Selected rate control algorithm 'iwl-3945-rs'
[   57.197218] udevd[611]: renamed network interface wlan0 to wlan1
[   57.292048] HDMI status: Codec=1 Pin=3 Presence_Detect=0 ELD_Valid=0
[   60.632763] init: failsafe main process (1203) killed by TERM signal
[   60.908955] Bluetooth: Core ver 2.16
[   60.908990] NET: Registered protocol family 31
[   60.908993] Bluetooth: HCI device and connection manager initialized
[   60.909240] Bluetooth: HCI socket layer initialized
[   60.909247] Bluetooth: L2CAP socket layer initialized
[   60.909255] Bluetooth: SCO socket layer initialized
[   61.016410] Bluetooth: RFCOMM TTY layer initialized
[   61.016417] Bluetooth: RFCOMM socket layer initialized
[   61.016420] Bluetooth: RFCOMM ver 1.11
[   61.169601] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   61.169605] Bluetooth: BNEP filters: protocol multicast
[   61.464191] input: HDA Intel HDMI/DP,pcm=3 as  
/devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   61.568312] sky2 0000:09:00.0: eth1: enabling interface
[   61.569027] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   61.989568] ppdev: user-space parallel port driver
[   62.039461] type=1400 audit(1333521185.549:5): apparmor="STATUS"  
operation="profile_replace" name="/sbin/dhclient" pid=1284  
comm="apparmor_parser"
[   62.039569] type=1400 audit(1333521185.549:6): apparmor="STATUS"  
operation="profile_replace"  
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1284  
comm="apparmor_parser"
[   62.039649] type=1400 audit(1333521185.549:7): apparmor="STATUS"  
operation="profile_replace"  
name="/usr/lib/connman/scripts/dhclient-script" pid=1284  
comm="apparmor_parser"
[   62.652958] type=1400 audit(1333521186.165:8): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/freshclam" pid=1325  
comm="apparmor_parser"
[   62.872107] type=1400 audit(1333521186.385:9): apparmor="STATUS"  
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf"  
pid=1320 comm="apparmor_parser"
[   62.872320] type=1400 audit(1333521186.385:10): apparmor="STATUS"  
operation="profile_load" name="/usr/sbin/cupsd" pid=1320  
comm="apparmor_parser"
[   63.921190] type=1400 audit(1333521187.433:11): apparmor="STATUS"  
operation="profile_load" name="/usr/lib/telepathy/mission-control-5"  
pid=1326 comm="apparmor_parser"
[   63.921454] type=1400 audit(1333521187.433:12): apparmor="STATUS"  
operation="profile_load" name="/usr/lib/telepathy/telepathy-*"  
pid=1326 comm="apparmor_parser"
[   64.824692] type=1400 audit(1333521188.337:13): apparmor="STATUS"  
operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf"  
pid=1337 comm="apparmor_parser"
[   64.824951] type=1400 audit(1333521188.337:14): apparmor="STATUS"  
operation="profile_replace" name="/usr/sbin/cupsd" pid=1337  
comm="apparmor_parser"
[   73.037605] audit_printk_skb: 24 callbacks suppressed
[   73.037610] type=1400 audit(1333521196.549:23): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/evince" pid=1285  
comm="apparmor_parser"
[   73.038027] type=1400 audit(1333521196.549:24): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/evince//launchpad_integration"  
pid=1285 comm="apparmor_parser"
[   73.038188] type=1400 audit(1333521196.549:25): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/evince//sanitized_helper"  
pid=1285 comm="apparmor_parser"
[   73.039055] type=1400 audit(1333521196.549:26): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/evince-previewer" pid=1285  
comm="apparmor_parser"
[   73.039358] type=1400 audit(1333521196.549:27): apparmor="STATUS"  
operation="profile_load"  
name="/usr/bin/evince-previewer//launchpad_integration" pid=1285  
comm="apparmor_parser"
[   73.039540] type=1400 audit(1333521196.549:28): apparmor="STATUS"  
operation="profile_load"  
name="/usr/bin/evince-previewer//sanitized_helper" pid=1285  
comm="apparmor_parser"
[   73.040158] type=1400 audit(1333521196.553:29): apparmor="STATUS"  
operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1285  
comm="apparmor_parser"
[   73.040335] type=1400 audit(1333521196.553:30): apparmor="STATUS"  
operation="profile_load"  
name="/usr/bin/evince-thumbnailer//sanitized_helper" pid=1285  
comm="apparmor_parser"
[   74.017386] init: isc-dhcp-server main process (1457) terminated  
with status 1
[   74.017424] init: isc-dhcp-server main process ended, respawning
[   74.165806] init: isc-dhcp-server main process (1562) terminated  
with status 1
[   74.165850] init: isc-dhcp-server main process ended, respawning
[   74.355723] init: isc-dhcp-server main process (1623) terminated  
with status 1
[   74.355766] init: isc-dhcp-server main process ended, respawning
[   75.065954] init: isc-dhcp-server main process (1642) terminated  
with status 1
[   75.065991] init: isc-dhcp-server main process ended, respawning
[   75.433720] init: isc-dhcp-server main process (1709) terminated  
with status 1
[   75.433759] init: isc-dhcp-server main process ended, respawning
[   75.742211] virtuoso-t[1771]: segfault at 8 ip 00000000007dc457 sp  
00007fffab1bbb38 error 4 in virtuoso-t[400000+96d000]
[   76.160644] init: isc-dhcp-server main process (1767) terminated  
with status 1
[   76.160682] init: isc-dhcp-server main process ended, respawning
[   76.637538] init: isc-dhcp-server main process (1802) terminated  
with status 1
[   76.637579] init: isc-dhcp-server main process ended, respawning
[   76.894282] init: isc-dhcp-server main process (1839) terminated  
with status 1
[   76.894319] init: isc-dhcp-server main process ended, respawning
[   77.025457] init: isc-dhcp-server main process (1854) terminated  
with status 1
[   77.025495] init: isc-dhcp-server main process ended, respawning
[   77.166375] init: isc-dhcp-server main process (1876) terminated  
with status 1
[   77.166420] init: isc-dhcp-server main process ended, respawning
[   77.317144] init: isc-dhcp-server main process (1902) terminated  
with status 1
[   77.317183] init: isc-dhcp-server respawning too fast, stopped
[   77.631276] type=1400 audit(1333521201.141:31): apparmor="ALLOWED"  
operation="mknod" parent=1 profile="/usr/sbin/mysqld"  
name="/run/mysqld/mysqld.sock" pid=1555 comm="mysqld"  
requested_mask="c" denied_mask="c" fsuid=110 ouid=110
[   79.223139] init: plymouth-stop pre-start process (2040) terminated  
with status 1
[  104.121761] init: mysql post-start process (1556) terminated with status 1
[  367.132176] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[  367.372732] Linux video capture interface: v2.00
[  367.556823] IR NEC protocol handler initialized
[  367.575693] tm6000: alt 0, interface 0, class 255
[  367.575697] tm6000: alt 0, interface 0, class 255
[  367.575700] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
[  367.575703] tm6000: alt 0, interface 0, class 255
[  367.575706] tm6000: alt 1, interface 0, class 255
[  367.575709] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
[  367.575712] tm6000: alt 1, interface 0, class 255
[  367.575715] tm6000: alt 1, interface 0, class 255
[  367.575718] tm6000: INT IN endpoint: 0x83 (max size=4 bytes)
[  367.575721] tm6000: alt 2, interface 0, class 255
[  367.575723] tm6000: alt 2, interface 0, class 255
[  367.575726] tm6000: alt 2, interface 0, class 255
[  367.575729] tm6000: alt 3, interface 0, class 255
[  367.575731] tm6000: alt 3, interface 0, class 255
[  367.575734] tm6000: alt 3, interface 0, class 255
[  367.575737] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
[  367.575740] tm6000: Found Hauppauge WinTV HVR-900H / WinTV USB2-Stick
[  367.576179] Found tm6010
[  367.580590] IR RC5(x) protocol handler initialized
[  367.583597] IR RC6 protocol handler initialized
[  367.609609] IR JVC protocol handler initialized
[  367.618347] IR Sony protocol handler initialized
[  367.625868] IR SANYO protocol handler initialized
[  367.652760] IR MCE Keyboard/mouse protocol handler initialized
[  367.656739] lirc_dev: IR Remote Control driver registered, major 250
[  367.657723] IR LIRC bridge handler initialized
[  367.917740] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00  
00 40 40 20 00 66  .YTE.......@@ .f
[  367.936318] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00  
79 00 62 00 72 00  i.. @...H.y.b.r.
[  367.955660] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ..d.............
[  367.975155] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  367.994400] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00  
30 00 30 00 48 00  ..H.V.R.9.0.0.H.
[  368.013910] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.033192] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff  
0a 03 32 00 2e 00  0...........2...
[  368.052657] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ?...............
[  368.072192] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.091800] tm6000 #0: i2c eeprom 90: 39 ff ff ff 16 03 34 00 30 00  
33 00 32 00 33 00  9.....4.0.3.2.3.
[  368.111404] tm6000 #0: i2c eeprom a0: 33 00 38 00 33 00 32 00 38 00  
00 00 77 00 ff ff  3.8.3.2.8...w...
[  368.131035] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.150403] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.169555] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.188697] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.208328] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.267551] i2c-core: driver [tuner] using legacy suspend method
[  368.267558] i2c-core: driver [tuner] using legacy resume method
[  368.268710] tuner 15-0061: Tuner -1 found with type(s) Radio TV.
[  368.327287] xc2028 15-0061: creating new instance
[  368.327292] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[  368.327297] Setting firmware parameters for xc2028
[  368.418287] xc2028 15-0061: Loading 81 firmware images from  
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[  368.624261] xc2028 15-0061: Loading firmware for type=BASE (1), id  
0000000000000000.
[  372.691792] xc2028 15-0061: Loading firmware for type=(0), id  
000000000000b700.
[  372.766793] SCODE (20000000), id 000000000000b700:
[  372.766801] xc2028 15-0061: Loading SCODE for type=MONO SCODE  
HAS_IF_4320 (60008000), id 0000000000008000.
[  373.133608] tm6000 #0: registered device video0
[  373.133615] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load  
status: 0)
[  373.320056] Registered IR keymap rc-hauppauge
[  373.320310] input: tm5600/60x0 IR (tm6000 #0) as  
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0/input9
[  373.320428] rc0: tm5600/60x0 IR (tm6000 #0) as  
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0
[  373.444376] usbcore: registered new interface driver tm6000
[  373.517483] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[  373.821461] tm6000: IR URB failure: status: -2, length 0
[  373.822423] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
[  373.822429] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353  
DVB-T)...
[  373.822577] xc2028 15-0061: attaching existing instance
[  373.822580] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[  373.822583] tm6000: XC2028/3028 asked to be attached to frontend!
[  373.826202] tm6000 #0: Initialized (TM6000 dvb Extension) extension

and after running tvtime:
[  367.132176] usb 2-3: new high-speed USB device number 2 using ehci_hcd
[  367.372732] Linux video capture interface: v2.00
[  367.556823] IR NEC protocol handler initialized
[  367.575693] tm6000: alt 0, interface 0, class 255
[  367.575697] tm6000: alt 0, interface 0, class 255
[  367.575700] tm6000: Bulk IN endpoint: 0x82 (max size=512 bytes)
[  367.575703] tm6000: alt 0, interface 0, class 255
[  367.575706] tm6000: alt 1, interface 0, class 255
[  367.575709] tm6000: ISOC IN endpoint: 0x81 (max size=3072 bytes)
[  367.575712] tm6000: alt 1, interface 0, class 255
[  367.575715] tm6000: alt 1, interface 0, class 255
[  367.575718] tm6000: INT IN endpoint: 0x83 (max size=4 bytes)
[  367.575721] tm6000: alt 2, interface 0, class 255
[  367.575723] tm6000: alt 2, interface 0, class 255
[  367.575726] tm6000: alt 2, interface 0, class 255
[  367.575729] tm6000: alt 3, interface 0, class 255
[  367.575731] tm6000: alt 3, interface 0, class 255
[  367.575734] tm6000: alt 3, interface 0, class 255
[  367.575737] tm6000: New video device @ 480 Mbps (2040:6600, ifnum 0)
[  367.575740] tm6000: Found Hauppauge WinTV HVR-900H / WinTV USB2-Stick
[  367.576179] Found tm6010
[  367.580590] IR RC5(x) protocol handler initialized
[  367.583597] IR RC6 protocol handler initialized
[  367.609609] IR JVC protocol handler initialized
[  367.618347] IR Sony protocol handler initialized
[  367.625868] IR SANYO protocol handler initialized
[  367.652760] IR MCE Keyboard/mouse protocol handler initialized
[  367.656739] lirc_dev: IR Remote Control driver registered, major 250
[  367.657723] IR LIRC bridge handler initialized
[  367.917740] tm6000 #0: i2c eeprom 00: 01 59 54 45 12 01 00 02 00 00  
00 40 40 20 00 66  .YTE.......@@ .f
[  367.936318] tm6000 #0: i2c eeprom 10: 69 00 10 20 40 01 02 03 48 00  
79 00 62 00 72 00  i.. @...H.y.b.r.
[  367.955660] tm6000 #0: i2c eeprom 20: ff 00 64 ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ..d.............
[  367.975155] tm6000 #0: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  367.994400] tm6000 #0: i2c eeprom 40: 10 03 48 00 56 00 52 00 39 00  
30 00 30 00 48 00  ..H.V.R.9.0.0.H.
[  368.013910] tm6000 #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.033192] tm6000 #0: i2c eeprom 60: 30 ff ff ff 0f ff ff ff ff ff  
0a 03 32 00 2e 00  0...........2...
[  368.052657] tm6000 #0: i2c eeprom 70: 3f 00 ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ?...............
[  368.072192] tm6000 #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.091800] tm6000 #0: i2c eeprom 90: 39 ff ff ff 16 03 34 00 30 00  
33 00 32 00 33 00  9.....4.0.3.2.3.
[  368.111404] tm6000 #0: i2c eeprom a0: 33 00 38 00 33 00 32 00 38 00  
00 00 77 00 ff ff  3.8.3.2.8...w...
[  368.131035] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.150403] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.169555] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.188697] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.208328] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff  ................
[  368.267551] i2c-core: driver [tuner] using legacy suspend method
[  368.267558] i2c-core: driver [tuner] using legacy resume method
[  368.268710] tuner 15-0061: Tuner -1 found with type(s) Radio TV.
[  368.327287] xc2028 15-0061: creating new instance
[  368.327292] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[  368.327297] Setting firmware parameters for xc2028
[  368.418287] xc2028 15-0061: Loading 81 firmware images from  
xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[  368.624261] xc2028 15-0061: Loading firmware for type=BASE (1), id  
0000000000000000.
[  372.691792] xc2028 15-0061: Loading firmware for type=(0), id  
000000000000b700.
[  372.766793] SCODE (20000000), id 000000000000b700:
[  372.766801] xc2028 15-0061: Loading SCODE for type=MONO SCODE  
HAS_IF_4320 (60008000), id 0000000000008000.
[  373.133608] tm6000 #0: registered device video0
[  373.133615] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load  
status: 0)
[  373.320056] Registered IR keymap rc-hauppauge
[  373.320310] input: tm5600/60x0 IR (tm6000 #0) as  
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0/input9
[  373.320428] rc0: tm5600/60x0 IR (tm6000 #0) as  
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc0
[  373.444376] usbcore: registered new interface driver tm6000
[  373.517483] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[  373.821461] tm6000: IR URB failure: status: -2, length 0
[  373.822423] DVB: registering new adapter (Trident TVMaster 6000 DVB-T)
[  373.822429] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353  
DVB-T)...
[  373.822577] xc2028 15-0061: attaching existing instance
[  373.822580] xc2028 15-0061: type set to XCeive xc2028/xc3028 tuner
[  373.822583] tm6000: XC2028/3028 asked to be attached to frontend!
[  373.826202] tm6000 #0: Initialized (TM6000 dvb Extension) extension
[  453.148460] xc2028 15-0061: Loading firmware for type=(0), id  
000000000000b700.
[  453.220576] SCODE (20000000), id 000000000000b700:
[  453.220588] xc2028 15-0061: Loading SCODE for type=MONO SCODE  
HAS_IF_4320 (60008000), id 0000000000008000.
[  454.004057] xc2028 15-0061: Loading firmware for type=BASE F8MHZ  
(3), id 0000000000000000.
[  458.018471] (0), id 00000000000000ff:
[  458.018479] xc2028 15-0061: Loading firmware for type=(0), id  
0000000000000007.
[  458.088583] xc2028 15-0061: Loading SCODE for type=MONO SCODE  
HAS_IF_5320 (60008000), id 0000000000000007.
[  458.279848] tm6000: IR URB failure: status: -2, length 0
[  465.560174] tm6000: IR URB failure: status: -2, length 0

lsmod:
Module                  Size  Used by
zl10353                13718  1
tm6000_dvb             13345  0
dvb_core              110385  1 tm6000_dvb
tm6000_alsa            13574  1
rc_hauppauge           12532  0
tuner_xc2028           27120  2
tuner                  27377  1
ir_lirc_codec          12901  0
lirc_dev               19204  1 ir_lirc_codec
ir_mce_kbd_decoder     12724  0
ir_sanyo_decoder       12513  0
ir_sony_decoder        12510  0
ir_jvc_decoder         12507  0
ir_rc6_decoder         12507  0
ir_rc5_decoder         12507  0
tm6000                 63412  2 tm6000_dvb,tm6000_alsa
ir_nec_decoder         12507  0
videobuf_vmalloc       13589  1 tm6000
videobuf_core          26138  2 tm6000,videobuf_vmalloc
rc_core                26373  11  
rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,tm6000,ir_nec_decoder
v4l2_common            16494  2 tuner,tm6000
videodev               97879  3 tuner,tm6000,v4l2_common
v4l2_compat_ioctl32    21257  1 videodev
speedstep_lib          13095  0
parport_pc             32734  0
ppdev                  17180  0
dm_crypt               22908  0
bnep                   18190  2
rfcomm                 47013  0
bluetooth             188048  10 bnep,rfcomm
binfmt_misc            17498  1
nls_iso8859_1          12713  2
nls_cp437              16991  2
vfat                   17535  2
fat                    61245  1 vfat
snd_hda_codec_idt      70464  1
snd_hda_codec_hdmi     32111  1
arc4                   12529  2
snd_hda_intel          33332  3
snd_hda_codec         122839  3  
snd_hda_codec_idt,snd_hda_codec_hdmi,snd_hda_intel
snd_hwdep              13652  1 snd_hda_codec
iwl3945                65774  0
iwlegacy               72151  1 iwl3945
snd_pcm                96984  4  
tm6000_alsa,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
r852                   18308  0
sm_common              16817  1 r852
nand                   54755  2 r852,sm_common
snd_seq_midi           13324  0
nand_ids               12723  1 nand
mtd                    33086  2 sm_common,nand
snd_rawmidi            30655  1 snd_seq_midi
mac80211              514543  2 iwl3945,iwlegacy
snd_seq_midi_event     14899  1 snd_seq_midi
snd_seq                61538  2 snd_seq_midi,snd_seq_midi_event
snd_timer              29708  2 snd_pcm,snd_seq
nand_bch               13147  1 nand
coretemp               13515  0
joydev                 17597  0
dell_laptop            18024  0
dell_wmi               12681  0
snd_seq_device         14490  3 snd_seq_midi,snd_rawmidi,snd_seq
cfg80211              206007  3 iwl3945,iwlegacy,mac80211
bch                    21767  1 nand_bch
mac_hid                13205  0
r592                   18145  0
snd                    78595  19  
tm6000_alsa,snd_hda_codec_idt,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
firewire_sbp2          22633  0
memstick               16599  1 r592
soundcore              14996  1 snd
psmouse                87507  0
dcdbas                 14438  1 dell_laptop
nand_ecc               13230  1 nand
tpm_tis                18678  0
lp                     17789  0
sparse_keymap          13890  1 dell_wmi
dm_multipath           23141  0
shpchp                 37252  0
snd_page_alloc         18484  2 snd_hda_intel,snd_pcm
serio_raw              13211  0
parport                46360  3 parport_pc,ppdev,lp
ext2                   73217  1
dm_mirror              22044  0
dm_region_hash         20805  1 dm_mirror
dm_log                 18518  2 dm_mirror,dm_region_hash
firewire_ohci          40327  0
firewire_core          63386  2 firewire_sbp2,firewire_ohci
crc_itu_t              12707  1 firewire_core
sdhci_pci              18593  0
sdhci                  32457  1 sdhci_pci
sky2                   62444  0
i915                  475482  2
drm_kms_helper         42475  1 i915
drm                   253084  3 i915,drm_kms_helper
wmi                    19141  1 dell_wmi
i2c_algo_bit           13368  1 i915
video                  19280  1 i915

Thanks in advance and best regards,
Jens Reimann

