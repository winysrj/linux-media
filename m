Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50302 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab2GFTX5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 15:23:57 -0400
Received: by mail-we0-f174.google.com with SMTP id b14so6568003wer.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 12:23:56 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 4/5] libdvbv5: Fix DiSEqC and LNB handling
Date: Fri,  6 Jul 2012 21:23:11 +0200
Message-Id: <1341602592-29508-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
References: <1341602592-29508-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/dvb-fe.h      |    2 +-
 lib/libdvbv5/dvb-fe.c     |   61 +++++++++++++++++++++++++--------------------
 lib/libdvbv5/dvb-sat.c    |   13 +++++----
 lib/libdvbv5/dvb-v5-std.c |    8 +++---
 4 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index a91a627..8b795cb 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -166,7 +166,7 @@ const char * const *dvb_attr_names(int cmd);
  */
 
 int dvb_fe_sec_voltage(struct dvb_v5_fe_parms *parms, int on, int v18);
-int dvb_fe_sec_tone(struct dvb_v5_fe_parms *parms, int on);
+int dvb_fe_sec_tone(struct dvb_v5_fe_parms *parms, fe_sec_tone_mode_t tone);
 int dvb_fe_lnb_high_voltage(struct dvb_v5_fe_parms *parms, int on);
 int dvb_fe_diseqc_burst(struct dvb_v5_fe_parms *parms, int mini_b);
 int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 9ff5b7b..1ef7b0d 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -534,7 +534,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 	/* DVBv3 call */
 	if (ioctl(parms->fd, FE_GET_FRONTEND, &v3_parms) == -1) {
 		dvb_perror("FE_GET_FRONTEND");
-		return errno;
+		return -1;
 	}
 
 	dvb_fe_store_parm(parms, DTV_FREQUENCY, v3_parms.frequency);
@@ -603,7 +603,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 			dvb_perror("FE_SET_PROPERTY");
 			if (parms->verbose)
 				dvb_fe_prt_parms(parms);
-			return errno;
+			return -1;
 		}
 		goto ret;
 	}
@@ -645,7 +645,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 		dvb_perror("FE_SET_FRONTEND");
 		if (parms->verbose)
 			dvb_fe_prt_parms(parms);
-		return errno;
+		return -1;
 	}
 ret:
 	/* For satellite, need to recover from LNBf IF frequency */
@@ -798,41 +798,43 @@ int dvb_fe_sec_voltage(struct dvb_v5_fe_parms *parms, int on, int v18)
 	fe_sec_voltage_t v;
 	int rc;
 
-	if (!on)
+	if (!on) {
 		v = SEC_VOLTAGE_OFF;
-	else
+		if (parms->verbose)
+			dvb_log("DiSEqC VOLTAGE: OFF");
+	} else {
 		v = v18 ? SEC_VOLTAGE_18 : SEC_VOLTAGE_13;
-
+		if (parms->verbose)
+			dvb_log("DiSEqC VOLTAGE: %s", v18 ? "18" : "13");
+	}
 	rc = ioctl(parms->fd, FE_SET_VOLTAGE, v);
 	if (rc == -1)
-		perror ("FE_SET_VOLTAGE");
-	return errno;
+		dvb_perror("FE_SET_VOLTAGE");
+	return rc;
 }
 
-int dvb_fe_sec_tone(struct dvb_v5_fe_parms *parms, int on)
+int dvb_fe_sec_tone(struct dvb_v5_fe_parms *parms, fe_sec_tone_mode_t tone)
 {
-	fe_sec_tone_mode_t tone;
 	int rc;
-
-	tone = on ? SEC_TONE_ON : SEC_TONE_OFF;
-
+	if (parms->verbose)
+		dvb_log( "DiSEqC TONE: %s", fe_tone_name[tone] );
 	rc = ioctl(parms->fd, FE_SET_TONE, tone);
 	if (rc == -1)
-		perror ("FE_SET_TONE");
-	return errno;
+		dvb_perror("FE_SET_TONE");
+	return rc;
 }
 
 int dvb_fe_lnb_high_voltage(struct dvb_v5_fe_parms *parms, int on)
 {
 	int rc;
 
-	if (on)
-		on = 1;
-
+	if (on) on = 1;
+	if (parms->verbose)
+		dvb_log( "DiSEqC HIGH LNB VOLTAGE: %s", on ? "ON" : "OFF" );
 	rc = ioctl(parms->fd, FE_ENABLE_HIGH_LNB_VOLTAGE, on);
 	if (rc == -1)
-		perror ("FE_ENABLE_HIGH_LNB_VOLTAGE");
-	return errno;
+		dvb_perror("FE_ENABLE_HIGH_LNB_VOLTAGE");
+	return rc;
 }
 
 int dvb_fe_diseqc_burst(struct dvb_v5_fe_parms *parms, int mini_b)
