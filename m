Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58015 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964950AbcCOQyk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 12:54:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Peter Rosin <peda@axentia.se>
Subject: [PATCH] si2168: add lock to cmd execute
Date: Tue, 15 Mar 2016 18:54:19 +0200
Message-Id: <1458060859-3517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro do not apply that patch, it is fix for Peter I2C-mux serie!

Peter, please meld that fix to main patch:
[media] si2168: declare that the i2c gate is self-locked

We need lock to make sure only single caller could execute firmware
command at the time. Earlier there was manual I2C locking which did
the same job.

Cc: Peter Rosin <peda@axentia.se>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 21 ++++++++++++++-------
 drivers/media/dvb-frontends/si2168_priv.h |  1 +
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 4a9b73b..786808f 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -21,17 +21,20 @@ static const struct dvb_frontend_ops si2168_ops;
 /* execute firmware command */
 static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 {
+	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	unsigned long timeout;
 
+	mutex_lock(&dev->i2c_mutex);
+
 	if (cmd->wlen) {
 		/* write cmd and args for firmware */
 		ret = i2c_master_send(client, cmd->args, cmd->wlen);
 		if (ret < 0) {
-			goto err;
+			goto err_mutex_unlock;
 		} else if (ret != cmd->wlen) {
 			ret = -EREMOTEIO;
-			goto err;
+			goto err_mutex_unlock;
 		}
 	}
 
@@ -42,10 +45,10 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 		while (!time_after(jiffies, timeout)) {
 			ret = i2c_master_recv(client, cmd->args, cmd->rlen);
 			if (ret < 0) {
-				goto err;
+				goto err_mutex_unlock;
 			} else if (ret != cmd->rlen) {
 				ret = -EREMOTEIO;
-				goto err;
+				goto err_mutex_unlock;
 			}
 
 			/* firmware ready? */
@@ -60,17 +63,19 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
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
@@ -658,6 +663,8 @@ static int si2168_probe(struct i2c_client *client,
 		goto err;
 	}
 
+	mutex_init(&dev->i2c_mutex);
+
 	/* create mux i2c adapter for tuner */
 	dev->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0,
 					I2C_MUX_SELF_LOCKED, 0, 0, 0,
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 165bf14..8a1f36d 100644
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
http://palosaari.fi/

