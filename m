Return-path: <mchehab@pedra>
Received: from DSL01.212.114.205.243.ip-pool.NEFkom.net ([212.114.205.243]:39455
	"EHLO enzo.pibbs.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948Ab1AXScA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 13:32:00 -0500
Received: from trixi.localnet (trixi.pibbs.org [192.168.20.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by enzo.pibbs.org (Postfix) with ESMTPS id DCFDDDCF46
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 19:32:03 +0100 (CET)
From: Martin Seekatz <martin@pibbs.de>
To: linux-media@vger.kernel.org
Subject: Silver Crest VG2000  "USB 2.0 Video Grabber", USB-Id: eb1a:2863 (em28xx) status change
Date: Mon, 24 Jan 2011 19:31:55 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bWcPN991VFtCsPt"
Message-Id: <201101241931.55829.martin@pibbs.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_bWcPN991VFtCsPt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hello,

the last updates has changed the behavior of a.m. device in 
conjunction with vlc and motv aplication.

Kernel "Linux trixi 2.6.34.7-0.7-desktop #1 SMP PREEMPT 2010-12-13 
11:13:53 +0100 x86_64 x86_64 x86_64 GNU/Linux"

TV applications vlc and motv is showing the video output of a 
connected VCR-Recorder - but without sound. With vlc the sound is 
played in audio mode, if the audioinput device of the video grabber 
device is selected.
So both signals are received, but not played together in video mode.

In order to keep this message better readable the system informations 
are attached.

Best regards
Martin

-- 
Microsoft makes the easy stuff easy, and the rest impossible.
Unix makes everything possible, but nothing too easy

--Boundary-00=_bWcPN991VFtCsPt
Content-Type: text/plain;
  charset="UTF-8";
  name="log.dmesg-mit.20110124"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.dmesg-mit.20110124"

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
[    0.001000] Detected 2666.760 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.52 BogoMIPS (lpj=2666760)
[    0.000058] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
[    0.000117] Security Framework initialized
[    0.000128] AppArmor: AppArmor initialized
[    0.000589] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.002121] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002862] Mount-cache hash table entries: 256
[    0.002952] CPU: Physical Processor ID: 0
[    0.002953] CPU: Processor Core ID: 0
[    0.002957] mce: CPU supports 9 MCE banks
[    0.002965] CPU0: Thermal monitoring enabled (TM1)
[    0.002971] using mwait in idle threads.
[    0.002972] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.002976] ... version:                3
[    0.002976] ... bit width:              48
[    0.002977] ... generic registers:      4
[    0.002978] ... value mask:             0000ffffffffffff
[    0.002979] ... max period:             000000007fffffff
[    0.002980] ... fixed-purpose events:   3
[    0.002981] ... event mask:             000000070000000f
[    0.003045] Unpacking initramfs...
[    0.151835] Freeing initrd memory: 10372k freed
[    0.153167] ACPI: Core revision 20100121
[    0.185348] Setting APIC routing to flat
[    0.185810] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.195787] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.383071] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    1.018425] Brought up 8 CPUs
[    1.018428] Total of 8 processors activated (42661.12 BogoMIPS).
[    1.021517] devtmpfs: initialized
[    1.022844] regulator: core version 0.5
[    1.022868] regulator: dummy: 
[    1.022886] Time: 16:55:59  Date: 01/24/11
[    1.022929] NET: Registered protocol family 16
[    1.023008] ACPI: bus type pci registered
[    1.023050] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.023052] PCI: not using MMCONFIG
[    1.023053] PCI: Using configuration type 1 for base access
[    1.023710] bio: create slab <bio-0> at 0
[    1.024924] ACPI: EC: Look up EC in DSDT
[    1.026049] ACPI: Executed 1 blocks of module-level executable AML code
[    1.032924] ACPI: SSDT 00000000cf79e0c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.033370] ACPI: SSDT 00000000cf7a0140 003B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.034009] ACPI: SSDT 00000000cf79e4d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    1.034385] ACPI: SSDT 00000000cf7a0500 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    1.035022] ACPI: SSDT 00000000cf79e8e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
[    1.035395] ACPI: SSDT 00000000cf7a0590 00085 (v01  PmRef  P003Cst 00003000 INTL 20051117)
[    1.036043] ACPI: SSDT 00000000cf79ecf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
[    1.036419] ACPI: SSDT 00000000cf7a0620 00085 (v01  PmRef  P004Cst 00003000 INTL 20051117)
[    1.037063] ACPI: SSDT 00000000cf79f100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20051117)
[    1.037448] ACPI: SSDT 00000000cf7a06b0 00085 (v01  PmRef  P005Cst 00003000 INTL 20051117)
[    1.038087] ACPI: SSDT 00000000cf79f510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20051117)
[    1.038465] ACPI: SSDT 00000000cf7a0740 00085 (v01  PmRef  P006Cst 00003000 INTL 20051117)
[    1.039107] ACPI: SSDT 00000000cf79f920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20051117)
[    1.039487] ACPI: SSDT 00000000cf7a07d0 00085 (v01  PmRef  P007Cst 00003000 INTL 20051117)
[    1.040135] ACPI: SSDT 00000000cf79fd30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20051117)
[    1.040519] ACPI: SSDT 00000000cf7a0860 00085 (v01  PmRef  P008Cst 00003000 INTL 20051117)
[    1.040808] ACPI: Interpreter enabled
[    1.040810] ACPI: (supports S0 S1 S3 S4 S5)
[    1.040829] ACPI: Using IOAPIC for interrupt routing
[    1.040871] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    1.042009] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    1.078410] ACPI: No dock devices found.
[    1.078412] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.078554] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.078829] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.078831] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.078833] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.078835] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    1.078837] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xdfffffff]
[    1.078838] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    1.078887] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.078890] pci 0000:00:00.0: PME# disabled
[    1.078943] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.078945] pci 0000:00:01.0: PME# disabled
[    1.078997] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.078999] pci 0000:00:03.0: PME# disabled
[    1.079053] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.079055] pci 0000:00:07.0: PME# disabled
[    1.079158] pci 0000:00:13.0: reg 10: [mem 0xfec8a000-0xfec8afff]
[    1.079185] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.079187] pci 0000:00:13.0: PME# disabled
[    1.079370] pci 0000:00:19.0: reg 10: [mem 0xf7ec0000-0xf7edffff]
[    1.079375] pci 0000:00:19.0: reg 14: [mem 0xf7ef2000-0xf7ef2fff]
[    1.079380] pci 0000:00:19.0: reg 18: [io  0xb080-0xb09f]
[    1.079413] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    1.079416] pci 0000:00:19.0: PME# disabled
[    1.079455] pci 0000:00:1a.0: reg 20: [io  0xb400-0xb41f]
[    1.079511] pci 0000:00:1a.1: reg 20: [io  0xb480-0xb49f]
[    1.079567] pci 0000:00:1a.2: reg 20: [io  0xb800-0xb81f]
[    1.079623] pci 0000:00:1a.7: reg 10: [mem 0xf7ef8000-0xf7ef83ff]
[    1.079670] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.079673] pci 0000:00:1a.7: PME# disabled
[    1.079703] pci 0000:00:1b.0: reg 10: [mem 0xf7ef4000-0xf7ef7fff 64bit]
[    1.079739] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.079742] pci 0000:00:1b.0: PME# disabled
[    1.079798] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.079801] pci 0000:00:1c.0: PME# disabled
[    1.079859] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.079862] pci 0000:00:1c.2: PME# disabled
[    1.079908] pci 0000:00:1d.0: reg 20: [io  0xb880-0xb89f]
[    1.079964] pci 0000:00:1d.1: reg 20: [io  0xbc00-0xbc1f]
[    1.080023] pci 0000:00:1d.2: reg 20: [io  0xc000-0xc01f]
[    1.080078] pci 0000:00:1d.7: reg 10: [mem 0xf7efa000-0xf7efa3ff]
[    1.080126] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.080129] pci 0000:00:1d.7: PME# disabled
[    1.080229] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.080232] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.080235] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    1.080287] pci 0000:00:1f.2: reg 10: [io  0xc880-0xc887]
[    1.080291] pci 0000:00:1f.2: reg 14: [io  0xc800-0xc803]
[    1.080295] pci 0000:00:1f.2: reg 18: [io  0xc480-0xc487]
[    1.080300] pci 0000:00:1f.2: reg 1c: [io  0xc400-0xc403]
[    1.080304] pci 0000:00:1f.2: reg 20: [io  0xc080-0xc09f]
[    1.080308] pci 0000:00:1f.2: reg 24: [mem 0xf7efc000-0xf7efc7ff]
[    1.080335] pci 0000:00:1f.2: PME# supported from D3hot
[    1.080338] pci 0000:00:1f.2: PME# disabled
[    1.080361] pci 0000:00:1f.3: reg 10: [mem 0xf7efe000-0xf7efe0ff 64bit]
[    1.080372] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    1.080420] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    1.080423] pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.080426] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.080430] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.080476] pci 0000:05:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    1.080484] pci 0000:05:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.080491] pci 0000:05:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    1.080496] pci 0000:05:00.0: reg 24: [io  0xec00-0xec7f]
[    1.080500] pci 0000:05:00.0: reg 30: [mem 0xfbe80000-0xfbefffff pref]
[    1.082258] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    1.082262] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    1.082266] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbefffff]
[    1.082272] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.082308] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    1.082311] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.082314] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.082318] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.082353] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    1.082356] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.082359] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.082363] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.082430] pci 0000:02:00.0: reg 10: [mem 0xf7fff800-0xf7ffffff 64bit]
[    1.082437] pci 0000:02:00.0: reg 18: [io  0xd800-0xd8ff]
[    1.082490] pci 0000:02:00.0: supports D2
[    1.082491] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    1.082495] pci 0000:02:00.0: PME# disabled
[    1.084259] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    1.084263] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    1.084267] pci 0000:00:1c.2:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    1.084273] pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.084338] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    1.084344] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.084347] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.084352] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.084354] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.084355] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.084357] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.084359] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    1.084360] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
[    1.084362] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff] (subtractive decode)
[    1.084385] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.084612] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    1.084665] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    1.084722] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    1.084795] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    1.084846] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    1.109644] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14 15), disabled.
[    1.109743] ACPI: PCI Interrupt Link [LNKB] (IRQs *5), disabled.
[    1.109838] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14 15), disabled.
[    1.109934] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15), disabled.
[    1.110031] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15), disabled.
[    1.110129] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15), disabled.
[    1.110230] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15), disabled.
[    1.110327] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15), disabled.
[    1.110427] vgaarb: device added: PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.110429] vgaarb: loaded
[    1.110446] usbcore: registered new interface driver usbfs
[    1.110455] usbcore: registered new interface driver hub
[    1.110473] usbcore: registered new device driver usb
[    1.110513] PCI: Using ACPI for IRQ routing
[    1.110515] PCI: pci_cache_line_size set to 64 bytes
[    1.110588] reserve RAM buffer: 000000000009ec00 - 000000000009ffff 
[    1.110590] reserve RAM buffer: 00000000cf790000 - 00000000cfffffff 
[    1.110641] NetLabel: Initializing
[    1.110642] NetLabel:  domain hash size = 128
[    1.110643] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.110652] NetLabel:  unlabeled traffic allowed by default
[    1.110656] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    1.110661] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.110664] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.116182] Switching to clocksource tsc
[    1.117210] AppArmor: AppArmor Filesystem Enabled
[    1.117217] pnp: PnP ACPI init
[    1.117224] ACPI: bus type pnp registered
[    1.119046] pnp: PnP ACPI: found 12 devices
[    1.119047] ACPI: ACPI bus type pnp unregistered
[    1.119056] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    1.119058] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.119060] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.119062] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    1.119064] system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
[    1.119065] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    1.119070] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    1.119074] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    1.119075] system 00:07: [io  0x0800-0x087f] has been reserved
[    1.119077] system 00:07: [io  0x0500-0x057f] could not be reserved
[    1.119079] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.119081] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.119083] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    1.119087] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.119089] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.119092] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    1.119095] system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.119097] system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
[    1.119099] system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.119101] system 00:0b: [mem 0x00100000-0xcfffffff] could not be reserved
[    1.119103] system 00:0b: [mem 0xfed90000-0xffffffff] could not be reserved
[    1.123878] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf0000000-0xf01fffff]
[    1.123881] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.123883] pci 0000:00:1c.2: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.123885] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    1.123887] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    1.123888] pci 0000:00:01.0:   bridge window [io  disabled]
[    1.123891] pci 0000:00:01.0:   bridge window [mem disabled]
[    1.123893] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    1.123897] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    1.123900] pci 0000:00:03.0:   bridge window [io  0xe000-0xefff]
[    1.123903] pci 0000:00:03.0:   bridge window [mem 0xf8000000-0xfbefffff]
[    1.123906] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.123910] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    1.123911] pci 0000:00:07.0:   bridge window [io  disabled]
[    1.123914] pci 0000:00:07.0:   bridge window [mem disabled]
[    1.123916] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    1.123920] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    1.123922] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    1.123926] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf01fffff]
[    1.123929] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.123934] pci 0000:00:1c.2: PCI bridge to [bus 02-02]
[    1.123936] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    1.123940] pci 0000:00:1c.2:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    1.123943] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.123947] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    1.123948] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.123952] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.123954] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.123965] pci 0000:00:01.0: setting latency timer to 64
[    1.123971] pci 0000:00:03.0: setting latency timer to 64
[    1.123977] pci 0000:00:07.0: setting latency timer to 64
[    1.123983] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    1.123987]   alloc irq_desc for 17 on node -1
[    1.123988]   alloc kstat_irqs on node -1
[    1.123992] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.123995] pci 0000:00:1c.0: setting latency timer to 64
[    1.124001]   alloc irq_desc for 18 on node -1
[    1.124002]   alloc kstat_irqs on node -1
[    1.124005] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.124008] pci 0000:00:1c.2: setting latency timer to 64
[    1.124012] pci 0000:00:1e.0: setting latency timer to 64
[    1.124015] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.124016] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.124018] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.124019] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    1.124021] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    1.124022] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.124024] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    1.124025] pci_bus 0000:05: resource 1 [mem 0xf8000000-0xfbefffff]
[    1.124027] pci_bus 0000:05: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.124028] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    1.124030] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf01fffff]
[    1.124031] pci_bus 0000:03: resource 2 [mem 0xf0200000-0xf03fffff 64bit pref]
[    1.124033] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    1.124034] pci_bus 0000:02: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    1.124036] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.124037] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.124038] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    1.124040] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.124041] pci_bus 0000:01: resource 7 [mem 0x000d0000-0x000dffff]
[    1.124043] pci_bus 0000:01: resource 8 [mem 0xd0000000-0xdfffffff]
[    1.124044] pci_bus 0000:01: resource 9 [mem 0xf0000000-0xfed8ffff]
[    1.124090] NET: Registered protocol family 2
[    1.124262] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.125054] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.126543] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.126761] TCP: Hash tables configured (established 524288 bind 65536)
[    1.126762] TCP reno registered
[    1.126774] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.126809] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.126925] NET: Registered protocol family 1
[    1.127090] pci 0000:05:00.0: Boot video device
[    1.127094] PCI: CLS 64 bytes, default 64
[    1.127096] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.127097] Placing 64MB software IO TLB between ffff880001fdc000 - ffff880005fdc000
[    1.127099] software IO TLB at phys 0x1fdc000 - 0x5fdc000
[    1.127611] Scanning for low memory corruption every 60 seconds
[    1.127717] audit: initializing netlink socket (disabled)
[    1.127725] type=2000 audit(1295888157.906:1): initialized
[    1.137946] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.138246] VFS: Disk quotas dquot_6.5.2
[    1.138267] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.138388] msgmni has been set to 2984
[    1.138544] alg: No test for stdrng (krng)
[    1.138565] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.138567] io scheduler noop registered
[    1.138568] io scheduler deadline registered
[    1.138583] io scheduler cfq registered (default)
[    1.138707] pcieport 0000:00:01.0: setting latency timer to 64
[    1.138732]   alloc irq_desc for 48 on node -1
[    1.138733]   alloc kstat_irqs on node -1
[    1.138741] pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
[    1.138791] pcieport 0000:00:03.0: setting latency timer to 64
[    1.138814]   alloc irq_desc for 49 on node -1
[    1.138815]   alloc kstat_irqs on node -1
[    1.138820] pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
[    1.138867] pcieport 0000:00:07.0: setting latency timer to 64
[    1.138890]   alloc irq_desc for 50 on node -1
[    1.138891]   alloc kstat_irqs on node -1
[    1.138896] pcieport 0000:00:07.0: irq 50 for MSI/MSI-X
[    1.138945] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.138971]   alloc irq_desc for 51 on node -1
[    1.138972]   alloc kstat_irqs on node -1
[    1.138978] pcieport 0000:00:1c.0: irq 51 for MSI/MSI-X
[    1.139037] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.139062]   alloc irq_desc for 52 on node -1
[    1.139063]   alloc kstat_irqs on node -1
[    1.139069] pcieport 0000:00:1c.2: irq 52 for MSI/MSI-X
[    1.139136] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.139141] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.139145] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.139165] pci-stub: invalid id string ""
[    1.140062] vesafb: framebuffer at 0xf9000000, mapped to 0xffffc90011800000, using 7500k, total 14336k
[    1.140064] vesafb: mode is 1600x1200x16, linelength=3200, pages=1
[    1.140065] vesafb: scrolling: redraw
[    1.140067] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    1.140224] bootsplash 3.1.6-2004/03/31: looking for picture...
[    1.140226] bootsplash: silentjpeg size 238929 bytes
[    1.161770] bootsplash: ...found (1600x1200, 114103 bytes, v3).
[    1.343277] Console: switching to colour frame buffer device 196x71
[    1.524488] fb0: VESA VGA frame buffer device
[    1.525403] Non-volatile memory driver v1.3
[    1.525405] Linux agpgart interface v0.103
[    1.525424] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    1.525728] Fixed MDIO Bus: probed
[    1.525732] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.525749] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.525762] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.525765] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.525778] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.525800] ehci_hcd 0000:00:1a.7: debug port 1
[    1.529676] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.529689] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7ef8000
[    1.538391] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.538413] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.538416] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.538418] usb usb1: Product: EHCI Host Controller
[    1.538420] usb usb1: Manufacturer: Linux 2.6.34.7-0.7-desktop ehci_hcd
[    1.538423] usb usb1: SerialNumber: 0000:00:1a.7
[    1.538508] hub 1-0:1.0: USB hub found
[    1.538511] hub 1-0:1.0: 6 ports detected
[    1.538564]   alloc irq_desc for 23 on node -1
[    1.538566]   alloc kstat_irqs on node -1
[    1.538570] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.538579] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.538582] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.538588] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.538606] ehci_hcd 0000:00:1d.7: debug port 1
[    1.542491] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.542501] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7efa000
[    1.552169] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.552190] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.552192] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.552195] usb usb2: Product: EHCI Host Controller
[    1.552197] usb usb2: Manufacturer: Linux 2.6.34.7-0.7-desktop ehci_hcd
[    1.552199] usb usb2: SerialNumber: 0000:00:1d.7
[    1.552279] hub 2-0:1.0: USB hub found
[    1.552282] hub 2-0:1.0: 6 ports detected
[    1.552329] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.552337] uhci_hcd: USB Universal Host Controller Interface driver
[    1.552365]   alloc irq_desc for 16 on node -1
[    1.552366]   alloc kstat_irqs on node -1
[    1.552369] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.552374] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.552376] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.552381] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.552409] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000b400
[    1.552431] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.552433] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.552434] usb usb3: Product: UHCI Host Controller
[    1.552435] usb usb3: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.552437] usb usb3: SerialNumber: 0000:00:1a.0
[    1.552491] hub 3-0:1.0: USB hub found
[    1.552495] hub 3-0:1.0: 2 ports detected
[    1.552534]   alloc irq_desc for 21 on node -1
[    1.552536]   alloc kstat_irqs on node -1
[    1.552539] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.552543] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.552545] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.552550] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.552575] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b480
[    1.552597] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.552599] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.552600] usb usb4: Product: UHCI Host Controller
[    1.552602] usb usb4: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.552603] usb usb4: SerialNumber: 0000:00:1a.1
[    1.552657] hub 4-0:1.0: USB hub found
[    1.552660] hub 4-0:1.0: 2 ports detected
[    1.552699]   alloc irq_desc for 19 on node -1
[    1.552700]   alloc kstat_irqs on node -1
[    1.552703] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.552708] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.552710] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.552714] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.552740] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
[    1.552762] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.552763] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.552765] usb usb5: Product: UHCI Host Controller
[    1.552766] usb usb5: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.552767] usb usb5: SerialNumber: 0000:00:1a.2
[    1.552818] hub 5-0:1.0: USB hub found
[    1.552821] hub 5-0:1.0: 2 ports detected
[    1.552861] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.552865] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.552867] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.552871] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.552891] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b880
[    1.552912] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.552914] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.552915] usb usb6: Product: UHCI Host Controller
[    1.552916] usb usb6: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.552918] usb usb6: SerialNumber: 0000:00:1d.0
[    1.552969] hub 6-0:1.0: USB hub found
[    1.552972] hub 6-0:1.0: 2 ports detected
[    1.553011] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.553015] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.553017] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.553022] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.553042] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000bc00
[    1.553064] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.553065] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.553067] usb usb7: Product: UHCI Host Controller
[    1.553068] usb usb7: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.553069] usb usb7: SerialNumber: 0000:00:1d.1
[    1.553121] hub 7-0:1.0: USB hub found
[    1.553123] hub 7-0:1.0: 2 ports detected
[    1.553162] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.553166] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.553169] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.553173] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.553192] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000c000
[    1.553214] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.553216] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.553217] usb usb8: Product: UHCI Host Controller
[    1.553218] usb usb8: Manufacturer: Linux 2.6.34.7-0.7-desktop uhci_hcd
[    1.553219] usb usb8: SerialNumber: 0000:00:1d.2
[    1.553270] hub 8-0:1.0: USB hub found
[    1.553273] hub 8-0:1.0: 2 ports detected
[    1.553339] PNP: No PS/2 controller found. Probing ports directly.
[    1.553661] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.553665] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.553702] mice: PS/2 mouse device common for all mice
[    1.553755] rtc_cmos 00:03: RTC can wake from S4
[    1.553777] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.553800] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.553807] cpuidle: using governor ladder
[    1.553808] cpuidle: using governor menu
[    1.553959] usbcore: registered new interface driver hiddev
[    1.553966] usbcore: registered new interface driver usbhid
[    1.553967] usbhid: USB HID core driver
[    1.619688] TCP cubic registered
[    1.619740] NET: Registered protocol family 10
[    1.619989] lo: Disabled Privacy Extensions
[    1.620141] lib80211: common routines for IEEE802.11 drivers
[    1.620143] lib80211_crypt: registered algorithm 'NULL'
[    1.620196] PM: Checking image partition /dev/disk/by-id/ata-ST31000528AS_6VP07CBM-part6
[    1.662316] PM: Resume from disk failed.
[    1.662331] registered taskstats version 1
[    1.662585]   Magic number: 11:360:945
[    1.662592] tty tty2: hash matches
[    1.662634] rtc_cmos 00:03: setting system clock to 2011-01-24 16:55:59 UTC (1295888159)
[    1.662680] Freeing unused kernel memory: 892k freed
[    1.662793] Write protecting the kernel read-only data: 10240k
[    1.662925] Freeing unused kernel memory: 1344k freed
[    1.663139] Freeing unused kernel memory: 632k freed
[    1.692939] SCSI subsystem initialized
[    1.705758] libata version 3.00 loaded.
[    1.708707] ahci 0000:00:1f.2: version 3.0
[    1.708720] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.708755]   alloc irq_desc for 53 on node -1
[    1.708757]   alloc kstat_irqs on node -1
[    1.708765] ahci 0000:00:1f.2: irq 53 for MSI/MSI-X
[    1.708788] ahci: SSS flag set, parallel bus scan disabled
[    1.708822] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.708825] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    1.708828] ahci 0000:00:1f.2: setting latency timer to 64
[    1.718153] scsi0 : ahci
[    1.718225] scsi1 : ahci
[    1.718256] scsi2 : ahci
[    1.718286] scsi3 : ahci
[    1.718316] scsi4 : ahci
[    1.718344] scsi5 : ahci
[    1.718486] ata1: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc100 irq 53
[    1.718488] ata2: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc180 irq 53
[    1.718490] ata3: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc200 irq 53
[    1.718492] ata4: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc280 irq 53
[    1.718494] ata5: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc300 irq 53
[    1.718496] ata6: SATA max UDMA/133 abar m2048@0xf7efc000 port 0xf7efc380 irq 53
[    1.839440] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    1.954771] usb 1-3: New USB device found, idVendor=05e3, idProduct=0605
[    1.954775] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    1.954777] usb 1-3: Product: USB2.0 Hub
[    1.955173] hub 1-3:1.0: USB hub found
[    1.955518] hub 1-3:1.0: 4 ports detected
[    2.021966] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.048853] ata1.00: ATA-8: ST31000528AS, CC44, max UDMA/133
[    2.048856] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.057868] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    2.088242] ata1.00: configured for UDMA/133
[    2.098853] scsi 0:0:0:0: Direct-Access     ATA      ST31000528AS     CC44 PQ: 0 ANSI: 5
[    2.173207] usb 1-4: New USB device found, idVendor=05e3, idProduct=0605
[    2.173211] usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    2.173213] usb 1-4: Product: USB2.0 Hub
[    2.173482] hub 1-4:1.0: USB hub found
[    2.173833] hub 1-4:1.0: 4 ports detected
[    2.276305] usb 1-5: new high speed USB device using ehci_hcd and address 4
[    2.398877] usb 1-5: New USB device found, idVendor=152d, idProduct=2329
[    2.398880] usb 1-5: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    2.398882] usb 1-5: Product: Storagebird 35EV821
[    2.398884] usb 1-5: Manufacturer: 0123456
[    2.398886] usb 1-5: SerialNumber: 00000000000D
[    2.500736] usb 2-4: new high speed USB device using ehci_hcd and address 2
[    2.661050] usb 2-4: New USB device found, idVendor=0424, idProduct=2250
[    2.661054] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.661056] usb 2-4: Product: Flash
[    2.661058] usb 2-4: Manufacturer: Generic
[    2.661060] usb 2-4: SerialNumber: 000000002250
[    2.734388] usb 1-3.2: new low speed USB device using ehci_hcd and address 5
[    2.819914] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.822612] ata2.00: ATAPI: HL-DT-ST DVDRAM GH20NS10, EL00, max UDMA/100
[    2.825901] usb 1-3.2: New USB device found, idVendor=040b, idProduct=6510
[    2.825905] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.825907] usb 1-3.2: Product: Bar Code Reader
[    2.825909] usb 1-3.2: Manufacturer: Weltrend
[    2.826597] ata2.00: configured for UDMA/100
[    2.829019] input: Weltrend Bar Code Reader as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.2/1-3.2:1.0/input/input0
[    2.829067] generic-usb 0003:040B:6510.0001: input,hidraw0: USB HID v1.10 Keyboard [Weltrend Bar Code Reader] on usb-0000:00:1a.7-3.2/input0
[    2.891982] usb 1-4.1: new low speed USB device using ehci_hcd and address 6
[    2.950394] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH20NS10  EL00 PQ: 0 ANSI: 5
[    2.986240] usb 1-4.1: New USB device found, idVendor=04f2, idProduct=0116
[    2.986244] usb 1-4.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.986246] usb 1-4.1: Product: USB Keyboard
[    2.986248] usb 1-4.1: Manufacturer: CHICONY
[    2.990983] input: CHICONY USB Keyboard as /devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.1/1-4.1:1.0/input/input1
[    2.991026] generic-usb 0003:04F2:0116.0002: input,hidraw1: USB HID v1.10 Keyboard [CHICONY USB Keyboard] on usb-0000:00:1a.7-4.1/input0
[    3.053566] usb 1-4.2: new low speed USB device using ehci_hcd and address 7
[    3.132238] usb 1-4.2: New USB device found, idVendor=046d, idProduct=c018
[    3.132241] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.132244] usb 1-4.2: Product: USB Optical Mouse
[    3.132246] usb 1-4.2: Manufacturer: Logitech
[    3.134214] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4.2/1-4.2:1.0/input/input2
[    3.134258] generic-usb 0003:046D:C018.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1a.7-4.2/input0
[    3.197196] usb 1-4.4: new full speed USB device using ehci_hcd and address 8
[    3.253792] ata3: SATA link down (SStatus 0 SControl 300)
[    3.320505] usb 1-4.4: New USB device found, idVendor=0c4b, idProduct=0100
[    3.320509] usb 1-4.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.568980] ata4: SATA link down (SStatus 0 SControl 300)
[    3.884168] ata5: SATA link down (SStatus 0 SControl 300)
[    4.199356] ata6: SATA link down (SStatus 0 SControl 300)
[    4.214268] Monitor-Mwait will be used to enter C-1 state
[    4.214283] Monitor-Mwait will be used to enter C-2 state
[    4.214296] Monitor-Mwait will be used to enter C-3 state
[    4.220517] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    4.223924] udev: starting version 157
[    4.251865] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.251895] sd 0:0:0:0: [sda] Write Protect is off
[    4.251897] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.251909] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.252019]  sda: sda1 sda2 < sda5 sda6 > sda3 sda4
[    4.304573] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.008831] PM: Marking nosave pages: 000000000009e000 - 0000000000100000
[    5.008835] PM: Marking nosave pages: 00000000cf790000 - 0000000100000000
[    5.009245] PM: Basic memory bitmaps created
[    5.025687] PM: Basic memory bitmaps freed
[    5.081285] PM: Starting manual resume from disk
[    5.081287] PM: Resume from partition 8:6
[    5.081288] PM: Checking hibernation image.
[    5.081542] PM: Error -22 checking image file
[    5.081544] PM: Resume from disk failed.
[    5.297911] kjournald starting.  Commit interval 15 seconds
[    5.298091] EXT3-fs (sda3): using internal journal
[    5.298096] EXT3-fs (sda3): mounted filesystem with ordered data mode
[    6.712019] preloadtrace: systemtap: 1.1/0.147, base: ffffffffa00c5000, memory: 37data/40text/101ctx/13net/442alloc kb, probes: 44
[    8.331162] udev: starting version 157
[    8.345839] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    8.345874] ACPI: Power Button [PWRB]
[    8.345923] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    8.345951] ACPI: Power Button [PWRF]
[    8.361974] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    8.361977] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    8.362009]   alloc irq_desc for 20 on node -1
[    8.362012]   alloc kstat_irqs on node -1
[    8.362019] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    8.362027] e1000e 0000:00:19.0: setting latency timer to 64
[    8.362128]   alloc irq_desc for 54 on node -1
[    8.362130]   alloc kstat_irqs on node -1
[    8.362140] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[    8.375646] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    8.380471] iTCO_vendor_support: vendor-support=0
[    8.397295] Initializing USB Mass Storage driver...
[    8.397379] scsi6 : usb-storage 1-5:1.0
[    8.397489] scsi7 : usb-storage 2-4:1.0
[    8.397568] usbcore: registered new interface driver usb-storage
[    8.397570] USB Mass Storage support registered.
[    8.399787] ohci1394 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    8.399794] ohci1394 0000:02:00.0: setting latency timer to 64
[    8.401761] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.401835] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0860)
[    8.401886] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.405733] usbcore: registered new interface driver usbserial
[    8.405745] USB Serial support registered for generic
[    8.405768] usbcore: registered new interface driver usbserial_generic
[    8.405770] usbserial: USB Serial Driver core
[    8.407754] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.407789] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    8.417593] USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    8.417616] cyberjack 1-4.4:1.0: Reiner SCT Cyberjack USB card reader converter detected
[    8.417710] usb 1-4.4: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB0
[    8.417720] usbcore: registered new interface driver cyberjack
[    8.417721] cyberjack: v1.01 Matthias Bruestle
[    8.417722] cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
[    8.432739] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    8.432742] Uniform CD-ROM driver Revision: 3.20
[    8.432920] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    8.453611] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[f7fff800-f7ffffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    8.493777] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:8c:9b:67:c9
[    8.493779] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    8.493799] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    8.493835] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    8.493889]   alloc irq_desc for 22 on node -1
[    8.493891]   alloc kstat_irqs on node -1
[    8.493897] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    8.493955]   alloc irq_desc for 55 on node -1
[    8.493957]   alloc kstat_irqs on node -1
[    8.493967] HDA Intel 0000:00:1b.0: irq 55 for MSI/MSI-X
[    8.493999] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    8.679118] hda_codec: ALC888: BIOS auto-probing.
[    8.679124] ALSA hda_codec.c:4385: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
[    8.679128] ALSA hda_codec.c:4389:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    8.679130] ALSA hda_codec.c:4393:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    8.679132] ALSA hda_codec.c:4394:    mono: mono_out=0x0
[    8.679134] ALSA hda_codec.c:4397:    dig-out=0x11/0x1e
[    8.679136] ALSA hda_codec.c:4405:    inputs: mic=0x18, fmic=0x19, line=0x1c, fline=0x0, cd=0x0, aux=0x0
[    8.680503] ALSA patch_realtek.c:1287: realtek: No valid SSID, checking pincfg 0x411111f0 for NID 0x1d
[    8.680505] ALSA patch_realtek.c:1370: realtek: Enable default setup for auto mode as fallback
[    9.397725] scsi 7:0:0:0: Direct-Access     Generic  Flash HS-CF      1.68 PQ: 0 ANSI: 0
[    9.397862] sd 7:0:0:0: Attached scsi generic sg2 type 0
[    9.399258] scsi 7:0:0:1: Direct-Access     Generic  Flash HS-MS/SD   1.68 PQ: 0 ANSI: 0
[    9.399430] sd 7:0:0:1: Attached scsi generic sg3 type 0
[    9.403201] scsi 7:0:0:2: Direct-Access     Generic  Flash HS-SM      1.68 PQ: 0 ANSI: 0
[    9.403314] sd 7:0:0:2: Attached scsi generic sg4 type 0
[    9.404815] sd 7:0:0:0: [sdb] Attached SCSI removable disk
[    9.406230] sd 7:0:0:1: [sdc] Attached SCSI removable disk
[    9.411703] sd 7:0:0:2: [sdd] Attached SCSI removable disk
[    9.436336] scsi 6:0:0:0: Direct-Access     WDC WD10 EAVS-00D7B0           PQ: 0 ANSI: 2 CCS
[    9.436465] sd 6:0:0:0: Attached scsi generic sg5 type 0
[    9.437815] sd 6:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    9.438635] sd 6:0:0:0: [sde] Write Protect is off
[    9.438638] sd 6:0:0:0: [sde] Mode Sense: 34 00 00 00
[    9.438641] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.440023] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.440030]  sde: sde1
[    9.463817] sd 6:0:0:0: [sde] Assuming drive cache: write through
[    9.463822] sd 6:0:0:0: [sde] Attached SCSI disk
[    9.712421] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c0001df49a2]
[   10.923756] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   11.023298] Adding 2103948k swap on /dev/sda6.  Priority:-1 extents:1 across:2103948k 
[   12.099162] device-mapper: uevent: version 1.0.3
[   12.099496] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[   12.916835] loop: module loaded
[   13.074481] kjournald starting.  Commit interval 15 seconds
[   13.074727] EXT3-fs (sda4): using internal journal
[   13.074732] EXT3-fs (sda4): mounted filesystem with ordered data mode
[   13.094949] fuse init (API version 7.13)
[   14.693980] type=1505 audit(1295884572.564:2): operation="profile_load" pid=1365 name=/bin/ping
[   14.731130] type=1505 audit(1295884572.601:3): operation="profile_load" pid=1366 name=/sbin/klogd
[   14.796963] type=1505 audit(1295884572.667:4): operation="profile_load" pid=1367 name=/sbin/syslog-ng
[   14.880587] type=1505 audit(1295884572.751:5): operation="profile_load" pid=1368 name=/sbin/syslogd
[   14.958955] type=1505 audit(1295884572.830:6): operation="profile_load" pid=1369 name=/usr/sbin/avahi-daemon
[   15.029978] type=1505 audit(1295884572.901:7): operation="profile_load" pid=1370 name=/usr/sbin/identd
[   15.101550] type=1505 audit(1295884572.973:8): operation="profile_load" pid=1371 name=/usr/sbin/mdnsd
[   15.179087] type=1505 audit(1295884573.050:9): operation="profile_load" pid=1372 name=/usr/sbin/nscd
[   15.293691] type=1505 audit(1295884573.165:10): operation="profile_load" pid=1373 name=/usr/sbin/ntpd
[   15.352121] type=1505 audit(1295884573.224:11): operation="profile_load" pid=1374 name=/usr/sbin/traceroute
[   17.144623] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[   17.195347] e1000e 0000:00:19.0: irq 54 for MSI/MSI-X
[   17.195989] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   19.293372] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   19.293375] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   19.294282] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   20.053869] nvidia: module license 'NVIDIA' taints kernel.
[   20.053872] Disabling lock debugging due to kernel taint
[   20.609991]   alloc irq_desc for 24 on node -1
[   20.609993]   alloc kstat_irqs on node -1
[   20.610000] nvidia 0000:05:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[   20.610006] nvidia 0000:05:00.0: setting latency timer to 64
[   20.610009] vgaarb: device changed decodes: PCI:0000:05:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   20.610223] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  256.35  Wed Jun 16 18:42:44 PDT 2010
[   29.515136] eth0: no IPv6 routers present
[   31.773002] bootsplash: status on console 0 changed to on
[ 4967.321310] usb 2-5: new high speed USB device using ehci_hcd and address 3
[ 4967.435364] usb 2-5: New USB device found, idVendor=eb1a, idProduct=2863
[ 4967.435368] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 4967.488921] IR NEC protocol handler initialized
[ 4967.494137] Linux video capture interface: v2.00
[ 4967.494139] WARNING: You're using an experimental version of the V4L stack. As the driver
[ 4967.494141]          is backported to an older kernel, it doesn't offer enough quality for
[ 4967.494142]          its usage in production.
[ 4967.494143]          Use it with care.
[ 4967.520811] em28xx: New device @ 480 Mbps (eb1a:2863, interface 0, class 0)
[ 4967.520910] em28xx #0: chip ID is em2860
[ 4967.522631] IR RC5(x) protocol handler initialized
[ 4967.531730] IR RC6 protocol handler initialized
[ 4967.588016] IR JVC protocol handler initialized
[ 4967.590206] em28xx #0: board has no eeprom
[ 4967.590210] em28xx #0: Identified as EM2860/TVP5150 Reference Design (card=29)
[ 4967.596497] IR Sony protocol handler initialized
[ 4967.631010] tvp5150 7-005c: chip found @ 0xb8 (em28xx #0)
[ 4967.631080] em28xx #0: Config register raw data: 0x10
[ 4967.643688] em28xx #0: AC97 vendor ID = 0x83847650
[ 4967.649673] em28xx #0: AC97 features = 0x6a90
[ 4967.649676] em28xx #0: Sigmatel audio processor detected(stac 9750)
[ 4967.926215] tvp5150 7-005c: tvp5150am1 detected.
[ 4969.036852] em28xx #0: v4l2 driver version 0.1.2
[ 4969.537646] em28xx #0: V4L2 video device registered as video0
[ 4969.537649] em28xx #0: V4L2 VBI device registered as vbi0
[ 4969.537707] usbcore: registered new interface driver em28xx
[ 4969.537710] em28xx driver loaded
[ 4969.564855] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 4969.564859] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 4969.565488] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 4969.736425] tvp5150 7-005c: tvp5150am1 detected.

