Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54421 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2BTLvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 06:51:07 -0500
Received: by eaah12 with SMTP id h12so2160610eaa.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 03:51:05 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: doronc@siano-ms.com, Gianluca Gennari <gennarone@gmail.com>,
	Panagiotis Malakoudis <malakudi@gmail.com>
Subject: [PATCH] smsdvb: fix get_frontend
Date: Mon, 20 Feb 2012 12:50:33 +0100
Message-Id: <1329738633-12177-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the get_frontend function, an internal copy of the dtv_frontend_properties
struct (which is never initialized) is copied over the frontend property cache
data structure, resetting everything to 0.
In particular, the delivery system is reset to 0 (which is an invalid value)
so the driver stops working as soon as a DVBv3 application calls the
get_frontend function, giving this error:

dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to delivery
system 0

This patch eliminates the unused internal copy of the dtv_frontend_properties
struct, and gives a proper implementation of the get_frontend function.

The original author of the patch is Panagiotis Malakoudis, who also tested
this new version on Ubuntu 11.10 with the latest media_build tree installed.
The original patch has been used on MIPS set-top-boxes for over one year,
but it was never posted on the linux-media list.
I ported the code to the current media_build tree (converting it to use the
dtv_frontend_properties struct) and added basic support for ISDB-T (untested).

Signed-off-by: Panagiotis Malakoudis <malakudi@gmail.com>
Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/siano/smsdvb.c |  123 +++++++++++++++++++++++++++++++++++--
 1 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 654685c..091796a 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -49,9 +49,6 @@ struct smsdvb_client_t {
 
 	struct completion       tune_done;
 
-	/* todo: save freq/band instead whole struct */
-	struct dtv_frontend_properties fe_params;
-
 	struct SMSHOSTLIB_STATISTICS_DVB_S sms_stat_dvb;
 	int event_fe_state;
 	int event_unc_state;
@@ -744,12 +741,124 @@ static int smsdvb_get_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct smsdvb_client_t *client =
 		container_of(fe, struct smsdvb_client_t, frontend);
+	struct smscore_device_t *coredev = client->coredev;
+	struct TRANSMISSION_STATISTICS_S *td =
+		&client->sms_stat_dvb.TransmissionData;
 
-	sms_debug("");
+	switch (smscore_get_device_mode(coredev)) {
+	case DEVICE_MODE_DVBT:
+	case DEVICE_MODE_DVBT_BDA:
+		fep->frequency = td->Frequency;
+
+		switch (td->Bandwidth) {
+		case 6:
+			fep->bandwidth_hz = 6000000;
+			break;
+		case 7:
+			fep->bandwidth_hz = 7000000;
+			break;
+		case 8:
+			fep->bandwidth_hz = 8000000;
+			break;
+		}
+
+		switch (td->TransmissionMode) {
+		case 2:
+			fep->transmission_mode = TRANSMISSION_MODE_2K;
+			break;
+		case 8:
+			fep->transmission_mode = TRANSMISSION_MODE_8K;
+		}
+
+		switch (td->GuardInterval) {
+		case 0:
+			fep->guard_interval = GUARD_INTERVAL_1_32;
+			break;
+		case 1:
+			fep->guard_interval = GUARD_INTERVAL_1_16;
+			break;
+		case 2:
+			fep->guard_interval = GUARD_INTERVAL_1_8;
+			break;
+		case 3:
+			fep->guard_interval = GUARD_INTERVAL_1_4;
+			break;
+		}
+
+		switch (td->CodeRate) {
+		case 0:
+			fep->code_rate_HP = FEC_1_2;
+			break;
+		case 1:
+			fep->code_rate_HP = FEC_2_3;
+			break;
+		case 2:
+			fep->code_rate_HP = FEC_3_4;
+			break;
+		case 3:
+			fep->code_rate_HP = FEC_5_6;
+			break;
+		case 4:
+			fep->code_rate_HP = FEC_7_8;
+			break;
+		}
+
+		switch (td->LPCodeRate) {
+		case 0:
+			fep->code_rate_LP = FEC_1_2;
+			break;
+		case 1:
+			fep->code_rate_LP = FEC_2_3;
+			break;
+		case 2:
+			fep->code_rate_LP = FEC_3_4;
+			break;
+		case 3:
+			fep->code_rate_LP = FEC_5_6;
+			break;
+		case 4:
+			fep->code_rate_LP = FEC_7_8;
+			break;
+		}
+
+		switch (td->Constellation) {
+		case 0:
+			fep->modulation = QPSK;
+			break;
+		case 1:
+			fep->modulation = QAM_16;
+			break;
+		case 2:
+			fep->modulation = QAM_64;
+			break;
+		}
+
+		switch (td->Hierarchy) {
+		case 0:
+			fep->hierarchy = HIERARCHY_NONE;
+			break;
+		case 1:
+			fep->hierarchy = HIERARCHY_1;
+			break;
+		case 2:
+			fep->hierarchy = HIERARCHY_2;
+			break;
+		case 3:
+			fep->hierarchy = HIERARCHY_4;
+			break;
+		}
 
-	/* todo: */
-	memcpy(fep, &client->fe_params,
-	       sizeof(struct dtv_frontend_properties));
+		fep->inversion = INVERSION_AUTO;
+		break;
+	case DEVICE_MODE_ISDBT:
+	case DEVICE_MODE_ISDBT_BDA:
+		fep->frequency = td->Frequency;
+		fep->bandwidth_hz = 6000000;
+		/* todo: retrive the other parameters */
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
1.7.0.4

