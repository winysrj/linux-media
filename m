Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5MB018665
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 11/47] [media] mxl5007t: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:16 -0200
Message-Id: <1324741852-26138-12-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-11-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mxl5007t.c |   51 +++++++++++++++-----------------
 1 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 2f0e550..6c45993 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -618,44 +618,42 @@ fail:
 static int mxl5007t_set_params(struct dvb_frontend *fe,
 			       struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys = c->delivery_system;
 	struct mxl5007t_state *state = fe->tuner_priv;
 	enum mxl5007t_bw_mhz bw;
 	enum mxl5007t_mode mode;
 	int ret;
-	u32 freq = params->frequency;
+	u32 freq = c->frequency;
+	u32 band = BANDWIDTH_6_MHZ;
 
-	if (fe->ops.info.type == FE_ATSC) {
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-		case VSB_16:
-			mode = MxL_MODE_ATSC;
-			break;
-		case QAM_64:
-		case QAM_256:
-			mode = MxL_MODE_CABLE;
-			break;
-		default:
-			mxl_err("modulation not set!");
-			return -EINVAL;
-		}
+	switch (delsys) {
+	case SYS_ATSC:
+		mode = MxL_MODE_ATSC;
+		bw = MxL_BW_6MHz;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		mode = MxL_MODE_CABLE;
 		bw = MxL_BW_6MHz;
-	} else if (fe->ops.info.type == FE_OFDM) {
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		break;
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		mode = MxL_MODE_DVBT;
+		switch (c->bandwidth_hz) {
+		case 6000000:
 			bw = MxL_BW_6MHz;
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			bw = MxL_BW_7MHz;
-			break;
-		case BANDWIDTH_8_MHZ:
+			band = BANDWIDTH_7_MHZ;
+		case 8000000:
 			bw = MxL_BW_8MHz;
-			break;
+			band = BANDWIDTH_8_MHZ;
 		default:
-			mxl_err("bandwidth not set!");
 			return -EINVAL;
 		}
-		mode = MxL_MODE_DVBT;
-	} else {
+		break;
+	default:
 		mxl_err("modulation type not supported!");
 		return -EINVAL;
 	}
@@ -674,8 +672,7 @@ static int mxl5007t_set_params(struct dvb_frontend *fe,
 		goto fail;
 
 	state->frequency = freq;
-	state->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-		params->u.ofdm.bandwidth : 0;
+	state->bandwidth = band;
 fail:
 	mutex_unlock(&state->lock);
 
-- 
1.7.8.352.g876a6

