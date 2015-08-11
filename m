Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34794 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbbHKPJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:09:53 -0400
Received: by iodb91 with SMTP id b91so145295615iod.1
        for <linux-media@vger.kernel.org>; Tue, 11 Aug 2015 08:09:52 -0700 (PDT)
From: Abhilash Jindal <klock.android@gmail.com>
To: linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net
Cc: Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] [media] zoran: Use monotonic time
Date: Tue, 11 Aug 2015 11:09:49 -0400
Message-Id: <1439305789-672-1-git-send-email-klock.android@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wall time obtained from do_gettimeofday is susceptible to sudden jumps due to
user setting the time or due to NTP.

Monotonic time is constantly increasing time better suited for comparing two
timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/media/pci/zoran/zoran_device.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index 40119b3..4d47dda 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/ktime.h>
 
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
@@ -181,20 +182,11 @@ dump_guests (struct zoran *zr)
 	}
 }
 
-static inline unsigned long
-get_time (void)
-{
-	struct timeval tv;
-
-	do_gettimeofday(&tv);
-	return (1000000 * tv.tv_sec + tv.tv_usec);
-}
-
 void
 detect_guest_activity (struct zoran *zr)
 {
 	int timeout, i, j, res, guest[8], guest0[8], change[8][3];
-	unsigned long t0, t1;
+	ktime_t t0, t1;
 
 	dump_guests(zr);
 	printk(KERN_INFO "%s: Detecting guests activity, please wait...\n",
@@ -205,15 +197,15 @@ detect_guest_activity (struct zoran *zr)
 
 	timeout = 0;
 	j = 0;
-	t0 = get_time();
+	t0 = ktime_get();
 	while (timeout < 10000) {
 		udelay(10);
 		timeout++;
 		for (i = 1; (i < 8) && (j < 8); i++) {
 			res = post_office_read(zr, i, 0);
 			if (res != guest[i]) {
-				t1 = get_time();
-				change[j][0] = (t1 - t0);
+				t1 = ktime_get();
+				change[j][0] = ktime_to_us(ktime_sub(t1, t0));
 				t0 = t1;
 				change[j][1] = i;
 				change[j][2] = res;
-- 
1.7.9.5

