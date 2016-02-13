Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbcBMSrn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2016 13:47:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id BEDE691D10
	for <linux-media@vger.kernel.org>; Sat, 13 Feb 2016 18:47:43 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH tvtime 01/17] alsa_stream: Sync with xawtv3 version
Date: Sat, 13 Feb 2016 19:47:22 +0100
Message-Id: <1455389258-13470-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xawtv3 copy of alsa_stream.c has several improvements / bug fixes,
sync these into tvtime.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 src/alsa_stream.c | 199 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 136 insertions(+), 63 deletions(-)

diff --git a/src/alsa_stream.c b/src/alsa_stream.c
index 99cea05..509787a 100644
--- a/src/alsa_stream.c
+++ b/src/alsa_stream.c
@@ -1,8 +1,9 @@
 /*
- *  tvtime ALSA device support
+ *  ALSA streaming support
  *
- *  Copyright (c) by Devin Heitmueller <dheitmueller@kernellabs.com>
- * 
+ *  Originally written by:
+ *      Copyright (c) by Devin Heitmueller <dheitmueller@kernellabs.com>
+ *	for usage at tvtime
  *  Derived from the alsa-driver test tool latency.c:
  *    Copyright (c) by Jaroslav Kysela <perex@perex.cz>
  *
@@ -25,6 +26,8 @@
  *
  */
 
+#include "config.h"
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -37,8 +40,9 @@
 #include <math.h>
 #include "alsa_stream.h"
 
+#define ARRAY_SIZE(a) (sizeof(a)/sizeof(*(a)))
+
 /* Private vars to control alsa thread status */
-static int alsa_is_running = 0;
 static int stop_alsa = 0;
 
 /* Error handlers */
@@ -56,7 +60,7 @@ struct final_params {
 static int setparams_stream(snd_pcm_t *handle,
 			    snd_pcm_hw_params_t *params,
 			    snd_pcm_format_t format,
-			    int channels,
+			    int *channels,
 			    const char *id)
 {
     int err;
@@ -83,10 +87,16 @@ static int setparams_stream(snd_pcm_t *handle,
 	       snd_strerror(err));
 	return err;
     }
-    err = snd_pcm_hw_params_set_channels(handle, params, channels);
+
+retry:
+    err = snd_pcm_hw_params_set_channels(handle, params, *channels);
     if (err < 0) {
+	if (strcmp(id, "capture") == 0 && *channels == 2) {
+	    *channels = 1;
+	    goto retry; /* Retry with mono capture */
+	}
 	fprintf(error_fp, "alsa: Channels count (%i) not available for %s: %s\n",
-		channels, id, snd_strerror(err));
+		*channels, id, snd_strerror(err));
 	return err;
     }
 
