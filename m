Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757200Ab3AOCbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:36 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2Vaip015426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 01/15] mb86a20s: improve error handling at get_frontend
Date: Tue, 15 Jan 2013 00:30:47 -0200
Message-Id: <1358217061-14982-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The read/write errors are not handled well on get_frontend. Fix it,
by letting the frontend cached values to represent the DVB properties
that were successfully retrieved.

While here, use "c" for dtv_frontend_properties cache, instead of
"p", as this is more common.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 138 +++++++++++++++++++--------------
 1 file changed, 80 insertions(+), 58 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fade566..4ff3a0c 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1,11 +1,9 @@
 /*
  *   Fujitu mb86a20s ISDB-T/ISDB-Tsb Module driver
  *
- *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010-2013 Mauro Carvalho Chehab <mchehab@redhat.com>
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
- *   FIXME: Need to port to DVB v5.2 API
- *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License as
  *   published by the Free Software Foundation version 2.
@@ -360,7 +358,7 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	/*
 	 * FIXME: Properly implement the set frontend properties
 	 */
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 #endif
 
 	dprintk("\n");
@@ -507,93 +505,117 @@ static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
 	return count;
 }
 
+static void mb86a20s_reset_frontend_cache(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	/* Fixed parameters */
+	c->delivery_system = SYS_ISDBT;
+	c->bandwidth_hz = 6000000;
+
+	/* Initialize values that will be later autodetected */
+	c->isdbt_layer_enabled = 0;
+	c->transmission_mode = TRANSMISSION_MODE_AUTO;
+	c->guard_interval = GUARD_INTERVAL_AUTO;
+	c->isdbt_sb_mode = 0;
+	c->isdbt_sb_segment_count = 0;
+}
+
 static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int i, rc;
 
-	/* Fixed parameters */
-	p->delivery_system = SYS_ISDBT;
-	p->bandwidth_hz = 6000000;
+	/* Reset frontend cache to default values */
+	mb86a20s_reset_frontend_cache(fe);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	/* Check for partial reception */
 	rc = mb86a20s_writereg(state, 0x6d, 0x85);
-	if (rc >= 0)
-		rc = mb86a20s_readreg(state, 0x6e);
-	if (rc >= 0)
-		p->isdbt_partial_reception = (rc & 0x10) ? 1 : 0;
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x6e);
+	if (rc < 0)
+		return rc;
+	c->isdbt_partial_reception = (rc & 0x10) ? 1 : 0;
 
 	/* Get per-layer data */
-	p->isdbt_layer_enabled = 0;
+
 	for (i = 0; i < 3; i++) {
 		rc = mb86a20s_get_segment_count(state, i);
-			if (rc >= 0 && rc < 14)
-				p->layer[i].segment_count = rc;
-		if (rc == 0x0f)
+		if (rc < 0)
+			goto error;
+		if (rc >= 0 && rc < 14)
+			c->layer[i].segment_count = rc;
+		else {
+			c->layer[i].segment_count = 0;
 			continue;
-		p->isdbt_layer_enabled |= 1 << i;
+		}
+		c->isdbt_layer_enabled |= 1 << i;
 		rc = mb86a20s_get_modulation(state, i);
-			if (rc >= 0)
-				p->layer[i].modulation = rc;
+		if (rc < 0)
+			goto error;
+		c->layer[i].modulation = rc;
 		rc = mb86a20s_get_fec(state, i);
-			if (rc >= 0)
-				p->layer[i].fec = rc;
+		if (rc < 0)
+			goto error;
+		c->layer[i].fec = rc;
 		rc = mb86a20s_get_interleaving(state, i);
-			if (rc >= 0)
-				p->layer[i].interleaving = rc;
+		if (rc < 0)
+			goto error;
+		c->layer[i].interleaving = rc;
 	}
 
-	p->isdbt_sb_mode = 0;
 	rc = mb86a20s_writereg(state, 0x6d, 0x84);
-	if ((rc >= 0) && ((rc & 0x60) == 0x20)) {
-		p->isdbt_sb_mode = 1;
+	if (rc < 0)
+		return rc;
+	if ((rc & 0x60) == 0x20) {
+		c->isdbt_sb_mode = 1;
 		/* At least, one segment should exist */
-		if (!p->isdbt_sb_segment_count)
-			p->isdbt_sb_segment_count = 1;
-	} else
-		p->isdbt_sb_segment_count = 0;
+		if (!c->isdbt_sb_segment_count)
+			c->isdbt_sb_segment_count = 1;
+	}
 
 	/* Get transmission mode and guard interval */
-	p->transmission_mode = TRANSMISSION_MODE_AUTO;
-	p->guard_interval = GUARD_INTERVAL_AUTO;
 	rc = mb86a20s_readreg(state, 0x07);
-	if (rc >= 0) {
-		if ((rc & 0x60) == 0x20) {
-			switch (rc & 0x0c >> 2) {
-			case 0:
-				p->transmission_mode = TRANSMISSION_MODE_2K;
-				break;
-			case 1:
-				p->transmission_mode = TRANSMISSION_MODE_4K;
-				break;
-			case 2:
-				p->transmission_mode = TRANSMISSION_MODE_8K;
-				break;
-			}
+	if (rc < 0)
+		return rc;
+	if ((rc & 0x60) == 0x20) {
+		switch (rc & 0x0c >> 2) {
+		case 0:
+			c->transmission_mode = TRANSMISSION_MODE_2K;
+			break;
+		case 1:
+			c->transmission_mode = TRANSMISSION_MODE_4K;
+			break;
+		case 2:
+			c->transmission_mode = TRANSMISSION_MODE_8K;
+			break;
 		}
-		if (!(rc & 0x10)) {
-			switch (rc & 0x3) {
-			case 0:
-				p->guard_interval = GUARD_INTERVAL_1_4;
-				break;
-			case 1:
-				p->guard_interval = GUARD_INTERVAL_1_8;
-				break;
-			case 2:
-				p->guard_interval = GUARD_INTERVAL_1_16;
-				break;
-			}
+	}
+	if (!(rc & 0x10)) {
+		switch (rc & 0x3) {
+		case 0:
+			c->guard_interval = GUARD_INTERVAL_1_4;
+			break;
+		case 1:
+			c->guard_interval = GUARD_INTERVAL_1_8;
+			break;
+		case 2:
+			c->guard_interval = GUARD_INTERVAL_1_16;
+			break;
 		}
 	}
 
+error:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	return 0;
+	return rc;
+
 }
 
 static int mb86a20s_tune(struct dvb_frontend *fe,
-- 
1.7.11.7

