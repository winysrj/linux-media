Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:24156 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0ARGR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 01:17:26 -0500
Received: by ey-out-2122.google.com with SMTP id d26so609942eyd.19
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 22:17:24 -0800 (PST)
Message-ID: <4B53FCF2.7000303@gmail.com>
Date: Mon, 18 Jan 2010 07:17:22 +0100
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	hermann pitton <hermann-pitton@arcor.de>, jpnews13@free.fr
Subject: [PATCH] [RFC] support for fly dvb duo on medion laptop
Content-Type: multipart/mixed;
 boundary="------------090208070807030304050705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090208070807030304050705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi list,

this patch add support for lifeview fly dvb duo (hybrid card) on medion 
laptop

what works : dvb and analogic tv
not tested :  svideo, composite, radio (i am not the owner of this card)

this card uses gpio 22 for the mode switch between analogic and dvb

gpio settings  should change when  svideo , composite an radio will be 
tested


Cheers,
Thomas

Signed-off-by : Thomas Genty <tomlohave@gmail.com>

--------------090208070807030304050705
Content-Type: text/x-patch;
 name="flymedion.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="flymedion.diff"

diff -r cdcf089168df linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jan 17 20:42:47 2010 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon Jan 18 07:03:53 2010 +0100
@@ -5394,7 +5394,37 @@
 			.amux = LINE2,
 		},
 	},
-
+	[SAA7134_BOARD_FLYDVBTDUO_MEDION] = {
+		/* Thomas Genty <tomlohave@gmail.com> */
+		.name           = "LifeView FlyDVB-T DUO Medion",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.gpiomask	= 0x00200000,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.gpio = 0x200000,
+			.tv   = 1,
+		},{
+			.name = name_comp1,	/* Not tested */
+			.vmux = 3,
+			.amux = LINE1,
+		},{
+			.name = name_svideo,	/* Not tested */
+			.vmux = 8,
+			.amux = LINE1,
+		}},
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x000000,	/* No tested */
+		},
+	},
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6551,6 +6581,12 @@
 		.subdevice    = 0x6655,
 		.driver_data  = SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x5168,         
+		.subdevice    = 0x0307,  /* LR307-N */       
+		.driver_data  = SAA7134_BOARD_FLYDVBTDUO_MEDION,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7318,6 +7354,7 @@
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
 	case SAA7134_BOARD_CREATIX_CTX953:
+	case SAA7134_BOARD_FLYDVBTDUO_MEDION:
 	{
 		/* this is a hybrid board, initialize to analog mode
 		 * and configure firmware eeprom address
diff -r cdcf089168df linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sun Jan 17 20:42:47 2010 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon Jan 18 07:03:53 2010 +0100
@@ -825,6 +825,20 @@
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config tda827x_flydvbtduo_medion_config = {
+	.demod_address = 0x08,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP01_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x61,
+	.antenna_switch = 2,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1586,6 +1600,22 @@
 				   &dtv1000s_tda18271_config);
 		}
 		break;
+	case SAA7134_BOARD_FLYDVBTDUO_MEDION:
+		/* this card uses saa713x GPIO22 for the mode switch */
+		fe0->dvb.frontend = dvb_attach(tda10046_attach,
+					       &tda827x_flydvbtduo_medion_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend) {
+			if (dvb_attach(tda827x_attach,fe0->dvb.frontend,
+				   tda827x_flydvbtduo_medion_config.tuner_address, &dev->i2c_adap,
+								&ads_duo_cfg) == NULL) {
+				wprintk("no tda827x tuner found at addr: %02x\n",
+					tda827x_flydvbtduo_medion_config.tuner_address);
+				goto dettach_frontend;
+			}
+		} else
+			wprintk("failed to attach tda10046\n");
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff -r cdcf089168df linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Jan 17 20:42:47 2010 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Mon Jan 18 07:03:53 2010 +0100
@@ -301,6 +301,7 @@
 #define SAA7134_BOARD_ASUS_EUROPA_HYBRID	174
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
 #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
+#define SAA7134_BOARD_FLYDVBTDUO_MEDION     177
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8

--------------090208070807030304050705--
