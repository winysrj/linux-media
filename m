Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44012 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739Ab3FCWzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:55:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] af9035: correct TS mode handling
Date: Tue,  4 Jun 2013 01:54:26 +0300
Message-Id: <1370300066-13964-5-git-send-email-crope@iki.fi>
In-Reply-To: <1370300066-13964-1-git-send-email-crope@iki.fi>
References: <1370300066-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 14 ++++++++------
 drivers/media/usb/dvb-usb-v2/af9035.h | 11 ++++++++---
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index e855ee6..1ea17dc 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -518,11 +518,11 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	 * which is done by master demod.
 	 * Master feeds also clock and controls power via GPIO.
 	 */
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_DUAL_MODE, &tmp);
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
-	if (tmp) {
+	if (tmp == 1 || tmp == 3) {
 		/* configure gpioh1, reset & power slave demod */
 		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
 		if (ret < 0)
@@ -640,13 +640,15 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	}
 
 	/* check if there is dual tuners */
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_DUAL_MODE, &tmp);
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
-	state->dual_mode = tmp;
-	dev_dbg(&d->udev->dev, "%s: dual mode=%d\n", __func__,
-			state->dual_mode);
+	if (tmp == 1 || tmp == 3)
+		state->dual_mode = true;
+
+	dev_dbg(&d->udev->dev, "%s: ts mode=%d dual mode=%d\n", __func__,
+			tmp, state->dual_mode);
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index b5827ca..a1c68d8 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -100,8 +100,13 @@ static const u32 clock_lut_it9135[] = {
  * eeprom is memory mapped as read only. Writing that memory mapped address
  * will not corrupt eeprom.
  *
- * eeprom has value 0x00 single mode and 0x03 for dual mode as far as I have
- * seen to this day.
+ * TS mode:
+ * 0  TS
+ * 1  DCA + PIP
+ * 3  PIP
+ * n  DCA
+ *
+ * Values 0 and 3 are seen to this day. 0 for single TS and 3 for dual TS.
  */
 
 #define EEPROM_BASE_AF9035        0x42fd
@@ -109,7 +114,7 @@ static const u32 clock_lut_it9135[] = {
 #define EEPROM_SHIFT                0x10
 
 #define EEPROM_IR_MODE              0x10
-#define EEPROM_DUAL_MODE            0x29
+#define EEPROM_TS_MODE              0x29
 #define EEPROM_2ND_DEMOD_ADDR       0x2a
 #define EEPROM_IR_TYPE              0x2c
 #define EEPROM_1_IF_L               0x30
-- 
1.7.11.7

