Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41903 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932562AbeALJre (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:47:34 -0500
Received: by mail-wr0-f194.google.com with SMTP id o7so4768947wro.8
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 01:47:33 -0800 (PST)
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: daniel@ffwll.ch, sumit.semwal@linaro.org, gustavo@padovan.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 3/3] drm/amdgpu: always allocate a PASIDs for each VM v2
Date: Fri, 12 Jan 2018 10:47:29 +0100
Message-Id: <20180112094729.17491-3-christian.koenig@amd.com>
In-Reply-To: <20180112094729.17491-1-christian.koenig@amd.com>
References: <20180112094729.17491-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Start to always allocate a pasid for each VM.

v2: use dev_warn when we run out of PASIDs

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 43 ++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 5773a581761b..a108b30d8186 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -805,7 +805,7 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 {
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_fpriv *fpriv;
-	int r;
+	int r, pasid;
 
 	file_priv->driver_priv = NULL;
 
@@ -819,28 +819,25 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		goto out_suspend;
 	}
 
-	r = amdgpu_vm_init(adev, &fpriv->vm,
-			   AMDGPU_VM_CONTEXT_GFX, 0);
-	if (r) {
-		kfree(fpriv);
-		goto out_suspend;
+	pasid = amdgpu_pasid_alloc(16);
+	if (pasid < 0) {
+		dev_warn(adev->dev, "No more PASIDs available!");
+		pasid = 0;
 	}
+	r = amdgpu_vm_init(adev, &fpriv->vm, AMDGPU_VM_CONTEXT_GFX, pasid);
+	if (r)
+		goto error_pasid;
 
 	fpriv->prt_va = amdgpu_vm_bo_add(adev, &fpriv->vm, NULL);
 	if (!fpriv->prt_va) {
 		r = -ENOMEM;
-		amdgpu_vm_fini(adev, &fpriv->vm);
-		kfree(fpriv);
-		goto out_suspend;
+		goto error_vm;
 	}
 
 	if (amdgpu_sriov_vf(adev)) {
 		r = amdgpu_map_static_csa(adev, &fpriv->vm, &fpriv->csa_va);
-		if (r) {
-			amdgpu_vm_fini(adev, &fpriv->vm);
-			kfree(fpriv);
-			goto out_suspend;
-		}
+		if (r)
+			goto error_vm;
 	}
 
 	mutex_init(&fpriv->bo_list_lock);
@@ -849,6 +846,16 @@ int amdgpu_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 	amdgpu_ctx_mgr_init(&fpriv->ctx_mgr);
 
 	file_priv->driver_priv = fpriv;
+	goto out_suspend;
+
+error_vm:
+	amdgpu_vm_fini(adev, &fpriv->vm);
+
+error_pasid:
+	if (pasid)
+		amdgpu_pasid_free(pasid);
+
+	kfree(fpriv);
 
 out_suspend:
 	pm_runtime_mark_last_busy(dev->dev);
@@ -871,6 +878,8 @@ void amdgpu_driver_postclose_kms(struct drm_device *dev,
 	struct amdgpu_device *adev = dev->dev_private;
 	struct amdgpu_fpriv *fpriv = file_priv->driver_priv;
 	struct amdgpu_bo_list *list;
+	struct amdgpu_bo *pd;
+	unsigned int pasid;
 	int handle;
 
 	if (!fpriv)
@@ -895,7 +904,13 @@ void amdgpu_driver_postclose_kms(struct drm_device *dev,
 		amdgpu_bo_unreserve(adev->virt.csa_obj);
 	}
 
+	pasid = fpriv->vm.pasid;
+	pd = amdgpu_bo_ref(fpriv->vm.root.base.bo);
+
 	amdgpu_vm_fini(adev, &fpriv->vm);
+	if (pasid)
+		amdgpu_pasid_free_delayed(pd->tbo.resv, pasid);
+	amdgpu_bo_unref(&pd);
 
 	idr_for_each_entry(&fpriv->bo_list_handles, list, handle)
 		amdgpu_bo_list_free(list);
-- 
2.14.1
