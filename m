Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:54256 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab3ENJh6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 05:37:58 -0400
Received: from lan226.bxl.tuxicoman.be ([172.19.1.226] helo=me)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1UcBg4-0002w0-No
	for linux-media@vger.kernel.org; Tue, 14 May 2013 11:37:49 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] libdvbv5: Add parsing of POLARIZATION
Date: Tue, 14 May 2013 11:23:52 +0200
Message-Id: <d76cac455ac428e73b72cfc7f19f2ef6efc1c595.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add parsing support for the POLARIZATION parameter for the DVBv5 file format.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

diff --git a/lib/include/dvb-file.h b/lib/include/dvb-file.h
index ea76080..2259844 100644
--- a/lib/include/dvb-file.h
+++ b/lib/include/dvb-file.h
@@ -35,7 +35,7 @@ struct dvb_entry {
 
 	char *location;
 
-//	enum dvbsat_polarization pol;
+	enum dvb_sat_polarization pol;
 	int sat_number;
 	unsigned freq_bpf;
 	unsigned diseqc_wait;
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index aa42a37..3ea40cc 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -428,16 +428,15 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		is_video = 1;
 	else if (!strcasecmp(key, "AUDIO_PID"))
 		is_audio = 1;
-	/*else if (!strcasecmp(key, "POLARIZATION")) {
-		entry->service_id = atol(value);
-		for (j = 0; ARRAY_SIZE(pol_name); j++)
-			if (!strcasecmp(value, pol_name[j]))
+	else if (!strcasecmp(key, "POLARIZATION")) {
+		for (j = 0; ARRAY_SIZE(dvb_sat_pol_name); j++)
+			if (!strcasecmp(value, dvb_sat_pol_name[j]))
 				break;
-		if (j == ARRAY_SIZE(pol_name))
+		if (j == ARRAY_SIZE(dvb_sat_pol_name))
 			return -2;
 		entry->pol = j;
 		return 0;
-	}*/ else if (!strncasecmp(key,"PID_", 4)){
+	} else if (!strncasecmp(key,"PID_", 4)){
 		type = strtol(&key[4], NULL, 16);
 		if (!type)
 			return 0;
@@ -647,10 +646,10 @@ int write_dvb_file(const char *fname, struct dvb_file *dvb_file)
 			fprintf(fp, "\n");
 		}
 
-		/*if (entry->pol != POLARIZATION_OFF) {*/
-			/*fprintf(fp, "\tPOLARIZATION = %s\n",*/
-				/*pol_name[entry->pol]);*/
-		/*}*/
+		if (entry->pol != POLARIZATION_OFF) {
+			fprintf(fp, "\tPOLARIZATION = %s\n",
+				dvb_sat_pol_name[entry->pol]);
+		}
 
 		if (entry->sat_number >= 0) {
 			fprintf(fp, "\tSAT_NUMBER = %d\n",
-- 
1.8.1.5


