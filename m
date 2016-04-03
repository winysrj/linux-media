Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:34855 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbcDCI5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 04:57:37 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: linux-kernel@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Peter Rosin <peda@axentia.se>,
	Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH v6 21/24] [media] si2168: change the i2c gate to be mux-locked
Date: Sun,  3 Apr 2016 10:52:51 +0200
Message-Id: <1459673574-11440-22-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Palosaari <crope@iki.fi>

The root i2c adapter lock is then no longer held by the i2c mux during
accesses behind the i2c gate, and such accesses need to take that lock
just like any other ordinary i2c accesses do.

So, declare the i2c gate mux-locked, and zap the code that makes the
i2c accesses unlocked. But add a mutex so that firmware commands are
still serialized.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Peter Rosin <peda@axentia.se>
---
 Documentation/i2c/i2c-topology            |  2 +-
 drivers/media/dvb-frontends/si2168.c      | 85 ++++++++-----------------------
 drivers/media/dvb-frontends/si2168_priv.h |  1 +
 3 files changed, 23 insertions(+), 65 deletions(-)

diff --git a/Documentation/i2c/i2c-topology b/Documentation/i2c/i2c-topology
index 346623a80bd1..a9ca97df7661 100644
--- a/Documentation/i2c/i2c-topology
+++ b/Documentation/i2c/i2c-topology
@@ -56,7 +56,7 @@ In drivers/media/
 dvb-frontends/m88ds3103   Parent-locked
 dvb-frontends/rtl2830     Parent-locked
 dvb-frontends/rtl2832     Parent-locked
-dvb-frontends/si2168      Parent-locked
+dvb-frontends/si2168      Mux-locked
 usb/cx231xx/              Parent-locked
 
 
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index ca455d01c71d..2eecbb2ef48e 100644
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
+					I2C_MUX_LOCKED, 0, 0, 0,
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

