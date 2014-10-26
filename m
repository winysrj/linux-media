Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58333 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaJZLrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:47:14 -0400
Received: by mail-pa0-f46.google.com with SMTP id lf10so2061444pab.5
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 04:47:14 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 1/7] v4l-utils/libdvbv5: fix auto generation of channel names
Date: Sun, 26 Oct 2014 20:46:17 +0900
Message-Id: <1414323983-15996-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

when channel name was not available, it was generated from unset variables,
and leaked memory.
---
 lib/libdvbv5/dvb-file.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 27d9a63..1ea14c4 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1121,20 +1121,23 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		if (rc)
 			dvb_logerr("Couldn't get frontend props");
 	}
+	for (j = 0; j < parms->n_props; j++) {
+		entry->props[j].cmd = parms->dvb_prop[j].cmd;
+		entry->props[j].u.data = parms->dvb_prop[j].u.data;
+
+		if (!*channel)
+			freq = entry->props[j].u.data;
+	}
 	if (!*channel) {
-		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
+		free(channel);
+		r = asprintf(&channel, "%.2f%cHz#%d", freq / 1000000.,
+			dvb_fe_is_satellite(parms->p.current_sys) ? 'G' : 'M',
+			service_id);
 		if (r < 0)
 			dvb_perror("asprintf");
 		if (parms->p.verbose)
 			dvb_log("Storing as: '%s'", channel);
 	}
-	for (j = 0; j < parms->n_props; j++) {
-		entry->props[j].cmd = parms->dvb_prop[j].cmd;
-		entry->props[j].u.data = parms->dvb_prop[j].u.data;
-
-		if (!*channel && entry->props[j].cmd == DTV_FREQUENCY)
-			freq = parms->dvb_prop[j].u.data;
-	}
 	entry->n_props = parms->n_props;
 	entry->channel = channel;
 
@@ -1225,12 +1228,19 @@ int dvb_store_channel(struct dvb_file **dvb_file,
 				continue;
 
 			service_id = dvb_scan_handler->program[i].pat_pgm->service_id;
+			rc = asprintf(&channel, "#%d", service_id);
+			if (rc < 0) {
+				dvb_perror("asprintf");
+				return rc;
+			}
 
 			rc = get_program_and_store(parms, *dvb_file, dvb_scan_handler,
 						   service_id, channel, NULL,
 						   get_detected, get_nit);
-			if (rc < 0)
+			if (rc < 0) {
+				free(channel);
 				return rc;
+			}
 		}
 
 		return 0;
-- 
2.1.2

