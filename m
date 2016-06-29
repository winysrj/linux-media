Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42091 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbcF2Xid (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:38:33 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/3] si2168: add support for newer firmwares
Date: Thu, 30 Jun 2016 02:38:17 +0300
Message-Id: <1467243499-26093-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Si2168-B40 firmware API has changed somewhere between 4.0-11 and
4.0-19 so that sleep will lose firmware upgrade from the chip. Due
to that firmware re-upload is needed when newer firmwares are used.

Rewrote firmware handling logic partly at the same.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 124 ++++++++++++++++++------------
 drivers/media/dvb-frontends/si2168_priv.h |   8 +-
 2 files changed, 80 insertions(+), 52 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 108a069..124addc 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -357,9 +357,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	const struct firmware *fw;
-	const char *fw_name;
 	struct si2168_cmd cmd;
-	unsigned int chip_id;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -371,7 +369,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	if (dev->fw_loaded) {
+	if (dev->warm) {
 		/* resume */
 		memcpy(cmd.args, "\xc0\x06\x08\x0f\x00\x20\x21\x01", 8);
 		cmd.wlen = 8;
@@ -398,49 +396,14 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* query chip revision */
-	memcpy(cmd.args, "\x02", 1);
-	cmd.wlen = 1;
-	cmd.rlen = 13;
-	ret = si2168_cmd_execute(client, &cmd);
-	if (ret)
-		goto err;
-
-	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
-			cmd.args[4] << 0;
-
-	#define SI2168_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
-	#define SI2168_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
-	#define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
-
-	switch (chip_id) {
-	case SI2168_A20:
-		fw_name = SI2168_A20_FIRMWARE;
-		break;
-	case SI2168_A30:
-		fw_name = SI2168_A30_FIRMWARE;
-		break;
-	case SI2168_B40:
-		fw_name = SI2168_B40_FIRMWARE;
-		break;
-	default:
-		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
-				cmd.args[2], cmd.args[1],
-				cmd.args[3], cmd.args[4]);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
-			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
-
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_name, &client->dev);
+	ret = request_firmware(&fw, dev->firmware_name, &client->dev);
 	if (ret) {
 		/* fallback mechanism to handle old name for Si2168 B40 fw */
-		if (chip_id == SI2168_B40) {
-			fw_name = SI2168_B40_FIRMWARE_FALLBACK;
-			ret = request_firmware(&fw, fw_name, &client->dev);
+		if (dev->chip_id == SI2168_CHIP_ID_B40) {
+			dev->firmware_name = SI2168_B40_FIRMWARE_FALLBACK;
+			ret = request_firmware(&fw, dev->firmware_name,
+					       &client->dev);
 		}
 
 		if (ret == 0) {
@@ -450,13 +413,13 @@ static int si2168_init(struct dvb_frontend *fe)
 		} else {
 			dev_err(&client->dev,
 					"firmware file '%s' not found\n",
-					fw_name);
+					dev->firmware_name);
 			goto err_release_firmware;
 		}
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-			fw_name);
+			dev->firmware_name);
 
 	if ((fw->size % 17 == 0) && (fw->data[0] > 5)) {
 		/* firmware is in the new format */
@@ -511,8 +474,11 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
-			cmd.args[6], cmd.args[7], cmd.args[8]);
+	dev->version = (cmd.args[9] + '@') << 24 | (cmd.args[6] - '0') << 16 |
+		       (cmd.args[7] - '0') << 8 | (cmd.args[8]) << 0;
+	dev_info(&client->dev, "firmware version: %c %d.%d.%d\n",
+		 dev->version >> 24 & 0xff, dev->version >> 16 & 0xff,
+		 dev->version >> 8 & 0xff, dev->version >> 0 & 0xff);
 
 	/* set ts mode */
 	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
@@ -525,7 +491,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev->fw_loaded = true;
+	dev->warm = true;
 warm:
 	dev->active = true;
 
@@ -549,6 +515,10 @@ static int si2168_sleep(struct dvb_frontend *fe)
 
 	dev->active = false;
 
