Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43966 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbaBJQMu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 8/8] rtl2832: implement delayed I2C gate close
Date: Mon, 10 Feb 2014 18:12:33 +0200
Message-Id: <1392048753-13292-9-git-send-email-crope@iki.fi>
In-Reply-To: <1392048753-13292-1-git-send-email-crope@iki.fi>
References: <1392048753-13292-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delay possible I2C gate close a little bit in order to see if there
is next message coming to tuner in a sequence.

Also, export private muxed I2C adapter. That is aimed only for SDR
extension module as SDR belongs to same RTL2832 physical I2C bus (it
is physically property of RTL2832, whilst it is own kernel module).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 92 +++++++++++++++++++++++++++++-
 drivers/media/dvb-frontends/rtl2832.h      | 12 ++++
 drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
 3 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index cfc5438..fdbed35 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -891,16 +891,65 @@ static void rtl2832_release(struct dvb_frontend *fe)
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	cancel_delayed_work_sync(&priv->i2c_gate_work);
 	i2c_del_mux_adapter(priv->i2c_adapter_tuner);
 	i2c_del_mux_adapter(priv->i2c_adapter);
 	kfree(priv);
 }
 
+/*
+ * Delay mechanism to avoid unneeded I2C gate open / close. Gate close is
+ * delayed here a little bit in order to see if there is sequence of I2C
+ * messages sent to same I2C bus.
+ * We must use unlocked version of __i2c_transfer() in order to avoid deadlock
+ * as lock is already taken by calling muxed i2c_transfer().
+ */
+static void rtl2832_i2c_gate_work(struct work_struct *work)
+{
+	struct rtl2832_priv *priv = container_of(work,
+			struct rtl2832_priv, i2c_gate_work.work);
+	struct i2c_adapter *adap = priv->i2c;
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
+
+	/* select reg bank 1 */
+	buf[0] = 0x00;
+	buf[1] = 0x01;
+	ret = __i2c_transfer(adap, msg, 1);
+	if (ret != 1)
+		goto err;
+
+	priv->page = 1;
+
+	/* close I2C repeater gate */
+	buf[0] = 0x01;
+	buf[1] = 0x10;
+	ret = __i2c_transfer(adap, msg, 1);
+	if (ret != 1)
+		goto err;
+
+	priv->i2c_gate_state = 0;
+
+	return;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
+	return;
+}
+
 static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
 	struct rtl2832_priv *priv = mux_priv;
 	int ret;
-	u8 buf[2];
+	u8 buf[2], val;
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
@@ -909,6 +958,22 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 			.buf = buf,
 		}
 	};
+	struct i2c_msg msg_rd[2] = {
+		{
+			.addr = priv->cfg.i2c_addr,
+			.flags = 0,
+			.len = 1,
+			.buf = "\x01",
+		}, {
+			.addr = priv->cfg.i2c_addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = &val,
+		}
+	};
+
+	/* terminate possible gate closing */
+	cancel_delayed_work_sync(&priv->i2c_gate_work);
 
 	if (priv->i2c_gate_state == chan_id)
 		return 0;
@@ -916,13 +981,17 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	/* select reg bank 1 */
 	buf[0] = 0x00;
 	buf[1] = 0x01;
-
 	ret = __i2c_transfer(adap, msg, 1);
 	if (ret != 1)
 		goto err;
 
 	priv->page = 1;
 
+	/* we must read that register, otherwise there will be errors */
+	ret = __i2c_transfer(adap, msg_rd, 2);
+	if (ret != 2)
+		goto err;
+
 	/* open or close I2C repeater gate */
 	buf[0] = 0x01;
 	if (chan_id == 1)
@@ -939,9 +1008,18 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	return 0;
 err:
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+
 	return -EREMOTEIO;
 }
 
+static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
+		u32 chan_id)
+{
+	struct rtl2832_priv *priv = mux_priv;
+	schedule_delayed_work(&priv->i2c_gate_work, usecs_to_jiffies(100));
+	return 0;
+}
+
 struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
@@ -949,6 +1027,13 @@ struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(rtl2832_get_i2c_adapter);
 
+struct i2c_adapter *rtl2832_get_private_i2c_adapter(struct dvb_frontend *fe)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	return priv->i2c_adapter;
+}
+EXPORT_SYMBOL(rtl2832_get_private_i2c_adapter);
+
 struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c)
 {
@@ -967,6 +1052,7 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	priv->i2c = i2c;
 	priv->tuner = cfg->tuner;
 	memcpy(&priv->cfg, cfg, sizeof(struct rtl2832_config));
+	INIT_DELAYED_WORK(&priv->i2c_gate_work, rtl2832_i2c_gate_work);
 
 	/* create muxed i2c adapter for demod itself */
 	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
@@ -981,7 +1067,7 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 
 	/* create muxed i2c adapter for demod tuner bus */
 	priv->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, priv,
-			0, 1, 0, rtl2832_select, NULL);
+			0, 1, 0, rtl2832_select, rtl2832_deselect);
 	if (priv->i2c_adapter_tuner == NULL)
 		goto err;
 
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index a9202d7..cb3b6b0 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -60,6 +60,10 @@ extern struct i2c_adapter *rtl2832_get_i2c_adapter(
 	struct dvb_frontend *fe
 );
 
+extern struct i2c_adapter *rtl2832_get_private_i2c_adapter(
+	struct dvb_frontend *fe
+);
+
 #else
 
 static inline struct dvb_frontend *rtl2832_attach(
@@ -77,6 +81,14 @@ static inline struct i2c_adapter *rtl2832_get_i2c_adapter(
 {
 	return NULL;
 }
+
+static inline struct i2c_adapter *rtl2832_get_private_i2c_adapter(
+	struct dvb_frontend *fe
+)
+{
+	return NULL;
+}
+
 #endif
 
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 8b7c1ae..ae469f0 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -37,6 +37,7 @@ struct rtl2832_priv {
 
 	u8 tuner;
 	u8 page; /* active register page */
+	struct delayed_work i2c_gate_work;
 };
 
 struct rtl2832_reg_entry {
-- 
1.8.5.3

