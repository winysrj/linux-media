Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab3AHA0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 19:26:23 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r080QN58025784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jan 2013 19:26:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv9 4/4] mb86a20s: add BER measure
Date: Mon,  7 Jan 2013 22:25:50 -0200
Message-Id: <1357604750-772-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1357604750-772-1-git-send-email-mchehab@redhat.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add per-layer BER measure. In order to provide some data for
applications not prepared for layers support, calculate BER for
the worse-case scenario, e. g. sums the BER values for all layers
and provide it as a "global BER" value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 99 ++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c2cc207..7ecee12 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -94,7 +94,7 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x04, 0x13 }, { 0x05, 0xff },
 	{ 0x04, 0x15 }, { 0x05, 0x4e },
 	{ 0x04, 0x16 }, { 0x05, 0x20 },
-	{ 0x52, 0x01 },
+	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
 	{ 0x50, 0xa7 }, { 0x51, 0xff },
 	{ 0x50, 0xa8 }, { 0x51, 0xff },
 	{ 0x50, 0xa9 }, { 0x51, 0xff },
@@ -705,13 +705,76 @@ err:
 	return rc;
 }
 
-static int mb86a20s_get_stats(struct dvb_frontend *fe)
+static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
+					  unsigned layer,
+					  u32 *error, u32 *count)
 {
-	int rc, i;
-	__u16 strength;
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	u8 byte[3];
+	int rc;
+
+	if (layer >= 3)
+		return -EINVAL;
+
+	/* Check if it is available */
+	rc = mb86a20s_readreg(state, 0x54);
+	if (rc < 0)
+		return rc;
+	/* Check if data is available for that layer */
+	if (!(rc & (1 << layer)))
+		return -EBUSY;
+
+	/* Read Bit Error Count */
+	rc = mb86a20s_readreg(state, 0x55 + layer);
+	if (rc < 0)
+		return rc;
+	byte[0] = rc;
+	rc = mb86a20s_readreg(state, 0x56 + layer);
+	if (rc < 0)
+		return rc;
+	byte[1] = rc;
+	rc = mb86a20s_readreg(state, 0x57 + layer);
+	if (rc < 0)
+		return rc;
+	byte[2] = rc;
+	*error = byte[0] << 16 | byte[1] << 8 | byte[2];
 
+	/* Read Bit Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	byte[0] = rc;
+	rc = mb86a20s_writereg(state, 0x50, 0xa8 + layer);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	byte[1] = rc;
+	rc = mb86a20s_writereg(state, 0x50, 0xa9 + layer);
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
+static int mb86a20s_get_stats(struct dvb_frontend *fe)
+{
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int rc, i;
+	u16 strength;
+	u32 bit_error = 0, bit_count = 0;
+	u32 t_bit_error = 0, t_bit_count = 0;
+	bool has_total_ber = true;
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -732,10 +795,36 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		if (rc > 0 && rc < 14) {
 			/* Layer is active and has rc segments */
 
-			/* FIXME: add a per-layer stats logic */
+			/* Handle BER before vterbi */
+			rc = mb86a20s_get_ber_before_vterbi(fe, i, &bit_error,
+							    &bit_count);
+			if (rc >= 0) {
+				c->bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->bit_error.stat[1 + i].uvalue = bit_error;
+				c->bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->bit_count.stat[1 + i].uvalue = bit_count;
+			}
+			if (c->bit_error.stat[1 + i].scale != FE_SCALE_COUNTER)
+				has_total_ber = false;
+			else {
+				t_bit_error += c->bit_error.stat[1 + i].uvalue;
+				t_bit_count += c->bit_count.stat[1 + i].uvalue;
+			}
+
 		}
 	}
 
+	if (has_total_ber) {
+		/*
+		 * Total Bit Error/Count is calculated as the sum of the
+		 * bit errors on all active layers.
+		 */
+		c->bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_error.stat[0].uvalue = t_bit_error;
+		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->bit_count.stat[0].uvalue = t_bit_count;
+	}
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-- 
1.7.11.7

