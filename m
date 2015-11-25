Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:54239 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbKYPMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 10:12:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>
Subject: [PATCH 1/3] staging: media: lirc: Replace timeval with ktime_t in lirc_serial.c
Date: Wed, 25 Nov 2015 16:11:55 +0100
Message-ID: <3966611.mJGTQOXNKU@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

'struct timeval tv' is used to get current time.
'static struct timeval lasttv' is used to get last interrupt time.

32-bit systems using 'struct timeval' will break in the year 2038,
so we have to replace that code with more appropriate types.
This patch changes the lirc_serial.c file of media: lirc to use
ktime_t.

ktime_get() is  better than using do_gettimeofday(),
because it uses the monotonic clock. ktime_sub is used
to subtract two ktime variables. The check to test time
going backwards is also removed. Intialization to static
variable is also removed. ktime_to_us() is used to convert
ktime_t to microsecond value. deltv is changed to delkt, a
ktime_t type varibale from long to assign the ktime_sub value
directly. ktime_compare is used to compare delkt with 15
seconds, which is changed to a nanosecond value by using
ktime_set().

Build tested it.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
These three patches were still in my backlog and part of linux-next
but never made it into mainline. Please apply to the v4l tree.

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 64a7b2fc5289..b798b311d32c 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -59,7 +59,7 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
-#include <linux/time.h>
+#include <linux/ktime.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
@@ -204,7 +204,7 @@ static struct lirc_serial hardware[] = {
 
 #define RBUF_LEN 256
 
-static struct timeval lasttv = {0, 0};
+static ktime_t lastkt;
 
 static struct lirc_buffer rbuf;
 
@@ -542,10 +542,10 @@ static void frbwrite(int l)
 
 static irqreturn_t lirc_irq_handler(int i, void *blah)
 {
-	struct timeval tv;
+	ktime_t kt;
 	int counter, dcd;
 	u8 status;
-	long deltv;
+	ktime_t delkt;
 	int data;
 	static int last_dcd = -1;
 
@@ -565,7 +565,7 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 		if ((status & hardware[type].signal_pin_change)
 		    && sense != -1) {
 			/* get current time */
-			do_gettimeofday(&tv);
+			kt = ktime_get();
 
 			/* New mode, written by Trent Piepho
 			   <xyzzy@u.washington.edu>. */
@@ -594,34 +594,20 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 			dcd = (status & hardware[type].signal_pin) ? 1 : 0;
 
 			if (dcd == last_dcd) {
-				pr_warn("ignoring spike: %d %d %lx %lx %lx %lx\n",
-					dcd, sense,
-					tv.tv_sec, lasttv.tv_sec,
-					(unsigned long)tv.tv_usec,
-					(unsigned long)lasttv.tv_usec);
+				pr_warn("ignoring spike: %d %d %llx %llx\n",
+					dcd, sense, ktime_to_us(kt),
+					ktime_to_us(lastkt));
 				continue;
 			}
 
-			deltv = tv.tv_sec-lasttv.tv_sec;
-			if (tv.tv_sec < lasttv.tv_sec ||
-			    (tv.tv_sec == lasttv.tv_sec &&
-			     tv.tv_usec < lasttv.tv_usec)) {
-				pr_warn("AIEEEE: your clock just jumped backwards\n");
-				pr_warn("%d %d %lx %lx %lx %lx\n",
-					dcd, sense,
-					tv.tv_sec, lasttv.tv_sec,
-					(unsigned long)tv.tv_usec,
-					(unsigned long)lasttv.tv_usec);
-				data = PULSE_MASK;
-			} else if (deltv > 15) {
+			delkt = ktime_sub(kt, lastkt);
+			if (ktime_compare(delkt, ktime_set(15, 0)) > 0) {
 				data = PULSE_MASK; /* really long time */
 				if (!(dcd^sense)) {
 					/* sanity check */
-					pr_warn("AIEEEE: %d %d %lx %lx %lx %lx\n",
-						dcd, sense,
-						tv.tv_sec, lasttv.tv_sec,
-						(unsigned long)tv.tv_usec,
-						(unsigned long)lasttv.tv_usec);
+					pr_warn("AIEEEE: %d %d %llx %llx\n",
+						dcd, sense, ktime_to_us(kt),
+						ktime_to_us(lastkt));
 					/*
 					 * detecting pulse while this
 					 * MUST be a space!
@@ -629,11 +615,9 @@ static irqreturn_t lirc_irq_handler(int i, void *blah)
 					sense = sense ? 0 : 1;
 				}
 			} else
-				data = (int) (deltv*1000000 +
-					       tv.tv_usec -
-					       lasttv.tv_usec);
+				data = (int) ktime_to_us(delkt);
 			frbwrite(dcd^sense ? data : (data|PULSE_BIT));
-			lasttv = tv;
+			lastkt = kt;
 			last_dcd = dcd;
 			wake_up_interruptible(&rbuf.wait_poll);
 		}
@@ -790,7 +774,7 @@ static int set_use_inc(void *data)
 	unsigned long flags;
 
 	/* initialize timestamp */
-	do_gettimeofday(&lasttv);
+	lastkt = ktime_get();
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 
@@ -979,7 +963,7 @@ static int lirc_serial_resume(struct platform_device *dev)
 
 	spin_lock_irqsave(&hardware[type].lock, flags);
 	/* Enable Interrupt */
-	do_gettimeofday(&lasttv);
+	lastkt = ktime_get();
 	soutp(UART_IER, sinp(UART_IER)|UART_IER_MSI);
 	off();
 

