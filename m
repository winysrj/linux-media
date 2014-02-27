Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59648 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbaB0AQ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:16:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 5/8] rtl2832: provide muxed I2C adapter
Date: Thu, 27 Feb 2014 02:16:07 +0200
Message-Id: <1393460170-11591-6-git-send-email-crope@iki.fi>
In-Reply-To: <1393460170-11591-1-git-send-email-crope@iki.fi>
References: <1393460170-11591-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2832 provides gated / repeater I2C adapter for tuner.
Implement it as a muxed I2C adapter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |  2 +-
 drivers/media/dvb-frontends/rtl2832.c      | 26 ++++++++++++++++++++++++++
 drivers/media/dvb-frontends/rtl2832.h      | 13 +++++++++++++
 drivers/media/dvb-frontends/rtl2832_priv.h |  2 ++
 4 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index dd12a1e..d701488 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -441,7 +441,7 @@ config DVB_RTL2830
 
 config DVB_RTL2832
 	tristate "Realtek RTL2832 DVB-T"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && I2C_MUX
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 00e63b9..dc46cf0 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -891,9 +891,29 @@ static void rtl2832_release(struct dvb_frontend *fe)
 	struct rtl2832_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	i2c_del_mux_adapter(priv->i2c_adapter);
 	kfree(priv);
 }
 
+static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+{
+	struct rtl2832_priv *priv = mux_priv;
+	return rtl2832_i2c_gate_ctrl(&priv->fe, 1);
+}
+
+static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv, u32 chan)
+{
+	struct rtl2832_priv *priv = mux_priv;
+	return rtl2832_i2c_gate_ctrl(&priv->fe, 0);
+}
+
+struct i2c_adapter *rtl2832_get_i2c_adapter(struct dvb_frontend *fe)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	return priv->i2c_adapter;
+}
+EXPORT_SYMBOL(rtl2832_get_i2c_adapter);
+
 struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c)
 {
@@ -918,6 +938,12 @@ struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
 	if (ret)
 		goto err;
 
+	/* create muxed i2c adapter */
+	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
+			rtl2832_select, rtl2832_deselect);
+	if (priv->i2c_adapter == NULL)
+		goto err;
+
 	/* create dvb_frontend */
 	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
 	priv->fe.demodulator_priv = priv;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index fa4e5f6..a9202d7 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -55,7 +55,13 @@ struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *cfg,
 	struct i2c_adapter *i2c
 );
+
+extern struct i2c_adapter *rtl2832_get_i2c_adapter(
+	struct dvb_frontend *fe
+);
+
 #else
+
 static inline struct dvb_frontend *rtl2832_attach(
 	const struct rtl2832_config *config,
 	struct i2c_adapter *i2c
@@ -64,6 +70,13 @@ static inline struct dvb_frontend *rtl2832_attach(
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+
+static inline struct i2c_adapter *rtl2832_get_i2c_adapter(
+	struct dvb_frontend *fe
+)
+{
+	return NULL;
+}
 #endif
 
 
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 4c845af..ec26c92 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -23,9 +23,11 @@
 
 #include "dvb_frontend.h"
 #include "rtl2832.h"
+#include <linux/i2c-mux.h>
 
 struct rtl2832_priv {
 	struct i2c_adapter *i2c;
+	struct i2c_adapter *i2c_adapter;
 	struct dvb_frontend fe;
 	struct rtl2832_config cfg;
 
-- 
1.8.5.3

