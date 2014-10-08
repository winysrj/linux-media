Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62860 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaJHMKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 08:10:12 -0400
Received: by mail-pa0-f54.google.com with SMTP id ey11so9044071pad.13
        for <linux-media@vger.kernel.org>; Wed, 08 Oct 2014 05:10:12 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH 1/4] v4l-utils/libdvbv5: avoid crash when failed to get a channel name
Date: Wed,  8 Oct 2014 21:09:38 +0900
Message-Id: <1412770181-5420-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-file.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 27d9a63..bcb1762 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1121,20 +1121,21 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		if (rc)
 			dvb_logerr("Couldn't get frontend props");
 	}
-	if (!*channel) {
-		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
-		if (r < 0)
-			dvb_perror("asprintf");
-		if (parms->p.verbose)
-			dvb_log("Storing as: '%s'", channel);
-	}
 	for (j = 0; j < parms->n_props; j++) {
 		entry->props[j].cmd = parms->dvb_prop[j].cmd;
 		entry->props[j].u.data = parms->dvb_prop[j].u.data;
 
-		if (!*channel && entry->props[j].cmd == DTV_FREQUENCY)
+		if ((!channel || !*channel) &&
+		    entry->props[j].cmd == DTV_FREQUENCY)
 			freq = parms->dvb_prop[j].u.data;
 	}
+	if (!channel || !*channel) {
+		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
+		if (r < 0)
+			dvb_perror("asprintf");
+		if (parms->p.verbose)
+			dvb_log("Storing as: '%s'", channel);
+	}
 	entry->n_props = parms->n_props;
 	entry->channel = channel;
 
-- 
2.1.2

