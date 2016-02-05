Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbcBEPRf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 10:17:35 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id D4DFFBC6C1
	for <linux-media@vger.kernel.org>; Fri,  5 Feb 2016 15:17:35 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3 1/2] alsa: Fix not being able to get a larger latency on capture devices with small max period sizes
Date: Fri,  5 Feb 2016 16:17:29 +0100
Message-Id: <1454685450-30470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some capture devices (e.g. bttv cards) the max period size is somewhat
small. Since we only use 2 perios on these devices we end up with only
allowing small latencies, which is a problem when e.g. using a usb codec
as output.

This commit fixes this by adjusting the amount of periods on the capture
side when this happens.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 common/alsa_stream.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/common/alsa_stream.c b/common/alsa_stream.c
index 3e33b5e..1165554 100644
--- a/common/alsa_stream.c
+++ b/common/alsa_stream.c
@@ -109,9 +109,10 @@ static void getparams_periods(snd_pcm_t *handle,
 		      snd_pcm_hw_params_t *params,
 		      unsigned int *usecs,
 		      unsigned int *count,
-		      const char *id)
+		      int allow_adjust, const char *id)
 {
     unsigned min = 0, max = 0;
+    unsigned desired = *usecs * *count;
 
     snd_pcm_hw_params_get_periods_min(params, &min, 0);
     snd_pcm_hw_params_get_periods_max(params, &max, 0);
@@ -137,6 +138,13 @@ static void getparams_periods(snd_pcm_t *handle,
 	if (*usecs > max)
 	    *usecs = max;
     }
+
+    /* If we deviate from the desired size by more then 20% adjust count */
+    if (allow_adjust && (((*usecs * *count) < (desired *  8 / 10)) ||
+                         ((*usecs * *count) > (desired * 12 / 10)))) {
+        *count = (desired + *usecs / 2) / *usecs;
+        getparams_periods(handle, params, usecs, count, 0, id);
+    }
 }
 
 static int setparams_periods(snd_pcm_t *handle,
@@ -351,12 +359,16 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
     /* Negotiate period parameters */
 
     c_periodtime = latency * 1000 / c_periods;
-    getparams_periods(chandle, c_hwparams, &c_periodtime, &c_periods, "capture");
+    getparams_periods(chandle, c_hwparams, &c_periodtime, &c_periods, 1, "capture");
     p_periods = c_periods * 2;
     p_periodtime = c_periodtime;
-    getparams_periods(phandle, p_hwparams, &p_periodtime, &p_periods, "playback");
+    getparams_periods(phandle, p_hwparams, &p_periodtime, &p_periods, 0, "playback");
     c_periods = p_periods / 2;
 
+    if (verbose)
+	fprintf(error_fp, "alsa: Capture %u periods of %u usecs, Playback %u periods of %u usecs\n",
+		c_periods, c_periodtime, p_periods, p_periodtime);
+
     /*
      * Some playback devices support a very limited periodtime range. If the user needs to
      * use a higher latency to avoid overrun/underrun, use an alternate algorithm of incresing
@@ -365,10 +377,10 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
     if (p_periodtime < c_periodtime) {
 	c_periodtime = p_periodtime;
 	c_periods = round (latency * 1000.0 / c_periodtime + 0.5);
-	getparams_periods(chandle, c_hwparams, &c_periodtime, &c_periods, "capture");
+	getparams_periods(chandle, c_hwparams, &c_periodtime, &c_periods, 0, "capture");
 	p_periods = c_periods * 2;
 	p_periodtime = c_periodtime;
-	getparams_periods(phandle, p_hwparams, &p_periodtime, &p_periods, "playback");
+	getparams_periods(phandle, p_hwparams, &p_periodtime, &p_periods, 0, "playback");
 	c_periods = p_periods / 2;
     }
 
-- 
2.5.0

