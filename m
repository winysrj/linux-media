Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5c2017054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 31/47] [media] mxl111sf-tuner: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:36 -0200
Message-Id: <1324741852-26138-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-31-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c |   46 +++++++++++++--------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
index 3bfc6d8..aeac7a9 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
@@ -275,52 +275,50 @@ static int mxl1x1sf_tuner_loop_thru_ctrl(struct mxl111sf_tuner_state *state,
 static int mxl111sf_tuner_set_params(struct dvb_frontend *fe,
 				     struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys  = c->delivery_system;
 	struct mxl111sf_tuner_state *state = fe->tuner_priv;
 	int ret;
 	u8 bw;
+	u32 band = BANDWIDTH_6_MHZ;
 
 	mxl_dbg("()");
 
-	if (fe->ops.info.type == FE_ATSC) {
-		switch (params->u.vsb.modulation) {
-		case VSB_8:
-		case VSB_16:
-			bw = 0; /* ATSC */
-			break;
-		case QAM_64:
-		case QAM_256:
-			bw = 1; /* US CABLE */
-			break;
-		default:
-			err("%s: modulation not set!", __func__);
-			return -EINVAL;
-		}
-	} else if (fe->ops.info.type == FE_OFDM) {
-		switch (params->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+	switch (delsys) {
+	case SYS_ATSC:
+		bw = 0; /* ATSC */
+		break;
+	case SYS_DVBC_ANNEX_B:
+		bw = 1; /* US CABLE */
+		break;
+	case SYS_DVBT:
+		switch (c->bandwidth_hz) {
+		case 6000000:
 			bw = 6;
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			bw = 7;
+			band = BANDWIDTH_7_MHZ;
 			break;
-		case BANDWIDTH_8_MHZ:
+		case 8000000:
 			bw = 8;
+			band = BANDWIDTH_8_MHZ;
 			break;
 		default:
 			err("%s: bandwidth not set!", __func__);
 			return -EINVAL;
 		}
-	} else {
+		break;
+	default:
 		err("%s: modulation type not supported!", __func__);
 		return -EINVAL;
 	}
-	ret = mxl1x1sf_tune_rf(fe, params->frequency, bw);
+	ret = mxl1x1sf_tune_rf(fe, c->frequency, bw);
 	if (mxl_fail(ret))
 		goto fail;
 
-	state->frequency = params->frequency;
-	state->bandwidth = (fe->ops.info.type == FE_OFDM) ?
-		params->u.ofdm.bandwidth : 0;
+	state->frequency = c->frequency;
+	state->bandwidth = band;
 fail:
 	return ret;
 }
-- 
1.7.8.352.g876a6

