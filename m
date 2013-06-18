Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57467 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941Ab3FROUn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:43 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowls-0006xi-Hh
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:33 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] dvbv5-zap: Parse the LNB from the channel file
Date: Tue, 18 Jun 2013 16:19:09 +0200
Message-Id: <0fa749428b7762956fd7e19fec6ea306f1d23eec.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Parsing the LNB needs to be done for proper tuning.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
---
 utils/dvb/dvbv5-zap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/utils/dvb/dvbv5-zap.c b/utils/dvb/dvbv5-zap.c
index c84cf70..d6c1152 100644
--- a/utils/dvb/dvbv5-zap.c
+++ b/utils/dvb/dvbv5-zap.c
@@ -165,6 +165,15 @@ static int parse(struct arguments *args,
 		return -3;
 	}
 
+	if (entry->lnb) {
+		int lnb = dvb_sat_search_lnb(entry->lnb);
+		if (lnb == -1) {
+			PERROR("unknown LNB %s\n", entry->lnb);
+			return -1;
+		}
+		parms->lnb = dvb_sat_get_lnb(lnb);
+	}
+
 	if (entry->video_pid) {
 		if (args->n_vpid < entry->video_pid_len)
 			*vpid = entry->video_pid[args->n_vpid];
-- 
1.8.1.5


