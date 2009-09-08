Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:13904 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZIHRfn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Sep 2009 13:35:43 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2706.orange.fr (SMTP Server) with ESMTP id A9BAB1C0009C
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 19:35:43 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2706.orange.fr (SMTP Server) with ESMTP id A33171C00047
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 19:35:43 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-19-82.w92-135.abo.wanadoo.fr [92.135.50.82])
	by mwinf2706.orange.fr (SMTP Server) with ESMTP id AC2E51C0009C
	for <linux-media@vger.kernel.org>; Tue,  8 Sep 2009 19:35:42 +0200 (CEST)
Message-ID: <4AA695EE.70800@gmail.com>
Date: Tue, 08 Sep 2009 19:35:42 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com>
In-Reply-To: <4AA683BD.6070601@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050706030204020909070408"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050706030204020909070408
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

It works more or less now.
At least the remote is now in /proc/bus/input/devices :

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/class/input/input0
U: Uniq=
H: Handlers=kbd event0
B: EV=120013
B: KEY=84 2044c00 3c12078 f970f409 feffffdf ffefffff ffffffff ffffffff
B: MSC=10
B: LED=7

I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/class/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/class/input/input2
U: Uniq=
H: Handlers=kbd event2
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/class/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=40001
B: SND=6

I: Bus=0001 Vendor=1421 Product=0350 Version=0001
N: Name="saa7134 IR (ADS Tech Instant TV"
P: Phys=pci-0000:01:06.0/ir0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=100003
B: KEY=108c0364 2046 0 0 0 0 2000400 4190 80300801 1e1680 0 10000 40000ffc

I: Bus=0011 Vendor=0002 Product=0005 Version=0000
N: Name="ImPS/2 Generic Wheel Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=mouse0 event5
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=103

I: Bus=0003 Vendor=04ca Product=f001 Version=0001
N: Name="IR-receiver inside an USB DVB receiver"
P: Phys=usb-0000:00:04.1-3/ir0
S: Sysfs=/class/input/input6
U: Uniq=
H: Handlers=kbd event6
B: EV=3
B: KEY=10afcb32 290304b 0 0 0 10004 80018000 180 c0000809 9e16c0 0 0 
10008ffe

( for that last one, i guess my Intuix S800 clone exist with a remote too )

So ...
In the file saa7134-cards.c, add :
    case SAA7134_BOARD_ADS_INSTANT_TV:

Before

        dev->has_remote = SAA7134_REMOTE_GPIO;
        break;
( around line 6659 )
in the file saa7134-input.c, add :
case SAA7134_BOARD_ADS_INSTANT_TV:
        ir_codes = ir_codes_adstech_dvb_t_pci;
        // This remote seems to return 0x7f after each button is pushed.
        // No button may be repeated ; no release message. Only 1 msg with
        // raw data = button idx, followed by one message with raw data 
= 0x7f
        mask_keycode = 0xffffff;
        mask_keyup   = 0xffffff;
        mask_keydown = 0xffffff;
        polling      = 50; // ms
        break;
( around line 654, after "case SAA7134_BOARD_VIDEOMATE_S350:" )

i can use the remote now ( using devinput in lirc ) but a few quirks 
remains :
- dmesg gives a lot of "saa7134 IR (ADS Tech Instant TV: unknown key: 
key=0x7f raw=0x7f down=1"
- in irw most keys are misidentified ( Power as RECORD, Mute as Menu, 
Down as DVD and DVD is correctly identified )

i guess using ir_codes_adstech_dvb_t_pci was not such a bright idea 
after all :p
( i included a full dmesg output )

For now, it is enough work on my part, i'll try to correct those 
keycodes later. It is amazing what you can do even when you don't 
understand most of it :D .

