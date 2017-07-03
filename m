Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:54649 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753007AbdGCLSL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 07:18:11 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: broonie@kernel.org
Cc: hverkuil@xs4all.nl, akpm@linux-foundation.org,
        yamada.masahiro@socionext.com, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        chris.paterson2@renesas.com,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v3 1/2] iopoll: Avoid namespace collision within macros & tidy up
Date: Mon,  3 Jul 2017 12:04:20 +0100
Message-Id: <20170703110421.3082-2-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170703110421.3082-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170703110421.3082-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renamed variable "timeout" to "__timeout" to avoid namespace collision.
Tidy up macro arguments with parentheses.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 include/linux/iopoll.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index d29e1e21bf3f..e000172bee54 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -42,18 +42,19 @@
  */
 #define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)	\
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \
 	might_sleep_if(sleep_us); \
 	for (;;) { \
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if ((timeout_us) && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
 		if (sleep_us) \
-			usleep_range((sleep_us >> 2) + 1, sleep_us); \
+			usleep_range(((sleep_us) >> 2) + 1, sleep_us); \
 	} \
 	(cond) ? 0 : -ETIMEDOUT; \
 })
@@ -77,12 +78,13 @@
  */
 #define readx_poll_timeout_atomic(op, addr, val, cond, delay_us, timeout_us) \
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \
 	for (;;) { \
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if ((timeout_us) && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
-- 
2.12.2
