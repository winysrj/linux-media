Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44479 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0ITLgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 07:36:18 -0400
Received: by bwz11 with SMTP id 11so4144245bwz.19
        for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 04:36:16 -0700 (PDT)
Message-ID: <4C97472D.4090609@googlemail.com>
Date: Mon, 20 Sep 2010 13:36:13 +0200
From: Manfred Tillmanns <m.tillmanns@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Unknown EM2800 video grabber =  Cinergy 200 USB
Content-Type: multipart/mixed;
 boundary="------------050805020808000109000605"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------050805020808000109000605
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

> [   24.700034] em28xx #0: Please send an email with this log


Please find it attached to this mail...


Regards,

Manfred Tillmanns

--------------050805020808000109000605
Content-Type: text/plain;
 name="cinergy200-dmesg-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cinergy200-dmesg-log.txt"

[    0.196112] Switching to clocksource tsc
[    0.199582] AppArmor: AppArmor Filesystem Enabled
[    0.199616] pnp: PnP ACPI init
[    0.199642] ACPI: bus type pnp registered
[    0.202409] pnp 00:0c: io resource (0xf800-0xf81f) overlaps 0000:00:1f.0 BAR 13 (0xf800-0xf87f), disabling
[    0.202417] pnp 00:0c: io resource (0xf820-0xf83f) overlaps 0000:00:1f.0 BAR 13 (0xf800-0xf87f), disabling
[    0.202423] pnp 00:0c: io resource (0xf840-0xf85f) overlaps 0000:00:1f.0 BAR 13 (0xf800-0xf87f), disabling
[    0.202430] pnp 00:0c: io resource (0xf860-0xf87f) overlaps 0000:00:1f.0 BAR 13 (0xf800-0xf87f), disabling
[    0.203077] pnp: PnP ACPI: found 14 devices
[    0.203083] ACPI: ACPI bus type pnp unregistered
[    0.203090] PnPBIOS: Disabled by ACPI PNP
[    0.203116] system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
[    0.203128] system 00:0c: ioport range 0x400-0x41f has been reserved
[    0.203133] system 00:0c: ioport range 0x420-0x43f has been reserved
[    0.203144] system 00:0c: ioport range 0x440-0x45f has been reserved
[    0.203150] system 00:0c: ioport range 0x460-0x47f has been reserved
[    0.203155] system 00:0c: ioport range 0xfa00-0xfa3f has been reserved
[    0.203161] system 00:0c: ioport range 0xfc00-0xfc7f could not be reserved
[    0.203167] system 00:0c: ioport range 0xfc80-0xfcff has been reserved
[    0.203172] system 00:0c: ioport range 0xfe00-0xfe7f has been reserved
[    0.203178] system 00:0c: ioport range 0xfe80-0xfeff has been reserved
[    0.203191] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.203198] system 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
[    0.203203] system 00:0d: iomem range 0x80000000-0x800fffff has been reserved
[    0.203209] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.203215] system 00:0d: iomem range 0xfec01000-0xffffffff could not be reserved
[    0.203220] system 00:0d: iomem range 0xce000-0xdffff has been reserved
[    0.238142] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.238149] pci 0000:00:01.0:   IO window: 0x1000-0x1fff
[    0.238158] pci 0000:00:01.0:   MEM window: 0xf8500000-0xf87fffff
[    0.238165] pci 0000:00:01.0:   PREFETCH window: 0xe8000000-0xf81fffff
[    0.238175] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.238178] pci 0000:00:1e.0:   IO window: disabled
[    0.238187] pci 0000:00:1e.0:   MEM window: 0xf8200000-0xf84fffff
[    0.238194] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.238217] pci 0000:00:1e.0: setting latency timer to 64
[    0.238224] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.238229] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.238234] pci_bus 0000:01: resource 0 io:  [0x1000-0x1fff]
[    0.238238] pci_bus 0000:01: resource 1 mem: [0xf8500000-0xf87fffff]
[    0.238243] pci_bus 0000:01: resource 2 pref mem [0xe8000000-0xf81fffff]
[    0.238248] pci_bus 0000:05: resource 1 mem: [0xf8200000-0xf84fffff]
[    0.238252] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.238257] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.238322] NET: Registered protocol family 2
[    0.238496] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.239102] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.239849] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.240247] TCP: Hash tables configured (established 131072 bind 65536)
[    0.240254] TCP reno registered
[    0.240421] NET: Registered protocol family 1
[    0.240577] pci 0000:01:00.0: Boot video device
[    0.240774] cpufreq-nforce2: No nForce2 chipset.
[    0.240822] Scanning for low memory corruption every 60 seconds
[    0.241030] audit: initializing netlink socket (disabled)
[    0.241046] type=2000 audit(1284979017.239:1): initialized
[    0.250969] highmem bounce pool size: 64 pages
[    0.250979] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.253916] VFS: Disk quotas dquot_6.5.2
[    0.254051] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.255143] fuse init (API version 7.13)
[    0.255355] msgmni has been set to 1690
[    0.255767] alg: No test for stdrng (krng)
[    0.255892] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.255898] io scheduler noop registered
[    0.255902] io scheduler anticipatory registered
[    0.255905] io scheduler deadline registered
[    0.255976] io scheduler cfq registered (default)
[    0.256183] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.256231] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.256420] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.256432] ACPI: Power Button [PBTN]
[    0.256511] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.256516] ACPI: Power Button [PWRF]
[    0.256858] processor LNXCPU:00: registered as cooling_device0
[    0.257117] processor LNXCPU:01: registered as cooling_device1
[    0.258847] isapnp: Scanning for PnP cards...
[    0.261099] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.261204] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.261673] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.263467] brd: module loaded
[    0.264281] loop: module loaded
[    0.264432] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    0.264581] ata_piix 0000:00:1f.1: version 2.13
[    0.264597] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    0.264607]   alloc irq_desc for 18 on node -1
[    0.264610]   alloc kstat_irqs on node -1
[    0.264620] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.264671] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.319431] scsi0 : ata_piix
[    0.363536] scsi1 : ata_piix
[    0.363856] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x24c0 irq 14
[    0.363860] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x24c8 irq 15
[    0.363899] ata_piix 0000:00:1f.2: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.363906] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
[    0.436188] Freeing initrd memory: 7783k freed
[    0.519462] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.519574] scsi2 : ata_piix
[    0.519690] scsi3 : ata_piix
[    0.519745] ata3: SATA max UDMA/133 cmd 0x24f0 ctl 0x2808 bmdma 0x24d0 irq 18
[    0.519749] ata4: SATA max UDMA/133 cmd 0x24f8 ctl 0x280c bmdma 0x24d8 irq 18
[    0.520331] Fixed MDIO Bus: probed
[    0.520391] PPP generic driver version 2.4.2
[    0.520483] tun: Universal TUN/TAP device driver, 1.6
[    0.520487] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.520637] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.520671]   alloc irq_desc for 23 on node -1
[    0.520675]   alloc kstat_irqs on node -1
[    0.520684] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.520703] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.520708] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.520769] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.520807] ehci_hcd 0000:00:1d.7: debug port 1
[    0.524705] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[    0.524816] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf8a00000
[    0.539446] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.539597] usb usb1: configuration #1 chosen from 1 choice
[    0.539645] hub 1-0:1.0: USB hub found
[    0.539657] hub 1-0:1.0: 8 ports detected
[    0.539762] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.539788] uhci_hcd: USB Universal Host Controller Interface driver
[    0.539842]   alloc irq_desc for 16 on node -1
[    0.539845]   alloc kstat_irqs on node -1
[    0.539854] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.539863] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.539868] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.539926] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.539961] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002440
[    0.540100] usb usb2: configuration #1 chosen from 1 choice
[    0.540143] hub 2-0:1.0: USB hub found
[    0.540153] hub 2-0:1.0: 2 ports detected
[    0.540220]   alloc irq_desc for 19 on node -1
[    0.540224]   alloc kstat_irqs on node -1
[    0.540230] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.540239] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.540244] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.540300] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.540332] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002460
[    0.540465] usb usb3: configuration #1 chosen from 1 choice
[    0.540508] hub 3-0:1.0: USB hub found
[    0.540517] hub 3-0:1.0: 2 ports detected
[    0.540583] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.540592] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.540597] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.540658] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.540682] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002480
[    0.540823] usb usb4: configuration #1 chosen from 1 choice
[    0.540865] hub 4-0:1.0: USB hub found
[    0.540876] hub 4-0:1.0: 2 ports detected
[    0.541026] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    0.543832] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.543842] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.543974] mice: PS/2 mouse device common for all mice
[    0.544126] rtc_cmos 00:03: RTC can wake from S4
[    0.544186] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.544212] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.544383] device-mapper: uevent: version 1.0.3
[    0.544545] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    0.544638] device-mapper: multipath: version 1.1.0 loaded
[    0.544642] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.544814] EISA: Probing bus 0 at eisa.0
[    0.544823] Cannot allocate resource for EISA slot 1
[    0.544826] Cannot allocate resource for EISA slot 2
[    0.544857] EISA: Detected 0 cards.
[    0.544965] cpuidle: using governor ladder
[    0.544969] cpuidle: using governor menu
[    0.545710] TCP cubic registered
[    0.545917] NET: Registered protocol family 10
[    0.546668] lo: Disabled Privacy Extensions
[    0.547293] NET: Registered protocol family 17
[    0.547371] Using IPI No-Shortcut mode
[    0.547521] PM: Resume from disk failed.
[    0.547539] registered taskstats version 1
[    0.547819]   Magic number: 10:162:629
[    0.547905] rtc_cmos 00:03: setting system clock to 2010-09-20 10:36:58 UTC (1284979018)
[    0.547910] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.547913] EDD information not available.
[    0.567161] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.611717] ata2.00: ATAPI: _NEC DVD+RW ND-1100A, 1.80, max UDMA/33
[    0.613071] isapnp: No Plug & Play device found
[    0.627608] ata2.00: configured for UDMA/33
[    0.667787] ata1.00: ATA-6: ST380011A, 8.10, max UDMA/100
[    0.667791] ata1.00: 156301488 sectors, multi 16: LBA48 
[    0.683706] ata1.00: configured for UDMA/100
[    0.683846] scsi 0:0:0:0: Direct-Access     ATA      ST380011A        8.10 PQ: 0 ANSI: 5
[    0.684082] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.690315] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    0.690391] sd 0:0:0:0: [sda] Write Protect is off
[    0.690395] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.690434] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.690650]  sda:
[    0.702118] scsi 1:0:0:0: CD-ROM            _NEC     DVD+RW ND-1100A  1.80 PQ: 0 ANSI: 5
[    0.705004]  sda1 sda2 sda3 <sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    0.705645] Uniform CD-ROM driver Revision: 3.20
[    0.705768] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.705847] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    0.723307]  sda5 sda6 sda7 >
[    0.781114] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.781131] Freeing unused kernel memory: 656k freed
[    0.781781] Write protecting the kernel text: 4684k
[    0.781842] Write protecting the kernel read-only data: 1840k
[    0.808874] udev: starting version 151
[    0.859435] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    0.987430] Floppy drive(s): fd0 is 1.44M
[    0.994046] usb 1-3: configuration #1 chosen from 1 choice
[    1.005734] FDC 0 is a post-1991 82077
[    1.017573] tg3.c:v3.102 (September 1, 2009)
[    1.017596]   alloc irq_desc for 20 on node -1
[    1.017601]   alloc kstat_irqs on node -1
[    1.017612] tg3 0000:05:02.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.092785] eth0: Tigon3 [partno(BCM95782A50) rev 3003] (PCI:33MHz:32-bit) MAC address 00:11:85:ed:ee:5a
[    1.092791] eth0: attached PHY is 5705 (10/100/1000Base-T Ethernet) (WireSpeed[0])
[    1.092794] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.092797] eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
[    1.103555] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    1.229457] usb 1-4: configuration #1 chosen from 1 choice
[    1.229994] hub 1-4:1.0: USB hub found
[    1.230341] hub 1-4:1.0: 4 ports detected
[    1.500337] usb 1-4.2: new full speed USB device using ehci_hcd and address 4
[    1.523040] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    1.634810] usb 1-4.2: configuration #1 chosen from 1 choice
[    1.704323] usb 1-4.4: new low speed USB device using ehci_hcd and address 5
[    1.801793] usb 1-4.4: configuration #1 chosen from 1 choice
[   13.201498] Adding 2963984k swap on /dev/sda2.  Priority:-1 extents:1 across:2963984k 
[   13.209330] udev: starting version 151
[   13.394820] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.395359] intel_rng: Firmware space is locked read-only. If you can't or
[   13.395361] intel_rng: don't want to disable this in firmware setup, and if
[   13.395363] intel_rng: you are certain that your system has a functional
[   13.395365] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   13.400895] Linux agpgart interface v0.103
[   13.575172] lp: driver loaded but no devices found
[   13.628133] agpgart-intel 0000:00:00.0: Intel 865 Chipset
[   13.646443] parport_pc 00:07: reported by Plug and Play ACPI
[   13.646472] parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
[   13.676827] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe0000000
[   13.718798] usblp0: USB Bidirectional printer dev 4 if 0 alt 0 proto 2 vid 0x03F0 pid 0x3304
[   13.718851] usbcore: registered new interface driver usblp
[   13.738561] [drm] Initialized drm 1.1.0 20060810
[   13.749285] lp0: using parport0 (interrupt-driven).
[   13.761635] ppdev: user-space parallel port driver
[   13.784138] usbcore: registered new interface driver hiddev
[   13.788519] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.4/1-4.4:1.0/input/input4
[   13.788794] generic-usb 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-4.4/input0
[   13.788857] usbcore: registered new interface driver usbhid
[   13.788865] usbhid: v2.6:USB HID core driver
[   13.824539] type=1505 audit(1284979031.776:2):  operation="profile_load" pid=518 name="/sbin/dhclient3"
[   13.825143] type=1505 audit(1284979031.776:3):  operation="profile_load" pid=518 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   13.825470] type=1505 audit(1284979031.776:4):  operation="profile_load" pid=518 name="/usr/lib/connman/scripts/dhclient-script"
[   13.845488] type=1505 audit(1284979031.796:5):  operation="profile_load" pid=531 name="/usr/sbin/ntpd"
[   13.897298] [drm] radeon defaulting to kernel modesetting.
[   13.897305] [drm] radeon kernel modesetting enabled.
[   13.897383] radeon 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   13.900351] [drm] radeon: Initializing kernel modesetting.
[   13.900503] [drm] register mmio base: 0xF8500000
[   13.900508] [drm] register mmio size: 65536
[   13.900810] [drm] GPU reset succeed (RBBM_STATUS=0x00000140)
[   13.900836] [drm] Generation 2 PCI interface, using max accessible memory
[   13.900856] agpgart-intel 0000:00:00.0: AGP 3.0 bridge
[   13.900884] agpgart-intel 0000:00:00.0: putting AGP V3 device into 8x mode
[   13.900939] radeon 0000:01:00.0: putting AGP V3 device into 8x mode
[   13.900964] [drm] radeon: VRAM 128M
[   13.900968] [drm] radeon: VRAM from 0x00000000 to 0x07FFFFFF
[   13.900972] [drm] radeon: GTT 128M
[   13.900975] [drm] radeon: GTT from 0xE0000000 to 0xE7FFFFFF
[   13.901006] [drm] radeon: irq initialized.
[   13.901177] [drm] Detected VRAM RAM=128M, BAR=128M
[   13.901184] [drm] RAM width 64bits DDR
[   13.901308] [TTM] Zone  kernel: Available graphics memory: 436940 kiB.
[   13.901313] [TTM] Zone highmem: Available graphics memory: 1030832 kiB.
[   13.901340] [drm] radeon: 128M of VRAM memory ready
[   13.901344] [drm] radeon: 128M of GTT memory ready.
[   13.901606] [drm] radeon: cp idle (0x02000603)
[   13.901683] [drm] Loading R200 Microcode
[   13.901689] platform radeon_cp.0: firmware: requesting radeon/R200_cp.bin
[   13.919747] [drm] radeon: ring at 0x00000000E0000000
[   13.919773] [drm] ring test succeeded in 1 usecs
[   13.926632] [drm] radeon: ib pool ready.
[   13.926797] [drm] ib test succeeded in 0 usecs
[   13.932416] [drm] Default TV standard: PAL
[   13.932421] [drm] 27.000000000 MHz TV ref clk
[   13.932427] [drm] Default TV standard: PAL
[   13.932431] [drm] 27.000000000 MHz TV ref clk
[   13.932565] [drm] Radeon Display Connectors
[   13.932571] [drm] Connector 0:
[   13.932574] [drm]   VGA
[   13.932579] [drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[   13.932582] [drm]   Encoders:
[   13.932586] [drm]     CRT1: INTERNAL_DAC1
[   13.932589] [drm] Connector 1:
[   13.932592] [drm]   S-video
[   13.932595] [drm]   Encoders:
[   13.932598] [drm]     TV1: INTERNAL_DAC2
[   14.039519]   alloc irq_desc for 17 on node -1
[   14.039525]   alloc kstat_irqs on node -1
[   14.039535] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.039568] Intel ICH 0000:00:1f.5: setting latency timer to 64
[   14.117216] [drm] fb mappable at 0xE8040000
[   14.117221] [drm] vram apper at 0xE8000000
[   14.117225] [drm] size 5242880
[   14.117229] [drm] fb depth is 24
[   14.117232] [drm]    pitch is 5120
[   14.120641] fb0: radeondrmfb frame buffer device
[   14.120646] registered panic notifier
[   14.120658] [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
[   14.127447] vga16fb: initializing
[   14.127456] vga16fb: mapped to 0xc00a0000
[   14.127465] vga16fb: not registering due to another framebuffer present
[   14.236204] Console: switching to colour frame buffer device 160x64
[   14.237480] Linux video capture interface: v2.00
[   14.461030] intel8x0_measure_ac97_clock: measured 54744 usecs (2637 samples)
[   14.461037] intel8x0: clocking to 48000
[   14.787951] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0, class 0)
[   14.788332] em28xx #0: em28xx chip ID = 4
[   14.941659] em28xx #0: board has no eeprom
[   15.016036] em28xx #0: preparing read at i2c address 0x60 failed (error=-19)
[   15.084027] em28xx #0: Identified as Unknown EM2800 video grabber (card=0)
[   17.801105] EXT4-fs (sda5): mounted filesystem with ordered data mode
[   20.105423] type=1505 audit(1284979038.056:6):  operation="profile_load" pid=703 name="/usr/share/gdm/guest-session/Xsession"
[   20.108776] type=1505 audit(1284979038.060:7):  operation="profile_replace" pid=704 name="/sbin/dhclient3"
[   20.109592] type=1505 audit(1284979038.060:8):  operation="profile_replace" pid=704 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   20.109950] type=1505 audit(1284979038.060:9):  operation="profile_replace" pid=704 name="/usr/lib/connman/scripts/dhclient-script"
[   20.118003] type=1505 audit(1284979038.068:10):  operation="profile_load" pid=705 name="/usr/bin/evince"
[   20.125985] type=1505 audit(1284979038.076:11):  operation="profile_load" pid=705 name="/usr/bin/evince-previewer"
[   20.130904] type=1505 audit(1284979038.080:12):  operation="profile_load" pid=705 name="/usr/bin/evince-thumbnailer"
[   20.145167] type=1505 audit(1284979038.096:13):  operation="profile_load" pid=709 name="/usr/lib/cups/backend/cups-pdf"
[   20.145963] type=1505 audit(1284979038.096:14):  operation="profile_load" pid=709 name="/usr/sbin/cupsd"
[   20.151568] type=1505 audit(1284979038.100:15):  operation="profile_replace" pid=710 name="/usr/sbin/ntpd"
[   20.204777] tg3 0000:05:02.0: firmware: requesting tigon/tg3_tso5.bin
[   20.511569] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.595334] microcode: CPU0 sig=0xf29, pf=0x4, revision=0x2e
[   20.595344] platform microcode: firmware: requesting intel-ucode/0f-02-09
[   20.613289] microcode: CPU1 sig=0xf29, pf=0x4, revision=0x2e
[   20.613312] platform microcode: firmware: requesting intel-ucode/0f-02-09
[   20.625251] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.731670] CPU0 attaching NULL sched-domain.
[   21.731678] CPU1 attaching NULL sched-domain.
[   21.761077] CPU0 attaching sched-domain:
[   21.761083]  domain 0: span 0-1 level SIBLING
[   21.761088]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   21.761099]   domain 1: span 0-1 level MC
[   21.761103]    groups: 0-1 (cpu_power = 1178)
[   21.761113] CPU1 attaching sched-domain:
[   21.761116]  domain 0: span 0-1 level SIBLING
[   21.761120]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   21.761129]   domain 1: span 0-1 level MC
[   21.761133]    groups: 0-1 (cpu_power = 1178)
[   22.078843] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   22.078854] tg3: eth0: Flow control is on for TX and on for RX.
[   22.079098] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   24.700025] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   24.700031] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   24.700034] em28xx #0: Please send an email with this log to:
[   24.700037] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   24.700040] em28xx #0: Board eeprom hash is 0x00000000
[   24.700043] em28xx #0: Board i2c devicelist hash is 0x1b800080
[   24.700045] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   24.700048] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   24.700051] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   24.700054] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   24.700057] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   24.700060] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   24.700062] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   24.700065] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   24.700068] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   24.700071] em28xx #0:     card=8 -> Kworld USB2800
[   24.700074] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   24.700077] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   24.700080] em28xx #0:     card=11 -> Terratec Hybrid XS
[   24.700082] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   24.700085] em28xx #0:     card=13 -> Terratec Prodigy XS
[   24.700088] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   24.700091] em28xx #0:     card=15 -> V-Gear PocketTV
[   24.700094] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   24.700097] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   24.700099] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   24.700102] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   24.700105] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   24.700108] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   24.700111] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   24.700118] em28xx #0:     card=23 -> Huaqi DLCW-130
[   24.700121] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   24.700123] em28xx #0:     card=25 -> Gadmei UTV310
[   24.700126] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   24.700129] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   24.700132] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   24.700135] em28xx #0:     card=29 -> <NULL>
[   24.700137] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   24.700140] em28xx #0:     card=31 -> Usbgear VD204v9
[   24.700143] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   24.700145] em28xx #0:     card=33 -> <NULL>
[   24.700148] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   24.700151] em28xx #0:     card=35 -> Typhoon DVD Maker
[   24.700154] em28xx #0:     card=36 -> NetGMBH Cam
[   24.700156] em28xx #0:     card=37 -> Gadmei UTV330
[   24.700159] em28xx #0:     card=38 -> Yakumo MovieMixer
[   24.700162] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   24.700164] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   24.700167] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   24.700170] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   24.700173] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   24.700175] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   24.700178] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   24.700181] em28xx #0:     card=46 -> Compro, VideoMate U3
[   24.700184] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   24.700186] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   24.700189] em28xx #0:     card=49 -> MSI DigiVox A/D
[   24.700192] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   24.700194] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   24.700197] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   24.700200] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   24.700203] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   24.700205] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   24.700208] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   24.700211] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   24.700214] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   24.700217] em28xx #0:     card=59 -> <NULL>
[   24.700219] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   24.700222] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   24.700225] em28xx #0:     card=62 -> Gadmei TVR200
[   24.700227] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   24.700230] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   24.700233] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   24.700235] em28xx #0:     card=66 -> Empire dual TV
[   24.700238] em28xx #0:     card=67 -> Terratec Grabby
[   24.700241] em28xx #0:     card=68 -> Terratec AV350
[   24.700243] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   24.700246] em28xx #0:     card=70 -> Evga inDtube
[   24.700249] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   24.700252] em28xx #0:     card=72 -> Gadmei UTV330+
[   24.700254] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   25.000226] em28xx #0: Config register raw data: 0x2b
[   25.000230] em28xx #0: I2S Audio (3 sample rates)
[   25.000233] em28xx #0: No AC97 audio processor
[   25.064015] em28xx #0: v4l2 driver version 0.1.2
[   25.504132] em28xx #0: V4L2 video device registered as /dev/video0
[   25.504171] usbcore: registered new interface driver em28xx
[   25.504176] em28xx driver loaded
[   25.541302] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   25.541309] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[   25.549173] Em28xx: Initialized (Em28xx Audio Extension) extension
[   25.736096] usb 1-3: selecting invalid altsetting 7
[   25.875077] CPU0 attaching NULL sched-domain.
[   25.875087] CPU1 attaching NULL sched-domain.
[   25.904170] CPU0 attaching sched-domain:
[   25.904177]  domain 0: span 0-1 level SIBLING
[   25.904183]   groups: 0 (cpu_power = 589) 1 (cpu_power = 589)
[   25.904195]   domain 1: span 0-1 level MC
[   25.904200]    groups: 0-1 (cpu_power = 1178)
[   25.904211] CPU1 attaching sched-domain:
[   25.904216]  domain 0: span 0-1 level SIBLING
[   25.904221]   groups: 1 (cpu_power = 589) 0 (cpu_power = 589)
[   25.904232]   domain 1: span 0-1 level MC
[   25.904237]    groups: 0-1 (cpu_power = 1178)
[   26.568966] usb 1-4.2: usbfs: interface 0 claimed by usblp while 'usb' sets config #1
[   32.124009] eth0: no IPv6 routers present
[   38.552062] usb 1-3: selecting invalid altsetting 7

---------------------------------------------------------
lsusb - dump:

Bus 001 Device 002: ID eb1a:2800 eMPIA Technology, Inc. Terratec Cinergy 200


--------------050805020808000109000605--
