Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab3AVQo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:44:59 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MGixmg028805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:44:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REVIEW PATCHv12 3/6] [media] mb86a20s: calculate statistics at .read_status()
Date: Tue, 22 Jan 2013 14:44:17 -0200
Message-Id: <1358873060-27609-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
References: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of providing separate callbacks to read the several FE
stats properties, the better seems to use just one method that will:

    - Read lock status;

    - Read signal strength;

    - if locked, get TMCC data;

    - if locked, get DVB statistics.

As the DVB frontend thread will call this read_status callback
on every 3 seconds, and userspace can even call it earlier,
all stats data and layers layout will be updated together if
available, with is a good thing.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
v12: minor changes:

- Folded with other patches to make easier to read/understand;
- BER code moved to a separate patch;
- Rebased to be applied after mb86a20s fix patches, that were
  independent from the status changes and got merged at media-tree
  from a separate patch series.

 drivers/media/dvb-frontends/mb86a20s.c | 262 ++++++++++++++++++++++++++++-----
 1 file changed, 223 insertions(+), 39 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c52ae2e..b307cb3 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -80,17 +80,26 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x04, 0x13 }, { 0x05, 0xff },
 	{ 0x04, 0x15 }, { 0x05, 0x4e },
 	{ 0x04, 0x16 }, { 0x05, 0x20 },
-	{ 0x52, 0x01 },
-	{ 0x50, 0xa7 }, { 0x51, 0xff },
+
+	/*
+	 * On this demod, when the bit count reaches the count below,
+	 * it collects the bit error count. The bit counters are initialized
+	 * to 65535 here. This warrants that all of them will be quickly
+	 * calculated when device gets locked. As TMCC is parsed, the values
+	 * can be adjusted later in the driver's code.
+	 */
+	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
+	{ 0x50, 0xa7 }, { 0x51, 0x00 },
 	{ 0x50, 0xa8 }, { 0x51, 0xff },
 	{ 0x50, 0xa9 }, { 0x51, 0xff },
-	{ 0x50, 0xaa }, { 0x51, 0xff },
+	{ 0x50, 0xaa }, { 0x51, 0x00 },
 	{ 0x50, 0xab }, { 0x51, 0xff },
 	{ 0x50, 0xac }, { 0x51, 0xff },
-	{ 0x50, 0xad }, { 0x51, 0xff },
+	{ 0x50, 0xad }, { 0x51, 0x00 },
 	{ 0x50, 0xae }, { 0x51, 0xff },
 	{ 0x50, 0xaf }, { 0x51, 0xff },
-	{ 0x5e, 0x07 },
+
+	{ 0x5e, 0x00 },				/* Turn off BER after Viterbi */
 	{ 0x50, 0xdc }, { 0x51, 0x01 },
 	{ 0x50, 0xdd }, { 0x51, 0xf4 },
 	{ 0x50, 0xde }, { 0x51, 0x01 },
@@ -105,8 +114,8 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x50, 0xb6 }, { 0x51, 0xff },
 	{ 0x50, 0xb7 }, { 0x51, 0xff },
 	{ 0x50, 0x50 }, { 0x51, 0x02 },
-	{ 0x50, 0x51 }, { 0x51, 0x04 },
-	{ 0x45, 0x04 },
+	{ 0x50, 0x51 }, { 0x51, 0x04 },		/* MER symbol 4 */
+	{ 0x45, 0x04 },				/* CN symbol 4 */
 	{ 0x48, 0x04 },
 	{ 0x50, 0xd5 }, { 0x51, 0x01 },		/* Serial */
 	{ 0x50, 0xd6 }, { 0x51, 0x1f },
