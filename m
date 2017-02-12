Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-out-2.rwth-aachen.de ([134.130.5.187]:10218 "EHLO
        mx-out-2.rwth-aachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdBLP0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 10:26:44 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH 3/3] [media] cxusb: MyGica T230C support
Date: Sun, 12 Feb 2017 16:26:28 +0100
In-Reply-To: <20170212152628.25383-1-stefan.bruens@rwth-aachen.de>
References: <20170212152628.25383-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <18845d0472524783bf68c835ac03a6bb@rwthex-w2-b.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mygica T230 DVB-T/T2/C USB stick support. It uses the same FX2/Si2168
bridge/demodulator combo as the T230, but uses the Si2141 tuner.
Factor out the common code and pass the tuner type and if port as
parameter, to avoid duplicating the initialization code.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/dvb-core/dvb-usb-ids.h |  1 +
 drivers/media/usb/dvb-usb/cxusb.c    | 80 ++++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 4 deletions(-)

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
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 9fd43a37154c..967f4f74309c 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1305,7 +1305,9 @@ static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
+static int cxusb_mygica_t230_common_frontend_attach(struct dvb_usb_adapter *adap,
+						    const char *tuner_name,
+						    u8 tuner_if_port)
 {
 	struct dvb_usb_device *d = adap->dev;
 	struct cxusb_state *st = d->priv;
@@ -1352,12 +1354,12 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe_adap[0].fe;
-	si2157_config.if_port = 1;
+	si2157_config.if_port = tuner_if_port;
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+	strlcpy(info.type, tuner_name, I2C_NAME_SIZE);
 	info.addr = 0x60;
 	info.platform_data = &si2157_config;
-	request_module(info.type);
+	request_module("si2157");
 	client_tuner = i2c_new_device(adapter, &info);
 	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
 		module_put(client_demod->dev.driver->owner);
@@ -1376,6 +1378,16 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
+static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	return cxusb_mygica_t230_common_frontend_attach(adap, "si2157", 1);
+}
+
+static int cxusb_mygica_t230c_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	return cxusb_mygica_t230_common_frontend_attach(adap, "si2141", 0);
+}
+
 /*
  * DViCO has shipped two devices with the same USB ID, but only one of them
  * needs a firmware download.  Check the device class details to see if they
@@ -1458,6 +1470,7 @@ static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
 static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
 static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
 static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
+static struct dvb_usb_device_properties cxusb_mygica_t230c_properties;
 
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -1490,6 +1503,8 @@ static int cxusb_probe(struct usb_interface *intf,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
+	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230c_properties,
+				     THIS_MODULE, NULL, adapter_nr) ||
 	    0)
 		return 0;
 
@@ -1541,6 +1556,7 @@ enum cxusb_table_index {
 	CONEXANT_D680_DMB,
 	MYGICA_D689,
 	MYGICA_T230,
+	MYGICA_T230C,
 	NR__cxusb_table_index
 };
 
@@ -1608,6 +1624,9 @@ static struct usb_device_id cxusb_table[NR__cxusb_table_index + 1] = {
 	[MYGICA_T230] = {
 		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230)
 	},
+	[MYGICA_T230C] = {
+		USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230C)
+	},
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -2307,6 +2326,59 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
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
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_map_table     = rc_map_d680_dmb_table,
+		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
+		.rc_query         = cxusb_d680_dmb_rc_query,
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
2.11.0
