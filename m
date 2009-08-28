Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40429 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZH1OpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 10:45:13 -0400
Received: by ewy2 with SMTP id 2so2187075ewy.17
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2009 07:45:14 -0700 (PDT)
From: Eugene Yudin <eugene.yudin@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [PATCH] Add support for RoverMedia TV Link Pro FM v3
Date: Fri, 28 Aug 2009 18:46:01 +0400
Cc: linux-media@vger.kernel.org
References: <200908272104.59221.Eugene.Yudin@gmail.com> <1251415468.3742.12.camel@pc07.localdom.local> <1251420843.3674.3.camel@pc07.localdom.local>
In-Reply-To: <1251420843.3674.3.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908281846.01964.Eugene.Yudin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann!

> Most likely you have one of the current tuner=38 TCL MK3 clones sitting
> on it.
You're right. Thanks much. This tuner is better suited. The picture was better 
on some channels.

> I suggest to start with tuner=38, enable debug=2 for tda9887 and switch
> between 2 or three channels and try also the radio mode. Is a tda9887
> active?
It seems that active.

[eugene@arch ~]$ dmesg | grep tda
tda9887 2-0043: configure for: Radio Mono
tda9887 2-0043: writing: b=0x4c c=0x30 e=0x3d
tda9887 2-0043: write: byte B 0x4c
tda9887 2-0043:   B0   video mode      : sound trap
tda9887 2-0043:   B1   auto mute fm    : no
tda9887 2-0043:   B2   carrier mode    : QSS
tda9887 2-0043:   B3-4 tv sound/radio  : FM/radio
tda9887 2-0043:   B5   force mute audio: no
tda9887 2-0043:   B6   output port 1   : high (inactive)
tda9887 2-0043:   B7   output port 2   : low (active)
tda9887 2-0043: write: byte C 0x30
tda9887 2-0043:   C0-4 top adjustment  : 0 dB
tda9887 2-0043:   C5-6 de-emphasis     : no
tda9887 2-0043:   C7   audio gain      : 0
tda9887 2-0043: write: byte E 0x3d
tda9887 2-0043:   E0-1 sound carrier   : 5.5 MHz
tda9887 2-0043:   E6   l pll gating   : 13
tda9887 2-0043:   E2-4 video if        : 44 MHz
tda9887 2-0043:   E7   vif agc output  : fm radio carrier afc
tda9887 2-0043: --
tda9887 2-0043: configure for: Radio Mono
tda9887 2-0043: writing: b=0x4c c=0x30 e=0x3d
tda9887 2-0043: write: byte B 0x4c
tda9887 2-0043:   B0   video mode      : sound trap
tda9887 2-0043:   B1   auto mute fm    : no
tda9887 2-0043:   B2   carrier mode    : QSS
tda9887 2-0043:   B3-4 tv sound/radio  : FM/radio
tda9887 2-0043:   B5   force mute audio: no
tda9887 2-0043:   B6   output port 1   : high (inactive)
tda9887 2-0043:   B7   output port 2   : low (active)
tda9887 2-0043: write: byte C 0x30
tda9887 2-0043:   C0-4 top adjustment  : 0 dB
tda9887 2-0043:   C5-6 de-emphasis     : no
tda9887 2-0043:   C7   audio gain      : 0
tda9887 2-0043: write: byte E 0x3d
tda9887 2-0043:   E0-1 sound carrier   : 5.5 MHz
tda9887 2-0043:   E6   l pll gating   : 13
tda9887 2-0043:   E2-4 video if        : 44 MHz
tda9887 2-0043:   E7   vif agc output  : fm radio carrier afc
tda9887 2-0043: --
tda9887 2-0043: configure for: SECAM-DK
tda9887 2-0043: writing: b=0x14 c=0x70 e=0x4b
tda9887 2-0043: write: byte B 0x14
tda9887 2-0043:   B0   video mode      : sound trap
tda9887 2-0043:   B1   auto mute fm    : no
tda9887 2-0043:   B2   carrier mode    : QSS
tda9887 2-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 2-0043:   B5   force mute audio: no
tda9887 2-0043:   B6   output port 1   : low (active)
tda9887 2-0043:   B7   output port 2   : low (active)
tda9887 2-0043: write: byte C 0x70
tda9887 2-0043:   C0-4 top adjustment  : 0 dB
tda9887 2-0043:   C5-6 de-emphasis     : 50
tda9887 2-0043:   C7   audio gain      : 0
tda9887 2-0043: write: byte E 0x4b
tda9887 2-0043:   E0-1 sound carrier   : 6.5 MHz / AM
tda9887 2-0043:   E6   l pll gating   : 36
tda9887 2-0043:   E2-4 video if        : 38.9 MHz
tda9887 2-0043:   E5   tuner gain      : normal
tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 2-0043: --
tda9887 2-0043: configure for: SECAM-DK
tda9887 2-0043: writing: b=0x14 c=0x70 e=0x4b
tda9887 2-0043: write: byte B 0x14
tda9887 2-0043:   B0   video mode      : sound trap
tda9887 2-0043:   B1   auto mute fm    : no
tda9887 2-0043:   B2   carrier mode    : QSS
tda9887 2-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 2-0043:   B5   force mute audio: no
tda9887 2-0043:   B6   output port 1   : low (active)
tda9887 2-0043:   B7   output port 2   : low (active)
tda9887 2-0043: write: byte C 0x70
tda9887 2-0043:   C0-4 top adjustment  : 0 dB
tda9887 2-0043:   C5-6 de-emphasis     : 50
tda9887 2-0043:   C7   audio gain      : 0
tda9887 2-0043: write: byte E 0x4b
tda9887 2-0043:   E0-1 sound carrier   : 6.5 MHz / AM
tda9887 2-0043:   E6   l pll gating   : 36
tda9887 2-0043:   E2-4 video if        : 38.9 MHz
tda9887 2-0043:   E5   tuner gain      : normal
tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 2-0043: --
tda9887 2-0043: configure for: PAL-BGHN
tda9887 2-0043: writing: b=0x14 c=0x70 e=0x49
tda9887 2-0043: write: byte B 0x14
tda9887 2-0043:   B0   video mode      : sound trap
tda9887 2-0043:   B1   auto mute fm    : no
tda9887 2-0043:   B2   carrier mode    : QSS
tda9887 2-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 2-0043:   B5   force mute audio: no
tda9887 2-0043:   B6   output port 1   : low (active)
tda9887 2-0043:   B7   output port 2   : low (active)
tda9887 2-0043: write: byte C 0x70
tda9887 2-0043:   C0-4 top adjustment  : 0 dB
tda9887 2-0043:   C5-6 de-emphasis     : 50
tda9887 2-0043:   C7   audio gain      : 0
tda9887 2-0043: write: byte E 0x49
tda9887 2-0043:   E0-1 sound carrier   : 5.5 MHz
tda9887 2-0043:   E6   l pll gating   : 36
tda9887 2-0043:   E2-4 video if        : 38.9 MHz
tda9887 2-0043:   E5   tuner gain      : normal
tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 2-0043: --

