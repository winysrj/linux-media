Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1AOPd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 10:33:28 -0500
Received: by wyb28 with SMTP id 28so3791131wyb.19
        for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 07:33:26 -0800 (PST)
From: Samir Benmendil <samir.benmendil@gmail.com>
Content-Type: multipart/mixed; boundary=Apple-Mail-6--1029177599
Subject: modprobe: FATAL: Error inserting cx88_dvb: No such device
Date: Sat, 15 Jan 2011 16:33:22 +0100
Message-Id: <A8DE80DD-AB4B-4AC6-A779-4249E6B4AB70@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--Apple-Mail-6--1029177599
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello,=20

I can't seem to get my Hauppauge HVR-4000 card to work. I tried several =
combination of driver and firmware listed here and the current head from =
git:
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000

I can remember that the card worked with the same PC about a year ago. =
Unfortunately I can't remember what kernel/driver/firmware combination I =
was using.

The problem is that the cx88-dvb module cannot be loaded.
$ sudo modprobe cb88-dvb
FATAL: Error inserting cx88_dvb =
(/lib/modules/2.6.35-22-server/kernel/drivers/media/video/cx88/cx88-dvb.ko=
): No such device

Any help would be highly appreciated. I'm trying for several month to =
get this working.

Regards,
Samir

$ uname -a
Linux tardis 2.6.35-22-server #34~lucid1-Ubuntu SMP Mon Oct 11 14:51:09 =
UTC 2010 x86_64 GNU/Linux
(I have also been trying with 2.6.32-27-server and .6.35-22-generic)

$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 10.04.1 LTS
Release:	10.04
Codename:	lucid


