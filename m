Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ml@punkrockworld.it>) id 1K9RKq-0000Sq-4E
	for linux-dvb@linuxtv.org; Thu, 19 Jun 2008 23:06:31 +0200
Received: from [192.168.0.12] (37.244.170.61) by aa011msr.fastwebnet.it
	(8.0.013.5) id 483216FE03F782DA for linux-dvb@linuxtv.org;
	Thu, 19 Jun 2008 23:05:49 +0200
Message-ID: <485ACA29.6020009@punkrockworld.it>
Date: Thu, 19 Jun 2008 23:05:45 +0200
From: Francesco <ml@punkrockworld.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48565075.6040400@iinet.net.au>	<200806161343.16372.eggert@hugsaser.is>	<4856FE3D.6040400@t-online.de>
	<4857CF64.8080201@punkrockworld.it> <48582245.2020407@t-online.de>
In-Reply-To: <48582245.2020407@t-online.de>
Content-Type: multipart/mixed; boundary="------------020403090108030801060703"
Subject: Re: [linux-dvb] unstable tda1004x firmware loading
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
--------------020403090108030801060703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hartmut Hackmann ha scritto:
> Hi, Francesco
> 
> Francesco schrieb:
>> I've found a little workaround (not a solution, but...) for this 
>> problem for my Asus7131H...
>>
>> Simply adding "saa7134-dvb" to /etc/modules, make a successful 
>> firmware loading on boot.
>> (My system is an Ubuntu 7.10)
>>
>>
> Could you post the relevant sections of the kernel log for both cases, 
> successful
> and unsuccessful firmware load? Please extract the entire board 
> initialization.
> Also: do you run a client / server based application (with early start 
> of the server)?
> 
> Hartmut


I've attached full boot logs for three cases:

1) System without modify. (firmware NOT loaded)
2) System without modify, rebooted from previous. (firmware LOADED).
3) System with modify. (firmware LOADED)


(Application that use tv card is backend of MythTV, started at the
  end of booting process, just before X and MythTV frontend)


Francesco Ferrario
- Chimera project -
- www.chimeratv.it -



--------------020403090108030801060703
Content-Type: text/plain;
 name="messages-chimera"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages-chimera"

= FIRST BOOT =
(Non modified, Power On)

