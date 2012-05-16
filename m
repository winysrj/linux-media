Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42155 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759389Ab2EPWwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 18:52:44 -0400
Received: by weyu7 with SMTP id u7so794397wey.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 15:52:43 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 3/3] renamings and global parms removed
Date: Thu, 17 May 2012 00:52:18 +0200
Message-Id: <1337208738-23530-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/include/dvb-fe.h   |    2 +-
 lib/include/libsat.h   |   10 +++++-----
 lib/libdvbv5/dvb-fe.c  |    4 ++--
 lib/libdvbv5/libsat.c  |   22 +++++++++++-----------
 utils/dvb/dvbv5-scan.c |    4 ++--
 utils/dvb/dvbv5-zap.c  |    4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/lib/include/dvb-fe.h b/lib/include/dvb-fe.h
index 28350d9..872a558 100644
--- a/lib/include/dvb-fe.h
+++ b/lib/include/dvb-fe.h
@@ -76,7 +76,7 @@ struct dvb_v5_fe_parms {
 	struct dvb_v5_stats		stats;
 
 	/* Satellite specific stuff, specified by the library client */
-	struct dvbsat_lnb       	*lnb;
+	struct dvb_sat_lnb       	*lnb;
 	int				sat_number;
 	unsigned			freq_bpf;
 
diff --git a/lib/include/libsat.h b/lib/include/libsat.h
index 3879914..2e74a11 100644
--- a/lib/include/libsat.h
+++ b/lib/include/libsat.h
@@ -25,7 +25,7 @@ struct dvbsat_freqrange {
 	unsigned low, high;
 };
 
-struct dvbsat_lnb {
+struct dvb_sat_lnb {
 	char *name;
 	char *alias;
 	unsigned lowfreq, highfreq;
@@ -44,12 +44,12 @@ extern "C" {
 #endif
 
 /* From libsat.c */
-int search_lnb(char *name);
+int dvb_sat_search_lnb(const char *name);
 int print_lnb(int i);
 void print_all_lnb(void);
-struct dvbsat_lnb *get_lnb(int i);
-int dvb_satellite_set_parms(struct dvb_v5_fe_parms *parms);
-int dvb_satellite_get_parms(struct dvb_v5_fe_parms *parms);
+struct dvb_sat_lnb *dvb_sat_get_lnb(int i);
+int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms);
+int dvb_sat_get_parms(struct dvb_v5_fe_parms *parms);
 
 #ifdef __cplusplus
 }
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 91713e2..1fa4ef5 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -517,7 +517,7 @@ int dvb_fe_get_parms(struct dvb_v5_fe_parms *parms)
 ret:
 	/* For satellite, need to recover from LNBf IF frequency */
 	if (is_satellite(parms->current_sys))
-		return dvb_satellite_get_parms(parms);
+		return dvb_sat_get_parms(parms);
 
 	return 0;
 }
@@ -535,7 +535,7 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *parms)
 
 	if (is_satellite(parms->current_sys)) {
 		dvb_fe_retrieve_parm(parms, DTV_FREQUENCY, &freq);
-		dvb_satellite_set_parms(parms);
+		dvb_sat_set_parms(parms);
 	}
 
 	if (!parms->legacy_fe) {
diff --git a/lib/libdvbv5/libsat.c b/lib/libdvbv5/libsat.c
index e99cc25..fae1b5b 100644
--- a/lib/libdvbv5/libsat.c
+++ b/lib/libdvbv5/libsat.c
@@ -25,7 +25,7 @@
 #include "dvb-fe.h"
 #include "dvb-v5-std.h"
 
-struct dvbsat_lnb lnb[] = {
+struct dvb_sat_lnb lnb[] = {
 	{
 		.name = "Europe",
 		.alias = "UNIVERSAL",
@@ -83,7 +83,7 @@ struct dvbsat_lnb lnb[] = {
 	},
 };
 
-int search_lnb(char *name)
+int dvb_sat_search_lnb(const char *name)
 {
 	int i = 0;
 
@@ -131,7 +131,7 @@ void print_all_lnb(void)
 	}
 }
 
-struct dvbsat_lnb *get_lnb(int i)
+struct dvb_sat_lnb *dvb_sat_get_lnb(int i)
 {
 	if (i >= ARRAY_SIZE(lnb))
 		return NULL;
@@ -213,10 +213,10 @@ static void dvbsat_diseqc_prep_frame_addr(struct diseqc_cmd *cmd,
 	cmd->address = diseqc_addr[type];
 }
 
-struct dvb_v5_fe_parms *parms; // legacy code, used for parms->fd, FIXME anyway
+//struct dvb_v5_fe_parms *parms; // legacy code, used for parms->fd, FIXME anyway
 
 /* Inputs are numbered from 1 to 16, according with the spec */
-static int dvbsat_diseqc_write_to_port_group(struct diseqc_cmd *cmd,
+static int dvbsat_diseqc_write_to_port_group(struct dvb_v5_fe_parms *parms, struct diseqc_cmd *cmd,
 					     int high_band,
 					     int pol_v,
 					     int sat_number)
@@ -238,7 +238,7 @@ static int dvbsat_diseqc_write_to_port_group(struct diseqc_cmd *cmd,
 	return dvb_fe_diseqc_cmd(parms, cmd->len, cmd->msg);
 }
 
-static int dvbsat_scr_odu_channel_change(struct diseqc_cmd *cmd,
+static int dvbsat_scr_odu_channel_change(struct dvb_v5_fe_parms *parms, struct diseqc_cmd *cmd,
 					 int high_band,
 					 int pol_v,
 					 int sat_number,
@@ -320,10 +320,10 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
 	usleep(15 * 1000);
 
 	if (!t)
-		rc = dvbsat_diseqc_write_to_port_group(&cmd, high_band,
+		rc = dvbsat_diseqc_write_to_port_group(parms, &cmd, high_band,
 						       pol_v, sat_number);
 	else
-		rc = dvbsat_scr_odu_channel_change(&cmd, high_band,
+		rc = dvbsat_scr_odu_channel_change(parms, &cmd, high_band,
 						   pol_v, sat_number, t);
 
 	if (rc)
@@ -345,9 +345,9 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms *parms, uint16_t t)
  */
 
 
-int dvb_satellite_set_parms(struct dvb_v5_fe_parms *parms)
+int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 {
-	struct dvbsat_lnb *lnb = parms->lnb;
+	struct dvb_sat_lnb *lnb = parms->lnb;
         enum dvb_sat_polarization pol;
         dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
 	uint32_t freq;
@@ -402,7 +402,7 @@ ret:
 	return rc;
 }
 
-int dvb_satellite_get_parms(struct dvb_v5_fe_parms *parms)
+int dvb_sat_get_parms(struct dvb_v5_fe_parms *parms)
 {
 	uint32_t freq = 0;
 
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 256fb00..c7b18eb 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -526,7 +526,7 @@ int main(int argc, char **argv)
 	argp_parse(&argp, argc, argv, 0, &idx, &args);
 
 	if (args.lnb_name) {
-		lnb = search_lnb(args.lnb_name);
+		lnb = dvb_sat_search_lnb(args.lnb_name);
 		if (lnb < 0) {
 			printf("Please select one of the LNBf's below:\n");
 			print_all_lnb();
@@ -562,7 +562,7 @@ int main(int argc, char **argv)
 	if (!parms)
 		return -1;
 	if (lnb >= 0)
-		parms->lnb = get_lnb(lnb);
+		parms->lnb = dvb_sat_get_lnb(lnb);
 	if (args.sat_number >= 0)
 		parms->sat_number = args.sat_number % 3;
 	parms->diseqc_wait = args.diseqc_wait;
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index 01bf5d9..819ca39 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -476,7 +476,7 @@ int main(int argc, char **argv)
 	}
 
 	if (args.lnb_name) {
-		lnb = search_lnb(args.lnb_name);
+		lnb = dvb_sat_search_lnb(args.lnb_name);
 		if (lnb < 0) {
 			printf("Please select one of the LNBf's below:\n");
 			print_all_lnb();
@@ -511,7 +511,7 @@ int main(int argc, char **argv)
 	if (!parms)
 		return -1;
 	if (lnb)
-		parms->lnb = get_lnb(lnb);
+		parms->lnb = dvb_sat_get_lnb(lnb);
 	if (args.sat_number > 0)
 		parms->sat_number = args.sat_number % 3;
 	parms->diseqc_wait = args.diseqc_wait;
-- 
1.7.2.5

