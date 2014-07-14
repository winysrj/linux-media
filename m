Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59224 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbaGNRJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/18] si2157: add read data support for fw cmd func
Date: Mon, 14 Jul 2014 20:08:46 +0300
Message-Id: <1405357739-3570-5-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We want also read data from firmware. Add support for it. Copied from
si2168 driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 74 +++++++++++++++++++++-----------------
 drivers/media/tuners/si2157_priv.h |  3 +-
 2 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 082e80e..a4908ee 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -20,50 +20,52 @@
 static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 {
 	int ret;
-	u8 buf[1];
 	unsigned long timeout;
 
 	mutex_lock(&s->i2c_mutex);
 
-	if (cmd->len) {
+	if (cmd->wlen) {
 		/* write cmd and args for firmware */
-		ret = i2c_master_send(s->client, cmd->args, cmd->len);
+		ret = i2c_master_send(s->client, cmd->args, cmd->wlen);
 		if (ret < 0) {
 			goto err_mutex_unlock;
-		} else if (ret != cmd->len) {
+		} else if (ret != cmd->wlen) {
 			ret = -EREMOTEIO;
 			goto err_mutex_unlock;
 		}
 	}
 
-	/* wait cmd execution terminate */
-	#define TIMEOUT 80
-	timeout = jiffies + msecs_to_jiffies(TIMEOUT);
-	while (!time_after(jiffies, timeout)) {
-		ret = i2c_master_recv(s->client, buf, 1);
-		if (ret < 0) {
-			goto err_mutex_unlock;
-		} else if (ret != 1) {
-			ret = -EREMOTEIO;
-			goto err_mutex_unlock;
+	if (cmd->rlen) {
+		/* wait cmd execution terminate */
+		#define TIMEOUT 80
+		timeout = jiffies + msecs_to_jiffies(TIMEOUT);
+		while (!time_after(jiffies, timeout)) {
+			ret = i2c_master_recv(s->client, cmd->args, cmd->rlen);
+			if (ret < 0) {
+				goto err_mutex_unlock;
+			} else if (ret != cmd->rlen) {
+				ret = -EREMOTEIO;
+				goto err_mutex_unlock;
+			}
+
+			/* firmware ready? */
+			if ((cmd->args[0] >> 7) & 0x01)
+				break;
 		}
 
-		/* firmware ready? */
-		if ((buf[0] >> 7) & 0x01)
-			break;
-	}
+		dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n",
+				__func__,
+				jiffies_to_msecs(jiffies) -
+				(jiffies_to_msecs(timeout) - TIMEOUT));
 
-	dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n", __func__,
-			jiffies_to_msecs(jiffies) -
-			(jiffies_to_msecs(timeout) - TIMEOUT));
-
-	if (!((buf[0] >> 7) & 0x01)) {
-		ret = -ETIMEDOUT;
-		goto err_mutex_unlock;
-	} else {
-		ret = 0;
+		if (!((cmd->args[0] >> 7) & 0x01)) {
+			ret = -ETIMEDOUT;
+			goto err_mutex_unlock;
+		}
 	}
 
+	ret = 0;
+
 err_mutex_unlock:
 	mutex_unlock(&s->i2c_mutex);
 	if (ret)
@@ -97,7 +99,8 @@ static int si2157_sleep(struct dvb_frontend *fe)
 	s->active = false;
 
 	memcpy(cmd.args, "\x13", 1);
-	cmd.len = 1;
+	cmd.wlen = 1;
+	cmd.rlen = 0;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
@@ -141,20 +144,23 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	cmd.args[12] = 0x00;
 	cmd.args[13] = 0x00;
 	cmd.args[14] = 0x01;
-	cmd.len = 15;
+	cmd.wlen = 15;
+	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	cmd.args[0] = 0x02;
-	cmd.len = 1;
+	cmd.wlen = 1;
+	cmd.rlen = 13;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	cmd.args[0] = 0x01;
 	cmd.args[1] = 0x01;
-	cmd.len = 2;
+	cmd.wlen = 2;
+	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
@@ -168,7 +174,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	cmd.args[5] = (c->frequency >>  8) & 0xff;
 	cmd.args[6] = (c->frequency >> 16) & 0xff;
 	cmd.args[7] = (c->frequency >> 24) & 0xff;
-	cmd.len = 8;
+	cmd.wlen = 8;
+	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
@@ -212,7 +219,8 @@ static int si2157_probe(struct i2c_client *client,
 	mutex_init(&s->i2c_mutex);
 
 	/* check if the tuner is there */
-	cmd.len = 0;
+	cmd.wlen = 0;
+	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 6cc6c6f..6db4c97 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -31,7 +31,8 @@ struct si2157 {
 #define SI2157_ARGLEN      30
 struct si2157_cmd {
 	u8 args[SI2157_ARGLEN];
-	unsigned len;
+	unsigned wlen;
+	unsigned rlen;
 };
 
 #endif
-- 
1.9.3

