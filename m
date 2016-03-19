Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54902 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbcCSTuq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 15:50:46 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sumit.semwal@linaro.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] fence: add missing descriptions for fence
Date: Sat, 19 Mar 2016 19:50:37 +0000
Message-Id: <1458417037-26691-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit b55b54b5db33 ("staging/android: remove struct sync_pt")
added the members child_list and active_list to the fence struct, but
didn't add descriptions for these. Adding the descriptions.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---
Hi,

Noticed this missing descriptions when running make htmldocs.

Got the following warnings:
.//include/linux/fence.h:84: warning: No description found for parameter 'child_list'
.//include/linux/fence.h:84: warning: No description found for parameter 'active_list'

Thanks :)
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
2.5.1

