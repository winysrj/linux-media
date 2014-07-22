Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43278 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbaGVUMm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 16:12:42 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, m.chehab@samsung.com, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge WinTV 930C-HD (model 1114xx)
Date: Tue, 22 Jul 2014 22:12:16 +0200
Message-Id: <1406059938-21141-7-git-send-email-zzam@gentoo.org>
In-Reply-To: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig         |  1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c | 42 +++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 63 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 4 files changed, 107 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 036454e..569aa29 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -48,6 +48,7 @@ config VIDEO_CX231XX_DVB
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 8b80f88..8857fdd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -743,6 +743,45 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx] = {
+		.name = "Hauppauge WinTV 930C-HD (1114xx)",
+		.tuner_type = TUNER_ABSENT,
+		.tuner_addr = 0x60,
+		.tuner_gpio = RDE250_XCV_TUNER,
+		.tuner_sif_gpio = 0x05,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 1,
+		.demod_i2c_master = 2,
+		.has_dvb = 1,
+		.demod_addr = 0x0e,
+		.norm = V4L2_STD_PAL,
+
+		.input = {{
+			.type = CX231XX_VMUX_TELEVISION,
+			.vmux = CX231XX_VIN_3_1,
+			.amux = CX231XX_AMUX_VIDEO,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_COMPOSITE1,
+			.vmux = CX231XX_VIN_2_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_1_1 |
+				(CX231XX_VIN_1_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		} },
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -774,6 +813,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xb130),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
+	{USB_DEVICE(0x2040, 0xb131),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx},
 	{USB_DEVICE(0x2040, 0xb140),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xc200),
@@ -998,6 +1039,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 
 	switch (dev->model) {
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 		{
 			struct tveeprom tvee;
 			static u8 eeprom[256];
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 4ff6f7f..1fa7974 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -34,6 +34,7 @@
 #include "lgdt3305.h"
 #include "si2165.h"
 #include "mb86a20s.h"
+#include "si2157.h"
 
 MODULE_DESCRIPTION("driver for cx231xx based DVB cards");
 MODULE_AUTHOR("Srinivasa Deevi <srinivasa.deevi@conexant.com>");
@@ -159,6 +160,12 @@ static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
 	.ref_freq_Hz	= 16000000,
 };
 
+static const struct si2165_config pctv_quatro_stick_1114xx_si2165_config = {
+	.i2c_addr	= 0x64,
+	.chip_mode	= SI2165_MODE_PLL_EXT,
+	.ref_freq_Hz	= 24000000,
+};
+
 static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 {
 	char *errmsg = "Unknown";
@@ -746,6 +753,62 @@ static int dvb_init(struct cx231xx *dev)
 		dev->cx231xx_reset_analog_tuner = NULL;
 		break;
 
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+	{
+		struct i2c_client *client;
+		struct i2c_board_info info;
+		struct si2157_config si2157_config;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+
+		dev->dvb->frontend = dvb_attach(si2165_attach,
+			&pctv_quatro_stick_1114xx_si2165_config,
+			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			);
+
+		if (dev->dvb->frontend == NULL) {
+			printk(DRIVER_NAME
+			       ": Failed to attach SI2165 front end\n");
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		dev->dvb->frontend->ops.i2c_gate_ctrl = 0;
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		/* attach tuner */
+		memset(&si2157_config, 0, sizeof(si2157_config));
+		si2157_config.fe = dev->dvb->frontend;
+		si2157_config.inversion = true;
+		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+		info.addr = 0x60;
+		info.platform_data = &si2157_config;
+		request_module("si2157");
+
+		client = i2c_new_device(
+			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			&info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dvb_frontend_detach(dev->dvb->frontend);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			dvb_frontend_detach(dev->dvb->frontend);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dev->cx231xx_reset_analog_tuner = NULL;
+
+		dev->dvb->i2c_client_tuner = client;
+		break;
+	}
+
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index a6373ba..aeb1bf4 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -74,6 +74,7 @@
 #define CX231XX_BOARD_OTG102 17
 #define CX231XX_BOARD_KWORLD_UB445_USB_HYBRID 18
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx 19
+#define CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx 20
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
2.0.0

