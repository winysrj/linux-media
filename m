Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47853 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbdFODbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 23:31:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/15] af9013: refactor firmware download routine
Date: Thu, 15 Jun 2017 06:31:04 +0300
Message-Id: <20170615033105.13517-14-crope@iki.fi>
In-Reply-To: <20170615033105.13517-1-crope@iki.fi>
References: <20170615033105.13517-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor firmware download routine.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 65 +++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index 63c532a..40fd2ea 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -1136,64 +1136,59 @@ static const struct dvb_frontend_ops af9013_ops;
 static int af9013_download_firmware(struct af9013_state *state)
 {
 	struct i2c_client *client = state->client;
-	int ret, i, len, remaining;
+	int ret, i, len, rem;
 	unsigned int utmp;
-	const struct firmware *fw;
+	u8 buf[4];
 	u16 checksum = 0;
-	u8 fw_params[4];
-	u8 *fw_file = AF9013_FIRMWARE;
+	const struct firmware *firmware;
+	const char *name = AF9013_FIRMWARE;
 
-	msleep(100);
-	/* check whether firmware is already running */
+	dev_dbg(&client->dev, "\n");
+
+	/* Check whether firmware is already running */
 	ret = regmap_read(state->regmap, 0x98be, &utmp);
 	if (ret)
 		goto err;
 
 	dev_dbg(&client->dev, "firmware status %02x\n", utmp);
 
-	if (utmp == 0x0c) /* fw is running, no need for download */
+	if (utmp == 0x0c)
 		return 0;
 
 	dev_info(&client->dev, "found a '%s' in cold state, will try to load a firmware\n",
 		 af9013_ops.info.name);
 
-	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &client->dev);
+	/* Request the firmware, will block and timeout */
+	ret = request_firmware(&firmware, name, &client->dev);
 	if (ret) {
 		dev_info(&client->dev, "firmware file '%s' not found %d\n",
-			 fw_file, ret);
+			 name, ret);
 		goto err;
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-		 fw_file);
-
-	/* calc checksum */
-	for (i = 0; i < fw->size; i++)
-		checksum += fw->data[i];
+		 name);
 
-	fw_params[0] = checksum >> 8;
-	fw_params[1] = checksum & 0xff;
-	fw_params[2] = fw->size >> 8;
-	fw_params[3] = fw->size & 0xff;
-
-	/* write fw checksum & size */
-	ret = regmap_bulk_write(state->regmap, 0x50fc, fw_params,
-				sizeof(fw_params));
+	/* Write firmware checksum & size */
+	for (i = 0; i < firmware->size; i++)
+		checksum += firmware->data[i];
 
+	buf[0] = (checksum >> 8) & 0xff;
+	buf[1] = (checksum >> 0) & 0xff;
+	buf[2] = (firmware->size >> 8) & 0xff;
+	buf[3] = (firmware->size >> 0) & 0xff;
+	ret = regmap_bulk_write(state->regmap, 0x50fc, buf, 4);
 	if (ret)
 		goto err_release_firmware;
 
-	#define FW_ADDR 0x5100 /* firmware start address */
-	#define LEN_MAX 16 /* max packet size */
-	for (remaining = fw->size; remaining > 0; remaining -= LEN_MAX) {
-		len = remaining;
-		if (len > LEN_MAX)
-			len = LEN_MAX;
-
+	/* Download firmware */
+	#define LEN_MAX 16
+	for (rem = firmware->size; rem > 0; rem -= LEN_MAX) {
+		len = min(LEN_MAX, rem);
 		ret = regmap_bulk_write(state->regmap,
-					FW_ADDR + fw->size - remaining,
-					&fw->data[fw->size - remaining], len);
+					0x5100 + firmware->size - rem,
+					&firmware->data[firmware->size - rem],
+					len);
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed %d\n",
 				ret);
@@ -1201,9 +1196,9 @@ static int af9013_download_firmware(struct af9013_state *state)
 		}
 	}
 
-	release_firmware(fw);
+	release_firmware(firmware);
 
-	/* request boot firmware */
+	/* Boot firmware */
 	ret = regmap_write(state->regmap, 0xe205, 0x01);
 	if (ret)
 		goto err;
@@ -1232,7 +1227,7 @@ static int af9013_download_firmware(struct af9013_state *state)
 
 	return 0;
 err_release_firmware:
-	release_firmware(fw);
+	release_firmware(firmware);
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
 	return ret;
-- 
http://palosaari.fi/