> Is "four in one" checked on the tuner's sticker?
Yes, it is. I also made a photo(3 Mb) of this board 
(http://img34.imageshack.us/img34/7330/img1417d.jpg).
Under the label was marked "TCL MFPE05".

Updated patch is at the end of letter. I also checked the auto-detection. It 
works correctly with this "modprobe.conf":
alias char-major-81 videodev
alias char-major-81-0 saa7134
options saa7134 i2c_scan=1

Dmesg:
[eugene@arch ~]$ dmesg | grep saa
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:01:07.0: PCI INT A -> Link[APC4] -> GSI 19 (level, high) -> IRQ 
19
saa7134[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio: 
0xea000000
saa7134[0]: subsystem: 19d1:0138, board: RoverMedia TV Link Pro FM 
[card=170,autodetected]
saa7134[0]: board init: gpio is 3b000                                                     
input: saa7134 IR (RoverMedia TV Link  as 
/devices/pci0000:00/0000:00:08.0/0000:01:07.0/input/input5                                                                                      
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs                            
saa7134[0]: i2c eeprom 00: d1 19 38 01 10 28 ff ff ff ff ff ff ff ff ff ff                   
saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7134[0]: i2c scan: found device @ 0xc2  [???]
tuner 2-0043: chip found @ 0x86 (saa7134[0])
tuner 2-0061: chip found @ 0xc2 (saa7134[0])
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[0]/alsa: saa7134[0] at 0xea000000 irq 19 registered as card -1

Once again, many thanks!

Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>

Best Regards, Eugene.

diff -uprN a/linux/Documentation/video4linux/CARDLIST.saa7134 
b/linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	2009-08-28 
14:11:53.000000000 +0400
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	2009-08-28 
17:59:29.286336586 +0400
@@ -168,3 +168,4 @@
 167 -> Beholder BeholdTV 609 RDS                [5ace:6092]
 168 -> Beholder BeholdTV 609 RDS                [5ace:6093]
 169 -> Compro VideoMate S350/S300               [185b:c900]
+170 -> RoverMedia TV Link Pro FM                [19d1:0138]
diff -uprN a/linux/drivers/media/video/saa7134/saa7134-cards.c 
b/linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-28 
14:11:55.000000000 +0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	2009-08-28 
18:06:47.419626739 +0400
@@ -5182,6 +5182,56 @@ struct saa7134_board saa7134_boards[] = 
 			.amux	= LINE1
 		} },
 	},
