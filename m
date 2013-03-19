Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab3CSQuV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 25/46] [media] siano: split get_frontend into per-std functions
Date: Tue, 19 Mar 2013 13:49:14 -0300
Message-Id: <1363711775-2120-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of handling both DVB-T and ISDB-T at the same get_frontend
function, break it intow one function per-delivery system.

That makes the code clearer as we start to add support for DVBv5
statistics, and for ISDB-T get frontend stuff.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb.c | 229 +++++++++++++++++++-----------------
 1 file changed, 124 insertions(+), 105 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb.c b/drivers/media/common/siano/smsdvb.c
index 6335574..1d6b8df 100644
--- a/drivers/media/common/siano/smsdvb.c
+++ b/drivers/media/common/siano/smsdvb.c
@@ -863,131 +863,150 @@ static int smsdvb_set_frontend(struct dvb_frontend *fe)
 	}
 }
 
-static int smsdvb_get_frontend(struct dvb_frontend *fe)
+static int smsdvb_get_frontend_dvb(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
-	struct smscore_device_t *coredev = client->coredev;
 	struct TRANSMISSION_STATISTICS_S *td =
 		&client->sms_stat_dvb.TransmissionData;
 
-	switch (smscore_get_device_mode(coredev)) {
-	case DEVICE_MODE_DVBT:
-	case DEVICE_MODE_DVBT_BDA:
-		fep->frequency = td->Frequency;
-
-		switch (td->Bandwidth) {
-		case 6:
-			fep->bandwidth_hz = 6000000;
-			break;
-		case 7:
-			fep->bandwidth_hz = 7000000;
-			break;
-		case 8:
-			fep->bandwidth_hz = 8000000;
-			break;
-		}
+	fep->frequency = td->Frequency;
 
-		switch (td->TransmissionMode) {
-		case 2:
-			fep->transmission_mode = TRANSMISSION_MODE_2K;
-			break;
-		case 8:
-			fep->transmission_mode = TRANSMISSION_MODE_8K;
-		}
+	switch (td->Bandwidth) {
+	case 6:
+		fep->bandwidth_hz = 6000000;
+		break;
+	case 7:
+		fep->bandwidth_hz = 7000000;
+		break;
+	case 8:
+		fep->bandwidth_hz = 8000000;
+		break;
+	}
 
-		switch (td->GuardInterval) {
-		case 0:
-			fep->guard_interval = GUARD_INTERVAL_1_32;
-			break;
-		case 1:
-			fep->guard_interval = GUARD_INTERVAL_1_16;
-			break;
-		case 2:
-			fep->guard_interval = GUARD_INTERVAL_1_8;
-			break;
-		case 3:
-			fep->guard_interval = GUARD_INTERVAL_1_4;
-			break;
-		}
+	switch (td->TransmissionMode) {
+	case 2:
+		fep->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case 8:
+		fep->transmission_mode = TRANSMISSION_MODE_8K;
+	}
 
-		switch (td->CodeRate) {
-		case 0:
-			fep->code_rate_HP = FEC_1_2;
-			break;
-		case 1:
-			fep->code_rate_HP = FEC_2_3;
-			break;
-		case 2:
-			fep->code_rate_HP = FEC_3_4;
-			break;
-		case 3:
-			fep->code_rate_HP = FEC_5_6;
-			break;
-		case 4:
-			fep->code_rate_HP = FEC_7_8;
-			break;
-		}
+	switch (td->GuardInterval) {
+	case 0:
+		fep->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case 1:
+		fep->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case 2:
+		fep->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case 3:
+		fep->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
 
-		switch (td->LPCodeRate) {
-		case 0:
-			fep->code_rate_LP = FEC_1_2;
-			break;
-		case 1:
-			fep->code_rate_LP = FEC_2_3;
-			break;
-		case 2:
-			fep->code_rate_LP = FEC_3_4;
-			break;
-		case 3:
-			fep->code_rate_LP = FEC_5_6;
-			break;
-		case 4:
-			fep->code_rate_LP = FEC_7_8;
-			break;
-		}
+	switch (td->CodeRate) {
+	case 0:
+		fep->code_rate_HP = FEC_1_2;
+		break;
+	case 1:
+		fep->code_rate_HP = FEC_2_3;
+		break;
+	case 2:
+		fep->code_rate_HP = FEC_3_4;
+		break;
+	case 3:
+		fep->code_rate_HP = FEC_5_6;
+		break;
+	case 4:
+		fep->code_rate_HP = FEC_7_8;
+		break;
+	}
 
-		switch (td->Constellation) {
-		case 0:
-			fep->modulation = QPSK;
-			break;
-		case 1:
-			fep->modulation = QAM_16;
-			break;
-		case 2:
-			fep->modulation = QAM_64;
-			break;
-		}
+	switch (td->LPCodeRate) {
+	case 0:
+		fep->code_rate_LP = FEC_1_2;
+		break;
+	case 1:
+		fep->code_rate_LP = FEC_2_3;
+		break;
+	case 2:
+		fep->code_rate_LP = FEC_3_4;
+		break;
+	case 3:
+		fep->code_rate_LP = FEC_5_6;
+		break;
+	case 4:
+		fep->code_rate_LP = FEC_7_8;
+		break;
+	}
 
-		switch (td->Hierarchy) {
-		case 0:
-			fep->hierarchy = HIERARCHY_NONE;
-			break;
-		case 1:
-			fep->hierarchy = HIERARCHY_1;
-			break;
-		case 2:
-			fep->hierarchy = HIERARCHY_2;
-			break;
-		case 3:
-			fep->hierarchy = HIERARCHY_4;
-			break;
-		}
+	switch (td->Constellation) {
+	case 0:
+		fep->modulation = QPSK;
+		break;
+	case 1:
+		fep->modulation = QAM_16;
+		break;
+	case 2:
+		fep->modulation = QAM_64;
+		break;
+	}
 
-		fep->inversion = INVERSION_AUTO;
+	switch (td->Hierarchy) {
+	case 0:
+		fep->hierarchy = HIERARCHY_NONE;
 		break;
+	case 1:
+		fep->hierarchy = HIERARCHY_1;
+		break;
+	case 2:
+		fep->hierarchy = HIERARCHY_2;
+		break;
+	case 3:
+		fep->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	fep->inversion = INVERSION_AUTO;
+
+	return 0;
+}
+
+static int smsdvb_get_frontend_isdb(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
+	struct smsdvb_client_t *client =
+		container_of(fe, struct smsdvb_client_t, frontend);
+	struct TRANSMISSION_STATISTICS_S *td =
+		&client->sms_stat_dvb.TransmissionData;
+
+	fep->frequency = td->Frequency;
+	fep->bandwidth_hz = 6000000;
+	/* todo: retrive the other parameters */
+
+	return 0;
+}
+
+static int smsdvb_get_frontend(struct dvb_frontend *fe)
+{
+	struct smsdvb_client_t *client =
+		container_of(fe, struct smsdvb_client_t, frontend);
+	struct smscore_device_t *coredev = client->coredev;
+
+	switch (smscore_get_device_mode(coredev)) {
+	case DEVICE_MODE_DVBT:
+	case DEVICE_MODE_DVBT_BDA:
+		return smsdvb_get_frontend_dvb(fe);
 	case DEVICE_MODE_ISDBT:
 	case DEVICE_MODE_ISDBT_BDA:
-		fep->frequency = td->Frequency;
-		fep->bandwidth_hz = 6000000;
-		/* todo: retrive the other parameters */
-		break;
+		return smsdvb_get_frontend_isdb(fe);
 	default:
 		return -EINVAL;
 	}
-
-	return 0;
 }
 
 static int smsdvb_init(struct dvb_frontend *fe)
-- 
1.8.1.4

