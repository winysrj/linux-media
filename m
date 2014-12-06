Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54043 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaLFVfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/22] si2157: carry pointer to client instead of state in tuner_priv
Date: Sat,  6 Dec 2014 23:34:50 +0200
Message-Id: <1417901696-5517-16-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carry struct i2c_client pointer in tuner_priv. This driver is I2C driver,
which is represented as a struct i2c_client, so better to carry this top
level structure for each routine in order to unify things.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 78 +++++++++++++++++++-------------------
 drivers/media/tuners/si2157_priv.h |  1 -
 2 files changed, 38 insertions(+), 41 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index f7c3867..88afb2a 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -19,8 +19,9 @@
 static const struct dvb_tuner_ops si2157_ops;
 
 /* execute firmware command */
-static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
+static int si2157_cmd_execute(struct i2c_client *client, struct si2157_cmd *cmd)
 {
+	struct si2157_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	unsigned long timeout;
 
@@ -28,7 +29,7 @@ static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
 
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = i2c_master_send(dev->client, cmd->args, cmd->wlen);
+		ret = i2c_master_send(client, cmd->args, cmd->wlen);
 		if (ret < 0) {
 			goto err_mutex_unlock;
 		} else if (ret != cmd->wlen) {
@@ -42,7 +43,7 @@ static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
 		#define TIMEOUT 80
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = i2c_master_recv(dev->client, cmd->args, cmd->rlen);
+			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
 			if (ret < 0) {
 				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
@@ -55,7 +56,7 @@ static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&dev->client->dev, "cmd execution took %d ms\n",
+		dev_dbg(&client->dev, "cmd execution took %d ms\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
@@ -70,20 +71,21 @@ static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
 
 err_mutex_unlock:
 	mutex_unlock(&dev->i2c_mutex);
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_init(struct dvb_frontend *fe)
 {
-	struct si2157_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	struct si2157_cmd cmd;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
 	unsigned int chip_id;
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	if (dev->fw_loaded)
 		goto warm;
@@ -97,7 +99,7 @@ static int si2157_init(struct dvb_frontend *fe)
 		cmd.wlen = 15;
 	}
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -105,7 +107,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 13;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -128,8 +130,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2146_A10:
 		goto skip_fw_download;
 	default:
-		dev_err(&dev->client->dev,
-				"unknown chip version Si21%d-%c%c%c\n",
+		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
 		ret = -EINVAL;
@@ -137,26 +138,26 @@ static int si2157_init(struct dvb_frontend *fe)
 	}
 
 	/* cold state - try to download firmware */
-	dev_info(&dev->client->dev, "found a '%s' in cold state\n",
+	dev_info(&client->dev, "found a '%s' in cold state\n",
 			si2157_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &dev->client->dev);
+	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
-		dev_err(&dev->client->dev, "firmware file '%s' not found\n",
+		dev_err(&client->dev, "firmware file '%s' not found\n",
 				fw_file);
 		goto err;
 	}
 
 	/* firmware should be n chunks of 17 bytes */
 	if (fw->size % 17 != 0) {
-		dev_err(&dev->client->dev, "firmware file '%s' is invalid\n",
+		dev_err(&client->dev, "firmware file '%s' is invalid\n",
 				fw_file);
 		ret = -EINVAL;
 		goto fw_release_exit;
 	}
 
-	dev_info(&dev->client->dev, "downloading firmware from file '%s'\n",
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
@@ -164,10 +165,9 @@ static int si2157_init(struct dvb_frontend *fe)
 		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 		cmd.wlen = len;
 		cmd.rlen = 1;
-		ret = si2157_cmd_execute(dev, &cmd);
+		ret = si2157_cmd_execute(client, &cmd);
 		if (ret) {
-			dev_err(&dev->client->dev,
-					"firmware download failed=%d\n",
+			dev_err(&client->dev, "firmware download failed %d\n",
 					ret);
 			goto fw_release_exit;
 		}
@@ -181,7 +181,7 @@ skip_fw_download:
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -194,17 +194,18 @@ warm:
 fw_release_exit:
 	release_firmware(fw);
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_sleep(struct dvb_frontend *fe)
 {
-	struct si2157_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct si2157_cmd cmd;
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	dev->active = false;
 
@@ -212,28 +213,28 @@ static int si2157_sleep(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x16\x00", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_set_params(struct dvb_frontend *fe)
 {
-	struct si2157_dev *dev = fe->tuner_priv;
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2157_cmd cmd;
 	u8 bandwidth, delivery_system;
 
-	dev_dbg(&dev->client->dev,
+	dev_dbg(&client->dev,
 			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
-			c->delivery_system, c->frequency,
-			c->bandwidth_hz);
+			c->delivery_system, c->frequency, c->bandwidth_hz);
 
 	if (!dev->active) {
 		ret = -EAGAIN;
@@ -274,7 +275,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		cmd.args[5] = 0x01;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -284,7 +285,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -296,13 +297,13 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	cmd.args[7] = (c->frequency >> 24) & 0xff;
 	cmd.wlen = 8;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -341,7 +342,7 @@ static int si2157_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev->client = client;
+	i2c_set_clientdata(client, dev);
 	dev->fe = cfg->fe;
 	dev->inversion = cfg->inversion;
 	dev->fw_loaded = false;
@@ -351,17 +352,14 @@ static int si2157_probe(struct i2c_client *client,
 	/* check if the tuner is there */
 	cmd.wlen = 0;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(dev, &cmd);
+	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
-	fe->tuner_priv = dev;
 	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = client;
 
-	i2c_set_clientdata(client, dev);
-
-	dev_info(&dev->client->dev,
-			"Silicon Labs %s successfully attached\n",
+	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
 			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
 			"Si2146" : "Si2147/2148/2157/2158");
 
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 8f6cfc0..7aa53bc 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -23,7 +23,6 @@
 /* state struct */
 struct si2157_dev {
 	struct mutex i2c_mutex;
-	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	bool active;
 	bool fw_loaded;
-- 
http://palosaari.fi/

