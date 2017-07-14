Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57062 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdGNJeM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:34:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 13/14] iopoll: avoid -Wint-in-bool-context warning
Date: Fri, 14 Jul 2017 11:31:06 +0200
Message-Id: <20170714093129.1366900-4-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we pass the result of a multiplication as the timeout, we
can get a warning:

drivers/mmc/host/bcm2835.c:596:149: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/mfd/arizona-core.c:247:195: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

This is easy to avoid by comparing the timeout to zero instead,
making it a boolean expression.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/iopoll.h | 6 ++++--
 include/linux/regmap.h | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index d29e1e21bf3f..7a17ba02253b 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -48,7 +48,8 @@
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if ((timeout_us) > 0 && \
+		    ktime_compare(ktime_get(), timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
@@ -82,7 +83,8 @@
 		(val) = op(addr); \
 		if (cond) \
 			break; \
-		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
+		if ((timeout_us) > 0 && \
+		    ktime_compare(ktime_get(), timeout) > 0) { \
 			(val) = op(addr); \
 			break; \
 		} \
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 1474ab0a3922..0889dbf37161 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -129,7 +129,7 @@ struct reg_sequence {
 			break; \
 		if (cond) \
 			break; \
-		if ((timeout_us) && \
+		if ((timeout_us) > 0 && \
 		    ktime_compare(ktime_get(), __timeout) > 0) { \
 			__ret = regmap_read((map), (addr), &(val)); \
 			break; \
-- 
2.9.0
