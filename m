Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57071 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaLFVfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/22] si2157: rename device state variable from 's' to 'dev'
Date: Sat,  6 Dec 2014 23:34:48 +0200
Message-Id: <1417901696-5517-14-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'dev' is likely most common name in kernel for structure containing
device state instance, so rename it in order to keep things
consistent.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 118 ++++++++++++++++++-------------------
 drivers/media/tuners/si2157_priv.h |   2 +-
 2 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 2180de9..14d2f73 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -19,16 +19,16 @@
 static const struct dvb_tuner_ops si2157_ops;
 
 /* execute firmware command */
-static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
+static int si2157_cmd_execute(struct si2157_dev *dev, struct si2157_cmd *cmd)
 {
 	int ret;
 	unsigned long timeout;
 
-	mutex_lock(&s->i2c_mutex);
+	mutex_lock(&dev->i2c_mutex);
 
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = i2c_master_send(s->client, cmd->args, cmd->wlen);
+		ret = i2c_master_send(dev->client, cmd->args, cmd->wlen);
 		if (ret < 0) {
 			goto err_mutex_unlock;
 		} else if (ret != cmd->wlen) {
@@ -42,7 +42,7 @@ static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 		#define TIMEOUT 80
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
+			ret = i2c_master_recv(dev->client, cmd->args, cmd->rlen);
 			if (ret < 0) {
 				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
@@ -55,7 +55,7 @@ static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&s->client->dev, "cmd execution took %d ms\n",
+		dev_dbg(&dev->client->dev, "cmd execution took %d ms\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
@@ -68,32 +68,32 @@ static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 	ret = 0;
 
 err_mutex_unlock:
-	mutex_unlock(&s->i2c_mutex);
+	mutex_unlock(&dev->i2c_mutex);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_init(struct dvb_frontend *fe)
 {
-	struct si2157 *s = fe->tuner_priv;
+	struct si2157_dev *dev = fe->tuner_priv;
 	int ret, len, remaining;
 	struct si2157_cmd cmd;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
 	unsigned int chip_id;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&dev->client->dev, "\n");
 
-	if (s->fw_loaded)
+	if (dev->fw_loaded)
 		goto warm;
 
 	/* power up */
-	if (s->chiptype == SI2157_CHIPTYPE_SI2146) {
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
 		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
 		cmd.wlen = 9;
 	} else {
@@ -101,7 +101,7 @@ static int si2157_init(struct dvb_frontend *fe)
 		cmd.wlen = 15;
 	}
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -109,7 +109,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 13;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -132,7 +132,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2146_A10:
 		goto skip_fw_download;
 	default:
-		dev_err(&s->client->dev,
+		dev_err(&dev->client->dev,
 				"unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
@@ -141,26 +141,26 @@ static int si2157_init(struct dvb_frontend *fe)
 	}
 
 	/* cold state - try to download firmware */
-	dev_info(&s->client->dev, "found a '%s' in cold state\n",
+	dev_info(&dev->client->dev, "found a '%s' in cold state\n",
 			si2157_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &s->client->dev);
+	ret = request_firmware(&fw, fw_file, &dev->client->dev);
 	if (ret) {
-		dev_err(&s->client->dev, "firmware file '%s' not found\n",
+		dev_err(&dev->client->dev, "firmware file '%s' not found\n",
 				fw_file);
 		goto err;
 	}
 
 	/* firmware should be n chunks of 17 bytes */
 	if (fw->size % 17 != 0) {
-		dev_err(&s->client->dev, "firmware file '%s' is invalid\n",
+		dev_err(&dev->client->dev, "firmware file '%s' is invalid\n",
 				fw_file);
 		ret = -EINVAL;
 		goto fw_release_exit;
 	}
 
-	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
+	dev_info(&dev->client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
@@ -168,9 +168,9 @@ static int si2157_init(struct dvb_frontend *fe)
 		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 		cmd.wlen = len;
 		cmd.rlen = 1;
-		ret = si2157_cmd_execute(s, &cmd);
+		ret = si2157_cmd_execute(dev, &cmd);
 		if (ret) {
-			dev_err(&s->client->dev,
+			dev_err(&dev->client->dev,
 					"firmware download failed=%d\n",
 					ret);
 			goto fw_release_exit;
@@ -185,61 +185,61 @@ skip_fw_download:
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	s->fw_loaded = true;
+	dev->fw_loaded = true;
 
 warm:
-	s->active = true;
+	dev->active = true;
 	return 0;
 
 fw_release_exit:
 	release_firmware(fw);
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_sleep(struct dvb_frontend *fe)
 {
-	struct si2157 *s = fe->tuner_priv;
+	struct si2157_dev *dev = fe->tuner_priv;
 	int ret;
 	struct si2157_cmd cmd;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&dev->client->dev, "\n");
 
-	s->active = false;
+	dev->active = false;
 
 	/* standby */
 	memcpy(cmd.args, "\x16\x00", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2157_set_params(struct dvb_frontend *fe)
 {
-	struct si2157 *s = fe->tuner_priv;
+	struct si2157_dev *dev = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2157_cmd cmd;
 	u8 bandwidth, delivery_system;
 
-	dev_dbg(&s->client->dev,
+	dev_dbg(&dev->client->dev,
 			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
 			c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
-	if (!s->active) {
+	if (!dev->active) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -274,21 +274,21 @@ static int si2157_set_params(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x03\x07\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
-	if (s->inversion)
+	if (dev->inversion)
 		cmd.args[5] = 0x01;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	if (s->chiptype == SI2157_CHIPTYPE_SI2146)
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2146)
 		memcpy(cmd.args, "\x14\x00\x02\x07\x00\x01", 6);
 	else
 		memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -300,13 +300,13 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	cmd.args[7] = (c->frequency >> 24) & 0xff;
 	cmd.wlen = 8;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -334,60 +334,58 @@ static int si2157_probe(struct i2c_client *client,
 {
 	struct si2157_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
-	struct si2157 *s;
+	struct si2157_dev *dev;
 	struct si2157_cmd cmd;
 	int ret;
 
-	s = kzalloc(sizeof(struct si2157), GFP_KERNEL);
-	if (!s) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	s->client = client;
-	s->fe = cfg->fe;
-	s->inversion = cfg->inversion;
-	s->fw_loaded = false;
-	s->chiptype = (u8)id->driver_data;
-	mutex_init(&s->i2c_mutex);
+	dev->client = client;
+	dev->fe = cfg->fe;
+	dev->inversion = cfg->inversion;
+	dev->fw_loaded = false;
+	dev->chiptype = (u8)id->driver_data;
+	mutex_init(&dev->i2c_mutex);
 
 	/* check if the tuner is there */
 	cmd.wlen = 0;
 	cmd.rlen = 1;
-	ret = si2157_cmd_execute(s, &cmd);
+	ret = si2157_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	fe->tuner_priv = s;
-	memcpy(&fe->ops.tuner_ops, &si2157_ops,
-			sizeof(struct dvb_tuner_ops));
+	fe->tuner_priv = dev;
+	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
 
-	i2c_set_clientdata(client, s);
+	i2c_set_clientdata(client, dev);
 
-	dev_info(&s->client->dev,
+	dev_info(&dev->client->dev,
 			"Silicon Labs %s successfully attached\n",
-			s->chiptype == SI2157_CHIPTYPE_SI2146 ?
+			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
 			"Si2146" : "Si2147/2148/2157/2158");
 
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	kfree(s);
-
+	kfree(dev);
 	return ret;
 }
 
 static int si2157_remove(struct i2c_client *client)
 {
-	struct si2157 *s = i2c_get_clientdata(client);
-	struct dvb_frontend *fe = s->fe;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+	struct dvb_frontend *fe = dev->fe;
 
 	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-	kfree(s);
+	kfree(dev);
 
 	return 0;
 }
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6e07cd..8f6cfc0 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -21,7 +21,7 @@
 #include "si2157.h"
 
 /* state struct */
-struct si2157 {
+struct si2157_dev {
 	struct mutex i2c_mutex;
 	struct i2c_client *client;
 	struct dvb_frontend *fe;
-- 
http://palosaari.fi/

