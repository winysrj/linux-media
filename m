Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/10] [media] as102: get rid of as10x_fe_copy_tps_parameters()
Date: Tue, 12 Aug 2014 18:50:21 -0300
Message-Id: <1407880224-374-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function just converts from the as10x internal data into
the DVBv5 cache. Get rid of it.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_fe.c | 201 ++++++++++++++++++-------------------
 1 file changed, 98 insertions(+), 103 deletions(-)

diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 975ad638ee41..0cd19f23eca9 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -30,104 +30,6 @@ struct as102_state {
 	uint32_t ber;
 };
 
-static void as10x_fe_copy_tps_parameters(struct dtv_frontend_properties *fe_tps,
-					 struct as10x_tps *as10x_tps)
-{
-
-	/* extract constellation */
-	switch (as10x_tps->modulation) {
-	case CONST_QPSK:
-		fe_tps->modulation = QPSK;
-		break;
-	case CONST_QAM16:
-		fe_tps->modulation = QAM_16;
-		break;
-	case CONST_QAM64:
-		fe_tps->modulation = QAM_64;
-		break;
-	}
-
-	/* extract hierarchy */
-	switch (as10x_tps->hierarchy) {
-	case HIER_NONE:
-		fe_tps->hierarchy = HIERARCHY_NONE;
-		break;
-	case HIER_ALPHA_1:
-		fe_tps->hierarchy = HIERARCHY_1;
-		break;
-	case HIER_ALPHA_2:
-		fe_tps->hierarchy = HIERARCHY_2;
-		break;
-	case HIER_ALPHA_4:
-		fe_tps->hierarchy = HIERARCHY_4;
-		break;
-	}
-
-	/* extract code rate HP */
-	switch (as10x_tps->code_rate_HP) {
-	case CODE_RATE_1_2:
-		fe_tps->code_rate_HP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		fe_tps->code_rate_HP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		fe_tps->code_rate_HP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		fe_tps->code_rate_HP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		fe_tps->code_rate_HP = FEC_7_8;
-		break;
-	}
-
-	/* extract code rate LP */
-	switch (as10x_tps->code_rate_LP) {
-	case CODE_RATE_1_2:
-		fe_tps->code_rate_LP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		fe_tps->code_rate_LP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		fe_tps->code_rate_LP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		fe_tps->code_rate_LP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		fe_tps->code_rate_LP = FEC_7_8;
-		break;
-	}
-
-	/* extract guard interval */
-	switch (as10x_tps->guard_interval) {
-	case GUARD_INT_1_32:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_32;
-		break;
-	case GUARD_INT_1_16:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_16;
-		break;
-	case GUARD_INT_1_8:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_8;
-		break;
-	case GUARD_INT_1_4:
-		fe_tps->guard_interval = GUARD_INTERVAL_1_4;
-		break;
-	}
-
-	/* extract transmission mode */
-	switch (as10x_tps->transmission_mode) {
-	case TRANS_MODE_2K:
-		fe_tps->transmission_mode = TRANSMISSION_MODE_2K;
-		break;
-	case TRANS_MODE_8K:
-		fe_tps->transmission_mode = TRANSMISSION_MODE_8K;
-		break;
-	}
-}
-
 static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
 {
 	uint8_t c;
@@ -300,7 +202,7 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 static int as102_fe_get_frontend(struct dvb_frontend *fe)
 {
 	struct as102_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret = 0;
 	struct as10x_tps tps = { 0 };
 
@@ -310,12 +212,105 @@ static int as102_fe_get_frontend(struct dvb_frontend *fe)
 	/* send abilis command: GET_TPS */
 	ret = as10x_cmd_get_tps(state->bus_adap, &tps);
 
-	if (ret == 0)
-		as10x_fe_copy_tps_parameters(p, &tps);
-
 	mutex_unlock(&state->bus_adap->lock);
 
-	return (ret < 0) ? -EINVAL : 0;
+	if (ret < 0)
+		return ret;
+
+	/* extract constellation */
+	switch (tps.modulation) {
+	case CONST_QPSK:
+		c->modulation = QPSK;
+		break;
+	case CONST_QAM16:
+		c->modulation = QAM_16;
+		break;
+	case CONST_QAM64:
+		c->modulation = QAM_64;
+		break;
+	}
+
+	/* extract hierarchy */
+	switch (tps.hierarchy) {
+	case HIER_NONE:
+		c->hierarchy = HIERARCHY_NONE;
+		break;
+	case HIER_ALPHA_1:
+		c->hierarchy = HIERARCHY_1;
+		break;
+	case HIER_ALPHA_2:
+		c->hierarchy = HIERARCHY_2;
+		break;
+	case HIER_ALPHA_4:
+		c->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	/* extract code rate HP */
+	switch (tps.code_rate_HP) {
+	case CODE_RATE_1_2:
+		c->code_rate_HP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		c->code_rate_HP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		c->code_rate_HP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		c->code_rate_HP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		c->code_rate_HP = FEC_7_8;
+		break;
+	}
+
+	/* extract code rate LP */
+	switch (tps.code_rate_LP) {
+	case CODE_RATE_1_2:
+		c->code_rate_LP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		c->code_rate_LP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		c->code_rate_LP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		c->code_rate_LP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		c->code_rate_LP = FEC_7_8;
+		break;
+	}
+
+	/* extract guard interval */
+	switch (tps.guard_interval) {
+	case GUARD_INT_1_32:
+		c->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case GUARD_INT_1_16:
+		c->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case GUARD_INT_1_8:
+		c->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case GUARD_INT_1_4:
+		c->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
+
+	/* extract transmission mode */
+	switch (tps.transmission_mode) {
+	case TRANS_MODE_2K:
+		c->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case TRANS_MODE_8K:
+		c->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
+	}
+
+	return 0;
 }
 
 static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
-- 
1.9.3

