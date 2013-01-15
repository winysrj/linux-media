Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199Ab3AOCbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:36 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VZIK021850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 05/15] mb86a20s: functions reorder
Date: Tue, 15 Jan 2013 00:30:51 -0200
Message-Id: <1358217061-14982-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes here. Just re-organizes the functions
inside the file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 217 +++++++++++++++++----------------
 1 file changed, 115 insertions(+), 102 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 0f8d9bc..c91e9b9 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -194,6 +194,10 @@ static struct regdata mb86a20s_clear_stats[] = {
 	{ 0x51, 0x01 },
 };
 
+/*
+ * I2C read/write functions and macros
+ */
+
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 			     u8 i2c_addr, int reg, int data)
 {
@@ -255,45 +259,42 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	mb86a20s_i2c_writeregdata(state, state->config->demod_address, \
 	regdata, ARRAY_SIZE(regdata))
 
-static int mb86a20s_initfe(struct dvb_frontend *fe)
+/*
+ * Ancillary internal routines (likely compiled inlined)
+ *
+ * The functions below assume that gateway lock has already obtained
+ */
+
+static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc;
-	u8  regD5 = 1;
+	int val;
 
 	dprintk("\n");
+	*status = 0;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
+	val = mb86a20s_readreg(state, 0x0a) & 0xf;
+	if (val < 0)
+		return val;
 
-	/* Initialize the frontend */
-	rc = mb86a20s_writeregdata(state, mb86a20s_init);
-	if (rc < 0)
-		goto err;
+	if (val >= 2)
+		*status |= FE_HAS_SIGNAL;
 
-	if (!state->config->is_serial) {
-		regD5 &= ~1;
+	if (val >= 4)
+		*status |= FE_HAS_CARRIER;
 
-		rc = mb86a20s_writereg(state, 0x50, 0xd5);
-		if (rc < 0)
-			goto err;
-		rc = mb86a20s_writereg(state, 0x51, regD5);
-		if (rc < 0)
-			goto err;
-	}
+	if (val >= 5)
+		*status |= FE_HAS_VITERBI;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (val >= 7)
+		*status |= FE_HAS_SYNC;
 
-err:
-	if (rc < 0) {
-		state->need_init = true;
-		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
-	} else {
-		state->need_init = false;
-		dprintk("Initialization succeeded.\n");
-	}
-	return rc;
+	if (val >= 8)				/* Maybe 9? */
+		*status |= FE_HAS_LOCK;
+
+	dprintk("val = %d, status = 0x%02x\n", val, *status);
+
+	return 0;
 }
 
 static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
@@ -340,78 +341,6 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct mb86a20s_state *state = fe->demodulator_priv;
-	int val;
-
-	dprintk("\n");
-	*status = 0;
-
-	val = mb86a20s_readreg(state, 0x0a) & 0xf;
-	if (val < 0)
-		return val;
-
-	if (val >= 2)
-		*status |= FE_HAS_SIGNAL;
-
-	if (val >= 4)
-		*status |= FE_HAS_CARRIER;
-
-	if (val >= 5)
-		*status |= FE_HAS_VITERBI;
-
-	if (val >= 7)
-		*status |= FE_HAS_SYNC;
-
-	if (val >= 8)				/* Maybe 9? */
-		*status |= FE_HAS_LOCK;
-
-	dprintk("val = %d, status = 0x%02x\n", val, *status);
-
-	return 0;
-}
-
-static int mb86a20s_set_frontend(struct dvb_frontend *fe)
-{
-	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc;
-#if 0
-	/*
-	 * FIXME: Properly implement the set frontend properties
-	 */
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-#endif
-
-	dprintk("\n");
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-	dprintk("Calling tuner set parameters\n");
-	fe->ops.tuner_ops.set_params(fe);
-
-	/*
-	 * Make it more reliable: if, for some reason, the initial
-	 * device initialization doesn't happen, initialize it when
-	 * a SBTVD parameters are adjusted.
-	 *
-	 * Unfortunately, due to a hard to track bug at tda829x/tda18271,
-	 * the agc callback logic is not called during DVB attach time,
-	 * causing mb86a20s to not be initialized with Kworld SBTVD.
-	 * So, this hack is needed, in order to make Kworld SBTVD to work.
-	 */
-	if (state->need_init)
-		mb86a20s_initfe(fe);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-	rc = mb86a20s_writeregdata(state, mb86a20s_reset_reception);
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
-	return rc;
-}
-
 static int mb86a20s_get_modulation(struct mb86a20s_state *state,
 				   unsigned layer)
 {
@@ -854,6 +783,91 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	return rc;
 }
 
+/*
+ * The functions below are called via DVB callbacks, so they need to
+ * properly use the I2C gate control
+ */
+static int mb86a20s_initfe(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
+	u8  regD5 = 1;
+
+	dprintk("\n");
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	/* Initialize the frontend */
+	rc = mb86a20s_writeregdata(state, mb86a20s_init);
+	if (rc < 0)
+		goto err;
+
+	if (!state->config->is_serial) {
+		regD5 &= ~1;
+
+		rc = mb86a20s_writereg(state, 0x50, 0xd5);
+		if (rc < 0)
+			goto err;
+		rc = mb86a20s_writereg(state, 0x51, regD5);
+		if (rc < 0)
+			goto err;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+err:
+	if (rc < 0) {
+		state->need_init = true;
+		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
+	} else {
+		state->need_init = false;
+		dprintk("Initialization succeeded.\n");
+	}
+	return rc;
+}
+
+static int mb86a20s_set_frontend(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
+#if 0
+	/*
+	 * FIXME: Properly implement the set frontend properties
+	 */
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+#endif
+
+	dprintk("\n");
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+	dprintk("Calling tuner set parameters\n");
+	fe->ops.tuner_ops.set_params(fe);
+
+	/*
+	 * Make it more reliable: if, for some reason, the initial
+	 * device initialization doesn't happen, initialize it when
+	 * a SBTVD parameters are adjusted.
+	 *
+	 * Unfortunately, due to a hard to track bug at tda829x/tda18271,
+	 * the agc callback logic is not called during DVB attach time,
+	 * causing mb86a20s to not be initialized with Kworld SBTVD.
+	 * So, this hack is needed, in order to make Kworld SBTVD to work.
+	 */
+	if (state->need_init)
+		mb86a20s_initfe(fe);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+	rc = mb86a20s_writeregdata(state, mb86a20s_reset_reception);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	return rc;
+}
+
 static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 					  fe_status_t *status)
 {
@@ -916,7 +930,6 @@ static int mb86a20s_read_signal_strength_from_cache(struct dvb_frontend *fe,
 	return 0;
 }
 
-
 static int mb86a20s_tune(struct dvb_frontend *fe,
 			bool re_tune,
 			unsigned int mode_flags,
-- 
1.7.11.7

