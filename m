Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab1EWUaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 16:30:25 -0400
Message-ID: <4DDAC3DD.2020501@redhat.com>
Date: Mon, 23 May 2011 17:30:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <BANLkTinjqbU0rYnG42afw+9FywT9PBhutQ@mail.gmail.com>
In-Reply-To: <BANLkTinjqbU0rYnG42afw+9FywT9PBhutQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 17:19, Devin Heitmueller escreveu:
> On Mon, May 23, 2011 at 4:17 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>> during the weekend, I decided to add alsa support also on xawtv3, basically
>> to provide a real usecase example. Of course, for it to work, it needs the
>> very latest v4l2-utils version from the git tree.
>>
>> I've basically added there the code that Devin wrote for tvtime, with a few
>> small fixes and with the audio device auto-detection.
> 
> If any of these fixes you made apply to the code in general, I will be
> happy to merge them into our tvtime tree.  Let me know.

They are small. As I changed the non-public stuff to static, some warnings
happened. I also added some logic there to avoid re-starting the thread when
it is active, to allow stopping a stream and to check if the stream is running.

The enclosed patch contains the diff from your version. As I'm using it at xawtv,
I've removed tvtime_ prefix from the calls, so you'll probably need to fix it, or
to change the function call inside tvtime.

--- a/alsa_stream.c
+++ b/alsa_stream.c
@@ -2,7 +2,7 @@
  *  tvtime ALSA device support
  *
  *  Copyright (c) by Devin Heitmueller <dheitmueller@kernellabs.com>
- * 
+ *
  *  Derived from the alsa-driver test tool latency.c:
  *    Copyright (c) by Jaroslav Kysela <perex@perex.cz>
  *
@@ -23,6 +23,10 @@
  *
  */
 
+#include "config.h"
+
+#ifdef HAVE_ALSA_ASOUNDLIB_H
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -33,6 +37,11 @@
 #include <alsa/asoundlib.h>
 #include <sys/time.h>
 #include <math.h>
+#include "alsa_stream.h"
+
+/* Private vars to control alsa thread status */
+static int alsa_is_running = 0;
+static int stop_alsa = 0;
 
 snd_output_t *output = NULL;
 
@@ -43,12 +52,12 @@ struct final_params {
     int channels;
 };
 
