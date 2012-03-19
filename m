Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35798 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab2CSPsg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 11:48:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] em28xx: support for 2013:0251 PCTV QuatroStick nano (520e)
Date: Mon, 19 Mar 2012 17:48:19 +0200
Message-Id: <1332172099-7210-2-git-send-email-crope@iki.fi>
In-Reply-To: <1332172099-7210-1-git-send-email-crope@iki.fi>
References: <1332172099-7210-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware is based of:
Empia EM2884
Micronas DRX 3926K
NXP TDA18271HDC2

... + analog parts.
Analog is not supported currently. Only DVB-T and DVB-C.

There seems to be still	problems for locking DVB-C channels which have
strong signal. Attenuator helps. I think it is demodulator IF/RF AGC
issue. Lets fix it later. Patches are welcome.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/video/em28xx/em28xx-cards.c |   28 +++++++++++++++
 drivers/media/video/em28xx/em28xx-dvb.c   |   52 +++++++++++++++++++++++++++++
 drivers/media/video/em28xx/em28xx.h       |    1 +
 3 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index d5c9613..a65d479 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -364,6 +364,20 @@ static struct em28xx_reg_seq maxmedia_ub425_tc[] = {
 	{-1,                 -1,    -1,   -1},
 };
 
+/* 2013:0251 PCTV QuatroStick nano (520e)
+ * GPIO_2: decoder reset, 0=active
+ * GPIO_4: decoder suspend, 0=active
+ * GPIO_6: demod reset, 0=active
+ * GPIO_7: LED, 1=active
+ */
+static struct em28xx_reg_seq pctv_520e[] = {
+	{EM2874_R80_GPIO, 0x10, 0xff, 100},
+	{EM2874_R80_GPIO, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
+	{EM2874_R80_GPIO, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
+	{EM2874_R80_GPIO, 0xd4, 0xff, 000}, /* GPIO_7 = 1 */
+	{             -1,   -1,   -1,  -1},
+};
+
 /*
  *  Board definitions
  */
@@ -1930,6 +1944,18 @@ struct em28xx_board em28xx_boards[] = {
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	/* 2013:0251 PCTV QuatroStick nano (520e)
+	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
+	[EM2884_BOARD_PCTV_520E] = {
+		.name          = "PCTV QuatroStick nano (520e)",
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = pctv_520e,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
+		.i2c_speed     = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2083,6 +2109,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2860_BOARD_EASYCAP },
 	{ USB_DEVICE(0x1b80, 0xe425),
 			.driver_info = EM2874_BOARD_MAXMEDIA_UB425_TC },
+	{ USB_DEVICE(0x2013, 0x0251),
+			.driver_info = EM2884_BOARD_PCTV_520E },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 0b3e301..398d713 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -331,6 +331,13 @@ struct drxk_config maxmedia_ub425_tc_drxk = {
 	.no_i2c_bridge = 1,
 };
 
+struct drxk_config pctv_520e_drxk = {
+	.adr = 0x29,
+	.single_master = 1,
+	.microcode_name = "dvb-demod-drxk-pctv.fw",
+	.chunk_size = 58,
+};
+
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct em28xx_dvb *dvb = fe->sec_priv;
@@ -464,6 +471,33 @@ static void terratec_h5_init(struct em28xx *dev)
 	em28xx_gpio_set(dev, terratec_h5_end);
 };
 
+static void pctv_520e_init(struct em28xx *dev)
+{
+	/*
+	 * Init TDA8295(?) analog demodulator. Looks like I2C traffic to
+	 * digital demodulator and tuner are routed via TDA8295.
+	 */
+	int i;
+	struct {
+		unsigned char r[4];
+		int len;
+	} regs[] = {
+		{{ 0x06, 0x02, 0x00, 0x31 }, 4},
+		{{ 0x01, 0x02 }, 2},
+		{{ 0x01, 0x02, 0x00, 0xc6 }, 4},
+		{{ 0x01, 0x00 }, 2},
+		{{ 0x01, 0x00, 0xff, 0xaf }, 4},
+		{{ 0x01, 0x00, 0x03, 0xa0 }, 4},
+		{{ 0x01, 0x00 }, 2},
+		{{ 0x01, 0x00, 0x73, 0xaf }, 4},
+	};
+
+	dev->i2c_client.addr = 0x82 >> 1; /* 0x41 */
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+};
+
 static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 {
 	/* Values extracted from a USB trace of the Terratec Windows driver */
@@ -965,6 +999,24 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				"driver version\n");
 
 		break;
+	case EM2884_BOARD_PCTV_520E:
+		pctv_520e_init(dev);
+
+		/* attach demodulator */
+		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
+				&dev->i2c_adap);
+
+		if (dvb->fe[0]) {
+			/* attach tuner */
+			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+					&dev->i2c_adap,
+					&em28xx_cxd2820r_tda18271_config)) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -EINVAL;
+				goto out_free;
+			}
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 59cdfa6..4b60327 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -126,6 +126,7 @@
 #define EM2884_BOARD_CINERGY_HTC_STICK		  82
 #define EM2860_BOARD_HT_VIDBOX_NW03 		  83
 #define EM2874_BOARD_MAXMEDIA_UB425_TC            84
+#define EM2884_BOARD_PCTV_520E                    85
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.7.6

