Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1JbAfO-0003mA-MC
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 09:26:01 +0100
Received: by fg-out-1718.google.com with SMTP id 22so4157968fge.25
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 01:25:53 -0700 (PDT)
Message-Id: <AC88CF1D-390F-4E14-AF94-D597C69CA8F6@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: joris abadie <temps.jo@gmail.com>
In-Reply-To: <a5467650803170001v41323699v88fd983566bad8c6@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 17 Mar 2008 09:25:43 +0100
References: <235E220E-C575-467D-85AB-181C2BEF9669@gmail.com>
	<a5467650803161233h459b981w27db8c45dca36d16@mail.gmail.com>
	<650D9864-A2A4-4AB7-ACCC-DD54368FFB75@gmail.com>
	<a5467650803170001v41323699v88fd983566bad8c6@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-S-Plus scan ERROR: Initial Tuning Failed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I've included the DMESG en lspci -vvv command outputs:



DMESG:

[    0.000000] Linux version 2.6.24-12-generic (buildd@palmer) (gcc  =

version 4.2.3 (Ubuntu 4.2.3-2ubuntu4)) #1 SMP Wed Mar 12 23:01:54 UTC  =

2008 (Ubuntu 2.6.24-12.22-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000  =

(reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000  =

(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f7e4000 (usable)
[    0.000000]  BIOS-e820: 000000001f7e4000 - 0000000020000000  =

(reserved)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000  =

(reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000  =

(reserved)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 503MB LOWMEM available.
[    0.000000] found SMP MP-table at 000fe700
[    0.000000] Entering add_active_range(0, 0, 128996) 0 entries of  =

256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   128996
[    0.000000]   HighMem    128996 ->   128996
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   128996
[    0.000000] On node 0 totalpages: 128996
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123925 pages, LIFO batch:31
[    0.000000]   HighMem zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP signature @ 0xC00E9C10 checksum 0
[    0.000000] ACPI: RSDP 000E9C10, 0014 (r0 COMPAQ)
[    0.000000] ACPI: RSDT 1F7F4040, 0038 (r1 COMPAQ CPQ0968   =

20050825             0)
[    0.000000] ACPI: FACP 1F7F40EC, 0074 (r1 COMPAQ GRANTSD          =

1             0)
[    0.000000] ACPI: DSDT 1F7F4267, 13F3 (r1 COMPAQ     DSDT        1  =

MSFT  100000E)
[    0.000000] ACPI: FACS 1F7F4000, 0040
[    0.000000] ACPI: SSDT 1F7F565A, 3303 (r1 COMPAQ  PROJECT        1  =

MSFT  100000E)
[    0.000000] ACPI: APIC 1F7F4160, 0068 (r1 COMPAQ GRANTSD          =

1             0)
[    0.000000] ACPI: ASF! 1F7F41C8, 0063 (r32 COMPAQ GRANTSD          =

1             0)
[    0.000000] ACPI: MCFG 1F7F422B, 003C (r1 COMPAQ GRANTSD          =

1             0)
[    0.000000] ACPI: DMI detected: Hewlett-Packard
[    0.000000] ACPI: PM-Timer IO Port: 0xf808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:4 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:4 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000,  =

GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high  =

level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 30000000 (gap:  =

20000000:b0000000)
[    0.000000] swsusp: Registered nosave memory region:  =

000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region:  =

00000000000a0000 - 00000000000e8000
[    0.000000] swsusp: Registered nosave memory region:  =

00000000000e8000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.   =

Total pages: 127989
[    0.000000] Kernel command line:  =

root=3DUUID=3D5f4e8bd1-8131-444d-9b1f-9a8ec6768f10 ro quiet splash
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 3192.078 MHz processor.
[   10.578614] Console: colour VGA+ 80x25
[   10.578618] console [tty0] enabled
[   10.578766] Dentry cache hash table entries: 65536 (order: 6,  =

262144 bytes)
[   10.578928] Inode-cache hash table entries: 32768 (order: 5, 131072  =

bytes)
[   10.586235] Memory: 499476k/515984k available (2164k kernel code,  =

15872k reserved, 1007k data, 364k init, 0k highmem)
[   10.586242] virtual kernel memory layout:
[   10.586243]     fixmap  : 0xfff4b000 - 0xfffff000   ( 720 kB)
[   10.586244]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   10.586245]     vmalloc : 0xe0000000 - 0xff7fe000   ( 503 MB)
[   10.586246]     lowmem  : 0xc0000000 - 0xdf7e4000   ( 503 MB)
[   10.586247]       .init : 0xc041f000 - 0xc047a000   ( 364 kB)
[   10.586248]       .data : 0xc031d1bd - 0xc0418dc4   (1007 kB)
[   10.586249]       .text : 0xc0100000 - 0xc031d1bd   (2164 kB)
[   10.586252] Checking if this processor honours the WP bit even in  =

supervisor mode... Ok.
[   10.586283] SLUB: Genslabs=3D11, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4,  =

CPUs=3D2, Nodes=3D1
[   10.666106] Calibrating delay using timer specific routine..  =

6390.03 BogoMIPS (lpj=3D12780064)
[   10.666127] Security Framework initialized
[   10.666131] SELinux:  Disabled at boot.
[   10.666143] AppArmor: AppArmor initialized
[   10.666147] Failure registering capabilities with primary security  =

module.
[   10.666155] Mount-cache hash table entries: 512
[   10.666266] CPU: After generic identify, caps: bfebfbff 20000000  =

00000000 00000000 0000649d 00000000 00000001 00000000
[   10.666274] monitor/mwait feature present.
[   10.666276] using mwait in idle threads.
[   10.666282] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   10.666284] CPU: L2 cache: 2048K
[   10.666286] CPU: Physical Processor ID: 0
[   10.666288] CPU: After all inits, caps: bfebfbff 20000000 00000000  =

0000b180 0000649d 00000000 00000001 00000000
[   10.666298] Compat vDSO mapped to ffffe000.
[   10.666311] Checking 'hlt' instruction... OK.
[   10.682477] SMP alternatives: switching to UP code
[   10.684171] Early unpacking initramfs... done
[   10.957632] ACPI: Core revision 20070126
[   10.957672] ACPI: Looking for DSDT in initramfs... error, file / =

DSDT.aml not found.
[   10.960145] CPU0: Intel(R) Pentium(R) 4 CPU 3.20GHz stepping 0a
[   10.960163] SMP alternatives: switching to SMP code
[   10.960869] Booting processor 1/1 eip 3000
[   10.971202] Initializing CPU#1
[   11.049166] Calibrating delay using timer specific routine..  =

6384.53 BogoMIPS (lpj=3D12769069)
[   11.049176] CPU: After generic identify, caps: bfebfbff 20000000  =

00000000 00000000 0000649d 00000000 00000001 00000000
[   11.049183] monitor/mwait feature present.
[   11.049189] CPU: Trace cache: 12K uops, L1 D cache: 16K
[   11.049192] CPU: L2 cache: 2048K
[   11.049194] CPU: Physical Processor ID: 0
[   11.049196] CPU: After all inits, caps: bfebfbff 20000000 00000000  =

0000b180 0000649d 00000000 00000001 00000000
[   11.049707] CPU1: Intel(R) Pentium(R) 4 CPU 3.20GHz stepping 0a
[   11.049746] Total of 2 processors activated (12774.56 BogoMIPS).
[   11.049893] ENABLING IO-APIC IRQs
[   11.050065] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[   11.196942] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   11.216908] Brought up 2 CPUs
[   11.216935] CPU0 attaching sched-domain:
[   11.216939]  domain 0: span 03
[   11.216940]   groups: 01 02
[   11.216944]   domain 1: span 03
[   11.216946]    groups: 03
[   11.216948] CPU1 attaching sched-domain:
[   11.216949]  domain 0: span 03
[   11.216951]   groups: 02 01
[   11.216954]   domain 1: span 03
[   11.216956]    groups: 03
[   11.217214] net_namespace: 64 bytes
[   11.217224] HP Compaq Laptop series board detected. Selecting BIOS- =

method for reboots.
[   11.217227] Booting paravirtualized kernel on bare hardware
[   11.217878] Time:  9:15:39  Date: 03/17/08
[   11.217943] NET: Registered protocol family 16
[   11.218196] EISA bus registered
[   11.218202] ACPI: bus type pci registered
[   11.219069] PCI: PCI BIOS revision 2.20 entry at 0xec3b7, last bus=3D64
[   11.219072] PCI: Using configuration type 1
[   11.219074] Setting up standard PCI resources
[   11.220674] ACPI: EC: Look up EC in DSDT
[   11.222560] ACPI: Interpreter enabled
[   11.222563] ACPI: (supports S0 S1 S3 S4 S5)
[   11.222580] ACPI: Using IOAPIC for interrupt routing
[   11.227275] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   11.227869] PCI quirk: region f800-f87f claimed by ICH6 ACPI/GPIO/TCO
[   11.227873] PCI quirk: region fa00-fa3f claimed by ICH6 GPIO
[   11.228614] PCI: Transparent bridge - 0000:00:1e.0
[   11.228645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   11.228961] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX1._PRT]
[   11.229078] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCX2._PRT]
[   11.229196] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB_._PRT]
[   11.239938] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11  =

