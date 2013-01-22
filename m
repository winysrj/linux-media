Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab3AVLQK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:10 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBGAgm018380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/7] [media] mb86a20s: convert it to use dev_info/dev_err/dev_dbg
Date: Tue, 22 Jan 2013 09:15:33 -0200
Message-Id: <1358853333-21554-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of having its own set of macros, use the Kernel default
ones for debug, error and info.

While here, do some cleanup on the debug printk's.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 96 ++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index b348f97..c52ae2e 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -24,18 +24,6 @@ static int debug = 1;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 
-#define rc(args...)  do {						\
-	printk(KERN_ERR  "mb86a20s: " args);				\
-} while (0)
-
-#define dprintk(args...)						\
-	do {								\
-		if (debug) {						\
-			printk(KERN_DEBUG "mb86a20s: %s: ", __func__);	\
-			printk(args);					\
-		}							\
-	} while (0)
-
 struct mb86a20s_state {
 	struct i2c_adapter *i2c;
 	const struct mb86a20s_config *config;
@@ -190,8 +178,9 @@ static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 
 	rc = i2c_transfer(state->i2c, &msg, 1);
 	if (rc != 1) {
-		printk("%s: writereg error (rc == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, rc, reg, data);
+		dev_err(&state->i2c->dev,
+			"%s: writereg error (rc == %i, reg == 0x%02x, data == 0x%02x)\n",
+			__func__, rc, reg, data);
 		return rc;
 	}
 
@@ -225,8 +214,9 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	rc = i2c_transfer(state->i2c, msg, 2);
 
 	if (rc != 2) {
-		rc("%s: reg=0x%x (error=%d)\n", __func__, reg, rc);
-		return rc;
+		dev_err(&state->i2c->dev, "%s: reg=0x%x (error=%d)\n",
+			__func__, reg, rc);
+		return (rc < 0) ? rc : -EIO;
 	}
 
 	return val;
@@ -245,7 +235,6 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int val;
 
-	dprintk("\n");
 	*status = 0;
 
 	val = mb86a20s_readreg(state, 0x0a) & 0xf;
@@ -267,7 +256,8 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (val >= 8)				/* Maybe 9? */
 		*status |= FE_HAS_LOCK;
 
-	dprintk("val = %d, status = 0x%02x\n", val, *status);
+	dev_dbg(&state->i2c->dev, "%s: Status = 0x%02x (state = %d)\n",
+		 __func__, *status, val);
 
 	return 0;
 }
@@ -278,8 +268,6 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	unsigned rf_max, rf_min, rf;
 	u8	 val;
 
-	dprintk("\n");
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
@@ -300,12 +288,13 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 			rf_max = (rf_max + rf_min) / 2;
 		if (rf_max - rf_min < 4) {
 			*strength = (((rf_max + rf_min) / 2) * 65535) / 4095;
+			dev_dbg(&state->i2c->dev,
+				"%s: signal strength = %d (%d < RF=%d < %d)\n",
+				__func__, rf, rf_min, rf >> 4, rf_max);
 			break;
 		}
 	} while (1);
 
-	dprintk("signal strength = %d\n", *strength);
-
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -419,15 +408,17 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
 				      unsigned layer)
 {
 	int rc, count;
-
 	static unsigned char reg[] = {
 		[0] = 0x89,	/* Layer A */
 		[1] = 0x8d,	/* Layer B */
 		[2] = 0x91,	/* Layer C */
 	};
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	if (layer >= ARRAY_SIZE(reg))
 		return -EINVAL;
+
 	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
 	if (rc < 0)
 		return rc;
@@ -436,13 +427,18 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
 		return rc;
 	count = (rc >> 4) & 0x0f;
 
+	dev_dbg(&state->i2c->dev, "%s: segments: %d.\n", __func__, count);
+
 	return count;
 }
 
 static void mb86a20s_reset_frontend_cache(struct dvb_frontend *fe)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	/* Fixed parameters */
 	c->delivery_system = SYS_ISDBT;
 	c->bandwidth_hz = 6000000;
@@ -461,6 +457,8 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i, rc;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	/* Reset frontend cache to default values */
 	mb86a20s_reset_frontend_cache(fe);
 