[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Feb 12 07:42:25 UTC 2008 (Ubuntu 2.6.22-14.52-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffce000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262080
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262080
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP signature @ 0xC00F9ED0 checksum 0
[    0.000000] ACPI: RSDP 000F9ED0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFC0000, 0038 (r1 A M I  OEMRSDT  11000702 MSFT       97)
[    0.000000] ACPI: FACP 3FFC0200, 0084 (r2 A M I  OEMFACP  11000702 MSFT       97)
[    0.000000] ACPI: DSDT 3FFC0440, 4F33 (r1  1AAAA 1AAAA000        0 INTL  2002026)
[    0.000000] ACPI: FACS 3FFCE000, 0040
[    0.000000] ACPI: APIC 3FFC0390, 006C (r1 A M I  OEMAPIC  11000702 MSFT       97)
[    0.000000] ACPI: MCFG 3FFC0400, 003C (r1 A M I  OEMMCFG  11000702 MSFT       97)
[    0.000000] ACPI: OEMB 3FFCE040, 0056 (r1 A M I  AMI_OEM  11000702 MSFT       97)
[    0.000000] ACPI: SSDT 3FFCE9C0, 0A7C (r1 DpgPmm    CpuPm       12 INTL 20051117)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
[    0.000000] Built 1 zonelists.  Total pages: 260033
[    0.000000] Kernel command line: root=UUID=a47e03e8-0b5e-4c39-8147-ff77ac7a9fde ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1995.097 MHz processor.
[   19.031319] Console: colour VGA+ 80x25
[   19.031532] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   19.031758] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   19.054680] Memory: 1027712k/1048320k available (2015k kernel code, 19980k reserved, 915k data, 364k init, 130816k highmem)
[   19.054688] virtual kernel memory layout:
[   19.054688]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   19.054689]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   19.054690]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   19.054691]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   19.054692]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   19.054693]       .data : 0xc02f7e86 - 0xc03dce84   ( 915 kB)
[   19.054694]       .text : 0xc0100000 - 0xc02f7e86   (2015 kB)
[   19.054697] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   19.054733] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   19.134715] Calibrating delay using timer specific routine.. 3993.28 BogoMIPS (lpj=7986567)
[   19.134740] Security Framework v1.0.0 initialized
[   19.134746] SELinux:  Disabled at boot.
[   19.134757] Mount-cache hash table entries: 512
[   19.134888] monitor/mwait feature present.
[   19.134890] using mwait in idle threads.
[   19.134894] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.134896] CPU: L2 cache: 1024K
[   19.134898] CPU: Physical Processor ID: 0
[   19.134900] CPU: Processor Core ID: 0
[   19.134910] Compat vDSO mapped to ffffe000.
[   19.134922] Checking 'hlt' instruction... OK.
[   19.150839] SMP alternatives: switching to UP code
[   19.151238] Early unpacking initramfs... done
[   19.426237] ACPI: Core revision 20070126
[   19.426277] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   19.439565] CPU0: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.439580] SMP alternatives: switching to SMP code
[   19.439660] Booting processor 1/1 eip 3000
[   19.449719] Initializing CPU#1
[   19.530518] Calibrating delay using timer specific routine.. 3990.30 BogoMIPS (lpj=7980615)
[   19.530528] monitor/mwait feature present.
[   19.530530] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.530532] CPU: L2 cache: 1024K
[   19.530534] CPU: Physical Processor ID: 0
[   19.530535] CPU: Processor Core ID: 1
[   19.530939] CPU1: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.530956] Total of 2 processors activated (7983.59 BogoMIPS).
[   19.531101] ENABLING IO-APIC IRQs
[   19.531272] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   19.678536] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   19.698539] Brought up 2 CPUs
[   19.840252] migration_cost=44
[   19.840365] Booting paravirtualized kernel on bare hardware
[   19.840420] Time: 18:41:45  Date: 05/19/108
[   19.840436] NET: Registered protocol family 16
[   19.840508] EISA bus registered
[   19.840512] ACPI: bus type pci registered
[   19.840645] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[   19.840646] PCI: Using configuration type 1
[   19.840648] Setting up standard PCI resources
[   19.847873] mtrr: your CPUs had inconsistent fixed MTRR settings
[   19.847875] mtrr: probably your BIOS does not setup all CPUs.
[   19.847877] mtrr: corrected configuration.
[   19.854159] ACPI: Interpreter enabled
[   19.854162] ACPI: (supports S0 S1 S3 S4 S5)
[   19.854177] ACPI: Using IOAPIC for interrupt routing
[   19.854327] Error attaching device data
[   19.854361] Error attaching device data
[   19.854401] Error attaching device data
[   19.854435] Error attaching device data
[   19.860323] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.860812] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   19.860815] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   19.861423] PCI: Transparent bridge - 0000:00:1e.0
[   19.863836] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.863938] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   19.864037] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.864136] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   19.864235] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.864335] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.864435] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.864534] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   19.864625] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.864633] pnp: PnP ACPI init
[   19.864639] ACPI: bus type pnp registered
[   19.867582] pnp: PnP ACPI: found 14 devices
[   19.867584] ACPI: ACPI bus type pnp unregistered
[   19.867587] PnPBIOS: Disabled by ACPI PNP
[   19.867630] PCI: Using ACPI for IRQ routing
[   19.867632] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   19.875357] NET: Registered protocol family 8
[   19.875358] NET: Registered protocol family 20
[   19.875409] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[   19.875417] pnp: 00:09: ioport range 0xa00-0xadf has been reserved
[   19.875419] pnp: 00:09: ioport range 0xae0-0xaef has been reserved
[   19.875429] pnp: 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   19.875431] pnp: 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
[   19.875434] pnp: 00:0a: iomem range 0xffb80000-0xfffffffe could not be reserved
[   19.875439] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   19.875442] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[   19.875446] pnp: 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
[   19.875451] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
[   19.875453] pnp: 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[   19.875455] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[   19.875458] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[   19.878361] Time: tsc clocksource has been installed.
[   19.905691] PCI: Bridge: 0000:00:01.0
[   19.905692]   IO window: disabled.
[   19.905696]   MEM window: cbb00000-cfbfffff
[   19.905699]   PREFETCH window: cff00000-efefffff
[   19.905702] PCI: Bridge: 0000:00:1c.0
[   19.905704]   IO window: disabled.
[   19.905708]   MEM window: disabled.
[   19.905711]   PREFETCH window: disabled.
[   19.905715] PCI: Bridge: 0000:00:1c.1
[   19.905717]   IO window: c000-cfff
[   19.905721]   MEM window: cfc00000-cfcfffff
[   19.905725]   PREFETCH window: disabled.
[   19.905729] PCI: Bridge: 0000:00:1e.0
[   19.905730]   IO window: disabled.
[   19.905734]   MEM window: cfd00000-cfdfffff
[   19.905737]   PREFETCH window: disabled.
[   19.905753] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.905773] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.905793] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   19.905817] NET: Registered protocol family 2
[   19.942461] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   19.942529] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[   19.943448] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   19.943788] TCP: Hash tables configured (established 131072 bind 65536)
[   19.943791] TCP reno registered
[   19.954649] checking if image is initramfs... it is
[   20.402327] Switched to high resolution mode on CPU 1
[   20.406230] Switched to high resolution mode on CPU 0
[   20.498224] Freeing initrd memory: 7074k freed
[   20.498720] audit: initializing netlink socket (disabled)
[   20.498734] audit(1213900905.196:1): initialized
[   20.498814] highmem bounce pool size: 64 pages
[   20.500373] VFS: Disk quotas dquot_6.5.1
[   20.500412] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   20.500486] io scheduler noop registered
[   20.500487] io scheduler anticipatory registered
[   20.500489] io scheduler deadline registered
[   20.500500] io scheduler cfq registered (default)
[   20.500687] assign_interrupt_mode Found MSI capability
[   20.500795] assign_interrupt_mode Found MSI capability
[   20.500925] assign_interrupt_mode Found MSI capability
[   20.501074] isapnp: Scanning for PnP cards...
[   20.853884] isapnp: No Plug & Play device found
[   20.872193] Real Time Clock Driver v1.12ac
[   20.872285] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   20.872380] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.872920] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.873494] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   20.873599] input: Macintosh mouse button emulation as /class/input/input0
[   20.873661] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   20.873663] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   20.875774] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.875779] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.875889] mice: PS/2 mouse device common for all mice
[   20.875969] EISA: Probing bus 0 at eisa.0
[   20.875997] EISA: Detected 0 cards.
[   20.876078] TCP cubic registered
[   20.876091] NET: Registered protocol family 1
[   20.876111] Using IPI No-Shortcut mode
[   20.876250]   Magic number: 12:469:696
[   20.876489] Freeing unused kernel memory: 364k freed
[   20.901803] input: AT Translated Set 2 keyboard as /class/input/input1
[   22.044890] AppArmor: AppArmor initialized<5>audit(1213900906.696:2):  type=1505 info="AppArmor initialized" pid=1221
[   22.051623] fuse init (API version 7.8)
[   22.056315] Failure registering capabilities with primary security module.
[   22.088160] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  DB, should be D6 [20070126]
[   22.088167] ACPI: SSDT 3FFCE0A0, 0235 (r1 DpgPmm  P001Ist       11 INTL 20051117)
[   22.088552] ACPI: SSDT 3FFCE530, 0235 (r1 DpgPmm  P002Ist       12 INTL 20051117)
[   22.088724] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   22.088732] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   22.450115] usbcore: registered new interface driver usbfs
[   22.450136] usbcore: registered new interface driver hub
[   22.450153] usbcore: registered new device driver usb
[   22.450781] USB Universal Host Controller Interface driver v3.0
[   22.450835] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 18
[   22.450848] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.450963] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   22.450988] uhci_hcd 0000:00:1d.0: irq 18, io base 0x0000ec00
[   22.451078] usb usb1: configuration #1 chosen from 1 choice
[   22.451102] hub 1-0:1.0: USB hub found
[   22.451107] hub 1-0:1.0: 2 ports detected
[   22.476192] SCSI subsystem initialized
[   22.553190] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   22.553205] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.553320] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   22.553347] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e880
[   22.553619] usb usb2: configuration #1 chosen from 1 choice
[   22.553733] hub 2-0:1.0: USB hub found
[   22.553739] hub 2-0:1.0: 2 ports detected
[   22.657180] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
[   22.657193] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.657310] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   22.657336] uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000e800
[   22.657622] usb usb3: configuration #1 chosen from 1 choice
[   22.657755] hub 3-0:1.0: USB hub found
[   22.657761] hub 3-0:1.0: 2 ports detected
[   22.761116] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[   22.761128] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   22.761254] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   22.761281] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e480
[   22.761589] usb usb4: configuration #1 chosen from 1 choice
[   22.761724] hub 4-0:1.0: USB hub found
[   22.761730] hub 4-0:1.0: 2 ports detected
[   22.792733] usb 1-1: new low speed USB device using uhci_hcd and address 2
[   22.866964] r8169 Gigabit Ethernet driver 2.2LK loaded
[   22.866999] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   22.867222] eth0: RTL8168b/8111b at 0xf881e000, 00:1d:92:5f:de:ca, XID 38000000 IRQ 17
[   22.869018] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 18
[   22.869031] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.869088] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   22.869123] ehci_hcd 0000:00:1d.7: debug port 1
[   22.869136] ehci_hcd 0000:00:1d.7: irq 18, io mem 0xcfe3bc00
[   22.916672] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   22.916784] usb usb5: configuration #1 chosen from 1 choice
[   22.916810] hub 5-0:1.0: USB hub found
[   22.916816] hub 5-0:1.0: 8 ports detected
[   23.020752] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 20
[   23.020868] scsi0 : ata_piix
[   23.020914] scsi1 : ata_piix
[   23.021002] ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
[   23.021005] ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
[   23.340775] ata1.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.01, max UDMA/66
[   23.512675] ata1.00: configured for UDMA/66
[   23.680343] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H58N 1.01 PQ: 0 ANSI: 5
[   23.680653] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   23.680675] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   23.680732] scsi2 : ata_piix
[   23.680860] scsi3 : ata_piix
[   23.681033] ata3: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e082 bmdma 0x0001d880 irq 19
[   23.681036] ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d888 irq 19
[   23.804167] usb 1-1: new low speed USB device using uhci_hcd and address 4
[   23.845058] ata3.00: ATA-8: WDC WD2500AAJS-000000, 01.03A01, max UDMA/133
[   23.845063] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   23.861050] ata3.00: configured for UDMA/133
[   24.003319] usb 1-1: configuration #1 chosen from 1 choice
[   24.027484] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 01.0 PQ: 0 ANSI: 5
[   24.027657] usbcore: registered new interface driver hiddev
[   24.041424] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   24.041430] Uniform CD-ROM driver Revision: 3.20
[   24.041692] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   24.041701] sd 2:0:0:0: [sda] Write Protect is off
[   24.041716] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.041755] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   24.041762] sd 2:0:0:0: [sda] Write Protect is off
[   24.041776] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.041780]  sda:<5>sr 0:0:0:0: Attached scsi generic sg0 type 5
[   24.045358] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   24.054630]  sda1 sda2 <<6>input: HID 04d9:0499 as /class/input/input2
[   24.066367] input: USB HID v1.10 Mouse [HID 04d9:0499] on usb-0000:00:1d.0-1
[   24.066383] usbcore: registered new interface driver usbhid
[   24.066387] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   24.082326]  sda5 >
[   24.082454] sd 2:0:0:0: [sda] Attached SCSI disk
[   24.247264] Attempting manual resume
[   24.295238] kjournald starting.  Commit interval 5 seconds
[   24.295254] EXT3-fs: mounted filesystem with ordered data mode.
[   29.705085] Linux agpgart interface v0.102 (c) Dave Jones
[   29.787244] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   29.788651] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   30.111131] ath_hal: module license 'Proprietary' taints kernel.
[   30.111728] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
[   30.237623] input: PC Speaker as /class/input/input3
[   30.258964] iTCO_vendor_support: vendor-support=0
[   30.325181] wlan: 0.8.4.2 (0.9.3.2)
[   30.359827] parport_pc 00:07: reported by Plug and Play ACPI
[   30.359872] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   30.365483] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   30.365555] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
[   30.365592] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   30.432676] ath_pci: 0.9.4.5 (0.9.3.2)
[   30.432747] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.310264] Linux video capture interface: v2.00
[   31.322200] saa7130/34: v4l2 driver version 0.2.14 loaded
[   31.341765] ath_rate_sample: 1.2 (0.9.3.2)
[   31.344105] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   31.344111] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   31.344119] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   31.344124] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   31.344127] wifi0: mac 7.9 phy 4.5 radio 5.6
[   31.344131] wifi0: Use hw queue 1 for WME_AC_BE traffic
[   31.344133] wifi0: Use hw queue 0 for WME_AC_BK traffic
[   31.344135] wifi0: Use hw queue 2 for WME_AC_VI traffic
[   31.344136] wifi0: Use hw queue 3 for WME_AC_VO traffic
[   31.344138] wifi0: Use hw queue 8 for CAB traffic
[   31.344139] wifi0: Use hw queue 9 for beacons
[   31.362234] wifi0: Atheros 5212: mem=0xcfdf0000, irq=16
[   31.362286] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.362410] NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.19  Wed Sep 12 14:12:24 PDT 2007
[   31.363804] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 17 (level, low) -> IRQ 17
[   31.363813] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfdef800
[   31.363818] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
[   31.363828] saa7133[0]: board init: gpio is 0
[   31.363902] input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input4
[   31.515861] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   31.515876] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   31.515888] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
[   31.515900] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515912] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
[   31.515924] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515936] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515948] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515960] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515971] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515988] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.515995] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.516002] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.516009] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.516016] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.516023] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.551299] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.599832] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   31.687747] tda829x 0-004b: setting tuner address to 61
[   31.755710] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   31.763715] tda829x 0-004b: type set to tda8290+75a
[   35.617892] saa7133[0]: registered device video0 [v4l2]
[   35.618009] saa7133[0]: registered device vbi0
[   35.618130] saa7133[0]: registered device radio0
[   35.696972] saa7134 ALSA driver for DMA sound loaded
[   35.696997] saa7133[0]/alsa: saa7133[0] at 0xcfdef800 irq 17 registered as card -2
[   35.809469] DVB: registering new adapter (saa7133[0])
[   35.809477] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   35.881398] tda1004x: setting up plls for 48MHz sampling clock
[   35.901457] loop: module loaded
[   35.920027] lp0: using parport0 (interrupt-driven).
[   36.047037] Adding 3028212k swap on /dev/sda5.  Priority:-1 extents:1 across:3028212k
[   36.367624] EXT3 FS on sda1, internal journal
[   37.405721] No dock devices found.
[   37.568401] input: Power Button (FF) as /class/input/input5
[   37.568418] ACPI: Power Button (FF) [PWRF]
[   37.568517] input: Power Button (CM) as /class/input/input6
[   37.568531] ACPI: Power Button (CM) [PWRB]
[   38.172109] tda1004x: found firmware revision 0 -- invalid
[   38.172115] tda1004x: trying to boot from eeprom
[   38.670861] Failure registering capabilities with primary security module.
[   38.977745] r8169: eth0: link up
[   38.977756] r8169: eth0: link up
[   39.055165] ppdev: user-space parallel port driver
[   39.230496] audit(1213900924.040:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5064 profile="/usr/sbin/cupsd"
[   40.542786] tda1004x: found firmware revision 0 -- invalid
[   40.542790] tda1004x: waiting for firmware upload...
[   40.985620] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.985624] apm: disabled - APM is not SMP safe.
dhcdbd: Started up.
[   49.656107] Bluetooth: Core ver 2.11
[   49.656274] NET: Registered protocol family 31
[   49.656277] Bluetooth: HCI device and connection manager initialized
[   49.656282] Bluetooth: HCI socket layer initialized
[   49.696247] Bluetooth: L2CAP ver 2.8
[   49.696251] Bluetooth: L2CAP socket layer initialized
[   49.787800] Bluetooth: RFCOMM socket layer initialized
[   49.787954] Bluetooth: RFCOMM TTY layer initialized
[   49.787958] Bluetooth: RFCOMM ver 1.8
[   50.137395] tda1004x: setting up plls for 48MHz sampling clock
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
[   53.814150] NET: Registered protocol family 17
[   53.827334] tda1004x: found firmware revision 0 -- invalid
[   53.827339] tda1004x: trying to boot from eeprom
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
[   55.127872] NET: Registered protocol family 10
[   55.127998] lo: Disabled Privacy Extensions
[   55.966179] tda1004x: found firmware revision 0 -- invalid
[   55.966183] tda1004x: firmware upload failed
[   56.190164] tda1004x: found firmware revision 80 -- invalid
[   56.190168] tda1004x: waiting for firmware upload...
[   70.621295] tda1004x: found firmware revision 80 -- invalid
[   70.621299] tda1004x: firmware upload failed





