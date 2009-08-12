Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:25641 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751736AbZHLXau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 19:30:50 -0400
From: "Christopher Thornley" <c.j.thornley@coolrose.fsnet.co.uk>
To: <n.wagenaar@xs4all.nl>, <linux-media@vger.kernel.org>
References: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAAJQ52z3qEFtDsl72y5icHrgBAAAAAA==@coolrose.fsnet.co.uk> <f554f7485cc95254484c951ed52cb7ba.squirrel@webmail.xs4all.nl>
In-Reply-To: <f554f7485cc95254484c951ed52cb7ba.squirrel@webmail.xs4all.nl>
Subject: RE: [linux-dvb] TechnoTrend TT-connect S2-3650 CI
Date: Thu, 13 Aug 2009 00:30:27 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMs7WpTkg9MRuRcAACHFyB/CgAAAEAAAACcjVxFMux1AotUWOp7nrWEBAAAAAA==@coolrose.fsnet.co.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_08CF_01CA1BAD.4808D130"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_08CF_01CA1BAD.4808D130
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
I have now successfully installed the S2API and s2-liplianin (Thank for the
link Goga777)

On checking /dev/dvb I now have adapter0, adapter1 and adapter2 (DVB-S,
DVB-C, DVB-T) 

Find attached my current dsmeg.txt file.

I have installed Kaffeine and this is currently taking an age to scan for
MUX's @ Winter Hill.
I am seeing some strong signal indications but no channels/pids/pats etc are
being detected.

I have tried setting the adapter up in MythTV. Although it sees the device
and I can select from 0 1 2 units the program freezes when I make a
selection.

I have tried to build (make) several versions of VDR from version 1.7.4 to
1.7.8 but I am receiving the following error message which I don't know what
to do to resolve this :-

system@Firefly:~/dvb/vdr-1.7.8$ make
g++ -g -O2 -Wall -Woverloaded-virtual -Wno-parentheses -c -DREMOTE_KBD
-DLIRC_DEVICE=\"/dev/lircd\" -DRCU_DEVICE=\"/dev/ttyS1\" -D_GNU_SOURCE
-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
-DVIDEODIR=\"/video\" -DCONFDIR=\"/video\" -DPLUGINDIR=\"./PLUGINS/lib\"
-DLOCDIR=\"./locale\" -I/usr/include/freetype2 dvbdevice.c
dvbdevice.c: In constructor 'cDvbDevice::cDvbDevice(int)':
dvbdevice.c:487: error: 'FE_CAN_2G_MODULATION' was not declared in this
scope
make: *** [dvbdevice.o] Error 1
system@Firefly:~/dvb/vdr-1.7.8$ 


