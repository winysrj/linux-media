Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36134 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932704AbcIRMtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 08:49:43 -0400
Received: by mail-pa0-f44.google.com with SMTP id id6so39793752pad.3
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2016 05:49:43 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: sumit.semwal@linaro.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Subject: [PATCH] dma-buf/sw_sync: mark sync_timeline_create() static
Date: Sun, 18 Sep 2016 20:49:21 +0800
Message-Id: <1474202961-10099-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/dma-buf/sw_sync.c:87:23: warning: no previous prototype for 'sync_timeline_create' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
So this patch marks it 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/dma-buf/sw_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 62e8e6d..6f16c85 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -84,7 +84,7 @@ static inline struct sync_pt *fence_to_sync_pt(struct fence *fence)
  * Creates a new sync_timeline. Returns the sync_timeline object or NULL in
  * case of error.
  */
-struct sync_timeline *sync_timeline_create(const char *name)
+static struct sync_timeline *sync_timeline_create(const char *name)
 {
 	struct sync_timeline *obj;
 
-- 
2.7.4