14 15)
[   11.240032] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11  =

14 15)
[   11.240121] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11  =

14 15)
[   11.240210] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11  =

14 15)
[   11.240298] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11  =

14 15)
[   11.240386] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11  =

14 15)
[   11.240473] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11  =

14 15)
[   11.240561] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11  =

14 15) *0, disabled.
[   11.240704] Linux Plug and Play Support v0.97 (c) Adam Belay
[   11.240750] pnp: PnP ACPI init
[   11.240759] ACPI: bus type pnp registered
[   11.243721] pnp: PnP ACPI: found 15 devices
[   11.243723] ACPI: ACPI bus type pnp unregistered
[   11.243727] PnPBIOS: Disabled by ACPI PNP
[   11.244016] PCI: Using ACPI for IRQ routing
[   11.244020] PCI: If a device doesn't work, try "pci=3Drouteirq".  If  =

it helps, post a report
[   11.915087] NET: Registered protocol family 8
[   11.915090] NET: Registered protocol family 20
[   11.915181] AppArmor: AppArmor Filesystem Enabled
[   11.919073] Time: tsc clocksource has been installed.
[   11.931117] system 00:0c: ioport range 0x400-0x41f has been reserved
[   11.931122] system 00:0c: ioport range 0x420-0x43f has been reserved
[   11.931125] system 00:0c: ioport range 0x440-0x45f has been reserved
[   11.931128] system 00:0c: ioport range 0x460-0x47f has been reserved
[   11.931131] system 00:0c: ioport range 0x480-0x48f has been reserved
[   11.931139] system 00:0c: ioport range 0xf800-0xf81f has been  =

