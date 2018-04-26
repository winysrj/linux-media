Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34902 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756864AbeDZR1m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 13:27:42 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/7] Header location fix for 3.5.0 to 3.11.x
Date: Thu, 26 Apr 2018 12:19:20 -0500
Message-Id: <1524763162-4865-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Header does not exist before 3.5.0 and is merged into linux/i2c.h
in 3.12.0.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 v4l/compat.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index d52c602..87ce401 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2414,4 +2414,11 @@ static inline void *memdup_user_nul(const void __user *src, size_t len)
 #include <linux/frame.h>
 #endif
 
+/* header location for of_find_i2c_[device,adapter]_by_node */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 12, 0)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 5, 0)
+#include <linux/of_i2c.h>
+#endif
+#endif
+
 #endif /*  _COMPAT_H */
-- 
2.7.4
