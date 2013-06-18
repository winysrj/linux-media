Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57461 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947Ab3FROUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:41 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowlp-0006xa-7o
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:30 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/6] libdvbv5: Fix satellite handling and apply polarization parameter to the frontend
Date: Tue, 18 Jun 2013 16:19:07 +0200
Message-Id: <499f1b86398f711babf414c69d43c69b1fc95129.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apply polarization parameters even if a satellite number is not provided. This allow
proper setup of the tone and voltage.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
---
 lib/include/dvb-fe.h      |  1 -
 lib/libdvbv5/dvb-sat.c    | 57 ++++++++++++++++++++---------------------------
 lib/libdvbv5/dvb-v5-std.c |  9 ++------
 3 files changed, 26 insertions(+), 41 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 7352218..b0e2bf9 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -104,7 +104,6 @@ struct dvb_v5_fe_parms {
 	unsigned			freq_bpf;
 
 	/* Satellite specific stuff, used internally */
-	//enum dvb_sat_polarization       pol;
 	int				high_band;
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index d00a09e..f84b5a4 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -273,7 +273,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 {
 	int rc;
 	enum dvb_sat_polarization pol;
-	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
+	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION, &pol);
 	int pol_v = (pol == POLARIZATION_V) || (pol == POLARIZATION_R);
 	int high_band = parms->high_band;
 	int sat_number = parms->sat_number;
@@ -284,12 +284,6 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 
 	if (!lnb->rangeswitch) {
 		/*
-		 * Bandstacking and single LO may not be using DISEqC
-		 */
-		if (sat_number < 0)
-			return 0;
-
-		/*
 		 * Bandstacking switches don't use 2 bands nor use
 		 * DISEqC for setting the polarization. It also doesn't
 		 * use any tone/tone burst
@@ -297,11 +291,6 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 		pol_v = 0;
 		high_band = 1;
 	} else {
-		if (sat_number < 0) {
-			dvb_logerr("Need a satellite number for DISEqC");
-			return -EINVAL;
-		}
-
 		/* Adjust voltage/tone accordingly */
 		if (parms->sat_number < 2) {
 			vol_high = pol_v ? 0 : 1;
@@ -310,32 +299,35 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 		}
 	}
 
-	rc = dvb_fe_sec_tone(parms, SEC_TONE_OFF);
-	if (rc)
-		return rc;
-
 	rc = dvb_fe_sec_voltage(parms, 1, vol_high);
 	if (rc)
 		return rc;
-	usleep(15 * 1000);
+	
+	if (parms->sat_number > 0) {
+		rc = dvb_fe_sec_tone(parms, SEC_TONE_OFF);
+		if (rc)
+			return rc;
 
-	if (!t)
-		rc = dvbsat_diseqc_write_to_port_group(parms, &cmd, high_band,
-						       pol_v, sat_number);
-	else
-		rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
-						   pol_v, sat_number, t);
+		usleep(15 * 1000);
 
-	if (rc) {
-		dvb_logerr("sending diseq failed");
-		return rc;
-	}
-	usleep((15 + parms->diseqc_wait) * 1000);
+		if (!t)
+			rc = dvbsat_diseqc_write_to_port_group(parms, &cmd, high_band,
+							       pol_v, sat_number);
+		else
+			rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
+							   pol_v, sat_number, t);
 
-	rc = dvb_fe_diseqc_burst(parms, mini_b);
-	if (rc)
-		return rc;
-	usleep(15 * 1000);
+		if (rc) {
+			dvb_logerr("sending diseq failed");
+			return rc;
+		}
+		usleep((15 + parms->diseqc_wait) * 1000);
+
+		rc = dvb_fe_diseqc_burst(parms, mini_b);
+		if (rc)
+			return rc;
+		usleep(15 * 1000);
+	}
 
 	rc = dvb_fe_sec_tone(parms, tone_on ? SEC_TONE_ON : SEC_TONE_OFF);
 
@@ -354,7 +346,6 @@ int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION, &pol);
 	uint32_t freq;
 	uint16_t t = 0;
-	/*uint32_t voltage = SEC_VOLTAGE_18;*/
 	int rc;
 
 	dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 5a1854b..574ae1e 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -125,8 +125,6 @@ const unsigned int sys_dvbs_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	/*DTV_VOLTAGE,*/
-	/*DTV_TONE,*/
 	DTV_POLARIZATION,
 	0
 };
@@ -136,8 +134,6 @@ const unsigned int sys_dvbs2_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	/*DTV_VOLTAGE,*/
-	/*DTV_TONE,*/
 	DTV_MODULATION,
 	DTV_PILOT,
 	DTV_ROLLOFF,
@@ -150,9 +146,8 @@ const unsigned int sys_turbo_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
-	DTV_TONE,
 	DTV_MODULATION,
+	DTV_POLARIZATION,
 	0
 };
 
@@ -161,8 +156,8 @@ const unsigned int sys_isdbs_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
 	DTV_ISDBS_TS_ID_LEGACY,
+	DTV_POLARIZATION,
 	0
 };
 
-- 
1.8.1.5