= SECOND BOOT =
(Non modified, Rebooted)

[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Feb 12 07:42:25 UTC 2008 (Ubuntu 2.6.22-14.52-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffce000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262080
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262080
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP signature @ 0xC00F9ED0 checksum 0
[    0.000000] ACPI: RSDP 000F9ED0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFC0000, 0038 (r1 A M I  OEMRSDT  11000702 MSFT       97)
[    0.000000] ACPI: FACP 3FFC0200, 0084 (r2 A M I  OEMFACP  11000702 MSFT       97)
[    0.000000] ACPI: DSDT 3FFC0440, 4F33 (r1  1AAAA 1AAAA000        0 INTL  2002026)
[    0.000000] ACPI: FACS 3FFCE000, 0040
[    0.000000] ACPI: APIC 3FFC0390, 006C (r1 A M I  OEMAPIC  11000702 MSFT       97)
[    0.000000] ACPI: MCFG 3FFC0400, 003C (r1 A M I  OEMMCFG  11000702 MSFT       97)
[    0.000000] ACPI: OEMB 3FFCE040, 0056 (r1 A M I  AMI_OEM  11000702 MSFT       97)
[    0.000000] ACPI: SSDT 3FFCE9C0, 0A7C (r1 DpgPmm    CpuPm       12 INTL 20051117)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
[    0.000000] Built 1 zonelists.  Total pages: 260033
[    0.000000] Kernel command line: root=UUID=a47e03e8-0b5e-4c39-8147-ff77ac7a9fde ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1995.058 MHz processor.
[   18.840409] Console: colour VGA+ 80x25
[   18.840623] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   18.840847] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   18.863763] Memory: 1027712k/1048320k available (2015k kernel code, 19980k reserved, 915k data, 364k init, 130816k highmem)
[   18.863771] virtual kernel memory layout:
[   18.863772]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   18.863773]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   18.863774]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   18.863775]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   18.863776]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   18.863777]       .data : 0xc02f7e86 - 0xc03dce84   ( 915 kB)
[   18.863777]       .text : 0xc0100000 - 0xc02f7e86   (2015 kB)
[   18.863780] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   18.863816] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   18.943799] Calibrating delay using timer specific routine.. 3993.29 BogoMIPS (lpj=7986593)
[   18.943823] Security Framework v1.0.0 initialized
[   18.943829] SELinux:  Disabled at boot.
[   18.943841] Mount-cache hash table entries: 512
[   18.943972] monitor/mwait feature present.
[   18.943974] using mwait in idle threads.
[   18.943978] CPU: L1 I cache: 32K, L1 D cache: 32K
[   18.943980] CPU: L2 cache: 1024K
[   18.943982] CPU: Physical Processor ID: 0
[   18.943984] CPU: Processor Core ID: 0
[   18.943994] Compat vDSO mapped to ffffe000.
[   18.944006] Checking 'hlt' instruction... OK.
[   18.959923] SMP alternatives: switching to UP code
[   18.960324] Early unpacking initramfs... done
[   19.235372] ACPI: Core revision 20070126
[   19.235413] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   19.248700] CPU0: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.248714] SMP alternatives: switching to SMP code
[   19.248793] Booting processor 1/1 eip 3000
[   19.258851] Initializing CPU#1
[   19.339601] Calibrating delay using timer specific routine.. 3990.29 BogoMIPS (lpj=7980582)
[   19.339611] monitor/mwait feature present.
[   19.339613] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.339615] CPU: L2 cache: 1024K
[   19.339617] CPU: Physical Processor ID: 0
[   19.339618] CPU: Processor Core ID: 1
[   19.339974] CPU1: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.339992] Total of 2 processors activated (7983.58 BogoMIPS).
[   19.340137] ENABLING IO-APIC IRQs
[   19.340308] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   19.487620] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   19.507623] Brought up 2 CPUs
[   19.675953] migration_cost=557
[   19.676066] Booting paravirtualized kernel on bare hardware
[   19.676121] Time: 18:48:29  Date: 05/19/108
[   19.676138] NET: Registered protocol family 16
[   19.676209] EISA bus registered
[   19.676213] ACPI: bus type pci registered
[   19.676346] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[   19.676348] PCI: Using configuration type 1
[   19.676349] Setting up standard PCI resources
[   19.683575] mtrr: your CPUs had inconsistent fixed MTRR settings
[   19.683577] mtrr: probably your BIOS does not setup all CPUs.
[   19.683578] mtrr: corrected configuration.
[   19.689860] ACPI: Interpreter enabled
[   19.689862] ACPI: (supports S0 S1 S3 S4 S5)
[   19.689877] ACPI: Using IOAPIC for interrupt routing
[   19.690027] Error attaching device data
[   19.690060] Error attaching device data
[   19.690094] Error attaching device data
[   19.690127] Error attaching device data
[   19.696014] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.696506] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   19.696509] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   19.697120] PCI: Transparent bridge - 0000:00:1e.0
[   19.699488] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.699591] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   19.699691] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.699791] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   19.699890] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.699990] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.700089] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.700189] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   19.700281] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.700290] pnp: PnP ACPI init
[   19.700297] ACPI: bus type pnp registered
[   19.703231] pnp: PnP ACPI: found 14 devices
[   19.703233] ACPI: ACPI bus type pnp unregistered
[   19.703236] PnPBIOS: Disabled by ACPI PNP
[   19.703279] PCI: Using ACPI for IRQ routing
[   19.703281] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   19.711037] NET: Registered protocol family 8
[   19.711039] NET: Registered protocol family 20
[   19.711090] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[   19.711099] pnp: 00:09: ioport range 0xa00-0xadf has been reserved
[   19.711101] pnp: 00:09: ioport range 0xae0-0xaef has been reserved
[   19.711110] pnp: 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   19.711113] pnp: 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
[   19.711116] pnp: 00:0a: iomem range 0xffb80000-0xfffffffe could not be reserved
[   19.711120] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   19.711123] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[   19.711127] pnp: 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
[   19.711132] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
[   19.711134] pnp: 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[   19.711137] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[   19.711139] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[   19.711438] Time: tsc clocksource has been installed.
[   19.741372] PCI: Bridge: 0000:00:01.0
[   19.741373]   IO window: disabled.
[   19.741377]   MEM window: cbb00000-cfbfffff
[   19.741380]   PREFETCH window: cff00000-efefffff
[   19.741384] PCI: Bridge: 0000:00:1c.0
[   19.741385]   IO window: disabled.
[   19.741389]   MEM window: disabled.
[   19.741392]   PREFETCH window: disabled.
[   19.741396] PCI: Bridge: 0000:00:1c.1
[   19.741398]   IO window: c000-cfff
[   19.741403]   MEM window: cfc00000-cfcfffff
[   19.741406]   PREFETCH window: disabled.
[   19.741410] PCI: Bridge: 0000:00:1e.0
[   19.741411]   IO window: disabled.
[   19.741416]   MEM window: cfd00000-cfdfffff
[   19.741419]   PREFETCH window: disabled.
[   19.741434] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.741454] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.741475] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   19.741499] NET: Registered protocol family 2
[   19.779536] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   19.779605] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[   19.780526] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   19.780867] TCP: Hash tables configured (established 131072 bind 65536)
[   19.780869] TCP reno registered
[   19.791725] checking if image is initramfs... it is
[   20.239412] Switched to high resolution mode on CPU 1
[   20.243315] Switched to high resolution mode on CPU 0
[   20.335381] Freeing initrd memory: 7074k freed
[   20.335874] audit: initializing netlink socket (disabled)
[   20.335888] audit(1213901309.220:1): initialized
[   20.335965] highmem bounce pool size: 64 pages
[   20.337520] VFS: Disk quotas dquot_6.5.1
[   20.337559] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   20.337633] io scheduler noop registered
[   20.337635] io scheduler anticipatory registered
[   20.337636] io scheduler deadline registered
[   20.337648] io scheduler cfq registered (default)
[   20.337836] assign_interrupt_mode Found MSI capability
[   20.337943] assign_interrupt_mode Found MSI capability
[   20.338074] assign_interrupt_mode Found MSI capability
[   20.338223] isapnp: Scanning for PnP cards...
[   20.691039] isapnp: No Plug & Play device found
[   20.709159] Real Time Clock Driver v1.12ac
[   20.709253] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   20.709347] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.709887] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.710455] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   20.710563] input: Macintosh mouse button emulation as /class/input/input0
[   20.710625] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   20.710627] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   20.712741] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.712746] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.712858] mice: PS/2 mouse device common for all mice
[   20.712939] EISA: Probing bus 0 at eisa.0
[   20.712967] EISA: Detected 0 cards.
[   20.713048] TCP cubic registered
[   20.713061] NET: Registered protocol family 1
[   20.713081] Using IPI No-Shortcut mode
[   20.713219]   Magic number: 12:125:848
[   20.713284]   hash matches device ptyv0
[   20.713456] Freeing unused kernel memory: 364k freed
[   20.738682] input: AT Translated Set 2 keyboard as /class/input/input1
[   21.882529] AppArmor: AppArmor initialized<5>audit(1213901310.720:2):  type=1505 info="AppArmor initialized" pid=1221
[   21.889266] fuse init (API version 7.8)
[   21.893957] Failure registering capabilities with primary security module.
[   21.925194] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  DB, should be D6 [20070126]
[   21.925201] ACPI: SSDT 3FFCE0A0, 0235 (r1 DpgPmm  P001Ist       11 INTL 20051117)
[   21.925589] ACPI: SSDT 3FFCE530, 0235 (r1 DpgPmm  P002Ist       12 INTL 20051117)
[   21.925761] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   21.925769] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   22.324849] r8169 Gigabit Ethernet driver 2.2LK loaded
[   22.324873] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   22.325075] eth0: RTL8168b/8111b at 0xf8858000, 00:1d:92:5f:de:ca, XID 38000000 IRQ 17
[   22.330345] SCSI subsystem initialized
[   22.337255] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[   22.337345] scsi0 : ata_piix
[   22.350320] usbcore: registered new interface driver usbfs
[   22.350343] usbcore: registered new interface driver hub
[   22.360954] scsi1 : ata_piix
[   22.361079] ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
[   22.361082] ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
[   22.361209] usbcore: registered new device driver usb
[   22.361975] USB Universal Host Controller Interface driver v3.0
[   22.678064] ata1.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.01, max UDMA/66
[   22.849983] ata1.00: configured for UDMA/66
[   23.017641] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H58N 1.01 PQ: 0 ANSI: 5
[   23.017723] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   23.017755] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   23.017946] scsi2 : ata_piix
[   23.018066] scsi3 : ata_piix
[   23.018149] ata3: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e082 bmdma 0x0001d880 irq 19
[   23.018152] ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d888 irq 19
[   23.182414] ata3.00: ATA-8: WDC WD2500AAJS-000000, 01.03A01, max UDMA/133
[   23.182419] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   23.190437] ata3.00: configured for UDMA/133
[   23.356074] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 01.0 PQ: 0 ANSI: 5
[   23.356360] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
[   23.356375] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   23.357492] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   23.357524] uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000ec00
[   23.357866] usb usb1: configuration #1 chosen from 1 choice
[   23.357891] hub 1-0:1.0: USB hub found
[   23.357897] hub 1-0:1.0: 2 ports detected
[   23.369194] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   23.369201] Uniform CD-ROM driver Revision: 3.20
[   23.369429] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   23.369439] sd 2:0:0:0: [sda] Write Protect is off
[   23.369455] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   23.369493] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   23.369501] sd 2:0:0:0: [sda] Write Protect is off
[   23.369514] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   23.369518]  sda:<5>sr 0:0:0:0: Attached scsi generic sg0 type 5
[   23.372793] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   23.379925]  sda1 sda2 < sda5 >
[   23.410178] sd 2:0:0:0: [sda] Attached SCSI disk
[   23.461499] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
[   23.461516] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   23.461538] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   23.461564] ehci_hcd 0000:00:1d.7: debug port 1
[   23.461576] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xcfe3bc00
[   23.465455] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   23.465526] usb usb2: configuration #1 chosen from 1 choice
[   23.465547] hub 2-0:1.0: USB hub found
[   23.465553] hub 2-0:1.0: 8 ports detected
[   23.569322] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   23.569341] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   23.569372] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   23.569396] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e880
[   23.569475] usb usb3: configuration #1 chosen from 1 choice
[   23.569496] hub 3-0:1.0: USB hub found
[   23.569501] hub 3-0:1.0: 2 ports detected
[   23.639490] Attempting manual resume
[   23.673265] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   23.673283] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   23.673312] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   23.673339] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[   23.673421] usb usb4: configuration #1 chosen from 1 choice
[   23.673442] hub 4-0:1.0: USB hub found
[   23.673446] hub 4-0:1.0: 2 ports detected
[   23.689231] kjournald starting.  Commit interval 5 seconds
[   23.689239] EXT3-fs: mounted filesystem with ordered data mode.
[   23.777204] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[   23.777222] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   23.777248] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   23.777274] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e480
[   23.777356] usb usb5: configuration #1 chosen from 1 choice
[   23.777379] hub 5-0:1.0: USB hub found
[   23.777384] hub 5-0:1.0: 2 ports detected
[   24.204852] usb 1-1: new low speed USB device using uhci_hcd and address 2
[   24.404117] usb 1-1: configuration #1 chosen from 1 choice
[   29.245104] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   29.247952] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   29.324519] Linux agpgart interface v0.102 (c) Dave Jones
[   29.606919] ath_hal: module license 'Proprietary' taints kernel.
[   29.607594] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
[   29.652503] wlan: 0.8.4.2 (0.9.3.2)
[   29.718242] ath_pci: 0.9.4.5 (0.9.3.2)
[   29.718344] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   30.321984] input: PC Speaker as /class/input/input2
[   30.334352] parport_pc 00:07: reported by Plug and Play ACPI
[   30.334397] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   30.410567] ath_rate_sample: 1.2 (0.9.3.2)
[   30.420407] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   30.420414] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   30.420422] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   30.420427] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   30.420431] wifi0: mac 7.9 phy 4.5 radio 5.6
[   30.420438] wifi0: Use hw queue 1 for WME_AC_BE traffic
[   30.420440] wifi0: Use hw queue 0 for WME_AC_BK traffic
[   30.420442] wifi0: Use hw queue 2 for WME_AC_VI traffic
[   30.420444] wifi0: Use hw queue 3 for WME_AC_VO traffic
[   30.420445] wifi0: Use hw queue 8 for CAB traffic
[   30.420447] wifi0: Use hw queue 9 for beacons
[   30.454060] Linux video capture interface: v2.00
[   30.736656] iTCO_vendor_support: vendor-support=0
[   30.737552] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   30.737622] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
[   30.737661] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   30.748409] saa7130/34: v4l2 driver version 0.2.14 loaded
[   30.765642] wifi0: Atheros 5212: mem=0xcfdf0000, irq=16
[   30.769094] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 17 (level, low) -> IRQ 17
[   30.769103] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfdef800
[   30.769109] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
[   30.769120] saa7133[0]: board init: gpio is 0
[   30.769212] input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input3
[   30.794361] usbcore: registered new interface driver hiddev
[   30.833157] input: HID 04d9:0499 as /class/input/input4
[   30.833196] input: USB HID v1.10 Mouse [HID 04d9:0499] on usb-0000:00:1d.0-1
[   30.833208] usbcore: registered new interface driver usbhid
[   30.833212] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   30.920933] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   30.920943] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   30.920950] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
[   30.920957] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.920964] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
[   30.920972] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.920979] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.920986] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.920993] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921000] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921008] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921015] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921022] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921029] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921036] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   30.921043] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.024920] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   31.116820] tda829x 0-004b: setting tuner address to 61
[   31.192781] tda829x 0-004b: type set to tda8290+75a
[   35.046870] saa7133[0]: registered device video0 [v4l2]
[   35.046983] saa7133[0]: registered device vbi0
[   35.047092] saa7133[0]: registered device radio0
[   35.110556] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   35.124258] saa7134 ALSA driver for DMA sound loaded
[   35.124282] saa7133[0]/alsa: saa7133[0] at 0xcfdef800 irq 17 registered as card -2
[   35.238482] DVB: registering new adapter (saa7133[0])
[   35.238488] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   35.310402] tda1004x: setting up plls for 48MHz sampling clock
[   35.322388] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   35.438605] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   35.438770] NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.19  Wed Sep 12 14:12:24 PDT 2007
[   35.594226] tda1004x: found firmware revision 20 -- ok
[   36.540304] loop: module loaded
[   36.554952] lp0: using parport0 (interrupt-driven).
[   36.623811] Adding 3028212k swap on /dev/sda5.  Priority:-1 extents:1 across:3028212k
[   36.896733] EXT3 FS on sda1, internal journal
[   37.908617] No dock devices found.
[   38.075859] input: Power Button (FF) as /class/input/input5
[   38.076035] ACPI: Power Button (FF) [PWRF]
[   38.076975] input: Power Button (CM) as /class/input/input6
[   38.077137] ACPI: Power Button (CM) [PWRB]
[   39.149021] Failure registering capabilities with primary security module.
[   39.477282] r8169: eth0: link up
[   39.477293] r8169: eth0: link up
[   39.642473] ppdev: user-space parallel port driver
[   39.823939] audit(1213901329.244:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5008 profile="/usr/sbin/cupsd"
[   41.463357] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   41.463361] apm: disabled - APM is not SMP safe.
dhcdbd: Started up.
[   49.539283] Bluetooth: Core ver 2.11
[   49.539349] NET: Registered protocol family 31
[   49.539351] Bluetooth: HCI device and connection manager initialized
[   49.539356] Bluetooth: HCI socket layer initialized
[   49.580744] Bluetooth: L2CAP ver 2.8
[   49.580749] Bluetooth: L2CAP socket layer initialized
[   49.657963] Bluetooth: RFCOMM socket layer initialized
[   49.657977] Bluetooth: RFCOMM TTY layer initialized
[   49.657980] Bluetooth: RFCOMM ver 1.8
[   49.993863] tda1004x: setting up plls for 48MHz sampling clock
[   50.277698] tda1004x: found firmware revision 20 -- ok
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
[   53.923564] NET: Registered protocol family 17
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
[   57.913328] NET: Registered protocol family 10
[   57.913464] lo: Disabled Privacy Extensions




