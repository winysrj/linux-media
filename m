Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56336 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBUED (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:04:03 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 2/4] dma-buf/fence: Sparse wants __rcu on the object itself
Date: Thu,  2 Nov 2017 22:03:34 +0200
Message-Id: <20171102200336.23347-3-ville.syrjala@linux.intel.com>
In-Reply-To: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chris Wilson <chris@chris-wilson.co.uk>

In order to silent sparse in dma_fence_get_rcu_safe(), we need to mark
the incoming fence object as being RCU protected and not the pointer to
the object.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 include/linux/dma-fence.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index efdabbb64e3c..4c008170fe65 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -242,7 +242,7 @@ static inline struct dma_fence *dma_fence_get_rcu(struct dma_fence *fence)
  * The caller is required to hold the RCU read lock.
  */
 static inline struct dma_fence *
-dma_fence_get_rcu_safe(struct dma_fence * __rcu *fencep)
+dma_fence_get_rcu_safe(struct dma_fence __rcu **fencep)
 {
 	do {
 		struct dma_fence *fence;
-- 
2.13.6
