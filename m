Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39735 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbaKRHVi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 02:21:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 1/6] rtl2832: implement option to bypass slave demod TS
Date: Tue, 18 Nov 2014 09:20:38 +0200
Message-Id: <1416295243-27300-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement partial PIP mode to carry TS from slave demodulator,
through that master demodulator. RTL2832 demod has TS input
interface to connected another demodulator TS output.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 60 +++++++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/rtl2832.h | 11 +++++++
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index eb737cf..9026e1a 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -258,13 +258,11 @@ static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
 	return rtl2832_rd(priv, reg, val, len);
 }
 
-#if 0 /* currently not used */
 /* write single register */
 static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 val)
 {
 	return rtl2832_wr_regs(priv, reg, page, &val, 1);
 }
-#endif
 
 /* read single register */
 static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
@@ -599,6 +597,11 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
+	/* PIP mode related */
+	ret = rtl2832_wr_regs(priv, 0x92, 1, "\x00\x0f\xff", 3);
+	if (ret)
+		goto err;
+
 	/* If the frontend has get_if_frequency(), use it */
 	if (fe->ops.tuner_ops.get_if_frequency) {
 		u32 if_freq;
@@ -661,7 +664,6 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-
 	/* soft reset */
 	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
 	if (ret)
@@ -1020,6 +1022,58 @@ static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
 	return 0;
 }
 
+int rtl2832_enable_external_ts_if(struct dvb_frontend *fe)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret;
+
+	dev_dbg(&priv->i2c->dev, "%s: setting PIP mode\n", __func__);
+
+	ret = rtl2832_wr_regs(priv, 0x0c, 1, "\x5f\xff", 2);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_demod_reg(priv, DVBT_PIP_ON, 0x1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(priv, 0xbc, 0, 0x18);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(priv, 0x22, 0, 0x01);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(priv, 0x26, 0, 0x1f);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_reg(priv, 0x27, 0, 0xff);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_regs(priv, 0x92, 1, "\x7f\xf7\xff", 3);
+	if (ret)
+		goto err;
+
+	/* soft reset */
+	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
+	if (ret)
+		goto err;
+
+	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+
+}
+EXPORT_SYMBOL(rtl2832_enable_external_ts_if);
+
 struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
 {
 	struct rtl2832_priv *priv = fe->demodulator_priv;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index cb3b6b0..5254c1d 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -64,6 +64,10 @@ extern struct i2c_adapter *rtl2832_get_private_i2c_adapter(
 	struct dvb_frontend *fe
 );
 
+extern int rtl2832_enable_external_ts_if(
+	struct dvb_frontend *fe
+);
+
 #else
 
 static inline struct dvb_frontend *rtl2832_attach(
@@ -89,6 +93,13 @@ static inline struct i2c_adapter *rtl2832_get_private_i2c_adapter(
 	return NULL;
 }
 
+static inline int rtl2832_enable_external_ts_if(
+	struct dvb_frontend *fe
+)
+{
+	return -ENODEV;
+}
+
 #endif
 
 
-- 
http://palosaari.fi/

