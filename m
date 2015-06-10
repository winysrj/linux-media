Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41654 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbbFJSux (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 14:50:53 -0400
Date: Wed, 10 Jun 2015 15:50:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andy Furniss <adf.lists@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvbv5-tzap with pctv 290e/292e needs EAGAIN for pat/pmt to work
 when recording.
Message-ID: <20150610155047.25b92662@recife.lan>
In-Reply-To: <55787382.5010607@gmail.com>
References: <556E2D5B.5080201@gmail.com>
	<20150610095215.79e5e77e@recife.lan>
	<55787382.5010607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Jun 2015 18:27:30 +0100
Andy Furniss <adf.lists@gmail.com> escreveu:

> Mauro Carvalho Chehab wrote:
> 
> > Just applied a fix for it:
> > 	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=c7c9af17163f282a147ea76f1a3c0e9a0a86e7fa
> >
> > It will retry up to 10 times. This should very likely be enough if the
> > driver doesn't have any bug.
> >
> > Please let me know if this fixes the issue.
> 
> No, it doesn't, so I reverted the above and added back my hack + a 
> counter as below and it seems to be retrying > a million times.

Hmm.... that's likely a bug at the demod driver. It doesn't make much
sense to keep a mutex hold for that long. 

Anyway, I modified the patch to use a timeout of 1 second, instead of
trying 10 times. It is still a hack, as IMHO this is a driver bug,
but it should produce a better result.

Please check if the patch below works for you.

You may change the MAX_TIME there if 1 second is not enough.

It could be interesting if you add a printf with the difference
between start and end time, for us to have an idea about how
much time the driver is kept on such unreliable state.

Thanks!
Mauro


[PATCH] libdvbv5: use a timeout for ioctl

Some frontends don't play nice: they return -EAGAIN if the
device doesn't lock. That actually means that it may take
some time for some ioctl's to succeed. On experimental tests,
the loop may happen ~2 million times!

Well, better to waste power on a loop than to fail. So, let's
change the code that detects EAGAIN by a loop that waits up
to 1 second.

This is not the right thing to do, but the Kernel drivers
require fixes. We can do it only for newer versions of the
Kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/lib/libdvbv5/dvb-demux.c b/lib/libdvbv5/dvb-demux.c
index 867d7b9dddde..af124ae3a7cc 100644
--- a/lib/libdvbv5/dvb-demux.c
+++ b/lib/libdvbv5/dvb-demux.c
@@ -30,6 +30,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <time.h>
 #include <errno.h>
 
 #include <sys/ioctl.h>
@@ -40,12 +41,25 @@
 
 #include <libdvbv5/dvb-demux.h>
 
+#define MAX_TIME		10	/* 1.0 seconds */
+
 #define xioctl(fh, request, arg...) ({					\
-	int __rc, __retry;						\
+	int __rc;							\
+	struct timespec __start, __end;					\
 									\
-	for (__retry = 0; __retry < 10; __retry++) {			\
+	clock_gettime(CLOCK_MONOTONIC, &__start);			\
+	do {								\
 		__rc = ioctl(fh, request, ##arg);			\
-	} while (__rc == -1 && ((errno == EINTR) || (errno == EAGAIN)));\
+		if (__rc != -1)						\
+			break;						\
+		if (!((errno == EINTR) | (errno == EAGAIN)))		\
+			break;						\
+		clock_gettime(CLOCK_MONOTONIC, &__end);			\
+		if (__end.tv_sec * 10 + __end.tv_nsec / 100000000 >	\
+		    __start.tv_sec * 10 + __start.tv_nsec / 100000000 +	\
+		    MAX_TIME)						\
+			break;						\
+	} while (1);							\
 									\
 	__rc;								\
 })
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 48b09cd9ceaa..8607401841f2 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -26,6 +26,7 @@
 #include <inttypes.h>
 #include <math.h>
 #include <stddef.h>
+#include <time.h>
 #include <unistd.h>
 
 #include <config.h>
@@ -43,12 +44,25 @@ static int libdvbv5_initialized = 0;
 
 # define N_(string) string
 
+#define MAX_TIME		10	/* 1.0 seconds */
+
 #define xioctl(fh, request, arg...) ({					\
-	int __rc, __retry;						\
+	int __rc;							\
+	struct timespec __start, __end;					\
 									\
-	for (__retry = 0; __retry < 10; __retry++) {			\
+	clock_gettime(CLOCK_MONOTONIC, &__start);			\
+	do {								\
 		__rc = ioctl(fh, request, ##arg);			\
-	} while (__rc == -1 && ((errno == EINTR) || (errno == EAGAIN)));\
+		if (__rc != -1)						\
+			break;						\
+		if (!((errno == EINTR) | (errno == EAGAIN)))		\
+			break;						\
+		clock_gettime(CLOCK_MONOTONIC, &__end);			\
+		if (__end.tv_sec * 10 + __end.tv_nsec / 100000000 >	\
+		    __start.tv_sec * 10 + __start.tv_nsec / 100000000 +	\
+		    MAX_TIME)						\
+			break;						\
+	} while (1);							\
 									\
 	__rc;								\
 })