reserved
[   11.931141] system 00:0c: ioport range 0xf820-0xf83f has been  =

reserved
[   11.931144] system 00:0c: ioport range 0xf840-0xf85f has been  =

reserved
[   11.931146] system 00:0c: ioport range 0xf860-0xf87f has been  =

reserved
[   11.931149] system 00:0c: ioport range 0xfa00-0xfa3f has been  =

reserved
[   11.931151] system 00:0c: ioport range 0xfc00-0xfc7f has been  =

reserved
[   11.931154] system 00:0c: ioport range 0xfc80-0xfcff has been  =

reserved
[   11.931156] system 00:0c: ioport range 0xfe00-0xfe7f has been  =

reserved
[   11.931159] system 00:0c: ioport range 0xfe80-0xfeff has been  =

reserved
[   11.931164] system 00:0d: ioport range 0x4d0-0x4d1 has been reserved
[   11.931171] system 00:0e: iomem range 0x0-0x9ffff could not be  =

reserved
[   11.931174] system 00:0e: iomem range 0x100000-0x1fffffff could not  =

be reserved
[   11.931178] system 00:0e: iomem range 0xe8000-0xfffff could not be  =

reserved
[   11.931182] system 00:0e: iomem range 0xfec01000-0xffffffff could  =

not be reserved
[   11.931185] system 00:0e: iomem range 0xd0000000-0xdfffffff could  =

not be reserved
[   11.931187] system 00:0e: iomem range 0xcd800-0xe7fff has been  =

reserved
[   11.961629] PCI: Bridge: 0000:00:1c.0
[   11.961631]   IO window: disabled.
[   11.961636]   MEM window: disabled.
[   11.961639]   PREFETCH window: disabled.
[   11.961644] PCI: Bridge: 0000:00:1c.1
[   11.961645]   IO window: disabled.
[   11.961650]   MEM window: f0200000-f04fffff
[   11.961654]   PREFETCH window: disabled.
[   11.961660] PCI: Bridge: 0000:00:1e.0
[   11.961661]   IO window: disabled.
[   11.961666]   MEM window: f1000000-f52fffff
[   11.961669]   PREFETCH window: disabled.
[   11.961695] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   11.961715] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level,  =

