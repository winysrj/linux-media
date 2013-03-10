Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab3CJCEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:39 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 11/41] af9035: basic support for IT9135 v2 chips
Date: Sun, 10 Mar 2013 04:03:03 +0200
Message-Id: <1362881013-5271-11-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 44 ++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a1e953a..0b92277 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -316,7 +316,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 			state->chip_type);
 
 	if (state->chip_type == 0x9135) {
-		if (state->chip_version == 2)
+		if (state->chip_version == 0x02)
 			*name = AF9035_FIRMWARE_IT9135_V2;
 		else
 			*name = AF9035_FIRMWARE_IT9135_V1;
@@ -595,18 +595,23 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 	/* eeprom memory mapped location */
 	if (state->chip_type == 0x9135) {
+		if (state->chip_version == 0x02) {
+			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
+			tmp16 = 0x00461d;
+		} else {
+			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
+			tmp16 = 0x00461b;
+		}
+
 		/* check if eeprom exists */
-		if (state->chip_version == 2)
-			ret = af9035_rd_reg(d, 0x00461d, &tmp);
-		else
-			ret = af9035_rd_reg(d, 0x00461b, &tmp);
+		ret = af9035_rd_reg(d, tmp16, &tmp);
 		if (ret < 0)
 			goto err;
 
 		if (tmp) {
 			addr = EEPROM_BASE_IT9135;
 		} else {
-			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
+			dev_dbg(&d->udev->dev, "%s: no eeprom\n", __func__);
 			goto skip_eeprom;
 		}
 	} else {
@@ -639,12 +644,15 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
-		state->af9033_config[i].tuner = tmp;
-		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
-				__func__, i, tmp);
+		if (tmp == 0x00)
+			dev_dbg(&d->udev->dev,
+					"%s: [%d]tuner not set, using default\n",
+					__func__, i);
+		else
+			state->af9033_config[i].tuner = tmp;
 
-		if (state->chip_type == 0x9135 && tmp == 0x00)
-			state->af9033_config[i].tuner = AF9033_TUNER_IT9135_38;
+		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
+				__func__, i, state->af9033_config[i].tuner);
 
 		switch (state->af9033_config[i].tuner) {
 		case AF9033_TUNER_TUA9001:
@@ -975,12 +983,12 @@ static const struct fc0012_config af9035_fc0012_config[] = {
 };
 
 static struct ite_config af9035_it913x_config = {
-	.chip_ver = 0x01,
+	.chip_ver = 0x02,
 	.chip_type = 0x9135,
 	.firmware = 0x00000000,
 	.firmware_ver = 1,
 	.adc_x2 = 1,
-	.tuner_id_0 = AF9033_TUNER_IT9135_38,
+	.tuner_id_0 = 0x00,
 	.tuner_id_1 = 0x00,
 	.dual_mode = 0x00,
 	.adf = 0x00,
@@ -1153,6 +1161,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
 	case AF9033_TUNER_IT9135_52:
+		af9035_it913x_config.chip_ver = 0x01;
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
@@ -1453,6 +1462,7 @@ static const struct dvb_usb_device_properties af9035_props = {
 };
 
 static const struct usb_device_id af9035_id_table[] = {
+	/* AF9035 devices */
 	{ DVB_USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_9035,
 		&af9035_props, "Afatech AF9035 reference design", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_1000,
@@ -1477,6 +1487,14 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
+
+	/* IT9135 devices */
+#if 0
+	{ DVB_USB_DEVICE(0x048d, 0x9135,
+		&af9035_props, "IT9135 reference design", NULL) },
+	{ DVB_USB_DEVICE(0x048d, 0x9006,
+		&af9035_props, "IT9135 reference design", NULL) },
+#endif
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
-- 
1.7.11.7

