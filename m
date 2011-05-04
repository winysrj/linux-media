Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55326 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1EDRWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 13:22:37 -0400
Received: by wya21 with SMTP id 21so1013924wya.19
        for <linux-media@vger.kernel.org>; Wed, 04 May 2011 10:22:35 -0700 (PDT)
Subject: HOW TO MAKE DVB STICK WORK
From: anibal <cgarauper@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-9Iwz2a/zpAdTfxMJdx7t"
Date: Wed, 04 May 2011 19:22:26 +0200
Message-ID: <1304529746.2179.4.camel@anibal-PCLX>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--=-9Iwz2a/zpAdTfxMJdx7t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi,
I'm trying to make a BEST BUY EASY TV USB HYBRID PRO work. When I do
lsusb this is what I get:
"Bus 001 Device 006: ID eb1a:2881 eMPIA Technology, Inc. EM2881 Video
Controller"

Could you help me with this?

I attach the dmesg log



--=-9Iwz2a/zpAdTfxMJdx7t
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    2.011536] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0xa
[    2.011582] Using IPI No-Shortcut mode
[    2.011703] PM: Hibernation image not present or could not be loaded.
[    2.011720] registered taskstats version 1
[    2.011924]   Magic number: 11:608:86
[    2.012076] rtc_cmos 00:02: setting system clock to 2011-05-04 17:03:42 UTC (1304528622)
[    2.012080] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.012082] EDD information not available.
[    2.012198] Freeing unused kernel memory: 700k freed
[    2.012851] Write protecting the kernel text: 5192k
[    2.012890] Write protecting the kernel read-only data: 2148k
[    2.044498] <30>udev[59]: starting version 167
[    2.196068] usb 1-5: new high speed USB device using ehci_hcd and address 5
[    2.202817] sata_uli 0000:00:0e.1: version 1.3
[    2.202836] sata_uli 0000:00:0e.1: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.249591] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    2.292561] scsi0 : sata_uli
[    2.298609] scsi1 : sata_uli
[    2.298706] ata1: SATA max UDMA/133 cmd 0xec00 ctl 0xe800 bmdma 0xdc00 irq 19
[    2.298710] ata2: SATA max UDMA/133 cmd 0xe400 ctl 0xe000 bmdma 0xdc08 irq 19
[    2.299615] uli526x 0000:00:0d.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.327768] Floppy drive(s): fd0 is 1.44M
[    2.350029] FDC 0 is a post-1991 82077
[    2.357790] net eth0: ULi M5263 at pci0000:00:0d.0, 00:0b:6a:93:6e:dd, irq 17
[    2.357839] pata_ali 0000:00:0e.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.358706] scsi2 : pata_ali
[    2.358840] scsi3 : pata_ali
[    2.360331] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    2.360334] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    2.369614] usbcore: registered new interface driver uas
[    2.540249] ata3.00: ATAPI: HL-DT-STDVD-ROM GDR8162B, 0015, max UDMA/33
[    2.540254] ata3.00: WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled
[    2.540257] ata3.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[    2.556130] ata3.00: configured for UDMA/33
[    2.764029] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.772351] ata1.00: ATA-8: ST1000DL002-9TT153, CC32, max UDMA/133
[    2.772354] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.788341] ata1.00: configured for UDMA/133
[    2.788489] scsi 0:0:0:0: Direct-Access     ATA      ST1000DL002-9TT1 CC32 PQ: 0 ANSI: 5
[    2.788707] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.788837] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.788888] sd 0:0:0:0: [sda] Write Protect is off
[    2.788891] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.788914] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.827124]  sda: sda1 sda2 < sda5 sda6 >
[    2.827492] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.836017] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    3.074954] usbcore: registered new interface driver usbhid
[    3.074959] usbhid: USB HID core driver
[    3.112454] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8162B 0015 PQ: 0 ANSI: 5
[    3.120098] sr0: scsi3-mmc drive: 20x/48x cd/rw xa/form2 cdda tray
[    3.120101] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.120257] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.120344] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    3.228011] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    3.301812] Initializing USB Mass Storage driver...
[    3.307732] scsi4 : usb-storage 1-5:1.0
[    3.310107] usbcore: registered new interface driver usb-storage
[    3.310113] USB Mass Storage support registered.
[    3.313195] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:0f.1/usb4/4-2/4-2:1.0/input/input2
[    3.313453] logitech 0003:046D:C517.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:0f.1-2/input0
[    3.321960] logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
[    3.325013] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:0f.1/usb4/4-2/4-2:1.1/input/input3
[    3.325940] logitech 0003:046D:C517.0002: input,hiddev0,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:0f.1-2/input1
[    3.608202] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.756057] usb 6-1: new full speed USB device using ohci_hcd and address 2
[    4.148018] usb 7-1: new low speed USB device using ohci_hcd and address 2
[    4.310657] scsi 4:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0128 PQ: 0 ANSI: 0
[    4.311640] scsi 4:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0128 PQ: 0 ANSI: 0
[    4.312765] scsi 4:0:0:2: Direct-Access     Generic  STORAGE DEVICE   0128 PQ: 0 ANSI: 0
[    4.313764] scsi 4:0:0:3: Direct-Access     Generic  STORAGE DEVICE   0128 PQ: 0 ANSI: 0
[    4.314257] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    4.314420] sd 4:0:0:1: Attached scsi generic sg3 type 0
[    4.314580] sd 4:0:0:2: Attached scsi generic sg4 type 0
[    4.314738] sd 4:0:0:3: Attached scsi generic sg5 type 0
[    4.329012] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    4.330380] sd 4:0:0:1: [sdc] Attached SCSI removable disk
[    4.331756] sd 4:0:0:2: [sdd] Attached SCSI removable disk
[    4.333128] sd 4:0:0:3: [sde] Attached SCSI removable disk
[    4.380488] input: KYE Systems Genius NetPRO USB as /devices/pci0000:00/0000:00:02.0/0000:02:06.1/usb7/7-1/7-1:1.0/input/input4
[    4.380622] generic-usb 0003:0458:0002.0003: input,hidraw2: USB HID v1.00 Mouse [KYE Systems Genius NetPRO USB] on usb-0000:02:06.1-1/input0
[    7.464301] usb 1-3: USB disconnect, address 3
[   12.574379] Adding 8787964k swap on /dev/sda5.  Priority:-1 extents:1 across:8787964k 
[   12.603185] <30>udev[290]: starting version 167
[   12.696663] lp: driver loaded but no devices found
[   12.873312] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   13.028538] ali1535_smbus 0000:00:03.1: ALI1535_smb region uninitialized - upgrade BIOS?
[   13.028546] ali1535_smbus 0000:00:03.1: ALI1535 not detected, module not inserted.
[   13.030067] ali1563_smbus 0000:00:03.0: Found ALi1563 SMBus at 0x0400
[   13.187412] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   13.190360] ali15x3_smbus 0000:00:03.1: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
[   13.190367] ali15x3_smbus 0000:00:03.1: ALI15X3 not detected, module not inserted.
[   13.198150] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.496165] parport_pc 00:06: reported by Plug and Play ACPI
[   13.496274] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   13.633974] lp0: using parport0 (interrupt-driven).
[   13.658571] gameport gameport0: NS558 PnP Gameport is pnp00:07/gameport0, io 0x200, speed 890kHz
[   13.755920] Linux video capture interface: v2.00
[   13.814410] type=1400 audit(1304528634.299:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=492 comm="apparmor_parser"
[   13.814847] type=1400 audit(1304528634.299:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=492 comm="apparmor_parser"
[   13.815118] type=1400 audit(1304528634.299:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=492 comm="apparmor_parser"
[   13.946966] gspca: v2.12.0 registered
[   13.995238] STV06xx: Probing for a stv06xx device
[   13.995245] gspca: probing 046d:0870
[   13.995251] STV06xx: Configuring camera
[   14.099882] STV06xx: HDCS-1020 sensor detected
[   14.099887] STV06xx: Initializing camera
[   14.257080] type=1400 audit(1304528634.743:5): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=724 comm="apparmor_parser"
[   14.263353] type=1400 audit(1304528634.747:6): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=725 comm="apparmor_parser"
[   14.268176] type=1400 audit(1304528634.755:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=725 comm="apparmor_parser"
[   14.268477] type=1400 audit(1304528634.755:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=725 comm="apparmor_parser"
[   14.308608] type=1400 audit(1304528634.795:9): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=727 comm="apparmor_parser"
[   14.359229] type=1400 audit(1304528634.843:10): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=727 comm="apparmor_parser"
[   14.397348] type=1400 audit(1304528634.883:11): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=727 comm="apparmor_parser"
[   14.468214] input: STV06xx as /devices/pci0000:00/0000:00:02.0/0000:02:06.0/usb6/6-1/input/input5
[   14.468554] gspca: video0 created
[   14.468887] usbcore: registered new interface driver STV06xx
[   14.697291] ppdev: user-space parallel port driver
[   14.716457] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.032002] [drm] Initialized drm 1.1.0 20060810
[   15.183823] Intel ICH 0000:00:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   15.242216] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.257806] [drm] nouveau 0000:01:00.0: Detected an NV30 generation card (0x034200b1)
[   15.258006] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   15.313032] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   15.313250] [drm] nouveau 0000:01:00.0: BMP BIOS found
[   15.313254] [drm] nouveau 0000:01:00.0: BMP version 5.39
[   15.313257] [drm] nouveau 0000:01:00.0: Bios version 04.34.20.23
[   15.313261] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 2.2
[   15.313266] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000300 000088b8
[   15.313270] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02010310 000088b8
[   15.313272] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 03010312 00000000
[   15.313275] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02020321 00000003
[   15.313428] [drm] nouveau 0000:01:00.0: Loading NV17 power sequencing microcode
[   15.313433] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xEA03
[   15.313472] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xEC07
[   15.313482] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xED4D
[   15.313526] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEED3
[   15.313531] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEEF0
[   15.313537] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xEF0D
[   15.432428] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xF091
[   15.556004] [drm] nouveau 0000:01:00.0: 0 available performance level(s)
[   15.556060] [drm] nouveau 0000:01:00.0: c: memory 295MHz core 231MHz
[   15.562451] [TTM] Zone  kernel: Available graphics memory: 443008 kiB.
[   15.562456] [TTM] Zone highmem: Available graphics memory: 512484 kiB.
[   15.562459] [TTM] Initializing pool allocator.
[   15.562477] [drm] nouveau 0000:01:00.0: Detected 128MiB VRAM
[   15.563012] agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
[   15.563031] agpgart: modprobe tried to set rate=x12. Setting to AGP3 x8 mode.
[   15.563041] agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
[   15.563071] nouveau 0000:01:00.0: putting AGP V3 device into 8x mode
[   15.563088] [drm] nouveau 0000:01:00.0: 64 MiB GART (aperture)
[   15.570823] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   15.570829] [drm] No driver support for vblank timestamp query.
[   15.583599] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 0)
[   15.583605] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 1)
[   15.583610] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on tmds encoder (output 2)
[   15.583615] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 3)
[   15.844627] [drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x49000, bo f2ee1200
[   15.846408] Console: switching to colour frame buffer device 160x64
[   15.846465] fb0: nouveaufb frame buffer device
[   15.846468] drm: registered panic notifier
[   15.846482] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   16.248051] AC'97 1 does not respond - RESET
[   16.248512] AC'97 1 access is not valid [0xffffffff], removing mixer.
[   16.248520] Unable to initialize codec #1
[   16.304049] intel8x0_measure_ac97_clock: measured 54993 usecs (2656 samples)
[   16.304055] intel8x0: clocking to 48000
[   16.501967] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   16.525941] EXT4-fs (sda6): re-mounted. Opts: commit=0
[   17.638781] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga encoder (output 0)
[   17.638789] [drm] nouveau 0000:01:00.0: Output VGA-1 is running on CRTC 0 using output A
[   17.720362] uli526x: eth0 NIC Link is Up 100 Mbps Full duplex
[   17.720669] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.140142] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   22.147334] EXT4-fs (sda6): re-mounted. Opts: commit=0
[   28.144005] eth0: no IPv6 routers present
[   76.996138] Marking TSC unstable due to cpufreq changes
[   76.996213] Switching to clocksource acpi_pm
[   82.897862] IR NEC protocol handler initialized
[   82.916288] IR RC5(x) protocol handler initialized
[   82.935512] IR RC6 protocol handler initialized
[   82.954123] usbcore: registered new interface driver em28xx
[   82.954132] em28xx driver loaded
[   83.012091] IR JVC protocol handler initialized
[   83.020228] IR Sony protocol handler initialized
[   83.031609] lirc_dev: IR Remote Control driver registered, major 250 
[   83.037319] IR LIRC bridge handler initialized
[   91.732085] usb 1-3: new high speed USB device using ehci_hcd and address 6
[   91.868813] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class 0)
[   91.868949] em28xx #0: chip ID is em2882/em2883
[   91.951954] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
[   91.951967] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
[   91.951977] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00 5b 1e 00 00
[   91.951985] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
[   91.951994] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952027] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952035] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
[   91.952043] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
[   91.952052] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
[   91.952060] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952068] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952077] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952085] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952093] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952101] em28xx #0: i2c eeprom e0: 5a 00 55 aa 23 21 5b 03 00 17 fc 01 00 00 00 00
[   91.952110] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
[   91.952120] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xa2d00320
[   91.952123] em28xx #0: EEPROM info:
[   91.952125] em28xx #0:	AC97 audio (5 sample rates)
[   91.952127] em28xx #0:	USB Remote wakeup capable
[   91.952128] em28xx #0:	500mA max power
[   91.952131] em28xx #0:	Table at 0x04, strings=0x206a, 0x006a, 0x0000
[   91.983472] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   91.987848] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[   91.989471] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[   92.000356] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   92.000365] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   92.000367] em28xx #0: Please send an email with this log to:
[   92.000369] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   92.000372] em28xx #0: Board eeprom hash is 0xa2d00320
[   92.000374] em28xx #0: Board i2c devicelist hash is 0x27e10080
[   92.000376] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   92.000379] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   92.000382] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   92.000385] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   92.000387] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   92.000390] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   92.000392] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   92.000394] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   92.000397] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   92.000399] em28xx #0:     card=8 -> Kworld USB2800
[   92.000402] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   92.000405] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   92.000407] em28xx #0:     card=11 -> Terratec Hybrid XS
[   92.000410] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   92.000412] em28xx #0:     card=13 -> Terratec Prodigy XS
[   92.000414] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   92.000417] em28xx #0:     card=15 -> V-Gear PocketTV
[   92.000419] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   92.000422] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   92.000424] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   92.000427] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   92.000429] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   92.000432] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   92.000434] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   92.000437] em28xx #0:     card=23 -> Huaqi DLCW-130
[   92.000439] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   92.000442] em28xx #0:     card=25 -> Gadmei UTV310
[   92.000444] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   92.000446] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   92.000449] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   92.000452] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[   92.000454] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   92.000457] em28xx #0:     card=31 -> Usbgear VD204v9
[   92.000459] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   92.000461] em28xx #0:     card=33 -> Elgato Video Capture
[   92.000463] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   92.000466] em28xx #0:     card=35 -> Typhoon DVD Maker
[   92.000468] em28xx #0:     card=36 -> NetGMBH Cam
[   92.000471] em28xx #0:     card=37 -> Gadmei UTV330
[   92.000473] em28xx #0:     card=38 -> Yakumo MovieMixer
[   92.000475] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   92.000477] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   92.000480] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   92.000482] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   92.000485] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   92.000487] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   92.000490] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   92.000492] em28xx #0:     card=46 -> Compro, VideoMate U3
[   92.000494] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   92.000497] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   92.000499] em28xx #0:     card=49 -> MSI DigiVox A/D
[   92.000501] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   92.000503] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   92.000506] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   92.000508] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   92.000510] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   92.000513] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[   92.000515] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   92.000518] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   92.000520] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   92.000523] em28xx #0:     card=59 -> (null)
[   92.000525] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   92.000527] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   92.000530] em28xx #0:     card=62 -> Gadmei TVR200
[   92.000532] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   92.000534] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   92.000537] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   92.000539] em28xx #0:     card=66 -> Empire dual TV
[   92.000541] em28xx #0:     card=67 -> Terratec Grabby
[   92.000543] em28xx #0:     card=68 -> Terratec AV350
[   92.000546] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   92.000548] em28xx #0:     card=70 -> Evga inDtube
[   92.000550] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   92.000553] em28xx #0:     card=72 -> Gadmei UTV330+
[   92.000555] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   92.000557] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   92.000560] em28xx #0:     card=75 -> Dikom DK300
[   92.000562] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[   92.000565] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[   92.000567] em28xx #0: Board not discovered
[   92.000569] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[   92.000572] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   92.000574] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   92.000577] em28xx #0: Please send an email with this log to:
[   92.000579] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   92.000581] em28xx #0: Board eeprom hash is 0xa2d00320
[   92.000583] em28xx #0: Board i2c devicelist hash is 0x27e10080
[   92.000585] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   92.000588] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   92.000590] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   92.000592] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   92.000595] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   92.000597] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   92.000599] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   92.000601] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   92.000604] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   92.000606] em28xx #0:     card=8 -> Kworld USB2800
[   92.000608] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   92.000611] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   92.000614] em28xx #0:     card=11 -> Terratec Hybrid XS
[   92.000616] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   92.000618] em28xx #0:     card=13 -> Terratec Prodigy XS
[   92.000621] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   92.000623] em28xx #0:     card=15 -> V-Gear PocketTV
[   92.000626] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   92.000628] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   92.000630] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   92.000633] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   92.000635] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   92.000638] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   92.000640] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   92.000643] em28xx #0:     card=23 -> Huaqi DLCW-130
[   92.000645] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   92.000647] em28xx #0:     card=25 -> Gadmei UTV310
[   92.000649] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   92.000652] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   92.000654] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   92.000657] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[   92.000659] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   92.000661] em28xx #0:     card=31 -> Usbgear VD204v9
[   92.000664] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   92.000666] em28xx #0:     card=33 -> Elgato Video Capture
[   92.000668] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   92.000670] em28xx #0:     card=35 -> Typhoon DVD Maker
[   92.000673] em28xx #0:     card=36 -> NetGMBH Cam
[   92.000675] em28xx #0:     card=37 -> Gadmei UTV330
[   92.000677] em28xx #0:     card=38 -> Yakumo MovieMixer
[   92.000679] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   92.000681] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   92.000684] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   92.000686] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   92.000688] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   92.000690] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   92.000693] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   92.000695] em28xx #0:     card=46 -> Compro, VideoMate U3
[   92.000697] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   92.000699] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   92.000701] em28xx #0:     card=49 -> MSI DigiVox A/D
[   92.000704] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   92.000706] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   92.000708] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   92.000710] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   92.000713] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   92.000715] em28xx #0:     card=55 -> Terratec Cinnergy Hybrid T USB XS (em2882)
[   92.000717] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   92.000720] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   92.000722] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   92.000724] em28xx #0:     card=59 -> (null)
[   92.000726] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   92.000729] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   92.000731] em28xx #0:     card=62 -> Gadmei TVR200
[   92.000733] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   92.000735] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   92.000738] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   92.000740] em28xx #0:     card=66 -> Empire dual TV
[   92.000742] em28xx #0:     card=67 -> Terratec Grabby
[   92.000744] em28xx #0:     card=68 -> Terratec AV350
[   92.000746] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   92.000749] em28xx #0:     card=70 -> Evga inDtube
[   92.000751] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   92.000753] em28xx #0:     card=72 -> Gadmei UTV330+
[   92.000755] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   92.000758] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[   92.000760] em28xx #0:     card=75 -> Dikom DK300
[   92.000763] em28xx #0:     card=76 -> KWorld PlusTV 340U or UB435-Q (ATSC)
[   92.000765] em28xx #0:     card=77 -> EM2874 Leadership ISDBT
[   92.000850] em28xx #0: Config register raw data: 0x58
[   92.001600] em28xx #0: AC97 vendor ID = 0x87998799
[   92.001975] em28xx #0: AC97 features = 0x8799
[   92.001977] em28xx #0: Unknown AC97 audio processor detected!
[   92.031750] em28xx #0: v4l2 driver version 0.1.2
[   92.071459] em28xx #0: V4L2 video device registered as video1
[   92.071464] em28xx #0: V4L2 VBI device registered as vbi0
[   92.071548] em28xx audio device (eb1a:2881): interface 1, class 1
[   92.071595] em28xx audio device (eb1a:2881): interface 2, class 1
[   92.173636] usbcore: registered new interface driver snd-usb-audio


--=-9Iwz2a/zpAdTfxMJdx7t--

