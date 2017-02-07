Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward8h.cmail.yandex.net ([87.250.230.219]:52092 "EHLO
        forward8h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754207AbdBGVnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 16:43:25 -0500
Received: from smtp3m.mail.yandex.net (smtp3m.mail.yandex.net [IPv6:2a02:6b8:0:2519::125])
        by forward8h.cmail.yandex.net (Yandex) with ESMTP id 42A9021770
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:37:07 +0300 (MSK)
Received: from smtp3m.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp3m.mail.yandex.net (Yandex) with ESMTP id 27A192840E5D
        for <linux-media@vger.kernel.org>; Wed,  8 Feb 2017 00:37:06 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] dvb-usb-cxusb: Geniatech T230C support.
Date: Tue, 07 Feb 2017 23:37:01 +0200
Message-ID: <3396730.KzdrAG0WSU@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated Geniatech DVB-T/T2 stick support.

Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
---
 drivers/media/usb/dvb-usb/cxusb.c | 139 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 138 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 5d7b4ea..9b541db 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1238,6 +1238,82 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
+static int cxusb_mygica_t230c_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvb_usb_device *d = adap->dev;
+	struct cxusb_state *st = d->priv;
+	struct i2c_adapter *adapter;
+	struct i2c_client *client_demod;
+	struct i2c_client *client_tuner;
+	struct i2c_board_info info;
+	struct si2168_config si2168_config;
+	struct si2157_config si2157_config;
+
+	/* Select required USB configuration */
+	if (usb_set_interface(d->udev, 0, 0) < 0)
+		err("set interface failed");
+
+	/* Unblock all USB pipes */
+	usb_clear_halt(d->udev,
+		usb_sndbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
+	usb_clear_halt(d->udev,
+		usb_rcvbulkpipe(d->udev, d->props.generic_bulk_ctrl_endpoint));
+	usb_clear_halt(d->udev,
+		usb_rcvbulkpipe(d->udev, d->props.adapter[0].fe[0].stream.endpoint));
+
+	/* attach frontend */
+	memset(&si2168_config, 0, sizeof(si2168_config));
+	si2168_config.i2c_adapter = &adapter;
+	si2168_config.fe = &adap->fe_adap[0].fe;
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+	si2168_config.ts_clock_inv = 1;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+	info.addr = 0x64;
+	info.platform_data = &si2168_config;
+	request_module(info.type);
+	client_demod = i2c_new_device(&d->i2c_adap, &info);
+	if (client_demod == NULL || client_demod->dev.driver == NULL)
+		return -ENODEV;
+
+	if (!try_module_get(client_demod->dev.driver->owner)) {
+		i2c_unregister_device(client_demod);
+		return -ENODEV;
+	}
+
+	/* attach tuner */
+	memset(&si2157_config, 0, sizeof(si2157_config));
+	si2157_config.fe = adap->fe_adap[0].fe;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "si2141", I2C_NAME_SIZE);
+	info.addr = 0x60;
+	info.platform_data = &si2157_config;
+	request_module("si2157");
+	client_tuner = i2c_new_device(adapter, &info);
+	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
+		module_put(client_demod->dev.driver->owner);
+		i2c_unregister_device(client_demod);
+		return -ENODEV;
+	}
+	if (!try_module_get(client_tuner->dev.driver->owner)) {
+		i2c_unregister_device(client_tuner);
+		module_put(client_demod->dev.driver->owner);
+		i2c_unregister_device(client_demod);
+		return -ENODEV;
+	}
+
+	st->i2c_client_demod = client_demod;
+	st->i2c_client_tuner = client_tuner;
+
+	/* hook fe: need to resync the slave fifo when signal locks. */
+	mutex_init(&st->stream_mutex);
+	st->last_lock = 0;
+	st->fe_read_status = adap->fe_adap[0].fe->ops.read_status;
+	adap->fe_adap[0].fe->ops.read_status = cxusb_read_status;
+
+	return 0;
+}
+
 /*
  * DViCO has shipped two devices with the same USB ID, but only one of them
  * needs a firmware download.  Check the device class details to see if they
@@ -1320,6 +1396,7 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
 static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
 static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
 static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
+static struct dvb_usb_device_properties cxusb_mygica_t230c_properties;
 
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -1352,6 +1429,8 @@ static int cxusb_probe(struct usb_interface *intf,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230c_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
 	    0)
 		return 0;
 
@@ -1403,6 +1482,7 @@ enum cxusb_table_index {
 	CONEXANT_D680_DMB,
 	MYGICA_D689,
 	MYGICA_T230,
+	MYGICA_T230C,
 	NR__cxusb_table_index
 };
 
@@ -1470,6 +1550,9 @@ enum cxusb_table_index {
 	[MYGICA_T230] = {
 		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
 	},
+	[MYGICA_T230C] = {
+		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230+1)
+	},
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -2164,7 +2247,7 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 
 	.rc.core = {
 		.rc_interval	= 100,
-		.rc_codes	= RC_MAP_D680_DMB,
+		.rc_codes	= RC_MAP_TOTAL_MEDIA_IN_HAND_02,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
 		.allowed_protos = RC_BIT_UNKNOWN,
@@ -2180,6 +2263,60 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 	}
 };
 
+static struct dvb_usb_device_properties cxusb_mygica_t230c_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl         = CYPRESS_FX2,
+
+	.size_of_priv     = sizeof(struct cxusb_state),
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+		.num_frontends = 1,
+		.fe = {{
+			.streaming_ctrl   = cxusb_streaming_ctrl,
+			.frontend_attach  = cxusb_mygica_t230c_frontend_attach,
+
+			/* parameter for the MPEG2-data transfer */
+			.stream = {
+				.type = USB_BULK,
+				.count = 5,
+				.endpoint = 0x02,
+				.u = {
+					.bulk = {
+						.buffersize = 8192,
+					}
+				}
+			},
+		} },
+		},
+	},
+
+	.power_ctrl       = cxusb_d680_dmb_power_ctrl,
+
+	.i2c_algo         = &cxusb_i2c_algo,
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+
+	.rc.core = {
+		.rc_interval	= 100,
+		.rc_codes	= RC_MAP_TOTAL_MEDIA_IN_HAND_02,
+		.module_name	= KBUILD_MODNAME,
+		.rc_query       = cxusb_d680_dmb_rc_query,
+		.allowed_protos = RC_BIT_UNKNOWN,
+	},
+
+	.num_device_descs = 1,
+	.devices = {
+		{
+			"Mygica T230C DVB-T/T2/C",
+			{ NULL },
+			{ &cxusb_table[MYGICA_T230C], NULL },
+		},
+	}
+};
+
 static struct usb_driver cxusb_driver = {
 	.name		= "dvb_usb_cxusb",
 	.probe		= cxusb_probe,
-- 
1.9.1