--Apple-Mail-6--1029177599
Content-Disposition: attachment;
	filename=dmesg.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-22-server (buildd@allspice) (gcc =
version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #34~lucid1-Ubuntu SMP Mon Oct 11 =
14:51:09 UTC 2010 (Ubuntu 2.6.35-22.34~lucid1-server 2.6.35.4)
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.35-22-server =
root=3DUUID=3Dde7aad54-4b74-4467-bd96-b5e8d0d62ebd ro quiet =
radeon.modeset=3D1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 =
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000006fee0000 (usable)
[    0.000000]  BIOS-e820: 000000006fee0000 - 000000006fee3000 (ACPI =
NVS)
[    0.000000]  BIOS-e820: 000000006fee3000 - 000000006fef0000 (ACPI =
data)
[    0.000000]  BIOS-e820: 000000006fef0000 - 000000006ff00000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 =
(reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 =
(usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 =
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0x6fee0 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
[    0.000000]   1 base 000040000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 000060000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 00006FF00000 mask FFFFFFF00000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new =
0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 =
(usable) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000006fee0000 (usable)
[    0.000000]  modified: 000000006fee0000 - 000000006fee3000 (ACPI NVS)
[    0.000000]  modified: 000000006fee3000 - 000000006fef0000 (ACPI =
data)
[    0.000000]  modified: 000000006fef0000 - 000000006ff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000f5c30] f5c30
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-000000006fee0000
[    0.000000]  0000000000 - 0040000000 page 1G
[    0.000000]  0040000000 - 006fe00000 page 2M
[    0.000000]  006fe00000 - 006fee0000 page 4k
[    0.000000] kernel direct mapping tables up to 6fee0000 @ 16000-19000
[    0.000000] RAMDISK: 37746000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f75d0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 000000006fee3000 0003C (v01 GBT    GBTUACPI =
42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 000000006fee3040 00074 (v01 GBT    GBTUACPI =
42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 000000006fee30c0 0705A (v01 GBT    GBTUACPI =
00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 000000006fee0000 00040
[    0.000000] ACPI: SSDT 000000006feea200 0095E (v01 PTLTD  POWERNOW =
00000001  LTP 00000001)
[    0.000000] ACPI: HPET 000000006feeab80 00038 (v01 GBT    GBTUACPI =
42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 000000006feeabc0 0003C (v01 GBT    GBTUACPI =
42302E31 GBTU 01010101)
[    0.000000] ACPI: TAMG 000000006feeac00 0030A (v01 GBT    GBT   B0 =
5455312E BG?? 53450101)
[    0.000000] ACPI: APIC 000000006feea140 00084 (v01 GBT    GBTUACPI =
42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000006fee0000
[    0.000000] Initmem setup node 0 0000000000000000-000000006fee0000
[    0.000000]   NODE_DATA [0000000001d1b140 - 0000000001d2013f]
[    0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> =
[ffff880002600000-ffff880003ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0006fee0
[    0.000000] On node 0 totalpages: 458351
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6213 pages used for memmap
[    0.000000]   DMA32 zone: 448155 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low =
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18160 - 1895f]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - =
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - =
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - =
0000000000100000
[    0.000000] Allocating PCI resources starting at 6ff00000 (gap: =
6ff00000:70100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 =
nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 =
r8192 d23168 u524288
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  =
Total pages: 452082
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: =
BOOT_IMAGE=3D/boot/vmlinuz-2.6.35-22-server =
root=3DUUID=3Dde7aad54-4b74-4467-bd96-b5e8d0d62ebd ro quiet =
radeon.modeset=3D1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ fc0c000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Subtract (48 early reservations)
[    0.000000]   #1 [0001000000 - 0001d1a6d4]   TEXT DATA BSS
[    0.000000]   #2 [0037746000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d1b000 - 0001d1b106]             BRK
[    0.000000]   #4 [00000f5c40 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000f5c30 - 00000f5c40]    MP-table mpf
[    0.000000]   #6 [000009f800 - 00000f1100]   BIOS reserved
[    0.000000]   #7 [00000f127c - 00000f5c30]   BIOS reserved
[    0.000000]   #8 [00000f1100 - 00000f127c]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0001d1b140 - 0001d20140]       NODE_DATA
[    0.000000]   #13 [0001d20140 - 0001d21140]         BOOTMEM
[    0.000000]   #14 [0000018000 - 0000018150]         BOOTMEM
[    0.000000]   #15 [0002522000 - 0002523000]         BOOTMEM
[    0.000000]   #16 [0002523000 - 0002524000]         BOOTMEM
[    0.000000]   #17 [0002600000 - 0004000000]        MEMMAP 0
[    0.000000]   #18 [0001d21140 - 0001d39140]         BOOTMEM
[    0.000000]   #19 [0001d39140 - 0001d51140]         BOOTMEM
[    0.000000]   #20 [0001d52000 - 0001d53000]         BOOTMEM
[    0.000000]   #21 [0001d1a700 - 0001d1a741]         BOOTMEM
[    0.000000]   #22 [0001d1a780 - 0001d1a7c3]         BOOTMEM
[    0.000000]   #23 [0001d1a800 - 0001d1aa30]         BOOTMEM
[    0.000000]   #24 [0001d1aa40 - 0001d1aaa8]         BOOTMEM
[    0.000000]   #25 [0001d1aac0 - 0001d1ab28]         BOOTMEM
[    0.000000]   #26 [0001d1ab40 - 0001d1aba8]         BOOTMEM
[    0.000000]   #27 [0001d1abc0 - 0001d1ac28]         BOOTMEM
[    0.000000]   #28 [0001d1ac40 - 0001d1aca8]         BOOTMEM
[    0.000000]   #29 [0001d1acc0 - 0001d1ad28]         BOOTMEM
[    0.000000]   #30 [0001d1ad40 - 0001d1ada8]         BOOTMEM
[    0.000000]   #31 [0001d1adc0 - 0001d1ae28]         BOOTMEM
[    0.000000]   #32 [0001d1ae40 - 0001d1aea8]         BOOTMEM
[    0.000000]   #33 [0001d1aec0 - 0001d1aee0]         BOOTMEM
[    0.000000]   #34 [0001d1af00 - 0001d1af73]         BOOTMEM
[    0.000000]   #35 [0001d1af80 - 0001d1aff3]         BOOTMEM
[    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #37 [0001e80000 - 0001e9e000]         BOOTMEM
[    0.000000]   #38 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #39 [0001f80000 - 0001f9e000]         BOOTMEM
[    0.000000]   #40 [0001d51140 - 0001d51148]         BOOTMEM
[    0.000000]   #41 [0001d51180 - 0001d51188]         BOOTMEM
[    0.000000]   #42 [0001d511c0 - 0001d511d0]         BOOTMEM
[    0.000000]   #43 [0001d51200 - 0001d51220]         BOOTMEM
[    0.000000]   #44 [0001d51240 - 0001d51370]         BOOTMEM
[    0.000000]   #45 [0001d51380 - 0001d513d0]         BOOTMEM
[    0.000000]   #46 [0001d51400 - 0001d51450]         BOOTMEM
[    0.000000]   #47 [0001d53000 - 0001d5b000]         BOOTMEM
[    0.000000] Memory: 1783708k/1833856k available (5794k kernel code, =
452k absent, 49696k reserved, 5388k data, 828k init)
[    0.000000] SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, =
MinObjects=3D0, CPUs=3D4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 18350080 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't =
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2711.423 MHz processor.
[    0.020005] Calibrating delay loop (skipped), value calculated using =
timer frequency.. 5422.83 BogoMIPS (lpj=3D27114190)
[    0.020009] pid_max: default: 32768 minimum: 301
[    0.020026] Security Framework initialized
[    0.020041] AppArmor: AppArmor initialized
[    0.020042] Yama: becoming mindful.
[    0.020242] Dentry cache hash table entries: 262144 (order: 9, =
2097152 bytes)
[    0.020984] Inode-cache hash table entries: 131072 (order: 8, 1048576 =
bytes)
[    0.021327] Mount-cache hash table entries: 256
[    0.021424] Initializing cgroup subsys ns
[    0.021427] Initializing cgroup subsys cpuacct
[    0.021431] Initializing cgroup subsys memory
[    0.021437] Initializing cgroup subsys devices
[    0.021439] Initializing cgroup subsys freezer
[    0.021441] Initializing cgroup subsys net_cls
[    0.021461] tseg: 006ff00000
[    0.021462] CPU: Physical Processor ID: 0
[    0.021464] CPU: Processor Core ID: 0
[    0.021465] mce: CPU supports 6 MCE banks
[    0.021473] Performance Events: AMD PMU driver.
[    0.021477] ... version:                0
[    0.021478] ... bit width:              48
[    0.021479] ... generic registers:      4
[    0.021481] ... value mask:             0000ffffffffffff
[    0.021482] ... max period:             00007fffffffffff
[    0.021483] ... fixed-purpose events:   0
[    0.021485] ... event mask:             000000000000000f
[    0.030247] ACPI: Core revision 20100428
[    0.040018] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040026] ftrace: allocating 22982 entries in 91 pages
[    0.050070] Setting APIC routing to flat
[    0.050551] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 =
pin2=3D-1
[    0.151180] CPU0: AMD Athlon(tm) II X2 235e Processor stepping 02
[    0.160000] Booting Node   0, Processors  #1
[    0.320007] Brought up 2 CPUs
[    0.320009] Total of 2 processors activated (10846.41 BogoMIPS).
[    0.320249] devtmpfs: initialized
[    0.322101] regulator: core version 0.5
[    0.322101] Time: 15:17:06  Date: 01/15/11
[    0.322101] NET: Registered protocol family 16
[    0.322101] node 0 link 0: io port [c000, ffff]
[    0.322101] TOM: 0000000080000000 aka 2048M
[    0.322101] Fam 10h mmconf [e0000000, e00fffff]
[    0.322101] node 0 link 0: mmio [a0000, bffff]
[    0.322101] node 0 link 0: mmio [80000000, dfffffff]
[    0.322101] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.322101] node 0 link 0: mmio [e0000000, e03fffff] =3D=3D> =
[e0100000, e03fffff]
[    0.322101] bus: [00, 03] on node 0 link 0
[    0.322101] bus: 00 index 0 [io  0x0000-0xffff]
[    0.322101] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.322101] bus: 00 index 2 [mem 0x80000000-0xdfffffff]
[    0.322101] bus: 00 index 3 [mem 0xe0400000-0xfcffffffff]
[    0.322101] bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
[    0.322101] ACPI: bus type pci registered
[    0.322101] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem =
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.322101] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in =
E820
[    0.337447] PCI: Using configuration type 1 for base access
[    0.337974] Trying to unpack rootfs image as initramfs...
[    0.337995] bio: create slab <bio-0> at 0
[    0.338673] ACPI: EC: Look up EC in DSDT
[    0.344411] ACPI: Interpreter enabled
[    0.344413] ACPI: (supports S0 S3 S4 S5)
[    0.344430] ACPI: Using IOAPIC for interrupt routing
[    0.348114] ACPI: No dock devices found.
[    0.348116] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
[    0.348212] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.348394] pci_root PNP0A03:00: host bridge window [io  =
0x0000-0x0cf7]
[    0.348396] pci_root PNP0A03:00: host bridge window [io  =
0x0d00-0xffff]
[    0.348399] pci_root PNP0A03:00: host bridge window [mem =
0x000a0000-0x000bffff]
[    0.348401] pci_root PNP0A03:00: host bridge window [mem =
0x000c0000-0x000dffff]
[    0.348403] pci_root PNP0A03:00: host bridge window [mem =
0x80000000-0xfebfffff]
[    0.348421] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff =
64bit]
[    0.348496] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.348499] pci 0000:00:0a.0: PME# disabled
[    0.348543] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.348549] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.348555] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.348561] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.348567] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.348573] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.348589] pci 0000:00:11.0: set SATA to AHCI mode
[    0.348635] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.348684] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.348744] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.348791] pci 0000:00:12.2: supports D1 D2
[    0.348793] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.348796] pci 0000:00:12.2: PME# disabled
[    0.348824] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.348872] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.348932] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.348979] pci 0000:00:13.2: supports D1 D2
[    0.348981] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.348984] pci 0000:00:13.2: PME# disabled
[    0.349084] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.349089] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.349095] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.349101] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.349107] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.349162] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff =
64bit]
[    0.349202] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.349205] pci 0000:00:14.2: PME# disabled
[    0.349298] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.349425] pci 0000:01:05.0: reg 10: [mem 0xd0000000-0xdfffffff =
pref]
[    0.349428] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
[    0.349431] pci 0000:01:05.0: reg 18: [mem 0xfdfe0000-0xfdfeffff]
[    0.349436] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.349446] pci 0000:01:05.0: supports D1 D2
[    0.349459] pci 0000:01:05.1: reg 10: [mem 0xfdffc000-0xfdffffff]
[    0.349475] pci 0000:01:05.1: supports D1 D2
[    0.349509] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.349512] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.349515] pci 0000:00:01.0:   bridge window [mem =
0xfde00000-0xfdffffff]
[    0.349518] pci 0000:00:01.0:   bridge window [mem =
0xd0000000-0xdfffffff 64bit pref]
[    0.349558] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.349571] pci 0000:02:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff =
64bit pref]
[    0.349581] pci 0000:02:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff =
64bit pref]
[    0.349587] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff =
pref]
[    0.349613] pci 0000:02:00.0: supports D1 D2
[    0.349615] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot =
D3cold
[    0.349618] pci 0000:02:00.0: PME# disabled
[    0.360026] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.360031] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.360034] pci 0000:00:0a.0:   bridge window [mem =
0xfdd00000-0xfddfffff]
[    0.360037] pci 0000:00:0a.0:   bridge window [mem =
0xfdb00000-0xfdbfffff 64bit pref]
[    0.360096] pci 0000:03:07.0: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.360196] pci 0000:03:07.1: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.360284] pci 0000:03:07.2: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.360378] pci 0000:03:07.4: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.360480] pci 0000:03:0e.0: reg 10: [mem 0xfcfff000-0xfcfff7ff]
[    0.360488] pci 0000:03:0e.0: reg 14: [mem 0xfcff8000-0xfcffbfff]
[    0.360542] pci 0000:03:0e.0: supports D1 D2
[    0.360544] pci 0000:03:0e.0: PME# supported from D0 D1 D2 D3hot
[    0.360548] pci 0000:03:0e.0: PME# disabled
[    0.360581] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive =
decode)
[    0.360584] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.360588] pci 0000:00:14.4:   bridge window [mem =
0xf8000000-0xfcffffff]
[    0.360592] pci 0000:00:14.4:   bridge window [mem =
0xfdc00000-0xfdcfffff pref]
[    0.360594] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] =
(subtractive decode)
[    0.360596] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] =
(subtractive decode)
[    0.360597] pci 0000:00:14.4:   bridge window [mem =
0x000a0000-0x000bffff] (subtractive decode)
[    0.360599] pci 0000:00:14.4:   bridge window [mem =
0x000c0000-0x000dffff] (subtractive decode)
[    0.360601] pci 0000:00:14.4:   bridge window [mem =
0x80000000-0xfebfffff] (subtractive decode)
[    0.360618] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.360838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.360916] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.360959] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.374062] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374137] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374208] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374279] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374349] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374419] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374489] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374561] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) =
*0, disabled.
[    0.374591] HEST: Table is not found!
[    0.374652] vgaarb: device added: =
PCI:0000:01:05.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.374655] vgaarb: loaded
[    0.374749] SCSI subsystem initialized
[    0.374804] libata version 3.00 loaded.
[    0.374834] usbcore: registered new interface driver usbfs
[    0.374843] usbcore: registered new interface driver hub
[    0.374859] usbcore: registered new device driver usb
[    0.374992] ACPI: WMI: Mapper loaded
[    0.374993] PCI: Using ACPI for IRQ routing
[    0.374995] PCI: pci_cache_line_size set to 64 bytes
[    0.375001] pci 0000:00:00.0: no compatible bridge window for [mem =
0xe0000000-0xffffffff 64bit]
[    0.375082] reserve RAM buffer: 000000000009f800 - 000000000009ffff=20=

