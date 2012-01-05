Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab2AEBBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:10 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AK7002499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 37/47] [media] mt2063: Rewrite tuning logic
Date: Wed,  4 Jan 2012 23:00:48 -0200
Message-Id: <1325725258-27934-38-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several vars at set_parms functions were set, but unused.
 Remove them and change the logic to return -EINVAL if the
analog set_param is used for digital mode.

At the analog side, cleans the logic that sets the several
analog standards.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   62 +++++++--------------------------
 1 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index cd67417..b72105d 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2013,14 +2013,11 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 				    struct analog_parameters *params)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	s32 pict_car = 0;
-	s32 pict2chanb_vsb = 0;
-	s32 pict2chanb_snd = 0;
-	s32 pict2snd1 = 0;
-	s32 pict2snd2 = 0;
-	s32 ch_bw = 0;
-	s32 if_mid = 0;
-	s32 rcvr_mode = 0;
+	s32 pict_car;
+	s32 pict2chanb_vsb;
+	s32 ch_bw;
+	s32 if_mid;
+	s32 rcvr_mode;
 	int status;
 
 	dprintk(2, "\n");
@@ -2030,8 +2027,6 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 		pict_car = 38900000;
 		ch_bw = 8000000;
 		pict2chanb_vsb = -(ch_bw / 2);
-		pict2snd1 = 0;
-		pict2snd2 = 0;
 		rcvr_mode = MT2063_OFFAIR_ANALOG;
 		break;
 	case V4L2_TUNER_ANALOG_TV:
@@ -2040,42 +2035,19 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 			pict_car = 38900000;
 			ch_bw = 6000000;
 			pict2chanb_vsb = -1250000;
-			pict2snd1 = 4500000;
-			pict2snd2 = 0;
-		} else if (params->std & V4L2_STD_PAL_I) {
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6000000;
-			pict2snd2 = 0;
-		} else if (params->std & V4L2_STD_PAL_B) {
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 5500000;
-			pict2snd2 = 5742000;
 		} else if (params->std & V4L2_STD_PAL_G) {
 			pict_car = 38900000;
 			ch_bw = 7000000;
 			pict2chanb_vsb = -1250000;
-			pict2snd1 = 5500000;
-			pict2snd2 = 0;
-		} else if (params->std & V4L2_STD_PAL_DK) {
+		} else {		/* PAL/SECAM standards */
 			pict_car = 38900000;
 			ch_bw = 8000000;
 			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6500000;
-			pict2snd2 = 0;
-		} else {	/* PAL-L */
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-			pict2snd1 = 6500000;
-			pict2snd2 = 0;
 		}
 		break;
+	default:
+		return -EINVAL;
 	}
-	pict2chanb_snd = pict2chanb_vsb - ch_bw;
 	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
 
 	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
@@ -2107,14 +2079,11 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct mt2063_state *state = fe->tuner_priv;
 	int status;
-	s32 pict_car = 0;
-	s32 pict2chanb_vsb = 0;
-	s32 pict2chanb_snd = 0;
-	s32 pict2snd1 = 0;
-	s32 pict2snd2 = 0;
-	s32 ch_bw = 0;
-	s32 if_mid = 0;
-	s32 rcvr_mode = 0;
+	s32 pict_car;
+	s32 pict2chanb_vsb;
+	s32 ch_bw;
+	s32 if_mid;
+	s32 rcvr_mode;
 
 	dprintk(2, "\n");
 
@@ -2132,21 +2101,16 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 		rcvr_mode = MT2063_OFFAIR_COFDM;
 		pict_car = 36125000;
 		pict2chanb_vsb = -(ch_bw / 2);
-		pict2snd1 = 0;
-		pict2snd2 = 0;
 		break;
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
 		rcvr_mode = MT2063_CABLE_QAM;
 		pict_car = 36125000;
-		pict2snd1 = 0;
-		pict2snd2 = 0;
 		pict2chanb_vsb = -(ch_bw / 2);
 		break;
 	default:
 		return -EINVAL;
 	}
-	pict2chanb_snd = pict2chanb_vsb - ch_bw;
 	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
 
 	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
-- 
1.7.7.5

