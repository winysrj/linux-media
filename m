Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout18.attiva.biz ([85.37.16.20]:28862 "EHLO
	smtpout18.attiva.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbZJXQ1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 12:27:49 -0400
Message-ID: <4AE32775.8020605@veneto.com>
Date: Sat, 24 Oct 2009 18:12:37 +0200
From: Massimo Del Fedele <max@veneto.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH]: Add support for Pinnacle PCTV310e card
Content-Type: multipart/mixed;
 boundary="------------070408010904030405010200"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070408010904030405010200
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This one adds support to Pinnacle PCTV310e hybrid tuner card,
for DVB-T and remote control, still no analog video.

Ciao

Max


--------------070408010904030405010200
Content-Type: text/x-patch;
 name="pinnacle310e.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pinnacle310e.patch"

# HG changeset patch
# User Massimo Del Fedele <max@veneto.com>
# Date 1256399510 -7200
# Node ID a855c30249ce7be8f6726e20835becbee8dacd1c
# Parent  f6680fa8e7ec88bbfbedddc7c3e99003e328a1aa
m920x : add support for Pinnacle PCTV310e
Added support for DVB-T and RC, still no analog TV

diff -r f6680fa8e7ec -r a855c30249ce linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Oct 20 00:08:05 2009 +0900
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Oct 24 17:51:50 2009 +0200
@@ -201,6 +201,7 @@
 #define USB_PID_PINNACLE_PCTV71E			0x022b
 #define USB_PID_PINNACLE_PCTV72E			0x0236
 #define USB_PID_PINNACLE_PCTV73E			0x0237
+#define USB_PID_PINNACLE_PCTV310E			0x3211
 #define USB_PID_PINNACLE_PCTV801E			0x023a
 #define USB_PID_PINNACLE_PCTV801E_SE			0x023b
 #define USB_PID_PINNACLE_PCTV73A			0x0243
diff -r f6680fa8e7ec -r a855c30249ce linux/drivers/media/dvb/dvb-usb/m920x.c
--- a/linux/drivers/media/dvb/dvb-usb/m920x.c	Tue Oct 20 00:08:05 2009 +0900
+++ b/linux/drivers/media/dvb/dvb-usb/m920x.c	Sat Oct 24 17:51:50 2009 +0200
@@ -16,6 +16,9 @@
 #include "qt1010.h"
 #include "tda1004x.h"
 #include "tda827x.h"
+
+#include <media/tuner.h>
+#include "tuner-simple.h"
 #include <asm/unaligned.h>
 
 /* debug */
@@ -158,11 +161,14 @@
 
 			case 0x93:
 			case 0x92:
+			case 0x83: /* pinnacle PCTV310e */
+			case 0x82:
 				m->rep_count = 0;
 				*state = REMOTE_KEY_PRESSED;
 				goto unlock;
 
 			case 0x91:
+			case 0x81: /* pinnacle PCTV310e */
 				/* prevent immediate auto-repeat */
 				if (++m->rep_count > 2)
 					*state = REMOTE_KEY_REPEAT;
@@ -549,6 +555,14 @@
 	return 0;
 }
 
+static int m920x_fmd1216me_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	dvb_attach(simple_tuner_attach, adap->fe,
+		   &adap->dev->i2c_adap, 0x61,
+		   TUNER_PHILIPS_FMD1216ME_MK3);
+	return 0;
+}
+
 /* device-specific initialization */
 static struct m920x_inits megasky_rc_init [] = {
 	{ M9206_RC_INIT2, 0xa8 },
@@ -565,6 +579,18 @@
 	{ } /* terminating entry */
 };
 
+static struct m920x_inits pinnacle310e_init [] = {
+	/* without these the tuner don't work */
+	{ 0xff20,         0x9b },
+	{ 0xff22,         0x70 },
+	
+	/* rc settings */
+	{ 0xff50,         0x80 },
+	{ M9206_RC_INIT1, 0x00 },
+	{ M9206_RC_INIT2, 0xff },
+	{ } /* terminating entry */
+};
+
 /* ir keymaps */
 static struct dvb_usb_rc_key megasky_rc_keys [] = {
 	{ 0x0012, KEY_POWER },
@@ -605,11 +631,68 @@
 	{ 0x001e, KEY_VOLUMEUP },
 };
 
