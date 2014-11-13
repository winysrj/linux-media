Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40521 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaKMIKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Nov 2014 03:10:45 -0500
Received: by mail-pa0-f43.google.com with SMTP id eu11so14867132pac.30
        for <linux-media@vger.kernel.org>; Thu, 13 Nov 2014 00:10:44 -0800 (PST)
Date: Thu, 13 Nov 2014 16:10:41 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 1/1] dvb-usb-dvbsky: add T680CI dvb-t2/t/c usb ci box support
Message-ID: <201411131610389068314@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T680CI dvb-t2/t/c usb ci box:
1>dvb frontend: SI2158A20(tuner), SI2168A30(demod)
2>usb controller: CY7C86013A
3>ci controller: CIMAX SP2 or its clone.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |   2 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 122 ++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 7423033..0982e73 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -145,7 +145,9 @@ config DVB_USB_DVBSKY
 	tristate "DVBSky USB support"
 	depends on DVB_USB_V2
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SP2 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the USB receivers from DVBSky.
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 8be8447..b6326c6 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -22,6 +22,8 @@
 #include "m88ds3103.h"
 #include "m88ts2022.h"
 #include "sp2.h"
+#include "si2168.h"
+#include "si2157.h"
 
 #define DVBSKY_MSG_DELAY	0/*2000*/
 #define DVBSKY_BUF_LEN	64
@@ -37,6 +39,7 @@ struct dvbsky_state {
 	u8 ibuf[DVBSKY_BUF_LEN];
 	u8 obuf[DVBSKY_BUF_LEN];
 	u8 last_lock;
+	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 	struct i2c_client *i2c_client_ci;
 
@@ -517,6 +520,90 @@ fail_attach:
 	return ret;
 }
 
+static int dvbsky_t680c_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvbsky_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret = 0;
+	struct i2c_adapter *i2c_adapter;
+	struct i2c_client *client_demod, *client_tuner, *client_ci;
+	struct i2c_board_info info;
+	struct si2168_config si2168_config;
+	struct si2157_config si2157_config;
+	struct sp2_config sp2_config;
+
+	/* attach demod */
+	memset(&si2168_config, 0, sizeof(si2168_config));
+	si2168_config.i2c_adapter = &i2c_adapter;
+	si2168_config.fe = &adap->fe[0];
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+	info.addr = 0x64;
+	info.platform_data = &si2168_config;
+
+	request_module(info.type);
+	client_demod = i2c_new_device(&d->i2c_adap, &info);
+	if (client_demod == NULL ||
+			client_demod->dev.driver == NULL)
+		goto fail_demod_device;
+	if (!try_module_get(client_demod->dev.driver->owner))
+		goto fail_demod_module;
+
+	/* attach tuner */
+	memset(&si2157_config, 0, sizeof(si2157_config));
+	si2157_config.fe = adap->fe[0];
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+	info.addr = 0x60;
+	info.platform_data = &si2157_config;
+
+	request_module(info.type);
+	client_tuner = i2c_new_device(i2c_adapter, &info);
+	if (client_tuner == NULL ||
+			client_tuner->dev.driver == NULL)
+		goto fail_tuner_device;
+	if (!try_module_get(client_tuner->dev.driver->owner))
+		goto fail_tuner_module;
+
+	/* attach ci controller */
+	memset(&sp2_config, 0, sizeof(sp2_config));
+	sp2_config.dvb_adap = &adap->dvb_adap;
+	sp2_config.priv = d;
+	sp2_config.ci_control = dvbsky_ci_ctrl;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "sp2", I2C_NAME_SIZE);
+	info.addr = 0x40;
+	info.platform_data = &sp2_config;
+
+	request_module(info.type);
+	client_ci = i2c_new_device(&d->i2c_adap, &info);
+
+	if (client_ci == NULL || client_ci->dev.driver == NULL)
+		goto fail_ci_device;
+
+	if (!try_module_get(client_ci->dev.driver->owner))
+		goto fail_ci_module;
+
+	state->i2c_client_demod = client_demod;
+	state->i2c_client_tuner = client_tuner;
+	state->i2c_client_ci = client_ci;
+	return ret;
+fail_ci_module:
+	i2c_unregister_device(client_ci);
+fail_ci_device:
+	module_put(client_tuner->dev.driver->owner);
+fail_tuner_module:
+	i2c_unregister_device(client_tuner);
+fail_tuner_device:
+	module_put(client_demod->dev.driver->owner);
+fail_demod_module:
+	i2c_unregister_device(client_demod);
+fail_demod_device:
+	ret = -ENODEV;
+	return ret;
+}
+
 static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	dvbsky_gpio_ctrl(d, 0x04, 1);
@@ -559,6 +646,12 @@ static void dvbsky_exit(struct dvb_usb_device *d)
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
+	client = state->i2c_client_demod;
+	/* remove I2C demod */
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
 	client = state->i2c_client_ci;
 	/* remove I2C ci */
 	if (client) {
@@ -622,11 +715,40 @@ static struct dvb_usb_device_properties dvbsky_s960c_props = {
 	}
 };
 
+static struct dvb_usb_device_properties dvbsky_t680c_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.adapter_nr = adapter_nr,
+	.size_of_priv = sizeof(struct dvbsky_state),
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+	.generic_bulk_ctrl_endpoint_response = 0x81,
+	.generic_bulk_ctrl_delay = DVBSKY_MSG_DELAY,
+
+	.i2c_algo         = &dvbsky_i2c_algo,
+	.frontend_attach  = dvbsky_t680c_attach,
+	.init             = dvbsky_init,
+	.get_rc_config    = dvbsky_get_rc_config,
+	.streaming_ctrl   = dvbsky_streaming_ctrl,
+	.identify_state	  = dvbsky_identify_state,
+	.exit             = dvbsky_exit,
+	.read_mac_address = dvbsky_read_mac_addr,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.stream = DVB_USB_STREAM_BULK(0x82, 8, 4096),
+		}
+	}
+};
+
 static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(0x0572, 0x6831,
 		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
 	{ DVB_USB_DEVICE(0x0572, 0x960c,
 		&dvbsky_s960c_props, "DVBSky S960CI", RC_MAP_DVBSKY) },
+	{ DVB_USB_DEVICE(0x0572, 0x680c,
+		&dvbsky_t680c_props, "DVBSky T680CI", RC_MAP_DVBSKY) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);

-- 
1.9.1