low) -> IRQ 16
[   11.961721] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   11.961731] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   11.961742] NET: Registered protocol family 2
[   11.998981] IP route cache hash table entries: 4096 (order: 2,  =

16384 bytes)
[   11.999250] TCP established hash table entries: 16384 (order: 5,  =

131072 bytes)
[   11.999322] TCP bind hash table entries: 16384 (order: 5, 131072  =

bytes)
[   11.999391] TCP: Hash tables configured (established 16384 bind  =

16384)
[   11.999393] TCP reno registered
[   12.011031] checking if image is initramfs... it is
[   12.457917] Switched to high resolution mode on CPU 1
[   12.461770] Switched to high resolution mode on CPU 0
[   12.549726] Freeing initrd memory: 7278k freed
[   12.550597] audit: initializing netlink socket (disabled)
[   12.550610] audit(1205745339.336:1): initialized
[   12.553041] VFS: Disk quotas dquot_6.5.1
[   12.553134] Dquot-cache hash table entries: 1024 (order 0, 4096  =

bytes)
[   12.553282] io scheduler noop registered
[   12.553285] io scheduler anticipatory registered
[   12.553287] io scheduler deadline registered
[   12.553298] io scheduler cfq registered (default)
[   12.553309] Boot video device is 0000:00:02.0
[   12.553514] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   12.553557] assign_interrupt_mode Found MSI capability
[   12.553595] Allocate Port Service[0000:00:1c.0:pcie00]
[   12.553639] Allocate Port Service[0000:00:1c.0:pcie02]
[   12.553733] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   12.553776] assign_interrupt_mode Found MSI capability
[   12.553810] Allocate Port Service[0000:00:1c.1:pcie00]
[   12.553851] Allocate Port Service[0000:00:1c.1:pcie02]
[   12.554154] isapnp: Scanning for PnP cards...
[   12.905236] isapnp: No Plug & Play device found
[   12.940590] Real Time Clock Driver v1.12ac
[   12.940707] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,  =

IRQ sharing enabled
[   12.940833] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   12.941613] 00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   12.942573] RAMDISK driver initialized: 16 RAM disks of 65536K size  =

1024 blocksize
[   12.942648] input: Macintosh mouse button emulation as /devices/ =

virtual/input/input0
[   12.942776] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at  =

0x60,0x64 irq 1,12
[   12.945345] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.945352] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.964533] mice: PS/2 mouse device common for all mice
[   12.964678] EISA: Probing bus 0 at eisa.0
[   12.964686] Cannot allocate resource for EISA slot 1
[   12.964709] EISA: Detected 0 cards.
[   12.964712] cpuidle: using governor ladder
[   12.964714] cpuidle: using governor menu
[   12.964791] NET: Registered protocol family 1
[   12.964819] Using IPI No-Shortcut mode
[   12.964848] registered taskstats version 1
[   12.964944]   Magic number: 0:929:272
[   12.964955]   hash matches device ttyy0
[   12.965003] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   12.965004] EDD information not available.
[   12.965197] Freeing unused kernel memory: 364k freed
[   14.163989] fuse init (API version 7.9)
[   14.181976] ACPI: SSDT 1F7FA11E, 0453 (r1 COMPAQ  CPU_TM2        1  =

MSFT  100000E)
[   14.182210] ACPI: Processor [CPU0] (supports 8 throttling states)
[   14.182369] ACPI: Processor [CPU1] (supports 8 throttling states)
[   14.372573] tg3.c:v3.86 (November 9, 2007)
[   14.372605] ACPI: PCI Interrupt 0000:40:00.0[A] -> GSI 17 (level,  =

low) -> IRQ 16
[   14.372618] PCI: Setting latency timer of device 0000:40:00.0 to 64
[   14.412140] eth0: Tigon3 [partno(BCM95751) rev 4001 PHY(5750)] (PCI  =

Express) 10/100/1000Base-T Ethernet 00:0f:fe:43:13:f6
[   14.412153] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0]  =

WireSpeed[1] TSOcap[1]
[   14.412157] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[   14.412422] usbcore: registered new interface driver usbfs
[   14.412453] usbcore: registered new interface driver hub
[   14.412501] usbcore: registered new device driver usb
[   14.414229] USB Universal Host Controller Interface driver v3.0
[   14.414292] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level,  =

low) -> IRQ 17
[   14.414308] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   14.414313] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   14.414562] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned  =

bus number 1
[   14.414594] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00001440
[   14.414770] usb usb1: configuration #1 chosen from 1 choice
[   14.414807] hub 1-0:1.0: USB hub found
[   14.414818] hub 1-0:1.0: 2 ports detected
[   14.516595] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 18 (level,  =

low) -> IRQ 18
[   14.516610] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   14.516615] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   14.516647] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned  =

