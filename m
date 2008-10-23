Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bene1.itea.ntnu.no ([129.241.56.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mathieu.taillefumier@free.fr>) id 1Kswir-0005bR-8e
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 11:43:21 +0200
Message-ID: <49004726.4020601@free.fr>
Date: Thu, 23 Oct 2008 11:43:02 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <1223741522.48f0d052c956b@webmail.free.fr>	
	<1223753645.3125.57.camel@palomino.walls.org>
	<1223768859.2706.15.camel@pc10.localdom.local>
In-Reply-To: <1223768859.2706.15.camel@pc10.localdom.local>
Content-Type: multipart/mixed; boundary="------------040802050200060701070403"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 bug in 64 bits system
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
--------------040802050200060701070403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I did not have much time to further investigate the problem but I tried 
again this time with a kernel 2.6.27.2 and the last hg version of the 
drivers. Here is what I get on 64bits a nice oops with NULL pointers. I 
have to do the test in 32bits kernel (with nearly the same 
configuration, and I know it works on this one) to check if the bug is 
reproducible but since there is already a problem with PCI resources 
allocation I think this bug is the consequence of it.

> at least the device is totally death for any i2c stuff, means that Andy
> is right, that it fails on prior PCI stuff already.
>    
I also think that the problem also comes from pci because I have 
troubles to use my wifi card on the same port. (not both at the same 
time of course)
> Coming up by default with a PCI latency of 0 also looks insane.
>
> It is also not reproducible on a recent 2.6.26 _64 quad too.
>    
I do not understand your sentence. Are you able to reproduce the bug 
2.6.26 _64 quad or not.
> [Herman]
>    
> Unload the drivers, put the device out, wait 35 seconds, load the
> drivers again, insert that card and report it is still the same.
>    
It does not work on my sony laptop.

regards

Mathieu

--------------040802050200060701070403
Content-Type: text/plain;
 name="dmesg-64"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-64"

Initializing cgroup subsys cpu
Linux version 2.6.27.2-intel-nogem (root@coesite) (gcc version 4.3.1 (GCC) ) #4 SMP Wed Oct 22 12:05:55 CEST 2008
Command line: ro root=/dev/sda2 vga=ask
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf6d0000 (usable)
 BIOS-e820: 00000000bf6d0000 - 00000000bf6df000 (ACPI NVS)
 BIOS-e820: 00000000bf6df000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbf6d0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 00bf600000 page 2M
 00bf600000 - 00bf6d0000 page 4k
kernel direct mapping tables up to bf6d0000 @ 8000-d000
last_map_addr: bf6d0000 end: bf6d0000
init_memory_mapping
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b000-11000
last_map_addr: 140000000 end: 140000000
DMI present.
ACPI: RSDP 000F76D0, 0024 (r2 PTLTD )
ACPI: XSDT BF6D2287, 009C (r1   Sony     VAIO 20080404 PTL         0)
ACPI: FACP BF6DBBD2, 00F4 (r3   Sony     VAIO 20080404 PTL         1)
ACPI: DSDT BF6D43DF, 777F (r2   Sony     VAIO 20080404 PTL  20050624)
ACPI: FACS BF6DEFC0, 0040
ACPI: APIC BF6DBCC6, 0068 (r1   Sony     VAIO 20080404 PTL        5A)
ACPI: HPET BF6DBD2E, 0038 (r1   Sony     VAIO 20080404 PTL        5A)
ACPI: MCFG BF6DBD66, 003C (r1   Sony     VAIO 20080404 PTL        5A)
ACPI: TCPA BF6DBDA2, 0032 (r1   Sony     VAIO 20080404 PTL      5A52)
ACPI: TMOR BF6DBDD4, 0026 (r1   Sony     VAIO 20080404 PTL         3)
ACPI: SLIC BF6DBDFA, 0176 (r1   Sony     VAIO 20080404 PTL   1000000)
ACPI: APIC BF6DBF70, 0068 (r1   Sony     VAIO 20080404 PTL         0)
ACPI: BOOT BF6DBFD8, 0028 (r1   Sony     VAIO 20080404 PTL         1)
ACPI: SSDT BF6D3D1E, 06C1 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D3610, 070E (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D34EE, 0122 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D28AF, 025F (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D2809, 00A6 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D2323, 04E6 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Sony
(6 early reservations) ==> bootmem [0000000000 - 0140000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000797688]    TEXT DATA BSS ==> [0000200000 - 0000797688]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
  #5 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
found SMP MP-table at [ffff8800000f7700] 000f7700
 [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bf6d0
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1046127
  DMA zone: 2407 pages, LIFO batch:0
  DMA32 zone: 765704 pages, LIFO batch:31
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bf6d0000 - 00000000bf6df000
PM: Registered nosave memory: 00000000bf6df000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
PM: Registered nosave memory: 00000000fed00000 - 00000000fed14000
PM: Registered nosave memory: 00000000fed14000 - 00000000fed1a000
PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 46752 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1026671
Kernel command line: ro root=/dev/sda2 vga=ask
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1994.967 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 4033776k/5242880k available (3146k kernel code, 149828k reserved, 1522k data, 288k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.93 BogoMIPS (lpj=1994967)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
Using local APIC timer interrupts.
APIC timer calibration result 12468543
Detected 12.468 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.80 BogoMIPS (lpj=1994903)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7979.74 BogoMIPS).
khelper used greatest stack depth: 6264 bytes left
net_namespace: 1504 bytes
Time: 11:20:54  Date: 10/23/08
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086/2a00] class 000600 header type 00
pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:02.0: found [8086/2a02] class 000300 header type 00
PCI: 0000:00:02.0 reg 10 64bit mmio: [fc000000, fc0fffff]
PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
PCI: 0000:00:02.0 reg 20 io port: [1800, 1807]
pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:02.1: found [8086/2a03] class 000380 header type 00
PCI: 0000:00:02.1 reg 10 64bit mmio: [fc100000, fc1fffff]
pci 0000:00:02.1: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1a.0: found [8086/2834] class 000c03 header type 00
PCI: 0000:00:1a.0 reg 20 io port: [1820, 183f]
pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1a.1: found [8086/2835] class 000c03 header type 00
PCI: 0000:00:1a.1 reg 20 io port: [1840, 185f]
pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1a.7: found [8086/283a] class 000c03 header type 00
PCI: 0000:00:1a.7 reg 10 32bit mmio: [fc504000, fc5043ff]
pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: found [8086/284b] class 000403 header type 00
PCI: 0000:00:1b.0 reg 10 64bit mmio: [fc500000, fc503fff]
pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: found [8086/283f] class 000604 header type 01
pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: found [8086/2841] class 000604 header type 01
pci 0000:00:1c.1: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: found [8086/2843] class 000604 header type 01
pci 0000:00:1c.2: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: found [8086/2845] class 000604 header type 01
pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: found [8086/2830] class 000c03 header type 00
PCI: 0000:00:1d.0 reg 20 io port: [1860, 187f]
pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1d.1: found [8086/2831] class 000c03 header type 00
PCI: 0000:00:1d.1 reg 20 io port: [1880, 189f]
pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1d.2: found [8086/2832] class 000c03 header type 00
PCI: 0000:00:1d.2 reg 20 io port: [18a0, 18bf]
pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1d.7: found [8086/2836] class 000c03 header type 00
PCI: 0000:00:1d.7 reg 10 32bit mmio: [fc504400, fc5047ff]
pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086/2448] class 000604 header type 01
pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1f.0: found [8086/2815] class 000601 header type 00
pci 0000:00:1f.0: calling quirk_ich6_lpc_acpi+0x0/0x79
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1f.1: found [8086/2850] class 000101 header type 00
PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
PCI: 0000:00:1f.1 reg 20 io port: [1810, 181f]
pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1f.2: found [8086/2828] class 000101 header type 00
PCI: 0000:00:1f.2 reg 10 io port: [1c00, 1c07]
PCI: 0000:00:1f.2 reg 14 io port: [18f4, 18f7]
PCI: 0000:00:1f.2 reg 18 io port: [18f8, 18ff]
PCI: 0000:00:1f.2 reg 1c io port: [18f0, 18f3]
PCI: 0000:00:1f.2 reg 20 io port: [18e0, 18ef]
PCI: 0000:00:1f.2 reg 24 io port: [18d0, 18df]
pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: found [8086/283e] class 000c05 header type 00
PCI: 0000:00:1f.3 reg 10 32bit mmio: [0, ff]
PCI: 0000:00:1f.3 reg 20 io port: [1c20, 1c3f]
pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2b
PCI: Fixups for bus 0000:00
pci 0000:00:1c.0: scanning behind bridge, config 050200, pass 0
PCI: Scanning bus 0000:02
PCI: Fixups for bus 0000:02
PCI: bridge 0000:00:1c.0 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [f6000000, f7ffffff]
PCI: bridge 0000:00:1c.0 64bit mmio pref: [f0000000, f1ffffff]
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:1c.1: scanning behind bridge, config 060600, pass 0
PCI: Scanning bus 0000:06
pci 0000:06:00.0: found [8086/4229] class 000280 header type 00
PCI: 0000:06:00.0 reg 10 64bit mmio: [f8000000, f8001fff]
pci 0000:06:00.0: calling pci_fixup_transparent_bridge+0x0/0x2b
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
PCI: Fixups for bus 0000:06
PCI: bridge 0000:00:1c.1 io port: [3000, 3fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [f8000000, f9ffffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [f2000000, f3ffffff]
PCI: Bus scan for 0000:06 returning with max=06
pci 0000:00:1c.2: scanning behind bridge, config 070700, pass 0
PCI: Scanning bus 0000:07
pci 0000:07:00.0: found [11ab/4363] class 000200 header type 00
PCI: 0000:07:00.0 reg 10 64bit mmio: [fa000000, fa003fff]
PCI: 0000:07:00.0 reg 18 io port: [4000, 40ff]
PCI: 0000:07:00.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:07:00.0: supports D1
pci 0000:07:00.0: supports D2
pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:07:00.0: PME# disabled
PCI: Fixups for bus 0000:07
PCI: bridge 0000:00:1c.2 io port: [4000, 4fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [fa000000, fbffffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [f4000000, f5ffffff]
PCI: Bus scan for 0000:07 returning with max=07
pci 0000:00:1c.3: scanning behind bridge, config 080800, pass 0
PCI: Scanning bus 0000:08
PCI: Fixups for bus 0000:08
PCI: bridge 0000:00:1c.3 io port: [5000, 5fff]
PCI: bridge 0000:00:1c.3 32bit mmio: [c8000000, c9ffffff]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [cc000000, cdffffff]
PCI: Bus scan for 0000:08 returning with max=08
pci 0000:00:1e.0: scanning behind bridge, config 0a0900, pass 0
PCI: Scanning bus 0000:09
pci 0000:09:04.0: found [104c/8039] class 000607 header type 02
PCI: 0000:09:04.0 reg 10 32bit mmio: [fc204000, fc204fff]
pci 0000:09:04.0: supports D1
pci 0000:09:04.0: supports D2
pci 0000:09:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:09:04.0: PME# disabled
pci 0000:09:04.1: found [104c/803a] class 000c00 header type 00
PCI: 0000:09:04.1 reg 10 32bit mmio: [fc206000, fc2067ff]
PCI: 0000:09:04.1 reg 14 32bit mmio: [fc200000, fc203fff]
pci 0000:09:04.1: supports D1
pci 0000:09:04.1: supports D2
pci 0000:09:04.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:09:04.1: PME# disabled
pci 0000:09:04.2: found [104c/803b] class 000180 header type 00
PCI: 0000:09:04.2 reg 10 32bit mmio: [fc205000, fc205fff]
pci 0000:09:04.2: supports D1
pci 0000:09:04.2: supports D2
pci 0000:09:04.2: PME# supported from D0 D1 D2 D3hot
pci 0000:09:04.2: PME# disabled
PCI: Fixups for bus 0000:09
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [fc200000, fc2fffff]
pci 0000:09:04.0: scanning behind bridge, config 0a0a09, pass 0
pci 0000:09:04.0: scanning behind bridge, config 0a0a09, pass 1
PCI: Bus #0a (-#0d) is partially hidden behind transparent bridge #09 (-#0a)
PCI: Bus scan for 0000:09 returning with max=0d
pci 0000:00:1c.0: scanning behind bridge, config 050200, pass 1
pci 0000:00:1c.1: scanning behind bridge, config 060600, pass 1
pci 0000:00:1c.2: scanning behind bridge, config 070700, pass 1
pci 0000:00:1c.3: scanning behind bridge, config 080800, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 0a0900, pass 1
PCI: Bus scan for 0000:00 returning with max=0d
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
ACPI: RTC can wake from S4
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:07: ioport range 0x680-0x69f has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x1000-0x107f has been reserved
system 00:07: ioport range 0x1180-0x11bf has been reserved
system 00:07: ioport range 0x1640-0x164f has been reserved
system 00:07: ioport range 0xfe00-0xfe00 has been reserved
pci 0000:00:1f.3: BAR 0: got res [0xc2000000-0xc20000ff] bus [0xc2000000-0xc20000ff] flags 0x20200
pci 0000:00:1f.3: BAR 0: moved to bus [0xc2000000-0xc20000ff] flags 0x20200
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000f0000000-0x000000f1ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
pci 0000:00:1c.1:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000f2000000-0x000000f3ffffff
pci 0000:07:00.0: BAR 6: got res [0xf4000000-0xf401ffff] bus [0xf4000000-0xf401ffff] flags 0x27200
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:07
pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
pci 0000:00:1c.2:   MEM window: 0xfa000000-0xfbffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000f4000000-0x000000f5ffffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.3:   IO window: 0x5000-0x5fff
pci 0000:00:1c.3:   MEM window: 0xc8000000-0xc9ffffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000cc000000-0x000000cdffffff
pci 0000:09:04.0: CardBus bridge, secondary bus 0000:0a
pci 0000:09:04.0:   IO window: 0x006000-0x0060ff
pci 0000:09:04.0:   IO window: 0x006400-0x0064ff
pci 0000:09:04.0:   PREFETCH window: 0xc4000000-0xc7ffffff
pci 0000:09:04.0:   MEM window: 0x140000000-0x143ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
pci 0000:00:1e.0:   IO window: 0x6000-0x6fff
pci 0000:00:1e.0:   MEM window: 0xfc200000-0xfc2fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c4000000-0x000000c7ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:09:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 02 index 0 io port: [2000, 2fff]
bus: 02 index 1 mmio: [f6000000, f7ffffff]
bus: 02 index 2 mmio: [f0000000, f1ffffff]
bus: 02 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [3000, 3fff]
bus: 06 index 1 mmio: [f8000000, f9ffffff]
bus: 06 index 2 mmio: [f2000000, f3ffffff]
bus: 06 index 3 mmio: [0, 0]
bus: 07 index 0 io port: [4000, 4fff]
bus: 07 index 1 mmio: [fa000000, fbffffff]
bus: 07 index 2 mmio: [f4000000, f5ffffff]
bus: 07 index 3 mmio: [0, 0]
bus: 08 index 0 io port: [5000, 5fff]
bus: 08 index 1 mmio: [c8000000, c9ffffff]
bus: 08 index 2 mmio: [cc000000, cdffffff]
bus: 08 index 3 mmio: [0, 0]
bus: 09 index 0 io port: [6000, 6fff]
bus: 09 index 1 mmio: [fc200000, fc2fffff]
bus: 09 index 2 mmio: [c4000000, c7ffffff]
bus: 09 index 3 io port: [0, ffff]
bus: 09 index 4 mmio: [0, ffffffffffffffff]
bus: 0a index 0 io port: [6000, 60ff]
bus: 0a index 1 io port: [6400, 64ff]
bus: 0a index 2 mmio: [c4000000, c7ffffff]
bus: 0a index 3 mmio: [140000000, 143ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x36 set to 0x1
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
audit: initializing netlink socket (disabled)
type=2000 audit(1224760854.198:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
fuse init (API version 7.9)
msgmni has been set to 7880
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:00.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:02.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:02.0: Boot video device
pci 0000:00:02.1: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:02.1: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1c.1: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1c.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1c.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1c.1: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1c.2: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1c.2: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1c.2: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1c.2: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1f.1: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xbf
pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xbf
pci 0000:06:00.0: calling quirk_e100_interrupt+0x0/0x1ce
pci 0000:06:00.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:06:00.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:06:00.0: calling pci_fixup_video+0x0/0xbf
pci 0000:07:00.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:07:00.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:07:00.0: calling pci_fixup_video+0x0/0xbf
pci 0000:09:04.0: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:09:04.0: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:09:04.0: calling pci_fixup_video+0x0/0xbf
pci 0000:09:04.1: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:09:04.1: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:09:04.1: calling pci_fixup_video+0x0/0xbf
pci 0000:09:04.2: calling quirk_cardbus_legacy+0x0/0x30
pci 0000:09:04.2: calling quirk_usb_early_handoff+0x0/0x480
pci 0000:09:04.2: calling pci_fixup_video+0x0/0xbf
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID0]
ACPI: SSDT BF6D31AC, 027A (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D2B0E, 0619 (r1   Sony     VAIO 20080404 PTL  20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BF6D3426, 00C8 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: SSDT BF6D3127, 0085 (r1   Sony     VAIO 20080404 PTL  20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [ATF0] (52 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [DTS0] (52 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [DTS1] (54 C)
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected 7676K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
loop: module loaded
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata1.00: ATAPI: SONY    DVD RW AW-G910A, 1.71, max UDMA/33
ata1.00: configured for UDMA/33
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
scsi 0:0:0:0: CD-ROM            SONY     DVD RW AW-G910A  1.71 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x1c00 ctl 0x18f4 bmdma 0x18e0 irq 22
ata4: SATA max UDMA/133 cmd 0x18f8 ctl 0x18f0 bmdma 0x18e8 irq 22
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7: TOSHIBA MK1637GSX, DL030G, max UDMA/100
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
ata4: SATA link down (SStatus 0 SControl 0)
scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK1637GS DL03 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 > sda4
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input3
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input4
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Marking TSC unstable due to TSC halts in idle
  Magic number: 12:190:328
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 288k freed
Write protecting the kernel read-only data: 4412k
khelper used greatest stack depth: 5464 bytes left
stty used greatest stack depth: 4032 bytes left
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
nvidia: module license 'NVIDIA' taints kernel.
NVRM: No NVIDIA graphics adapter found!
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
udev: starting version 130
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
sony-laptop: Sony Programmable IO Control Driver v0.6.
sony-laptop: detected Type4 model
input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3b/SNY6001:00/input/input5
input: Sony Vaio Jogdial as /devices/virtual/input/input6
sony-laptop: Sony Notebook Control Driver v0.6.
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.2-intel-nogem uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 20, io base 0x00001840
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
iwlagn: Copyright(c) 2003-2008 Intel Corporation
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.2-intel-nogem uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.2-intel-nogem uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 23, io base 0x00001880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.2-intel-nogem uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 23, io base 0x000018a0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.2-intel-nogem uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.2
sky2 0000:07:00.0: power state changed by ACPI to D0
sky2 0000:07:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:07:00.0: setting latency timer to 64
sky2 0000:07:00.0: v1.22 addr 0xfa000000 irq 18 Yukon-2 EC Ultra rev 3
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ACPI: I/O resource 0000:00:1f.3 [0x1c20-0x1c3f] conflicts with ACPI region SMBI [0x1c20-0x1c2f]
ACPI: Device needs an ACPI driver
sky2 eth0: addr 00:1a:80:5c:5f:f3
tifm_7xx1 0000:09:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
iwlagn 0000:06:00.0: power state changed by ACPI to D0
iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:06:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
iwlagn 0000:06:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
Yenta: CardBus bridge found at 0000:09:04.0 [104d:9008]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:09:04.0, mfunc 0x01a21b22, devctl 0x64
Yenta: ISA IRQ mask 0x0cb8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#09) from #0a to #0d
pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
pcmcia: parent PCI bridge Memory window: 0xfc200000 - 0xfc2fffff
pcmcia: parent PCI bridge Memory window: 0xc4000000 - 0xc7ffffff
ohci1394 0000:09:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[fc206000-fc2067ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Adding 1959888k swap on /dev/sda1.  Priority:-1 extents:1 across:1959888k
fsck.ext3 used greatest stack depth: 3984 bytes left
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[080046030298eee2]
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
rc used greatest stack depth: 3704 bytes left
sky2 eth0: enabling interface
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
NET: Registered protocol family 10
pccard: CardBus card inserted into slot 0
pci 0000:0a:00.0: found [1131/7133] class 000480 header type 00
PCI: 0000:0a:00.0 reg 10 32bit mmio: [0, 7ff]
pci 0000:0a:00.0: supports D1
pci 0000:0a:00.0: supports D2
pci 0000:0a:00.0: BAR 0: got res [0x140000000-0x1400007ff] bus [0x140000000-0x1400007ff] flags 0x20200
pci 0000:0a:00.0: BAR 0: moved to bus [0x140000000-0x1400007ff] flags 0x20200
saa7134 0000:0a:00.0: enabling device (0000 -> 0002)
saa7134 0000:0a:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
saa7133[0]: found at 0000:0a:00.0, rev: 209, irq: 20, latency: 0, mmio: 0x140000000
saa7134 0000:0a:00.0: enabling bus mastering
saa7134 0000:0a:00.0: setting latency timer to 64
saa7133[0]: subsystem: 153b:1172, board: Terratec Cinergy HT PCMCIA [card=105,autodetected]
saa7133[0]: board init: gpio is ffffffff
saa7133[0]/core: hwinit1
saa7133[0]: gpio: mode=0xfffffff in=0x0000000 out=0xfffffff [pre-init]
saa7133[0]/irq[0,4294699388]: r=0xffffffff s=0xffffffff DONE_RA0 DONE_RA1 DONE_RA2 DONE_RA3 AR PE PWR_ON RDCAP INTL FIDT MMC TRIG_ERR CONF_ERR LOAD_ERR GPIO16? GPIO18 GPIO22 GPIO23 | RA0=vbi,b,odd,15
BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
IP: [<ffffffffa00f5d27>] mute_input_7133+0x17/0x120 [saa7134]
PGD 13e1ad067 PUD 13e1ae067 PMD 0 
Oops: 0000 [1] SMP 
CPU 0 
Modules linked in: ipv6 ohci1394 yenta_socket iwlagn i2c_i801 rsrc_nonstatic tifm_7xx1 iwlcore ieee1394 pcmcia_core tifm_core sky2 sony_laptop uhci_hcd rfkill mac80211 usbcore saa7134 ir_common compat_ioctl32 videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core tveeprom snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd soundcore
Pid: 1205, comm: pccardd Tainted: P          2.6.27.2-intel-nogem #4
RIP: 0010:[<ffffffffa00f5d27>]  [<ffffffffa00f5d27>] mute_input_7133+0x17/0x120 [saa7134]
RSP: 0018:ffff88013bd5bbc0  EFLAGS: 00010086
RAX: 0000000000000000 RBX: ffff88013b503000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000000000ff RDI: ffff88013b503000
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000002
R10: ffffffff80735360 R11: 0000000080734f60 R12: 00000000000000ff
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff8069d380(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000000000c CR3: 000000013e1ac000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pccardd (pid: 1205, threadinfo ffff88013bd5a000, task ffff88013e0774e0)
Stack:  0000003000000030 ffff88013b503000 0000000000000040 ffffffffa00f9f74
 00000000ffffffff ffff88013b503000 00000000ffffffff ffffffffa00f30ca
 ffff88013b503170 ffffffff802117dd ffff88013b503170 0000000000000202
Call Trace:
 [<ffffffffa00f9f74>] ? saa7134_irq_video_signalchange+0x74/0x1b0 [saa7134]
 [<ffffffffa00f30ca>] ? saa7134_irq+0x16a/0x3b0 [saa7134]
 [<ffffffff802117dd>] ? dma_alloc_coherent+0x20d/0x2f0
 [<ffffffffa00f2f60>] ? saa7134_irq+0x0/0x3b0 [saa7134]
 [<ffffffff802806a1>] ? request_irq+0xf1/0x130
 [<ffffffffa00fceab>] ? saa7134_initdev+0x46b/0x9b7 [saa7134]
 [<ffffffff803a96dc>] ? pci_device_probe+0x7c/0xa0
 [<ffffffff8040ad4e>] ? driver_probe_device+0x9e/0x1d0
 [<ffffffff8040af10>] ? __device_attach+0x0/0x10
 [<ffffffff8040a19b>] ? bus_for_each_drv+0x5b/0x80
 [<ffffffff8040afe8>] ? device_attach+0x88/0x90
 [<ffffffff80409f75>] ? bus_attach_device+0x55/0xa0
 [<ffffffff80408bd0>] ? device_add+0x510/0x610
 [<ffffffff803a44cd>] ? pci_bus_add_device+0x1d/0x50
 [<ffffffff803a453f>] ? pci_bus_add_devices+0x3f/0x1e0
 [<ffffffffa019965d>] ? cb_alloc+0xbd/0xd4 [pcmcia_core]
 [<ffffffffa01957f1>] ? socket_insert+0xd1/0xf0 [pcmcia_core]
 [<ffffffffa019623b>] ? pccardd+0x24b/0x2d0 [pcmcia_core]
 [<ffffffffa0195ff0>] ? pccardd+0x0/0x2d0 [pcmcia_core]
 [<ffffffff802532e7>] ? kthread+0x47/0x90
 [<ffffffff8023a707>] ? schedule_tail+0x27/0x70
 [<ffffffff8020c889>] ? child_rip+0xa/0x11
 [<ffffffff802532a0>] ? kthread+0x0/0x90
 [<ffffffff8020c87f>] ? child_rip+0x0/0x11


Code: 48 c7 c7 b8 0d 10 a0 31 c0 e8 f2 6e 41 e0 e9 0f ff ff ff 90 55 31 d2 53 bd 02 00 00 00 48 83 ec 08 48 89 fb 48 8b 87 70 0a 00 00 <8b> 40 0c 83 f8 01 74 11 0f 83 db 00 00 00 31 ed ba 03 00 00 00 
RIP  [<ffffffffa00f5d27>] mute_input_7133+0x17/0x120 [saa7134]
 RSP <ffff88013bd5bbc0>
CR2: 000000000000000c
---[ end trace 275dd20e4ce73791 ]---

--------------040802050200060701070403
Content-Type: application/gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
--------------040802050200060701070403
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040802050200060701070403--