[    0.375084] reserve RAM buffer: 000000006fee0000 - 000000006fffffff=20=

[    0.375143] NetLabel: Initializing
[    0.375145] NetLabel:  domain hash size =3D 128
[    0.375146] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.375155] NetLabel:  unlabeled traffic allowed by default
[    0.375179] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.375183] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.377215] Switching to clocksource tsc
[    0.379987] AppArmor: AppArmor Filesystem Enabled
[    0.379987] pnp: PnP ACPI init
[    0.379987] ACPI: bus type pnp registered
[    0.379987] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] =
because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:02: disabling [mem 0x00000000-0x00000fff window =
disabled] because it overlaps 0000:02:00.0 BAR 6 [mem =
0x00000000-0x0000ffff pref]
[    0.379987] pnp 00:0a: disabling [mem 0x000cea00-0x000cffff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:0a: disabling [mem 0x000f0000-0x000f7fff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:0a: disabling [mem 0x000f8000-0x000fbfff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:0a: disabling [mem 0x000fc000-0x000fffff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp 00:0a: disabling [mem 0x00100000-0x6fedffff] because =
it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.379987] pnp: PnP ACPI: found 11 devices
[    0.379987] ACPI: ACPI bus type pnp unregistered
[    0.379987] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.379987] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.379987] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.379987] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.379987] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.379987] system 00:02: [io  0x040b] has been reserved
[    0.379987] system 00:02: [io  0x04d6] has been reserved
[    0.379987] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.379987] system 00:02: [io  0x0c14] has been reserved
[    0.379987] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.379987] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.379987] system 00:02: [io  0x0c6f] has been reserved
[    0.379987] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.379987] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.379987] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.379987] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.379987] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.379987] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.379987] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.379987] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.379987] system 00:02: [mem 0xfee00400-0xfee00fff window] has been =
reserved
[    0.379987] system 00:09: [mem 0xe0000000-0xefffffff] has been =
reserved
[    0.379987] system 00:0a: [mem 0x6fee0000-0x6fefffff] could not be =
reserved
[    0.379987] system 00:0a: [mem 0xffff0000-0xffffffff] has been =
reserved
[    0.379987] system 00:0a: [mem 0x6fff0000-0x7ffeffff] could not be =
reserved
[    0.379987] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be =
reserved
[    0.379987] system 00:0a: [mem 0xfee00000-0xfee00fff] could not be =
reserved
[    0.379987] system 00:0a: [mem 0xfff80000-0xfffeffff] has been =
reserved
[    0.383164] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.383167] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.383169] pci 0000:00:01.0:   bridge window [mem =
0xfde00000-0xfdffffff]
[    0.383172] pci 0000:00:01.0:   bridge window [mem =
0xd0000000-0xdfffffff 64bit pref]
[    0.383176] pci 0000:02:00.0: BAR 6: assigned [mem =
0xfdb00000-0xfdb0ffff pref]
[    0.383178] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.383180] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.383183] pci 0000:00:0a.0:   bridge window [mem =
0xfdd00000-0xfddfffff]
[    0.383185] pci 0000:00:0a.0:   bridge window [mem =
0xfdb00000-0xfdbfffff 64bit pref]
[    0.383189] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.383191] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.383196] pci 0000:00:14.4:   bridge window [mem =
0xf8000000-0xfcffffff]
[    0.383199] pci 0000:00:14.4:   bridge window [mem =
0xfdc00000-0xfdcfffff pref]
[    0.383214]   alloc irq_desc for 18 on node 0
[    0.383216]   alloc kstat_irqs on node 0
[    0.383225] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18
[    0.383227] pci 0000:00:0a.0: setting latency timer to 64
[    0.383233] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.383235] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.383237] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.383239] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.383240] pci_bus 0000:00: resource 8 [mem 0x80000000-0xfebfffff]
[    0.383242] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.383244] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    0.383245] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff =
64bit pref]
[    0.383247] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.383249] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.383251] pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff =
64bit pref]
[    0.383253] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.383254] pci_bus 0000:03: resource 1 [mem 0xf8000000-0xfcffffff]
[    0.383256] pci_bus 0000:03: resource 2 [mem 0xfdc00000-0xfdcfffff =
pref]
[    0.383257] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.383259] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.383261] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.383262] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.383264] pci_bus 0000:03: resource 8 [mem 0x80000000-0xfebfffff]
[    0.383290] NET: Registered protocol family 2
[    0.383376] IP route cache hash table entries: 65536 (order: 7, =
524288 bytes)
[    0.383941] TCP established hash table entries: 262144 (order: 10, =
4194304 bytes)
[    0.385454] TCP bind hash table entries: 65536 (order: 8, 1048576 =
bytes)
[    0.385832] TCP: Hash tables configured (established 262144 bind =
65536)
[    0.385835] TCP reno registered
[    0.385843] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.385861] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.385949] NET: Registered protocol family 1
[    0.385964] pci 0000:00:01.0: MSI quirk detected; subordinate MSI =
disabled
[    0.532597] pci 0000:01:05.0: Boot video device
[    0.532615] PCI: CLS 4 bytes, default 64
[    0.551687] Freeing initrd memory: 8872k freed
[    0.555720] Scanning for low memory corruption every 60 seconds
[    0.555798] audit: initializing netlink socket (disabled)
[    0.555806] type=3D2000 audit(1295104626.550:1): initialized
[    0.566033] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.566990] VFS: Disk quotas dquot_6.5.2
[    0.567035] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.567465] fuse init (API version 7.14)
[    0.567586] msgmni has been set to 3501
[    0.569239] Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 253)
[    0.569241] io scheduler noop registered
[    0.569243] io scheduler deadline registered (default)
[    0.569267] io scheduler cfq registered
[    0.569424] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.569444]   alloc irq_desc for 40 on node 0
[    0.569445]   alloc kstat_irqs on node 0
[    0.569452] pcieport 0000:00:0a.0: irq 40 for MSI/MSI-X
[    0.569602] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.569621] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.569745] input: Power Button as =
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.569750] ACPI: Power Button [PWRB]
[    0.569783] input: Power Button as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.569785] ACPI: Power Button [PWRF]
[    0.569975] ACPI: acpi_idle registered with cpuidle
[    0.571385] ERST: Table is not found!
[    0.571529] Linux agpgart interface v0.103
[    0.571532] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.571630] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.571867] 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.572532] brd: module loaded
[    0.572854] loop: module loaded
[    0.573067]   alloc irq_desc for 16 on node 0
[    0.573070]   alloc kstat_irqs on node 0
[    0.573079] pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    0.573375] Fixed MDIO Bus: probed
[    0.573395] PPP generic driver version 2.4.2
[    0.573427] tun: Universal TUN/TAP device driver, 1.6
[    0.573428] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.573489] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) =
Driver
[    0.573553]   alloc irq_desc for 17 on node 0
[    0.573556]   alloc kstat_irqs on node 0
[    0.573568] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) =
-> IRQ 17
[    0.573585] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.573707] ehci_hcd 0000:00:12.2: new USB bus registered, assigned =
bus number 1
[    0.573734] ehci_hcd 0000:00:12.2: debug port 1
[    0.573760] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    0.592562] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.592670] hub 1-0:1.0: USB hub found
[    0.592673] hub 1-0:1.0: 6 ports detected
[    0.592797]   alloc irq_desc for 19 on node 0
[    0.592799]   alloc kstat_irqs on node 0
[    0.592808] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) =
-> IRQ 19
[    0.592824] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.592851] ehci_hcd 0000:00:13.2: new USB bus registered, assigned =
bus number 2
[    0.592875] ehci_hcd 0000:00:13.2: debug port 1
[    0.592902] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    0.612545] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.612664] hub 2-0:1.0: USB hub found
[    0.612668] hub 2-0:1.0: 6 ports detected
[    0.612764] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.612821] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    0.612838] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.612870] ohci_hcd 0000:00:12.0: new USB bus registered, assigned =
bus number 3
[    0.612902] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    0.676666] hub 3-0:1.0: USB hub found
[    0.676673] hub 3-0:1.0: 3 ports detected
[    0.676794] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    0.676810] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.676838] ohci_hcd 0000:00:12.1: new USB bus registered, assigned =
bus number 4
[    0.676857] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    0.736671] hub 4-0:1.0: USB hub found
[    0.736678] hub 4-0:1.0: 3 ports detected
[    0.736801] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) =
-> IRQ 18
[    0.736818] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.736845] ohci_hcd 0000:00:13.0: new USB bus registered, assigned =
bus number 5
[    0.736877] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    0.796693] hub 5-0:1.0: USB hub found
[    0.796699] hub 5-0:1.0: 3 ports detected
[    0.796821] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) =
-> IRQ 18
[    0.796837] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.796864] ohci_hcd 0000:00:13.1: new USB bus registered, assigned =
bus number 6
[    0.796880] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    0.856693] hub 6-0:1.0: USB hub found
[    0.856700] hub 6-0:1.0: 3 ports detected
[    0.856824] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) =
-> IRQ 18
[    0.856842] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.856869] ohci_hcd 0000:00:14.5: new USB bus registered, assigned =
bus number 7
[    0.856886] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    0.916698] hub 7-0:1.0: USB hub found
[    0.916704] hub 7-0:1.0: 2 ports detected
[    0.916796] uhci_hcd: USB Universal Host Controller Interface driver
[    0.916884] PNP: No PS/2 controller found. Probing ports directly.
[    0.950919] Failed to disable AUX port, but continuing anyway... Is =
this a SiS?
[    0.950921] If AUX port is really absent please use the 'i8042.noaux' =
option.
[    1.200054] usb 3-1: new low speed USB device using ohci_hcd and =
address 2
[    1.200147] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.200242] mice: PS/2 mouse device common for all mice
[    1.200322] rtc_cmos 00:05: RTC can wake from S4
[    1.200348] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.200379] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.200453] device-mapper: uevent: version 1.0.3
[    1.200527] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) =
initialised: dm-devel@redhat.com
[    1.200601] device-mapper: multipath: version 1.1.1 loaded
[    1.200604] device-mapper: multipath round-robin: version 1.0.0 =
loaded
[    1.200779] cpuidle: using governor ladder
[    1.200781] cpuidle: using governor menu
[    1.200965] TCP cubic registered
[    1.201047] NET: Registered protocol family 10
[    1.201291] lo: Disabled Privacy Extensions
[    1.201424] NET: Registered protocol family 17
[    1.201457] powernow-k8: Found 1 AMD Athlon(tm) II X2 235e Processor =
(2 cpu cores) (version 2.20.00)
[    1.201490] powernow-k8:    0 : pstate 0 (2700 MHz)
[    1.201492] powernow-k8:    1 : pstate 1 (1900 MHz)
[    1.201493] powernow-k8:    2 : pstate 2 (1500 MHz)
[    1.201494] powernow-k8:    3 : pstate 3 (800 MHz)
[    1.201738] PM: Resume from disk failed.
[    1.201747] registered taskstats version 1
[    1.201974]   Magic number: 11:405:285
[    1.202007] acpi PNP0C04:00: hash matches
[    1.202047] rtc_cmos 00:05: setting system clock to 2011-01-15 =
15:17:07 UTC (1295104627)
[    1.202049] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.202050] EDD information not available.
[    1.202110] Freeing unused kernel memory: 828k freed
[    1.202273] Write protecting the kernel read-only data: 10240k
[    1.202391] Freeing unused kernel memory: 328k freed
[    1.202583] Freeing unused kernel memory: 1608k freed
[    1.219322] udev: starting version 151
[    1.280302] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.280320] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> =
IRQ 18
[    1.280352] r8169 0000:02:00.0: setting latency timer to 64
[    1.280382]   alloc irq_desc for 41 on node 0
[    1.280383]   alloc kstat_irqs on node 0
[    1.280393] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    1.280724] r8169 0000:02:00.0: eth0: RTL8168c/8111c at =
0xffffc9000037c000, 00:24:1d:cc:82:02, XID 1c4000c0 IRQ 41
[    1.287900] md: linear personality registered for level -1
[    1.305397] scsi0 : pata_atiixp
[    1.306441]   alloc irq_desc for 22 on node 0
[    1.306444]   alloc kstat_irqs on node 0
[    1.306455] ohci1394 0000:03:0e.0: PCI INT A -> GSI 22 (level, low) =
-> IRQ 22
[    1.307285] md: multipath personality registered for level -4
[    1.307945] scsi1 : pata_atiixp
[    1.308723] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 =
irq 14
[    1.308726] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 =
irq 15
[    1.309246] ahci 0000:00:11.0: version 3.0
[    1.309274] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[    1.309357]   alloc irq_desc for 42 on node 0
[    1.309358]   alloc kstat_irqs on node 0
[    1.309368] ahci 0000:00:11.0: irq 42 for MSI/MSI-X
[    1.309446] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps =
0xf impl SATA mode
[    1.309449] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo =
pmp pio slum part ccc=20
[    1.309721] scsi2 : ahci
[    1.309824] scsi3 : ahci
[    1.309879] scsi4 : ahci
[    1.309932] scsi5 : ahci
[    1.310079] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port =
0xfe02f100 irq 42
[    1.310082] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port =
0xfe02f180 irq 42
[    1.310085] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port =
0xfe02f200 irq 42
[    1.310087] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port =
0xfe02f280 irq 42
[    1.311473] md: raid0 personality registered for level 0
[    1.370082] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[22]  =
MMIO=3D[fcfff000-fcfff7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
[    1.464249] usbcore: registered new interface driver hiddev
[    1.464317] usbcore: registered new interface driver usbhid
[    1.464319] usbhid: USB HID core driver
[    1.490483] ata1.01: ATAPI: AOPEN   DVD1648/AAP PRO, 1.02, max =
UDMA/33
[    1.512063] ata1.01: configured for UDMA/33
[    1.531029] scsi 0:0:1:0: CD-ROM            AOPEN    DVD1648/AAP PRO  =
1.02 PQ: 0 ANSI: 5
[    1.531178] ata2.00: ATA-8: WDC WD15EADS-00S2B0, 01.00A01, max =
UDMA/133
[    1.531182] ata2.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth =
0/32)
[    1.531366] ata2.01: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max =
UDMA/133
[    1.531370] ata2.01: 2930277168 sectors, multi 16: LBA48 NCQ (depth =
0/32)
[    1.552143] ata2.00: configured for UDMA/100
[    1.570552] ata2.01: configured for UDMA/100
[    1.571847] sr0: scsi3-mmc drive: 0x/48x cd/rw xa/form2 cdda tray
[    1.571851] Uniform CD-ROM driver Revision: 3.20
[    1.571947] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    1.571995] sr 0:0:1:0: Attached scsi generic sg0 type 5
[    1.572130] scsi 1:0:0:0: Direct-Access     ATA      WDC WD15EADS-00S =
01.0 PQ: 0 ANSI: 5
[    1.572222] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.572292] scsi 1:0:1:0: Direct-Access     ATA      WDC WD15EADS-00P =
01.0 PQ: 0 ANSI: 5
[    1.572371] sd 1:0:1:0: Attached scsi generic sg2 type 0
[    1.572419] sd 1:0:0:0: [sda] 2930277168 512-byte logical blocks: =
(1.50 TB/1.36 TiB)
[    1.572422] sd 1:0:1:0: [sdb] 2930277168 512-byte logical blocks: =
(1.50 TB/1.36 TiB)
[    1.572485] sd 1:0:0:0: [sda] Write Protect is off
[    1.572487] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.572491] sd 1:0:1:0: [sdb] Write Protect is off
[    1.572494] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.572515] sd 1:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    1.572518] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    1.572629]  sda: sda1
[    1.589871]  sdb: sdb1
[    1.601301] sd 1:0:1:0: [sdb] Attached SCSI disk
[    1.601410] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.650049] ata6: SATA link down (SStatus 0 SControl 300)
[    1.830055] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.836467] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01109, max UDMA7
[    1.836470] ata4.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth =
31/32), AA
[    1.841293] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.842977] ata4.00: configured for UDMA/133
[    1.843007] ata5.00: ATA-8: WDC WD15EADS-00S2B0, 01.00A01, max =
UDMA/133
[    1.843009] ata5.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth =
31/32), AA
[    1.845437] ata5.00: configured for UDMA/133
[    1.950052] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.953818] ata3.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
[    1.953821] ata3.00: 390721968 sectors, multi 16: LBA48=20
[    1.957702] ata3.00: configured for UDMA/133
[    1.970157] scsi 2:0:0:0: Direct-Access     ATA      ST3200822AS      =
3.01 PQ: 0 ANSI: 5
[    1.970293] sd 2:0:0:0: Attached scsi generic sg3 type 0
[    1.970296] sd 2:0:0:0: [sdc] 390721968 512-byte logical blocks: (200 =
GB/186 GiB)
[    1.970371] sd 2:0:0:0: [sdc] Write Protect is off
[    1.970374] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  =
1AA0 PQ: 0 ANSI: 5
[    1.970377] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.970414] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    1.970461] sd 3:0:0:0: Attached scsi generic sg4 type 0
[    1.970527] scsi 4:0:0:0: Direct-Access     ATA      WDC WD15EADS-00S =
01.0 PQ: 0 ANSI: 5
[    1.970595] sd 4:0:0:0: Attached scsi generic sg5 type 0
[    1.970651] sd 4:0:0:0: [sde] 2930277168 512-byte logical blocks: =
(1.50 TB/1.36 TiB)
[    1.970670]  sdc:
[    1.970684] sd 3:0:0:0: [sdd] 1465149168 512-byte logical blocks: =
(750 GB/698 GiB)
[    1.970707] sd 4:0:0:0: [sde] Write Protect is off
[    1.970709] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.970726] sd 4:0:0:0: [sde] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    1.970728] sd 3:0:0:0: [sdd] Write Protect is off
[    1.970730] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.970743] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    1.970824]  sde:
[    1.970861]  sdd: sdd1
[    1.973843] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.981458]  sdc1 sdc2 sdc3 sdc4
[    1.985992]  sde1
[    1.986187] sd 4:0:0:0: [sde] Attached SCSI disk
[    1.993574] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.002180] md: raid1 personality registered for level 1
[    2.003056] input: Logitech USB Receiver as =
/devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input2
[    2.003124] logitech 0003:046D:C512.0001: input,hidraw0: USB HID =
v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.0-1/input0
[    2.007566] async_tx: api initialized (async)
[    2.011175] input: Logitech USB Receiver as =
/devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.1/input/input3
[    2.011316] logitech 0003:046D:C512.0002: input,hidraw1: USB HID =
v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-1/input1
[    2.171270] raid6: int64x1   2336 MB/s
[    2.341279] raid6: int64x2   3199 MB/s
[    2.511284] raid6: int64x4   2426 MB/s
[    2.681287] raid6: int64x8   2118 MB/s
[    2.851272] raid6: sse2x1    3889 MB/s
[    3.021261] raid6: sse2x2    6133 MB/s
[    3.191267] raid6: sse2x4    7347 MB/s
[    3.191268] raid6: using algorithm sse2x4 (7347 MB/s)
[    3.192647] xor: automatically using best checksumming function: =
generic_sse
[    3.241254]    generic_sse: 11132.800 MB/sec
[    3.241256] xor: using function: generic_sse (11132.800 MB/sec)
[    3.245008] md: raid6 personality registered for level 6
[    3.245011] md: raid5 personality registered for level 5
[    3.245012] md: raid4 personality registered for level 4
[    3.251046] md: raid10 personality registered for level 10
[    3.293298] EXT3-fs (sdc1): recovery required on readonly filesystem
[    3.293302] EXT3-fs (sdc1): write access will be enabled during =
recovery
[    3.297642] EXT3-fs: barriers not enabled
[    3.311586] md: bind<sde1>
[    3.319685] md: bind<sdb1>
[    3.511423] ieee1394: Host added: ID:BUS[0-00:1023]  =
GUID[00cc06d60000241d]
[    3.548101] md: bind<sda1>
[    3.553048] md/raid:md0: device sda1 operational as raid disk 2
[    3.553051] md/raid:md0: device sdb1 operational as raid disk 3
[    3.553053] md/raid:md0: device sde1 operational as raid disk 0
[    3.553411] md/raid:md0: allocated 4282kB
[    3.553466] md/raid:md0: raid level 5 active with 3 out of 4 devices, =
algorithm 2
[    3.553499] RAID conf printout:
[    3.553501]  --- level:5 rd:4 wd:3
[    3.553503]  disk 0, o:1, dev:sde1
[    3.553505]  disk 2, o:1, dev:sda1
[    3.553506]  disk 3, o:1, dev:sdb1
[    3.553566] md0: detected capacity change from 0 to 4500255670272
[    3.554510]  md0: unknown partition table
[    3.942248] kjournald starting.  Commit interval 5 seconds
[    3.942266] EXT3-fs (sdc1): recovery complete
[    3.946249] EXT3-fs (sdc1): mounted filesystem with ordered data mode
[   19.706349] Adding 1052252k swap on /dev/sdc2.  Priority:-1 extents:1 =
across:1052252k=20
[   19.715953] udev: starting version 151
[   20.017390] type=3D1400 audit(1295104646.302:2): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/sbin/dhclient3" pid=3D694 =
comm=3D"apparmor_parser"
[   20.017606] type=3D1400 audit(1295104646.302:3): apparmor=3D"STATUS" =
operation=3D"profile_load" =
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D694 =
comm=3D"apparmor_parser"
[   20.017730] type=3D1400 audit(1295104646.302:4): apparmor=3D"STATUS" =
operation=3D"profile_load" =
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D694 =
comm=3D"apparmor_parser"
[   20.018595] type=3D1400 audit(1295104646.302:5): apparmor=3D"STATUS" =
operation=3D"profile_replace" name=3D"/sbin/dhclient3" pid=3D701 =
comm=3D"apparmor_parser"
[   20.018809] type=3D1400 audit(1295104646.302:6): apparmor=3D"STATUS" =
operation=3D"profile_replace" =
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D701 =
comm=3D"apparmor_parser"
[   20.018932] type=3D1400 audit(1295104646.302:7): apparmor=3D"STATUS" =
operation=3D"profile_replace" =
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D701 =
comm=3D"apparmor_parser"
[   20.019422] type=3D1400 audit(1295104646.302:8): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/sbin/ntpd" pid=3D842 =
comm=3D"apparmor_parser"
[   20.020530] type=3D1400 audit(1295104646.312:9): apparmor=3D"STATUS" =
operation=3D"profile_replace" name=3D"/usr/sbin/ntpd" pid=3D843 =
comm=3D"apparmor_parser"
[   20.036279] r8169 0000:02:00.0: eth0: link up
[   20.036285] r8169 0000:02:00.0: eth0: link up
[   20.405450] lp: driver loaded but no devices found
[   20.496286] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.602485] it87: Found IT8718F chip at 0x228, revision 5
[   20.602503] it87: in3 is VCC (+5V)
[   20.602508] it87: Beeping is supported
[   20.606476] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts =
with ACPI region SOR1 [mem 0x00000b00-0x00000b0f 64bit]
[   20.606480] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   20.632310] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602 =
ss_vid 1022 ss_did 9602
[   20.632314] shpchp 0000:00:01.0: Cannot reserve MMIO region
[   20.632402] shpchp: Standard Hot Plug PCI Controller Driver version: =
0.4
[   20.638866] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   20.639020] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. =
Please use
[   20.639022] nf_conntrack.acct=3D1 kernel parameter, acct=3D1 =
nf_conntrack module option or
[   20.639023] sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
[   20.670941] EDAC MC: Ver: 2.1.0 Oct 11 2010
[   20.703796] EDAC amd64_edac:  Ver: 3.3.0 Oct 11 2010
[   20.703980] EDAC amd64: This node reports that Memory ECC is =
currently disabled, set F3x44[22] (0000:00:18.3).
[   20.703986] EDAC amd64: ECC disabled in the BIOS or no ECC =
capability, module will not load.
[   20.703987]  Either enable ECC checking or force module loading by =
setting 'ecc_enable_override'.
[   20.703988]  (Note that use of the override may cause unknown side =
effects.)
[   20.704148] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   20.754706] Linux video capture interface: v2.00
[   20.793351] IR NEC protocol handler initialized
[   20.842273] IR RC5(x) protocol handler initialized
[   20.871008] IR RC6 protocol handler initialized
[   20.891280] [drm] Initialized drm 1.1.0 20060810
[   20.909159] IR JVC protocol handler initialized
[   20.947073] IR Sony protocol handler initialized
[   20.987905] cx2388x alsa driver version 0.0.8 loaded
[   20.988384] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8 =
loaded
[   20.988466]   alloc irq_desc for 21 on node 0
[   20.988468]   alloc kstat_irqs on node 0
[   20.988478] cx88_audio 0000:03:07.1: PCI INT A -> GSI 21 (level, low) =
-> IRQ 21
[   20.989432] cx88[0]: subsystem: 0070:6902, board: Hauppauge =
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=3D68,autodetected], frontend(s): 2
[   20.989434] cx88[0]: TV tuner type 63, Radio tuner type -1
[   20.995345] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[   20.995359] lirc_dev: IR Remote Control driver registered, major 250=20=

