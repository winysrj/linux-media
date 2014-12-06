Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48417 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/22] si2168: get rid of own struct i2c_client pointer
Date: Sat,  6 Dec 2014 23:34:38 +0200
Message-Id: <1417901696-5517-4-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need that anymore as same pointer is passed to each
routine via struct dvb_frontend private field.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 61 +++++++++++++++----------------
 drivers/media/dvb-frontends/si2168_priv.h |  1 -
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 50674d4..db06bb7 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -29,7 +29,7 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = i2c_master_send(dev->client, cmd->args, cmd->wlen);
+		ret = i2c_master_send(client, cmd->args, cmd->wlen);
 		if (ret < 0) {
 			goto err_mutex_unlock;
 		} else if (ret != cmd->wlen) {
@@ -43,7 +43,7 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 		#define TIMEOUT 50
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = i2c_master_recv(dev->client, cmd->args, cmd->rlen);
+			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
 			if (ret < 0) {
 				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
@@ -56,7 +56,7 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&dev->client->dev, "cmd execution took %d ms\n",
+		dev_dbg(&client->dev, "cmd execution took %d ms\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
@@ -75,7 +75,7 @@ err_mutex_unlock:
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -151,12 +151,12 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
-	dev_dbg(&dev->client->dev, "status=%02x args=%*ph\n",
+	dev_dbg(&client->dev, "status=%02x args=%*ph\n",
 			*status, cmd.rlen, cmd.args);
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -169,7 +169,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	struct si2168_cmd cmd;
 	u8 bandwidth, delivery_system;
 
-	dev_dbg(&dev->client->dev,
+	dev_dbg(&client->dev,
 			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u, stream_id=%d\n",
 			c->delivery_system, c->modulation,
 			c->frequency, c->bandwidth_hz, c->symbol_rate,
@@ -352,7 +352,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -367,7 +367,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	struct si2168_cmd cmd;
 	unsigned int chip_id;
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	/* initialize */
 	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
@@ -430,7 +430,7 @@ static int si2168_init(struct dvb_frontend *fe)
 		fw_file = SI2168_B40_FIRMWARE;
 		break;
 	default:
-		dev_err(&dev->client->dev,
+		dev_err(&client->dev,
 				"unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
@@ -439,31 +439,31 @@ static int si2168_init(struct dvb_frontend *fe)
 	}
 
 	/* cold state - try to download firmware */
-	dev_info(&dev->client->dev, "found a '%s' in cold state\n",
+	dev_info(&client->dev, "found a '%s' in cold state\n",
 			si2168_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &dev->client->dev);
+	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
 		/* fallback mechanism to handle old name for Si2168 B40 fw */
 		if (chip_id == SI2168_B40) {
 			fw_file = SI2168_B40_FIRMWARE_FALLBACK;
-			ret = request_firmware(&fw, fw_file, &dev->client->dev);
+			ret = request_firmware(&fw, fw_file, &client->dev);
 		}
 
 		if (ret == 0) {
-			dev_notice(&dev->client->dev,
+			dev_notice(&client->dev,
 					"please install firmware file '%s'\n",
 					SI2168_B40_FIRMWARE);
 		} else {
-			dev_err(&dev->client->dev,
+			dev_err(&client->dev,
 					"firmware file '%s' not found\n",
 					fw_file);
 			goto error_fw_release;
 		}
 	}
 
-	dev_info(&dev->client->dev, "downloading firmware from file '%s'\n",
+	dev_info(&client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
 	if ((fw->size % 17 == 0) && (fw->data[0] > 5)) {
@@ -475,7 +475,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			cmd.rlen = 1;
 			ret = si2168_cmd_execute(client, &cmd);
 			if (ret) {
-				dev_err(&dev->client->dev,
+				dev_err(&client->dev,
 						"firmware download failed=%d\n",
 						ret);
 				goto error_fw_release;
@@ -493,7 +493,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			cmd.rlen = 1;
 			ret = si2168_cmd_execute(client, &cmd);
 			if (ret) {
-				dev_err(&dev->client->dev,
+				dev_err(&client->dev,
 						"firmware download failed=%d\n",
 						ret);
 				goto error_fw_release;
@@ -519,7 +519,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->client->dev, "firmware version: %c.%c.%d\n",
+	dev_dbg(&client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
 
 	/* set ts mode */
@@ -533,7 +533,7 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	dev->fw_loaded = true;
 
-	dev_info(&dev->client->dev, "found a '%s' in warm state\n",
+	dev_info(&client->dev, "found a '%s' in warm state\n",
 			si2168_ops.info.name);
 warm:
 	dev->active = true;
@@ -543,7 +543,7 @@ warm:
 error_fw_release:
 	release_firmware(fw);
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -554,7 +554,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
 	int ret;
 	struct si2168_cmd cmd;
 
-	dev_dbg(&dev->client->dev, "\n");
+	dev_dbg(&client->dev, "\n");
 
 	dev->active = false;
 
@@ -567,7 +567,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -590,7 +590,7 @@ static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg gate_open_msg = {
-		.addr = dev->client->addr,
+		.addr = client->addr,
 		.flags = 0,
 		.len = 3,
 		.buf = "\xc0\x0d\x01",
@@ -599,9 +599,9 @@ static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 	mutex_lock(&dev->i2c_mutex);
 
 	/* open tuner I2C gate */
-	ret = __i2c_transfer(dev->client->adapter, &gate_open_msg, 1);
+	ret = __i2c_transfer(client->adapter, &gate_open_msg, 1);
 	if (ret != 1) {
-		dev_warn(&dev->client->dev, "i2c write failed=%d\n", ret);
+		dev_warn(&client->dev, "i2c write failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 	} else {
@@ -617,16 +617,16 @@ static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg gate_close_msg = {
-		.addr = dev->client->addr,
+		.addr = client->addr,
 		.flags = 0,
 		.len = 3,
 		.buf = "\xc0\x0d\x00",
 	};
 
 	/* close tuner I2C gate */
-	ret = __i2c_transfer(dev->client->adapter, &gate_close_msg, 1);
+	ret = __i2c_transfer(client->adapter, &gate_close_msg, 1);
 	if (ret != 1) {
-		dev_warn(&dev->client->dev, "i2c write failed=%d\n", ret);
+		dev_warn(&client->dev, "i2c write failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 	} else {
@@ -691,7 +691,6 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	dev->client = client;
 	mutex_init(&dev->i2c_mutex);
 
 	/* create mux i2c adapter for tuner */
@@ -714,7 +713,7 @@ static int si2168_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, dev);
 
-	dev_info(&dev->client->dev,
+	dev_info(&client->dev,
 			"Silicon Labs Si2168 successfully attached\n");
 	return 0;
 err:
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index cb8827a..aadd136 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -29,7 +29,6 @@
 
 /* state struct */
 struct si2168_dev {
-	struct i2c_client *client;
 	struct i2c_adapter *adapter;
 	struct mutex i2c_mutex;
 	struct dvb_frontend fe;
-- 
http://palosaari.fi/

