Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55799 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbeECO0O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 10:26:14 -0400
Received: by mail-wm0-f66.google.com with SMTP id a8so28717292wmg.5
        for <linux-media@vger.kernel.org>; Thu, 03 May 2018 07:26:13 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 03/15] dma-fence: Allow wait_any_timeout for all fences
Date: Thu,  3 May 2018 16:25:51 +0200
Message-Id: <20180503142603.28513-4-daniel.vetter@ffwll.ch>
In-Reply-To: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
References: <20180503142603.28513-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When this was introduced in

commit a519435a96597d8cd96123246fea4ae5a6c90b02
Author: Christian König <christian.koenig@amd.com>
Date:   Tue Oct 20 16:34:16 2015 +0200

    dma-buf/fence: add fence_wait_any_timeout function v2

there was a restriction added that this only works if the dma-fence
uses the dma_fence_default_wait hook. Which works for amdgpu, which is
the only caller. Well, until you share some buffers with e.g. i915,
then you get an -EINVAL.

But there's really no reason for this, because all drivers must
support callbacks. The special ->wait hook is only as an optimization;
if the driver needs to create a worker thread for an active callback,
then it can avoid to do that if it knows that there's a process
context available already. So ->wait is just an optimization, just
using the logic in dma_fence_default_wait() should work for all
drivers.

Let's remove this restriction.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
---
 drivers/dma-buf/dma-fence.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 7b5b40d6b70e..59049375bd19 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -503,11 +503,6 @@ dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
 	for (i = 0; i < count; ++i) {
 		struct dma_fence *fence = fences[i];
 
-		if (fence->ops->wait != dma_fence_default_wait) {
-			ret = -EINVAL;
-			goto fence_rm_cb;
-		}
-
 		cb[i].task = current;
 		if (dma_fence_add_callback(fence, &cb[i].base,
 					   dma_fence_default_wait_cb)) {
-- 
2.17.0