bus number 2
[   14.516678] uhci_hcd 0000:00:1d.1: irq 18, io base 0x00001460
[   14.516842] usb usb2: configuration #1 chosen from 1 choice
[   14.516879] hub 2-0:1.0: USB hub found
[   14.516888] hub 2-0:1.0: 2 ports detected
[   14.620331] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 21 (level,  =

low) -> IRQ 19
[   14.620346] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   14.620352] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.620384] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned  =

bus number 3
[   14.620415] uhci_hcd 0000:00:1d.2: irq 19, io base 0x00001480
[   14.620576] usb usb3: configuration #1 chosen from 1 choice
[   14.620612] hub 3-0:1.0: USB hub found
[   14.620621] hub 3-0:1.0: 2 ports detected
[   14.728381] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 22 (level,  =

low) -> IRQ 20
[   14.728396] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   14.728401] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   14.728437] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned  =

bus number 4
[   14.728469] uhci_hcd 0000:00:1d.3: irq 20, io base 0x000014a0
[   14.728635] usb usb4: configuration #1 chosen from 1 choice
[   14.728672] hub 4-0:1.0: USB hub found
[   14.728680] hub 4-0:1.0: 2 ports detected
[   14.755877] usb 1-1: new low speed USB device using uhci_hcd and  =

address 2
[   14.756218] SCSI subsystem initialized
[   14.779898] libata version 3.00 loaded.
[   14.831877] ata_piix 0000:00:1f.1: version 2.12
[   14.831900] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 17 (level,  =

low) -> IRQ 16
[   14.831944] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   14.856934] scsi0 : ata_piix
[   14.883585] scsi1 : ata_piix
[   14.883756] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma  =

0x14e0 irq 14
[   14.883760] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma  =

0x14e8 irq 15
[   14.902515] FDC 0 is a post-1991 82077
[   14.939459] usb 1-1: configuration #1 chosen from 1 choice
[   15.178808] usb 1-2: new low speed USB device using uhci_hcd and  =

address 3
[   15.204116] ata1.00: ATAPI: LITE-ON COMBO SOHC-4836K, SQK5, max  =

UDMA/44
[   15.357418] usb 1-2: configuration #1 chosen from 1 choice
[   15.360443] usbcore: registered new interface driver hiddev
[   15.374510] input: Microsoft Microsoft=C6 Digital Media Keyboard      =

as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input1
[   15.375582] ata1.00: configured for UDMA/44
[   15.406265] input,hidraw0: USB HID v1.11 Keyboard [Microsoft  =

Microsoft=C6 Digital Media Keyboard    ] on usb-0000:00:1d.0-1
[   15.434287] input: Microsoft Microsoft=C6 Digital Media Keyboard      =

as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.1/input/input2
[   15.450137] input,hidraw1: USB HID v1.11 Device [Microsoft  =

Microsoft=C6 Digital Media Keyboard    ] on usb-0000:00:1d.0-1
[   15.463187] input: Logitech Logitech USB Optical Mouse as /devices/ =

pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input3
[   15.478091] input,hidraw2: USB HID v1.11 Mouse [Logitech Logitech  =

USB Optical Mouse] on usb-0000:00:1d.0-2
[   15.478122] usbcore: registered new interface driver usbhid
[   15.478128] /build/buildd/linux-2.6.24/drivers/hid/usbhid/hid- =

core.c: v2.6:USB HID core driver
[   15.541272] scsi 0:0:0:0: CD-ROM            LITE-ON  COMBO  =

SOHC-4836K SQK5 PQ: 0 ANSI: 5
[   15.541380] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   15.693530] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,  =

low) -> IRQ 21
[   15.693574] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   15.693628] scsi2 : ata_piix
[   15.693800] scsi3 : ata_piix
[   15.693955] ata3: SATA max UDMA/133 cmd 0x1818 ctl 0x1830 bmdma  =

0x14f0 irq 21
[   15.693960] ata4: SATA max UDMA/133 cmd 0x1820 ctl 0x1834 bmdma  =

0x14f8 irq 21
[   15.857280] ata3.00: ATA-7: SAMSUNG HD080HJ, WT100-33, max UDMA/100
[   15.857284] ata3.00: 156301488 sectors, multi 16: LBA48
[   15.865264] ata3.00: configured for UDMA/100
[   16.031074] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG  =

HD080HJ  WT10 PQ: 0 ANSI: 5
[   16.031181] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level,  =

low) -> IRQ 17
[   16.031197] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   16.031202] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   16.031242] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned  =

