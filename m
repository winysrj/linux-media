Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39213 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab0D0BT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 21:19:56 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Michael=20M=C3=BCller?= <mueller_michael@alice-dsl.net>,
	Wolfram Sang <w.sang@pengutronix.de>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Date: Tue, 27 Apr 2010 03:18:57 +0200
Message-Id: <1272331137-17597-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH] Add Elgato EyeTV Diversity to dibcom driver
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Müller <mueller michael@alice-dsl.net>

This patch introduces support for DVB-T for the following dibcom
based card: Elgato EyeTV Diversity (USB-ID: 0fd9:0011)

Support for the Elgato silver IR remote is added too (set parameter
dvb_usb_dib0700_ir_proto=0)

[wsa: rebased to current linuxtv-master]

Signed-off-by: Michael Müller <mueller_michael@alice-dsl.net>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Olivier Grenie <olivier.grenie@dibcom.fr>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   46 +++++++++++++++++++++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 2deca21..800800a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -794,6 +794,43 @@ static struct dvb_usb_rc_key ir_codes_dib0700_table[] = {
 	{ 0x7a13, KEY_VOLUMEDOWN },
 	{ 0x7a40, KEY_POWER },
 	{ 0x7a41, KEY_MUTE },
+
+	/* Key codes for the Elgato EyeTV Diversity silver remote,
+	   set dvb_usb_dib0700_ir_proto=0 */
+	{ 0x4501, KEY_POWER },
+	{ 0x4502, KEY_MUTE },
+	{ 0x4503, KEY_1 },
+	{ 0x4504, KEY_2 },
+	{ 0x4505, KEY_3 },
+	{ 0x4506, KEY_4 },
+	{ 0x4507, KEY_5 },
+	{ 0x4508, KEY_6 },
+	{ 0x4509, KEY_7 },
+	{ 0x450a, KEY_8 },
+	{ 0x450b, KEY_9 },
+	{ 0x450c, KEY_LAST },
+	{ 0x450d, KEY_0 },
+	{ 0x450e, KEY_ENTER },
+	{ 0x450f, KEY_RED },
+	{ 0x4510, KEY_CHANNELUP },
+	{ 0x4511, KEY_GREEN },
+	{ 0x4512, KEY_VOLUMEDOWN },
+	{ 0x4513, KEY_OK },
+	{ 0x4514, KEY_VOLUMEUP },
+	{ 0x4515, KEY_YELLOW },
+	{ 0x4516, KEY_CHANNELDOWN },
+	{ 0x4517, KEY_BLUE },
+	{ 0x4518, KEY_LEFT }, /* Skip backwards */
+	{ 0x4519, KEY_PLAYPAUSE },
+	{ 0x451a, KEY_RIGHT }, /* Skip forward */
+	{ 0x451b, KEY_REWIND },
+	{ 0x451c, KEY_L }, /* Live */
+	{ 0x451d, KEY_FASTFORWARD },
+	{ 0x451e, KEY_STOP }, /* 'Reveal' for Teletext */
+	{ 0x451f, KEY_MENU }, /* KEY_TEXT for Teletext */
+	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
+	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
+	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */
 };
 
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
@@ -2049,6 +2086,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 /* 65 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73ESE) },
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
+	{ USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2393,7 +2431,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			}
 		},
 
-		.num_device_descs = 6,
+		.num_device_descs = 7,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -2419,7 +2457,11 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			{  "Sony PlayTV",
 				{ &dib0700_usb_id_table[44], NULL },
 				{ NULL },
-			}
+			},
+			{   "Elgato EyeTV Diversity",
+				{ &dib0700_usb_id_table[68], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = ir_codes_dib0700_table,
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index de1f3af..085c4e4 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -290,6 +290,7 @@
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
 #define USB_PID_SONY_PLAYTV				0x0003
 #define USB_PID_MYGICA_D689				0xd811
+#define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
-- 
1.7.0

