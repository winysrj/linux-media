Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34000 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbbLRNFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 08:05:43 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 3/5] staging: media: lirc: space around operator
Date: Fri, 18 Dec 2015 18:35:27 +0530
Message-Id: <1450443929-15305-3-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

checkpatch complains about missing space around operators.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/media/lirc/lirc_parallel.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index f65ab93..e09894d 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -161,17 +161,17 @@ static unsigned int init_lirc_timer(void)
 			     || (now.tv_sec == tv.tv_sec
 				 && now.tv_usec < tv.tv_usec)));
 
-	timeelapsed = (now.tv_sec + 1 - tv.tv_sec)*1000000
+	timeelapsed = (now.tv_sec + 1 - tv.tv_sec) * 1000000
 		     + (now.tv_usec - tv.tv_usec);
 	if (count >= 1000 && timeelapsed > 0) {
 		if (default_timer == 0) {
 			/* autodetect timer */
-			newtimer = (1000000*count)/timeelapsed;
+			newtimer = (1000000 * count) / timeelapsed;
 			pr_info("%u Hz timer detected\n", newtimer);
 			return newtimer;
 		}
-		newtimer = (1000000*count)/timeelapsed;
-		if (abs(newtimer - default_timer) > default_timer/10) {
+		newtimer = (1000000 * count) / timeelapsed;
+		if (abs(newtimer - default_timer) > default_timer / 10) {
 			/* bad timer */
 			pr_notice("bad timer: %u Hz\n", newtimer);
 			pr_notice("using default timer: %u Hz\n",
@@ -196,7 +196,7 @@ static int lirc_claim(void)
 			return 0;
 		}
 	}
-	out(LIRC_LP_CONTROL, LP_PSELECP|LP_PINITP);
+	out(LIRC_LP_CONTROL, LP_PSELECP | LP_PINITP);
 	is_claimed = 1;
 	return 1;
 }
@@ -251,7 +251,7 @@ static void lirc_lirc_irq_handler(void *blah)
 			/* really long time */
 			data = PULSE_MASK;
 		else
-			data = (int)(signal*1000000 +
+			data = (int)(signal * 1000000 +
 					 tv.tv_usec - lasttv.tv_usec +
 					 LIRC_SFH506_DELAY);
 
@@ -269,7 +269,7 @@ static void lirc_lirc_irq_handler(void *blah)
 		init = 1;
 	}
 
-	timeout = timer/10;	/* timeout after 1/10 sec. */
+	timeout = timer / 10;	/* timeout after 1/10 sec. */
 	signal = 1;
 	level = lirc_get_timer();
 	do {
@@ -291,7 +291,7 @@ static void lirc_lirc_irq_handler(void *blah)
 		/* adjust value to usecs */
 		__u64 helper;
 
-		helper = ((__u64)signal)*1000000;
+		helper = ((__u64)signal) * 1000000;
 		do_div(helper, timer);
 		signal = (long)helper;
 
@@ -299,7 +299,7 @@ static void lirc_lirc_irq_handler(void *blah)
 			data = signal - LIRC_SFH506_DELAY;
 		else
 			data = 1;
-		rbuf_write(PULSE_BIT|data); /* pulse */
+		rbuf_write(PULSE_BIT | data); /* pulse */
 	}
 	do_gettimeofday(&lasttv);
 #else
@@ -336,7 +336,7 @@ static ssize_t lirc_read(struct file *filep, char __user *buf, size_t n,
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (count < n) {
 		if (rptr != wptr) {
-			if (copy_to_user(buf+count, &rbuf[rptr],
+			if (copy_to_user(buf + count, &rbuf[rptr],
 					 sizeof(int))) {
 				result = -EFAULT;
 				break;
@@ -398,7 +398,7 @@ static ssize_t lirc_write(struct file *filep, const char __user *buf, size_t n,
 	for (i = 0; i < count; i++) {
 		__u64 helper;
 
-		helper = ((__u64)wbuf[i])*timer;
+		helper = ((__u64)wbuf[i]) * timer;
 		do_div(helper, 1000000);
 		wbuf[i] = (int)helper;
 	}
@@ -669,7 +669,7 @@ static int __init lirc_parallel_init(void)
 	if (parport_claim(ppdevice) != 0)
 		goto skip_init;
 	is_claimed = 1;
-	out(LIRC_LP_CONTROL, LP_PSELECP|LP_PINITP);
+	out(LIRC_LP_CONTROL, LP_PSELECP | LP_PINITP);
 
 #ifdef LIRC_TIMER
 	if (debug)
-- 
1.9.1

