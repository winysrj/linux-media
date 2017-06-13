Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:25806 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753091AbdFMNrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 09:47:16 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: broonie@kernel.org, hverkuil@xs4all.nl, mattw@codeaurora.org,
        mitchelh@codeaurora.org, akpm@linux-foundation.org,
        yamada.masahiro@socionext.com
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, chris.paterson2@renesas.com,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v2 2/2] regmap: Avoid namespace collision within macro & tidyup
Date: Tue, 13 Jun 2017 14:33:48 +0100
Message-Id: <20170613133348.48044-3-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Renamed variable "timeout" to "__timeout" & "pollret" to "__ret" to
avoid namespace collision. Tidy up macro arguments with paranthesis.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 include/linux/regmap.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 86eeacc1425a..ebc7282abc80 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -120,23 +120,24 @@ struct reg_sequence {
  */
 #define regmap_read_poll_timeout(map, addr, val, cond, sleep_us, timeout_us) \
 ({ \
-	ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
-	int pollret; \
+	ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \
+	int __ret; \
 	might_sleep_if(sleep_us); \
 	for (;;) { \
-		pollret = regmap_read((map), (addr), &(val)); \
-		if (pollret) \
+		__ret = regmap_read((map), (addr), &(val)); \
+		if (__ret) \
 			break; \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
-			pollret = regmap_read((map), (addr), &(val)); \
+		if ((timeout_us) && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			__ret = regmap_read((map), (addr), &(val)); \
 			break; \
 		} \
 		if (sleep_us) \
-			usleep_range((sleep_us >> 2) + 1, sleep_us); \
+			usleep_range(((sleep_us) >> 2) + 1, sleep_us); \
 	} \
-	pollret ?: ((cond) ? 0 : -ETIMEDOUT); \
+	__ret ?: ((cond) ? 0 : -ETIMEDOUT); \
 })
 
 #ifdef CONFIG_REGMAP
-- 
2.12.2
