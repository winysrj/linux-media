Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:54257 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab3ENJiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 05:38:01 -0400
Received: from lan226.bxl.tuxicoman.be ([172.19.1.226] helo=me)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1UcBg7-0002w6-IA
	for linux-media@vger.kernel.org; Tue, 14 May 2013 11:37:52 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] libdvbv5: Apply polarization parameters to the frontend
Date: Tue, 14 May 2013 11:23:54 +0200
Message-Id: <a313e75ecb5d16533a6143bd268a15b1274f8819.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apply polarization parameters even if a satellite number is not provided.
The polarization is fetched from struct dvb_v5_fe_parms directly and not from the
parameter DTV_POLARIZATION.
Since DTV_VOLTAGE and DTV_TONE are set according the polarization, those parameters
are removed from the props structures in dvb-v5-std.c.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 7352218..571d4ac 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -104,7 +104,7 @@ struct dvb_v5_fe_parms {
 	unsigned			freq_bpf;
 
 	/* Satellite specific stuff, used internally */
-	//enum dvb_sat_polarization       pol;
+	enum dvb_sat_polarization	pol;
 	int				high_band;
 	unsigned			diseqc_wait;
 	unsigned			freq_offset;
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index d00a09e..89f8e88 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -272,8 +272,7 @@ static int dvbsat_scr_odu_channel_change(struct dvb_v5_fe_parms *parms, struct d
 static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 {
 	int rc;
-	enum dvb_sat_polarization pol;
-	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
+	enum dvb_sat_polarization pol = parms->pol;
 	int pol_v = (pol == POLARIZATION_V) || (pol == POLARIZATION_R);
 	int high_band = parms->high_band;
 	int sat_number = parms->sat_number;
@@ -284,12 +283,6 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 
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
@@ -297,11 +290,6 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
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
@@ -310,32 +298,35 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
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
 
@@ -350,8 +341,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 {
 	const struct dvb_sat_lnb *lnb = parms->lnb;
-	enum dvb_sat_polarization pol;
-	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION, &pol);
+	enum dvb_sat_polarization pol = parms->pol;
 	uint32_t freq;
 	uint16_t t = 0;
 	/*uint32_t voltage = SEC_VOLTAGE_18;*/
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 5a1854b..53809ef 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -125,9 +125,6 @@ const unsigned int sys_dvbs_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	/*DTV_VOLTAGE,*/
-	/*DTV_TONE,*/
-	DTV_POLARIZATION,
 	0
 };
 
@@ -136,12 +133,9 @@ const unsigned int sys_dvbs2_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	/*DTV_VOLTAGE,*/
-	/*DTV_TONE,*/
 	DTV_MODULATION,
 	DTV_PILOT,
 	DTV_ROLLOFF,
-	DTV_POLARIZATION,
 	0
 };
 
@@ -150,8 +144,6 @@ const unsigned int sys_turbo_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
-	DTV_TONE,
 	DTV_MODULATION,
 	0
 };
@@ -161,7 +153,6 @@ const unsigned int sys_isdbs_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
 	DTV_ISDBS_TS_ID_LEGACY,
 	0
 };
-- 
1.8.1.5


