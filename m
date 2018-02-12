Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:43735 "EHLO
        homiemail-a123.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753347AbeBLU4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 15:56:25 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 1/2] cx231xx: Add support for Hauppauge HVR-935C
Date: Mon, 12 Feb 2018 14:55:53 -0600
Message-Id: <1518468953-22655-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515515916-32108-2-git-send-email-brad@nextdimension.cc>
References: <1515515916-32108-2-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HVR-935C is hybrid PAL, DVB-C/T/T2 usb device.

CX23102 + Si2168 + Si2157
and
composite/s-video + stereo audio capture via breakout cable

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- add capture properties to message

 drivers/media/usb/cx231xx/cx231xx-cards.c | 42 +++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 75 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 3 files changed, 118 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f9ec7fe..c2efbff 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -922,6 +922,45 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_HAUPPAUGE_935C] = {
+		.name = "Hauppauge WinTV-HVR-935C",
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
+		.demod_i2c_master = I2C_1_MUX_3,
+		.has_dvb = 1,
+		.demod_addr = 0x64, /* 0xc8 >> 1 */
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
 
@@ -953,6 +992,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xb123),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_955Q},
+	{USB_DEVICE(0x2040, 0xb151),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_935C},
 	{USB_DEVICE(0x2040, 0xb130),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb131),
@@ -1211,6 +1252,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	case CX231XX_BOARD_HAUPPAUGE_955Q:
+	case CX231XX_BOARD_HAUPPAUGE_935C:
 		{
 			struct eeprom {
 				struct tveeprom tvee;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index fb56540..fa2ff92 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1068,6 +1068,81 @@ static int dvb_init(struct cx231xx *dev)
 			   &astrometa_t2hybrid_r820t_config);
 		break;
 	}
+	case CX231XX_BOARD_HAUPPAUGE_935C:
+	{
+		struct i2c_client *client;
+		struct i2c_adapter *adapter;
+		struct i2c_board_info info = {};
+		struct si2157_config si2157_config = {};
+		struct si2168_config si2168_config = {};
+
+		/* attach demodulator chip */
+		si2168_config.ts_mode = SI2168_TS_SERIAL;
+		si2168_config.fe = &dev->dvb->frontend;
+		si2168_config.i2c_adapter = &adapter;
+		si2168_config.ts_clock_inv = true;
+
+		strlcpy(info.type, "si2168", sizeof(info.type));
+		info.addr = dev->board.demod_addr;
+		info.platform_data = &si2168_config;
+
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dev_err(dev->dev,
+				"Failed to attach %s frontend.\n", info.type);
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
+		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
+
+		/* define general-purpose callback pointer */
+		dvb->frontend->callback = cx231xx_tuner_callback;
+
+		/* attach tuner */
+		si2157_config.fe = dev->dvb->frontend;
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+		si2157_config.mdev = dev->media_dev;
+#endif
+		si2157_config.if_port = 1;
+		si2157_config.inversion = true;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+		info.addr = dev->board.tuner_addr;
+		info.platform_data = &si2157_config;
+		request_module("si2157");
+
+		client = i2c_new_device(adapter, &info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dev_err(dev->dev,
+				"Failed to obtain %s tuner.\n",	info.type);
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dev->cx231xx_reset_analog_tuner = NULL;
+		dev->dvb->i2c_client_tuner = client;
+		break;
+	}
 	default:
 		dev_err(dev->dev,
 			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 65b039c..1493192 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -81,6 +81,7 @@
 #define CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD 23
 #define CX231XX_BOARD_ASTROMETA_T2HYBRID 24
 #define CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO 25
+#define CX231XX_BOARD_HAUPPAUGE_935C 26
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
2.7.4
