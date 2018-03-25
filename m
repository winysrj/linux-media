Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37152 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752577AbeCYLAI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:08 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] drm/amdgpu: add amdgpu_gem_attach
Date: Sun, 25 Mar 2018 12:59:59 +0200
Message-Id: <20180325110000.2238-7-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check if we can do peer2peer on the PCIe bus.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
index 2566268806c3..133596df0775 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_prime.c
@@ -134,6 +134,29 @@ amdgpu_gem_prime_import_sg_table(struct drm_device *dev,
 	return obj;
 }
 
+static int amdgpu_gem_attach(struct dma_buf *dma_buf, struct device *dev,
+			     struct dma_buf_attachment *attach)
+{
+	struct drm_gem_object *obj = dma_buf->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+
+	if (!attach->peer2peer)
+		return 0;
+
+	if (!dev_is_pci(dev))
+		goto no_peer2peer;
+
+	if (!pci_peer_traffic_supported(adev->pdev, to_pci_dev(dev)))
+		goto no_peer2peer;
+
+	return 0;
+
+no_peer2peer:
+	attach->peer2peer = false;
+	return 0;
+}
+
 static struct sg_table *
 amdgpu_gem_map_dma_buf(struct dma_buf_attachment *attach,
 		       enum dma_data_direction dir)
@@ -274,6 +297,7 @@ static int amdgpu_gem_begin_cpu_access(struct dma_buf *dma_buf,
 }
 
 static const struct dma_buf_ops amdgpu_dmabuf_ops = {
+	.attach = amdgpu_gem_attach,
 	.map_dma_buf = amdgpu_gem_map_dma_buf,
 	.unmap_dma_buf = amdgpu_gem_unmap_dma_buf,
 	.release = drm_gem_dmabuf_release,
-- 
2.14.1