bus number 5
[   16.035159] ehci_hcd 0000:00:1d.7: debug port 1
[   16.035170] PCI: cache line size of 128 is not supported by device  =

0000:00:1d.7
[   16.035182] ehci_hcd 0000:00:1d.7: irq 17, io mem 0xcfdc0000
[   16.048587] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,  =

driver 10 Dec 2004
[   16.048761] usb usb5: configuration #1 chosen from 1 choice
[   16.048801] hub 5-0:1.0: USB hub found
[   16.048811] hub 5-0:1.0: 8 ports detected
[   16.064589] usb 1-1: USB disconnect, address 2
[   16.178750] Driver 'sd' needs updating - please use bus_type methods
[   16.181201] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors  =

(80026 MB)
[   16.181222] sd 2:0:0:0: [sda] Write Protect is off
[   16.181227] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.181266] sd 2:0:0:0: [sda] Write cache: enabled, read cache:  =

enabled, doesn't support DPO or FUA
[   16.181350] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors  =

(80026 MB)
[   16.181375] sd 2:0:0:0: [sda] Write Protect is off
[   16.181379] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.181416] sd 2:0:0:0: [sda] Write cache: enabled, read cache:  =

enabled, doesn't support DPO or FUA
[   16.181422]  sda:<4>Driver 'sr' needs updating - please use  =

bus_type methods
[   16.190429] sr0: scsi3-mmc drive: 0x/48x writer cd/rw xa/form2 cdda  =

tray
[   16.190434] Uniform CD-ROM driver Revision: 3.20
[   16.190506] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   16.191453]  sda1 sda2 < sda5 >
[   16.209738] sd 2:0:0:0: [sda] Attached SCSI disk
[   16.217943] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   16.217978] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   16.228152] usb 1-2: USB disconnect, address 3
[   16.367922] Attempting manual resume
[   16.367927] swsusp: Resume From Partition 8:5
[   16.367928] PM: Checking swsusp image.
[   16.368125] PM: Resume from disk failed.
[   16.409161] kjournald starting.  Commit interval 5 seconds
[   16.409171] EXT3-fs: mounted filesystem with ordered data mode.
[   16.987206] usb 1-1: new low speed USB device using uhci_hcd and  =

address 4
[   17.169857] usb 1-1: configuration #1 chosen from 1 choice
[   17.186926] input: Microsoft Microsoft=C6 Digital Media Keyboard      =

as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.0/input/input4
[   17.197718] input,hidraw0: USB HID v1.11 Keyboard [Microsoft  =

Microsoft=C6 Digital Media Keyboard    ] on usb-0000:00:1d.0-1
[   17.225799] input: Microsoft Microsoft=C6 Digital Media Keyboard      =

as /devices/pci0000:00/0000:00:1d.0/usb1/1-1/1-1:1.1/input/input5
[   17.237599] input,hidraw1: USB HID v1.11 Device [Microsoft  =

Microsoft=C6 Digital Media Keyboard    ] on usb-0000:00:1d.0-1
[   17.476959] usb 1-2: new low speed USB device using uhci_hcd and  =

address 5
[   17.653630] usb 1-2: configuration #1 chosen from 1 choice
[   17.669668] input: Logitech Logitech USB Optical Mouse as /devices/ =

pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input6
[   17.680494] input,hidraw2: USB HID v1.11 Mouse [Logitech Logitech  =

USB Optical Mouse] on usb-0000:00:1d.0-2
[   23.726321] input: PC Speaker as /devices/platform/pcspkr/input/ =

input7
[   23.852885] iTCO_vendor_support: vendor-support=3D0
[   23.900754] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26- =

Jul-2007)
[   23.900935] iTCO_wdt: Found a ICH6 or ICH6R TCO device (Version=3D2,  =

TCOBASE=3D0xf860)
[   23.901001] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   23.940642] Linux agpgart interface v0.102
[   23.996552] agpgart: Detected an Intel 915G Chipset.
[   23.997840] agpgart: Detected 7932K stolen memory.
[   24.012509] agpgart: AGP aperture is 256M @ 0xe0000000
[   24.140180] parport_pc 00:07: reported by Plug and Play ACPI
[   24.140243] parport0: PC-style at 0x378 (0x778), irq 7, dma 3  =

[PCSPP,TRISTATE,COMPAT,ECP,DMA]
[   24.251827] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   24.303747] shpchp: Standard Hot Plug PCI Controller Driver  =

version: 0.4
[   24.359546] intel_rng: Firmware space is locked read-only. If you  =