[   21.016938] IR LIRC bridge handler initialized
[   21.017088] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[   21.122132] cx88[0]: i2c init: enabling analog demod on =
HVR1300/3000/4000 tuner
[   21.262009] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   21.431285] hda_codec: ALC889A: BIOS auto-probing.
[   21.444825] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) =
-> IRQ 19
[   21.444854] HDA Intel 0000:01:05.1: setting latency timer to 64
[   21.534858] [drm] radeon kernel modesetting enabled.
[   21.536390] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> =
IRQ 18
[   21.536395] radeon 0000:01:05.0: setting latency timer to 64
[   21.538345] [drm] initializing kernel modesetting (RS780 =
0x1002:0x9614).
[   21.538575] [drm] register mmio base: 0xFDFE0000
[   21.538577] [drm] register mmio size: 65536
[   21.538910] ATOM BIOS: B27721
[   21.538925] [drm] Clocks initialized !
[   21.538931] radeon 0000:01:05.0: VRAM: 384M 0xC0000000 - 0xD7FFFFFF =
(384M used)
[   21.538933] radeon 0000:01:05.0: GTT: 512M 0xA0000000 - 0xBFFFFFFF
[   21.539150] [drm] Detected VRAM RAM=3D384M, BAR=3D256M
[   21.539154] [drm] RAM width 32bits DDR
[   21.540080] [TTM] Zone  kernel: Available graphics memory: 897672 =
kiB.
[   21.540083] [TTM] Initializing pool allocator.
[   21.540099] [drm] radeon: 384M of VRAM memory ready
[   21.540100] [drm] radeon: 512M of GTT memory ready.
[   21.540126] [drm] radeon: irq initialized.
[   21.540129] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   21.541002] [drm] Loading RS780 Microcode
[   21.546525] tuner 0-0043: chip found @ 0x86 (cx88[0])
[   21.594712] tda9887 0-0043: creating new instance
[   21.594715] tda9887 0-0043: tda988[5/6/7] found
[   21.597722] tuner 0-0061: chip found @ 0xc2 (cx88[0])
[   21.642455] tveeprom 0-0050: Hauppauge model 69009, rev B5D3, serial# =
7151981
[   21.642457] tveeprom 0-0050: MAC address is 00:0d:fe:6d:21:6d
[   21.642459] tveeprom 0-0050: tuner model is Philips FMD1216MEX (idx =
133, type 78)
[   21.642461] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') =
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   21.642464] tveeprom 0-0050: audio processor is CX880 (idx 30)
[   21.642465] tveeprom 0-0050: decoder processor is CX880 (idx 20)
[   21.642467] tveeprom 0-0050: has radio, has IR receiver, has no IR =
transmitter
[   21.642469] cx88[0]: hauppauge eeprom: model=3D69009
[   21.728153] tuner-simple 0-0061: creating new instance
[   21.728157] tuner-simple 0-0061: type set to 78 (Philips FMD1216MEX =
MK3 Hybrid Tuner)
[   21.766023] [drm] ring test succeeded in 1 usecs
[   21.766111] [drm] radeon: ib pool ready.
[   21.766168] [drm] ib test succeeded in 0 usecs
[   21.766170] [drm] Enabling audio support
[   21.766176] failed to evaluate ATIF got AE_BAD_PARAMETER
[   21.766178] radeon 0000:01:05.0: Error during ACPI methods call
[   21.766228] [drm] Unknown TV standard; defaulting to NTSC
[   21.766314] [drm] Radeon Display Connectors
[   21.766316] [drm] Connector 0:
[   21.766317] [drm]   VGA
[   21.766319] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 =
0x7e4c 0x7e4c
[   21.766320] [drm]   Encoders:
[   21.766321] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   21.766323] [drm] Connector 1:
[   21.766324] [drm]   HDMI-A
[   21.766324] [drm]   HPD1
[   21.766326] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 =
0x7e5c 0x7e5c
[   21.766327] [drm]   Encoders:
[   21.766328] [drm]     DFP1: INTERNAL_KLDSCP_LVTMA
[   21.830033] Registered IR keymap rc-hauppauge-new
[   21.830094] input: cx88 IR (Hauppauge WinTV-HVR400 as =
/devices/pci0000:00/0000:00:14.4/0000:03:07.1/rc/rc0/input4
[   21.830139] rc0: cx88 IR (Hauppauge WinTV-HVR400 as =
/devices/pci0000:00/0000:00:14.4/0000:03:07.1/rc/rc0
[   21.830176] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   21.840024] cx88[0]/2: cx2388x 8802 Driver Manager
[   21.840038] cx88-mpeg driver manager 0000:03:07.2: PCI INT A -> GSI =
21 (level, low) -> IRQ 21
[   21.840047] cx88[0]/2: found at 0000:03:07.2, rev: 5, irq: 21, =
latency: 32, mmio: 0xfb000000
[   21.841179] cx8800 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> =
IRQ 21
[   21.841187] cx88[0]/0: found at 0000:03:07.0, rev: 5, irq: 21, =
latency: 32, mmio: 0xf9000000
[   21.876116] [drm] radeon: power management initialized
[   21.877364] RPC: Registered udp transport module.
[   21.877367] RPC: Registered tcp transport module.
[   21.877369] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   21.894167] wm8775 0-001b: chip found @ 0x36 (cx88[0])
[   21.901553] cx88[0]/0: registered device video0 [v4l2]
[   21.901576] cx88[0]/0: registered device vbi0
[   21.901593] cx88[0]/0: registered device radio0
[   22.015571] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[   22.015574] cx88/2: registering cx8802 driver, type: dvb access: =
shared
[   22.015577] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge =
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=3D68]
[   22.015579] cx88[0]/2: cx2388x based DVB/ATSC card
[   22.015581] cx8802_alloc_frontends() allocating 2 frontend(s)
[   22.016128] EXT3-fs (sdc1): using internal journal
[   22.019850] [drm] fb mappable at 0xD0141000
[   22.019853] [drm] vram apper at 0xD0000000
[   22.019854] [drm] size 8294400
[   22.019856] [drm] fb depth is 24
[   22.019857] [drm]    pitch is 7680
[   22.056289] Console: switching to colour frame buffer device 240x67
[   22.062393] fb0: radeondrmfb frame buffer device
[   22.062395] drm: registered panic notifier
[   22.062398] Slow work thread pool: Starting up
[   22.062461] Slow work thread pool: Ready
[   22.062466] [drm] Initialized radeon 2.5.0 20080528 for 0000:01:05.0 =
on minor 0
[   22.070612] cx88[0]/2: dvb_register failed (err =3D -22)
[   22.070645] cx88[0]/2: cx8802 probe failed, err =3D -22
[   22.587695] EXT3-fs: barriers not enabled
[   22.609677] kjournald starting.  Commit interval 5 seconds
[   22.610549] EXT3-fs (md0): mounted filesystem with ordered data mode
[   22.631212] EXT3-fs: barriers not enabled
[   22.646505] kjournald starting.  Commit interval 5 seconds
[   22.646539] EXT3-fs (sdc4): warning: maximal mount count reached, =
running e2fsck is recommended
[   22.646756] EXT3-fs (sdc4): using internal journal
[   22.646762] EXT3-fs (sdc4): mounted filesystem with ordered data mode
[   22.677781] EXT3-fs: barriers not enabled
[   22.688445] kjournald starting.  Commit interval 5 seconds
[   22.688664] EXT3-fs (sdc3): using internal journal
[   22.688670] EXT3-fs (sdc3): mounted filesystem with ordered data mode
[   23.607894] type=3D1400 audit(1295104649.892:10): apparmor=3D"STATUS" =
operation=3D"profile_load" name=3D"/usr/sbin/mysqld" pid=3D1422 =
comm=3D"apparmor_parser"
[   23.608813] type=3D1400 audit(1295104649.892:11): apparmor=3D"STATUS" =
operation=3D"profile_replace" name=3D"/sbin/dhclient3" pid=3D1421 =
comm=3D"apparmor_parser"
[   23.978766] FS-Cache: Loaded
[   24.041846] lirc_i2c: module is from the staging directory, the =
quality is unknown, you have been warned.
[   24.198847] FS-Cache: Netfs 'nfs' registered for caching
[   24.251289] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   24.365711] svc: failed to register lockdv1 RPC service (errno 97).
[   24.367617] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state =
recovery directory
[   24.409507] NFSD: starting 90-second grace period
[   24.791292] device eth0 entered promiscuous mode
[   27.295224] hda-intel: IRQ timing workaround is activated for card =
#2. Suggest a bigger bdl_pos_adj.
[   30.831275] eth0: no IPv6 routers present
[  310.816702] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[  310.816710] cx88/2: registering cx8802 driver, type: dvb access: =
shared
[  310.816719] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge =
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=3D68]
[  310.816726] cx88[0]/2: cx2388x based DVB/ATSC card
[  310.816731] cx8802_alloc_frontends() allocating 2 frontend(s)
[  310.819810] cx88[0]/2: dvb_register failed (err =3D -22)
[  310.819816] cx88[0]/2: cx8802 probe failed, err =3D -22

