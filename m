Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:9423 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbZGCUq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 16:46:58 -0400
Date: Fri, 3 Jul 2009 22:46:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>
Subject: [PATCH 1/2] Compatibility layer for hrtimer API
Message-ID: <20090703224652.339a63e7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kernels 2.6.22 to 2.6.24 (inclusive) need some compatibility quirks
for the hrtimer API. For older kernels, some required functions were
not exported so there's nothing we can do. This means that drivers
using the hrtimer infrastructure will no longer work for kernels older
than 2.6.22.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 v4l/compat.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -480,4 +480,22 @@ static inline unsigned long v4l_compat_f
 }
 #endif
 
+/*
+ * Compatibility code for hrtimer API
+ * This will make hrtimer usable for kernels 2.6.22 and later.
+ * For earlier kernels, not all required functions are exported
+ * so there's nothing we can do.
+ */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25) && \
+	LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+#include <linux/hrtimer.h>
+/* Forward a hrtimer so it expires after the hrtimer's current now */
+static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
+						ktime_t interval)
+{
+	return hrtimer_forward(timer, timer->base->get_time(), interval);
+}
+#endif
+
 #endif /*  _COMPAT_H */


-- 
Jean Delvare
