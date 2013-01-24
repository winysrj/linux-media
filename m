Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567Ab3AXQ2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:28:55 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0OGStYt003121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 11:28:55 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/5] [media] mb86a20s: fix the PER reset logic
Date: Thu, 24 Jan 2013 14:28:49 -0200
Message-Id: <1359044931-13058-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
References: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic that resets the device is wrong. It should be resetting
just the layer that got read. Also, stop is needed before updating
the counters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 40 +++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 305ebc0..7d4e911 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -934,7 +934,7 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 			    u32 *error, u32 *count)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	int rc;
+	int rc, val;
 	u32 collect_rate;
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -1007,7 +1007,6 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 		goto reset_measurement;
 
 	collect_rate = state->estimated_rate[layer] / 204 / 8;
-
 	if (collect_rate < 32)
 		collect_rate = 32;
 	if (collect_rate > 65535)
@@ -1017,6 +1016,16 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 		dev_dbg(&state->i2c->dev,
 			"%s: updating PER counter on layer %c to %d.\n",
 			__func__, 'A' + layer, collect_rate);
+
+		/* Stop PER measurement */
+		rc = mb86a20s_writereg(state, 0x50, 0xb0);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, 0x00);
+		if (rc < 0)
+			return rc;
+
+		/* Update this layer's counter */
 		rc = mb86a20s_writereg(state, 0x50, 0xb2 + layer * 2);
 		if (rc < 0)
 			return rc;
@@ -1029,6 +1038,25 @@ static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
 		rc = mb86a20s_writereg(state, 0x51, collect_rate & 0xff);
 		if (rc < 0)
 			return rc;
+
+		/* start PER measurement */
+		rc = mb86a20s_writereg(state, 0x50, 0xb0);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, 0x07);
+		if (rc < 0)
+			return rc;
+
+		/* Reset all counters to collect new data */
+		rc = mb86a20s_writereg(state, 0x50, 0xb1);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, 0x07);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, 0x00);
+
+		return rc;
 	}
 
 reset_measurement:
@@ -1036,14 +1064,16 @@ reset_measurement:
 	rc = mb86a20s_writereg(state, 0x50, 0xb1);
 	if (rc < 0)
 		return rc;
-	rc = mb86a20s_writereg(state, 0x51, (1 << layer));
+	rc = mb86a20s_readreg(state, 0x51);
 	if (rc < 0)
 		return rc;
-	rc = mb86a20s_writereg(state, 0x51, 0x00);
+	val = rc;
+	rc = mb86a20s_writereg(state, 0x51, val | (1 << layer));
 	if (rc < 0)
 		return rc;
+	rc = mb86a20s_writereg(state, 0x51, val & ~(1 << layer));
 
-	return 0;
+	return rc;
 }
 
 struct linear_segments {
-- 
1.8.1

