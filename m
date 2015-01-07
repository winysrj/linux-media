Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58442 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbAGNVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 08:21:04 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so4886396pab.0
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 05:21:03 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 1/4] dvb: qm1d1c0042: use dvb-core i2c binding model template
Date: Wed,  7 Jan 2015 22:20:41 +0900
Message-Id: <1420636844-32553-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1420636844-32553-1-git-send-email-tskd08@gmail.com>
References: <1420636844-32553-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/qm1d1c0042.c | 60 +++++++++++++--------------------------
 drivers/media/tuners/qm1d1c0042.h |  2 --
 2 files changed, 19 insertions(+), 43 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 18bc745..b6d637d 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -29,6 +29,7 @@
 
 #include <linux/kernel.h>
 #include <linux/math64.h>
+#include "dvb_i2c.h"
 #include "qm1d1c0042.h"
 
 #define QM1D1C0042_NUM_REGS 0x20
@@ -55,11 +56,6 @@ struct qm1d1c0042_state {
 	u8 regs[QM1D1C0042_NUM_REGS];
 };
 
-static struct qm1d1c0042_state *cfg_to_state(struct qm1d1c0042_config *c)
-{
-	return container_of(c, struct qm1d1c0042_state, cfg);
-}
-
 static int reg_write(struct qm1d1c0042_state *state, u8 reg, u8 val)
 {
 	u8 wbuf[2] = { reg, val };
@@ -106,10 +102,12 @@ static int qm1d1c0042_set_srch_mode(struct qm1d1c0042_state *state, bool fast)
 	return reg_write(state, 0x03, state->regs[0x03]);
 }
 
-static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
+static int qm1d1c0042_wakeup(struct dvb_frontend *fe)
 {
+	struct qm1d1c0042_state *state;
 	int ret;
 
+	state = fe->tuner_priv;
 	state->regs[0x01] |= 1 << 3;             /* BB_Reg_enable */
 	state->regs[0x01] &= (~(1 << 0)) & 0xff; /* NORMAL (wake-up) */
 	state->regs[0x05] &= (~(1 << 3)) & 0xff; /* pfd_rst NORMAL */
@@ -119,7 +117,7 @@ static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
 
 	if (ret < 0)
 		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, state->cfg.fe->dvb->num, state->cfg.fe->id);
+			__func__, fe->dvb->num, fe->id);
 	return ret;
 }
 
@@ -133,9 +131,6 @@ static int qm1d1c0042_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	state = fe->tuner_priv;
 	cfg = priv_cfg;
 
-	if (cfg->fe)
-		state->cfg.fe = cfg->fe;
-
 	if (cfg->xtal_freq != QM1D1C0042_CFG_XTAL_DFLT)
 		dev_warn(&state->i2c->dev,
 			"(%s) changing xtal_freq not supported. ", __func__);
@@ -359,7 +354,7 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
 			goto failed;
 	}
 
-	ret = qm1d1c0042_wakeup(state);
+	ret = qm1d1c0042_wakeup(fe);
 	if (ret < 0)
 		goto failed;
 
@@ -395,33 +390,18 @@ static const struct dvb_tuner_ops qm1d1c0042_ops = {
 static int qm1d1c0042_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
-	struct qm1d1c0042_state *state;
-	struct qm1d1c0042_config *cfg;
+	struct dvb_i2c_tuner_config *cfg;
 	struct dvb_frontend *fe;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c = client;
+	struct qm1d1c0042_state *state;
 
 	cfg = client->dev.platform_data;
 	fe = cfg->fe;
-	fe->tuner_priv = state;
-	qm1d1c0042_set_config(fe, cfg);
-	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(qm1d1c0042_ops));
+	state = fe->tuner_priv;
+	state->i2c = client;
 
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "Sharp QM1D1C0042 attached.\n");
-	return 0;
-}
+	qm1d1c0042_set_config(fe, (void *)cfg->devcfg.priv_cfg);
 
-static int qm1d1c0042_remove(struct i2c_client *client)
-{
-	struct qm1d1c0042_state *state;
-
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
+	dev_info(&client->dev, "Sharp QM1D1C0042 attached.\n");
 	return 0;
 }
 
@@ -430,18 +410,16 @@ static const struct i2c_device_id qm1d1c0042_id[] = {
 	{"qm1d1c0042", 0},
 	{}
 };
-MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id);
 
-static struct i2c_driver qm1d1c0042_driver = {
-	.driver = {
-		.name	= "qm1d1c0042",
-	},
-	.probe		= qm1d1c0042_probe,
-	.remove		= qm1d1c0042_remove,
-	.id_table	= qm1d1c0042_id,
+static const struct dvb_i2c_module_param qm1d1c0042_param = {
+	.ops.tuner_ops = &qm1d1c0042_ops,
+	.priv_probe = qm1d1c0042_probe,
+
+	.priv_size = sizeof(struct qm1d1c0042_state),
+	.is_tuner = true,
 };
 
-module_i2c_driver(qm1d1c0042_driver);
+DEFINE_DVB_I2C_MODULE(qm1d1c0042, qm1d1c0042_id, qm1d1c0042_param);
 
 MODULE_DESCRIPTION("Sharp QM1D1C0042 tuner");
 MODULE_AUTHOR("Akihiro TSUKADA");
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
index 4f5c188..043787e 100644
--- a/drivers/media/tuners/qm1d1c0042.h
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -21,8 +21,6 @@
 
 
 struct qm1d1c0042_config {
-	struct dvb_frontend *fe;
-
 	u32  xtal_freq;    /* [kHz] */ /* currently ignored */
 	bool lpf;          /* enable LPF */
 	bool fast_srch;    /* enable fast search mode, no LPF */
-- 
2.2.1

