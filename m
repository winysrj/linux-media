Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H0NOvI012298
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 20:23:24 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5H0N9hI006960
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 20:23:10 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Bozhan Boiadzhiev <bozhan@abv.bg>, linux-dvb@linuxtv.org,
	video4linux-list@redhat.com
In-Reply-To: <2133294887.17801.1213652531155.JavaMail.apache@mail73.abv.bg>
References: <2133294887.17801.1213652531155.JavaMail.apache@mail73.abv.bg>
Content-Type: multipart/mixed; boundary="=-UCXTAsftzs8Px3b2V8de"
Date: Tue, 17 Jun 2008 02:21:34 +0200
Message-Id: <1213662094.3950.14.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: 
Subject: Re: Re: Re: [linux-dvb] ASUS My-Cinema remote patch
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


--=-UCXTAsftzs8Px3b2V8de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Am Dienstag, den 17.06.2008, 00:42 +0300 schrieb Bozhan Boiadzhiev:
> first of all
> case SAA7134_BOARD_ASUSTeK_TVFM35:
> must be 
> case SAA7134_BOARD_ASUSTeK_TVFM7135:
> and second(result):

of course, caused by at least faking it on a P7131_Dual previously and
it seems I don't have all the devices in mind anymore ...

> [   27.947020] Linux video capture interface: v2.00
> [   28.018335] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   28.018746] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
> [   28.018757] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [LNKC] -> GSI 19 (level, low) -> IRQ 20
> [   28.018765] saa7133[0]: found at 0000:01:0a.0, rev: 208, irq: 20, latency: 32, mmio: 0xdffff800
> [   28.018770] saa7133[0]: subsystem: 1043:4845, board: ASUS TV-FM 7135 [card=53,autodetected]
> [   28.018785] saa7133[0]: board init: gpio is 40000
> [   28.168275] saa7133[0]: i2c eeprom 00: 43 10 45 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [   28.168284] saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> [   28.168290] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 88 ff ff ff ff
> [   28.168296] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168302] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff ff ff ff ff ff ff
> [   28.168307] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168313] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168318] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168324] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168330] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168335] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168341] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168346] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168352] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168358] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.168363] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   28.404285] tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> [   28.448222] saa7133[0]: P7131 analog only, using entry of ASUSTeK P7131 Analog
> [   28.528013] tda829x 2-004b: setting tuner address to 61
> [   28.655950] tda829x 2-004b: type set to tda8290+75a
> [   28.680922] NET: Registered protocol family 10
> [   28.681144] lo: Disabled Privacy Extensions
> [   29.067262] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input5
> [   32.489132] saa7133[0]: registered device video0 [v4l2]
> [   32.489154] saa7133[0]: registered device vbi0
> [   32.489175] saa7133[0]: registered device radio0
> [   32.552715] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
> [   32.552723] ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [LAZA] -> GSI 23 (level, low) -> IRQ 16
> [   32.552748] PCI: Setting latency timer of device 0000:00:05.0 to 64
> [   32.588072] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> [   32.599962] saa7134_alsa: disagrees about version of symbol saa7134_tvaudio_setmute
> [   32.599968] saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
> [   32.600067] saa7134_alsa: disagrees about version of symbol saa_dsp_writel
> [   32.600069] saa7134_alsa: Unknown symbol saa_dsp_writel
> [   32.600181] saa7134_alsa: disagrees about version of symbol videobuf_dma_free
> [   32.600183] saa7134_alsa: Unknown symbol videobuf_dma_free
> [   32.600298] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_alloc
> [   32.600300] saa7134_alsa: Unknown symbol saa7134_pgtable_alloc
> [   32.600332] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_build
> [   32.600334] saa7134_alsa: Unknown symbol saa7134_pgtable_build
> [   32.600360] saa7134_alsa: disagrees about version of symbol saa7134_pgtable_free
> [   32.600362] saa7134_alsa: Unknown symbol saa7134_pgtable_free
> [   32.600389] saa7134_alsa: disagrees about version of symbol saa7134_dmasound_init
> [   32.600391] saa7134_alsa: Unknown symbol saa7134_dmasound_init
> [   32.600477] saa7134_alsa: disagrees about version of symbol saa7134_dmasound_exit
> [   32.600478] saa7134_alsa: Unknown symbol saa7134_dmasound_exit
> [   32.600540] saa7134_alsa: disagrees about version of symbol videobuf_dma_init
> [   32.600542] saa7134_alsa: Unknown symbol videobuf_dma_init
> [   32.600633] saa7134_alsa: disagrees about version of symbol videobuf_dma_init_kernel
> [   32.600635] saa7134_alsa: Unknown symbol videobuf_dma_init_kernel
> [   32.600710] saa7134_alsa: Unknown symbol videobuf_pci_dma_unmap
> [   32.600796] saa7134_alsa: Unknown symbol videobuf_pci_dma_map
> [   32.600828] saa7134_alsa: disagrees about version of symbol saa7134_set_dmabits
> [   32.600830] saa7134_alsa: Unknown symbol saa7134_set_dmabits
> [   33.623299] lp: driver loaded but no devices found
> [   33.773941] Adding 859436k swap on /dev/sda5.  Priority:-1 extents:1 across:859436k 
> 
> 
> and ...:)
> no sound :)

Did you upgrade to some recent Ubuntu in between?
You don't have the on board analog audio out connected and are depending
on saa7134-alsa?

