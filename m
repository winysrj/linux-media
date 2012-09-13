Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52757 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/16] af9015: improve af9015_eeprom_hash()
Date: Thu, 13 Sep 2012 03:23:51 +0300
Message-Id: <1347495837-3244-10-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 49 ++++++++++++++---------------------
 1 file changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index c429da7..a4be303 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -398,43 +398,34 @@ error:
 static int af9015_eeprom_hash(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
-	int ret;
-	static const unsigned int eeprom_size = 256;
-	unsigned int reg;
-	u8 val, *eeprom;
-	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, &val};
-
-	eeprom = kmalloc(eeprom_size, GFP_KERNEL);
-	if (eeprom == NULL)
-		return -ENOMEM;
-
-	for (reg = 0; reg < eeprom_size; reg++) {
-		req.addr = reg;
+	int ret, i;
+	static const unsigned int AF9015_EEPROM_SIZE = 256;
+	u8 buf[AF9015_EEPROM_SIZE];
+	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, NULL};
+
+	/* read eeprom */
+	for (i = 0; i < AF9015_EEPROM_SIZE; i++) {
+		req.addr = i;
+		req.data = &buf[i];
 		ret = af9015_ctrl_msg(d, &req);
-		if (ret)
-			goto free;
-
-		eeprom[reg] = val;
+		if (ret < 0)
+			goto err;
 	}
 
-	for (reg = 0; reg < eeprom_size; reg += 16)
-		dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 16,
-				eeprom + reg);
-
-	BUG_ON(eeprom_size % 4);
-
-	state->eeprom_sum = 0;
-	for (reg = 0; reg < eeprom_size / sizeof(u32); reg++) {
+	/* calculate checksum */
+	for (i = 0; i < AF9015_EEPROM_SIZE / sizeof(u32); i++) {
 		state->eeprom_sum *= GOLDEN_RATIO_PRIME_32;
-		state->eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
+		state->eeprom_sum += le32_to_cpu(((u32 *)buf)[i]);
 	}
 
+	for (i = 0; i < AF9015_EEPROM_SIZE; i += 16)
+		dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 16, buf + i);
+
 	dev_dbg(&d->udev->dev, "%s: eeprom sum=%.8x\n",
 			__func__, state->eeprom_sum);
-
-	ret = 0;
-free:
-	kfree(eeprom);
+	return 0;
+err:
+	dev_err(&d->udev->dev, "%s: eeprom failed=%d\n", KBUILD_MODNAME, ret);
 	return ret;
 }
 
-- 
1.7.11.4

