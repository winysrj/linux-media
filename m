Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:52926 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1HIKQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 06:16:31 -0400
From: Steve Kerrison <steve@stevekerrison.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Robert Schlabbach <robert_s@gmx.net>,
	Steve Kerrison <steve@stevekerrison.com>
Subject: [PATCH v2] CXD2820R: Replace i2c message translation with repeater gate control
Date: Tue,  9 Aug 2011 11:16:21 +0100
Message-Id: <1312884981-15835-1-git-send-email-steve@stevekerrison.com>
In-Reply-To: <4E406E53.6050302@iki.fi>
References: <4E406E53.6050302@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements an i2c_gate_ctrl op for the cxd2820r. Thanks to Robert
Schlabbach for identifying the register address and field to set.

The old i2c intercept code that prefixed messages with a passthrough byte has
been removed and the PCTV nanoStick T2 290e entry in em28xx-dvb has been
updated appropriately.

Tested for DVB-T2 use; I would appreciate it if somebody with DVB-C capabilities
could test it as well - from inspection I cannot see any problems.

This is patch v2. It fixes some schoolboy style errors and removes superfluous
i2c entries in cxd2820r.h.

Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
---
 drivers/media/dvb/frontends/cxd2820r.h      |    9 ---
 drivers/media/dvb/frontends/cxd2820r_c.c    |    1 -
 drivers/media/dvb/frontends/cxd2820r_core.c |   76 +++------------------------
 drivers/media/dvb/frontends/cxd2820r_priv.h |    1 -
 drivers/media/dvb/frontends/cxd2820r_t.c    |    1 -
 drivers/media/dvb/frontends/cxd2820r_t2.c   |    1 -
 drivers/media/video/em28xx/em28xx-dvb.c     |    7 +--
 7 files changed, 11 insertions(+), 85 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r.h b/drivers/media/dvb/frontends/cxd2820r.h
index 2906582..03cab7b 100644
--- a/drivers/media/dvb/frontends/cxd2820r.h
+++ b/drivers/media/dvb/frontends/cxd2820r.h
@@ -93,9 +93,6 @@ extern struct dvb_frontend *cxd2820r_attach(
 	struct i2c_adapter *i2c,
 	struct dvb_frontend *fe
 );
-extern struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-);
 #else
 static inline struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
@@ -106,12 +103,6 @@ static inline struct dvb_frontend *cxd2820r_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static inline struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-)
-{
-	return NULL;
-}
 
 #endif
 
diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index 3c07d40..b85f501 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -335,4 +335,3 @@ int cxd2820r_get_tune_settings_c(struct dvb_frontend *fe,
 
 	return 0;
 }
-
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index d416e85..0151267 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -727,70 +727,20 @@ static void cxd2820r_release(struct dvb_frontend *fe)
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	dbg("%s", __func__);
 
-	if (fe->ops.info.type == FE_OFDM) {
-		i2c_del_adapter(&priv->tuner_i2c_adapter);
+	if (fe->ops.info.type == FE_OFDM)
 		kfree(priv);
-	}
 
 	return;
 }
 
-static u32 cxd2820r_tuner_i2c_func(struct i2c_adapter *adapter)
-{
-	return I2C_FUNC_I2C;
-}
-
-static int cxd2820r_tuner_i2c_xfer(struct i2c_adapter *i2c_adap,
-	struct i2c_msg msg[], int num)
-{
-	struct cxd2820r_priv *priv = i2c_get_adapdata(i2c_adap);
-	int ret;
-	u8 *obuf = kmalloc(msg[0].len + 2, GFP_KERNEL);
-	struct i2c_msg msg2[2] = {
-		{
-			.addr = priv->cfg.i2c_address,
-			.flags = 0,
-			.len = msg[0].len + 2,
-			.buf = obuf,
-		}, {
-			.addr = priv->cfg.i2c_address,
-			.flags = I2C_M_RD,
-			.len = msg[1].len,
-			.buf = msg[1].buf,
-		}
-	};
-
-	if (!obuf)
-		return -ENOMEM;
-
-	obuf[0] = 0x09;
-	obuf[1] = (msg[0].addr << 1);
-	if (num == 2) { /* I2C read */
-		obuf[1] = (msg[0].addr << 1) | I2C_M_RD; /* I2C RD flag */
-		msg2[0].len = msg[0].len + 2 - 1; /* '-1' maybe HW bug ? */
-	}
-	memcpy(&obuf[2], msg[0].buf, msg[0].len);
-
-	ret = i2c_transfer(priv->i2c, msg2, num);
-	if (ret < 0)
-		warn("tuner i2c failed ret:%d", ret);
-
-	kfree(obuf);
-
-	return ret;
-}
-
-static struct i2c_algorithm cxd2820r_tuner_i2c_algo = {
-	.master_xfer   = cxd2820r_tuner_i2c_xfer,
-	.functionality = cxd2820r_tuner_i2c_func,
-};
-
-struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(struct dvb_frontend *fe)
+static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	return &priv->tuner_i2c_adapter;
+	dbg("%s: %d", __func__, enable);
+
+	/* Bit 0 of reg 0xdb in bank 0x00 controls I2C repeater */
+	return cxd2820r_wr_reg_mask(priv, 0xdb, enable ? 1 : 0, 0x1);
 }
