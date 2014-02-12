Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60986 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaBLTky (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:40:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 3/3] tda10071: coding style issues
Date: Wed, 12 Feb 2014 21:40:40 +0200
Message-Id: <1392234040-14198-3-git-send-email-crope@iki.fi>
In-Reply-To: <1392234040-14198-1-git-send-email-crope@iki.fi>
References: <1392234040-14198-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some coding style issues, mostly reported by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 60 +++++++++++++++++++---------------
 drivers/media/dvb-frontends/tda10071.h |  2 +-
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 13c823a..522fe00 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -42,8 +42,8 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 
 	if (1 + len > sizeof(buf)) {
 		dev_warn(&priv->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+				"%s: i2c wr reg=%04x: len=%d is too big!\n",
+				KBUILD_MODNAME, reg, len);
 		return -EINVAL;
 	}
 
@@ -54,8 +54,9 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -83,8 +84,8 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 
 	if (len > sizeof(buf)) {
 		dev_warn(&priv->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+				"%s: i2c wr reg=%04x: len=%d is too big!\n",
+				KBUILD_MODNAME, reg, len);
 		return -EINVAL;
 	}
 
@@ -93,8 +94,9 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
-				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&priv->i2c->dev,
+				"%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -667,11 +669,11 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
 
-	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d modulation=%d " \
-		"frequency=%d symbol_rate=%d inversion=%d pilot=%d " \
-		"rolloff=%d\n", __func__, c->delivery_system, c->modulation,
-		c->frequency, c->symbol_rate, c->inversion, c->pilot,
-		c->rolloff);
+	dev_dbg(&priv->i2c->dev,
+			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
+			__func__, c->delivery_system, c->modulation,
+			c->frequency, c->symbol_rate, c->inversion, c->pilot,
+			c->rolloff);
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -951,10 +953,8 @@ static int tda10071_init(struct dvb_frontend *fe)
 		/* request the firmware, this will block and timeout */
 		ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
 		if (ret) {
-			dev_err(&priv->i2c->dev, "%s: did not find the " \
-					"firmware file. (%s) Please see " \
-					"linux/Documentation/dvb/ for more " \
-					"details on firmware-problems. (%d)\n",
+			dev_err(&priv->i2c->dev,
+					"%s: did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)\n",
 					KBUILD_MODNAME, fw_file, ret);
 			goto error;
 		}
@@ -984,11 +984,12 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error_release_firmware;
 
-		dev_info(&priv->i2c->dev, "%s: found a '%s' in cold state, " \
-				"will try to load a firmware\n", KBUILD_MODNAME,
-				tda10071_ops.info.name);
-		dev_info(&priv->i2c->dev, "%s: downloading firmware from " \
-				"file '%s'\n", KBUILD_MODNAME, fw_file);
+		dev_info(&priv->i2c->dev,
+				"%s: found a '%s' in cold state, will try to load a firmware\n",
+				KBUILD_MODNAME, tda10071_ops.info.name);
+		dev_info(&priv->i2c->dev,
+				"%s: downloading firmware from file '%s'\n",
+				KBUILD_MODNAME, fw_file);
 
 		/* do not download last byte */
 		fw_size = fw->size - 1;
@@ -1002,8 +1003,8 @@ static int tda10071_init(struct dvb_frontend *fe)
 			ret = tda10071_wr_regs(priv, 0xfa,
 				(u8 *) &fw->data[fw_size - remaining], len);
 			if (ret) {
-				dev_err(&priv->i2c->dev, "%s: firmware " \
-						"download failed=%d\n",
+				dev_err(&priv->i2c->dev,
+						"%s: firmware download failed=%d\n",
 						KBUILD_MODNAME, ret);
 				goto error_release_firmware;
 			}
@@ -1067,12 +1068,17 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error;
 
+		if (priv->cfg.tuner_i2c_addr)
+			tmp = priv->cfg.tuner_i2c_addr;
+		else
+			tmp = 0x14;
+
 		cmd.args[0] = CMD_TUNER_INIT;
 		cmd.args[1] = 0x00;
 		cmd.args[2] = 0x00;
 		cmd.args[3] = 0x00;
 		cmd.args[4] = 0x00;
-		cmd.args[5] = (priv->cfg.tuner_i2c_addr) ? priv->cfg.tuner_i2c_addr : 0x14;
+		cmd.args[5] = tmp;
 		cmd.args[6] = 0x00;
 		cmd.args[7] = 0x03;
 		cmd.args[8] = 0x02;
@@ -1212,14 +1218,14 @@ struct dvb_frontend *tda10071_attach(const struct tda10071_config *config,
 
 	/* make sure demod i2c address is specified */
 	if (!config->demod_i2c_addr) {
-		dev_dbg(&i2c->dev, "%s: invalid demod i2c address!\n", __func__);
+		dev_dbg(&i2c->dev, "%s: invalid demod i2c address\n", __func__);
 		ret = -EINVAL;
 		goto error;
 	}
 
 	/* make sure tuner i2c address is specified */
 	if (!config->tuner_i2c_addr) {
-		dev_dbg(&i2c->dev, "%s: invalid tuner i2c address!\n", __func__);
+		dev_dbg(&i2c->dev, "%s: invalid tuner i2c address\n", __func__);
 		ret = -EINVAL;
 		goto error;
 	}
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index f9542f6..331b5a8 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -79,7 +79,7 @@ extern struct dvb_frontend *tda10071_attach(
 static inline struct dvb_frontend *tda10071_attach(
 	const struct tda10071_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
-- 
1.8.5.3

