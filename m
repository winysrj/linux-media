Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40690 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752584AbdLMM60 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 07:58:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] dvb-sat: do the best to tune if DiSEqC is disabled
Date: Wed, 13 Dec 2017 10:58:18 -0200
Message-Id: <20171213125818.11589-1-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If sat_number is not filled (e.g. it is -1), the dvb-sat
disables DiSEqC. However, currently, it also breaks support
for non-bandstacking LNBf.

Change the logic to fix it. There is a drawback on this
approach, though: usually, on bandstacking arrangements,
only one device needs to feed power to the LNBf. The
others don't need to send power. With the previous code,
no power would be sent at all, if sat_number == -1.

Now, it will always power the LNBf when using it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/libdvbv5/dvb-sat.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index b012318c4195..8c04f66f973b 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -523,11 +523,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 	struct diseqc_cmd cmd;
 	const struct dvb_sat_lnb_priv *lnb = (void *)parms->p.lnb;
 
-	/* Negative numbers means to not use a DiSEqC switch */
-	if (parms->p.sat_number < 0) {
-		/* If not bandstack, warn if DiSEqC is disabled */
-		if (!lnb->freqrange[0].pol)
-			dvb_logwarn(_("DiSEqC disabled. Probably won't tune."));
+	if (sat_number < 0 && t) {
+		dvb_logwarn(_("DiSEqC disabled. Can't tune using SCR/Unicable."));
 		return 0;
 	}
 
@@ -546,7 +543,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 			vol_high = 1;
 	} else {
 		/* Adjust voltage/tone accordingly */
-		if (parms->p.sat_number < 2) {
+		if (sat_number < 2) {
 			vol_high = pol_v ? 0 : 1;
 			tone_on = high_band;
 		}
@@ -560,28 +557,31 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 	if (rc)
 		return rc;
 
-	usleep(15 * 1000);
-
-	if (!t)
-		rc = dvbsat_diseqc_write_to_port_group(parms, &cmd, high_band,
-							pol_v, sat_number);
-	else
-		rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
-							pol_v, sat_number, t);
+	if (sat_number >= 0) {
+		/* DiSEqC is enabled. Send DiSEqC commands */
+		usleep(15 * 1000);
 
-	if (rc) {
-		dvb_logerr(_("sending diseq failed"));
-		return rc;
-	}
-	usleep((15 + parms->p.diseqc_wait) * 1000);
+		if (!t)
+			rc = dvbsat_diseqc_write_to_port_group(parms, &cmd, high_band,
+								pol_v, sat_number);
+		else
+			rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
+								pol_v, sat_number, t);
 
-	/* miniDiSEqC/Toneburst commands are defined only for up to 2 sattelites */
-	if (parms->p.sat_number < 2) {
-		rc = dvb_fe_diseqc_burst(&parms->p, parms->p.sat_number);
-		if (rc)
+		if (rc) {
+			dvb_logerr(_("sending diseq failed"));
 			return rc;
+		}
+		usleep((15 + parms->p.diseqc_wait) * 1000);
+
+		/* miniDiSEqC/Toneburst commands are defined only for up to 2 sattelites */
+		if (parms->p.sat_number < 2) {
+			rc = dvb_fe_diseqc_burst(&parms->p, parms->p.sat_number);
+			if (rc)
+				return rc;
+		}
+		usleep(15 * 1000);
 	}
-	usleep(15 * 1000);
 
 	rc = dvb_fe_sec_tone(&parms->p, tone_on ? SEC_TONE_ON : SEC_TONE_OFF);
 
-- 
2.14.3
