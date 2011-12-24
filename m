Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp50x017044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 09/47] [media] mxl5005s: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:14 -0200
Message-Id: <1324741852-26138-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-9-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mxl5005s.c |   65 ++++++++++++++-----------------
 1 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index 54be9e6..c63f767 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -3983,50 +3983,43 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
 	struct mxl5005s_state *state = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
+	u32 bw = c->bandwidth_hz;
 	u32 req_mode, req_bw = 0;
 	int ret;
 
 	dprintk(1, "%s()\n", __func__);
 
-	if (fe->ops.info.type == FE_ATSC) {
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-			req_mode = MXL_ATSC; break;
-		default:
-		case QAM_64:
-		case QAM_256:
-		case QAM_AUTO:
-			req_mode = MXL_QAM; break;
-		}
-	} else
+	switch (delsys) {
+	case SYS_ATSC:
+		req_mode = MXL_ATSC;
+		req_bw  = MXL5005S_BANDWIDTH_6MHZ;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		req_mode = MXL_QAM;
+		req_bw  = MXL5005S_BANDWIDTH_6MHZ;
+		break;
+	default:	/* Assume DVB-T */
 		req_mode = MXL_DVBT;
-
-	/* Change tuner for new modulation type if reqd */
-	if (req_mode != state->current_mode) {
-		switch (req_mode) {
-		case MXL_ATSC:
-		case MXL_QAM:
-			req_bw  = MXL5005S_BANDWIDTH_6MHZ;
+		switch (bw) {
+		case 6000000:
+			req_bw = MXL5005S_BANDWIDTH_6MHZ;
+			break;
+		case 7000000:
+			req_bw = MXL5005S_BANDWIDTH_7MHZ;
+			break;
+		case 8000000:
+		case 0:
+			req_bw = MXL5005S_BANDWIDTH_8MHZ;
 			break;
-		case MXL_DVBT:
 		default:
-			/* Assume DVB-T */
-			switch (params->u.ofdm.bandwidth) {
-			case BANDWIDTH_6_MHZ:
-				req_bw  = MXL5005S_BANDWIDTH_6MHZ;
-				break;
-			case BANDWIDTH_7_MHZ:
-				req_bw  = MXL5005S_BANDWIDTH_7MHZ;
-				break;
-			case BANDWIDTH_AUTO:
-			case BANDWIDTH_8_MHZ:
-				req_bw  = MXL5005S_BANDWIDTH_8MHZ;
-				break;
-			default:
-				return -EINVAL;
-			}
+			return -EINVAL;
 		}
+	}
 
+	/* Change tuner for new modulation type if reqd */
+	if (req_mode != state->current_mode) {
 		state->current_mode = req_mode;
 		ret = mxl5005s_reconfigure(fe, req_mode, req_bw);
 
@@ -4034,8 +4027,8 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
 		ret = 0;
 
 	if (ret == 0) {
-		dprintk(1, "%s() freq=%d\n", __func__, params->frequency);
-		ret = mxl5005s_SetRfFreqHz(fe, params->frequency);
+		dprintk(1, "%s() freq=%d\n", __func__, c->frequency);
+		ret = mxl5005s_SetRfFreqHz(fe, c->frequency);
 	}
 
 	return ret;
-- 
1.7.8.352.g876a6

