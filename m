Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:46989 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbbB1PZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2015 10:25:45 -0500
Received: by lams18 with SMTP id s18so22770293lam.13
        for <linux-media@vger.kernel.org>; Sat, 28 Feb 2015 07:25:43 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] cx231xx: Hauppauge HVR-955Q ATSC/QAM tuner
Date: Sat, 28 Feb 2015 17:25:24 +0200
Message-Id: <1425137124-17324-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1425137124-17324-1-git-send-email-olli.salonen@iki.fi>
References: <1425137124-17324-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge HVR-955Q is a ATSC/QAM USB tuner with LGDT3306A demodulator and SiLabs Si2157-A30 tuner. This patch should be applied on top of the LGDT3306A patches in Mauro's lgdt3306a branch.

Only digital TV has been tested to work (ATSC and QAM256).

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/cx231xx/Kconfig         |  1 +
 drivers/media/usb/cx231xx/cx231xx-cards.c | 42 +++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 67 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 4 files changed, 111 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 173c0e2..0cced3e 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -47,6 +47,7 @@ config VIDEO_CX231XX_DVB
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MB86A20S if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_LGDT3306A if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA18271C2DD if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index dfc7010c..39004a1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -776,6 +776,45 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_HAUPPAUGE_955Q] = {
+		.name = "Hauppauge WinTV-HVR-955Q (111401)",
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
+		.tuner_i2c_master = I2C_1_MUX_3,
+		.demod_i2c_master = I2C_2,
+		.has_dvb = 1,
+		.demod_addr = 0x0e,
+		.norm = V4L2_STD_NTSC,
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
 
@@ -805,6 +844,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC},
 	{USB_DEVICE(0x2040, 0xb120),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
+	{USB_DEVICE(0x2040, 0xb123),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_955Q},
 	{USB_DEVICE(0x2040, 0xb130),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb131),
@@ -1049,6 +1090,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	switch (dev->model) {
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+	case CX231XX_BOARD_HAUPPAUGE_955Q:
 		{
 			struct tveeprom tvee;
 			static u8 eeprom[256];
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index e8c054c..140c997 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -34,6 +34,7 @@
 #include "si2165.h"
 #include "mb86a20s.h"
 #include "si2157.h"
+#include "lgdt3306a.h"
 
 MODULE_DESCRIPTION("driver for cx231xx based DVB cards");
 MODULE_AUTHOR("Srinivasa Deevi <srinivasa.deevi@conexant.com>");
@@ -160,6 +161,18 @@ static const struct si2165_config pctv_quatro_stick_1114xx_si2165_config = {
 	.ref_freq_Hz	= 24000000,
 };
 
+static struct lgdt3306a_config hauppauge_955q_lgdt3306a_config = {
+	.i2c_addr           = 0x59,
+	.qam_if_khz         = 4000,
+	.vsb_if_khz         = 3250,
+	.deny_i2c_rptr      = 1,
+	.spectral_inversion = 1,
+	.mpeg_mode          = LGDT3306A_MPEG_SERIAL,
+	.tpclk_edge         = LGDT3306A_TPCLK_RISING_EDGE,
+	.tpvalid_polarity   = LGDT3306A_TP_VALID_HIGH,
+	.xtalMHz            = 25,
+};
+
 static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 {
 	char *errmsg = "Unknown";
@@ -812,7 +825,61 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->i2c_client_tuner = client;
 		break;
 	}
+	case CX231XX_BOARD_HAUPPAUGE_955Q:
+	{
+		struct i2c_client *client;
+		struct i2c_board_info info;
+		struct si2157_config si2157_config;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+
+		dev->dvb->frontend = dvb_attach(lgdt3306a_attach,
+			&hauppauge_955q_lgdt3306a_config,
+			tuner_i2c
+			);
+
+		if (dev->dvb->frontend == NULL) {
+			dev_err(dev->dev,
+				"Failed to attach LGDT3306A frontend.\n");
+			result = -EINVAL;
+			goto out_free;
+		}
+
+		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
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
+			tuner_i2c,
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
 
+		dev->dvb->i2c_client_tuner = client;
+		break;
+	}
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index e0d3106..573b3c0 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -76,6 +76,7 @@
 #define CX231XX_BOARD_KWORLD_UB445_USB_HYBRID 18
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx 19
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx 20
+#define CX231XX_BOARD_HAUPPAUGE_955Q 21
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
1.9.1

