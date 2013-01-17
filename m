Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab3AQS7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIxD13015162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:13 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 04/16] [media] mb86a20s: Add DVBv5 statistics at FE read_status
Date: Thu, 17 Jan 2013 16:58:18 -0200
Message-Id: <1358449110-11203-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of providing separate callbacks to read the several FE
status properties, the better seems to use just one method that will:
    - Read lock status;
    - Read signal strength;
    - if locked, get TMCC data;
    - if locked, get DVB status.
As the DVB frontend thread will call this method on every 3 seconds,
all stats data will be updated together, with is a good thing.
It also prevents userspace to generate undesired I2C traffic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 384 +++++++++++++++++++++++++++++----
 1 file changed, 348 insertions(+), 36 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 4ff3a0c..a0c9f41 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -43,6 +43,12 @@ struct mb86a20s_state {
 	struct dvb_frontend frontend;
 
 	bool need_init;
+
+	/*
+	 * Stats measure flags to be used to know when it is possible to
+	 * artificially generate a "global" measure, based on all 3 layers
+	 */
+	bool read_ber[3];
 };
 
 struct regdata {
@@ -92,7 +98,7 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x04, 0x13 }, { 0x05, 0xff },
 	{ 0x04, 0x15 }, { 0x05, 0x4e },
 	{ 0x04, 0x16 }, { 0x05, 0x20 },
-	{ 0x52, 0x01 },
+	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
 	{ 0x50, 0xa7 }, { 0x51, 0xff },
 	{ 0x50, 0xa8 }, { 0x51, 0xff },
 	{ 0x50, 0xa9 }, { 0x51, 0xff },
@@ -117,8 +123,8 @@ static struct regdata mb86a20s_init[] = {
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
@@ -174,6 +180,20 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
+static struct regdata mb86a20s_vber_reset[] = {
+	{ 0x53, 0x00 },	/* VBER Counter reset */
+	{ 0x53, 0x07 },
+};
+
+static struct regdata mb86a20s_clear_stats[] = {
+	{ 0x5f, 0x00 },	/* SBER Counter reset */
+	{ 0x5f, 0x07 },
+
+	{ 0x50, 0xb1 },	/* PBER Counter reset */
+	{ 0x51, 0x07 },
+	{ 0x51, 0x01 },
+};
+
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
 			     u8 i2c_addr, int reg, int data)
 {
@@ -221,7 +241,7 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 
 	if (rc != 2) {
 		rc("%s: reg=0x%x (error=%d)\n", __func__, reg, rc);
-		return rc;
+		return (rc < 0) ? rc : -EIO;
 	}
 
 	return val;
@@ -276,59 +296,61 @@ err:
 	return rc;
 }
 
-static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
 	unsigned rf_max, rf_min, rf;
-	u8	 val;
-
-	dprintk("\n");
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
-			break;
+			rf = (rf_max + rf_min) / 2;
+
+			/* Rescale it from 2^12 (4096) to 2^16 */
+			rf <<= (16 - 12);
+			dprintk("signal strength = %d\n", rf);
+			return rf;
 		}
 	} while (1);
 
-	dprintk("signal strength = %d\n", *strength);
-
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
-
 	return 0;
 }
 
 static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	u8 val;
+	int val;
 
 	dprintk("\n");
 	*status = 0;
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
 	val = mb86a20s_readreg(state, 0x0a) & 0xf;
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 1);
+	if (val < 0)
+		return val;
 
 	if (val >= 2)
 		*status |= FE_HAS_SIGNAL;
@@ -350,6 +372,8 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 }
 
+static int mb86a20s_reset_counters(struct dvb_frontend *fe);
+
 static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -387,6 +411,8 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	mb86a20s_reset_counters(fe);
+
 	return rc;
 }
 
@@ -530,9 +556,6 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 	/* Reset frontend cache to default values */
 	mb86a20s_reset_frontend_cache(fe);
 
-	if (fe->ops.i2c_gate_ctrl)
-		fe->ops.i2c_gate_ctrl(fe, 0);
-
 	/* Check for partial reception */
 	rc = mb86a20s_writereg(state, 0x6d, 0x85);
 	if (rc < 0)
@@ -609,15 +632,305 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 			break;
 		}
 	}
+	return 0;
 
 error:
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
+	int rc, val, i;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	/* Reset the counters */
+	memset(&c->strength, 0, sizeof(c->strength));
+	memset(&c->cnr, 0, sizeof(c->cnr));
+	memset(&c->bit_error, 0, sizeof(c->bit_error));
+	memset(&c->bit_count, 0, sizeof(c->bit_count));
+	memset(&c->block_error, 0, sizeof(c->block_error));
+	memset(&c->block_count, 0, sizeof(c->block_count));
+
+	/* Clear status for most stats */
+
+	/* BER counter reset */
+	rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
+	if (rc < 0)
+		goto err;
+	for (i = 0; i < 3; i++)
+		state->read_ber[i] = true;
+
+	/* MER, PER counter reset */
+	rc = mb86a20s_writeregdata(state, mb86a20s_clear_stats);
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
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	return rc;
+}
+
+static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
+					  unsigned layer,
+					  u32 *error, u32 *count)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	u8 byte[3];
+	int rc;
 
