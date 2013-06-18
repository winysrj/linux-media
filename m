Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:57450 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932884Ab3FROUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 10:20:35 -0400
Received: from [2001:7e8:2221:300:230:5ff:fec0:2d3b] (helo=devbox)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1Uowlj-0006xJ-MZ
	for linux-media@vger.kernel.org; Tue, 18 Jun 2013 16:20:24 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 1/6] libdvbv5: Remove buggy parsing of extra DTV_foo parameters
Date: Tue, 18 Jun 2013 16:19:04 +0200
Message-Id: <a386f3a8a7b76795dc487f9ae6ec728628c5bc0a.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parsing of those extra parameters is buggy and completely useless since they are parsed
individually later on in the code.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>
---
 lib/libdvbv5/dvb-file.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index d8d583c..aa42a37 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -392,31 +392,6 @@ static int fill_entry(struct dvb_entry *entry, char *key, char *value)
 		return 0;
 	}
 
-	/* Handle the DVB extra DTV_foo properties */
-	for (i = 0; i < ARRAY_SIZE(dvb_user_name); i++) {
-		if (!dvb_user_name[i])
-			continue;
-		if (!strcasecmp(key, dvb_user_name[i]))
-			break;
-	}
-	if (i < ARRAY_SIZE(dvb_user_name)) {
-		const char * const *attr_name = dvb_attr_names(i);
-		n_prop = entry->n_props;
-		entry->props[n_prop].cmd = i + DTV_USER_COMMAND_START;
-		if (!attr_name || !*attr_name)
-			entry->props[n_prop].u.data = atol(value);
-		else {
-			for (j = 0; attr_name[j]; j++)
-				if (!strcasecmp(value, attr_name[j]))
-					break;
-			if (!attr_name[j])
-				return -2;
-			entry->props[n_prop].u.data = j + DTV_USER_COMMAND_START;
-		}
-		entry->n_props++;
-		return 0;
-	}
-
 	/* Handle the other properties */
 
 	if (!strcasecmp(key, "SERVICE_ID")) {
-- 
1.8.1.5


