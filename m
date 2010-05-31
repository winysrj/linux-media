Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-eu.gmx.com ([213.165.64.42]:37124 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751279Ab0EaU3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 16:29:47 -0400
Message-ID: <4C041C36.6060509@gmx.com>
Date: Mon, 31 May 2010 23:29:42 +0300
From: Daniel Voina <daniel.voina@gmx.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Leadtek USB II Deluxe initialization log
Content-Type: multipart/mixed;
 boundary="------------090205040607020000060209"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090205040607020000060209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

The board is not correctly detected.
In case that I use card=28 I get:

[  660.111864] usb 1-1.4: new high speed USB device using ehci_hcd and 
address 5
[  660.199917] em28xx: New device @ 480 Mbps (eb1a:2821, interface 0, 
class 0)
[  660.200021] em28xx #0: chip ID is em2820 (or em2710)
[  661.270404] em28xx #0: reading from i2c device failed (error=-110)
[  661.270410] em28xx #0: board has no eeprom
[  662.270195] em28xx #0: reading from i2c device failed (error=-110)
[  663.270906] em28xx #0: reading i2c device failed (error=-110)
[  664.270923] em28xx #0: reading from i2c device failed (error=-110)
[  664.270936] em28xx #0: Identified as Leadtek Winfast USB II Deluxe 
(card=28)
[  664.292918] em28xx #0:
[  664.292922]
[  664.292929] em28xx #0: The support for this board weren't valid yet.
[  664.292933] em28xx #0: Please send a report of having this working
[  664.292938] em28xx #0: not to V4L mailing list (and/or to other 
addresses)
[  664.292940]
[  665.334238] em28xx #0: reading from i2c device failed (error=-110)
[  666.334739] em28xx #0: reading from i2c device failed (error=-110)
[  667.334279] em28xx #0: reading from i2c device failed (error=-110)
[  668.334158] em28xx #0: reading from i2c device failed (error=-110)
[  669.366572] tvaudio 5-0058: I/O error (read2)
[  669.377074] tvaudio 5-0058: I/O error (read2)
[  669.387057] tvaudio 5-0058: I/O error (read2)
[  669.387077] tvaudio: probe of 5-0058 failed with error -5
[  669.408122] tuner 5-0000: chip found @ 0x0 (em28xx #0)
[  669.415521] em28xx #0: reading from i2c device failed (error=-71)
[  669.419642] em28xx #0: reading from i2c device failed (error=-71)
[  669.423770] em28xx #0: reading from i2c device failed (error=-71)
[  669.427896] em28xx #0: reading from i2c device failed (error=-71)
[  669.434763] em28xx #0: reading from i2c device failed (error=-71)
[  669.438893] em28xx #0: reading from i2c device failed (error=-71)
[  669.443030] em28xx #0: reading from i2c device failed (error=-71)
[  669.447148] em28xx #0: reading from i2c device failed (error=-71)
[  669.451271] em28xx #0: reading from i2c device failed (error=-71)
[  669.518266] em28xx #0: reading i2c device failed (error=-71)
[  669.518270] tuner-simple 5-0000: unable to probe Alps TSBE1, 
proceeding anyway.
[  669.518273] tuner-simple 5-0000: creating new instance
[  669.518275] tuner-simple 5-0000: type set to 10 (Alps TSBE1)
[  669.528562] tuner-simple 5-0000: i2c i/o error: rc == -71 (should be 4)
[  669.528575] tuner-simple 5-0000: destroying instance
[  669.533046] em28xx #0: reading i2c device failed (error=-71)
[  669.533055] tuner-simple 5-0000: unable to probe Philips PAL/SECAM 
multi (FM1216ME MK3), proceeding anyway.
[  669.533064] tuner-simple 5-0000: creating new instance
[  669.533070] tuner-simple 5-0000: type set to 38 (Philips PAL/SECAM 
multi (FM1216ME MK3))
[  669.543132] tuner-simple 5-0000: i2c i/o error: rc == -71 (should be 4)
[  669.553096] tuner-simple 5-0000: i2c i/o error: rc == -71 (should be 4)
[  669.557151] em28xx #0: Config register raw data: 0xffffffb9
[  669.561272] em28xx #0: AC97 chip type couldn't be determined
[  669.561277] em28xx #0: No AC97 audio processor
[  669.561285] em28xx #0: v4l2 driver version 0.1.2
[  669.565397] em28xx #0: cannot change alternate number to 6 (error=-71)

Regards,
   Daniel

-- 
Daniel Voina
e: daniel.voina@gmx.com


--------------090205040607020000060209
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34 (root@marauder) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #2 SMP Fri May 28 22:38:08 EEST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34 root=UUID=be93501b-a9ec-4675-8452-9bada47bb69d ro crashkernel=384M-2G:64M,2G-:128M quiet splash video=vesafb vga=791
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000776b1000 (usable)
[    0.000000]  BIOS-e820: 00000000776b1000 - 00000000776b7000 (reserved)
[    0.000000]  BIOS-e820: 00000000776b7000 - 00000000777bb000 (usable)
[    0.000000]  BIOS-e820: 00000000777bb000 - 000000007780f000 (reserved)
[    0.000000]  BIOS-e820: 000000007780f000 - 0000000077908000 (usable)
[    0.000000]  BIOS-e820: 0000000077908000 - 0000000077b0f000 (reserved)
[    0.000000]  BIOS-e820: 0000000077b0f000 - 0000000077b18000 (usable)
[    0.000000]  BIOS-e820: 0000000077b18000 - 0000000077b1f000 (reserved)
[    0.000000]  BIOS-e820: 0000000077b1f000 - 0000000077b65000 (usable)
[    0.000000]  BIOS-e820: 0000000077b65000 - 0000000077b9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077b9f000 - 0000000077be1000 (usable)
[    0.000000]  BIOS-e820: 0000000077be1000 - 0000000077bfd000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077bfd000 - 0000000077c00000 (usable)
[    0.000000]  BIOS-e820: 0000000077c00000 - 0000000077e00000 (reserved)
[    0.000000]  BIOS-e820: 0000000078000000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77c00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 078000000 mask FF8000000 uncachable
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000776b1000 (usable)
[    0.000000]  modified: 00000000776b1000 - 00000000776b7000 (reserved)
[    0.000000]  modified: 00000000776b7000 - 00000000777bb000 (usable)
[    0.000000]  modified: 00000000777bb000 - 000000007780f000 (reserved)
[    0.000000]  modified: 000000007780f000 - 0000000077908000 (usable)
[    0.000000]  modified: 0000000077908000 - 0000000077b0f000 (reserved)
[    0.000000]  modified: 0000000077b0f000 - 0000000077b18000 (usable)
[    0.000000]  modified: 0000000077b18000 - 0000000077b1f000 (reserved)
[    0.000000]  modified: 0000000077b1f000 - 0000000077b65000 (usable)
[    0.000000]  modified: 0000000077b65000 - 0000000077b9f000 (ACPI NVS)
[    0.000000]  modified: 0000000077b9f000 - 0000000077be1000 (usable)
[    0.000000]  modified: 0000000077be1000 - 0000000077bfd000 (ACPI data)
[    0.000000]  modified: 0000000077bfd000 - 0000000077c00000 (usable)
[    0.000000]  modified: 0000000077c00000 - 0000000077e00000 (reserved)
[    0.000000]  modified: 0000000078000000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f6ff0] f6ff0
[    0.000000] init_memory_mapping: 0000000000000000-0000000077c00000
[    0.000000]  0000000000 - 0077c00000 page 2M
[    0.000000] kernel direct mapping tables up to 77c00000 @ 16000-19000
[    0.000000] RAMDISK: 34016000 - 37ff0000
[    0.000000] Reserving 64MB of memory at 32MB for crashkernel (System RAM: 1916MB)
[    0.000000] ACPI: RSDP 00000000000f6f30 00024 (v02 TOSQCI)
[    0.000000] ACPI: XSDT 0000000077bf2b2a 0007C (v01 TOSQCI TOSQCI00 06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0000000077be5000 000F4 (v03 T0SQCI TOSQCI00 06040000 ALAN 00000001)
[    0.000000] ACPI: DSDT 0000000077be6000 09E52 (v02 Intel  CANTIGA  06040000 INTL 20061109)
[    0.000000] ACPI: FACS 0000000077b9efc0 00040
[    0.000000] ACPI: APIC 0000000077bfcd1e 00068 (v01 INTEL  CRESTLNE 06040000 LOHR 0000005A)
[    0.000000] ACPI: HPET 0000000077bfcd86 00038 (v01 TOSQCI TOSQCI00 06040000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 0000000077bfcdbe 0003C (v01 TOSQCI TOSQCI00 06040000 LOHR 0000005A)
[    0.000000] ACPI: APIC 0000000077bfcdfa 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0000000077bfce62 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SLIC 0000000077bfce8a 00176 (v01 TOSQCI TOSQCI00 06040000  LTP 00000000)
[    0.000000] ACPI: SSDT 0000000077bf2bce 00196 (v01 SataRe SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: SSDT 0000000077be4000 00655 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0000000077be3000 00259 (v01  PmRef  Cpu0Tst 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0000000077be2000 0020F (v01  PmRef    ApTst 00003000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000077c00000
[    0.000000] Initmem setup node 0 0000000000000000-0000000077c00000
[    0.000000]   NODE_DATA [0000000001caa200 - 0000000001caf1ff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880006800000-ffff8800083fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000776b1
[    0.000000]     0: 0x000776b7 -> 0x000777bb
[    0.000000]     0: 0x0007780f -> 0x00077908
[    0.000000]     0: 0x00077b0f -> 0x00077b18
[    0.000000]     0: 0x00077b1f -> 0x00077b65
[    0.000000]     0: 0x00077b9f -> 0x00077be1
[    0.000000]     0: 0x00077bfd -> 0x00077c00
[    0.000000] On node 0 totalpages: 489681
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6650 pages used for memmap
[    0.000000]   DMA32 zone: 479048 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [17000 - 177ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000776b1000 - 00000000776b7000
[    0.000000] PM: Registered nosave memory: 00000000777bb000 - 000000007780f000
[    0.000000] PM: Registered nosave memory: 0000000077908000 - 0000000077b0f000
[    0.000000] early_res array is doubled to 128 at [17800 - 187ff]
[    0.000000] PM: Registered nosave memory: 0000000077b18000 - 0000000077b1f000
[    0.000000] PM: Registered nosave memory: 0000000077b65000 - 0000000077b9f000
[    0.000000] PM: Registered nosave memory: 0000000077be1000 - 0000000077bfd000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s90600 r8192 d24088 u1048576
[    0.000000] pcpu-alloc: s90600 r8192 d24088 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 482975
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34 root=UUID=be93501b-a9ec-4675-8452-9bada47bb69d ro crashkernel=384M-2G:64M,2G-:128M quiet splash video=vesafb vga=791
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (71 early reservations)
[    0.000000]   #1 [0001000000 - 0001ca9d54]   TEXT DATA BSS
[    0.000000]   #2 [0034016000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001caa000 - 0001caa1ec]             BRK
[    0.000000]   #4 [00000f7000 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f6ff0 - 00000f7000]    MP-table mpf
[    0.000000]   #6 [000009f400 - 000009f971]   BIOS reserved
[    0.000000]   #7 [000009fad5 - 00000f6ff0]   BIOS reserved
[    0.000000]   #8 [000009f971 - 000009fad5]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000017000]         PGTABLE
[    0.000000]   #12 [0002000000 - 0006000000]    CRASH KERNEL
[    0.000000]   #13 [0001caa200 - 0001caf200]       NODE_DATA
[    0.000000]   #14 [0001caf200 - 0001cb0200]         BOOTMEM
[    0.000000]   #15 [0001ca9d80 - 0001ca9ee8]         BOOTMEM
[    0.000000]   #16 [0001cb1000 - 0001cb2000]         BOOTMEM
[    0.000000]   #17 [0001cb2000 - 0001cb3000]         BOOTMEM
[    0.000000]   #18 [0006800000 - 0008400000]        MEMMAP 0
[    0.000000]   #19 [0001cb3000 - 0001ccb000]         BOOTMEM
[    0.000000]   #20 [0001ccb000 - 0001ce3000]         BOOTMEM
[    0.000000]   #21 [0001ce3000 - 0001ce4000]         BOOTMEM
[    0.000000]   #22 [0001ca9f00 - 0001ca9f41]         BOOTMEM
[    0.000000]   #23 [0001ca9f80 - 0001ca9fc3]         BOOTMEM
[    0.000000]   #24 [0001cb0200 - 0001cb0820]         BOOTMEM
[    0.000000]   #25 [0001cb0840 - 0001cb08a8]         BOOTMEM
[    0.000000]   #26 [0001cb08c0 - 0001cb0928]         BOOTMEM
[    0.000000]   #27 [0001cb0940 - 0001cb09a8]         BOOTMEM
[    0.000000]   #28 [0001cb09c0 - 0001cb0a28]         BOOTMEM
[    0.000000]   #29 [0001cb0a40 - 0001cb0aa8]         BOOTMEM
[    0.000000]   #30 [0001cb0ac0 - 0001cb0b28]         BOOTMEM
[    0.000000]   #31 [0001cb0b40 - 0001cb0ba8]         BOOTMEM
[    0.000000]   #32 [0001cb0bc0 - 0001cb0c28]         BOOTMEM
[    0.000000]   #33 [0001cb0c40 - 0001cb0ca8]         BOOTMEM
[    0.000000]   #34 [0001cb0cc0 - 0001cb0d28]         BOOTMEM
[    0.000000]   #35 [0001cb0d40 - 0001cb0da8]         BOOTMEM
[    0.000000]   #36 [0001cb0dc0 - 0001cb0e28]         BOOTMEM
[    0.000000]   #37 [0001cb0e40 - 0001cb0ea8]         BOOTMEM
[    0.000000]   #38 [0001cb0ec0 - 0001cb0f28]         BOOTMEM
[    0.000000]   #39 [0001cb0f40 - 0001cb0fa8]         BOOTMEM
[    0.000000]   #40 [0001ce4000 - 0001ce4068]         BOOTMEM
[    0.000000]   #41 [0001ce4080 - 0001ce40e8]         BOOTMEM
[    0.000000]   #42 [0001ce4100 - 0001ce4168]         BOOTMEM
[    0.000000]   #43 [0001ce4180 - 0001ce41e8]         BOOTMEM
[    0.000000]   #44 [0001ce4200 - 0001ce4268]         BOOTMEM
[    0.000000]   #45 [0001ce4280 - 0001ce42e8]         BOOTMEM
[    0.000000]   #46 [0001ce4300 - 0001ce4368]         BOOTMEM
[    0.000000]   #47 [0001ce4380 - 0001ce43e8]         BOOTMEM
[    0.000000]   #48 [0001ce4400 - 0001ce4468]         BOOTMEM
[    0.000000]   #49 [0001ce4480 - 0001ce44e8]         BOOTMEM
[    0.000000]   #50 [0001ce4500 - 0001ce4568]         BOOTMEM
[    0.000000]   #51 [0001ce4580 - 0001ce45e8]         BOOTMEM
[    0.000000]   #52 [0001cb0fc0 - 0001cb0fe0]         BOOTMEM
[    0.000000]   #53 [0001ce4600 - 0001ce4620]         BOOTMEM
[    0.000000]   #54 [0001ce4640 - 0001ce4660]         BOOTMEM
[    0.000000]   #55 [0001ce4680 - 0001ce46a0]         BOOTMEM
[    0.000000]   #56 [0001ce46c0 - 0001ce46e0]         BOOTMEM
[    0.000000]   #57 [0001ce4700 - 0001ce4720]         BOOTMEM
[    0.000000]   #58 [0001ce4740 - 0001ce4760]         BOOTMEM
[    0.000000]   #59 [0001ce4780 - 0001ce4815]         BOOTMEM
[    0.000000]   #60 [0001ce4840 - 0001ce48d5]         BOOTMEM
[    0.000000]   #61 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #62 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #63 [0001ce6900 - 0001ce6908]         BOOTMEM
[    0.000000]   #64 [0001ce6940 - 0001ce6948]         BOOTMEM
[    0.000000]   #65 [0001ce6980 - 0001ce6988]         BOOTMEM
[    0.000000]   #66 [0001ce69c0 - 0001ce69d0]         BOOTMEM
[    0.000000]   #67 [0001ce6a00 - 0001ce6b40]         BOOTMEM
[    0.000000]   #68 [0001ce6b40 - 0001ce6ba0]         BOOTMEM
[    0.000000]   #69 [0001ce6bc0 - 0001ce6c20]         BOOTMEM
[    0.000000]   #70 [0001ce6c40 - 0001ceec40]         BOOTMEM
[    0.000000] Memory: 1785624k/1961984k available (5515k kernel code, 3260k absent, 173100k reserved, 5528k data, 788k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 19660800 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2260.914 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.82 BogoMIPS (lpj=2260914)
[    0.001034] Security Framework initialized
[    0.001045] SELinux:  Disabled at boot.
[    0.002083] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003376] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003982] Mount-cache hash table entries: 256
[    0.004138] Initializing cgroup subsys ns
[    0.004142] Initializing cgroup subsys cpuacct
[    0.004146] Initializing cgroup subsys memory
[    0.004155] Initializing cgroup subsys devices
[    0.004157] Initializing cgroup subsys freezer
[    0.004159] Initializing cgroup subsys net_cls
[    0.004161] Initializing cgroup subsys blkio
[    0.004191] CPU: Physical Processor ID: 0
[    0.004192] CPU: Processor Core ID: 0
[    0.004195] mce: CPU supports 6 MCE banks
[    0.004204] CPU0: Thermal monitoring enabled (TM2)
[    0.004208] using mwait in idle threads.
[    0.004209] Performance Events: Core2 events, Intel PMU driver.
[    0.004215] ... version:                2
[    0.004217] ... bit width:              40
[    0.004218] ... generic registers:      2
[    0.004219] ... value mask:             000000ffffffffff
[    0.004221] ... max period:             000000007fffffff
[    0.004222] ... fixed-purpose events:   3
[    0.004224] ... event mask:             0000000700000003
[    0.006810] ACPI: Core revision 20100121
[    0.022011] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.022016] ftrace: allocating 20804 entries in 82 pages
[    0.024050] Setting APIC routing to flat
[    0.025214] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.035223] CPU0: Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz stepping 06
[    0.035999] Booting Node   0, Processors  #1 Ok.
[    0.107017] Brought up 2 CPUs
[    0.107020] Total of 2 processors activated (9043.58 BogoMIPS).
[    0.107749] devtmpfs: initialized
[    0.110925] regulator: core version 0.5
[    0.110952] Time: 20:16:34  Date: 05/31/10
[    0.110981] NET: Registered protocol family 16
[    0.111077] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.111080] ACPI: bus type pci registered
[    0.111148] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.111152] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.170204] PCI: Using configuration type 1 for base access
[    0.170782] bio: create slab <bio-0> at 0
[    0.172640] ACPI: EC: Look up EC in DSDT
[    0.177986] ACPI: BIOS _OSI(Linux) query ignored
[    0.180440] ACPI: SSDT 0000000077b1ac20 00265 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.181105] ACPI: SSDT 0000000077b185a0 00537 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.181959] ACPI: SSDT 0000000077b19ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.182531] ACPI: SSDT 0000000077b19f20 0008D (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.193116] ACPI: Interpreter enabled
[    0.193120] ACPI: (supports S0 S3 S4 S5)
[    0.193141] ACPI: Using IOAPIC for interrupt routing
[    0.199265] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.199603] ACPI: No dock devices found.
[    0.199606] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.200072] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.200981] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.200984] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.200986] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.200989] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    0.200991] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    0.200994] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff]
[    0.201057] pci 0000:00:02.0: reg 10: [mem 0xf4000000-0xf43fffff 64bit]
[    0.201063] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.201067] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.201098] pci 0000:00:02.1: reg 10: [mem 0xf4400000-0xf44fffff 64bit]
[    0.201209] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.201291] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.201374] pci 0000:00:1a.2: reg 20: [io  0x1860-0x187f]
[    0.201454] pci 0000:00:1a.7: reg 10: [mem 0xf4a04800-0xf4a04bff]
[    0.201520] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.201525] pci 0000:00:1a.7: PME# disabled
[    0.201570] pci 0000:00:1b.0: reg 10: [mem 0xf4800000-0xf4803fff 64bit]
[    0.201628] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.201632] pci 0000:00:1b.0: PME# disabled
[    0.201724] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.201729] pci 0000:00:1c.0: PME# disabled
[    0.201828] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.201832] pci 0000:00:1c.4: PME# disabled
[    0.201927] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.201931] pci 0000:00:1c.5: PME# disabled
[    0.202005] pci 0000:00:1d.0: reg 20: [io  0x1880-0x189f]
[    0.202096] pci 0000:00:1d.1: reg 20: [io  0x18a0-0x18bf]
[    0.202182] pci 0000:00:1d.2: reg 20: [io  0x18c0-0x18df]
[    0.202259] pci 0000:00:1d.7: reg 10: [mem 0xf4a04c00-0xf4a04fff]
[    0.202326] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.202331] pci 0000:00:1d.7: PME# disabled
[    0.202556] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.202564] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.202571] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.202578] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.202585] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.202592] pci 0000:00:1f.2: reg 24: [mem 0xf4a04000-0xf4a047ff]
[    0.202638] pci 0000:00:1f.2: PME# supported from D3hot
[    0.202642] pci 0000:00:1f.2: PME# disabled
[    0.202681] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff 64bit]
[    0.202698] pci 0000:00:1f.3: reg 20: [io  0x1c00-0x1c1f]
[    0.202782] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.202786] pci 0000:00:1c.0:   bridge window [io  0x0000-0x0000] (disabled)
[    0.202791] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.202798] pci 0000:00:1c.0:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.202897] pci 0000:07:00.0: reg 10: [mem 0x00000000-0x00003fff 64bit]
[    0.202906] pci 0000:07:00.0: reg 18: [io  0x0000-0x00ff]
[    0.202936] pci 0000:07:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.202976] pci 0000:07:00.0: supports D1 D2
[    0.202978] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.202983] pci 0000:07:00.0: PME# disabled
[    0.203010] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.203014] pci 0000:00:1c.4:   bridge window [io  0x0000-0x0000] (disabled)
[    0.203019] pci 0000:00:1c.4:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.203026] pci 0000:00:1c.4:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.203141] pci 0000:08:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[    0.203252] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.203259] pci 0000:08:00.0: PME# disabled
[    0.203291] pci 0000:00:1c.5: PCI bridge to [bus 08-08]
[    0.203295] pci 0000:00:1c.5:   bridge window [io  0x0000-0x0000] (disabled)
[    0.203299] pci 0000:00:1c.5:   bridge window [mem 0x00000000-0x000fffff] (disabled)
[    0.203306] pci 0000:00:1c.5:   bridge window [mem 0x00000000-0x000fffff pref] (disabled)
[    0.203363] pci 0000:0a:01.0: reg 10: [mem 0xff501000-0xff501fff]
[    0.203370] pci 0000:0a:01.0: reg 14: [mem 0xf4700000-0xf47007ff]
[    0.203418] pci 0000:0a:01.0: supports D1 D2
[    0.203420] pci 0000:0a:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.203424] pci 0000:0a:01.0: PME# disabled
[    0.203464] pci 0000:0a:01.2: reg 10: [mem 0xf4700800-0xf47008ff]
[    0.203529] pci 0000:0a:01.2: supports D1 D2
[    0.203531] pci 0000:0a:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.203536] pci 0000:0a:01.2: PME# disabled
[    0.203575] pci 0000:0a:01.3: reg 10: [mem 0xf4702000-0xf4702fff]
[    0.203641] pci 0000:0a:01.3: supports D1 D2
[    0.203643] pci 0000:0a:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.203648] pci 0000:0a:01.3: PME# disabled
[    0.203713] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a] (subtractive decode)
[    0.203717] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.203722] pci 0000:00:1e.0:   bridge window [mem 0xf4700000-0xf47fffff]
[    0.203729] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.203731] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.203733] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.203736] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.203738] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    0.203740] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    0.203742] pci 0000:00:1e.0:   bridge window [mem 0x80000000-0xfebfffff] (subtractive decode)
[    0.203771] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.203910] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.204014] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.204089] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.216854] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.216958] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.217067] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 *6 7 10 12 14 15)
[    0.217169] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.217272] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.217373] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.217475] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.217577] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    0.217670] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.217683] vgaarb: loaded
[    0.217765] SCSI subsystem initialized
[    0.217786] libata version 3.00 loaded.
[    0.217786] usbcore: registered new interface driver usbfs
[    0.217786] usbcore: registered new interface driver hub
[    0.217786] usbcore: registered new device driver usb
[    0.218093] ACPI: WMI: Mapper loaded
[    0.218094] PCI: Using ACPI for IRQ routing
[    0.218097] PCI: pci_cache_line_size set to 64 bytes
[    0.218146] pci 0000:0a:01.0: no compatible bridge window for [mem 0xff501000-0xff501fff]
[    0.218203] reserve RAM buffer: 000000000009f400 - 000000000009ffff 
[    0.218206] reserve RAM buffer: 00000000776b1000 - 0000000077ffffff 
[    0.218209] reserve RAM buffer: 00000000777bb000 - 0000000077ffffff 
[    0.218213] reserve RAM buffer: 0000000077908000 - 0000000077ffffff 
[    0.218216] reserve RAM buffer: 0000000077b18000 - 0000000077ffffff 
[    0.218219] reserve RAM buffer: 0000000077b65000 - 0000000077ffffff 
[    0.218221] reserve RAM buffer: 0000000077be1000 - 0000000077ffffff 
[    0.218224] reserve RAM buffer: 0000000077c00000 - 0000000077ffffff 
[    0.218290] NetLabel: Initializing
[    0.218292] NetLabel:  domain hash size = 128
[    0.218293] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.218305] NetLabel:  unlabeled traffic allowed by default
[    0.218334] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.218340] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.218344] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.221016] Switching to clocksource tsc
[    0.222668] pnp: PnP ACPI init
[    0.222677] ACPI: bus type pnp registered
[    0.223656] pnp 00:04: disabling [io  0x002e-0x002f] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223660] pnp 00:04: disabling [io  0x004e-0x004f] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223663] pnp 00:04: disabling [io  0x0061] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223666] pnp 00:04: disabling [io  0x0063] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223669] pnp 00:04: disabling [io  0x0065] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223671] pnp 00:04: disabling [io  0x0067] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223674] pnp 00:04: disabling [io  0x0068] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223677] pnp 00:04: disabling [io  0x006c] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223680] pnp 00:04: disabling [io  0x0070] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223683] pnp 00:04: disabling [io  0x0080] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223686] pnp 00:04: disabling [io  0x0092] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.223689] pnp 00:04: disabling [io  0x00b2-0x00b3] because it overlaps 0000:07:00.0 BAR 2 [io  0x0000-0x00ff]
[    0.224901] pnp: PnP ACPI: found 9 devices
[    0.224903] ACPI: ACPI bus type pnp unregistered
[    0.224912] system 00:02: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.224918] system 00:04: [io  0x03e0-0x03e1] has been reserved
[    0.224921] system 00:04: [io  0x0400-0x047f] has been reserved
[    0.224923] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.224926] system 00:04: [io  0x0480-0x048f] has been reserved
[    0.224928] system 00:04: [io  0xffff] has been reserved
[    0.224930] system 00:04: [io  0xffff] has been reserved
[    0.224933] system 00:04: [io  0x1180-0x11ff] has been reserved
[    0.224935] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.224937] system 00:04: [io  0xfe00] has been reserved
[    0.224943] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.224945] system 00:08: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.224948] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.224950] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.224953] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.224955] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.229690] pci 0000:00:1c.0: BAR 14: assigned [mem 0x80000000-0x801fffff]
[    0.229693] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    0.229696] pci 0000:00:1c.4: BAR 14: assigned [mem 0x80400000-0x805fffff]
[    0.229699] pci 0000:00:1c.4: BAR 15: assigned [mem 0x80600000-0x807fffff pref]
[    0.229701] pci 0000:00:1c.5: BAR 14: assigned [mem 0x80800000-0x809fffff]
[    0.229704] pci 0000:00:1c.5: BAR 15: assigned [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.229707] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.229710] pci 0000:00:1c.4: BAR 13: assigned [io  0x3000-0x3fff]
[    0.229712] pci 0000:00:1c.5: BAR 13: assigned [io  0x4000-0x4fff]
[    0.229715] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80c00000-0x80c000ff 64bit]
[    0.229723] pci 0000:00:1f.3: BAR 0: set to [mem 0x80c00000-0x80c000ff 64bit] (PCI address [0x80c00000-0x80c000ff]
[    0.229726] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.229729] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.229735] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff]
[    0.229739] pci 0000:00:1c.0:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    0.229747] pci 0000:07:00.0: BAR 6: assigned [mem 0x80600000-0x8061ffff pref]
[    0.229750] pci 0000:07:00.0: BAR 0: assigned [mem 0x80400000-0x80403fff 64bit]
[    0.229759] pci 0000:07:00.0: BAR 0: set to [mem 0x80400000-0x80403fff 64bit] (PCI address [0x80400000-0x80403fff]
[    0.229762] pci 0000:07:00.0: BAR 2: assigned [io  0x3000-0x30ff]
[    0.229768] pci 0000:07:00.0: BAR 2: set to [io  0x3000-0x30ff] (PCI address [0x3000-0x30ff]
[    0.229770] pci 0000:00:1c.4: PCI bridge to [bus 07-07]
[    0.229773] pci 0000:00:1c.4:   bridge window [io  0x3000-0x3fff]
[    0.229779] pci 0000:00:1c.4:   bridge window [mem 0x80400000-0x805fffff]
[    0.229783] pci 0000:00:1c.4:   bridge window [mem 0x80600000-0x807fffff pref]
[    0.229791] pci 0000:08:00.0: BAR 0: assigned [mem 0x80800000-0x80801fff 64bit]
[    0.229804] pci 0000:08:00.0: BAR 0: set to [mem 0x80800000-0x80801fff 64bit] (PCI address [0x80800000-0x80801fff]
[    0.229807] pci 0000:00:1c.5: PCI bridge to [bus 08-08]
[    0.229810] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.229815] pci 0000:00:1c.5:   bridge window [mem 0x80800000-0x809fffff]
[    0.229820] pci 0000:00:1c.5:   bridge window [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.229834] pci 0000:0a:01.0: BAR 0: assigned [mem 0xf4701000-0xf4701fff]
[    0.229839] pci 0000:0a:01.0: BAR 0: set to [mem 0xf4701000-0xf4701fff] (PCI address [0xf4701000-0xf4701fff]
[    0.229841] pci 0000:00:1e.0: PCI bridge to [bus 0a-0a]
[    0.229843] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.229848] pci 0000:00:1e.0:   bridge window [mem 0xf4700000-0xf47fffff]
[    0.229853] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.229867] pci 0000:00:1c.0: enabling device (0000 -> 0003)
[    0.229871]   alloc irq_desc for 17 on node -1
[    0.229873]   alloc kstat_irqs on node -1
[    0.229878] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.229884] pci 0000:00:1c.0: setting latency timer to 64
[    0.229892] pci 0000:00:1c.4: enabling device (0000 -> 0003)
[    0.229896] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.229901] pci 0000:00:1c.4: setting latency timer to 64
[    0.229910] pci 0000:00:1c.5: enabling device (0000 -> 0003)
[    0.229915]   alloc irq_desc for 16 on node -1
[    0.229916]   alloc kstat_irqs on node -1
[    0.229919] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.229925] pci 0000:00:1c.5: setting latency timer to 64
[    0.229932] pci 0000:00:1e.0: setting latency timer to 64
[    0.229936] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.229938] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.229939] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.229941] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.229943] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.229945] pci_bus 0000:00: resource 9 [mem 0x80000000-0xfebfffff]
[    0.229947] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.229949] pci_bus 0000:02: resource 1 [mem 0x80000000-0x801fffff]
[    0.229951] pci_bus 0000:02: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    0.229954] pci_bus 0000:07: resource 0 [io  0x3000-0x3fff]
[    0.229955] pci_bus 0000:07: resource 1 [mem 0x80400000-0x805fffff]
[    0.229957] pci_bus 0000:07: resource 2 [mem 0x80600000-0x807fffff pref]
[    0.229960] pci_bus 0000:08: resource 0 [io  0x4000-0x4fff]
[    0.229961] pci_bus 0000:08: resource 1 [mem 0x80800000-0x809fffff]
[    0.229964] pci_bus 0000:08: resource 2 [mem 0x80a00000-0x80bfffff 64bit pref]
[    0.229966] pci_bus 0000:0a: resource 1 [mem 0xf4700000-0xf47fffff]
[    0.229968] pci_bus 0000:0a: resource 4 [io  0x0000-0x0cf7]
[    0.229970] pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
[    0.229972] pci_bus 0000:0a: resource 6 [mem 0x000a0000-0x000bffff]
[    0.229974] pci_bus 0000:0a: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.229976] pci_bus 0000:0a: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.229978] pci_bus 0000:0a: resource 9 [mem 0x80000000-0xfebfffff]
[    0.229999] NET: Registered protocol family 2
[    0.230090] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.230703] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.232791] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.233409] TCP: Hash tables configured (established 262144 bind 65536)
[    0.233411] TCP reno registered
[    0.233418] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.233444] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.233574] NET: Registered protocol family 1
[    0.233595] pci 0000:00:02.0: Boot video device
[    0.233773] PCI: CLS 64 bytes, default 64
[    0.233849] Trying to unpack rootfs image as initramfs...
[    1.638081] Freeing initrd memory: 65384k freed
[    1.670806] Simple Boot Flag at 0x36 set to 0x80
[    1.670995] Scanning for low memory corruption every 60 seconds
[    1.671223] audit: initializing netlink socket (disabled)
[    1.671237] type=2000 audit(1275336995.671:1): initialized
[    1.683662] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.684918] VFS: Disk quotas dquot_6.5.2
[    1.684961] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.685466] fuse init (API version 7.13)
[    1.685542] msgmni has been set to 3615
[    1.685717] alg: No test for stdrng (krng)
[    1.685762] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.685766] io scheduler noop registered
[    1.685768] io scheduler deadline registered
[    1.685823] io scheduler cfq registered (default)
[    1.685931] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.685976]   alloc irq_desc for 24 on node -1
[    1.685978]   alloc kstat_irqs on node -1
[    1.685990] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.686086] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.686129]   alloc irq_desc for 25 on node -1
[    1.686130]   alloc kstat_irqs on node -1
[    1.686138] pcieport 0000:00:1c.4: irq 25 for MSI/MSI-X
[    1.686223] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.686266]   alloc irq_desc for 26 on node -1
[    1.686268]   alloc kstat_irqs on node -1
[    1.686276] pcieport 0000:00:1c.5: irq 26 for MSI/MSI-X
[    1.686369] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    1.686380] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    1.686384] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    1.686387] pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
[    1.686390] pcieport 0000:00:1c.4: Failed to receive control of PCIe PME service: no _OSC support
[    1.686393] pcie_pme: probe of 0000:00:1c.4:pcie01 failed with error -13
[    1.686396] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    1.686399] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    1.686401] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    1.686417] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.686518] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.687742] ACPI: AC Adapter [ACAD] (on-line)
[    1.687817] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.687820] ACPI: Power Button [PWRB]
[    1.687854] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.688069] ACPI: Lid Switch [LID]
[    1.688109] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.688112] ACPI: Power Button [PWRF]
[    1.690389] Monitor-Mwait will be used to enter C-1 state
[    1.690413] Monitor-Mwait will be used to enter C-2 state
[    1.690433] Monitor-Mwait will be used to enter C-3 state
[    1.690440] Marking TSC unstable due to TSC halts in idle
[    1.690469] Switching to clocksource hpet
[    1.701854] thermal LNXTHERM:01: registered as thermal_zone0
[    1.701861] ACPI: Thermal Zone [THRM] (61 C)
[    1.701960] ACPI: Battery Slot [BAT1] (battery absent)
[    1.703165] Linux agpgart interface v0.103
[    1.703199] [drm] Initialized drm 1.1.0 20060810
[    1.703203] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.704323] brd: module loaded
[    1.704733] loop: module loaded
[    1.705097] Fixed MDIO Bus: probed
[    1.705123] PPP generic driver version 2.4.2
[    1.705153] tun: Universal TUN/TAP device driver, 1.6
[    1.705155] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.705216] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.705237]   alloc irq_desc for 19 on node -1
[    1.705239]   alloc kstat_irqs on node -1
[    1.705244] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    1.705268] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.705271] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.705298] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.705329] ehci_hcd 0000:00:1a.7: debug port 1
[    1.709218] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.709234] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4a04800
[    1.718018] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.718113] hub 1-0:1.0: USB hub found
[    1.718117] hub 1-0:1.0: 6 ports detected
[    1.718185]   alloc irq_desc for 23 on node -1
[    1.718186]   alloc kstat_irqs on node -1
[    1.718190] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.718200] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.718203] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.718229] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.718263] ehci_hcd 0000:00:1d.7: debug port 1
[    1.722157] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.722169] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4a04c00
[    1.731018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.731097] hub 2-0:1.0: USB hub found
[    1.731100] hub 2-0:1.0: 6 ports detected
[    1.731162] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.731173] uhci_hcd: USB Universal Host Controller Interface driver
[    1.731214] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.731220] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.731224] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.731261] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.731297] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    1.731390] hub 3-0:1.0: USB hub found
[    1.731394] hub 3-0:1.0: 2 ports detected
[    1.731446]   alloc irq_desc for 21 on node -1
[    1.731447]   alloc kstat_irqs on node -1
[    1.731451] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.731457] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.731460] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.731488] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.731518] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    1.731616] hub 4-0:1.0: USB hub found
[    1.731619] hub 4-0:1.0: 2 ports detected
[    1.731670] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    1.731676] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.731679] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.731718] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    1.731746] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    1.731839] hub 5-0:1.0: USB hub found
[    1.731842] hub 5-0:1.0: 2 ports detected
[    1.731895] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.731900] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.731904] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.731929] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    1.731953] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    1.732048] hub 6-0:1.0: USB hub found
[    1.732051] hub 6-0:1.0: 2 ports detected
[    1.732103] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.732108] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.732112] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.732136] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    1.732161] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    1.732265] hub 7-0:1.0: USB hub found
[    1.732268] hub 7-0:1.0: 2 ports detected
[    1.732318]   alloc irq_desc for 18 on node -1
[    1.732320]   alloc kstat_irqs on node -1
[    1.732323] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.732331] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.732334] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.732363] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    1.732396] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    1.732489] hub 8-0:1.0: USB hub found
[    1.732492] hub 8-0:1.0: 2 ports detected
[    1.732571] usbcore: registered new interface driver usbserial
[    1.732580] USB Serial support registered for generic
[    1.732592] usbcore: registered new interface driver usbserial_generic
[    1.732594] usbserial: USB Serial Driver core
[    1.732626] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2A] at 0x60,0x64 irq 1,12
[    1.734801] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.737178] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.737183] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.737208] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.737226] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.737246] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.737333] mice: PS/2 mouse device common for all mice
[    1.737437] rtc_cmos 00:05: RTC can wake from S4
[    1.737465] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.737493] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.737567] device-mapper: uevent: version 1.0.3
[    1.737664] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    1.737726] device-mapper: multipath: version 1.1.1 loaded
[    1.737728] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.737921] cpuidle: using governor ladder
[    1.738007] cpuidle: using governor menu
[    1.738077] Detected Toshiba ACPI Bluetooth device - installing RFKill handler
[    1.741203] toshiba_bluetooth: Re-enabling Toshiba Bluetooth
[    1.744634] TCP cubic registered
[    1.744739] NET: Registered protocol family 10
[    1.745011] lo: Disabled Privacy Extensions
[    1.745182] NET: Registered protocol family 17
[    1.745862] PM: Resume from disk failed.
[    1.745872] registered taskstats version 1
[    1.746183]   Magic number: 10:166:297
[    1.746273] rtc_cmos 00:05: setting system clock to 2010-05-31 20:16:36 UTC (1275336996)
[    1.746275] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.746277] EDD information not available.
[    1.746383] Freeing unused kernel memory: 788k freed
[    1.746651] Write protecting the kernel read-only data: 10240k
[    1.746843] Freeing unused kernel memory: 608k freed
[    1.747223] Freeing unused kernel memory: 1788k freed
[    1.760884] udev: starting version 151
[    1.766313] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.848396] sky2: driver version 1.27
[    1.848438] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    1.848446] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.848462] sky2 0000:07:00.0: setting latency timer to 64
[    1.848494] sky2 0000:07:00.0: Yukon-2 Extreme chip revision 2
[    1.848584]   alloc irq_desc for 27 on node -1
[    1.848586]   alloc kstat_irqs on node -1
[    1.848602] sky2 0000:07:00.0: irq 27 for MSI/MSI-X
[    1.849095] sky2 0000:07:00.0: eth0: addr 00:1e:68:a4:8b:c3
[    1.856524] ahci 0000:00:1f.2: version 3.0
[    1.856543] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.856591]   alloc irq_desc for 28 on node -1
[    1.856593]   alloc kstat_irqs on node -1
[    1.856607] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.856716] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    1.856719] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part ccc ems sxs 
[    1.856726] ahci 0000:00:1f.2: setting latency timer to 64
[    1.863096] scsi0 : ahci
[    1.863259] scsi1 : ahci
[    1.863344] scsi2 : ahci
[    1.863423] scsi3 : ahci
[    1.863504] scsi4 : ahci
[    1.863591] scsi5 : ahci
[    1.863747] ata1: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a04100 irq 28
[    1.863750] ata2: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a04180 irq 28
[    1.863752] ata3: DUMMY
[    1.863754] ata4: DUMMY
[    1.863756] ata5: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a04300 irq 28
[    1.863759] ata6: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a04380 irq 28
[    2.168073] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.168725] ata1.00: unexpected _GTF length (8)
[    2.170081] ata5: SATA link down (SStatus 0 SControl 300)
[    2.170108] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.170127] ata6: SATA link down (SStatus 0 SControl 300)
[    2.237087] usb 2-4: new high speed USB device using ehci_hcd and address 4
[    2.239042] ata1.00: ATA-8: TOSHIBA MK2552GSX, LV010M, max UDMA/100
[    2.239046] ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.240066] ata1.00: unexpected _GTF length (8)
[    2.240269] ata1.00: configured for UDMA/100
[    2.240387] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK2552GS LV01 PQ: 0 ANSI: 5
[    2.240537] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.240563] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.240619] sd 0:0:0:0: [sda] Write Protect is off
[    2.240621] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.240642] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.240766]  sda:
[    2.257164] ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-U20N, HT05, max UDMA/133
[    2.261943] ata2.00: configured for UDMA/133
[    2.331873]  sda1 sda2 sda3 sda4 sda5 sda6
[    2.332182] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.371283] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U20N  HT05 PQ: 0 ANSI: 5
[    2.604065] usb 6-2: new full speed USB device using uhci_hcd and address 2
[    2.731436] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.731440] Uniform CD-ROM driver Revision: 3.20
[    2.731553] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.731616] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.734551] ohci1394 0000:0a:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.786082] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[f4701000-f47017ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    2.966279] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    3.256141] EXT4-fs (sda5): INFO: recovery required on readonly filesystem
[    3.256146] EXT4-fs (sda5): write access will be enabled during recovery
[    3.580124] EXT4-fs (sda5): orphan cleanup on readonly fs
[    3.580133] EXT4-fs (sda5): ext4_orphan_cleanup: deleting unreferenced inode 260634
[    3.582789] EXT4-fs (sda5): ext4_orphan_cleanup: deleting unreferenced inode 260636
[    3.582796] EXT4-fs (sda5): 2 orphan inodes deleted
[    3.582799] EXT4-fs (sda5): recovery complete
[    3.835567] EXT4-fs (sda5): mounted filesystem with ordered data mode
[    4.045190] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b2400011c5113]
[   13.969387] udev: starting version 151
[   13.972599] Adding 3999996k swap on /dev/sda3.  Priority:-1 extents:1 across:3999996k 
[   14.638848] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.640420] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[   14.660210] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   14.690620] lp: driver loaded but no devices found
[   14.955605] sdhci: Secure Digital Host Controller Interface driver
[   14.955609] sdhci: Copyright(c) Pierre Ossman
[   15.212858] cfg80211: Calling CRDA to update world regulatory domain
[   15.234713] cfg80211: World regulatory domain updated:
[   15.234716]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.234719]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.234721]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.234723]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.234726]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.234728]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.460722] Bluetooth: Core ver 2.15
[   15.460808] NET: Registered protocol family 31
[   15.460809] Bluetooth: HCI device and connection manager initialized
[   15.460812] Bluetooth: HCI socket layer initialized
[   16.051864] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.051869] i915 0000:00:02.0: setting latency timer to 64
[   16.134925]   alloc irq_desc for 29 on node -1
[   16.134929]   alloc kstat_irqs on node -1
[   16.134937] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[   16.134943] [drm] set up 127M of stolen space
[   16.501537] input: PS/2 Mouse as /devices/platform/i8042/serio4/input/input4
[   16.517360] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio4/input/input5
[   16.579720] EXT4-fs (sda6): warning: mounting fs with errors, running e2fsck is recommended
[   16.582201] EXT4-fs (sda6): recovery complete
[   16.612452] EXT4-fs (sda6): mounted filesystem with ordered data mode
[   16.965527] fb0: inteldrmfb frame buffer device
[   16.965529] registered panic notifier
[   16.970889] acpi device:03: registered as cooling_device2
[   16.971241] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input6
[   16.971335] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   16.971406] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.263471] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   17.264807] usbcore: registered new interface driver btusb
[   17.521065] sdhci-pci 0000:0a:01.2: SDHCI controller found [1217:7120] (rev 2)
[   17.521086] sdhci-pci 0000:0a:01.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   17.521113] mmc0: Unknown controller version (2). You may experience problems.
[   17.521157] Registered led device: mmc0::
[   17.521194] mmc0: SDHCI controller on PCI [0000:0a:01.2] using DMA
[   18.556947] sky2 0000:07:00.0: eth0: enabling interface
[   18.557182] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.685942] Linux video capture interface: v2.00
[   19.125990] Bluetooth: L2CAP ver 2.14
[   19.125994] Bluetooth: L2CAP socket layer initialized
[   19.256482] uvcvideo: Found UVC 1.00 device CNA7137 (04f2:b064)
[   19.279276] input: CNA7137 as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/2-4:1.0/input/input7
[   19.279384] usbcore: registered new interface driver uvcvideo
[   19.279387] USB Video Class driver (v0.1.0)
[   19.536621] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   19.536625] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   19.536702] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[   19.536712] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   19.536724] iwlagn 0000:08:00.0: setting latency timer to 64
[   19.536759] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[   19.558798] iwlagn 0000:08:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   19.558862]   alloc irq_desc for 30 on node -1
[   19.558864]   alloc kstat_irqs on node -1
[   19.558885] iwlagn 0000:08:00.0: irq 30 for MSI/MSI-X
[   19.560280] iwlagn 0000:08:00.0: firmware: requesting iwlwifi-5000-2.ucode
[   19.563817] iwlagn 0000:08:00.0: loaded firmware version 8.24.2.12
[   19.684703] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   19.833613] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   19.904824] Console: switching to colour frame buffer device 160x50
[   19.984692] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   19.984696] Bluetooth: BNEP filters: protocol multicast
[   19.987550] /dev/vmmon[982]: Module vmmon: registered with major=10 minor=165
[   19.987562] /dev/vmmon[982]: Initial HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1 anyDisabled=0
[   19.987567] /dev/vmmon[982]: HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1 anyDisabled=0
[   19.987569] /dev/vmmon[982]: Module vmmon: initialized
[   20.278858] Bridge firewalling registered
[   20.281699] /dev/vmci[1005]: VMCI: Driver initialized.
[   20.281822] /dev/vmci[1005]: Module vmci: registered with major=10 minor=55
[   20.281825] /dev/vmci[1005]: Module vmci: initialized
[   20.417778] Bluetooth: SCO (Voice Link) ver 0.6
[   20.417783] Bluetooth: SCO socket layer initialized
[   20.779552] Bluetooth: RFCOMM TTY layer initialized
[   20.779557] Bluetooth: RFCOMM socket layer initialized
[   20.779559] Bluetooth: RFCOMM ver 1.11
[   20.955802] ppdev: user-space parallel port driver
[   21.272584]   alloc irq_desc for 22 on node -1
[   21.272587]   alloc kstat_irqs on node -1
[   21.272594] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   21.272767]   alloc irq_desc for 31 on node -1
[   21.272769]   alloc kstat_irqs on node -1
[   21.272780] HDA Intel 0000:00:1b.0: irq 31 for MSI/MSI-X
[   21.272815] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   21.411142] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   21.411220] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   22.114190] /dev/vmnet: open called by PID 1153 (vmnet-dhcpd)
[   22.114197] /dev/vmnet: hub 1 does not exist, allocating memory.
[   22.114217] /dev/vmnet: port on hub 1 successfully opened
[   22.148695] /dev/vmnet: open called by PID 1155 (vmnet-netifup)
[   22.148704] /dev/vmnet: port on hub 1 successfully opened
[   22.238035] /dev/vmnet: open called by PID 1159 (vmnet-dhcpd)
[   22.238111] /dev/vmnet: hub 8 does not exist, allocating memory.
[   22.238130] /dev/vmnet: port on hub 8 successfully opened
[   22.332812] /dev/vmnet: open called by PID 1163 (vmnet-natd)
[   22.332824] /dev/vmnet: port on hub 8 successfully opened
[   22.371467] /dev/vmnet: open called by PID 1164 (vmnet-netifup)
[   22.371476] /dev/vmnet: port on hub 8 successfully opened
[   32.262213] vmnet1: no IPv6 routers present
[   32.630197] vmnet8: no IPv6 routers present
[  159.769593] usb 1-1: new high speed USB device using ehci_hcd and address 2
[  159.885368] hub 1-1:1.0: USB hub found
[  159.885537] hub 1-1:1.0: 4 ports detected
[  160.159711] usb 1-1.4: new high speed USB device using ehci_hcd and address 3
[  160.839323] em28xx: New device @ 480 Mbps (eb1a:2821, interface 0, class 0)
[  160.839755] em28xx #0: chip ID is em2820 (or em2710)
[  161.911775] em28xx #0: reading from i2c device failed (error=-110)
[  161.911785] em28xx #0: board has no eeprom
[  162.911791] em28xx #0: reading from i2c device failed (error=-110)
[  163.911289] em28xx #0: reading i2c device failed (error=-110)
[  164.911800] em28xx #0: reading from i2c device failed (error=-110)
[  165.921830] em28xx #0: reading i2c device failed (error=-71)
[  165.921841] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  165.925893] em28xx #0: reading from i2c device failed (error=-71)
[  165.930019] em28xx #0: reading from i2c device failed (error=-71)
[  165.934143] em28xx #0: reading from i2c device failed (error=-71)
[  165.938264] em28xx #0: reading from i2c device failed (error=-71)
[  165.942389] em28xx #0: reading from i2c device failed (error=-71)
[  165.946511] em28xx #0: reading from i2c device failed (error=-71)
[  165.950636] em28xx #0: reading from i2c device failed (error=-71)
[  165.954758] em28xx #0: reading from i2c device failed (error=-71)
[  165.958886] em28xx #0: reading from i2c device failed (error=-71)
[  165.963029] em28xx #0: reading from i2c device failed (error=-71)
[  165.967137] em28xx #0: reading from i2c device failed (error=-71)
[  165.971260] em28xx #0: reading from i2c device failed (error=-71)
[  165.975383] em28xx #0: reading from i2c device failed (error=-71)
[  165.979508] em28xx #0: reading from i2c device failed (error=-71)
[  165.983631] em28xx #0: reading from i2c device failed (error=-71)
[  165.987767] em28xx #0: reading from i2c device failed (error=-71)
[  165.991882] em28xx #0: reading from i2c device failed (error=-71)
[  165.996022] em28xx #0: reading from i2c device failed (error=-71)
[  166.000134] em28xx #0: reading from i2c device failed (error=-71)
[  166.004256] em28xx #0: reading from i2c device failed (error=-71)
[  166.008382] em28xx #0: reading from i2c device failed (error=-71)
[  166.012504] em28xx #0: reading from i2c device failed (error=-71)
[  166.016628] em28xx #0: reading from i2c device failed (error=-71)
[  166.020754] em28xx #0: reading from i2c device failed (error=-71)
[  166.024879] em28xx #0: reading from i2c device failed (error=-71)
[  166.029002] em28xx #0: reading from i2c device failed (error=-71)
[  166.033131] em28xx #0: reading from i2c device failed (error=-71)
[  166.037255] em28xx #0: reading from i2c device failed (error=-71)
[  166.041380] em28xx #0: reading from i2c device failed (error=-71)
[  166.045504] em28xx #0: reading from i2c device failed (error=-71)
[  166.049628] em28xx #0: reading from i2c device failed (error=-71)
[  166.053753] em28xx #0: reading from i2c device failed (error=-71)
[  166.057878] em28xx #0: reading from i2c device failed (error=-71)
[  166.062003] em28xx #0: reading from i2c device failed (error=-71)
[  166.066129] em28xx #0: reading from i2c device failed (error=-71)
[  166.070253] em28xx #0: reading from i2c device failed (error=-71)
[  166.074379] em28xx #0: reading from i2c device failed (error=-71)
[  166.078499] em28xx #0: reading from i2c device failed (error=-71)
[  166.082626] em28xx #0: reading from i2c device failed (error=-71)
[  166.086751] em28xx #0: reading from i2c device failed (error=-71)
[  166.090877] em28xx #0: reading from i2c device failed (error=-71)
[  166.095022] em28xx #0: reading from i2c device failed (error=-71)
[  166.099131] em28xx #0: reading from i2c device failed (error=-71)
[  166.103251] em28xx #0: reading from i2c device failed (error=-71)
[  166.107375] em28xx #0: reading from i2c device failed (error=-71)
[  166.111501] em28xx #0: reading from i2c device failed (error=-71)
[  166.115627] em28xx #0: reading from i2c device failed (error=-71)
[  166.119753] em28xx #0: reading from i2c device failed (error=-71)
[  166.123878] em28xx #0: reading from i2c device failed (error=-71)
[  166.128016] em28xx #0: reading from i2c device failed (error=-71)
[  166.132130] em28xx #0: reading from i2c device failed (error=-71)
[  166.136253] em28xx #0: reading from i2c device failed (error=-71)
[  166.140377] em28xx #0: reading from i2c device failed (error=-71)
[  166.144502] em28xx #0: reading from i2c device failed (error=-71)
[  166.148627] em28xx #0: reading from i2c device failed (error=-71)
[  166.152754] em28xx #0: reading from i2c device failed (error=-71)
[  166.156878] em28xx #0: reading from i2c device failed (error=-71)
[  166.161018] em28xx #0: reading from i2c device failed (error=-71)
[  166.165129] em28xx #0: reading from i2c device failed (error=-71)
[  166.169252] em28xx #0: reading from i2c device failed (error=-71)
[  166.173378] em28xx #0: reading from i2c device failed (error=-71)
[  166.177503] em28xx #0: reading from i2c device failed (error=-71)
[  166.181629] em28xx #0: reading from i2c device failed (error=-71)
[  166.185753] em28xx #0: reading from i2c device failed (error=-71)
[  166.189876] em28xx #0: reading from i2c device failed (error=-71)
[  166.194002] em28xx #0: reading from i2c device failed (error=-71)
[  166.198131] em28xx #0: reading from i2c device failed (error=-71)
[  166.202255] em28xx #0: reading from i2c device failed (error=-71)
[  166.206378] em28xx #0: reading from i2c device failed (error=-71)
[  166.210503] em28xx #0: reading from i2c device failed (error=-71)
[  166.214629] em28xx #0: reading from i2c device failed (error=-71)
[  166.218752] em28xx #0: reading from i2c device failed (error=-71)
[  166.222880] em28xx #0: reading from i2c device failed (error=-71)
[  166.227022] em28xx #0: reading from i2c device failed (error=-71)
[  166.231130] em28xx #0: reading from i2c device failed (error=-71)
[  166.235253] em28xx #0: reading from i2c device failed (error=-71)
[  166.239379] em28xx #0: reading from i2c device failed (error=-71)
[  166.243504] em28xx #0: reading from i2c device failed (error=-71)
[  166.247630] em28xx #0: reading from i2c device failed (error=-71)
[  166.251752] em28xx #0: reading from i2c device failed (error=-71)
[  166.255879] em28xx #0: reading from i2c device failed (error=-71)
[  166.260002] em28xx #0: reading from i2c device failed (error=-71)
[  166.264131] em28xx #0: reading from i2c device failed (error=-71)
[  166.268253] em28xx #0: reading from i2c device failed (error=-71)
[  166.272379] em28xx #0: reading from i2c device failed (error=-71)
[  166.276505] em28xx #0: reading from i2c device failed (error=-71)
[  166.280632] em28xx #0: reading from i2c device failed (error=-71)
[  166.284757] em28xx #0: reading from i2c device failed (error=-71)
[  166.288881] em28xx #0: reading from i2c device failed (error=-71)
[  166.293020] em28xx #0: reading from i2c device failed (error=-71)
[  166.297131] em28xx #0: reading from i2c device failed (error=-71)
[  166.301253] em28xx #0: reading from i2c device failed (error=-71)
[  166.305378] em28xx #0: reading from i2c device failed (error=-71)
[  166.309505] em28xx #0: reading from i2c device failed (error=-71)
[  166.313630] em28xx #0: reading from i2c device failed (error=-71)
[  166.317754] em28xx #0: reading from i2c device failed (error=-71)
[  166.321881] em28xx #0: reading from i2c device failed (error=-71)
[  166.326025] em28xx #0: reading from i2c device failed (error=-71)
[  166.330132] em28xx #0: reading from i2c device failed (error=-71)
[  166.334255] em28xx #0: reading from i2c device failed (error=-71)
[  166.338380] em28xx #0: reading from i2c device failed (error=-71)
[  166.342503] em28xx #0: reading from i2c device failed (error=-71)
[  166.346630] em28xx #0: reading from i2c device failed (error=-71)
[  166.350754] em28xx #0: reading from i2c device failed (error=-71)
[  166.354879] em28xx #0: reading from i2c device failed (error=-71)
[  166.359020] em28xx #0: reading from i2c device failed (error=-71)
[  166.363133] em28xx #0: reading from i2c device failed (error=-71)
[  166.367255] em28xx #0: reading from i2c device failed (error=-71)
[  166.371382] em28xx #0: reading from i2c device failed (error=-71)
[  166.375504] em28xx #0: reading from i2c device failed (error=-71)
[  166.379632] em28xx #0: reading from i2c device failed (error=-71)
[  166.383756] em28xx #0: reading from i2c device failed (error=-71)
[  166.387881] em28xx #0: reading from i2c device failed (error=-71)
[  166.392021] em28xx #0: reading from i2c device failed (error=-71)
[  166.396133] em28xx #0: reading from i2c device failed (error=-71)
[  166.400256] em28xx #0: reading from i2c device failed (error=-71)
[  166.404380] em28xx #0: reading from i2c device failed (error=-71)
[  166.408506] em28xx #0: reading from i2c device failed (error=-71)
[  166.412628] em28xx #0: reading from i2c device failed (error=-71)
[  166.416756] em28xx #0: reading from i2c device failed (error=-71)
[  166.420881] em28xx #0: reading from i2c device failed (error=-71)
[  166.425024] em28xx #0: reading from i2c device failed (error=-71)
[  166.429134] em28xx #0: reading from i2c device failed (error=-71)
[  166.433255] em28xx #0: reading from i2c device failed (error=-71)
[  166.437381] em28xx #0: reading from i2c device failed (error=-71)
[  166.441507] em28xx #0: reading from i2c device failed (error=-71)
[  166.445631] em28xx #0: reading from i2c device failed (error=-71)
[  166.449757] em28xx #0: reading from i2c device failed (error=-71)
[  166.449764] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[  166.449771] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[  166.449775] em28xx #0: Please send an email with this log to:
[  166.449779] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  166.449784] em28xx #0: Board eeprom hash is 0x00000000
[  166.449789] em28xx #0: Board i2c devicelist hash is 0x1b800080
[  166.449793] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[  166.449799] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  166.449804] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  166.449810] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  166.449814] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  166.449819] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  166.449824] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  166.449829] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  166.449834] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  166.449839] em28xx #0:     card=8 -> Kworld USB2800
[  166.449844] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  166.449851] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  166.449856] em28xx #0:     card=11 -> Terratec Hybrid XS
[  166.449861] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  166.449866] em28xx #0:     card=13 -> Terratec Prodigy XS
[  166.449870] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[  166.449876] em28xx #0:     card=15 -> V-Gear PocketTV
[  166.449881] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  166.449886] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  166.449891] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  166.449896] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  166.449901] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  166.449907] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[  166.449912] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  166.449917] em28xx #0:     card=23 -> Huaqi DLCW-130
[  166.449922] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  166.449927] em28xx #0:     card=25 -> Gadmei UTV310
[  166.449932] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  166.449937] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  166.449943] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  166.449948] em28xx #0:     card=29 -> (null)
[  166.449952] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  166.449957] em28xx #0:     card=31 -> Usbgear VD204v9
[  166.449962] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  166.449967] em28xx #0:     card=33 -> (null)
[  166.449971] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  166.449976] em28xx #0:     card=35 -> Typhoon DVD Maker
[  166.449981] em28xx #0:     card=36 -> NetGMBH Cam
[  166.449986] em28xx #0:     card=37 -> Gadmei UTV330
[  166.449991] em28xx #0:     card=38 -> Yakumo MovieMixer
[  166.449995] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  166.450000] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  166.450023] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  166.450028] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  166.450033] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  166.450039] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  166.450046] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  166.450051] em28xx #0:     card=46 -> Compro, VideoMate U3
[  166.450057] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  166.450062] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  166.450068] em28xx #0:     card=49 -> MSI DigiVox A/D
[  166.450074] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  166.450080] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  166.450085] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  166.450091] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  166.450097] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  166.450103] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  166.450109] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  166.450115] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  166.450122] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  166.450127] em28xx #0:     card=59 -> (null)
[  166.450133] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  166.450139] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  166.450144] em28xx #0:     card=62 -> Gadmei TVR200
[  166.450150] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  166.450155] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  166.450161] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  166.450167] em28xx #0:     card=66 -> Empire dual TV
[  166.450173] em28xx #0:     card=67 -> Terratec Grabby
[  166.450179] em28xx #0:     card=68 -> Terratec AV350
[  166.450185] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  166.450191] em28xx #0:     card=70 -> Evga inDtube
[  166.450196] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  166.450203] em28xx #0:     card=72 -> Gadmei UTV330+
[  166.450208] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  166.450214] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  166.450221] em28xx #0:     card=75 -> Dikom DK300
[  166.454267] em28xx #0: Config register raw data: 0xffffffb9
[  166.458382] em28xx #0: AC97 chip type couldn't be determined
[  166.458388] em28xx #0: No AC97 audio processor
[  166.458395] em28xx #0: v4l2 driver version 0.1.2
[  166.462509] em28xx #0: cannot change alternate number to 6 (error=-71)
[  166.738218] em28xx #0: V4L2 video device registered as video1
[  166.903542] usbcore: registered new interface driver snd-usb-audio
[  166.904886] usbcore: registered new interface driver em28xx
[  166.904892] em28xx driver loaded
[  166.910575] em28xx #0: cannot change alternate number to 0 (error=-71)
[  167.038631] 3:2:2: usb_set_interface failed
[  167.042774] 3:2:2: usb_set_interface failed
[  167.047001] 3:2:2: usb_set_interface failed
[  167.055245] 3:2:2: usb_set_interface failed
[  167.063509] 3:2:2: usb_set_interface failed
[  167.100771] 3:2:2: usb_set_interface failed
[  167.104889] 3:2:2: usb_set_interface failed
[  167.109011] 3:2:2: usb_set_interface failed
[  167.117268] 3:2:2: usb_set_interface failed
[  167.125518] 3:2:2: usb_set_interface failed
[  167.163024] 3:2:2: usb_set_interface failed
[  167.167142] 3:2:2: usb_set_interface failed
[  167.171405] 3:2:2: usb_set_interface failed
[  167.179639] 3:2:2: usb_set_interface failed
[  167.187887] 3:2:2: usb_set_interface failed
[  167.225896] 3:2:2: usb_set_interface failed
[  167.230015] 3:2:2: usb_set_interface failed
[  167.234286] 3:2:2: usb_set_interface failed
[  167.242519] 3:2:2: usb_set_interface failed
[  167.250769] 3:2:2: usb_set_interface failed
[  167.350886] 3:2:2: usb_set_interface failed
[  167.359135] 3:2:2: usb_set_interface failed
[  167.367382] 3:2:2: usb_set_interface failed
[  167.375632] 3:2:2: usb_set_interface failed
[  167.383881] 3:2:2: usb_set_interface failed
[  167.412897] 3:2:2: usb_set_interface failed
[  167.417017] 3:2:2: usb_set_interface failed
[  167.421142] 3:2:2: usb_set_interface failed
[  167.429525] 3:2:2: usb_set_interface failed
[  167.437770] 3:2:2: usb_set_interface failed
[  167.475291] 3:2:2: usb_set_interface failed
[  167.479516] 3:2:2: usb_set_interface failed
[  167.483764] 3:2:2: usb_set_interface failed
[  167.492018] 3:2:2: usb_set_interface failed
[  167.500267] 3:2:2: usb_set_interface failed
[  167.538301] 3:2:2: usb_set_interface failed
[  167.542521] 3:2:2: usb_set_interface failed
[  167.546771] 3:2:2: usb_set_interface failed
[  167.555019] 3:2:2: usb_set_interface failed
[  167.563268] 3:2:2: usb_set_interface failed
[  167.660271] 3:2:2: usb_set_interface failed
[  167.668512] 3:2:2: usb_set_interface failed
[  167.676761] 3:2:2: usb_set_interface failed
[  167.685013] 3:2:2: usb_set_interface failed
[  167.693262] 3:2:2: usb_set_interface failed
[  167.722293] 3:2:2: usb_set_interface failed
[  167.726414] 3:2:2: usb_set_interface failed
[  167.730522] 3:2:2: usb_set_interface failed
[  167.738902] 3:2:2: usb_set_interface failed
[  167.747144] 3:2:2: usb_set_interface failed
[  167.784653] 3:2:2: usb_set_interface failed
[  167.788776] 3:2:2: usb_set_interface failed
[  167.793041] 3:2:2: usb_set_interface failed
[  167.801278] 3:2:2: usb_set_interface failed
[  167.809528] 3:2:2: usb_set_interface failed
[  167.847529] 3:2:2: usb_set_interface failed
[  167.851650] 3:2:2: usb_set_interface failed
[  167.855887] 3:2:2: usb_set_interface failed
[  167.864130] 3:2:2: usb_set_interface failed
[  167.872395] 3:2:2: usb_set_interface failed
[  167.974537] 3:2:2: usb_set_interface failed
[  167.982778] 3:2:2: usb_set_interface failed
[  167.991028] 3:2:2: usb_set_interface failed
[  167.999276] 3:2:2: usb_set_interface failed
[  168.007530] 3:2:2: usb_set_interface failed
[  168.036530] 3:2:2: usb_set_interface failed
[  168.040652] 3:2:2: usb_set_interface failed
[  168.044765] 3:2:2: usb_set_interface failed
[  168.053017] 3:2:2: usb_set_interface failed
[  168.061267] 3:2:2: usb_set_interface failed
[  168.098785] 3:2:2: usb_set_interface failed
[  168.102905] 3:2:2: usb_set_interface failed
[  168.107151] 3:2:2: usb_set_interface failed
[  168.115407] 3:2:2: usb_set_interface failed
[  168.123654] 3:2:2: usb_set_interface failed
[  168.161656] 3:2:2: usb_set_interface failed
[  168.165779] 3:2:2: usb_set_interface failed
[  168.170039] 3:2:2: usb_set_interface failed
[  168.178283] 3:2:2: usb_set_interface failed
[  168.186532] 3:2:2: usb_set_interface failed
[  168.280648] 3:2:2: usb_set_interface failed
[  168.288895] 3:2:2: usb_set_interface failed
[  168.297160] 3:2:2: usb_set_interface failed
[  168.305401] 3:2:2: usb_set_interface failed
[  168.313659] 3:2:2: usb_set_interface failed
[  168.342658] 3:2:2: usb_set_interface failed
[  168.346780] 3:2:2: usb_set_interface failed
[  168.350906] 3:2:2: usb_set_interface failed
[  168.359162] 3:2:2: usb_set_interface failed
[  168.367401] 3:2:2: usb_set_interface failed
[  168.404912] 3:2:2: usb_set_interface failed
[  168.409158] 3:2:2: usb_set_interface failed
[  168.413419] 3:2:2: usb_set_interface failed
[  168.421659] 3:2:2: usb_set_interface failed
[  168.429902] 3:2:2: usb_set_interface failed
[  168.468090] 3:2:2: usb_set_interface failed
[  168.472294] 3:2:2: usb_set_interface failed
[  168.476519] 3:2:2: usb_set_interface failed
[  168.484773] 3:2:2: usb_set_interface failed
[  168.493022] 3:2:2: usb_set_interface failed
[  168.589901] 3:2:2: usb_set_interface failed
[  168.598151] 3:2:2: usb_set_interface failed
[  168.606398] 3:2:2: usb_set_interface failed
[  168.614648] 3:2:2: usb_set_interface failed
[  168.622898] 3:2:2: usb_set_interface failed
[  168.651913] 3:2:2: usb_set_interface failed
[  168.656037] 3:2:2: usb_set_interface failed
[  168.660161] 3:2:2: usb_set_interface failed
[  168.668414] 3:2:2: usb_set_interface failed
[  168.676662] 3:2:2: usb_set_interface failed
[  168.714165] 3:2:2: usb_set_interface failed
[  168.718427] 3:2:2: usb_set_interface failed
[  168.722661] 3:2:2: usb_set_interface failed
[  168.730915] 3:2:2: usb_set_interface failed
[  168.739156] 3:2:2: usb_set_interface failed
[  168.777159] 3:2:2: usb_set_interface failed
[  168.781410] 3:2:2: usb_set_interface failed
[  168.785649] 3:2:2: usb_set_interface failed
[  168.793901] 3:2:2: usb_set_interface failed
[  168.802164] 3:2:2: usb_set_interface failed
[  187.842387] 3:2:2: usb_set_interface failed
[  187.846506] 3:2:2: usb_set_interface failed
[  187.850677] 3:2:2: usb_set_interface failed
[  187.855133] 3:2:2: usb_set_interface failed
[  187.859508] 3:2:2: usb_set_interface failed
[  187.864132] 3:2:2: usb_set_interface failed
[  187.868289] 3:2:2: usb_set_interface failed
[  187.872390] 3:2:2: usb_set_interface failed
[  187.876769] 3:2:2: usb_set_interface failed
[  187.881025] 3:2:2: usb_set_interface failed
[  187.885660] 3:2:2: usb_set_interface failed
[  187.889782] 3:2:2: usb_set_interface failed
[  187.894040] 3:2:2: usb_set_interface failed
[  187.898783] 3:2:2: usb_set_interface failed
[  187.903651] 3:2:2: usb_set_interface failed
[  187.909637] 3:2:2: usb_set_interface failed
[  187.913778] 3:2:2: usb_set_interface failed
[  187.917893] 3:2:2: usb_set_interface failed
[  187.922518] 3:2:2: usb_set_interface failed
[  187.927014] 3:2:2: usb_set_interface failed
[  187.931515] 3:2:2: usb_set_interface failed
[  187.935642] 3:2:2: usb_set_interface failed
[  187.939763] 3:2:2: usb_set_interface failed
[  187.944140] 3:2:2: usb_set_interface failed
[  187.948641] 3:2:2: usb_set_interface failed
[  187.953015] 3:2:2: usb_set_interface failed
[  187.957147] 3:2:2: usb_set_interface failed
[  187.961277] 3:2:2: usb_set_interface failed
[  187.965642] 3:2:2: usb_set_interface failed
[  187.970140] 3:2:2: usb_set_interface failed
[  187.975139] 3:2:2: usb_set_interface failed
[  187.979269] 3:2:2: usb_set_interface failed
[  187.983394] 3:2:2: usb_set_interface failed
[  187.987776] 3:2:2: usb_set_interface failed
[  187.992276] 3:2:2: usb_set_interface failed
[  187.996892] 3:2:2: usb_set_interface failed
[  188.001023] 3:2:2: usb_set_interface failed
[  188.005141] 3:2:2: usb_set_interface failed
[  188.009521] 3:2:2: usb_set_interface failed
[  188.013891] 3:2:2: usb_set_interface failed
[  188.018517] 3:2:2: usb_set_interface failed
[  188.022645] 3:2:2: usb_set_interface failed
[  188.026768] 3:2:2: usb_set_interface failed
[  188.031142] 3:2:2: usb_set_interface failed
[  188.035520] 3:2:2: usb_set_interface failed
[  188.040144] 3:2:2: usb_set_interface failed
[  188.044276] 3:2:2: usb_set_interface failed
[  188.048390] 3:2:2: usb_set_interface failed
[  188.052768] 3:2:2: usb_set_interface failed
[  188.057143] 3:2:2: usb_set_interface failed
[  188.061889] 3:2:2: usb_set_interface failed
[  188.066016] 3:2:2: usb_set_interface failed
[  188.070141] 3:2:2: usb_set_interface failed
[  188.074517] 3:2:2: usb_set_interface failed
[  188.079024] 3:2:2: usb_set_interface failed
[  188.083896] 3:2:2: usb_set_interface failed
[  188.088022] 3:2:2: usb_set_interface failed
[  188.092140] 3:2:2: usb_set_interface failed
[  188.096523] 3:2:2: usb_set_interface failed
[  188.100892] 3:2:2: usb_set_interface failed
[  188.309396] 3:2:2: usb_set_interface failed
[  188.313518] 3:2:2: usb_set_interface failed
[  188.317644] 3:2:2: usb_set_interface failed
[  188.322016] 3:2:2: usb_set_interface failed
[  188.326277] 3:2:2: usb_set_interface failed
[  188.330768] 3:2:2: usb_set_interface failed
[  188.334893] 3:2:2: usb_set_interface failed
[  188.339018] 3:2:2: usb_set_interface failed
[  188.343273] 3:2:2: usb_set_interface failed
[  188.347516] 3:2:2: usb_set_interface failed
[  188.352144] 3:2:2: usb_set_interface failed
[  188.356282] 3:2:2: usb_set_interface failed
[  188.360400] 3:2:2: usb_set_interface failed
[  188.364897] 3:2:2: usb_set_interface failed
[  188.369402] 3:2:2: usb_set_interface failed
[  188.374286] 3:2:2: usb_set_interface failed
[  188.378397] 3:2:2: usb_set_interface failed
[  188.382526] 3:2:2: usb_set_interface failed
[  188.386902] 3:2:2: usb_set_interface failed
[  188.391401] 3:2:2: usb_set_interface failed
[  188.395767] 3:2:2: usb_set_interface failed
[  188.399897] 3:2:2: usb_set_interface failed
[  188.404025] 3:2:2: usb_set_interface failed
[  188.408396] 3:2:2: usb_set_interface failed
[  188.412649] 3:2:2: usb_set_interface failed
[  188.417038] 3:2:2: usb_set_interface failed
[  188.421163] 3:2:2: usb_set_interface failed
[  188.425288] 3:2:2: usb_set_interface failed
[  188.429789] 3:2:2: usb_set_interface failed
[  188.434282] 3:2:2: usb_set_interface failed
[  188.439300] 3:2:2: usb_set_interface failed
[  188.443414] 3:2:2: usb_set_interface failed
[  188.447665] 3:2:2: usb_set_interface failed
[  188.452288] 3:2:2: usb_set_interface failed
[  188.456914] 3:2:2: usb_set_interface failed
[  188.462423] 3:2:2: usb_set_interface failed
[  188.466540] 3:2:2: usb_set_interface failed
[  188.470788] 3:2:2: usb_set_interface failed
[  188.475409] 3:2:2: usb_set_interface failed
[  188.480041] 3:2:2: usb_set_interface failed
[  188.485792] 3:2:2: usb_set_interface failed
[  188.489913] 3:2:2: usb_set_interface failed
[  188.494042] 3:2:2: usb_set_interface failed
[  188.498535] 3:2:2: usb_set_interface failed
[  188.503041] 3:2:2: usb_set_interface failed
[  188.508665] 3:2:2: usb_set_interface failed
[  188.512790] 3:2:2: usb_set_interface failed
[  188.516914] 3:2:2: usb_set_interface failed
[  188.521423] 3:2:2: usb_set_interface failed
[  188.525915] 3:2:2: usb_set_interface failed
[  188.531917] 3:2:2: usb_set_interface failed
[  188.536042] 3:2:2: usb_set_interface failed
[  188.540285] 3:2:2: usb_set_interface failed
[  188.544916] 3:2:2: usb_set_interface failed
[  188.549535] 3:2:2: usb_set_interface failed
[  188.555922] 3:2:2: usb_set_interface failed
[  188.560042] 3:2:2: usb_set_interface failed
[  188.564286] 3:2:2: usb_set_interface failed
[  188.568921] 3:2:2: usb_set_interface failed
[  188.573660] 3:2:2: usb_set_interface failed
[  188.606153] 3:2:2: usb_set_interface failed
[  188.610276] 3:2:2: usb_set_interface failed
[  188.614404] 3:2:2: usb_set_interface failed
[  188.618665] 3:2:2: usb_set_interface failed
[  188.623164] 3:2:2: usb_set_interface failed
[  188.628544] 3:2:2: usb_set_interface failed
[  188.632666] 3:2:2: usb_set_interface failed
[  188.636790] 3:2:2: usb_set_interface failed
[  188.641290] 3:2:2: usb_set_interface failed
[  188.645791] 3:2:2: usb_set_interface failed
[  188.651444] 3:2:2: usb_set_interface failed
[  188.655537] 3:2:2: usb_set_interface failed
[  188.659783] 3:2:2: usb_set_interface failed
[  188.664534] 3:2:2: usb_set_interface failed
[  188.669159] 3:2:2: usb_set_interface failed
[  188.675034] 3:2:2: usb_set_interface failed
[  188.679160] 3:2:2: usb_set_interface failed
[  188.683546] 3:2:2: usb_set_interface failed
[  188.688306] 3:2:2: usb_set_interface failed
[  188.693170] 3:2:2: usb_set_interface failed
[  188.698025] 3:2:2: usb_set_interface failed
[  188.702148] 3:2:2: usb_set_interface failed
[  188.706281] 3:2:2: usb_set_interface failed
[  188.710697] 3:2:2: usb_set_interface failed
[  188.715025] 3:2:2: usb_set_interface failed
[  188.719650] 3:2:2: usb_set_interface failed
[  188.723849] 3:2:2: usb_set_interface failed
[  188.727901] 3:2:2: usb_set_interface failed
[  188.732405] 3:2:2: usb_set_interface failed
[  188.736776] 3:2:2: usb_set_interface failed
[  188.741285] 3:2:2: usb_set_interface failed
[  188.745400] 3:2:2: usb_set_interface failed
[  188.749530] 3:2:2: usb_set_interface failed
[  188.755267] 3:2:2: usb_set_interface failed
[  188.759649] 3:2:2: usb_set_interface failed
[  188.765267] 3:2:2: usb_set_interface failed
[  188.769401] 3:2:2: usb_set_interface failed
[  188.773528] 3:2:2: usb_set_interface failed
[  188.777902] 3:2:2: usb_set_interface failed
[  188.782405] 3:2:2: usb_set_interface failed
[  188.787028] 3:2:2: usb_set_interface failed
[  188.791152] 3:2:2: usb_set_interface failed
[  188.795284] 3:2:2: usb_set_interface failed
[  188.799652] 3:2:2: usb_set_interface failed
[  188.804026] 3:2:2: usb_set_interface failed
[  188.808651] 3:2:2: usb_set_interface failed
[  188.812776] 3:2:2: usb_set_interface failed
[  188.816905] 3:2:2: usb_set_interface failed
[  188.821403] 3:2:2: usb_set_interface failed
[  188.825775] 3:2:2: usb_set_interface failed
[  188.830528] 3:2:2: usb_set_interface failed
[  188.834649] 3:2:2: usb_set_interface failed
[  188.838775] 3:2:2: usb_set_interface failed
[  188.843153] 3:2:2: usb_set_interface failed
[  188.847689] 3:2:2: usb_set_interface failed
[  188.852907] 3:2:2: usb_set_interface failed
[  188.857032] 3:2:2: usb_set_interface failed
[  188.861153] 3:2:2: usb_set_interface failed
[  188.865655] 3:2:2: usb_set_interface failed
[  188.870157] 3:2:2: usb_set_interface failed
[  188.895295] 3:2:2: usb_set_interface failed
[  188.899409] 3:2:2: usb_set_interface failed
[  188.903529] 3:2:2: usb_set_interface failed
[  188.907904] 3:2:2: usb_set_interface failed
[  188.912287] 3:2:2: usb_set_interface failed
[  188.917295] 3:2:2: usb_set_interface failed
[  188.921404] 3:2:2: usb_set_interface failed
[  188.925532] 3:2:2: usb_set_interface failed
[  188.929906] 3:2:2: usb_set_interface failed
[  188.934294] 3:2:2: usb_set_interface failed
[  188.938932] 3:2:2: usb_set_interface failed
[  188.943038] 3:2:2: usb_set_interface failed
[  188.947155] 3:2:2: usb_set_interface failed
[  188.951656] 3:2:2: usb_set_interface failed
[  188.956169] 3:2:2: usb_set_interface failed
[  188.961031] 3:2:2: usb_set_interface failed
[  188.965157] 3:2:2: usb_set_interface failed
[  188.969289] 3:2:2: usb_set_interface failed
[  188.973781] 3:2:2: usb_set_interface failed
[  188.978288] 3:2:2: usb_set_interface failed
[  188.982661] 3:2:2: usb_set_interface failed
[  188.986780] 3:2:2: usb_set_interface failed
[  188.990906] 3:2:2: usb_set_interface failed
[  188.995280] 3:2:2: usb_set_interface failed
[  188.999664] 3:2:2: usb_set_interface failed
[  189.004032] 3:2:2: usb_set_interface failed
[  189.008162] 3:2:2: usb_set_interface failed
[  189.012288] 3:2:2: usb_set_interface failed
[  189.016655] 3:2:2: usb_set_interface failed
[  189.021031] 3:2:2: usb_set_interface failed
[  189.025532] 3:2:2: usb_set_interface failed
[  189.029652] 3:2:2: usb_set_interface failed
[  189.033779] 3:2:2: usb_set_interface failed
[  189.038284] 3:2:2: usb_set_interface failed
[  189.042652] 3:2:2: usb_set_interface failed
[  189.047407] 3:2:2: usb_set_interface failed
[  189.051525] 3:2:2: usb_set_interface failed
[  189.055654] 3:2:2: usb_set_interface failed
[  189.060030] 3:2:2: usb_set_interface failed
[  189.064407] 3:2:2: usb_set_interface failed
[  189.069159] 3:2:2: usb_set_interface failed
[  189.073291] 3:2:2: usb_set_interface failed
[  189.077425] 3:2:2: usb_set_interface failed
[  189.082041] 3:2:2: usb_set_interface failed
[  189.087494] 3:2:2: usb_set_interface failed
[  189.092156] 3:2:2: usb_set_interface failed
[  189.096284] 3:2:2: usb_set_interface failed
[  189.100407] 3:2:2: usb_set_interface failed
[  189.104787] 3:2:2: usb_set_interface failed
[  189.109159] 3:2:2: usb_set_interface failed
[  189.113906] 3:2:2: usb_set_interface failed
[  189.118034] 3:2:2: usb_set_interface failed
[  189.122169] 3:2:2: usb_set_interface failed
[  189.126658] 3:2:2: usb_set_interface failed
[  189.131031] 3:2:2: usb_set_interface failed
[  189.135910] 3:2:2: usb_set_interface failed
[  189.140029] 3:2:2: usb_set_interface failed
[  189.144157] 3:2:2: usb_set_interface failed
[  189.148534] 3:2:2: usb_set_interface failed
[  189.152904] 3:2:2: usb_set_interface failed
[  189.176403] 3:2:2: usb_set_interface failed
[  189.180526] 3:2:2: usb_set_interface failed
[  189.184651] 3:2:2: usb_set_interface failed
[  189.189278] 3:2:2: usb_set_interface failed
[  189.193654] 3:2:2: usb_set_interface failed
[  189.198283] 3:2:2: usb_set_interface failed
[  189.202402] 3:2:2: usb_set_interface failed
[  189.206525] 3:2:2: usb_set_interface failed
[  189.210927] 3:2:2: usb_set_interface failed
[  189.215903] 3:2:2: usb_set_interface failed
[  189.220652] 3:2:2: usb_set_interface failed
[  189.224775] 3:2:2: usb_set_interface failed
[  189.228900] 3:2:2: usb_set_interface failed
[  189.233402] 3:2:2: usb_set_interface failed
[  189.237776] 3:2:2: usb_set_interface failed
[  189.242658] 3:2:2: usb_set_interface failed
[  189.246782] 3:2:2: usb_set_interface failed
[  189.250909] 3:2:2: usb_set_interface failed
[  189.255403] 3:2:2: usb_set_interface failed
[  189.259902] 3:2:2: usb_set_interface failed
[  189.264279] 3:2:2: usb_set_interface failed
[  189.268407] 3:2:2: usb_set_interface failed
[  189.272537] 3:2:2: usb_set_interface failed
[  189.276911] 3:2:2: usb_set_interface failed
[  189.281289] 3:2:2: usb_set_interface failed
[  189.285914] 3:2:2: usb_set_interface failed
[  189.290027] 3:2:2: usb_set_interface failed
[  189.294151] 3:2:2: usb_set_interface failed
[  189.298532] 3:2:2: usb_set_interface failed
[  189.302902] 3:2:2: usb_set_interface failed
[  189.307399] 3:2:2: usb_set_interface failed
[  189.311529] 3:2:2: usb_set_interface failed
[  189.315653] 3:2:2: usb_set_interface failed
[  189.320153] 3:2:2: usb_set_interface failed
[  189.324682] 3:2:2: usb_set_interface failed
[  189.329404] 3:2:2: usb_set_interface failed
[  189.333533] 3:2:2: usb_set_interface failed
[  189.337651] 3:2:2: usb_set_interface failed
[  189.342047] 3:2:2: usb_set_interface failed
[  189.346528] 3:2:2: usb_set_interface failed
[  189.351285] 3:2:2: usb_set_interface failed
[  189.355493] 3:2:2: usb_set_interface failed
[  189.359529] 3:2:2: usb_set_interface failed
[  189.363904] 3:2:2: usb_set_interface failed
[  189.368403] 3:2:2: usb_set_interface failed
[  189.373153] 3:2:2: usb_set_interface failed
[  189.377300] 3:2:2: usb_set_interface failed
[  189.381404] 3:2:2: usb_set_interface failed
[  189.385778] 3:2:2: usb_set_interface failed
[  189.390152] 3:2:2: usb_set_interface failed
[  189.394903] 3:2:2: usb_set_interface failed
[  189.399037] 3:2:2: usb_set_interface failed
[  189.403154] 3:2:2: usb_set_interface failed
[  189.407652] 3:2:2: usb_set_interface failed
[  189.412317] 3:2:2: usb_set_interface failed
[  189.417405] 3:2:2: usb_set_interface failed
[  189.421528] 3:2:2: usb_set_interface failed
[  189.425655] 3:2:2: usb_set_interface failed
[  189.430279] 3:2:2: usb_set_interface failed
[  189.434778] 3:2:2: usb_set_interface failed
[  189.459658] 3:2:2: usb_set_interface failed
[  189.463779] 3:2:2: usb_set_interface failed
[  189.467910] 3:2:2: usb_set_interface failed
[  189.472410] 3:2:2: usb_set_interface failed
[  189.476780] 3:2:2: usb_set_interface failed
[  189.481684] 3:2:2: usb_set_interface failed
[  189.485778] 3:2:2: usb_set_interface failed
[  189.489904] 3:2:2: usb_set_interface failed
[  189.494281] 3:2:2: usb_set_interface failed
[  189.498656] 3:2:2: usb_set_interface failed
[  189.503404] 3:2:2: usb_set_interface failed
[  189.507533] 3:2:2: usb_set_interface failed
[  189.511664] 3:2:2: usb_set_interface failed
[  189.516282] 3:2:2: usb_set_interface failed
[  189.520778] 3:2:2: usb_set_interface failed
[  189.525653] 3:2:2: usb_set_interface failed
[  189.529787] 3:2:2: usb_set_interface failed
[  189.533906] 3:2:2: usb_set_interface failed
[  189.538406] 3:2:2: usb_set_interface failed
[  189.542913] 3:2:2: usb_set_interface failed
[  189.547421] 3:2:2: usb_set_interface failed
[  189.551533] 3:2:2: usb_set_interface failed
[  189.555662] 3:2:2: usb_set_interface failed
[  189.560157] 3:2:2: usb_set_interface failed
[  189.564656] 3:2:2: usb_set_interface failed
[  189.569173] 3:2:2: usb_set_interface failed
[  189.573281] 3:2:2: usb_set_interface failed
[  189.577442] 3:2:2: usb_set_interface failed
[  189.581904] 3:2:2: usb_set_interface failed
[  189.586281] 3:2:2: usb_set_interface failed
[  189.590779] 3:2:2: usb_set_interface failed
[  189.594904] 3:2:2: usb_set_interface failed
[  189.599031] 3:2:2: usb_set_interface failed
[  189.603530] 3:2:2: usb_set_interface failed
[  189.608032] 3:2:2: usb_set_interface failed
[  189.612654] 3:2:2: usb_set_interface failed
[  189.616781] 3:2:2: usb_set_interface failed
[  189.620905] 3:2:2: usb_set_interface failed
[  189.627044] 3:2:2: usb_set_interface failed
[  189.631530] 3:2:2: usb_set_interface failed
[  189.636288] 3:2:2: usb_set_interface failed
[  189.640411] 3:2:2: usb_set_interface failed
[  189.644533] 3:2:2: usb_set_interface failed
[  189.648778] 3:2:2: usb_set_interface failed
[  189.653031] 3:2:2: usb_set_interface failed
[  189.657785] 3:2:2: usb_set_interface failed
[  189.661906] 3:2:2: usb_set_interface failed
[  189.666031] 3:2:2: usb_set_interface failed
[  189.670414] 3:2:2: usb_set_interface failed
[  189.674910] 3:2:2: usb_set_interface failed
[  189.679665] 3:2:2: usb_set_interface failed
[  189.683789] 3:2:2: usb_set_interface failed
[  189.687911] 3:2:2: usb_set_interface failed
[  189.692413] 3:2:2: usb_set_interface failed
[  189.696915] 3:2:2: usb_set_interface failed
[  189.701905] 3:2:2: usb_set_interface failed
[  189.706026] 3:2:2: usb_set_interface failed
[  189.710157] 3:2:2: usb_set_interface failed
[  189.714672] 3:2:2: usb_set_interface failed
[  189.719158] 3:2:2: usb_set_interface failed
[  191.267458] wlan0: deauthenticating from 00:16:b6:b7:77:12 by local choice (reason=3)
[  191.267522] wlan0: authenticate with 00:16:b6:b7:77:12 (try 1)
[  191.270480] wlan0: authenticated
[  191.270530] wlan0: associate with 00:16:b6:b7:77:12 (try 1)
[  191.272840] wlan0: RX AssocResp from 00:16:b6:b7:77:12 (capab=0x411 status=0 aid=1)
[  191.272847] wlan0: associated
[  191.274990] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  191.437244] Intel AES-NI instructions are not detected.
[  191.464563] padlock: VIA PadLock not detected.
[  191.470651] /dev/vmnet: open called by PID 1092 (vmnet-bridge)
[  191.470674] /dev/vmnet: hub 0 does not exist, allocating memory.
[  191.470727] /dev/vmnet: port on hub 0 successfully opened
[  191.470765] bridge-wlan0: up
[  191.470772] bridge-wlan0: attached
[  201.320275] wlan0: no IPv6 routers present
[  207.063668] usb 1-1.4: USB disconnect, address 3
[  207.063777] em28xx #0: disconnecting em28xx #0 video
[  207.063785] em28xx #0: V4L2 device video1 deregistered
[  208.778743] usb 1-1.4: new high speed USB device using ehci_hcd and address 4
[  208.865138] em28xx: New device @ 480 Mbps (eb1a:2821, interface 0, class 0)
[  208.865540] em28xx #0: chip ID is em2820 (or em2710)
[  209.934907] em28xx #0: reading from i2c device failed (error=-110)
[  209.934917] em28xx #0: board has no eeprom
[  210.934914] em28xx #0: reading from i2c device failed (error=-110)
[  211.934925] em28xx #0: reading i2c device failed (error=-110)
[  212.934246] em28xx #0: reading from i2c device failed (error=-110)
[  213.945525] em28xx #0: reading i2c device failed (error=-71)
[  213.945536] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  213.949614] em28xx #0: reading from i2c device failed (error=-71)
[  213.953737] em28xx #0: reading from i2c device failed (error=-71)
[  213.957862] em28xx #0: reading from i2c device failed (error=-71)
[  213.961988] em28xx #0: reading from i2c device failed (error=-71)
[  213.966116] em28xx #0: reading from i2c device failed (error=-71)
[  213.970237] em28xx #0: reading from i2c device failed (error=-71)
[  213.974362] em28xx #0: reading from i2c device failed (error=-71)
[  213.978488] em28xx #0: reading from i2c device failed (error=-71)
[  213.982612] em28xx #0: reading from i2c device failed (error=-71)
[  213.986737] em28xx #0: reading from i2c device failed (error=-71)
[  213.990862] em28xx #0: reading from i2c device failed (error=-71)
[  213.994987] em28xx #0: reading from i2c device failed (error=-71)
[  213.999114] em28xx #0: reading from i2c device failed (error=-71)
[  214.003237] em28xx #0: reading from i2c device failed (error=-71)
[  214.007362] em28xx #0: reading from i2c device failed (error=-71)
[  214.011488] em28xx #0: reading from i2c device failed (error=-71)
[  214.015612] em28xx #0: reading from i2c device failed (error=-71)
[  214.019737] em28xx #0: reading from i2c device failed (error=-71)
[  214.023862] em28xx #0: reading from i2c device failed (error=-71)
[  214.027987] em28xx #0: reading from i2c device failed (error=-71)
[  214.032114] em28xx #0: reading from i2c device failed (error=-71)
[  214.036237] em28xx #0: reading from i2c device failed (error=-71)
[  214.040362] em28xx #0: reading from i2c device failed (error=-71)
[  214.044486] em28xx #0: reading from i2c device failed (error=-71)
[  214.048614] em28xx #0: reading from i2c device failed (error=-71)
[  214.052738] em28xx #0: reading from i2c device failed (error=-71)
[  214.056862] em28xx #0: reading from i2c device failed (error=-71)
[  214.060982] em28xx #0: reading from i2c device failed (error=-71)
[  214.065117] em28xx #0: reading from i2c device failed (error=-71)
[  214.069237] em28xx #0: reading from i2c device failed (error=-71)
[  214.073361] em28xx #0: reading from i2c device failed (error=-71)
[  214.077485] em28xx #0: reading from i2c device failed (error=-71)
[  214.081612] em28xx #0: reading from i2c device failed (error=-71)
[  214.085737] em28xx #0: reading from i2c device failed (error=-71)
[  214.089862] em28xx #0: reading from i2c device failed (error=-71)
[  214.093987] em28xx #0: reading from i2c device failed (error=-71)
[  214.098115] em28xx #0: reading from i2c device failed (error=-71)
[  214.102237] em28xx #0: reading from i2c device failed (error=-71)
[  214.106361] em28xx #0: reading from i2c device failed (error=-71)
[  214.110487] em28xx #0: reading from i2c device failed (error=-71)
[  214.114611] em28xx #0: reading from i2c device failed (error=-71)
[  214.118739] em28xx #0: reading from i2c device failed (error=-71)
[  214.122863] em28xx #0: reading from i2c device failed (error=-71)
[  214.126987] em28xx #0: reading from i2c device failed (error=-71)
[  214.131115] em28xx #0: reading from i2c device failed (error=-71)
[  214.135238] em28xx #0: reading from i2c device failed (error=-71)
[  214.139363] em28xx #0: reading from i2c device failed (error=-71)
[  214.143488] em28xx #0: reading from i2c device failed (error=-71)
[  214.147614] em28xx #0: reading from i2c device failed (error=-71)
[  214.151736] em28xx #0: reading from i2c device failed (error=-71)
[  214.155863] em28xx #0: reading from i2c device failed (error=-71)
[  214.159990] em28xx #0: reading from i2c device failed (error=-71)
[  214.164113] em28xx #0: reading from i2c device failed (error=-71)
[  214.168237] em28xx #0: reading from i2c device failed (error=-71)
[  214.172364] em28xx #0: reading from i2c device failed (error=-71)
[  214.176488] em28xx #0: reading from i2c device failed (error=-71)
[  214.180612] em28xx #0: reading from i2c device failed (error=-71)
[  214.184739] em28xx #0: reading from i2c device failed (error=-71)
[  214.188863] em28xx #0: reading from i2c device failed (error=-71)
[  214.192989] em28xx #0: reading from i2c device failed (error=-71)
[  214.197116] em28xx #0: reading from i2c device failed (error=-71)
[  214.201238] em28xx #0: reading from i2c device failed (error=-71)
[  214.205363] em28xx #0: reading from i2c device failed (error=-71)
[  214.209488] em28xx #0: reading from i2c device failed (error=-71)
[  214.213612] em28xx #0: reading from i2c device failed (error=-71)
[  214.217738] em28xx #0: reading from i2c device failed (error=-71)
[  214.221863] em28xx #0: reading from i2c device failed (error=-71)
[  214.225989] em28xx #0: reading from i2c device failed (error=-71)
[  214.230114] em28xx #0: reading from i2c device failed (error=-71)
[  214.234238] em28xx #0: reading from i2c device failed (error=-71)
[  214.238363] em28xx #0: reading from i2c device failed (error=-71)
[  214.242488] em28xx #0: reading from i2c device failed (error=-71)
[  214.246613] em28xx #0: reading from i2c device failed (error=-71)
[  214.250736] em28xx #0: reading from i2c device failed (error=-71)
[  214.254863] em28xx #0: reading from i2c device failed (error=-71)
[  214.258989] em28xx #0: reading from i2c device failed (error=-71)
[  214.263116] em28xx #0: reading from i2c device failed (error=-71)
[  214.267238] em28xx #0: reading from i2c device failed (error=-71)
[  214.271363] em28xx #0: reading from i2c device failed (error=-71)
[  214.275489] em28xx #0: reading from i2c device failed (error=-71)
[  214.279613] em28xx #0: reading from i2c device failed (error=-71)
[  214.283739] em28xx #0: reading from i2c device failed (error=-71)
[  214.287875] em28xx #0: reading from i2c device failed (error=-71)
[  214.291989] em28xx #0: reading from i2c device failed (error=-71)
[  214.296115] em28xx #0: reading from i2c device failed (error=-71)
[  214.300239] em28xx #0: reading from i2c device failed (error=-71)
[  214.304363] em28xx #0: reading from i2c device failed (error=-71)
[  214.308490] em28xx #0: reading from i2c device failed (error=-71)
[  214.312626] em28xx #0: reading from i2c device failed (error=-71)
[  214.316739] em28xx #0: reading from i2c device failed (error=-71)
[  214.320864] em28xx #0: reading from i2c device failed (error=-71)
[  214.324986] em28xx #0: reading from i2c device failed (error=-71)
[  214.329118] em28xx #0: reading from i2c device failed (error=-71)
[  214.333242] em28xx #0: reading from i2c device failed (error=-71)
[  214.337366] em28xx #0: reading from i2c device failed (error=-71)
[  214.341491] em28xx #0: reading from i2c device failed (error=-71)
[  214.345614] em28xx #0: reading from i2c device failed (error=-71)
[  214.349741] em28xx #0: reading from i2c device failed (error=-71)
[  214.353866] em28xx #0: reading from i2c device failed (error=-71)
[  214.357991] em28xx #0: reading from i2c device failed (error=-71)
[  214.362118] em28xx #0: reading from i2c device failed (error=-71)
[  214.366241] em28xx #0: reading from i2c device failed (error=-71)
[  214.370365] em28xx #0: reading from i2c device failed (error=-71)
[  214.374489] em28xx #0: reading from i2c device failed (error=-71)
[  214.378616] em28xx #0: reading from i2c device failed (error=-71)
[  214.382739] em28xx #0: reading from i2c device failed (error=-71)
[  214.386864] em28xx #0: reading from i2c device failed (error=-71)
[  214.390991] em28xx #0: reading from i2c device failed (error=-71)
[  214.395118] em28xx #0: reading from i2c device failed (error=-71)
[  214.399241] em28xx #0: reading from i2c device failed (error=-71)
[  214.403367] em28xx #0: reading from i2c device failed (error=-71)
[  214.407491] em28xx #0: reading from i2c device failed (error=-71)
[  214.411616] em28xx #0: reading from i2c device failed (error=-71)
[  214.415741] em28xx #0: reading from i2c device failed (error=-71)
[  214.419866] em28xx #0: reading from i2c device failed (error=-71)
[  214.423992] em28xx #0: reading from i2c device failed (error=-71)
[  214.428119] em28xx #0: reading from i2c device failed (error=-71)
[  214.432241] em28xx #0: reading from i2c device failed (error=-71)
[  214.436366] em28xx #0: reading from i2c device failed (error=-71)
[  214.440492] em28xx #0: reading from i2c device failed (error=-71)
[  214.444616] em28xx #0: reading from i2c device failed (error=-71)
[  214.448742] em28xx #0: reading from i2c device failed (error=-71)
[  214.452868] em28xx #0: reading from i2c device failed (error=-71)
[  214.456991] em28xx #0: reading from i2c device failed (error=-71)
[  214.461116] em28xx #0: reading from i2c device failed (error=-71)
[  214.465240] em28xx #0: reading from i2c device failed (error=-71)
[  214.469367] em28xx #0: reading from i2c device failed (error=-71)
[  214.473491] em28xx #0: reading from i2c device failed (error=-71)
[  214.473499] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[  214.473506] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[  214.473510] em28xx #0: Please send an email with this log to:
[  214.473515] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[  214.473520] em28xx #0: Board eeprom hash is 0x00000000
[  214.473525] em28xx #0: Board i2c devicelist hash is 0x1b800080
[  214.473529] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[  214.473535] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  214.473541] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  214.473547] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  214.473552] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  214.473557] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  214.473562] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  214.473567] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  214.473572] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  214.473576] em28xx #0:     card=8 -> Kworld USB2800
[  214.473591] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[  214.473597] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  214.473602] em28xx #0:     card=11 -> Terratec Hybrid XS
[  214.473607] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  214.473612] em28xx #0:     card=13 -> Terratec Prodigy XS
[  214.473617] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[  214.473622] em28xx #0:     card=15 -> V-Gear PocketTV
[  214.473627] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  214.473632] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  214.473637] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  214.473643] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  214.473648] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  214.473653] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[  214.473659] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  214.473664] em28xx #0:     card=23 -> Huaqi DLCW-130
[  214.473669] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  214.473674] em28xx #0:     card=25 -> Gadmei UTV310
[  214.473679] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  214.473684] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[  214.473689] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  214.473694] em28xx #0:     card=29 -> (null)
[  214.473699] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  214.473704] em28xx #0:     card=31 -> Usbgear VD204v9
[  214.473708] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  214.473713] em28xx #0:     card=33 -> (null)
[  214.473718] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  214.473723] em28xx #0:     card=35 -> Typhoon DVD Maker
[  214.473727] em28xx #0:     card=36 -> NetGMBH Cam
[  214.473732] em28xx #0:     card=37 -> Gadmei UTV330
[  214.473737] em28xx #0:     card=38 -> Yakumo MovieMixer
[  214.473742] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  214.473747] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  214.473752] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  214.473757] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  214.473762] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  214.473767] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  214.473772] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  214.473777] em28xx #0:     card=46 -> Compro, VideoMate U3
[  214.473781] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  214.473786] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  214.473791] em28xx #0:     card=49 -> MSI DigiVox A/D
[  214.473796] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  214.473801] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  214.473806] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  214.473810] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  214.473815] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  214.473820] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  214.473825] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  214.473830] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  214.473835] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  214.473840] em28xx #0:     card=59 -> (null)
[  214.473845] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  214.473850] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  214.473856] em28xx #0:     card=62 -> Gadmei TVR200
[  214.473860] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  214.473865] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  214.473870] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  214.473875] em28xx #0:     card=66 -> Empire dual TV
[  214.473880] em28xx #0:     card=67 -> Terratec Grabby
[  214.473885] em28xx #0:     card=68 -> Terratec AV350
[  214.473889] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  214.473894] em28xx #0:     card=70 -> Evga inDtube
[  214.473899] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  214.473904] em28xx #0:     card=72 -> Gadmei UTV330+
[  214.473909] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[  214.473914] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[  214.473919] em28xx #0:     card=75 -> Dikom DK300
[  214.477985] em28xx #0: Config register raw data: 0xffffffb9
[  214.482119] em28xx #0: AC97 chip type couldn't be determined
[  214.482124] em28xx #0: No AC97 audio processor
[  214.482131] em28xx #0: v4l2 driver version 0.1.2
[  214.486243] em28xx #0: cannot change alternate number to 6 (error=-71)
[  214.762368] em28xx #0: V4L2 video device registered as video1
[  214.933318] em28xx #0: cannot change alternate number to 0 (error=-71)
[  214.952361] 4:2:2: usb_set_interface failed
[  214.956484] 4:2:2: usb_set_interface failed
[  214.964739] 4:2:2: usb_set_interface failed
[  214.972987] 4:2:2: usb_set_interface failed
[  214.981252] 4:2:2: usb_set_interface failed
[  215.014876] 4:2:2: usb_set_interface failed
[  215.018998] 4:2:2: usb_set_interface failed
[  215.023118] 4:2:2: usb_set_interface failed
[  215.027862] 4:2:2: usb_set_interface failed
[  215.036112] 4:2:2: usb_set_interface failed
[  215.078251] 4:2:2: usb_set_interface failed
[  215.082501] 4:2:2: usb_set_interface failed
[  215.086737] 4:2:2: usb_set_interface failed
[  215.094991] 4:2:2: usb_set_interface failed
[  215.103239] 4:2:2: usb_set_interface failed
[  215.141756] 4:2:2: usb_set_interface failed
[  215.145984] 4:2:2: usb_set_interface failed
[  215.150118] 4:2:2: usb_set_interface failed
[  215.158357] 4:2:2: usb_set_interface failed
[  215.166614] 4:2:2: usb_set_interface failed
[  215.203877] 4:2:2: usb_set_interface failed
[  215.208002] 4:2:2: usb_set_interface failed
[  215.212126] 4:2:2: usb_set_interface failed
[  215.220504] 4:2:2: usb_set_interface failed
[  215.228752] 4:2:2: usb_set_interface failed
[  215.266128] 4:2:2: usb_set_interface failed
[  215.270392] 4:2:2: usb_set_interface failed
[  215.274488] 4:2:2: usb_set_interface failed
[  215.282740] 4:2:2: usb_set_interface failed
[  215.290990] 4:2:2: usb_set_interface failed
[  215.328496] 4:2:2: usb_set_interface failed
[  215.332614] 4:2:2: usb_set_interface failed
[  215.340866] 4:2:2: usb_set_interface failed
[  215.349113] 4:2:2: usb_set_interface failed
[  215.357373] 4:2:2: usb_set_interface failed
[  215.391281] 4:2:2: usb_set_interface failed
[  215.395502] 4:2:2: usb_set_interface failed
[  215.399877] 4:2:2: usb_set_interface failed
[  215.408968] 4:2:2: usb_set_interface failed
[  215.416391] 4:2:2: usb_set_interface failed
[  215.456617] 4:2:2: usb_set_interface failed
[  215.460744] 4:2:2: usb_set_interface failed
[  215.468988] 4:2:2: usb_set_interface failed
[  215.477271] 4:2:2: usb_set_interface failed
[  215.485496] 4:2:2: usb_set_interface failed
[  215.519492] 4:2:2: usb_set_interface failed
[  215.523622] 4:2:2: usb_set_interface failed
[  215.531866] 4:2:2: usb_set_interface failed
[  215.540124] 4:2:2: usb_set_interface failed
[  215.548399] 4:2:2: usb_set_interface failed
[  215.582368] 4:2:2: usb_set_interface failed
[  215.586493] 4:2:2: usb_set_interface failed
[  215.594951] 4:2:2: usb_set_interface failed
[  215.603002] 4:2:2: usb_set_interface failed
[  215.611252] 4:2:2: usb_set_interface failed
[  215.646389] 4:2:2: usb_set_interface failed
[  215.650638] 4:2:2: usb_set_interface failed
[  215.654987] 4:2:2: usb_set_interface failed
[  215.659494] 4:2:2: usb_set_interface failed
[  215.667750] 4:2:2: usb_set_interface failed
[  215.836513] 4:2:2: usb_set_interface failed
[  215.844757] 4:2:2: usb_set_interface failed
[  215.853024] 4:2:2: usb_set_interface failed
[  215.861258] 4:2:2: usb_set_interface failed
[  215.869508] 4:2:2: usb_set_interface failed
[  215.899033] 4:2:2: usb_set_interface failed
[  215.903140] 4:2:2: usb_set_interface failed
[  215.907254] 4:2:2: usb_set_interface failed
[  215.912030] 4:2:2: usb_set_interface failed
[  215.920260] 4:2:2: usb_set_interface failed
[  215.962408] 4:2:2: usb_set_interface failed
[  215.966637] 4:2:2: usb_set_interface failed
[  215.971010] 4:2:2: usb_set_interface failed
[  215.979267] 4:2:2: usb_set_interface failed
[  215.987510] 4:2:2: usb_set_interface failed
[  216.026014] 4:2:2: usb_set_interface failed
[  216.030281] 4:2:2: usb_set_interface failed
[  216.034635] 4:2:2: usb_set_interface failed
[  216.042890] 4:2:2: usb_set_interface failed
[  216.051134] 4:2:2: usb_set_interface failed
[  216.088517] 4:2:2: usb_set_interface failed
[  216.092638] 4:2:2: usb_set_interface failed
[  216.096763] 4:2:2: usb_set_interface failed
[  216.105018] 4:2:2: usb_set_interface failed
[  216.113271] 4:2:2: usb_set_interface failed
[  216.150646] 4:2:2: usb_set_interface failed
[  216.154763] 4:2:2: usb_set_interface failed
[  216.158887] 4:2:2: usb_set_interface failed
[  216.167267] 4:2:2: usb_set_interface failed
[  216.175516] 4:2:2: usb_set_interface failed
[  216.213145] 4:2:2: usb_set_interface failed
[  216.217406] 4:2:2: usb_set_interface failed
[  216.221764] 4:2:2: usb_set_interface failed
[  216.230019] 4:2:2: usb_set_interface failed
[  216.238271] 4:2:2: usb_set_interface failed
[  216.276286] 4:2:2: usb_set_interface failed
[  216.280517] 4:2:2: usb_set_interface failed
[  216.284877] 4:2:2: usb_set_interface failed
[  216.293132] 4:2:2: usb_set_interface failed
[  216.301389] 4:2:2: usb_set_interface failed
[  216.339412] 4:2:2: usb_set_interface failed
[  216.343637] 4:2:2: usb_set_interface failed
[  216.347760] 4:2:2: usb_set_interface failed
[  216.356020] 4:2:2: usb_set_interface failed
[  216.364262] 4:2:2: usb_set_interface failed
[  216.402294] 4:2:2: usb_set_interface failed
[  216.406515] 4:2:2: usb_set_interface failed
[  216.410642] 4:2:2: usb_set_interface failed
[  216.418896] 4:2:2: usb_set_interface failed
[  216.427138] 4:2:2: usb_set_interface failed
[  216.465391] 4:2:2: usb_set_interface failed
[  216.469522] 4:2:2: usb_set_interface failed
[  216.473769] 4:2:2: usb_set_interface failed
[  216.478627] 4:2:2: usb_set_interface failed
[  216.486877] 4:2:2: usb_set_interface failed
[  216.529647] 4:2:2: usb_set_interface failed
[  216.533769] 4:2:2: usb_set_interface failed
[  216.537996] 4:2:2: usb_set_interface failed
[  216.546250] 4:2:2: usb_set_interface failed
[  216.554514] 4:2:2: usb_set_interface failed
[  216.705637] 4:2:2: usb_set_interface failed
[  216.713885] 4:2:2: usb_set_interface failed
[  216.722137] 4:2:2: usb_set_interface failed
[  216.730398] 4:2:2: usb_set_interface failed
[  216.738647] 4:2:2: usb_set_interface failed
[  216.763902] 4:2:2: usb_set_interface failed
[  216.768018] 4:2:2: usb_set_interface failed
[  216.772140] 4:2:2: usb_set_interface failed
[  216.780390] 4:2:2: usb_set_interface failed
[  216.788643] 4:2:2: usb_set_interface failed
[  216.826649] 4:2:2: usb_set_interface failed
[  216.830770] 4:2:2: usb_set_interface failed
[  216.835008] 4:2:2: usb_set_interface failed
[  216.843260] 4:2:2: usb_set_interface failed
[  216.851513] 4:2:2: usb_set_interface failed
[  216.889903] 4:2:2: usb_set_interface failed
[  216.894025] 4:2:2: usb_set_interface failed
[  216.898260] 4:2:2: usb_set_interface failed
[  216.906512] 4:2:2: usb_set_interface failed
[  216.914760] 4:2:2: usb_set_interface failed
[  216.953138] 4:2:2: usb_set_interface failed
[  216.957271] 4:2:2: usb_set_interface failed
[  216.965504] 4:2:2: usb_set_interface failed
[  216.973766] 4:2:2: usb_set_interface failed
[  216.982004] 4:2:2: usb_set_interface failed
[  217.015515] 4:2:2: usb_set_interface failed
[  217.019629] 4:2:2: usb_set_interface failed
[  217.027886] 4:2:2: usb_set_interface failed
[  217.036141] 4:2:2: usb_set_interface failed
[  217.044394] 4:2:2: usb_set_interface failed
[  217.077515] 4:2:2: usb_set_interface failed
[  217.081634] 4:2:2: usb_set_interface failed
[  217.085760] 4:2:2: usb_set_interface failed
[  217.094010] 4:2:2: usb_set_interface failed
[  217.102273] 4:2:2: usb_set_interface failed
[  217.141512] 4:2:2: usb_set_interface failed
[  217.145638] 4:2:2: usb_set_interface failed
[  217.153891] 4:2:2: usb_set_interface failed
[  217.162138] 4:2:2: usb_set_interface failed
[  217.170395] 4:2:2: usb_set_interface failed
[  217.205514] 4:2:2: usb_set_interface failed
[  217.209633] 4:2:2: usb_set_interface failed
[  217.217892] 4:2:2: usb_set_interface failed
[  217.226142] 4:2:2: usb_set_interface failed
[  217.234397] 4:2:2: usb_set_interface failed
[  217.268310] 4:2:2: usb_set_interface failed
[  217.272418] 4:2:2: usb_set_interface failed
[  217.276528] 4:2:2: usb_set_interface failed
[  217.284779] 4:2:2: usb_set_interface failed
[  217.293024] 4:2:2: usb_set_interface failed
[  217.331295] 4:2:2: usb_set_interface failed
[  217.335526] 4:2:2: usb_set_interface failed
[  217.339771] 4:2:2: usb_set_interface failed
[  217.344660] 4:2:2: usb_set_interface failed
[  217.352899] 4:2:2: usb_set_interface failed
[  217.395653] 4:2:2: usb_set_interface failed
[  217.399777] 4:2:2: usb_set_interface failed
[  217.404025] 4:2:2: usb_set_interface failed
[  217.408894] 4:2:2: usb_set_interface failed
[  217.417142] 4:2:2: usb_set_interface failed
[  217.623524] 4:2:2: usb_set_interface failed
[  217.627662] 4:2:2: usb_set_interface failed
[  217.631784] 4:2:2: usb_set_interface failed
[  217.636537] 4:2:2: usb_set_interface failed
[  217.641299] 4:2:2: usb_set_interface failed
[  217.646772] 4:2:2: usb_set_interface failed
[  217.650894] 4:2:2: usb_set_interface failed
[  217.655022] 4:2:2: usb_set_interface failed
[  217.659663] 4:2:2: usb_set_interface failed
[  217.664155] 4:2:2: usb_set_interface failed
[  217.669662] 4:2:2: usb_set_interface failed
[  217.673786] 4:2:2: usb_set_interface failed
[  217.678035] 4:2:2: usb_set_interface failed
[  217.682655] 4:2:2: usb_set_interface failed
[  217.687281] 4:2:2: usb_set_interface failed
[  217.693042] 4:2:2: usb_set_interface failed
[  217.697162] 4:2:2: usb_set_interface failed
[  217.701405] 4:2:2: usb_set_interface failed
[  217.706041] 4:2:2: usb_set_interface failed
[  217.710781] 4:2:2: usb_set_interface failed
[  217.715535] 4:2:2: usb_set_interface failed
[  217.719660] 4:2:2: usb_set_interface failed
[  217.723787] 4:2:2: usb_set_interface failed
[  217.728285] 4:2:2: usb_set_interface failed
[  217.732787] 4:2:2: usb_set_interface failed
[  217.737412] 4:2:2: usb_set_interface failed
[  217.741535] 4:2:2: usb_set_interface failed
[  217.745661] 4:2:2: usb_set_interface failed
[  217.750160] 4:2:2: usb_set_interface failed
[  217.754655] 4:2:2: usb_set_interface failed
[  217.759538] 4:2:2: usb_set_interface failed
[  217.763661] 4:2:2: usb_set_interface failed
[  217.767911] 4:2:2: usb_set_interface failed
[  217.772531] 4:2:2: usb_set_interface failed
[  217.777160] 4:2:2: usb_set_interface failed
[  217.782414] 4:2:2: usb_set_interface failed
[  217.786536] 4:2:2: usb_set_interface failed
[  217.790787] 4:2:2: usb_set_interface failed
[  217.795406] 4:2:2: usb_set_interface failed
[  217.800040] 4:2:2: usb_set_interface failed
[  217.805631] 4:2:2: usb_set_interface failed
[  217.809783] 4:2:2: usb_set_interface failed
[  217.813908] 4:2:2: usb_set_interface failed
[  217.818534] 4:2:2: usb_set_interface failed
[  217.823159] 4:2:2: usb_set_interface failed
[  217.828655] 4:2:2: usb_set_interface failed
[  217.832778] 4:2:2: usb_set_interface failed
[  217.836910] 4:2:2: usb_set_interface failed
[  217.841527] 4:2:2: usb_set_interface failed
[  217.846028] 4:2:2: usb_set_interface failed
[  217.851781] 4:2:2: usb_set_interface failed
[  217.855910] 4:2:2: usb_set_interface failed
[  217.860150] 4:2:2: usb_set_interface failed
[  217.864788] 4:2:2: usb_set_interface failed
[  217.869526] 4:2:2: usb_set_interface failed
[  217.875534] 4:2:2: usb_set_interface failed
[  217.879659] 4:2:2: usb_set_interface failed
[  217.883909] 4:2:2: usb_set_interface failed
[  217.888526] 4:2:2: usb_set_interface failed
[  217.893152] 4:2:2: usb_set_interface failed
[  217.928651] 4:2:2: usb_set_interface failed
[  217.932767] 4:2:2: usb_set_interface failed
[  217.936910] 4:2:2: usb_set_interface failed
[  217.941657] 4:2:2: usb_set_interface failed
[  217.947535] 4:2:2: usb_set_interface failed
[  217.952826] 4:2:2: usb_set_interface failed
[  217.956912] 4:2:2: usb_set_interface failed
[  217.961038] 4:2:2: usb_set_interface failed
[  217.965537] 4:2:2: usb_set_interface failed
[  217.970037] 4:2:2: usb_set_interface failed
[  217.975407] 4:2:2: usb_set_interface failed
[  217.979536] 4:2:2: usb_set_interface failed
[  217.983785] 4:2:2: usb_set_interface failed
[  217.988404] 4:2:2: usb_set_interface failed
[  217.993031] 4:2:2: usb_set_interface failed
[  217.998782] 4:2:2: usb_set_interface failed
[  218.002913] 4:2:2: usb_set_interface failed
[  218.007153] 4:2:2: usb_set_interface failed
[  218.011787] 4:2:2: usb_set_interface failed
[  218.016403] 4:2:2: usb_set_interface failed
[  218.022041] 4:2:2: usb_set_interface failed
[  218.026172] 4:2:2: usb_set_interface failed
[  218.030286] 4:2:2: usb_set_interface failed
[  218.034788] 4:2:2: usb_set_interface failed
[  218.039278] 4:2:2: usb_set_interface failed
[  218.043783] 4:2:2: usb_set_interface failed
[  218.047907] 4:2:2: usb_set_interface failed
[  218.052039] 4:2:2: usb_set_interface failed
[  218.056535] 4:2:2: usb_set_interface failed
[  218.061039] 4:2:2: usb_set_interface failed
[  218.065907] 4:2:2: usb_set_interface failed
[  218.070042] 4:2:2: usb_set_interface failed
[  218.074600] 4:2:2: usb_set_interface failed
[  218.079666] 4:2:2: usb_set_interface failed
[  218.085679] 4:2:2: usb_set_interface failed
[  218.090408] 4:2:2: usb_set_interface failed
[  218.094522] 4:2:2: usb_set_interface failed
[  218.098866] 4:2:2: usb_set_interface failed
[  218.103277] 4:2:2: usb_set_interface failed
[  218.107651] 4:2:2: usb_set_interface failed
[  218.112406] 4:2:2: usb_set_interface failed
[  218.116525] 4:2:2: usb_set_interface failed
[  218.120647] 4:2:2: usb_set_interface failed
[  218.125211] 4:2:2: usb_set_interface failed
[  218.130044] 4:2:2: usb_set_interface failed
[  218.135529] 4:2:2: usb_set_interface failed
[  218.139658] 4:2:2: usb_set_interface failed
[  218.143783] 4:2:2: usb_set_interface failed
[  218.148522] 4:2:2: usb_set_interface failed
[  218.152783] 4:2:2: usb_set_interface failed
[  218.157519] 4:2:2: usb_set_interface failed
[  218.161653] 4:2:2: usb_set_interface failed
[  218.165785] 4:2:2: usb_set_interface failed
[  218.170698] 4:2:2: usb_set_interface failed
[  218.175522] 4:2:2: usb_set_interface failed
[  218.180468] 4:2:2: usb_set_interface failed
[  218.184522] 4:2:2: usb_set_interface failed
[  218.188649] 4:2:2: usb_set_interface failed
[  218.193147] 4:2:2: usb_set_interface failed
[  218.197537] 4:2:2: usb_set_interface failed
[  218.227654] 4:2:2: usb_set_interface failed
[  218.231925] 4:2:2: usb_set_interface failed
[  218.236030] 4:2:2: usb_set_interface failed
[  218.240525] 4:2:2: usb_set_interface failed
[  218.244778] 4:2:2: usb_set_interface failed
[  218.249663] 4:2:2: usb_set_interface failed
[  218.254973] 4:2:2: usb_set_interface failed
[  218.259040] 4:2:2: usb_set_interface failed
[  218.263660] 4:2:2: usb_set_interface failed
[  218.268293] 4:2:2: usb_set_interface failed
[  218.272902] 4:2:2: usb_set_interface failed
[  218.277037] 4:2:2: usb_set_interface failed
[  218.281150] 4:2:2: usb_set_interface failed
[  218.285537] 4:2:2: usb_set_interface failed
[  218.290162] 4:2:2: usb_set_interface failed
[  218.296145] 4:2:2: usb_set_interface failed
[  218.300290] 4:2:2: usb_set_interface failed
[  218.304412] 4:2:2: usb_set_interface failed
[  218.308903] 4:2:2: usb_set_interface failed
[  218.313143] 4:2:2: usb_set_interface failed
[  218.317537] 4:2:2: usb_set_interface failed
[  218.321663] 4:2:2: usb_set_interface failed
[  218.325782] 4:2:2: usb_set_interface failed
[  218.330156] 4:2:2: usb_set_interface failed
[  218.334528] 4:2:2: usb_set_interface failed
[  218.338901] 4:2:2: usb_set_interface failed
[  218.343024] 4:2:2: usb_set_interface failed
[  218.347155] 4:2:2: usb_set_interface failed
[  218.351786] 4:2:2: usb_set_interface failed
[  218.356407] 4:2:2: usb_set_interface failed
[  218.360910] 4:2:2: usb_set_interface failed
[  218.365034] 4:2:2: usb_set_interface failed
[  218.369173] 4:2:2: usb_set_interface failed
[  218.373917] 4:2:2: usb_set_interface failed
[  218.378664] 4:2:2: usb_set_interface failed
[  218.384044] 4:2:2: usb_set_interface failed
[  218.388167] 4:2:2: usb_set_interface failed
[  218.392415] 4:2:2: usb_set_interface failed
[  218.397046] 4:2:2: usb_set_interface failed
[  218.401789] 4:2:2: usb_set_interface failed
[  218.407163] 4:2:2: usb_set_interface failed
[  218.411306] 4:2:2: usb_set_interface failed
[  218.415419] 4:2:2: usb_set_interface failed
[  218.419916] 4:2:2: usb_set_interface failed
[  218.424534] 4:2:2: usb_set_interface failed
[  218.429917] 4:2:2: usb_set_interface failed
[  218.434044] 4:2:2: usb_set_interface failed
[  218.438169] 4:2:2: usb_set_interface failed
[  218.442670] 4:2:2: usb_set_interface failed
[  218.447302] 4:2:2: usb_set_interface failed
[  218.452918] 4:2:2: usb_set_interface failed
[  218.457048] 4:2:2: usb_set_interface failed
[  218.461292] 4:2:2: usb_set_interface failed
[  218.465917] 4:2:2: usb_set_interface failed
[  218.470663] 4:2:2: usb_set_interface failed
[  218.476668] 4:2:2: usb_set_interface failed
[  218.480794] 4:2:2: usb_set_interface failed
[  218.485046] 4:2:2: usb_set_interface failed
[  218.489790] 4:2:2: usb_set_interface failed
[  218.494539] 4:2:2: usb_set_interface failed

--------------090205040607020000060209--
