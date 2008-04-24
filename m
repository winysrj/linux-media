Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OIiXqd024585
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:44:33 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OIiEv4025959
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 14:44:15 -0400
Message-ID: <4810D4EA.409@linuxtv.org>
From: mkrufky@linuxtv.org
To: greg@kroah.com
Date: Thu, 24 Apr 2008 14:43:54 -0400
MIME-Version: 1.0
in-reply-to: <20080424182147.GA28661@kroah.com>
Content-Type: multipart/mixed; boundary="----_=_NextPart_000_01C8A63A.BE3C5C80"
Cc: video4linux-list@redhat.com, kristen.c.accardi@intel.com
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C8A63A.BE3C5C80
Content-Type: text/plain;
	charset="iso-8859-1"

Greg KH wrote:
> On Thu, Apr 24, 2008 at 02:10:47PM -0400, mkrufky@linuxtv.org wrote:
>   
>> Greg KH wrote:
>>     
>>> On Thu, Apr 24, 2008 at 10:40:24AM -0400, Michael Krufky wrote:
>>>   
>>>       
>>>> On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
>>>>     
>>>>         
>>>>> While not exactly the same, this bug MAY be related to my hot swap
>>>>>           
>> poblem:
>>     
>> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519
>>     
>>>>>       
>>>>>           
>>>> No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
>>>> entirely irrelevant.
>>>>
>>>> The problem is PCIe hotplugging  -- it doesn't work in Linux, at
>>>> least, not with Expresscards.  This issue is not specific to the
>>>> HVR1500 -- you'll see it on other similar Expresscards as well.
>>>>     
>>>>         
>>> Huh?  We had expresscard hotplugging working in Linux before any other
>>> operating system ever did.  It works for me just fine here on many
>>> machines, and does so for many thousands of users.
>>>
>>>   
>>>       
>>>> I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
>>>> it is installed in the system when I boot up the PC.  Inserting it
>>>> after boot does absolutely nothing, and removing it after you booted
>>>> the system with it installed will leave the system unstable.
>>>>     
>>>>         
>>> Have you actually loaded the pci hotplug controller driver that is
>>> needed to get hotplugging of express cards to work properly?  :)
>>>   
>>>       
>> This is what I see upon insertion of an HVR1500 with pciehp loaded:
>>
>> [  122.798217] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 ss_did
0
>> [  122.798457] Evaluate _OSC Set fails. Status = 0x0005
>> [  122.798492] Evaluate _OSC Set fails. Status = 0x0005
>> [  122.798514] pciehp: Cannot get control of hotplug hardware for pci
0000:00:01.0
>> [  122.798662] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 ss_did
0
>> [  122.798705] Evaluate _OSC Set fails. Status = 0x0005
>> [  122.798735] Evaluate _OSC Set fails. Status = 0x0005
>> [  122.798758] pciehp: Cannot get control of hotplug hardware for pci
0000:00:1c.0
>>     
>
> This really looks like your BIOS does not support PCI Hotplug of your
> express cards.
>
> But I'm adding Kristen to the CC: as she is the PCI Hotplug maintainer
> of the kernel, and she knows this way better than I do.
>
> Also, have you tried the acpiphp driver?  That might be the one your
> hardware needs instead.
>
> thanks,
>
> greg k-h
>   
acpiphp gives me the following:

[  264.251609] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[  264.282563] acpiphp_glue: can't get bus number, assuming 0
[  264.282729] decode_hpp: Could not get hotplug parameters. Use defaults
[  264.282783] acpiphp: Slot [1] registered
[  265.125349] cx23885 driver version 0.0.1 loaded

I loaded the cx23885 driver, but it did not pick up on the hardware, nor 
do I see the expresscard listed in lspci.

The BIOS on my laptop definitely does support hotplug of my 
expresscards.  It works in Windows Vista (yuck)

To get a better idea about my Dell Latitude D830 laptop configuration, 
I've included full dmesg dump (please see attached)

Thank you for looking into this.

Regards,

Mike


------_=_NextPart_000_01C8A63A.BE3C5C80
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

