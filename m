Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:57322 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2LJVhp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:45 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 9/9] [media] m920x: add support for the VP-7049 Twinhan DVB-T USB Stick
Date: Mon, 10 Dec 2012 22:37:17 +0100
Message-Id: <1355175437-21623-10-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device was originally made by Twinhan/Azurewave[1] and sometimes
named DTV-DVB UDTT7049, it could be also found in Italy under the name
of Digicom Digitune-S[2], or Think Xtra Hollywood DVB-T USB2.0[3].

Components:
  Usb bridge: ULi M9206
  Frontend: MT352CG
  Tuner: MT2060F

The firmware can be downloaded with:
$ ./Documentation/dvb/get_dvb_firmware vp7049

[1] http://www.azurewave.com/Support_Utility_Driver.asp
[2] http://www.digicom.it/digisit/driver_link.nsf/driverprodotto?openform&prodotto=DigiTuneS
[3] http://www.txitalia.it/prodotto.asp?prodotto=txhollywooddvttv

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/dvb-core/dvb-usb-ids.h |    1 +
 drivers/media/usb/dvb-usb/m920x.c    |  123 ++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 58e0220..faeaadd 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -172,6 +172,7 @@
 #define USB_PID_TWINHAN_VP7045_WARM			0x3206
 #define USB_PID_TWINHAN_VP7021_COLD			0x3207
 #define USB_PID_TWINHAN_VP7021_WARM			0x3208
+#define USB_PID_TWINHAN_VP7049				0x3219
 #define USB_PID_TINYTWIN				0x3226
 #define USB_PID_TINYTWIN_2				0xe402
 #define USB_PID_TINYTWIN_3				0x9016
diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 531a681..02facc6 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -16,6 +16,7 @@
 #include "qt1010.h"
 #include "tda1004x.h"
 #include "tda827x.h"
+#include "mt2060.h"
 
 #include <media/tuner.h>
 #include "tuner-simple.h"
@@ -546,6 +547,12 @@ static struct qt1010_config m920x_qt1010_config = {
 	.i2c_address = 0x62
 };
 
+static struct mt2060_config m920x_mt2060_config = {
+	.i2c_address = 0x60, /* 0xc0 */
+	.clock_out = 0,
+};
+
+
 /* Callbacks for DVB USB */
 static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 {
@@ -560,6 +567,37 @@ static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
+static int m920x_mt352_frontend_attach_vp7049(struct dvb_usb_adapter *adap)
+{
+	struct m920x_inits vp7049_fe_init_seq[] = {
+		/* XXX without these commands the frontend cannot be detected,
+		 * they must be sent BEFORE the frontend is attached */
+		{ 0xff28,         0x00 },
+		{ 0xff23,         0x00 },
+		{ 0xff28,         0x00 },
+		{ 0xff23,         0x00 },
+		{ 0xff21,         0x20 },
+		{ 0xff21,         0x60 },
+		{ 0xff28,         0x00 },
+		{ 0xff22,         0x00 },
+		{ 0xff20,         0x30 },
+		{ 0xff20,         0x20 },
+		{ 0xff20,         0x30 },
+		{ } /* terminating entry */
+	};
+	int ret;
+
+	deb("%s\n",__func__);
+
+	ret = m920x_write_seq(adap->dev->udev, M9206_CORE, vp7049_fe_init_seq);
+	if (ret != 0) {
+		deb("Initialization of vp7049 frontend failed.");
+		return ret;
+	}
+
+	return m920x_mt352_frontend_attach(adap);
+}
+
 static int m920x_tda10046_08_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	deb("%s\n",__func__);
@@ -624,6 +662,18 @@ static int m920x_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
+static int m920x_mt2060_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	deb("%s\n",__func__);
+
+	if (dvb_attach(mt2060_attach, adap->fe_adap[0].fe, &adap->dev->i2c_adap,
+		       &m920x_mt2060_config, 1220) == NULL)
+		return -ENODEV;
+
+	return 0;
+}
+
+
 /* device-specific initialization */
 static struct m920x_inits megasky_rc_init [] = {
 	{ M9206_RC_INIT2, 0xa8 },
@@ -652,6 +702,15 @@ static struct m920x_inits pinnacle310e_init[] = {
 	{ } /* terminating entry */
 };
 
+static struct m920x_inits vp7049_rc_init[] = {
+	{ 0xff28,         0x00 },
+	{ 0xff23,         0x00 },
+	{ 0xff21,         0x70 },
+	{ M9206_RC_INIT2, 0x00 },
+	{ M9206_RC_INIT1, 0xff },
+	{ } /* terminating entry */
+};
+
 /* ir keymaps */
 static struct rc_map_table rc_map_megasky_table[] = {
 	{ 0x0012, KEY_POWER },
@@ -754,6 +813,7 @@ static struct dvb_usb_device_properties digivox_mini_ii_properties;
 static struct dvb_usb_device_properties tvwalkertwin_properties;
 static struct dvb_usb_device_properties dposh_properties;
 static struct dvb_usb_device_properties pinnacle_pctv310e_properties;
+static struct dvb_usb_device_properties vp7049_properties;
 
 static int m920x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -806,6 +866,13 @@ static int m920x_probe(struct usb_interface *intf,
 			goto found;
 		}
 
+		ret = dvb_usb_device_init(intf, &vp7049_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
+			rc_init_seq = vp7049_rc_init;
+			goto found;
+		}
+
 		return ret;
 	} else {
 		/* Another interface on a multi-tuner device */
@@ -837,6 +904,7 @@ static struct usb_device_id m920x_table [] = {
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_COLD) },
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_WARM) },
 		{ USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_PINNACLE_PCTV310E) },
+		{ USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_TWINHAN_VP7049) },
 		{ }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, m920x_table);
@@ -1129,6 +1197,61 @@ static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
 	}
 };
 
+static struct dvb_usb_device_properties vp7049_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.firmware = "dvb-usb-vp7049-0.95.fw",
+	.download_firmware = m920x_firmware_download,
+
+	.rc.core = {
+		.rc_interval    = 150,
+		.rc_codes       = RC_MAP_TWINHAN_VP1027_DVBS,
+		.rc_query       = m920x_rc_core_query,
+		.allowed_protos = RC_TYPE_UNKNOWN,
+	},
+
+	.size_of_priv     = sizeof(struct m920x_state),
+
+	.identify_state   = m920x_identify_state,
+	.num_adapters = 1,
+	.adapter = {{
+		.num_frontends = 1,
+		.fe = {{
+
+		.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+			DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+		.pid_filter_count = 8,
+		.pid_filter       = m920x_pid_filter,
+		.pid_filter_ctrl  = m920x_pid_filter_ctrl,
+
+		.frontend_attach  = m920x_mt352_frontend_attach_vp7049,
+		.tuner_attach     = m920x_mt2060_tuner_attach,
+
+		.stream = {
+			.type = USB_BULK,
+			.count = 8,
+			.endpoint = 0x81,
+			.u = {
+				 .bulk = {
+					 .buffersize = 512,
+				 }
+			}
+		},
+		}},
+	}},
+	.i2c_algo         = &m920x_i2c_algo,
+
+	.num_device_descs = 1,
+	.devices = {
+		{   "DTV-DVB UDTT7049",
+			{ &m920x_table[7], NULL },
+			{ NULL },
+		}
+	 }
+};
+
 static struct usb_driver m920x_driver = {
 	.name		= "dvb_usb_m920x",
 	.probe		= m920x_probe,
-- 
1.7.10.4

