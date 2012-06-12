Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53892 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2FLWTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:39 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so40001wey.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 15:19:38 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: sven.pilz@gmail.com, soeren.moch@ims.uni-hannover.de,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/3] [media] em28xx: Improve support for the Terratec Cinergy HTC Stick HD.
Date: Wed, 13 Jun 2012 00:19:28 +0200
Message-Id: <1339539568-7725-4-git-send-email-martin.blumenstingl@googlemail.com>
In-Reply-To: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
References: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The windows driver used different values for the GPIOs and analog
decoder configuration. The values from the windows driver are now
used.
It also seems that the windows driver has LNA always disabled.
Thus we are doing the same (using the same flags as on windows).

I (only) tested with DVB-T and it worked quite well.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    7 +--
 drivers/media/video/em28xx/em28xx-dvb.c   |   83 ++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 92da7c2..12bc54a 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -975,12 +975,7 @@ struct em28xx_board em28xx_boards[] = {
 		.name         = "Terratec Cinergy HTC Stick",
 		.has_dvb      = 1,
 		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
-#if 0
-		.tuner_type   = TUNER_PHILIPS_TDA8290,
-		.tuner_addr   = 0x41,
-		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
-		.tuner_gpio   = terratec_h5_gpio,
-#endif
+		.tuner_type   = TUNER_ABSENT,
 		.i2c_speed    = EM2874_I2C_SECONDARY_BUS_SELECT |
 				EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 16410ac..2b81427 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -317,6 +317,18 @@ struct drxk_config terratec_h5_drxk = {
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
+struct drxk_config terratec_htc_stick_drxk = {
+	.adr = 0x29,
+	.single_master = 1,
+	.no_i2c_bridge = 1,
+	.microcode_name = "dvb-usb-terratec-htc-stick-drxk.fw",
+	.chunk_size = 54,
+	/* Required for the antenna_gpio to disable LNA. */
+	.antenna_dvbt = true,
+	/* The windows driver uses the same. This will disable LNA. */
+	.antenna_gpio = 0x6,
+};
+
 struct drxk_config hauppauge_930c_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
@@ -473,6 +485,57 @@ static void terratec_h5_init(struct em28xx *dev)
 	em28xx_gpio_set(dev, terratec_h5_end);
 };
 
+static void terratec_htc_stick_init(struct em28xx *dev)
+{
+	int i;
+
+	/*
+	 * GPIO configuration:
+	 * 0xff: unknown (does not affect DVB-T).
+	 * 0xf6: DRX-K (demodulator).
+	 * 0xe6: unknown (does not affect DVB-T).
+	 * 0xb6: unknown (does not affect DVB-T).
+	 */
+	struct em28xx_reg_seq terratec_htc_stick_init[] = {
+		{EM28XX_R08_GPIO,	0xff,	0xff,	10},
+		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{EM2874_R80_GPIO,	0xe6,	0xff,	50},
+		{EM2874_R80_GPIO,	0xf6,	0xff,	100},
+		{ -1,                   -1,     -1,     -1},
+	};
+	struct em28xx_reg_seq terratec_htc_stick_end[] = {
+		{EM2874_R80_GPIO,	0xb6,	0xff,	100},
+		{EM2874_R80_GPIO,	0xf6,	0xff,	50},
+		{ -1,                   -1,     -1,     -1},
+	};
+
+	/* Init the analog decoder? */
+	struct {
+		unsigned char r[4];
+		int len;
+	} regs[] = {
+		{{ 0x06, 0x02, 0x00, 0x31 }, 4},
+		{{ 0x01, 0x02 }, 2},
+		{{ 0x01, 0x02, 0x00, 0xc6 }, 4},
+		{{ 0x01, 0x00 }, 2},
+		{{ 0x01, 0x00, 0xff, 0xaf }, 4},
+	};
+
+	em28xx_gpio_set(dev, terratec_htc_stick_init);
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
+	em28xx_gpio_set(dev, terratec_htc_stick_end);
+};
+
 static void pctv_520e_init(struct em28xx *dev)
 {
 	/*
@@ -944,7 +1007,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	}
 	case EM2884_BOARD_TERRATEC_H5:
-	case EM2884_BOARD_CINERGY_HTC_STICK:
 		terratec_h5_init(dev);
 
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap);
@@ -1021,6 +1083,25 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			}
 		}
 		break;
+	case EM2884_BOARD_CINERGY_HTC_STICK:
+		terratec_htc_stick_init(dev);
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
-- 
1.7.10.4

