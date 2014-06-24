Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49685 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaFXNP7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 09:15:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: override tuner id when bad value set into eeprom
Date: Tue, 24 Jun 2014 16:15:32 +0300
Message-Id: <1403615732-9193-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuner ID set into EEPROM is wrong in some cases, which causes driver
to select wrong tuner profile. That leads device non-working. Fix
issue by overriding known bad tuner IDs with suitable default value.

Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 40 +++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 021e4d3..7b9b75f 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -704,15 +704,41 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
-		if (tmp == 0x00)
-			dev_dbg(&d->udev->dev,
-					"%s: [%d]tuner not set, using default\n",
-					__func__, i);
-		else
+		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
+				__func__, i, tmp);
+
+		/* tuner sanity check */
+		if (state->chip_type == 0x9135) {
+			if (state->chip_version == 0x02) {
+				/* IT9135 BX (v2) */
+				switch (tmp) {
+				case AF9033_TUNER_IT9135_60:
+				case AF9033_TUNER_IT9135_61:
+				case AF9033_TUNER_IT9135_62:
+					state->af9033_config[i].tuner = tmp;
+					break;
+				}
+			} else {
+				/* IT9135 AX (v1) */
+				switch (tmp) {
+				case AF9033_TUNER_IT9135_38:
+				case AF9033_TUNER_IT9135_51:
+				case AF9033_TUNER_IT9135_52:
+					state->af9033_config[i].tuner = tmp;
+					break;
+				}
+			}
+		} else {
+			/* AF9035 */
 			state->af9033_config[i].tuner = tmp;
+		}
 
-		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
-				__func__, i, state->af9033_config[i].tuner);
+		if (state->af9033_config[i].tuner != tmp) {
+			dev_info(&d->udev->dev,
+					"%s: [%d] overriding tuner from %02x to %02x\n",
+					KBUILD_MODNAME, i, tmp,
+					state->af9033_config[i].tuner);
+		}
 
 		switch (state->af9033_config[i].tuner) {
 		case AF9033_TUNER_TUA9001:
-- 
1.9.3

