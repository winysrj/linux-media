Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33021 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbEaHRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 03:17:12 -0400
Date: Sun, 31 May 2015 12:47:06 +0530
From: Tina Ruchandani <ruchandani.tina@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3] [media] dvb-frontend: Replace timeval with ktime_t
Message-ID: <20150531071706.GA3940@tinar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct timeval uses a 32-bit seconds representation which will
overflow in the year 2038 and beyond. This patch replaces
the usage of struct timeval with ktime_t which is a 64-bit
timestamp and is year 2038 safe.
This patch is part of a larger attempt to remove all instances
of 32-bit timekeeping variables (timeval, timespec, time_t)
which are not year 2038 safe, from the kernel.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
Suggested-by: Arnd Bergmann <arndb@arndb.de>

--
Changes in v3:
- Clean up commit message.
- Use ktime_us_delta which is more concise than the combination
of ktime_sub and ktime_to_us
Changes in v2:
- Use the more concise ktime_us_delta
- Preserve the waketime argument in dvb_frontend_sleep_until as
a pointer, fixes bug introduced in v1 of the patch where the caller
doesn't get its timestamp modified.

Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 41 ++++++++++-------------------------
 drivers/media/dvb-core/dvb_frontend.h |  3 +--
 drivers/media/dvb-frontends/stv0299.c | 12 +++++-----
 3 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 882ca41..69be73c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -40,6 +40,7 @@
 #include <linux/freezer.h>
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
+#include <linux/ktime.h>
 #include <asm/processor.h>
 
 #include "dvb_frontend.h"
@@ -889,42 +890,21 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 				fepriv->thread);
 }
 
-s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime)
-{
-	return ((curtime.tv_usec < lasttime.tv_usec) ?
-		1000000 - lasttime.tv_usec + curtime.tv_usec :
-		curtime.tv_usec - lasttime.tv_usec);
-}
-EXPORT_SYMBOL(timeval_usec_diff);
-
-static inline void timeval_usec_add(struct timeval *curtime, u32 add_usec)
-{
-	curtime->tv_usec += add_usec;
-	if (curtime->tv_usec >= 1000000) {
-		curtime->tv_usec -= 1000000;
-		curtime->tv_sec++;
-	}
-}
-
 /*
  * Sleep until gettimeofday() > waketime + add_usec
  * This needs to be as precise as possible, but as the delay is
  * usually between 2ms and 32ms, it is done using a scheduled msleep
  * followed by usleep (normally a busy-wait loop) for the remainder
  */
-void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec)
+void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec)
 {
-	struct timeval lasttime;
 	s32 delta, newdelta;
 
-	timeval_usec_add(waketime, add_usec);
-
-	do_gettimeofday(&lasttime);
-	delta = timeval_usec_diff(lasttime, *waketime);
+	ktime_add_us(*waketime, add_usec);
+	delta = ktime_us_delta(ktime_get_real(), *waketime);
 	if (delta > 2500) {
 		msleep((delta - 1500) / 1000);
-		do_gettimeofday(&lasttime);
-		newdelta = timeval_usec_diff(lasttime, *waketime);
+		newdelta = ktime_us_delta(ktime_get_real(), *waketime);
 		delta = (newdelta > delta) ? 0 : newdelta;
 	}
 	if (delta > 0)
@@ -2458,13 +2438,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			 * include the initialization or start bit
 			 */
 			unsigned long swcmd = ((unsigned long) parg) << 1;
-			struct timeval nexttime;
-			struct timeval tv[10];
+			ktime_t nexttime;
+			ktime_t tv[10];
 			int i;
 			u8 last = 1;
 			if (dvb_frontend_debug)
 				printk("%s switch command: 0x%04lx\n", __func__, swcmd);
-			do_gettimeofday(&nexttime);
+			nexttime = ktime_get_real();
 			if (dvb_frontend_debug)
 				tv[0] = nexttime;
 			/* before sending a command, initialize by sending
@@ -2475,7 +2455,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 			for (i = 0; i < 9; i++) {
 				if (dvb_frontend_debug)
-					do_gettimeofday(&tv[i + 1]);
+					tv[i+1] = ktime_get_real();
 				if ((swcmd & 0x01) != last) {
 					/* set voltage to (last ? 13V : 18V) */
 					fe->ops.set_voltage(fe, (last) ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18);
@@ -2489,7 +2469,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 				printk("%s(%d): switch delay (should be 32k followed by all 8k\n",
 					__func__, fe->dvb->num);
 				for (i = 1; i < 10; i++)
-					printk("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
+					printk("%d: %d\n", i,
+					(int) ktime_us_delta(tv[i], tv[i-1]);
 			}
 			err = 0;
 			fepriv->state = FESTATE_DISEQC;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 816269e..5b64686 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -439,7 +439,6 @@ extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
 extern int dvb_frontend_suspend(struct dvb_frontend *fe);
 extern int dvb_frontend_resume(struct dvb_frontend *fe);
 
-extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
-extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
+extern void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec);
 
 #endif
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index b57ecf4..347c2bc 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -44,6 +44,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -404,8 +405,8 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 	u8 lv_mask = 0x40;
 	u8 last = 1;
 	int i;
-	struct timeval nexttime;
-	struct timeval tv[10];
+	ktime_t nexttime;
+	ktime_t tv[10];
 
 	reg0x08 = stv0299_readreg (state, 0x08);
 	reg0x0c = stv0299_readreg (state, 0x0c);
@@ -418,7 +419,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 	if (debug_legacy_dish_switch)
 		printk ("%s switch command: 0x%04lx\n",__func__, cmd);
 
-	do_gettimeofday (&nexttime);
+	nexttime = ktime_get_real();
 	if (debug_legacy_dish_switch)
 		tv[0] = nexttime;
 	stv0299_writeregI (state, 0x0c, reg0x0c | 0x50); /* set LNB to 18V */
@@ -427,7 +428,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 
 	for (i=0; i<9; i++) {
 		if (debug_legacy_dish_switch)
-			do_gettimeofday (&tv[i+1]);
+			tv[i+1] = ktime_get_real();
 		if((cmd & 0x01) != last) {
 			/* set voltage to (last ? 13V : 18V) */
 			stv0299_writeregI (state, 0x0c, reg0x0c | (last ? lv_mask : 0x50));
@@ -443,7 +444,8 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 		printk ("%s(%d): switch delay (should be 32k followed by all 8k\n",
 			__func__, fe->dvb->num);
 		for (i = 1; i < 10; i++)
-			printk ("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
+			printk("%d: %d\n", i,
+			       (int) ktime_us_delta(tv[i], tv[i-1]));
 	}
 
 	return 0;
-- 
2.2.0.rc0.207.ga3a616c

