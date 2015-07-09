Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36535 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/12] tda10071: protect firmware command exec with mutex
Date: Thu,  9 Jul 2015 07:06:30 +0300
Message-Id: <1436414792-9716-10-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There should be clearly some lock in order to make sure firmware
command in execution is not disturbed by another command. It has
worked as callbacks are serialized somehow pretty well and command
execution happens usually without any delays.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 12 +++++++++---
 drivers/media/dvb-frontends/tda10071_priv.h |  1 +
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index c1507cc..c8feb58 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -62,15 +62,17 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 		goto error;
 	}
 
+	mutex_lock(&dev->cmd_execute_mutex);
+
 	/* write cmd and args for firmware */
 	ret = regmap_bulk_write(dev->regmap, 0x00, cmd->args, cmd->len);
 	if (ret)
-		goto error;
+		goto error_mutex_unlock;
 
 	/* start cmd execution */
 	ret = regmap_write(dev->regmap, 0x1f, 1);
 	if (ret)
-		goto error;
+		goto error_mutex_unlock;
 
 	/* wait cmd execution terminate */
 	#define CMD_EXECUTE_TIMEOUT 30
@@ -78,8 +80,9 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 	for (uitmp = 1; !time_after(jiffies, timeout) && uitmp;) {
 		ret = regmap_read(dev->regmap, 0x1f, &uitmp);
 		if (ret)
-			goto error;
+			goto error_mutex_unlock;
 	}
+	mutex_unlock(&dev->cmd_execute_mutex);
 
 	dev_dbg(&client->dev, "cmd execution took %u ms\n",
 		jiffies_to_msecs(jiffies) -
@@ -91,6 +94,8 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 	}
 
 	return ret;
+error_mutex_unlock:
+	mutex_unlock(&dev->cmd_execute_mutex);
 error:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -1170,6 +1175,7 @@ static int tda10071_probe(struct i2c_client *client,
 	}
 
 	dev->client = client;
+	mutex_init(&dev->cmd_execute_mutex);
 	dev->clk = pdata->clk;
 	dev->i2c_wr_max = pdata->i2c_wr_max;
 	dev->ts_mode = pdata->ts_mode;
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 30143c8..cf5b433 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -30,6 +30,7 @@ struct tda10071_dev {
 	struct dvb_frontend fe;
 	struct i2c_client *client;
 	struct regmap *regmap;
+	struct mutex cmd_execute_mutex;
 	u32 clk;
 	u16 i2c_wr_max;
 	u8 ts_mode;
-- 
http://palosaari.fi/

