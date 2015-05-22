Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33099 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945933AbbEVP6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 11:58:52 -0400
From: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jarod@wilsonet.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Subject: [PATCH] Staging: media: lirc: Replace timeval with ktime_t
Date: Fri, 22 May 2015 17:58:42 +0200
Message-Id: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
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
 drivers/staging/media/lirc/lirc_sir.c | 75 ++++++++++++++---------------------
 1 file changed, 30 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index 29087f6..4f326e9 100644
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
@@ -400,20 +400,6 @@ static void drop_chrdev(void)
 }
 
 /* SECTION: Hardware */
-static long delta(struct timeval *tv1, struct timeval *tv2)
-{
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
-}
-
 static void sir_timeout(unsigned long data)
 {
 	/*
@@ -432,12 +418,14 @@ static void sir_timeout(unsigned long data)
 		/* clear unread bits in UART and restart */
 		outb(UART_FCR_CLEAR_RCVR, io + UART_FCR);
 		/* determine 'virtual' pulse end: */
-		pulse_end = delta(&last_tv, &last_intr_tv);
+		pulse_end = min_t(unsigned long,
+				  ktime_us_delta(last, last_intr_time),
+				  PULSE_MASK);
 		dev_dbg(driver.dev, "timeout add %d for %lu usec\n",
 				    last_value, pulse_end);
 		add_read_queue(last_value, pulse_end);
 		last_value = 0;
-		last_tv = last_intr_tv;
+		last = last_intr_time;
 	}
 	spin_unlock_irqrestore(&timer_lock, flags);
 }
@@ -445,9 +433,9 @@ static void sir_timeout(unsigned long data)
 static irqreturn_t sir_interrupt(int irq, void *dev_id)
 {
 	unsigned char data;
-	struct timeval curr_tv;
-	static unsigned long deltv;
-	unsigned long deltintrtv;
+	ktime_t curr_time;
+	static unsigned long delt;
+	unsigned long deltintr;
 	unsigned long flags;
 	int iir, lsr;
 
@@ -471,49 +459,46 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
 			do {
 				del_timer(&timerlist);
 				data = inb(io + UART_RX);
-				do_gettimeofday(&curr_tv);
-				deltv = delta(&last_tv, &curr_tv);
-				deltintrtv = delta(&last_intr_tv, &curr_tv);
+				curr_time = ktime_get();
+				delt = min_t(unsigned long,
+					     ktime_us_delta(last, curr_time),
+					     PULSE_MASK);
+				deltintr = min_t(unsigned long,
+						 ktime_us_delta(last_intr_time,
+								curr_time),
+						 PULSE_MASK);
 				dev_dbg(driver.dev, "t %lu, d %d\n",
-						    deltintrtv, (int)data);
+						    deltintr, (int)data);
 				/*
 				 * if nothing came in last X cycles,
 				 * it was gap
 				 */
-				if (deltintrtv > TIME_CONST * threshold) {
+				if (deltintr > TIME_CONST * threshold) {
 					if (last_value) {
 						dev_dbg(driver.dev, "GAP\n");
 						/* simulate signal change */
 						add_read_queue(last_value,
-							       deltv -
-							       deltintrtv);
+							       delt -
+							       deltintr);
 						last_value = 0;
-						last_tv.tv_sec =
-							last_intr_tv.tv_sec;
-						last_tv.tv_usec =
-							last_intr_tv.tv_usec;
-						deltv = deltintrtv;
+						last = last_intr_time;
+						delt = deltintr;
 					}
 				}
 				data = 1;
 				if (data ^ last_value) {
 					/*
-					 * deltintrtv > 2*TIME_CONST, remember?
+					 * deltintr > 2*TIME_CONST, remember?
 					 * the other case is timeout
 					 */
 					add_read_queue(last_value,
-						       deltv-TIME_CONST);
+						       delt-TIME_CONST);
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

