Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:26000 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZGEI6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 04:58:33 -0400
Date: Sun, 5 Jul 2009 10:58:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 1/2 v2] Compatibility layer for hrtimer API
Message-ID: <20090705105825.0e05160c@hyperion.delvare>
In-Reply-To: <20090703224652.339a63e7@hyperion.delvare>
References: <20090703224652.339a63e7@hyperion.delvare>
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
Updated according to Trent's comment: the compatibility code is only
included if <linux/htrimer.h> was already included by the driver.

 v4l/compat.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- v4l-dvb.orig/v4l/compat.h	2009-07-05 10:32:12.000000000 +0200
+++ v4l-dvb/v4l/compat.h	2009-07-05 10:33:37.000000000 +0200
@@ -480,4 +480,23 @@ static inline unsigned long v4l_compat_f
 }
 #endif
 
+/*
+ * Compatibility code for hrtimer API
+ * This will make hrtimer usable for kernels 2.6.22 and later.
+ * For earlier kernels, not all required functions are exported
+ * so there's nothing we can do.
+ */
+
+#ifdef _LINUX_HRTIMER_H
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25) && \
+	LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+/* Forward a hrtimer so it expires after the hrtimer's current now */
+static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
+						ktime_t interval)
+{
+	return hrtimer_forward(timer, timer->base->get_time(), interval);
+}
+#endif
+#endif /* _LINUX_HRTIMER_H */
+
 #endif /*  _COMPAT_H */


-- 
Jean Delvare
