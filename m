Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34722 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/22] si2168: carry pointer to client instead of state
Date: Sat,  6 Dec 2014 23:34:37 +0200
Message-Id: <1417901696-5517-3-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carry struct i2c_client pointer inside struct dvb_frontend private
pointer. This driver is I2C driver, which is represented as a
struct i2c_client, so better to carry this top level structure for
each routine in order to unify things. This allows further
simplification.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 83 +++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 38 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index e989bd4..50674d4 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -19,8 +19,9 @@
 static const struct dvb_frontend_ops si2168_ops;
 
 /* execute firmware command */
-static int si2168_cmd_execute(struct si2168_dev *dev, struct si2168_cmd *cmd)
+static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 {
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	unsigned long timeout;
 
@@ -80,7 +81,8 @@ err:
 
 static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct si2168_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
@@ -113,7 +115,7 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -160,7 +162,8 @@ err:
 
 static int si2168_set_frontend(struct dvb_frontend *fe)
 {
-	struct si2168_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2168_cmd cmd;
@@ -217,7 +220,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x88\x02\x02\x02\x02", 5);
 	cmd.wlen = 5;
 	cmd.rlen = 5;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -230,7 +233,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		memcpy(cmd.args, "\x89\x21\x06\x11\x89\x20", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 3;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -241,7 +244,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		cmd.args[2] = c->stream_id == NO_STREAM_ID_FILTER ? 0 : 1;
 		cmd.wlen = 3;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(dev, &cmd);
+		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
 	}
@@ -249,35 +252,35 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x51\x03", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 12;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x12\x08\x04", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 3;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x0c\x10\x12\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x06\x10\x24\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x07\x10\x00\x24", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -285,7 +288,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	cmd.args[4] = delivery_system | bandwidth;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -296,7 +299,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		cmd.args[5] = ((c->symbol_rate / 1000) >> 8) & 0xff;
 		cmd.wlen = 6;
 		cmd.rlen = 4;
-		ret = si2168_cmd_execute(dev, &cmd);
+		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
 	}
@@ -304,7 +307,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -312,7 +315,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	cmd.args[5] |= dev->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -320,28 +323,28 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	cmd.args[5] |= dev->ts_clock_inv ? 0x00 : 0x10;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x12\x00\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x85", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -355,7 +358,8 @@ err:
 
 static int si2168_init(struct dvb_frontend *fe)
 {
-	struct si2168_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file;
@@ -369,7 +373,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
 	cmd.wlen = 13;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -378,14 +382,14 @@ static int si2168_init(struct dvb_frontend *fe)
 		memcpy(cmd.args, "\xc0\x06\x08\x0f\x00\x20\x21\x01", 8);
 		cmd.wlen = 8;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(dev, &cmd);
+		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
 
 		memcpy(cmd.args, "\x85", 1);
 		cmd.wlen = 1;
 		cmd.rlen = 1;
-		ret = si2168_cmd_execute(dev, &cmd);
+		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
 
@@ -396,7 +400,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\xc0\x06\x01\x0f\x00\x20\x20\x01", 8);
 	cmd.wlen = 8;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -404,7 +408,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 13;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -469,7 +473,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
-			ret = si2168_cmd_execute(dev, &cmd);
+			ret = si2168_cmd_execute(client, &cmd);
 			if (ret) {
 				dev_err(&dev->client->dev,
 						"firmware download failed=%d\n",
@@ -487,7 +491,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			memcpy(cmd.args, &fw->data[fw->size - remaining], len);
 			cmd.wlen = len;
 			cmd.rlen = 1;
-			ret = si2168_cmd_execute(dev, &cmd);
+			ret = si2168_cmd_execute(client, &cmd);
 			if (ret) {
 				dev_err(&dev->client->dev,
 						"firmware download failed=%d\n",
@@ -503,7 +507,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -511,7 +515,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x11", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 10;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -523,7 +527,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	cmd.args[4] |= dev->ts_mode;
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -545,7 +549,8 @@ err:
 
 static int si2168_sleep(struct dvb_frontend *fe)
 {
-	struct si2168_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct si2168_cmd cmd;
 
@@ -556,7 +561,7 @@ static int si2168_sleep(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x13", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute(dev, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -581,7 +586,8 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
  */
 static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct si2168_dev *dev = mux_priv;
+	struct i2c_client *client = mux_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg gate_open_msg = {
 		.addr = dev->client->addr,
@@ -607,7 +613,8 @@ static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 
 static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct si2168_dev *dev = mux_priv;
+	struct i2c_client *client = mux_priv;
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg gate_close_msg = {
 		.addr = dev->client->addr,
@@ -688,8 +695,8 @@ static int si2168_probe(struct i2c_client *client,
 	mutex_init(&dev->i2c_mutex);
 
 	/* create mux i2c adapter for tuner */
-	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev, dev,
-			0, 0, 0, si2168_select, si2168_deselect);
+	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+			client, 0, 0, 0, si2168_select, si2168_deselect);
 	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err;
@@ -697,7 +704,7 @@ static int si2168_probe(struct i2c_client *client,
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
-	dev->fe.demodulator_priv = dev;
+	dev->fe.demodulator_priv = client;
 
 	*config->i2c_adapter = dev->adapter;
 	*config->fe = &dev->fe;
-- 
http://palosaari.fi/

