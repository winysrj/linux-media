Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41437 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbcDKLtP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 07:49:15 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, sumit.semwal@linaro.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [RESEND] fence: add missing descriptions for fence
Date: Mon, 11 Apr 2016 12:48:55 +0100
Message-Id: <1460375335-20188-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The members child_list and active_list were added to the fence struct
without descriptions for the Documentation. Adding these.

Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
Hi,

Just resending this patch since it hasn't had any reviews in since
March 21st.

Thanks,
Luis

 include/linux/fence.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index 2b17698..2056e9f 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -49,6 +49,8 @@ struct fence_cb;
  * @timestamp: Timestamp when the fence was signaled.
  * @status: Optional, only valid if < 0, must be set before calling
  * fence_signal, indicates that the fence has completed with an error.
+ * @child_list: list of children fences
+ * @active_list: list of active fences
  *
  * the flags member must be manipulated and read using the appropriate
  * atomic ops (bit_*), so taking the spinlock will not be needed most
-- 
2.6.4

