Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1AQW7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 17:59:30 -0500
Received: by wyb28 with SMTP id 28so5520308wyb.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 14:59:28 -0800 (PST)
Subject: [PATCH][_COMPAT_H] git://linuxtv.org/media_build.git Legacy issues
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 22:59:21 +0000
Message-ID: <1295305161.2162.21.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Clean up legacy issues for error free build on Kernel 2.6.37.

Today while testing on Kernel 2.6.35 latest tarball throws error with 
alloc_ordered_workqueue undefined on Kernels less than 2.6.37. defined back to 
create_singlethread_workqueue.

Please test on other kernel versions.

Tested-on 2.6.35/37 by: Malcolm Priestley <tvboxspy@gmail.com>


diff --git a/v4l/compat.h b/v4l/compat.h
index 9e622ce..df98698 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -749,6 +749,8 @@ static inline void *vzalloc(unsigned long size)
 
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 37)
+
 #if NEED_FLUSH_WORK_SYNC
 #define flush_work_sync(dev)
 #endif
@@ -760,6 +762,14 @@ static inline void *vzalloc(unsigned long size)
 }
 #endif
 
+#define alloc_ordered_workqueue(a,b) create_singlethread_workqueue(a)
+
+#else
+#ifdef CONFIG_PM
+#include <linux/pm_runtime.h>
+#endif
+#endif
+
 #ifndef KEY_10CHANNELSUP
 #define KEY_10CHANNELSUP        0x1b8   /* 10 channels up (10+) */
 #define KEY_10CHANNELSDOWN      0x1b9   /* 10 channels down (10-) */