+static struct dvb_usb_rc_key pinnacle310e_rc_keys [] = {
+	{ 0x16, KEY_POWER },
+	{ 0x17, KEY_FAVORITES },
+	{ 0x0f, KEY_TEXT },
+	{ 0x48, KEY_MEDIA },		/* preview */
+	{ 0x1c, KEY_EPG },
+	{ 0x04, KEY_LIST },			/* record list */
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
+	{ 0x41, KEY_PREVIOUSSONG },	/* Replay */
+	{ 0x42, KEY_NEXTSONG },		/* Skip */
+	{ 0x54, KEY_CAMERA },		/* Capture */
+/*	{ 0x50, KEY_SAP },	*/		/* Sap */
+	{ 0x47, KEY_CYCLEWINDOWS },	/* Pip */
+	{ 0x4d, KEY_SCREEN },		/* FullScreen */
+	{ 0x08, KEY_SUBTITLE },
+	{ 0x0e, KEY_MUTE },
+/*	{ 0x49, KEY_LR },	*/		/* L/R */
+	{ 0x07, KEY_SLEEP },		/* Hibernate */
+	{ 0x08, KEY_MEDIA },		/* A/V */
+	{ 0x0e, KEY_MENU },			/* Recall */
+	{ 0x45, KEY_ZOOMIN },
+	{ 0x46, KEY_ZOOMOUT },
+	{ 0x18, KEY_TV },			/* Red */
+	{ 0x53, KEY_VCR },			/* Green */
+	{ 0x5e, KEY_SAT },			/* Yellow */
+	{ 0x5f, KEY_PLAYER },		/* Blue */
+};
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties megasky_properties;
 static struct dvb_usb_device_properties digivox_mini_ii_properties;
 static struct dvb_usb_device_properties tvwalkertwin_properties;
 static struct dvb_usb_device_properties dposh_properties;
+static struct dvb_usb_device_properties pinnacle_pctv310e_properties;
 
 static int m920x_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -655,6 +738,13 @@
 			goto found;
 		}
 
+		ret = dvb_usb_device_init(intf, &pinnacle_pctv310e_properties,
+					  THIS_MODULE, &d, adapter_nr);
+		if (ret == 0) {
+			rc_init_seq = pinnacle310e_init;
+			goto found;
+		}
+
 		return ret;
 	} else {
 		/* Another interface on a multi-tuner device */
@@ -685,6 +775,7 @@
 			     USB_PID_LIFEVIEW_TV_WALKER_TWIN_WARM) },
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_COLD) },
 		{ USB_DEVICE(USB_VID_DPOSH, USB_PID_DPOSH_M9206_WARM) },
+        { USB_DEVICE(USB_VID_VISIONPLUS, USB_PID_PINNACLE_PCTV310E) },
 		{ }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, m920x_table);
@@ -898,6 +989,56 @@
 	 }
 };
 
+static struct dvb_usb_device_properties pinnacle_pctv310e_properties = {
+	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
+
+	.usb_ctrl = DEVICE_SPECIFIC,
+	.download_firmware = NULL,
+
+	.rc_interval      = 100,
+	.rc_key_map       = pinnacle310e_rc_keys,
+	.rc_key_map_size  = ARRAY_SIZE(pinnacle310e_rc_keys),
+	.rc_query         = m920x_rc_query,
+
+	.size_of_priv     = sizeof(struct m920x_state),
+
+	.identify_state   = m920x_identify_state,
+	.num_adapters = 1,
+	.adapter = {{
+		.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+			DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+		.pid_filter_count = 8,
+		.pid_filter       = m920x_pid_filter,
+		.pid_filter_ctrl  = m920x_pid_filter_ctrl,
+
+		.frontend_attach  = m920x_mt352_frontend_attach,
+		.tuner_attach     = m920x_fmd1216me_tuner_attach,
+
+		.stream = {
+			.type = USB_ISOC,
+			.count = 5,
+			.endpoint = 0x84,
+			.u = {
+				.isoc = {
+					.framesperurb = 128,
+					.framesize = 564,
+					.interval = 1,
+				}
+			}
+		},
+	}},
+	.i2c_algo         = &m920x_i2c_algo,
+
+	.num_device_descs = 1,
+	.devices = {
+		{   "Pinnacle PCTV 310e",
+			{ &m920x_table[6], NULL },
+			{ NULL },
+		}
+	}
+};
+
 static struct usb_driver m920x_driver = {
 	.name		= "dvb_usb_m920x",
 	.probe		= m920x_probe,
diff -r f6680fa8e7ec -r a855c30249ce linux/drivers/media/dvb/dvb-usb/m920x.h
--- a/linux/drivers/media/dvb/dvb-usb/m920x.h	Tue Oct 20 00:08:05 2009 +0900
+++ b/linux/drivers/media/dvb/dvb-usb/m920x.h	Sat Oct 24 17:51:50 2009 +0200
@@ -18,7 +18,7 @@
 #define M9206_FW	0x30
 
 #define M9206_MAX_FILTERS 8
-#define M9206_MAX_ADAPTERS 2
+#define M9206_MAX_ADAPTERS 4
 
 /*
 sequences found in logs:

--------------070408010904030405010200--
