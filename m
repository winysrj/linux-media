Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59713 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcAFFme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 00:42:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Peter Rosin <peda@axentia.se>,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH] si2168: use i2c controlled mux interface
Date: Wed,  6 Jan 2016 07:42:00 +0200
Message-Id: <1452058920-9797-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent i2c mux locking update offers support for i2c controlled i2c
muxes. Use it and get the rid of homemade hackish i2c adapter
locking code.

Cc: Peter Rosin <peda@axentia.se>
Cc: Peter Rosin <peda@lysator.liu.se>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 61 ++++--------------------------------
 1 file changed, 6 insertions(+), 55 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index ae217b5..d2a5608 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -18,48 +18,15 @@
 
 static const struct dvb_frontend_ops si2168_ops;
 
-/* Own I2C adapter locking is needed because of I2C gate logic. */
-static int si2168_i2c_master_send_unlocked(const struct i2c_client *client,
-					   const char *buf, int count)
-{
-	int ret;
-	struct i2c_msg msg = {
-		.addr = client->addr,
-		.flags = 0,
-		.len = count,
-		.buf = (char *)buf,
-	};
-
-	ret = __i2c_transfer(client->adapter, &msg, 1);
-	return (ret == 1) ? count : ret;
-}
-
-static int si2168_i2c_master_recv_unlocked(const struct i2c_client *client,
-					   char *buf, int count)
-{
-	int ret;
-	struct i2c_msg msg = {
-		.addr = client->addr,
-		.flags = I2C_M_RD,
-		.len = count,
-		.buf = buf,
-	};
-
-	ret = __i2c_transfer(client->adapter, &msg, 1);
-	return (ret == 1) ? count : ret;
-}
-
 /* execute firmware command */
-static int si2168_cmd_execute_unlocked(struct i2c_client *client,
-				       struct si2168_cmd *cmd)
+static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 {
 	int ret;
 	unsigned long timeout;
 
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = si2168_i2c_master_send_unlocked(client, cmd->args,
-						      cmd->wlen);
+		ret = i2c_master_send(client, cmd->args, cmd->wlen);
 		if (ret < 0) {
 			goto err;
 		} else if (ret != cmd->wlen) {
@@ -73,8 +40,7 @@ static int si2168_cmd_execute_unlocked(struct i2c_client *client,
 		#define TIMEOUT 70
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = si2168_i2c_master_recv_unlocked(client, cmd->args,
-							      cmd->rlen);
+			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
 			if (ret < 0) {
 				goto err;
 			} else if (ret != cmd->rlen) {
@@ -109,17 +75,6 @@ err:
 	return ret;
 }
 
-static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
-{
-	int ret;
-
-	i2c_lock_adapter(client->adapter);
-	ret = si2168_cmd_execute_unlocked(client, cmd);
-	i2c_unlock_adapter(client->adapter);
-
-	return ret;
-}
-
 static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
@@ -610,11 +565,6 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-/*
- * I2C gate logic
- * We must use unlocked I2C I/O because I2C adapter lock is already taken
- * by the caller (usually tuner driver).
- */
 static int si2168_select(struct i2c_mux_core *muxc, u32 chan)
 {
 	struct i2c_client *client = i2c_mux_priv(muxc);
@@ -625,7 +575,7 @@ static int si2168_select(struct i2c_mux_core *muxc, u32 chan)
 	memcpy(cmd.args, "\xc0\x0d\x01", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -645,7 +595,7 @@ static int si2168_deselect(struct i2c_mux_core *muxc, u32 chan)
 	memcpy(cmd.args, "\xc0\x0d\x00", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -717,6 +667,7 @@ static int si2168_probe(struct i2c_client *client,
 	dev->muxc->parent = client->adapter;
 	dev->muxc->select = si2168_select;
 	dev->muxc->deselect = si2168_deselect;
+	dev->muxc->i2c_controlled = true;
 
 	/* create mux i2c adapter for tuner */
 	ret = i2c_add_mux_adapter(dev->muxc, 0, 0, 0);
-- 
http://palosaari.fi/

