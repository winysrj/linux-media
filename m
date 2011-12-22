Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNED032755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 19/28] [media] mxl5007t: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:07 -0200
Message-Id: <1324552816-25704-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-19-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
 <1324552816-25704-9-git-send-email-mchehab@redhat.com>
 <1324552816-25704-10-git-send-email-mchehab@redhat.com>
 <1324552816-25704-11-git-send-email-mchehab@redhat.com>
 <1324552816-25704-12-git-send-email-mchehab@redhat.com>
 <1324552816-25704-13-git-send-email-mchehab@redhat.com>
 <1324552816-25704-14-git-send-email-mchehab@redhat.com>
 <1324552816-25704-15-git-send-email-mchehab@redhat.com>
 <1324552816-25704-16-git-send-email-mchehab@redhat.com>
 <1324552816-25704-17-git-send-email-mchehab@redhat.com>
 <1324552816-25704-18-git-send-email-mchehab@redhat.com>
 <1324552816-25704-19-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mxl5007t.c |   53 ++++++++++++++------------------
 1 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 2f0e550..0d4f17c 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -618,44 +618,38 @@ fail:
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
 		bw = MxL_BW_6MHz;
-	} else if (fe->ops.info.type == FE_OFDM) {
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		break;
+	case SYS_DVBC_ANNEX_B:
+		mode = MxL_MODE_CABLE;
+		bw = MxL_BW_6MHz;
+		break;
+	case SYS_DVBT:
+	case SYS_DVBT2:
+		mode = MxL_MODE_DVBT;
+		if (c->bandwidth_hz <= 6000000) {
 			bw = MxL_BW_6MHz;
-			break;
-		case BANDWIDTH_7_MHZ:
+		} else if (c->bandwidth_hz <= 7000000) {
 			bw = MxL_BW_7MHz;
-			break;
-		case BANDWIDTH_8_MHZ:
+			band = BANDWIDTH_7_MHZ;
+		} else {
 			bw = MxL_BW_8MHz;
-			break;
-		default:
-			mxl_err("bandwidth not set!");
-			return -EINVAL;
+			band = BANDWIDTH_8_MHZ;
 		}
-		mode = MxL_MODE_DVBT;
-	} else {
+		break;
+	default:
 		mxl_err("modulation type not supported!");
 		return -EINVAL;
 	}
@@ -674,8 +668,7 @@ static int mxl5007t_set_params(struct dvb_frontend *fe,
 		goto fail;
 
 	state->frequency = freq;
-	state->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-		params->u.ofdm.bandwidth : 0;
+	state->bandwidth = band;
 fail:
 	mutex_unlock(&state->lock);
 
-- 
1.7.8.352.g876a6