Many Thanks
Chris


               />      Christopher J. Thornley is cjt@coolrose.fsnet.co.uk
  (           //------------------------------------------------------,
 (*)OXOXOXOXO(*>=*=O=S=U=0=3=6=*=---------                             >
  (           \\------------------------------------------------------'
               \>       Home Page :-http://www.coolrose.fsnet.co.uk
 
-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Niels Wagenaar
Sent: 11 August 2009 20:07
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] TechnoTrend TT-connect S2-3650 CI



Then check if your cards were detected using dmesg (it should tell you
information if the DVB devices were detected) and you can check /dev/dvb.
You should have two folders containing adapter0 and adapter1.

Normally, a simple check would be to use a DVB application like Kaffeine.
Alternatively you can use MythTV 0.22 (which supports S2API), VDR 1.7.0 with
my S2API patch or VDR 1.7.4 or higher (latest version is 1.7.8).

------=_NextPart_000_08CF_01CA1BAD.4808D130
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

[    0.000000] BIOS EBDA/lowmem at: 0009ec00/0009ec00
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-14-generic (buildd@yellow) (gcc =
version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #47-Ubuntu SMP Sat Jul 25 =
01:19:55 UTC 2009 (Ubuntu 2.6.28-14.47-generic)
[    0.000000] Command line: =
root=3DUUID=3D387af4e1-0619-49df-b36d-7e50dfaa6415 ro quiet splash=20
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000000e1000 - 0000000000100000 =
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bff80000 (usable)
[    0.000000]  BIOS-e820: 00000000bff80000 - 00000000bff8f000 (ACPI =
data)
[    0.000000]  BIOS-e820: 00000000bff8f000 - 00000000bffe0000 (ACPI =
NVS)
[    0.000000]  BIOS-e820: 00000000bffe0000 - 00000000c0000000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed40000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 =
(reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it =
around.
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x3ffffffff
[    0.000000] last_pfn =3D 0xbff80 max_arch_pfn =3D 0x3ffffffff
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e1000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bff80000 (usable)
[    0.000000]  modified: 00000000bff80000 - 00000000bff8f000 (ACPI =
data)
[    0.000000]  modified: 00000000bff8f000 - 00000000bffe0000 (ACPI NVS)
[    0.000000]  modified: 00000000bffe0000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed40000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000bff80000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bff80000 page 4k
[    0.000000] kernel direct mapping tables up to bff80000 @ 10000-15000
[    0.000000] last_map_addr: bff80000 end: bff80000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ =
13000-19000
[    0.000000] last_map_addr: 140000000 end: 140000000
[    0.000000] RAMDISK: 37858000 - 37fef2f5
[    0.000000] ACPI: RSDP 000F9350, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT BFF80100, 0084 (r1 _ASUS_ Notebook 20081031 =
MSFT       97)
[    0.000000] ACPI: FACP BFF80290, 00F4 (r3 103108 FACP0921 20081031 =
MSFT       97)
[    0.000000] ACPI: DSDT BFF80680, B844 (r1  N80Vc N80Vc207      207 =
INTL 20081204)
[    0.000000] ACPI: FACS BFF8F000, 0040
[    0.000000] ACPI: APIC BFF80390, 005C (r1 103108 APIC0921 20081031 =
MSFT       97)
[    0.000000] ACPI: MCFG BFF80430, 003C (r1 103108 OEMMCFG  20081031 =
MSFT       97)
[    0.000000] ACPI: SLIC BFF80470, 0176 (r1 _ASUS_ Notebook 20081031 =
MSFT       97)
[    0.000000] ACPI: ECDT BFF80620, 0054 (r1 103108 OEMECDT  20081031 =
MSFT       97)
[    0.000000] ACPI: DBGP BFF803F0, 0034 (r1 103108 DBGP0921 20081031 =
MSFT       97)
[    0.000000] ACPI: BOOT BFF805F0, 0028 (r1 103108 BOOT0921 20081031 =
MSFT       97)
[    0.000000] ACPI: OEMB BFF8F040, 0071 (r1 103108 OEMB0921 20081031 =
MSFT       97)
[    0.000000] ACPI: HPET BFF8BF30, 0038 (r1 103108 OEMHPET  20081031 =
MSFT       97)
[    0.000000] ACPI: DMAR BFF8F0C0, 0108 (r1 103108 DMAR0921 20081031 =
MSFT       97)
[    0.000000] ACPI: ATKG BFF8F3D0, 8024 (r1 103108  OEMATKG 20081031 =
MSFT       97)
[    0.000000] ACPI: SSDT BFF97F20, 04F0 (r1  PmRef    CpuPm     3000 =
INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - =
0140000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> =
[0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> =
[0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b7bbb0]    TEXT DATA BSS =3D=3D> =
[0000200000 - 0000b7bbb0]
[    0.000000]   #3 [0037858000 - 0037fef2f5]          RAMDISK =3D=3D> =
[0037858000 - 0037fef2f5]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved =3D=3D> =
[000009ec00 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE =3D=3D> =
[0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 0000014000]          PGTABLE =3D=3D> =
[0000013000 - 0000014000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> =
[ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bff80
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1048334
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2533 pages reserved
[    0.000000]   DMA zone: 1393 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767928 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high =
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009e000 - =
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - =
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - =
00000000000e1000
[    0.000000] PM: Registered nosave memory: 00000000000e1000 - =
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bff80000 - =
00000000bff8f000
[    0.000000] PM: Registered nosave memory: 00000000bff8f000 - =
00000000bffe0000
[    0.000000] PM: Registered nosave memory: 00000000bffe0000 - =
00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - =
00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - =
00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - =
00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - =
00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - =
00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - =
0000000100000000
[    0.000000] Allocating PCI resources starting at c4000000 (gap: =
c0000000:3ed20000)
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  =
Total pages: 1027881
[    0.000000] Kernel command line: =
root=3DUUID=3D387af4e1-0619-49df-b36d-7e50dfaa6415 ro quiet splash=20
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.248 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, =
4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
[    0.004000] allocated 52428800 bytes of page_cgroup
[    0.004000] please try cgroup_disable=3Dmemory option if you don't =
want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - =
bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 3979556k/5242880k available (4748k kernel code, =
1049544k absent, 212828k reserved, 2524k data, 532k init)
[    0.004000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-3, =
MinObjects=3D0, CPUs=3D2, Nodes=3D1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for =
per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using =
timer frequency.. 3990.49 BogoMIPS (lpj=3D7980992)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.006474] ACPI: Checking initramfs for custom DSDT
[    0.348046] Setting APIC routing to flat
[    0.348415] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 =
pin2=3D-1
[    0.391319] CPU0: Intel(R) Core(TM)2 Duo CPU     T5800  @ 2.00GHz =
stepping 0d
[    0.392001] APIC calibration not consistent with PM Timer: 159ms =
instead of 100ms
[    0.392001] APIC delta adjusted to PM-Timer: 1246874 (1994967)
[    0.392001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 3989.97 =
BogoMIPS (lpj=3D7979942)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.476455] CPU1: Intel(R) Core(TM)2 Duo CPU     T5800  @ 2.00GHz =
stepping 0d
[    0.476480] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.480467] Brought up 2 CPUs
[    0.480469] Total of 2 processors activated (7980.46 BogoMIPS).
[    0.480515] CPU0 attaching sched-domain:
[    0.480518]  domain 0: span 0-1 level MC
[    0.480520]   groups: 0 1
[    0.480525] CPU1 attaching sched-domain:
[    0.480527]  domain 0: span 0-1 level MC
[    0.480529]   groups: 1 0
[    0.480591] net_namespace: 1400 bytes
[    0.480591] Booting paravirtualized kernel on bare hardware
[    0.480591] Time: 19:31:49  Date: 08/12/09
[    0.480591] regulator: core version 0.5
[    0.480591] NET: Registered protocol family 16
[    0.480591] ACPI FADT declares the system doesn't support PCIe ASPM, =
so disable it
[    0.480591] ACPI: bus type pci registered
[    0.480591] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[    0.480591] PCI: Not using MMCONFIG.
[    0.480591] PCI: Using configuration type 1 for base access
[    0.481448] ACPI: EC: EC description table is found, configuring boot =
EC
[    0.489049] ACPI: BIOS _OSI(Linux) query ignored
[    0.498600] ACPI: Interpreter enabled
[    0.498603] ACPI: (supports S0 S1 S3 S4 S5)
[    0.498626] ACPI: Using IOAPIC for interrupt routing
[    0.498757] PCI: MCFG configuration 0: base e0000000 segment 0 buses =
0 - 255
[    0.503285] PCI: MCFG area at e0000000 reserved in ACPI motherboard =
resources
[    0.513530] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.525861] ACPI: EC: GPE =3D 0x1b, I/O: command/status =3D 0x66, =
data =3D 0x62
[    0.525863] ACPI: EC: driver started in poll mode
[    0.526129] ACPI: No dock devices found.
[    0.526235] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.526331] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.526334] pci 0000:00:01.0: PME# disabled
[    0.526426] pci 0000:00:1a.0: reg 20 io port: [0xbc00-0xbc1f]
[    0.526504] pci 0000:00:1a.1: reg 20 io port: [0xb880-0xb89f]
[    0.526582] pci 0000:00:1a.2: reg 20 io port: [0xb800-0xb81f]
[    0.526664] pci 0000:00:1a.7: reg 10 32bit mmio: =
[0xf7fffc00-0xf7ffffff]
[    0.526711] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.526715] pci 0000:00:1a.7: PME# disabled
[    0.526768] pci 0000:00:1b.0: reg 10 64bit mmio: =
[0xf7ff8000-0xf7ffbfff]
[    0.526803] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.526808] pci 0000:00:1b.0: PME# disabled
[    0.526866] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.526870] pci 0000:00:1c.0: PME# disabled
[    0.526930] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.526934] pci 0000:00:1c.1: PME# disabled
[    0.526993] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.526997] pci 0000:00:1c.2: PME# disabled
[    0.527060] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.527064] pci 0000:00:1c.5: PME# disabled
[    0.527131] pci 0000:00:1d.0: reg 20 io port: [0xb480-0xb49f]
[    0.527209] pci 0000:00:1d.1: reg 20 io port: [0xb400-0xb41f]
[    0.527288] pci 0000:00:1d.2: reg 20 io port: [0xb080-0xb09f]
[    0.527370] pci 0000:00:1d.7: reg 10 32bit mmio: =
[0xf7fff800-0xf7fffbff]
[    0.527416] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.527421] pci 0000:00:1d.7: PME# disabled
[    0.527621] pci 0000:00:1f.2: reg 10 io port: [0xb000-0xb007]
[    0.527628] pci 0000:00:1f.2: reg 14 io port: [0xac00-0xac03]
[    0.527635] pci 0000:00:1f.2: reg 18 io port: [0xa880-0xa887]
[    0.527642] pci 0000:00:1f.2: reg 1c io port: [0xa800-0xa803]
[    0.527648] pci 0000:00:1f.2: reg 20 io port: [0xa480-0xa49f]
[    0.527655] pci 0000:00:1f.2: reg 24 32bit mmio: =
[0xf7fff000-0xf7fff7ff]
[    0.527672] pci 0000:00:1f.2: PME# supported from D3hot
[    0.527676] pci 0000:00:1f.2: PME# disabled
[    0.527761] pci 0000:01:00.0: reg 10 32bit mmio: =
[0xfb000000-0xfbffffff]
[    0.527778] pci 0000:01:00.0: reg 14 64bit mmio: =
[0xd0000000-0xdfffffff]
[    0.527796] pci 0000:01:00.0: reg 1c 64bit mmio: =
[0xf8000000-0xf9ffffff]
[    0.527805] pci 0000:01:00.0: reg 24 io port: [0xcc00-0xcc7f]
[    0.527815] pci 0000:01:00.0: reg 30 32bit mmio: =
[0xfafe0000-0xfaffffff]
[    0.527892] pci 0000:00:01.0: bridge io port: [0xc000-0xcfff]
[    0.527895] pci 0000:00:01.0: bridge 32bit mmio: =
[0xf8000000-0xfbffffff]
[    0.527900] pci 0000:00:01.0: bridge 64bit mmio pref: =
[0xd0000000-0xdfffffff]
[    0.528024] pci 0000:03:00.0: reg 10 64bit mmio: =
[0xfcff0000-0xfcffffff]
[    0.528074] pci 0000:03:00.0: supports D1
[    0.528076] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.528081] pci 0000:03:00.0: PME# disabled
[    0.528149] pci 0000:00:1c.1: bridge 32bit mmio: =
[0xfcf00000-0xfcffffff]
[    0.528205] pci 0000:00:1c.2: bridge io port: [0xd000-0xdfff]
[    0.528209] pci 0000:00:1c.2: bridge 32bit mmio: =
[0xfd000000-0xfddfffff]
[    0.528216] pci 0000:00:1c.2: bridge 64bit mmio pref: =
[0xf4000000-0xf6efffff]
[    0.528271] pci 0000:06:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.528295] pci 0000:06:00.0: reg 18 64bit mmio: =
[0xf6fff000-0xf6ffffff]
[    0.528311] pci 0000:06:00.0: reg 20 64bit mmio: =
[0xf6fe0000-0xf6feffff]
[    0.528321] pci 0000:06:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.528334] pci 0000:06:00.0: supports D1 D2
[    0.528336] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot =
D3cold
[    0.528341] pci 0000:06:00.0: PME# disabled
[    0.528409] pci 0000:00:1c.5: bridge io port: [0xe000-0xefff]
[    0.528414] pci 0000:00:1c.5: bridge 32bit mmio: =
[0xfde00000-0xfdefffff]
[    0.528421] pci 0000:00:1c.5: bridge 64bit mmio pref: =
[0xf6f00000-0xf6ffffff]
[    0.528466] pci 0000:07:03.0: reg 10 32bit mmio: =
[0xfdfff800-0xfdffffff]
[    0.528512] pci 0000:07:03.0: PME# supported from D0 D3hot D3cold
[    0.528517] pci 0000:07:03.0: PME# disabled
[    0.528558] pci 0000:07:03.1: reg 10 32bit mmio: =
[0xfdfff400-0xfdfff4ff]
[    0.528604] pci 0000:07:03.1: supports D1 D2
[    0.528605] pci 0000:07:03.1: PME# supported from D0 D1 D2 D3hot =
D3cold
[    0.528610] pci 0000:07:03.1: PME# disabled
[    0.528650] pci 0000:07:03.2: reg 10 32bit mmio: =
[0xfdfff000-0xfdfff0ff]
[    0.528697] pci 0000:07:03.2: supports D1 D2
[    0.528699] pci 0000:07:03.2: PME# supported from D0 D1 D2 D3hot =
D3cold
[    0.528703] pci 0000:07:03.2: PME# disabled
[    0.528744] pci 0000:07:03.3: reg 10 32bit mmio: =
[0xfdffec00-0xfdffecff]
[    0.528790] pci 0000:07:03.3: supports D1 D2
[    0.528792] pci 0000:07:03.3: PME# supported from D0 D1 D2 D3hot =
D3cold
[    0.528796] pci 0000:07:03.3: PME# disabled
[    0.528854] pci 0000:00:1e.0: transparent bridge
[    0.528861] pci 0000:00:1e.0: bridge 32bit mmio: =
[0xfdf00000-0xfdffffff]
[    0.528897] bus 00 -> node 0
[    0.528906] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.529224] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.529371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.529527] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.529667] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.529827] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.529965] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.558172] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 =
12)
[    0.558374] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 10 12)
[    0.558572] ACPI: PCI Interrupt Link [LNKC] (IRQs *6)
[    0.558767] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 12)
[    0.558964] ACPI: PCI Interrupt Link [LNKE] (IRQs 6) *0, disabled.
[    0.559160] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 12)
[    0.559357] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 7 10 12)
[    0.559555] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 12)
[    0.562507] ACPI Warning (tbutils-0217): Incorrect checksum in table =
[ATKG] - 59, should be C5 [20080926]
[    0.562536] ACPI: WMI: Mapper loaded
[    0.562585] SCSI subsystem initialized
[    0.562585] libata version 3.00 loaded.
[    0.562585] usbcore: registered new interface driver usbfs
[    0.562585] usbcore: registered new interface driver hub
[    0.562585] usbcore: registered new device driver usb
[    0.562585] PCI: Using ACPI for IRQ routing
[    0.576009] Bluetooth: Core ver 2.13
[    0.576020] NET: Registered protocol family 31
[    0.576020] Bluetooth: HCI device and connection manager initialized
[    0.576020] Bluetooth: HCI socket layer initialized
[    0.576020] NET: Registered protocol family 8
[    0.576022] NET: Registered protocol family 20
[    0.576033] NetLabel: Initializing
[    0.576035] NetLabel:  domain hash size =3D 128
[    0.576036] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.576049] NetLabel:  unlabeled traffic allowed by default
[    0.576080] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.576084] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.580061] AppArmor: AppArmor Filesystem Enabled
[    0.584008] Switched to high resolution mode on CPU 0
[    0.584943] Switched to high resolution mode on CPU 1
[    0.592008] pnp: PnP ACPI init
[    0.592016] ACPI: bus type pnp registered
[    0.595689] pnp: PnP ACPI: found 16 devices
[    0.595692] ACPI: ACPI bus type pnp unregistered
[    0.595700] system 00:01: iomem range 0xfed10000-0xfed19fff has been =
reserved
[    0.595708] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.595711] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.595713] system 00:08: ioport range 0x400-0x41f has been reserved
[    0.595715] system 00:08: ioport range 0x500-0x57f has been reserved
[    0.595718] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been =
reserved
[    0.595720] system 00:08: iomem range 0xfed20000-0xfed3ffff has been =
reserved
[    0.595725] system 00:08: iomem range 0xfed45000-0xfed89fff has been =
reserved
[    0.595728] system 00:08: iomem range 0xfed90000-0xfed90fff has been =
reserved
[    0.595730] system 00:08: iomem range 0xfed91000-0xfed91fff has been =
reserved
[    0.595733] system 00:08: iomem range 0xfed92000-0xfed92fff has been =
reserved
[    0.595735] system 00:08: iomem range 0xfed93000-0xfed93fff has been =
reserved
[    0.595738] system 00:08: iomem range 0xffb00000-0xffbfffff has been =
reserved
[    0.595740] system 00:08: iomem range 0xfff00000-0xffffffff has been =
reserved
[    0.595746] system 00:0a: iomem range 0xffa00000-0xffbfffff could not =
be reserved
[    0.595748] system 00:0a: iomem range 0xffe00000-0xffffffff could not =
be reserved
[    0.595756] system 00:0b: iomem range 0xffc00000-0xffdfffff has been =
reserved
[    0.595760] system 00:0c: ioport range 0x250-0x253 has been reserved
[    0.595763] system 00:0c: ioport range 0x256-0x25f has been reserved
[    0.595765] system 00:0c: iomem range 0xfec00000-0xfec00fff has been =
reserved
[    0.595768] system 00:0c: iomem range 0xfee00000-0xfee00fff has been =
reserved
[    0.595770] system 00:0c: iomem range 0xfec10000-0xfec17fff has been =
reserved
[    0.595772] system 00:0c: iomem range 0xfec18000-0xfec1ffff has been =
reserved
[    0.595775] system 00:0c: iomem range 0xfec20000-0xfec27fff has been =
reserved
[    0.595777] system 00:0c: iomem range 0xfec38000-0xfec3ffff has been =
reserved
[    0.595782] system 00:0e: iomem range 0xe0000000-0xefffffff has been =
reserved
[    0.595787] system 00:0f: iomem range 0x0-0x9ffff could not be =
reserved
[    0.595790] system 00:0f: iomem range 0xc0000-0xcffff has been =
reserved
[    0.595792] system 00:0f: iomem range 0xe0000-0xfffff could not be =
reserved
[    0.595795] system 00:0f: iomem range 0x100000-0xbfffffff could not =
be reserved
[    0.600475] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.600478] pci 0000:00:01.0:   IO window: 0xc000-0xcfff
[    0.600481] pci 0000:00:01.0:   MEM window: 0xf8000000-0xfbffffff
[    0.600485] pci 0000:00:01.0:   PREFETCH window: =
0x000000d0000000-0x000000dfffffff
[    0.600489] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.600491] pci 0000:00:1c.0:   IO window: disabled
[    0.600496] pci 0000:00:1c.0:   MEM window: disabled
[    0.600500] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.600507] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.600508] pci 0000:00:1c.1:   IO window: disabled
[    0.600514] pci 0000:00:1c.1:   MEM window: 0xfcf00000-0xfcffffff
[    0.600518] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.600525] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.600528] pci 0000:00:1c.2:   IO window: 0xd000-0xdfff
[    0.600533] pci 0000:00:1c.2:   MEM window: 0xfd000000-0xfddfffff
[    0.600537] pci 0000:00:1c.2:   PREFETCH window: =
0x000000f4000000-0x000000f6efffff
[    0.600545] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:06
[    0.600548] pci 0000:00:1c.5:   IO window: 0xe000-0xefff
[    0.600553] pci 0000:00:1c.5:   MEM window: 0xfde00000-0xfdefffff
[    0.600558] pci 0000:00:1c.5:   PREFETCH window: =
0x000000f6f00000-0x000000f6ffffff
[    0.600565] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    0.600566] pci 0000:00:1e.0:   IO window: disabled
[    0.600572] pci 0000:00:1e.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.600576] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.600590] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    0.600593] pci 0000:00:01.0: setting latency timer to 64
[    0.600601] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    0.600605] pci 0000:00:1c.0: setting latency timer to 64
[    0.600614] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ =
17
[    0.600618] pci 0000:00:1c.1: setting latency timer to 64
[    0.600626] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ =
18
[    0.600630] pci 0000:00:1c.2: setting latency timer to 64
[    0.600638] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ =
17
[    0.600642] pci 0000:00:1c.5: setting latency timer to 64
[    0.600649] pci 0000:00:1e.0: setting latency timer to 64
[    0.600653] bus: 00 index 0 io port: [0x00-0xffff]
[    0.600655] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.600657] bus: 01 index 0 io port: [0xc000-0xcfff]
[    0.600659] bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
[    0.600661] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.600662] bus: 01 index 3 mmio: [0x0-0x0]
[    0.600664] bus: 02 index 0 mmio: [0x0-0x0]
[    0.600666] bus: 02 index 1 mmio: [0x0-0x0]
[    0.600667] bus: 02 index 2 mmio: [0x0-0x0]
[    0.600668] bus: 02 index 3 mmio: [0x0-0x0]
[    0.600670] bus: 03 index 0 mmio: [0x0-0x0]
[    0.600671] bus: 03 index 1 mmio: [0xfcf00000-0xfcffffff]
[    0.600673] bus: 03 index 2 mmio: [0x0-0x0]
[    0.600675] bus: 03 index 3 mmio: [0x0-0x0]
[    0.600676] bus: 04 index 0 io port: [0xd000-0xdfff]
[    0.600678] bus: 04 index 1 mmio: [0xfd000000-0xfddfffff]
[    0.600680] bus: 04 index 2 mmio: [0xf4000000-0xf6efffff]
[    0.600681] bus: 04 index 3 mmio: [0x0-0x0]
[    0.600683] bus: 06 index 0 io port: [0xe000-0xefff]
[    0.600685] bus: 06 index 1 mmio: [0xfde00000-0xfdefffff]
[    0.600686] bus: 06 index 2 mmio: [0xf6f00000-0xf6ffffff]
[    0.600688] bus: 06 index 3 mmio: [0x0-0x0]
[    0.600690] bus: 07 index 0 mmio: [0x0-0x0]
[    0.600691] bus: 07 index 1 mmio: [0xfdf00000-0xfdffffff]
[    0.600693] bus: 07 index 2 mmio: [0x0-0x0]
[    0.600694] bus: 07 index 3 io port: [0x00-0xffff]
[    0.600696] bus: 07 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.600705] NET: Registered protocol family 2
[    0.636050] IP route cache hash table entries: 131072 (order: 8, =
1048576 bytes)
[    0.636571] TCP established hash table entries: 262144 (order: 10, =
4194304 bytes)
[    0.638413] TCP bind hash table entries: 65536 (order: 8, 1048576 =
bytes)
[    0.638923] TCP: Hash tables configured (established 262144 bind =
65536)
[    0.638925] TCP reno registered
[    0.648103] NET: Registered protocol family 1
[    0.648223] checking if image is initramfs... it is
[    1.323093] Freeing initrd memory: 7772k freed
[    1.326715] Simple Boot Flag at 0x51 set to 0x1
[    1.327027] audit: initializing netlink socket (disabled)
[    1.327049] type=3D2000 audit(1250105509.324:1): initialized
[    1.335464] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.336633] VFS: Disk quotas dquot_6.5.1
[    1.336681] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.337207] fuse init (API version 7.10)
[    1.337277] msgmni has been set to 7789
[    1.337426] alg: No test for stdrng (krng)
[    1.337435] io scheduler noop registered
[    1.337437] io scheduler anticipatory registered
[    1.337438] io scheduler deadline registered
[    1.337474] io scheduler cfq registered (default)
[    1.337657] pci 0000:01:00.0: Boot video device
[    1.341532] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.341567] pcieport-driver 0000:00:01.0: found MSI capability
[    1.341589] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    1.341599] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.341612] pci_express 0000:00:01.0:pcie02: allocate port service
[    1.341622] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.341670] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.341711] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.341742] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    1.341756] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.341768] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.341778] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.341842] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.341882] pcieport-driver 0000:00:1c.1: found MSI capability
[    1.341910] pcieport-driver 0000:00:1c.1: irq 2301 for MSI/MSI-X
[    1.341924] pci_express 0000:00:1c.1:pcie00: allocate port service
[    1.341935] pci_express 0000:00:1c.1:pcie03: allocate port service
[    1.341997] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    1.342039] pcieport-driver 0000:00:1c.2: found MSI capability
[    1.342067] pcieport-driver 0000:00:1c.2: irq 2300 for MSI/MSI-X
[    1.342081] pci_express 0000:00:1c.2:pcie00: allocate port service
[    1.342092] pci_express 0000:00:1c.2:pcie02: allocate port service
[    1.342102] pci_express 0000:00:1c.2:pcie03: allocate port service
[    1.342168] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    1.342208] pcieport-driver 0000:00:1c.5: found MSI capability
[    1.342237] pcieport-driver 0000:00:1c.5: irq 2299 for MSI/MSI-X
[    1.342250] pci_express 0000:00:1c.5:pcie00: allocate port service
[    1.342263] pci_express 0000:00:1c.5:pcie03: allocate port service
[    1.342334] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.342821] pciehp 0000:00:01.0:pcie02: HPC vendor_id 8086 device_id =
2a41 ss_vid 0 ss_did 0
[    1.342853] pciehp 0000:00:01.0:pcie02: service driver pciehp loaded
[    1.343313] pciehp 0000:00:1c.0:pcie02: HPC vendor_id 8086 device_id =
2940 ss_vid 0 ss_did 0
[    1.343345] pciehp 0000:00:1c.0:pcie02: service driver pciehp loaded
[    1.343808] pciehp 0000:00:1c.2:pcie02: HPC vendor_id 8086 device_id =
2944 ss_vid 0 ss_did 0
[    1.343841] pciehp 0000:00:1c.2:pcie02: service driver pciehp loaded
[    1.343848] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    1.344042] ACPI: AC Adapter [AC0] (on-line)
[    1.344481] ACPI: EC: non-query interrupt received, switching to =
interrupt mode
[    1.409373] ACPI: Battery Slot [BAT0] (battery present)
[    1.409437] input: Power Button (FF) as =
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.409440] ACPI: Power Button (FF) [PWRF]
[    1.409492] input: Sleep Button (CM) as =
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    1.409500] ACPI: Sleep Button (CM) [SLPB]
[    1.409540] input: Lid Switch as =
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    1.416575] ACPI: Lid Switch [LID]
[    1.417345] ACPI: SSDT BFF974D0, 0248 (r1  PmRef  Cpu0Ist     3000 =
INTL 20051117)
[    1.417977] ACPI: SSDT BFF977B0, 0765 (r1  PmRef  Cpu0Cst     3001 =
INTL 20051117)
[    1.418877] Monitor-Mwait will be used to enter C-1 state
[    1.418880] Monitor-Mwait will be used to enter C-3 state
[    1.418892] ACPI: CPU0 (power states: C1[C1] C2[C3])
[    1.418913] processor ACPI_CPU:00: registered as cooling_device0
[    1.418917] ACPI: Processor [P001] (supports 8 throttling states)
[    1.419275] ACPI: SSDT BFF97400, 00CC (r1  PmRef  Cpu1Ist     3000 =
INTL 20051117)
[    1.419753] ACPI: SSDT BFF97720, 0085 (r1  PmRef  Cpu1Cst     3000 =
INTL 20051117)
[    1.420807] ACPI: CPU1 (power states: C1[C1] C2[C3])
[    1.420823] processor ACPI_CPU:01: registered as cooling_device1
[    1.420827] ACPI: Processor [P002] (supports 8 throttling states)
[    1.432467] thermal LNXTHERM:01: registered as thermal_zone0
[    1.434808] ACPI: Thermal Zone [THRM] (58 C)
[    1.457183] Linux agpgart interface v0.103
[    1.457190] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.458137] brd: module loaded
[    1.458422] loop: module loaded
[    1.458481] Fixed MDIO Bus: probed
[    1.458486] PPP generic driver version 2.4.2
[    1.458538] input: Macintosh mouse button emulation as =
/devices/virtual/input/input3
[    1.458562] Driver 'sd' needs updating - please use bus_type methods
[    1.458570] Driver 'sr' needs updating - please use bus_type methods
[    1.458608] ahci 0000:00:1f.2: version 3.0
[    1.458622] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> =
IRQ 19
[    1.458657] ahci 0000:00:1f.2: irq 2298 for MSI/MSI-X
[    1.458729] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps =
0x23 impl SATA mode
[    1.458732] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo =
pio slum part ems=20
[    1.458737] ahci 0000:00:1f.2: setting latency timer to 64
[    1.458946] scsi0 : ahci
[    1.459029] scsi1 : ahci
[    1.459078] scsi2 : ahci
[    1.459126] scsi3 : ahci
[    1.459174] scsi4 : ahci
[    1.459220] scsi5 : ahci
[    1.459433] ata1: SATA max UDMA/133 abar m2048@0xf7fff000 port =
0xf7fff100 irq 2298
[    1.459436] ata2: SATA max UDMA/133 abar m2048@0xf7fff000 port =
0xf7fff180 irq 2298
[    1.459438] ata3: DUMMY
[    1.459439] ata4: DUMMY
[    1.459440] ata5: DUMMY
[    1.459442] ata6: SATA max UDMA/133 abar m2048@0xf7fff000 port =
0xf7fff380 irq 2298
[    1.776018] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.781709] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.781779] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
[    1.781781] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.788539] ata1.00: ATA-8: SAMSUNG HM500LI, 2TF00_00, max UDMA7
[    1.788541] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth =
31/32)
[    1.795958] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    1.796028] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
[    1.796030] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.802792] ata1.00: configured for UDMA/133
[    2.540015] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.542540] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
[    2.544304] ata2.00: ATAPI: MATSHITADVD-RAM UJ870BJ, 1.02, max =
UDMA/33
[    2.547110] ata2.00: ACPI cmd ef/10:06:00:00:00:a0 succeeded
[    2.548887] ata2.00: configured for UDMA/33
[    2.884015] ata6: SATA link down (SStatus 0 SControl 300)
[    2.900090] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM500LI  =
2TF0 PQ: 0 ANSI: 5
[    2.900172] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: =
(500 GB/465 GiB)
[    2.900192] sd 0:0:0:0: [sda] Write Protect is off
[    2.900194] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.900218] sd 0:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    2.900278] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors: =
(500 GB/465 GiB)
[    2.900292] sd 0:0:0:0: [sda] Write Protect is off
[    2.900294] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.900317] sd 0:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[    2.900320]  sda: sda1 sda2 sda3 sda4
[    2.967637] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.967680] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.969452] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ870BJ  =
1.02 PQ: 0 ANSI: 5
[    2.972997] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw =
xa/form2 cdda tray
[    2.973004] Uniform CD-ROM driver Revision: 3.20
[    2.973082] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.973114] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.973700] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) =
Driver
[    2.973720] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) =
-> IRQ 18
[    2.973736] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    2.973739] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    2.973787] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned =
bus number 1
[    2.977705] ehci_hcd 0000:00:1a.7: debug port 1
[    2.977711] ehci_hcd 0000:00:1a.7: cache line size of 32 is not =
supported
[    2.977727] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fffc00
[    2.992008] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.992066] usb usb1: configuration #1 chosen from 1 choice
[    2.992089] hub 1-0:1.0: USB hub found
[    2.992097] hub 1-0:1.0: 6 ports detected
[    2.992202] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) =
-> IRQ 23
[    2.992212] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.992215] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.992250] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned =
bus number 2
[    2.996165] ehci_hcd 0000:00:1d.7: debug port 1
[    2.996171] ehci_hcd 0000:00:1d.7: cache line size of 32 is not =
supported
[    2.996182] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7fff800
[    3.008008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.008063] usb usb2: configuration #1 chosen from 1 choice
[    3.008085] hub 2-0:1.0: USB hub found
[    3.008091] hub 2-0:1.0: 6 ports detected
[    3.008174] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.008190] uhci_hcd: USB Universal Host Controller Interface driver
[    3.008209] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    3.008215] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.008219] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.008258] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned =
bus number 3
[    3.008289] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bc00
[    3.008356] usb usb3: configuration #1 chosen from 1 choice
[    3.008377] hub 3-0:1.0: USB hub found
[    3.008383] hub 3-0:1.0: 2 ports detected
[    3.008459] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) =
-> IRQ 21
[    3.008464] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.008467] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.008502] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned =
bus number 4
[    3.008533] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000b880
[    3.008602] usb usb4: configuration #1 chosen from 1 choice
[    3.008623] hub 4-0:1.0: USB hub found
[    3.008628] hub 4-0:1.0: 2 ports detected
[    3.008703] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) =
-> IRQ 19
[    3.008708] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.008711] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.008748] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned =
bus number 5
[    3.008780] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000b800
[    3.008844] usb usb5: configuration #1 chosen from 1 choice
[    3.008865] hub 5-0:1.0: USB hub found
[    3.008871] hub 5-0:1.0: 2 ports detected
[    3.008949] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) =
-> IRQ 23
[    3.008955] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.008958] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.008996] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned =
bus number 6
[    3.009025] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000b480
[    3.009088] usb usb6: configuration #1 chosen from 1 choice
[    3.009111] hub 6-0:1.0: USB hub found
[    3.009117] hub 6-0:1.0: 2 ports detected
[    3.009189] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) =
-> IRQ 19
[    3.009195] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.009198] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.009240] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned =
bus number 7
[    3.009264] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000b400
[    3.009331] usb usb7: configuration #1 chosen from 1 choice
[    3.009352] hub 7-0:1.0: USB hub found
[    3.009357] hub 7-0:1.0: 2 ports detected
[    3.009431] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) =
-> IRQ 18
[    3.009436] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.009440] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.009479] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned =
bus number 8
[    3.009505] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000b080
[    3.009571] usb usb8: configuration #1 chosen from 1 choice
[    3.009592] hub 8-0:1.0: USB hub found
[    3.009599] hub 8-0:1.0: 2 ports detected
[    3.009723] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at =
0x60,0x64 irq 1,12
[    3.012815] i8042.c: Detected active multiplexing controller, rev =
1.1.
[    3.014920] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.014925] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    3.014927] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    3.014929] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    3.014931] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    3.025039] mice: PS/2 mouse device common for all mice
[    3.073054] rtc_cmos 00:03: RTC can wake from S4
[    3.073084] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.073111] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet =
irqs
[    3.073166] device-mapper: uevent: version 1.0.3
[    3.073247] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) =
initialised: dm-devel@redhat.com
[    3.073316] device-mapper: multipath: version 1.0.5 loaded
[    3.073318] device-mapper: multipath round-robin: version 1.0.0 =
loaded
[    3.073442] cpuidle: using governor ladder
[    3.073516] cpuidle: using governor menu
[    3.073884] TCP cubic registered
[    3.073943] NET: Registered protocol family 10
[    3.074290] lo: Disabled Privacy Extensions
[    3.074548] NET: Registered protocol family 17
[    3.074564] Bluetooth: L2CAP ver 2.11
[    3.074565] Bluetooth: L2CAP socket layer initialized
[    3.074568] Bluetooth: SCO (Voice Link) ver 0.6
[    3.074569] Bluetooth: SCO socket layer initialized
[    3.074597] Bluetooth: RFCOMM socket layer initialized
[    3.074603] Bluetooth: RFCOMM TTY layer initialized
[    3.074605] Bluetooth: RFCOMM ver 1.10
[    3.075401] Marking TSC unstable due to TSC halts in idle
[    3.075495] registered taskstats version 1
[    3.075619]   Magic number: 5:407:546
[    3.075658] mem null: hash matches
[    3.075680] processor ACPI_CPU:01: hash matches
[    3.075723] rtc_cmos 00:03: setting system clock to 2009-08-12 =
19:31:51 UTC (1250105511)
[    3.075726] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.075727] EDD information not available.
[    3.075773] Freeing unused kernel memory: 532k freed
[    3.075971] Write protecting the kernel read-only data: 6688k
[    3.111439] input: AT Translated Set 2 keyboard as =
/devices/platform/i8042/serio0/input/input4
[    3.424933] ohci1394 0000:07:03.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
[    3.430317] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.430334] r8169 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> =
IRQ 17
[    3.430351] r8169 0000:06:00.0: setting latency timer to 64
[    3.430432] r8169 0000:06:00.0: irq 2297 for MSI/MSI-X
[    3.430949] eth0: RTL8168c/8111c at 0xffffc2000007c000, =
00:23:54:4c:38:15, XID 3c4000c0 IRQ 2297
[    3.476763] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=3D[16]  =
MMIO=3D[fdfff800-fdffffff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/4]
[    3.537029] usb 2-1: new high speed USB device using ehci_hcd and =
address 2
[    3.670045] usb 2-1: configuration #1 chosen from 1 choice
[    3.781017] usb 2-2: new high speed USB device using ehci_hcd and =
address 3
[    3.913702] usb 2-2: configuration #1 chosen from 1 choice
[    4.022388] kjournald starting.  Commit interval 5 seconds
[    4.022398] EXT3-fs: mounted filesystem with ordered data mode.
[    4.080072] usb 2-5: new high speed USB device using ehci_hcd and =
address 5
[    4.752148] ieee1394: Host added: ID:BUS[0-00:1023]  =
GUID[001e8c000196f505]
[    4.771176] usb 2-5: configuration #1 chosen from 1 choice
[    5.068057] usb 5-1: new full speed USB device using uhci_hcd and =
address 2
[    5.238902] usb 5-1: configuration #1 chosen from 1 choice
[    5.481041] usb 5-2: new full speed USB device using uhci_hcd and =
address 3
[    5.649895] usb 5-2: configuration #1 chosen from 1 choice
[    5.892050] usb 7-2: new low speed USB device using uhci_hcd and =
address 2
[    6.070360] usb 7-2: configuration #1 chosen from 1 choice
[    6.336051] usb 8-2: new low speed USB device using uhci_hcd and =
address 2
[    6.518978] usb 8-2: configuration #1 chosen from 1 choice
[   10.984338] udev: starting version 141
[   12.118813] nvidia: module license 'NVIDIA' taints kernel.
[   12.371451] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[   12.371468] nvidia 0000:01:00.0: setting latency timer to 64
[   12.372447] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.44  =
Tue Mar 24 05:46:32 PST 2009
[   12.445650] Bluetooth: Generic Bluetooth USB driver ver 0.3
[   12.445742] usbcore: registered new interface driver btusb
[   12.563187] usbcore: registered new interface driver hiddev
[   12.578652] input:   USB Multimedia Keyboard  as =
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input5
[   12.612184] generic-usb 0003:099A:610C.0001: input,hidraw0: USB HID =
v1.00 Keyboard [  USB Multimedia Keyboard ] on usb-0000:00:1d.1-2/input0
[   12.626656] input:   USB Multimedia Keyboard  as =
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input6
[   12.656192] generic-usb 0003:099A:610C.0002: input,hidraw1: USB HID =
v1.00 Device [  USB Multimedia Keyboard ] on usb-0000:00:1d.1-2/input1
[   12.671285] input: Microsoft Microsoft 3-Button Mouse with =
IntelliEye(TM) as =
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input7
[   12.696134] generic-usb 0003:045E:0040.0003: input,hidraw2: USB HID =
v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on =
usb-0000:00:1d.2-2/input0
[   12.696155] usbcore: registered new interface driver usbhid
[   12.696176] usbhid: v2.6:USB HID core driver
[   12.711182] iTCO_vendor_support: vendor-support=3D0
[   12.720370] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   12.720530] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, =
TCOBASE=3D0x0860)
[   12.720611] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   12.738780] sdhci: Secure Digital Host Controller Interface driver
[   12.738782] sdhci: Copyright(c) Pierre Ossman
[   12.780282] sdhci-pci 0000:07:03.1: SDHCI controller found =
[1180:0822] (rev 22)
[   12.780298] sdhci-pci 0000:07:03.1: PCI INT B -> GSI 17 (level, low) =
-> IRQ 17
[   12.781337] sdhci-pci 0000:07:03.1: Will use DMA mode even though HW =
doesn't fully claim to support it.
[   12.783400] mmc0: SDHCI controller on PCI [0000:07:03.1] using DMA
[   12.818258] input: PC Speaker as =
/devices/platform/pcspkr/input/input8
[   13.037077] cfg80211: Calling CRDA to update world regulatory domain
[   13.123374] Linux video capture interface: v2.00
[   13.151371] asus-laptop: Asus Laptop Support version 0.42
[   13.155644] asus-laptop:   N80Vc model detected
[   13.156635] asus-laptop: Brightness ignored, must be controlled by =
ACPI video driver
[   13.317667] cfg80211: World regulatory domain updated:
[   13.317671] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, =
max_eirp)
[   13.317673] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
[   13.317675] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 =
mBm)
[   13.317677] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 =
mBm)
[   13.317679] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
[   13.317681] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 =
mBm)
[   13.353503] acpi device:1e: registered as cooling_device2
[   13.353735] input: Video Bus as =
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/device:1a/input/input=
9
[   13.354891] dvb-usb: found a 'Technotrend TT Connect S2-3650-CI' in =
warm state.
[   13.354897] pctv452e_power_ctrl: 1
[   13.356043] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[   13.356246] DVB: registering new adapter (Technotrend TT Connect =
S2-3650-CI)
[   13.356734] pctv452e: I2C error -121; AA 02  A0 01 14 -> 55 02  A0 00 =
00.
[   13.359742] dvb-usb: MAC address: ffff88013c8270e0
[   13.360066] pctv452e_frontend_attach Enter
[   13.380135] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: =
no)
[   13.384019] uvcvideo: Found UVC 1.00 device USB2.0 UVC PC Camera =
(174f:8a34)
[   13.413529] dvb-usb: found a 'Technotrend TT-connect CT-3650' in warm =
state.
[   13.414130] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[   13.415438] DVB: registering new adapter (Technotrend TT-connect =
CT-3650)
[   13.424684] synaptics was reset on resume, see synaptics_resume_reset =
if you have trouble on resume
[   13.462246] uvcvideo: UVC non compliance - GET_DEF(PROBE) not =
supported. Enabling workaround.
[   13.485379] usbcore: registered new interface driver uvcvideo
[   13.485401] USB Video Class driver (v0.1.0)
[   13.548235] TDA10023: i2c-addr =3D 0x0c, id =3D 0x7d
[   13.548241] DVB: registering adapter 1 frontend 0 (Philips TDA10023 =
DVB-C)...
[   13.568236] stb0899_attach: Attaching STB0899=20
[   13.618440] dvb-usb: will pass the complete MPEG2 transport stream to =
the software demuxer.
[   13.618612] DVB: registering new adapter (Technotrend TT-connect =
CT-3650)
[   13.634941] pctv452e: CI initialized.
[   13.634944] pctv452e_frontend_attach Leave Ok
[   13.634947] DVB: registering adapter 0 frontend 0 (STB0899 =
Multistandard)...
[   13.635012] pctv452e_tuner_attach Enter
[   13.657669] ath9k: 0.1
[   13.657716] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> =
IRQ 17
[   13.657727] ath9k 0000:03:00.0: setting latency timer to 64
[   13.664292] tda10048_establish_defaults() =
tda10048_config.dtv6_if_freq_khz is not set (defaulting to 4300)
[   13.664295] tda10048_establish_defaults() =
tda10048_config.dtv7_if_freq_khz is not set (defaulting to 4300)
[   13.664297] tda10048_establish_defaults() =
tda10048_config.dtv8_if_freq_khz is not set (defaulting to 4300)
[   13.664299] tda10048_establish_defaults() =
tda10048_config.clk_freq_khz is not set (defaulting to 16000)
[   13.664390] stb6100_attach: Attaching STB6100=20
[   13.664392] pctv452e_tuner_attach Leave
[   13.664693] input: IR-receiver inside an USB DVB receiver as =
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/input/input10
[   13.670590] DVB: registering adapter 2 frontend 0 (NXP TDA10048HN =
DVB-T)...
[   13.811823] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) =
-> IRQ 22
[   13.811890] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   13.842812] hda_codec: Unknown model for ALC662, trying auto-probe =
from BIOS...
[   14.091831] phy0: Selected rate control algorithm =
'ath9k_rate_control'
[   14.117141] dvb-usb: schedule remote query interval to 500 msecs.
[   14.117146] pctv452e_power_ctrl: 0
[   14.117148] dvb-usb: Technotrend TT Connect S2-3650-CI successfully =
initialized and connected.
[   14.117177] usbcore: registered new interface driver pctv452e
[   14.117224] usbcore: registered new interface driver =
dvb-usb-tt-connect-s2-3600-01.fw
[   14.146411] Registered led device: ath9k-phy0:radio
[   14.146458] Registered led device: ath9k-phy0:assoc
[   14.146494] Registered led device: ath9k-phy0:tx
[   14.146529] Registered led device: ath9k-phy0:rx
[   14.146990] phy0: Atheros 9280: mem=3D0xffffc20010740000, irq=3D17
[   14.312119] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, =
caps: 0xa04711/0x200000
[   14.354402] input: SynPS/2 Synaptics TouchPad as =
/devices/platform/i8042/serio4/input/input11
[   15.668111] dvb-usb: recv bulk message failed: -110
[   15.668115] ttusb2: there might have been an error during control =
message transfer. (rlen =3D 0, was 0)
[   15.668361] dvb-usb: Technotrend TT-connect CT-3650 successfully =
initialized and connected.
[   15.668397] usbcore: registered new interface driver dvb_usb_ttusb2
[   15.843706] lp: driver loaded but no devices found
[   16.500113] Clocksource tsc unstable (delta =3D -209427918 ns)
[   16.535985] EXT3 FS on sda3, internal journal
[   17.634964] type=3D1505 audit(1250105526.057:2): =
operation=3D"profile_load" =
name=3D"/usr/share/gdm/guest-session/Xsession" name2=3D"default" =
pid=3D2341
[   17.672855] type=3D1505 audit(1250105526.093:3): =
operation=3D"profile_load" name=3D"/sbin/dhclient-script" =
name2=3D"default" pid=3D2345
[   17.672967] type=3D1505 audit(1250105526.093:4): =
operation=3D"profile_load" name=3D"/sbin/dhclient3" name2=3D"default" =
pid=3D2345
[   17.673004] type=3D1505 audit(1250105526.093:5): =
operation=3D"profile_load" =
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" name2=3D"default" =
pid=3D2345
[   17.673041] type=3D1505 audit(1250105526.097:6): =
operation=3D"profile_load" =
name=3D"/usr/lib/connman/scripts/dhclient-script" name2=3D"default" =
pid=3D2345
[   17.778442] type=3D1505 audit(1250105526.201:7): =
operation=3D"profile_load" name=3D"/usr/lib/cups/backend/cups-pdf" =
name2=3D"default" pid=3D2350
[   17.778589] type=3D1505 audit(1250105526.201:8): =
operation=3D"profile_load" name=3D"/usr/sbin/cupsd" name2=3D"default" =
pid=3D2350
[   17.820086] type=3D1505 audit(1250105526.241:9): =
operation=3D"profile_load" name=3D"/usr/sbin/mysqld" name2=3D"default" =
pid=3D2354
[   17.843324] type=3D1505 audit(1250105526.265:10): =
operation=3D"profile_load" name=3D"/usr/sbin/tcpdump" name2=3D"default" =
pid=3D2358
[   28.520452] vboxdrv: Trying to deactivate the NMI watchdog =
permanently...
[   28.520456] vboxdrv: Successfully done.
[   28.520457] vboxdrv: Found 2 processor cores.
[   28.520530] VBoxDrv: dbg - g_abExecMemory=3Dffffffffa0b94b40
[   28.520550] vboxdrv: fAsync=3D0 offMin=3D0x1a4 offMax=3D0x6c2
[   28.520592] vboxdrv: TSC mode is 'synchronous', kernel timer mode is =
'normal'.
[   28.520593] vboxdrv: Successfully loaded version 2.1.4_OSE (interface =
0x000a0009).
[   28.726100] VBoxNetFlt: dbg - g_abExecMemory=3Dffffffffa0d33980
[   35.854791] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   35.854797] Bluetooth: BNEP filters: protocol multicast
[   35.953243] Bridge firewalling registered
[   37.612620] ppdev: user-space parallel port driver
[   41.577880] r8169: eth0: link up
[   41.577888] r8169: eth0: link up
[   41.608220] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   52.073056] eth0: no IPv6 routers present
[   55.347330] pciehp 0000:00:01.0:pcie02: Card present on Slot(16)
[  114.735996] pciehp 0000:00:01.0:pcie02: Card not present on Slot(16)
[  114.748153] pciehp 0000:00:01.0:pcie02: Card present on Slot(16)
[  114.753198] hda-intel: IRQ timing workaround is activated for card =
#0. Suggest a bigger bdl_pos_adj.

------=_NextPart_000_08CF_01CA1BAD.4808D130--


