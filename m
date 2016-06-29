Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52914 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcF2Xj7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:39:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] m88ds3103: refactor firmware download
Date: Thu, 30 Jun 2016 02:39:48 +0300
Message-Id: <1467243588-26204-5-git-send-email-crope@iki.fi>
In-Reply-To: <1467243588-26204-1-git-send-email-crope@iki.fi>
References: <1467243588-26204-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* remove some unneeded variable initialization
* rename variables
* use min() macro to calc max i2c xfer len
* change bad firmware error code from EFAULT to EINVAL

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 49 +++++++++++++++------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 5158bf3..e0fe5bc 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -621,10 +621,10 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
 	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, len, remaining;
+	int ret, len, rem;
 	unsigned int utmp;
-	const struct firmware *fw = NULL;
-	u8 *fw_file;
+	const struct firmware *firmware;
+	const char *name;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -650,7 +650,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "firmware=%02x\n", utmp);
 
 	if (utmp)
-		goto skip_fw_download;
+		goto warm;
 
 	/* global reset, global diseqc reset, golbal fec reset */
 	ret = regmap_write(dev->regmap, 0x07, 0xe0);
@@ -665,52 +665,47 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 		 m88ds3103_ops.info.name);
 
 	if (dev->chip_id == M88RS6000_CHIP_ID)
-		fw_file = M88RS6000_FIRMWARE;
+		name = M88RS6000_FIRMWARE;
 	else
-		fw_file = M88DS3103_FIRMWARE;
+		name = M88DS3103_FIRMWARE;
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
+	ret = request_firmware(&firmware, name, &client->dev);
 	if (ret) {
-		dev_err(&client->dev, "firmware file '%s' not found\n", fw_file);
+		dev_err(&client->dev, "firmware file '%s' not found\n", name);
 		goto err;
 	}
 
-	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-		 fw_file);
+	dev_info(&client->dev, "downloading firmware from file '%s'\n", name);
 
 	ret = regmap_write(dev->regmap, 0xb2, 0x01);
 	if (ret)
-		goto error_fw_release;
-
-	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->cfg->i2c_wr_max - 1)) {
-		len = remaining;
-		if (len > (dev->cfg->i2c_wr_max - 1))
-			len = (dev->cfg->i2c_wr_max - 1);
+		goto err_release_firmware;
 
+	for (rem = firmware->size; rem > 0; rem -= (dev->cfg->i2c_wr_max - 1)) {
+		len = min(dev->cfg->i2c_wr_max - 1, rem);
 		ret = regmap_bulk_write(dev->regmap, 0xb0,
-				&fw->data[fw->size - remaining], len);
+					&firmware->data[firmware->size - rem],
+					len);
 		if (ret) {
-			dev_err(&client->dev, "firmware download failed=%d\n",
+			dev_err(&client->dev, "firmware download failed %d\n",
 				ret);
-			goto error_fw_release;
+			goto err_release_firmware;
 		}
 	}
 
 	ret = regmap_write(dev->regmap, 0xb2, 0x00);
 	if (ret)
-		goto error_fw_release;
+		goto err_release_firmware;
 
-	release_firmware(fw);
-	fw = NULL;
+	release_firmware(firmware);
 
 	ret = regmap_read(dev->regmap, 0xb9, &utmp);
 	if (ret)
 		goto err;
 
 	if (!utmp) {
+		ret = -EINVAL;
 		dev_info(&client->dev, "firmware did not run\n");
-		ret = -EFAULT;
 		goto err;
 	}
 
@@ -719,7 +714,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	dev_info(&client->dev, "firmware version: %X.%X\n",
 		 (utmp >> 4) & 0xf, (utmp >> 0 & 0xf));
 
-skip_fw_download:
+warm:
 	/* warm state */
 	dev->warm = true;
 
@@ -732,8 +727,8 @@ skip_fw_download:
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	return 0;
-error_fw_release:
-	release_firmware(fw);
+err_release_firmware:
+	release_firmware(firmware);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
-- 
http://palosaari.fi/

