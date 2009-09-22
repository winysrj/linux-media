Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:33038
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZIVVJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:09:18 -0400
Date: Tue, 22 Sep 2009 23:09:15 +0200
From: spam@systol-ng.god.lan
To: linux-media@vger.kernel.org
Cc: mkrufky@gmail.com
Subject: [PATCH 4/4] Zolid Hybrid PCI card add AGC control
Message-ID: <20090922210915.GD8661@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Switches IF AGC control via GPIO 21 of the saa7134. Improves DTV reception and
FM radio reception.

Signed-off-by: Henk.Vergonet@gmail.com

diff -r 29e4ba1a09bc linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Sep 22 22:06:31 2009 +0200
@@ -6651,6 +6651,22 @@
 	return 0;
 }
 
+static inline int saa7134_tda18271_zolid_toggle_agc(struct saa7134_dev *dev,
+						      enum tda18271_mode mode)
+{
+	switch (mode) {
+	case TDA18271_ANALOG:
+		saa7134_set_gpio(dev, 21, 0);
+		break;
+	case TDA18271_DIGITAL:
+		saa7134_set_gpio(dev, 21, 1);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int saa7134_tda8290_18271_callback(struct saa7134_dev *dev,
 					  int command, int arg)
 {
@@ -6663,7 +6679,8 @@
 		case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 			ret = saa7134_tda18271_hvr11x0_toggle_agc(dev, arg);
 			break;
-		default:
+		case SAA7134_BOARD_ZOLID_HYBRID_PCI:
+			ret = saa7134_tda18271_zolid_toggle_agc(dev, arg);
 			break;
 		}
 		break;
@@ -6682,6 +6699,7 @@
 	switch (dev->board) {
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
@@ -6985,6 +7003,11 @@
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
 		break;
+	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
+		saa7134_set_gpio(dev, 21, 0);	/* s0 HC4052 */
+		saa7134_set_gpio(dev, 22, 0);	/* vsync tda18271 - TODO implement saa713x driven sync in analog TV modes */
+		saa7134_set_gpio(dev, 23, 0);	/* s1 HC4052 */
+		break;
 	}
 	return 0;
 }
diff -r 29e4ba1a09bc linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue Sep 22 22:06:31 2009 +0200
@@ -1026,8 +1026,17 @@
 	.disable_gate_access = 1,
 };
 
+static struct tda18271_std_map zolid_tda18271_std_map = {
+	/* FM reception via RF_IN */
+	.fm_radio = { .if_freq = 1250, .fm_rfn = 0, .agc_mode = 3, .std = 0,
+		      .if_lvl = 0, .rfagc_top = 0x2c, },
+};
+
 static struct tda18271_config zolid_tda18271_config = {
+	.std_map = &zolid_tda18271_std_map,
 	.gate    = TDA18271_GATE_ANALOG,
+	.config  = 3,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
 /* ==================================================================
