Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:35224 "EHLO
        homiemail-a118.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751729AbeAIQof (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 11:44:35 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 2/2] cx231xx: Add support for Hauppauge HVR-975
Date: Tue,  9 Jan 2018 10:44:26 -0600
Message-Id: <1515516266-365-1-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515515916-32108-3-git-send-email-brad@nextdimension.cc>
References: <1515515916-32108-3-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge HVR-975 is hybrid NTSC/PAL, QAM/ATSC, and DVB-C/T/T2 usb device.

Only ATSC/QAM front end is initially active. Second frontend support is
work in progress.

CX23102 + LG3306A/Si2168(WiP) + Si2157

Changes since v1:
- removed double semicolon


Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 42 ++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 74 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 3 files changed, 117 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c2efbff..8582568 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -961,6 +961,45 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_HAUPPAUGE_975] = {
+		.name = "Hauppauge WinTV-HVR-975",
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
+		.demod_addr = 0x59, /* 0xb2 >> 1 */
+		.norm = V4L2_STD_ALL,
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
 
@@ -994,6 +1033,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_955Q},
 	{USB_DEVICE(0x2040, 0xb151),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_935C},
+	{USB_DEVICE(0x2040, 0xb150),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_975},
 	{USB_DEVICE(0x2040, 0xb130),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx},
 	{USB_DEVICE(0x2040, 0xb131),
@@ -1253,6 +1294,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	case CX231XX_BOARD_HAUPPAUGE_955Q:
 	case CX231XX_BOARD_HAUPPAUGE_935C:
+	case CX231XX_BOARD_HAUPPAUGE_975:
 		{
 			struct eeprom {
 				struct tveeprom tvee;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 2e6bb09..cb8e90a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1143,6 +1143,80 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->i2c_client_tuner = client;
 		break;
 	}
+	case CX231XX_BOARD_HAUPPAUGE_975:
+	{
+		struct i2c_client *client;
+		struct i2c_adapter *adapter;
+		struct i2c_board_info info = {};
+		struct si2157_config si2157_config = {};
+		struct lgdt3306a_config lgdt3306a_config = {};
+
+		/* attach demodulator chip */
+		lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
+		lgdt3306a_config.fe = &dev->dvb->frontend;
+		lgdt3306a_config.i2c_adapter = &adapter;
+
+		strlcpy(info.type, "lgdt3306a", sizeof(info.type));
+		info.addr = dev->board.demod_addr;
+		info.platform_data = &lgdt3306a_config;
+
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL) {
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			dev_err(dev->dev,
+				"Failed to attach %s frontend.\n", info.type);
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
+		client = i2c_new_device(tuner_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL) {
+			module_put(dvb->i2c_client_demod->dev.driver->owner);
+			i2c_unregister_device(dvb->i2c_client_demod);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			dev_err(dev->dev,
+				"Failed to obtain %s tuner.\n",	info.type);
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
index 1493192..fa993f7 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -82,6 +82,7 @@
 #define CX231XX_BOARD_ASTROMETA_T2HYBRID 24
 #define CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO 25
 #define CX231XX_BOARD_HAUPPAUGE_935C 26
+#define CX231XX_BOARD_HAUPPAUGE_975 27
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
2.7.4