-int setparams_stream(snd_pcm_t *handle,
-		     snd_pcm_hw_params_t *params,
-		     snd_pcm_format_t format,
-		     int channels,
-		     int rate,
-		     const char *id)
+static int setparams_stream(snd_pcm_t *handle,
+			    snd_pcm_hw_params_t *params,
+			    snd_pcm_format_t format,
+			    int channels,
+			    int rate,
+			    const char *id)
 {
     int err;
     unsigned int rrate;
@@ -66,14 +75,14 @@ int setparams_stream(snd_pcm_t *handle,
     err = snd_pcm_hw_params_set_access(handle, params,
 				       SND_PCM_ACCESS_RW_INTERLEAVED);
     if (err < 0) {
-	printf("Access type not available for %s: %s\n", id, 
+	printf("Access type not available for %s: %s\n", id,
 	       snd_strerror(err));
 	return err;
     }
 
     err = snd_pcm_hw_params_set_format(handle, params, format);
     if (err < 0) {
-	printf("Sample format not available for %s: %s\n", id, 
+	printf("Sample format not available for %s: %s\n", id,
 	       snd_strerror(err));
 	return err;
     }
@@ -129,10 +138,10 @@ int setparams_bufsize(snd_pcm_t *handle,
     return 0;
 }
 
-int setparams_set(snd_pcm_t *handle,
-		  snd_pcm_hw_params_t *params,
-		  snd_pcm_sw_params_t *swparams,
-		  const char *id)
+static int setparams_set(snd_pcm_t *handle,
+			 snd_pcm_hw_params_t *params,
+			 snd_pcm_sw_params_t *swparams,
+			 const char *id)
 {
     int err;
 
@@ -181,7 +190,7 @@ int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle, snd_pcm_format_t format,
     snd_pcm_sw_params_t *p_swparams, *c_swparams;
     snd_pcm_uframes_t p_size, c_size, p_psize, c_psize;
     unsigned int p_time, c_time;
-    
+
     snd_pcm_hw_params_alloca(&p_params);
     snd_pcm_hw_params_alloca(&c_params);
     snd_pcm_hw_params_alloca(&pt_params);
@@ -258,7 +267,7 @@ int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle, snd_pcm_format_t format,
     printf("final config\n");
     snd_pcm_dump_setup(phandle, output);
     snd_pcm_dump_setup(chandle, output);
-    printf("Parameters are %iHz, %s, %i channels\n", rate, 
+    printf("Parameters are %iHz, %s, %i channels\n", rate,
 	   snd_pcm_format_name(format), channels);
     fflush(stdout);
 #endif
@@ -270,25 +279,8 @@ int setparams(snd_pcm_t *phandle, snd_pcm_t *chandle, snd_pcm_format_t format,
     return 0;
 }
 
-void setscheduler(void)
-{
-    struct sched_param sched_param;
-
-    if (sched_getparam(0, &sched_param) < 0) {
-	printf("Scheduler getparam failed...\n");
-	return;
-    }
-    sched_param.sched_priority = sched_get_priority_max(SCHED_RR);
-    if (!sched_setscheduler(0, SCHED_RR, &sched_param)) {
-	printf("Scheduler set to Round Robin with priority %i...\n", sched_param.sched_priority);
-	fflush(stdout);
-	return;
-    }
-    printf("!!!Scheduler set to Round Robin with priority %i FAILED!!!\n", sched_param.sched_priority);
-}
-
-snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len,
-			  size_t *frames, size_t *max)
+static snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len,
+				 size_t *frames, size_t *max)
 {
     snd_pcm_sframes_t r;
 
@@ -306,8 +298,8 @@ snd_pcm_sframes_t readbuf(snd_pcm_t *handle, char *buf, long len,
     return r;
 }
 
-snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len,
-			   size_t *frames)
+static snd_pcm_sframes_t writebuf(snd_pcm_t *handle, char *buf, long len,
+				  size_t *frames)
 {
     snd_pcm_sframes_t r;
 
@@ -352,7 +344,7 @@ int startup_capture(snd_pcm_t *phandle, snd_pcm_t *chandle,
     return 0;
 }
 
-int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
+static int alsa_stream(const char *pdevice, const char *cdevice)
 {
     snd_pcm_t *phandle, *chandle;
     char *buffer;
@@ -370,20 +362,20 @@ int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
     }
 
 //    setscheduler();
- 
+
     printf("Playback device is %s\n", pdevice);
     printf("Capture device is %s\n", cdevice);
 
     /* Open the devices */
     if ((err = snd_pcm_open(&phandle, pdevice, SND_PCM_STREAM_PLAYBACK,
 			    SND_PCM_NONBLOCK)) < 0) {
-	printf("Cannot open ALSA Playback device %s: %s\n", pdevice, 
+	printf("Cannot open ALSA Playback device %s: %s\n", pdevice,
 	       snd_strerror(err));
 	return 0;
     }
     if ((err = snd_pcm_open(&chandle, cdevice, SND_PCM_STREAM_CAPTURE,
 			    SND_PCM_NONBLOCK)) < 0) {
-	printf("Cannot open ALSA Capture device %s: %s\n", 
+	printf("Cannot open ALSA Capture device %s: %s\n",
 	       cdevice, snd_strerror(err));
 	return 0;
     }
@@ -406,10 +398,11 @@ int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
 	return 1;
     }
 
-    startup_capture(phandle, chandle, format, buffer, negotiated.latency, 
+    alsa_is_running = 1;
+    startup_capture(phandle, chandle, format, buffer, negotiated.latency,
 		    negotiated.channels);
 
-    while (1) { 			  
+    while (!stop_alsa) {
 	in_max = 0;
 
 	/* use poll to wait for next event */
@@ -452,6 +445,8 @@ int tvtime_alsa_stream(const char *pdevice, const char *cdevice)
 
     snd_pcm_close(phandle);
     snd_pcm_close(chandle);
+
+    alsa_is_running = 0;
     return 0;
 }
 
@@ -460,13 +455,22 @@ struct input_params {
     const char *cdevice;
 };
 
-void *tvtime_alsa_thread_entry(void *whatever)
+static void *alsa_thread_entry(void *whatever)
 {
     struct input_params *inputs = (struct input_params *) whatever;
-    tvtime_alsa_stream(inputs->pdevice, inputs->cdevice);
+
+    printf("Starting copying alsa stream from %s to %s\n", inputs->cdevice, inputs->pdevice);
+    alsa_stream(inputs->pdevice, inputs->cdevice);
+    printf("Alsa stream stopped\n");
+
+    return whatever;
 }
 
-int tvtime_alsa_thread_startup(const char *pdevice, const char *cdevice)
+/*************************************************************************
+ Public functions
+ *************************************************************************/
+
+int alsa_thread_startup(const char *pdevice, const char *cdevice)
 {
     int ret;
     pthread_t thread;
@@ -486,17 +490,27 @@ int tvtime_alsa_thread_startup(const char *pdevice, const char *cdevice)
     inputs->pdevice = strdup(pdevice);
     inputs->cdevice = strdup(cdevice);
 
+    if (alsa_is_running) {
+       stop_alsa = 1;
+       while ((volatile int)alsa_is_running)
+	       usleep(10);
+    }
+
+    stop_alsa = 0;
+
     ret = pthread_create(&thread, NULL,
-			 &tvtime_alsa_thread_entry, (void *) inputs);
+			 &alsa_thread_entry, (void *) inputs);
     return ret;
 }
 
-#ifdef TVTIME_ALSA_DEBUGGING
-/* This allows the alsa_stream.c to be a standalone binary for debugging */
- int main(int argc, char *argv[])
+void alsa_thread_stop(void)
 {
-    char *pdevice = "hw:0,0";
-    char *cdevice = "hw:1,0";
-    tvtime_alsa_stream(pdevice, cdevice);
+	stop_alsa = 1;
 }
+
+int alsa_thread_is_running(void)
+{
+	return alsa_is_running;
+}
+
 #endif
diff --git a/common/alsa_stream.h b/common/alsa_stream.h
index 8572c8b..b8d468c 100644
--- a/alsa_stream.h
+++ b/alsa_stream.h
@@ -1 +1,3 @@
-int tvtime_alsa_thread_startup(char *pdevice, char *cdevice);
+int alsa_thread_startup(const char *pdevice, const char *cdevice);
+void alsa_thread_stop(void);
+int alsa_thread_is_running(void);