+	[SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM] = {
+		/* Eugene Yudin <Eugene.Yudin@gmail.com> */
+		.name		= "RoverMedia TV Link Pro FM",
+		.audio_clock	= 0x00200000,
+		.tuner_type	= TUNER_PHILIPS_FM1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+
+		.gpiomask       = 0xe000,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x8000,
+			.tv   = 1,
+		},{
+			.name = name_tv_mono,
+			.vmux = 1,
+			.amux = LINE2,
+			.gpio = 0x0000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		},{
+			.name = name_comp2,
+			.vmux = 3,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+			.gpio = 0x4000,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x2000,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = TV,
+			.gpio = 0x8000,
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6296,6 +6346,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_S350,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x19d1, /* RoverMedia */
+		.subdevice    = 0x0138, /* LifeView FlyTV Prime30 OEM */
+		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -6656,6 +6712,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_REAL_ANGEL_220:
 	case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
 	case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
+	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
diff -uprN a/linux/drivers/media/video/saa7134/saa7134-input.c 
b/linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	2009-08-28 
14:11:55.000000000 +0400
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	2009-08-28 
18:07:15.409625963 +0400
@@ -456,6 +456,7 @@ int saa7134_input_init1(struct saa7134_d
 	case SAA7134_BOARD_FLYVIDEO3000:
 	case SAA7134_BOARD_FLYTVPLATINUM_FM:
 	case SAA7134_BOARD_FLYTVPLATINUM_MINI2:
+	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
 		ir_codes     = ir_codes_flyvideo;
 		mask_keycode = 0xEC00000;
 		mask_keydown = 0x0040000;
diff -uprN a/linux/drivers/media/video/saa7134/saa7134.h 
b/linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	2009-08-28 
14:11:55.000000000 +0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h	2009-08-28 
18:00:10.563752295 +0400
@@ -294,6 +294,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_609RDS_MK3     167
 #define SAA7134_BOARD_BEHOLD_609RDS_MK5     168
 #define SAA7134_BOARD_VIDEOMATE_S350        169
+#define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM     170
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8



