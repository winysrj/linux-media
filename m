Return-path: <mchehab@pedra>
Received: from imsantv96b.netvigator.com ([210.87.250.82]:59780 "EHLO
	imsantv96.netvigator.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754823Ab1CYScP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 14:32:15 -0400
Received: from [192.168.0.34] (219-76-193-085.static.netvigator.com [219.76.193.85])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtil1.siriushk.com (Postfix) with ESMTP id 9C55311EAD7
	for <linux-media@vger.kernel.org>; Sat, 26 Mar 2011 02:00:34 +0800 (CST)
Message-ID: <4D8CD841.1010607@siriushk.com>
Date: Sat, 26 Mar 2011 02:00:33 +0800
From: Timothy Lee <timothy.lee@siriushk.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: support MagicPro ProHDTV Pro2 Hybrid DMB-TH PCI
 card
Content-Type: multipart/mixed;
 boundary="------------010604080507030708010300"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010604080507030708010300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  The attached patch adds support for MagicPro ProHDTV Pro2.  Please 
consider its inclusion into the DVB tree.  Thanks.

--------------010604080507030708010300
Content-Type: text/plain;
 name="prohdtv-pro2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="prohdtv-pro2.patch"

>From 5495d8d9c1f958306846e9c4d2dae90cbf889640 Mon Sep 17 00:00:00 2001
From: Timothy Lee <timothy.lee@siriushk.com>
Date: Sat, 26 Mar 2011 01:44:08 +0800
Subject: [PATCH 1/1] saa7134: support MagicPro ProHDTV Pro2 Hybrid DMB-TH PCI card

This card has a TD18271 silicon tuner, and uses TDA8290 and LGS8G75 to
demodulate analog and digital broadcast respectively.  GPIO configurations
were derived using DScaler regspy.

Signed-off-by: Timothy Lee <timothy.lee@siriushk.com>
---
 drivers/media/video/saa7134/saa7134-cards.c |   54 +++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-dvb.c   |   34 +++++++++++++++++
 drivers/media/video/saa7134/saa7134.h       |    1 +
 3 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 61c6007..31a901e 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5591,6 +5591,47 @@ struct saa7134_board saa7134_boards[] = {
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2] = {
+		/* Timothy Lee <timothy.lee@siriushk.com> */
+		.name           = "MagicPro ProHDTV Pro2 DMB-TH/Hybrid",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_config   = 3,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.gpiomask       = 0x02050000,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs = {{
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+			.gpio   = 0x00050000,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1,
+			.gpio   = 0x00050000,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1,
+			.gpio   = 0x00050000,
+		} },
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio   = 0x00050000,
+		},
+		.mute = {
+			.name   = name_mute,
+			.vmux   = 0,
+			.amux   = TV,
+			.gpio   = 0x00050000,
+		},
+	},
 
 };
 
@@ -6795,6 +6836,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subvendor    = 0x185b,
 		.subdevice    = 0xc900,
 		.driver_data  = SAA7134_BOARD_VIDEOMATE_M1F,
+ 	}, {
+ 		.vendor       = PCI_VENDOR_ID_PHILIPS,
+ 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
+ 		.subvendor    = 0x17de,
+ 		.subdevice    = 0xd136,
+ 		.driver_data  = SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2,
 	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
@@ -6988,6 +7035,7 @@ static int saa7134_tda8290_18271_callback(struct saa7134_dev *dev,
 		switch (dev->board) {
 		case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 		case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+		case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
 			ret = saa7134_tda18271_hvr11x0_toggle_agc(dev, arg);
 			break;
 		case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
@@ -7014,6 +7062,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 	case SAA7134_BOARD_AVERMEDIA_M733A:
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
+	case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
@@ -7326,6 +7375,11 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa7134_set_gpio(dev, 1, 1);
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
+	case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
+		/* enable LGS-8G75 */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0e050000, 0x0c050000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0e050000, 0x0c050000);
+		break;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index f65cad2..996a206 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -53,6 +53,7 @@
 #include "lgdt3305.h"
 #include "tda8290.h"
 #include "mb86a20s.h"
+#include "lgs8gxx.h"
 
 #include "zl10353.h"
 
@@ -1123,6 +1124,26 @@ static struct tda18271_config dtv1000s_tda18271_config = {
 	.gate    = TDA18271_GATE_ANALOG,
 };
 
+static struct lgs8gxx_config prohdtv_pro2_lgs8g75_config = {
+	.prod = LGS8GXX_PROD_LGS8G75,
+	.demod_address = 0x1d,
+	.serial_ts = 0,
+	.ts_clk_pol = 1,
+	.ts_clk_gated = 0,
+	.if_clk_freq = 30400, /* 30.4 MHz */
+	.if_freq = 4000, /* 4.00 MHz */
+	.if_neg_center = 0,
+	.ext_adc = 0,
+	.adc_signed = 1,
+	.adc_vpp = 3, /* 2.0 Vpp */
+	.if_neg_edge = 1,
+};
+
+static struct tda18271_config prohdtv_pro2_tda18271_config = {
+	.gate = TDA18271_GATE_ANALOG,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1674,6 +1695,19 @@ static int dvb_init(struct saa7134_dev *dev)
 
 		/* mb86a20s need to use the I2C gateway */
 		break;
+	case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
+		fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
+					       &prohdtv_pro2_lgs8g75_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b,
+				   &tda829x_no_probe);
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
+				   0x60, &dev->i2c_adap,
+				   &prohdtv_pro2_tda18271_config);
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index f96cd5d..0385d0b 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -328,6 +328,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG 182
 #define SAA7134_BOARD_VIDEOMATE_M1F         183
 #define SAA7134_BOARD_ENCORE_ENLTV_FM3      184
+#define SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2 185
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
-- 
1.5.5.6


--------------010604080507030708010300--
