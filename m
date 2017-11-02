Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:62185 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932497AbdKBUDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 16:03:45 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 1/4] drm/syncobj: Mark up the fence as an RCU protected pointer
Date: Thu,  2 Nov 2017 22:03:33 +0200
Message-Id: <20171102200336.23347-2-ville.syrjala@linux.intel.com>
In-Reply-To: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
References: <20171102200336.23347-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chris Wilson <chris@chris-wilson.co.uk>

We take advantage of that syncobj->fence is an RCU-protected pointer, and
so sparse complains that it is lacking annotation.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-media@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 include/drm/drm_syncobj.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_syncobj.h b/include/drm/drm_syncobj.h
index 43e2f382d2f0..9e8ba90c6784 100644
--- a/include/drm/drm_syncobj.h
+++ b/include/drm/drm_syncobj.h
@@ -49,7 +49,7 @@ struct drm_syncobj {
 	 * This field should not be used directly.  Use drm_syncobj_fence_get
 	 * and drm_syncobj_replace_fence instead.
 	 */
-	struct dma_fence *fence;
+	struct dma_fence __rcu *fence;
 	/**
 	 * @cb_list:
 	 * List of callbacks to call when the fence gets replaced
-- 
2.13.6