can't or
[   24.359549] intel_rng: don't want to disable this in firmware  =

setup, and if
[   24.359551] intel_rng: you are certain that your system has a  =

functional
[   24.359553] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   24.518323] input: Power Button (FF) as /devices/virtual/input/input8
[   24.675729] ACPI: Power Button (FF) [PWRF]
[   24.675849] input: Power Button (CM) as /devices/virtual/input/input9
[   24.723609] ACPI: Power Button (CM) [PBTN]
[   24.826607] ACPI: WMI-Acer: Mapper loaded
[   25.854009] Linux video capture interface: v2.00
[   26.198670] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6  =

loaded
[   26.198784] cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S- =

Plus DVB-S [card=3D37,autodetected]
[   26.198789] cx88[0]: TV tuner type 4, Radio tuner type -1
[   26.206095] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   26.355707] tveeprom 0-0050: Hauppauge model 92001, rev C1B1,  =

serial# 798818
[   26.355713] tveeprom 0-0050: MAC address is 00-0D-FE-0C-30-62
[   26.355718] tveeprom 0-0050: tuner model is Conexant_CX24109 (idx  =

111, type 4)
[   26.355723] tveeprom 0-0050: TV standards ATSC/DVB Digital (eeprom  =

0x80)
[   26.355727] tveeprom 0-0050: audio processor is CX883 (idx 32)
[   26.355730] tveeprom 0-0050: decoder processor is CX883 (idx 22)
[   26.355733] tveeprom 0-0050: has no radio, has IR receiver, has no  =

IR transmitter
[   26.355737] cx88[0]: hauppauge eeprom: model=3D92001
[   26.355877] input: cx88 IR (Hauppauge Nova-S-Plus  as /devices/ =

pci0000:00/0000:00:1e.0/0000:05:04.2/input/input10
[   26.402362] cx88[0]/2: cx2388x 8802 Driver Manager
[   26.402388] ACPI: PCI Interrupt 0000:05:04.2[A] -> GSI 16 (level,  =

low) -> IRQ 22
[   26.402401] cx88[0]/2: found at 0000:05:04.2, rev: 5, irq: 22,  =

latency: 32, mmio: 0xf3000000
[   26.402465] ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 16 (level,  =

low) -> IRQ 22
[   26.402478] cx88[0]/0: found at 0000:05:04.0, rev: 5, irq: 22,  =

latency: 32, mmio: 0xf1000000
[   26.402536] cx88[0]/0: registered device video0 [v4l2]
[   26.402570] cx88[0]/0: registered device vbi0
[   26.402649] ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 21 (level,  =

low) -> IRQ 19
[   26.402677] PCI: Setting latency timer of device 0000:00:1e.2 to 64
[   26.445715] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   26.445721] cx88/2: registering cx8802 driver, type: dvb access:  =

shared
[   26.445726] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova- =

S-Plus DVB-S [card=3D37]
[   26.445731] cx88[0]/2: cx2388x based DVB/ATSC card
[   26.562436] DVB: registering new adapter (cx88[0])
[   26.562443] DVB: registering frontend 0 (Conexant CX24123/CX24109)...
[   26.821252] intel8x0_measure_ac97_clock: measured 54860 usecs
[   26.821258] intel8x0: clocking to 48000
[   28.092705] loop: module loaded
[   28.113217] lp0: using parport0 (interrupt-driven).
[   28.213805] Adding 1485972k swap on /dev/sda5.  Priority:-1 extents: =

1 across:1485972k
[   28.826840] EXT3 FS on sda1, internal journal
[   30.054533] ip_tables: (C) 2000-2006 Netfilter Core Team
[   30.525115] No dock devices found.
[   32.242172] ppdev: user-space parallel port driver
[   32.528225] audit(1205741760.500:2): operation=3D"inode_permission"  =

request_mask=3D"a::" denied_mask=3D"a::" name=3D"/dev/tty" pid=3D5027  =

profile=3D"/usr/sbin/cupsd" namespace=3D"default"
[   32.611329] apm: BIOS not found.
[   34.183124] Bluetooth: Core ver 2.11
[   34.184324] NET: Registered protocol family 31
[   34.184331] Bluetooth: HCI device and connection manager initialized
[   34.184338] Bluetooth: HCI socket layer initialized
[   34.233480] Bluetooth: L2CAP ver 2.9
[   34.233489] Bluetooth: L2CAP socket layer initialized
[   34.320946] Bluetooth: RFCOMM socket layer initialized
[   34.320967] Bluetooth: RFCOMM TTY layer initialized
[   34.320973] Bluetooth: RFCOMM ver 1.8
[   35.593862] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   35.593869] tg3: eth0: Flow control is on for TX and on for RX.
[   37.617002] [drm] Initialized drm 1.1.0 20060810
[   37.620289] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,  =