@@ -163,12 +172,23 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
+static struct regdata mb86a20s_vber_reset[] = {
+	{ 0x53, 0x00 },	/* VBER Counter reset */
+	{ 0x53, 0x07 },
+};
+
+static struct regdata mb86a20s_per_reset[] = {
+	{ 0x50, 0xb1 },	/* PER Counter reset */
+	{ 0x51, 0x07 },
+	{ 0x51, 0x00 },
+};
+
 /*
  * I2C read/write functions and macros
  */
 
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
-			     u8 i2c_addr, int reg, int data)
+			     u8 i2c_addr, u8 reg, u8 data)
 {
 	u8 buf[] = { reg, data };
 	struct i2c_msg msg = {
@@ -230,6 +250,12 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 	mb86a20s_i2c_writeregdata(state, state->config->demod_address, \
 	regdata, ARRAY_SIZE(regdata))
 
+/*
+ * Ancillary internal routines (likely compiled inlined)
+ *
+ * The functions below assume that gateway lock has already obtained
+ */
+
 static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -262,42 +288,49 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 }
 
-static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
 	unsigned rf_max, rf_min, rf;
-	u8	 val;
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	/* Does a binary search to get RF strength */
 	rf_max = 0xfff;
 	rf_min = 0;
 	do {
 		rf = (rf_max + rf_min) / 2;
-		mb86a20s_writereg(state, 0x04, 0x1f);
-		mb86a20s_writereg(state, 0x05, rf >> 8);
-		mb86a20s_writereg(state, 0x04, 0x20);
-		mb86a20s_writereg(state, 0x04, rf);
+		rc = mb86a20s_writereg(state, 0x04, 0x1f);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x05, rf >> 8);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x04, 0x20);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x04, rf);
+		if (rc < 0)
+			return rc;
 
-		val = mb86a20s_readreg(state, 0x02);
-		if (val & 0x08)
+		rc = mb86a20s_readreg(state, 0x02);
+		if (rc < 0)
+			return rc;
+		if (rc & 0x08)
 			rf_min = (rf_max + rf_min) / 2;
 		else
 			rf_max = (rf_max + rf_min) / 2;
 		if (rf_max - rf_min < 4) {
-			*strength = (((rf_max + rf_min) / 2) * 65535) / 4095;
+			rf = (rf_max + rf_min) / 2;
+
+			/* Rescale it from 2^12 (4096) to 2^16 */
+			rf <<= (16 - 12);
 			dev_dbg(&state->i2c->dev,
 				"%s: signal strength = %d (%d < RF=%d < %d)\n",
 				__func__, rf, rf_min, rf >> 4, rf_max);
-			break;
+			return rf;
 		}
 	} while (1);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	return 0;
 }
 
@@ -462,9 +495,6 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	/* Reset frontend cache to default values */
 	mb86a20s_reset_frontend_cache(fe);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	/* Check for partial reception */
 	rc = mb86a20s_writereg(state, 0x6d, 0x85);
 	if (rc < 0)
@@ -550,15 +580,119 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 			break;
 		}
 	}
+	return 0;
 
 noperlayer_error:
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	/* per-layer info is incomplete; discard all per-layer */
+	c->isdbt_layer_enabled = 0;
+
+	return rc;
+}
+
+static int mb86a20s_reset_counters(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc, val;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
+	/* Reset the counters, if the channel changed */
+	if (state->last_frequency != c->frequency) {
+		memset(&c->strength, 0, sizeof(c->strength));
+		memset(&c->cnr, 0, sizeof(c->cnr));
+		memset(&c->bit_error, 0, sizeof(c->bit_error));
+		memset(&c->bit_count, 0, sizeof(c->bit_count));
+		memset(&c->block_error, 0, sizeof(c->block_error));
+		memset(&c->block_count, 0, sizeof(c->block_count));
+
+		state->last_frequency = c->frequency;
+	}
+
+	/* Clear status for most stats */
+
+	/* BER counter reset */
+	rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
+	if (rc < 0)
+		goto err;
+
+	/* MER, PER counter reset */
+	rc = mb86a20s_writeregdata(state, mb86a20s_per_reset);
+	if (rc < 0)
+		goto err;
+
+	/* CNR counter reset */
+	rc = mb86a20s_readreg(state, 0x45);
+	if (rc < 0)
+		goto err;
+	val = rc;
+	rc = mb86a20s_writereg(state, 0x45, val | 0x10);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x45, val & 0x6f);
+	if (rc < 0)
+		goto err;
+
+	/* MER counter reset */
+	rc = mb86a20s_writereg(state, 0x50, 0x50);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		goto err;
+	val = rc;
+	rc = mb86a20s_writereg(state, 0x51, val | 0x01);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x51, val & 0x06);
+	if (rc < 0)
+		goto err;
+
+err:
 	return rc;