--Apple-Mail-6--1029177599
Content-Disposition: attachment;
	filename=lspci_vnn.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="lspci_vnn.txt"
Content-Transfer-Encoding: quoted-printable

00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] RS780 Host =
Bridge [1022:9600]
	Subsystem: Advanced Micro Devices [AMD] RS780 Host Bridge =
[1022:9600]
	Flags: bus master, 66MHz, medium devsel, latency 32
	Memory at <ignored> (64-bit, non-prefetchable)
	Capabilities: <access denied>

00:01.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI =
bridge (int gfx) [1022:9602]
	Flags: bus master, 66MHz, medium devsel, latency 99
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, =
sec-latency=3D68
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdffffff
	Prefetchable memory behind bridge: =
00000000d0000000-00000000dfffffff
	Capabilities: <access denied>
	Kernel modules: shpchp

00:0a.0 PCI bridge [0604]: Advanced Micro Devices [AMD] RS780 PCI to PCI =
bridge (PCIE port 5) [1022:9609]
	Flags: bus master, fast devsel, latency 0
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, =
sec-latency=3D0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: =
00000000fdb00000-00000000fdbfffff
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:11.0 SATA controller [0106]: ATI Technologies Inc SB700/SB800 SATA =
Controller [IDE mode] [1002:4390] (prog-if 01)
	Subsystem: Giga-byte Technology Device [1458:b002]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 42
	I/O ports at ff00 [size=3D8]
	I/O ports at fe00 [size=3D4]
	I/O ports at fd00 [size=3D8]
	I/O ports at fc00 [size=3D4]
	I/O ports at fb00 [size=3D16]
	Memory at fe02f000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: <access denied>
	Kernel driver in use: ahci
	Kernel modules: ahci

