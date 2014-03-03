Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaCCTh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 14:37:57 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] em28xx: add support for Kworld UB435-Q version 3
Date: Mon,  3 Mar 2014 16:37:18 -0300
Message-Id: <1393875438-1916-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393875438-1916-1-git-send-email-m.chehab@samsung.com>
References: <1393875438-1916-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device is close to Kworld UB435-Q, but it uses a different
tuner. Add support for it.

Tested only in 8VSB mode.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 Documentation/video4linux/CARDLIST.em28xx |  1 +
 drivers/media/usb/em28xx/Kconfig          |  1 +
 drivers/media/usb/em28xx/em28xx-cards.c   | 23 ++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c     | 36 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h         |  1 +
 5 files changed, 62 insertions(+)

diff --git a/Documentation/video4linux/CARDLIST.em28xx b/Documentation/video4linux/CARDLIST.em28xx
index cb8706be3dbe..e085b1243b45 100644
--- a/Documentation/video4linux/CARDLIST.em28xx
+++ b/Documentation/video4linux/CARDLIST.em28xx
@@ -91,3 +91,4 @@
  90 -> KWorld USB ATSC TV Stick UB435-Q V2      (em2874)        [1b80:e346]
  91 -> SpeedLink Vicious And Devine Laplace webcam (em2765)        [1ae7:9003,1ae7:9004]
  92 -> PCTV DVB-S2 Stick (461e)                 (em28178)
+ 93 -> KWorld USB ATSC TV Stick UB435-Q V3      (em2874)        [1b80:e34c]
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 7fb02875a1e6..d23a912096f7 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -53,6 +53,7 @@ config VIDEO_EM28XX_DVB
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 138659b23cbb..5cd2df14bf1a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -189,6 +189,14 @@ static struct em28xx_reg_seq kworld_a340_digital[] = {
 	{	-1,		-1,	-1,		-1},
 };
 
+static struct em28xx_reg_seq kworld_ub435q_v3_digital[] = {
+	{EM2874_R80_GPIO_P0_CTRL,	0xff, 	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfe, 	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xbe,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfe,	0xff,	100},
+	{	-1,			-1,	-1,	-1},
+};
+
 /* Pinnacle Hybrid Pro eb1a:2881 */
 static struct em28xx_reg_seq pinnacle_hybrid_pro_analog[] = {
 	{EM2820_R08_GPIO_CTRL,	0xfd,   ~EM_GPIO_4,	10},
@@ -2139,6 +2147,19 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_gpio	= default_tuner_gpio,
 		.def_i2c_bus	= 1,
 	},
+	/*
+	 * 1b80:e34c KWorld USB ATSC TV Stick UB435-Q V3
+	 * Empia EM2874B + LG DT3305 + NXP TDA18271HDC2
+	 */
+	[EM2874_BOARD_KWORLD_UB435Q_V3] = {
+		.name		= "KWorld USB ATSC TV Stick UB435-Q V3",
+		.tuner_type	= TUNER_ABSENT,
+		.has_dvb	= 1,
+		.tuner_gpio	= kworld_ub435q_v3_digital,
+		.def_i2c_bus	= 1,
+		.i2c_speed      = EM28XX_I2C_CLK_WAIT_ENABLE |
+				  EM28XX_I2C_FREQ_100_KHZ,
+	},
 	[EM2874_BOARD_PCTV_HD_MINI_80E] = {
 		.name         = "Pinnacle PCTV HD Mini",
 		.tuner_type   = TUNER_ABSENT,
@@ -2325,6 +2346,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2870_BOARD_KWORLD_A340 },
 	{ USB_DEVICE(0x1b80, 0xe346),
 			.driver_info = EM2874_BOARD_KWORLD_UB435Q_V2 },
+	{ USB_DEVICE(0x1b80, 0xe34c),
+			.driver_info = EM2874_BOARD_KWORLD_UB435Q_V3 },
 	{ USB_DEVICE(0x2013, 0x024f),
 			.driver_info = EM28174_BOARD_PCTV_290E },
 	{ USB_DEVICE(0x2013, 0x024c),
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a63a3a2fbd55..9bf1ca50b260 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -49,6 +49,7 @@
 #include "tda18271c2dd.h"
 #include "drxk.h"
 #include "tda10071.h"
+#include "tda18212.h"
 #include "a8293.h"
 #include "qt1010.h"
 #include "mb86a20s.h"
@@ -320,6 +321,18 @@ static struct lgdt3305_config em2874_lgdt3305_dev = {
 	.qam_if_khz         = 4000,
 };
 
+static struct lgdt3305_config em2874_lgdt3305_nogate_dev = {
+	.i2c_addr           = 0x0e,
+	.demod_chip         = LGDT3305,
+	.spectral_inversion = 1,
+	.deny_i2c_rptr      = 1,
+	.mpeg_mode          = LGDT3305_MPEG_SERIAL,
+	.tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
+	.tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
+	.vsb_if_khz         = 3250,
+	.qam_if_khz         = 4000,
+};
+
 static struct s921_config sharp_isdbt = {
 	.demod_address = 0x30 >> 1
 };
@@ -356,6 +369,12 @@ static struct tda18271_config kworld_ub435q_v2_config = {
 	.gate		= TDA18271_GATE_DIGITAL,
 };
 
+static struct tda18212_config kworld_ub435q_v3_config = {
+	.i2c_address	= 0x60,
+	.if_atsc_vsb	= 3250,
+	.if_atsc_qam	= 4000,
+};
+
 static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner = 1,
@@ -1389,6 +1408,23 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM2874_BOARD_KWORLD_UB435Q_V3:
+		dvb->fe[0] = dvb_attach(lgdt3305_attach,
+					&em2874_lgdt3305_nogate_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (!dvb->fe[0]) {
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		/* Attach the demodulator. */
+		if (!dvb_attach(tda18212_attach, dvb->fe[0],
+				&dev->i2c_adap[dev->def_i2c_bus],
+				&kworld_ub435q_v3_config)) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		break;
 	case EM2874_BOARD_PCTV_HD_MINI_80E:
 		dvb->fe[0] = dvb_attach(drx39xxj_attach, &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL) {
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 90e7cec389fb..3b08556376e3 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -138,6 +138,7 @@
 #define EM2874_BOARD_KWORLD_UB435Q_V2		  90
 #define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  91
 #define EM28178_BOARD_PCTV_461E                   92
+#define EM2874_BOARD_KWORLD_UB435Q_V3		  93
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.8.5.3

