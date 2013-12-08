Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33483 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759991Ab3LHWby (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 05/18] em28xx: add support for PCTV DVB-S2 Stick (461e) [2013:0258]
Date: Mon,  9 Dec 2013 00:31:22 +0200
Message-Id: <1386541895-8634-6-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Device has following chips: Empia EM28178, Montage M88DS3103,
Montage M88TS2022, Allegro A8293.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/Kconfig        |  2 ++
 drivers/media/usb/em28xx/em28xx-cards.c | 35 ++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 53 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 4 files changed, 91 insertions(+)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index ca5ee6a..d6ba514 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -49,6 +49,8 @@ config VIDEO_EM28XX_DVB
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 62332a6..4db5eab 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -356,6 +356,28 @@ static struct em28xx_reg_seq c3tech_digital_duo_digital[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
+/*
+ * 2013:0258 PCTV DVB-S2 Stick (461e)
+ * GPIO 0 = POWER_ON
+ * GPIO 1 = BOOST
+ * GPIO 2 = VUV_LNB (red LED)
+ * GPIO 3 = #EXT_12V
+ * GPIO 4 = INT_DEM
+ * GPIO 5 = INT_LNB
+ * GPIO 6 = #RESET_DEM
+ * GPIO 7 = P07_LED (green LED)
+ */
+static struct em28xx_reg_seq pctv_461e[] = {
+	{EM2874_R80_GPIO_P0_CTRL,      0x7f, 0xff,    0},
+	{0x0d,                 0xff, 0xff,    0},
+	{EM2874_R80_GPIO_P0_CTRL,      0x3f, 0xff,  100}, /* reset demod */
+	{EM2874_R80_GPIO_P0_CTRL,      0x7f, 0xff,  200}, /* reset demod */
+	{0x0d,                 0x42, 0xff,    0},
+	{EM2874_R80_GPIO_P0_CTRL,      0xeb, 0xff,    0},
+	{EM2874_R5F_TS_ENABLE, 0x84, 0x84,    0}, /* parallel? | null discard */
+	{                  -1,   -1,   -1,   -1},
+};
+
 #if 0
 static struct em28xx_reg_seq hauppauge_930c_gpio[] = {
 	{EM2874_R80_GPIO_P0_CTRL,	0x6f,	0xff,	10},
@@ -2043,6 +2065,17 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_gpio	= default_tuner_gpio,
 		.def_i2c_bus	= 1,
 	},
+	/* 2013:0258 PCTV DVB-S2 Stick (461e)
+	 * Empia EM28178, Montage M88DS3103, Montage M88TS2022, Allegro A8293 */
+	[EM28178_BOARD_PCTV_461E] = {
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.name          = "PCTV DVB-S2 Stick (461e)",
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = pctv_461e,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2208,6 +2241,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_520E },
 	{ USB_DEVICE(0x1b80, 0xe1cc),
 			.driver_info = EM2874_BOARD_DELOCK_61959 },
+	{ USB_DEVICE(0x2013, 0x0258),
+			.driver_info = EM28178_BOARD_PCTV_461E },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 344042b..4f8f687 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -51,6 +51,8 @@
 #include "a8293.h"
 #include "qt1010.h"
 #include "mb86a20s.h"
+#include "m88ds3103.h"
+#include "m88ts2022.h"
 
 MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
@@ -808,6 +810,19 @@ static struct tda18271_config c3tech_duo_tda18271_config = {
 	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
+static const struct m88ds3103_config pctv_461e_m88ds3103_config = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.clock_out = 0,
+	.ts_mode = M88DS3103_TS_PARALLEL_16,
+	.agc = 0x99,
+};
+
+static const struct m88ts2022_config em28xx_m88ts2022_config = {
+	.i2c_addr = 0x60,
+	.clock = 27000000,
+};
 
 /* ------------------------------------------------------------------ */
 
@@ -1330,6 +1345,44 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			goto out_free;
 		}
 		break;
+	case EM28178_BOARD_PCTV_461E:
+		{
+			/* demod I2C adapter */
+			struct i2c_adapter *i2c_adapter;
+
+			/* attach demod */
+			dvb->fe[0] = dvb_attach(m88ds3103_attach,
+					&pctv_461e_m88ds3103_config,
+					&dev->i2c_adap[dev->def_i2c_bus],
+					&i2c_adapter);
+			if (dvb->fe[0] == NULL) {
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			/* attach tuner */
+			if (!dvb_attach(m88ts2022_attach, dvb->fe[0],
+					i2c_adapter,
+					&em28xx_m88ts2022_config)) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			/* delegate signal strength measurement to tuner */
+			dvb->fe[0]->ops.read_signal_strength =
+					dvb->fe[0]->ops.tuner_ops.get_rf_strength;
+
+			/* attach SEC */
+			if (!dvb_attach(a8293_attach, dvb->fe[0],
+					&dev->i2c_adap[dev->def_i2c_bus],
+					&em28xx_a8293_config)) {
+				dvb_frontend_detach(dvb->fe[0]);
+				result = -ENODEV;
+				goto out_free;
+			}
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index f8726ad..ea058be 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -132,6 +132,7 @@
 #define EM2884_BOARD_C3TECH_DIGITAL_DUO		  88
 #define EM2874_BOARD_DELOCK_61959		  89
 #define EM2874_BOARD_KWORLD_UB435Q_V2		  90
+#define EM28178_BOARD_PCTV_461E                   91
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.8.4.2

