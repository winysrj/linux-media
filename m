Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47341 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/22] si2168: rename device state variable from 's' to 'dev'
Date: Sat,  6 Dec 2014 23:34:36 +0200
Message-Id: <1417901696-5517-2-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'dev' is most common name in kernel for structure containing device
state instance, so rename it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 202 +++++++++++++++---------------
 drivers/media/dvb-frontends/si2168_priv.h |   2 +-
 2 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index acf0fc3..e989bd4 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -19,16 +19,16 @@
 static const struct dvb_frontend_ops si2168_ops;
 
 /* execute firmware command */
-static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
+static int si2168_cmd_execute(struct si2168_dev *dev, struct si2168_cmd *cmd)
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
@@ -42,7 +42,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
 		#define TIMEOUT 50
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
+			ret = i2c_master_recv(dev->client, cmd->args, cmd->rlen);
 			if (ret < 0) {
 				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
@@ -55,7 +55,7 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&s->client->dev, "cmd execution took %d ms\n",
+		dev_dbg(&dev->client->dev, "cmd execution took %d ms\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
@@ -68,26 +68,26 @@ static int si2168_cmd_execute(struct si2168 *s, struct si2168_cmd *cmd)
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
 
 static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct si2168 *s = fe->demodulator_priv;
+	struct si2168_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
 
 	*status = 0;
 
-	if (!s->active) {
+	if (!dev->active) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -113,7 +113,7 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -138,7 +138,7 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		break;
 	}
 
-	s->fe_status = *status;
+	dev->fe_status = *status;
 
 	if (*status & FE_HAS_LOCK) {
 		c->cnr.len = 1;
@@ -149,30 +149,30 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
-	dev_dbg(&s->client->dev, "status=%02x args=%*ph\n",
+	dev_dbg(&dev->client->dev, "status=%02x args=%*ph\n",
 			*status, cmd.rlen, cmd.args);
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2168_set_frontend(struct dvb_frontend *fe)
 {
-	struct si2168 *s = fe->demodulator_priv;
+	struct si2168_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
 	u8 bandwidth, delivery_system;
 
-	dev_dbg(&s->client->dev,
+	dev_dbg(&dev->client->dev,
 			"delivery_system=%u modulation=%u frequency=%u bandwidth_hz=%u symbol_rate=%u inversion=%u, stream_id=%d\n",
 			c->delivery_system, c->modulation,
 			c->frequency, c->bandwidth_hz, c->symbol_rate,
 			c->inversion, c->stream_id);
 
-	if (!s->active) {
+	if (!dev->active) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -217,7 +217,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x88\x02\x02\x02\x02", 5);
 	cmd.wlen = 5;
 	cmd.rlen = 5;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -230,7 +230,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		memcpy(cmd.args, "\x89\x21\x06\x11\x89\x20", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 3;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -241,7 +241,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;
 		cmd.wlen = 3;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(s, &cmd);
+		ret = si2168_cmd_execute(dev, &cmd);
 		if (ret)
 			goto err;
 	}
@@ -249,35 +249,35 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x51\x03", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 12;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x12\x08\x04", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 3;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x0c\x10\x12\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x06\x10\x24\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x07\x10\x00\x24", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -285,7 +285,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	cmd.args[4] = delivery_system | bandwidth;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -296,7 +296,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		cmd.args[5] = ((c->symbol_rate / 1000) >> 8) & 0xff;
 		cmd.wlen = 6;
 		cmd.rlen = 4;
-		ret = si2168_cmd_execute(s, &cmd);
+		ret = si2168_cmd_execute(dev, &cmd);
 		if (ret)
 			goto err;
 	}
@@ -304,58 +304,58 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x08", 6);
-	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
+	cmd.args[5] |= dev->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x05", 6);
-	cmd.args[5] |= s->ts_clock_inv ? 0x00 : 0x10;
+	cmd.args[5] |= dev->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x12\x00\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x85", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	s->delivery_system = c->delivery_system;
+	dev->delivery_system = c->delivery_system;
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2168_init(struct dvb_frontend *fe)
 {
-	struct si2168 *s = fe->demodulator_priv;
+	struct si2168_dev *dev = fe->demodulator_priv;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
@@ -363,29 +363,29 @@ static int si2168_init(struct dvb_frontend *fe)
 	struct si2168_cmd cmd;
 	unsigned int chip_id;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&dev->client->dev, "\n");
 
 	/* initialize */
 	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
 	cmd.wlen = 13;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	if (s->fw_loaded) {
+	if (dev->fw_loaded) {
 		/* resume */
 		memcpy(cmd.args, "\xc0\x06\x08\x0f\x00\x20\x21\x01", 8);
 		cmd.wlen = 8;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(s, &cmd);
+		ret = si2168_cmd_execute(dev, &cmd);
 		if (ret)
 			goto err;
 
 		memcpy(cmd.args, "\x85", 1);
 		cmd.wlen = 1;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(s, &cmd);
+		ret = si2168_cmd_execute(dev, &cmd);
 		if (ret)
 			goto err;
 
@@ -396,7 +396,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\xc0\x06\x01\x0f\x00\x20\x20\x01", 8);
 	cmd.wlen = 8;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -404,7 +404,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 13;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -426,7 +426,7 @@ static int si2168_init(struct dvb_frontend *fe)
 		fw_file = SI2168_B40_FIRMWARE;
 		break;
 	default:
-		dev_err(&s->client->dev,
+		dev_err(&dev->client->dev,
 				"unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
@@ -435,31 +435,31 @@ static int si2168_init(struct dvb_frontend *fe)
 	}
 
 	/* cold state - try to download firmware */
-	dev_info(&s->client->dev, "found a '%s' in cold state\n",
+	dev_info(&dev->client->dev, "found a '%s' in cold state\n",
 			si2168_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, &s->client->dev);
+	ret = request_firmware(&fw, fw_file, &dev->client->dev);
 	if (ret) {
 		/* fallback mechanism to handle old name for Si2168 B40 fw */
 		if (chip_id == SI2168_B40) {
 			fw_file = SI2168_B40_FIRMWARE_FALLBACK;
-			ret = request_firmware(&fw, fw_file, &s->client->dev);
+			ret = request_firmware(&fw, fw_file, &dev->client->dev);
 		}
 
 		if (ret == 0) {
-			dev_notice(&s->client->dev,
+			dev_notice(&dev->client->dev,
 					"please install firmware file '%s'\n",
 					SI2168_B40_FIRMWARE);
 		} else {
-			dev_err(&s->client->dev,
+			dev_err(&dev->client->dev,
 					"firmware file '%s' not found\n",
 					fw_file);
 			goto error_fw_release;
 		}
 	}
 
-	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
+	dev_info(&dev->client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
 	if ((fw->size % 17 == 0) && (fw->data[0] > 5)) {
@@ -469,9 +469,9 @@ static int si2168_init(struct dvb_frontend *fe)
 			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
-			ret = si2168_cmd_execute(s, &cmd);
+			ret = si2168_cmd_execute(dev, &cmd);
 			if (ret) {
-				dev_err(&s->client->dev,
+				dev_err(&dev->client->dev,
 						"firmware download failed=%d\n",
 						ret);
 				goto error_fw_release;
@@ -487,9 +487,9 @@ static int si2168_init(struct dvb_frontend *fe)
 			memcpy(cmd.args, &fw->data[fw->size - remaining], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
-			ret = si2168_cmd_execute(s, &cmd);
+			ret = si2168_cmd_execute(dev, &cmd);
 			if (ret) {
-				dev_err(&s->client->dev,
+				dev_err(&dev->client->dev,
 						"firmware download failed=%d\n",
 						ret);
 				goto error_fw_release;
@@ -503,7 +503,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
@@ -511,58 +511,58 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x11", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 10;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	dev_dbg(&s->client->dev, "firmware version: %c.%c.%d\n",
+	dev_dbg(&dev->client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
 
 	/* set ts mode */
 	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
-	cmd.args[4] |= s->ts_mode;
+	cmd.args[4] |= dev->ts_mode;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
-	s->fw_loaded = true;
+	dev->fw_loaded = true;
 
-	dev_info(&s->client->dev, "found a '%s' in warm state\n",
+	dev_info(&dev->client->dev, "found a '%s' in warm state\n",
 			si2168_ops.info.name);
 warm:
-	s->active = true;
+	dev->active = true;
 
 	return 0;
 
 error_fw_release:
 	release_firmware(fw);
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2168_sleep(struct dvb_frontend *fe)
 {
-	struct si2168 *s = fe->demodulator_priv;
+	struct si2168_dev *dev = fe->demodulator_priv;
 	int ret;
 	struct si2168_cmd cmd;
 
-	dev_dbg(&s->client->dev, "\n");
+	dev_dbg(&dev->client->dev, "\n");
 
-	s->active = false;
+	dev->active = false;
 
 	memcpy(cmd.args, "\x13", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute(s, &cmd);
+	ret = si2168_cmd_execute(dev, &cmd);
 	if (ret)
 		goto err;
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "failed=%d\n", ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -581,21 +581,21 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
  */
 static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct si2168 *s = mux_priv;
+	struct si2168_dev *dev = mux_priv;
 	int ret;
 	struct i2c_msg gate_open_msg = {
-		.addr = s->client->addr,
+		.addr = dev->client->addr,
 		.flags = 0,
 		.len = 3,
 		.buf = "\xc0\x0d\x01",
 	};
 
-	mutex_lock(&s->i2c_mutex);
+	mutex_lock(&dev->i2c_mutex);
 
 	/* open tuner I2C gate */
-	ret = __i2c_transfer(s->client->adapter, &gate_open_msg, 1);
+	ret = __i2c_transfer(dev->client->adapter, &gate_open_msg, 1);
 	if (ret != 1) {
-		dev_warn(&s->client->dev, "i2c write failed=%d\n", ret);
+		dev_warn(&dev->client->dev, "i2c write failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 	} else {
@@ -607,26 +607,26 @@ static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 
 static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct si2168 *s = mux_priv;
+	struct si2168_dev *dev = mux_priv;
 	int ret;
 	struct i2c_msg gate_close_msg = {
-		.addr = s->client->addr,
+		.addr = dev->client->addr,
 		.flags = 0,
 		.len = 3,
 		.buf = "\xc0\x0d\x00",
 	};
 
 	/* close tuner I2C gate */
-	ret = __i2c_transfer(s->client->adapter, &gate_close_msg, 1);
+	ret = __i2c_transfer(dev->client->adapter, &gate_close_msg, 1);
 	if (ret != 1) {
-		dev_warn(&s->client->dev, "i2c write failed=%d\n", ret);
+		dev_warn(&dev->client->dev, "i2c write failed=%d\n", ret);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 	} else {
 		ret = 0;
 	}
 
-	mutex_unlock(&s->i2c_mutex);
+	mutex_unlock(&dev->i2c_mutex);
 
 	return ret;
 }
@@ -672,62 +672,62 @@ static int si2168_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct si2168_config *config = client->dev.platform_data;
-	struct si2168 *s;
+	struct si2168_dev *dev;
 	int ret;
 
 	dev_dbg(&client->dev, "\n");
 
-	s = kzalloc(sizeof(struct si2168), GFP_KERNEL);
-	if (!s) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-	s->client = client;
-	mutex_init(&s->i2c_mutex);
+	dev->client = client;
+	mutex_init(&dev->i2c_mutex);
 
 	/* create mux i2c adapter for tuner */
-	s->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, s,
+	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, dev,
 			0, 0, 0, si2168_select, si2168_deselect);
-	if (s->adapter == NULL) {
+	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err;
 	}
 
 	/* create dvb_frontend */
-	memcpy(&s->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
-	s->fe.demodulator_priv = s;
+	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = dev;
 
-	*config->i2c_adapter = s->adapter;
-	*config->fe = &s->fe;
-	s->ts_mode = config->ts_mode;
-	s->ts_clock_inv = config->ts_clock_inv;
-	s->fw_loaded = false;
+	*config->i2c_adapter = dev->adapter;
+	*config->fe = &dev->fe;
+	dev->ts_mode = config->ts_mode;
+	dev->ts_clock_inv = config->ts_clock_inv;
+	dev->fw_loaded = false;
 
-	i2c_set_clientdata(client, s);
+	i2c_set_clientdata(client, dev);
 
-	dev_info(&s->client->dev,
+	dev_info(&dev->client->dev,
 			"Silicon Labs Si2168 successfully attached\n");
 	return 0;
 err:
-	kfree(s);
+	kfree(dev);
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2168_remove(struct i2c_client *client)
 {
-	struct si2168 *s = i2c_get_clientdata(client);
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	i2c_del_mux_adapter(s->adapter);
+	i2c_del_mux_adapter(dev->adapter);
 
-	s->fe.ops.release = NULL;
-	s->fe.demodulator_priv = NULL;
+	dev->fe.ops.release = NULL;
+	dev->fe.demodulator_priv = NULL;
 
-	kfree(s);
+	kfree(dev);
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 60bc334..cb8827a 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -28,7 +28,7 @@
 #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
 
 /* state struct */
-struct si2168 {
+struct si2168_dev {
 	struct i2c_client *client;
 	struct i2c_adapter *adapter;
 	struct mutex i2c_mutex;
-- 
http://palosaari.fi/

