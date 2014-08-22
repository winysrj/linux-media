Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46473 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbaHVK62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:28 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 02/21] si2157: clean logging
Date: Fri, 22 Aug 2014 13:57:54 +0300
Message-Id: <1408705093-5167-3-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Same thing for si2157 as Antti did earlier for tda18212:

There is no need to print module name nor function name as those
are done by kernel logging system when dev_xxx logging is used and
driver is proper I2C driver.

While here, fix a typo ("unknown") in si2157_init.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 52 +++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 6c53edb..2281b7d 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -55,8 +55,7 @@ static int si2157_cmd_execute(struct si2157 *s, struct si2157_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&s->client->dev, "%s: cmd execution took %d ms\n",
-				__func__,
+		dev_dbg(&s->client->dev, "cmd execution took %d ms\n",
 				jiffies_to_msecs(jiffies) -
 				(jiffies_to_msecs(timeout) - TIMEOUT));
 
@@ -75,7 +74,7 @@ err_mutex_unlock:
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -88,7 +87,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	u8 *fw_file;
 	unsigned int chip_id;
 
-	dev_dbg(&s->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "\n");
 
 	/* configure? */
 	memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
@@ -121,35 +120,35 @@ static int si2157_init(struct dvb_frontend *fe)
 		break;
 	default:
 		dev_err(&s->client->dev,
-				"%s: unkown chip version Si21%d-%c%c%c\n",
-				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
+				"unknown chip version Si21%d-%c%c%c\n",
+				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
 		ret = -EINVAL;
 		goto err;
 	}
 
 	/* cold state - try to download firmware */
-	dev_info(&s->client->dev, "%s: found a '%s' in cold state\n",
-			KBUILD_MODNAME, si2157_ops.info.name);
+	dev_info(&s->client->dev, "found a '%s' in cold state\n",
+			si2157_ops.info.name);
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &s->client->dev);
 	if (ret) {
-		dev_err(&s->client->dev, "%s: firmware file '%s' not found\n",
-				KBUILD_MODNAME, fw_file);
+		dev_err(&s->client->dev, "firmware file '%s' not found\n",
+				fw_file);
 		goto err;
 	}
 
 	/* firmware should be n chunks of 17 bytes */
 	if (fw->size % 17 != 0) {
-		dev_err(&s->client->dev, "%s: firmware file '%s' is invalid\n",
-				KBUILD_MODNAME, fw_file);
+		dev_err(&s->client->dev, "firmware file '%s' is invalid\n",
+				fw_file);
 		ret = -EINVAL;
 		goto err;
 	}
 
-	dev_info(&s->client->dev, "%s: downloading firmware from file '%s'\n",
-			KBUILD_MODNAME, fw_file);
+	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
+			fw_file);
 
 	for (remaining = fw->size; remaining > 0; remaining -= 17) {
 		len = fw->data[fw->size - remaining];
@@ -159,8 +158,8 @@ static int si2157_init(struct dvb_frontend *fe)
 		ret = si2157_cmd_execute(s, &cmd);
 		if (ret) {
 			dev_err(&s->client->dev,
-					"%s: firmware download failed=%d\n",
-					KBUILD_MODNAME, ret);
+					"firmware download failed=%d\n",
+					ret);
 			goto err;
 		}
 	}
@@ -184,7 +183,7 @@ err:
 	if (fw)
 		release_firmware(fw);
 
-	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -194,7 +193,7 @@ static int si2157_sleep(struct dvb_frontend *fe)
 	int ret;
 	struct si2157_cmd cmd;
 
-	dev_dbg(&s->client->dev, "%s:\n", __func__);
+	dev_dbg(&s->client->dev, "\n");
 
 	s->active = false;
 
@@ -207,7 +206,7 @@ static int si2157_sleep(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -220,8 +219,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	u8 bandwidth, delivery_system;
 
 	dev_dbg(&s->client->dev,
-			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
-			__func__, c->delivery_system, c->frequency,
+			"delivery_system=%d frequency=%u bandwidth_hz=%u\n",
+			c->delivery_system, c->frequency,
 			c->bandwidth_hz);
 
 	if (!s->active) {
@@ -275,7 +274,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -310,7 +309,7 @@ static int si2157_probe(struct i2c_client *client,
 	s = kzalloc(sizeof(struct si2157), GFP_KERNEL);
 	if (!s) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
@@ -333,11 +332,10 @@ static int si2157_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, s);
 
 	dev_info(&s->client->dev,
-			"%s: Silicon Labs Si2157/Si2158 successfully attached\n",
-			KBUILD_MODNAME);
+			"Silicon Labs Si2157/Si2158 successfully attached\n");
 	return 0;
 err:
-	dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	kfree(s);
 
 	return ret;
@@ -348,7 +346,7 @@ static int si2157_remove(struct i2c_client *client)
 	struct si2157 *s = i2c_get_clientdata(client);
 	struct dvb_frontend *fe = s->fe;
 
-	dev_dbg(&client->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
-- 
http://palosaari.fi/

