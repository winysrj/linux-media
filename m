Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54932 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932287AbdKFOGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 09:06:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sean Young <sean@mess.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: rc: Replace timeval with ktime_t in imon.c
Date: Mon,  6 Nov 2017 15:06:10 +0100
Message-Id: <20171106140626.1601072-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chunyan Zhang <zhang.chunyan@linaro.org>

This patch changes the 32-bit time type (timeval) to the 64-bit one
(ktime_t), since 32-bit time types will break in the year 2038.

I use ktime_t instead of all uses of timeval in imon.c

This patch also changes do_gettimeofday() to ktime_get() accordingly,
since ktime_get returns a ktime_t, but do_gettimeofday returns a
struct timeval, and the other reason is that ktime_get() uses
the monotonic clock.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This patch was part of an old three-patch series, but did not
get merged at the time after I dropped the ball on it.
---
 drivers/media/rc/imon.c | 49 +++++++++++++------------------------------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index b25b35b3f6da..6c3ca1fff16b 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -27,6 +27,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -37,7 +38,6 @@
 #include <linux/usb/input.h>
 #include <media/rc-core.h>
 
-#include <linux/time.h>
 #include <linux/timer.h>
 
 #define MOD_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
@@ -1168,29 +1168,6 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 	return retval;
 }
 
-static inline int tv2int(const struct timeval *a, const struct timeval *b)
-{
-	int usecs = 0;
-	int sec   = 0;
-
-	if (b->tv_usec > a->tv_usec) {
-		usecs = 1000000;
-		sec--;
-	}
-
-	usecs += a->tv_usec - b->tv_usec;
-
-	sec += a->tv_sec - b->tv_sec;
-	sec *= 1000;
-	usecs /= 1000;
-	sec += usecs;
-
-	if (sec < 0)
-		sec = 1000;
-
-	return sec;
-}
-
 /**
  * The directional pad behaves a bit differently, depending on whether this is
  * one of the older ffdc devices or a newer device. Newer devices appear to
@@ -1201,16 +1178,16 @@ static inline int tv2int(const struct timeval *a, const struct timeval *b)
  */
 static int stabilize(int a, int b, u16 timeout, u16 threshold)
 {
-	struct timeval ct;
-	static struct timeval prev_time = {0, 0};
-	static struct timeval hit_time  = {0, 0};
+	ktime_t ct;
+	static ktime_t prev_time;
+	static ktime_t hit_time;
 	static int x, y, prev_result, hits;
 	int result = 0;
-	int msec, msec_hit;
+	long msec, msec_hit;
 
-	do_gettimeofday(&ct);
-	msec = tv2int(&ct, &prev_time);
-	msec_hit = tv2int(&ct, &hit_time);
+	ct = ktime_get();
+	msec = ktime_ms_delta(ct, prev_time);
+	msec_hit = ktime_ms_delta(ct, hit_time);
 
 	if (msec > 100) {
 		x = 0;
@@ -1688,9 +1665,9 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 	u32 kc;
 	u64 scancode;
 	int press_type = 0;
-	int msec;
-	struct timeval t;
-	static struct timeval prev_time = { 0, 0 };
+	long msec;
+	ktime_t t;
+	static ktime_t prev_time;
 	u8 ktype;
 
 	/* filter out junk data on the older 0xffdc imon devices */
@@ -1783,10 +1760,10 @@ static void imon_incoming_scancode(struct imon_context *ictx,
 	/* Only panel type events left to process now */
 	spin_lock_irqsave(&ictx->kc_lock, flags);
 
-	do_gettimeofday(&t);
+	t = ktime_get();
 	/* KEY_MUTE repeats from knob need to be suppressed */
 	if (ictx->kc == KEY_MUTE && ictx->kc == ictx->last_keycode) {
-		msec = tv2int(&t, &prev_time);
+		msec = ktime_ms_delta(t, prev_time);
 		if (msec < ictx->idev->rep[REP_DELAY]) {
 			spin_unlock_irqrestore(&ictx->kc_lock, flags);
 			return;
-- 
2.9.0