--Boundary-00=_bWcPN991VFtCsPt
Content-Type: text/plain;
  charset="UTF-8";
  name="log.lsmod-mit.20110124"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.lsmod-mit.20110124"

Module                  Size  Used by
em28xx_alsa             7812  1 
tvp5150                18521  1 
ir_sony_decoder         2485  0 
ir_jvc_decoder          2450  0 
ir_rc6_decoder          3026  0 
ir_rc5_decoder          2514  0 
em28xx                105961  1 em28xx_alsa
v4l2_common            21343  2 tvp5150,em28xx
videodev               51824  3 tvp5150,em28xx,v4l2_common
v4l1_compat            17249  1 videodev
ir_nec_decoder          2514  0 
v4l2_compat_ioctl32    10853  1 videodev
ir_core                17940  6 ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder
videobuf_vmalloc        5709  1 em28xx
videobuf_core          20773  2 em28xx,videobuf_vmalloc
tveeprom               13945  1 em28xx
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
snd_hda_intel          28621  3 
snd_hda_codec         113249  2 snd_hda_codec_realtek,snd_hda_intel
sr_mod                 16684  0 
snd_hwdep               8100  1 snd_hda_codec
cyberjack               9820  0 
snd_pcm               105589  4 em28xx_alsa,snd_pcm_oss,snd_hda_intel,snd_hda_codec
cdrom                  43440  1 sr_mod
sg                     33348  0 
usbserial              41885  1 cyberjack
iTCO_wdt               12170  0 
ohci1394               33702  0 
usb_storage            52947  0 
snd_timer              26828  2 snd_seq,snd_pcm
i2c_i801               11881  0 
snd                    84547  19 em28xx_alsa,snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
soundcore               9003  1 snd
iTCO_vendor_support     3150  1 iTCO_wdt
snd_page_alloc          9569  2 snd_hda_intel,snd_pcm
serio_raw               5318  0 
pcspkr                  2222  0 
ieee1394              104868  1 ohci1394
e1000e                152493  0 
button                  6989  0 
sd_mod                 41436  6 
edd                    10208  0 
fan                     4559  0 
processor              45747  9 acpi_cpufreq
ahci                   42680  5 
libata                211449  1 ahci
scsi_mod              191748  5 sr_mod,sg,usb_storage,sd_mod,libata
thermal                20625  0 
thermal_sys            18230  3 fan,processor,thermal

