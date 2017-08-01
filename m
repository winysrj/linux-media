Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34105 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbdHARzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:55:02 -0400
Received: by mail-lf0-f65.google.com with SMTP id o85so2112653lff.1
        for <linux-media@vger.kernel.org>; Tue, 01 Aug 2017 10:55:01 -0700 (PDT)
From: olli.salonen@iki.fi
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCHv2 2/2] dib0700: add support for Xbox One Digital TV Tuner
Date: Tue,  1 Aug 2017 20:54:44 +0300
Message-Id: <1501610084-23964-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1501610084-23964-1-git-send-email-olli.salonen@iki.fi>
References: <1501610084-23964-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Xbox One Digital TV Tuner is a low-cost USB 2.0 multistandard TV tuner. It
supports DVB-T, DVB-T2 and DVB-C broadcast standards.

USB bridge: DibCom 0700C
Demodulator: Panasonic MN88472
Tuner: TDA18250BHN

The demodulator requires firmware. Download one from here:
http://palosaari.fi/linux/v4l-dvb/firmware/MN88472/02/latest/

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h        |   2 +
 drivers/media/usb/dvb-usb/Kconfig           |   2 +
 drivers/media/usb/dvb-usb/dib0700.h         |   2 +
 drivers/media/usb/dvb-usb/dib0700_core.c    |  26 ++++++-
 drivers/media/usb/dvb-usb/dib0700_devices.c | 109 +++++++++++++++++++++++++++-
 5 files changed, 139 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 5b6041d..daf49ec 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -80,6 +80,7 @@
 #define USB_VID_AZUREWAVE			0x13d3
 #define USB_VID_TECHNISAT			0x14f7
 #define USB_VID_HAMA				0x147f
+#define USB_VID_MICROSOFT			0x045e
 
 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD			0xa333
@@ -417,4 +418,5 @@
 #define USB_PID_WINTV_SOLOHD                            0x0264
 #define USB_PID_EVOLVEO_XTRATV_STICK			0xa115
 #define USB_PID_HAMA_DVBT_HYBRID			0x2758
+#define USB_PID_XBOX_ONE_TUNER                          0x02d5
 #endif
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 959fa09..2651ae2 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -86,6 +86,7 @@ config DVB_USB_DIB0700
 	select DVB_USB_DIB3000MC if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1411 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LGDT3305 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MN88472 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TUNER_DIB0090 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
@@ -94,6 +95,7 @@ config DVB_USB_DIB0700
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_MXL5007T if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_TDA18250 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB2.0/1.1 DVB receivers based on the DiB0700 USB bridge. The
 	  USB bridge is also present in devices having the DiB7700 DVB-T-USB
diff --git a/drivers/media/usb/dvb-usb/dib0700.h b/drivers/media/usb/dvb-usb/dib0700.h
index 8fd8f5b..5f29128 100644
--- a/drivers/media/usb/dvb-usb/dib0700.h
+++ b/drivers/media/usb/dvb-usb/dib0700.h
@@ -51,6 +51,8 @@ struct dib0700_state {
 	int (*read_status)(struct dvb_frontend *, enum fe_status *);
 	int (*sleep)(struct dvb_frontend* fe);
 	u8 buf[255];
+	struct i2c_client *i2c_client_demod;
+	struct i2c_client *i2c_client_tuner;
 };
 
 extern int dib0700_get_version(struct dvb_usb_device *d, u32 *hwversion,
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bea1b47..dbd031c 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -911,10 +911,34 @@ static int dib0700_probe(struct usb_interface *intf,
 	return -ENODEV;
 }
 
+static void dib0700_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct dib0700_state *st = d->priv;
+	struct i2c_client *client;
+
+	/* remove I2C client for tuner */
+	client = st->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	/* remove I2C client for demodulator */
+	client = st->i2c_client_demod;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
+	dvb_usb_device_exit(intf);
+}
+
+
 static struct usb_driver dib0700_driver = {
 	.name       = "dvb_usb_dib0700",
 	.probe      = dib0700_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect = dib0700_disconnect,
 	.id_table   = dib0700_usb_id_table,
 };
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 6a57fc6..7c0fb18 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -23,6 +23,9 @@
 #include "dib0090.h"
 #include "lgdt3305.h"
 #include "mxl5007t.h"
+#include "mn88472.h"
+#include "tda18250.h"
+
 
 static int force_lna_activation;
 module_param(force_lna_activation, int, 0644);
@@ -3725,6 +3728,90 @@ static int mxl5007t_tuner_attach(struct dvb_usb_adapter *adap)
 			  &hcw_mxl5007t_config) == NULL ? -ENODEV : 0;
 }
 
