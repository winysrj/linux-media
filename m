Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35383 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbbEMQ51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 12:57:27 -0400
Received: by widdi4 with SMTP id di4so207254946wid.0
        for <linux-media@vger.kernel.org>; Wed, 13 May 2015 09:57:26 -0700 (PDT)
From: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
To: y2038@lists.linaro.org
Cc: linux-media@vger.kernel.org, arnd@arndb.de, john.stultz@linaro.org,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Subject: [PATCH v3] Staging: media: Replace timeval with ktime_t
Date: Wed, 13 May 2015 18:57:18 +0200
Message-Id: <1431536238-12738-1-git-send-email-ksenija.stanojevic@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'struct timeval last_tv' is used to get the time of last signal change
and 'struct timeval last_intr_tv' is used to get the time of last UART
interrupt.
32-bit systems using 'struct timeval' will break in the year 2038, so we
have to replace that code with more appropriate types.
Here struct timeval is replaced with ktime_t.

Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
---
Changes in v3:
	- as John suggested delta function is changed to inline function,
	checkpatch signals a warning to change min to min_t. Is it a false 
	positive?
	- change variable names.

Changes in v2:
	- change subject line

 drivers/staging/media/lirc/lirc_sir.c | 51 +++++++++++++----------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 29087f6..c98c486 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -44,7 +44,7 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
-#include <linux/time.h>
+#include <linux/ktime.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
@@ -127,9 +127,9 @@ static int threshold = 3;
 static DEFINE_SPINLOCK(timer_lock);
 static struct timer_list timerlist;
 /* time of last signal change detected */
-static struct timeval last_tv = {0, 0};
+static ktime_t last;
 /* time of last UART data ready interrupt */
-static struct timeval last_intr_tv = {0, 0};
+static ktime_t last_intr_time;
 static int last_value;
 
 static DECLARE_WAIT_QUEUE_HEAD(lirc_read_queue);
@@ -400,18 +400,11 @@ static void drop_chrdev(void)
 }
 
 /* SECTION: Hardware */
-static long delta(struct timeval *tv1, struct timeval *tv2)
+static inline long delta(ktime_t t1, ktime_t t2)
 {
-	unsigned long deltv;
-
-	deltv = tv2->tv_sec - tv1->tv_sec;
-	if (deltv > 15)
-		deltv = 0xFFFFFF;
-	else
-		deltv = deltv*1000000 +
-			tv2->tv_usec -
-			tv1->tv_usec;
-	return deltv;
+	/* return the delta in 32bit usecs, but cap to UINTMAX in case the
+	 * delta is greater then 32bits */
+	return (long) min((unsigned int) ktime_us_delta(t1, t2), UINT_MAX);
 }
 
 static void sir_timeout(unsigned long data)
@@ -432,12 +425,12 @@ static void sir_timeout(unsigned long data)
 		/* clear unread bits in UART and restart */
 		outb(UART_FCR_CLEAR_RCVR, io + UART_FCR);
 		/* determine 'virtual' pulse end: */
-		pulse_end = delta(&last_tv, &last_intr_tv);
+		pulse_end = delta(last, last_intr_time);
 		dev_dbg(driver.dev, "timeout add %d for %lu usec\n",
 				    last_value, pulse_end);
 		add_read_queue(last_value, pulse_end);
 		last_value = 0;
-		last_tv = last_intr_tv;
+		last = last_intr_time;
 	}
 	spin_unlock_irqrestore(&timer_lock, flags);
 }
@@ -445,7 +438,7 @@ static void sir_timeout(unsigned long data)
 static irqreturn_t sir_interrupt(int irq, void *dev_id)
 {
 	unsigned char data;
-	struct timeval curr_tv;
+	ktime_t curr_time;
 	static unsigned long deltv;
 	unsigned long deltintrtv;
 	unsigned long flags;
@@ -471,9 +464,9 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 			do {
 				del_timer(&timerlist);
 				data = inb(io + UART_RX);
-				do_gettimeofday(&curr_tv);
-				deltv = delta(&last_tv, &curr_tv);
-				deltintrtv = delta(&last_intr_tv, &curr_tv);
+				curr_time = ktime_get();
+				deltv = delta(last, curr_time);
+				deltintrtv = delta(last_intr_time, curr_time);
 				dev_dbg(driver.dev, "t %lu, d %d\n",
 						    deltintrtv, (int)data);
 				/*
@@ -488,10 +481,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 							       deltv -
 							       deltintrtv);
 						last_value = 0;
-						last_tv.tv_sec =
-							last_intr_tv.tv_sec;
-						last_tv.tv_usec =
-							last_intr_tv.tv_usec;
+						last = last_intr_time;
 						deltv = deltintrtv;
 					}
 				}
@@ -504,16 +494,11 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 					add_read_queue(last_value,
 						       deltv-TIME_CONST);
 					last_value = data;
-					last_tv = curr_tv;
-					if (last_tv.tv_usec >= TIME_CONST) {
-						last_tv.tv_usec -= TIME_CONST;
-					} else {
-						last_tv.tv_sec--;
-						last_tv.tv_usec += 1000000 -
-							TIME_CONST;
-					}
+					last = curr_time;
+					last = ktime_sub_us(last,
+							    TIME_CONST);
 				}
-				last_intr_tv = curr_tv;
+				last_intr_time = curr_time;
 				if (data) {
 					/*
 					 * start timer for end of
-- 
1.9.1

