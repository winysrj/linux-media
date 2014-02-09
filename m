Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaBIJXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:23:04 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 80/86] rtl2832: add muxed I2C adapter for demod itself
Date: Sun,  9 Feb 2014 10:49:25 +0200
Message-Id: <1391935771-18670-81-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a deadlock between master I2C adapter and muxed I2C
adapter. Implement two I2C muxed I2C adapters and leave master
alone, just only for offering I2C adapter for these mux adapters.

Reported-by: Luis Alves <ljalvs@gmail.com>
Reported-by: Benjamin Larsson <benjamin@southpole.se>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 71 ++++++++++++++++++++++++------
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index dc46cf0..c0366a8 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -180,7 +180,7 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(priv->i2c_adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
@@ -210,7 +210,7 @@ static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(priv->i2c_adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
@@ -891,26 +891,61 @@ static void rtl2832_release(struct dvb_frontend *fe)
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	i2c_del_mux_adapter(priv->i2c_adapter_tuner);
 	i2c_del_mux_adapter(priv->i2c_adapter);
 	kfree(priv);
 }
 
-static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
 	struct rtl2832_priv *priv = mux_priv;
-	return rtl2832_i2c_gate_ctrl(&priv->fe, 1);
-}
+	int ret;
+	u8 buf[2];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = priv->cfg.i2c_addr,
+			.flags = 0,
+			.len = sizeof(buf),
+			.buf = buf,
+		}
+	};
 
-static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
-{
-	struct rtl2832_priv *priv = mux_priv;
-	return rtl2832_i2c_gate_ctrl(&priv->fe, 0);
+	if (priv->i2c_gate_state == chan_id)
+		return 0;
+
+	/* select reg bank 1 */
+	buf[0] = 0x00;
+	buf[1] = 0x01;
+
+	ret = i2c_transfer(adap, msg, 1);
+	if (ret != 1)
+		goto err;
+
+	priv->page = 1;
+
+	/* open or close I2C repeater gate */
+	buf[0] = 0x01;
+	if (chan_id == 1)
+		buf[1] = 0x18; /* open */
+	else
+		buf[1] = 0x10; /* close */
+
+	ret = i2c_transfer(adap, msg, 1);
+	if (ret != 1)
+		goto err;
+
+	priv->i2c_gate_state = chan_id;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return -EREMOTEIO;
 }
 
 struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
-	return priv->i2c_adapter;
+	return priv->i2c_adapter_tuner;
 }
 EXPORT_SYMBOL(rtl2832_get_i2c_adapter);
 
@@ -933,15 +968,21 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	priv->tuner = cfg->tuner;
 	memcpy(&priv->cfg, cfg, sizeof(struct rtl2832_config));
 
+	/* create muxed i2c adapter for demod itself */
+	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
+			rtl2832_select, NULL);
+	if (priv->i2c_adapter == NULL)
+		goto err;
+
 	/* check if the demod is there */
 	ret = rtl2832_rd_reg(priv, 0x00, 0x0, &tmp);
 	if (ret)
 		goto err;
 
-	/* create muxed i2c adapter */
-	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
-			rtl2832_select, rtl2832_deselect);
-	if (priv->i2c_adapter == NULL)
+	/* create muxed i2c adapter for demod tuner bus */
+	priv->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, priv,
+			0, 1, 0, rtl2832_select, NULL);
+	if (priv->i2c_adapter_tuner == NULL)
 		goto err;
 
 	/* create dvb_frontend */
@@ -954,6 +995,8 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	return &priv->fe;
 err:
 	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	if (priv && priv->i2c_adapter)
+		i2c_del_mux_adapter(priv->i2c_adapter);
 	kfree(priv);
 	return NULL;
 }
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index ec26c92..8b7c1ae 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -28,6 +28,7 @@
 struct rtl2832_priv {
 	struct i2c_adapter *i2c;
 	struct i2c_adapter *i2c_adapter;
+	struct i2c_adapter *i2c_adapter_tuner;
 	struct dvb_frontend fe;
 	struct rtl2832_config cfg;
 
-- 
1.8.5.3

