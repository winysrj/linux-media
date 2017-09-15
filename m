Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37459 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdIOJxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 05:53:10 -0400
Received: by mail-wm0-f66.google.com with SMTP id f4so2299460wmh.4
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 02:53:09 -0700 (PDT)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-fence: fix dma_fence_get_rcu_safe v2
Date: Fri, 15 Sep 2017 11:53:07 +0200
Message-Id: <1505469187-3565-1-git-send-email-deathsimple@vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christian König <christian.koenig@amd.com>

When dma_fence_get_rcu() fails to acquire a reference it doesn't necessary
mean that there is no fence at all.

It usually mean that the fence was replaced by a new one and in this situation
we certainly want to have the new one as result and *NOT* NULL.

v2: Keep extra check after dma_fence_get_rcu().

Signed-off-by: Christian König <christian.koenig@amd.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 include/linux/dma-fence.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 0a186c4..f4f23cb 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -248,9 +248,12 @@ dma_fence_get_rcu_safe(struct dma_fence * __rcu *fencep)
 		struct dma_fence *fence;
 
 		fence = rcu_dereference(*fencep);
-		if (!fence || !dma_fence_get_rcu(fence))
+		if (!fence)
 			return NULL;
 
+		if (!dma_fence_get_rcu(fence))
+			continue;
+
 		/* The atomic_inc_not_zero() inside dma_fence_get_rcu()
 		 * provides a full memory barrier upon success (such as now).
 		 * This is paired with the write barrier from assigning
-- 
2.7.4
