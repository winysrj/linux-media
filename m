Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163Ab3AHA0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 19:26:23 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r080QNiZ020600
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jan 2013 19:26:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv9 3/4] mb86a20s: provide signal strength via DVBv5 stats API
Date: Mon,  7 Jan 2013 22:25:49 -0200
Message-Id: <1357604750-772-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357604750-772-1-git-send-email-mchehab@redhat.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 API status handler functions.

The counter reset code there is complete for all stats provided
by this frontend.

The get_stats callback currently handles only the existing stat
(signal strength), although the code is already prepared for the
per-layer stats.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 166 +++++++++++++++++++++++++++++----
 1 file changed, 148 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fade566..c2cc207 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -119,8 +119,8 @@ static struct regdata mb86a20s_init[] = {
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
@@ -176,6 +176,18 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
+static struct regdata mb86a20s_clear_stats[] = {
+	{ 0x53, 0x00 },	/* VBER Counter reset */
+	{ 0x53, 0x07 },
+
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
@@ -223,7 +235,7 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
 
 	if (rc != 2) {
 		rc("%s: reg=0x%x (error=%d)\n", __func__, reg, rc);
-		return rc;
+		return (rc < 0) ? rc : -EIO;
 	}
 
 	return val;
@@ -278,29 +290,34 @@ err:
 	return rc;
 }
 
-static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+static int __mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
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
@@ -310,12 +327,22 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		}
 	} while (1);
 
-	dprintk("signal strength = %d\n", *strength);
+	return 0;
+}
+
+static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	int rc;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	rc = __mb86a20s_read_signal_strength(fe, strength);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	return 0;
+	return rc;
 }
 
 static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
@@ -615,6 +642,106 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 	return rc;
 }
 
+static int mb86a20s_reset_counters(struct dvb_frontend *fe)
+{
+
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	int rc, val;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	/* Set the QoS clear status for most stats */
+	rc = mb86a20s_writeregdata(state, mb86a20s_clear_stats);
+	if (rc < 0)
+		goto err;
+
+	/* CNR counter reset */
+	rc = mb86a20s_readreg(state, 0x45);
+	if (rc < 0)
+		goto err;
+
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
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* Update the length of each status counter */
+
+	/* Only global stats */
+	c->strength.len = 1;
+
+	/* Per-layer stats */
+	c->cnr.len = 4;
+	c->bit_error.len = 4;
+	c->bit_count.len = 4;
+	c->block_error.len = 4;
+	c->block_count.len = 4;
+
+	return rc;
+}
+
+static int mb86a20s_get_stats(struct dvb_frontend *fe)
+{
+	int rc, i;
+	__u16 strength;
+
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	/* Update signal relative level */
+	rc = __mb86a20s_read_signal_strength(fe, &strength);
+	c->strength.len = 1;
+	if (rc < 0) {
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	} else {
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+		c->strength.stat[0].uvalue = strength;
+	}
+
+	/* Get per-layer stats */
+	for (i = 0; i < 3; i++) {
+		rc = mb86a20s_get_segment_count(state, i);
+		if (rc > 0 && rc < 14) {
+			/* Layer is active and has rc segments */
+
+			/* FIXME: add a per-layer stats logic */
+		}
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	return rc;
+}
+
 static void mb86a20s_release(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -694,6 +821,9 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 	.read_status = mb86a20s_read_status,
 	.read_signal_strength = mb86a20s_read_signal_strength,
 	.tune = mb86a20s_tune,
+
+	.reset_qos_counters = mb86a20s_reset_counters,
+	.get_qos_stats = mb86a20s_get_stats,
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Fujitsu mb86A20s hardware");
-- 
1.7.11.7

