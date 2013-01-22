Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab3AVQpA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:45:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MGj0a4014249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:45:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REVIEW PATCHv12 4/6] [media] mb86a20s: add BER measurement
Date: Tue, 22 Jan 2013 14:44:18 -0200
Message-Id: <1358873060-27609-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
References: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the methods to read bit error/bit count measurements from
mb86a20s. On ISDB-T devices, those reads are done per layer.

However, as userspace applications may not be aware of that,
add a global measure that will sum the bit errors and bit
counts for each layer, storing them into a global value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
v12: minor changes:
- Rebased on the top of the previous patch;
- BER function was splitted on this patch and merged with a few
  fixup patches.

 drivers/media/dvb-frontends/mb86a20s.c | 181 ++++++++++++++++++++++++++++++++-
 1 file changed, 178 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index b307cb3..0017ecb 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -649,10 +649,95 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 	if (rc < 0)
 		goto err;
 
+	goto ok;
 err:
+	dev_err(&state->i2c->dev,
+		"%s: Can't reset FE statistics (error %d).\n",
+		__func__, rc);
+ok:
 	return rc;
 }
 
+static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
+					  unsigned layer,
+					  u32 *error, u32 *count)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
+	if (layer >= 3)
+		return -EINVAL;
+
+	/* Check if the BER measures are already available */
+	rc = mb86a20s_readreg(state, 0x54);
+	if (rc < 0)
+		return rc;
+
+	/* Check if data is available for that layer */
+	if (!(rc & (1 << layer))) {
+		dev_dbg(&state->i2c->dev,
+			"%s: BER for layer %c is not available yet.\n",
+			__func__, 'A' + layer);
+		return -EBUSY;
+	}
+
+	/* Read Bit Error Count */
+	rc = mb86a20s_readreg(state, 0x55 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error = rc << 16;
+	rc = mb86a20s_readreg(state, 0x56 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error |= rc << 8;
+	rc = mb86a20s_readreg(state, 0x57 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error |= rc;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: bit error before Viterbi for layer %c: %d.\n",
+		__func__, 'A' + layer, *error);
+
+	/* Read Bit Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*count = rc << 16;
+	rc = mb86a20s_writereg(state, 0x50, 0xa8 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*count |= rc << 8;
+	rc = mb86a20s_writereg(state, 0x50, 0xa9 + layer * 3);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*count |= rc;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: bit count before Viterbi for layer %c: %d.\n",
+		__func__, 'A' + layer, *count);
+
+
+	/* Reset counter to collect new data */
+	rc = mb86a20s_writereg(state, 0x53, 0x07 & ~(1 << layer));
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x53, 0x07);
+
+	return 0;
+}
+
 static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -687,6 +772,72 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	}
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
+			/* Read per-layer BER */
+			/* Handle BER before vterbi */
+			rc = mb86a20s_get_ber_before_vterbi(fe, i,
+							&bit_error,
+							&bit_count);
+			if (rc >= 0) {
+				c->bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->bit_error.stat[1 + i].uvalue += bit_error;
+				c->bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->bit_count.stat[1 + i].uvalue += bit_count;
+			} else if (rc != -EBUSY) {
+				/*
+					* If an I/O error happened,
+					* measures are now unavailable
+					*/
+				c->bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				dev_err(&state->i2c->dev,
+					"%s: Can't get BER for layer %c (error %d).\n",
+					__func__, 'A' + i, rc);
+			}
+
+			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+				ber_layers++;
+
+			/* Update total BER */
+			t_bit_error += c->bit_error.stat[1 + i].uvalue;
+			t_bit_count += c->bit_count.stat[1 + i].uvalue;
+		}
+	}
+
+	/*
+	 * Start showing global count if at least one error count is
+	 * available.
+	 */
+	if (ber_layers) {
+		/*
+		 * At least one per-layer BER measure was read. We can now
+		 * calculate the total BER
+		 *
+		 * Total Bit Error/Count is calculated as the sum of the
+		 * bit errors on all active layers.
+		 */
+		c->bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_error.stat[0].uvalue = t_bit_error;
+		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_count.stat[0].uvalue = t_bit_count;
+	}
+
+	return rc;
+}
 
 /*
  * The functions below are called via DVB callbacks, so they need to
@@ -796,14 +947,21 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
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
@@ -812,15 +970,32 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 	if (*status & FE_HAS_LOCK) {
 		/* Get TMCC info*/
 		rc = mb86a20s_get_frontend(fe);
-		if (rc < 0)
+		if (rc < 0) {
+			dev_err(&state->i2c->dev,
+				"%s: Can't get FE TMCC data.\n", __func__);
+			rc = 0;		/* Status is OK */
+			goto error;
+		}
+
+		/* Get statistics */
+		rc = mb86a20s_get_stats(fe);
+		if (rc < 0 && rc != -EBUSY) {
+			dev_err(&state->i2c->dev,
+				"%s: Can't get FE statistics.\n", __func__);
+			rc = 0;
 			goto error;
+		}
+		rc = 0;	/* Don't return EBUSY to userspace */
 	}
+	goto ok;
 
+error:
 	mb86a20s_stats_not_ready(fe);
 
+ok:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
-error:
+
 	return rc;
 }
 
-- 
1.7.11.7

