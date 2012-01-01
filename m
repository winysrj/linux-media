Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBOiY021913
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/9] [media] dvb-core: Fix ISDB-T defaults
Date: Sun,  1 Jan 2012 18:11:15 -0200
Message-Id: <1325448678-13001-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

using -1 for ISDB-T parameters do the wrong thing. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   56 ++++++++++++++--------------
 1 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index c1b3b30..ea3d0a3 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -951,17 +951,17 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	c->sectone = SEC_TONE_OFF;
 	c->pilot = PILOT_AUTO;
 
-	c->isdbt_partial_reception = -1;
-	c->isdbt_sb_mode = -1;
-	c->isdbt_sb_subchannel = -1;
-	c->isdbt_sb_segment_idx = -1;
-	c->isdbt_sb_segment_count = -1;
-	c->isdbt_layer_enabled = 0x7;
+	c->isdbt_partial_reception = 0;
+	c->isdbt_sb_mode = 0;
+	c->isdbt_sb_subchannel = 0;
+	c->isdbt_sb_segment_idx = 0;
+	c->isdbt_sb_segment_count = 0;
+	c->isdbt_layer_enabled = 0;
 	for (i = 0; i < 3; i++) {
 		c->layer[i].fec = FEC_AUTO;
 		c->layer[i].modulation = QAM_AUTO;
-		c->layer[i].interleaving = -1;
-		c->layer[i].segment_count = -1;
+		c->layer[i].interleaving = 0;
+		c->layer[i].segment_count = 0;
 	}
 
 	c->isdbs_ts_id = 0;
@@ -1528,28 +1528,28 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 		__func__, delsys, desired_system);
 
 	/*
-	 * For now, uses it for ISDB-T, DMBTH and DVB-T2
-	 * For DVB-S2 and DVB-TURBO, assumes that the DVB-S parameters are enough.
+	 * For now, handles ISDB-T calls. More code may be needed here for the
+	 * other emulated stuff
 	 */
 	if (type == DVBV3_OFDM) {
-		c->modulation = QAM_AUTO;
-		c->code_rate_HP = FEC_AUTO;
-		c->code_rate_LP = FEC_AUTO;
-		c->transmission_mode = TRANSMISSION_MODE_AUTO;
-		c->guard_interval = GUARD_INTERVAL_AUTO;
-		c->hierarchy = HIERARCHY_AUTO;
-
-		c->isdbt_partial_reception = -1;
-		c->isdbt_sb_mode = -1;
-		c->isdbt_sb_subchannel = -1;
-		c->isdbt_sb_segment_idx = -1;
-		c->isdbt_sb_segment_count = -1;
-		c->isdbt_layer_enabled = 0x7;
-		for (i = 0; i < 3; i++) {
-			c->layer[i].fec = FEC_AUTO;
-			c->layer[i].modulation = QAM_AUTO;
-			c->layer[i].interleaving = -1;
-			c->layer[i].segment_count = -1;
+		if (c->delivery_system == SYS_ISDBT) {
+			dprintk("%s() Using defaults for SYS_ISDBT\n",
+				__func__);
+			if (!c->bandwidth_hz)
+				c->bandwidth_hz = 6000000;
+
+			c->isdbt_partial_reception = 0;
+			c->isdbt_sb_mode = 0;
+			c->isdbt_sb_subchannel = 0;
+			c->isdbt_sb_segment_idx = 0;
+			c->isdbt_sb_segment_count = 0;
+			c->isdbt_layer_enabled = 0;
+			for (i = 0; i < 3; i++) {
+				c->layer[i].fec = FEC_AUTO;
+				c->layer[i].modulation = QAM_AUTO;
+				c->layer[i].interleaving = 0;
+				c->layer[i].segment_count = 0;
+			}
 		}
 	}
 	return 0;
-- 
1.7.8.352.g876a6