@@ -97,9 +107,10 @@ static void getparams_periods(snd_pcm_t *handle,
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
@@ -125,6 +136,13 @@ static void getparams_periods(snd_pcm_t *handle,
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
@@ -199,6 +217,33 @@ static int setparams_set(snd_pcm_t *handle,
     return 0;
 }
 
+static int alsa_try_rate(snd_pcm_t *phandle, snd_pcm_t *chandle,
+                        snd_pcm_hw_params_t *p_hwparams,
+                        snd_pcm_hw_params_t *c_hwparams,
+                        int allow_resample, unsigned *ratep, unsigned *ratec)
+{
+    int err;
+
+    err = snd_pcm_hw_params_set_rate_near(chandle, c_hwparams, ratec, 0);
+    if (err)
+        return err;
+
+    *ratep = *ratec;
+    err = snd_pcm_hw_params_set_rate_near(phandle, p_hwparams, ratep, 0);
+    if (err)
+        return err;
+
+    if (*ratep == *ratec)
+        return 0;
+
+    if (verbose)
+        fprintf(error_fp,
+                "alsa_try_rate: capture wanted %u, playback wanted %u%s\n",
+                *ratec, *ratep, allow_resample ? " with resample enabled": "");
+
+    return 1; /* No error, but also no match */
+}
+
 static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
 		     snd_pcm_format_t format,
 		     int latency, int allow_resample,
@@ -214,16 +259,17 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
     /* Our latency is 2 periods (in usecs) */
     unsigned int c_periods = 2, p_periods;
     unsigned int c_periodtime, p_periodtime;
+    const unsigned int prefered_rates[] = { 44100, 48000, 32000 };
 
     snd_pcm_hw_params_alloca(&p_hwparams);
     snd_pcm_hw_params_alloca(&c_hwparams);
     snd_pcm_sw_params_alloca(&p_swparams);
     snd_pcm_sw_params_alloca(&c_swparams);
 
-    if (setparams_stream(phandle, p_hwparams, format, channels, "playback"))
+    if (setparams_stream(chandle, c_hwparams, format, &channels, "capture"))
 	return 1;
 
-    if (setparams_stream(chandle, c_hwparams, format, channels, "capture"))
+    if (setparams_stream(phandle, p_hwparams, format, &channels, "playback"))
 	return 1;
 
     if (allow_resample) {
@@ -258,25 +304,40 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
     }
 
     if (verbose)
-	fprintf(error_fp, "alsa: Will search a common rate between %u and %u\n",
+	fprintf(error_fp,
+	        "alsa: Will search a common rate between %u and %u\n",
 		ratemin, ratemax);
 
-    for (i = ratemax; i <= ratemin; i -= 100) {
-	err = snd_pcm_hw_params_set_rate_near(chandle, c_hwparams, &i, 0);
-	if (err)
-	    continue;
-	ratec = i;
-	ratep = i;
-	err = snd_pcm_hw_params_set_rate_near(phandle, p_hwparams, &ratep, 0);
-	if (err)
-	    continue;
-	if (ratep == ratec)
-	    break;
-	if (verbose)
-	    fprintf(error_fp,
-		    "alsa: Failed to set to %u: capture wanted %u, playback wanted %u%s\n",
-		    i, ratec, ratep,
-		    allow_resample ? " with resample enabled": "");
+    /* First try a set of common rates */
+    err = -1;
+    for (i = 0; i < ARRAY_SIZE(prefered_rates); i++) {
+        if (prefered_rates[i] < ratemin || prefered_rates[i] > ratemax)
+            continue;
+        ratep = ratec = prefered_rates[i];
+        err = alsa_try_rate(phandle, chandle, p_hwparams, c_hwparams,
+                            allow_resample, &ratep, &ratec);
+        if (err == 0)
+            break;
+    }
+
+    if (err != 0) {
+        if (ratemin >= 44100) {
+            for (i = ratemin; i <= ratemax; i += 100) {
+                ratep = ratec = i;
+                err = alsa_try_rate(phandle, chandle, p_hwparams, c_hwparams,
+                                    allow_resample, &ratep, &ratec);
+                if (err == 0)
+                    break;
+            }
+        } else {
+            for (i = ratemax; i >= ratemin; i -= 100) {
+                ratep = ratec = i;
+                err = alsa_try_rate(phandle, chandle, p_hwparams, c_hwparams,
+                                    allow_resample, &ratep, &ratec);
+                if (err == 0)
+                    break;
+            }
+        }
     }
 
     if (err < 0) {
@@ -293,15 +354,19 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
     if (verbose)
 	fprintf(error_fp, "alsa: Using Rate %d\n", ratec);
 
-    /* Negociate period parameters */
+    /* Negotiate period parameters */
 
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
@@ -310,10 +375,10 @@ static int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle,
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
 
@@ -427,6 +492,7 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
 			    SND_PCM_NONBLOCK)) < 0) {
 	fprintf(error_fp, "alsa: Cannot open capture device %s: %s\n",
 		cdevice, snd_strerror(err));
+	snd_pcm_close(phandle);
 	return 0;
     }
 
@@ -445,6 +511,8 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
 				0)) < 0) {
 	    fprintf(error_fp, "alsa: Cannot open playback device %s: %s\n",
 		    pdevice, snd_strerror(err));
+	    snd_pcm_close(chandle);
+	    return 0;
 	}
 
 	err = setparams(phandle, chandle, format, latency, 1, &negotiated);
@@ -452,6 +520,8 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
 
     if (err != 0) {
 	fprintf(error_fp, "alsa: setparams failed\n");
+	snd_pcm_close(phandle);
+	snd_pcm_close(chandle);
 	return 1;
     }
 
@@ -459,20 +529,17 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
 		    * negotiated.channels);
     if (buffer == NULL) {
 	fprintf(error_fp, "alsa: Failed allocating buffer for audio\n");
+	snd_pcm_close(phandle);
+	snd_pcm_close(chandle);
 	return 0;
     }
 