00:12.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB =
OHCI0 Controller [1002:4397] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
	Memory at fe02e000 (32-bit, non-prefetchable) [size=3D4K]
	Kernel driver in use: ohci_hcd

00:12.1 USB Controller [0c03]: ATI Technologies Inc SB700 USB OHCI1 =
Controller [1002:4398] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
	Memory at fe02d000 (32-bit, non-prefetchable) [size=3D4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI =
Controller [1002:4396] (prog-if 20)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	Memory at fe02c000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:13.0 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB =
OHCI0 Controller [1002:4397] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe02b000 (32-bit, non-prefetchable) [size=3D4K]
	Kernel driver in use: ohci_hcd

00:13.1 USB Controller [0c03]: ATI Technologies Inc SB700 USB OHCI1 =
Controller [1002:4398] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe02a000 (32-bit, non-prefetchable) [size=3D4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB EHCI =
Controller [1002:4396] (prog-if 20)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
	Memory at fe029000 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:14.0 SMBus [0c05]: ATI Technologies Inc SBx00 SMBus Controller =
[1002:4385] (rev 3c)
	Subsystem: Giga-byte Technology Device [1458:4385]
	Flags: 66MHz, medium devsel
	Capabilities: <access denied>
	Kernel modules: i2c-piix4

00:14.1 IDE interface [0101]: ATI Technologies Inc SB700/SB800 IDE =
Controller [1002:439c] (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device [1458:5002]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
	I/O ports at 01f0 [size=3D8]
	I/O ports at 03f4 [size=3D1]
	I/O ports at 0170 [size=3D8]
	I/O ports at 0374 [size=3D1]
	I/O ports at fa00 [size=3D16]
	Capabilities: <access denied>
	Kernel driver in use: pata_atiixp
	Kernel modules: pata_atiixp

00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel =
HDA) [1002:4383]
	Subsystem: Giga-byte Technology Device [1458:a102]
	Flags: bus master, slow devsel, latency 32, IRQ 16
	Memory at fe024000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:14.3 ISA bridge [0601]: ATI Technologies Inc SB700/SB800 LPC host =
controller [1002:439d]
	Subsystem: ATI Technologies Inc SB700/SB800 LPC host controller =
[1002:439d]
	Flags: bus master, 66MHz, medium devsel, latency 0

00:14.4 PCI bridge [0604]: ATI Technologies Inc SBx00 PCI to PCI Bridge =
[1002:4384] (prog-if 01)
	Flags: bus master, VGA palette snoop, 66MHz, medium devsel, =
latency 64
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, =
sec-latency=3D64
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: f8000000-fcffffff
	Prefetchable memory behind bridge: fdc00000-fdcfffff

00:14.5 USB Controller [0c03]: ATI Technologies Inc SB700/SB800 USB =
OHCI2 Controller [1002:4399] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:5004]
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe028000 (32-bit, non-prefetchable) [size=3D4K]
	Kernel driver in use: ohci_hcd

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, =
Athlon64, Sempron] HyperTransport Configuration [1022:1200]
	Flags: fast devsel
	Capabilities: <access denied>

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, =
Athlon64, Sempron] Address Map [1022:1201]
	Flags: fast devsel

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, =
Athlon64, Sempron] DRAM Controller [1022:1202]
	Flags: fast devsel
	Kernel modules: amd64_edac_mod

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, =
Athlon64, Sempron] Miscellaneous Control [1022:1203]
	Flags: fast devsel
	Capabilities: <access denied>
	Kernel driver in use: k10temp
	Kernel modules: k10temp

