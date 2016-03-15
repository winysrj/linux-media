Return-path: <linux-media-owner@vger.kernel.org>
Received: from axentia.se ([87.96.186.132]:9426 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbcCOThl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 15:37:41 -0400
From: Peter Rosin <peda@axentia.se>
To: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] si2168: add lock to cmd execute
Date: Tue, 15 Mar 2016 19:35:28 +0000
Message-ID: <ed61fdb0633a4e14a3d48291ae7ae87f@EMAIL.axentia.se>
References: <1458060859-3517-1-git-send-email-crope@iki.fi>
In-Reply-To: <1458060859-3517-1-git-send-email-crope@iki.fi>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti!

Antti Palosaari wrote:
> Mauro do not apply that patch, it is fix for Peter I2C-mux serie!

Still true with the below patch  :-)

> Peter, please meld that fix to main patch:
> [media] si2168: declare that the i2c gate is self-locked
> 
> We need lock to make sure only single caller could execute firmware
> command at the time. Earlier there was manual I2C locking which did
> the same job.

Right, the squashed thing I have in the mux series after this is the below
patch. I simply put you as author of the whole thing and added your sign-off,
since my contribution added up to a trivial one-liner rename or something
like that, and the commit message. Holler if this is not what you intended.

Thanks,
Peter

From: Antti Palosaari <crope@iki.fi>
Date: Tue, 15 Mar 2016 20:20:11 +0100
Subject: [PATCH] [media] si2168: declare that the i2c gate is self-locked

When the i2c adapter lock is no longer held by the i2c mux during
accesses behind the i2c gate, such accesses need to take that lock
just like any other ordinary i2c accesses do.

So, declare the i2c gate self-locked, and zap the code that makes the
i2c accesses unlocked. But add a mutex so that firmware commands are
still serialized.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/si2168.c      | 85 ++++++++-----------------------
 drivers/media/dvb-frontends/si2168_priv.h |  1 +
 2 files changed, 22 insertions(+), 64 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index ca455d01c71d..786808f923e5 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -18,53 +18,23 @@
 
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
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	unsigned long timeout;
 
+	mutex_lock(&dev->i2c_mutex);
+
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = si2168_i2c_master_send_unlocked(client, cmd->args,
-						      cmd->wlen);
+		ret = i2c_master_send(client, cmd->args, cmd->wlen);
 		if (ret < 0) {
-			goto err;
+			goto err_mutex_unlock;
 		} else if (ret != cmd->wlen) {
 			ret = -EREMOTEIO;
-			goto err;
+			goto err_mutex_unlock;
 		}
 	}
 
@@ -73,13 +43,12 @@ static int si2168_cmd_execute_unlocked(struct i2c_client *client,
 		#define TIMEOUT 70
 		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
 		while (!time_after(jiffies, timeout)) {
-			ret = si2168_i2c_master_recv_unlocked(client, cmd->args,
-							      cmd->rlen);
+			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
 			if (ret < 0) {
-				goto err;
+				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
 				ret = -EREMOTEIO;
-				goto err;
+				goto err_mutex_unlock;
 			}
 
 			/* firmware ready? */
@@ -94,32 +63,23 @@ static int si2168_cmd_execute_unlocked(struct i2c_client *client,
 		/* error bit set? */
 		if ((cmd->args[0] >> 6) & 0x01) {
 			ret = -EREMOTEIO;
-			goto err;
+			goto err_mutex_unlock;
 		}
 
 		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
-			goto err;
+			goto err_mutex_unlock;
 		}
 	}
 
+	mutex_unlock(&dev->i2c_mutex);
 	return 0;
-err:
+err_mutex_unlock:
+	mutex_unlock(&dev->i2c_mutex);
 	dev_dbg(&client->dev, "failed=%d\n", ret);
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
@@ -610,11 +570,6 @@ static int si2168_get_tune_settings(struct dvb_frontend *fe,
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
@@ -625,7 +580,7 @@ static int si2168_select(struct i2c_mux_core *muxc, u32 chan)
 	memcpy(cmd.args, "\xc0\x0d\x01", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -645,7 +600,7 @@ static int si2168_deselect(struct i2c_mux_core *muxc, u32 chan)
 	memcpy(cmd.args, "\xc0\x0d\x00", 3);
 	cmd.wlen = 3;
 	cmd.rlen = 0;
-	ret = si2168_cmd_execute_unlocked(client, &cmd);
+	ret = si2168_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
 
@@ -708,9 +663,11 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	mutex_init(&dev->i2c_mutex);
+
 	/* create mux i2c adapter for tuner */
-	dev->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
-					0, 0, 0,
+	dev->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0,
+					I2C_MUX_SELF_LOCKED, 0, 0, 0,
 					si2168_select, si2168_deselect);
 	if (IS_ERR(dev->muxc)) {
 		ret = PTR_ERR(dev->muxc);
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 165bf1412063..8a1f36d2014d 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -29,6 +29,7 @@
 
 /* state struct */
 struct si2168_dev {
+	struct mutex i2c_mutex;
 	struct i2c_mux_core *muxc;
 	struct dvb_frontend fe;
 	enum fe_delivery_system delivery_system;
-- 
2.1.4

