Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:49642 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750911AbdIKXO6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 19:14:58 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2] build: Added missing functions nsecs_to_jiffies(64)
Date: Tue, 12 Sep 2017 01:14:57 +0200
Message-Id: <1505171697-29475-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Several modules expect the functions nsecs_to_jiffies64 and
nsecs_to_jiffies to be available when they get loaded. For Kernels prior
to 3.16, this symbol is not exported in time.c .
Copied the functions to compat.h, so that they get already resolved during
compilation. Define also a macro with a name conversion, because the
mentioned functions are defined as extern in include/linux/jiffies.h,
which gives an error when they are re-defined as static.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index bfc9c51..58dcb88 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2119,4 +2119,44 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
 	.subvendor = (subvend), .subdevice = (subdev)
 #endif
 
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 16, 0)
+
+#include <linux/jiffies.h>
+
+/*
+ * copied from kernel/time/time.c
+ */
+static inline u64 nsecs_to_jiffies64_static(u64 n)
+{
+#if (NSEC_PER_SEC % HZ) == 0
+    /* Common case, HZ = 100, 128, 200, 250, 256, 500, 512, 1000 etc. */
+    return div_u64(n, NSEC_PER_SEC / HZ);
+#elif (HZ % 512) == 0
+    /* overflow after 292 years if HZ = 1024 */
+    return div_u64(n * HZ / 512, NSEC_PER_SEC / 512);
+#else
+    /*
+     * Generic case - optimized for cases where HZ is a multiple of 3.
+     * overflow after 64.99 years, exact for HZ = 60, 72, 90, 120 etc.
+     */
+    return div_u64(n * 9, (9ull * NSEC_PER_SEC + HZ / 2) / HZ);
+#endif
+}
+
+static inline unsigned long nsecs_to_jiffies_static(u64 n)
+{
+    return (unsigned long)nsecs_to_jiffies64_static(n);
+}
+
+/*
+ * linux/jiffies.h defines nsecs_to_jiffies64 and nsecs_to_jiffies
+ * as externals. To get rid of the compiler error, we redefine the
+ * functions to the static variant just defined above.
+ */
+#define nsecs_to_jiffies64(_n) nsecs_to_jiffies64_static(_n)
+#define nsecs_to_jiffies(_n) nsecs_to_jiffies_static(_n)
+
+#endif
+
 #endif /*  _COMPAT_H */
-- 
2.7.4
