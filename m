Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:54261 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931Ab3ENJiE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 05:38:04 -0400
Received: from lan226.bxl.tuxicoman.be ([172.19.1.226] helo=me)
	by ibiza.bxl.tuxicoman.be with smtp (Exim 4.80.1)
	(envelope-from <gmsoft@tuxicoman.be>)
	id 1UcBgA-0002wE-4v
	for linux-media@vger.kernel.org; Tue, 14 May 2013 11:37:54 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] libdvbv5: Remove buggy parsing of extra DTV_foo properties
Date: Tue, 14 May 2013 11:23:51 +0200
Message-Id: <e10ca4f5588066aea09f0c7e8979545ee9e63a03.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
In-Reply-To: <cover.1368522021.git.gmsoft@tuxicoman.be>
References: <cover.1368522021.git.gmsoft@tuxicoman.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parsing of those extra parameters is buggy and completely useless since they are parsed
individually later on in the code.

Signed-off-by: Guy Martin <gmsoft@tuxicoman.be>

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


