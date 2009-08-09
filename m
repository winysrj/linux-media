Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmtp2.tin.it ([212.216.176.222]:46305 "EHLO vsmtp2.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZHINFL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2009 09:05:11 -0400
Received: from [192.168.0.2] (79.0.84.227) by vsmtp2.tin.it (8.0.022) (authenticated as v.donadonibus@tin.it)
        id 49F5BE4206FC03E6 for linux-media@vger.kernel.org; Sun, 9 Aug 2009 14:59:29 +0200
Message-ID: <4A7EC830.5070602@tiscali.it>
Date: Sun, 09 Aug 2009 14:59:28 +0200
From: Vittorio Donadonibus <v.donadonibus@tiscali.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: During the USB dvb-t install
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, attached as requested during installation

Best Regards


[  246.881824] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, 
interface 0, class 0)
[  246.881837] em28xx #0: Identified as Unknown EM2750/28xx video 
grabber (card=1)
[  246.881933] em28xx #0: chip ID is em2882/em2883
[  246.973022] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 
5c 00 6a 20 6a 00
[  246.973041] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 
00 00 02 02 00 00
[  246.973058] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 
00 00 5b 1e 00 00
[  246.973075] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 
00 00 00 00 00 00
[  246.973093] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973109] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973126] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
20 03 55 00 53 00
[  246.973143] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 
31 00 20 00 56 00
[  246.973160] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 
00 00 00 00 00 00
[  246.973177] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973194] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973211] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973228] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973245] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973262] em28xx #0: i2c eeprom e0: 5a 00 55 aa 8f b7 55 03 00 17 
fc 01 00 00 00 00
[  246.973279] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 
00 00 00 00 00 00
[  246.973297] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x17620d20
[  246.973300] em28xx #0: EEPROM info:
[  246.973302] em28xx #0:    AC97 audio (5 sample rates)
[  246.973304] em28xx #0:    USB Remote wakeup capable
[  246.973306] em28xx #0:    500mA max power
[  246.973309] em28xx #0:    Table at 0x04, strings=0x206a, 0x006a, 0x0000
[  246.999891] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  247.003388] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[  247.005139] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[  247.013138] em28xx #0: Your board has no unique USB ID and thus need 
a hint to be detected.
[  247.013143] em28xx #0: You may try to use card=<n> insmod option to 
workaround that.
[  247.013145] em28xx #0: Please send an email with this log to:
[  247.013148] em28xx #0:     V4L Mailing List <linux-media@vger.kernel.org>
[  247.013151] em28xx #0: Board eeprom hash is 0x17620d20
[  247.013153] em28xx #0: Board i2c devicelist hash is 0x27e10080
[  247.013156] em28xx #0: Here is a list of valid choices for the 
card=<n> insmod option:
[  247.013159] em28xx #0:     card=0 -> Unknown EM2800 video grabber
[  247.013162] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
[  247.013164] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
[  247.013167] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
[  247.013169] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
[  247.013171] em28xx #0:     card=5 -> MSI VOX USB 2.0
[  247.013174] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
[  247.013177] em28xx #0:     card=7 -> Leadtek Winfast USB II
[  247.013179] em28xx #0:     card=8 -> Kworld USB2800
[  247.013182] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker
[  247.013185] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
[  247.013187] em28xx #0:     card=11 -> Terratec Hybrid XS
[  247.013190] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
[  247.013192] em28xx #0:     card=13 -> Terratec Prodigy XS
[  247.013195] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview 
Prolink PlayTV USB 2.0
[  247.013198] em28xx #0:     card=15 -> V-Gear PocketTV
[  247.013200] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
[  247.013203] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
[  247.013205] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
[  247.013208] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design
[  247.013210] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
[  247.013213] em28xx #0:     card=21 -> eMPIA Technology, Inc. 
GrabBeeX+ Video Encoder
[  247.013216] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
[  247.013219] em28xx #0:     card=23 -> Huaqi DLCW-130
[  247.013221] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
[  247.013224] em28xx #0:     card=25 -> Gadmei UTV310
[  247.013226] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
[  247.013229] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips 
FM1216ME)
[  247.013231] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
[  247.013234] em28xx #0:     card=29 -> <NULL>
[  247.013237] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
[  247.013239] em28xx #0:     card=31 -> Usbgear VD204v9
[  247.013242] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
[  247.013244] em28xx #0:     card=33 -> <NULL>
[  247.013247] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
[  247.013249] em28xx #0:     card=35 -> Typhoon DVD Maker
[  247.013252] em28xx #0:     card=36 -> NetGMBH Cam
[  247.013254] em28xx #0:     card=37 -> Gadmei UTV330
[  247.013256] em28xx #0:     card=38 -> Yakumo MovieMixer
[  247.013259] em28xx #0:     card=39 -> KWorld PVRTV 300U
[  247.013261] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
[  247.013264] em28xx #0:     card=41 -> Kworld 350 U DVB-T
[  247.013266] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[  247.013269] em28xx #0:     card=43 -> Terratec Cinergy T XS
[  247.013271] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[  247.013274] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[  247.013277] em28xx #0:     card=46 -> Compro, VideoMate U3
[  247.013279] em28xx #0:     card=47 -> KWorld DVB-T 305U
[  247.013282] em28xx #0:     card=48 -> KWorld DVB-T 310U
[  247.013284] em28xx #0:     card=49 -> MSI DigiVox A/D
[  247.013286] em28xx #0:     card=50 -> MSI DigiVox A/D II
[  247.013289] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[  247.013292] em28xx #0:     card=52 -> DNT DA2 Hybrid
[  247.013294] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[  247.013296] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  247.013299] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  247.013302] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  247.013304] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  247.013307] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  247.013309] em28xx #0:     card=59 -> <NULL>
[  247.013312] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  247.013314] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  247.013317] em28xx #0:     card=62 -> Gadmei TVR200
[  247.013319] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  247.013322] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  247.013324] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  247.013327] em28xx #0:     card=66 -> Empire dual TV
[  247.013329] em28xx #0:     card=67 -> Terratec Grabby
[  247.013332] em28xx #0:     card=68 -> Terratec AV350
[  247.013334] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  247.013337] em28xx #0:     card=70 -> Evga inDtube
[  247.013339] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  247.013385] em28xx #0: Config register raw data: 0x58
[  247.014135] em28xx #0: AC97 vendor ID = 0x41e441e4
[  247.014510] em28xx #0: AC97 features = 0x41e4
[  247.014513] em28xx #0: Unknown AC97 audio processor detected!
[  247.047885] em28xx #0: v4l2 driver version 0.1.2
[  247.047924] Modules linked in: snd_usb_audio(+) snd_usb_lib snd_hwdep 
em28xx(+) ir_common v4l2_common videodev v4l1_compat videobuf_vmalloc 
videobuf_core tveeprom binfmt_misc radeon drm video output input_polldev 
it87 hwmon_vid lp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd psmouse 
i82875p_edac iTCO_wdt iTCO_vendor_support soundcore ppdev edac_core 
pcspkr snd_page_alloc serio_raw shpchp parport_pc parport joydev 
intel_agp agpgart usbhid ohci1394 e100 mii ieee1394 floppy fbcon 
tileblit font bitblit softcursor
[  247.048016] EIP is at get_scale+0x38/0xc0 [em28xx]
[  247.048069]  [<f8184d7d>] ? em28xx_set_video_format+0x6d/0x90 [em28xx]
[  247.048078]  [<f8185550>] ? em28xx_register_analog_devices+0x90/0x2b0 
[em28xx]
[  247.048086]  [<f81886b8>] ? em28xx_usb_probe+0x578/0xaa0 [em28xx]
[  247.048211]  [<f7d8d000>] ? em28xx_module_init+0x0/0x47 [em28xx]
[  247.048218]  [<f7d8d01b>] ? em28xx_module_init+0x1b/0x47 [em28xx]
[  247.048356] EIP: [<f8183138>] get_scale+0x38/0xc0 [em28xx] SS:ESP 
0068:f2d59b18

