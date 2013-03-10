Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53887 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3CJCEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 25/41] af9035: use already detected eeprom base addr
Date: Sun, 10 Mar 2013 04:03:17 +0200
Message-Id: <1362881013-5271-25-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

eeprom memory mapped base address is detected at the very first.
Use it everywhere.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 0399062..a29169f 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -606,18 +606,14 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
-		if (tmp) {
-			addr = EEPROM_BASE_IT9135;
-		} else {
+		if (tmp == 0x00) {
 			dev_dbg(&d->udev->dev, "%s: no eeprom\n", __func__);
 			goto skip_eeprom;
 		}
-	} else {
-		addr = EEPROM_BASE_AF9035;
 	}
 
 	/* check if there is dual tuners */
-	ret = af9035_rd_reg(d, addr + EEPROM_DUAL_MODE, &tmp);
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_DUAL_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -627,7 +623,9 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
-		ret = af9035_rd_reg(d, addr + EEPROM_2ND_DEMOD_ADDR, &tmp);
+		ret = af9035_rd_reg(d,
+				state->eeprom_addr + EEPROM_2ND_DEMOD_ADDR,
+				&tmp);
 		if (ret < 0)
 			goto err;
 
@@ -636,6 +634,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 				__func__, tmp);
 	}
 
+	addr = state->eeprom_addr;
+
 	for (i = 0; i < state->dual_mode + 1; i++) {
 		/* tuner */
 		ret = af9035_rd_reg(d, addr + EEPROM_1_TUNER_ID, &tmp);
@@ -1258,7 +1258,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (state->chip_type == 0x9135)
 		return 0;
 
-	ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_IR_MODE, &tmp);
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_IR_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -1266,7 +1266,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 
 	/* don't activate rc if in HID mode or if not available */
 	if (tmp == 5) {
-		ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_IR_TYPE,
+		ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_IR_TYPE,
 				&tmp);
 		if (ret < 0)
 			goto err;
-- 
1.7.11.7