--Boundary-00=_bWcPN991VFtCsPt
Content-Type: text/plain;
  charset="UTF-8";
  name="log.lsusb-v.20110124"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.lsusb-v.20110124"


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

--Boundary-00=_bWcPN991VFtCsPt
Content-Type: text/plain;
  charset="UTF-8";
  name="log.messages-laden.20110124"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.messages-laden.20110124"

Jan 24 18:18:58 trixi kernel: [ 4967.321310] usb 2-5: new high speed USB device using ehci_hcd and address 3
Jan 24 18:18:58 trixi kernel: [ 4967.435364] usb 2-5: New USB device found, idVendor=eb1a, idProduct=2863
Jan 24 18:18:58 trixi kernel: [ 4967.435368] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 24 18:18:58 trixi kernel: [ 4967.435368] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan 24 18:18:58 trixi kernel: [ 4967.488921] IR NEC protocol handler initialized
Jan 24 18:18:58 trixi kernel: [ 4967.494137] Linux video capture interface: v2.00
Jan 24 18:18:58 trixi kernel: [ 4967.494139] WARNING: You're using an experimental version of the V4L stack. As the driver
Jan 24 18:18:58 trixi kernel: [ 4967.494139] WARNING: You're using an experimental version of the V4L stack. As the driver
Jan 24 18:18:58 trixi kernel: [ 4967.494141]          is backported to an older kernel, it doesn't offer enough quality for
Jan 24 18:18:58 trixi kernel: [ 4967.494142]          its usage in production.
Jan 24 18:18:58 trixi kernel: [ 4967.494142]          its usage in production.
Jan 24 18:18:58 trixi kernel: [ 4967.494143]          Use it with care.
Jan 24 18:18:58 trixi kernel: [ 4967.494143]          Use it with care.
Jan 24 18:18:58 trixi kernel: [ 4967.520811] em28xx: New device @ 480 Mbps (eb1a:2863, interface 0, class 0)
Jan 24 18:18:58 trixi kernel: [ 4967.520910] em28xx #0: chip ID is em2860
Jan 24 18:18:58 trixi kernel: [ 4967.522631] IR RC5(x) protocol handler initialized
Jan 24 18:18:58 trixi kernel: [ 4967.531730] IR RC6 protocol handler initialized
Jan 24 18:18:58 trixi kernel: [ 4967.588016] IR JVC protocol handler initialized
Jan 24 18:18:58 trixi kernel: [ 4967.590206] em28xx #0: board has no eeprom
Jan 24 18:18:58 trixi kernel: [ 4967.590210] em28xx #0: Identified as EM2860/TVP5150 Reference Design (card=29)
Jan 24 18:18:58 trixi kernel: [ 4967.596497] IR Sony protocol handler initialized
Jan 24 18:18:58 trixi kernel: [ 4967.631010] tvp5150 7-005c: chip found @ 0xb8 (em28xx #0)
Jan 24 18:18:58 trixi kernel: [ 4967.631080] em28xx #0: Config register raw data: 0x10
Jan 24 18:18:58 trixi kernel: [ 4967.643688] em28xx #0: AC97 vendor ID = 0x83847650
Jan 24 18:18:58 trixi kernel: [ 4967.649673] em28xx #0: AC97 features = 0x6a90
Jan 24 18:18:58 trixi kernel: [ 4967.649676] em28xx #0: Sigmatel audio processor detected(stac 9750)
Jan 24 18:18:58 trixi kernel: [ 4967.926215] tvp5150 7-005c: tvp5150am1 detected.
Jan 24 18:18:59 trixi kernel: [ 4969.036852] em28xx #0: v4l2 driver version 0.1.2
Jan 24 18:19:00 trixi kernel: [ 4969.537646] em28xx #0: V4L2 video device registered as video0
Jan 24 18:19:00 trixi kernel: [ 4969.537649] em28xx #0: V4L2 VBI device registered as vbi0
Jan 24 18:19:00 trixi kernel: [ 4969.537707] usbcore: registered new interface driver em28xx
Jan 24 18:19:00 trixi kernel: [ 4969.537710] em28xx driver loaded
Jan 24 18:19:00 trixi kernel: [ 4969.537707] usbcore: registered new interface driver em28xx
Jan 24 18:19:00 trixi kernel: [ 4969.537710] em28xx driver loaded
Jan 24 18:19:00 trixi kernel: [ 4969.564855] em28xx-audio.c: probing for em28x1 non standard usbaudio
Jan 24 18:19:00 trixi kernel: [ 4969.564859] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Jan 24 18:19:00 trixi kernel: [ 4969.565488] Em28xx: Initialized (Em28xx Audio Extension) extension
Jan 24 18:19:00 trixi kernel: [ 4969.736425] tvp5150 7-005c: tvp5150am1 detected.



--Boundary-00=_bWcPN991VFtCsPt
Content-Type: text/plain;
  charset="UTF-8";
  name="log.vlc.en.20110124"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="log.vlc.en.20110124"

On the Silver Crest Video Grabber there is a VCR Recorder connected.

Verhalten:
Im Videoaufzeichnungsmodus wird das Fernsehbild angezeigt - OHNE Ton.
Im Audioaufzeichnungsmodus wird der Ton wiedergegeben.

Attitude:
In VIDEO modus the TV pictures are displayed - without sound.
In AUDIO modus the sound is to hear.

Device selection (as displayed in german language)
Videoaufzeichnung:
 +- eb1a
    |- EM2860/TVP5150 Reference Design
    |- EM2860/TVP5150 Reference Design

Audioaufzeichnung:
 +- Intel Corporation
 |  |- 82801JI(ICH10 Family) HD Audio Controller (0)
 |  |- 82801JI(ICH10 Family) HD Audio Controller (2)
 +- eMPIA Technologie, Inc.
    |- Ger=C3=A4t (0)

On VLC=20
Opening of the video device:
[0x7f998c001470] v4l2 demux error: device does not support mmap i/o
[0x7f998c001470] v4l2 demux error: device does not support mmap i/o
[0xd2d360] v4l2 access error: device does not support mmap i/o
[0xd2d360] v4l2 access error: device does not support mmap i/o
[0x7f998c000b90] main input error: open of `v4l2:///dev/vbi0' failed: (null)
ERROR: Couldn't attach to DCOP server!

Note - to get sound you have to select eMPIA Ger=C3=A4t 0.

--Boundary-00=_bWcPN991VFtCsPt--
