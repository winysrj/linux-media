Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55885 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbKYPNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 10:13:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	y2038@lists.linaro.org
Subject: [PATCH 2/3] staging: media: lirc: Replace timeval with ktime_t in lirc_sasem.c
Date: Wed, 25 Nov 2015 16:12:53 +0100
Message-ID: <14705179.XxOpBT5U0L@wuerfel>
In-Reply-To: <3966611.mJGTQOXNKU@wuerfel>
References: <3966611.mJGTQOXNKU@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'struct timeval presstime' and 'struct timeval tv' is used to
calculate the time since the last button press.

32-bit systems using 'struct timeval' will break in the year 2038,
so we have to replace that code with more appropriate types.
This patch changes the media: lirc driver to use ktime_t.

ktime_get() is  better than using do_gettimeofday(), because it uses
the monotonic clock. ktime_sub() are used to subtract two ktime
variables. 'ms' is only used to check how much time has passed by comparing
to 250. So instead of using expensive ktime_to_ms() call, it has been
changed to hold nanoseconds by using ktime_to_ns().

Build tested it. Tested with sparse too.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index f2dca69c2bc0..2218d0042030 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -42,6 +42,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
+#include <linux/ktime.h>
 
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
@@ -111,7 +112,7 @@ struct sasem_context {
 	} tx;
 
 	/* for dealing with repeat codes (wish there was a toggle bit!) */
-	struct timeval presstime;
+	ktime_t presstime;
 	char lastcode[8];
 	int codesaved;
 };
@@ -566,8 +567,8 @@ static void incoming_packet(struct sasem_context *context,
 {
 	int len = urb->actual_length;
 	unsigned char *buf = urb->transfer_buffer;
-	long ms;
-	struct timeval tv;
+	u64 ns;
+	ktime_t kt;
 
 	if (len != 8) {
 		dev_warn(&context->dev->dev,
@@ -584,9 +585,8 @@ static void incoming_packet(struct sasem_context *context,
 	 */
 
 	/* get the time since the last button press */
-	do_gettimeofday(&tv);
-	ms = (tv.tv_sec - context->presstime.tv_sec) * 1000 +
-	     (tv.tv_usec - context->presstime.tv_usec) / 1000;
+	kt = ktime_get();
+	ns = ktime_to_ns(ktime_sub(kt, context->presstime));
 
 	if (memcmp(buf, "\x08\0\0\0\0\0\0\0", 8) == 0) {
 		/*
@@ -600,10 +600,9 @@ static void incoming_packet(struct sasem_context *context,
 		 *   in that time and then get a false repeat of the previous
 		 *   press but it is long enough for a genuine repeat
 		 */
-		if ((ms < 250) && (context->codesaved != 0)) {
+		if ((ns < 250 * NSEC_PER_MSEC) && (context->codesaved != 0)) {
 			memcpy(buf, &context->lastcode, 8);
-			context->presstime.tv_sec = tv.tv_sec;
-			context->presstime.tv_usec = tv.tv_usec;
+			context->presstime = kt;
 		}
 	} else {
 		/* save the current valid code for repeats */
@@ -613,8 +612,7 @@ static void incoming_packet(struct sasem_context *context,
 		 * just for safety reasons
 		 */
 		context->codesaved = 1;
-		context->presstime.tv_sec = tv.tv_sec;
-		context->presstime.tv_usec = tv.tv_usec;
+		context->presstime = kt;
 	}
 
 	lirc_buffer_write(context->driver->rbuf, buf);

