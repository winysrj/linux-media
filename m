Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207Ab3AOCbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:37 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2Va6e014231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 09/15] mb86a20s: convert it to use dev_info/dev_err/dev_dbg
Date: Tue, 15 Jan 2013 00:30:55 -0200
Message-Id: <1358217061-14982-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also add some additional debug and error messages when needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 156 +++++++++++++++++++++++----------
 1 file changed, 111 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index d14824a..e73f66d 100644
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
@@ -209,8 +197,9 @@ static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 
 	rc = i2c_transfer(state->i2c, &msg, 1);
 	if (rc != 1) {
-		printk("%s: writereg error (rc == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __func__, rc, reg, data);
+		dev_err(&state->i2c->dev,
+			"%s: writereg error (rc == %i, reg == 0x%02x, data == 0x%02x)\n",
+			__func__, rc, reg, data);
 		return rc;
 	}
 
@@ -244,7 +233,8 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	rc = i2c_transfer(state->i2c, msg, 2);
 
 	if (rc != 2) {
-		rc("%s: reg=0x%x (error=%d)\n", __func__, reg, rc);
+		dev_err(&state->i2c->dev, "%s: reg=0x%x (error=%d)\n",
+			__func__, reg, rc);
 		return (rc < 0) ? rc : -EIO;
 	}
 
@@ -270,7 +260,6 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int val;
 
-	dprintk("\n");
 	*status = 0;
 
 	val = mb86a20s_readreg(state, 0x0a) & 0xf;
@@ -292,7 +281,8 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (val >= 8)				/* Maybe 9? */
 		*status |= FE_HAS_LOCK;
 
-	dprintk("val = %d, status = 0x%02x\n", val, *status);
+	dev_dbg(&state->i2c->dev, "%s: Status = 0x%02x (state = %d)\n",
+		 __func__, *status, val);
 
 	return 0;
 }
@@ -333,8 +323,9 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 
 			/* Rescale it from 2^12 (4096) to 2^16 */
 			rf <<= (16 - 12);
-			dprintk("signal strength = %d (%d < RF=%d < %d)\n", rf,
-				rf_min, rf, rf_max);
+			dev_dbg(&state->i2c->dev,
+				"%s: signal strength = %d (%d < RF=%d < %d)\n",
+				__func__, rf, rf_min, rf >> 4, rf_max);
 			return (rf);
 		}
 	} while (1);
@@ -435,15 +426,17 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
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
@@ -452,13 +445,18 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
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
@@ -477,6 +475,8 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i, rc;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	/* Reset frontend cache to default values */
 	mb86a20s_reset_frontend_cache(fe);
 
@@ -492,9 +492,12 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
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
@@ -504,15 +507,21 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
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
 
@@ -558,7 +567,8 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	}
 	return 0;
 
-error:
+noperlayer_error:
+
 	/* per-layer info is incomplete; discard all per-layer */
 	c->isdbt_layer_enabled = 0;
 
@@ -570,6 +580,8 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc, val, i;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
@@ -614,7 +626,12 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 	if (rc < 0)
 		goto err;
 
+	goto ok;
 err:
+	dev_err(&state->i2c->dev,
+		"%s: Can't reset FE QoS counters (error %d).\n",
+		__func__, rc);
+ok:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -629,6 +646,8 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	u8 byte[3];
 	int rc;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	if (layer >= 3)
 		return -EINVAL;
 
@@ -638,8 +657,12 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 		return rc;
 
 	/* Check if data is available for that layer */
-	if (!(rc & (1 << layer)))
+	if (!(rc & (1 << layer))) {
+		dev_info(&state->i2c->dev,
+			"%s: BER for layer %c is not available yet.\n",
+			__func__, 'A' + layer);
 		return -EBUSY;
+	}
 
 	/* Read Bit Error Count */
 	rc = mb86a20s_readreg(state, 0x55 + layer * 3);
@@ -656,6 +679,10 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	byte[2] = rc;
 	*error = byte[0] << 16 | byte[1] << 8 | byte[2];
 
+	dev_err(&state->i2c->dev,
+		"%s: bit error before Viterbi for layer %c: %d.\n",
+		__func__, 'A' + layer, *error);
+
 	/* Read Bit Count */
 	rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer * 3);
 	if (rc < 0)
@@ -679,15 +706,21 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 		return rc;
 	byte[2] = rc;
 	*count = byte[0] << 16 | byte[1] << 8 | byte[2];
+	dev_dbg(&state->i2c->dev,
+		"%s: bit count before Viterbi for layer %c: %d.\n",
+		__func__, 'A' + layer, *count);
 