-EXPORT_SYMBOL(cxd2820r_get_tuner_i2c_adapter);
 
 static struct dvb_frontend_ops cxd2820r_ops[2];
 
@@ -831,18 +781,6 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 		priv->fe[0].demodulator_priv = priv;
 		priv->fe[1].demodulator_priv = priv;
 
-		/* create tuner i2c adapter */
-		strlcpy(priv->tuner_i2c_adapter.name,
-			"CXD2820R tuner I2C adapter",
-			sizeof(priv->tuner_i2c_adapter.name));
-		priv->tuner_i2c_adapter.algo = &cxd2820r_tuner_i2c_algo;
-		priv->tuner_i2c_adapter.algo_data = NULL;
-		i2c_set_adapdata(&priv->tuner_i2c_adapter, priv);
-		if (i2c_add_adapter(&priv->tuner_i2c_adapter) < 0) {
-			err("tuner I2C bus could not be initialized");
-			goto error;
-		}
-
 		return &priv->fe[0];
 
 	} else {
@@ -883,6 +821,7 @@ static struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.sleep = cxd2820r_sleep,
 
 		.get_tune_settings = cxd2820r_get_tune_settings,
+		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
 		.get_frontend = cxd2820r_get_frontend,
 
@@ -911,6 +850,7 @@ static struct dvb_frontend_ops cxd2820r_ops[2] = {
 		.sleep = cxd2820r_sleep,
 
 		.get_tune_settings = cxd2820r_get_tune_settings,
+		.i2c_gate_ctrl = cxd2820r_i2c_gate_ctrl,
 
 		.set_frontend = cxd2820r_set_frontend,
 		.get_frontend = cxd2820r_get_frontend,
diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index 0c0ebc9..9553913 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -50,7 +50,6 @@ struct cxd2820r_priv {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe[2];
 	struct cxd2820r_config cfg;
-	struct i2c_adapter tuner_i2c_adapter;
 
 	struct mutex fe_lock; /* FE lock */
 	int active_fe:2; /* FE lock, -1=NONE, 0=DVB-T/T2, 1=DVB-C */
diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb/frontends/cxd2820r_t.c
index 6582564..a04f9c8 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t.c
@@ -446,4 +446,3 @@ int cxd2820r_get_tune_settings_t(struct dvb_frontend *fe,
 
 	return 0;
 }
-
diff --git a/drivers/media/dvb/frontends/cxd2820r_t2.c b/drivers/media/dvb/frontends/cxd2820r_t2.c
index c47b35c..6548588 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t2.c
@@ -420,4 +420,3 @@ int cxd2820r_get_tune_settings_t2(struct dvb_frontend *fe,
 
 	return 0;
 }
-
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index e5916de..223a2fc 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -438,6 +438,7 @@ static struct cxd2820r_config em28xx_cxd2820r_config = {
 
 static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
 	.output_opt = TDA18271_OUTPUT_LT_OFF,
+	.gate = TDA18271_GATE_DIGITAL,
 };
 
 /* ------------------------------------------------------------------ */
@@ -753,11 +754,9 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 			&em28xx_cxd2820r_config, &dev->i2c_adap, NULL);
 		if (dvb->fe[0]) {
-			struct i2c_adapter *i2c_tuner;
-			i2c_tuner = cxd2820r_get_tuner_i2c_adapter(dvb->fe[0]);
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-				i2c_tuner, &em28xx_cxd2820r_tda18271_config)) {
+				&dev->i2c_adap, &em28xx_cxd2820r_tda18271_config)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
 				goto out_free;
@@ -768,7 +767,7 @@ static int dvb_init(struct em28xx *dev)
 			dvb->fe[1]->id = 1;
 			/* FE 1 attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[1], 0x60,
-				i2c_tuner, &em28xx_cxd2820r_tda18271_config)) {
+				&dev->i2c_adap, &em28xx_cxd2820r_tda18271_config)) {
 				dvb_frontend_detach(dvb->fe[1]);
 				/* leave FE 0 still active */
 			}
-- 
1.7.1