low) -> IRQ 22
[   37.620301] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   37.620380] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   37.812074] NET: Registered protocol family 17
[   41.429790] NET: Registered protocol family 10
[   41.430361] lo: Disabled Privacy Extensions
[   52.317722] eth0: no IPv6 routers present




LSPCI

00:00.0 Host bridge: Intel Corporation 82915G/P/GV/GL/PL/910GL Memory  =

Controller Hub (rev 04)
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82915G/GV/910GL  =

Integrated Graphics Controller (rev 04) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at cfd00000 (32-bit, non-prefetchable) [size=3D512K]
	Region 1: I/O ports at 1800 [size=3D8]
	Region 2: Memory at e0000000 (32-bit, prefetchable) [size=3D256M]
	Region 3: Memory at cfd80000 (32-bit, non-prefetchable) [size=3D256K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA  =

PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D20, subordinate=3D20, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 10.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-  =

Queue=3D0/0 Enable+
		Address: fee0300c  Data: 41b1
	Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device  =

300c
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot =

+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=3D00, secondary=3D40, subordinate=3D40, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f0200000-f04fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 3, PowerLimit 10.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-  =

Queue=3D0/0 Enable+
		Address: fee0300c  Data: 41b9
	Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device  =

300c
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot =

+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) USB UHCI #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 17
	Region 4: I/O ports at 1440 [size=3D32]

00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) USB UHCI #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 18
	Region 4: I/O ports at 1460 [size=3D32]

00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) USB UHCI #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 19
	Region 4: I/O ports at 1480 [size=3D32]

00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) USB UHCI #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 20
	Region 4: I/O ports at 14a0 [size=3D32]

00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at cfdc0000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot =

+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d3) (prog- =

if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D32
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f1000000-f52fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: Gammagraphx, Inc. Unknown device 0000

00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/ =

FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at 1000 [size=3D256]
	Region 1: I/O ports at 1400 [size=3D64]
	Region 2: Memory at cfdc0400 (32-bit, non-prefetchable) [size=3D512]
	Region 3: Memory at cfdc0600 (32-bit, non-prefetchable) [size=3D256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA PME(D0+,D1-,D2-,D3hot =

+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1f.0 ISA bridge: Intel Corporation 82801FB/FR (ICH6/ICH6R) LPC  =

Interface Bridge (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6  =

Family) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at 14e0 [size=3D16]

00:1f.2 IDE interface: Intel Corporation 82801FB/FW (ICH6/ICH6W) SATA  =

Controller (rev 03) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Hewlett-Packard Company Unknown device 300c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 0: I/O ports at 1818 [size=3D8]
	Region 1: I/O ports at 1830 [size=3D4]
	Region 2: I/O ports at 1820 [size=3D8]
	Region 3: I/O ports at 1834 [size=3D4]
	Region 4: I/O ports at 14f0 [size=3D16]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot =

+,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:04.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video  =

and Audio Decoder (rev 05)
	Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f1000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA  =

PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:04.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  =

Audio Decoder [Audio Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA  =

PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:04.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  =

Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f3000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA  =

PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:04.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  =

Audio Decoder [IR Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f4000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA  =

PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

05:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH S2-3200
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f5200000 (32-bit, non-prefetchable) [size=3D512]

40:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751  =

Gigabit Ethernet PCI Express (rev 01)
	Subsystem: Hewlett-Packard Company Unknown device 3005
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  =

Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-  =

<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f0400000 (64-bit, non-prefetchable) [size=3D64K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot =

+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+  =

Queue=3D0/3 Enable-
		Address: 69cb72a78afefffc  Data: feb9
	Capabilities: [d0] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <4us, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
		Link: Latency L0s <2us, L1 <64us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1


Hope this helps.

Timothy.



On 17 Mar 2008, at 08:01, joris abadie wrote:

> Since your post, I try with feisty and gutsy, the nova-S PCI and it  =

> is the same, no problem. Maybe your card is broken or something with  =

> your PC. Can you give me dmesg ?
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH3isH+j5y+etesF8RAmJ9AJ4z0/1Y/NqPcGkY1QsAowC70D+BUQCg5OW6
7Vl2Y5/B5S8qE7pV341hyX4=3D
=3D/3ri
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
