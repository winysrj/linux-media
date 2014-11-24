Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39056 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaKXHAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 02:00:42 -0500
Received: by mail-la0-f45.google.com with SMTP id gq15so7153136lab.18
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 23:00:40 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv2 2/4] em28xx: Add support for Terratec Cinergy T2 Stick HD
Date: Mon, 24 Nov 2014 08:57:34 +0200
Message-Id: <1416812256-27894-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
References: <1416812256-27894-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terratec Cinergy T2 Stick HD [eb1a:8179] is a USB DVB-T/T2/C tuner that 
contains following components:

* Empia EM28178 USB bridge
* Silicon Labs Si2168-A30 demodulator
* Silicon Labs Si2146-A10 tuner

I don't have the remote, so the RC_MAP is a best guess based on the pictures of 
the remote controllers and other supported Terratec devices with a similar 
remote.

Patch v2 initializes struct si2168_config with zeroes.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 27 +++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 59 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 87 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 71fa51e..382018d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -479,6 +479,20 @@ static struct em28xx_reg_seq pctv_292e[] = {
 	{-1,                             -1,   -1,     -1},
 };
 
+static struct em28xx_reg_seq terratec_t2_stick_hd[] = {
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xff,	0},
+	{0x0d,				0xff,	0xff,	600},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xbc,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0x00,	0xff,	300},
+	{EM2874_R80_GPIO_P0_CTRL,	0xf8,	0xff,	100},
+	{EM2874_R80_GPIO_P0_CTRL,	0xfc,	0xff,	300},
+	{0x0d,				0x42,	0xff,	1000},
+	{EM2874_R5F_TS_ENABLE,		0x85,	0xff,	0},
+	{-1,                             -1,   -1,     -1},
+};
+
 /*
  *  Button definitions
  */
@@ -2243,6 +2257,17 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
+	/* eb1a:8179 Terratec Cinergy T2 Stick HD.
+	 * Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2146 */
+	[EM28178_BOARD_TERRATEC_T2_STICK_HD] = {
+		.name          = "Terratec Cinergy T2 Stick HD",
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE | EM28XX_I2C_FREQ_400_KHZ,
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = terratec_t2_stick_hd,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_TERRATEC_SLIM_2,
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2424,6 +2449,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28178_BOARD_PCTV_461E },
 	{ USB_DEVICE(0x2013, 0x025f),
 			.driver_info = EM28178_BOARD_PCTV_292E },
+	{ USB_DEVICE(0xeb1a, 0x8179),
+			.driver_info = EM28178_BOARD_TERRATEC_T2_STICK_HD },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 65a456d..bd12f4c 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1603,6 +1603,65 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			dvb->fe[0]->ops.set_lna = em28xx_pctv_292e_set_lna;
 		}
 		break;
+	case EM28178_BOARD_TERRATEC_T2_STICK_HD:
+		{
+			struct i2c_adapter *adapter;
+			struct i2c_client *client;
+			struct i2c_board_info info;
+			struct si2168_config si2168_config;
+			struct si2157_config si2157_config;
+
+			/* attach demod */
+			memset(&si2168_config, 0, sizeof(si2168_config));
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &dvb->fe[0];
+			si2168_config.ts_mode = SI2168_TS_PARALLEL;
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
+			memset(&si2157_config, 0, sizeof(si2157_config));
+			si2157_config.fe = dvb->fe[0];
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2146", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module("si2157");
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
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a21a746..16dd880 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -141,6 +141,7 @@
 #define EM28178_BOARD_PCTV_461E                   92
 #define EM2874_BOARD_KWORLD_UB435Q_V3		  93
 #define EM28178_BOARD_PCTV_292E                   94
+#define EM28178_BOARD_TERRATEC_T2_STICK_HD        95
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.9.1

