Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59735 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbcJUHZQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 03:25:16 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3] [media] vb2: Add support for capture_dma_bidirectional queue flag
Date: Fri, 21 Oct 2016 09:25:05 +0200
Message-Id: <1477034705-5829-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

When this flag is set for CAPTURE queues by the driver on calling
vb2_queue_init(), it forces the buffers on the queue to be
allocated/mapped with DMA_BIDIRECTIONAL direction flag instead of
DMA_FROM_DEVICE. This allows the device not only to write to the
buffers, but also read out from them. This may be useful e.g. for codec
hardware which may be using CAPTURE buffers as reference to decode
other buffers.

This flag is ignored for OUTPUT queues as we don't want to allow HW to
be able to write to OUTPUT buffers.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Tested-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---

Changes since v1:
- Renamed use_dma_bidirectional field as capture_dma_bidirectional
- Added a VB2_DMA_DIR() macro

Changes since v2:
- Get rid of dma_dir field and therefore squashed the previous patch

Changes since v3:
- Fixed typos in include/media/videobuf2-core.h

 drivers/media/v4l2-core/videobuf2-core.c |  9 +++------
 include/media/videobuf2-core.h           | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 21900202..22d6105 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -194,8 +194,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
 	void *mem_priv;
 	int plane;
 	int ret = -ENOMEM;
@@ -978,8 +977,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1096,8 +1094,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ac5898a..a6cfdfb 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -433,6 +433,9 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @capture_dma_bidirectional:	use DMA_BIDIRECTIONAL for CAPTURE buffers; this
+ *				allows HW to read from the CAPTURE buffers in
+ *				addition to writing; ignored for OUTPUT queues.
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -499,6 +502,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			capture_dma_bidirectional:1;
 
 	struct mutex			*lock;
 	void				*owner;
@@ -554,6 +558,17 @@ struct vb2_queue {
 #endif
 };
 
+/*
+ * Returns the corresponding DMA direction given the vb2_queue type (capture or
+ * output). Returns DMA_BIDIRECTIONAL for capture buffers if the vb2_queue field
+ * capture_dma_bidirectional is set by the driver.
+ */
+#define VB2_DMA_DIR(q) (V4L2_TYPE_IS_OUTPUT((q)->type)   \
+			? DMA_TO_DEVICE                  \
+			: (q)->capture_dma_bidirectional \
+			  ? DMA_BIDIRECTIONAL            \
+			  : DMA_FROM_DEVICE)
+
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
  * @vb:		vb2_buffer to which the plane in question belongs to
-- 
2.7.4

