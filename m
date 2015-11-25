Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:63524 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbbKYPNj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 10:13:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	y2038@lists.linaro.org
Subject: [PATCH 3/3] staging: media: lirc: Replace timeval with ktime_t in lirc_parallel.c
Date: Wed, 25 Nov 2015 16:13:26 +0100
Message-ID: <4716726.5GsAHSDJCO@wuerfel>
In-Reply-To: <3966611.mJGTQOXNKU@wuerfel>
References: <3966611.mJGTQOXNKU@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'struct timeval tv' and 'struct timeval now' is used to calculate the
elapsed time. 'LIRC_SFH506_DELAY' is a delay t_phl in usecs.

32-bit systems using 'struct timeval' will break in the year 2038,
so we have to replace that code with more appropriate types.
This patch changes the lirc_parallel.c file of  media: lirc driver
to use ktime_t.

ktime_get() is  better than using do_gettimeofday(),
because it uses the monotonic clock. ktime_sub is used
to subtract two ktime variables. ktime_to_us() is used to
convert ktime to microsecond.

New ktime_t variable timeout, is added in lirc_off(),to improve
clarity. Introduced a new ktime_t variable in lirc_lirc_irq_handler()
function, to avoid the use of signal variable for storing
seconds in the first part of this fucntion as later it uses
a time unit that is defined by the global "timer" variable.
This makes it more clear.

ktime_set() is used to set a value in seconds to a value in
nanosecond so that ktime_compare() can be used appropriately.
ktime_compare() is used to compare two ktime values.
ktime_add_ns() is used to increment a ktime value by 1 sec.

One comment is also shifted a line up, as it was creating a 80
character warning.

Build tested it. Also tested it with sparse.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index c1408342b1d0..c7987c01d9e0 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -33,7 +33,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/ioport.h>
-#include <linux/time.h>
+#include <linux/ktime.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 
@@ -144,25 +144,22 @@ static void lirc_off(void)
 
 static unsigned int init_lirc_timer(void)
 {
-	struct timeval tv, now;
+	ktime_t kt, now, timeout;
 	unsigned int level, newlevel, timeelapsed, newtimer;
 	int count = 0;
 
-	do_gettimeofday(&tv);
-	tv.tv_sec++;                     /* wait max. 1 sec. */
+	kt = ktime_get();
+	/* wait max. 1 sec. */
+	timeout = ktime_add_ns(kt, NSEC_PER_SEC);
 	level = lirc_get_timer();
 	do {
 		newlevel = lirc_get_timer();
 		if (level == 0 && newlevel != 0)
 			count++;
 		level = newlevel;
-		do_gettimeofday(&now);
-	} while (count < 1000 && (now.tv_sec < tv.tv_sec
-			     || (now.tv_sec == tv.tv_sec
-				 && now.tv_usec < tv.tv_usec)));
-
-	timeelapsed = (now.tv_sec + 1 - tv.tv_sec)*1000000
-		     + (now.tv_usec - tv.tv_usec);
+		now = ktime_get();
+	} while (count < 1000 && (ktime_before(now, timeout)));
+	timeelapsed = ktime_us_delta(now, kt);
 	if (count >= 1000 && timeelapsed > 0) {
 		if (default_timer == 0) {
 			/* autodetect timer */
@@ -220,8 +217,8 @@ static void rbuf_write(int signal)
 
 static void lirc_lirc_irq_handler(void *blah)
 {
-	struct timeval tv;
-	static struct timeval lasttv;
+	ktime_t kt, delkt;
+	static ktime_t lastkt;
 	static int init;
 	long signal;
 	int data;
@@ -244,16 +241,14 @@ static void lirc_lirc_irq_handler(void *blah)
 
 #ifdef LIRC_TIMER
 	if (init) {
-		do_gettimeofday(&tv);
+		kt = ktime_get();
 
-		signal = tv.tv_sec - lasttv.tv_sec;
-		if (signal > 15)
+		delkt = ktime_sub(kt, lastkt);
+		if (ktime_compare(delkt, ktime_set(15, 0)) > 0)
 			/* really long time */
 			data = PULSE_MASK;
 		else
-			data = (int) (signal*1000000 +
-					 tv.tv_usec - lasttv.tv_usec +
-					 LIRC_SFH506_DELAY);
+			data = (int) (ktime_to_us(delkt) + LIRC_SFH506_DELAY);
 
 		rbuf_write(data); /* space */
 	} else {
@@ -301,7 +296,7 @@ static void lirc_lirc_irq_handler(void *blah)
 			data = 1;
 		rbuf_write(PULSE_BIT|data); /* pulse */
 	}
-	do_gettimeofday(&lasttv);
+	lastkt = ktime_get();
 #else
 	/* add your code here */
 #endif

