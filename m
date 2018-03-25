Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36710 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbeCYLAH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 07:00:07 -0400
From: "=?UTF-8?q?Christian=20K=C3=B6nig?="
        <ckoenig.leichtzumerken@gmail.com>
To: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] drm/amdgpu: print DMA-buf status in debugfs
Date: Sun, 25 Mar 2018 12:59:57 +0200
Message-Id: <20180325110000.2238-5-christian.koenig@amd.com>
In-Reply-To: <20180325110000.2238-1-christian.koenig@amd.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just note if a BO was imported/exported.

Signed-off-by: Christian König <christian.koenig@amd.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 46b9ea4e6103..7c1f761bb1a5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -777,6 +777,8 @@ static int amdgpu_debugfs_gem_bo_info(int id, void *ptr, void *data)
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(gobj);
 	struct seq_file *m = data;
 
+	struct dma_buf_attachment *attachment;
+	struct dma_buf *dma_buf;
 	unsigned domain;
 	const char *placement;
 	unsigned pin_count;
@@ -805,6 +807,15 @@ static int amdgpu_debugfs_gem_bo_info(int id, void *ptr, void *data)
 	pin_count = READ_ONCE(bo->pin_count);
 	if (pin_count)
 		seq_printf(m, " pin count %d", pin_count);
+
+	dma_buf = READ_ONCE(bo->gem_base.dma_buf);
+	attachment = READ_ONCE(bo->gem_base.import_attach);
+
+	if (attachment)
+		seq_printf(m, " imported from %p", dma_buf);
+	else if (dma_buf)
+		seq_printf(m, " exported as %p", dma_buf);
+
 	seq_printf(m, "\n");
 
 	return 0;
-- 
2.14.1