+static int xbox_one_attach(struct dvb_usb_adapter *adap)
+{
+	struct dib0700_state *st = adap->dev->priv;
+	struct i2c_client *client_demod, *client_tuner;
+	struct dvb_usb_device *d = adap->dev;
+	struct mn88472_config mn88472_config = { };
+	struct tda18250_config tda18250_config;
+	struct i2c_board_info info;
+
+	st->fw_use_new_i2c_api = 1;
+	st->disable_streaming_master_mode = 1;
+
+	/* fe power enable */
+	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
+	msleep(30);
+	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
+	msleep(30);
+
+	/* demod reset */
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
+	msleep(30);
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
+	msleep(30);
+	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
+	msleep(30);
+
+	/* attach demod */
+	mn88472_config.fe = &adap->fe_adap[0].fe;
+	mn88472_config.i2c_wr_max = 22;
+	mn88472_config.xtal = 20500000;
+	mn88472_config.ts_mode = PARALLEL_TS_MODE;
+	mn88472_config.ts_clock = FIXED_TS_CLOCK;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
+	info.addr = 0x18;
+	info.platform_data = &mn88472_config;
+	request_module(info.type);
+	client_demod = i2c_new_device(&d->i2c_adap, &info);
+	if (client_demod == NULL || client_demod->dev.driver == NULL)
+		goto fail_demod_device;
+	if (!try_module_get(client_demod->dev.driver->owner))
+		goto fail_demod_module;
+
+	st->i2c_client_demod = client_demod;
+
+	adap->fe_adap[0].fe = mn88472_config.get_dvb_frontend(client_demod);
+
+	/* attach tuner */
+	memset(&tda18250_config, 0, sizeof(tda18250_config));
+	tda18250_config.if_dvbt_6 = 3950;
+	tda18250_config.if_dvbt_7 = 4450;
+	tda18250_config.if_dvbt_8 = 4950;
+	tda18250_config.if_dvbc_6 = 4950;
+	tda18250_config.if_dvbc_8 = 4950;
+	tda18250_config.if_atsc = 4079;
+	tda18250_config.loopthrough = true;
+	tda18250_config.xtal_freq = TDA18250_XTAL_FREQ_27MHZ;
+	tda18250_config.fe = adap->fe_adap[0].fe;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "tda18250", I2C_NAME_SIZE);
+	info.addr = 0x60;
+	info.platform_data = &tda18250_config;
+
+	request_module(info.type);
+	client_tuner = i2c_new_device(&adap->dev->i2c_adap, &info);
+	if (client_tuner == NULL || client_tuner->dev.driver == NULL)
+		goto fail_tuner_device;
+	if (!try_module_get(client_tuner->dev.driver->owner))
+		goto fail_tuner_module;
+
+	st->i2c_client_tuner = client_tuner;
+	return 0;
+
+fail_tuner_module:
+	i2c_unregister_device(client_tuner);
+fail_tuner_device:
+	module_put(client_demod->dev.driver->owner);
+fail_demod_module:
+	i2c_unregister_device(client_demod);
+fail_demod_device:
+	return -ENODEV;
+}
+
 
 /* DVB-USB and USB stuff follows */
 struct usb_device_id dib0700_usb_id_table[] = {
@@ -3816,7 +3903,8 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_PCTV_2002E_SE) },
 	{ USB_DEVICE(USB_VID_PCTV,      USB_PID_DIBCOM_STK8096PVR) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096PVR) },
-	{ USB_DEVICE(USB_VID_HAMA,	USB_PID_HAMA_DVBT_HYBRID) },
+/* 85 */{ USB_DEVICE(USB_VID_HAMA,	USB_PID_HAMA_DVBT_HYBRID) },
+	{ USB_DEVICE(USB_VID_MICROSOFT,	USB_PID_XBOX_ONE_TUNER) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -5040,6 +5128,25 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				RC_BIT_NEC,
 			.change_protocol  = dib0700_change_protocol,
 		},
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+		.num_adapters = 1,
+		.adapter = {
+			{
+				DIB0700_NUM_FRONTENDS(1),
+				.fe = {{
+					.frontend_attach = xbox_one_attach,
+
+					DIB0700_DEFAULT_STREAMING_CONFIG(0x82),
+				} },
+			},
+		},
+		.num_device_descs = 1,
+		.devices = {
+			{ "Microsoft Xbox One Digital TV Tuner",
+				{ &dib0700_usb_id_table[86], NULL },
+				{ NULL },
+			},
+		},
 	},
 };
 
-- 
2.7.4
