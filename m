Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52510 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934137AbaKLELh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:11:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/11] mn88472: rename state to dev
Date: Wed, 12 Nov 2014 06:11:11 +0200
Message-Id: <1415765477-23153-6-git-send-email-crope@iki.fi>
In-Reply-To: <1415765477-23153-1-git-send-email-crope@iki.fi>
References: <1415765477-23153-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename state to dev.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c      | 141 +++++++++++++++--------------
 drivers/media/dvb-frontends/mn88472_priv.h |   2 +-
 2 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index a3c4ae1..1d72e02 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -19,7 +19,7 @@
 static struct dvb_frontend_ops mn88472_ops;
 
 /* write multiple registers */
-static int mn88472_wregs(struct mn88472_state *s, u16 reg, const u8 *val, int len)
+static int mn88472_wregs(struct mn88472_dev *dev, u16 reg, const u8 *val, int len)
 {
 #define MAX_WR_LEN 21
 #define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
@@ -40,11 +40,11 @@ static int mn88472_wregs(struct mn88472_state *s, u16 reg, const u8 *val, int le
 	buf[0] = (reg >> 0) & 0xff;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(s->i2c, msg, 1);
+	ret = i2c_transfer(dev->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&s->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c wr failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -54,7 +54,7 @@ static int mn88472_wregs(struct mn88472_state *s, u16 reg, const u8 *val, int le
 }
 
 /* read multiple registers */
-static int mn88472_rregs(struct mn88472_state *s, u16 reg, u8 *val, int len)
+static int mn88472_rregs(struct mn88472_dev *dev, u16 reg, u8 *val, int len)
 {
 #define MAX_RD_LEN 2
 #define MAX_RD_XFER_LEN (MAX_RD_LEN)
@@ -79,12 +79,12 @@ static int mn88472_rregs(struct mn88472_state *s, u16 reg, u8 *val, int len)
 
 	buf[0] = (reg >> 0) & 0xff;
 
-	ret = i2c_transfer(s->i2c, msg, 2);
+	ret = i2c_transfer(dev->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&s->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -94,15 +94,15 @@ static int mn88472_rregs(struct mn88472_state *s, u16 reg, u8 *val, int len)
 }
 
 /* write single register */
-static int mn88472_wreg(struct mn88472_state *s, u16 reg, u8 val)
+static int mn88472_wreg(struct mn88472_dev *dev, u16 reg, u8 val)
 {
-	return mn88472_wregs(s, reg, &val, 1);
+	return mn88472_wregs(dev, reg, &val, 1);
 }
 
 /* read single register */
-static int mn88472_rreg(struct mn88472_state *s, u16 reg, u8 *val)
+static int mn88472_rreg(struct mn88472_dev *dev, u16 reg, u8 *val)
 {
-	return mn88472_rregs(s, reg, val, 1);
+	return mn88472_rregs(dev, reg, val, 1);
 }
 
 static int mn88472_get_tune_settings(struct dvb_frontend *fe,
@@ -114,16 +114,16 @@ static int mn88472_get_tune_settings(struct dvb_frontend *fe,
 
 static int mn88472_set_frontend(struct dvb_frontend *fe)
 {
-	struct mn88472_state *s = fe->demodulator_priv;
+	struct mn88472_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u32 if_frequency = 0;
-	dev_dbg(&s->i2c->dev,
+	dev_dbg(&dev->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
 			__func__, c->delivery_system, c->modulation,
 			c->frequency, c->symbol_rate, c->inversion);
 
-	if (!s->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
@@ -140,96 +140,96 @@ static int mn88472_set_frontend(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
-		dev_dbg(&s->i2c->dev, "%s: get_if_frequency=%d\n",
+		dev_dbg(&dev->i2c->dev, "%s: get_if_frequency=%d\n",
 				__func__, if_frequency);
 	}
 
 	if (if_frequency != 5070000) {
-		dev_err(&s->i2c->dev, "%s: IF frequency %d not supported\n",
+		dev_err(&dev->i2c->dev, "%s: IF frequency %d not supported\n",
 				KBUILD_MODNAME, if_frequency);
 		ret = -EINVAL;
 		goto err;
 	}
 
-	ret = mn88472_wregs(s, 0x1c08, "\x1d", 1);
+	ret = mn88472_wregs(dev, 0x1c08, "\x1d", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18d9, "\xe3", 1);
+	ret = mn88472_wregs(dev, 0x18d9, "\xe3", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1c83, "\x01", 1);
+	ret = mn88472_wregs(dev, 0x1c83, "\x01", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1c00, "\x66\x00\x01\x04\x00", 5);
+	ret = mn88472_wregs(dev, 0x1c00, "\x66\x00\x01\x04\x00", 5);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1c10,
+	ret = mn88472_wregs(dev, 0x1c10,
 			"\x3f\x50\x2c\x8f\x80\x00\x08\xee\x08\xee", 10);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1846, "\x00", 1);
+	ret = mn88472_wregs(dev, 0x1846, "\x00", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18ae, "\x00", 1);
+	ret = mn88472_wregs(dev, 0x18ae, "\x00", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18b0, "\x0b", 1);
+	ret = mn88472_wregs(dev, 0x18b0, "\x0b", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18b4, "\x00", 1);
+	ret = mn88472_wregs(dev, 0x18b4, "\x00", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18cd, "\x17", 1);
+	ret = mn88472_wregs(dev, 0x18cd, "\x17", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18d4, "\x09", 1);
+	ret = mn88472_wregs(dev, 0x18d4, "\x09", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x18d6, "\x48", 1);
+	ret = mn88472_wregs(dev, 0x18d6, "\x48", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1a00, "\xb0", 1);
+	ret = mn88472_wregs(dev, 0x1a00, "\xb0", 1);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1cf8, "\x9f", 1);
+	ret = mn88472_wregs(dev, 0x1cf8, "\x9f", 1);
 	if (ret)
 		goto err;
 
-	s->delivery_system = c->delivery_system;
+	dev->delivery_system = c->delivery_system;
 
 	return 0;
 err:
-	dev_dbg(&s->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct mn88472_state *s = fe->demodulator_priv;
+	struct mn88472_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 u8tmp;
 
 	*status = 0;
 
-	if (!s->warm) {
+	if (!dev->warm) {
 		ret = -EAGAIN;
 		goto err;
 	}
 
-	ret = mn88472_rreg(s, 0x1a84, &u8tmp);
+	ret = mn88472_rreg(dev, 0x1a84, &u8tmp);
 	if (ret)
 		goto err;
 
@@ -239,62 +239,62 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return 0;
 err:
-	dev_dbg(&s->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int mn88472_init(struct dvb_frontend *fe)
 {
-	struct mn88472_state *s = fe->demodulator_priv;
+	struct mn88472_dev *dev = fe->demodulator_priv;
 	int ret, len, remaining;
 	const struct firmware *fw = NULL;
 	u8 *fw_file = MN88472_FIRMWARE;
-	dev_dbg(&s->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
 
 	/* set cold state by default */
-	s->warm = false;
+	dev->warm = false;
 
 	/* power on */
-	ret = mn88472_wreg(s, 0x1c05, 0x00);
+	ret = mn88472_wreg(dev, 0x1c05, 0x00);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wregs(s, 0x1c0b, "\x00\x00", 2);
+	ret = mn88472_wregs(dev, 0x1c0b, "\x00\x00", 2);
 	if (ret)
 		goto err;
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, s->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, dev->i2c->dev.parent);
 	if (ret) {
-		dev_err(&s->i2c->dev, "%s: firmare file '%s' not found\n",
+		dev_err(&dev->i2c->dev, "%s: firmare file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
 		goto err;
 	}
 
-	dev_info(&s->i2c->dev, "%s: downloading firmware from file '%s'\n",
+	dev_info(&dev->i2c->dev, "%s: downloading firmware from file '%s'\n",
 			KBUILD_MODNAME, fw_file);
 
-	ret = mn88472_wreg(s, 0x18f5, 0x03);
+	ret = mn88472_wreg(dev, 0x18f5, 0x03);
 	if (ret)
 		goto err;
 
 	for (remaining = fw->size; remaining > 0;
-			remaining -= (s->cfg->i2c_wr_max - 1)) {
+			remaining -= (dev->cfg->i2c_wr_max - 1)) {
 		len = remaining;
-		if (len > (s->cfg->i2c_wr_max - 1))
-			len = (s->cfg->i2c_wr_max - 1);
+		if (len > (dev->cfg->i2c_wr_max - 1))
+			len = (dev->cfg->i2c_wr_max - 1);
 
-		ret = mn88472_wregs(s, 0x18f6,
+		ret = mn88472_wregs(dev, 0x18f6,
 				&fw->data[fw->size - remaining], len);
 		if (ret) {
-			dev_err(&s->i2c->dev,
+			dev_err(&dev->i2c->dev,
 					"%s: firmware download failed=%d\n",
 					KBUILD_MODNAME, ret);
 			goto err;
 		}
 	}
 
-	ret = mn88472_wreg(s, 0x18f5, 0x00);
+	ret = mn88472_wreg(dev, 0x18f5, 0x00);
 	if (ret)
 		goto err;
 
@@ -302,78 +302,79 @@ static int mn88472_init(struct dvb_frontend *fe)
 	fw = NULL;
 
 	/* warm state */
-	s->warm = true;
+	dev->warm = true;
 
 	return 0;
 err:
 	if (fw)
 		release_firmware(fw);
 
-	dev_dbg(&s->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int mn88472_sleep(struct dvb_frontend *fe)
 {
-	struct mn88472_state *s = fe->demodulator_priv;
+	struct mn88472_dev *dev = fe->demodulator_priv;
 	int ret;
-	dev_dbg(&s->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
 
 	/* power off */
-	ret = mn88472_wreg(s, 0x1c0b, 0x30);
+	ret = mn88472_wreg(dev, 0x1c0b, 0x30);
 	if (ret)
 		goto err;
 
-	ret = mn88472_wreg(s, 0x1c05, 0x3e);
+	ret = mn88472_wreg(dev, 0x1c05, 0x3e);
 	if (ret)
 		goto err;
 
-	s->delivery_system = SYS_UNDEFINED;
+	dev->delivery_system = SYS_UNDEFINED;
 
 	return 0;
 err:
-	dev_dbg(&s->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static void mn88472_release(struct dvb_frontend *fe)
 {
-	struct mn88472_state *s = fe->demodulator_priv;
-	kfree(s);
+	struct mn88472_dev *dev = fe->demodulator_priv;
+
+	kfree(dev);
 }
 
 struct dvb_frontend *mn88472_attach(const struct mn88472_config *cfg,
 		struct i2c_adapter *i2c)
 {
 	int ret;
-	struct mn88472_state *s;
+	struct mn88472_dev *dev;
 	u8 u8tmp;
 	dev_dbg(&i2c->dev, "%s:\n", __func__);
 
 	/* allocate memory for the internal state */
-	s = kzalloc(sizeof(struct mn88472_state), GFP_KERNEL);
-	if (!s) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
 		ret = -ENOMEM;
 		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
 		goto err;
 	}
 
-	s->cfg = cfg;
-	s->i2c = i2c;
+	dev->cfg = cfg;
+	dev->i2c = i2c;
 
 	/* check demod responds to I2C */
-	ret = mn88472_rreg(s, 0x1c00, &u8tmp);
+	ret = mn88472_rreg(dev, 0x1c00, &u8tmp);
 	if (ret)
 		goto err;
 
 	/* create dvb_frontend */
-	memcpy(&s->fe.ops, &mn88472_ops, sizeof(struct dvb_frontend_ops));
-	s->fe.demodulator_priv = s;
+	memcpy(&dev->fe.ops, &mn88472_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = dev;
 
-	return &s->fe;
+	return &dev->fe;
 err:
 	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(s);
+	kfree(dev);
 	return NULL;
 }
 EXPORT_SYMBOL(mn88472_attach);
diff --git a/drivers/media/dvb-frontends/mn88472_priv.h b/drivers/media/dvb-frontends/mn88472_priv.h
index 1aaa25f..be31adb 100644
--- a/drivers/media/dvb-frontends/mn88472_priv.h
+++ b/drivers/media/dvb-frontends/mn88472_priv.h
@@ -25,7 +25,7 @@
 
 #define MN88472_FIRMWARE "dvb-demod-mn88472-02.fw"
 
-struct mn88472_state {
+struct mn88472_dev {
 	struct i2c_adapter *i2c;
 	const struct mn88472_config *cfg;
 	struct dvb_frontend fe;
-- 
http://palosaari.fi/

