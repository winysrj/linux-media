Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53420 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751346AbeEDSCC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 14:02:02 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel@collabora.com, Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] dma-buf: Remove unneeded stubs around sync_debug interfaces
Date: Fri,  4 May 2018 15:00:37 -0300
Message-Id: <20180504180037.10661-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sync_debug.h header is internal, and only used by
sw_sync.c. Therefore, SW_SYNC is always defined and there
is no need for the stubs. Remove them and make the code
simpler.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/dma-buf/sync_debug.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/dma-buf/sync_debug.h b/drivers/dma-buf/sync_debug.h
index d615a89f774c..05e33f937ad0 100644
--- a/drivers/dma-buf/sync_debug.h
+++ b/drivers/dma-buf/sync_debug.h
@@ -62,8 +62,6 @@ struct sync_pt {
 	struct rb_node node;
 };
 
-#ifdef CONFIG_SW_SYNC
-
 extern const struct file_operations sw_sync_debugfs_fops;
 
 void sync_timeline_debug_add(struct sync_timeline *obj);
@@ -72,12 +70,4 @@ void sync_file_debug_add(struct sync_file *fence);
 void sync_file_debug_remove(struct sync_file *fence);
 void sync_dump(void);
 
-#else
-# define sync_timeline_debug_add(obj)
-# define sync_timeline_debug_remove(obj)
-# define sync_file_debug_add(fence)
-# define sync_file_debug_remove(fence)
-# define sync_dump()
-#endif
-
 #endif /* _LINUX_SYNC_H */
-- 
2.16.3
