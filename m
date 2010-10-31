Return-path: <mchehab@gaivota>
Received: from espatrio.investici.org ([204.13.164.67]:55729 "EHLO
	espatrio.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0JaJUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 05:20:23 -0400
Received: from [204.13.164.67] (espatrio [204.13.164.67]) (Authenticated sender: danlin@anche.no) by localhost (Postfix) with ESMTPSA id E4F4E4AC34
	for <linux-media@vger.kernel.org>; Sun, 31 Oct 2010 08:57:06 +0000 (UTC)
Subject: PinnaclePCTVusb2
From: danlin <danlin@anche.no>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-5UWdTk18BnDsaBJ3xsi3"
Date: Sun, 31 Oct 2010 09:56:54 +0100
Message-ID: <1288515414.10180.7.camel@ubuntu>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


--=-5UWdTk18BnDsaBJ3xsi3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I remember i was able to use this card once. it was compiling v4l ,using
hg mercurial...it's  sad i can't use it anymore...tell me how please.

this dmesg is after i tried
modprobe card=45
modprobe em28xx-dvb


info
Linux ubuntu 2.6.35-23-generic #36-Ubuntu SMP Tue Oct 26 17:13:06 UTC
2010 x86_64 GNU/Linux

lsusb
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 003: ID 046d:c001 Logitech, Inc. N48/M-BB48 [FirstMouse
Plus]
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 008: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV
Stick
Bus 002 Device 004: ID 04f2:b159 Chicony Electronics Co., Ltd 
Bus 002 Device 003: ID 058f:6366 Alcor Micro Corp. Multi Flash Reader
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

dmesg

[86192.461739] usb 2-2: USB disconnect, address 7
[86203.493581] usb 2-1: USB disconnect, address 6
[86217.040102] usb 2-2: new high speed USB device using ehci_hcd and
address 8
[86217.435136] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
interface 0, class 0)
[86217.435832] em28xx #0: chip ID is em2870
[86217.519759] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
81 00 6a 22 00 00
[86217.519779] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
00 00 00 00 00 00
[86217.519796] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
00 00 5b 00 00 00
[86217.519812] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 10 1d 8c 49
[86217.519829] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519848] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519857] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
22 03 55 00 53 00
[86217.519866] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
30 00 20 00 44 00
[86217.519874] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
00 00 00 00 00 00
[86217.519883] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519892] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519901] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519910] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519918] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519927] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519936] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[86217.519945] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0x5e2c36c0
[86217.519947] em28xx #0: EEPROM info:
[86217.519949] em28xx #0:	No audio on board.
[86217.519950] em28xx #0:	500mA max power
[86217.519952] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[86217.521619] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)
[86217.552988] em28xx #0: found i2c device @ 0xa0 [eeprom]
[86217.559370] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[86217.571370] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[86217.571378] em28xx #0: You may try to use card=<n> insmod option to
workaround that.
[86217.571382] em28xx #0: Please send an email with this log to:
[86217.571385] em28xx #0: 	V4L Mailing List
<linux-media@vger.kernel.org>
[86217.571388] em28xx #0: Board eeprom hash is 0x5e2c36c0
[86217.571392] em28xx #0: Board i2c devicelist hash is 0x4b800080
[86217.571395] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:
[86217.571401] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[86217.571405] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber
[86217.571409] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[86217.571413] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[86217.571416] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[86217.571420] em28xx #0:     card=5 -> MSI VOX USB 2.0
[86217.571424] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[86217.571428] em28xx #0:     card=7 -> Leadtek Winfast USB II
[86217.571431] em28xx #0:     card=8 -> Kworld USB2800
[86217.571435] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[86217.571440] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[86217.571444] em28xx #0:     card=11 -> Terratec Hybrid XS
[86217.571448] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[86217.571452] em28xx #0:     card=13 -> Terratec Prodigy XS
[86217.571455] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0
[86217.571460] em28xx #0:     card=15 -> V-Gear PocketTV
[86217.571463] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[86217.571467] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[86217.571471] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[86217.571475] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[86217.571479] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[86217.571483] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video Encoder
[86217.571487] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber
[86217.571491] em28xx #0:     card=23 -> Huaqi DLCW-130
[86217.571495] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[86217.571498] em28xx #0:     card=25 -> Gadmei UTV310
[86217.571502] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[86217.571506] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)
[86217.571510] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[86217.571514] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[86217.571518] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[86217.571522] em28xx #0:     card=31 -> Usbgear VD204v9
[86217.571525] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[86217.571529] em28xx #0:     card=33 -> (null)
[86217.571532] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[86217.571536] em28xx #0:     card=35 -> Typhoon DVD Maker
[86217.571540] em28xx #0:     card=36 -> NetGMBH Cam
[86217.571543] em28xx #0:     card=37 -> Gadmei UTV330
[86217.571547] em28xx #0:     card=38 -> Yakumo MovieMixer
[86217.571551] em28xx #0:     card=39 -> KWorld PVRTV 300U
[86217.571554] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[86217.571558] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[86217.571562] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[86217.571565] em28xx #0:     card=43 -> Terratec Cinergy T XS
[86217.571569] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[86217.571573] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[86217.571577] em28xx #0:     card=46 -> Compro, VideoMate U3
[86217.571581] em28xx #0:     card=47 -> KWorld DVB-T 305U
[86217.571584] em28xx #0:     card=48 -> KWorld DVB-T 310U
[86217.571588] em28xx #0:     card=49 -> MSI DigiVox A/D
[86217.571592] em28xx #0:     card=50 -> MSI DigiVox A/D II
[86217.571595] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[86217.571599] em28xx #0:     card=52 -> DNT DA2 Hybrid
[86217.571603] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[86217.571606] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[86217.571610] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[86217.571614] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[86217.571618] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[86217.571622] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[86217.571625] em28xx #0:     card=59 -> (null)
[86217.571629] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[86217.571633] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[86217.571636] em28xx #0:     card=62 -> Gadmei TVR200
[86217.571640] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[86217.571644] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[86217.571647] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[86217.571651] em28xx #0:     card=66 -> Empire dual TV
[86217.571655] em28xx #0:     card=67 -> Terratec Grabby
[86217.571658] em28xx #0:     card=68 -> Terratec AV350
[86217.571662] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[86217.571666] em28xx #0:     card=70 -> Evga inDtube
[86217.571669] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[86217.571673] em28xx #0:     card=72 -> Gadmei UTV330+
[86217.571677] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[86217.571681] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus
VC211A
[86217.571684] em28xx #0:     card=75 -> Dikom DK300
[86217.571691] em28xx #0: v4l2 driver version 0.1.2
[86217.575596] IR NEC protocol handler initialized
[86217.577257] em28xx #0: V4L2 video device registered as video1
[86217.578010] usbcore: registered new interface driver em28xx
[86217.578013] em28xx driver loaded
[86217.616364] IR RC5(x) protocol handler initialized
[86217.630910] IR RC6 protocol handler initialized
[86217.650968] IR JVC protocol handler initialized
[86217.670455] IR Sony protocol handler initialized
[86217.702104] lirc_dev: IR Remote Control driver registered, major 250 
[86217.709599] IR LIRC bridge handler initialized
[86338.409334] Em28xx: Initialized (Em28xx dvb Extension) extension


