Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52630 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeEEJuu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2018 05:50:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id w194so7274085wmf.2
        for <linux-media@vger.kernel.org>; Sat, 05 May 2018 02:50:49 -0700 (PDT)
From: Thomas Hollstegge <thomas.hollstegge@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Hollstegge <thomas.hollstegge@gmail.com>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 2/2] dvbsky: Add support for MyGica T230C v2
Date: Sat,  5 May 2018 11:50:31 +0200
Message-Id: <1525513831-17682-3-git-send-email-thomas.hollstegge@gmail.com>
In-Reply-To: <1525513831-17682-1-git-send-email-thomas.hollstegge@gmail.com>
References: <1525513831-17682-1-git-send-email-thomas.hollstegge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for newer revisions of the MyGica T230C, shipping with a
different USB pid. Although sometimes referred to as T230C2, the device
is sold under its original name T230C.

Besides a slightly different PCB layout and some different minor
components, it utilizes the same bridge, demodulator and tuner as the
older revision. However, it requires a fixed TS clock frequency of 10
MHz to tune to some muxes.

Tested with various DVB-T2 HEVC and DVB-C channels.

Signed-off-by: Thomas Hollstegge <thomas.hollstegge@gmail.com>
Cc: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 90 +++++++++++++++++++++++++++++++++++
 include/media/dvb-usb-ids.h           |  1 +
 2 files changed, 91 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 43eb828..49db69f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -719,6 +719,66 @@ static int dvbsky_mygica_t230c_attach(struct dvb_usb_adapter *adap)
 	return -ENODEV;
 }
 
+static int dvbsky_mygica_t230c_v2_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvbsky_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
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
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+	si2168_config.ts_clock_inv = 1;
+	si2168_config.ts_clock_mode = SI2168_TS_CLOCK_MODE_MANUAL;
+	si2168_config.ts_clock_freq = 10000000;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2168", sizeof(info.type));
+	info.addr = 0x64;
+	info.platform_data = &si2168_config;
+
+	request_module("si2168");
+	client_demod = i2c_new_device(&d->i2c_adap, &info);
+	if (!client_demod || !client_demod->dev.driver)
+		goto fail_demod_device;
+	if (!try_module_get(client_demod->dev.driver->owner))
+		goto fail_demod_module;
+
+	/* attach tuner */
+	memset(&si2157_config, 0, sizeof(si2157_config));
+	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 0;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2141", sizeof(info.type));
+	info.addr = 0x60;
+	info.platform_data = &si2157_config;
+
+	request_module("si2157");
+	client_tuner = i2c_new_device(i2c_adapter, &info);
+	if (!client_tuner || !client_tuner->dev.driver)
+		goto fail_tuner_device;
+	if (!try_module_get(client_tuner->dev.driver->owner))
+		goto fail_tuner_module;
+
+	state->i2c_client_demod = client_demod;
+	state->i2c_client_tuner = client_tuner;
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
 
 static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
 {
@@ -911,6 +971,33 @@ static struct dvb_usb_device_properties mygica_t230c_props = {
 	}
 };
 
+static struct dvb_usb_device_properties mygica_t230c_v2_props = {
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
+	.frontend_attach  = dvbsky_mygica_t230c_v2_attach,
+	.init             = dvbsky_init,
+	.get_rc_config    = dvbsky_get_rc_config,
+	.streaming_ctrl   = dvbsky_streaming_ctrl,
+	.identify_state	  = dvbsky_identify_state,
+	.exit             = dvbsky_exit,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.stream = DVB_USB_STREAM_BULK(0x82, 8, 4096),
+		}
+	}
+};
+
+
 static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(0x0572, 0x6831,
 		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
@@ -946,6 +1033,9 @@ static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
 		&mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C",
 		RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
+	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C_V2,
+		&mygica_t230c_v2_props, "MyGica Mini DVB-T2 USB Stick T230C v2",
+		RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
diff --git a/include/media/dvb-usb-ids.h b/include/media/dvb-usb-ids.h
index 28e2be5..e31944d 100644
--- a/include/media/dvb-usb-ids.h
+++ b/include/media/dvb-usb-ids.h
@@ -387,6 +387,7 @@
 #define USB_PID_MYGICA_D689				0xd811
 #define USB_PID_MYGICA_T230				0xc688
 #define USB_PID_MYGICA_T230C				0xc689
+#define USB_PID_MYGICA_T230C_V2				0xc68a
 #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
-- 
2.7.4