--------------050706030204020909070408
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-2-686 (Debian 2.6.26-19) (dannf@debian.org) (gcc version 4.1.3 20080704 (prerelease) (Debian 4.1.2-25)) #1 SMP Wed Aug 19 06:06:52 UTC 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007bf90000 (usable)
[    0.000000]  BIOS-e820: 000000007bf90000 - 000000007bf9e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bf9e000 - 000000007bfe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bfe0000 - 000000007bfee000 (reserved)
[    0.000000]  BIOS-e820: 000000007bff0000 - 000000007c000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] 1087MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 507792) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   507792
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   507792
[    0.000000] On node 0 totalpages: 507792
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2176 pages used for memmap
[    0.000000]   HighMem zone: 276240 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F9C70, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 7BF90000, 003C (r1 070808 RSDT1030 20080708 MSFT       97)
[    0.000000] ACPI: FACP 7BF90200, 0084 (r1 070808 FACP1030 20080708 MSFT       97)
[    0.000000] ACPI: DSDT 7BF904A0, 5B43 (r1  1ADSY 1ADSY002        2 INTL 20051117)
[    0.000000] ACPI: FACS 7BF9E000, 0040
[    0.000000] ACPI: APIC 7BF90390, 0080 (r1 070808 APIC1030 20080708 MSFT       97)
[    0.000000] ACPI: MCFG 7BF90410, 003C (r1 070808 OEMMCFG  20080708 MSFT       97)
[    0.000000] ACPI: WDRT 7BF90450, 0047 (r1 070808 NV-WDRT  20080708 MSFT       97)
[    0.000000] ACPI: OEMB 7BF9E040, 0072 (r1 070808 OEMB1030 20080708 MSFT       97)
[    0.000000] ACPI: NVHD 7BF9E0C0, 0554 (r1 070808  NVHDCP  20080708 MSFT       97)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 7c000000:82c00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 4 CPUs, 3 hotplug CPUs
[    0.000000] PERCPU: Allocating 37960 bytes of per cpu data
[    0.000000] NR_CPUS: 8, nr_cpu_ids: 4
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 503824
[    0.000000] Kernel command line: root=/dev/hda1 ro 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2666.670 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 2003844k/2031168k available (1770k kernel code, 26176k reserved, 751k data, 244k init, 1113664k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4c000 - 0xfffff000   ( 716 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc037f000 - 0xc03bc000   ( 244 kB)
[    0.004000]       .data : 0xc02ba9a9 - 0xc0376620   ( 751 kB)
[    0.004000]       .text : 0xc0100000 - 0xc02ba9a9   (1770 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.084009] Calibrating delay using timer specific routine.. 5341.44 BogoMIPS (lpj=10682891)
[    0.084144] Security Framework initialized
[    0.084194] SELinux:  Disabled at boot.
[    0.084240] Capability LSM initialized
[    0.084303] Mount-cache hash table entries: 512
[    0.084542] Initializing cgroup subsys ns
[    0.084593] Initializing cgroup subsys cpuacct
[    0.084641] Initializing cgroup subsys devices
[    0.084717] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.084793] CPU: L2 cache: 256K
[    0.084838] CPU: Hyper-Threading is disabled
[    0.084884] Intel machine check architecture supported.
[    0.084936] Intel machine check reporting enabled on CPU#0.
[    0.084984] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.085034] CPU0: Thermal monitoring enabled
[    0.085080] using mwait in idle threads.
[    0.085137] Checking 'hlt' instruction... OK.
[    0.100429] SMP alternatives: switching to UP code
[    0.111519] ACPI: Core revision 20080321
[    0.123410] ENABLING IO-APIC IRQs
[    0.123662] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.163461] CPU0: Intel(R) Celeron(R) CPU 2.66GHz stepping 09
[    0.164010] Brought up 1 CPUs
[    0.164010] Total of 1 processors activated (5341.44 BogoMIPS).
[    0.164010] CPU0 attaching sched-domain:
[    0.164010]  domain 0: span 0
[    0.164010]   groups: 0
[    0.164010] net_namespace: 660 bytes
[    0.164010] Booting paravirtualized kernel on bare hardware
[    0.164010] NET: Registered protocol family 16
[    0.164010] ACPI: bus type pci registered
[    0.164010] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.164010] PCI: Not using MMCONFIG.
[    0.164010] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[    0.164010] PCI: Using configuration type 1 for base access
[    0.164010] Setting up standard PCI resources
[    0.172010] ACPI: EC: Look up EC in DSDT
[    0.183789] ACPI: Interpreter enabled
[    0.183840] ACPI: (supports S0 S1 S3 S4 S5)
[    0.184011] ACPI: Using IOAPIC for interrupt routing
[    0.184011] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.190427] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.190478] PCI: Using MMCONFIG for extended config space
[    0.203465] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.205605] PCI: Transparent bridge - 0000:00:0a.0
[    0.205846] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.206245] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.206483] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.206635] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.206786] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.223205] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
[    0.223792] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.224420] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.225020] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.225619] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.226220] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
[    0.226822] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.227425] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.228093] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *10
[    0.228681] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
[    0.229265] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *7
[    0.229850] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *7
[    0.230436] ACPI: PCI Interrupt Link [SGRU] (IRQs 20 21 22 23) *10
[    0.231023] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[    0.231611] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *7
[    0.232221] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *5
[    0.232858] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
[    0.233427] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 1B, should be 1A [20080321]
[    0.233724] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.233825] pnp: PnP ACPI init
[    0.233879] ACPI: bus type pnp registered
[    0.241266] pnp: PnP ACPI: found 13 devices
[    0.241315] ACPI: ACPI bus type pnp unregistered
[    0.241363] PnPBIOS: Disabled by ACPI PNP
[    0.241850] PCI: Using ACPI for IRQ routing
[    0.242238] ACPI: RTC can wake from S4
[    0.242332] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.242381] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.242429] system 00:05: ioport range 0x4000-0x407f has been reserved
[    0.242477] system 00:05: ioport range 0x4080-0x40ff has been reserved
[    0.242525] system 00:05: ioport range 0x4400-0x447f has been reserved
[    0.242573] system 00:05: ioport range 0x4480-0x44ff has been reserved
[    0.242621] system 00:05: ioport range 0x4800-0x487f has been reserved
[    0.242669] system 00:05: ioport range 0x4880-0x48ff has been reserved
[    0.242720] system 00:05: iomem range 0xfed02000-0xfed03fff has been reserved
[    0.242769] system 00:05: iomem range 0xfed04000-0xfed04fff has been reserved
[    0.242818] system 00:05: iomem range 0xfee01000-0xfeefffff has been reserved
[    0.242867] system 00:05: iomem range 0xfed01000-0xfed01fff has been reserved
[    0.242923] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.242984] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.243050] system 00:0a: ioport range 0xa00-0xadf has been reserved
[    0.243098] system 00:0a: ioport range 0xae0-0xaef has been reserved
[    0.243151] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.243207] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.243255] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.243304] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.243353] system 00:0c: iomem range 0x100000-0x7fffffff could not be reserved
[    0.243412] system 00:0c: iomem range 0xfed45000-0xffffffff could not be reserved
[    0.274184] PCI: Bridge: 0000:00:0a.0
[    0.274231]   IO window: disabled.
[    0.274278]   MEM window: 0xfeb00000-0xfebfffff
[    0.276612]   PREFETCH window: disabled.
[    0.276660] PCI: Bridge: 0000:00:0b.0
[    0.276704]   IO window: disabled.
[    0.276749]   MEM window: disabled.
[    0.276794]   PREFETCH window: disabled.
[    0.276841] PCI: Bridge: 0000:00:0c.0
[    0.276884]   IO window: disabled.
[    0.276930]   MEM window: disabled.
[    0.276974]   PREFETCH window: disabled.
[    0.277021] PCI: Bridge: 0000:00:0d.0
[    0.277064]   IO window: disabled.
[    0.277109]   MEM window: disabled.
[    0.277154]   PREFETCH window: disabled.
[    0.277212] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    0.277230] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.277244] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.277258] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.277291] NET: Registered protocol family 2
[    0.277466] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.277850] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.278637] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.279065] TCP: Hash tables configured (established 131072 bind 65536)
[    0.279117] TCP reno registered
[    0.279331] NET: Registered protocol family 1
[    0.279517] checking if image is initramfs... it is
[    0.776060] Switched to high resolution mode on CPU 0
[    0.840163] Freeing initrd memory: 6056k freed
[    0.841194] audit: initializing netlink socket (disabled)
[    0.841268] type=2000 audit(1252429129.840:1): initialized
[    0.841543] highmem bounce pool size: 64 pages
[    0.841595] Total HugeTLB memory allocated, 0
[    0.841743] VFS: Disk quotas dquot_6.5.1
[    0.841820] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.841915] msgmni has been set to 1751
[    0.842123] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.842187] io scheduler noop registered
[    0.842231] io scheduler anticipatory registered
[    0.842276] io scheduler deadline registered
[    0.842336] io scheduler cfq registered (default)
[    0.857545] pci 0000:00:10.0: Boot video device
[    0.857724] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.857768] assign_interrupt_mode Found MSI capability
[    0.857851] Allocate Port Service[0000:00:0b.0:pcie00]
[    0.857919] Allocate Port Service[0000:00:0b.0:pcie03]
[    0.858034] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.858080] assign_interrupt_mode Found MSI capability
[    0.858160] Allocate Port Service[0000:00:0c.0:pcie00]
[    0.858220] Allocate Port Service[0000:00:0c.0:pcie03]
[    0.858337] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.858380] assign_interrupt_mode Found MSI capability
[    0.858460] Allocate Port Service[0000:00:0d.0:pcie00]
[    0.858522] Allocate Port Service[0000:00:0d.0:pcie03]
[    0.859002] isapnp: Scanning for PnP cards...
[    1.210327] isapnp: No Plug & Play device found
[    1.214152] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.214369] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.215021] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.217487] brd: module loaded
[    1.217677] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.219818] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.219872] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.220188] mice: PS/2 mouse device common for all mice
[    1.220448] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.220526] rtc0: alarms up to one year, y3k
[    1.220627] cpuidle: using governor ladder
[    1.220673] cpuidle: using governor menu
[    1.220722] No iBFT detected.
[    1.221295] TCP cubic registered
[    1.221341] NET: Registered protocol family 17
[    1.221391] Using IPI No-Shortcut mode
[    1.221638] registered taskstats version 1
[    1.221868] rtc_cmos 00:06: setting system clock to 2009-09-08 16:58:51 UTC (1252429131)
[    1.222090] Freeing unused kernel memory: 244k freed
[    1.237139] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.333154] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.333219] ACPI: Processor [P001] (supports 8 throttling states)
[    2.155814] usbcore: registered new interface driver usbfs
[    2.155900] usbcore: registered new interface driver hub
[    2.156027] usbcore: registered new device driver usb
[    2.172118] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.172710] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 23
[    2.172765] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LUB0] -> GSI 23 (level, low) -> IRQ 23
[    2.172895] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    2.172900] ohci_hcd 0000:00:04.0: OHCI Host Controller
[    2.173095] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 1
[    2.173177] ohci_hcd 0000:00:04.0: irq 23, io mem 0xfea7f000
[    2.182454] No dock devices found.
[    2.208342] SCSI subsystem initialized
[    2.226906] libata version 3.00 loaded.
[    2.230283] usb usb1: configuration #1 chosen from 1 choice
[    2.230373] hub 1-0:1.0: USB hub found
[    2.230429] hub 1-0:1.0: 10 ports detected
[    2.332185] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.332239] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.332298] usb usb1: Product: OHCI Host Controller
[    2.332344] usb usb1: Manufacturer: Linux 2.6.26-2-686 ohci_hcd
[    2.332390] usb usb1: SerialNumber: 0000:00:04.0
[    2.333357] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[    2.333411] ACPI: PCI Interrupt 0000:00:04.1[B] -> Link [LUB2] -> GSI 22 (level, low) -> IRQ 22
[    2.333541] PCI: Setting latency timer of device 0000:00:04.1 to 64
[    2.333546] ehci_hcd 0000:00:04.1: EHCI Host Controller
[    2.333634] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 2
[    2.333725] ehci_hcd 0000:00:04.1: debug port 1
[    2.333774] PCI: cache line size of 128 is not supported by device 0000:00:04.1
[    2.333790] ehci_hcd 0000:00:04.1: irq 22, io mem 0xfea7ec00
[    2.344081] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.344253] usb usb2: configuration #1 chosen from 1 choice
[    2.344341] hub 2-0:1.0: USB hub found
[    2.344394] hub 2-0:1.0: 10 ports detected
[    2.448154] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.448209] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.448269] usb usb2: Product: EHCI Host Controller
[    2.448314] usb usb2: Manufacturer: Linux 2.6.26-2-686 ehci_hcd
[    2.448361] usb usb2: SerialNumber: 0000:00:04.1
[    2.448559] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    2.449180] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 21
[    2.449233] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [LMAC] -> GSI 21 (level, low) -> IRQ 21
[    2.449354] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    2.968958] forcedeth 0000:00:0f.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:24:21:59:28:60
[    2.969023] forcedeth 0000:00:0f.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[    2.982792] ahci 0000:00:0e.0: version 3.0
[    2.983354] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 20
[    2.983409] ACPI: PCI Interrupt 0000:00:0e.0[A] -> Link [LSA0] -> GSI 20 (level, low) -> IRQ 20
[    2.983744] Uniform Multi-Platform E-IDE driver
[    2.983795] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    2.991677] udev: renamed network interface eth0 to eth1
[    3.084023] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.217684] usb 2-1: configuration #1 chosen from 1 choice
[    3.217936] hub 2-1:1.0: USB hub found
[    3.218134] hub 2-1:1.0: 4 ports detected
[    3.320168] usb 2-1: New USB device found, idVendor=0409, idProduct=0058
[    3.320221] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.320271] usb 2-1: Product: USB2.0 Hub Controller
[    3.320317] usb 2-1: Manufacturer: NEC Corporation
[    3.800011] usb 2-3: new high speed USB device using ehci_hcd and address 4
[    3.941311] usb 2-3: configuration #1 chosen from 1 choice
[    3.941986] usb 2-3: New USB device found, idVendor=04ca, idProduct=f001
[    3.942039] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.942088] usb 2-3: Product: TvTUNER
[    3.942131] usb 2-3: Manufacturer: SKGZ
[    3.984037] ahci 0000:00:0e.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl IDE mode
[    3.984104] ahci 0000:00:0e.0: flags: 64bit sntf led clo pmp pio 
[    3.984155] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    3.984569] scsi0 : ahci
[    3.984996] scsi1 : ahci
[    3.985341] scsi2 : ahci
[    3.985674] scsi3 : ahci
[    3.985848] ata1: SATA max UDMA/133 abar m8192@0xfea7c000 port 0xfea7c100 irq 220
[    3.985909] ata2: SATA max UDMA/133 abar m8192@0xfea7c000 port 0xfea7c180 irq 220
[    3.985968] ata3: SATA max UDMA/133 abar m8192@0xfea7c000 port 0xfea7c200 irq 220
[    3.986027] ata4: SATA max UDMA/133 abar m8192@0xfea7c000 port 0xfea7c280 irq 220
[    4.304016] ata1: SATA link down (SStatus 0 SControl 300)
[    4.484010] usb 1-2: new full speed USB device using ohci_hcd and address 2
[    4.624014] ata2: SATA link down (SStatus 0 SControl 300)
[    4.688003] usb 1-2: configuration #1 chosen from 1 choice
[    4.713409] usb 1-2: New USB device found, idVendor=04f9, idProduct=0027
[    4.713463] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.713512] usb 1-2: Product: HL-2030 series
[    4.713556] usb 1-2: Manufacturer: Brother
[    4.713601] usb 1-2: SerialNumber: G5J391268
[    4.944017] ata3: SATA link down (SStatus 0 SControl 300)
[    5.016012] usb 1-4: new full speed USB device using ohci_hcd and address 3
[    5.224003] usb 1-4: configuration #1 chosen from 1 choice
[    5.228409] usb 1-4: New USB device found, idVendor=055f, idProduct=021f
[    5.228463] usb 1-4: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.228512] usb 1-4: Product: USB Scanner
[    5.260038] ata4: SATA link down (SStatus 0 SControl 300)
[    5.264142] NFORCE-MCP73: 0000:00:08.0 (rev a1) UDMA133 controller
[    5.264195] NFORCE-MCP73: IDE controller (0x10de:0x056c rev 0xa1) at  PCI slot 0000:00:08.0
[    5.264282] NFORCE-MCP73: not 100% native mode: will probe irqs later
[    5.264332] NFORCE-MCP73: BIOS didn't set cable bits correctly. Enabling workaround.
[    5.264396] NFORCE-MCP73: IDE port disabled
[    5.264445]     ide0: BM-DMA at 0xffa0-0xffa7
[    5.264494] Probing IDE interface ide0...
[    5.552119] hda: Maxtor 6Y120L0, ATA DISK drive
[    6.000118] hdb: _NEC DVD_RW ND-2500A, ATAPI CD/DVD-ROM drive
[    6.056064] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.056173] hda: UDMA/133 mode selected
[    6.056339] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.056433] hdb: UDMA/33 mode selected
[    6.056599] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.091326] hda: max request size: 128KiB
[    6.092727] hda: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=65535/16/63
[    6.092991] hda: cache flushes supported
[    6.093088]  hda: hda1 hda2 < hda5 >
[    6.120500] hdb: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[    6.120726] Uniform CD-ROM driver Revision: 3.20
[    6.367906] PM: Starting manual resume from disk
[    6.426084] kjournald starting.  Commit interval 5 seconds
[    6.426147] EXT3-fs: mounted filesystem with ordered data mode.
[    8.814970] udevd version 125 started
[   10.578007] input: Power Button (FF) as /class/input/input1
[   10.604079] ACPI: Power Button (FF) [PWRF]
[   10.604240] input: Power Button (CM) as /class/input/input2
[   10.636080] ACPI: Power Button (CM) [PWRB]
[   11.466194] ACPI: WMI: Mapper loaded
[   11.773273] usblp0: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04F9 pid 0x0027
[   11.773362] usbcore: registered new interface driver usblp
[   12.319684] input: PC Speaker as /class/input/input3
[   12.577138] Linux video capture interface: v2.00
[   12.741819] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
[   12.741819] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   12.747125] DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
[   12.752272] DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
[   12.917649] saa7130/34: v4l2 driver version 0.2.15 loaded
[   12.918305] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 19
[   12.918360] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKA] -> GSI 19 (level, low) -> IRQ 19
[   12.918484] saa7133[0]: found at 0000:01:06.0, rev: 240, irq: 19, latency: 64, mmio: 0xfebff800
[   12.918550] saa7133[0]: subsystem: 1421:0350, board: ADS Tech Instant TV (saa7135) [card=58,autodetected]
[   12.918621] saa7133[0]: board init: gpio is 7f
[   12.918754] input: saa7134 IR (ADS Tech Instant TV as /class/input/input4
[   13.017011] MT2060: successfully identified (IF1 = 1226)
[   13.072276] saa7133[0]: i2c eeprom 00: 21 14 50 03 10 28 ff ff ff ff ff ff ff ff ff ff
[   13.072823] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.073371] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.073911] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.074452] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.074991] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.075531] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.076096] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.076635] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.077173] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.077712] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.078250] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.078790] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.079328] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.079866] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.080419] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.220079] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[   13.249752] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
[   13.300025] tda829x 2-004b: setting tuner address to 61
[   13.388013] tda829x 2-004b: type set to tda8290+75
[   13.558687] input: IR-receiver inside an USB DVB receiver as /class/input/input6
[   13.559074] dvb-usb: schedule remote query interval to 150 msecs.
[   13.559128] dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
[   13.559213] usbcore: registered new interface driver dvb_usb_dibusb_mc
[   13.916012] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[   17.708062] saa7133[0]: registered device video0 [v4l2]
[   17.708140] saa7133[0]: registered device vbi0
[   17.807550] saa7134 ALSA driver for DMA sound loaded
[   17.807634] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 19 registered as card -1
[   17.883662] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[   17.883717] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LAZA] -> GSI 23 (level, low) -> IRQ 23
[   17.883860] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   17.914805] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   19.209744] Adding 1124508k swap on /dev/hda5.  Priority:-1 extents:1 across:1124508k
[   19.648812] EXT3 FS on hda1, internal journal
[   20.006113] loop: module loaded
[   20.081592] usbcore: registered new interface driver usbserial
[   20.081661] usbserial: USB Serial support registered for generic
[   20.081736] usbcore: registered new interface driver usbserial_generic
[   20.081785] usbserial: USB Serial Driver core
[   20.098220] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[   20.098301] usbserial: USB Serial support registered for Sony Clie 3.5
[   20.098362] usbserial: USB Serial support registered for Sony Clie 5.0
[   20.098433] usbcore: registered new interface driver visor
[   20.098480] visor: USB HandSpring Visor / Palm OS driver
[   20.129686] f71882fg: Not a Fintek device
[   20.129686] f71882fg: Found F71882FG chip at 0xa00, revision 32
[   20.239464] device-mapper: uevent: version 1.0.3
[   20.239595] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   20.480005] fuse init (API version 7.9)
[   27.957458] NET: Registered protocol family 10
[   27.958047] lo: Disabled Privacy Extensions
[   32.850426] lp: driver loaded but no devices found
[   32.868722] ppdev: user-space parallel port driver
[   35.739670] RPC: Registered udp transport module.
[   35.739723] RPC: Registered tcp transport module.
[   35.867560] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   35.989337] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   36.004007] NFSD: starting 90-second grace period
[   38.136052] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
[   38.576008] eth1: no IPv6 routers present
[   48.784481] Linux agpgart interface v0.103
[   48.967217] nvidia: module license 'NVIDIA' taints kernel.
[   49.222186] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 22
[   49.222200] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [SGRU] -> GSI 22 (level, low) -> IRQ 22
[   49.222212] PCI: Setting latency timer of device 0000:00:10.0 to 64
[   49.222433] NVRM: loading NVIDIA UNIX x86 Kernel Module  173.14.09  Wed Jun  4 23:43:17 PDT 2008
[  146.460013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  146.564028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  147.240016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  147.344030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  147.864018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  147.968029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  148.280011] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  148.384026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  148.696015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  148.748038] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  446.292013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  446.396021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  447.020013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  447.072027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  448.892015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  448.944026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  449.568013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  449.620024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  449.880013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  449.984024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  450.296016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  450.348021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  451.752013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  451.804025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  452.844021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  452.948024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  453.572013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  453.676019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  575.200015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  575.304030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  591.008018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  591.112039] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  591.736013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  591.788034] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  592.516017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  592.568032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  592.984015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  593.036033] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  593.400016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  593.452032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  594.544016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  594.648031] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  595.064018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  595.168032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  597.716015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  597.820031] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  598.444014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  598.548028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  598.912016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  598.964031] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  599.224016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  599.328030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  601.096018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  601.200032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  601.720014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  601.772036] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  602.968018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  603.020030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  605.984014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  606.036032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  606.660016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  606.764030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  609.936013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  609.988047] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  611.340017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  611.444028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  612.796014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  612.848036] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  613.212018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  613.316030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  613.576013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  613.628047] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  614.408016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  614.512028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  614.876022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  614.980029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  615.396015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  615.448032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  615.656016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  615.760030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  646.128014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  646.180029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  647.376016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  647.428040] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  649.664012] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  649.768026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  650.288013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  650.340037] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  650.808013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  650.912030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  651.432019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  651.536030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  651.900013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  652.004027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  652.264016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  652.368023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  652.628017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  652.732030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  653.772015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  653.876025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  655.384021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  655.488026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  655.904013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  656.008028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  656.476017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  656.528045] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  656.892020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  656.944022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  657.256014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  657.308042] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  657.724013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  657.828025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  658.244014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  658.296022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  659.440017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  659.492024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  663.756013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  663.808040] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  664.224014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  664.276020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  664.692015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  664.796026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  665.108025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  665.160043] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  666.408014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  666.460031] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  666.876023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  666.980028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  667.292014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  667.344026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  667.760013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  667.864025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  668.436016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  668.540029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  674.364016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  674.416038] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  675.404016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  675.456030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  761.100013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  761.204021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  762.348017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  762.400024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  800.672015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  800.776026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  802.024015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  802.128025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  824.020013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  824.124022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  825.476018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  825.580039] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  826.152014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  826.204035] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  826.776015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  826.880028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  827.140027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  827.244033] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  827.504016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  827.608029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  827.816014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  827.920024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  828.388014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  828.492030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  828.908019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  828.960029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  829.428018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  829.480027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  829.896012] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  829.948028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  831.924014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  832.028023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  832.236015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  832.288027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  832.444016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  832.496024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  832.704014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  832.808023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  832.964016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  833.068028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  833.380020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  833.432030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  833.744014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  833.848030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  834.004015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  834.108029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  834.420014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  834.472030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  834.680014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  834.784024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  834.940015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  835.044026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  837.280016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  837.332030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  837.696014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  837.800024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  838.684015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  838.736028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  839.048014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  839.100030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  878.516016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  878.620025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  880.180020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  880.284021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  880.752015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  880.856030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  881.272017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  881.324026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  881.636018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  881.688025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  882.000020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  882.104020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  882.676016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  882.780020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  883.092013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  883.196023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  883.508016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  883.612020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  884.808016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  884.912027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  886.680016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  886.784023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  887.096016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  887.148036] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  887.408015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  887.512028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  887.928014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  887.980023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  888.448014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  888.500027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  888.760016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  888.864033] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  889.176013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  889.280021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  889.644013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  889.696021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  890.528021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  890.580023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  891.308013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  891.412022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  893.336013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  893.388021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  893.960016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  894.012024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  894.376016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  894.480030] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  894.740015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  894.844029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  895.208020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  895.260018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  895.572015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  895.676024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  895.988018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  896.040021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  896.404014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  896.456023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  896.768026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  896.820025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  898.588020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  898.640025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  898.952014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  899.004028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  899.368014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  899.420023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  899.784016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  899.888024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  900.200026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  900.304023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  900.876016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  900.928022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  901.500019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  901.604022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  989.848021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  989.900025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  990.940013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  991.044021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  991.616016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  991.720023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  992.292017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  992.344024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  994.268020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  994.372018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  995.568016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  995.672023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  996.192029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  996.244024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  996.660013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  996.764023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  997.284014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  997.336023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[  997.804014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[  997.908027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1000.196026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1000.248025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1000.820014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1000.872032] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1001.704015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1001.808026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1002.432013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1002.536023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1003.212015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1003.264024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1005.500016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1005.552025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1047.256017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1047.360024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1051.208017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1051.260022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1051.780012] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1051.884025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1053.132025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1053.184028] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1053.600016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1053.652022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1054.016052] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1054.068024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1560.652014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1560.704025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1561.484016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1561.588025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1571.316019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1571.368025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1572.044013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1572.148024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1572.512013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1572.564023] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1572.928019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1573.032022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1573.240017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1573.344024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1573.552020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1573.656024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1577.036014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1577.140034] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1578.128013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1578.180027] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1578.440013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1578.544022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1578.804015] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1578.856031] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1579.116025] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1579.220021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1579.376018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1579.480029] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1579.688017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1579.792018] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1580.208020] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1580.260019] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1580.936017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1581.040026] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1582.132013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1582.184039] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1582.756014] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1582.808024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1617.232012] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1617.336017] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1635.692016] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1635.796022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1644.688022] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1644.792021] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1
[ 1648.796013] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=0
[ 1648.900024] saa7134 IR (ADS Tech Instant TV: unknown key: key=0x7f raw=0x7f down=1

--------------050706030204020909070408--


