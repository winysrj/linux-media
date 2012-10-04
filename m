Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61323 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2JDSXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 14:23:01 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so493884bkc.19
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2012 11:22:59 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/2] em28xx: Better support for the Terratec Cinergy HTC USB XS. This intializes the card just like the windows driver does.
Date: Thu,  4 Oct 2012 20:22:54 +0200
Message-Id: <1349374975-5934-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 13 ++++-
 drivers/media/usb/em28xx/em28xx-dvb.c   | 84 ++++++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ab98d08..9418c5e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -1979,6 +1979,15 @@ struct em28xx_board em28xx_boards[] = {
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
 	},
+	[EM2884_BOARD_TERRATEC_HTC_USB_XS] = {
+		.name         = "Terratec Cinergy HTC USB XS",
+		.has_dvb      = 1,
+		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
+		.tuner_type   = TUNER_ABSENT,
+		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
+				EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_400_KHZ,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2057,9 +2066,9 @@ struct usb_device_id em28xx_id_table[] = {
 	{ USB_DEVICE(0x0ccd, 0x0043),
 			.driver_info = EM2870_BOARD_TERRATEC_XS },
 	{ USB_DEVICE(0x0ccd, 0x008e),	/* Cinergy HTC USB XS Rev. 1 */
-			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+			.driver_info = EM2884_BOARD_TERRATEC_HTC_USB_XS },
 	{ USB_DEVICE(0x0ccd, 0x00ac),	/* Cinergy HTC USB XS Rev. 2 */
-			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+			.driver_info = EM2884_BOARD_TERRATEC_HTC_USB_XS },
 	{ USB_DEVICE(0x0ccd, 0x10a2),	/* H5 Rev. 1 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x10ad),	/* H5 Rev. 2 */
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 913e522..14f8f17 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -331,7 +331,7 @@ static struct drxk_config hauppauge_930c_drxk = {
 	.load_firmware_sync = true,
 };
 
-struct drxk_config terratec_htc_stick_drxk = {
+static struct drxk_config terratec_htc_stick_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
@@ -520,7 +520,10 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 		{ -1,                   -1,     -1,     -1},
 	};
 
-	/* Init the analog decoder? */
+	/*
+	 * Init the analog decoder (not yet supported), but
+	 * it's probably still a good idea.
+	 */
 	struct {
 		unsigned char r[4];
 		int len;
@@ -547,6 +550,64 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 	em28xx_gpio_set(dev, terratec_htc_stick_end);
 };
 
+static void terratec_htc_usb_xs_init(struct em28xx *dev)
+{
+	int i;
+
+	struct em28xx_reg_seq terratec_htc_usb_xs_init[] = {
+		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2874_R80_GPIO,	0xb2,	0xff,	100},
+		{EM2874_R80_GPIO,	0xb2,	0xff,	50},
+		{EM2874_R80_GPIO,	0xb6,	0xff,	100},
+		{ -1,                   -1,     -1,     -1},
+	};
+	struct em28xx_reg_seq terratec_htc_usb_xs_end[] = {
+		{EM2874_R80_GPIO,	0xa6,	0xff,	100},
+		{EM2874_R80_GPIO,	0xa6,	0xff,	50},
+		{EM2874_R80_GPIO,	0xe6,	0xff,	100},
+		{ -1,                   -1,     -1,     -1},
+	};
+
+	/*
+	 * Init the analog decoder (not yet supported), but
+	 * it's probably still a good idea.
+	 */
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
+		{{ 0x04, 0x00 }, 2},
+		{{ 0x00, 0x04 }, 2},
+		{{ 0x00, 0x04, 0x00, 0x0a }, 4},
+		{{ 0x04, 0x14 }, 2},
+		{{ 0x04, 0x14, 0x00, 0x00 }, 4},
+	};
+
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
+
+	em28xx_gpio_set(dev, terratec_htc_usb_xs_init);
+
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
+	msleep(10);
+	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
+	msleep(10);
+
+	dev->i2c_client.addr = 0x82 >> 1;
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+
+	em28xx_gpio_set(dev, terratec_htc_usb_xs_end);
+};
+
 static void pctv_520e_init(struct em28xx *dev)
 {
 	/*
@@ -1154,6 +1215,25 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2884_BOARD_TERRATEC_HTC_USB_XS:
+		terratec_htc_usb_xs_init(dev);
+
+		/* attach demodulator */
+		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_htc_stick_drxk,
+					&dev->i2c_adap);
+		if (!dvb->fe[0]) {
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		/* Attach the demodulator. */
+		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+				&dev->i2c_adap,
+				&em28xx_cxd2820r_tda18271_config)) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8757523..86e90d8 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -128,6 +128,7 @@
 #define EM2874_BOARD_MAXMEDIA_UB425_TC            84
 #define EM2884_BOARD_PCTV_510E                    85
 #define EM2884_BOARD_PCTV_520E                    86
+#define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.12.2

