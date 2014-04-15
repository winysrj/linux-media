Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34331 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaDOJcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 05:32:07 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/10] em28xx: add [2013:025f] PCTV tripleStick (292e)
Date: Tue, 15 Apr 2014 12:31:39 +0300
Message-Id: <1397554306-14561-4-git-send-email-crope@iki.fi>
In-Reply-To: <1397554306-14561-1-git-send-email-crope@iki.fi>
References: <1397554306-14561-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/Kconfig        |  2 +
 drivers/media/usb/em28xx/em28xx-cards.c | 25 +++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 73 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 4 files changed, 101 insertions(+)

diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index d23a912..f5d7198 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -57,6 +57,8 @@ config VIDEO_EM28XX_DVB
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 50aa5a5..437f73f 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -467,6 +467,18 @@ static struct em28xx_reg_seq speedlink_vad_laplace_reg_seq[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
+static struct em28xx_reg_seq pctv_292e[] = {
+	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,      0},
+	{0x0d,                         0xff, 0xff,    950},
+	{EM2874_R80_GPIO_P0_CTRL,      0xbd, 0xff,    100},
+	{EM2874_R80_GPIO_P0_CTRL,      0xfd, 0xff,    410},
+	{EM2874_R80_GPIO_P0_CTRL,      0x7d, 0xff,    300},
+	{EM2874_R80_GPIO_P0_CTRL,      0x7c, 0xff,     60},
+	{0x0d,                         0x42, 0xff,     50},
+	{EM2874_R5F_TS_ENABLE,         0x85, 0xff,      0},
+	{-1,                             -1,   -1,     -1},
+};
+
 /*
  *  Button definitions
  */
@@ -2220,6 +2232,17 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
+	/* 2013:025f PCTV tripleStick (292e).
+	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157 */
+	[EM28178_BOARD_PCTV_292E] = {
+		.name          = "PCTV tripleStick (292e)",
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = pctv_292e,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2397,6 +2420,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2765_BOARD_SPEEDLINK_VAD_LAPLACE },
 	{ USB_DEVICE(0x2013, 0x0258),
 			.driver_info = EM28178_BOARD_PCTV_461E },
+	{ USB_DEVICE(0x2013, 0x025f),
+			.driver_info = EM28178_BOARD_PCTV_292E },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index f599b18..b79e08b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -55,6 +55,8 @@
 #include "mb86a20s.h"
 #include "m88ds3103.h"
 #include "m88ts2022.h"
+#include "si2168.h"
+#include "si2157.h"
 
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
@@ -93,6 +95,7 @@ struct em28xx_dvb {
 	struct semaphore      pll_mutex;
 	bool			dont_attach_fe1;
 	int			lna_gpio;
+	struct i2c_client	*i2c_client_demod;
 	struct i2c_client	*i2c_client_tuner;
 };
 
@@ -1496,6 +1499,62 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->i2c_client_tuner = client;
 		}
 		break;
+	case EM28178_BOARD_PCTV_292E:
+		{
+			struct i2c_adapter *adapter;
+			struct i2c_client *client;
+			struct i2c_board_info info;
+			struct si2168_config si2168_config;
+			struct si2157_config si2157_config;
+
+			/* attach demod */
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &dvb->fe[0];
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2168_config;
+			request_module(info.type);
+			client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus], &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			dvb->i2c_client_demod = client;
+
+			/* attach tuner */
+			si2157_config.fe = dvb->fe[0];
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module(info.type);
+			client = i2c_new_device(adapter, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				module_put(dvb->i2c_client_demod->dev.driver->owner);
+				i2c_unregister_device(dvb->i2c_client_demod);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				module_put(dvb->i2c_client_demod->dev.driver->owner);
+				i2c_unregister_device(dvb->i2c_client_demod);
+				result = -ENODEV;
+				goto out_free;
+			}
+
+			dvb->i2c_client_tuner = client;
+		}
+		break;
 	default:
 		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
 				" isn't supported yet\n");
@@ -1582,6 +1641,13 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 		i2c_unregister_device(client);
 	}
 
+	/* remove I2C demod */
+	client = dvb->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	em28xx_unregister_dvb(dvb);
 	kfree(dvb);
 	dev->dvb = NULL;
@@ -1647,6 +1713,13 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 			i2c_unregister_device(client);
 		}
 
+		/* remove I2C demod */
+		client = dvb->i2c_client_demod;
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
+
 		em28xx_unregister_dvb(dvb);
 		kfree(dvb);
 		dev->dvb = NULL;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2051fc9..2313433 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -140,6 +140,7 @@
 #define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  91
 #define EM28178_BOARD_PCTV_461E                   92
 #define EM2874_BOARD_KWORLD_UB435Q_V3		  93
+#define EM28178_BOARD_PCTV_292E                   94
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.9.0

