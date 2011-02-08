Return-path: <mchehab@pedra>
Received: from DSL01.212.114.205.243.ip-pool.NEFkom.net ([212.114.205.243]:44348
	"EHLO enzo.pibbs.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295Ab1BHWF3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 17:05:29 -0500
From: Martin Seekatz <martin@pibbs.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: em28xx: board id [eb1a:2863 eMPIA Technology, Inc] Silver Crest VG2000  "USB 2.0 Video Grabber"
Date: Tue, 8 Feb 2011 23:05:24 +0100
MIME-Version: 1.0
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_k4bUNBVjV0xb0Ce"
Message-Id: <201102082305.24897.martin@pibbs.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

after updating my system from the git sources on 2011-02-03,  I=C2=B4ve=20
made some new tests with this USB-Stick.

Model: Silver Crest VG2000  "USB 2.0 Video Grabber"
Vendor/Product id: [eb1a:2863]

The entry in the Linux  Kernel Documentation for Kernel 2.6.36 do not=20
match the information given on loading the device drivers. In the=20
Kernel list the device is listed as number "1 -> Unknown EM2750/28xx=20
video grabber", the log information is number "29 -> EM2860/TVP5150=20
Reference Design"

System: Linux trixi 2.6.34.7-0.7-desktop #1 SMP PREEMPT 2010-12-13=20
11:13:53 +0100 x86_64 x86_64 x86_64 GNU/Linux

Test made:
 - Analogue Video, komposite Modus
 - Analogue Audio, Stereo Modus
This device has no receiver, nore remote control.
The device is equiped with an snapshoot buttom.

Aplication used for testing: VLC media player, ver 1.1.7-3.5
Result: The vlc aplication get the video display and audio output=20
working.
Device List show=20
=2D Video capture:=20
   - eb1a=20
       - EM2860/TVP5150 Reference Design -> v4l2:///dev/vbi0
       - EM2860/TVP5150 Reference Design -> v4l2:///dev/video0
=2D Audo capture
   - Intel Corporation
      - 82801JI (ICH10 Family) HD Audio Controller (0) ->=20
alsa://plughw:0,0
      - 82801JI (ICH10 Family) HD Audio Controller (2) ->=20
alsa://plughw:0,2
   - eMPIA Technology, Inc.
      - Ger=C3=A4t (0) -> alsa://plughw:1,0
=20
The vbi0 device is not working:
ERROR: Couldn't attach to DCOP server!
[0x10713a0] v4l2 demux error: device does not support mmap i/o
[0x10713a0] v4l2 demux error: device does not support mmap i/o
[0x1270260] v4l2 access error: device does not support mmap i/o
[0x1270260] v4l2 access error: device does not support mmap i/o
[0x7f91d000d660] main input error: open of `v4l2:///dev/vbi0' failed:=20
(null)

The audio device must be explicitly selected to watch video together=20
with sound.
The snapshot buttom shows no effect on operating.

Other video applications as motv show the video graphic, but without=20
sound.

I hope it helps to enhance the drivers for better support of this=20
products, or to advice me how to handle it with the actual sytem.

Best regards
Martin Seekatz

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8";
  name="log.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.dmesg"

[    0.000000] Linux version 2.6.34.7-0.7-desktop (geeko@buildhost) (gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux) ) #1 SMP PREEMPT 2010-12-13 11:13:53 +0100
[    0.000000] Command line: root=/dev/sda3 resume=/dev/disk/by-id/ata-ST31000528AS_6VP07CBM-part6 splash=silent quiet vga=0x346
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf790000 (usable)
[    0.000000]  BIOS-e820: 00000000cf790000 - 00000000cf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf79e000 - 00000000cf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf7d0000 - 00000000cf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf7ec000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-protect
[    0.000000]   E8000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 1B0000000 mask FF0000000 uncachable
[    0.000000]   1 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   2 base 000000000 mask E00000000 write-back
[    0.000000]   3 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000cf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcf790 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cf790000 (usable)
[    0.000000]  modified: 00000000cf790000 - 00000000cf79e000 (ACPI data)
[    0.000000]  modified: 00000000cf79e000 - 00000000cf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000cf7d0000 - 00000000cf7e0000 (reserved)
[    0.000000]  modified: 00000000cf7ec000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000cf790000
[    0.000000]  0000000000 - 00cf600000 page 2M
[    0.000000]  00cf600000 - 00cf790000 page 4k
[    0.000000] kernel direct mapping tables up to cf790000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-00000001b0000000
[    0.000000]  0100000000 - 01b0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1b0000000 @ 1a000-22000
[    0.000000] RAMDISK: 375cf000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f9b00 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000cf790000 00040 (v01 MEDION MEDIONAG 20090324 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cf790200 00084 (v01 032409 FACP1454 20090324 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cf7905f0 052A3 (v01  IPMTB IPMTB000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cf79e000 00040
[    0.000000] ACPI: APIC 00000000cf790390 00098 (v01 032409 APIC1454 20090324 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cf790430 0003C (v01 032409 OEMMCFG  20090324 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000cf790470 00176 (v01 MEDION MEDIONAG 20090324 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cf79e040 00076 (v01 032409 OEMB1454 20090324 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cf79a5f0 00038 (v01 032409 OEMHPET  20090324 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cf7a08f0 01298 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001b0000000
[    0.000000] Initmem setup node 0 0000000000000000-00000001b0000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100013fff]
[    0.000000]  [ffffea0000000000-ffffea0005ffffff] PMD -> [ffff880100200000-ffff8801057fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001b0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000cf790
[    0.000000]     0: 0x00100000 -> 0x001b0000
[    0.000000] On node 0 totalpages: 1570590
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3926 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831432 pages, LIFO batch:31
[    0.000000]   Normal zone: 9856 pages used for memmap
[    0.000000]   Normal zone: 711040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] early_res array is doubled to 64 at [1d000 - 1d7ff]
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cf790000 - 00000000cf79e000
[    0.000000] PM: Registered nosave memory: 00000000cf79e000 - 00000000cf7d0000
[    0.000000] PM: Registered nosave memory: 00000000cf7d0000 - 00000000cf7e0000
[    0.000000] PM: Registered nosave memory: 00000000cf7e0000 - 00000000cf7ec000
[    0.000000] PM: Registered nosave memory: 00000000cf7ec000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ee00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001e00000 s84136 r8192 d22360 u262144
[    0.000000] pcpu-alloc: s84136 r8192 d22360 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] early_res array is doubled to 128 at [1d800 - 1e7ff]
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1546398
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda3 resume=/dev/disk/by-id/ata-ST31000528AS_6VP07CBM-part6 splash=silent quiet vga=0x346
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (61 early reservations)
[    0.000000]   #1 [0001000000 - 0001d95bb8]   TEXT DATA BSS
[    0.000000]   #2 [00375cf000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d96000 - 0001d9612e]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009ec00 - 00000fcca0]   BIOS reserved
[    0.000000]   #7 [00000fce34 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fcca0 - 00000fce34]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #12 [000001a000 - 000001d000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100014000]       NODE_DATA
[    0.000000]   #14 [0001d96140 - 0001d97140]         BOOTMEM
[    0.000000]   #15 [0100014000 - 0100014480]         BOOTMEM
[    0.000000]   #16 [0100015000 - 0100016000]         BOOTMEM
[    0.000000]   #17 [0100016000 - 0100017000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105800000]        MEMMAP 0
[    0.000000]   #19 [0001d97140 - 0001daf140]         BOOTMEM
[    0.000000]   #20 [0001daf140 - 0001dc7140]         BOOTMEM
[    0.000000]   #21 [0001dc7140 - 0001ddf140]         BOOTMEM
[    0.000000]   #22 [0001de0000 - 0001de1000]         BOOTMEM
[    0.000000]   #23 [0001d95bc0 - 0001d95c01]         BOOTMEM
[    0.000000]   #24 [0001d95c40 - 0001d95cc6]         BOOTMEM
[    0.000000]   #25 [0001d95d00 - 0001d95fa0]         BOOTMEM
[    0.000000]   #26 [0001ddf140 - 0001ddf1a8]         BOOTMEM
[    0.000000]   #27 [0001ddf1c0 - 0001ddf228]         BOOTMEM
[    0.000000]   #28 [0001ddf240 - 0001ddf2a8]         BOOTMEM
[    0.000000]   #29 [0001ddf2c0 - 0001ddf328]         BOOTMEM
[    0.000000]   #30 [0001ddf340 - 0001ddf3a8]         BOOTMEM
[    0.000000]   #31 [0001ddf3c0 - 0001ddf428]         BOOTMEM
[    0.000000]   #32 [0001ddf440 - 0001ddf4a8]         BOOTMEM
[    0.000000]   #33 [0001ddf4c0 - 0001ddf528]         BOOTMEM
[    0.000000]   #34 [0001ddf540 - 0001ddf5a8]         BOOTMEM
[    0.000000]   #35 [0001ddf5c0 - 0001ddf628]         BOOTMEM
[    0.000000]   #36 [0001ddf640 - 0001ddf6a8]         BOOTMEM
[    0.000000]   #37 [0001d95fc0 - 0001d95fe0]         BOOTMEM
[    0.000000]   #38 [0001ddf6c0 - 0001ddf6e0]         BOOTMEM
[    0.000000]   #39 [0001ddf700 - 0001ddf764]         BOOTMEM
[    0.000000]   #40 [0001ddf780 - 0001ddf7e4]         BOOTMEM
[    0.000000]   #41 [0001e00000 - 0001e1c000]         BOOTMEM
[    0.000000]   #42 [0001e40000 - 0001e5c000]         BOOTMEM
[    0.000000]   #43 [0001e80000 - 0001e9c000]         BOOTMEM
[    0.000000]   #44 [0001ec0000 - 0001edc000]         BOOTMEM
[    0.000000]   #45 [0001f00000 - 0001f1c000]         BOOTMEM
[    0.000000]   #46 [0001f40000 - 0001f5c000]         BOOTMEM
[    0.000000]   #47 [0001f80000 - 0001f9c000]         BOOTMEM
[    0.000000]   #48 [0001fc0000 - 0001fdc000]         BOOTMEM
[    0.000000]   #49 [0001ddf800 - 0001ddf808]         BOOTMEM
[    0.000000]   #50 [0001ddf840 - 0001ddf848]         BOOTMEM
[    0.000000]   #51 [0001ddf880 - 0001ddf8a0]         BOOTMEM
[    0.000000]   #52 [0001ddf8c0 - 0001ddf900]         BOOTMEM
[    0.000000]   #53 [0001ddf900 - 0001ddfa20]         BOOTMEM
[    0.000000]   #54 [0001ddfa40 - 0001ddfa88]         BOOTMEM
[    0.000000]   #55 [0001ddfac0 - 0001ddfb08]         BOOTMEM
[    0.000000]   #56 [0001de1000 - 0001de9000]         BOOTMEM
[    0.000000]   #57 [0001fdc000 - 0005fdc000]         BOOTMEM
[    0.000000]   #58 [0001e1c000 - 0001e3c000]         BOOTMEM
[    0.000000]   #59 [0005fdc000 - 000601c000]         BOOTMEM
[    0.000000]   #60 [000001e800 - 0000026800]         BOOTMEM
[    0.000000] Memory: 6102684k/7077888k available (4781k kernel code, 795528k absent, 179676k reserved, 6601k data, 892k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:33024 nr_irqs:880
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 2666.826 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.65 BogoMIPS (lpj=2666826)
[    0.000058] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
[    0.000117] Security Framework initialized
[    0.000128] AppArmor: AppArmor initialized
[    0.000589] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002120] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002859] Mount-cache hash table entries: 256
[    0.002949] CPU: Physical Processor ID: 0
[    0.002950] CPU: Processor Core ID: 0
[    0.002954] mce: CPU supports 9 MCE banks
[    0.002962] CPU0: Thermal monitoring enabled (TM1)
[    0.002968] using mwait in idle threads.
[    0.002969] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.002973] ... version:                3
[    0.002974] ... bit width:              48
[    0.002975] ... generic registers:      4
[    0.002975] ... value mask:             0000ffffffffffff
[    0.002976] ... max period:             000000007fffffff
[    0.002977] ... fixed-purpose events:   3
[    0.002978] ... event mask:             000000070000000f
[    0.003042] Unpacking initramfs...
[    0.152187] Freeing initrd memory: 10372k freed
[    0.153521] ACPI: Core revision 20100121
[    0.185662] Setting APIC routing to flat
[    0.186116] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.196093] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.397002] APIC calibration not consistent with PM-Timer: 199ms instead of 100ms
[    0.397004] APIC delta adjusted to PM-Timer: 833361 (1666700)
[    0.403020] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.038366] Brought up 8 CPUs
[    1.038369] Total of 8 processors activated (42661.24 BogoMIPS).
[    1.041478] devtmpfs: initialized
[    1.042814] regulator: core version 0.5
[    1.042844] regulator: dummy: 
[    1.042863] Time: 10:47:22  Date: 02/08/11
[    1.042906] NET: Registered protocol family 16
[    1.042985] ACPI: bus type pci registered
[    1.043027] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.043029] PCI: not using MMCONFIG
[    1.043031] PCI: Using configuration type 1 for base access
[    1.043689] bio: create slab <bio-0> at 0
[    1.044868] ACPI: EC: Look up EC in DSDT
[    1.045995] ACPI: Executed 1 blocks of module-level executable AML code
[    1.053002] ACPI: SSDT 00000000cf79e0c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.053452] ACPI: SSDT 00000000cf7a0140 003B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.054092] ACPI: SSDT 00000000cf79e4d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    1.054469] ACPI: SSDT 00000000cf7a0500 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    1.055105] ACPI: SSDT 00000000cf79e8e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
[    1.055480] ACPI: SSDT 00000000cf7a0590 00085 (v01  PmRef  P003Cst 00003000 INTL 20051117)
[    1.056122] ACPI: SSDT 00000000cf79ecf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
[    1.056500] ACPI: SSDT 00000000cf7a0620 00085 (v01  PmRef  P004Cst 00003000 INTL 20051117)
[    1.057144] ACPI: SSDT 00000000cf79f100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20051117)
[    1.057526] ACPI: SSDT 00000000cf7a06b0 00085 (v01  PmRef  P005Cst 00003000 INTL 20051117)
[    1.058167] ACPI: SSDT 00000000cf79f510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20051117)
[    1.058548] ACPI: SSDT 00000000cf7a0740 00085 (v01  PmRef  P006Cst 00003000 INTL 20051117)
[    1.059198] ACPI: SSDT 00000000cf79f920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20051117)
[    1.059581] ACPI: SSDT 00000000cf7a07d0 00085 (v01  PmRef  P007Cst 00003000 INTL 20051117)
[    1.060230] ACPI: SSDT 00000000cf79fd30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20051117)
[    1.060618] ACPI: SSDT 00000000cf7a0860 00085 (v01  PmRef  P008Cst 00003000 INTL 20051117)
[    1.060907] ACPI: Interpreter enabled
[    1.060909] ACPI: (supports S0 S1 S3 S4 S5)
[    1.060929] ACPI: Using IOAPIC for interrupt routing
[    1.060971] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.062111] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.098519] ACPI: No dock devices found.
[    1.098521] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.098662] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.098938] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.098940] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.098942] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.098944] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.098945] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xdfffffff]
[    1.098947] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.098996] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.098999] pci 0000:00:00.0: PME# disabled
[    1.099051] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.099054] pci 0000:00:01.0: PME# disabled
[    1.099106] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.099108] pci 0000:00:03.0: PME# disabled
[    1.099162] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.099165] pci 0000:00:07.0: PME# disabled
[    1.099270] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    1.099297] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.099299] pci 0000:00:13.0: PME# disabled
[    1.099479] pci 0000:00:19.0: reg 10: [mem 0xf7ec0000-0xf7edffff]
[    1.099484] pci 0000:00:19.0: reg 14: [mem 0xf7ef2000-0xf7ef2fff]
[    1.099489] pci 0000:00:19.0: reg 18: [io  0xb080-0xb09f]
[    1.099522] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.099525] pci 0000:00:19.0: PME# disabled
[    1.099565] pci 0000:00:1a.0: reg 20: [io  0xb400-0xb41f]
[    1.099622] pci 0000:00:1a.1: reg 20: [io  0xb480-0xb49f]
[    1.099678] pci 0000:00:1a.2: reg 20: [io  0xb800-0xb81f]
[    1.099735] pci 0000:00:1a.7: reg 10: [mem 0xf7ef8000-0xf7ef83ff]
[    1.099783] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.099787] pci 0000:00:1a.7: PME# disabled
[    1.099817] pci 0000:00:1b.0: reg 10: [mem 0xf7ef4000-0xf7ef7fff 64bit]
[    1.099853] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.099856] pci 0000:00:1b.0: PME# disabled
[    1.099913] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.099916] pci 0000:00:1c.0: PME# disabled
[    1.099975] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.099978] pci 0000:00:1c.2: PME# disabled
[    1.100024] pci 0000:00:1d.0: reg 20: [io  0xb880-0xb89f]
[    1.100081] pci 0000:00:1d.1: reg 20: [io  0xbc00-0xbc1f]
[    1.100140] pci 0000:00:1d.2: reg 20: [io  0xc000-0xc01f]
[    1.100198] pci 0000:00:1d.7: reg 10: [mem 0xf7efa000-0xf7efa3ff]
[    1.100247] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.100250] pci 0000:00:1d.7: PME# disabled
[    1.100352] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.100355] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.100358] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    1.100408] pci 0000:00:1f.2: reg 10: [io  0xc880-0xc887]
[    1.100413] pci 0000:00:1f.2: reg 14: [io  0xc800-0xc803]
[    1.100417] pci 0000:00:1f.2: reg 18: [io  0xc480-0xc487]
[    1.100422] pci 0000:00:1f.2: reg 1c: [io  0xc400-0xc403]
[    1.100426] pci 0000:00:1f.2: reg 20: [io  0xc080-0xc09f]
[    1.100430] pci 0000:00:1f.2: reg 24: [mem 0xf7efc000-0xf7efc7ff]
[    1.100458] pci 0000:00:1f.2: PME# supported from D3hot
[    1.100460] pci 0000:00:1f.2: PME# disabled
[    1.100484] pci 0000:00:1f.3: reg 10: [mem 0xf7efe000-0xf7efe0ff 64bit]
[    1.100495] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    1.100543] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    1.100546] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.100549] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.100553] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.100600] pci 0000:05:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    1.100607] pci 0000:05:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.100614] pci 0000:05:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    1.100619] pci 0000:05:00.0: reg 24: [io  0xec00-0xec7f]
[    1.100623] pci 0000:05:00.0: reg 30: [mem 0xfbe80000-0xfbefffff pref]
[    1.102207] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    1.102211] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    1.102215] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbefffff]
[    1.102221] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.102256] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    1.102259] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.102262] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.102266] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.102301] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    1.102304] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.102307] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.102312] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.102380] pci 0000:02:00.0: reg 10: [mem 0xf7fff800-0xf7ffffff 64bit]
[    1.102387] pci 0000:02:00.0: reg 18: [io  0xd800-0xd8ff]
[    1.102440] pci 0000:02:00.0: supports D2
[    1.102441] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    1.102445] pci 0000:02:00.0: PME# disabled
[    1.104212] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    1.104216] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    1.104220] pci 0000:00:1c.2:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    1.104227] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.104290] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.104294] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.104297] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.104301] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.104303] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.104305] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.104306] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.104308] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.104310] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
[    1.104311] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.104335] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.104562] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.104615] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.104672] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.104745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.104796] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    1.129640] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15), disabled.
[    1.129739] ACPI: PCI Interrupt Link [LNKB] (IRQs *5), disabled.
[    1.129834] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15), disabled.
[    1.129931] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15), disabled.
[    1.130027] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15), disabled.
[    1.130129] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15), disabled.
[    1.130228] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15), disabled.
[    1.130324] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15), disabled.
[    1.130424] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.130426] vgaarb: loaded
[    1.130443] usbcore: registered new interface driver usbfs
[    1.130452] usbcore: registered new interface driver hub
[    1.130470] usbcore: registered new device driver usb
[    1.130510] PCI: Using ACPI for IRQ routing
[    1.130512] PCI: pci_cache_line_size set to 64 bytes
[    1.130586] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.130587] reserve RAM buffer: 00000000cf790000 - 00000000cfffffff 
[    1.130639] NetLabel: Initializing
[    1.130640] NetLabel:  domain hash size = 128
[    1.130641] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.130650] NetLabel:  unlabeled traffic allowed by default
[    1.130654] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.130658] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.130661] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.137140] Switching to clocksource tsc
[    1.138186] AppArmor: AppArmor Filesystem Enabled
[    1.138194] pnp: PnP ACPI init
[    1.138201] ACPI: bus type pnp registered
[    1.140025] pnp: PnP ACPI: found 12 devices
[    1.140027] ACPI: ACPI bus type pnp unregistered
[    1.140035] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    1.140037] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.140039] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.140041] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.140043] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    1.140047] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    1.140052] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    1.140056] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    1.140057] system 00:07: [io  0x0800-0x087f] has been reserved
[    1.140059] system 00:07: [io  0x0500-0x057f] could not be reserved
[    1.140061] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.140063] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.140065] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    1.140069] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.140071] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.140074] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    1.140077] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.140079] system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
[    1.140081] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.140083] system 00:0b: [mem 0x00100000-0xcfffffff] could not be reserved
[    1.140085] system 00:0b: [mem 0xfed90000-0xffffffff] could not be reserved
[    1.144839] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf01fffff]
[    1.144842] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.144844] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.144846] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.144848] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    1.144849] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.144852] pci 0000:00:01.0:   bridge window [mem disabled]
[    1.144854] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.144858] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    1.144860] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    1.144864] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbefffff]
[    1.144867] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.144871] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    1.144872] pci 0000:00:07.0:   bridge window [io  disabled]
[    1.144875] pci 0000:00:07.0:   bridge window [mem disabled]
[    1.144877] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    1.144881] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    1.144883] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.144887] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    1.144890] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.144895] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    1.144897] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    1.144901] pci 0000:00:1c.2:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    1.144903] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.144908] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.144909] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.144913] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.144915] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.144926] pci 0000:00:01.0: setting latency timer to 64
[    1.144932] pci 0000:00:03.0: setting latency timer to 64
[    1.144939] pci 0000:00:07.0: setting latency timer to 64
[    1.144944] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.144948]   alloc irq_desc for 17 on node -1
[    1.144949]   alloc kstat_irqs on node -1
[    1.144954] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.144956] pci 0000:00:1c.0: setting latency timer to 64
[    1.144962]   alloc irq_desc for 18 on node -1
[    1.144963]   alloc kstat_irqs on node -1
[    1.144966] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.144969] pci 0000:00:1c.2: setting latency timer to 64
[    1.144974] pci 0000:00:1e.0: setting latency timer to 64
[    1.144977] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.144978] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.144979] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.144981] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.144982] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    1.144984] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.144985] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    1.144987] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xfbefffff]
[    1.144988] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.144990] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    1.144991] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf01fffff]
[    1.144993] pci_bus 0000:03: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.144994] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.144996] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    1.144997] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.144999] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.145000] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    1.145001] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.145003] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    1.145004] pci_bus 0000:01: resource 8 [mem 0xd0000000-0xdfffffff]
[    1.145006] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.145052] NET: Registered protocol family 2
[    1.145223] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.146022] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.147495] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.147702] TCP: Hash tables configured (established 524288 bind 65536)
[    1.147704] TCP reno registered
[    1.147715] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.147752] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.147870] NET: Registered protocol family 1
[    1.148036] pci 0000:05:00.0: Boot video device
[    1.148040] PCI: CLS 64 bytes, default 64
[    1.148042] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.148044] Placing 64MB software IO TLB between ffff880001fdc000 - ffff880005fdc000
[    1.148045] software IO TLB at phys 0x1fdc000 - 0x5fdc000
[    1.148552] Scanning for low memory corruption every 60 seconds
[    1.148659] audit: initializing netlink socket (disabled)
[    1.148667] type=2000 audit(1297162041.907:1): initialized
[    1.158927] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.159213] VFS: Disk quotas dquot_6.5.2
[    1.159234] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.159355] msgmni has been set to 2984
[    1.159497] alg: No test for stdrng (krng)
[    1.159528] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.159530] io scheduler noop registered
[    1.159531] io scheduler deadline registered
[    1.159547] io scheduler cfq registered (default)
[    1.159669] pcieport 0000:00:01.0: setting latency timer to 64
[    1.159694]   alloc irq_desc for 48 on node -1
[    1.159696]   alloc kstat_irqs on node -1
[    1.159703] pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
[    1.159753] pcieport 0000:00:03.0: setting latency timer to 64
[    1.159776]   alloc irq_desc for 49 on node -1
[    1.159777]   alloc kstat_irqs on node -1
[    1.159782] pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
[    1.159829] pcieport 0000:00:07.0: setting latency timer to 64
[    1.159852]   alloc irq_desc for 50 on node -1
[    1.159853]   alloc kstat_irqs on node -1
[    1.159858] pcieport 0000:00:07.0: irq 50 for MSI/MSI-X
[    1.159907] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.159934]   alloc irq_desc for 51 on node -1
[    1.159935]   alloc kstat_irqs on node -1
[    1.159940] pcieport 0000:00:1c.0: irq 51 for MSI/MSI-X
[    1.160000] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.160029]   alloc irq_desc for 52 on node -1
[    1.160030]   alloc kstat_irqs on node -1
[    1.160035] pcieport 0000:00:1c.2: irq 52 for MSI/MSI-X
[    1.160101] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.160107] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.160110] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.160130] pci-stub: invalid id string ""
[    1.161029] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90011800000, using 7500k, total 14336k
[    1.161031] vesafb: mode is 1600x1200x16, linelength=3200, pages=1
[    1.161032] vesafb: scrolling: redraw
[    1.161034] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.161189] bootsplash 3.1.6-2004/03/31: looking for picture...
[    1.161191] bootsplash: silentjpeg size 238929 bytes
[    1.182777] bootsplash: ...found (1600x1200, 114103 bytes, v3).
[    1.363250] Console: switching to colour frame buffer device 196x71
[    1.543400] fb0: VESA VGA frame buffer device
[    1.544316] Non-volatile memory driver v1.3
[    1.544318] Linux agpgart interface v0.103
[    1.544334] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    1.544638] Fixed MDIO Bus: probed
[    1.544642] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.544659] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.544673] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.544675] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.544689] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.544712] ehci_hcd 0000:00:1a.7: debug port 1
[    1.548588] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.548600] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7ef8000
[    1.558380] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.558404] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.558406] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.558409] usb usb1: Product: EHCI Host Controller
[    1.558411] usb usb1: Manufacturer: Linux 2.6.34.7-0.7-desktop ehci_hcd
[    1.558413] usb usb1: SerialNumber: 0000:00:1a.7
[    1.558498] hub 1-0:1.0: USB hub found
[    1.558501] hub 1-0:1.0: 6 ports detected
[    1.558554]   alloc irq_desc for 23 on node -1
[    1.558556]   alloc kstat_irqs on node -1
[    1.558560] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.558570] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.558572] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.558578] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.558596] ehci_hcd 0000:00:1d.7: debug port 1
[    1.562467] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.562477] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7efa000
[    1.571348] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.571369] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.571371] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.571374] usb usb2: Product: EHCI Host Controller
[    1.571376] usb usb2: Manufacturer: Linux 2.6.34.7-0.7-desktop ehci_hcd
[    1.571378] usb usb2: SerialNumber: 0000:00:1d.7
[    1.571458] hub 2-0:1.0: USB hub found
[    1.571461] hub 2-0:1.0: 6 ports detected
[    1.571508] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.571516] uhci_hcd: USB Universal Host Controller Interface driver
[    1.571540]   alloc irq_desc for 16 on node -1
[    1.571541]   alloc kstat_irqs on node -1
[    1.571545] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.571549] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.571551] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.571556] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.571583] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b400
[    1.571607] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.571608] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.571610] usb usb3: Product: UHCI Host Controller
[    1.571611] usb usb3: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.571612] usb usb3: SerialNumber: 0000:00:1a.0
[    1.571666] hub 3-0:1.0: USB hub found
[    1.571669] hub 3-0:1.0: 2 ports detected
[    1.571709]   alloc irq_desc for 21 on node -1
[    1.571710]   alloc kstat_irqs on node -1
[    1.571714] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.571718] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.571720] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.571724] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.571750] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b480
[    1.571772] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.571773] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.571775] usb usb4: Product: UHCI Host Controller
[    1.571776] usb usb4: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.571777] usb usb4: SerialNumber: 0000:00:1a.1
[    1.571831] hub 4-0:1.0: USB hub found
[    1.571834] hub 4-0:1.0: 2 ports detected
[    1.571872]   alloc irq_desc for 19 on node -1
[    1.571874]   alloc kstat_irqs on node -1
[    1.571877] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.571881] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.571884] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.571888] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.571914] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
[    1.571935] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.571937] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.571938] usb usb5: Product: UHCI Host Controller
[    1.571940] usb usb5: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.571941] usb usb5: SerialNumber: 0000:00:1a.2
[    1.571992] hub 5-0:1.0: USB hub found
[    1.571994] hub 5-0:1.0: 2 ports detected
[    1.572034] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.572039] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.572041] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.572045] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.572064] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b880
[    1.572086] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.572087] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.572089] usb usb6: Product: UHCI Host Controller
[    1.572090] usb usb6: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.572091] usb usb6: SerialNumber: 0000:00:1d.0
[    1.572142] hub 6-0:1.0: USB hub found
[    1.572145] hub 6-0:1.0: 2 ports detected
[    1.572184] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.572188] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.572190] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.572195] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.572215] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000bc00
[    1.572237] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.572239] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.572240] usb usb7: Product: UHCI Host Controller
[    1.572241] usb usb7: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.572242] usb usb7: SerialNumber: 0000:00:1d.1
[    1.572294] hub 7-0:1.0: USB hub found
[    1.572296] hub 7-0:1.0: 2 ports detected
[    1.572335] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.572339] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.572345] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.572350] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.572369] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c000
[    1.572391] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.572393] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.572394] usb usb8: Product: UHCI Host Controller
[    1.572395] usb usb8: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.572397] usb usb8: SerialNumber: 0000:00:1d.2
[    1.572448] hub 8-0:1.0: USB hub found
[    1.572451] hub 8-0:1.0: 2 ports detected
[    1.572516] PNP: No PS/2 controller found. Probing ports directly.
[    1.572837] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.572841] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.572878] mice: PS/2 mouse device common for all mice
[    1.572931] rtc_cmos 00:03: RTC can wake from S4
[    1.572954] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.572977] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.572984] cpuidle: using governor ladder
[    1.572985] cpuidle: using governor menu
[    1.573135] usbcore: registered new interface driver hiddev
[    1.573142] usbcore: registered new interface driver usbhid
[    1.573143] usbhid: USB HID core driver
[    1.638763] TCP cubic registered
[    1.638816] NET: Registered protocol family 10
[    1.639071] lo: Disabled Privacy Extensions
[    1.639227] lib80211: common routines for IEEE802.11 drivers
[    1.639228] lib80211_crypt: registered algorithm 'NULL'
[    1.639277] PM: Checking image partition /dev/disk/by-id/ata-ST31000528AS_6VP07CBM-part6
[    1.683028] PM: Resume from disk failed.
[    1.683045] registered taskstats version 1
[    1.683300]   Magic number: 15:868:779
[    1.683348] rtc_cmos 00:03: setting system clock to 2011-02-08 10:47:23 UTC (1297162043)
[    1.683395] Freeing unused kernel memory: 892k freed
[    1.683508] Write protecting the kernel read-only data: 10240k
[    1.683639] Freeing unused kernel memory: 1344k freed
[    1.683850] Freeing unused kernel memory: 632k freed
[    1.713652] SCSI subsystem initialized
[    1.726475] libata version 3.00 loaded.
[    1.729424] ahci 0000:00:1f.2: version 3.0
[    1.729436] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.729472]   alloc irq_desc for 53 on node -1
[    1.729474]   alloc kstat_irqs on node -1
[    1.729481] ahci 0000:00:1f.2: irq 53 for MSI/MSI-X
[    1.729505] ahci: SSS flag set, parallel bus scan disabled
[    1.729539] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.729542] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.729545] ahci 0000:00:1f.2: setting latency timer to 64
[    1.739147] scsi0 : ahci
[    1.739219] scsi1 : ahci
[    1.739249] scsi2 : ahci
[    1.739280] scsi3 : ahci
[    1.739311] scsi4 : ahci
[    1.739339] scsi5 : ahci
[    1.739481] ata1: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc100 irq 53
[    1.739483] ata2: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc180 irq 53
[    1.739485] ata3: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc200 irq 53
[    1.739487] ata4: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc280 irq 53
[    1.739489] ata5: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc300 irq 53
[    1.739491] ata6: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc380 irq 53
[    1.859436] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    1.974805] usb 1-3: New USB device found, idVendor=05e3, idProduct=0605
[    1.974808] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.974811] usb 1-3: Product: USB2.0 Hub
[    1.975207] hub 1-3:1.0: USB hub found
[    1.975552] hub 1-3:1.0: 4 ports detected
[    2.042965] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.069852] ata1.00: ATA-8: ST31000528AS, CC44, max UDMA/133
[    2.069855] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.077871] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    2.109241] ata1.00: configured for UDMA/133
[    2.119848] scsi 0:0:0:0: Direct-Access     ATA      ST31000528AS     CC44 PQ: 0 ANSI: 5
[    2.193241] usb 1-4: New USB device found, idVendor=05e3, idProduct=0605
[    2.193244] usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.193247] usb 1-4: Product: USB2.0 Hub
[    2.193516] hub 1-4:1.0: USB hub found
[    2.193866] hub 1-4:1.0: 4 ports detected
[    2.296314] usb 1-5: new high speed USB device using ehci_hcd and address 4
[    2.426890] usb 1-5: New USB device found, idVendor=152d, idProduct=2329
[    2.426893] usb 1-5: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    2.426896] usb 1-5: Product: Storagebird 35EV821
[    2.426898] usb 1-5: Manufacturer: 0123456
[    2.426899] usb 1-5: SerialNumber: 00000000000D
[    2.528729] usb 1-6: new high speed USB device using ehci_hcd and address 5
[    2.643333] usb 1-6: New USB device found, idVendor=152d, idProduct=2329
[    2.643336] usb 1-6: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    2.643338] usb 1-6: Product: Storagebird 35EV840
[    2.643340] usb 1-6: Manufacturer: Fujitsu-Siemens Computers
[    2.643342] usb 1-6: SerialNumber: 000000209E25
[    2.745176] usb 2-4: new high speed USB device using ehci_hcd and address 2
[    2.840933] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.843629] ata2.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00, max UDMA/100
[    2.847576] ata2.00: configured for UDMA/100
[    2.905448] usb 2-4: New USB device found, idVendor=0424, idProduct=2250
[    2.905451] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.905454] usb 2-4: Product: Flash
[    2.905456] usb 2-4: Manufacturer: Generic
[    2.905458] usb 2-4: SerialNumber: 000000002250
[    2.971411] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH20NS10  EL00 PQ: 0 ANSI: 5
[    2.978843] usb 1-3.2: new low speed USB device using ehci_hcd and address 6
[    3.070233] usb 1-3.2: New USB device found, idVendor=040b, idProduct=6510
[    3.070236] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.070239] usb 1-3.2: Product: Bar Code Reader
[    3.070241] usb 1-3.2: Manufacturer: Weltrend
[    3.073372] input: Weltrend Bar Code Reader as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.2/1-3.2:1.0/input/input0
[    3.073420] generic-usb 0003:040B:6510.0001: input,hidraw0: USB HID v1.10 Keyboard [Weltrend Bar Code Reader] on usb-0000:00:1a.7-3.2/input0
[    3.136438] usb 1-4.1: new low speed USB device using ehci_hcd and address 7
[    3.229572] usb 1-4.1: New USB device found, idVendor=04f2, idProduct=0116
[    3.229576] usb 1-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.229578] usb 1-4.1: Product: USB Keyboard
[    3.229580] usb 1-4.1: Manufacturer: CHICONY
[    3.234191] input: CHICONY USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.1/1-4.1:1.0/input/input1
[    3.234232] generic-usb 0003:04F2:0116.0002: input,hidraw1: USB HID v1.10 Keyboard [CHICONY USB Keyboard] on usb-0000:00:1a.7-4.1/input0
[    3.274822] ata3: SATA link down (SStatus 0 SControl 300)
[    3.307996] usb 1-4.2: new low speed USB device using ehci_hcd and address 8
[    3.386668] usb 1-4.2: New USB device found, idVendor=046d, idProduct=c018
[    3.386671] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.386674] usb 1-4.2: Product: USB Optical Mouse
[    3.386676] usb 1-4.2: Manufacturer: Logitech
[    3.388643] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.2/1-4.2:1.0/input/input2
[    3.388686] generic-usb 0003:046D:C018.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.7-4.2/input0
[    3.451627] usb 1-4.4: new full speed USB device using ehci_hcd and address 9
[    3.560222] usb 1-4.4: New USB device found, idVendor=0c4b, idProduct=0100
[    3.560226] usb 1-4.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.590017] ata4: SATA link down (SStatus 0 SControl 300)
[    3.905213] ata5: SATA link down (SStatus 0 SControl 300)
[    4.220409] ata6: SATA link down (SStatus 0 SControl 300)
[    4.235326] Monitor-Mwait will be used to enter C-1 state
[    4.235342] Monitor-Mwait will be used to enter C-2 state
[    4.235355] Monitor-Mwait will be used to enter C-3 state
[    4.241551] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    4.244926] udev: starting version 157
[    4.273809] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.273839] sd 0:0:0:0: [sda] Write Protect is off
[    4.273841] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.273853] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.273928]  sda: sda1 sda2 < sda5 sda6 > sda3 sda4
[    4.327988] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.880117] PM: Marking nosave pages: 000000000009e000 - 0000000000100000
[    4.880121] PM: Marking nosave pages: 00000000cf790000 - 0000000100000000
[    4.880531] PM: Basic memory bitmaps created
[    4.896958] PM: Basic memory bitmaps freed
[    4.902235] PM: Starting manual resume from disk
[    4.902237] PM: Resume from partition 8:6
[    4.902238] PM: Checking hibernation image.
[    4.902404] PM: Error -22 checking image file
[    4.902407] PM: Resume from disk failed.
[    5.138378] kjournald starting.  Commit interval 15 seconds
[    5.138557] EXT3-fs (sda3): using internal journal
[    5.138562] EXT3-fs (sda3): mounted filesystem with ordered data mode
[    6.652339] preloadtrace: systemtap: 1.1/0.147, base: ffffffffa00c5000, memory: 37data/40text/101ctx/13net/442alloc kb, probes: 44
[    8.363241] udev: starting version 157
[    8.377760] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    8.377796] ACPI: Power Button [PWRB]
[    8.377842] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    8.377871] ACPI: Power Button [PWRF]
[    8.396125] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    8.396128] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    8.396161]   alloc irq_desc for 20 on node -1
[    8.396164]   alloc kstat_irqs on node -1
[    8.396171] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    8.396179] e1000e 0000:00:19.0: setting latency timer to 64
[    8.396283]   alloc irq_desc for 54 on node -1
[    8.396285]   alloc kstat_irqs on node -1
[    8.396295] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[    8.417086] usbcore: registered new interface driver usbserial
[    8.417097] USB Serial support registered for generic
[    8.417124] usbcore: registered new interface driver usbserial_generic
[    8.417125] usbserial: USB Serial Driver core
[    8.418356] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    8.418369] cyberjack 1-4.4:1.0: Reiner SCT Cyberjack USB card reader converter detected
[    8.418462] usb 1-4.4: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB0
[    8.418474] usbcore: registered new interface driver cyberjack
[    8.418475] cyberjack: v1.01 Matthias Bruestle
[    8.418477] cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
[    8.418804] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    8.421020] iTCO_vendor_support: vendor-support=0
[    8.431383] ohci1394 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    8.431389] ohci1394 0000:02:00.0: setting latency timer to 64
[    8.437815] Initializing USB Mass Storage driver...
[    8.437896] scsi6 : usb-storage 1-5:1.0
[    8.437989] scsi7 : usb-storage 1-6:1.0
[    8.438068] scsi8 : usb-storage 2-4:1.0
[    8.438131] usbcore: registered new interface driver usb-storage
[    8.438132] USB Mass Storage support registered.
[    8.439186] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.439269] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
[    8.439315] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.477294] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.477327] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    8.485012] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[f7fff800-f7ffffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    8.492268] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.492270] Uniform CD-ROM driver Revision: 3.20
[    8.492344] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.548732] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:8c:9b:67:c9
[    8.548734] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.548755] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    8.548774] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.548829]   alloc irq_desc for 22 on node -1
[    8.548831]   alloc kstat_irqs on node -1
[    8.548837] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.548899]   alloc irq_desc for 55 on node -1
[    8.548900]   alloc kstat_irqs on node -1
[    8.548907] HDA Intel 0000:00:1b.0: irq 55 for MSI/MSI-X
[    8.548930] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.694341] hda_codec: ALC888: BIOS auto-probing.
[    8.694345] ALSA hda_codec.c:4385: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
[    8.694348] ALSA hda_codec.c:4389:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.694351] ALSA hda_codec.c:4393:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    8.694353] ALSA hda_codec.c:4394:    mono: mono_out=0x0
[    8.694354] ALSA hda_codec.c:4397:    dig-out=0x11/0x1e
[    8.694356] ALSA hda_codec.c:4405:    inputs: mic=0x18, fmic=0x19, line=0x1c, fline=0x0, cd=0x0, aux=0x0
[    8.695742] ALSA patch_realtek.c:1287: realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
[    8.695745] ALSA patch_realtek.c:1370: realtek: Enable default setup for auto mode as fallback
[    9.437156] scsi 8:0:0:0: Direct-Access     Generic  Flash HS-CF      1.68 PQ: 0 ANSI: 0
[    9.437390] sd 8:0:0:0: Attached scsi generic sg2 type 0
[    9.440009] scsi 8:0:0:1: Direct-Access     Generic  Flash HS-MS/SD   1.68 PQ: 0 ANSI: 0
[    9.440125] sd 8:0:0:1: Attached scsi generic sg3 type 0
[    9.441390] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[    9.443993] scsi 8:0:0:2: Direct-Access     Generic  Flash HS-SM      1.68 PQ: 0 ANSI: 0
[    9.444098] sd 8:0:0:2: Attached scsi generic sg4 type 0
[    9.446736] sd 8:0:0:1: [sdc] Attached SCSI removable disk
[    9.453506] sd 8:0:0:2: [sdd] Attached SCSI removable disk
[    9.477669] scsi 6:0:0:0: Direct-Access     WDC WD10 EAVS-00D7B0           PQ: 0 ANSI: 2 CCS
[    9.477811] sd 6:0:0:0: Attached scsi generic sg5 type 0
[    9.477863] scsi 7:0:0:0: Direct-Access     SAMSUNG  HD154UI               PQ: 0 ANSI: 2 CCS
[    9.477992] sd 7:0:0:0: Attached scsi generic sg6 type 0
[    9.478405] sd 6:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.478530] sd 7:0:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
[    9.480865] sd 6:0:0:0: [sde] Write Protect is off
[    9.480869] sd 6:0:0:0: [sde] Mode Sense: 34 00 00 00
[    9.480873] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.481232] sd 7:0:0:0: [sdf] Write Protect is off
[    9.481235] sd 7:0:0:0: [sdf] Mode Sense: 34 00 00 00
[    9.481237] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[    9.482232] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.482241]  sde:
[    9.482603] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[    9.482609]  sdf: sdf1
[    9.484595] sd 7:0:0:0: [sdf] Assuming drive cache: write through
[    9.484601] sd 7:0:0:0: [sdf] Attached SCSI disk
[    9.496850]  sde1
[    9.498435] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.498440] sd 6:0:0:0: [sde] Attached SCSI disk
[    9.744454] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c0001df49a2]
[   10.972187] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   11.063222] Adding 2103948k swap on /dev/sda6.  Priority:-1 extents:1 across:2103948k 
[   11.499872] device-mapper: uevent: version 1.0.3
[   11.500074] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[   12.732726] loop: module loaded
[   12.764047] kjournald starting.  Commit interval 15 seconds
[   12.764324] EXT3-fs (sda4): using internal journal
[   12.764329] EXT3-fs (sda4): mounted filesystem with ordered data mode
[   12.786058] fuse init (API version 7.13)
[   14.409829] type=1505 audit(1297158456.258:2): operation="profile_load" pid=1352 name=/bin/ping
[   14.457256] type=1505 audit(1297158456.305:3): operation="profile_load" pid=1353 name=/sbin/klogd
[   14.536997] type=1505 audit(1297158456.385:4): operation="profile_load" pid=1354 name=/sbin/syslog-ng
[   14.602401] type=1505 audit(1297158456.451:5): operation="profile_load" pid=1355 name=/sbin/syslogd
[   14.673166] type=1505 audit(1297158456.522:6): operation="profile_load" pid=1356 name=/usr/sbin/avahi-daemon
[   14.732361] type=1505 audit(1297158456.581:7): operation="profile_load" pid=1357 name=/usr/sbin/identd
[   14.798286] type=1505 audit(1297158456.647:8): operation="profile_load" pid=1358 name=/usr/sbin/mdnsd
[   14.873025] type=1505 audit(1297158456.722:9): operation="profile_load" pid=1359 name=/usr/sbin/nscd
[   14.974411] type=1505 audit(1297158456.824:10): operation="profile_load" pid=1360 name=/usr/sbin/ntpd
[   15.031983] type=1505 audit(1297158456.882:11): operation="profile_load" pid=1361 name=/usr/sbin/traceroute
[   18.998316] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[   19.049051] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[   19.049770] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.657615] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   20.657617] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   20.658200] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.307092] nvidia: module license 'NVIDIA' taints kernel.
[   22.307095] Disabling lock debugging due to kernel taint
[   22.839685]   alloc irq_desc for 24 on node -1
[   22.839687]   alloc kstat_irqs on node -1
[   22.839693] nvidia 0000:05:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[   22.839700] nvidia 0000:05:00.0: setting latency timer to 64
[   22.839703] vgaarb: device changed decodes: PCI:0000:05:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   22.839875] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  256.35  Wed Jun 16 18:42:44 PDT 2010
[   31.147597] eth0: no IPv6 routers present
[   33.212214] bootsplash: status on console 0 changed to on
[ 5840.348514] sd 8:0:0:1: [sdc] 7744512 512-byte logical blocks: (3.96 GB/3.69 GiB)
[ 5840.351321] sd 8:0:0:1: [sdc] Assuming drive cache: write through
[ 5840.360671] sd 8:0:0:1: [sdc] Assuming drive cache: write through
[ 5840.360678]  sdc: sdc1
[ 5922.091400] kjournald starting.  Commit interval 15 seconds
[ 5922.091945] EXT3-fs (sde1): using internal journal
[ 5922.091950] EXT3-fs (sde1): mounted filesystem with ordered data mode
[25262.431661] usb 2-5: new high speed USB device using ehci_hcd and address 3
[25262.545730] usb 2-5: New USB device found, idVendor=eb1a, idProduct=2863
[25262.545734] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[25262.605312] Linux video capture interface: v2.00
[25262.652308] em28xx: New device @ 480 Mbps (eb1a:2863, interface 0, class 0)
[25262.652455] em28xx #0: chip ID is em2860
[25262.654115] IR NEC protocol handler initialized
[25262.662558] IR RC5(x) protocol handler initialized
[25262.664051] IR RC6 protocol handler initialized
[25262.705150] IR JVC protocol handler initialized
[25262.707222] IR Sony protocol handler initialized
[25262.711403] lirc_dev: IR Remote Control driver registered, major 250 
[25262.713074] IR LIRC bridge handler initialized
[25262.721379] em28xx #0: board has no eeprom
[25262.721383] em28xx #0: Identified as EM2860/TVP5150 Reference Design (card=29)
[25262.735736] tvp5150 7-005c: chip found @ 0xb8 (em28xx #0)
[25262.760050] em28xx #0: Config register raw data: 0x10
[25262.772027] em28xx #0: AC97 vendor ID = 0x83847650
[25262.778005] em28xx #0: AC97 features = 0x6a90
[25262.778007] em28xx #0: Sigmatel audio processor detected(stac 9750)
[25263.054539] tvp5150 7-005c: tvp5150am1 detected.
[25264.166164] em28xx #0: v4l2 driver version 0.1.2
[25264.672948] em28xx #0: V4L2 video device registered as video0
[25264.672951] em28xx #0: V4L2 VBI device registered as vbi0
[25264.673015] usbcore: registered new interface driver em28xx
[25264.673019] em28xx driver loaded
[25264.704161] em28xx-audio.c: probing for em28x1 non standard usbaudio
[25264.704165] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[25264.704637] Em28xx: Initialized (Em28xx Audio Extension) extension
[25264.876698] tvp5150 7-005c: tvp5150am1 detected.
[25266.413760] tvp5150 7-005c: tvp5150am1 detected.

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8";
  name="log.lsmod"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.lsmod"

Module                  Size  Used by
em28xx_alsa             7576  1 
tvp5150                16756  1 
ir_lirc_codec           4811  0 
lirc_dev               17928  1 ir_lirc_codec
ir_sony_decoder         2421  0 
ir_jvc_decoder          2514  0 
ir_rc6_decoder          3058  0 
ir_rc5_decoder          2514  0 
ir_nec_decoder          2834  0 
em28xx                105044  1 em28xx_alsa
v4l2_common            12223  2 tvp5150,em28xx
videodev               85231  3 tvp5150,em28xx,v4l2_common
v4l2_compat_ioctl32     8249  1 videodev
videobuf_vmalloc        5741  1 em28xx
videobuf_core          21209  2 em28xx,videobuf_vmalloc
rc_core                21572  7 ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,em28xx
tveeprom               14201  1 em28xx
snd_pcm_oss            53701  0 
snd_mixer_oss          19415  1 snd_pcm_oss
snd_seq                68137  0 
snd_seq_device          7834  1 snd_seq
nvidia              11114068  28 
cpufreq_conservative    12628  0 
cpufreq_userspace       3264  0 
cpufreq_powersave       1258  0 
acpi_cpufreq            8399  0 
mperf                   1523  1 acpi_cpufreq
nls_iso8859_1           4729  1 
nls_cp437               6447  1 
vfat                   12114  1 
fat                    59802  1 vfat
fuse                   75897  5 
loop                   18524  0 
dm_mod                 86873  0 
snd_hda_codec_realtek   324511  1 
firewire_ohci          26938  0 
firewire_core          60890  1 firewire_ohci
crc_itu_t               1747  1 firewire_core
sr_mod                 16684  0 
cdrom                  43440  1 sr_mod
sg                     33348  0 
snd_hda_intel          28621  3 
snd_hda_codec         113249  2 snd_hda_codec_realtek,snd_hda_intel
snd_hwdep               8100  1 snd_hda_codec
snd_pcm               105589  4 em28xx_alsa,snd_pcm_oss,snd_hda_intel,snd_hda_codec
iTCO_wdt               12170  0 
usb_storage            52947  1 
snd_timer              26828  2 snd_seq,snd_pcm
ohci1394               33702  0 
serio_raw               5318  0 
ieee1394              104868  1 ohci1394
iTCO_vendor_support     3150  1 iTCO_wdt
pcspkr                  2222  0 
cyberjack               9820  0 
usbserial              41885  1 cyberjack
i2c_i801               11881  0 
snd                    84547  19 em28xx_alsa,snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               9003  1 snd
snd_page_alloc          9569  2 snd_hda_intel,snd_pcm
e1000e                152493  0 
button                  6989  0 
sd_mod                 41436  8 
edd                    10208  0 
fan                     4559  0 
processor              45747  9 acpi_cpufreq
ahci                   42680  5 
libata                211449  1 ahci
scsi_mod              191748  5 sr_mod,sg,usb_storage,sd_mod,libata
thermal                20625  0 
thermal_sys            18230  3 fan,processor,thermal

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8";
  name="log.lsusb.em2683"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.lsusb.em2683"


Bus 002 Device 003: ID eb1a:2863 eMPIA Technology, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0xeb1a eMPIA Technology, Inc.
  idProduct          0x2863 
  bcdDevice            1.10
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
        wMaxPacketSize     0x0000  1x 0 bytes
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
Device Status:     0x0000
  (Bus Powered)

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8";
  name="log.messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.messages"

Feb  8 17:49:29 trixi kernel: [25262.431661] usb 2-5: new high speed USB device using ehci_hcd and address 3
Feb  8 17:49:29 trixi kernel: [25262.545730] usb 2-5: New USB device found, idVendor=eb1a, idProduct=2863
Feb  8 17:49:29 trixi kernel: [25262.545734] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Feb  8 17:49:29 trixi kernel: [25262.545734] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Feb  8 17:49:29 trixi kernel: [25262.605312] Linux video capture interface: v2.00
Feb  8 17:49:29 trixi kernel: [25262.652308] em28xx: New device @ 480 Mbps (eb1a:2863, interface 0, class 0)
Feb  8 17:49:29 trixi kernel: [25262.652455] em28xx #0: chip ID is em2860
Feb  8 17:49:29 trixi kernel: [25262.654115] IR NEC protocol handler initialized
Feb  8 17:49:29 trixi kernel: [25262.662558] IR RC5(x) protocol handler initialized
Feb  8 17:49:29 trixi kernel: [25262.664051] IR RC6 protocol handler initialized
Feb  8 17:49:29 trixi kernel: [25262.705150] IR JVC protocol handler initialized
Feb  8 17:49:29 trixi kernel: [25262.707222] IR Sony protocol handler initialized
Feb  8 17:49:29 trixi kernel: [25262.711403] lirc_dev: IR Remote Control driver registered, major 250 
Feb  8 17:49:29 trixi kernel: [25262.713074] IR LIRC bridge handler initialized
Feb  8 17:49:29 trixi kernel: [25262.721379] em28xx #0: board has no eeprom
Feb  8 17:49:29 trixi kernel: [25262.721383] em28xx #0: Identified as EM2860/TVP5150 Reference Design (card=29)
Feb  8 17:49:29 trixi kernel: [25262.721383] em28xx #0: Identified as EM2860/TVP5150 Reference Design (card=29)
Feb  8 17:49:29 trixi kernel: [25262.735736] tvp5150 7-005c: chip found @ 0xb8 (em28xx #0)
Feb  8 17:49:29 trixi kernel: [25262.760050] em28xx #0: Config register raw data: 0x10
Feb  8 17:49:29 trixi kernel: [25262.772027] em28xx #0: AC97 vendor ID = 0x83847650
Feb  8 17:49:29 trixi kernel: [25262.778005] em28xx #0: AC97 features = 0x6a90
Feb  8 17:49:29 trixi kernel: [25262.778007] em28xx #0: Sigmatel audio processor detected(stac 9750)
Feb  8 17:49:30 trixi kernel: [25263.054539] tvp5150 7-005c: tvp5150am1 detected.
Feb  8 17:49:31 trixi kernel: [25264.166164] em28xx #0: v4l2 driver version 0.1.2
Feb  8 17:49:31 trixi kernel: [25264.672948] em28xx #0: V4L2 video device registered as video0
Feb  8 17:49:31 trixi kernel: [25264.672951] em28xx #0: V4L2 VBI device registered as vbi0
Feb  8 17:49:31 trixi kernel: [25264.673015] usbcore: registered new interface driver em28xx
Feb  8 17:49:31 trixi kernel: [25264.673019] em28xx driver loaded
Feb  8 17:49:31 trixi kernel: [25264.704161] em28xx-audio.c: probing for em28x1 non standard usbaudio
Feb  8 17:49:31 trixi kernel: [25264.704165] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Feb  8 17:49:31 trixi kernel: [25264.704637] Em28xx: Initialized (Em28xx Audio Extension) extension
Feb  8 17:49:31 trixi kernel: [25264.876698] tvp5150 7-005c: tvp5150am1 detected.
Feb  8 17:49:33 trixi kernel: [25266.413760] tvp5150 7-005c: tvp5150am1 detected.

--Boundary-00=_k4bUNBVjV0xb0Ce
Content-Type: text/plain;
  charset="utf-8";
  name="log.v4l-info"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.v4l-info"


### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "em28xx"
	card                    : "EM2860/TVP5150 Reference Design"
	bus_info                : "usb-0000:00:1d.7-5"
	version                 : 0.1.2
	capabilities            : 0x5030051 [VIDEO_CAPTURE,VBI_CAPTURE,?,TUNER,AUDIO,READWRITE,STREAMING]

standards
    VIDIOC_ENUMSTD(0)
	index                   : 0
	id                      : 0xb000 [NTSC_M,NTSC_M_JP,?]
	name                    : "NTSC"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(1)
	index                   : 1
	id                      : 0x1000 [NTSC_M]
	name                    : "NTSC-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(2)
	index                   : 2
	id                      : 0x2000 [NTSC_M_JP]
	name                    : "NTSC-M-JP"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(3)
	index                   : 3
	id                      : 0x8000 [?]
	name                    : "NTSC-M-KR"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(4)
	index                   : 4
	id                      : 0x4000 [?]
	name                    : "NTSC-443"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(5)
	index                   : 5
	id                      : 0xff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
	name                    : "PAL"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(6)
	index                   : 6
	id                      : 0x7 [PAL_B,PAL_B1,PAL_G]
	name                    : "PAL-BG"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(7)
	index                   : 7
	id                      : 0x8 [PAL_H]
	name                    : "PAL-H"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(8)
	index                   : 8
	id                      : 0x10 [PAL_I]
	name                    : "PAL-I"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(9)
	index                   : 9
	id                      : 0xe0 [PAL_D,PAL_D1,PAL_K]
	name                    : "PAL-DK"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(10)
	index                   : 10
	id                      : 0x100 [PAL_M]
	name                    : "PAL-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(11)
	index                   : 11
	id                      : 0x200 [PAL_N]
	name                    : "PAL-N"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(12)
	index                   : 12
	id                      : 0x400 [PAL_Nc]
	name                    : "PAL-Nc"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(13)
	index                   : 13
	id                      : 0x800 [PAL_60]
	name                    : "PAL-60"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(14)
	index                   : 14
	id                      : 0xff0000 [SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	name                    : "SECAM"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(15)
	index                   : 15
	id                      : 0x10000 [SECAM_B]
	name                    : "SECAM-B"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(16)
	index                   : 16
	id                      : 0x40000 [SECAM_G]
	name                    : "SECAM-G"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(17)
	index                   : 17
	id                      : 0x80000 [SECAM_H]
	name                    : "SECAM-H"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(18)
	index                   : 18
	id                      : 0x320000 [SECAM_D,SECAM_K,SECAM_K1]
	name                    : "SECAM-DK"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(19)
	index                   : 19
	id                      : 0x400000 [SECAM_L]
	name                    : "SECAM-L"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(20)
	index                   : 20
	id                      : 0x800000 [?ATSC_8_VSB]
	name                    : "SECAM-Lc"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "Composite1"
	type                    : CAMERA
	audioset                : 0
	tuner                   : 0
	std                     : 0xffffff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(1)
	index                   : 1
	name                    : "S-Video"
	type                    : CAMERA
	audioset                : 0
	tuner                   : 0
	std                     : 0xffffff [PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []

tuners
    VIDIOC_G_TUNER(0)
	index                   : 0
	name                    : "Tuner"
	type                    : ANALOG_TV
	capability              : 0x0 []
	rangelow                : 0
	rangehigh               : 0
	rxsubchans              : 0x0 []
	audmode                 : MONO
	signal                  : 65535
	afc                     : 0

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
	index                   : 0
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp YUY2, 4:2:2, packed"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
	index                   : 1
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp RGB 565, LE"
	pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
	index                   : 2
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp Bayer BGBG..GRGR"
	pixelformat             : 0x31384142 [BA81]
    VIDIOC_ENUM_FMT(3,VIDEO_CAPTURE)
	index                   : 3
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp Bayer GRGR..BGBG"
	pixelformat             : 0x47425247 [GRBG]
    VIDIOC_ENUM_FMT(4,VIDEO_CAPTURE)
	index                   : 4
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp Bayer GBGB..RGRG"
	pixelformat             : 0x47524247 [GBRG]
    VIDIOC_ENUM_FMT(5,VIDEO_CAPTURE)
	index                   : 5
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "12 bpp YUV411"
	pixelformat             : 0x50313134 [411P]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 720
	fmt.pix.height          : 576
	fmt.pix.pixelformat     : 0x56595559 [YUYV]
	fmt.pix.field           : INTERLACED
	fmt.pix.bytesperline    : 1440
	fmt.pix.sizeimage       : 829440
	fmt.pix.colorspace      : SMPTE170M
	fmt.pix.priv            : 0

vbi capture
    VIDIOC_G_FMT(VBI_CAPTURE)
	type                    : VBI_CAPTURE
	fmt.vbi.sampling_rate   : 13500000
	fmt.vbi.offset          : 0
	fmt.vbi.samples_per_line: 720
	fmt.vbi.sample_format   : 0x59455247 [GREY]
	fmt.vbi.start[0]        : 6
	fmt.vbi.start[1]        : 318
	fmt.vbi.count[0]        : 18
	fmt.vbi.count[1]        : 18
	fmt.vbi.flags           : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+1)
	id                      : 9963777
	type                    : INTEGER
	name                    : "Contrast"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+2)
	id                      : 9963778
	type                    : INTEGER
	name                    : "Saturation"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 32
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : -128
	maximum                 : 127
	step                    : 1
	default_value           : 0
	flags                   : 32

--Boundary-00=_k4bUNBVjV0xb0Ce--