00:18.4 Host bridge [0600]: Advanced Micro Devices [AMD] K10 [Opteron, =
Athlon64, Sempron] Link Control [1022:1204]
	Flags: fast devsel

01:05.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon HD =
3300 Graphics [1002:9614]
	Subsystem: Giga-byte Technology Device [1458:d000]
	Flags: bus master, fast devsel, latency 0, IRQ 18
	Memory at d0000000 (32-bit, prefetchable) [size=3D256M]
	I/O ports at ee00 [size=3D256]
	Memory at fdfe0000 (32-bit, non-prefetchable) [size=3D64K]
	Memory at fde00000 (32-bit, non-prefetchable) [size=3D1M]
	Capabilities: <access denied>
	Kernel driver in use: radeon
	Kernel modules: radeon

01:05.1 Audio device [0403]: ATI Technologies Inc RS780 Azalia =
controller [1002:960f]
	Subsystem: Giga-byte Technology Device [1458:960f]
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fdffc000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. =
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev =
02)
	Subsystem: Giga-byte Technology Device [1458:e000]
	Flags: bus master, fast devsel, latency 0, IRQ 41
	I/O ports at de00 [size=3D256]
	Memory at fdbff000 (64-bit, prefetchable) [size=3D4K]
	Memory at fdbe0000 (64-bit, prefetchable) [size=3D64K]
	[virtual] Expansion ROM at fdb00000 [disabled] [size=3D64K]
	Capabilities: <access denied>
	Kernel driver in use: r8169
	Kernel modules: r8169

