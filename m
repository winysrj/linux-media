Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58171 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755286AbdEHPFL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 11:05:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, posciak@chromium.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 05/18] vb2: Anticipate queue specific DMA attributes for USERPTR buffers
Date: Mon,  8 May 2017 18:03:17 +0300
Message-Id: <1494255810-12672-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DMA attributes were available for the memop implementation for MMAP
buffers but not for USERPTR buffers. Do the same for USERPTR. This patch
makes no functional changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c       | 2 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 3 ++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 3 ++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 3 ++-
 include/media/videobuf2-core.h                 | 3 ++-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index e866115..c659b64 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1025,7 +1025,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
 		mem_priv = call_ptr_memop(vb, get_userptr,
 				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
-				planes[plane].length, dma_dir);
+				planes[plane].length, dma_dir, q->dma_attrs);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed acquiring userspace memory for plane %d\n",
 				plane);
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
