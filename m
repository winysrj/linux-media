Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:41671 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932489AbeALJrd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:47:33 -0500
Received: by mail-wm0-f66.google.com with SMTP id g75so10894249wme.0
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 01:47:33 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org, gustavo@padovan.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 2/3] drm/amdgpu: add amdgpu_pasid_free_delayed v2
Date: Fri, 12 Jan 2018 10:47:28 +0100
Message-Id: <20180112094729.17491-2-christian.koenig@amd.com>
In-Reply-To: <20180112094729.17491-1-christian.koenig@amd.com>
References: <20180112094729.17491-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free up a pasid after all fences signaled.

v2: also handle the case when we can't allocate a fence array.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 82 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h |  2 +
 2 files changed, 84 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index 5248a3232aff..842caa5ed73b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -40,6 +40,12 @@
  */
 static DEFINE_IDA(amdgpu_pasid_ida);
 
+/* Helper to free pasid from a fence callback */
+struct amdgpu_pasid_cb {
+	struct dma_fence_cb cb;
+	unsigned int pasid;
+};
+
 /**
  * amdgpu_pasid_alloc - Allocate a PASID
  * @bits: Maximum width of the PASID in bits, must be at least 1
@@ -75,6 +81,82 @@ void amdgpu_pasid_free(unsigned int pasid)
 	ida_simple_remove(&amdgpu_pasid_ida, pasid);
 }
 
+static void amdgpu_pasid_free_cb(struct dma_fence *fence,
+				 struct dma_fence_cb *_cb)
+{
+	struct amdgpu_pasid_cb *cb =
+		container_of(_cb, struct amdgpu_pasid_cb, cb);
+
+	amdgpu_pasid_free(cb->pasid);
+	dma_fence_put(fence);
+	kfree(cb);
+}
+
+/**
+ * amdgpu_pasid_free_delayed - free pasid when fences signal
+ *
+ * @resv: reservation object with the fences to wait for
+ * @pasid: pasid to free
+ *
+ * Free the pasid only after all the fences in resv are signaled.
+ */
+void amdgpu_pasid_free_delayed(struct reservation_object *resv,
+			       unsigned int pasid)
+{
+	struct dma_fence *fence, **fences;
+	struct amdgpu_pasid_cb *cb;
+	unsigned count;
+	int r;
+
+	r = reservation_object_get_fences_rcu(resv, NULL, &count, &fences);
+	if (r)
+		goto fallback;
+
+	if (count == 0) {
+		amdgpu_pasid_free(pasid);
+		return;
+	}
+
+	if (count == 1) {
+		fence = fences[0];
+		kfree(fences);
+	} else {
+		uint64_t context = dma_fence_context_alloc(1);
+		struct dma_fence_array *array;
+
+		array = dma_fence_array_create(count, fences, context,
+					       1, false);
+		if (!array) {
+			kfree(fences);
+			goto fallback;
+		}
+		fence = &array->base;
+	}
+
+	cb = kmalloc(sizeof(*cb), GFP_KERNEL);
+	if (!cb) {
+		/* Last resort when we are OOM */
+		dma_fence_wait(fence, false);
+		dma_fence_put(fence);
+		amdgpu_pasid_free(pasid);
+	} else {
+		cb->pasid = pasid;
+		if (dma_fence_add_callback(fence, &cb->cb,
+					   amdgpu_pasid_free_cb))
+			amdgpu_pasid_free_cb(fence, &cb->cb);
+	}
+
+	return;
+
+fallback:
+	/* Not enough memory for the delayed delete, as last resort
+	 * block for all the fences to complete.
+	 */
+	reservation_object_wait_timeout_rcu(resv, true, false,
+					    MAX_SCHEDULE_TIMEOUT);
+	amdgpu_pasid_free(pasid);
+}
+
 /*
  * VMID manager
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
index ad931fa570b3..38f37c16fc5e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.h
@@ -69,6 +69,8 @@ struct amdgpu_vmid_mgr {
 
 int amdgpu_pasid_alloc(unsigned int bits);
 void amdgpu_pasid_free(unsigned int pasid);
+void amdgpu_pasid_free_delayed(struct reservation_object *resv,
+			       unsigned int pasid);
 
 bool amdgpu_vmid_had_gpu_reset(struct amdgpu_device *adev,
 			       struct amdgpu_vmid *id);
-- 
2.14.1