= THIRD BOOT =
(Modified, Power On)

[    0.000000] Linux version 2.6.22-14-generic (buildd@terranova) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Tue Feb 12 07:42:25 UTC 2008 (Ubuntu 2.6.22-14.52-generic)
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffce000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262080
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262080
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP signature @ 0xC00F9ED0 checksum 0
[    0.000000] ACPI: RSDP 000F9ED0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFC0000, 0038 (r1 A M I  OEMRSDT  11000702 MSFT       97)
[    0.000000] ACPI: FACP 3FFC0200, 0084 (r2 A M I  OEMFACP  11000702 MSFT       97)
[    0.000000] ACPI: DSDT 3FFC0440, 4F33 (r1  1AAAA 1AAAA000        0 INTL  2002026)
[    0.000000] ACPI: FACS 3FFCE000, 0040
[    0.000000] ACPI: APIC 3FFC0390, 006C (r1 A M I  OEMAPIC  11000702 MSFT       97)
[    0.000000] ACPI: MCFG 3FFC0400, 003C (r1 A M I  OEMMCFG  11000702 MSFT       97)
[    0.000000] ACPI: OEMB 3FFCE040, 0056 (r1 A M I  AMI_OEM  11000702 MSFT       97)
[    0.000000] ACPI: SSDT 3FFCE9C0, 0A7C (r1 DpgPmm    CpuPm       12 INTL 20051117)
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
[    0.000000] Built 1 zonelists.  Total pages: 260033
[    0.000000] Kernel command line: root=UUID=a47e03e8-0b5e-4c39-8147-ff77ac7a9fde ro quiet splash
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1995.055 MHz processor.
[   19.073152] Console: colour VGA+ 80x25
[   19.073356] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   19.073581] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   19.096502] Memory: 1027712k/1048320k available (2015k kernel code, 19980k reserved, 915k data, 364k init, 130816k highmem)
[   19.096510] virtual kernel memory layout:
[   19.096511]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[   19.096512]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   19.096513]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   19.096513]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   19.096514]       .init : 0xc03e3000 - 0xc043e000   ( 364 kB)
[   19.096515]       .data : 0xc02f7e86 - 0xc03dce84   ( 915 kB)
[   19.096516]       .text : 0xc0100000 - 0xc02f7e86   (2015 kB)
[   19.096519] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   19.096555] SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[   19.176536] Calibrating delay using timer specific routine.. 3993.31 BogoMIPS (lpj=7986634)
[   19.176562] Security Framework v1.0.0 initialized
[   19.176568] SELinux:  Disabled at boot.
[   19.176579] Mount-cache hash table entries: 512
[   19.176710] monitor/mwait feature present.
[   19.176711] using mwait in idle threads.
[   19.176716] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.176718] CPU: L2 cache: 1024K
[   19.176720] CPU: Physical Processor ID: 0
[   19.176721] CPU: Processor Core ID: 0
[   19.176732] Compat vDSO mapped to ffffe000.
[   19.176743] Checking 'hlt' instruction... OK.
[   19.192661] SMP alternatives: switching to UP code
[   19.193059] Early unpacking initramfs... done
[   19.468084] ACPI: Core revision 20070126
[   19.468124] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml not found.
[   19.481399] CPU0: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.481414] SMP alternatives: switching to SMP code
[   19.481493] Booting processor 1/1 eip 3000
[   19.491552] Initializing CPU#1
[   19.572339] Calibrating delay using timer specific routine.. 3990.29 BogoMIPS (lpj=7980587)
[   19.572349] monitor/mwait feature present.
[   19.572351] CPU: L1 I cache: 32K, L1 D cache: 32K
[   19.572353] CPU: L2 cache: 1024K
[   19.572355] CPU: Physical Processor ID: 0
[   19.572356] CPU: Processor Core ID: 1
[   19.572760] CPU1: Intel(R) Pentium(R) Dual  CPU  E2180  @ 2.00GHz stepping 0d
[   19.572778] Total of 2 processors activated (7983.61 BogoMIPS).
[   19.572922] ENABLING IO-APIC IRQs
[   19.573093] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   19.720359] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   19.740362] Brought up 2 CPUs
[   19.908657] migration_cost=42
[   19.908770] Booting paravirtualized kernel on bare hardware
[   19.908825] Time: 18:52:05  Date: 05/19/108
[   19.908842] NET: Registered protocol family 16
[   19.908914] EISA bus registered
[   19.908918] ACPI: bus type pci registered
[   19.909051] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=4
[   19.909052] PCI: Using configuration type 1
[   19.909054] Setting up standard PCI resources
[   19.916279] mtrr: your CPUs had inconsistent fixed MTRR settings
[   19.916281] mtrr: probably your BIOS does not setup all CPUs.
[   19.916282] mtrr: corrected configuration.
[   19.922568] ACPI: Interpreter enabled
[   19.922571] ACPI: (supports S0 S1 S3 S4 S5)
[   19.922586] ACPI: Using IOAPIC for interrupt routing
[   19.922736] Error attaching device data
[   19.922770] Error attaching device data
[   19.922804] Error attaching device data
[   19.922837] Error attaching device data
[   19.928742] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   19.929231] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[   19.929235] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
[   19.929844] PCI: Transparent bridge - 0000:00:1e.0
[   19.932260] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.932362] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[   19.932462] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[   19.932562] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 10 11 12 14 15)
[   19.932660] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.932760] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.932860] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[   19.932959] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[   19.933051] Linux Plug and Play Support v0.97 (c) Adam Belay
[   19.933060] pnp: PnP ACPI init
[   19.933067] ACPI: bus type pnp registered
[   19.936005] pnp: PnP ACPI: found 14 devices
[   19.936007] ACPI: ACPI bus type pnp unregistered
[   19.936010] PnPBIOS: Disabled by ACPI PNP
[   19.936052] PCI: Using ACPI for IRQ routing
[   19.936054] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   19.943775] NET: Registered protocol family 8
[   19.943777] NET: Registered protocol family 20
[   19.943827] pnp: 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[   19.943836] pnp: 00:09: ioport range 0xa00-0xadf has been reserved
[   19.943838] pnp: 00:09: ioport range 0xae0-0xaef has been reserved
[   19.943848] pnp: 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
[   19.943850] pnp: 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
[   19.943853] pnp: 00:0a: iomem range 0xffb80000-0xfffffffe could not be reserved
[   19.943857] pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[   19.943860] pnp: 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[   19.943864] pnp: 00:0c: iomem range 0xf0000000-0xf3ffffff has been reserved
[   19.943869] pnp: 00:0d: iomem range 0x0-0x9ffff could not be reserved
[   19.943871] pnp: 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[   19.943874] pnp: 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[   19.943876] pnp: 00:0d: iomem range 0x100000-0x3fffffff could not be reserved
[   19.944175] Time: tsc clocksource has been installed.
[   19.974107] PCI: Bridge: 0000:00:01.0
[   19.974108]   IO window: disabled.
[   19.974112]   MEM window: cbb00000-cfbfffff
[   19.974115]   PREFETCH window: cff00000-efefffff
[   19.974119] PCI: Bridge: 0000:00:1c.0
[   19.974120]   IO window: disabled.
[   19.974124]   MEM window: disabled.
[   19.974127]   PREFETCH window: disabled.
[   19.974131] PCI: Bridge: 0000:00:1c.1
[   19.974133]   IO window: c000-cfff
[   19.974138]   MEM window: cfc00000-cfcfffff
[   19.974141]   PREFETCH window: disabled.
[   19.974145] PCI: Bridge: 0000:00:1e.0
[   19.974146]   IO window: disabled.
[   19.974151]   MEM window: cfd00000-cfdfffff
[   19.974154]   PREFETCH window: disabled.
[   19.974169] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.974189] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.974209] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   19.974233] NET: Registered protocol family 2
[   20.012274] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   20.012344] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[   20.013264] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   20.013605] TCP: Hash tables configured (established 131072 bind 65536)
[   20.013608] TCP reno registered
[   20.024462] checking if image is initramfs... it is
[   20.472151] Switched to high resolution mode on CPU 1
[   20.476053] Switched to high resolution mode on CPU 0
[   20.568048] Freeing initrd memory: 7074k freed
[   20.568544] audit: initializing netlink socket (disabled)
[   20.568558] audit(1213901525.220:1): initialized
[   20.568636] highmem bounce pool size: 64 pages
[   20.570193] VFS: Disk quotas dquot_6.5.1
[   20.570233] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   20.570306] io scheduler noop registered
[   20.570308] io scheduler anticipatory registered
[   20.570310] io scheduler deadline registered
[   20.570321] io scheduler cfq registered (default)
[   20.570507] assign_interrupt_mode Found MSI capability
[   20.570615] assign_interrupt_mode Found MSI capability
[   20.570746] assign_interrupt_mode Found MSI capability
[   20.570895] isapnp: Scanning for PnP cards...
[   20.923706] isapnp: No Plug & Play device found
[   20.942067] Real Time Clock Driver v1.12ac
[   20.942160] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   20.942254] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.942803] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   20.943373] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[   20.943480] input: Macintosh mouse button emulation as /class/input/input0
[   20.943541] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   20.943543] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   20.945665] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.945670] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.945779] mice: PS/2 mouse device common for all mice
[   20.945859] EISA: Probing bus 0 at eisa.0
[   20.945887] EISA: Detected 0 cards.
[   20.945967] TCP cubic registered
[   20.945980] NET: Registered protocol family 1
[   20.945999] Using IPI No-Shortcut mode
[   20.946138]   Magic number: 12:675:898
[   20.946194]   hash matches device ptyy8
[   20.946202]   hash matches device ptyvb
[   20.946376] Freeing unused kernel memory: 364k freed
[   20.975607] input: AT Translated Set 2 keyboard as /class/input/input1
[   22.114720] AppArmor: AppArmor initialized<5>audit(1213901526.720:2):  type=1505 info="AppArmor initialized" pid=1221
[   22.121425] fuse init (API version 7.8)
[   22.126093] Failure registering capabilities with primary security module.
[   22.157919] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  DB, should be D6 [20070126]
[   22.157927] ACPI: SSDT 3FFCE0A0, 0235 (r1 DpgPmm  P001Ist       11 INTL 20051117)
[   22.158316] ACPI: SSDT 3FFCE530, 0235 (r1 DpgPmm  P002Ist       12 INTL 20051117)
[   22.158488] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   22.158496] ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
[   22.536607] usbcore: registered new interface driver usbfs
[   22.536633] usbcore: registered new interface driver hub
[   22.536650] usbcore: registered new device driver usb
[   22.537280] USB Universal Host Controller Interface driver v3.0
[   22.537334] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 18
[   22.537347] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   22.537465] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   22.537489] uhci_hcd 0000:00:1d.0: irq 18, io base 0x0000ec00
[   22.537584] usb usb1: configuration #1 chosen from 1 choice
[   22.537604] hub 1-0:1.0: USB hub found
[   22.537609] hub 1-0:1.0: 2 ports detected
[   22.577207] SCSI subsystem initialized
[   22.638739] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   22.638753] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   22.638777] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   22.638803] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e880
[   22.638880] usb usb2: configuration #1 chosen from 1 choice
[   22.638901] hub 2-0:1.0: USB hub found
[   22.638906] hub 2-0:1.0: 2 ports detected
[   22.742683] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
[   22.742706] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   22.742727] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   22.742753] uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000e800
[   22.742834] usb usb3: configuration #1 chosen from 1 choice
[   22.742858] hub 3-0:1.0: USB hub found
[   22.742865] hub 3-0:1.0: 2 ports detected
[   22.846609] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[   22.846626] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   22.846654] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   22.846681] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e480
[   22.846762] usb usb4: configuration #1 chosen from 1 choice
[   22.846785] hub 4-0:1.0: USB hub found
[   22.846790] hub 4-0:1.0: 2 ports detected
[   22.878475] usb 1-1: new low speed USB device using uhci_hcd and address 2
[   22.950770] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 18
[   22.950786] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   22.950814] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   22.950841] ehci_hcd 0000:00:1d.7: debug port 1
[   22.950853] ehci_hcd 0000:00:1d.7: irq 18, io mem 0xcfe3bc00
[   23.002430] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   23.002574] usb usb5: configuration #1 chosen from 1 choice
[   23.002596] hub 5-0:1.0: USB hub found
[   23.002603] hub 5-0:1.0: 8 ports detected
[   23.106441] r8169 Gigabit Ethernet driver 2.2LK loaded
[   23.106468] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   23.106676] eth0: RTL8168b/8111b at 0xf8856000, 00:1d:92:5f:de:ca, XID 38000000 IRQ 17
[   23.110686] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 20
[   23.110864] scsi0 : ata_piix
[   23.110910] scsi1 : ata_piix
[   23.110998] ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
[   23.111001] ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
[   23.434477] ata1.00: ATAPI: HL-DT-STDVD-RAM GSA-H58N, 1.01, max UDMA/66
[   23.606372] ata1.00: configured for UDMA/66
[   23.774062] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H58N 1.01 PQ: 0 ANSI: 5
[   23.774365] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   23.774387] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[   23.774442] scsi2 : ata_piix
[   23.774569] scsi3 : ata_piix
[   23.774742] ata3: SATA max UDMA/133 cmd 0x0001e400 ctl 0x0001e082 bmdma 0x0001d880 irq 19
[   23.774745] ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d888 irq 19
[   23.889887] usb 1-1: new low speed USB device using uhci_hcd and address 4
[   23.938902] ata3.00: ATA-8: WDC WD2500AAJS-000000, 01.03A01, max UDMA/133
[   23.938907] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   23.954897] ata3.00: configured for UDMA/133
[   24.089820] usb 1-1: configuration #1 chosen from 1 choice
[   24.104529] usbcore: registered new interface driver hiddev
[   24.120689] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-0 01.0 PQ: 0 ANSI: 5
[   24.127721] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   24.127733] sd 2:0:0:0: [sda] Write Protect is off
[   24.127748] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.127794] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   24.127802] sd 2:0:0:0: [sda] Write Protect is off
[   24.127816] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.127819]  sda:sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   24.135305] Uniform CD-ROM driver Revision: 3.20
[   24.138832]  sda1 sda2 <<6>input: HID 04d9:0499 as /class/input/input2
[   24.143917] input: USB HID v1.10 Mouse [HID 04d9:0499] on usb-0000:00:1d.0-1
[   24.143929] usbcore: registered new interface driver usbhid
[   24.143933] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   24.168605]  sda5 >
[   24.169083] sd 2:0:0:0: [sda] Attached SCSI disk
[   24.172260] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   24.172280] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   24.340344] Attempting manual resume
[   24.389845] kjournald starting.  Commit interval 5 seconds
[   24.389857] EXT3-fs: mounted filesystem with ordered data mode.
[   29.565499] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   29.566835] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   29.712335] Linux agpgart interface v0.102 (c) Dave Jones
[   29.956484] input: PC Speaker as /class/input/input3
[   30.040870] ath_hal: module license 'Proprietary' taints kernel.
[   30.042333] ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
[   30.042611] parport_pc 00:07: reported by Plug and Play ACPI
[   30.042658] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   30.153691] wlan: 0.8.4.2 (0.9.3.2)
[   30.169401] ath_pci: 0.9.4.5 (0.9.3.2)
[   30.169478] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.033273] iTCO_vendor_support: vendor-support=0
[   31.034127] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   31.034193] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
[   31.034228] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   31.061602] ath_rate_sample: 1.2 (0.9.3.2)
[   31.067996] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   31.068002] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   31.068010] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   31.068014] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   31.068018] wifi0: mac 7.9 phy 4.5 radio 5.6
[   31.068022] wifi0: Use hw queue 1 for WME_AC_BE traffic
[   31.068024] wifi0: Use hw queue 0 for WME_AC_BK traffic
[   31.068025] wifi0: Use hw queue 2 for WME_AC_VI traffic
[   31.068027] wifi0: Use hw queue 3 for WME_AC_VO traffic
[   31.068028] wifi0: Use hw queue 8 for CAB traffic
[   31.068030] wifi0: Use hw queue 9 for beacons
[   31.145233] wifi0: Atheros 5212: mem=0xcfdf0000, irq=16
[   31.145274] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.145391] NVRM: loading NVIDIA UNIX x86 Kernel Module  100.14.19  Wed Sep 12 14:12:24 PDT 2007
[   31.171397] Linux video capture interface: v2.00
[   31.190935] saa7130/34: v4l2 driver version 0.2.14 loaded
[   31.191054] ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 17 (level, low) -> IRQ 17
[   31.191062] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 17, latency: 64, mmio: 0xcfdef800
[   31.191067] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
[   31.191075] saa7133[0]: board init: gpio is 0
[   31.191228] input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input4
[   31.336525] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   31.341557] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   31.341571] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
[   31.341584] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
[   31.341596] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341608] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
[   31.341620] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341632] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341643] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341655] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341667] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341679] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341695] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341702] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341709] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341716] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.341723] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   31.417542] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   31.505464] tda829x 0-004b: setting tuner address to 61
[   31.541436] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   31.585419] tda829x 0-004b: type set to tda8290+75a
[   35.439406] saa7133[0]: registered device video0 [v4l2]
[   35.439423] saa7133[0]: registered device vbi0
[   35.439442] saa7133[0]: registered device radio0
[   35.516731] saa7134 ALSA driver for DMA sound loaded
[   35.516756] saa7133[0]/alsa: saa7133[0] at 0xcfdef800 irq 17 registered as card -2
[   35.611113] DVB: registering new adapter (saa7133[0])
[   35.611119] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   35.683049] tda1004x: setting up plls for 48MHz sampling clock
[   35.708460] loop: module loaded
[   35.723571] lp0: using parport0 (interrupt-driven).
[   37.969694] tda1004x: found firmware revision 0 -- invalid
[   37.969697] tda1004x: trying to boot from eeprom
[   40.336313] tda1004x: found firmware revision 0 -- invalid
[   40.336315] tda1004x: waiting for firmware upload...
[   52.793071] tda1004x: found firmware revision 20 -- ok
[   53.206915] Adding 3028212k swap on /dev/sda5.  Priority:-1 extents:1 across:3028212k
[   53.480093] EXT3 FS on sda1, internal journal
[   54.506170] No dock devices found.
[   54.639184] input: Power Button (FF) as /class/input/input5
[   54.639201] ACPI: Power Button (FF) [PWRF]
[   54.639288] input: Power Button (CM) as /class/input/input6
[   54.639300] ACPI: Power Button (CM) [PWRB]
[   55.781715] Failure registering capabilities with primary security module.
[   56.116235] r8169: eth0: link up
[   56.116245] r8169: eth0: link up
[   56.273226] ppdev: user-space parallel port driver
[   56.456988] audit(1213901561.794:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5084 profile="/usr/sbin/cupsd"
[   58.079013] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   58.079017] apm: disabled - APM is not SMP safe.
dhcdbd: Started up.
[   66.023510] Bluetooth: Core ver 2.11
[   66.023585] NET: Registered protocol family 31
[   66.023588] Bluetooth: HCI device and connection manager initialized
[   66.023593] Bluetooth: HCI socket layer initialized
[   66.071183] Bluetooth: L2CAP ver 2.8
[   66.071188] Bluetooth: L2CAP socket layer initialized
[   66.145959] Bluetooth: RFCOMM socket layer initialized
[   66.146042] Bluetooth: RFCOMM TTY layer initialized
[   66.146045] Bluetooth: RFCOMM ver 1.8
[   66.836899] tda1004x: setting up plls for 48MHz sampling clock
[   67.120742] tda1004x: found firmware revision 20 -- ok
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
[   70.241169] NET: Registered protocol family 17
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
[   72.088050] NET: Registered protocol family 10
[   72.088184] lo: Disabled Privacy Extensions
[   96.521804] usb 5-8: new high speed USB device using ehci_hcd and address 3
[   96.737996] usb 5-8: configuration #1 chosen from 1 choice
[   96.823359] usbcore: registered new interface driver libusual
[   96.858349] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   96.858355] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   96.864109] Initializing USB Mass Storage driver...
[   96.865529] scsi4 : SCSI emulation for USB Mass Storage devices
[   96.867221] usbcore: registered new interface driver usb-storage
[   96.867310] USB Mass Storage support registered.
[  101.874623] scsi 4:0:0:0: Direct-Access              USB Flash Memory 1.00 PQ: 0 ANSI: 2
[  101.882719] sd 4:0:0:0: [sdb] 1001472 512-byte hardware sectors (513 MB)
[  101.883339] sd 4:0:0:0: [sdb] Write Protect is off
[  101.891212] sd 4:0:0:0: [sdb] 1001472 512-byte hardware sectors (513 MB)
[  101.891833] sd 4:0:0:0: [sdb] Write Protect is off
[  101.891846]  sdb: sdb1
[  101.892914] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[  101.892970] sd 4:0:0:0: Attached scsi generic sg2 type 0
[  107.189203] UDF-fs: No partition found (1)
[  107.307267] Unable to identify CD-ROM format.



--------------020403090108030801060703
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020403090108030801060703--
