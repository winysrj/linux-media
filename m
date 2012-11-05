Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:35240 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab2KEX2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 18:28:35 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [PATCH 3/5] [media] m920x: Add support for the VP-7049 Twinhan DVB-T USB Stick
Date: Tue,  6 Nov 2012 00:28:14 +0100
Message-Id: <1352158096-17737-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This device was originally made by Twinhan/Azurewave[1] sometimes named
DTV-DVB UDTT7049, it could be also found in Italy under the name of
Digicom Digitune-S[2], or Think Xtra Hollywood DVB-T USB2.0[3].

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
 drivers/media/usb/dvb-usb/m920x.c    |  189 ++++++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+)

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
index 661bb75..ec820ec 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -16,6 +16,7 @@
 #include "qt1010.h"
 #include "tda1004x.h"
 #include "tda827x.h"
+#include "mt2060.h"
 
 #include <media/tuner.h>
 #include "tuner-simple.h"
@@ -496,6 +497,12 @@ static struct qt1010_config m920x_qt1010_config = {
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
@@ -574,6 +581,18 @@ static int m920x_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
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
@@ -602,6 +621,15 @@ static struct m920x_inits pinnacle310e_init[] = {
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
@@ -698,12 +726,69 @@ static struct rc_map_table rc_map_pinnacle310e_table[] = {
 	{ 0x5f, KEY_BLUE },		/* Blue */
 };
 
+static struct rc_map_table rc_map_vp7049_table[] = {
+	{ 0x16, KEY_POWER },
+	{ 0x17, KEY_FAVORITES },
+	{ 0x0f, KEY_TEXT },
+	{ 0x48, KEY_PROGRAM },		/* preview */
+	{ 0x1c, KEY_EPG },
+	{ 0x04, KEY_LIST },		/* record list */
+	{ 0x03, KEY_1 },
+	{ 0x01, KEY_2 },
+	{ 0x06, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x1d, KEY_5 },
+	{ 0x1f, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x19, KEY_8 },
+	{ 0x1b, KEY_9 },
+	{ 0x15, KEY_0 },
+	{ 0x0c, KEY_CANCEL },
+	{ 0x4a, KEY_CLEAR },
+	{ 0x13, KEY_BACK },
+	{ 0x00, KEY_TAB },
+	{ 0x4b, KEY_UP },
+	{ 0x4e, KEY_LEFT },
+	{ 0x52, KEY_RIGHT },
+	{ 0x51, KEY_DOWN },
+	{ 0x4f, KEY_ENTER },		/* could also be KEY_OK */
+	{ 0x1e, KEY_VOLUMEUP },
+	{ 0x0a, KEY_VOLUMEDOWN },
+	{ 0x05, KEY_CHANNELUP },
+	{ 0x02, KEY_CHANNELDOWN },
+	{ 0x11, KEY_RECORD },
+	{ 0x14, KEY_PLAY },
+	{ 0x4c, KEY_PAUSE },
+	{ 0x1a, KEY_STOP },
+	{ 0x40, KEY_REWIND },
+	{ 0x12, KEY_FASTFORWARD },
+	{ 0x41, KEY_PREVIOUS },		/* Replay */
+	{ 0x42, KEY_NEXT },		/* Skip */
+	{ 0x54, KEY_CAMERA },		/* Capture */
+	{ 0x50, KEY_LANGUAGE },		/* SAP (Separate Audio Program) */
+	{ 0x47, KEY_CYCLEWINDOWS },	/* Pip */
+	{ 0x4d, KEY_SCREEN },		/* FullScreen */
+	{ 0x43, KEY_SUBTITLE },
+	{ 0x10, KEY_MUTE },
+	{ 0x49, KEY_AB },		/* L/R */
+	{ 0x07, KEY_SLEEP },		/* Hibernate */
+	{ 0x08, KEY_VIDEO },		/* A/V */
+	{ 0x0e, KEY_MENU },		/* Recall */
+	{ 0x45, KEY_ZOOMIN },
+	{ 0x46, KEY_ZOOMOUT },
+	{ 0x18, KEY_RED },		/* Red */
+	{ 0x53, KEY_GREEN },		/* Green */
+	{ 0x5e, KEY_YELLOW },		/* Yellow */
+	{ 0x5f, KEY_BLUE },		/* Blue */
+};
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties megasky_properties;
 static struct dvb_usb_device_properties digivox_mini_ii_properties;
 static struct dvb_usb_device_properties tvwalkertwin_properties;
 static struct dvb_usb_device_properties dposh_properties;
 static struct dvb_usb_device_properties pinnacle_pctv310e_properties;
+static struct dvb_usb_device_properties vp7049_properties;
 
 static int m920x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -756,6 +841,13 @@ static int m920x_probe(struct usb_interface *intf,
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
@@ -787,6 +879,7 @@ static struct usb_device_id m920x_table [] = {
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_COLD) },
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_WARM) },
 		{ USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_PINNACLE_PCTV310E) },
+		{ USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_TWINHAN_VP7049) },
 		{ }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, m920x_table);
@@ -1079,6 +1172,102 @@ static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
 	}
 };
 
+static struct m920x_inits vp7049_pre_init_seq[] = {
+	/* XXX without these commands the frontend cannot be detected,
+	 * they must be sent BEFORE the frontend is attached */
+	{ 0xff28,         0x00 },
+	{ 0xff23,         0x00 },
+	{ 0xff28,         0x00 },
+	{ 0xff23,         0x00 },
+	{ 0xff21,         0x20 },
+	{ 0xff21,         0x60 },
+	{ 0xff28,         0x00 },
+	{ 0xff22,         0x00 },
+	{ 0xff20,         0x30 },
+	{ 0xff20,         0x20 },
+	{ 0xff20,         0x30 },
+	{ } /* terminating entry */
+};
+
+static int vp7049_pre_init(struct dvb_usb_device *d)
+{
+	struct m920x_inits *pre_init_seq = vp7049_pre_init_seq;
+	struct usb_device *udev = d->udev;
+	int ret;
+
+	deb("Pre-initialising vp7049\n");
+	while (pre_init_seq->address) {
+		if ((ret = m920x_write(udev, M9206_CORE,
+				       pre_init_seq->data,
+				       pre_init_seq->address)) != 0) {
+			deb("Pre-initialising vp7049 failed\n");
+			return ret;
+		}
+
+		pre_init_seq++;
+	}
+
+	deb("Pre-initialising vp7049 success\n");
+	return 0;
+}
+
+static struct dvb_usb_device_properties vp7049_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.firmware = "dvb-usb-vp7049-0.95.fw",
+	.download_firmware = m920x_firmware_download,
+
+	.pre_init = vp7049_pre_init,
+
+	.rc.legacy = {
+		.rc_interval      = 100,
+		.rc_map_table     = rc_map_vp7049_table,
+		.rc_map_size      = ARRAY_SIZE(rc_map_vp7049_table),
+		.rc_query         = m920x_rc_query,
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
+		.frontend_attach  = m920x_mt352_frontend_attach,
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