+	if (layer >= 3)
+		return -EINVAL;
+
+	/* Check if the BER measures are already available */
+	rc = mb86a20s_readreg(state, 0x54);
+	if (rc < 0)
+		return rc;
+
+	/* Check if data is available for that layer */
+	if (!(rc & (1 << layer)))
+		return -EBUSY;
+
+	/* Read Bit Error Count */
+	rc = mb86a20s_readreg(state, 0x55 + layer * 3);
+	if (rc < 0)
+		return rc;
+	byte[0] = rc;
+	rc = mb86a20s_readreg(state, 0x56 + layer * 3);
+	if (rc < 0)
+		return rc;
+	byte[1] = rc;
+	rc = mb86a20s_readreg(state, 0x57 + layer * 3);
+	if (rc < 0)
+		return rc;
+	byte[2] = rc;
+	*error = byte[0] << 16 | byte[1] << 8 | byte[2];
+
+	/* Read Bit Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	byte[0] = rc;
+	rc = mb86a20s_writereg(state, 0x50, 0xa8 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	byte[1] = rc;
+	rc = mb86a20s_writereg(state, 0x50, 0xa9 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	byte[2] = rc;
+	*count = byte[0] << 16 | byte[1] << 8 | byte[2];
+
+	return rc;
+}
+
+static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int i;
+
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
 
+static int mb86a20s_get_stats(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc = 0, i;
+	u32 bit_error = 0, bit_count = 0;
+	u32 t_bit_error = 0, t_bit_count = 0;
+	int active_layers = 0, ber_layers = 0;
+
+	/* Get per-layer stats */
+	for (i = 0; i < 3; i++) {
+		if (c->isdbt_layer_enabled & (1 << i)) {
+			/* Layer is active and has rc segments */
+			active_layers++;
+
+			if (state->read_ber[i]) {
+				/* Handle BER before vterbi */
+				rc = mb86a20s_get_ber_before_vterbi(fe, i,
+								&bit_error,
+								&bit_count);
+				if (rc >= 0) {
+					c->bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+					c->bit_error.stat[1 + i].uvalue += bit_error;
+					c->bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+					c->bit_count.stat[1 + i].uvalue += bit_count;
+
+					state->read_ber[i] = false;
+				} else if (rc != -EBUSY) {
+					/*
+					 * If an I/O error happened,
+					 * measures are now unavailable
+					 */
+					c->bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+					c->bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				}
+			}
+			if (!state->read_ber[i]) {
+				/* Update total BER counter */
+				t_bit_error += c->bit_error.stat[1 + i].uvalue;
+				t_bit_count += c->bit_count.stat[1 + i].uvalue;
+
+				ber_layers++;
+			}
+		}
+	}
+
+	if (active_layers == ber_layers) {
+		/*
+		 * All BER values are read. We can now calculate the total BER
+		 * And ask for another BER measure
+		 *
+		 * Total Bit Error/Count is calculated as the sum of the
+		 * bit errors on all active layers.
+		 */
+		c->bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_error.stat[0].uvalue += t_bit_error;
+		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_count.stat[0].uvalue += t_bit_count;
+
+		/* Reset counters to collect new data */
+		rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
+
+		/* All BER measures need to be collected when ready */
+		for (i = 0; i < 3; i++)
+			state->read_ber[i] = true;
+	}
+	return rc;
+}
+
+static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
+					  fe_status_t *status)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
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
+
+		/* Get statistics */
+		rc = mb86a20s_get_stats(fe);
+		if (rc < 0)
+			goto error;
+	}
+	goto ok;
+
+error:
+	mb86a20s_stats_not_ready(fe);
+
+ok:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
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
+
+	return 0;
+}
+
+
 static int mb86a20s_tune(struct dvb_frontend *fe,
 			bool re_tune,
 			unsigned int mode_flags,
@@ -632,7 +945,7 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 		rc = mb86a20s_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
-		mb86a20s_read_status(fe, status);
+		mb86a20s_read_status_and_stats(fe, status);
 
 	return rc;
 }
@@ -712,9 +1025,8 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
-	.get_frontend = mb86a20s_get_frontend,
-	.read_status = mb86a20s_read_status,
-	.read_signal_strength = mb86a20s_read_signal_strength,
+	.read_status = mb86a20s_read_status_and_stats,
+	.read_signal_strength = mb86a20s_read_signal_strength_from_cache,
 	.tune = mb86a20s_tune,
 };
 
-- 
1.7.11.7

