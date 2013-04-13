Return-path: <linux-media-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.49.41]:50068 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab3DMPJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 11:09:44 -0400
From: Jakob Haufe <sur5r@sur5r.net>
To: linux-media@vger.kernel.org
Cc: Jakob Haufe <sur5r@sur5r.net>
Subject: [PATCH 2/2] em28xx: Add support for 1b80:e1cc Delock 61959
Date: Sat, 13 Apr 2013 17:03:37 +0200
Message-Id: <1365865417-22853-3-git-send-email-sur5r@sur5r.net>
In-Reply-To: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
References: <1365865417-22853-1-git-send-email-sur5r@sur5r.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware is the same as MaxMedia UB425-TC but ships with a different
remote.

Signed-off-by: Jakob Haufe <sur5r@sur5r.net>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   16 ++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |    5 +++--
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 1d3866f..f625907 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -374,6 +374,7 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
 #endif
 
 /* 1b80:e425 MaxMedia UB425-TC
+ * 1b80:e1cc Delock 61959
  * GPIO_6 - demod reset, 0=active
  * GPIO_7 - LED, 0=active
  */
@@ -2016,6 +2017,19 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	/* 1b80:e1cc Delock 61959
+	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2
+         * mostly the same as MaxMedia UB-425-TC but different remote */
+	[EM2874_BOARD_DELOCK_61959] = {
+		.name          = "Delock 61959",
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = maxmedia_ub425_tc,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_DELOCK_61959,
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2177,6 +2191,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_510E },
 	{ USB_DEVICE(0x2013, 0x0251),
 			.driver_info = EM2884_BOARD_PCTV_520E },
+	{ USB_DEVICE(0x1b80, 0xe1cc),
+			.driver_info = EM2874_BOARD_DELOCK_61959 },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 42a6a26..663c998 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1213,6 +1213,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
 				&em28xx_a8293_config);
 		break;
+	case EM2874_BOARD_DELOCK_61959:
 	case EM2874_BOARD_MAXMEDIA_UB425_TC:
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &maxmedia_ub425_tc_drxk,
@@ -1232,8 +1233,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 
 		/* TODO: we need drx-3913k firmware in order to support DVB-T */
-		em28xx_info("MaxMedia UB425-TC: only DVB-C supported by that " \
-				"driver version\n");
+		em28xx_info("MaxMedia UB425-TC/Delock 61959: only DVB-C " \
+				"supported by that driver version\n");
 
 		break;
 	case EM2884_BOARD_PCTV_510E:
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a9323b6..59a9580 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -130,6 +130,7 @@
 #define EM2884_BOARD_PCTV_520E			  86
 #define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
 #define EM2884_BOARD_C3TECH_DIGITAL_DUO		  88
+#define EM2874_BOARD_DELOCK_61959		  89
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.10.4

