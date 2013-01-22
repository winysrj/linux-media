Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab3AVLQK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:10 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBG9HE026862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/7] [media] mb86a20s: Function reorder
Date: Tue, 22 Jan 2013 09:15:32 -0200
Message-Id: <1358853333-21554-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorder functions to have everything related to stats/status read
close. That will make the file more organized as other stats
routines will be added.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 215 +++++++++++++++++----------------
 1 file changed, 110 insertions(+), 105 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 03b74d3..b348f97 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -175,6 +175,10 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
+/*
+ * I2C read/write functions and macros
+ */
+
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 			     u8 i2c_addr, int reg, int data)
 {
@@ -236,45 +240,36 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	mb86a20s_i2c_writeregdata(state, state->config->demod_address, \
 	regdata, ARRAY_SIZE(regdata))
 
-static int mb86a20s_initfe(struct dvb_frontend *fe)
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
 
-err:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (val >= 7)
+		*status |= FE_HAS_SYNC;
 
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
 
 static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
@@ -317,82 +312,6 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
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
-	/*
-	 * Gate should already be opened, but it doesn't hurt to
-	 * double-check
-	 */
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
@@ -633,6 +552,92 @@ error:
 
 }
 
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
+err:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
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
+	/*
+	 * Gate should already be opened, but it doesn't hurt to
+	 * double-check
+	 */
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
+
 static int mb86a20s_read_status_gate(struct dvb_frontend *fe,
 				     fe_status_t *status)
 {
-- 
1.7.11.7

