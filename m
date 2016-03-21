Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55128 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbcCUN5A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:57:00 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2] fence: add missing descriptions for fence
Date: Mon, 21 Mar 2016 13:56:37 +0000
Message-Id: <1458568597-10678-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The members child_list and active_list were added to the fence struct
without descriptions for the Documentation. Adding these.

Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
Hi,

This second version fixes the commit message as suggested by Javier Martinez.
https://lkml.org/lkml/2016/3/19/135

Thanks,
Luis

 include/linux/fence.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index bb52201..ba5b678 100644
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

