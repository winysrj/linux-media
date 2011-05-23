Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1EWUcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 16:32:21 -0400
Message-ID: <4DDAC451.6000002@redhat.com>
Date: Mon, 23 May 2011 17:32:17 -0300
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

The code bellow will probably be more useful for you. It basically adds alsa
device autodetection. The patch is against xawtv source code, but the code
there is generic enough to be added on tvtime.

Have fun!
Mauro

diff --git a/x11/xt.c b/x11/xt.c
index 81658a0..7cf7281 100644
--- a/x11/xt.c
+++ b/x11/xt.c
@@ -22,7 +22,9 @@
 #include <netinet/in.h>
 #include <netdb.h>
 #include <pthread.h>
-
+#ifdef HAVE_LIBV42LUTIL
+# include <get_media_devices.h>
+#endif
 #if defined(__linux__)
 # include <sys/ioctl.h>
 #include <linux/types.h>
@@ -58,6 +60,7 @@
 #include "blit.h"
 #include "parseconfig.h"
 #include "event.h"
+#include "alsa_stream.h"
 
 /* jwz */
 #include "remote.h"
@@ -1377,6 +1380,11 @@ grabber_init()
 {
     struct ng_video_fmt screen;
     void *base = NULL;
+#if defined(HAVE_V4L2UTIL) && defined(HAVE_ALSA)
+    struct media_devices *md;
+    unsigned int size = 0;
+    char *alsa_cap, *alsa_out, *p;
+#endif
 
     memset(&screen,0,sizeof(screen));
 #ifdef HAVE_LIBXXF86DGA
@@ -1417,6 +1425,22 @@ grabber_init()
     }
     f_drv = drv->capabilities(h_drv);
     add_attrs(drv->list_attrs(h_drv));
+
+#if defined(HAVE_V4L2UTIL) && defined(HAVE_ALSA)
+    /* Start audio capture thread */
+    md = discover_media_devices(&size);
+    p = strrchr(args.device, '/');
+    if (!p)
+	p = args.device;
+    alsa_cap = get_first_alsa_cap_device(md, size, p + 1);
+    alsa_out = get_first_no_video_out_device(md, size);
+
+    printf("Alsa devices: cap: %s (%s), out: %s\n", alsa_cap, args.device, alsa_out);
+
+    if (alsa_cap && alsa_out)
+        alsa_thread_startup(alsa_out, alsa_cap);
+    free_media_devices(md, size);
+#endif
 }
 
 void