03:07.0 Multimedia video controller [0400]: Conexant Systems, Inc. =
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
	Subsystem: Hauppauge computer works Inc. Device [0070:6902]
	Flags: bus master, medium devsel, latency 32, IRQ 21
	Memory at f9000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: <access denied>
	Kernel driver in use: cx8800
	Kernel modules: cx8800

03:07.1 Multimedia controller [0480]: Conexant Systems, Inc. =
CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801] (rev =
05)
	Subsystem: Hauppauge computer works Inc. Device [0070:6902]
	Flags: bus master, medium devsel, latency 32, IRQ 21
	Memory at f8000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: <access denied>
	Kernel driver in use: cx88_audio
	Kernel modules: cx88-alsa

03:07.2 Multimedia controller [0480]: Conexant Systems, Inc. =
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev =
05)
	Subsystem: Hauppauge computer works Inc. Device [0070:6902]
	Flags: bus master, medium devsel, latency 32, IRQ 21
	Memory at fb000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: <access denied>
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802

03:07.4 Multimedia controller [0480]: Conexant Systems, Inc. =
CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] [14f1:8804] (rev 05)
	Subsystem: Hauppauge computer works Inc. Device [0070:6902]
	Flags: bus master, medium devsel, latency 32, IRQ 5
	Memory at fa000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: <access denied>

03:0e.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB23 =
IEEE-1394a-2000 Controller (PHY/Link) [104c:8024] (prog-if 10)
	Subsystem: Giga-byte Technology Device [1458:1000]
	Flags: bus master, medium devsel, latency 32, IRQ 22
	Memory at fcfff000 (32-bit, non-prefetchable) [size=3D2K]
	Memory at fcff8000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: <access denied>
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394


--Apple-Mail-6--1029177599
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




--Apple-Mail-6--1029177599--