-    /*
-     * Buffering delay is due for capture and for playback, so we
-     * need to multiply it by two.
-     */
-    fprintf(error_fp,
+    if (verbose)
+        fprintf(error_fp,
 	    "alsa: stream started from %s to %s (%i Hz, buffer delay = %.2f ms)\n",
 	    cdevice, pdevice, negotiated.rate,
 	    negotiated.latency * 1000.0 / negotiated.rate);
 
-    alsa_is_running = 1;
-
     while (!stop_alsa) {
 	/* We start with a read and not a wait to auto(re)start the capture */
 	r = readbuf(chandle, buffer, negotiated.bufsize);
@@ -481,12 +548,12 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
 	if (r > 0)
 	    writebuf(phandle, buffer, r);
 	/* use poll to wait for next event */
-	snd_pcm_wait(chandle, 1000);
+	while (!stop_alsa && !snd_pcm_wait(chandle, 50))
+	    ;
     }
 
     snd_pcm_drop(chandle);
-    snd_pcm_nonblock(phandle, 0);
-    snd_pcm_drain(phandle);
+    snd_pcm_drop(phandle);
 
     snd_pcm_unlink(chandle);
     snd_pcm_hw_free(phandle);
@@ -495,7 +562,6 @@ static int alsa_stream(const char *pdevice, const char *cdevice, int latency)
     snd_pcm_close(phandle);
     snd_pcm_close(chandle);
 
-    alsa_is_running = 0;
     return 0;
 }
 
@@ -513,7 +579,8 @@ static void *alsa_thread_entry(void *whatever)
 	fprintf(error_fp, "alsa: starting copying alsa stream from %s to %s\n",
 		inputs->cdevice, inputs->pdevice);
     alsa_stream(inputs->pdevice, inputs->cdevice, inputs->latency);
-    fprintf(error_fp, "alsa: stream stopped\n");
+    if (verbose)
+        fprintf(error_fp, "alsa: stream stopped\n");
 
     free(inputs->pdevice);
     free(inputs->cdevice);
@@ -526,12 +593,18 @@ static void *alsa_thread_entry(void *whatever)
  Public functions
  *************************************************************************/
 
+static int alsa_is_running = 0;
+static pthread_t alsa_thread;
+
 int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
 			FILE *__error_fp, int __verbose)
 {
     int ret;
-    pthread_t thread;
-    struct input_params *inputs = malloc(sizeof(struct input_params));
+    struct input_params *inputs;
+
+    if ((strcasecmp(pdevice, "disabled") == 0) ||
+	(strcasecmp(cdevice, "disabled") == 0))
+	return 0;
 
     if (__error_fp)
 	error_fp = __error_fp;
@@ -540,41 +613,41 @@ int alsa_thread_startup(const char *pdevice, const char *cdevice, int latency,
 
     verbose = __verbose;
 
+    if (alsa_is_running) {
+        fprintf(error_fp, "alsa: Already running\n");
+        return EBUSY;
+    }
 
+    inputs = malloc(sizeof(struct input_params));
     if (inputs == NULL) {
 	fprintf(error_fp, "alsa: failed allocating memory for inputs\n");
-	return 0;
-    }
-
-    if ((strcasecmp(pdevice, "disabled") == 0) ||
-	(strcasecmp(cdevice, "disabled") == 0)) {
-	free(inputs);
-	return 0;
+	return ENOMEM;
     }
 
     inputs->pdevice = strdup(pdevice);
     inputs->cdevice = strdup(cdevice);
     inputs->latency = latency;
 
-    if (alsa_is_running) {
-       stop_alsa = 1;
-       while ((volatile int)alsa_is_running)
-	       usleep(10);
-    }
-
     stop_alsa = 0;
-
-    ret = pthread_create(&thread, NULL,
+    ret = pthread_create(&alsa_thread, NULL,
 			 &alsa_thread_entry, (void *) inputs);
+    if (ret == 0)
+        alsa_is_running = 1;
+
     return ret;
 }
 
 void alsa_thread_stop(void)
 {
-	stop_alsa = 1;
+    if (!alsa_is_running)
+        return;
+
+    stop_alsa = 1;
+    pthread_join(alsa_thread, NULL);
+    alsa_is_running = 0;
 }
 
 int alsa_thread_is_running(void)
 {
-	return alsa_is_running;
+    return alsa_is_running;
 }
-- 
2.5.0

