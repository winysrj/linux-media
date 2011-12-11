Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44467 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab1LKWPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 17:15:04 -0500
Received: by eekc4 with SMTP id c4so1299506eek.19
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2011 14:15:03 -0800 (PST)
Message-ID: <4EE52B64.2080803@gmail.com>
Date: Mon, 12 Dec 2011 00:15:00 +0200
From: =?ISO-8859-1?Q?Aivar_P=E4kk?= <aivar11@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] KWorld 355U and 380U support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds Kworld 355U and 380U support

Signed-off-by: Aivar Päkk <aivar11@gmail.com>

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9b747c2..c9dabdf 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -839,6 +839,10 @@ struct em28xx_board em28xx_boards[] = {
 	[EM2870_BOARD_KWORLD_355U] = {
 		.name         = "Kworld 355 U DVB-T",
 		.valid        = EM28XX_BOARD_NOT_VALIDATED,
+		.tuner_type   = TUNER_ABSENT,
+		.tuner_gpio   = default_tuner_gpio,
+		.has_dvb      = 1,
+		.dvb_gpio     = default_digital,
 	},
 	[EM2870_BOARD_PINNACLE_PCTV_DVB] = {
 		.name         = "Pinnacle PCTV DVB-T",
@@ -1899,6 +1903,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2800_BOARD_GRABBEEX_USB2800 },
 	{ USB_DEVICE(0xeb1a, 0xe357),
 			.driver_info = EM2870_BOARD_KWORLD_355U },
+	{ USB_DEVICE(0xeb1a, 0xe359),
+			.driver_info = EM2870_BOARD_KWORLD_355U },
 	{ USB_DEVICE(0x1b80, 0xe302),
 			.driver_info = EM2820_BOARD_PINNACLE_DVC_90 }, /* Kaiser Baas Video to DVD maker */
 	{ USB_DEVICE(0x1b80, 0xe304),
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index cef7a2d..70d35a8 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -44,6 +44,7 @@
 #include "drxk.h"
 #include "tda10071.h"
 #include "a8293.h"
+#include "qt1010.h"
 
 MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
@@ -456,6 +457,17 @@ static const struct a8293_config em28xx_a8293_config = {
 	.i2c_addr = 0x08, /* (0x10 >> 1) */
 };
 
+static struct zl10353_config em28xx_zl10353_no_i2c_gate_dev = {
+	.demod_address = (0x1e >> 1),
+	.disable_i2c_gate_ctrl = 1,
+	.no_tuner = 1,
+	.parallel_ts = 1,
+};
+static struct qt1010_config em28xx_qt1010_config = {
+	.i2c_address = 0x62
+
+};
+
 /* ------------------------------------------------------------------ */
 
 static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
@@ -708,6 +720,14 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2870_BOARD_KWORLD_355U:
+		dvb->fe[0] = dvb_attach(zl10353_attach,
+					   &em28xx_zl10353_no_i2c_gate_dev,
+					   &dev->i2c_adap);
+		if (dvb->fe[0] != NULL)
+		dvb_attach(qt1010_attach, dvb->fe[0],
+				   &dev->i2c_adap, &em28xx_qt1010_config);
+		break;
 	case EM2883_BOARD_KWORLD_HYBRID_330U:
 	case EM2882_BOARD_EVGA_INDTUBE:
 		dvb->fe[0] = dvb_attach(s5h1409_attach,
