Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39496 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab2CRWJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 18:09:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH FOR 3.4] em28xx: support for 1b80:e425 MaxMedia UB425-TC
Date: Mon, 19 Mar 2012 00:09:01 +0200
Message-Id: <1332108541-14584-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware is based of:
Empia EM2874B
Micronas DRX 3913KA2
NXP TDA18271HDC2

Only DVB-C supported currently since missing firmware.
According to my tests, DRX 3913KA2 demodulator requires firmware
in order to support DVB-T mode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/video/em28xx/em28xx-cards.c |   24 ++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx-dvb.c   |   29 +++++++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx.h       |    1 +
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ce1b60f..d5c9613 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -353,6 +353,17 @@ static struct em28xx_reg_seq hauppauge_930c_digital[] = {
 };
 #endif
 
+/* 1b80:e425 MaxMedia UB425-TC
+ * GPIO_6 - demod reset, 0=active
+ * GPIO_7 - LED, 0=active
+ */
+static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
+	{EM2874_R80_GPIO,  0x83,  0xff,  100},
+	{EM2874_R80_GPIO,  0xc3,  0xff,  100}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO,  0x43,  0xff,  000}, /* GPIO_7 = 0 */
+	{-1,                 -1,    -1,   -1},
+};
+
 /*
  *  Board definitions
  */
@@ -1908,6 +1919,17 @@ struct em28xx_board em28xx_boards[] = {
 			.amux     = EM28XX_AMUX_LINE_IN,
 		} },
 	},
+	/* 1b80:e425 MaxMedia UB425-TC
+	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2 */
+	[EM2874_BOARD_MAXMEDIA_UB425_TC] = {
+		.name          = "MaxMedia UB425-TC",
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = maxmedia_ub425_tc,
+		.has_dvb       = 1,
+		.i2c_speed     = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2059,6 +2081,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2860_BOARD_HT_VIDBOX_NW03 },
 	{ USB_DEVICE(0x1b80, 0xe309), /* Sveon STV40 */
 			.driver_info = EM2860_BOARD_EASYCAP },
+	{ USB_DEVICE(0x1b80, 0xe425),
+			.driver_info = EM2874_BOARD_MAXMEDIA_UB425_TC },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index fbd9010..0b3e301 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -325,6 +325,12 @@ struct drxk_config hauppauge_930c_drxk = {
 	.chunk_size = 56,
 };
 
+struct drxk_config maxmedia_ub425_tc_drxk = {
+	.adr = 0x29,
+	.single_master = 1,
+	.no_i2c_bridge = 1,
+};
+
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct em28xx_dvb *dvb = fe->sec_priv;
@@ -936,6 +942,29 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap,
 				&em28xx_a8293_config);
 		break;
+	case EM2874_BOARD_MAXMEDIA_UB425_TC:
+		/* attach demodulator */
+		dvb->fe[0] = dvb_attach(drxk_attach, &maxmedia_ub425_tc_drxk,
+				&dev->i2c_adap);
+
+		if (dvb->fe[0]) {
+			/* disable I2C-gate */
+			dvb->fe[0]->ops.i2c_gate_ctrl = NULL;
+
+			/* attach tuner */
+			if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
+					&dev->i2c_adap, 0x60)) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -EINVAL;
+				goto out_free;
+			}
+		}
+
+		/* TODO: we need drx-3913k firmware in order to support DVB-T */
+		em28xx_info("MaxMedia UB425-TC: only DVB-C supported by that " \
+				"driver version\n");
+
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2ae6815..59cdfa6 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -125,6 +125,7 @@
 #define EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C	  81
 #define EM2884_BOARD_CINERGY_HTC_STICK		  82
 #define EM2860_BOARD_HT_VIDBOX_NW03 		  83
+#define EM2874_BOARD_MAXMEDIA_UB425_TC            84
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.7.6

