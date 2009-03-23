Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NM5aqC021386
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 18:05:36 -0400
Received: from smtp.seznam.cz (smtp.seznam.cz [77.75.72.43])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2NM5Dum029734
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 18:05:13 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: video4linux-list@redhat.com
Date: Mon, 23 Mar 2009 23:05:09 +0100
References: <49B85A45.1060203@altlinux.ru>
In-Reply-To: <49B85A45.1060203@altlinux.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VeAyJ8SVhdSuw3U"
Message-Id: <200903232305.09859.oldium.pro@seznam.cz>
Subject: Re: AverMedia CardBus Plus (E501R)
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

--Boundary-00=_VeAyJ8SVhdSuw3U
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 12 of March 2009 at 01:41:41, Grigory Milev wrote:
> Does any body know, why support for this card don't exists in v4l2
> kernel drivers?
> May be sombody know how to use Radio and IR on this card.
>

Hi Grigory,

I have this card somewhere, I was using it up to 2.6.25 with the attached 
patch (doesn't apply to the latest kernel). The IR should be the same as it 
is in E506R (that I have now), so the patch for E506R's IR should work for 
you too.

1. Look at the attached patch for E501R (Cardbus Plus). You need to tweak it  
a little bit (change the constant, maybe other initialization code) to make 
it work. Hopefully you will be successful.

2. The IR patch and instructions for E506R (applies to 2.6.28 cleanly, it is 
part of linux-next branch in linux-dvb tree now) can be found in 
http://en.gentoo-wiki.com/wiki/AverMedia_AverTV_Cardbus_Hybrid_E506R

3. You need to activate the IR by inserting line

  dev->has_remote = SAA7134_REMOTE_I2C;

in the card initialization code (saa7134-cards.c,  lines after `case 
SAA7134_BOARD_AVERMEDIA_CARDBUS_PLUS:`, but before the `break`).

Cheers,
Oldrich.

> Thanks.

--Boundary-00=_VeAyJ8SVhdSuw3U
Content-Type: text/x-diff;
  charset="utf-8";
  name="avermedia-2.6.25.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="avermedia-2.6.25.patch"

diff -ur linux-2.6.25-rc4.orig/drivers/media/video/saa7134/saa7134-cards.c linux-2.6.25-rc4/drivers/media/video/saa7134/saa7134-cards.c
--- linux-2.6.25-rc4.orig/drivers/media/video/saa7134/saa7134-cards.c	2008-03-05 18:57:43.000000000 +0100
+++ linux-2.6.25-rc4/drivers/media/video/saa7134/saa7134-cards.c	2008-03-05 19:04:29.000000000 +0100
@@ -1641,6 +1641,38 @@
 			.amux = LINE1,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_CARDBUS_PLUS] = {
+		.name           = "AVerMedia Cardbus Plus TV/Radio (E501)",
+		.audio_clock    = 0x187de7,
+		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
+		.radio_type     = TUNER_TEA5767,
+		.tuner_addr	= 0x61,
+		.radio_addr	= 0x60,
+		.tda9887_conf	= TDA9887_PRESENT,
+		.gpiomask	= 0x0C400003,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0C400001,
+		},{
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+			.gpio = 0x0C400002,
+		},{
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+			.gpio = 0x0C400002,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+			.gpio = 0x04400001,
+		},
+	},
 	[SAA7134_BOARD_CINERGY400_CARDBUS] = {
 		.name           = "Terratec Cinergy 400 mobile",
 		.audio_clock    = 0x187de7,
@@ -4247,6 +4279,13 @@
 		.subdevice    = 0xd6ee,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS,
 	},{
+		/* AVerMedia CardBus Plus */
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xb7e9,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_CARDBUS_PLUS,
+	},{
 		/* TransGear 3000TV */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
@@ -5111,6 +5150,12 @@
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00040000, 0x00040000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00040000, 0x00000000);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_CARDBUS_PLUS:
+		/* power-up tuner chip */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0C440003, 0x0C440003);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0C400000, 0x0C400000);
+		msleep(1);
+		break;
 	case SAA7134_BOARD_PINNACLE_300I_DVBT_PAL:
 		/* this turns the remote control chip off to work around a bug in it */
 		saa_writeb(SAA7134_GPIO_GPMODE1, 0x80);
diff -ur linux-2.6.25-rc4.orig/drivers/media/video/saa7134/saa7134.h linux-2.6.25-rc4/drivers/media/video/saa7134/saa7134.h
--- linux-2.6.25-rc4.orig/drivers/media/video/saa7134/saa7134.h	2008-03-05 18:57:43.000000000 +0100
+++ linux-2.6.25-rc4/drivers/media/video/saa7134/saa7134.h	2008-03-05 19:05:14.000000000 +0100
@@ -254,6 +254,7 @@
 #define SAA7134_BOARD_BEHOLD_M6		130
 #define SAA7134_BOARD_TWINHAN_DTV_DVB_3056 131
 #define SAA7134_BOARD_GENIUS_TVGO_A11MCE 132
+#define SAA7134_BOARD_AVERMEDIA_CARDBUS_PLUS 133
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--Boundary-00=_VeAyJ8SVhdSuw3U
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_VeAyJ8SVhdSuw3U--
