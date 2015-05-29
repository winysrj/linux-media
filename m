Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42822 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbbE2VFc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2015 17:05:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Adam Baker <linux@baker-net.org.uk>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] si2168: Implement own I2C adapter locking
Date: Sat, 30 May 2015 00:05:09 +0300
Message-Id: <1432933510-19028-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need own I2C locking because of tuner I2C adapter/repeater.
Firmware command is executed using I2C send + reply message. Default
I2C adapter locking protects only single I2C operation, not whole
send + reply sequence as needed. Due to that, it was possible tuner
I2C message interrupts firmware command sequence.

Reported-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 135 +++++++++++++++++-------------
 drivers/media/dvb-frontends/si2168_priv.h |   1 -
 2 files changed, 79 insertions(+), 57 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index b68ab34..93c166a 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -18,23 +18,53 @@
 
 static const struct dvb_frontend_ops si2168_ops;
 
+/* Own I2C adapter locking is needed because of I2C gate logic. */
+int si2168_i2c_master_send_unlocked(const struct i2c_client *client,
+				    const char *buf, int count)
+{
+	int ret;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = 0,
+		.len = count,
+		.buf = (char *)buf,
+	};
+
+	ret = __i2c_transfer(client->adapter, &msg, 1);
+	return (ret == 1) ? count : ret;
+}
+
+int si2168_i2c_master_recv_unlocked(const struct i2c_client *client,
+				    char *buf, int count)
+{
+	int ret;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = I2C_M_RD,
+		.len = count,
+		.buf = buf,
+	};
+
+	ret = __i2c_transfer(client->adapter, &msg, 1);
+	return (ret == 1) ? count : ret;
+}
+
 /* execute firmware command */
-static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
+static int si2168_cmd_execute_unlocked(struct i2c_client *client,
+				       struct si2168_cmd *cmd)
 {
-	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	unsigned long timeout;
 
-	mutex_lock(&dev->i2c_mutex);
-
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = i2c_master_send(client, cmd->args, cmd->wlen);
+		ret = si2168_i2c_master_send_unlocked(client, cmd->args,
+						      cmd->wlen);
 		if (ret < 0) {
-			goto err_mutex_unlock;
+			goto err;
 		} else if (ret != cmd->wlen) {
 			ret = -EREMOTEIO;
-			goto err_mutex_unlock;
+			goto err;
 		}
 	}
 
@@ -43,12 +73,13 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 		#define TIMEOUT 70
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
+			ret = si2168_i2c_master_recv_unlocked(client, cmd->args,
+							      cmd->rlen);
 			if (ret < 0) {
-				goto err_mutex_unlock;
+				goto err;
 			} else if (ret != cmd->rlen) {
 				ret = -EREMOTEIO;
-				goto err_mutex_unlock;
+				goto err;
 			}
 
 			/* firmware ready? */
@@ -63,24 +94,32 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 		/* error bit set? */
 		if ((cmd->args[0] >> 6) & 0x01) {
 			ret = -EREMOTEIO;
-			goto err_mutex_unlock;
+			goto err;
 		}
 
 		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
-			goto err_mutex_unlock;
+			goto err;
 		}
 	}
 
-	mutex_unlock(&dev->i2c_mutex);
 	return 0;
-
-err_mutex_unlock:
-	mutex_unlock(&dev->i2c_mutex);
+err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
+static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
+{
+	int ret;
+
+	i2c_lock_adapter(client->adapter);
+	ret = si2168_cmd_execute_unlocked(client, cmd);
+	i2c_unlock_adapter(client->adapter);
+
+	return ret;
+}
+
 static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
@@ -569,60 +608,46 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
 
 /*
  * I2C gate logic
- * We must use unlocked i2c_transfer() here because I2C lock is already taken
- * by tuner driver.
+ * We must use unlocked I2C I/O because I2C adapter lock is already taken
+ * by the caller (usually tuner driver).
  */
 static int si2168_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
 	struct i2c_client *client = mux_priv;
-	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	struct i2c_msg gate_open_msg = {
-		.addr = client->addr,
-		.flags = 0,
-		.len = 3,
-		.buf = "\xc0\x0d\x01",
-	};
-
-	mutex_lock(&dev->i2c_mutex);
+	struct si2168_cmd cmd;
 
-	/* open tuner I2C gate */
-	ret = __i2c_transfer(client->adapter, &gate_open_msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c write failed=%d\n", ret);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-	} else {
-		ret = 0;
-	}
+	/* open I2C gate */
+	memcpy(cmd.args, "\xc0\x0d\x01", 3);
+	cmd.wlen = 3;
+	cmd.rlen = 0;
+	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	if (ret)
+		goto err;
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int si2168_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
 	struct i2c_client *client = mux_priv;
-	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
-	struct i2c_msg gate_close_msg = {
-		.addr = client->addr,
-		.flags = 0,
-		.len = 3,
-		.buf = "\xc0\x0d\x00",
-	};
-
-	/* close tuner I2C gate */
-	ret = __i2c_transfer(client->adapter, &gate_close_msg, 1);
-	if (ret != 1) {
-		dev_warn(&client->dev, "i2c write failed=%d\n", ret);
-		if (ret >= 0)
-			ret = -EREMOTEIO;
-	} else {
-		ret = 0;
-	}
+	struct si2168_cmd cmd;
 
-	mutex_unlock(&dev->i2c_mutex);
+	/* close I2C gate */
+	memcpy(cmd.args, "\xc0\x0d\x00", 3);
+	cmd.wlen = 3;
+	cmd.rlen = 0;
+	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	if (ret)
+		goto err;
 
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -679,8 +704,6 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
-	mutex_init(&dev->i2c_mutex);
-
 	/* create mux i2c adapter for tuner */
 	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
 			client, 0, 0, 0, si2168_select, si2168_deselect);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index d2589e3..90b6b6e 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -30,7 +30,6 @@
 /* state struct */
 struct si2168_dev {
 	struct i2c_adapter *adapter;
-	struct mutex i2c_mutex;
 	struct dvb_frontend fe;
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
-- 
http://palosaari.fi/

