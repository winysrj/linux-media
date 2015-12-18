Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35279 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbbLRNFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 08:05:40 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 2/5] staging: media: lirc: no space after cast
Date: Fri, 18 Dec 2015 18:35:26 +0530
Message-Id: <1450443929-15305-2-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

checkpatch complains about space after type cast.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/media/lirc/lirc_parallel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index 9df8d14..f65ab93 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -251,7 +251,7 @@ static void lirc_lirc_irq_handler(void *blah)
 			/* really long time */
 			data = PULSE_MASK;
 		else
-			data = (int) (signal*1000000 +
+			data = (int)(signal*1000000 +
 					 tv.tv_usec - lasttv.tv_usec +
 					 LIRC_SFH506_DELAY);
 
@@ -291,9 +291,9 @@ static void lirc_lirc_irq_handler(void *blah)
 		/* adjust value to usecs */
 		__u64 helper;
 
-		helper = ((__u64) signal)*1000000;
+		helper = ((__u64)signal)*1000000;
 		do_div(helper, timer);
-		signal = (long) helper;
+		signal = (long)helper;
 
 		if (signal > LIRC_SFH506_DELAY)
 			data = signal - LIRC_SFH506_DELAY;
@@ -398,9 +398,9 @@ static ssize_t lirc_write(struct file *filep, const char __user *buf, size_t n,
 	for (i = 0; i < count; i++) {
 		__u64 helper;
 
-		helper = ((__u64) wbuf[i])*timer;
+		helper = ((__u64)wbuf[i])*timer;
 		do_div(helper, 1000000);
-		wbuf[i] = (int) helper;
+		wbuf[i] = (int)helper;
 	}
 
 	local_irq_save(flags);
-- 
1.9.1

