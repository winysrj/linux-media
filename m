Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:55031 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424943AbdDVPlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Apr 2017 11:41:51 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: benjamin.larsson@inteno.se, linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] cx231xx: Initial support Astrometa T2hybrid
Date: Sat, 22 Apr 2017 18:47:13 +0300
Message-Id: <20170422154713.16807-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch provide only digital support;
The device is based on 24C02N EEPROM, Panasonic MN88473 demodulator,
Rafael Micro R828D tuner and CX23102-11Z chipset;
USB id: 15f4:0135.

Status:
- DVB-T/T2 works fine;
- Composite works fine;
- Analog not implemented.

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/usb/cx231xx/Kconfig         |  2 ++
 drivers/media/usb/cx231xx/cx231xx-cards.c | 34 +++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 49 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 4 files changed, 86 insertions(+)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 58de80b..6276d9b 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -52,6 +52,8 @@ config VIDEO_CX231XX_DVB
 	select DVB_SI2165 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MN88473 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_R820T if MEDIA_SUBDRV_AUTOSELECT
 
 	---help---
 	  This adds support for DVB cards based on the
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f730fdb..48f4c80 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -868,6 +868,33 @@ struct cx231xx_board cx231xx_boards[] = {
 			.amux = CX231XX_AMUX_LINE_IN,
 		} },
 	},
+	[CX231XX_BOARD_ASTROMETA_T2HYBRID] = {
+		.name = "Astrometa T2hybrid",
+		.tuner_type = TUNER_ABSENT,
+		.has_dvb = 1,
+		.output_mode = OUT_MODE_VIP11,
+		.agc_analog_digital_select_gpio = 0x01,
+		.ctl_pin_status_mask = 0xffffffc4,
+		.demod_addr = 0x18, /* 0x30 >> 1 */
+		.demod_i2c_master = I2C_1_MUX_1,
+		.gpio_pin_status_mask = 0xa,
+		.norm = V4L2_STD_NTSC,
+		.tuner_addr = 0x3a, /* 0x74 >> 1 */
+		.tuner_i2c_master = I2C_1_MUX_3,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.tuner_sif_gpio = 0x05,
+		.input = {{
+				.type = CX231XX_VMUX_TELEVISION,
+				.vmux = CX231XX_VIN_1_1,
+				.amux = CX231XX_AMUX_VIDEO,
+			}, {
+				.type = CX231XX_VMUX_COMPOSITE1,
+				.vmux = CX231XX_VIN_2_1,
+				.amux = CX231XX_AMUX_LINE_IN,
+			},
+		},
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -937,6 +964,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_TERRATEC_GRABBY},
 	{USB_DEVICE(0x1b80, 0xd3b2),
 	.driver_info = CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD},
+	{USB_DEVICE(0x15f4, 0x0135),
+	.driver_info = CX231XX_BOARD_ASTROMETA_T2HYBRID},
 	{},
 };
 
@@ -1013,6 +1042,11 @@ void cx231xx_pre_card_setup(struct cx231xx *dev)
 	dev_info(dev->dev, "Identified as %s (card=%d)\n",
 		dev->board.name, dev->model);
 
+	if (CX231XX_BOARD_ASTROMETA_T2HYBRID == dev->model) {
+		/* turn on demodulator chip */
+		cx231xx_set_gpio_value(dev, 0x03, 0x01);
+	}
+
 	/* set the direction for GPIO pins */
 	if (dev->board.tuner_gpio) {
 		cx231xx_set_gpio_direction(dev, dev->board.tuner_gpio->bit, 1);
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 46427fd..ee3eeeb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -37,6 +37,8 @@
 #include "mb86a20s.h"
 #include "si2157.h"
 #include "lgdt3306a.h"
+#include "r820t.h"
+#include "mn88473.h"
 
 MODULE_DESCRIPTION("driver for cx231xx based DVB cards");
 MODULE_AUTHOR("Srinivasa Deevi <srinivasa.deevi@conexant.com>");
@@ -164,6 +166,13 @@ static struct lgdt3306a_config hauppauge_955q_lgdt3306a_config = {
 	.xtalMHz            = 25,
 };
 
+static struct r820t_config astrometa_t2hybrid_r820t_config = {
+	.i2c_addr		= 0x3a, /* 0x74 >> 1 */
+	.xtal			= 16000000,
+	.rafael_chip		= CHIP_R828D,
+	.max_i2c_msg_len	= 2,
+};
+
 static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 {
 	char *errmsg = "Unknown";
@@ -1019,6 +1028,46 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->i2c_client_tuner = client;
 		break;
 	}
+	case CX231XX_BOARD_ASTROMETA_T2HYBRID:
+	{
+		struct i2c_client *client;
+		struct i2c_board_info info = {};
+		struct mn88473_config mn88473_config = {};
+
+		/* attach demodulator chip */
+		mn88473_config.i2c_wr_max = 16;
+		mn88473_config.xtal = 25000000;
+		mn88473_config.fe = &dev->dvb->frontend;
+
+		strlcpy(info.type, "mn88473", sizeof(info.type));
+		info.addr = dev->board.demod_addr;
+		info.platform_data = &mn88473_config;
+
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+
+		if (client == NULL || client->dev.driver == NULL) {
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod = client;
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		/* attach tuner chip */
+		dvb_attach(r820t_attach, dev->dvb->frontend,
+			   tuner_i2c,
+			   &astrometa_t2hybrid_r820t_config);
+		break;
+	}
 	default:
 		dev_err(dev->dev,
 			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index d9792ea..986c64b 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -79,6 +79,7 @@
 #define CX231XX_BOARD_HAUPPAUGE_955Q 21
 #define CX231XX_BOARD_TERRATEC_GRABBY 22
 #define CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD 23
+#define CX231XX_BOARD_ASTROMETA_T2HYBRID 24
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
2.10.2
