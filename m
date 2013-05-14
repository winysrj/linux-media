Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:54263 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931Ab3ENJiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 05:38:07 -0400
Received: from lan226.bxl.tuxicoman.be ([172.19.1.226] helo=me)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1UcBgB-0002wI-C5
	for linux-media@vger.kernel.org; Tue, 14 May 2013 11:37:56 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] dvbv5-zap: Copy satellite parameters before tuning dvbv5-scan: Likewise
Date: Tue, 14 May 2013 11:23:55 +0200
Message-Id: <e89ed7155a31f745bae11fc81ce02874c59fe22a.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy satellite parameters to the frontend params. Since an LNB can be specified in
the channel/tuning file, set it correctly as well.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 9a29b34..fa236fc 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -436,6 +436,20 @@ static int run_scan(struct arguments *args,
 			}
 		}
 
+		/* Copy sat parameters */
+		if (dvb_fe_is_satellite(parms->current_sys)) {
+			parms->pol = entry->pol;
+			/* If an LNB is specified for this entry, parse it */
+			if (entry->lnb) {
+				int lnb = dvb_sat_search_lnb(entry->lnb);
+				if (lnb == -1) {
+					PERROR("unknown LNB %s\n", entry->lnb);
+					return -1;
+				}
+				parms->lnb = dvb_sat_get_lnb(lnb);
+			}
+		}
+
 		/*
 		 * If the channel file has duplicated frequencies, or some
 		 * entries without any frequency at all, discard.
diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index c84cf70..3d8ac8c 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -237,6 +237,20 @@ static int parse(struct arguments *args,
 		}
 	}
 
+	/* Copy sat parameters */
+	if (dvb_fe_is_satellite(parms->current_sys)) {
+		parms->pol = entry->pol;
+		/* If an LNB is specified for this entry, parse it */
+		if (entry->lnb) {
+			int lnb = dvb_sat_search_lnb(entry->lnb);
+			if (lnb == -1) {
+				PERROR("unknown LNB %s\n", entry->lnb);
+				return -1;
+			}
+			parms->lnb = dvb_sat_get_lnb(lnb);
+		}
+	}
+
 #if 0
 	/* HACK to test the write file function */
 	write_dvb_file("dvb_channels.conf", dvb_file);
-- 
1.8.1.5