Analog audio and saa7134-alsa was tested on my fake stuff, also that DVB
is not registered and should work.

> aa and no one more input device either

This is more serious and brain damage by me, improved by faking the
device. Since you have no IR registered on your device, the Dual has,
we can't "steel" it and that fails here.

Force card=145 for now. No sure what to try next yet.

> thanks
> 
>  >-------- Оригинално писмо --------
>  >От:  hermann pitton 
>  >Относно: Re: Re: [linux-dvb] ASUS My-Cinema remote patch
>  >До: Bozhan Boiadzhiev , Hartmut Hackmann , Mauro Carvalho Chehab 
>  >Изпратено на: Неделя, 2008, Юни 15 23:34:35 EEST
> 
>  >Hi,
>  >
>  >Am Sonntag, den 15.06.2008, 13:03 +0300 schrieb Bozhan Boiadzhiev:
>  >> 
>  >> ok i'll test patch later.
>  >> thanks
>  >> :)
>  >
>  >here is an updated version after latest changes by Matthias and Tim on
>  >saa7134. Should work.
>  >
>  >Can't do much more on it. 
>  >
>  >Hartmut, Mauro, the eeprom detection is very basic, but should work. I
>  >sign off so far. Also attached.
>  >
>  >Cheers,
>  >Hermann
>  >
>  >saa7134: add a separate entry for the ASUSTeK P7131 analog only
>  >         and do some eeprom detection to escape from the TVFM35
>  >         with the same PCI subsystem on auto detection.

Many thanks to Bozhan Boiadzhiev for testing and reporting.

Recent version attached, but not ready yet for IR on auto detection.

>  >
>  >Signed-off-by: Hermann Pitton 
>  >
[snip]
>  >
>  >>  >-------- Оригинално писмо --------
>  >>  >От:  hermann pitton 
>  >>  >Относно: Re: [linux-dvb] ASUS My-Cinema remote patch
>  >>  >До: Bozhan Boiadzhiev 
>  >>  >Изпратено на: Неделя, 2008, Юни 15 04:53:14 EEST
>  >> 
>  >>  >Hi Bozhan,
>  >>  >
>  >>  >Am Samstag, den 14.06.2008, 23:44 +0300 schrieb Bozhan Boiadzhiev: 
>  >>  >> ASUS My-Cinema package include remote 
>  >>  >> here i found patch for 2.6.22  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/141622
>  >>  >> Please include it!
>  >>  >> All ASUS My-Cinema comes with remote control.
>  >>  >> Thanks.
>  >>  >> 
>  >>  >
>  >>  >the video4linux-list is the better place for analog only cards.
>  >>  >
>  >>  >The problem is known, but we had no testers.
>  >>  >
>  >>  >The old Asus TVFM35 is not identical to your card.
>  >>  >
>  >>  >It seems to have different s-video and composite inputs and also came
>  >>  >with an USB remote. Adding a new, on the old card not present remote now
>  >>  >there, seems to be confusing for the users.
>  >>  >
>  >>  >The new tuner type tda8275a is auto detected, that makes the old entry
>  >>  >working for you. It has the previous tda8275 not "a".
>  >>  >
>  >>  >The problem is the unchanged PCI subsystem on your card, which causes
>  >>  >that it is autodetected as card=53.
>  >>  >
>  >>  >The following untested patch is a first try to detect your card and add
>  >>  >a separate entry for it. We discussed this once.
>  >>  >
>  >>  >Cheers,
>  >>  >Hermann
>  >>  




--=-UCXTAsftzs8Px3b2V8de
Content-Disposition: attachment;
	filename=saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch
Content-Type: text/x-patch;
	name=saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 78442352b885 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Tue Jun 17 01:05:57 2008 +0200
@@ -143,3 +143,4 @@ 142 -> Beholder BeholdTV H6             
 142 -> Beholder BeholdTV H6                     [5ace:6290]
 143 -> Beholder BeholdTV M63                    [5ace:6191]
 144 -> Beholder BeholdTV M6 Extra               [5ace:6193]
+145 -> ASUSTeK P7131 Analog
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jun 17 01:05:57 2008 +0200
@@ -4394,6 +4394,39 @@ struct saa7134_board saa7134_boards[] = 
 		},
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
+	},
+	[SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
+		.name           = "ASUSTeK P7131 Analog",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.gpiomask	= 1 << 21,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000000,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+		}, {
+			.name = name_comp2,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
 	},
 };
 
@@ -5671,6 +5704,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_FLYDVBT_LR301:
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -6009,6 +6043,15 @@ int saa7134_board_init2(struct saa7134_d
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ASUSTeK_TVFM7135:
+	/* The card below is detected as card=53, but is different */
+		if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
+			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+			printk(KERN_INFO "%s: P7131 analog only, using "
+							"entry of %s\n",
+			dev->name, saa7134_boards[dev->board].name);
+		}
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		hauppauge_eeprom(dev, dev->eedata+0x80);
 		/* break intentionally omitted */
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Tue Jun 17 01:05:57 2008 +0200
@@ -409,6 +409,7 @@ int saa7134_input_init1(struct saa7134_d
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = ir_codes_asus_pc39;
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Jun 17 01:05:57 2008 +0200
@@ -273,6 +273,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_H6      142
 #define SAA7134_BOARD_BEHOLD_M63      143
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
+#define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 145
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--=-UCXTAsftzs8Px3b2V8de
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-UCXTAsftzs8Px3b2V8de--