@@ -479,9 +477,12 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	/* Get per-layer data */
 
 	for (i = 0; i < 3; i++) {
+		dev_dbg(&state->i2c->dev, "%s: getting data for layer %c.\n",
+			__func__, 'A' + i);
+
 		rc = mb86a20s_get_segment_count(state, i);
 		if (rc < 0)
-			goto error;
+			goto noperlayer_error;
 		if (rc >= 0 && rc < 14)
 			c->layer[i].segment_count = rc;
 		else {
@@ -491,15 +492,21 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		c->isdbt_layer_enabled |= 1 << i;
 		rc = mb86a20s_get_modulation(state, i);
 		if (rc < 0)
-			goto error;
+			goto noperlayer_error;
+		dev_dbg(&state->i2c->dev, "%s: modulation %d.\n",
+			__func__, rc);
 		c->layer[i].modulation = rc;
 		rc = mb86a20s_get_fec(state, i);
 		if (rc < 0)
-			goto error;
+			goto noperlayer_error;
+		dev_dbg(&state->i2c->dev, "%s: FEC %d.\n",
+			__func__, rc);
 		c->layer[i].fec = rc;
 		rc = mb86a20s_get_interleaving(state, i);
 		if (rc < 0)
-			goto error;
+			goto noperlayer_error;
+		dev_dbg(&state->i2c->dev, "%s: interleaving %d.\n",
+			__func__, rc);
 		c->layer[i].interleaving = rc;
 	}
 
@@ -544,7 +551,7 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		}
 	}
 
-error:
+noperlayer_error:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -558,7 +565,7 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	int rc;
 	u8  regD5 = 1;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -585,10 +592,11 @@ err:
 
 	if (rc < 0) {
 		state->need_init = true;
-		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
+		dev_info(&state->i2c->dev,
+			 "mb86a20s: Init failed. Will try again later\n");
 	} else {
 		state->need_init = false;
-		dprintk("Initialization succeeded.\n");
+		dev_dbg(&state->i2c->dev, "Initialization succeeded.\n");
 	}
 	return rc;
 }
@@ -603,8 +611,7 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	 */
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 #endif
-
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	/*
 	 * Gate should already be opened, but it doesn't hurt to
@@ -612,7 +619,6 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	 */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	dprintk("Calling tuner set parameters\n");
 	fe->ops.tuner_ops.set_params(fe);
 
 	/*
@@ -637,13 +643,11 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	return rc;
 }
 
-
 static int mb86a20s_read_status_gate(struct dvb_frontend *fe,
 				     fe_status_t *status)
 {
 	int ret;
 
-	dprintk("\n");
 	*status = 0;
 
 	if (fe->ops.i2c_gate_ctrl)
@@ -663,9 +667,10 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 			unsigned int *delay,
 			fe_status_t *status)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc = 0;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	if (re_tune)
 		rc = mb86a20s_set_frontend(fe);
@@ -680,7 +685,7 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	kfree(state);
 }
@@ -690,15 +695,16 @@ static struct dvb_frontend_ops mb86a20s_ops;
 struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 				    struct i2c_adapter *i2c)
 {
+	struct mb86a20s_state *state;
 	u8	rev;
 
 	/* allocate memory for the internal state */
-	struct mb86a20s_state *state =
-		kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 	if (state == NULL) {
-		rc("Unable to kzalloc\n");
+		dev_err(&state->i2c->dev,
+			"%s: unable to allocate memory for state\n", __func__);
 		goto error;
 	}
 
@@ -715,9 +721,11 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	rev = mb86a20s_readreg(state, 0);
 
 	if (rev == 0x13) {
-		printk(KERN_INFO "Detected a Fujitsu mb86a20s frontend\n");
+		dev_info(&state->i2c->dev,
+			 "Detected a Fujitsu mb86a20s frontend\n");
 	} else {
-		printk(KERN_ERR "Frontend revision %d is unknown - aborting.\n",
+		dev_dbg(&state->i2c->dev,
+			"Frontend revision %d is unknown - aborting.\n",
 		       rev);
 		goto error;
 	}
-- 
1.7.11.7

