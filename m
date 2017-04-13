Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57654 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdDMH6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:58:01 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: [RFC v3 05/14] vb2: Anticipate queue specific DMA attributes for USERPTR buffers
Date: Thu, 13 Apr 2017 10:57:10 +0300
Message-Id: <1492070239-21532-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1492070239-21532-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA attributes were available for the memop implementation for MMAP
buffers but not for USERPTR buffers. Do the same for USERPTR. This patch
makes no functional changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 3 ++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 3 ++-
 include/media/videobuf2-core.h                 | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index d29a07f..30082a4 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -475,7 +475,8 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev, unsigned long pfn
 #endif
 
 static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
-	unsigned long size, enum dma_data_direction dma_dir)
+	unsigned long size, enum dma_data_direction dma_dir,
+	unsigned long attrs)
 {
 	struct vb2_dc_buf *buf;
 	struct frame_vector *vec;
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 29fde1a..102ddb2 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -220,7 +220,8 @@ static void vb2_dma_sg_finish(void *buf_priv)
 
 static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
 				    unsigned long size,
-				    enum dma_data_direction dma_dir)
+				    enum dma_data_direction dma_dir,
+				    unsigned long dma_attrs)
 {
 	struct vb2_dma_sg_buf *buf;
 	struct sg_table *sgt;
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index f83253a..a4914fc 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -73,7 +73,8 @@ static void vb2_vmalloc_put(void *buf_priv)
 
 static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
 				     unsigned long size,
-				     enum dma_data_direction dma_dir)
+				     enum dma_data_direction dma_dir,
+				     unsigned long dma_attrs)
 {
 	struct vb2_vmalloc_buf *buf;
 	struct frame_vector *vec;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb97c22..4172f6e 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -122,7 +122,8 @@ struct vb2_mem_ops {
 
 	void		*(*get_userptr)(struct device *dev, unsigned long vaddr,
 					unsigned long size,
-					enum dma_data_direction dma_dir);
+					enum dma_data_direction dma_dir,
+					unsigned long dma_attrs);
 	void		(*put_userptr)(void *buf_priv);
 
 	void		(*prepare)(void *buf_priv);
-- 
2.7.4