@@ -842,10 +844,12 @@ int dvb_fe_diseqc_burst(struct dvb_v5_fe_parms *parms, int mini_b)
 
 	mini = mini_b ? SEC_MINI_B : SEC_MINI_A;
 
+	if (parms->verbose)
+		dvb_log( "DiSEqC BURST: %s", mini_b ? "SEC_MINI_B" : "SEC_MINI_A" );
 	rc = ioctl(parms->fd, FE_DISEQC_SEND_BURST, mini);
 	if (rc == -1)
-		perror ("FE_DISEQC_SEND_BURST");
-	return errno;
+		dvb_perror("FE_DISEQC_SEND_BURST");
+	return rc;
 }
 
 int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
@@ -864,16 +868,16 @@ int dvb_fe_diseqc_cmd(struct dvb_v5_fe_parms *parms, const unsigned len,
 		int i;
 		char log[len * 3 + 20], *p = log;
 
-		p += sprintf(p, "DiSEqC cmd: ");
+		p += sprintf(p, "DiSEqC command: ");
 		for (i = 0; i < len; i++)
-			p += sprintf (p, "0x%02x ", buf[i]);
+			p += sprintf (p, "%02x ", buf[i]);
 		dvb_log(log);
 	}
 
 	rc = ioctl(parms->fd, FE_DISEQC_SEND_MASTER_CMD, &msg);
 	if (rc == -1)
-		perror ("FE_DISEQC_SEND_BURST");
-	return errno;
+		dvb_perror("FE_DISEQC_SEND_MASTER_CMD");
+	return rc;
 }
 
 int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
@@ -888,10 +892,13 @@ int dvb_fe_diseqc_reply(struct dvb_v5_fe_parms *parms, unsigned *len, char *buf,
 	reply.timeout = timeout;
 	reply.msg_len = *len;
 
+	if (parms->verbose)
+		dvb_log("DiSEqC FE_DISEQC_RECV_SLAVE_REPLY");
+
 	rc = ioctl(parms->fd, FE_DISEQC_RECV_SLAVE_REPLY, reply);
 	if (rc == -1) {
 		dvb_perror("FE_DISEQC_RECV_SLAVE_REPLY");
-		return errno;
+		return rc;
 	}
 
 	*len = reply.msg_len;
diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 25995fb..d00a09e 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -304,8 +304,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 
 		/* Adjust voltage/tone accordingly */
 		if (parms->sat_number < 2) {
-			vol_high = high_band;
-			tone_on = pol_v ? 0 : 1;
+			vol_high = pol_v ? 0 : 1;
+			tone_on = high_band;
 			mini_b = parms->sat_number & 1;
 		}
 	}
@@ -326,8 +326,10 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 		rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
 						   pol_v, sat_number, t);
 
-	if (rc)
+	if (rc) {
+		dvb_logerr("sending diseq failed");
 		return rc;
+	}
 	usleep((15 + parms->diseqc_wait) * 1000);
 
 	rc = dvb_fe_diseqc_burst(parms, mini_b);
@@ -335,7 +337,7 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 		return rc;
 	usleep(15 * 1000);
 
-	rc = dvb_fe_sec_tone(parms, tone_on);
+	rc = dvb_fe_sec_tone(parms, tone_on ? SEC_TONE_ON : SEC_TONE_OFF);
 
 	return rc;
 }
@@ -352,7 +354,7 @@ int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION, &pol);
 	uint32_t freq;
 	uint16_t t = 0;
-	uint32_t voltage = SEC_VOLTAGE_13;
+	/*uint32_t voltage = SEC_VOLTAGE_18;*/
 	int rc;
 
 	dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
@@ -396,7 +398,6 @@ ret:
 	rc = dvbsat_diseqc_set_input(parms, t);
 
 	freq = abs(freq - parms->freq_offset);
-	dvb_fe_store_parm(parms, DTV_VOLTAGE, voltage);
 	dvb_fe_store_parm(parms, DTV_FREQUENCY, freq);
 
 	return rc;
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 1396e5f..362eb25 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -125,8 +125,8 @@ const unsigned int sys_dvbs_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
-	DTV_TONE,
+	/*DTV_VOLTAGE,*/
+	/*DTV_TONE,*/
         DTV_POLARIZATION,
 	0
 };
@@ -136,8 +136,8 @@ const unsigned int sys_dvbs2_props[] = {
 	DTV_INVERSION,
 	DTV_SYMBOL_RATE,
 	DTV_INNER_FEC,
-	DTV_VOLTAGE,
-	DTV_TONE,
+	/*DTV_VOLTAGE,*/
+	/*DTV_TONE,*/
 	DTV_MODULATION,
 	DTV_PILOT,
 	DTV_ROLLOFF,
-- 
1.7.2.5

