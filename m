Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34209 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936941AbdAJDOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 22:14:32 -0500
Received: by mail-qk0-f193.google.com with SMTP id e1so18871908qkh.1
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 19:14:32 -0800 (PST)
Date: Mon, 9 Jan 2017 22:14:29 -0500
From: Kevin Cheng <kcheng@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v3 2/2] [media] em28xx: support for Hauppauge WinTV-dualHD
 01595 ATSC/QAM
Message-ID: <20170110031428.vcx2wex3ooxfdjoh@whisper>
References: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <693918b2-bfbe-9827-a11a-e1f73f4ac019@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge WinTV-dualHD model 01595 is a USB 2.0 dual ATSC/QAM tuner with
the following components:

USB bridge: Empia em28274
Demodulator: 2x LG LGDT3306a at addresses 0xb2 and 0x1c
Tuner: 2x Silicon Labs si2157 at addresses 0xc0 and 0xc4

This patch enables only the first tuner.

Signed-off-by: Kevin Cheng <kcheng@gmail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 19 +++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   | 74 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 3 files changed, 94 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 23c6749..5f90d08 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -509,6 +509,7 @@ static struct em28xx_reg_seq plex_px_bcud[] = {
 
 /*
  * 2040:0265 Hauppauge WinTV-dualHD DVB
+ * 2040:026d Hauppauge WinTV-dualHD ATSC/QAM
  * reg 0x80/0x84:
  * GPIO_0: Yellow LED tuner 1, 0=on, 1=off
  * GPIO_1: Green LED tuner 1, 0=on, 1=off
@@ -2389,6 +2390,21 @@ struct em28xx_board em28xx_boards[] = {
 		.ir_codes      = RC_MAP_HAUPPAUGE,
 		.leds          = hauppauge_dualhd_leds,
 	},
+	/*
+	 * 2040:026d Hauppauge WinTV-dualHD (model 01595 - ATSC/QAM).
+	 * Empia EM28274, 2x LG LGDT3306A, 2x Silicon Labs Si2157
+	 */
+	[EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595] = {
+		.name          = "Hauppauge WinTV-dualHD 01595 ATSC/QAM",
+		.def_i2c_bus   = 1,
+		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
+				 EM28XX_I2C_FREQ_400_KHZ,
+		.tuner_type    = TUNER_ABSENT,
+		.tuner_gpio    = hauppauge_dualhd_dvb,
+		.has_dvb       = 1,
+		.ir_codes      = RC_MAP_HAUPPAUGE,
+		.leds          = hauppauge_dualhd_leds,
+	},
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
@@ -2514,6 +2530,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850 },
 	{ USB_DEVICE(0x2040, 0x0265),
 			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB },
+	{ USB_DEVICE(0x2040, 0x026d),
+			.driver_info = EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 },
 	{ USB_DEVICE(0x0438, 0xb002),
 			.driver_info = EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600 },
 	{ USB_DEVICE(0x2001, 0xf112),
@@ -2945,6 +2963,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	case EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB:
+	case EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595:
 	{
 		struct tveeprom tv;
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 75a75da..82edd37 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -37,6 +37,7 @@
 
 #include "lgdt330x.h"
 #include "lgdt3305.h"
+#include "lgdt3306a.h"
 #include "zl10353.h"
 #include "s5h1409.h"
 #include "mt2060.h"
@@ -920,6 +921,17 @@ static struct tda18271_config pinnacle_80e_dvb_config = {
 	.role    = TDA18271_MASTER,
 };
 
+static struct lgdt3306a_config hauppauge_01595_lgdt3306a_config = {
+	.qam_if_khz         = 4000,
+	.vsb_if_khz         = 3250,
+	.spectral_inversion = 0,
+	.deny_i2c_rptr      = 0,
+	.mpeg_mode          = LGDT3306A_MPEG_SERIAL,
+	.tpclk_edge         = LGDT3306A_TPCLK_RISING_EDGE,
+	.tpvalid_polarity   = LGDT3306A_TP_VALID_HIGH,
+	.xtalMHz            = 25,
+};
+
 /* ------------------------------------------------------------------ */
 
 static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
@@ -1950,6 +1962,68 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		}
 		break;
+	case EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595:
+		{
+			struct i2c_adapter *adapter;
+			struct i2c_client *client;
+			struct i2c_board_info info = {};
+			struct lgdt3306a_config lgdt3306a_config;
+			struct si2157_config si2157_config = {};
+
+			/* attach demod */
+			lgdt3306a_config = hauppauge_01595_lgdt3306a_config;
+			lgdt3306a_config.fe = &dvb->fe[0];
+			lgdt3306a_config.i2c_adapter = &adapter;
+			strlcpy(info.type, "lgdt3306a", sizeof(info.type));
+			info.addr = 0x59;
+			info.platform_data = &lgdt3306a_config;
+			request_module(info.type);
+			client = i2c_new_device(&dev->i2c_adap[dev->def_i2c_bus],
+					&info);
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
+			si2157_config.if_port = 1;
+			si2157_config.inversion = 1;
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+			si2157_config.mdev = dev->media_dev;
+#endif
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2157", sizeof(info.type));
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module(info.type);
+
+			client = i2c_new_device(adapter, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				module_put(dvb->i2c_client_demod->dev.driver->owner);
+				i2c_unregister_device(dvb->i2c_client_demod);
+				result = -ENODEV;
+				goto out_free;
+			}
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
 		dev_err(&dev->intf->dev,
 			"The frontend of your DVB/ATSC card isn't supported yet\n");
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index ca59e2d..e9f3799 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -147,6 +147,7 @@
 #define EM2884_BOARD_ELGATO_EYETV_HYBRID_2008     97
 #define EM28178_BOARD_PLEX_PX_BCUD                98
 #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
+#define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
2.9.3

