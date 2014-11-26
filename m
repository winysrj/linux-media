Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44479 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaKZMet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 07:34:49 -0500
Received: by mail-pa0-f42.google.com with SMTP id et14so2810394pad.29
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 04:34:48 -0800 (PST)
Date: Wed, 26 Nov 2014 20:34:46 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 1/3] dvb-usb-dvbsky: add T330 dvb-t2/t/c usb stick support
Message-ID: <201411262034428907954@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T330 dvb-t2/t/c usb stick:
1>dvb frontend: SI2157A30(tuner), SI2168B40(demod)
2>usb controller: CY7C68013A

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 88 +++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index b6326c6..86db800 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -604,6 +604,65 @@ fail_demod_device:
 	return ret;
 }
 
+static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvbsky_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret = 0;
+	struct i2c_adapter *i2c_adapter;
+	struct i2c_client *client_demod, *client_tuner;
+	struct i2c_board_info info;
+	struct si2168_config si2168_config;
+	struct si2157_config si2157_config;
+
+	/* attach demod */
+	memset(&si2168_config, 0, sizeof(si2168_config));
+	si2168_config.i2c_adapter = &i2c_adapter;
+	si2168_config.fe = &adap->fe[0];
+	si2168_config.ts_mode = SI2168_TS_PARALLEL | 0x40;
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
+	state->i2c_client_demod = client_demod;
+	state->i2c_client_tuner = client_tuner;
+	return ret;
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
@@ -742,6 +801,33 @@ static struct dvb_usb_device_properties dvbsky_t680c_props = {
 	}
 };
 
+static struct dvb_usb_device_properties dvbsky_t330_props = {
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
+	.frontend_attach  = dvbsky_t330_attach,
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
@@ -749,6 +835,8 @@ static const struct usb_device_id dvbsky_id_table[] = {
 		&dvbsky_s960c_props, "DVBSky S960CI", RC_MAP_DVBSKY) },
 	{ DVB_USB_DEVICE(0x0572, 0x680c,
 		&dvbsky_t680c_props, "DVBSky T680CI", RC_MAP_DVBSKY) },
+	{ DVB_USB_DEVICE(0x0572, 0x0320,
+		&dvbsky_t330_props, "DVBSky T330", RC_MAP_DVBSKY) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);

-- 
1.9.1

