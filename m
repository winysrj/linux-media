Return-path: <mchehab@pedra>
Received: from web114716.mail.gq1.yahoo.com ([98.136.183.143]:33913 "HELO
	web114716.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750814Ab1COWOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 18:14:44 -0400
Message-ID: <57989.84081.qm@web114716.mail.gq1.yahoo.com>
Date: Tue, 15 Mar 2011 15:08:02 -0700 (PDT)
From: Nels Poulsen <nels_poulsen@yahoo.com>
Subject: Support for StarTech SVID2USB2 USB 2.0 Video Capture Cable
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: nels@npoulsen.us
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I've been trying to get StarTech SVID2USB2 working for Ubuntu 10.04 LTS - the Lucid Lynx to no avail. Although drivers in Windows XP identify the device as using an empi2821 chipset and device probe in Ubuntu seem to identify the chip correctly, there does not seem to be a automatically selected driver that is capable of accessing the hardware in Ubuntu. I have included a portion of the dmesg file for your reference. Please advise if I can provide any more information:

[   16.845233] Linux video capture interface: v2.00
[   16.852844] vga16fb: initializing
[   16.852848] vga16fb: mapped to 0xffff8800000a0000
[   16.852929] fb0: VGA16 VGA frame buffer device
[   17.000014] EDAC amd64_edac:  Ver: 3.2.0 Feb 11 2011
[   17.000275] EDAC amd64: This node reports that Memory ECC is currently disabled, set F3x44[22] (0000:00:18.3).
[   17.000284] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   17.000285]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   17.000286]  (Note that use of the override may cause unknown side effects.)
[   17.000299] amd64_edac: probe of 0000:00:18.2 failed with error -22
[   17.021423] em28xx: New device USB 2821 Device @ 480 Mbps (eb1a:2821, interface 0, class 0)
[   17.021602] em28xx #0: chip ID is em2820 (or em2710)
[   17.048166] Console: switching to colour frame buffer device 80x30
[   17.184107] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 21 28 90 00 11 03 6a 22 00 00
[   17.184115] em28xx #0: i2c eeprom 10: 00 00 04 57 06 21 01 00 00 00 00 00 00 00 00 00
[   17.184122] em28xx #0: i2c eeprom 20: 02 00 01 01 f0 10 00 00 00 00 00 00 5b 00 00 00
[   17.184128] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 03 01 00 00 00 00
[   17.184134] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184140] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184145] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[   17.184151] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 32 00 31 00 20 00 44 00
[   17.184157] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[   17.184163] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184169] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184174] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184180] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184186] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184192] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184197] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   17.184205] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x37da7b8a
[   17.184206] em28xx #0: EEPROM info:
[   17.184207] em28xx #0:	AC97 audio (5 sample rates)
[   17.184209] em28xx #0:	500mA max power
[   17.184210] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   17.202861] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[   17.214864] em28xx #0: found i2c device @ 0x4a [saa7113h]
[   17.226086] nvidia: module license 'NVIDIA' taints kernel.
[   17.226090] Disabling lock debugging due to kernel taint
[   17.233363] em28xx #0: found i2c device @ 0xa0 [eeprom]
[   17.250613] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
[   17.250999] em28xx #0: You may try to use card=<n> insmod option to workaround that.
[   17.251362] em28xx #0: Please send an email with this log to:
[   17.251634] em28xx #0: 	V4L Mailing List <linux-media@vger.kernel.org>
[   17.251925] em28xx #0: Board eeprom hash is 0x37da7b8a
[   17.252180] em28xx #0: Board i2c devicelist hash is 0x6ba50080
[   17.252453] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
[   17.252820] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[   17.253098] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[   17.253387] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[   17.253660] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[   17.253920] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[   17.254184] em28xx #0:     card=5 -> MSI VOX USB 2.0
[   17.254437] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[   17.254705] em28xx #0:     card=7 -> Leadtek Winfast USB II
[   17.254970] em28xx #0:     card=8 -> Kworld USB2800
[   17.255218] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2
[   17.255666] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[   17.255934] em28xx #0:     card=11 -> Terratec Hybrid XS
[   17.256192] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[   17.256457] em28xx #0:     card=13 -> Terratec Prodigy XS
[   17.256719] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0
[   17.257090] em28xx #0:     card=15 -> V-Gear PocketTV
[   17.257342] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[   17.270367] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[   17.282747] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[   17.294450] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[   17.305623] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[   17.316293] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
[   17.337168] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[   17.348048] em28xx #0:     card=23 -> Huaqi DLCW-130
[   17.358971] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[   17.369941] em28xx #0:     card=25 -> Gadmei UTV310
[   17.380458] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[   17.390763] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
[   17.401228] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[   17.401230] em28xx #0:     card=29 -> <NULL>
[   17.401232] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[   17.401233] em28xx #0:     card=31 -> Usbgear VD204v9
[   17.401234] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[   17.401236] em28xx #0:     card=33 -> <NULL>
[   17.401237] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[   17.401239] em28xx #0:     card=35 -> Typhoon DVD Maker
[   17.401240] em28xx #0:     card=36 -> NetGMBH Cam
[   17.401241] em28xx #0:     card=37 -> Gadmei UTV330
[   17.401242] em28xx #0:     card=38 -> Yakumo MovieMixer
[   17.401244] em28xx #0:     card=39 -> KWorld PVRTV 300U
[   17.401245] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[   17.401246] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[   17.401248] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[   17.401249] em28xx #0:     card=43 -> Terratec Cinergy T XS
[   17.401251] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[   17.401252] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[   17.401253] em28xx #0:     card=46 -> Compro, VideoMate U3
[   17.401255] em28xx #0:     card=47 -> KWorld DVB-T 305U
[   17.401256] em28xx #0:     card=48 -> KWorld DVB-T 310U
[   17.401257] em28xx #0:     card=49 -> MSI DigiVox A/D
[   17.401259] em28xx #0:     card=50 -> MSI DigiVox A/D II
[   17.401260] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[   17.401261] em28xx #0:     card=52 -> DNT DA2 Hybrid
[   17.401263] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[   17.401264] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[   17.401265] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[   17.401267] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[   17.401268] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[   17.401270] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[   17.401271] em28xx #0:     card=59 -> <NULL>
[   17.401272] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[   17.401274] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[   17.401275] em28xx #0:     card=62 -> Gadmei TVR200
[   17.401276] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[   17.401278] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[   17.401280] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[   17.401282] em28xx #0:     card=66 -> Empire dual TV
[   17.401283] em28xx #0:     card=67 -> Terratec Grabby
[   17.401284] em28xx #0:     card=68 -> Terratec AV350
[   17.401286] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[   17.401287] em28xx #0:     card=70 -> Evga inDtube
[   17.401288] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[   17.401290] em28xx #0:     card=72 -> Gadmei UTV330+
[   17.401291] em28xx #0:     card=73 -> Reddo DVB-C USB TV Box
[   17.401376] em28xx #0: Config register raw data: 0x90
[   17.440130] em28xx #0: AC97 vendor ID = 0xffffffff
[   17.460130] em28xx #0: AC97 features = 0x6a90
[   17.460131] em28xx #0: Empia 202 AC97 audio processor detected
[   17.863467] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 21
[   17.863473] nvidia 0000:02:00.0: PCI INT A -> Link[SGRU] -> GSI 21 (level, low) -> IRQ 21
[   17.863481] nvidia 0000:02:00.0: setting latency timer to 64
[   17.863485] vgaarb: device changed decodes: PCI:0000:02:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   17.863911] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  195.36.24  Thu Apr 22 19:10:14 PDT 2010
[   18.072871] lp: driver loaded but no devices found
[   18.159508] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input5
[   18.382518] em28xx #0: v4l2 driver version 0.1.2
[   18.419239] bttv: driver version 0.9.18 loaded
[   18.419242] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   18.927074] bt878: AUDIO driver version 0.0.0 loaded
[   19.425683] HDA Intel 0000:00:07.0: power state changed by ACPI to D0
[   19.425721] HDA Intel 0000:00:07.0: power state changed by ACPI to D0
[   19.426089] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
[   19.426094] HDA Intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 20 (level, low) -> IRQ 20
[   19.426098] hda_intel: Disable MSI for Nvidia chipset
[   19.426149] HDA Intel 0000:00:07.0: setting latency timer to 64
[   19.584611] type=1505 audit(1300220099.145:2):  operation="profile_load" pid=736 name="/sbin/dhclient3"
[   19.584627] type=1505 audit(1300220099.145:3):  operation="profile_replace" pid=738 name="/sbin/dhclient3"
[   19.584868] type=1505 audit(1300220099.145:4):  operation="profile_load" pid=736 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   19.584896] type=1505 audit(1300220099.145:5):  operation="profile_replace" pid=738 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   19.585015] type=1505 audit(1300220099.145:6):  operation="profile_load" pid=736 name="/usr/lib/connman/scripts/dhclient-script"
[   19.585050] type=1505 audit(1300220099.145:7):  operation="profile_replace" pid=738 name="/usr/lib/connman/scripts/dhclient-script"
[   19.762591] em28xx #0: V4L2 video device registered as /dev/video0
[   19.762611] em28xx audio device (eb1a:2821): interface 1, class 1
[   19.770388] em28xx audio device (eb1a:2821): interface 2, class 1
[   19.778010] usbcore: registered new interface driver em28xx
[   19.778013] em28xx driver loaded
[   19.938847] usbcore: registered new interface driver snd-usb-audio
[   21.560019] hda_codec: ALC662 rev1: BIOS auto-probing.
[   22.021504] type=1505 audit(1300220101.584:8):  operation="profile_replace" pid=1174 name="/sbin/dhclient3"
[   22.021776] type=1505 audit(1300220101.584:9):  operation="profile_replace" pid=1174 name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   22.021933] type=1505 audit(1300220101.584:10):  operation="profile_replace" pid=1174 name="/usr/lib/connman/scripts/dhclient-script"
[   22.266950] type=1505 audit(1300220101.824:11):  operation="profile_load" pid=1173 name="/usr/share/gdm/guest-session/Xsession"
[   22.270085] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:07.0/input/input6
[   22.531527]   alloc irq_desc for 29 on node 0
[   22.531530]   alloc kstat_irqs on node 0
[   22.531540] forcedeth 0000:00:0a.0: irq 29 for MSI/MSI-X



      
