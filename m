Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55307 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeD0GRg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 02:17:36 -0400
Received: by mail-wm0-f65.google.com with SMTP id a8so693606wmg.5
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 23:17:35 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 05/17] dma-fence: Make ->wait callback optional
Date: Fri, 27 Apr 2018 08:17:12 +0200
Message-Id: <20180427061724.28497-6-daniel.vetter@ffwll.ch>
In-Reply-To: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Almost everyone uses dma_fence_default_wait.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-fence-array.c |  1 -
 drivers/dma-buf/dma-fence.c       |  5 ++++-
 drivers/dma-buf/sw_sync.c         |  1 -
 include/linux/dma-fence.h         | 13 ++++++++-----
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma-buf/dma-fence-array.c b/drivers/dma-buf/dma-fence-array.c
index dd1edfb27b61..a8c254497251 100644
--- a/drivers/dma-buf/dma-fence-array.c
+++ b/drivers/dma-buf/dma-fence-array.c
@@ -104,7 +104,6 @@ const struct dma_fence_ops dma_fence_array_ops = {
 	.get_timeline_name = dma_fence_array_get_timeline_name,
 	.enable_signaling = dma_fence_array_enable_signaling,
 	.signaled = dma_fence_array_signaled,
-	.wait = dma_fence_default_wait,
 	.release = dma_fence_array_release,
 };
 EXPORT_SYMBOL(dma_fence_array_ops);
diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 59049375bd19..30fcbe415ff4 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -158,7 +158,10 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 		return -EINVAL;
 
 	trace_dma_fence_wait_start(fence);
-	ret = fence->ops->wait(fence, intr, timeout);
+	if (fence->ops->wait)
+		ret = fence->ops->wait(fence, intr, timeout);
+	else
+		ret = dma_fence_default_wait(fence, intr, timeout);
 	trace_dma_fence_wait_end(fence);
 	return ret;
 }
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 3d78ca89a605..53c1d6d36a64 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -188,7 +188,6 @@ static const struct dma_fence_ops timeline_fence_ops = {
 	.get_timeline_name = timeline_fence_get_timeline_name,
 	.enable_signaling = timeline_fence_enable_signaling,
 	.signaled = timeline_fence_signaled,
-	.wait = dma_fence_default_wait,
 	.release = timeline_fence_release,
 	.fence_value_str = timeline_fence_value_str,
 	.timeline_value_str = timeline_fence_timeline_value_str,
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index c730f569621a..d05496ff0d10 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -191,11 +191,14 @@ struct dma_fence_ops {
 	/**
 	 * @wait:
 	 *
-	 * Custom wait implementation, or dma_fence_default_wait.
+	 * Custom wait implementation, defaults to dma_fence_default_wait() if
+	 * not set.
 	 *
-	 * Must not be NULL, set to dma_fence_default_wait for default implementation.
-	 * the dma_fence_default_wait implementation should work for any fence, as long
-	 * as enable_signaling works correctly.
+	 * The dma_fence_default_wait implementation should work for any fence, as long
+	 * as @enable_signaling works correctly. This hook allows drivers to
+	 * have an optimized version for the case where a process context is
+	 * already available, e.g. if @enable_signaling for the general case
+	 * needs to set up a worker thread.
 	 *
 	 * Must return -ERESTARTSYS if the wait is intr = true and the wait was
 	 * interrupted, and remaining jiffies if fence has signaled, or 0 if wait
@@ -203,7 +206,7 @@ struct dma_fence_ops {
 	 * which should be treated as if the fence is signaled. For example a hardware
 	 * lockup could be reported like that.
 	 *
-	 * This callback is mandatory.
+	 * This callback is optional.
 	 */
 	signed long (*wait)(struct dma_fence *fence,
 			    bool intr, signed long timeout);
-- 
2.17.0