[    0.000000] Linux version 2.6.22-14-generic (buildd@king) (gcc =
version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP =
Tue Feb 12 02:46:46 UTC 2008 (Ubuntu 2.6.22-14.52-generic)
[    0.000000] Command line: =
root=3DUUID=3D7e14049f-e649-4bf3-a0ac-19849626e313 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 =
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fe80400 (usable)
[    0.000000]  BIOS-e820: 000000007fe80400 - 0000000080000000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 =
(reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 =
(reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 256, 523904) 1 entries of =
3200 used
[    0.000000] end_pfn_map =3D 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP signature @ 0xFFFF8100000FBB00 checksum 0
[    0.000000] ACPI: RSDP 000FBB00, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 7FE81E00, 0064 (r1 DELL    M08     27D70607 =
ASL        61)
[    0.000000] ACPI: FACP 7FE81C9C, 00F4 (r4 DELL    M08     27D70607 =
ASL        61)
[    0.000000] ACPI: DSDT 7FE82400, 63C0 (r2 INT430 SYSFexxx     1001 =
INTL 20050624)
[    0.000000] ACPI: FACS 7FE90C00, 0040
[    0.000000] ACPI: HPET 7FE81F00, 0038 (r1 DELL    M08            1 =
ASL        61)
[    0.000000] ACPI: APIC 7FE82000, 0068 (r1 DELL    M08     27D70607 =
ASL        47)
[    0.000000] ACPI: ASF! 7FE81C00, 007E (r32 DELL    M08     27D70607 =
ASL        61)
[    0.000000] ACPI: MCFG 7FE81FC0, 003E (r16 DELL    M08     27D70607 =
ASL        61)
[    0.000000] ACPI: SLIC 7FE8209C, 0176 (r1 DELL    M08     27D70607 =
ASL        61)
[    0.000000] ACPI: TCPA 7FE82300, 0032 (r1                        0 =
ASL         0)
[    0.000000] ACPI: SSDT 7FE806EF, 04CC (r1  PmRef    CpuPm     3000 =
INTL 20050624)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007fe80000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 3200 =
used
[    0.000000] Entering add_active_range(0, 256, 523904) 1 entries of =
3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-000000007fe80000
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   523904
[    0.000000] On node 0 totalpages: 523807
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1125 pages reserved
[    0.000000]   DMA zone: 2818 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7106 pages used for memmap
[    0.000000]   DMA32 zone: 512702 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high =
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] swsusp: Registered nosave memory region: =
000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: =
00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: =
80000000:74000000)
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34696 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 515520
[    0.000000] Kernel command line: =
root=3DUUID=3D7e14049f-e649-4bf3-a0ac-19849626e313 ro quiet splash
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[   17.924002] time.c: Detected 1995.001 MHz processor.
[   17.926557] Console: colour VGA+ 80x25
[   17.926574] Checking aperture...
[   17.926586] Calgary: detecting Calgary via BIOS EBDA area
[   17.926588] Calgary: Unable to locate Rio Grande table in EBDA - =
bailing!
[   17.946403] Memory: 2054676k/2095616k available (2274k kernel code, =
40552k reserved, 1185k data, 296k init)
[   17.946445] SLUB: Genslabs=3D23, HWalign=3D64, Order=3D0-1, =
MinObjects=3D4, CPUs=3D2, Nodes=3D1
[   18.025820] Calibrating delay using timer specific routine.. 3994.55 =
BogoMIPS (lpj=3D7989109)
[   18.025850] Security Framework v1.0.0 initialized
[   18.025857] SELinux:  Disabled at boot.
[   18.026054] Dentry cache hash table entries: 262144 (order: 9, =
2097152 bytes)
[   18.027279] Inode-cache hash table entries: 131072 (order: 8, =
1048576 bytes)
[   18.027864] Mount-cache hash table entries: 256
[   18.027994] CPU: L1 I cache: 32K, L1 D cache: 32K
[   18.027998] CPU: L2 cache: 4096K
[   18.028000] CPU 0/0 -> Node 0
[   18.028002] using mwait in idle threads.
[   18.028004] CPU: Physical Processor ID: 0
[   18.028005] CPU: Processor Core ID: 0
[   18.028011] CPU0: Thermal monitoring enabled (TM2)
[   18.028021] SMP alternatives: switching to UP code
[   18.028271] Early unpacking initramfs... done
[   18.359216] ACPI: Core revision 20070126
[   18.359259] ACPI: Looking for DSDT in initramfs... error, file =
/DSDT.aml not found.
[   18.404648] Using local APIC timer interrupts.
[   18.454749] result 12468753
[   18.454750] Detected 12.468 MHz APIC timer.
[   18.457629] SMP alternatives: switching to SMP code
[   18.457706] Booting processor 1/2 APIC 0x1
[   18.468205] Initializing CPU#1
[   18.545528] Calibrating delay using timer specific routine.. 3990.08 =
BogoMIPS (lpj=3D7980171)
[   18.545534] CPU: L1 I cache: 32K, L1 D cache: 32K
[   18.545536] CPU: L2 cache: 4096K
[   18.545538] CPU 1/1 -> Node 0
[   18.545540] CPU: Physical Processor ID: 0
[   18.545541] CPU: Processor Core ID: 1
[   18.545547] CPU1: Thermal monitoring enabled (TM2)
[   18.546038] Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping =
0a
[   18.546125] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   18.569527] Brought up 2 CPUs
[   18.644019] migration_cost=3D11
[   18.644180] NET: Registered protocol family 16
[   18.644252] ACPI: bus type pci registered
[   18.644259] PCI: Using configuration type 1
[   18.651112] ACPI: EC: Look up EC in DSDT
[   18.712285] ACPI: SSDT 7FE90C80, 0043 (r1  LMPWR  DELLLOM     1001 =
INTL 20050624)
[   18.712452] ACPI: Interpreter enabled
[   18.712455] ACPI: (supports S0 S3 S4 S5)
[   18.712470] ACPI: Using IOAPIC for interrupt routing
[   18.757163] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   18.757173] PCI: Probing PCI hardware (bus 00)
[   18.759216] PCI: Transparent bridge - 0000:00:1e.0
[   18.759374] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   18.759844] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[   18.760010] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[   18.760107] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[   18.760228] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[   18.760347] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[   18.760465] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[   18.777109] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *5
[   18.777218] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *10
[   18.777313] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 11) *0, =
disabled.
[   18.777445] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[   18.777553] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 =
12 14 15)
[   18.777661] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 =
12 14 15)
[   18.777768] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 =
12 14 15)
[   18.777865] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 =
12 14 15) *0, disabled.
[   18.777972] Linux Plug and Play Support v0.97 (c) Adam Belay
[   18.777982] pnp: PnP ACPI init
[   18.777990] ACPI: bus type pnp registered
[   18.836418] pnp: PnP ACPI: found 14 devices
[   18.836420] ACPI: ACPI bus type pnp unregistered
[   18.836462] PCI: Using ACPI for IRQ routing
[   18.836464] PCI: If a device doesn't work, try "pci=3Drouteirq".  If =
it helps, post a report
[   18.836614] NET: Registered protocol family 8
[   18.836616] NET: Registered protocol family 20
[   18.836630] PCI-GART: No AMD northbridge found.
[   18.836636] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   18.836640] hpet0: 3 64-bit timers, 14318180 Hz
[   18.837685] pnp: 00:05: ioport range 0xc80-0xcaf has been reserved
[   18.837688] pnp: 00:05: ioport range 0xcc0-0xcff could not be =
reserved
[   18.837693] pnp: 00:08: iomem range 0xfed00000-0xfed003ff has been =
reserved
[   18.837698] pnp: 00:0a: ioport range 0xcb0-0xcbb has been reserved
[   18.837701] pnp: 00:0a: iomem range 0xfed40000-0xfed44fff could not =
be reserved
[   18.837707] pnp: 00:0b: ioport range 0x900-0x97f has been reserved
[   18.837709] pnp: 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[   18.837712] pnp: 00:0b: ioport range 0x1000-0x1005 has been reserved
[   18.837714] pnp: 00:0b: ioport range 0x1008-0x100f has been reserved
[   18.837718] pnp: 00:0c: ioport range 0xf400-0xf4fe has been reserved
[   18.837721] pnp: 00:0c: ioport range 0x1006-0x1007 has been reserved
[   18.837723] pnp: 00:0c: ioport range 0x100a-0x1059 could not be =
reserved
[   18.837726] pnp: 00:0c: ioport range 0x1060-0x107f has been reserved
[   18.837728] pnp: 00:0c: ioport range 0x1080-0x10bf has been reserved
[   18.837731] pnp: 00:0c: ioport range 0x10c0-0x10df has been reserved
[   18.837733] pnp: 00:0c: ioport range 0x1010-0x102f has been reserved
[   18.837737] pnp: 00:0d: iomem range 0x0-0x9efff could not be =
reserved
[   18.837740] pnp: 00:0d: iomem range 0x9f000-0x9ffff could not be =
reserved
[   18.837742] pnp: 00:0d: iomem range 0xc0000-0xcffff has been =
reserved
[   18.837745] pnp: 00:0d: iomem range 0xe0000-0xfffff has been =
reserved
[   18.838003] PCI: Bridge: 0000:00:01.0
[   18.838006]   IO window: e000-efff
[   18.838010]   MEM window: fa000000-feafffff
[   18.838013]   PREFETCH window: e0000000-efffffff
[   18.838016] PCI: Bridge: 0000:00:1c.0
[   18.838017]   IO window: disabled.
[   18.838023]   MEM window: disabled.
[   18.838027]   PREFETCH window: disabled.
[   18.838033] PCI: Bridge: 0000:00:1c.1
[   18.838034]   IO window: disabled.
[   18.838040]   MEM window: f9f00000-f9ffffff
[   18.838044]   PREFETCH window: disabled.
[   18.838050] PCI: Bridge: 0000:00:1c.3
[   18.838053]   IO window: d000-dfff
[   18.838059]   MEM window: f9c00000-f9efffff
[   18.838064]   PREFETCH window: f0000000-f01fffff
[   18.838069] PCI: Bridge: 0000:00:1c.5
[   18.838071]   IO window: disabled.
[   18.838077]   MEM window: f9b00000-f9bfffff
[   18.838081]   PREFETCH window: disabled.
[   18.838093] PCI: Bus 4, cardbus bridge: 0000:03:01.0
[   18.838094]   IO window: 00002000-000020ff
[   18.838099]   IO window: 00002400-000024ff
[   18.838104]   PREFETCH window: 88000000-8bffffff
[   18.838110]   MEM window: 8c000000-8fffffff
[   18.838115] PCI: Bridge: 0000:00:1e.0
[   18.838118]   IO window: 2000-2fff
[   18.838124]   MEM window: f9a00000-f9afffff
[   18.838128]   PREFETCH window: 88000000-8bffffff
[   18.838143] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, =
low) -> IRQ 16
[   18.838148] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   18.838170] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, =
low) -> IRQ 16
[   18.838176] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   18.838199] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, =
low) -> IRQ 17
[   18.838205] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   18.838228] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, =
low) -> IRQ 19
[   18.838234] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   18.838256] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, =
low) -> IRQ 17
[   18.838262] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   18.838276] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   18.838293] PCI: Enabling device 0000:03:01.0 (0000 -> 0003)
[   18.838296] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, =
low) -> IRQ 19
[   18.838311] NET: Registered protocol family 2
[   18.841367] Time: tsc clocksource has been installed.
[   18.877411] IP route cache hash table entries: 65536 (order: 7, =
524288 bytes)
[   18.878072] TCP established hash table entries: 262144 (order: 10, =
6291456 bytes)
[   18.880647] TCP bind hash table entries: 65536 (order: 8, 1048576 =
bytes)
[   18.881207] TCP: Hash tables configured (established 262144 bind =
65536)
[   18.881209] TCP reno registered
[   18.893477] checking if image is initramfs... it is
[   19.546316] Freeing initrd memory: 7199k freed
[   19.549865] audit: initializing netlink socket (disabled)
[   19.549884] audit(1209045280.568:1): initialized
[   19.551651] VFS: Disk quotas dquot_6.5.1
[   19.551695] Dquot-cache hash table entries: 512 (order 0, 4096 =
bytes)
[   19.551773] io scheduler noop registered
[   19.551775] io scheduler anticipatory registered
[   19.551777] io scheduler deadline registered
[   19.551856] io scheduler cfq registered (default)
[   19.555700] Boot video device is 0000:01:00.0
[   19.555820] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   19.555853] assign_interrupt_mode Found MSI capability
[   19.555856] Allocate Port Service[0000:00:01.0:pcie00]
[   19.555888] Allocate Port Service[0000:00:01.0:pcie02]
[   19.555957] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   19.556015] assign_interrupt_mode Found MSI capability
[   19.556017] Allocate Port Service[0000:00:1c.0:pcie00]
[   19.556041] Allocate Port Service[0000:00:1c.0:pcie02]
[   19.556134] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   19.556192] assign_interrupt_mode Found MSI capability
[   19.556193] Allocate Port Service[0000:00:1c.1:pcie00]
[   19.556220] Allocate Port Service[0000:00:1c.1:pcie02]
[   19.556313] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   19.556371] assign_interrupt_mode Found MSI capability
[   19.556373] Allocate Port Service[0000:00:1c.3:pcie00]
[   19.556399] Allocate Port Service[0000:00:1c.3:pcie02]
[   19.556494] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[   19.556552] assign_interrupt_mode Found MSI capability
[   19.556554] Allocate Port Service[0000:00:1c.5:pcie00]
[   19.556581] Allocate Port Service[0000:00:1c.5:pcie02]
[   19.573980] Real Time Clock Driver v1.12ac
[   19.574108] hpet_resources: 0xfed00000 is busy
[   19.574163] Linux agpgart interface v0.102 (c) Dave Jones
[   19.574166] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ =
sharing enabled
[   19.574292] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   19.574801] 00:09: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   19.575322] RAMDISK driver initialized: 16 RAM disks of 65536K size =
1024 blocksize
[   19.575433] input: Macintosh mouse button emulation as =
/class/input/input0
[   19.575499] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at =
0x60,0x64 irq 1,12
[   19.578914] serio: i8042 KBD port at 0x60,0x64 irq 1
[   19.578918] serio: i8042 AUX port at 0x60,0x64 irq 12
[   19.579056] mice: PS/2 mouse device common for all mice
[   19.579160] TCP cubic registered
[   19.579216] NET: Registered protocol family 1
[   19.579395] =
/build/buildd/linux-source-2.6.22-2.6.22/drivers/rtc/hctosys.c: unable =
to open rtc device (rtc0)
[   19.579402] Freeing unused kernel memory: 296k freed
[   19.582462] input: AT Translated Set 2 keyboard as =
/class/input/input1
[   20.729897] AppArmor: AppArmor =
initialized<5>audit(1209045281.748:2):  type=3D1505 info=3D"AppArmor =
initialized" pid=3D1286
[   20.734084] fuse init (API version 7.8)
[   20.737343] Failure registering capabilities with primary security =
module.
[   20.773735] ACPI: SSDT 7FE810F6, 0286 (r1  PmRef  Cpu0Ist     3000 =
INTL 20050624)
[   20.773929] ACPI: SSDT 7FE80BBB, 04B6 (r1  PmRef  Cpu0Cst     3001 =
INTL 20050624)
[   20.774179] Monitor-Mwait will be used to enter C-1 state
[   20.774182] Monitor-Mwait will be used to enter C-2 state
[   20.774184] Monitor-Mwait will be used to enter C-3 state
[   20.774187] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   20.774191] ACPI: Processor [CPU0] (supports 8 throttling states)
[   20.774386] ACPI: SSDT 7FE8137C, 00C4 (r1  PmRef  Cpu1Ist     3000 =
INTL 20050624)
[   20.774564] ACPI: SSDT 7FE81071, 0085 (r1  PmRef  Cpu1Cst     3000 =
INTL 20050624)
[   20.774854] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   20.774859] ACPI: Processor [CPU1] (supports 8 throttling states)
[   20.776309] Marking TSC unstable due to possible TSC halt in C2
[   20.776315] Time: hpet clocksource has been installed.
[   20.778809] ACPI: Thermal Zone [THM] (37 C)
[   21.149658] usbcore: registered new interface driver usbfs
[   21.149680] usbcore: registered new interface driver hub
[   21.149702] usbcore: registered new device driver usb
[   21.150297] USB Universal Host Controller Interface driver v3.0
[   21.150382] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, =
low) -> IRQ 20
[   21.150394] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   21.150398] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   21.150528] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned =
bus number 1
[   21.150561] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[   21.150659] usb usb1: configuration #1 chosen from 1 choice
[   21.150681] hub 1-0:1.0: USB hub found
[   21.150687] hub 1-0:1.0: 2 ports detected
[   21.222662] SCSI subsystem initialized
[   21.226513] libata version 2.21 loaded.
[   21.234551] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, =
low) -> IRQ 21
[   21.234567] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   21.234572] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   21.234600] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned =
bus number 2
[   21.234637] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[   21.234720] usb usb2: configuration #1 chosen from 1 choice
[   21.234741] hub 2-0:1.0: USB hub found
[   21.234746] hub 2-0:1.0: 2 ports detected
[   21.254415] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, =
low) -> IRQ 20
[   21.254428] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   21.254433] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   21.254458] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned =
bus number 3
[   21.254487] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[   21.254578] usb usb3: configuration #1 chosen from 1 choice
[   21.254597] hub 3-0:1.0: USB hub found
[   21.254602] hub 3-0:1.0: 2 ports detected
[   21.274446] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, =
low) -> IRQ 21
[   21.274457] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   21.274462] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   21.274489] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned =
bus number 4
[   21.274518] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[   21.274604] usb usb4: configuration #1 chosen from 1 choice
[   21.274623] hub 4-0:1.0: USB hub found
[   21.274628] hub 4-0:1.0: 2 ports detected
[   21.294624] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, =
low) -> IRQ 22
[   21.294636] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   21.294640] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   21.294666] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned =
bus number 5
[   21.294698] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[   21.294790] usb usb5: configuration #1 chosen from 1 choice
[   21.294809] hub 5-0:1.0: USB hub found
[   21.294813] hub 5-0:1.0: 2 ports detected
[   21.315122] tg3.c:v3.77 (May 31, 2007)
[   21.315145] ACPI: PCI Interrupt 0000:09:00.0[A] -> GSI 17 (level, =
low) -> IRQ 17
[   21.315155] PCI: Setting latency timer of device 0000:09:00.0 to 64
[   21.316236] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, =
low) -> IRQ 22
[   21.317084] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   21.317090] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   21.317136] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned =
bus number 6
[   21.317175] ehci_hcd 0000:00:1a.7: debug port 1
[   21.317182] PCI: cache line size of 32 is not supported by device =
0000:00:1a.7
[   21.317191] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[   21.321071] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, =
driver 10 Dec 2004
[   21.321159] usb usb6: configuration #1 chosen from 1 choice
[   21.321182] hub 6-0:1.0: USB hub found
[   21.321189] hub 6-0:1.0: 4 ports detected
[   21.334326] eth0: Tigon3 [partno(BCM95755m) rev a002 PHY(5755)] (PCI =
Express) 10/100/1000Base-T Ethernet 00:1c:23:97:ba:67
[   21.334332] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] =
WireSpeed[1] TSOcap[1]
[   21.334334] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   21.365007] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, =
low) -> IRQ 20
[   21.366209] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   21.366216] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   21.366263] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned =
bus number 7
[   21.366298] ehci_hcd 0000:00:1d.7: debug port 1
[   21.366305] PCI: cache line size of 32 is not supported by device =
0000:00:1d.7
[   21.366312] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[   21.370210] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, =
driver 10 Dec 2004
[   21.370288] usb usb7: configuration #1 chosen from 1 choice
[   21.370312] hub 7-0:1.0: USB hub found
[   21.370318] hub 7-0:1.0: 6 ports detected
[   21.390872] ACPI: PCI Interrupt 0000:03:01.4[A] -> GSI 19 (level, =
low) -> IRQ 19
[   21.442051] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[19]  =
MMIO=3D[f9aff000-f9aff7ff]  Max Packet=3D[2048]  IR/IT contexts=3D[8/8]
[   21.444129] ata_piix 0000:00:1f.1: version 2.11
[   21.444147] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, =
low) -> IRQ 16
[   21.444179] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   21.444717] scsi0 : ata_piix
[   21.444864] scsi1 : ata_piix
[   21.446651] ata1: PATA max UDMA/100 cmd 0x00000000000101f0 ctl =
0x00000000000103f6 bmdma 0x0000000000016fa0 irq 14
[   21.446654] ata2: PATA max UDMA/100 cmd 0x0000000000010170 ctl =
0x0000000000010376 bmdma 0x0000000000016fa8 irq 15
[   21.496955] ata2: port disabled. ignoring.
[   21.497039] ahci 0000:00:1f.2: version 2.2
[   21.497060] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, =
low) -> IRQ 17
[   21.497935] ahci 0000:00:1f.2: nr_ports (3) and implemented port map =
(0x5) don't match
[   21.622928] usb 5-1: new full speed USB device using uhci_hcd and =
address 2
[   21.652503] usb 5-1: configuration #1 chosen from 1 choice
[   21.653781] hub 5-1:1.0: USB hub found
[   21.656714] hub 5-1:1.0: 4 ports detected
[   21.711150] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 =
Gbps 0x5 impl SATA mode
[   21.711156] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum =
part=20
[   21.711163] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   21.711295] scsi2 : ahci
[   21.711355] scsi3 : ahci
[   21.711384] scsi4 : ahci
[   21.711624] ata3: SATA max UDMA/133 cmd 0xffffc20000ad4900 ctl =
0x0000000000000000 bmdma 0x0000000000000000 irq 17
[   21.711627] ata4: DUMMY
[   21.711630] ata5: SATA max UDMA/133 cmd 0xffffc20000ad4a00 ctl =
0x0000000000000000 bmdma 0x0000000000000000 irq 17
[   21.729538] ieee1394: Host added: ID:BUS[0-00:1023]  =
GUID[4a4fc00039d5cd81]
[   21.735266] usb 5-2: new full speed USB device using uhci_hcd and =
address 3
[   21.787388] usb 5-2: configuration #1 chosen from 1 choice
[   21.862762] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   21.863658] ata3.00: ATA-8: Hitachi HTS722012K9A300, DCCOC54P, max =
UDMA/133
[   21.863663] ata3.00: 234441648 sectors, multi 8: LBA48 NCQ (depth =
31/32)
[   21.864744] ata3.00: configured for UDMA/133
[   21.890895] usb 5-1.2: new full speed USB device using uhci_hcd and =
address 4
[   21.949112] usb 5-1.2: configuration #1 chosen from 1 choice
[   21.984711] ata5: SATA link down (SStatus 0 SControl 300)
[   21.984836] scsi 2:0:0:0: Direct-Access     ATA      Hitachi =
HTS72201 DCCO PQ: 0 ANSI: 5
[   21.990614] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors =
(120034 MB)
[   21.990624] sd 2:0:0:0: [sda] Write Protect is off
[   21.990626] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   21.990639] sd 2:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[   21.990677] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors =
(120034 MB)
[   21.990684] sd 2:0:0:0: [sda] Write Protect is off
[   21.990686] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   21.990698] sd 2:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[   21.990701]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[   22.066330] sd 2:0:0:0: [sda] Attached SCSI disk
[   22.069762] sd 2:0:0:0: Attached scsi generic sg0 type 0
[   22.379804] kjournald starting.  Commit interval 5 seconds
[   22.379815] EXT3-fs: mounted filesystem with ordered data mode.
[   30.462381] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   30.472357] shpchp: Standard Hot Plug PCI Controller Driver version: =
0.4
[   30.570309] input: PC Speaker as /class/input/input2
[   30.673059] Yenta: CardBus bridge found at 0000:03:01.0 [1028:01fe]
[   30.673086] Yenta O2: res at 0x94/0xD4: 00/ea
[   30.673088] Yenta O2: enabling read prefetch/write burst
[   30.749307] iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for =
Linux, 1.1.0
[   30.749310] iwl4965: Copyright(c) 2003-2007 Intel Corporation
[   30.802784] Yenta: ISA IRQ mask 0x0cb8, PCI irq 19
[   30.802789] Socket status: 30000006
[   30.802792] Yenta: Raising subordinate bus# of parent bus (#03) from =
#04 to #07
[   30.802800] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   30.802803] pcmcia: parent PCI bridge Memory window: 0xf9a00000 - =
0xf9afffff
[   30.802805] pcmcia: parent PCI bridge Memory window: 0x88000000 - =
0x8bffffff
[   30.803468] ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, =
low) -> IRQ 17
[   30.803501] PCI: Setting latency timer of device 0000:0c:00.0 to 64
[   30.805213] iwl4965: Detected Intel Wireless WiFi Link 4965AGN
[   30.808268] nvidia: module license 'NVIDIA' taints kernel.
[   31.112385] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, =
low) -> IRQ 16
[   31.112397] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   31.112464] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  =
100.14.19  Wed Sep 12 14:08:38 PDT 2007
[   31.261434] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, =
low) -> IRQ 21
[   31.262365] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   31.355533] input: PS/2 Mouse as /class/input/input3
[   31.356500] iwl4965: Tunable channels: 11 802.11bg, 13 802.11a =
channels
[   31.356678] wmaster0: Selected rate control algorithm 'iwl-4965-rs'
[   31.375734] input: AlpsPS/2 ALPS GlidePoint as /class/input/input4
[   32.584886] lp: driver loaded but no devices found
[   33.145691] EXT3 FS on sda7, internal journal
[   33.842394] kjournald starting.  Commit interval 5 seconds
[   33.842677] EXT3 FS on sda8, internal journal
[   33.842682] EXT3-fs: mounted filesystem with ordered data mode.
[   34.978585] ACPI: ACPI Dock Station Driver=20
[   34.988090] input: Lid Switch as /class/input/input5
[   34.988114] ACPI: Lid Switch [LID]
[   34.988148] input: Power Button (CM) as /class/input/input6
[   34.988164] ACPI: Power Button (CM) [PBTN]
[   34.988197] input: Sleep Button (CM) as /class/input/input7
[   34.988211] ACPI: Sleep Button (CM) [SBTN]
[   35.021820] ACPI: AC Adapter [AC] (on-line)
[   35.046072] ACPI: \_SB_.PCI0.IDE0.SEC0.MAST: found ejectable bay
[   35.046077] ACPI: \_SB_.PCI0.IDE0.SEC0.MAST: Adding notify handler
[   35.046105] ACPI: Bay [\_SB_.PCI0.IDE0.SEC0.MAST] Added
[   35.046117] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: found ejectable bay
[   35.046120] ACPI: \_SB_.PCI0.IDE1.PRI_.MAST: Adding notify handler
[   35.046131] ACPI: Error installing bay notify handler
[   35.046134] ACPI: Bay [\_SB_.PCI0.IDE1.PRI_.MAST] Added
[   35.076789] ACPI: Battery Slot [BAT0] (battery present)
[   35.098930] ACPI: Battery Slot [BAT1] (battery present)
[   35.139000] ACPI: Video Device [VID] (multi-head: yes  rom: no  =
post: no)
[   35.139431] ACPI: Video Device [VID1] (multi-head: yes  rom: no  =
post: no)
[   35.139500] ACPI: Video Device [VID2] (multi-head: yes  rom: no  =
post: no)
[   36.256092] PM: Writing back config space on device 0000:09:00.0 at =
offset c (was ff770000, writing 0)
[   36.585316] NET: Registered protocol family 10
[   36.585392] lo: Disabled Privacy Extensions
[   36.585426] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.585454] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   36.722272] Failure registering capabilities with primary security =
module.
[   36.926026] ppdev: user-space parallel port driver
[   37.207112] audit(1209059700.837:3):  type=3D1503 =
operation=3D"inode_permission" requested_mask=3D"a" denied_mask=3D"a" =
name=3D"/dev/tty" pid=3D5365 profile=3D"/usr/sbin/cupsd"
[   38.056620] Bluetooth: Core ver 2.11
[   38.056707] NET: Registered protocol family 31
[   38.056711] Bluetooth: HCI device and connection manager initialized
[   38.056717] Bluetooth: HCI socket layer initialized
[   38.091581] Bluetooth: L2CAP ver 2.8
[   38.091588] Bluetooth: L2CAP socket layer initialized
[   38.158883] Bluetooth: RFCOMM socket layer initialized
[   38.159047] Bluetooth: RFCOMM TTY layer initialized
[   38.159052] Bluetooth: RFCOMM ver 1.8
[   38.449190] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   38.449201] tg3: eth0: Flow control is on for TX and on for RX.
[   38.455411] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   40.427837] lirc_dev: IR Remote Control driver registered, at major =
61=20
[   40.614560] Linux video capture interface: v2.00
[   40.759473] bttv: driver version 0.9.17 loaded
[   40.759479] bttv: using 8 buffers with 2080k (520 pages) each for =
capture
[   40.853330] ivtv:  Start initialization, version 1.2.0
[   40.853401] ivtv:  End initialization
[   40.909895] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   41.310448] NET: Registered protocol family 17
[   44.874818] eth0: no IPv6 routers present
[   74.245771] ata3.00: exception Emask 0x2 SAct 0x3f2 SErr 0x0 action =
0x2 frozen
[   74.245784] ata3.00: (spurious completions during NCQ issue=3D0x0 =
SAct=3D0x3f2 FIS=3D005040a1:00000001)
[   74.245798] ata3.00: cmd 60/28:08:70:35:c6/00:00:07:00:00/40 tag 1 =
cdb 0x0 data 20480 in
[   74.245801]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245813] ata3.00: cmd 60/20:20:78:a3:c5/00:00:07:00:00/40 tag 4 =
cdb 0x0 data 16384 in
[   74.245817]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245829] ata3.00: cmd 60/08:28:b8:08:c6/00:00:07:00:00/40 tag 5 =
cdb 0x0 data 4096 in
[   74.245832]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245843] ata3.00: cmd 60/18:30:00:2c:c6/00:00:07:00:00/40 tag 6 =
cdb 0x0 data 12288 in
[   74.245847]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245858] ata3.00: cmd 60/18:38:58:35:c6/00:00:07:00:00/40 tag 7 =
cdb 0x0 data 12288 in
[   74.245862]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245874] ata3.00: cmd 60/00:40:e8:62:bf/01:00:07:00:00/40 tag 8 =
cdb 0x0 data 131072 in
[   74.245877]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.245889] ata3.00: cmd 60/d8:48:d8:35:c6/00:00:07:00:00/40 tag 9 =
cdb 0x0 data 110592 in
[   74.245892]          res 50/00:d8:d8:35:c6/00:00:07:00:00/40 Emask =
0x2 (HSM violation)
[   74.268073] ata3: soft resetting port
[   74.276039] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   74.278111] ata3.00: configured for UDMA/133
[   74.278143] ata3: EH complete
[   74.278663] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors =
(120034 MB)
[   74.278997] sd 2:0:0:0: [sda] Write Protect is off
[   74.279004] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   74.279536] sd 2:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[   95.546148] ata3.00: exception Emask 0x2 SAct 0x77f7f SErr 0x0 =
action 0x2 frozen
[   95.546160] ata3.00: (spurious completions during NCQ issue=3D0x0 =
SAct=3D0x77f7f FIS=3D005040a1:00008000)
[   95.546173] ata3.00: cmd 61/08:00:f7:be:56/00:00:0b:00:00/40 tag 0 =
cdb 0x0 data 4096 out
[   95.546177]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546189] ata3.00: cmd 61/20:08:f7:bd:56/00:00:0b:00:00/40 tag 1 =
cdb 0x0 data 16384 out
[   95.546192]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546204] ata3.00: cmd 61/78:10:1f:be:56/00:00:0b:00:00/40 tag 2 =
cdb 0x0 data 61440 out
[   95.546207]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546219] ata3.00: cmd 61/60:18:9f:bf:56/00:00:0b:00:00/40 tag 3 =
cdb 0x0 data 49152 out
[   95.546222]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546234] ata3.00: cmd 61/18:20:07:c0:56/00:00:0b:00:00/40 tag 4 =
cdb 0x0 data 12288 out
[   95.546238]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546249] ata3.00: cmd 61/08:28:5f:bd:56/00:00:0b:00:00/40 tag 5 =
cdb 0x0 data 4096 out
[   95.546252]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546264] ata3.00: cmd 61/40:30:7f:bd:56/00:00:0b:00:00/40 tag 6 =
cdb 0x0 data 32768 out
[   95.546268]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546279] ata3.00: cmd 61/08:40:c7:bd:56/00:00:0b:00:00/40 tag 8 =
cdb 0x0 data 4096 out
[   95.546283]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546294] ata3.00: cmd 61/10:48:07:bf:56/00:00:0b:00:00/40 tag 9 =
cdb 0x0 data 8192 out
[   95.546298]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546310] ata3.00: cmd 61/18:50:d7:bd:56/00:00:0b:00:00/40 tag 10 =
cdb 0x0 data 12288 out
[   95.546313]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546325] ata3.00: cmd 61/60:58:1f:bf:56/00:00:0b:00:00/40 tag 11 =
cdb 0x0 data 49152 out
[   95.546328]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546340] ata3.00: cmd 61/08:60:9f:be:56/00:00:0b:00:00/40 tag 12 =
cdb 0x0 data 4096 out
[   95.546343]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546355] ata3.00: cmd 61/60:68:27:c0:56/00:00:0b:00:00/40 tag 13 =
cdb 0x0 data 49152 out
[   95.546358]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546370] ata3.00: cmd 61/08:70:87:bf:56/00:00:0b:00:00/40 tag 14 =
cdb 0x0 data 4096 out
[   95.546374]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546385] ata3.00: cmd 61/10:80:8f:c0:56/00:00:0b:00:00/40 tag 16 =
cdb 0x0 data 8192 out
[   95.546389]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546400] ata3.00: cmd 61/50:88:07:bd:56/00:00:0b:00:00/40 tag 17 =
cdb 0x0 data 40960 out
[   95.546404]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.546416] ata3.00: cmd 61/30:90:bf:be:56/00:00:0b:00:00/40 tag 18 =
cdb 0x0 data 24576 out
[   95.546419]          res 50/00:10:8f:c0:56/00:00:0b:00:00/40 Emask =
0x2 (HSM violation)
[   95.585353] ata3: soft resetting port
[   95.605625] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   95.607709] ata3.00: configured for UDMA/133
[   95.607762] ata3: EH complete
[   95.607883] sd 2:0:0:0: [sda] 234441648 512-byte hardware sectors =
(120034 MB)
[   95.607905] sd 2:0:0:0: [sda] Write Protect is off
[   95.607911] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   95.607942] sd 2:0:0:0: [sda] Write cache: enabled, read cache: =
enabled, doesn't support DPO or FUA
[  122.798217] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 =
ss_did 0
[  122.798457] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798492] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798514] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:01.0
[  122.798662] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 =
ss_did 0
[  122.798705] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798735] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798758] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.0
[  122.798798] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 =
ss_did 0
[  122.798832] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798859] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798881] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.1
[  122.798919] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 =
ss_did 0
[  122.798953] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.798979] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.799000] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.3
[  122.799038] pciehp: HPC vendor_id 8086 device_id 2849 ss_vid 0 =
ss_did 0
[  122.799070] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.799096] Evaluate _OSC Set fails. Status =3D 0x0005
[  122.799117] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.5
[  122.799135] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[  128.803669] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4 unloaded
[  129.685050] pciehp: HPC vendor_id 8086 device_id 2a01 ss_vid 0 =
ss_did 0
[  129.685304] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.685338] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.685361] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:01.0
[  129.685838] pciehp: HPC vendor_id 8086 device_id 283f ss_vid 0 =
ss_did 0
[  129.685874] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.685900] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.685932] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.0
[  129.686565] pciehp: HPC vendor_id 8086 device_id 2841 ss_vid 0 =
ss_did 0
[  129.686603] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.686629] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.686650] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.1
[  129.687956] pciehp: HPC vendor_id 8086 device_id 2845 ss_vid 0 =
ss_did 0
[  129.687998] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.688026] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.688047] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.3
[  129.689434] pciehp: HPC vendor_id 8086 device_id 2849 ss_vid 0 =
ss_did 0
[  129.689476] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.689505] Evaluate _OSC Set fails. Status =3D 0x0005
[  129.689526] pciehp: Cannot get control of hotplug hardware for pci =
0000:00:1c.5
[  129.689983] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[  132.339937] cx23885 driver version 0.0.1 loaded
[  261.664368] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4 unloaded
[  264.251609] acpiphp: ACPI Hot Plug PCI Controller Driver version: =
0.5
[  264.282563] acpiphp_glue: can't get bus number, assuming 0
[  264.282729] decode_hpp: Could not get hotplug parameters. Use =
defaults
[  264.282783] acpiphp: Slot [1] registered
[  265.125349] cx23885 driver version 0.0.1 loaded

------_=_NextPart_000_01C8A63A.BE3C5C80
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------_=_NextPart_000_01C8A63A.BE3C5C80--
