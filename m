Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36067 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759992Ab3LHWb7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH REVIEW 10/18] m88ds3103: use I2C mux for tuner I2C adapter
Date: Mon,  9 Dec 2013 00:31:27 +0200
Message-Id: <1386541895-8634-11-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch standard I2C adapter to muxed I2C adapter.

David reported that I2C adapter implementation caused deadlock.
I discussed with Jean and he suggested to implement it as a
multiplexed i2c adapter because tuner I2C bus could be seen like
own I2C segment.

Reported-by: David Howells <dhowells@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig          |  2 +-
 drivers/media/dvb-frontends/m88ds3103.c      | 73 +++++++++++-----------------
 drivers/media/dvb-frontends/m88ds3103_priv.h |  3 +-
 3 files changed, 31 insertions(+), 47 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 6c46caf..dd12a1e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -37,7 +37,7 @@ config DVB_STV6110x
 
 config DVB_M88DS3103
 	tristate "Montage M88DS3103"
-	depends on DVB_CORE && I2C
+	depends on DVB_CORE && I2C && I2C_MUX
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 302c923..e07e8d6 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1108,15 +1108,16 @@ static int m88ds3103_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static u32 m88ds3103_tuner_i2c_func(struct i2c_adapter *adapter)
+static void m88ds3103_release(struct dvb_frontend *fe)
 {
-	return I2C_FUNC_I2C;
+	struct m88ds3103_priv *priv = fe->demodulator_priv;
+	i2c_del_mux_adapter(priv->i2c_adapter);
+	kfree(priv);
 }
 
-static int m88ds3103_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
-		struct i2c_msg msg[], int num)
+static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 {
-	struct m88ds3103_priv *priv = i2c_get_adapdata(i2c_adap);
+	struct m88ds3103_priv *priv = mux_priv;
 	int ret;
 	struct i2c_msg gate_open_msg[1] = {
 		{
@@ -1126,43 +1127,31 @@ static int m88ds3103_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
 			.buf = "\x03\x11",
 		}
 	};
-	dev_dbg(&priv->i2c->dev, "%s: num=%d\n", __func__, num);
 
 	mutex_lock(&priv->i2c_mutex);
 
-	/* open i2c-gate */
+	/* open tuner I2C repeater for 1 xfer, closes automatically */
 	ret = i2c_transfer(priv->i2c, gate_open_msg, 1);
 	if (ret != 1) {
-		mutex_unlock(&priv->i2c_mutex);
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c wr failed=%d\n",
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d\n",
 				KBUILD_MODNAME, ret);
-		ret = -EREMOTEIO;
-		goto err;
-	}
+		if (ret >= 0)
+			ret = -EREMOTEIO;
 
-	ret = i2c_transfer(priv->i2c, msg, num);
-	mutex_unlock(&priv->i2c_mutex);
-	if (ret < 0)
-		dev_warn(&priv->i2c->dev, "%s: i2c failed=%d\n",
-				KBUILD_MODNAME, ret);
+		return ret;
+	}
 
-	return ret;
-err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
+	return 0;
 }
 
-static struct i2c_algorithm m88ds3103_tuner_i2c_algo = {
-	.master_xfer   = m88ds3103_tuner_i2c_xfer,
-	.functionality = m88ds3103_tuner_i2c_func,
-};
-
-static void m88ds3103_release(struct dvb_frontend *fe)
+static int m88ds3103_deselect(struct i2c_adapter *adap, void *mux_priv,
+		u32 chan)
 {
-	struct m88ds3103_priv *priv = fe->demodulator_priv;
-	i2c_del_adapter(&priv->i2c_adapter);
-	kfree(priv);
+	struct m88ds3103_priv *priv = mux_priv;
+
+	mutex_unlock(&priv->i2c_mutex);
+
+	return 0;
 }
 
 struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
@@ -1228,24 +1217,18 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 	if (ret)
 		goto err;
 
+	/* create mux i2c adapter for tuner */
+	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
+			m88ds3103_select, m88ds3103_deselect);
+	if (priv->i2c_adapter == NULL)
+		goto err;
+
+	*tuner_i2c_adapter = priv->i2c_adapter;
+
 	/* create dvb_frontend */
 	memcpy(&priv->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
 	priv->fe.demodulator_priv = priv;
 
-	/* create i2c adapter for tuner */
-	strlcpy(priv->i2c_adapter.name, KBUILD_MODNAME,
-			sizeof(priv->i2c_adapter.name));
-	priv->i2c_adapter.algo = &m88ds3103_tuner_i2c_algo;
-	priv->i2c_adapter.algo_data = NULL;
-	i2c_set_adapdata(&priv->i2c_adapter, priv);
-	ret = i2c_add_adapter(&priv->i2c_adapter);
-	if (ret) {
-		dev_err(&i2c->dev, "%s: i2c bus could not be initialized\n",
-				KBUILD_MODNAME);
-		goto err;
-	}
-	*tuner_i2c_adapter = &priv->i2c_adapter;
-
 	return &priv->fe;
 err:
 	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index f3d0867..322db4d 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -25,6 +25,7 @@
 #include "m88ds3103.h"
 #include "dvb_math.h"
 #include <linux/firmware.h>
+#include <linux/i2c-mux.h>
 
 #define M88DS3103_FIRMWARE "dvb-demod-m88ds3103.fw"
 #define M88DS3103_MCLK_KHZ 96000
@@ -38,7 +39,7 @@ struct m88ds3103_priv {
 	fe_delivery_system_t delivery_system;
 	fe_status_t fe_status;
 	bool warm; /* FW running */
-	struct i2c_adapter i2c_adapter;
+	struct i2c_adapter *i2c_adapter;
 };
 
 struct m88ds3103_reg_val {
-- 
1.8.4.2