+	/* Firmware B 4.0-11 or later loses warm state during sleep */
+	if (dev->version > ('B' << 24 | 4 << 16 | 0 << 8 | 11 << 0))
+		dev->warm = false;
+
 	memcpy(cmd.args, "\x13", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 0;
@@ -653,6 +623,7 @@ static int si2168_probe(struct i2c_client *client,
 	struct si2168_config *config = client->dev.platform_data;
 	struct si2168_dev *dev;
 	int ret;
+	struct si2168_cmd cmd;
 
 	dev_dbg(&client->dev, "\n");
 
@@ -663,8 +634,56 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	i2c_set_clientdata(client, dev);
 	mutex_init(&dev->i2c_mutex);
 
+	/* Initialize */
+	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
+	cmd.wlen = 13;
+	cmd.rlen = 0;
+	ret = si2168_cmd_execute(client, &cmd);
+	if (ret)
+		goto err_kfree;
+
+	/* Power up */
+	memcpy(cmd.args, "\xc0\x06\x01\x0f\x00\x20\x20\x01", 8);
+	cmd.wlen = 8;
+	cmd.rlen = 1;
+	ret = si2168_cmd_execute(client, &cmd);
+	if (ret)
+		goto err_kfree;
+
+	/* Query chip revision */
+	memcpy(cmd.args, "\x02", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 13;
+	ret = si2168_cmd_execute(client, &cmd);
+	if (ret)
+		goto err_kfree;
+
+	dev->chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 |
+		       cmd.args[3] << 8 | cmd.args[4] << 0;
+
+	switch (dev->chip_id) {
+	case SI2168_CHIP_ID_A20:
+		dev->firmware_name = SI2168_A20_FIRMWARE;
+		break;
+	case SI2168_CHIP_ID_A30:
+		dev->firmware_name = SI2168_A30_FIRMWARE;
+		break;
+	case SI2168_CHIP_ID_B40:
+		dev->firmware_name = SI2168_B40_FIRMWARE;
+		break;
+	default:
+		dev_dbg(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
+			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
+		ret = -ENODEV;
+		goto err_kfree;
+	}
+
+	dev->version = (cmd.args[1]) << 24 | (cmd.args[3] - '0') << 16 |
+		       (cmd.args[4] - '0') << 8 | (cmd.args[5]) << 0;
+
 	/* create mux i2c adapter for tuner */
 	dev->muxc = i2c_mux_alloc(client->adapter, &client->dev,
 				  1, 0, I2C_MUX_LOCKED,
@@ -686,11 +705,14 @@ static int si2168_probe(struct i2c_client *client,
 	dev->ts_mode = config->ts_mode;
 	dev->ts_clock_inv = config->ts_clock_inv;
 	dev->ts_clock_gapped = config->ts_clock_gapped;
-	dev->fw_loaded = false;
 
-	i2c_set_clientdata(client, dev);
+	dev_info(&client->dev, "Silicon Labs Si2168-%c%d%d successfully identified\n",
+		 dev->version >> 24 & 0xff, dev->version >> 16 & 0xff,
+		 dev->version >> 8 & 0xff);
+	dev_info(&client->dev, "firmware version: %c %d.%d.%d\n",
+		 dev->version >> 24 & 0xff, dev->version >> 16 & 0xff,
+		 dev->version >> 8 & 0xff, dev->version >> 0 & 0xff);
 
-	dev_info(&client->dev, "Silicon Labs Si2168 successfully attached\n");
 	return 0;
 err_kfree:
 	kfree(dev);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 8a1f36d..7843ccb 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -34,8 +34,14 @@ struct si2168_dev {
 	struct dvb_frontend fe;
 	enum fe_delivery_system delivery_system;
 	enum fe_status fe_status;
+	#define SI2168_CHIP_ID_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
+	#define SI2168_CHIP_ID_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
+	#define SI2168_CHIP_ID_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
+	unsigned int chip_id;
+	unsigned int version;
+	const char *firmware_name;
 	bool active;
-	bool fw_loaded;
+	bool warm;
 	u8 ts_mode;
 	bool ts_clock_inv;
 	bool ts_clock_gapped;
-- 
http://palosaari.fi/

