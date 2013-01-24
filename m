Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab3AXQ2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:28:55 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0OGStTh032740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 11:28:55 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] [media] mb86a20s: some fixes at preBER logic
Date: Thu, 24 Jan 2013 14:28:48 -0200
Message-Id: <1359044931-13058-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
References: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that resets the device is wrong. It should be resetting
just the layer that got read. Also, stop is needed before updating
the counters.
While there, rename it, as we'll soon introduce a postBER logic
there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 51 ++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c5c2c49..305ebc0 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -785,12 +785,12 @@ ok:
 	return rc;
 }
 
-static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
-					  unsigned layer,
-					  u32 *error, u32 *count)
+static int mb86a20s_get_pre_ber(struct dvb_frontend *fe,
+				unsigned layer,
+				u32 *error, u32 *count)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc;
+	int rc, val;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -805,7 +805,7 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	/* Check if data is available for that layer */
 	if (!(rc & (1 << layer))) {
 		dev_dbg(&state->i2c->dev,
-			"%s: BER for layer %c is not available yet.\n",
+			"%s: preBER for layer %c is not available yet.\n",
 			__func__, 'A' + layer);
 		return -EBUSY;
 	}
@@ -866,8 +866,13 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	if (state->estimated_rate[layer]
 	    && state->estimated_rate[layer] != *count) {
 		dev_dbg(&state->i2c->dev,
-			"%s: updating layer %c counter to %d.\n",
+			"%s: updating layer %c preBER counter to %d.\n",
 			__func__, 'A' + layer, state->estimated_rate[layer]);
+
+		/* Turn off BER before Viterbi */
+		rc = mb86a20s_writereg(state, 0x52, 0x00);
+
+		/* Update counter for this layer */
 		rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer * 3);
 		if (rc < 0)
 			return rc;
@@ -889,16 +894,39 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 				       state->estimated_rate[layer]);
 		if (rc < 0)
 			return rc;
+
+		/* Turn on BER before Viterbi */
+		rc = mb86a20s_writereg(state, 0x52, 0x01);
+
+		/* Reset all preBER counters */
+		rc = mb86a20s_writereg(state, 0x53, 0x00);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x53, 0x07);
+	} else {
+		/* Reset counter to collect new data */
+		rc = mb86a20s_readreg(state, 0x53);
+		if (rc < 0)
+			return rc;
+		val = rc;
+		rc = mb86a20s_writereg(state, 0x53, val & ~(1 << layer));
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x53, val | (1 << layer));
 	}
 
 
 	/* Reset counter to collect new data */
-	rc = mb86a20s_writereg(state, 0x53, 0x07 & ~(1 << layer));
+	rc = mb86a20s_readreg(state, 0x5f);
 	if (rc < 0)
 		return rc;
-	rc = mb86a20s_writereg(state, 0x53, 0x07);
+	val = rc;
+	rc = mb86a20s_writereg(state, 0x5f, val & ~(1 << layer));
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x5f, val);
 
-	return 0;
+	return rc;
 }
 
 static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
@@ -1401,9 +1429,8 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 
 			/* Read per-layer BER */
 			/* Handle BER before vterbi */
-			rc = mb86a20s_get_ber_before_vterbi(fe, i,
-							&bit_error,
-							&bit_count);
+			rc = mb86a20s_get_pre_ber(fe, i,
+						  &bit_error, &bit_count);
 			if (rc >= 0) {
 				c->pre_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
 				c->pre_bit_error.stat[1 + i].uvalue += bit_error;
-- 
1.8.1