--=-5UWdTk18BnDsaBJ3xsi3
Content-Disposition: attachment; filename="file"
Content-Type: text/plain; name="file"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-23-generic (buildd@yellow) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #36-Ubuntu SMP Tue Oct 26 17:13:06 UTC 2010 (Ubuntu 2.6.35-23.36-generic 2.6.35.7)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-23-generic root=UUID=8a7c4326-dbcc-4ff3-aecc-e6b94af3f1b9 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f7b0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 0FEDA0000 mask FFFFE0000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f7b0000 (usable)
[    0.000000]  modified: 000000007f7b0000 - 000000007f7c5400 (reserved)
[    0.000000]  modified: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
[    0.000000]  modified: 000000007f7e7fb8 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed9a000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000fedc0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 00000000ffc00000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f7b0000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f7b0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f7b0000 @ 16000-1a000
[    0.000000] RAMDISK: 37571000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000f6f60 00024 (v02 HP    )
[    0.000000] ACPI: XSDT 000000007f7c81c4 00074 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: FACP 000000007f7c8084 000F4 (v04 HP     308A     00000003 HP   00000001)
[    0.000000] ACPI: DSDT 000000007f7c8348 13057 (v01 HP      nc6xxxs 00010000 MSFT 03000001)
[    0.000000] ACPI: FACS 000000007f7e7d80 00040
[    0.000000] ACPI: HPET 000000007f7c8238 00038 (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: APIC 000000007f7c8270 00068 (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 000000007f7c82d8 0003C (v01 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 000000007f7c8314 00032 (v02 HP     308A     00000001 HP   00000001)
[    0.000000] ACPI: SSDT 000000007f7db39f 00328 (v01 HP       HPQSAT 00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000007f7db6c7 0017D (v01 HP       HPQMRM 00000001 MSFT 03000001)
[    0.000000] ACPI: SSDT 000000007f7dc229 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007f7dc488 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
[    0.000000] ACPI: SSDT 000000007f7dc52e 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f7b0000
[    0.000000] Initmem setup node 0 0000000000000000-000000007f7b0000
[    0.000000]   NODE_DATA [0000000001d181c0 - 0000000001d1d1bf]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002600000-ffff8800041fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f7b0
[    0.000000] On node 0 totalpages: 522047
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7083 pages used for memmap
[    0.000000]   DMA32 zone: 510981 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
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
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [18000 - 187ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520 r8192 d23168 u1048576
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514908
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-23-generic root=UUID=8a7c4326-dbcc-4ff3-aecc-e6b94af3f1b9 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (46 early reservations)
[    0.000000]   #1 [0001000000 - 0001d17114]   TEXT DATA BSS
[    0.000000]   #2 [0037571000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [0001d18000 - 0001d18188]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #8 [0001d181c0 - 0001d1d1c0]       NODE_DATA
[    0.000000]   #9 [0001d1d1c0 - 0001d1e1c0]         BOOTMEM
[    0.000000]   #10 [0001d17140 - 0001d172c0]         BOOTMEM
[    0.000000]   #11 [000251f000 - 0002520000]         BOOTMEM
[    0.000000]   #12 [0002520000 - 0002521000]         BOOTMEM
[    0.000000]   #13 [0002600000 - 0004200000]        MEMMAP 0
[    0.000000]   #14 [0001d172c0 - 0001d17440]         BOOTMEM
[    0.000000]   #15 [0001d1e1c0 - 0001d2a1c0]         BOOTMEM
[    0.000000]   #16 [0001d2b000 - 0001d2c000]         BOOTMEM
[    0.000000]   #17 [0001d17440 - 0001d17481]         BOOTMEM
[    0.000000]   #18 [0001d174c0 - 0001d17503]         BOOTMEM
[    0.000000]   #19 [0001d17540 - 0001d17850]         BOOTMEM
[    0.000000]   #20 [0001d17880 - 0001d178e8]         BOOTMEM
[    0.000000]   #21 [0001d17900 - 0001d17968]         BOOTMEM
[    0.000000]   #22 [0001d17980 - 0001d179e8]         BOOTMEM
[    0.000000]   #23 [0001d17a00 - 0001d17a68]         BOOTMEM
[    0.000000]   #24 [0001d17a80 - 0001d17ae8]         BOOTMEM
[    0.000000]   #25 [0001d17b00 - 0001d17b68]         BOOTMEM
[    0.000000]   #26 [0001d17b80 - 0001d17be8]         BOOTMEM
[    0.000000]   #27 [0001d17c00 - 0001d17c68]         BOOTMEM
[    0.000000]   #28 [0001d17c80 - 0001d17ce8]         BOOTMEM
[    0.000000]   #29 [0001d17d00 - 0001d17d68]         BOOTMEM
[    0.000000]   #30 [0001d17d80 - 0001d17de8]         BOOTMEM
[    0.000000]   #31 [0001d17e00 - 0001d17e68]         BOOTMEM
[    0.000000]   #32 [0001d17e80 - 0001d17ee8]         BOOTMEM
[    0.000000]   #33 [0001d17f00 - 0001d17f20]         BOOTMEM
[    0.000000]   #34 [0001d17f40 - 0001d17faa]         BOOTMEM
[    0.000000]   #35 [0001d2a1c0 - 0001d2a22a]         BOOTMEM
[    0.000000]   #36 [0001e00000 - 0001e1e000]         BOOTMEM
[    0.000000]   #37 [0001f00000 - 0001f1e000]         BOOTMEM
[    0.000000]   #38 [0001d17fc0 - 0001d17fc8]         BOOTMEM
[    0.000000]   #39 [0001d2a240 - 0001d2a248]         BOOTMEM
[    0.000000]   #40 [0001d2a280 - 0001d2a288]         BOOTMEM
[    0.000000]   #41 [0001d2a2c0 - 0001d2a2d0]         BOOTMEM
[    0.000000]   #42 [0001d2a300 - 0001d2a440]         BOOTMEM
[    0.000000]   #43 [0001d2a440 - 0001d2a4a0]         BOOTMEM
[    0.000000]   #44 [0001d2a4c0 - 0001d2a520]         BOOTMEM
[    0.000000]   #45 [0001d2c000 - 0001d34000]         BOOTMEM
[    0.000000] Memory: 2034968k/2088640k available (5710k kernel code, 452k absent, 53220k reserved, 5380k data, 908k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.916 MHz processor.
[    0.010011] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.83 BogoMIPS (lpj=19949160)
[    0.010016] pid_max: default: 32768 minimum: 301
[    0.010043] Security Framework initialized
[    0.010066] AppArmor: AppArmor initialized
[    0.010067] Yama: becoming mindful.
[    0.010343] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.011660] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.012425] Mount-cache hash table entries: 256
[    0.012580] Initializing cgroup subsys ns
[    0.012586] Initializing cgroup subsys cpuacct
[    0.012590] Initializing cgroup subsys memory
[    0.012599] Initializing cgroup subsys devices
[    0.012602] Initializing cgroup subsys freezer
[    0.012604] Initializing cgroup subsys net_cls
[    0.012636] CPU: Physical Processor ID: 0
[    0.012637] CPU: Processor Core ID: 0
[    0.012639] mce: CPU supports 6 MCE banks
[    0.012647] CPU0: Thermal monitoring handled by SMI
[    0.012653] using mwait in idle threads.
[    0.012655] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.012661] PEBS disabled due to CPU errata.
[    0.012665] ... version:                2
[    0.012666] ... bit width:              40
[    0.012668] ... generic registers:      2
[    0.012670] ... value mask:             000000ffffffffff
[    0.012671] ... max period:             000000007fffffff
[    0.012673] ... fixed-purpose events:   3
[    0.012674] ... event mask:             0000000700000003
[    0.015204] ACPI: Core revision 20100428
[    0.040009] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.040016] ftrace: allocating 22688 entries in 89 pages
[    0.050064] Setting APIC routing to flat
[    0.050421] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159727] CPU0: Intel(R) Core(TM)2 Duo CPU     T5870  @ 2.00GHz stepping 0d
[    0.160000] Booting Node   0, Processors  #1 Ok.
[    0.020000] CPU1: Thermal monitoring handled by SMI
[    0.320020] Brought up 2 CPUs
[    0.320023] Total of 2 processors activated (7979.84 BogoMIPS).
[    0.320527] devtmpfs: initialized
[    0.320761] regulator: core version 0.5
[    0.320798] Time: 10:49:34  Date: 10/30/10
[    0.320838] NET: Registered protocol family 16
[    0.320862] Trying to unpack rootfs image as initramfs...
[    0.320981] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.320984] ACPI: bus type pci registered
[    0.321057] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.321061] PCI: not using MMCONFIG
[    0.321063] PCI: Using configuration type 1 for base access
[    0.330262] bio: create slab <bio-0> at 0
[    0.332431] ACPI: EC: Look up EC in DSDT
[    0.366759] ACPI: SSDT 000000007f7db90c 0027F (v01 HP      Cpu0Ist 00003000 INTL 20060317)
[    0.366759] ACPI: Dynamic OEM Table Load:
[    0.366759] ACPI: SSDT (null) 0027F (v01 HP      Cpu0Ist 00003000 INTL 20060317)
[    0.366759] ACPI: SSDT 000000007f7dbc10 00619 (v01 HP      Cpu0Cst 00003001 INTL 20060317)
[    0.366759] ACPI: Dynamic OEM Table Load:
[    0.366759] ACPI: SSDT (null) 00619 (v01 HP      Cpu0Cst 00003001 INTL 20060317)
[    0.366759] ACPI: SSDT 000000007f7db844 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
[    0.366759] ACPI: Dynamic OEM Table Load:
[    0.366759] ACPI: SSDT (null) 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
[    0.366759] ACPI: SSDT 000000007f7dbb8b 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
[    0.366759] ACPI: Dynamic OEM Table Load:
[    0.366759] ACPI: SSDT (null) 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
[    0.403478] ACPI: Interpreter enabled
[    0.403478] ACPI: (supports S0 S3 S4 S5)
[    0.403478] ACPI: Using IOAPIC for interrupt routing
[    0.403478] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.403478] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.427293] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.427379] ACPI: Power Resource [C2A5] (on)
[    0.427431] ACPI: Power Resource [C1CE] (off)
[    0.427535] ACPI: Power Resource [C3C1] (off)
[    0.427631] ACPI: Power Resource [C3C2] (off)
[    0.427725] ACPI: Power Resource [C3C3] (off)
[    0.427819] ACPI: Power Resource [C3C4] (off)
[    0.427913] ACPI: Power Resource [C3C5] (off)
[    0.428227] ACPI: No dock devices found.
[    0.428231] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.432337] ACPI: PCI Root Bridge [C003] (domain 0000 [bus 00-ff])
[    0.440461] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.440464] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.440468] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.440471] pci_root PNP0A08:00: host bridge window [mem 0x7f800000-0xfedfffff]
[    0.440474] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
[    0.440477] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000dffff]
[    0.440549] pci 0000:00:02.0: reg 10: [mem 0xe8400000-0xe84fffff 64bit]
[    0.440557] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.440562] pci 0000:00:02.0: reg 20: [io  0x6000-0x6007]
[    0.440602] pci 0000:00:02.1: reg 10: [mem 0xe8500000-0xe85fffff 64bit]
[    0.440725] pci 0000:00:1a.0: reg 20: [io  0x6020-0x603f]
[    0.440795] pci 0000:00:1a.7: reg 10: [mem 0xe8600000-0xe86003ff]
[    0.440863] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.440870] pci 0000:00:1a.7: PME# disabled
[    0.440918] pci 0000:00:1b.0: reg 10: [mem 0xe8604000-0xe8607fff 64bit]
[    0.440984] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.440989] pci 0000:00:1b.0: PME# disabled
[    0.441096] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.441101] pci 0000:00:1c.0: PME# disabled
[    0.441210] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.441215] pci 0000:00:1c.1: PME# disabled
[    0.441326] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.441332] pci 0000:00:1c.4: PME# disabled
[    0.441441] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.441446] pci 0000:00:1c.5: PME# disabled
[    0.441513] pci 0000:00:1d.0: reg 20: [io  0x6040-0x605f]
[    0.441583] pci 0000:00:1d.1: reg 20: [io  0x6060-0x607f]
[    0.441652] pci 0000:00:1d.2: reg 20: [io  0x6080-0x609f]
[    0.441719] pci 0000:00:1d.7: reg 10: [mem 0xe8608000-0xe86083ff]
[    0.441786] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.441792] pci 0000:00:1d.7: PME# disabled
[    0.441968] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.441973] pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
[    0.441978] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
[    0.441987] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
[    0.442044] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.442053] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.442061] pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
[    0.442070] pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
[    0.442078] pci 0000:00:1f.1: reg 20: [io  0x60a0-0x60af]
[    0.442145] pci 0000:00:1f.2: reg 10: [io  0x13f0-0x13f7]
[    0.442153] pci 0000:00:1f.2: reg 14: [io  0x15f4-0x15f7]
[    0.442161] pci 0000:00:1f.2: reg 18: [io  0x1370-0x1377]
[    0.442170] pci 0000:00:1f.2: reg 1c: [io  0x1574-0x1577]
[    0.442178] pci 0000:00:1f.2: reg 20: [io  0x60e0-0x60ff]
[    0.442186] pci 0000:00:1f.2: reg 24: [mem 0xe8609000-0xe86097ff]
[    0.442232] pci 0000:00:1f.2: PME# supported from D3hot
[    0.442237] pci 0000:00:1f.2: PME# disabled
[    0.442325] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.442331] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.442338] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.442346] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.442542] pci 0000:10:00.0: reg 10: [mem 0xe8000000-0xe8001fff 64bit]
[    0.442682] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    0.442704] pci 0000:10:00.0: PME# disabled
[    0.442758] pci 0000:00:1c.1: PCI bridge to [bus 10-10]
[    0.442764] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.442769] pci 0000:00:1c.1:   bridge window [mem 0xe8000000-0xe80fffff]
[    0.442778] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.442843] pci 0000:00:1c.4: PCI bridge to [bus 28-28]
[    0.442848] pci 0000:00:1c.4:   bridge window [io  0x4000-0x5fff]
[    0.442854] pci 0000:00:1c.4:   bridge window [mem 0xe4000000-0xe7ffffff]
[    0.442862] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.442985] pci 0000:30:00.0: reg 10: [mem 0xe0000000-0xe0003fff 64bit]
[    0.442996] pci 0000:30:00.0: reg 18: [io  0x2000-0x20ff]
[    0.443089] pci 0000:30:00.0: supports D1 D2
[    0.443091] pci 0000:30:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.443098] pci 0000:30:00.0: PME# disabled
[    0.443132] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.443137] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.443143] pci 0000:00:1c.5:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.443152] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.443255] pci 0000:00:1e.0: PCI bridge to [bus 02-02] (subtractive decode)
[    0.443261] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.443266] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.443275] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.443278] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.443281] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.443283] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.443286] pci 0000:00:1e.0:   bridge window [mem 0x7f800000-0xfedfffff] (subtractive decode)
[    0.443289] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
[    0.443291] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000dffff] (subtractive decode)
[    0.443332] ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
[    0.443604] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B6._PRT]
[    0.443726] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C125._PRT]
[    0.443804] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C139._PRT]
[    0.443889] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C13C._PRT]
[    0.444015] ACPI: PCI Interrupt Routing Table [\_SB_.C003.C13D._PRT]
[    0.485606] ACPI: PCI Interrupt Link [C135] (IRQs *10 11)
[    0.485823] ACPI: PCI Interrupt Link [C136] (IRQs *10 11)
[    0.486038] ACPI: PCI Interrupt Link [C137] (IRQs 10 *11)
[    0.486242] ACPI: PCI Interrupt Link [C138] (IRQs 10 11) *0, disabled.
[    0.486457] ACPI: PCI Interrupt Link [C148] (IRQs *10 11)
[    0.486667] ACPI: PCI Interrupt Link [C149] (IRQs *10 11)
[    0.486870] ACPI: PCI Interrupt Link [C14A] (IRQs 10 11) *0, disabled.
[    0.486970] ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20100428/pci_link-185)
[    0.487080] HEST: Table is not found!
[    0.487171] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.487186] vgaarb: loaded
[    0.487360] SCSI subsystem initialized
[    0.487475] libata version 3.00 loaded.
[    0.487531] usbcore: registered new interface driver usbfs
[    0.487543] usbcore: registered new interface driver hub
[    0.487636] usbcore: registered new device driver usb
[    0.488022] ACPI: WMI: Mapper loaded
[    0.488025] PCI: Using ACPI for IRQ routing
[    0.488028] PCI: pci_cache_line_size set to 64 bytes
[    0.488184] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.488188] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.488191] reserve RAM buffer: 000000007f7b0000 - 000000007fffffff 
[    0.488295] NetLabel: Initializing
[    0.488298] NetLabel:  domain hash size = 128
[    0.488299] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.488314] NetLabel:  unlabeled traffic allowed by default
[    0.488348] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.488354] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.488359] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.510045] Switching to clocksource tsc
[    0.521456] AppArmor: AppArmor Filesystem Enabled
[    0.521484] pnp: PnP ACPI init
[    0.521513] ACPI: bus type pnp registered
[    0.530729] pnp: PnP ACPI: found 12 devices
[    0.530732] ACPI: ACPI bus type pnp unregistered
[    0.530747] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.530751] system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.530754] system 00:00: [mem 0x00100000-0x7f7fffff] could not be reserved
[    0.530764] system 00:09: [io  0x0500-0x057f] has been reserved
[    0.530767] system 00:09: [io  0x0800-0x080f] has been reserved
[    0.530770] system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.530773] system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
[    0.530779] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.530782] system 00:0a: [io  0x1000-0x107f] has been reserved
[    0.530785] system 00:0a: [io  0x1100-0x113f] has been reserved
[    0.530788] system 00:0a: [io  0x1200-0x121f] has been reserved
[    0.530791] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.530794] system 00:0a: [mem 0xfec00000-0xfec000ff] could not be reserved
[    0.530797] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.530800] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.530803] system 00:0a: [mem 0xfed90000-0xfed99fff] has been reserved
[    0.530809] system 00:0b: [mem 0x000cec00-0x000cffff] has been reserved
[    0.530812] system 00:0b: [mem 0x000d1000-0x000d3fff] has been reserved
[    0.530815] system 00:0b: [mem 0xfeda0000-0xfedbffff] has been reserved
[    0.530818] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.537024] pci 0000:00:1c.1: BAR 15: assigned [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.537028] pci 0000:00:1c.4: BAR 15: assigned [mem 0x7fa00000-0x7fbfffff 64bit pref]
[    0.537032] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    0.537036] pci 0000:00:1c.0: PCI bridge to [bus 08-08]
[    0.537038] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.537045] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.537050] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.537058] pci 0000:00:1c.1: PCI bridge to [bus 10-10]
[    0.537062] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.537069] pci 0000:00:1c.1:   bridge window [mem 0xe8000000-0xe80fffff]
[    0.537075] pci 0000:00:1c.1:   bridge window [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.537083] pci 0000:00:1c.4: PCI bridge to [bus 28-28]
[    0.537087] pci 0000:00:1c.4:   bridge window [io  0x4000-0x5fff]
[    0.537094] pci 0000:00:1c.4:   bridge window [mem 0xe4000000-0xe7ffffff]
[    0.537099] pci 0000:00:1c.4:   bridge window [mem 0x7fa00000-0x7fbfffff 64bit pref]
[    0.537108] pci 0000:00:1c.5: PCI bridge to [bus 30-30]
[    0.537111] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.537118] pci 0000:00:1c.5:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.537123] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    0.537132] pci 0000:00:1e.0: PCI bridge to [bus 02-02]
[    0.537134] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.537140] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.537145] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.537168]   alloc irq_desc for 16 on node -1
[    0.537170]   alloc kstat_irqs on node -1
[    0.537179] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537186] pci 0000:00:1c.0: setting latency timer to 64
[    0.537197]   alloc irq_desc for 17 on node -1
[    0.537199]   alloc kstat_irqs on node -1
[    0.537203] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.537209] pci 0000:00:1c.1: setting latency timer to 64
[    0.537221] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.537226] pci 0000:00:1c.4: setting latency timer to 64
[    0.537238] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.537243] pci 0000:00:1c.5: setting latency timer to 64
[    0.537253] pci 0000:00:1e.0: setting latency timer to 64
[    0.537258] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.537260] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.537263] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.537265] pci_bus 0000:00: resource 7 [mem 0x7f800000-0xfedfffff]
[    0.537267] pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
[    0.537270] pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000dffff]
[    0.537273] pci_bus 0000:10: resource 0 [io  0x3000-0x3fff]
[    0.537275] pci_bus 0000:10: resource 1 [mem 0xe8000000-0xe80fffff]
[    0.537278] pci_bus 0000:10: resource 2 [mem 0x7f800000-0x7f9fffff 64bit pref]
[    0.537280] pci_bus 0000:28: resource 0 [io  0x4000-0x5fff]
[    0.537282] pci_bus 0000:28: resource 1 [mem 0xe4000000-0xe7ffffff]
[    0.537285] pci_bus 0000:28: resource 2 [mem 0x7fa00000-0x7fbfffff 64bit pref]
[    0.537288] pci_bus 0000:30: resource 0 [io  0x2000-0x2fff]
[    0.537290] pci_bus 0000:30: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.537293] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.537295] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.537297] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.537300] pci_bus 0000:02: resource 7 [mem 0x7f800000-0xfedfffff]
[    0.537302] pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
[    0.537305] pci_bus 0000:02: resource 9 [mem 0x000d4000-0x000dffff]
[    0.537347] NET: Registered protocol family 2
[    0.537491] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.538425] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.541251] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.542012] TCP: Hash tables configured (established 262144 bind 65536)
[    0.542015] TCP reno registered
[    0.542025] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.542054] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.542205] NET: Registered protocol family 1
[    0.542232] pci 0000:00:02.0: Boot video device
[    0.542417] PCI: CLS 64 bytes, default 64
[    0.542661] Scanning for low memory corruption every 60 seconds
[    0.542860] audit: initializing netlink socket (disabled)
[    0.542872] type=2000 audit(1288435773.530:1): initialized
[    0.558568] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.560138] VFS: Disk quotas dquot_6.5.2
[    0.560200] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.560813] fuse init (API version 7.14)
[    0.560900] msgmni has been set to 3974
[    0.561211] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.561214] io scheduler noop registered
[    0.561216] io scheduler deadline registered
[    0.561257] io scheduler cfq registered (default)
[    0.561375] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.561427]   alloc irq_desc for 40 on node -1
[    0.561429]   alloc kstat_irqs on node -1
[    0.561446] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    0.561545] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.561593]   alloc irq_desc for 41 on node -1
[    0.561594]   alloc kstat_irqs on node -1
[    0.561604] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    0.561710] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.561758]   alloc irq_desc for 42 on node -1
[    0.561760]   alloc kstat_irqs on node -1
[    0.561769] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    0.561872] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.561919]   alloc irq_desc for 43 on node -1
[    0.561921]   alloc kstat_irqs on node -1
[    0.561930] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    0.562039] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.562119] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.562209] intel_idle: MWAIT substates: 0x22220
[    0.562211] intel_idle: does not run on family 6 model 15
[    0.565903] ACPI: AC Adapter [C244] (on-line)
[    0.565999] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    0.566007] ACPI: Sleep Button [C2BE]
[    0.566051] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.566120] ACPI: Lid Switch [C15B]
[    0.566171] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.566176] ACPI: Power Button [PWRF]
[    0.566417] ACPI: Fan [C3C6] (off)
[    0.566620] ACPI: Fan [C3C7] (off)
[    0.566814] ACPI: Fan [C3C8] (off)
[    0.567007] ACPI: Fan [C3C9] (off)
[    0.567205] ACPI: Fan [C3CA] (off)
[    0.567467] ACPI: acpi_idle registered with cpuidle
[    0.569839] Monitor-Mwait will be used to enter C-1 state
[    0.570016] Monitor-Mwait will be used to enter C-2 state
[    0.570039] Monitor-Mwait will be used to enter C-3 state
[    0.570046] Marking TSC unstable due to TSC halts in idle
[    0.570788] Switching to clocksource hpet
[    0.588439] thermal LNXTHERM:01: registered as thermal_zone0
[    0.588451] ACPI: Thermal Zone [TZ3] (41 C)
[    0.591289] Freeing initrd memory: 10748k freed
[    0.599159] thermal LNXTHERM:02: registered as thermal_zone1
[    0.599174] ACPI: Thermal Zone [TZ4] (22 C)
[    0.602764] thermal LNXTHERM:03: registered as thermal_zone2
[    0.602773] ACPI: Thermal Zone [TZ5] (75 C)
[    0.619823] thermal LNXTHERM:04: registered as thermal_zone3
[    0.619832] ACPI: Thermal Zone [TZ0] (54 C)
[    0.623903] thermal LNXTHERM:05: registered as thermal_zone4
[    0.623911] ACPI: Thermal Zone [TZ1] (49 C)
[    0.624046] ERST: Table is not found!
[    0.624652] Linux agpgart interface v0.103
[    0.624687] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.626209] brd: module loaded
[    0.626752] loop: module loaded
[    0.626952] ata_piix 0000:00:1f.1: version 2.13
[    0.626969] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.627016] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.627130] scsi0 : ata_piix
[    0.627217] scsi1 : ata_piix
[    0.627747] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
[    0.627750] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
[    0.627949] ata2: port disabled. ignoring.
[    0.628101] Fixed MDIO Bus: probed
[    0.628135] PPP generic driver version 2.4.2
[    0.628171] tun: Universal TUN/TAP device driver, 1.6
[    0.628173] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.628262] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.628283]   alloc irq_desc for 18 on node -1
[    0.628285]   alloc kstat_irqs on node -1
[    0.628292] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.628308] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.628312] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.628347] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.628384] ehci_hcd 0000:00:1a.7: debug port 1
[    0.632282] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    0.632299] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8600000
[    0.652526] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.652639] hub 1-0:1.0: USB hub found
[    0.652646] hub 1-0:1.0: 4 ports detected
[    0.652722]   alloc irq_desc for 20 on node -1
[    0.652724]   alloc kstat_irqs on node -1
[    0.652729] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.652740] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.652744] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.652786] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.652819] ehci_hcd 0000:00:1d.7: debug port 1
[    0.656697] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    0.656714] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe8608000
[    0.665345] ACPI: Battery Slot [C245] (battery present)
[    0.672515] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.672625] hub 2-0:1.0: USB hub found
[    0.672630] hub 2-0:1.0: 6 ports detected
[    0.672704] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.672717] uhci_hcd: USB Universal Host Controller Interface driver
[    0.672774] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.672782] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.672785] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.672819] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.672859] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00006020
[    0.672992] hub 3-0:1.0: USB hub found
[    0.672996] hub 3-0:1.0: 2 ports detected
[    0.673062] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.673069] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.673073] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.673109] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    0.673139] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006040
[    0.673260] hub 4-0:1.0: USB hub found
[    0.673265] hub 4-0:1.0: 2 ports detected
[    0.673326]   alloc irq_desc for 21 on node -1
[    0.673328]   alloc kstat_irqs on node -1
[    0.673333] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.673340] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.673344] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.673381] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    0.673418] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006060
[    0.673536] hub 5-0:1.0: USB hub found
[    0.673540] hub 5-0:1.0: 2 ports detected
[    0.673604] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.673611] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.673615] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.673655] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    0.673686] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006080
[    0.673810] hub 6-0:1.0: USB hub found
[    0.673814] hub 6-0:1.0: 2 ports detected
[    0.673935] PNP: PS/2 Controller [PNP0303:C2A2,PNP0f13:C2A3] at 0x60,0x64 irq 1,12
[    0.675517] i8042.c: Detected active multiplexing controller, rev 1.1.
[    0.676234] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.676240] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    0.676247] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    0.676250] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    0.676253] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    0.676327] mice: PS/2 mouse device common for all mice
[    0.676457] rtc_cmos 00:05: RTC can wake from S4
[    0.676500] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.676533] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.676628] device-mapper: uevent: version 1.0.3
[    0.676718] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    0.676809] device-mapper: multipath: version 1.1.1 loaded
[    0.676812] device-mapper: multipath round-robin: version 1.0.0 loaded
[    0.677075] cpuidle: using governor ladder
[    0.677175] cpuidle: using governor menu
[    0.677453] TCP cubic registered
[    0.677583] NET: Registered protocol family 10
[    0.677942] lo: Disabled Privacy Extensions
[    0.678151] NET: Registered protocol family 17
[    0.678908] PM: Resume from disk failed.
[    0.678920] registered taskstats version 1
[    0.679234]   Magic number: 14:127:832
[    0.679374] rtc_cmos 00:05: setting system clock to 2010-10-30 10:49:34 UTC (1288435774)
[    0.679377] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.679379] EDD information not available.
[    0.698032] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.792206] Freeing unused kernel memory: 908k freed
[    0.792594] Write protecting the kernel read-only data: 10240k
[    0.792841] Freeing unused kernel memory: 412k freed
[    0.793176] Freeing unused kernel memory: 1644k freed
[    0.810691] udev[85]: starting version 163
[    0.859788] sky2: driver version 1.28
[    0.859838] sky2 0000:30:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.859855] sky2 0000:30:00.0: setting latency timer to 64
[    0.859893] sky2 0000:30:00.0: Yukon-2 FE+ chip revision 0
[    0.859999]   alloc irq_desc for 44 on node -1
[    0.860002]   alloc kstat_irqs on node -1
[    0.860022] sky2 0000:30:00.0: irq 44 for MSI/MSI-X
[    0.881543] sky2 0000:30:00.0: eth0: addr 18:a9:05:d5:70:8e
[    0.968565] ahci 0000:00:1f.2: version 3.0
[    0.968589] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.968641]   alloc irq_desc for 45 on node -1
[    0.968643]   alloc kstat_irqs on node -1
[    0.968657] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.968702] ahci: SSS flag set, parallel bus scan disabled
[    0.968736] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
[    0.968741] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc 
[    0.968747] ahci 0000:00:1f.2: setting latency timer to 64
[    0.971802] scsi2 : ahci
[    0.971998] scsi3 : ahci
[    0.972104] scsi4 : ahci
[    0.972201] ata3: SATA max UDMA/133 abar m2048@0xe8609000 port 0xe8609100 irq 45
[    0.972206] ata4: SATA max UDMA/133 abar m2048@0xe8609000 port 0xe8609180 irq 45
[    0.972210] ata5: SATA max UDMA/133 abar m2048@0xe8609000 port 0xe8609200 irq 45
[    1.052559] usb 2-4: new high speed USB device using ehci_hcd and address 3
[    1.208269] Initializing USB Mass Storage driver...
[    1.208416] scsi5 : usb-storage 2-4:1.0
[    1.208526] usbcore: registered new interface driver usb-storage
[    1.208529] USB Mass Storage support registered.
[    1.330063] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.330084] usb 2-5: new high speed USB device using ehci_hcd and address 4
[    1.332387] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.332391] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.332598] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.332603] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.333622] ata3.00: ATA-8: Hitachi HTS723225L9A360, FCDOC60D, max UDMA/100
[    1.333625] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.336157] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.336161] ata3.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.336365] ata3.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
[    1.336369] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    1.337404] ata3.00: configured for UDMA/100
[    1.352383] ata3.00: configured for UDMA/100
[    1.352387] ata3: EH complete
[    1.352563] scsi 2:0:0:0: Direct-Access     ATA      Hitachi HTS72322 FCDO PQ: 0 ANSI: 5
[    1.352722] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.352774] sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    1.352854] sd 2:0:0:0: [sda] Write Protect is off
[    1.352858] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.352882] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.353021]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    1.430397] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.700085] ata4: SATA link down (SStatus 0 SControl 300)
[    1.800054] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    2.070074] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.074169] ata5.00: ATAPI: hp       DVDRAM GT20L, DC05, max UDMA/100
[    2.079049] ata5.00: configured for UDMA/100
[    2.103197] scsi 4:0:0:0: CD-ROM            hp       DVDRAM GT20L     DC05 PQ: 0 ANSI: 5
[    2.114376] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.114380] Uniform CD-ROM driver Revision: 3.20
[    2.114489] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    2.114556] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    2.121349] usbcore: registered new interface driver hiddev
[    2.136804] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:1d.1/usb5/5-1/5-1:1.0/input/input4
[    2.136920] generic-usb 0003:046D:C001.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:1d.1-1/input0
[    2.136942] usbcore: registered new interface driver usbhid
[    2.136945] usbhid: USB HID core driver
[    2.331202] scsi 5:0:0:0: Direct-Access     Multiple Card  Reader     1.00 PQ: 0 ANSI: 0
[    2.331873] sd 5:0:0:0: Attached scsi generic sg2 type 0
[    2.720017] EXT4-fs (sda7): mounted filesystem with ordered data mode. Opts: (null)
[    3.043937] sd 5:0:0:0: [sdb] 15523840 512-byte logical blocks: (7.94 GB/7.40 GiB)
[    3.044679] sd 5:0:0:0: [sdb] Write Protect is off
[    3.044682] sd 5:0:0:0: [sdb] Mode Sense: 03 00 00 00
[    3.044685] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.047044] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.047053]  sdb: sdb1
[    3.049920] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[    3.049924] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[   11.636906] udev[416]: starting version 163
[   11.763631] Adding 2000056k swap on /dev/sda8.  Priority:-1 extents:1 across:2000056k 
[   11.986149] agpgart-intel 0000:00:00.0: Intel 965GME/GLE Chipset
[   11.986830] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   12.000876] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   12.032283] cfg80211: Calling CRDA to update world regulatory domain
[   12.049739] cfg80211: World regulatory domain updated:
[   12.049743]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   12.049746]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.049749]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.049752]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.049755]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.049758]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.074941] sky2 0000:30:00.0: eth0: enabling interface
[   12.075223] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.091667] type=1400 audit(1288428585.909:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient3" pid=689 comm="apparmor_parser"
[   12.092401] type=1400 audit(1288428585.909:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=689 comm="apparmor_parser"
[   12.092888] type=1400 audit(1288428585.909:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=689 comm="apparmor_parser"
[   12.134522] input: HP WMI hotkeys as /devices/virtual/input/input5
[   12.350352] lp: driver loaded but no devices found
[   12.452588] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   12.452592] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   12.452726] iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.452764] iwlagn 0000:10:00.0: setting latency timer to 64
[   12.452845] iwlagn 0000:10:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   12.477800] iwlagn 0000:10:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   12.477898]   alloc irq_desc for 46 on node -1
[   12.477901]   alloc kstat_irqs on node -1
[   12.477942] iwlagn 0000:10:00.0: irq 46 for MSI/MSI-X
[   12.482064] [drm] Initialized drm 1.1.0 20060810
[   12.499859] iwlagn 0000:10:00.0: loaded firmware version 8.24.2.12
[   12.528773] Linux video capture interface: v2.00
[   12.578095] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   12.599541] uvcvideo: Found UVC 1.00 device CNF8243 (04f2:b159)
[   12.657160] input: CNF8243 as /devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5:1.0/input/input6
[   12.657269] usbcore: registered new interface driver uvcvideo
[   12.657272] USB Video Class driver (v0.1.0)
[   12.688348] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.688354] i915 0000:00:02.0: setting latency timer to 64
[   12.734880]   alloc irq_desc for 47 on node -1
[   12.734884]   alloc kstat_irqs on node -1
[   12.734900] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[   12.734914] [drm] set up 7M of stolen space
[   12.841541] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   12.841856] [drm] initialized overlay support
[   13.136191] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04731/0xa40000/0xa0000
[   13.150048] Skipping EDID probe due to cached edid
[   13.180868] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
[   13.275205] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro
[   13.542237] Console: switching to colour frame buffer device 170x48
[   13.544906] fb0: inteldrmfb frame buffer device
[   13.544907] drm: registered panic notifier
[   13.544915] Slow work thread pool: Starting up
[   13.545061] Slow work thread pool: Ready
[   13.547509] ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond end of object (20100428/exoparg2-418)
[   13.547523] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C003.C09E._DOD] (Node ffff88007cf30d20), AE_AML_PACKAGE_LIMIT
[   13.547556] ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20100428/video-1937)
[   13.551296] acpi device:00: registered as cooling_device7
[   13.552895] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input8
[   13.553023] ACPI: Video Device [C09E] (multi-head: yes  rom: no  post: no)
[   13.553338] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   13.558298] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   13.558352] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   13.558363] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.558429]   alloc irq_desc for 48 on node -1
[   13.558431]   alloc kstat_irqs on node -1
[   13.558446] HDA Intel 0000:00:1b.0: irq 48 for MSI/MSI-X
[   13.558484] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   13.562342] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
[   13.610064] Skipping EDID probe due to cached edid
[   13.840302] input: HDA Intel Mic at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   13.840465] input: HDA Intel HP Out at Ext Front Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.913054] type=1400 audit(1288428588.729:5): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=1129 comm="apparmor_parser"
[   14.919619] type=1400 audit(1288428588.729:6): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1132 comm="apparmor_parser"
[   14.924519] type=1400 audit(1288428588.739:7): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient3" pid=1130 comm="apparmor_parser"
[   14.925381] type=1400 audit(1288428588.739:8): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1130 comm="apparmor_parser"
[   14.925787] type=1400 audit(1288428588.739:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1130 comm="apparmor_parser"
[   14.934165] type=1400 audit(1288428588.749:10): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=1132 comm="apparmor_parser"
[   14.936871] type=1400 audit(1288428588.749:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1137 comm="apparmor_parser"
[   14.964486] ppdev: user-space parallel port driver
[   15.080168] Skipping EDID probe due to cached edid
[   15.120859] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   15.197035] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   15.197040] vboxdrv: Successfully done.
[   15.197042] vboxdrv: Found 2 processor cores.
[   15.197523] VBoxDrv: dbg - g_abExecMemory=ffffffffa03bbd60
[   15.197544] vboxdrv: fAsync=0 offMin=0x1c2 offMax=0x992
[   15.198170] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   15.198173] vboxdrv: Successfully loaded version 3.2.8_OSE (interface 0x00140001).
[   15.482623] Skipping EDID probe due to cached edid
[   16.015855] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro,commit=0
[   16.046075] EXT4-fs (sda9): re-mounted. Opts: commit=0
[   16.752572] Skipping EDID probe due to cached edid
[   17.150055] Skipping EDID probe due to cached edid
[   17.560063] Skipping EDID probe due to cached edid
[   17.960052] Skipping EDID probe due to cached edid
[   19.238189] EXT4-fs (sda7): re-mounted. Opts: errors=remount-ro,commit=0
[   19.241622] EXT4-fs (sda9): re-mounted. Opts: commit=0
[   22.822593] Skipping EDID probe due to cached edid
[   23.220082] Skipping EDID probe due to cached edid
[   23.650090] Skipping EDID probe due to cached edid
[   24.054529] Skipping EDID probe due to cached edid
[   29.912573] Skipping EDID probe due to cached edid
[  127.932692] CE: hpet increased min_delta_ns to 7500 nsec
[ 7309.732661] Skipping EDID probe due to cached edid
[22823.003787] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[22836.339485] wlan0: authenticate with 00:24:01:56:76:ac (try 1)
[22836.341799] wlan0: authenticated
[22836.341858] wlan0: associate with 00:24:01:56:76:ac (try 1)
[22836.344270] wlan0: RX AssocResp from 00:24:01:56:76:ac (capab=0x401 status=0 aid=1)
[22836.344279] wlan0: associated
[22836.346687] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[22846.522530] wlan0: no IPv6 routers present
[24452.158056] usb 2-2: new high speed USB device using ehci_hcd and address 5
[24452.314906] scsi6 : usb-storage 2-2:1.0
[24453.310964] scsi 6:0:0:0: Direct-Access     SanDisk  Cruzer Blade     1.00 PQ: 0 ANSI: 2
[24453.311537] sd 6:0:0:0: Attached scsi generic sg3 type 0
[24453.315112] sd 6:0:0:0: [sdc] 31250432 512-byte logical blocks: (16.0 GB/14.9 GiB)
[24453.317578] sd 6:0:0:0: [sdc] Write Protect is off
[24453.317588] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
[24453.317595] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[24453.320715] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[24453.320731]  sdc:
[24453.333053] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[24453.333059] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[27451.400073] No probe response from AP 00:24:01:56:76:ac after 500ms, disconnecting.
[27451.422768] cfg80211: All devices are disconnected, going to restore regulatory settings
[27451.422781] cfg80211: Restoring regulatory settings
[27451.422790] cfg80211: Calling CRDA to update world regulatory domain
[27451.594591] cfg80211: World regulatory domain updated:
[27451.594600]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[27451.594609]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[27451.594617]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[27451.594624]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[27451.594632]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[27451.594639]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[27454.678638] wlan0: authenticate with 00:24:01:56:76:ac (try 1)
[27454.680603] wlan0: authenticated
[27454.680664] wlan0: associate with 00:24:01:56:76:ac (try 1)
[27454.683129] wlan0: RX AssocResp from 00:24:01:56:76:ac (capab=0x401 status=0 aid=1)
[27454.683139] wlan0: associated
[33020.932729] CE: hpet increased min_delta_ns to 11250 nsec
[35378.542621] hub 5-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
[35378.542635] usb 5-1: USB disconnect, address 2
[35378.870094] usb 5-1: new low speed USB device using uhci_hcd and address 3
[35379.066005] input: Logitech USB Mouse as /devices/pci0000:00/0000:00:1d.1/usb5/5-1/5-1:1.0/input/input11
[35379.066140] generic-usb 0003:046D:C001.0002: input,hidraw0: USB HID v1.10 Mouse [Logitech USB Mouse] on usb-0000:00:1d.1-1/input0
[40425.460143] usb 2-1: new high speed USB device using ehci_hcd and address 6
[40425.616038] scsi7 : usb-storage 2-1:1.0
[40426.611365] scsi 7:0:0:0: Direct-Access     ST350041 8AS                   PQ: 0 ANSI: 2 CCS
[40426.612772] sd 7:0:0:0: Attached scsi generic sg4 type 0
[40426.616847] sd 7:0:0:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[40426.617672] sd 7:0:0:0: [sdd] Write Protect is off
[40426.617680] sd 7:0:0:0: [sdd] Mode Sense: 00 38 00 00
[40426.617687] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[40426.619569] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[40426.619585]  sdd: sdd1
[40426.636791] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[40426.636803] sd 7:0:0:0: [sdd] Attached SCSI disk
[40427.227113] EXT4-fs (sdd1): warning: maximal mount count reached, running e2fsck is recommended
[40427.253725] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)
[49411.430052] No probe response from AP 00:24:01:56:76:ac after 500ms, disconnecting.
[49411.452726] cfg80211: All devices are disconnected, going to restore regulatory settings
[49411.452735] cfg80211: Restoring regulatory settings
[49411.452741] cfg80211: Calling CRDA to update world regulatory domain
[49411.651381] cfg80211: World regulatory domain updated:
[49411.651386]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[49411.651389]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[49411.651393]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[49411.651396]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[49411.651398]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[49411.651401]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[49414.756365] wlan0: authenticate with 00:24:01:56:76:ac (try 1)
[49414.758347] wlan0: authenticated
[49414.758388] wlan0: associate with 00:24:01:56:76:ac (try 1)
[49414.760750] wlan0: RX AssocResp from 00:24:01:56:76:ac (capab=0x401 status=0 aid=1)
[49414.760754] wlan0: associated
[56895.753676] Skipping EDID probe due to cached edid
[59371.561151] No probe response from AP 00:24:01:56:76:ac after 500ms, disconnecting.
[59371.600419] cfg80211: All devices are disconnected, going to restore regulatory settings
[59371.600432] cfg80211: Restoring regulatory settings
[59371.600440] cfg80211: Calling CRDA to update world regulatory domain
[59371.608892] cfg80211: World regulatory domain updated:
[59371.608900]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[59371.608909]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[59371.608916]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[59371.608924]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[59371.608931]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[59371.608938]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[59374.857572] wlan0: authenticate with 00:24:01:56:76:ac (try 1)
[59374.859685] wlan0: authenticated
[59374.859743] wlan0: associate with 00:24:01:56:76:ac (try 1)
[59374.862445] wlan0: RX AssocResp from 00:24:01:56:76:ac (capab=0x401 status=0 aid=1)
[59374.862455] wlan0: associated
[81338.274176] show_signal_msg: 9 callbacks suppressed
[81338.274183] npviewer.bin[6136]: segfault at 418 ip 00000000f606add6 sp 00000000ff944648 error 6 in libflashplayer.so[f5e1c000+b2c000]
[84165.503452] Skipping EDID probe due to cached edid
[84236.127954] usb 2-2: USB disconnect, address 5
[85808.300087] usb 2-2: new high speed USB device using ehci_hcd and address 7
[85808.452607] scsi8 : usb-storage 2-2:1.0
[85809.453795] scsi 8:0:0:0: Direct-Access     SanDisk  Cruzer Blade     1.00 PQ: 0 ANSI: 2
[85809.454445] sd 8:0:0:0: Attached scsi generic sg3 type 0
[85809.466278] sd 8:0:0:0: [sdc] 31250432 512-byte logical blocks: (16.0 GB/14.9 GiB)
[85809.467639] sd 8:0:0:0: [sdc] Write Protect is off
[85809.467642] sd 8:0:0:0: [sdc] Mode Sense: 03 00 00 00
[85809.467645] sd 8:0:0:0: [sdc] Assuming drive cache: write through
[85809.471140] sd 8:0:0:0: [sdc] Assuming drive cache: write through
[85809.471147]  sdc:
[85809.478273] sd 8:0:0:0: [sdc] Assuming drive cache: write through
[85809.478280] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[86192.461739] usb 2-2: USB disconnect, address 7
[86203.493581] usb 2-1: USB disconnect, address 6
[86217.040102] usb 2-2: new high speed USB device using ehci_hcd and address 8
[86217.435136] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870, interface 0, class 0)
[86217.435832] em28xx #0: chip ID is em2870
[86217.519759] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
[86217.519779] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
[86217.519796] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
[86217.519812] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 10 1d 8c 49
[86217.519829] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519848] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519857] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[86217.519866] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
[86217.519874] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[86217.519883] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519892] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519901] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519910] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519918] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519927] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519936] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[86217.519945] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x5e2c36c0
[86217.519947] em28xx #0: EEPROM info:
[86217.519949] em28xx #0:	No audio on board.
[86217.519950] em28xx #0:	500mA max power
[86217.519952] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[86217.521619] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[86217.552988] em28xx #0: found i2c device @ 0xa0 [eeprom]
[86217.559370] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[86217.571370] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[86217.571378] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[86217.571382] em28xx #0: Please send an email with this log to:
[86217.571385] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[86217.571388] em28xx #0: Board eeprom hash is 0x5e2c36c0
[86217.571392] em28xx #0: Board i2c devicelist hash is 0x4b800080
[86217.571395] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[86217.571401] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[86217.571405] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[86217.571409] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[86217.571413] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[86217.571416] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[86217.571420] em28xx #0:     card=5 -> MSI VOX USB 2.0
[86217.571424] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[86217.571428] em28xx #0:     card=7 -> Leadtek Winfast USB II
[86217.571431] em28xx #0:     card=8 -> Kworld USB2800
[86217.571435] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[86217.571440] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[86217.571444] em28xx #0:     card=11 -> Terratec Hybrid XS
[86217.571448] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[86217.571452] em28xx #0:     card=13 -> Terratec Prodigy XS
[86217.571455] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[86217.571460] em28xx #0:     card=15 -> V-Gear PocketTV
[86217.571463] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[86217.571467] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[86217.571471] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[86217.571475] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[86217.571479] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[86217.571483] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[86217.571487] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[86217.571491] em28xx #0:     card=23 -> Huaqi DLCW-130
[86217.571495] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[86217.571498] em28xx #0:     card=25 -> Gadmei UTV310
[86217.571502] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[86217.571506] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[86217.571510] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[86217.571514] em28xx #0:     card=29 -> EM2860/TVP5150 Reference Design
[86217.571518] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[86217.571522] em28xx #0:     card=31 -> Usbgear VD204v9
[86217.571525] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[86217.571529] em28xx #0:     card=33 -> (null)
[86217.571532] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[86217.571536] em28xx #0:     card=35 -> Typhoon DVD Maker
[86217.571540] em28xx #0:     card=36 -> NetGMBH Cam
[86217.571543] em28xx #0:     card=37 -> Gadmei UTV330
[86217.571547] em28xx #0:     card=38 -> Yakumo MovieMixer
[86217.571551] em28xx #0:     card=39 -> KWorld PVRTV 300U
[86217.571554] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[86217.571558] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[86217.571562] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[86217.571565] em28xx #0:     card=43 -> Terratec Cinergy T XS
[86217.571569] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[86217.571573] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[86217.571577] em28xx #0:     card=46 -> Compro, VideoMate U3
[86217.571581] em28xx #0:     card=47 -> KWorld DVB-T 305U
[86217.571584] em28xx #0:     card=48 -> KWorld DVB-T 310U
[86217.571588] em28xx #0:     card=49 -> MSI DigiVox A/D
[86217.571592] em28xx #0:     card=50 -> MSI DigiVox A/D II
[86217.571595] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[86217.571599] em28xx #0:     card=52 -> DNT DA2 Hybrid
[86217.571603] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[86217.571606] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[86217.571610] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[86217.571614] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[86217.571618] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[86217.571622] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[86217.571625] em28xx #0:     card=59 -> (null)
[86217.571629] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[86217.571633] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[86217.571636] em28xx #0:     card=62 -> Gadmei TVR200
[86217.571640] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[86217.571644] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[86217.571647] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[86217.571651] em28xx #0:     card=66 -> Empire dual TV
[86217.571655] em28xx #0:     card=67 -> Terratec Grabby
[86217.571658] em28xx #0:     card=68 -> Terratec AV350
[86217.571662] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[86217.571666] em28xx #0:     card=70 -> Evga inDtube
[86217.571669] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[86217.571673] em28xx #0:     card=72 -> Gadmei UTV330+
[86217.571677] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[86217.571681] em28xx #0:     card=74 -> Actionmaster/LinXcel/Digitus VC211A
[86217.571684] em28xx #0:     card=75 -> Dikom DK300
[86217.571691] em28xx #0: v4l2 driver version 0.1.2
[86217.575596] IR NEC protocol handler initialized
[86217.577257] em28xx #0: V4L2 video device registered as video1
[86217.578010] usbcore: registered new interface driver em28xx
[86217.578013] em28xx driver loaded
[86217.616364] IR RC5(x) protocol handler initialized
[86217.630910] IR RC6 protocol handler initialized
[86217.650968] IR JVC protocol handler initialized
[86217.670455] IR Sony protocol handler initialized
[86217.702104] lirc_dev: IR Remote Control driver registered, major 250 
[86217.709599] IR LIRC bridge handler initialized
[86338.409334] Em28xx: Initialized (Em28xx dvb Extension) extension

--=-5UWdTk18BnDsaBJ3xsi3--

