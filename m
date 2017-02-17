Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-1.rwth-aachen.de ([134.130.5.186]:27634 "EHLO
        mx-out-1.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754747AbdBQAzs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 19:55:48 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH v3 3/3] [media] dvbsky: MyGica T230C support
Date: Fri, 17 Feb 2017 01:55:33 +0100
In-Reply-To: <20170217005533.22424-1-stefan.bruens@rwth-aachen.de>
References: <20170217005533.22424-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <96682364420246ebb2b0246be8320591@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mygica T230 DVB-T/T2/C USB stick support. It uses the same FX2/Si2168
bridge/demodulator combo as the other devices supported by the driver,
but uses the Si2141 tuner.
Several DVB-T (MPEG2) and DVB-T2 (H.265) channels were tested, as well as
the included remote control.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
v2: add support to the dvbsky driver instead of cxusb, correct RC
model
v3: fixed coding style issues, use name as printed on box for id table
---
 drivers/media/dvb-core/dvb-usb-ids.h  |  1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 88 +++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index a7a4674ccc40..ce4a3d574dd7 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -380,6 +380,7 @@
 #define USB_PID_SONY_PLAYTV				0x0003
 #define USB_PID_MYGICA_D689				0xd811
 #define USB_PID_MYGICA_T230				0xc688
+#define USB_PID_MYGICA_T230C				0xc689
 #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_2			0x003f
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 02dbc6c45423..f98225767712 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -665,6 +665,65 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
 	return ret;
 }
 
+static int dvbsky_mygica_t230c_attach(struct dvb_usb_adapter *adap)
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
+
 static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	dvbsky_gpio_ctrl(d, 0x04, 1);
@@ -830,6 +889,32 @@ static struct dvb_usb_device_properties dvbsky_t330_props = {
 	}
 };
 
+static struct dvb_usb_device_properties mygica_t230c_props = {
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
+	.frontend_attach  = dvbsky_mygica_t230c_attach,
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
 static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(0x0572, 0x6831,
 		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
@@ -858,6 +943,9 @@ static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R4,
 		&dvbsky_s960_props, "Terratec Cinergy S2 Rev.4",
 		RC_MAP_DVBSKY) },
+	{ DVB_USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C,
+		&mygica_t230c_props, "MyGica Mini DVB-T2 USB Stick T230C",
+		RC_MAP_TOTAL_MEDIA_IN_HAND_02) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
-- 
2.11.0