+}
+
+static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int i;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
+	/* Fill the length of each status counter */
+
+	/* Only global stats */
+	c->strength.len = 1;
+
+	/* Per-layer stats - 3 layers + global */
+	c->cnr.len = 4;
+	c->bit_error.len = 4;
+	c->bit_count.len = 4;
+	c->block_error.len = 4;
+	c->block_count.len = 4;
+
+	/* Signal is always available */
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = 0;
+
+	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
+	for (i = 0; i < 4; i++) {
+		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+	}
 }
 
+
+/*
+ * The functions below are called via DVB callbacks, so they need to
+ * properly use the I2C gate control
+ */
+
 static int mb86a20s_initfe(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -637,30 +771,80 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	rc = mb86a20s_writeregdata(state, mb86a20s_reset_reception);
+	mb86a20s_reset_counters(fe);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	return rc;
 }
 
-static int mb86a20s_read_status_gate(struct dvb_frontend *fe,
-				     fe_status_t *status)
+static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
+					  fe_status_t *status)
 {
-	int ret;
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc;
 
-	*status = 0;
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
-	ret = mb86a20s_read_status(fe, status);
+	/* Get lock */
+	rc = mb86a20s_read_status(fe, status);
+	if (!(*status & FE_HAS_LOCK)) {
+		mb86a20s_stats_not_ready(fe);
+		mb86a20s_reset_frontend_cache(fe);
+	}
+	if (rc < 0)
+		goto error;
+
+	/* Get signal strength */
+	rc = mb86a20s_read_signal_strength(fe);
+	if (rc < 0) {
+		mb86a20s_stats_not_ready(fe);
+		mb86a20s_reset_frontend_cache(fe);
+		goto error;
+	}
+	/* Fill signal strength */
+	c->strength.stat[0].uvalue = rc;
+
+	if (*status & FE_HAS_LOCK) {
+		/* Get TMCC info*/
+		rc = mb86a20s_get_frontend(fe);
+		if (rc < 0)
+			goto error;
+	}
+
+	mb86a20s_stats_not_ready(fe);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
+error:
+	return rc;
+}
+
+static int mb86a20s_read_signal_strength_from_cache(struct dvb_frontend *fe,
+						    u16 *strength)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+
+	*strength = c->strength.stat[0].uvalue;
 
-	return ret;
+	return 0;
 }
 
+static int mb86a20s_get_frontend_dummy(struct dvb_frontend *fe)
+{
+	/*
+	 * get_frontend is now handled together with other stats
+	 * retrival, when read_status() is called, as some statistics
+	 * will depend on the layers detection.
+	 */
+	return 0;
+};
+
 static int mb86a20s_tune(struct dvb_frontend *fe,
 			bool re_tune,
 			unsigned int mode_flags,
@@ -676,7 +860,7 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 		rc = mb86a20s_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
-		mb86a20s_read_status_gate(fe, status);
+		mb86a20s_read_status_and_stats(fe, status);
 
 	return rc;
 }
@@ -759,9 +943,9 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
-	.get_frontend = mb86a20s_get_frontend,
-	.read_status = mb86a20s_read_status_gate,
-	.read_signal_strength = mb86a20s_read_signal_strength,
+	.get_frontend = mb86a20s_get_frontend_dummy,
+	.read_status = mb86a20s_read_status_and_stats,
+	.read_signal_strength = mb86a20s_read_signal_strength_from_cache,
 	.tune = mb86a20s_tune,
 };
 
-- 
1.7.11.7

