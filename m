Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/10] [media] as102: get rid of as102_fe_copy_tune_parameters()
Date: Tue, 12 Aug 2014 18:50:20 -0300
Message-Id: <1407880224-374-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function just parses the frontend cache and converts
to the as102 internal format message. Get rid of it.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_fe.c | 117 +++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 62 deletions(-)

diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 7ec1c67ba119..975ad638ee41 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -156,144 +156,137 @@ static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
 	return c;
 }
 
-static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
-			  struct dtv_frontend_properties *params)
+static int as102_fe_set_frontend(struct dvb_frontend *fe)
 {
+	struct as102_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as10x_tune_args tune_args = { 0 };
 
 	/* set frequency */
-	tune_args->freq = params->frequency / 1000;
+	tune_args.freq = c->frequency / 1000;
 
 	/* fix interleaving_mode */
-	tune_args->interleaving_mode = INTLV_NATIVE;
+	tune_args.interleaving_mode = INTLV_NATIVE;
 
-	switch (params->bandwidth_hz) {
+	switch (c->bandwidth_hz) {
 	case 8000000:
-		tune_args->bandwidth = BW_8_MHZ;
+		tune_args.bandwidth = BW_8_MHZ;
 		break;
 	case 7000000:
-		tune_args->bandwidth = BW_7_MHZ;
+		tune_args.bandwidth = BW_7_MHZ;
 		break;
 	case 6000000:
-		tune_args->bandwidth = BW_6_MHZ;
+		tune_args.bandwidth = BW_6_MHZ;
 		break;
 	default:
-		tune_args->bandwidth = BW_8_MHZ;
+		tune_args.bandwidth = BW_8_MHZ;
 	}
 
-	switch (params->guard_interval) {
+	switch (c->guard_interval) {
 	case GUARD_INTERVAL_1_32:
-		tune_args->guard_interval = GUARD_INT_1_32;
+		tune_args.guard_interval = GUARD_INT_1_32;
 		break;
 	case GUARD_INTERVAL_1_16:
-		tune_args->guard_interval = GUARD_INT_1_16;
+		tune_args.guard_interval = GUARD_INT_1_16;
 		break;
 	case GUARD_INTERVAL_1_8:
-		tune_args->guard_interval = GUARD_INT_1_8;
+		tune_args.guard_interval = GUARD_INT_1_8;
 		break;
 	case GUARD_INTERVAL_1_4:
-		tune_args->guard_interval = GUARD_INT_1_4;
+		tune_args.guard_interval = GUARD_INT_1_4;
 		break;
 	case GUARD_INTERVAL_AUTO:
 	default:
-		tune_args->guard_interval = GUARD_UNKNOWN;
+		tune_args.guard_interval = GUARD_UNKNOWN;
 		break;
 	}
 
-	switch (params->modulation) {
+	switch (c->modulation) {
 	case QPSK:
-		tune_args->modulation = CONST_QPSK;
+		tune_args.modulation = CONST_QPSK;
 		break;
 	case QAM_16:
-		tune_args->modulation = CONST_QAM16;
+		tune_args.modulation = CONST_QAM16;
 		break;
 	case QAM_64:
-		tune_args->modulation = CONST_QAM64;
+		tune_args.modulation = CONST_QAM64;
 		break;
 	default:
-		tune_args->modulation = CONST_UNKNOWN;
+		tune_args.modulation = CONST_UNKNOWN;
 		break;
 	}
 
-	switch (params->transmission_mode) {
+	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
-		tune_args->transmission_mode = TRANS_MODE_2K;
+		tune_args.transmission_mode = TRANS_MODE_2K;
 		break;
 	case TRANSMISSION_MODE_8K:
-		tune_args->transmission_mode = TRANS_MODE_8K;
+		tune_args.transmission_mode = TRANS_MODE_8K;
 		break;
 	default:
-		tune_args->transmission_mode = TRANS_MODE_UNKNOWN;
+		tune_args.transmission_mode = TRANS_MODE_UNKNOWN;
 	}
 
-	switch (params->hierarchy) {
+	switch (c->hierarchy) {
 	case HIERARCHY_NONE:
-		tune_args->hierarchy = HIER_NONE;
+		tune_args.hierarchy = HIER_NONE;
 		break;
 	case HIERARCHY_1:
-		tune_args->hierarchy = HIER_ALPHA_1;
+		tune_args.hierarchy = HIER_ALPHA_1;
 		break;
 	case HIERARCHY_2:
-		tune_args->hierarchy = HIER_ALPHA_2;
+		tune_args.hierarchy = HIER_ALPHA_2;
 		break;
 	case HIERARCHY_4:
-		tune_args->hierarchy = HIER_ALPHA_4;
+		tune_args.hierarchy = HIER_ALPHA_4;
 		break;
 	case HIERARCHY_AUTO:
-		tune_args->hierarchy = HIER_UNKNOWN;
+		tune_args.hierarchy = HIER_UNKNOWN;
 		break;
 	}
 
 	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
-			params->frequency,
-			tune_args->bandwidth,
-			tune_args->guard_interval);
+			c->frequency,
+			tune_args.bandwidth,
+			tune_args.guard_interval);
 
 	/*
 	 * Detect a hierarchy selection
 	 * if HP/LP are both set to FEC_NONE, HP will be selected.
 	 */
-	if ((tune_args->hierarchy != HIER_NONE) &&
-		       ((params->code_rate_LP == FEC_NONE) ||
-			(params->code_rate_HP == FEC_NONE))) {
-
-		if (params->code_rate_LP == FEC_NONE) {
-			tune_args->hier_select = HIER_HIGH_PRIORITY;
-			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->code_rate_HP);
+	if ((tune_args.hierarchy != HIER_NONE) &&
+		       ((c->code_rate_LP == FEC_NONE) ||
+			(c->code_rate_HP == FEC_NONE))) {
+
+		if (c->code_rate_LP == FEC_NONE) {
+			tune_args.hier_select = HIER_HIGH_PRIORITY;
+			tune_args.code_rate =
+			   as102_fe_get_code_rate(c->code_rate_HP);
 		}
 
-		if (params->code_rate_HP == FEC_NONE) {
-			tune_args->hier_select = HIER_LOW_PRIORITY;
-			tune_args->code_rate =
-			   as102_fe_get_code_rate(params->code_rate_LP);
+		if (c->code_rate_HP == FEC_NONE) {
+			tune_args.hier_select = HIER_LOW_PRIORITY;
+			tune_args.code_rate =
+			   as102_fe_get_code_rate(c->code_rate_LP);
 		}
 
 		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
-			tune_args->hierarchy,
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			tune_args.hierarchy,
+			tune_args.hier_select == HIER_HIGH_PRIORITY ?
 			"HP" : "LP",
-			tune_args->hier_select == HIER_HIGH_PRIORITY ?
+			tune_args.hier_select == HIER_HIGH_PRIORITY ?
 			"HP" : "LP",
-			tune_args->code_rate);
+			tune_args.code_rate);
 	} else {
-		tune_args->code_rate =
-			as102_fe_get_code_rate(params->code_rate_HP);
+		tune_args.code_rate =
+			as102_fe_get_code_rate(c->code_rate_HP);
 	}
-}
-
-static int as102_fe_set_frontend(struct dvb_frontend *fe)
-{
-	struct as102_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as10x_tune_args tune_args = { 0 };
 
+	/* Set frontend arguments */
 	if (mutex_lock_interruptible(&state->bus_adap->lock))
 		return -EBUSY;
 
-	as102_fe_copy_tune_parameters(&tune_args, p);
-
-	/* send abilis command: SET_TUNE */
 	ret =  as10x_cmd_set_tune(state->bus_adap, &tune_args);
 	if (ret != 0)
 		dev_dbg(&state->bus_adap->usb_dev->dev,
-- 
1.9.3