-	return rc;
+	return 0;
 }
 
 static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	/* Fill the length of each status counter */
 
 	/* Only global stats */
@@ -723,6 +756,8 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	u32 t_bit_error = 0, t_bit_count = 0;
 	int active_layers = 0, ber_layers = 0;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	/* Get per-layer stats */
 	for (i = 0; i < 3; i++) {
 		if (c->isdbt_layer_enabled & (1 << i)) {
@@ -747,6 +782,10 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 					 */
 					c->bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
 					c->bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+					dev_err(&state->i2c->dev,
+						"%s: Can't get BER for layer %c (error %d).\n",
+						__func__, 'A' + i, rc);
+
 				}
 			}
 			if (!state->read_ber[i]) {
@@ -774,6 +813,9 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 
 		/* Reset counters to collect new data */
 		rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
+		if (rc < 0)
+			dev_err(&state->i2c->dev,
+				"%s: Can't reset VBER registers.\n", __func__);
 
 		/* All BER measures need to be collected when ready */
 		for (i = 0; i < 3; i++)
@@ -792,7 +834,7 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	int rc;
 	u8  regD5 = 1;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -819,10 +861,11 @@ err:
 
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
@@ -831,6 +874,9 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 #if 0
 	/*
 	 * FIXME: Properly implement the set frontend properties
@@ -838,15 +884,12 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 #endif
 
-	dprintk("\n");
-
 	/*
 	 * Gate should already be opened, but it doesn't hurt to
 	 * double-check
 	 */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-	dprintk("Calling tuner set parameters\n");
 	fe->ops.tuner_ops.set_params(fe);
 
 	/*
@@ -874,9 +917,12 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 					  fe_status_t *status)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc;
 
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
@@ -886,14 +932,21 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 		mb86a20s_stats_not_ready(fe);
 		mb86a20s_reset_frontend_cache(fe);
 	}
-	if (rc < 0)
+	if (rc < 0) {
+		dev_err(&state->i2c->dev,
+			"%s: Can't read frontend lock status\n", __func__);
 		goto error;
+	}
 
 	/* Get signal strength */
 	rc = mb86a20s_read_signal_strength(fe);
 	if (rc < 0) {
+		dev_err(&state->i2c->dev,
+			"%s: Can't reset VBER registers.\n", __func__);
 		mb86a20s_stats_not_ready(fe);
 		mb86a20s_reset_frontend_cache(fe);
+
+		rc = 0;		/* Status is OK */
 		goto error;
 	}
 	/* Fill signal strength */
@@ -902,13 +955,21 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 	if (*status & FE_HAS_LOCK) {
 		/* Get TMCC info*/
 		rc = mb86a20s_get_frontend(fe);
-		if (rc < 0)
+		if (rc < 0) {
+			dev_err(&state->i2c->dev,
+				"%s: Can't get FE TMCC data.\n", __func__);
+			rc = 0;		/* Status is OK */
 			goto error;
+		}
 
 		/* Get QoS statistics */
 		rc = mb86a20s_get_stats(fe);
-		if (rc < 0)
+		if (rc < 0) {
+			dev_err(&state->i2c->dev,
+				"%s: Can't get FE QoS statistics.\n", __func__);
+			rc = 0;
 			goto error;
+		}
 	}
 	goto ok;
 
@@ -939,9 +1000,10 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 			unsigned int *delay,
 			fe_status_t *status)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	int rc = 0;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	if (re_tune)
 		rc = mb86a20s_set_frontend(fe);
@@ -956,7 +1018,7 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 
-	dprintk("\n");
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	kfree(state);
 }
@@ -967,14 +1029,16 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 				    struct i2c_adapter *i2c)
 {
 	u8	rev;
+	struct mb86a20s_state *state;
 
 	/* allocate memory for the internal state */
-	struct mb86a20s_state *state =
-		kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
-	dprintk("\n");
 	if (state == NULL) {
-		rc("Unable to kzalloc\n");
+		dev_err(&state->i2c->dev,
+			"%s: unable to allocate memory for state\n", __func__);
 		goto error;
 	}
 
@@ -991,10 +1055,12 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	rev = mb86a20s_readreg(state, 0);
 
 	if (rev == 0x13) {
-		printk(KERN_INFO "Detected a Fujitsu mb86a20s frontend\n");
+		dev_info(&state->i2c->dev,
+			 "Detected a Fujitsu mb86a20s frontend\n");
 	} else {
-		printk(KERN_ERR "Frontend revision %d is unknown - aborting.\n",
-		       rev);
+		dev_err(&state->i2c->dev,
+		        "Frontend revision %d is unknown - aborting.\n",
+		        rev);
 		goto error;
 	}
 
-- 
1.7.11.7

